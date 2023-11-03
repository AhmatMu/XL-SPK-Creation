@isTest
private class SalesIncentive_ScheduleTEST {
    static testMethod void schenario1 () {

        Sales_Incentive_Workspace__c sinWorkspaceObj =  new Sales_Incentive_Workspace__c();
        sinWorkspaceObj.name = '2021 q1';
        sinWorkspaceObj.year__c = '2021';
        sinWorkspaceObj.quarter__c = 'Q1';
        insert sinWorkspaceObj;
 
        Test.startTest();

        DateTime nextSchedule = System.now().addSeconds(3);

        createSheduleJob ('Put Revenue Data', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(30);

        createSheduleJob ('Put Achievement Data', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(20);

        createSheduleJob ('Put Weighted Data', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(30);

        createSheduleJob ('Put Total Achievement Data', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(20);

        createSheduleJob ('Put Revenue Data Manager', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(30);

        createSheduleJob ('Put Achievement Data', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(20);

        createSheduleJob ('Put Weighted Data', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(30);

        createSheduleJob ('Put Total Achievement Data', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(20);

        createSheduleJob ('Put Collection Rate Data', nextSchedule, sinWorkspaceObj);
        nextSchedule = nextSchedule.addSeconds(5);

        createSheduleJob ('Put Final Incentive Data', nextSchedule, sinWorkspaceObj);


        Test.stopTest();

    }

    static void createSheduleJob (string jobType, DateTime nextSchedule, Sales_Incentive_Workspace__c sinWorkspaceObj ) {

        system.debug ('============ nextSchedule :' + nextSchedule);
        system.debug ('============ jobType :' + jobType);

        string sYear;
        string sMonth;
        string sDay;
        string sHour;
        string sMinute;
        string sSecond;
        string schTime;
        
        string jobTitle;
        

        Scheduled_Process__c spOBJ = new Scheduled_Process__c();
        spOBJ.name = '**';
        spOBJ.Execute_Plan__c = nextSchedule;
        spOBJ.Parameter1__c = sinWorkspaceObj.id;
        spOBJ.type__c = jobType + ' (Sales Incentive)';
        insert spOBJ;


        sYear = string.valueof( nextSchedule.year() );
        sMonth = string.valueof( nextSchedule.month() );
        sDay = string.valueof( nextSchedule.day() ); 
        sHour = string.valueof( nextSchedule.Hour() );
        sMinute = string.valueof( nextSchedule.minute() );
        sSecond = string.valueof( nextSchedule.second() );
        
        SalesIncentive_Schedule sinSchedule = new SalesIncentive_Schedule(jobType, sinWorkspaceObj); 
        sinSchedule.jobType = jobType;   
        sinSchedule.scheduledProcessID = spOBJ.id;  // <<-- this is the key

        schTime = sSecond + ' ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
        system.debug ('============ schTime :' + schTime);

        //-- create scheduler
        jobTitle = 'Sales Incentive : ' + jobType + ' - ' + sinWorkspaceObj.Name  + ' - '
            + schTime ;
        
        string jobID = system.schedule(jobTitle, schTime, sinSchedule);


        spOBJ.jobid__c = jobID;
        spOBJ.parameter3__c = jobID;
        spOBJ.title__c = jobTitle;
        spOBJ.name = spOBJ.title__c.left(80);
        update spOBJ;
    }


}