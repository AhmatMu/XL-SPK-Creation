/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 08-01-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
public class TA_AT_PresurveyStatusMovement implements TriggerAction.BeforeUpdate {

    public void BeforeUpdate(List<Presurvey__c> newPresurveyList, List<Presurvey__c> oldPresurveyList) {
        System.debug('----TA_AT_PresurveyStatusMovement----');
        
        String notes;
        String errorMsg;
        String presurveyId;

        try {
            
            Map<Id, Presurvey__c> oldMap = new Map<Id, Presurvey__c>(oldPresurveyList);
            Set<String> recipientNotification = new Set<String>(); //untuk notification recipient
            recipientNotification.add(UserInfo.getUserId());

            for (Presurvey__c newPresurveyRec : newPresurveyList) {
                Presurvey__c oldPresurveyRec = oldMap.get(newPresurveyRec.Id); // get old presurvey record
                presurveyId = newPresurveyRec.Id; // set presurvey Id
                System.debug('oldPresurveySource : ' + oldPresurveyRec.update_source__c);

                // before callout
                if (oldPresurveyRec.Presurvey_Status__c == 'Submit' && newPresurveyRec.Presurvey_Status__c == 'In Progress') {
                    newPresurveyRec.update_source__c = 'Integration'; // untuk lolos validasi bagi sales
                    newPresurveyRec.In_Progress_Status__c = 'Need to Request'; // new

                    REST_Presurvey_Callout.sendNotification(recipientNotification, newPresurveyRec.id, newPresurveyRec.name, Label.PRESURVEY_GET_TOWER_INPROCESS_NOTIF_TITLE_ENG, Label.PRESURVEY_GET_TOWER_INPROCESS_NOTIF_ENG);
                }
                
                if (oldPresurveyRec.Presurvey_Status__c == 'Draft' && newPresurveyRec.Presurvey_Status__c == 'In Progress') {
                    newPresurveyRec.In_Progress_Status__c = 'No Need to Request';
                }   

                // reset only administrator
                if (oldPresurveyRec.Presurvey_Status__c != 'Draft' && newPresurveyRec.Presurvey_Status__c == 'Draft') {
                    newPresurveyRec.update_source__c = 'User';
                    newPresurveyRec.In_Progress_Status__c = null; // new
                    newPresurveyRec.Get_Tower_API_Call_Number__c = 0; // new
                }
            }

            
        } catch (Exception e) {
            notes = 'Error on TA_AT_PresurveyStatusMovement.AfterUpdate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            errorMsg = notes + '::' +  message + '::' + lineNumber + ' :: ' + presurveyId; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }
}