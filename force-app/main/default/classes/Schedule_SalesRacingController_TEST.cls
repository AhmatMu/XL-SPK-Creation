@isTest
public class Schedule_SalesRacingController_TEST {
    
    @isTest static void runSchedule() {
        
        sales_racing__c srcObj = new Sales_racing__c (
            
            name = 'racing 01',
            data_source__C = 'revenue',
            period_start_date__c = date.newInstance(2021, 07, 01),
            period_end_date__c = date.newInstance(2021, 09, 30),
            As_of_Date__c = Datetime.newInstance(2021,9,16,11,10,10),
            Group_services__c = 'Connectivity Fixed FIXED MOBILE',          
            Revenue_Category__c = '4G Access Revenue - INTERNATIONAL MPLSRevenue - LEASED LINESRevenue - TRACKING SYSTEMS & MPLSRevenue ISPRevenue NAPSD-WANUCVOIP' 
        ); 
        insert srcObj;         
        
        test.starttest();
        Schedule_SalesRacingController scheduleObj = new Schedule_SalesRacingController ();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, scheduleObj);
        test.stopTest(); 
    }
   
}