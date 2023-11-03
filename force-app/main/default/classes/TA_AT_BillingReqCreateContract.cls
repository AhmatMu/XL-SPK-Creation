/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 01-31-2023
 * @last modified by  : Diky Nurosid
**/
public with sharing class TA_AT_BillingReqCreateContract implements TriggerAction.AfterUpdate{
    
    public void afterUpdate(List<Billing_Request__c> newList, List<Billing_Request__c> oldList){
        System.debug('=========== TA_AT_BillingRequestContract ============' );

        try {
            List<String> BillingRequestIds = new list<String>();
            Map<Id,Billing_Request__c> oldMap = new Map<Id,Billing_Request__c>(oldList);
            List<Billing_Request__c> billingReqBurstableList = new List<Billing_Request__c>();
            List<Billing_Request__c> billingReqUsageList = new List<Billing_Request__c>();

            for (Billing_Request__c billingRequestRec : newList) {
                if(oldMap.get(billingRequestRec.id).Status__c == 'Requested' && billingRequestRec.Status__c == 'In Queue'){
                    if(billingRequestRec.Type__c == 'Burstable'){
                        billingReqBurstableList.add(billingRequestRec);
                    }
                    if(billingRequestRec.Type__c == 'Usage'){
                        billingReqUsageList.add(billingRequestRec);
                    }
                }
            }
             
            if(billingReqBurstableList.size() > 0){
                System.debug('=========== billingReqBurstableBatchRunning ============' );
                Batch_CreateBrustableContract batchObjBurstable = new Batch_CreateBrustableContract(billingReqBurstableList);
                Database.executeBatch(batchObjBurstable, 10);
            }

            if(billingReqUsageList.size() > 0){
                System.debug('=========== billingReqUsageBatchRunning ============' );
                Batch_CreateUsageContract batchObjUsage = new Batch_CreateUsageContract(billingReqUsageList);
                 Database.executeBatch(batchObjUsage, 10);
            }

        } catch(Exception e) {
            string notes = 'Error on TA_AT_BillingRequestContract.AfterUpdate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);    
        }
    }
}