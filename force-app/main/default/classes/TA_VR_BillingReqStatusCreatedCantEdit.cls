/**
* @description       : 
* @author            : Diky Nurosid
* @group             : 
* @last modified on  : 07-31-2023
* @last modified by  : Diky Nurosid
**/
public with sharing class TA_VR_BillingReqStatusCreatedCantEdit implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<Billing_Request__c> newList, List<Billing_Request__c> oldList) {
        Map<Id, Billing_Request__c> oldMap = new Map<Id, Billing_Request__c>(oldList);

        List<Profile> profileRecord = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
        String contractManagerProfileName = 'Contract Manager';
        String systemAdministratorName = 'System Administrator';

        if (!profileRecord.isEmpty()) {
            String userProfileName = profileRecord[0].Name;
            SObjectField statusField = Billing_Request__c.Status__c;
            Map<String, SObjectField> objectFields = Billing_Request__c.SObjectType.getDescribe().fields.getMap();
            for (Billing_Request__c billingRec : newList) {
                // Exempt System Administrator from any validation
                if (userProfileName.contains(systemAdministratorName)) {
                    continue; // Skip the record, allowing the System Administrator to edit freely
                }

                // Check if the user is Contract Manager
                if (userProfileName.contains(contractManagerProfileName)) {
                    // Check if the status is 'Created' and the old status is not 'Created'
                    if (billingRec.Status__c != 'Requested') {
                      
                        // Check if any field other than Status has changed
                        for (String fieldName : objectFields.keySet()) {
                            if (fieldName != 'Status__c' && fieldName != 'Complete_Status__c' && billingRec.get(fieldName) != oldMap.get(billingRec.Id).get(fieldName)) {
                                billingRec.addError('BLR Ticket Can ONLY be EDITED by ORM when Status is "Requested".');
                                break;
                            }
                        }
                    }
                } else {
                    // For other profiles, they are not allowed to edit at all
                    billingRec.addError('You are not allowed to edit the Billing Request');
                }
            }
        }
    }
}