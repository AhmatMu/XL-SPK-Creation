global class SalesIncentive_Schedule implements Schedulable{
    public string jobType = '';
    public string scheduledProcessID = '';
    
    public Sales_Incentive_Workspace__c siwOBJ;

    public SalesIncentive_Schedule (string jobType, Sales_Incentive_Workspace__c siwOBJ) {
        this.jobType = jobType;
        this.siwOBJ = siwOBJ;

    }

    global void execute(SchedulableContext sc)  {
        //--Todo : create log for bellow process
       //    Sales_Incentive_Workspace__c siwObjRec = [select id, name, year__c, quarter__c, mode_data__c from Sales_Incentive_Workspace__c where year__c = :this.dateYear and quarter__c = :this.quarter ];

        DateTime executeStart = system.now();
        system.debug(' sales incentive workspaces Mode Data = ' +  siwOBJ.Mode_Data__c);

        if(siwOBJ.Mode_Data__c == 'Auto Calculate'){
            
            switch on jobtype {

                when 'Put Revenue Data' {
                    SalesIncentiveWorkspaceController siwController= new SalesIncentiveWorkspaceController (siwOBJ);
                    // perlu di update cara pemanggilanya step executenya
                    siwController.putRevenueData();
                }

                when 'Put Revenue Data Manager' {
                    SalesIncentiveWorkspaceController siwController = new SalesIncentiveWorkspaceController (siwOBJ);
                    siwController.putRevenueDataSMGH();
                }

                when 'Put Achievement Data' {
                    SalesIncentiveWorkspaceController siwController= new SalesIncentiveWorkspaceController (siwOBJ);
                    siwController.putAchievementData();
                }
                
                when 'Put Weighted Data' {
                    SalesIncentiveWorkspaceController siwController= new SalesIncentiveWorkspaceController (siwOBJ);
                    siwController.putWeightedData();
                }

                when 'Put Total Achievement Data' {
                    SalesIncentiveWorkspaceController siwController= new SalesIncentiveWorkspaceController (siwOBJ);
                    siwController.putTotalAchievementData();
                }

                when 'Put Collection Rate Data' {
                    SalesIncentiveWorkspaceController siwController= new SalesIncentiveWorkspaceController (siwOBJ);
                    siwController.putCollectionRateData();
                }

                when 'Put Final Incentive Data' {
                    SalesIncentiveWorkspaceController siwController= new SalesIncentiveWorkspaceController (siwOBJ);
                    siwController.putFinalIncentiveData();
                }
            }
        }

        //-- update schedule process record
        List<Scheduled_Process__c> spList = [SELECT 
            id, status__c, execute_start__c, Execute_End__c
        FROM Scheduled_Process__c
        WHERE id = :scheduledProcessID
        ];
        
        if (spList.size() > 0) {
            spList[0].Execute_start__c = executeStart;
            spList[0].Execute_End__c = system.now();
            spList[0].status__c = 'Success';

            update spList[0];
        }




    }

}