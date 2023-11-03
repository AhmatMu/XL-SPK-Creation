/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 02-19-2023
 * @last modified by  : Diky Nurosid
**/
public with sharing class TriggerSRPRHandler {
   
    public void OnAfterUpdate(List<SR_PR_Notification__c> newList, List<SR_PR_Notification__c> oldList) {
       
        try {

            
            
        } catch (Exception e) {
            string errorMsg = '';
            string notes = 'Error on triggerCircuitHandler.OnBeforeInsert method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' ; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
         }
     }
}