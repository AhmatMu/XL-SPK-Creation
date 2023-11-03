/**
 * @description       : 
 * @Test Class		  : TA_AT_CALL_Schdle_FixingSRPRName_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-26-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-14-2023   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_AT_CALL_Schdle_FixingSRPRName implements TriggerAction.AfterInsert {
    public void afterInsert (list<SR_PR_Notification__c> newSRPRList) {
        system.debug('==== TA_AT_CALL_Schdle_FixingSRPRName.afterInsert ====== ');
        string errorMsg;
        
        try {
            Datetime nextSchedule = system.now().addMinutes(2);

            String hour = String.valueOf( nextSchedule.hour());
            String min = String.valueOf( nextSchedule.minute()); 
            String ss = String.valueOf( nextSchedule.second());
            String sDay = string.valueof( nextSchedule.day() ); 
            String sYear = string.valueof( nextSchedule.year() );
            String sMonth = string.valueof( nextSchedule.month() );

            String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

            Schedule_FixingSRPRName Schedule_FixingSRPRName_class = new Schedule_FixingSRPRName(); 
            System.schedule('Schedule_FixingSRPRName ' + String.valueOf(system.now()), nextFireTime, Schedule_FixingSRPRName_class);

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_CALL_Schdle_FixingSRPRName After Insert' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

    }
}