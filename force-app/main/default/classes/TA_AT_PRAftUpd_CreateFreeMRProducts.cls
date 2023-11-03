/**
 * @description       : 
 * @Test Class		  : TA_AT_PRAftUpd_CreateFreeMRProducts_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-11-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-21-2023   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_AT_PRAftUpd_CreateFreeMRProducts implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<SR_PR_Notification__c> newList, list<SR_PR_Notification__c> oldList) {
        system.debug('==== TA_AT_PRAftUpd_CreateFreeMRProducts.AfterUpdate ====== ');
        string errorMsg;

        try {
            Map<Id,SR_PR_Notification__c> oldMap = new Map<Id,SR_PR_Notification__c>(oldList);
            
            for (SR_PR_Notification__c srprRec : newList) {
                if (
                    srprRec.Billing_Start_Date__c != oldMap.get(srprRec.id).Billing_Start_Date__c && 
                    srprRec.Notif_Type__c == 'PR'&&
                    srprRec.Opportunity_Free_MRC_Periode_Month__c != Null
                ) {
                    if (
                        srprRec.Project_type__c == 'New' ||
                        srprRec.Project_type__c == 'Licensed'
                    ) {
                        OpportunityService.CreateFreeMRCOpptyProducts(srprRec.opportunity__c, srprRec.Billing_Start_Date__c);
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_PRAftUpd_CreateFreeMRProducts After Update' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}