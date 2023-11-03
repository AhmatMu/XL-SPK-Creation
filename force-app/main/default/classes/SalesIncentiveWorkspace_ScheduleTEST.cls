@ isTest
public class SalesIncentiveWorkspace_ScheduleTEST {
    @isTest static void schenario1() {


        Test.startTest();

        //-- 'Create Sales Incentive Workspace'
        DateTime nextSchedule = System.now().addSeconds(2);
        createSheduleJob (nextSchedule);


        //-- 'Refresh Sales Incentive Data'
        nextSchedule = nextSchedule.addSeconds(2);
        createSheduleJob (nextSchedule);

        Test.stopTest();

    }

    static void createSheduleJob (DateTime nextSchedule ) {

        system.debug ('============ nextSchedule :' + nextSchedule);


        string sYear;
        string sMonth;
        string sDay;
        string sHour;
        string sMinute;
        string sSecond;
        string schTime;
        
        string jobTitle;
        


        sYear = string.valueof( nextSchedule.year() );
        sMonth = string.valueof( nextSchedule.month() );
        sDay = string.valueof( nextSchedule.day() ); 
        sHour = string.valueof( nextSchedule.Hour() );
        sMinute = string.valueof( nextSchedule.minute() );
        sSecond = string.valueof( nextSchedule.second() );
        
        SalesIncentiveWorkspace_Schedule sinWSchedule = new SalesIncentiveWorkspace_Schedule(); 

        schTime = sSecond + ' ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
        system.debug ('============ schTime :' + schTime);

        //-- create scheduler
        jobTitle = 'Sales Incentive Workspace : ' + nextSchedule;
        
        string jobID = system.schedule(jobTitle, schTime, sinWSchedule);

    }
        
}