@istest
public with sharing class Schedule_badDebtOppAdjustmentTEST {
    
    @isTest
    static void runScheduleFailed(){
        test.startTest();
            Schedule_badDebtOppAdjustment scheduleObj = new Schedule_badDebtOppAdjustment ();   
            String chron = '0 0 23 * * ?';        
            system.schedule('Test Sched', chron, scheduleObj);
        test.stopTest();
    }
}