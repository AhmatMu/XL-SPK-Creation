/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-08-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-08-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class ProductOnboarding_Schedule_Test {
    static testMethod void myUnitTest1() {
        Test.startTest();
        Datetime nextSchedule = system.now().addSeconds(3);

        String hour = String.valueOf( nextSchedule.hour());
        String min = String.valueOf( nextSchedule.minute()); 
        String ss = String.valueOf( nextSchedule.second());
        String sDay = string.valueof( nextSchedule.day() ); 
        String sYear = string.valueof( nextSchedule.year() );
        String sMonth = string.valueof( nextSchedule.month() );

        String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

        updateGlobalPicklistRecordType_Schedule updateGlobalPicklistRecordTypes = new updateGlobalPicklistRecordType_Schedule(
            'update', 
            ''
        ); 

        System.schedule('POB updateGlobalPicklistRecordType_Schedule ' +  String.valueOf(nextSchedule), nextFireTime, updateGlobalPicklistRecordTypes);


        String DependentPicklistValues_String = '{"test1":["test1"],"Test2":["Test2"] }';
        Set<String> tikectIds = new Set<String> ();

        updateDependentPicklist_Schedule updateDependentPicklist_Schedules = new updateDependentPicklist_Schedule(
            DependentPicklistValues_String, 
            tikectIds
        ); 

        System.schedule('POB updateDependentPicklist_Schedules ' + String.valueOf(nextSchedule), nextFireTime, updateDependentPicklist_Schedules);

        set<string> newPicklistValues = new set<string>();
        newPicklistValues.add('Test123');

        updatePicklistRecordType_Schedule updatePicklistRecordType = new updatePicklistRecordType_Schedule(
            newPicklistValues,
            'SR_PR_Notification__c',
            'Services__c',
            'One Site'
        ); 

        System.schedule('POB updatePicklistRecordType_Schedule ' +  String.valueOf(nextSchedule), nextFireTime, updatePicklistRecordType);
        Test.stopTest();
    }
}