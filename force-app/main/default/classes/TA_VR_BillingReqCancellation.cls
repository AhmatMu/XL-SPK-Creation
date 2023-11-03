/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 07-31-2023
 * @last modified by  : Diky Nurosid
**/
public with sharing class TA_VR_BillingReqCancellation implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<Billing_Request__c> newList, List<Billing_Request__c> oldList) {
        Map<Id, Billing_Request__c> oldMap = new Map<Id, Billing_Request__c>(oldList);
        List<Profile> profileRecord = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
        String contractManagerProfileName = 'Contract Manager';

        for (Billing_Request__c billingRec : newList) {
            Billing_Request__c oldBillingRec = oldMap.get(billingRec.Id);
            if (oldBillingRec.Complete_Status__c != billingRec.Complete_Status__c && billingRec.Complete_Status__c == 'Canceled'
                && (billingRec.Status__c == 'Requested' || billingRec.Status__c == 'In Queue')) {
                if (!profileRecord.isEmpty() && !profileRecord[0].Name.contains(contractManagerProfileName)) {
                    billingRec.addError('Cannot Cancel a Billing Request. Only Contract Managers are allowed to cancel.');
                }
            }
        }
    }
}