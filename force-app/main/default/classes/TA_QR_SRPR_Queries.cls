/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 10-03-2023
 * @last modified by  : Novando Utoyo Agmawan
**/

public with sharing class TA_QR_SRPR_Queries {
    private static TA_QR_SRPR_Queries instance;
 
    private TA_QR_SRPR_Queries() {
     
    }
    
    public static TA_QR_SRPR_Queries getInstance() {
        if (TA_QR_SRPR_Queries.instance == null) {
            TA_QR_SRPR_Queries.instance = new TA_QR_SRPR_Queries();
        }
        return TA_QR_SRPR_Queries.instance;
    }
    
    public Map<Id, Opportunity> getOpportunityProductItem { get; private set; }

    public Map<Id, Link__c> getLinkProductItem { get; private set; }
   
    public class Service implements TriggerAction.AfterUpdate{
      public void afterUpdate(List<SR_PR_Notification__c> newList, List<SR_PR_Notification__c> oldList) {
        TA_QR_SRPR_Queries.getInstance().getOpportunityProductItem = getOpportunityProductItem(
            newList
          );
      }
      
      private Map<Id, Opportunity> getOpportunityProductItem(List<SR_PR_Notification__c> newList){
        system.debug('----getOpportunityProductItem----');
        Set<Id> oppIds = new Set<Id>();
  
        for(SR_PR_Notification__c srprRec : newList){
            oppIds.add(srprRec.Opportunity__c);
        }
        return new Map<Id, Opportunity>(
          [SELECT Id,BP_Payer__c,BP_VAT__c,AccountId,SAP_Code__c,BW_after__c,BW_before__c,Link_Related__c,Uom_BW_Before__c,Uom_BW_After__c, Free_MRC_Periode_Month_Invoice__c, (SELECT Id,Name,Product2Id,Product2.Name,Product2.SAP_Code__c,UnitPrice,Opportunity_Product_ID__c,ListPrice,Revenue_Type__c FROM OpportunityLineItems) FROM Opportunity WHERE Id IN : oppIds]
        );
      }

      private Map<Id, Link__c> getLinkProductItem(List<SR_PR_Notification__c> newList){
        system.debug('----getOpportunityProductItem----');
        Set<Id> linkIds = new Set<Id>();
  
        for(SR_PR_Notification__c srprRec : newList){
          linkIds.add(srprRec.Link__c);
        }
        return new Map<Id, Link__c>(
          [SELECT Id, (SELECT Id,Name,Type__c,is_Last__c FROM Link_Products__r WHERE is_Last__c = TRUE) FROM Link__c WHERE Id IN : linkIds]
        );
      }
    
    }    
}