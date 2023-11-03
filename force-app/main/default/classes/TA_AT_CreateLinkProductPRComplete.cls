/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 02-20-2023
 * @last modified by  : Diky Nurosid
**/
public with sharing class TA_AT_CreateLinkProductPRComplete implements TriggerAction.AfterUpdate {
    
    public void afterUpdate (list<SR_PR_Notification__c> newList, list<SR_PR_Notification__c> oldList) {
        system.debug('==== TA_AT_CreateLinkProductPRComplete.afterUpdate ====== ');
        string errorMsg;
        Map<Id,SR_PR_Notification__c> oldMap = new Map<Id,SR_PR_Notification__c>(oldList);
        List<Link_Product__c> linkProductList = new List<Link_Product__c>();
        Set<Id> oppIds = new Set<Id>();
        try {
            Map<Id, OpportunityLineItem> opportunityProductMap = TA_QR_SRPR_Queries.getInstance().getOpportunityProductItem;
            System.debug('Opp Product==> '+opportunityProductMap);
            for (SR_PR_Notification__c srprRec : newList){
                oppIds.add(srprRec.Opportunity__c);
            }
            List<OpportunityLineItem> oppProductList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId IN : oppIds];
            Id product = opportunityProductMap.get(oppProductList[0].Id).Product2Id;
            String productId = opportunityProductMap.get(oppProductList[0].Id).Opportunity_Product_ID__c;
            Decimal salesPrice = opportunityProductMap.get(oppProductList[0].Id).UnitPrice;

            for (SR_PR_Notification__c srprRec : newList) {
                if(srprRec.Status__c != oldMap.get(srprRec.id).Status__c && srprRec.Status__c == 'Complete'){
                    Link_Product__c linkProduct = new Link_Product__c();
                    linkProduct.Link__c = srprRec.Link__c;
                    linkProduct.Product__c = product;
                    linkProduct.Product_ID__c = productId;
                    linkProduct.Sales_Price__c = salesPrice;
                  //  linkProduct.Type = 'Burstable';
                    linkProductList.add(linkProduct);
                }
               
            } 
            insert linkProductList;
            
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_CreateLinkProductPRComplete After Update' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}