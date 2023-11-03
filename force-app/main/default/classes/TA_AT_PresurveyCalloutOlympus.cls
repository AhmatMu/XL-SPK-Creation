/**
 * @description       : 
 * @author            : Ahmad Aulia Fahmi
 * @group             : 
 * @last modified on  : 10-04-2023
 * @last modified by  : Ahmat Zulkifli Murad
 * Modifications Log
 * Ver   Date         Author        		Modification
 * 1.0   05-06-2023   Ahmad Aulia Fahmi   	Initial Version
**/

public class TA_AT_PresurveyCalloutOlympus implements TriggerAction.AfterUpdate{
    
    public void AfterUpdate (list<Presurvey__c> newPresurveyList, list<Presurvey__c> oldPresurveyList) {

        System.debug('----TA_AT_PresurveyCalloutOlympus----');

        String notes;
        String errorMsg;
        String presurveyId;
        try {
            Presurvey_General_Setting__c countingCallout = Presurvey_General_Setting__c.getValues('Counting_Call_API');
            Map<Id, Presurvey__c> oldMap = new Map<Id, Presurvey__c>(oldPresurveyList);
            for (Presurvey__c newPresurveyRec : newPresurveyList) {
                Presurvey__c oldPresurveyRec = oldMap.get(newPresurveyRec.Id); // get Old Presurvey Record
                presurveyId = newPresurveyRec.Id; // set presurvey Id

                /* OLD VERSION
                if (oldPresurveyRec.Presurvey_Status__c == 'Submit' && newPresurveyRec.Presurvey_Status__c == 'In Progress') {
                    REST_Presurvey_Callout.getTowerCandidates( presurveyId ); 
                }
                */

                Integer API_CALL_MAX_for_GET_TOWER = integer.valueOf(countingCallout.API_Call_Max_for_Get_Tower__c); //TODO : change this statement to get value from custom setting

                system.debug('==== newPresurveyRec.Presurvey_Status__c  : ' + newPresurveyRec.Presurvey_Status__c );
                system.debug('==== oldPresurveyRec.In_Progress_Status__c  : ' + oldPresurveyRec.In_Progress_Status__c );
                system.debug('==== newPresurveyRec.In_Progress_Status__c  : ' + newPresurveyRec.In_Progress_Status__c);
                system.debug('==== newPresurveyRec.Get_Tower_API_Call_Number__c  : ' + newPresurveyRec.Get_Tower_API_Call_Number__c );

                integer callNumber = (newPresurveyRec.Get_Tower_API_Call_Number__c == null) ? 0 : integer.valueOf(newPresurveyRec.Get_Tower_API_Call_Number__c);
                system.debug('==== callNumber : ' + callNumber);

                //existing before fixing
                /*
                if (newPresurveyRec.Presurvey_Status__c == 'In Progress' &&
                    oldPresurveyRec.In_Progress_Status__c != 'Need to Request' && 
                    newPresurveyRec.In_Progress_Status__c == 'Need to Request' &&
                    callNumber <= API_CALL_MAX_for_GET_TOWER
                    ) {
                        System.debug('In Presurvey Callout Trigger');
                        // call api to get tower candidates
                        REST_Presurvey_Callout.getTowerCandidates(presurveyId); 
                }
                */
                if ( (oldPresurveyRec.Presurvey_Status__c <> 'In Progress' && newPresurveyRec.Presurvey_Status__c == 'In Progress' ) &&
                    newPresurveyRec.In_Progress_Status__c == 'Need to Request' &&
                    callNumber <= API_CALL_MAX_for_GET_TOWER
                    ) {
                        System.debug('In Presurvey Callout Trigger');
                        // call api to get tower candidates
                        REST_Presurvey_Callout.getTowerCandidates(presurveyId); 
                }
            }
        } catch (Exception e) {
            notes = 'Error on TA_AT_PresurveyCalloutOlympus.AfterUpdate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            errorMsg = notes + '::' +  message + '::' + lineNumber + ' :: ' + presurveyId; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

}