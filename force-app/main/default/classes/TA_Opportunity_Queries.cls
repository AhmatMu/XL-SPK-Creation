/**
 * @description       : 
 * @Test Class        : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 09-14-2022
 * @last modified by  : Diky Nurosid
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-09-2022   Diky Nurosid            Initial Version
**/

public class TA_Opportunity_Queries {
  private static TA_Opportunity_Queries instance;
 
  //private TA_Opportunity_Queries() {
   
  //}
  
  public static TA_Opportunity_Queries getInstance() {
      if (TA_Opportunity_Queries.instance == null) {
          TA_Opportunity_Queries.instance = new TA_Opportunity_Queries();
      }
      return TA_Opportunity_Queries.instance;
  }
  
  public Map<Id, Account> beforeAccountBpPayerMap { get; private set; }
  public Map<Id, Customer_Type_Mapping__c> beforeCustomerTypeMap { get; private set; }

  public class Service implements TriggerAction.BeforeUpdate{
    public void beforeUpdate(List<Opportunity> newList, List<Opportunity> oldList) {
        TA_Opportunity_Queries.getInstance().beforeAccountBpPayerMap = getAccountBpPayerMapFromOpportunities(
          newList
        );

        /*TA_Opportunity_Queries.getInstance().beforeCustomerTypeMap = getcustomerTypeMapFromOppProductCode(
          newList
        );*/
    }
    
    private Map<Id, Account> getAccountBpPayerMapFromOpportunities(List<Opportunity> newList){
      Set<Id> bpPayerId = new Set<Id>();

      for(Opportunity oppRec : newList){
        bpPayerId.add(oppRec.BP_Payer__c);
      }

      return new Map<Id, Account>(
        [SELECT Id, customer_type__c FROM Account WHERE Id IN : bpPayerId]
      );
    }
    
    /*private Map<Id, Customer_Type_Mapping__c> getcustomerTypeMapFromOppProductCode(List<Opportunity> newList){
      //string queryString = 'SELECT Id, Name, Customer_Type__c, Product_Code__c FROM Customer_Type_Mapping__c WHERE Customer_Type__c = '+'\''+customerType+'\''+' AND Product_Code__c INCLUDES('+'\''+productCode+'\''+') LIMIT 1';

      string queryString = '';

      return new Map<Id, Customer_Type_Mapping__c>((List<Customer_Type_Mapping__c>)Database.query(queryString));
    }*/
  }
}