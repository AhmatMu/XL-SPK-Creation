/**
 * @description       : Functionality to create Sales Incentive for AM, SM, GH base on KPI in system setting
 * @author            : Doddy
 * @group             : Saasten Technologies
 * @last modified on  : 18-08-2022
 * @last modified by  : Doddy Prima
 * 
 * Modification Log
 * Ver   Date         Author        Modification
 * 1.0   08-Sep-21    Doddy         Initial Version
 * 2.0   21-Sep-21    Doddy         add quarterEndDate attribute for handling pipeline soql
 *                                  add functionality to setup for ownerID in sales incentive record       
 * 2.1   22-Sep-21    Doddy         add createActualDetailReportLink method to fulfill the report link
 *                              
**/

public with sharing class SalesIncentiveWorkspaceController {
    
    class KPI_ITEM_WRAP {
        string groupSegment;
        string segment;
        string roleLevels;
        string kpiType;
        string kpiName;
        double weighted;
    }


    public Sales_Incentive_Workspace__c sinWorkspaceREC{get; set;}
    public ID sinWorkspaceID {get; set;}

    public string prevQuarterYear {get; set;}
    public string nextQuarterYear {get; set;}
    
    public string prevQuarterQuarter {get; set;}
    public string nextQuarterQuarter {get; set;}


    public String year;
    public String quarter;
    public String modeData;
    public String[] months;
    public Date periodDate ;
    public Date quarterEndDate;

    public string defaultOwnerID;
    public boolean UseAVGforTotalAchofManager;
    



    public List<SInc_Tiering_Performance_Score_Settings__c> tearingIncALLSegmentList = new List<SInc_Tiering_Performance_Score_Settings__c> ();
    public List<SInc_Tiering_Performance_Score_Settings__c> tearingIncList = New List<SInc_Tiering_Performance_Score_Settings__c>();
    



    public SalesIncentiveWorkspaceController() {

    }

    public SalesIncentiveWorkspaceController(ApexPages.StandardController controller) {

        if (!Test.isRunningTest()) {
			controller.addFields(New List<String> {'year__c', 'quarter__c', 'name', 'id', 'Mode_Data__c'});
		}

        sinWorkspaceREC=  (Sales_Incentive_Workspace__c) controller.getRecord();
        sinWorkspaceID = sinWorkspaceREC.Id;
        System.debug('The record : ' + sinWorkspaceREC);
        
        init();
    }

    public SalesIncentiveWorkspaceController(Sales_Incentive_Workspace__c sinWorkspaceREC) {
        this.sinWorkspaceREC =  sinWorkspaceREC;
        this.sinWorkspaceID = sinWorkspaceREC.Id;
        System.debug('The record : ' + sinWorkspaceREC);

        init();
    }

    public void init () {
        this.year = sinWorkspaceREC.year__c;
        this.quarter = sinWorkspaceREC.quarter__c;
        this.modeData = sinWorkspaceREC.Mode_Data__c;

        months = new List<String>();

        switch on sinWorkspaceREC.quarter__c {
            when  'Q1' {
                prevQuarterYear = string.valueof (integer.valueof(sinWorkspaceREC.year__c) -1 );
                nextQuarterYear = sinWorkspaceREC.year__c; 
                prevQuarterQuarter = 'Q4' ;
                nextQuarterQuarter = 'Q2';

                months.add('1');
                months.add('2');
                months.add('3');
                periodDate = Date.newInstance(integer.valueof(year), 3, 31);
                quarterEndDate = Date.newInstance(integer.valueof(year), 3, 31);

            }

            when  'Q2' {
                prevQuarterYear = sinWorkspaceREC.year__c;
                nextQuarterYear = sinWorkspaceREC.year__c; 
                prevQuarterQuarter = 'Q1' ;
                nextQuarterQuarter = 'Q3';

                months.add('4');
                months.add('5');
                months.add('6');
                periodDate = Date.newInstance(integer.valueof(year), 6, 30);
                quarterEndDate = Date.newInstance(integer.valueof(year), 6, 31);

            }

            when  'Q3' {
                prevQuarterYear = sinWorkspaceREC.year__c;
                nextQuarterYear = sinWorkspaceREC.year__c; 
                prevQuarterQuarter = 'Q2' ;
                nextQuarterQuarter = 'Q4';

                months.add('7');
                months.add('8');
                months.add('9');
                periodDate = Date.newInstance(integer.valueof(year), 9, 31);
                quarterEndDate = Date.newInstance(integer.valueof(year), 9, 31);

            }

            when  'Q4' {
                prevQuarterYear = sinWorkspaceREC.year__c;
                nextQuarterYear = string.valueof (integer.valueof(sinWorkspaceREC.year__c) +1 );
                prevQuarterQuarter = 'Q3' ;
                nextQuarterQuarter = 'Q1';

                months.add('10');
                months.add('11');
                months.add('12');
                periodDate = Date.newInstance(integer.valueof(year), 12, 31);
                quarterEndDate = Date.newInstance(integer.valueof(year), 12, 31);


            }

        } 

        //-- get default owner id;
        Sales_Incentive_General_Setting__c  sincGeneralSettingRec = Sales_Incentive_General_Setting__c.getOrgDefaults();
        defaultOwnerID = sincGeneralSettingRec.default_owner_id__c;
        useAVGforTotalAchofManager = sincGeneralSettingRec.UseAVGforTotalAchofManager__c;

        System.debug('=== defaultOwnerID : ' +defaultOwnerID);

        

        //-- GET TEARING setting list for ALL LE and ALL ME
        tearingIncALLSegmentList = [
            SELECT  year__c, employee_category__c, 
                segment__c, segment__r.name,
                greater_than_equal__c, less_than__c, 
                MainKPIScore__c, OtherKPIScore__c
            FROM SInc_Tiering_Performance_Score_Settings__c
            WHERE year__c = :year
                AND quarter__c = :quarter
                AND segment__r.name like 'ALL%'
        ];

        //-- GET TEARING setting list for NOT ALL LE and ALL ME
        tearingIncList = [
            SELECT  year__c, employee_category__c, 
                segment__c, segment__r.name,
                greater_than_equal__c, less_than__c, 
                MainKPIScore__c, OtherKPIScore__c
            FROM SInc_Tiering_Performance_Score_Settings__c
            WHERE year__c = :year
                AND quarter__c = :quarter
                AND (NOT segment__r.name like 'ALL%')
        ];

    }

    public void attachRelatedObjects () {

        //-- WEIGHTED 
        /*
        List<Sales_Incentive_Weighteds__c> siwList = [SELECT id, year__c, quarter__c, sales_incentive_workspace__c   
        FROM Sales_Incentive_Weighteds__c
        WHERE year__c = :sinWorkspaceREC.year__c
            AND quarter__c = :sinWorkspaceREC.quarter__c
            AND sales_incentive_workspace__c = null
        ];

        for (Sales_Incentive_Weighteds__c siwREC : siwList) {
            //-- todo : update name
            //
            siwREC.sales_incentive_workspace__c = sinWorkspaceID;
        }
        update siwList; */
        //..........................................................................................................


        //-- TIERING
        /*
        List<Tiering_Incentive__c> tieringList = [SELECT id, year__c, quarter__c, sales_incentive_workspace__c   
        FROM Tiering_Incentive__c
        WHERE year__c = :sinWorkspaceREC.year__c
            AND quarter__c = :sinWorkspaceREC.quarter__c
            AND sales_incentive_workspace__c = null
        ];

        for (Tiering_Incentive__c tieringREC : tieringList) {
            //-- todo : update name
            //
            tieringREC.sales_incentive_workspace__c = sinWorkspaceID;
        }
        update tieringList;
        */

        //----------------------------------------------------------------------------------------------------------


        //-- SALES INCENTIVE
        List<Sales_Incentive__c> sinList = [SELECT id, year__c, quarter__c, sales_incentive_workspace__c   
        FROM Sales_Incentive__c
        WHERE year__c = :sinWorkspaceREC.year__c
            AND quarter__c = :sinWorkspaceREC.quarter__c
            AND sales_incentive_workspace__c = null
        ];

        for (Sales_Incentive__c sinREC : sinList) {
            //-- todo : update name
            //
            sinREC.sales_incentive_workspace__c = sinWorkspaceID;
        }
        update sinList;

        //..........................................................................................................


    }

    /*
    public void putData() {
        SalesIncentiveController sinControllerREC = new SalesIncentiveController(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        sinControllerREC.putAMGSData();
        sinControllerREC.putAMData();
        //sinControllerREC.putAchievementData();
        sinWorkspaceREC.Calculation_Date__c = system.now();
        update sinWorkspaceREC;

    }*/

// PERLU DIPISAHKAN UNTUK AM, SM DAN GH
    public void putRevenueData() {
        system.debug(' putRevenueData Mode Data  == ' + this.modeData);
        if(this.modeData == 'Auto Calculate'){
            string relatedSFIDs = sinWorkspaceREC.id;
            List<Sinc_Revenue_Data_Source_Setting__c> revenueDataSourceSettingList = new List<Sinc_Revenue_Data_Source_Setting__c>();

            List<Sinc_Revenue_Data_Source_Setting__c> tmpRevenueDataSourceSettingList = [
            SELECT  
                revenue_type__c, SOQL_type__c
                , combine_soql_am__c, combine_soql_sm__c, combine_soql_gh__c
                , target_soql_am__c, target_soql_sm__c, target_soql_gh__c
                , actual_soql_am__c, actual_soql_sm__c, actual_soql_gh__c
            FROM Sinc_Revenue_Data_Source_Setting__c
            WHERE is_active__c = TRUE
            ];


            //-- loop untuk membuat revenueDataSourceSettingList, dimana pada tmpRevenueDataSourceSettingList yang masih terdapat KPI yang optional (lebih dari 1) akan dibuat masing-masing 1 record setting
            for (Sinc_Revenue_Data_Source_Setting__c revenueDataSourceSettingREC : tmpRevenueDataSourceSettingList) {
                string[] revenueTypes = revenueDataSourceSettingREC.revenue_type__c.split(' / ') ;

                //-- loop for revenue type (single or multi/optional)
                for (String revenueType : revenueTypes) {
                    Sinc_Revenue_Data_Source_Setting__c tmpRevenueDataSourceSettingREC =
                        new Sinc_Revenue_Data_Source_Setting__c (
                                revenue_type__c = revenueType
                                , SOQL_type__c = revenueDataSourceSettingREC.SOQL_type__c
                                , combine_soql_am__c = revenueDataSourceSettingREC.combine_soql_am__c
                                , target_soql_am__c = revenueDataSourceSettingREC.target_soql_am__c                           
                                , actual_soql_am__c = revenueDataSourceSettingREC.actual_soql_am__c
                                
                    );

                    revenueDataSourceSettingList.add( tmpRevenueDataSourceSettingREC );
                }
            }

            system.debug ( '=== revenueDataSourceSettingList : ' + revenueDataSourceSettingList);

            string revenueType;
            string soqltype;
            string soqlString;

            string employeeID;
            //string revenueType;

            for (Sinc_Revenue_Data_Source_Setting__c settingREC : revenueDataSourceSettingList) {

                revenueType = settingREC.revenue_type__c;
                soqltype = settingREC.SOQL_type__c;
                
                //******************************************************* COMBINE ******************************************************* 
                if ( settingREC.SOQL_type__c == 'COMBINE') {

                    //-- PUT AM (account manager) DATA (COMBINE) ------------------------------------------------------------------------
                    soqlString = settingREC.combine_soql_am__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putAMTargetActualRevenueData (soqlString, revenueType);
                    // .endOF put AM (account manager) data (COMBINE) << ----------------------------------------------

                } 

                //******************************************************* SEPARATE ******************************************************* 
                else if ( settingREC.SOQL_type__c == 'SEPARATE') {
                    
                    //-- PUT AM (account manager) DATA ----------------------------------------------------------------------------->

                    //-- TARGET (AM) --
                    soqlString = settingREC.target_soql_am__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putAMTargetRevenueData(soqlString, revenueType);

                    //-- ACTUAL (AM) --
                    soqlString = settingREC.actual_soql_am__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putAMActualRevenueData(soqlString, revenueType);

                    // .endOF put AM (account manager) data (SEPARATE) << ----------------------------------------------------------<

                }
            }

            sinWorkspaceREC.Calculation_Date__c = system.now();
            update sinWorkspaceREC;


            //-- create report link
            createActualDetailReportLink();
        }
    }

    //panggil method ini setelah revenue AM diput 
    public void putRevenueDataSMGH() {
        system.debug(' putRevenueDataSMGH Mode Data  == ' + this.modeData);
        if(this.modeData == 'Auto Calculate' ){
            string relatedSFIDs = sinWorkspaceREC.id;
            List<Sinc_Revenue_Data_Source_Setting__c> revenueDataSourceSettingList = new List<Sinc_Revenue_Data_Source_Setting__c>();

            List<Sinc_Revenue_Data_Source_Setting__c> tmpRevenueDataSourceSettingList = [
            SELECT  
                revenue_type__c, SOQL_type__c
                , combine_soql_sm__c, combine_soql_gh__c
                , target_soql_sm__c, target_soql_gh__c
                , actual_soql_sm__c, actual_soql_gh__c
            FROM Sinc_Revenue_Data_Source_Setting__c
            WHERE is_active__c = TRUE
            ];


            //-- loop untuk membuat revenueDataSourceSettingList, dimana pada tmpRevenueDataSourceSettingList yang masih terdapat KPI yang optional (lebih dari 1) akan dibuat masing-masing 1 record setting
            for (Sinc_Revenue_Data_Source_Setting__c revenueDataSourceSettingREC : tmpRevenueDataSourceSettingList) {
                string[] revenueTypes = revenueDataSourceSettingREC.revenue_type__c.split(' / ') ;

                //-- loop for revenue type (single or multi/optional)
                for (String revenueType : revenueTypes) {
                    Sinc_Revenue_Data_Source_Setting__c tmpRevenueDataSourceSettingREC =
                        new Sinc_Revenue_Data_Source_Setting__c (
                                revenue_type__c = revenueType
                                , SOQL_type__c = revenueDataSourceSettingREC.SOQL_type__c
                                
                                , combine_soql_sm__c = revenueDataSourceSettingREC.combine_soql_sm__c
                                , combine_soql_gh__c = revenueDataSourceSettingREC.combine_soql_gh__c
                                
                                , target_soql_sm__c = revenueDataSourceSettingREC.target_soql_sm__c
                                , target_soql_gh__c = revenueDataSourceSettingREC.target_soql_gh__c
                                
                                , actual_soql_sm__c = revenueDataSourceSettingREC.actual_soql_sm__c
                                , actual_soql_gh__c = revenueDataSourceSettingREC.actual_soql_gh__c
                    );

                    revenueDataSourceSettingList.add( tmpRevenueDataSourceSettingREC );
                }
            }

            system.debug ( '=== revenueDataSourceSettingList : ' + revenueDataSourceSettingList);

            string revenueType;
            string soqltype;
            string soqlString;

            string employeeID;
            //string revenueType;

            for (Sinc_Revenue_Data_Source_Setting__c settingREC : revenueDataSourceSettingList) {

                revenueType = settingREC.revenue_type__c;
                soqltype = settingREC.SOQL_type__c;
                
                //******************************************************* COMBINE ******************************************************* 
                if ( settingREC.SOQL_type__c == 'COMBINE') {

                    //-- PUT SM (Sales Manager) DATA (COMBINE) ------------------------------------------------------------------------
                    soqlString = settingREC.combine_soql_sm__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putSMTargetActualRevenueData(soqlString, revenueType);
                    // .endOF put SM (Sales Manager) data (COMBINE) << ----------------------------------------------


                    //-- PUT GH (Group Head) DATA (COMBINE) ------------------------------------------------------------------------
                    soqlString = settingREC.combine_soql_gh__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putGHTargetActualRevenueData(soqlString, revenueType);
                    // .endOF put SM (Sales Manager) data (COMBINE) << ----------------------------------------------                

                } 

                //******************************************************* SEPARATE ******************************************************* 
                else if ( settingREC.SOQL_type__c == 'SEPARATE') {
                    

                    //-- PUT SM (Sales Manager) DATA ------------------------------------------------------------------------------->

                    //-- TARGET (SM) --
                    soqlString = settingREC.target_soql_sm__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putSMTargetRevenueData(soqlString, revenueType) ;

                    //-- ACTUAL (SM) --
                    soqlString = settingREC.actual_soql_sm__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putSMActualRevenueData(soqlString, revenueType);

                    // .endOF put SM (Sales Manager) data (SEPARATE) << -------------------------------------------------------------<


                    //-- PUT GH (Group Head) DATA (SEPARATE) ------------------------------------------------------------------------>

                    //-- TARGET (GH) --
                    soqlString = settingREC.target_soql_gh__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putGHTargetRevenueData(soqlString, revenueType);
                    
                    //-- ACTUAL (GH) --
                    soqlString = settingREC.actual_soql_gh__c;
                    system.debug('=== soqlString : ' + soqlString);
                    putGHActualRevenueData(soqlString, revenueType);
                        
                    // .endOF put SM (Sales Manager) data (SEPARATE) << ---------------------------------------------------------------<               

                }


            }

            sinWorkspaceREC.Calculation_Date__c = system.now();
            update sinWorkspaceREC;


            //-- create report link
            createActualDetailReportLink();

        }
    }

    //-- COMBINE SOQL ---
    //-- PUT Account Manager (AM) Target & Actual (COMBINE) DATA
    public void putAMTargetActualRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putAMTargetActualRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;

        try {
            system.debug('=== soqlString : ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            List<AggregateResult> performanceARAMList = Database.query(soqlString);
            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();

            for (AggregateResult performanceAR : performanceARAMList ) {

                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_AM_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);

                sinREC.role_level__c = 'AM';
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');
                sinREC.Group_Segment__c = (string) performanceAR.get('groupSegmentName');
                sinREC.Segment__c = (ID) performanceAR.get('segmentSFID');
                sinREC.Target__c = (double) performanceAR.get('target');
                sinREC.Actual__c = (double) performanceAR.get('actual');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;
                sinREC.Sales_Manager__c = (ID) performanceAR.get('salesManagerId');
                sinREC.group_head__c = (ID) performanceAR.get('groupHeadId');

    
                //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                    system.debug ('set ownerid to default');
                    //-- kalau nga active semua , set default owner
                    ownerID = defaultOwnerID;
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }
                //--- endof Set OwnerID


                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putAMTargetActualRevenueData (AM Data - COMBINE) method.' + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  + ' - ' + soqlString  ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }    
    }

    //-- PUT Sales Manager (SM) Target & Actual (COMBINE) DATA
    public void putSMTargetActualRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putSMTargetActualRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;

        try {
            system.debug('=== soqlString : ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            
            List<AggregateResult> performanceARSMList = Database.query(soqlString);

            //-- GET Segement data -----------------------------------------
            Set<String> segmentNames = new Set<String> ();
            string roleName;
            string segmentName;

            for (AggregateResult performanceAR : performanceARSMList ) {
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                        roleName = roleName.replace('Head - ', '');
                        segmentNames.add (roleName.toUpperCase());
                    }
                }
            }
            List<Segment__c> segmentList =  
            [ SELECT ID, Name, Group_Segment_Name__c
                FROM Segment__c 
                WHERE name in :segmentNames
            ];
            //-- PUT Segment Name and SFID into the Map
            Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
            for (Segment__c REC : segmentList ) {
                segmentMap.put(REC.Name.toUpperCase(), REC);
            }
            SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );



            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();

            for (AggregateResult performanceAR : performanceARSMList ) {

                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_SM_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);
              //  sinREC.group_head__c = (ID) performanceAR.get('groupHeadId');
                sinREC.role_level__c = 'SM';
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');
                
                //-- get segment information --
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                    roleName = roleName.replace('Head - ', '');
                    segmentName = roleName.toUpperCase();
                    }
                }
                Segment__c segmentREC = segmentMap.get(segmentName);

                if (segmentREC != null) {
                    sinREC.Group_Segment__c = segmentREC.Group_Segment_Name__c; // (string) performanceAR.get('groupSegmentName');
                    sinREC.Segment__c = segmentREC.id; //  (ID) performanceAR.get('segmentSFID');
                }

                sinREC.Target__c = (double) performanceAR.get('target');
                sinREC.Actual__c = (double) performanceAR.get('actual');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                  //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                    system.debug ('set ownerid to default');
                    //-- kalau nga active semua , set default owner
                    ownerID = defaultOwnerID;                    
                    
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }

                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
            
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putSMTargetActualRevenueData (SM Data - COMBINE) method.'  + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString() + ' - ' + soqlString ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }        
    }

    //-- PUT Group Head (GH) Target & Actual (COMBINE) DATA
    public void putGHTargetActualRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putGHTargetActualRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;
        
        try {
            system.debug('=== soqlString : ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            List<AggregateResult> performanceARGHList = Database.query(soqlString);

            //-- GET Segement data -----------------------------------------
            Set<String> segmentNames = new Set<String> ();
            string roleName;
            string segmentName;

            for (AggregateResult performanceAR : performanceARGHList ) {
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    roleName = roleName.replace('Group Head - ', '');
                    segmentNames.add (roleName.toUpperCase());
                }
            }
            system.debug( 'segmentName = ' +segmentName );
            List<Segment__c> segmentList =  
            [ SELECT ID, Name, Group_Segment_Name__c
                FROM Segment__c 
                WHERE name in :segmentNames
            ];
            //-- PUT Segment Name and SFID into the Map
            Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
            for (Segment__c REC : segmentList ) {
                segmentMap.put(REC.Name.toUpperCase(), REC);
            }
            SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );

            
            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();

            for (AggregateResult performanceAR : performanceARGHList ) {

                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_GH_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);
                sinREC.role_level__c = 'GH';
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');

                //-- get segment information --
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                    roleName = roleName.replace('Group Head - ', '');
                    segmentName = roleName.toUpperCase();
                    }
                }
                Segment__c segmentREC = segmentMap.get(segmentName);

                if (segmentREC != null) {
                    sinREC.Group_Segment__c = segmentREC.Group_Segment_Name__c; // (string) performanceAR.get('groupSegmentName');
                }

                sinREC.Target__c = (double) performanceAR.get('target');
                sinREC.Actual__c = (double) performanceAR.get('actual');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                    system.debug ('set ownerid to default');
                    //-- kalau nga active semua , set default owner
                    ownerID = defaultOwnerID;      
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }


                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putGHTargetActualRevenueData (GH Data - COMBINE) method.' + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  + ' - ' + soqlString ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

    //-- SEPARATE SOQL ---
    //-- PUT Account Manager (AM) Target (SEPARATE) DATA
    public void putAMTargetRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putAMTargetRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;
        
        try {
            system.debug('=== soqlString : ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            List<AggregateResult> performanceARAMList = Database.query(soqlString);
            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();

            for (AggregateResult performanceAR : performanceARAMList ) {

                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_AM_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);

                sinREC.role_level__c = 'AM';
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');
                sinREC.Sales_Manager__c = (ID) performanceAR.get('salesManagerId');
                sinREC.group_head__c = (ID) performanceAR.get('groupHeadId');
                sinREC.Group_Segment__c = (string) performanceAR.get('groupSegmentName');
                sinREC.Segment__c = (ID) performanceAR.get('segmentSFID');
                sinREC.Target__c = (double) performanceAR.get('target');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                    system.debug ('set ownerid to default');
                    //-- kalau nga active semua , set default owner
                    ownerID = defaultOwnerID;      
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }

                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putAMTargetRevenueData (AM Data - SEPARATE - Target) method.' + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  + ' - ' + soqlString  ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

    //-- PUT Account Manager (AM) Actual (SEPARATE) DATA
    public void putAMActualRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putAMActualRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;
        
        try {
            system.debug('=== soqlString putAMActualRevenueData: ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            system.debug('next quarter : ' + nextQuarterQuarter); system.debug('next quarter year : ' + nextQuarterYear);
            system.debug('quarter end date : ' + quarterEndDate);
            List<AggregateResult> performanceARAMList = Database.query(soqlString);
            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();

            //-- GET Segement data -----------------------------------------
            Set<String> segmentNames = new Set<String> ();
            string roleName;
            string segmentName;

            for (AggregateResult performanceAR : performanceARAMList ) {
                roleName = (string) performanceAR.get('roleName');
                system.debug('  roleName >> ' + roleName);
                if (roleName != null) {
                    roleName = roleName.replace('Group Head - ', '').replace('Head - ', '');
                    segmentNames.add (roleName.toUpperCase());
                }
            }
            List<Segment__c> segmentList =  
            [ SELECT ID, Name, Group_Segment_Name__c
                FROM Segment__c 
                WHERE name in :segmentNames
            ];
            //-- PUT Segment Name and SFID into the Map
            Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
            for (Segment__c REC : segmentList ) {
                segmentMap.put(REC.Name.toUpperCase(), REC);
            }
            SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );


            for (AggregateResult performanceAR : performanceARAMList ) {
                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_AM_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);

                sinREC.role_level__c = 'AM';
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');
                sinRec.sales_manager__c = (ID) performanceAR.get('salesManagerId');
                sinRec.group_head__c = (ID) performanceAR.get('groupHeadId');

                //-- get segment information --
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                    roleName = roleName.replace('Group Head - ', '').replace('Head - ', '');
                    segmentName = roleName.toUpperCase();
                    }
                }
                Segment__c segmentREC = segmentMap.get(segmentName);

                if (segmentREC != null) {
                    sinREC.Group_Segment__c = segmentREC.Group_Segment_Name__c; // (string) performanceAR.get('groupSegmentName');
                    sinREC.Segment__c = segmentREC.id; //  (ID) performanceAR.get('segmentSFID');
                }

                sinREC.Actual__c = (double) performanceAR.get('actual');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                system.debug ('set ownerid to default');
                //-- kalau nga active semua , set default owner
                ownerID = defaultOwnerID;    
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }

                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putAMActualRevenueData (AM Data - SEPARATE - ACTUAL) method.' + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  + ' - ' + soqlString  ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

    //-- PUT Sales Manager (SM) Target  (SEPARATE) DATA // need update get from sales incentive
    public void putSMTargetRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putSMTargetRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;
        
        try {
            system.debug('=== soqlString : ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            List<AggregateResult> performanceARSMList = Database.query(soqlString);

            //-- GET Segement data -----------------------------------------
            Set<String> segmentNames = new Set<String> ();
            string roleName;
            string segmentName;

            for (AggregateResult performanceAR : performanceARSMList ) {
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                        roleName = roleName.replace('Head - ', '');
                        segmentNames.add (roleName.toUpperCase());
                    }
                }
            }
            List<Segment__c> segmentList =  
            [ SELECT ID, Name, Group_Segment_Name__c
                FROM Segment__c 
                WHERE name in :segmentNames
            ];
            //-- PUT Segment Name and SFID into the Map
            Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
            for (Segment__c REC : segmentList ) {
                segmentMap.put(REC.Name.toUpperCase(), REC);
            }
            SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );



            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();

            for (AggregateResult performanceAR : performanceARSMList ) {

                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_SM_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);

                sinREC.role_level__c = 'SM';
             //   sinREC.group_head__c = (ID) performanceAR.get('groupHeadId');
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');
                
                //-- get segment information --
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                    roleName = roleName.replace('Head - ', '');
                    segmentName = roleName.toUpperCase();
                    }
                }
                Segment__c segmentREC = segmentMap.get(segmentName);

                if (segmentREC != null) {
                    sinREC.Group_Segment__c = segmentREC.Group_Segment_Name__c; // (string) performanceAR.get('groupSegmentName');
                    sinREC.Segment__c = segmentREC.id; //  (ID) performanceAR.get('segmentSFID');
                }

                sinREC.Target__c = (double) performanceAR.get('target');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                    system.debug ('set ownerid to default');
                //-- kalau nga active semua , set default owner
                ownerID = defaultOwnerID;
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }

                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putSMTargetRevenueData (SM Data - SEPARATE - TARGET) method.' + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString() + ' - ' + soqlString ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

    //-- PUT Sales Manager (SM) Actual (SEPARATE) DATA // need update get from sales incentive
    public void putSMActualRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putSMActualRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;

        try {
            system.debug('=== soqlString : ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            List<AggregateResult> performanceARAMList = Database.query(soqlString);
            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();


            //-- GET Segement data -----------------------------------------
            Set<String> segmentNames = new Set<String> ();
            string roleName;
            string segmentName;

            for (AggregateResult performanceAR : performanceARAMList ) {
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    roleName = roleName.replace('Head - ', '');
                    segmentNames.add (roleName.toUpperCase());
                }
            }
            List<Segment__c> segmentList =  
            [ SELECT ID, Name, Group_Segment_Name__c
                FROM Segment__c 
                WHERE name in :segmentNames
            ];
            //-- PUT Segment Name and SFID into the Map
            Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
            for (Segment__c REC : segmentList ) {
                segmentMap.put(REC.Name.toUpperCase(), REC);
            }
            SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );


            for (AggregateResult performanceAR : performanceARAMList ) {
                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_SM_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);

                sinREC.role_level__c = 'SM';
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');

                //-- get segment information --
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                    roleName = roleName.replace('Head - ', '');
                    segmentName = roleName.toUpperCase();
                    }
                }
                Segment__c segmentREC = segmentMap.get(segmentName);

                if (segmentREC != null) {
                    sinREC.Group_Segment__c = segmentREC.Group_Segment_Name__c; // (string) performanceAR.get('groupSegmentName');
                    sinREC.Segment__c = segmentREC.id; //  (ID) performanceAR.get('segmentSFID');
                }

                sinREC.Actual__c = (double) performanceAR.get('actual');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                    system.debug ('set ownerid to default');
                    //-- kalau nga active semua , set default owner
                    ownerID = defaultOwnerID;
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }

                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putSMActualRevenueData (SM Data - SEPARATE - ACTUAL) method.' + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  + ' - ' + soqlString  ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }    
    }
    
    
    //-- PUT Group Head (GH) Target (SEPARATE) DATA // // need update get from sales incentive
    public void putGHTargetRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putGHTargetRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;
        
        try {
            system.debug('=== soqlString : ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            List<AggregateResult> performanceARGHList = Database.query(soqlString);

            //-- GET Segement data -----------------------------------------
            Set<String> segmentNames = new Set<String> ();
            string roleName;
            string segmentName;

            system.debug('performanceARGHList == '  + performanceARGHList.size());

            for (AggregateResult performanceAR : performanceARGHList ) {
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    roleName = roleName.replace('Group Head - ', '');
                    segmentNames.add (roleName.toUpperCase());
                }
            }
            List<Segment__c> segmentList =  
            [ SELECT ID, Name, Group_Segment_Name__c
                FROM Segment__c 
                WHERE name in :segmentNames
            ];
            //-- PUT Segment Name and SFID into the Map
            Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
            for (Segment__c REC : segmentList ) {
                segmentMap.put(REC.Name.toUpperCase(), REC);
            }
            SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );

            
            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();

            for (AggregateResult performanceAR : performanceARGHList ) {

                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_GH_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);

                sinREC.role_level__c = 'GH';
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');
                

                //-- get segment information --
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                    roleName = roleName.replace('Group Head - ', '');
                    segmentName = roleName.toUpperCase();
                    }
                }
                Segment__c segmentREC = segmentMap.get(segmentName);

                if (segmentREC != null) {
                    sinREC.Group_Segment__c = segmentREC.Group_Segment_Name__c; // (string) performanceAR.get('groupSegmentName');
                }


                sinREC.Target__c = (double) performanceAR.get('target');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;


                //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                    system.debug ('set ownerid to default');
                    //-- kalau nga active semua , set default owner
                    ownerID = defaultOwnerID;
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }

                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putGHTargetRevenueData (GH Data - SEPARATE - TARGET) method.' + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  + ' - ' + soqlString ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

    //-- PUT Group Head (GH) Actual (SEPARATE) DATA // // need update get from sales incentive
    public void putGHActualRevenueData(string soqlString, string revenueType) {
        system.debug ('========== SalesIncentiveWorkspaceController.putGHActualRevenueData ==========');
        
        string relatedSFIDs = sinWorkspaceREC.id;
        string employeeID;
        
        try {
            system.debug('=== soqlString : ' + soqlString); system.debug('=== year months : ' + year + ' ' + months);
            List<AggregateResult> performanceARAMList = Database.query(soqlString);
            List <Sales_Incentive__c> sinList = new List<Sales_Incentive__c>();


            //-- GET Segement data -----------------------------------------
            Set<String> segmentNames = new Set<String> ();
            string roleName;
            string segmentName;

            for (AggregateResult performanceAR : performanceARAMList ) {
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    roleName = roleName.replace('Group Head - ', '');
                    segmentNames.add (roleName.toUpperCase());
                }
            }
            List<Segment__c> segmentList =  
            [ SELECT ID, Name, Group_Segment_Name__c
                FROM Segment__c 
                WHERE name in :segmentNames
            ];
            //-- PUT Segment Name and SFID into the Map
            Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
            for (Segment__c REC : segmentList ) {
                segmentMap.put(REC.Name.toUpperCase(), REC);
            }
            SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );


            for (AggregateResult performanceAR : performanceARAMList ) {
                Sales_Incentive__c sinREC = new Sales_Incentive__c();
                employeeID = (string) performanceAR.get('EmployeeID') ;

                sinREC.name = 'SIN_' + year.right(2) + quarter + '_GH_' + employeeID  + '_' + revenueType;
                sinREC.unique_id__c = sinREC.name;
                system.debug ('===== sinREC.unique_id__c : ' + sinREC.unique_id__c);

                sinREC.role_level__c = 'GH';
                sinREC.Type__c = revenueType;
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                sinREC.Sales_Person__c = (ID) performanceAR.get('userSFID');

                //-- get segment information --
                roleName = (string) performanceAR.get('roleName');
                if (roleName != null) {
                    if (roleName != null) {
                    roleName = roleName.replace('Group Head - ', '');
                    segmentName = roleName.toUpperCase();
                    }
                }
                Segment__c segmentREC = segmentMap.get(segmentName);

                if (segmentREC != null) {
                    sinREC.Group_Segment__c = segmentREC.Group_Segment_Name__c; // (string) performanceAR.get('groupSegmentName');
                }

                sinREC.Actual__c = (double) performanceAR.get('actual');
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                //-- Set OwnerID
                ID userSFID = (ID) performanceAR.get('userSFID');
                boolean userIsActive = (boolean) performanceAR.get('userIsActive');
                ID managerSFID = (ID) performanceAR.get('managerSFID');
                boolean managerIsActive = (boolean) performanceAR.get('managerIsActive');
                ID managerManagerSFID = (ID) performanceAR.get('managerManagerSFID');
                boolean managerManagerIsActive = (boolean) performanceAR.get('managerManagerIsActive');

                id ownerID;
                if (userIsActive) {
                    ownerID = (ID) performanceAR.get('userSFID');
                }
                else if (managerIsActive) {
                    ownerID = (ID) performanceAR.get('managerSFID');
                }
                else if (managerManagerIsActive) {
                    ownerID = (ID) performanceAR.get('managerManagerSFID');
                }
                else {
                    system.debug ('set ownerid to default');
                    //-- kalau nga active semua , set default owner
                    ownerID = defaultOwnerID;
                }

                if (ownerID <> null) {
                    sinREC.ownerid = ownerId;
                }

                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putGHActualRevenueData (GH Data - SEPARATE - ACTUAL) method.' + ' Revenue Type : ' + revenueType ; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  + ' - ' + soqlString  ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        } 
    }


    public void putAchievementData() {    
        system.debug('========== in SalesIncentiveWorkspaceController.putAchievementData method ========== ');
        string relatedSFIDs = sinWorkspaceREC.id;
        
        //SalesIncentiveController sinControllerREC = new SalesIncentiveController(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        //sinControllerREC.putAchievementData();
        //untuk non type2 contains "/" untuk handle achievement saja
        

        List<SInc_Achievement_Setting__c> achievementSettingList= [
        SELECT revenue_type__c,
            min__c, max__c
        FROM SInc_Achievement_Setting__c
        WHERE year__c = :year
            AND quarter__c = :quarter
        ];
        

        /*
        List<Sales_Incentive__c> sinList = [
        SELECT type__c, target__c, actual__c, Achievement__c
        FROM Sales_Incentive__c
        WHERE year__c = :year
            AND quarter__c = :quarter
        ];*/

        List<sales_incentive__c> sinList = [SELECT type__c, target__c, actual__c, Achievement__c, role_level__c
        FROM Sales_Incentive__c
        WHERE year__c = :year
        AND quarter__c = :quarter and (NOT Type__c like '%/%')];

        for (Sales_Incentive__c sinREC : sinList) {
            double achievement = 0;
            double target = sinREC.target__c;
            double actual = sinREC.actual__c;
            String RoleLevel = sinRec.role_level__c;
    
            if (target == null) target = 0;
            if (actual == null) actual = 0;
            
            if (target <> 0  ) {
                achievement = (actual / target) * 100;
                system.debug (' == actual : ' + actual);
                system.debug (' == target : ' + target);
                system.debug (' == achievement : ' + achievement);
            }

            for (SInc_Achievement_Setting__c  achievementSettingREC : achievementSettingList) {
                if (achievementSettingREC.revenue_type__c == sinREC.type__c ) {

                    if (achievement < achievementSettingREC.min__c) {
                        achievement = achievementSettingREC.min__c;
                    }

                    if (achievement > achievementSettingREC.max__c) {
                        achievement = achievementSettingREC.max__c;
                    }
                }
            }

            sinREC.Achievement__c = achievement;
        }

        try {
            update sinList;

            sinWorkspaceREC.Calculation_Date__c = system.now();
            update sinWorkspaceREC;
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putAchievementData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  +  '' ;integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }






        // add untuk condition "/" SM dan GH metode sama untuk handle achievement saja ===================================
        
        //-- for SALES MANAGER ----------------------------
        List<AggregateResult> sinSMList = [SELECT 
            AVG(Achievement__c) ach, 
            role_level__c role, 
            type2__c type2, 
            sales_manager__C salesManager, 
            sales_manager__r.name salesManagerName,
            sales_manager__r.Employee_ID__c SMEmployeeId, 
            group_head__c groupHead, 
            group_head__r.name groupHeadName,
            segment__c SMsegment,
            group_segment__c SMGroupSegment 
        FROM 
            Sales_Incentive__c 
        WHERE 
            year__c = :year 
            AND quarter__c = :quarter 
            and Type2__c like '%/%' 
            and sales_manager__c != null
            and isused__c = true
            and role_level__c = 'AM'
        group by 
            role_level__c, 
            type2__c, 
            sales_manager__c, 
            group_head__c, 
            sales_manager__r.name, 
            group_head__r.name,
            sales_manager__r.Employee_ID__c,
            segment__c,
            group_segment__c
        
        ];
        system.debug(' sinSMList >> ' + sinSMList);
        system.debug(' sinSMList >> ' + sinSMList.size());

        list<sales_incentive__c> sincSMList = new List <sales_incentive__c>();

        if(sincSMList != null){
        
            for(AggregateResult sinRec : sinSMList){
                Double achievement = (Double) sinRec.get('ach');
                String salesPersonIds = (String) sinRec.get('salesManager');
                String ownerIds = (String) sinRec.get('salesManager');
                String groupHeadIds = (string) sinRec.get('groupHead');
                String sincType2 = (String) sinRec.get('type2');
                String SMEmployeeId = (String) sinRec.get('SMEmployeeId');
                String SMSegmentId = (String) sinRec.get('SMsegment');
                String SMGroupSegment = (String) sinRec.get('SMGroupSegment');
                system.debug(' sincType2 >> ' + sincType2);
                
                for (SInc_Achievement_Setting__c  achievementSettingREC : achievementSettingList) {

                    if (achievementSettingREC.revenue_type__c == sincType2 ) {

                        if (achievement < achievementSettingREC.min__c) {
                            achievement = achievementSettingREC.min__c;
                        }

                        if (achievement > achievementSettingREC.max__c) {
                            achievement = achievementSettingREC.max__c;
                        }
                    }
                }

                sales_incentive__c sincCreationRec = new Sales_Incentive__c ();
                sincCreationRec.name = 'SIN_' + year.right(2) + quarter + '_SM_'+ SMEmployeeId + '_' + sincType2;
                system.debug(' sincCreationRec.name >> ' + sincCreationRec.name);
                sincCreationRec.sales_person__c = salesPersonIds;
                sincCreationRec.ownerId = ownerIds;
                sincCreationRec.group_head__c = groupHeadIds;
                sincCreationRec.year__c = year;
                sincCreationRec.quarter__c = quarter;
                sincCreationRec.achievement__c = achievement;
                sincCreationRec.type__c = sincType2;
                sincCreationRec.role_level__c = 'SM';
                sincCreationRec.segment__c = SMSegmentId;
                sincCreationRec.group_segment__c = SMGroupSegment;
                sincCreationRec.sales_incentive_workspace__c = sinWorkspaceID;
                sincCreationRec.unique_id__c = sincCreationRec.name;
                sincCreationRec.period_date__c = periodDate;

                sincSMList.add(sincCreationRec);
            }
            
            try {
                system.debug('sincSMList >>  ' + sincSMList);
                upsert sincSMList unique_id__c;
    
                sinWorkspaceREC.Calculation_Date__c = system.now();
                update sinWorkspaceREC;
            }
            catch (Exception e) {
                string notes = 'Error on SalesIncentiveWorkspaceController.putAchievementData method on SM.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  +  '' ;integer lineNumber = e.getLineNumber();
                
                string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
                system.debug ('===== errorMsg : ' + errorMsg);
            }



            //-- for GROUP HEAD ----------------------------
            List<AggregateResult> sinGHList = [SELECT 
                AVG(Achievement__c) ach, 
                type2__c type2,  
                group_head__c groupHead, 
                group_head__r.name groupHeadName,
                group_head__r.employee_id__c GHEmployeeid,
                group_segment__c GHGroupSegment 
            FROM 
                Sales_Incentive__c 
            WHERE 
                year__c = :year 
                AND quarter__c = :quarter 
                and Type2__c like '%/%'
                and isUsed__c = true 
                and role_level__c = 'AM'
            group by 
                type2__c, 
                group_head__c,  
                group_head__r.name,
                group_segment__c,
                group_head__r.employee_id__c
            
            ];

            system.debug('sinGHList >> ' + sinGHList);
            list<sales_incentive__c> sincGHList = new List <sales_incentive__c>();

            if(sincSMList.size() > 0){
        
                for(AggregateResult sinRec : sinGHList){
                    Double achievement = (Double) sinRec.get('ach');
                    String salesPersonIds = (String) sinRec.get('groupHead');
                    String ownerIds = (String) sinRec.get('groupHead');
                    String groupHeadIds = (string) sinRec.get('groupHead');
                    String sincType2 = (String) sinRec.get('type2');
                    String GHEmployeeId = (String) sinRec.get('GHEmployeeid');
                    String GHGroupSegment = (String) sinRec.get('GHGroupSegment');

                    for (SInc_Achievement_Setting__c  achievementSettingREC : achievementSettingList) {

                        if (achievementSettingREC.revenue_type__c == sincType2 ) {

                            if (achievement < achievementSettingREC.min__c) {
                                achievement = achievementSettingREC.min__c;
                            }

                            if (achievement > achievementSettingREC.max__c) {
                                achievement = achievementSettingREC.max__c;
                            }
                        }
                    }

                    sales_incentive__c sincCreationRec = new Sales_Incentive__c ();
                    sincCreationRec.name = 'SIN_' + year.right(2) + quarter + '_GH_' + GHEmployeeId + '_' + sincType2;
                    sincCreationRec.sales_person__c = salesPersonIds;
                    sincCreationRec.ownerId = ownerIds;
                    sincCreationRec.year__c = year;
                    sincCreationRec.quarter__c = quarter;
                    sincCreationRec.group_head__c = groupHeadIds;
                    sincCreationRec.achievement__c = achievement;
                    sincCreationRec.type__c = sincType2;
                    sincCreationRec.role_level__c = 'GH';
                    sincCreationRec.group_segment__c = GHGroupSegment;
                    sincCreationRec.sales_incentive_workspace__c = sinWorkspaceID;
                    sincCreationRec.unique_id__c = sincCreationRec.name;
                    sincCreationRec.period_date__c = periodDate;

                    sincGHList.add(sincCreationRec);
                }
            
                try {
                    upsert sincGHList unique_id__c;
        
                    sinWorkspaceREC.Calculation_Date__c = system.now();
                    update sinWorkspaceREC;
                }
                catch (Exception e) {
                    string notes = 'Error on SalesIncentiveWorkspaceController.putAchievementData method on GH.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString()  +  '' ;integer lineNumber = e.getLineNumber();
                    
                    string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
                    system.debug ('===== errorMsg : ' + errorMsg);
                }

            }

        }
    }




    /**
     * version      : 1.0
     * function     : put weighted data from wieghted setting
     * start date   : ..
     * end date     : Q3 2021
     */
    
    /*
    public void putWeightedData_v1() {    
        system.debug('========== in SalesIncentiveWorkspaceController.putWeightedData method ========== ');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;

        //SalesIncentiveController sinControllerREC = new SalesIncentiveController(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        //sinControllerREC.putWeightedData();

        //-- set collection rate :
        List<Sinc_Weighted_Setting__c> siwList = [SELECT id, group_segment__c, 
            segment__r.name, role_level__c,  revenue_type__c, Weighted__c 
        FROM Sinc_Weighted_Setting__c
        WHERE year__c = :year
            AND quarter__c = :quarter
        ];

        
        List<Sales_incentive__c> sinList= new List<Sales_incentive__c>();

        string groupSegment;
        string segment;
        string roleLevel;
        string revenueType;
        double weighted;

        string condition;
        string soqlString;

        //List<Sales_Incentive__c> sinAllList = new List<Sales_Incentive__c> ();

        try {
            for (Sinc_Weighted_Setting__c siwREC : siwList ) {

                groupSegment = siwREC.group_segment__c;
                segment = siwREC.segment__r.name;
                roleLevel = siwREC.role_level__c;
                revenueType = siwREC.revenue_type__c;
                weighted = siwREC.weighted__c;
            
                condition = ' year__c = \'' + year + '\' and quarter__c = \'' + quarter  + '\'' ;
                condition = condition + ' AND type__c = \'' + revenueType + '\'' ;

                if ( segment.left(3) != 'ALL' ) {
                    condition = condition + ' AND segment__r.name =\'' + segment + '\'';
                }
                condition = condition + ' AND group_segment__c =\'' + groupSegment + '\'';
                condition = condition + ' AND role_level__c = \'' + roleLevel + '\'' ;

                soqlString = 'select id, name, weighted__c from Sales_Incentive__c where ' + condition;
                system.debug ('=== soqlString : ' + soqlString);

                List<Sales_Incentive__c> sinTEMPList = Database.query (soqlString);
                if (sinTEMPList.size() > 0) {
                    for (Sales_Incentive__c sinREC : sinTEMPList) {
                        system.debug ('=== sinREC : ' + sinREC);

                        sinREC.weighted__c = siwREC.weighted__c;
                        sinList.add (sinREC);
                       

                    }
                    update sinTEMPList;

                    sinWorkspaceREC.Calculation_Date__c = system.now();
                    update sinWorkspaceREC;
                }


            }


            //system.debug ('===== sinList : ' + sinList);  ///TODO : find, why wrrror duplicate
            //update sinList;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putWeightedData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + sinList + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

    }
    */


    /**
     * version      : 2.0
     * function     : put weighted data from Total Achievement setting
     * start date   : Q1 2022
     * end date     : ...
     */
    public void putWeightedData() {    
        system.debug('========== in SalesIncentiveWorkspaceController.putWeightedData method ========== ');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;

        //-- Get wieghted from total achievement setting
        List<SInc_Main_KPI_Item__c> mainKPIweightedList = [SELECT id,
            TotalAchievementSetting__r.segment__r.Group_Segment_Name__c,
            TotalAchievementSetting__r.segment__r.name, 
            TotalAchievementSetting__r.Role_Levels__c,
            KPIName__c,
            Weighted__c 
        FROM SInc_Main_KPI_Item__c
        WHERE TotalAchievementSetting__r.year__c = :year
            AND TotalAchievementSetting__r.quarter__c = :quarter
        ];
        system.debug(' == mainKPIweightedList : ' + mainKPIweightedList.size());

        List<SInc_Other_KPI_Item__c> otherKPIweightedList = [SELECT id,
            TotalAchievementSetting__r.segment__r.Group_Segment_Name__c,
            TotalAchievementSetting__r.segment__r.name, 
            TotalAchievementSetting__r.Role_Levels__c,
            KPIName__c,
            Weighted__c 
        FROM SInc_Other_KPI_Item__c
        WHERE TotalAchievementSetting__r.year__c = :year
            AND TotalAchievementSetting__r.quarter__c = :quarter
        ];
        system.debug(' == otherKPIweightedList : ' + otherKPIweightedList.size());
        
        List <KPI_ITEM_WRAP> weightedList = New List <KPI_ITEM_WRAP>();  //-- initiate list of wieghted

        //-- put MAIN kpi wieghted to the list
        for (SInc_Main_KPI_Item__c weightedRec: mainKPIweightedList) {
            KPI_ITEM_WRAP weightedWrapRec = New KPI_ITEM_WRAP();
            weightedWrapRec.kpiName = weightedRec.KPIName__c;
            weightedWrapRec.kpiType = 'Main';
            weightedWrapRec.groupSegment = weightedRec.TotalAchievementSetting__r.segment__r.Group_Segment_Name__c;
            weightedWrapRec.segment = weightedRec.TotalAchievementSetting__r.segment__r.name;
            weightedWrapRec.roleLevels = weightedRec.TotalAchievementSetting__r.Role_Levels__c;            
            weightedWrapRec.weighted = weightedRec.Weighted__c;
            weightedList.add (weightedWrapRec);
        }

        //-- put OTHER kpi wieghted to the list
        for (SInc_Other_KPI_Item__c weightedRec: otherKPIweightedList) {
            KPI_ITEM_WRAP weightedWrapRec = New KPI_ITEM_WRAP();
            weightedWrapRec.kpiName = weightedRec.KPIName__c;
            weightedWrapRec.kpiType = 'Other';
            weightedWrapRec.groupSegment = weightedRec.TotalAchievementSetting__r.segment__r.Group_Segment_Name__c;
            weightedWrapRec.segment = weightedRec.TotalAchievementSetting__r.segment__r.name;
            weightedWrapRec.roleLevels= weightedRec.TotalAchievementSetting__r.Role_Levels__c;            
            weightedWrapRec.weighted = weightedRec.Weighted__c;
            weightedList.add (weightedWrapRec);
        }       

        system.debug('=== weightedList : ' + weightedList);


        List<Sales_incentive__c> sinList= new List<Sales_incentive__c>();

        string groupSegment;
        string segment;
        string roleLevels='';
        string[] revenueTypeList;
        set<string> revenueTypes = new set<string>() ;
        double weighted;

        string condition;
        string soqlString;

        //List<Sales_Incentive__c> sinAllList = new List<Sales_Incentive__c> ();

        try {
            for (KPI_ITEM_WRAP weightedREC : weightedList ) {

                groupSegment = weightedREC.groupSegment;
                segment = weightedREC.segment;

                List<String> roleLevelList= weightedREC.roleLevels.split(';');
                roleLevels = '';
                for (String roleLevel : roleLevelList) {
                    roleLevels = roleLevels + '\'' + roleLevel + '\',';
                }
                roleLevels = roleLevels.left(roleLevels.length()-1);

                if(roleLevels.contains('AM')){
                system.debug ('=== weightedREC.kpiName : ' + weightedREC.kpiName);
                revenueTypeList = weightedREC.kpiName.split(' / ');

                revenueTypes = new set<string>() ;
                for (string str : revenueTypeList) {
                    revenueTypes.add(str);
                }
                system.debug ('=== revenueTypes : ' + revenueTypes);

                weighted = weightedREC.weighted;
            
                condition = ' year__c = \'' + year + '\' and quarter__c = \'' + quarter  + '\'' ;
                condition = condition + ' AND type__c in :revenueTypes ';  // = \'' + revenueTypes + '\'' ;

                if ( segment.left(3) != 'ALL' ) {
                    condition = condition + ' AND segment__r.name =\'' + segment + '\'';
                }
                condition = condition + ' AND group_segment__c =\'' + groupSegment + '\'';
                condition = condition + ' AND role_level__c in (\'AM\')' ;

                soqlString = 'select id, name, weighted__c from Sales_Incentive__c where ' + condition;
                system.debug ('=== soqlString AM: ' + soqlString);

                List<Sales_Incentive__c> sinTEMPList = Database.query (soqlString);
                if (sinTEMPList.size() > 0) {
                    for (Sales_Incentive__c sinREC : sinTEMPList) {
                        system.debug ('=== sinREC : ' + sinREC);

                        sinREC.weighted__c = weightedREC.weighted;
                        sinREC.kpiType__c = weightedREC.kpiType;
                        //ngetest
                     
                        sinREC.type2__c = weightedREC.kpiName;
                        sinList.add (sinREC);
                    }

                    system.debug ('=== sinTEMPList : ' + sinTEMPList);
                    update sinTEMPList;

                    sinWorkspaceREC.Calculation_Date__c = system.now();
                    update sinWorkspaceREC;
                }
            }
            
            if(roleLevels.contains('SM') || roleLevels.contains('GH')){
                String roleLevelSMGH = '(\'SM\',\'GH\')';
                system.debug ('=== weightedREC.kpiName : ' + weightedREC.kpiName);
                revenueTypeList = weightedREC.kpiName.split(';');
                system.debug(' revenueTypeList SM >> ' + revenueTypeList);

                revenueTypes = new set<string>() ;
                for (string str : revenueTypeList) {
                    revenueTypes.add(str);
                }
                system.debug ('=== revenueTypes : ' + revenueTypes);

                weighted = weightedREC.weighted;
            
                condition = ' year__c = \'' + year + '\' and quarter__c = \'' + quarter  + '\'' ;
                condition = condition + ' AND type__c in :revenueTypes ';  // = \'' + revenueTypes + '\'' ;

                if ( segment.left(3) != 'ALL' ) {
                    condition = condition + ' AND segment__r.name =\'' + segment + '\'';
                }
                condition = condition + ' AND group_segment__c =\'' + groupSegment + '\'';
                condition = condition + ' AND role_level__c in ' + roleLevelSMGH ;

                soqlString = 'select id, name, isused__c, weighted__c from Sales_Incentive__c where ' + condition;
                system.debug ('=== soqlString SMGH : ' + soqlString);

                List<Sales_Incentive__c> sinTEMPList = Database.query (soqlString);
                if (sinTEMPList.size() > 0) {
                    for (Sales_Incentive__c sinREC : sinTEMPList) {
                        system.debug ('=== sinREC : ' + sinREC);

                        sinREC.weighted__c = weightedREC.weighted;
                        sinREC.kpiType__c = weightedREC.kpiType;
                        sinREC.isUsed__c = true;
                        sinREC.type2__c = weightedREC.kpiName;
                        sinList.add (sinREC);
                    }

                    system.debug ('=== sinTEMPList : ' + sinTEMPList);
                    update sinTEMPList;

                    sinWorkspaceREC.Calculation_Date__c = system.now();
                    update sinWorkspaceREC;
                }
            }
        }


            //system.debug ('===== sinList : ' + sinList);  ///TODO : find, why wrrror duplicate
            //update sinList;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putWeightedData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + sinList + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

    }
    





    /**
     * version      : 1.0
     * function     : calculate all kpis
     * start date   : ..
     * end date     : Q3 2021
     */
    public void putTotalAchievementData_V1() {   
        /*
        system.debug('========== in SalesIncentiveWorkspaceController.putTotalAchievementData method ========== ');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;
        
        
        //SalesIncentiveController sinControllerREC = new SalesIncentiveController(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        //sinControllerREC.putTotalAchievementData();


        List<SInc_Tiering_Performance_Score_Settings__c> tearingIncList = [
        SELECT  year__c, employee_category__c, greater_than_equal__c, less_than__c, score__c
        FROM SInc_Tiering_Performance_Score_Settings__c
        WHERE year__c = :year
            AND quarter__c = :quarter
        ];
		

        List <SInc_Total_Achievement_Setting__c> totalAchSettingList = [SELECT  
            segment__c, segment__r.name, role_levels__c, sales_incentive_types__c
        FROM SInc_Total_Achievement_Setting__c
        WHERE year__c = :year and quarter__c = :quarter]; 

        string segmentWhereCond;
        string roleLevelWhereCond;
        string typeWhereCond;

        string[] roleLevels;
        string segment;
        string[] incentiveTypes;
        

        ID salesPerson;
        Double totalAchievement;
        Map <ID, double> totalAchievementSalesMap = new Map <ID, double> ();
        

        for (SInc_Total_Achievement_Setting__c totalAchSettingREC : totalAchSettingList) {
            segmentWhereCond = '';
            roleLevelWhereCond = '';
            typeWhereCond = '';

            segment = totalAchSettingREC.segment__c;
            roleLevels = totalAchSettingREC.Role_Levels__c.split(';');
            incentiveTypes = totalAchSettingREC.sales_incentive_types__c.split(';');

            system.debug ('=== segment : ' + segment);
            system.debug ('=== roleLevels : ' + roleLevels);
            system.debug ('=== incentiveTypes : ' + segment);

            if (totalAchSettingREC.segment__c != null && totalAchSettingREC.segment__r.name.left(3) != 'ALL') {
                segmentWhereCond = 'AND segment__c = :segment ';
            }
            if (totalAchSettingREC.role_levels__c != null ) {
                roleLevelWhereCond = 'AND role_level__c in :roleLevels ';
            }
            if (totalAchSettingREC.sales_incentive_types__c != null ) {
                typeWhereCond = 'AND type__c in :incentiveTypes';
            }

            

            string soqlString = 'SELECT sales_person__c, sum(Ach_Weighted__c) totalAchievement ' 
                + ' FROM Sales_Incentive__c '
                + ' WHERE year__c = :year and quarter__c = :quarter '
                + segmentWhereCond + ' '
                + roleLevelWhereCond + ' '
                + typeWhereCond  + ' '
                + ' GROUP BY sales_person__c ';

            
            system.debug ('=== soqlString : ' + soqlString);
            
            List<AggregateResult> tmpARList = Database.query(soqlString);

            
            
            for (AggregateResult ARREC : tmpARList) {
                salesPerson = (ID) ARREC.get('sales_person__c');
                totalAchievement = (Double) ARREC.get('totalAchievement');
                
                totalAchievementSalesMap.put (salesPerson, totalAchievement);

            }

        }
        system.debug(' === salesPerson : ' + salesPerson);

        system.debug ('=== totalAchievementSalesMap : ' + totalAchievementSalesMap);


        /*
        List<Sales_Incentive__c> sinCalculationList = [SELECT id,
            sales_person__c, Total_Ach__c
        FROM Sales_Incentive__c
        WHERE type__c = 'Calculation'
            AND  year__c = :year 
            AND quarter__c = :quarter 
        ];*/

        /*
        List<AggregateResult> sinCalculationARList = [SELECT
            sales_person__c, sales_person__r.employee_id__c employeeID, 
            Group_Segment__c, Segment__c,
            role_level__c,
            period_date__c,
            sales_person__r.Employee_Category__c employeCategory
        FROM Sales_Incentive__c
        WHERE year__c = :year 
            AND quarter__c = :quarter
        GROUP BY  
            sales_person__c, sales_person__r.employee_id__c,
            Group_Segment__c, Segment__c,
            role_level__c,
            period_date__c,
            sales_person__r.Employee_Category__c
        ];

        system.debug ('=== sinCalculationARList : ' + sinCalculationARList);

        List<Sales_Incentive__c> sinCalculationList = new List<Sales_Incentive__c>(); 
        for (AggregateResult sinCalculationARREC : sinCalculationARList) {

            Sales_Incentive__c sinCalculationREC =  new Sales_Incentive__c();
            sinCalculationREC.type__c = 'Calculation';
            sinCalculationREC.Sales_Person__c = (ID) sinCalculationARREC.get ('sales_person__c');
            sinCalculationREC.Group_Segment__c = (string) sinCalculationARREC.get ('Group_Segment__c');
            sinCalculationREC.Segment__c = (ID) sinCalculationARREC.get ('Segment__c');
            sinCalculationREC.role_level__c = (string) sinCalculationARREC.get ('role_level__c');
            sinCalculationREC.period_date__c = (Date) sinCalculationARREC.get ('period_date__c');
            sinCalculationREC.Year__c = year;
            sinCalculationREC.Quarter__c = quarter;

            sinCalculationREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

            string employeeID = (string) sinCalculationARREC.get ('employeeID');

            sinCalculationREC.name = 'SIN_' + year.right(2) + quarter + '_' + sinCalculationREC.role_level__c  + '_' + employeeID  + '_Calculation';
            sinCalculationREC.unique_id__c = sinCalculationREC.name;

    
            totalAchievement = totalAchievementSalesMap.get (sinCalculationREC.Sales_Person__c);
            sinCalculationREC.Total_Ach__c = totalAchievement;

            string employeeCategory = (string) sinCalculationARREC.get ('employeCategory');
            if (employeeCategory == null) {
                employeeCategory = 'New Employee'; //--todo change to 'New Employee'
            }

            for (SInc_Tiering_Performance_Score_Settings__c tearingREC : tearingIncList) {
                if ( sinCalculationREC.Total_Ach__c >= tearingREC.greater_than_equal__c && 
                sinCalculationREC.Total_Ach__c < tearingREC.less_than__c &&
                tearingREC.employee_category__c == employeeCategory

                    ) {
                    
                    //-- put Total Incentive related to tiering
                    sinCalculationREC.Total_Inc__c = tearingREC.score__c;
                }
            }

            sinCalculationList.add (sinCalculationREC);
            
        }
        system.debug ('=== sinCalculationList : ' + sinCalculationList);

        try {
            upsert sinCalculationList unique_id__c;

            sinWorkspaceREC.Calculation_Date__c = system.now();
            update sinWorkspaceREC;

        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putTotalAchievementData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

        */
    
    }





    /**
     * version      : 2.0
     * function     : calculate main kpi and other kpi
     * start date   : Q2 2022
     * end date     : ...
     */
    public void putTotalAchievementData() {   
        system.debug('========== in SalesIncentiveWorkspaceController.putTotalAchievementData method ========== ');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;

        setSalesPersonAttributes ('AM');
      //  setSalesPersonAttributes ('SM');
      //  setSalesPersonAttributes ('GH');
        
        
        //SalesIncentiveController sinControllerREC = new SalesIncentiveController(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        //sinControllerREC.putTotalAchievementData();

        //-- GET TEARING setting list for ALL LE and ALL ME
        List<SInc_Tiering_Performance_Score_Settings__c> tearingIncALLSegmentList = [
            SELECT  year__c, employee_category__c, 
                segment__c, segment__r.name,
                greater_than_equal__c, less_than__c, 
                MainKPIScore__c, OtherKPIScore__c
            FROM SInc_Tiering_Performance_Score_Settings__c
            WHERE year__c = :year
                AND quarter__c = :quarter
                AND segment__r.name like 'ALL%'
        ];

        //-- GET TEARING setting list for NOT ALL LE and ALL ME
        List<SInc_Tiering_Performance_Score_Settings__c> tearingIncList = [
            SELECT  year__c, employee_category__c, 
                segment__c, segment__r.name,
                greater_than_equal__c, less_than__c, 
                MainKPIScore__c, OtherKPIScore__c
            FROM SInc_Tiering_Performance_Score_Settings__c
            WHERE year__c = :year
                AND quarter__c = :quarter
                AND (NOT segment__r.name like 'ALL%')
        ];

        //--ALL segment
        list<SInc_Total_Achievement_Setting__c> sincAllTotalAch = [
            SELECT Id, 
                Role_Levels__c, 
                Segment__c,
                Segment__r.group_segment_name__c, 
                Quarter__c, 
                Year__c,
                MinimumAchievementforMainKPI__c, 
                MinimumAchievementforOtherKPI__c 
            FROM SInc_Total_Achievement_Setting__c 
            WHERE year__c = :year
            AND quarter__c = :quarter
            AND segment__r.name like 'ALL%' 
        ]; 

        //--SPECIFIC Segment
        List<SInc_Total_Achievement_Setting__c> sincSpecificTotalAch = [ 
            SELECT Id, 
                Role_Levels__c, 
                Segment__c, 
                Quarter__c, 
                Year__c,
                MinimumAchievementforMainKPI__c, 
                MinimumAchievementforOtherKPI__c 
            FROM SInc_Total_Achievement_Setting__c 
            WHERE year__c = :year
            AND quarter__c = :quarter
            AND ( NOT segment__r.name like '%ALL%' ) 
        ];
       

        string segmentWhereCond;
        string roleLevelWhereCond;
        string typeWhereCond;

        string[] roleLevels;
        string segment;
        string[] incentiveTypes;
        

        ID salesPerson;
        String kpiType;
        Double sumOfAchxWeighted;
        Map <ID, double> totalAchievementSalesMap = new Map <ID, double> ();
        Map <ID, double> mainAchievementSalesMap = new Map <ID, double> ();
        Map <ID, double> otherAchievementSalesMap = new Map <ID, double> ();



        //List<AggregateResult> tmpARList = Database.query(soqlString);
        List<AggregateResult> tmpARList = [ SELECT 
                Sales_Person__c, Sales_Person__r.name,
                KPIType__c,
                sum(Ach_Weighted__c) sumOfAchxWeighted
            FROM Sales_Incentive__c
            WHERE IsUsed__c = TRUE
                AND KPIType__c <> null
                AND year__c = :year 
                AND quarter__c = :quarter
            GROUP BY
                Sales_Person__c, Sales_Person__r.name,
                KPIType__c
        ];
     
        //-- put sum of Main & Other KPI %
        for (AggregateResult arREC : tmpARList) {
            salesPerson = (ID) ARREC.get('sales_person__c');
            kpiType = (string) arREC.get('KPIType__c');
            sumOfAchxWeighted = (Double) arREC.get('sumOfAchxWeighted');
            
            if (kpiType == 'Main') {
                mainAchievementSalesMap.put (salesPerson, sumOfAchxWeighted);
            }
            else if (kpiType == 'Other') {
                otherAchievementSalesMap.put (salesPerson, sumOfAchxWeighted);
            }
            

        }


        //-- CREATE CALCULATION RECORDS
        List<AggregateResult> sinCalculationARList = [SELECT 
            sales_person__c, 
            sales_person__r.isActive salesPersonIsActive, 
            sales_person__r.employee_id__c employeeID, 
            Group_Segment__c, 
            Segment__c, 
            Segment__r.name segmentName, 
            role_level__c, 
            sales_person__r.Employee_Category__c employeCategory 
        FROM 
            Sales_Incentive__c 
        WHERE 
            year__c = :year 
            AND quarter__c = :quarter
            AND Sales_Person__c <> null 
            AND sales_person__r.isActive = true
        GROUP BY 
            sales_person__c, 
            sales_person__r.employee_id__c, 
            Group_Segment__c, 
            Segment__c, 
            Segment__r.name, 
            role_level__c, 
            sales_person__r.Employee_Category__c,
            sales_person__r.isActive
      
        ];

        system.debug ('=== sinCalculationARList : ' + sinCalculationARList);

        List<Sales_Incentive__c> sinCalculationList = new List<Sales_Incentive__c>(); 

        for (AggregateResult sinCalculationARREC : sinCalculationARList) {
            Sales_Incentive__c sinCalculationREC =  new Sales_Incentive__c();
            sinCalculationREC.type__c = 'Calculation';
            sinCalculationREC.Sales_Person__c = (ID) sinCalculationARREC.get ('sales_person__c');
            
            sinCalculationREC.Group_Segment__c = (string) sinCalculationARREC.get ('Group_Segment__c');
            sinCalculationREC.Segment__c = (ID) sinCalculationARREC.get ('Segment__c');
            sinCalculationREC.role_level__c = (string) sinCalculationARREC.get ('role_level__c');
            sinCalculationREC.period_date__c = periodDate; //(Date) sinCalculationARREC.get ('period_date__c');
            sinCalculationREC.Year__c = year;
            sinCalculationREC.Quarter__c = quarter;
            sinCalculationREC.ownerId =  sinCalculationREC.Sales_Person__c;
            sinCalculationREC.period_date__c = periodDate;
                
           

            sinCalculationREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

            string employeeID = (string) sinCalculationARREC.get ('employeeID');

            sinCalculationREC.name = 'SIN_' + year.right(2) + quarter + '_' + sinCalculationREC.role_level__c  + '_' + employeeID  + '_Calculation';
            sinCalculationREC.unique_id__c = sinCalculationREC.name;

    
            double mainAchievement = mainAchievementSalesMap.get (sinCalculationREC.Sales_Person__c);
            if ( mainAchievement == null ) { 
                mainAchievement = 0;
            }
            else{
                sinCalculationREC.Main_Ach__c = mainAchievement;
            }

            double otherAchievement = otherAchievementSalesMap.get (sinCalculationREC.Sales_Person__c);
            if ( otherAchievement == null ) { 
                otherAchievement = 0; 
            }
            else{
                sinCalculationREC.Other_Ach__c = otherAchievement;
            }
            

            sinCalculationREC.Total_Ach__c = mainAchievement + otherAchievement;


            
            boolean mainKPIisQualify = FALSE;
            boolean otherKPIisQualify = FALSE;
            SInc_Total_Achievement_Setting__c sinTotalAchievment =  new SInc_Total_Achievement_Setting__c();
            
            
            if(sincSpecificTotalAch.size() > 0 || sincAllTotalAch.size() > 0){
             
                
                system.debug (' == sinCalculationREC.Sales_Person__c : ' + sinCalculationREC.Sales_Person__c);
                system.debug(' == sincSpecificTotalAch : ' + sincSpecificTotalAch);
                system.debug(' == sincAllTotalAch : ' + sincAllTotalAch);
                
                double MinimumAchievementforMainKPI = 0;
                double MinimumAchievementforOtherKPI = 0;


                //LOOP SPECIFIC SEGMENT
                for (SInc_Total_Achievement_Setting__c sincSpecificTotalAchRec: sincSpecificTotalAch) {
                    system.debug(' == sincSpecificTotalAchRec.segment__c : ' + sincSpecificTotalAchRec.segment__c + ' & == sinCalculationREC.segment__c : ' + sinCalculationREC.segment__c);
    
                    system.debug(' == sincSpecificTotalAchRec.Role_Levels__c : ' + sincSpecificTotalAchRec.Role_Levels__c + '& == sinCalculationREC.role_level__c : ' + sinCalculationREC.role_level__c);

                    //   klo ketemu / cocok then
                    if (sincSpecificTotalAchRec.segment__c == sinCalculationREC.segment__c && sincSpecificTotalAchRec.Role_Levels__c.contains(sinCalculationREC.role_level__c ) ) {
                
                        MinimumAchievementforMainKPI = sincSpecificTotalAchRec.MinimumAchievementforMainKPI__c;
                        MinimumAchievementforOtherKPI = sincSpecificTotalAchRec.MinimumAchievementforOtherKPI__c;

                        system.debug(' == MinimumAchievementforMainKPI : ' + MinimumAchievementforMainKPI + ' + == MinimumAchievementforOtherKPI : ' + MinimumAchievementforOtherKPI);
                
                    } 
                }   

                for (SInc_Total_Achievement_Setting__c sincAllTotalAchRec: sincAllTotalAch) {
                    
                    system.debug(' sincAllTotalAchRec.segment__c : ' + sincAllTotalAchRec.Segment__r.group_segment_name__c + ' == '+sinCalculationREC.Group_Segment__c);
                    if (sincAllTotalAchRec.Segment__r.group_segment_name__c == sinCalculationREC.Group_Segment__c && sincAllTotalAchRec.Role_Levels__c.contains(sinCalculationREC.role_level__c) ) {
        
                        MinimumAchievementforMainKPI = sincAllTotalAchRec.MinimumAchievementforMainKPI__c;
                        MinimumAchievementforOtherKPI = sincAllTotalAchRec.MinimumAchievementforOtherKPI__c;
                        
                        system.debug(' == MinimumAchievementforMainKPI : ' + MinimumAchievementforMainKPI + ' + == MinimumAchievementforOtherKPI : ' + MinimumAchievementforOtherKPI);
                    }
                }

                if ( mainAchievement >= MinimumAchievementforMainKPI ) { 
                    system.debug(' == mainAchievement : ' + mainAchievement 
                            + ' >= MinimumAchievementforMainKPI : ' + MinimumAchievementforMainKPI);
                    System.debug(' == in MinimumAchievementforMainKPI :');
                        
                    mainKPIisQualify = TRUE;

                }

                if ( otherAchievement >= MinimumAchievementforOtherKPI ) {
                    system.debug(' == otherAchievement : ' + otherAchievement + ' >= MinimumAchievementforOtherKPI : ' 
                        + MinimumAchievementforOtherKPI);
                   
                    System.debug(' == in MinimumAchievementforOtherKPI :');
                    otherKPIisQualify = TRUE;
                }

        }
           
            //--- TEIRING PROCESS

            string employeeCategory = (string) sinCalculationARREC.get ('employeCategory');
            if (employeeCategory == null) {
                employeeCategory = 'New Employee'; //--todo change to 'New Employee'
            }

            string segmentName = (string) sinCalculationARREC.get ('segmentName');
            string groupSegmentName = sinCalculationREC.Group_Segment__c;

            if (mainKPIisQualify == TRUE) {

                //-- cek in ALL Segment 
                for (SInc_Tiering_Performance_Score_Settings__c tearingREC : tearingIncAllSegmentList) {

                    string tearingGroupSegmentName = tearingREC.segment__r.name.replace('ALL ', '') ;

                    if ( sinCalculationREC.main_Ach__c >= tearingREC.greater_than_equal__c && 
                        sinCalculationREC.main_Ach__c < tearingREC.less_than__c &&
                        tearingREC.employee_category__c == employeeCategory &&
                        tearingGroupSegmentName == groupSegmentName
                        ) {
                        
                        //-- put MAIN Incentive score related to tiering
                        sinCalculationREC.MainIncPayout__c = tearingREC.MainKPIScore__c;

                        system.debug(' otherKPIisQualify  : ' + otherKPIisQualify);
                        //-- put OTHER Incentive score related to tiering
                        if ( otherKPIisQualify == true ) {
                            sinCalculationREC.OtherIncPayout__c = tearingREC.OtherKPIScore__c;
                            
                        } 
                        else {
                            sinCalculationREC.OtherIncPayout__c = 0;
                        }

                        sinCalculationREC.Total_Inc__c = sinCalculationREC.MainIncPayout__c + sinCalculationREC.OtherIncPayout__c;
                        
                        
                    }
                }

                //-- cek in specific Segment 
                for (SInc_Tiering_Performance_Score_Settings__c tearingREC : tearingIncList) {

                    string tearingSegmentName = tearingREC.segment__r.name ;

                    if ( sinCalculationREC.main_Ach__c >= tearingREC.greater_than_equal__c && 
                        sinCalculationREC.main_Ach__c < tearingREC.less_than__c &&
                        tearingREC.employee_category__c == employeeCategory &&
                        tearingSegmentName == segmentName
                        ) {
                        
                        //-- put MAIN Incentive score related to tiering
                        sinCalculationREC.MainIncPayout__c = tearingREC.MainKPIScore__c;                    
                        system.debug(' otherKPIisQualify  : ' + otherKPIisQualify);
                        //-- put OTHER Incentive score related to tiering
                        if ( otherKPIisQualify == true ) {
                            sinCalculationREC.OtherIncPayout__c = tearingREC.OtherKPIScore__c;
                            
                        } 
                        else {
                            sinCalculationREC.OtherIncPayout__c = 0;
                        }

                        sinCalculationREC.Total_Inc__c = sinCalculationREC.MainIncPayout__c + sinCalculationREC.OtherIncPayout__c;
                        
                        
                    }
                }

            }
            else {
                sinCalculationREC.Total_Inc__c = 0;

            }

            

            sinCalculationList.add (sinCalculationREC);
            
        }


        
        system.debug ('=== sinCalculationList : ' + sinCalculationList);

        try {
            upsert sinCalculationList unique_id__c;

            sinWorkspaceREC.Calculation_Date__c = system.now();
            update sinWorkspaceREC;

        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putTotalAchievementData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

        //-- JIKA metode kalkulasi SM dan GH adalah AVERAGE  Total Achievement dari AM nya.
        /*
        if ( UseAVGforTotalAchofManager ) {

            //-- calculation for SM
            sinCalculationARList = [SELECT
                Sales_Manager__c,
                Sales_Manager__r.employee_id__c employeeID ,
                Group_Segment__c, Segment__c, Segment__r.name,
                period_date__c,
                avg (Total_Ach__c) TotalAchAVG,
                avg (Main_Ach__c) MainAchAVG,
                avg (Other_Ach__c) OtherAchAVG
                
            FROM Sales_Incentive__c
            WHERE year__c = :year 
                AND quarter__c = :quarter
                AND Sales_Person__c <> null
                AND Sales_Manager__c <> null
                AND Role_Level__c = 'AM'
            GROUP BY  
                Sales_Manager__c,
                Sales_Manager__r.employee_id__c,
                Group_Segment__c, Segment__c, Segment__r.name,
                period_date__c
            ];

            system.debug ('=== sinCalculationARList : ' + sinCalculationARList);

            sinCalculationList = new List<Sales_Incentive__c>(); 
            for (AggregateResult sinCalculationAMARREC : sinCalculationARList) {

                sinCalculationREC =  new Sales_Incentive__c();
                sinCalculationREC.type__c = 'Calculation';
                sinCalculationREC.Sales_Person__c = (ID) sinCalculationAMARREC.get ('Sales_Manager__c');
                sinCalculationREC.Group_Segment__c = (string) sinCalculationAMARREC.get ('Group_Segment__c');
                sinCalculationREC.Segment__c = (ID) sinCalculationAMARREC.get ('Segment__c');
                sinCalculationREC.role_level__c = 'SM'; //(string) sinCalculationAMARREC.get ('role_level__c');
                sinCalculationREC.period_date__c = (Date) sinCalculationAMARREC.get ('period_date__c');
                sinCalculationREC.Year__c = year;
                sinCalculationREC.Quarter__c = quarter;

                sinCalculationREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                employeeID = (string) sinCalculationAMARREC.get ('employeeID');

                sinCalculationREC.name = 'SIN_' + year.right(2) + quarter + '_' + sinCalculationREC.role_level__c  + '_' + employeeID  + '_Calculation';
                sinCalculationREC.unique_id__c = sinCalculationREC.name;

                mainAchievement = (double) sinCalculationAMARREC.get ('MainAchAVG');
                if ( mainAchievement == null ) { mainAchievement = 0;}
                sinCalculationREC.Main_Ach__c = mainAchievement;

                otherAchievement = (double) sinCalculationAMARREC.get ('OtherAchAVG');
                if ( otherAchievement == null ) { otherAchievement = 0; }
                sinCalculationREC.Other_Ach__c = otherAchievement;

                sinCalculationREC.Total_Ach__c = mainAchievement + otherAchievement;


                Sales_Incentive__c tmpSalesIncRec = calcPayoutData (
                    sinCalculationREC,
                    sinCalculationARREC,
                    sincSpecificTotalAch, 
                    sincAllTotalAch
                );
                
                sinCalculationREC.MainIncPayout__c = tmpSalesIncRec.MainIncPayout__c;
                sinCalculationREC.OtherIncPayout__c = tmpSalesIncRec.OtherIncPayout__c;

                

                sinCalculationList.add (sinCalculationREC);
                
            }
            system.debug ('=== sinCalculationList : ' + sinCalculationList);
            
            try {
                upsert sinCalculationList unique_id__c;
    
                sinWorkspaceREC.Calculation_Date__c = system.now();
                update sinWorkspaceREC;
    
            }
            catch (Exception e) {
                string notes = 'Error on SalesIncentiveWorkspaceController.putTotalAchievementData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
                
                errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
                system.debug ('===== errorMsg : ' + errorMsg);
            }






            //-- calulation for SM
            sinCalculationARList = [SELECT
                Group_Head__c,
                Group_Head__r.employee_id__c employeeID ,
                Group_Segment__c, Segment__c, Segment__r.name,
                period_date__c,
                avg (Total_Ach__c) TotalAchAVG,
                avg (Main_Ach__c) MainAchAVG,
                avg (Other_Ach__c) OtherAchAVG
                
            FROM Sales_Incentive__c
            WHERE year__c = :year 
                AND quarter__c = :quarter
                AND Sales_Person__c <> null
                AND Group_Head__c <> null
                AND Role_Level__c = 'AM'
            GROUP BY  
                Group_Head__c,
                Group_Head__r.employee_id__c,
                Group_Segment__c, Segment__c, Segment__r.name,
                period_date__c
            ];

            system.debug ('=== sinCalculationARList : ' + sinCalculationARList);

            sinCalculationList = new List<Sales_Incentive__c>(); 
            for (AggregateResult sinCalculationAMARREC : sinCalculationARList) {

                sinCalculationREC =  new Sales_Incentive__c();
                sinCalculationREC.type__c = 'Calculation';
                sinCalculationREC.Sales_Person__c = (ID) sinCalculationAMARREC.get ('Sales_Manager__c');
                sinCalculationREC.Group_Segment__c = (string) sinCalculationAMARREC.get ('Group_Segment__c');
                sinCalculationREC.Segment__c = (ID) sinCalculationAMARREC.get ('Segment__c');
                sinCalculationREC.role_level__c = 'GH'; //(string) sinCalculationAMARREC.get ('role_level__c');
                sinCalculationREC.period_date__c = (Date) sinCalculationAMARREC.get ('period_date__c');
                sinCalculationREC.Year__c = year;
                sinCalculationREC.Quarter__c = quarter;

                sinCalculationREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

                employeeID = (string) sinCalculationAMARREC.get ('employeeID');

                sinCalculationREC.name = 'SIN_' + year.right(2) + quarter + '_' + sinCalculationREC.role_level__c  + '_' + employeeID  + '_Calculation';
                sinCalculationREC.unique_id__c = sinCalculationREC.name;

                mainAchievement = (double) sinCalculationAMARREC.get ('MainAchAVG');
                if ( mainAchievement == null ) { mainAchievement = 0;}
                sinCalculationREC.Main_Ach__c = mainAchievement;

                otherAchievement = (double) sinCalculationAMARREC.get ('OtherAchAVG');
                if ( otherAchievement == null ) { otherAchievement = 0; }
                sinCalculationREC.Other_Ach__c = otherAchievement;

                sinCalculationREC.Total_Ach__c = mainAchievement + otherAchievement;


                Sales_Incentive__c tmpSalesIncRec = calcPayoutData (
                    sinCalculationREC,
                    sinCalculationARREC,
                    sincSpecificTotalAch, 
                    sincAllTotalAch
                );
                
                sinCalculationREC.MainIncPayout__c = tmpSalesIncRec.MainIncPayout__c;
                sinCalculationREC.OtherIncPayout__c = tmpSalesIncRec.OtherIncPayout__c;

                

                sinCalculationList.add (sinCalculationREC);
                
            }
            system.debug ('=== sinCalculationList : ' + sinCalculationList);
            
            try {
                upsert sinCalculationList unique_id__c;
    
                sinWorkspaceREC.Calculation_Date__c = system.now();
                update sinWorkspaceREC;
    
            }
            catch (Exception e) {
                string notes = 'Error on SalesIncentiveWorkspaceController.putTotalAchievementData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
                
                errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
                system.debug ('===== errorMsg : ' + errorMsg);
            }

        }
        */


    

        /*        
        //-- GET Main KPI and other KPI
        List<SInc_Main_KPI_Item__c> mainKPIItemList = [SELECT id,
            //TotalAchievementSetting__r.segment__r.Group_Segment_Name__c,
            //TotalAchievementSetting__r.segment__r.name, 
            //TotalAchievementSetting__r.Role_Levels__c,
            KPIName__c,
            Weighted__c 
        FROM SInc_Main_KPI_Item__c
        WHERE TotalAchievementSetting__r.year__c = :year
            AND TotalAchievementSetting__r.quarter__c = :quarter
        ];

        List<SInc_Other_KPI_Item__c> otherKPIItemList = [SELECT id,
            //TotalAchievementSetting__r.segment__r.Group_Segment_Name__c,
            //TotalAchievementSetting__r.segment__r.name, 
            //TotalAchievementSetting__r.Role_Levels__c,
            KPIName__c,
            Weighted__c 
        FROM SInc_Other_KPI_Item__c
        WHERE TotalAchievementSetting__r.year__c = :year
            AND TotalAchievementSetting__r.quarter__c = :quarter
        ];
        
        List <KPI_ITEM_WRAP> kpiItemList = New List <KPI_ITEM_WRAP>();  //-- initiate list of wieghted

        //-- put MAIN kpi wieghted to the list
        for (SInc_Main_KPI_Item__c kpiItemRec: mainKPIItemList) {
            KPI_ITEM_WRAP kpiItemWrapRec = New KPI_ITEM_WRAP();
            kpiItemWrapRec.kpiName = kpiItemRec.KPIName__c;
            kpiItemWrapRec.kpiType = 'MAIN';
            kpiItemWrapRec.groupSegment = kpiItemRec.TotalAchievementSetting__r.segment__r.Group_Segment_Name__c;
            kpiItemWrapRec.segment = kpiItemRec.TotalAchievementSetting__r.segment__r.name;
            kpiItemWrapRec.roleLevels = kpiItemRec.TotalAchievementSetting__r.Role_Levels__c;            
            kpiItemWrapRec.weighted = kpiItemRec.Weighted__c;
            kpiItemList.add (kpiItemWrapRec);
        }

        //-- put OTHER kpi wieghted to the list
        for (SInc_Other_KPI_Item__c kpiItemRec: otherKPIItemList) {
            KPI_ITEM_WRAP kpiItemWrapRec = New KPI_ITEM_WRAP();
            kpiItemWrapRec.kpiName = kpiItemRec.KPIName__c;
            kpiItemWrapRec.kpiType = 'OTHER';
            kpiItemWrapRec.groupSegment = kpiItemRec.TotalAchievementSetting__r.segment__r.Group_Segment_Name__c;
            kpiItemWrapRec.segment = kpiItemRec.TotalAchievementSetting__r.segment__r.name;
            kpiItemWrapRec.roleLevels= kpiItemRec.TotalAchievementSetting__r.Role_Levels__c;            
            kpiItemWrapRec.weighted = kpiItemRec.Weighted__c;
            kpiItemList.add (kpiItemWrapRec);
        }       

        system.debug('=== kpiItemList : ' + kpiItemList);

        */




        /*
        

        for (SInc_Total_Achievement_Setting__c totalAchSettingREC : totalAchSettingList) {
            segmentWhereCond = '';
            roleLevelWhereCond = '';
            typeWhereCond = '';

            segment = totalAchSettingREC.segment__c;
            roleLevels = totalAchSettingREC.Role_Levels__c.split(';');

            //-- GET Main KPI and other KPI
            List<SInc_Main_KPI_Item__c> mainKPIItemList = [SELECT id,
                TotalAchievementSetting__r.segment__r.Group_Segment_Name__c,
                TotalAchievementSetting__r.segment__r.name, 
                TotalAchievementSetting__r.Role_Levels__c,
                KPIName__c,
                Weighted__c 
            FROM SInc_Main_KPI_Item__c
            WHERE TotalAchievementSetting__r.id = :totalAchSettingREC.id
            ];
            for (SInc_Main_KPI_Item__c mainKPIItemREC :mainKPIItemList){
                incentiveTypes.add( mainKPIItemREC.KPIName__c );
            }
            //incentiveTypes = totalAchSettingREC.sales_incentive_types__c.split(';');

            system.debug ('=== segment : ' + segment);
            system.debug ('=== roleLevels : ' + roleLevels);
            system.debug ('=== incentiveTypes : ' + segment);

            if (totalAchSettingREC.segment__c != null && totalAchSettingREC.segment__r.name.left(3) != 'ALL') {
                segmentWhereCond = 'AND segment__c = :segment ';
            }
            if (totalAchSettingREC.role_levels__c != null ) {
                roleLevelWhereCond = 'AND role_level__c in :roleLevels ';
            }
            if (totalAchSettingREC.sales_incentive_types__c != null ) {
                typeWhereCond = 'AND type__c in :incentiveTypes';
            }

            

            string soqlString = 'SELECT sales_person__c, sum(Ach_Weighted__c) totalAchievement ' 
                + ' FROM Sales_Incentive__c '
                + ' WHERE year__c = :year and quarter__c = :quarter '
                + segmentWhereCond + ' '
                + roleLevelWhereCond + ' '
                + typeWhereCond  + ' '
                + ' GROUP BY sales_person__c ';

            
            system.debug ('=== soqlString : ' + soqlString);
            
            List<AggregateResult> tmpARList = Database.query(soqlString);

            
            
            for (AggregateResult ARREC : tmpARList) {
                salesPerson = (ID) ARREC.get('sales_person__c');
                totalAchievement = (Double) ARREC.get('totalAchievement');
                
                totalAchievementSalesMap.put (salesPerson, totalAchievement);

            }


        }
        */

        system.debug ('=== totalAchievementSalesMap : ' + totalAchievementSalesMap);


        /*
        List<Sales_Incentive__c> sinCalculationList = [SELECT id,
            sales_person__c, Total_Ach__c
        FROM Sales_Incentive__c
        WHERE type__c = 'Calculation'
            AND  year__c = :year 
            AND quarter__c = :quarter 
        ];*/

        /******************** 
        List<AggregateResult> sinCalculationARList = [SELECT
            sales_person__c, sales_person__r.employee_id__c employeeID, 
            Group_Segment__c, Segment__c,
            role_level__c,
            period_date__c,
            sales_person__r.Employee_Category__c employeCategory
        FROM Sales_Incentive__c
        WHERE year__c = :year 
            AND quarter__c = :quarter
        GROUP BY  
            sales_person__c, sales_person__r.employee_id__c,
            Group_Segment__c, Segment__c,
            role_level__c,
            period_date__c,
            sales_person__r.Employee_Category__c
        ];

        system.debug ('=== sinCalculationARList : ' + sinCalculationARList);

        List<Sales_Incentive__c> sinCalculationList = new List<Sales_Incentive__c>(); 
        for (AggregateResult sinCalculationARREC : sinCalculationARList) {

            Sales_Incentive__c sinCalculationREC =  new Sales_Incentive__c();
            sinCalculationREC.type__c = 'Calculation';
            sinCalculationREC.Sales_Person__c = (ID) sinCalculationARREC.get ('sales_person__c');
            sinCalculationREC.Group_Segment__c = (string) sinCalculationARREC.get ('Group_Segment__c');
            sinCalculationREC.Segment__c = (ID) sinCalculationARREC.get ('Segment__c');
            sinCalculationREC.role_level__c = (string) sinCalculationARREC.get ('role_level__c');
            sinCalculationREC.period_date__c = (Date) sinCalculationARREC.get ('period_date__c');
            sinCalculationREC.Year__c = year;
            sinCalculationREC.Quarter__c = quarter;

            sinCalculationREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;

            string employeeID = (string) sinCalculationARREC.get ('employeeID');

            sinCalculationREC.name = 'SIN_' + year.right(2) + quarter + '_' + sinCalculationREC.role_level__c  + '_' + employeeID  + '_Calculation';
            sinCalculationREC.unique_id__c = sinCalculationREC.name;

    
            totalAchievement = totalAchievementSalesMap.get (sinCalculationREC.Sales_Person__c);
            sinCalculationREC.Total_Ach__c = totalAchievement;

            string employeeCategory = (string) sinCalculationARREC.get ('employeCategory');
            if (employeeCategory == null) {
                employeeCategory = 'Existing Employee'; //--todo change to 'New Employee'
            }

            for (SInc_Tiering_Performance_Score_Settings__c tearingREC : tearingIncList) {
                if ( sinCalculationREC.Total_Ach__c >= tearingREC.greater_than_equal__c && 
                sinCalculationREC.Total_Ach__c < tearingREC.less_than__c &&
                tearingREC.employee_category__c == employeeCategory

                    ) {
                    
                    //-- put Total Incentive related to tiering
                    sinCalculationREC.Total_Inc__c = tearingREC.score__c;
                }
            }

            sinCalculationList.add (sinCalculationREC);
            
        }
        system.debug ('=== sinCalculationList : ' + sinCalculationList);

        try {
            upsert sinCalculationList unique_id__c;

            sinWorkspaceREC.Calculation_Date__c = system.now();
            update sinWorkspaceREC;

        }
        


        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putTotalAchievementData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

        */
    
    }

    public void setSalesPersonAttributes (string roleLevel) {
        SYSTEM.DEBUG ('========== in SalesIncentiveWorkspaceController.setSalesPersonAttributes method ========== ');
        
        string errorMsg = '';
        string relatedSFIDs = '';


        List <SInc_Total_Achievement_Setting__c> totalAchSettingList = [
            SELECT  
            Id, OwnerId, Name, CreatedById, LastModifiedById, Role_Levels__c, Segment__c, Quarter__c, Sales_Incentive_Workspace__c, Year__c, Unique_ID__c, MainKPIComposition__c, OtherKPIComposition__c, SumofMainKPICompositionItems__c, SumofOtherKPICompositionItems__c, MinimumAchievementforMainKPI__c, MinimumAchievementforOtherKPI__c
            FROM SInc_Total_Achievement_Setting__c
            WHERE year__c = :year 
                AND quarter__c = :quarter
        ];     


        //-- GET SALES Person Setting
        List<SInc_Sales_Person_Setting__c> salesPersonSettingList = [
            SELECT 
                sales_Person__c,
                Sales_Person_Rel_Employee_ID__c,
                Year__c,
                Quarter__c,
                Revenue_Type__c
            FROM SInc_Sales_Person_Setting__c
            WHERE year__c = :year 
                AND quarter__c = :quarter
                //AND Employee_ID__c = '90007487'
        ]; 

        //-- put Sales person into MAP
        Map<string, string> salesPersonKPIMap = new Map <string, string>();
        //-- 1st string for specific kpi item. ex. "Gross-Adds Fixed Links"
        //-- 2nd string for kpi in sales person setting (specific or optional) ex. "Gross-Adds Fixed Links / Gross-Adds Mobile'


        try {
            if ( roleLevel == 'AM') {
                for (SInc_Sales_Person_Setting__c salesPersonSettingREC :salesPersonSettingList) {
                    list<string> revenueTypeList = salesPersonSettingREC.Revenue_Type__c.split(';');
                    
                    for (String revenueType : revenueTypeList){
                        
                        string[] tmpRevenueTypeList = revenueType.split(' / ');
                        for (string tmpRevenueType : tmpRevenueTypeList) {
                            string salespersonKPITemp = salesPersonSettingREC.Sales_Person_Rel_Employee_ID__c + '_' + tmpRevenueType;
                            salesPersonKPIMap.put(salespersonKPITemp, revenueType);
                        }
                    }
                }
            } 
            system.debug('==== salesPersonKPIMap : ' + salesPersonKPIMap);



            //-- GET Sales Incentive
            List<Sales_Incentive__c> salesIncentiveList = [
                SELECT id, employee_id__c, type__c, isUsed__c
                FROM Sales_Incentive__c
                WHERE year__c = :year 
                    AND quarter__c = :quarter
                    AND Role_level__c = : roleLevel
            ];

            //-- set sales person KPI that used based on setting (isUSED = TRUE/FALSE)
            for (Sales_Incentive__c salesIncentiveREC : salesIncentiveList) {
                string salespersonKPITemp = salesIncentiveREC.Employee_ID__c + '_' + salesIncentiveREC.type__c;
                string revenueType = salesPersonKPIMap.get(salespersonKPITemp);
                
                system.debug('=== revenueType : ' + revenueType);

                salesIncentiveREC.isUsed__c = FALSE;
                if (revenueType != null) {
                    salesIncentiveREC.isUsed__c = TRUE;
                }
                system.debug('=== salesIncentiveREC : ' + salesIncentiveREC);
            
            }
            system.debug('=== salesIncentiveList : ' + salesIncentiveList);
            update salesIncentiveList;


        }
        

        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.setSalesPersonAttributes method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }


    /*
    public Sales_Incentive__c calcPayoutData (
        Sales_Incentive__c sinCalculationREC,
        AggregateResult sinCalculationARREC,  
        List<SInc_Total_Achievement_Setting__c> sincSpecificTotalAch, 
        List<SInc_Total_Achievement_Setting__c> sincAllTotalAch
        
        ) {

        double mainAchievement = sinCalculationREC.Main_Ach__c;
        double otherAchievement = sinCalculationREC.Other_Ach__c;

        boolean mainKPIisQualify = FALSE;
        boolean otherKPIisQualify = FALSE;
        SInc_Total_Achievement_Setting__c sinTotalAchievment =  new SInc_Total_Achievement_Setting__c();


        
        if(sincSpecificTotalAch.size() > 0 || sincAllTotalAch.size() > 0){
         
            //LOOP SPECIFIC
            system.debug (' == sinCalculationREC.Sales_Person__c : ' + sinCalculationREC.Sales_Person__c);
            system.debug(' == sincSpecificTotalAch : ' + sincSpecificTotalAch);
            system.debug(' == sincAllTotalAch : ' + sincAllTotalAch);
            
            double MinimumAchievementforMainKPI = 0 ;
            double MinimumAchievementforOtherKPI = 0;

            for (SInc_Total_Achievement_Setting__c sincSpecificTotalAchRec: sincSpecificTotalAch) {
                system.debug(' == sincSpecificTotalAchRec.segment__c : ' + sincSpecificTotalAchRec.segment__c + ' & == sinCalculationREC.segment__c : ' + sinCalculationREC.segment__c);

                system.debug(' == sincSpecificTotalAchRec.Role_Levels__c : ' + sincSpecificTotalAchRec.Role_Levels__c + '& == sinCalculationREC.role_level__c : ' + sinCalculationREC.role_level__c);

                //   klo ketemu / cocok then
                if (sincSpecificTotalAchRec.segment__c == sinCalculationREC.segment__c && sincSpecificTotalAchRec.Role_Levels__c.contains(sinCalculationREC.role_level__c ) ) {
            
                    MinimumAchievementforMainKPI = sincSpecificTotalAchRec.MinimumAchievementforMainKPI__c;
                    MinimumAchievementforOtherKPI = sincSpecificTotalAchRec.MinimumAchievementforOtherKPI__c;

                    system.debug(' == MinimumAchievementforMainKPI : ' + MinimumAchievementforMainKPI + ' + == MinimumAchievementforOtherKPI : ' + MinimumAchievementforOtherKPI);
            
                } else if(MinimumAchievementforMainKPI == 0 || MinimumAchievementforOtherKPI == 0){
                    
                    //loop all
                    for (SInc_Total_Achievement_Setting__c sincAllTotalAchRec: sincAllTotalAch) {
                        if (sincAllTotalAchRec.segment__c ==  sinCalculationREC.segment__c && sincAllTotalAchRec.Role_Levels__c.contains(sinCalculationREC.role_level__c) ) {
            
                            MinimumAchievementforMainKPI = sincAllTotalAchRec.MinimumAchievementforMainKPI__c;
                            MinimumAchievementforOtherKPI = sincAllTotalAchRec.MinimumAchievementforOtherKPI__c;
                            
                            system.debug(' == MinimumAchievementforMainKPI : ' + MinimumAchievementforMainKPI + ' + == MinimumAchievementforOtherKPI : ' + MinimumAchievementforOtherKPI);
                        }
                    }
            
                }

                system.debug(' == MinimumAchievementforMainKPI : ' + MinimumAchievementforMainKPI + ' + == MinimumAchievementforOtherKPI : ' + MinimumAchievementforOtherKPI);


                if ( mainAchievement >= MinimumAchievementforMainKPI ) { //TODO: put the 90 to the total achievement setting (use MinimumAchievementforMainKPI__c)
                    //sinTotalAchievment.MinimumAchievementforMainKPI__c = 90; //update 28/04/2022 by diky
                        System.debug(' == in MinimumAchievementforMainKPI :');
                        mainKPIisQualify = TRUE;

                    if ( otherAchievement >= MinimumAchievementforOtherKPI ) { //TODO: put the 90 to the total achievement setting (use MinimumAchievementforOtherKPI__c)
                    //   sinTotalAchievment.MinimumAchievementforOtherKPI__c =90; //update 28/04/2022 by diky
                    System.debug(' == in MinimumAchievementforOtherKPI :');
                        otherKPIisQualify = TRUE;
                    }
                }   
            }
       


            string employeeCategory = (string) sinCalculationARREC.get ('employeCategory');
            if (employeeCategory == null) {
                employeeCategory = 'New Employee'; //--todo change to 'New Employee'
            }

            string segmentName = (string) sinCalculationARREC.get ('segmentName');
            string groupSegmentName = sinCalculationREC.Group_Segment__c;

            if (mainKPIisQualify == TRUE) {

                //-- cek in ALL Segment 
                for (SInc_Tiering_Performance_Score_Settings__c tearingREC : tearingIncAllSegmentList) {

                    string tearingGroupSegmentName = tearingREC.segment__r.name.replace('ALL ', '') ;

                    if ( sinCalculationREC.main_Ach__c >= tearingREC.greater_than_equal__c && 
                        sinCalculationREC.main_Ach__c < tearingREC.less_than__c &&
                        tearingREC.employee_category__c == employeeCategory &&
                        tearingGroupSegmentName == groupSegmentName
                        ) {
                        
                        //-- put MAIN Incentive score related to tiering
                        sinCalculationREC.MainIncPayout__c = tearingREC.MainKPIScore__c;

                        //-- put OTHER Incentive score related to tiering
                        if ( otherKPIisQualify == TRUE ) {
                            sinCalculationREC.OtherIncPayout__c = tearingREC.OtherKPIScore__c;
                        } 
                        else {
                            sinCalculationREC.OtherIncPayout__c = 0;
                        }

                        sinCalculationREC.Total_Inc__c = sinCalculationREC.MainIncPayout__c + sinCalculationREC.OtherIncPayout__c;
                        
                        
                    }
                }

                //-- cek in specific Segment 
                for (SInc_Tiering_Performance_Score_Settings__c tearingREC : tearingIncList) {

                    string tearingSegmentName = tearingREC.segment__r.name ;

                    if ( sinCalculationREC.main_Ach__c >= tearingREC.greater_than_equal__c && 
                        sinCalculationREC.main_Ach__c < tearingREC.less_than__c &&
                        tearingREC.employee_category__c == employeeCategory &&
                        tearingSegmentName == segmentName
                        ) {
                        
                        //-- put MAIN Incentive score related to tiering
                        sinCalculationREC.MainIncPayout__c = tearingREC.MainKPIScore__c;

                        //-- put OTHER Incentive score related to tiering
                        if ( otherKPIisQualify == TRUE ) {
                            sinCalculationREC.OtherIncPayout__c = tearingREC.OtherKPIScore__c;
                        } 
                        else {
                            sinCalculationREC.OtherIncPayout__c = 0;
                        }

                        sinCalculationREC.Total_Inc__c = sinCalculationREC.MainIncPayout__c + sinCalculationREC.OtherIncPayout__c;
                        
                        
                    }
                }

            }
            else {
                sinCalculationREC.Total_Inc__c = 0;

            }

         
        }

        return sinCalculationREC;
    
    }
*/
    public void putCollectionRateData() {    
        system.debug('========== in SalesIncentiveWorkspaceController.putCollectionRateData method ========== ');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;

        //SalesIncentiveController sinControllerREC = new SalesIncentiveController(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        //sinControllerREC.putCollectionRateData();

        //-- set collection rate :
        List<Collection_Rate_Quarterly__c> crqList = [SELECT id, year__c, quarter__c, coll_ratio__c, sales_person__c, 
            sales_person__r.employee_id__c, sales_person__r.userrole.name 
        FROM Collection_Rate_Quarterly__c
        WHERE year__c = :year and quarter__c = :quarter
        ];

        Map <String, segment__c> segmentMap = new Map <String, segment__c>();
        List<Segment__c> segmentList =  [select id, name, Group_Segment_Name__c from segment__c];
        for (Segment__c segmentREC : segmentList) {
            segmentMap.put ( segmentREC.name.toUpperCase(), segmentREC );
        }

        
        List<Sales_incentive__c> sinList= new List<Sales_incentive__c>();

        try {
            for (Collection_Rate_Quarterly__c crqREC : crqList ) {
                Sales_Incentive__c sinREC = new Sales_Incentive__c();

                //string AMName = (string) crqREC.get('AMName');
                //string[] AMNameSplit = AMName.split(' ');
                string employeeID = crqREC.sales_person__r.employee_id__c  ;
                //string userlabel = employeeID + ' ' + AMNameSplit[0];
                string userlabel = employeeID ; //+ ' ' + AMNameSplit[0];
                

                String segmentName ;
                String segmentID=null;
                String groupSegment;

                

                string salesPersonSortTitle;
                if (crqREC.sales_person__r.userrole.name.contains('Group Head - ')) {
                    sinREC.title__c = 'Group Head';
                    sinREC.role_level__c = 'GH';
                    salesPersonSortTitle = 'GH';
                    segmentName = crqREC.sales_person__r.userrole.name.replace('Group Head - ','');

                }
                else if (crqREC.sales_person__r.userrole.name.contains('Head - ') ) {
                    sinREC.title__c = 'Sales Manager';
                    sinREC.role_level__c = 'SM';
                    salesPersonSortTitle = 'SM';
                    segmentName = crqREC.sales_person__r.userrole.name.replace('Head - ','');
                }
                else {
                    sinREC.title__c = 'Account Manager';
                    sinREC.role_level__c = 'AM';
                    salesPersonSortTitle = 'AM';
                    segmentName = crqREC.sales_person__r.userrole.name;
                }

                system.debug ('===== segmentName : ' + segmentName);

                
                sinREC.Type__c = 'Calculation';
                sinREC.name = 'SIN_' + year.right(2) + quarter + '_' + salesPersonSortTitle + '_' + userlabel  + '_' + sinREC.Type__c;
                sinREC.unique_id__c = sinREC.name;
                
                
                sinREC.Period_Date__c = periodDate;
                sinREC.As_of_Date__c = periodDate;
                sinREC.Year__c = year;
                sinREC.Quarter__c = quarter;
                
                sinREC.Sales_Person__c = (ID) crqREC.get('Sales_Person__c');

                Segment__c segmentREC = segmentMap.get(segmentName.toUpperCase());
                //system.debug ('===== segmentID : ' + segmentID + ' <- ' + segmentName.toUpperCase());
                if (segmentREC <> null) {
                    if (salesPersonSortTitle != 'GH') {
                        segmentID = segmentREC.id;
                    } else segmentID = null;
                    groupSegment = segmentREC.group_segment_name__c;
                }

                sinREC.Segment__c = segmentID;
                sinREC.Group_Segment__c = groupSegment;
                sinREC.Sales_Incentive_Workspace__c = sinWorkspaceID;  

                sinREC.coll_rate__c = (Decimal) crqREC.get('coll_ratio__c');

                sinList.add (sinREC);

            }

            system.debug ('===== sinList : ' + sinList);
            upsert sinList unique_id__c;


            sinWorkspaceREC.Calculation_Date__c = system.now();
            update sinWorkspaceREC;
            
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putCollectionRateData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    
    }

    public void putFinalIncentiveData() {    
        system.debug('========== in SalesIncentiveWorkspaceController.putFinalIncentiveData method ========== ');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;
        
        //SalesIncentiveController sinControllerREC = new SalesIncentiveController(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        //sinControllerREC.putFinalIncentiveData();


        List<SInc_Payout_Setting__c>  payoutSettingList = [
        SELECT 
            Coll_Rate_Greater_Than__c, Coll_Rate_Less_Than__c, Payout__c
        FROM SInc_Payout_Setting__c
        WHERE
            year__c = :year //'2021'
            AND quarter__c = :quarter    //'q2'
        ];

        List<sales_incentive__c>  sinList = [
        SELECT Role_Level__c, sales_person__r.name, sales_person__c, 
            sales_person__r.employee_id__c ,
            group_segment__c,
            segment__c,
            coll_rate__c,
            total_inc__c,
            final_inc__c
        FROM sales_incentive__c
        WHERE 
            year__c = :year //'2021'
            AND quarter__c = :quarter    //'q2'
            AND type__c = 'Calculation'
        ];

        double totalInc = 0;
        try {
            for (sales_incentive__c sinREC : sinList ) {

                for (SInc_Payout_Setting__c payoutSettingREC : payoutSettingList ) {
                    system.debug ('== payoutSettingREC.Payout__c : ' + payoutSettingREC.Payout__c);
                    system.debug ('== sinREC.coll_Rate__c  : ' + sinREC.coll_Rate__c );
                    system.debug ('== payoutSettingREC.Coll_Rate_Greater_Than__c : ' + payoutSettingREC.Coll_Rate_Greater_Than__c);
                    system.debug ('== payoutSettingREC.Coll_Rate_Less_Than__c : ' + payoutSettingREC.Coll_Rate_Less_Than__c);


                    if ( sinREC.coll_Rate__c >= payoutSettingREC.Coll_Rate_Greater_Than__c 
                            && sinREC.coll_Rate__c < payoutSettingREC.Coll_Rate_Less_Than__c ) {
                        
                        if (sinREC.total_inc__c == null ) {
                            totalInc = 0;}
                        else {
                            totalInc = sinREC.total_inc__c;
                        }
                        
                        sinREC.final_inc__c =  (totalInc * payoutSettingREC.Payout__c) / 100;
                    } 
                }

                relatedSFIDs = relatedSFIDs + sinREC.id + '; ';
            }

            update sinList;

            sinWorkspaceREC.Calculation_Date__c = system.now();
            update sinWorkspaceREC;
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.putFinalIncentiveData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    
    }
    
    

    /*
    public PageReference generate() {
        System.debug('=== sinWorkspaceID : ' + sinWorkspaceID);

        SalesIncentiveController sinControllerREC = new SalesIncentiveController(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        //sinControllerREC.putRevenueData();
        //sinControllerREC.putCollectionRateData(sinWorkspaceREC.year__c, sinWorkspaceREC.quarter__c);
        sinControllerREC.generate();
        
        PageReference pageRef = new PageReference('/' + sinWorkspaceID);
        pageRef.setRedirect(true);
        return pageRef; //Returns to the case page
     }
     */




    //--- clone configuration
    public void cloneSettingData () {
        cloneWeightedSetting();
        cloneAchievementSetting();
        cloneTotalAchievementSetting();
        cloneTieringPerformanceScoreSetting();
        clonePayoutSetting();
        cloneSincSalesPersonSetting();
    }

    public void cloneWeightedSetting () {
        system.debug ('========== in SalesIncentiveWorkspaceController.cloneWeightedSetting ==========');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;
        

        List<SInc_Weighted_Setting__c> settingList =  [
        SELECT  segment__c, segment__r.name, revenue_type__c, role_level__c, weighted__c, Sales_Incentive_Workspace__c, unique_id__c
        FROM SInc_Weighted_Setting__c
        WHERE year__c = :prevQuarterYear
            AND quarter__c = :prevQuarterQuarter
        ];
        system.debug(' == settingList : ' + settingList);
        List<SInc_Weighted_Setting__c> settingTobeADDList = new List<SInc_Weighted_Setting__c> ();
        for (SInc_Weighted_Setting__c settingREC : settingList) {
            SInc_Weighted_Setting__c newSettingREC = new SInc_Weighted_Setting__c();
            newSettingREC = settingREC.clone (false, true, false, false);
            
            newSettingREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;
            
            newSettingREC.name = 'SETT_Weighted' 
                + '_' + sinWorkspaceREC.year__c + sinWorkspaceREC.quarter__c
                + '_' + newSettingREC.segment__r.name 
                + '_' + newSettingREC.revenue_type__c  
                + '_' + newSettingREC.role_level__c;

            newSettingREC.unique_id__c = newSettingREC.name;

            settingTobeADDList.add (newSettingREC);
        }

        
        try {
            System.debug(' == settingTobeADDList : '+ settingTobeADDList );
            upsert settingTobeADDList unique_id__c;

        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.cloneWeightedSetting method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + settingTobeADDList + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

    }

    public void cloneAchievementSetting () {
        system.debug ('========== in SalesIncentiveWorkspaceController.cloneAchievementSetting ==========');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;
        

        List<SInc_Achievement_Setting__c> settingList =  [
        SELECT  revenue_type__c, min__c, max__c, Sales_Incentive_Workspace__c, unique_id__c
        FROM SInc_Achievement_Setting__c
        WHERE year__c = :prevQuarterYear
            AND quarter__c = :prevQuarterQuarter
        ];

        List<SInc_Achievement_Setting__c> settingTobeADDList = new List<SInc_Achievement_Setting__c> ();
        for (SInc_Achievement_Setting__c settingREC : settingList) {
            SInc_Achievement_Setting__c newSettingREC = new SInc_Achievement_Setting__c();
            newSettingREC = settingREC.clone (false, true, false, false);
            
            newSettingREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;
            
            newSettingREC.name = 'SETT_ACH_' + sinWorkspaceREC.year__c + sinWorkspaceREC.quarter__c 
                + '_' + newSettingREC.revenue_type__c;

            newSettingREC.unique_id__c = newSettingREC.name;

            settingTobeADDList.add (newSettingREC);
        }

        
        try {
            upsert settingTobeADDList unique_id__c;

        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.cloneAchievementSetting method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + settingTobeADDList + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

    }

    //TODO: include the childe object (main kpi & other kpi) - pic: dicky
    public void cloneTotalAchievementSetting () {
        system.debug ('========== in SalesIncentiveWorkspaceController.cloneTotalAchievementSetting ==========');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;
        

        List<SInc_Total_Achievement_Setting__c> settingList =  [
        SELECT  segment__c,segment__r.name, role_levels__c, sales_incentive_types__c, Sales_Incentive_Workspace__c, unique_id__c
        FROM SInc_Total_Achievement_Setting__c
        WHERE year__c = :prevQuarterYear
            AND quarter__c = :prevQuarterQuarter
        ];
        List<SInc_Total_Achievement_Setting__c> settingTobeADDList = new List<SInc_Total_Achievement_Setting__c> ();
        List<Id> oldAchievementIds = new List<Id> ();
        Map<String,Id> oldAchievementIdsMap = new Map<String,Id> ();
        for (SInc_Total_Achievement_Setting__c settingREC : settingList) {
           
            SInc_Total_Achievement_Setting__c newSettingREC = new SInc_Total_Achievement_Setting__c();
            newSettingREC = settingREC.clone (false, true, false, false);
            newSettingREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;
            newSettingREC.name = 'SETT_TOTACH_' + sinWorkspaceREC.year__c + sinWorkspaceREC.quarter__c 
                + '_' + newSettingREC.segment__r.name
                + '_' + newSettingREC.role_levels__c;

            newSettingREC.Unique_ID__c = newSettingREC.name;
            oldAchievementIdsMap.put(newSettingREC.name, settingREC.id);
            oldAchievementIds.add(settingREC.Id);
            settingTobeADDList.add(newSettingREC);
          
           
        }
        system.debug('OLD MAP--> '+oldAchievementIdsMap);
        List<SInc_Main_KPI_Item__c> mainKPIList =  [
            SELECT Id, Name, KPIName__c, Composition__c, Weighted__c, TotalAchievementSetting__c FROM SInc_Main_KPI_Item__c WHERE TotalAchievementSetting__c IN :oldAchievementIds];
           
            List<SInc_Other_KPI_Item__c> otherKPIList =  [
            SELECT Id, Name, KPIName__c, Composition__c, Weighted__c, TotalAchievementSetting__c FROM SInc_Other_KPI_Item__c WHERE TotalAchievementSetting__c IN :oldAchievementIds];
        try {
            upsert settingTobeADDList unique_id__c;
            set<String> uniqueIds = new set<String>();
            for(SInc_Total_Achievement_Setting__c newExtract : settingTobeADDList){
                uniqueIds.add(newExtract.Unique_ID__c);
            }
            List<SInc_Total_Achievement_Setting__c> newSettingList =  [
                SELECT  Id,unique_id__c
                FROM SInc_Total_Achievement_Setting__c 
                WHERE unique_id__c IN :uniqueIds
                ];
         
            Map<Id,Id>  achievementIdsMap = new Map<Id,Id>();
            for(SInc_Total_Achievement_Setting__c settingListRec : newSettingList){
                Id achievementIdOld = oldAchievementIdsMap.get(settingListRec.unique_id__c);
                achievementIdsMap.put(achievementIdOld,settingListRec.Id);
                system.debug('== id Lama -->' + achievementIdOld + ' == id Baru -->' + settingListRec.Id);     
            }
           system.debug('== NewSettingList -->' + newSettingList);
            List<SInc_Main_KPI_Item__c> mainKPITobeADDList = new List<SInc_Main_KPI_Item__c> ();
            List<SInc_Other_KPI_Item__c> otherKPITobeADDList = new List<SInc_Other_KPI_Item__c> ();
                
                    for(SInc_Main_KPI_Item__c mainKPI : mainKPIList){
                        SInc_Main_KPI_Item__c newMainKPI = new SInc_Main_KPI_Item__c();
                       
                        newMainKPI = mainKPI.clone (false, true, false, false);
                        newMainKPI.TotalAchievementSetting__c = achievementIdsMap.get(mainKPI.TotalAchievementSetting__c);
                        system.debug('IdTotalAchievementSetting ---> ' + achievementIdsMap.get(mainKPI.TotalAchievementSetting__c));
                        mainKPITobeADDList.add(newMainKPI);

                    }
                    system.debug('mainKPI---> ' + mainKPIList);
                    upsert mainKPITobeADDList;
                    for(SInc_Other_KPI_Item__c otherKPI : otherKPIList){
                        SInc_Other_KPI_Item__c newOtherKPI = new SInc_Other_KPI_Item__c();
                        newOtherKPI = otherKPI.clone (false, true, false, false);
                        newOtherKPI.TotalAchievementSetting__c = achievementIdsMap.get(otherKPI.TotalAchievementSetting__c);
                       // newOtherKPI.unique_id__c = achievementIdsMap.get(otherKPI.TotalAchievementSetting__c);
                        otherKPITobeADDList.add(newOtherKPI);
                    }
                    system.debug('otherKPI---> ' + otherKPIList);
                    upsert otherKPITobeADDList;
        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.cloneTotalAchievementSetting method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + settingTobeADDList + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

    }   

    public void cloneTieringPerformanceScoreSetting () {
        system.debug ('========== in SalesIncentiveWorkspaceController.cloneTieringPerformanceScoreSetting ==========');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;
        

        List<SInc_Tiering_Performance_Score_Settings__c> settingList =  [
        SELECT  employee_category__c, Greater_Than_Equal__c, less_than__c, score__c, Sales_Incentive_Workspace__c, unique_id__c, segment__c
        FROM SInc_Tiering_Performance_Score_Settings__c
        WHERE year__c = :prevQuarterYear
            AND quarter__c = :prevQuarterQuarter
        ];

        List<SInc_Tiering_Performance_Score_Settings__c> settingTobeADDList = new List<SInc_Tiering_Performance_Score_Settings__c> ();
        for (SInc_Tiering_Performance_Score_Settings__c settingREC : settingList) {
            SInc_Tiering_Performance_Score_Settings__c newSettingREC = new SInc_Tiering_Performance_Score_Settings__c();
            newSettingREC = settingREC.clone (false, true, false, false);
            
            newSettingREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;
            newSettingREC.segment__c = newSettingREC.segment__c;
            
            newSettingREC.name = 'SETT_PERFSCORE_' + sinWorkspaceREC.year__c + sinWorkspaceREC.quarter__c 
                + '_' + newSettingREC.employee_category__c
                + '_' + newSettingREC.Greater_Than_Equal__c 
                + '-' + newSettingREC.less_than__c 
                ;

            newSettingREC.unique_id__c = newSettingREC.name;

            settingTobeADDList.add (newSettingREC);
        }

        
        try {
            upsert settingTobeADDList unique_id__c;

        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.cloneTieringPerformanceScoreSetting method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + settingTobeADDList + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

    }

    public void clonePayoutSetting () {
        system.debug ('========== in SalesIncentiveWorkspaceController.clonePayoutSetting ==========');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;
        

        List<SInc_Payout_Setting__c> settingList =  [
        SELECT  coll_rate_greater_than__c, coll_rate_less_than__c, payout__c, Sales_Incentive_Workspace__c, unique_id__c
        FROM SInc_Payout_Setting__c
        WHERE year__c = :prevQuarterYear
            AND quarter__c = :prevQuarterQuarter
        ];

        List<SInc_Payout_Setting__c> settingTobeADDList = new List<SInc_Payout_Setting__c> ();
        for (SInc_Payout_Setting__c settingREC : settingList) {
            SInc_Payout_Setting__c newSettingREC = new SInc_Payout_Setting__c();
            newSettingREC = settingREC.clone (false, true, false, false);
            
            newSettingREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;
            
            newSettingREC.name = 'SETT_PAYOUT_' + sinWorkspaceREC.year__c + sinWorkspaceREC.quarter__c 
                + '_' + newSettingREC.coll_rate_greater_than__c
                + '-' + newSettingREC.Coll_Rate_Less_Than__c 
                ;

            newSettingREC.unique_id__c = newSettingREC.name;

            settingTobeADDList.add (newSettingREC);
        }

        
        try {
            upsert settingTobeADDList unique_id__c;

        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.clonePayoutSetting method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + settingTobeADDList + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

    }
    
    
    public void refreshData () {
        /* // step untuk melakukan refresh data sales incentive dari mulai AM 
        1. Put Revenue Data
        2. Put Achievement Data
        3. Put Weighted Data
        4. Put Total Achievement Data
        5. Put Revenue Data SMGH
        6. Put Achievement Data
        7. Put Weighted Data
        8. Put Total Achievement Data
        9. Put Collection Rate Data
        10. Put Final Incentive Data
        */

        if(this.modeData == 'Auto Calculate' ){

            DateTime nextSchedule = System.now().addSeconds(3);

            createSheduleJob ('Put Revenue Data', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(30);

            createSheduleJob ('Put Achievement Data', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(20);

            createSheduleJob ('Put Weighted Data', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(30);

            createSheduleJob ('Put Total Achievement Data', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(20);

            createSheduleJob ('Put Revenue Data Manager', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(30);

            createSheduleJob ('Put Achievement Data', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(20);

            createSheduleJob ('Put Weighted Data', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(30);

            createSheduleJob ('Put Total Achievement Data', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(20);

            createSheduleJob ('Put Collection Rate Data', nextSchedule);
            nextSchedule = nextSchedule.addSeconds(5);

            createSheduleJob ('Put Final Incentive Data', nextSchedule);

            system.debug('=== Sales incentive workspaces Mode Data menggunakan Auto Calculate ===');

        }else{
            system.debug('=== Sales incentive workspaces Mode Data menggunakan Upload Manual ===');
        }      
    }

    public void createSheduleJob (string jobType, DateTime nextSchedule ) {

        if (this.modeData == 'Auto Calculate'){
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
            
    
            Scheduled_Process__c spREC = new Scheduled_Process__c();
            spREC.name = '**';
            spREC.Execute_Plan__c = nextSchedule;
            spREC.Parameter1__c = sinWorkspaceREC.id;
            spREC.type__c = jobType + ' (Sales Incentive)';
            insert spREC;
    
    
            sYear = string.valueof( nextSchedule.year() );
            sMonth = string.valueof( nextSchedule.month() );
            sDay = string.valueof( nextSchedule.day() ); 
            sHour = string.valueof( nextSchedule.Hour() );
            sMinute = string.valueof( nextSchedule.minute() );
            sSecond = string.valueof( nextSchedule.second() );
            
            SalesIncentive_Schedule sinSchedule = new SalesIncentive_Schedule(jobType, sinWorkspaceREC); 
            sinSchedule.jobType = jobType;   
            sinSchedule.scheduledProcessID = spREC.id;  // <<-- this is the key
    
            schTime = sSecond + ' ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
            system.debug ('============ schTime :' + schTime);
    
            //-- create scheduler
            jobTitle = 'Sales Incentive : ' + jobType + ' - ' + sinWorkspaceREC.Name  + ' - '
                + schTime ;
            
            string jobID = system.schedule(jobTitle, schTime, sinSchedule);
    
    
            spREC.jobid__c = jobID;
            spREC.parameter3__c = jobID;
            spREC.title__c = jobTitle;
            spREC.name = spREC.title__c.left(80);
            update spREC;

            system.debug(' === schedule berjalan karena sales incentive mode data menggunakan auto calculated ===');
        }else{
            system.debug(' === schedule tidak berjalan karena sales incentive mode data menggunakan manual upload === ');
        }
       
    }

    public void createActualDetailReportLink () {

        List<Sales_Incentive__c> salesIncentiveToBeUpdateList = [
            SELECT
                id,
                Role_level__c,
                type__c,
                Report_Link_Actual_Detail_by_Type__c,

                Report_link_Sinc_Revenue_Total_AM__c,
                Report_link_Sinc_New_Revenue_AM__c,
                Report_link_Sinc_Net_Adds_Mobile_AM__c,
                Report_link_Sinc_Gross_Adds_Mobile_AM__c,
                Report_link_Sinc_Net_Adds_Fixed_Links_AM__c,
                Report_link_SincGross_Adds_Links_AM__c,
                Report_link_Sinc_Partnership_Revenue_AM__c,
                Report_link_Sinc_Pipeline_PO_AM__c,
                Report_link_Sinc_Pipeline_Total_AM__c,
                Report_Link_Sinc_Pipeline_New_Reven_AM__c,
                Report_link_Sinc_Pipeline_BAU_AM__c,
                Report_link_Sinc_Partnership_Number_AM__c,

                Report_link_Sinc_Revenue_Total_SM__C,
                Report_link_New_Revenue_SM__C,
                Report_Link_Nett_Adds_Mobile_SM__c,
                Report_link_Gross_Adds_Mobile_SM__C,
                Report_Link_Net_Adds_Links_SM__c,
                Report_link_Gross_Adds_Links_SM__C,
                Report_link_Partnership_Revenue_SM__C,
                Report_link_Pipeline_PO_SM__C,
                Report_link_Pipeline_Total_SM__C,
                Report_link_Pipeline_BAU_SM__C,
                Report_Link_Pipeline_New_Revenue_SM__c,
                Report_link_Partnership_Number_SM__C,

                Report_link_Sinc_Revenue_Total_GH__c,
                Report_link_New_Revenue_GH__c,
                Report_Link_Nett_Adds_Mobile_GH__c,
                Report_link_Gross_Adds_Mobile_GH__c,
                Report_Link_Net_Adds_Links_GH__c,
                Report_link_Gross_Adds_Links_GH__c,
                Report_link_Partnership_Revenue_GH__c,
                Report_link_Pipeline_PO_GH__c,
                Report_link_Pipeline_Total_GH__c,
                Report_link_Pipeline_BAU_GH__c,
                Report_Link_Pipeline_New_Revenue_GH__c,
                Report_link_Partnership_Number_GH__c

            FROM Sales_Incentive__c
            WHERE
                year__c = :year //'2021'
                AND quarter__c = :quarter //'q2'
        ];


        for(Sales_Incentive__c sincREC : salesIncentiveToBeUpdateList) {

            system.debug('=== sincREC.Role_level__c : ' + sincREC.Role_level__c);
            system.debug('=== sincREC.Type__c : ' + sincREC.Type__c);
    
            //sincIDs.add (sincREC.id);
    
            if (sincREC.Role_level__c == 'AM') {
                switch on sincREC.Type__c  {
                    when 'Revenue Total' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Revenue_Total_AM__c;
                    }
                    when 'New Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_New_Revenue_AM__c;
                    }
                    when 'Net-Adds Mobile' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Net_Adds_Mobile_AM__c;
                    }
                    when 'Gross-Adds Mobile' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Gross_Adds_Mobile_AM__c;
                    }
                    when 'Net-Adds Fixed Links' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Net_Adds_Fixed_Links_AM__c;
                    }
                    when 'Gross-Adds Fixed Links' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_SincGross_Adds_Links_AM__c;
                    }
                    when 'Partnership Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Partnership_Revenue_AM__c;
                    }
                    when 'Pipeline PO' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Pipeline_PO_AM__c;
                    }
                    when 'Pipeline Total' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Pipeline_Total_AM__c;
                    }
                    when 'Pipeline New Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_Link_Sinc_Pipeline_New_Reven_AM__c;
                    }
                    when 'Pipeline BAU' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Pipeline_BAU_AM__c;
                    }
                    when 'Partnership Number' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Partnership_Number_AM__c;
                    }
                }
    
            }
    
            else if (sincREC.Role_level__c == 'SM') {
                switch on sincREC.Type__c  {
                    when 'Revenue Total' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Revenue_Total_SM__C;
                    }
                    when 'New Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_New_Revenue_SM__C;
                    }
                    when 'Net-Adds Mobile' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_Link_Nett_Adds_Mobile_SM__c;
                    }
                    when 'Gross-Adds Mobile' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Gross_Adds_Mobile_SM__C;
                    }
                    when 'Net-Adds Fixed Links' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_Link_Net_Adds_Links_SM__c;
                    }
                    when 'Gross-Adds Fixed Links' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Gross_Adds_Links_SM__C;
                    }
                    when 'Partnership Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Partnership_Revenue_SM__C;
                    }
                    when 'Pipeline PO' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Pipeline_PO_SM__C;
                    }
                    when 'Pipeline Total' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Pipeline_Total_SM__C;
                    }
                    
                    when 'Pipeline New Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_Link_Pipeline_New_Revenue_SM__c;
                    }
                    when 'Pipeline BAU' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Pipeline_BAU_SM__C;
                    }
                    when 'Partnership Number' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Partnership_Number_SM__C;
                    }
                }
            
            }
    
            else if (sincREC.Role_level__c == 'GH') {
                switch on sincREC.Type__c  {
                    when 'Revenue Total' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Sinc_Revenue_Total_GH__c;
                    }
                    when 'New Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_New_Revenue_GH__c;
                    }
                    when 'Net-Adds Mobile' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_Link_Nett_Adds_Mobile_GH__c;
                    }
                    when 'Gross-Adds Mobile' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Gross_Adds_Mobile_GH__c;
                    }
                    when 'Net-Adds Fixed Links' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_Link_Net_Adds_Links_GH__c;
                    }
                    when 'Gross-Adds Fixed Links' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Gross_Adds_Links_GH__c;
                    }
                    when 'Partnership Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Partnership_Revenue_GH__c;
                    }
                    when 'Pipeline PO' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Pipeline_PO_GH__c;
                    }
                    when 'Pipeline Total' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Pipeline_Total_GH__c;
                    }
                    when 'Pipeline New Revenue' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_Link_Pipeline_New_Revenue_GH__c;
                    }
                    when 'Pipeline BAU' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Pipeline_BAU_GH__c;
                    }
                    when 'Partnership Number' {
                        sincREC.report_link_actual_detail_by_type__c = sincREC.Report_link_Partnership_Number_GH__c;
                    }
                }
            }
        
        } //.endFor

        update salesIncentiveToBeUpdateList;

    }

    public void cloneSincSalesPersonSetting(){
      system.debug ('========== in SalesIncentiveWorkspaceController.cloneSincSalesPersonSetting ==========');
        string relatedSFIDs = sinWorkspaceREC.id;
        string errorMsg;
        
        List<SInc_Sales_Person_Setting__c> settingList =  [
            SELECT 
            Id, 
            Name, 
            CreatedById, 
            LastModifiedById, 
            Sales_Person__c, 
            Year__c, 
            Quarter__c, 
            Revenue_Type__c, 
            Employee_Id__c, 
            Sales_Person_Rel_Employee_ID__c, 
            unique_id__c, 
            Sales_Incentive_Workspace__c 
          FROM 
            SInc_Sales_Person_Setting__c 
          WHERE 
            year__c = : prevQuarterYear 
            AND quarter__c = : prevQuarterQuarter
          
        ];

        List<SInc_Sales_Person_Setting__c> settingTobeADDList = new List<SInc_Sales_Person_Setting__c> ();
        for (SInc_Sales_Person_Setting__c settingREC : settingList) {
            SInc_Sales_Person_Setting__c newSettingREC = new SInc_Sales_Person_Setting__c();
            newSettingREC = settingREC.clone (false, true, false, false);
            
            newSettingREC.Sales_Incentive_Workspace__c = sinWorkspaceREC.id;
            
            newSettingREC.name = 'SETT_PERSON_' + sinWorkspaceREC.year__c + sinWorkspaceREC.quarter__c 
                + '_' + newSettingREC.Employee_Id__c
                ;
            newSettingREC.year__c = sinWorkspaceREC.Year__c;
            newSettingREC.quarter__c = sinWorkspaceREC.quarter__c;
            newSettingREC.unique_id__c = newSettingREC.name;

            settingTobeADDList.add (newSettingREC);
        }

        
        try {

            upsert settingTobeADDList unique_id__c;

        }
        catch (Exception e) {
            string notes = 'Error on SalesIncentiveWorkspaceController.cloneSincSalesPersonSetting method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '>> ' + settingTobeADDList + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

}