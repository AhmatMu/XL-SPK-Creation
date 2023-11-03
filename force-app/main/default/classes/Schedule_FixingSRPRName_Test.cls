/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-26-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-26-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class Schedule_FixingSRPRName_Test {
    static testMethod void myUnitTest1() {
        Test.startTest();
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
        Test.stopTest();
    }
}