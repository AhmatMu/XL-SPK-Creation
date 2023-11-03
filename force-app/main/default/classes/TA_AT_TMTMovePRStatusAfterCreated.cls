/**
 * @description       : Trigger Action for create vendor after vendor registration ticket approved
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 09-26-2022
 * @last modified by  : Diky Nurosid
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0  09-06-2022   Diky Nurosid   Initial Version
**/
public with sharing class TA_AT_TMTMovePRStatusAfterCreated implements TriggerAction.AfterInsert {
    public void AfterInsert(List<Trial_Monitoring_Ticket__c> newList){
        system.debug('----TA_AT_TMTMovePRStatusAfterCreated----');

        try {
           
            List<SR_PR_Notification__c> srprList = new List<SR_PR_Notification__c>();
            for (Trial_Monitoring_Ticket__c tmtRec : newList) {

                SR_PR_Notification__c srprObj = new SR_PR_Notification__c();
                srprObj.Id = tmtRec.PR_Rel__c;
                srprObj.Status__c = 'On Going Trial';
                srprList.add(srprObj);
            }
            update srprList;

           
        } catch(Exception e) {
            string notes = 'Error on TA_AT_TMTMovePRStatusAfterCreated.AfterInsert method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
}