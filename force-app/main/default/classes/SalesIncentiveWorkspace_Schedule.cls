global class SalesIncentiveWorkspace_Schedule implements Schedulable{
    public string jobType = '';
    public string jobId = '';
    public string jobTitle = '';
    
    public string scheduledProcessID = '';
    public Sales_Incentive_Workspace__c siwOBJ;
    public string sccheduleStatus = 'Success';
    


    public SalesIncentiveWorkspace_Schedule () {

    }

    global void execute(SchedulableContext sc)  {
        date todayDate = system.today();
        string quarter ;
        string year;
        string relatedSFIDs = scheduledProcessID;
        string errorMsg = '';
        DateTime executePlan = system.now();

        switch on todayDate.month() {
            when 1 {
                quarter = 'Q1';
            }
            when 4 {
                quarter = 'Q2';
            }
            when 7 {
                quarter = 'Q3';
            }
            when 10 {
                quarter = 'Q4';
            }
        } 
        year = string.valueOf(todayDate.year());

        List<Sales_Incentive_Workspace__C> findSINWorkspaceList = [SELECT id, Year__c, mode_data__c, quarter__c, name 
        FROM Sales_Incentive_Workspace__C 
        WHERE quarter__c = :quarter 
            AND year__c = :year
        ];

        Sales_Incentive_Workspace__C newSINWorkspace ;

        if (findSINWorkspaceList.size() == 0 ) {
            jobType = 'Create Sales Incentive Workspace';

            newSINWorkspace = new Sales_Incentive_Workspace__C();
            newSINWorkspace.name = 'Sales Incentive Workspace for ' + quarter + ' ' + todayDate.year();
            newSINWorkspace.quarter__c = quarter;
            newSINWorkspace.year__c = year;

            try {
                insert newSINWorkspace;

                SalesIncentiveWorkspaceController sinWControllerOBJ = new SalesIncentiveWorkspaceController (newSINWorkspace);
                sinWControllerOBJ.cloneSettingData();
            

                //-- after creation, in another automation (PB) the system will be send email to PPM PIC for setting configuration

            }
            catch (Exception e) {
                string notes = 'Error on SalesIncentiveWorkspace_Schedule.execute method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
                
                errorMsg = notes + '::' +  message + '>> ' + newSINWorkspace + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
                system.debug ('===== errorMsg : ' + errorMsg);

                sccheduleStatus = 'Failed';
            }

        } 
        else {
            //-- system will be auto refresh data related to setting configuration
            jobType = 'Refresh Sales Incentive Data';
            newSINWorkspace = findSINWorkspaceList[0];

            SalesIncentiveWorkspaceController sinWControllerOBJ = new SalesIncentiveWorkspaceController (newSINWorkspace);
            sinWControllerOBJ.refreshData();

        }


        CronTrigger ct = [SELECT CronJobDetail.Name, CronJobDetailId 
        FROM CronTrigger 
        WHERE Id = :sc.getTriggerId()
        ];

        jobTitle = 'Sales Incentive Workspace : ' + jobType + ' - ' + sc.getTriggerId() + ' - ' + executePlan;

        Scheduled_Process__c spOBJ = new Scheduled_Process__c();
        spOBJ.Execute_Plan__c = executePlan;
        spOBJ.Execute_Start__c = executePlan;
        spOBJ.Execute_End__c =  system.now();
        spOBJ.Parameter1__c = sc.getTriggerId();
        spOBJ.Parameter2__c = newSINWorkspace.id;
        spOBJ.type__c = jobType;
        spOBJ.Status__c = sccheduleStatus;
        spOBJ.jobid__c = ct.CronJobDetailId;
        spOBJ.parameter3__c = jobID;
        spOBJ.title__c = jobTitle;
        spOBJ.name = spOBJ.title__c.left(80);

        try {
            insert spOBJ;
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspace_Schedule.execute method. (insert Scheduled_Process__c)'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + newSINWorkspace + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);

        }
    }

}