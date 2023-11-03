/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 05-05-2023
 * @last modified by  : Diky Nurosid
**/
public with sharing class TA_QR_BillingReq_Queries {
    private static TA_QR_BillingReq_Queries instance;
 
    private TA_QR_BillingReq_Queries() {
     
    }
    
    public static TA_QR_BillingReq_Queries getInstance() {
        if (TA_QR_BillingReq_Queries.instance == null) {
            TA_QR_BillingReq_Queries.instance = new TA_QR_BillingReq_Queries();
        }
        return TA_QR_BillingReq_Queries.instance;
    }
    
    public Map<String, Link__c> getlinkProductItem { get; private set; }
   
    public class Service implements TriggerAction.BeforeInsert{
      public void beforeInsert(List<Billing_Request__c> newList) {
        TA_QR_BillingReq_Queries.getInstance().getlinkProductItem = getlinkProductItem(
            newList
          );
      }
      
      private Map<String, Link__c> getlinkProductItem(List<Billing_Request__c> newList){
        system.debug('----getlinkProductItem----');
        Set<String> linkIds = new Set<String>();
  
        for(Billing_Request__c billRec : newList){
            linkIds.add(billRec.Service_ID__c);
        }
        
        return new Map<String, Link__c>(
          [SELECT Id,Name,Account__c,isBurstable__c,isUsage__c,Product_Usage_Name__c,Product_One_Time__c,Product_Recurring__c,Product_Burstable_Name__c, (SELECT Id, Link__c,Product__c,Product__r.Revenue_Type__c,Sales_Price__c,Bandwidth__c,SAP_Code__c FROM Link_Products__r) FROM Link__c WHERE Link_ID__c IN : linkIds]
        );
      }
    
    }    
}