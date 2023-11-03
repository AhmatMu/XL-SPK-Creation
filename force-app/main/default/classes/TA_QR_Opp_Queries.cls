/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 08-02-2023
 * @last modified by  : Ahmat Zulkifli Murad
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   29-09-2022   Doddy Prima   Initial Version
**/
public with sharing class TA_QR_Opp_Queries {
    private static TA_QR_Opp_Queries instance;
 
    private TA_QR_Opp_Queries() {
     
    }
    
    public static TA_QR_Opp_Queries getInstance() {
        if (TA_QR_Opp_Queries.instance == null) {
            TA_QR_Opp_Queries.instance = new TA_QR_Opp_Queries();
        }
        return TA_QR_Opp_Queries.instance;
    }
    
    public Map<Id, Account> beforeAccountBpPayerMap { get; private set; }
   // public Map<Id, Customer_Type_Mapping__c> beforeCustomerTypeMap { get; private set; }
  
    public class Service implements TriggerAction.BeforeUpdate{
      public void beforeUpdate(List<Opportunity> newList, List<Opportunity> oldList) {
        TA_QR_Opp_Queries.getInstance().beforeAccountBpPayerMap = getAccountBpPayerMapFromOpportunities(
            newList
          );
  
          /*TA_QR_Opp_Queries.getInstance().beforeCustomerTypeMap = getcustomerTypeMapFromOppProductCode(
            newList
          );*/
      }
      
      private Map<Id, Account> getAccountBpPayerMapFromOpportunities(List<Opportunity> newList){
        system.debug('----getAccountBpPayerMapFromOpportunities----');
        Set<Id> bpPayerId = new Set<Id>();
  
        for(Opportunity oppRec : newList){
          bpPayerId.add(oppRec.BP_Payer__c);
        }
        system.debug('BP PAYER' + bpPayerId);
        return new Map<Id, Account>(
          [SELECT Id, customer_type__c FROM Account WHERE Id IN : bpPayerId]
        );
      }
      /*
      private Map<Id, Customer_Type_Mapping__c> getcustomerTypeMapFromOppProductCode(List<Opportunity> newList){
        //string queryString = 'SELECT Id, Name, Customer_Type__c, Product_Code__c FROM Customer_Type_Mapping__c WHERE Customer_Type__c = '+'\''+customerType+'\''+' AND Product_Code__c INCLUDES('+'\''+productCode+'\''+') LIMIT 1';
  
        string queryString = '';
  
        return new Map<Id, Customer_Type_Mapping__c>((List<Customer_Type_Mapping__c>)Database.query(queryString));
      }*/
    }    
}