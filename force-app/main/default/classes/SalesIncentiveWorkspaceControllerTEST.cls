/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 06-09-2022
 * @last modified by  : Diky Nurosid
**/
@ isTest
public class SalesIncentiveWorkspaceControllerTEST {

    @isTest static void schenario1() {

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.undelete', Is_Active__c=true));
        insert lstTriggerController;
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMGSObj;
        system.debug('== sprM_AMGSObj :' + sprM_AMGSObj);

        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMObj;
        system.debug('== sprM_AMObj :' + sprM_AMGSObj);

        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprMObj;
        system.debug('== sprMObj :' + sprMObj);

        User groupHeadobj=[SELECT id, userroleid FROM User WHERE Profile.Name='Sales Group Head' AND UserRole.Name='Group Head - Key Account Management' AND IsActive=true LIMIT 1];

        User salesManagerobj=[SELECT id, userroleid FROM User WHERE Profile.Name='Sales Manager' AND UserRole.Name='Head - Banking & Financial Services' AND IsActive=true LIMIT 1];

        User AMobj=[SELECT id, userroleId FROM user WHERE Profile.Name='Sales' AND UserRole.Name='Banking & Financial Services' AND IsActive=true LIMIT 1];

         Sales_Incentive_Workspace__c siwObj = new Sales_Incentive_Workspace__c(
            Name = 'Sales Incentive for Q1 2021', // Name
            Year__c = '2021', // Year
            Quarter__c = 'Q1' // Quarter
        );
        insert siwObj;
            
    	
        Segment__c segmentALLLE = new Segment__c(
          Name = 'ALL LE',             // Segment Name
          Group_Segment_Name__c = 'LE',  // Group Segment Name
          Unique_ID__c = 'ALL LE'       // Unique_ID
        );
        insert segmentALLLE;
        
        //sales total achievemnt setting
        //ada disini
        SInc_Total_Achievement_Setting__c STASObj = new SInc_Total_Achievement_Setting__c(
          Name = 'SETT_TOTACH_2022Q1_a1M7F000004FSdmUAG_AM;SM;GH',     // Name
          Segment__c = segmentALLLE.Id,                                      // Segment
          Sales_Incentive_Workspace__c = siwObj.id,                    // Sales Incentive Workspace
          Unique_ID__c = 'SETT_TOTACH_2022Q1_a1M7F000004FSdmUAG_AM;SM',  // Unique ID
          Role_Levels__c = 'AM;SM;GH',                                   // Role Levels
          MainKPIComposition__c = 60,                                    // Main KPI Composition (%)
          OtherKPIComposition__c = 40,                                   // Other KPI Composition (%)
          MinimumAchievementforMainKPI__c = 90,                          // Minimum Achievement for Main KPI
          MinimumAchievementforOtherKPI__c = 90                         // Minimum Achievement for Other KPI
        );
        insert STASObj;

        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services', // Segment Name
            Group_Segment_Name__c = 'LE', // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services' // Unique_ID
        );
        insert segmentObj;

        SInc_Total_Achievement_Setting__c totAchSettingObj = new SInc_Total_Achievement_Setting__c(
            Name = 'ME\tIndirect Sales\tTerritory Corporate Sales\tAM; SM',
            Segment__c = segmentObj.id,            
            Sales_Incentive_Workspace__c = siwObj.id,              
            Role_Levels__c = 'GH',                  
            Sales_Incentive_Types__c = 'Revenue Total;New Revenue;Net-Adds Mobile;Net-Adds Fixed Links;Gross-Adds Fixed Links;Partnership Revenue',
            MinimumAchievementforMainKPI__c =90,
            MinimumAchievementforOtherKPI__c = 90
        );
        insert totAchSettingObj; 

        SInc_Main_KPI_Item__c SIncMainKPIItemObj = new SInc_Main_KPI_Item__c(
            TotalAchievementSetting__c = totAchSettingObj.id,// Total Achievement Setting
            KPIName__c = 'Revenue Total',              // KPI Name
            Composition__c = 60                       // Composition
        );
        insert SIncMainKPIItemObj;

        SInc_Other_KPI_Item__c SIncOtherKPIItemobj1 = new SInc_Other_KPI_Item__c(
            TotalAchievementSetting__c = totAchSettingObj.id,// Total Achievement Setting
            KPIName__c = 'New Revenue',                // KPI Name
            Composition__c = 10                       // Composition
        );
        insert SIncOtherKPIItemobj1;

        SInc_Other_KPI_Item__c SIncOtherKPIItemobj2 = new SInc_Other_KPI_Item__c(
            TotalAchievementSetting__c = totAchSettingObj.id,// Total Achievement Setting
            KPIName__c = 'Gross-Adds Mobile',            
            Composition__c = 10                       // Composition
        );
        insert SIncOtherKPIItemobj2;

        SInc_Other_KPI_Item__c SIncOtherKPIItemobj3 = new SInc_Other_KPI_Item__c(
            TotalAchievementSetting__c = totAchSettingObj.id,// Total Achievement Setting
            KPIName__c = 'Pipeline PO',                // KPI Name
            Composition__c = 20                       // Composition
        );
        insert SIncOtherKPIItemobj3;

        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'Connectivity Mobile', // Group Service Name
            Unique_ID__c = 'Connectivity Mobile', // Unique ID
            Type__c = 'BAU' // Type
        );
        insert groupServiceObj;

        Revenue_Category__c revCatobj = new Revenue_Category__c(
            Name = 'Revenue - Cloud', // Name
            Group_Service__c = groupServiceObj.id // Group Service
        );
        insert revCatobj;
        
        Sales_Performance_Monthly_AMGS__c sprAMGSobj = new Sales_Performance_Monthly_AMGS__c(
            Name = 'SPR_2101_90002724_FIXED', // Name
            Period_Date__c = date.newInstance(2021, 01, 01), // Period Date
            Year__c = '2021', // Year
            Group_Service_Type__c = groupServiceObj.Type__c, // Group Service Type
            Group_Service__c = groupServiceObj.id, // Group Service
            Month__c = '1', // Month
            Group_Head__c = groupHeadobj.id, // Group Head
            Segment__c = SegmentObj.id, // Segment
            Sales_Manager__c = salesManagerobj.id, // Sales Manager
            AM__c = AMobj.id // AM
        );
        insert sprAMGSobj;
        system.debug('hasil sprAMGSobj*' + sprAMGSobj);


        Sales_Performance_Monthly_AMGS__c sprAMGSobjs = new Sales_Performance_Monthly_AMGS__c(
            Name = 'SPR_2101_90002724_FIXED', // Name
            Period_Date__c = date.newInstance(2021, 01, 01), // Period Date
            Year__c = '2021', // Year
            Group_Service_Type__c = groupServiceObj.Type__c, // Group Service Type
            Group_Service__c = groupServiceObj.id, // Group Service
            Month__c = '1', // Month
            Group_Head__c = groupHeadobj.id, // Group Head
            Segment__c = SegmentObj.id, // Segment
            Sales_Manager__c = salesManagerobj.id, // Sales Manager
            AM__c = AMobj.id // AM
        );
        insert sprAMGSobjs;
        system.debug('hasil sprAMGSobj*' + sprAMGSobj);

        // sales target 
        id strRecTypeId = Schema.SObjectType.Sales_target__c.getRecordTypeInfosByName().get('Target Revenue').getRecordTypeId();
        Sales_Target__c strobj = new Sales_Target__c(
            Name = 'STR_2101_90007138_Managed IT-Data Center_Revenue', // Name
            RecordTypeId = strRecTypeId, // Record Type
            Year__c = '2021', // Year
            Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id, // Sales Performance Monthly AMGS
            Month__c = '1', // Month
            AM__c = AMobj.id, // AM
            Period_date__c = Date.newInstance(2021, 01, 01), // Period date
            Group_Service__c = groupServiceObj.id, // Group Service
            Amount__c = 31141, // Amount
            Type__c = 'Target Revenue', // Type
            Group_Service_Type__c = 'New Revenue', // Group Service Type
            Sales_Performance_Monthly_AM__c = sprM_AMObj.id, // Sales Performance Monthly AM
            Segment__c = SegmentObj.id, // Segment
            Sales_Manager__c = salesManagerobj.id, // Sales Manager
            Group_Head__c = groupHeadobj.id, // Group Head
            AM_Employee_ID__c = '90007138', // AM Employee ID
            Group_Service_Name__c = 'Managed IT-Data Center', // Group Service Name

            Unique_ID__c = 'STR_2101_90007138_Managed IT-Data Center_Revenue' // Unique_ID
        );
        system.debug('strobj ==' + strobj);
        insert strobj;
        
        // sales revenue
        id srvRecTypeId = Schema.SObjectType.Sales_revenue__c.getRecordTypeInfosByName().get('Actual Revenue').getRecordTypeId();
        Sales_Revenue__c srvobj = new Sales_Revenue__c(
            Name = 'SRV_2101_90007138_Revenue - Cloud_725469_ActualRevenue', // Name
            Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id, // Sales Performance Monthly AMGS
            Year__c = '2021', // Year
            Sales_Performance_Monthly_AM__c = sprM_AMObj.id, // Sales Performance Monthly AM
            Month__c = '1', // Month
            RecordTypeId = srvRecTypeId, // Record Type
            Type__c = 'Actual Revenue', // Type
            Period_Date__c = Date.newInstance(2021, 01, 01), // Period Date
            AM__c = AMobj.id, // AM
            Amount__c = 32728,
            Segment__c = SegmentObj.id, // Amount
            Revenue_Category__c = revCatobj.id, // Revenue Category
            Group_Service__c = groupServiceObj.id, // Group Service
            Data_Status__c = 'Created', // Is New Customer_T
            Group_Service_Type__c = 'New Revenue', // Group Service Type
            Sales_Manager__c = salesManagerobj.id,
            Group_Head__c = groupHeadobj.id, // Group Head
            AM_Employee_ID__c = '90007138', // AM Employee ID
            Customer_BP_No__c = '725469', // Customer BP No
            Revenue_Category_Name__c = 'Revenue - Cloud' // Revenue Category Name
           // Unique_ID__c = 'SRV_2101_90007138_Revenue - Cloud_725469_ActualRevenue' // Unique ID
        );
        system.debug('=== srvobj :' + srvobj);
        insert srvobj;
        
        /* 
        Sales_Revenue__c srvobj = new Sales_Revenue__c(
            name = '123',
            Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id, // Sales Performance Monthly AMGS
            Year__c = '2021', // Year
            Sales_Performance_Monthly_AM__c = sprM_AMObj.id, // Sales Performance Monthly AM
            Month__c = '1', // Month
            Type__c = 'Actual Revenue', // Type
            Amount__c = 32728,
            AM_Employee_ID__c = '90007138', // AM Employee ID
            Customer_BP_No__c = '725469', // Customer BP No
            Revenue_Category_Name__c = 'Revenue - Cloud' // Revenue Category Name
           // Unique_ID__c = 'SRV_2101_90007138_Revenue - Cloud_725469_ActualRevenue' // Unique ID
        );
        system.debug('=== srvobj :' + srvobj);
        insert srvobj;
        */



      //  id RecTypeId = Schema.SObjectType.Sales_Incentive__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        Sales_Incentive__c sincobj = new Sales_Incentive__c(
            Name = 'SIN_21Q1_AM_90002724_New Revenue', // Sales Incentive Name
           // RecordTypeId = RecTypeId, // Record Type
            Year__c = '2021', // Year
            Sales_Incentive_Workspace__c = siwObj.id, // Sales Incentive Workspace
            Quarter__c = 'Q1', // Quarter
            Period_Date__c = Date.newInstance(2021, 07, 05), // Period Date
            Sales_Person__c = AMobj.id, // Sales Person
            sales_manager__C = salesManagerobj.id,
            group_head__c = groupHeadobj.id,
            segment__c = SegmentObj.id,
            Group_Segment__c = 'LE', // Group Segment
            Role_Level__c = 'AM', // Role Level
            Type__c = 'Revenue Total', // Type
            Achievement__c = 0.00, // Achievement
            Target__c = 240091444, // Target
            Weighted__c = 15.00, // Weighted
            Actual__c = 210091444, // Actual
            isused__c = true,
            Unique_ID__c = 'SIN_21Q1_AM_90002724_New Revenue' // Unique ID
        );
        system.debug('sincobj ==' + sincobj);
        insert sincobj;


        Sinc_Revenue_Data_Source_Setting__c sobj = new Sinc_Revenue_Data_Source_Setting__c(
            Revenue_Type__c = 'Revenue Total', // Revenue Type
            SOQL_Type__c = 'COMBINE', // SOQL Type
            Is_Active__c = true, // Is Active
            Combine_SOQL_AM__c = 'SELECT segment__r.group_segment_name__c groupSegmentName, segment__r.name segmentName, segment__c segmentSFID,  AM__r.name userName, AM__r.employee_id__c employeeID, AM__r.id userSFID,  AM__r.IsActive userIsActive,  AM__r.managerId managerSFID, AM__r.manager.IsActive managerIsActive, AM__r.manager.managerId managerManagerSFID, AM__r.manager.manager.IsActive managerManagerIsActive, sales_manager__c salesManagerId, group_head__c groupHeadId,   sum(Target_Revenue__c) target, sum(Actual_Revenue__c) actual  FROM sales_performance_Monthly_amgs__c  WHERE year__c = :year AND month__c in :months AND segment__c <> NULL  GROUP BY segment__r.group_segment_name__c, segment__r.name, segment__c, AM__r.name, AM__r.employee_id__c, AM__r.id, AM__r.IsActive,  AM__r.managerId, AM__r.manager.IsActive, AM__r.manager.managerId, AM__r.manager.manager.IsActive, sales_manager__c, group_head__c',  // Combine SOQL AM

            
            // using old way query to performances for sm and gh
            Combine_SOQL_SM__c = 'SELECT Sales_Manager__r.id userSFID, Sales_Manager__r.IsActive userIsActive,  Sales_Manager__r.managerId managerSFID, Sales_Manager__r.manager.IsActive managerIsActive, Sales_Manager__r.manager.managerId managerManagerSFID,Sales_Manager__r.manager.manager.IsActive managerManagerIsActive,      Sales_Manager__r.name userName,       Sales_Manager__r.employee_id__c employeeID,       Sales_Manager__r.userrole.name roleName,       sum(Target_Revenue__c) target,       sum(Actual_Revenue__c) actual FROM sales_performance_Monthly_amgs__c WHERE year__c = :year  AND month__c in :months  AND segment__c <> NULL  AND Sales_Manager__r.employee_id__c <> NULL  AND Sales_Manager__r.userrole.name like \'Head - %\' GROUP BY          Sales_Manager__r.id, Sales_Manager__r.IsActive, Sales_Manager__r.managerId, Sales_Manager__r.manager.IsActive, Sales_Manager__r.manager.managerId, Sales_Manager__r.manager.manager.IsActive,         Sales_Manager__r.name,         Sales_Manager__r.employee_id__c,         Sales_Manager__r.userrole.name', // Combine SOQL SM

            Combine_SOQL_GH__c = 'SELECT segment__r.group_segment_name__c groupSegmentName,      Group_Head__r.id userSFID,  Group_Head__r.IsActive userIsActive,  Group_Head__r.managerId managerSFID, Group_Head__r.manager.IsActive managerIsActive, Group_Head__r.manager.managerId managerManagerSFID, Group_Head__r.manager.manager.IsActive managerManagerIsActive,       Group_Head__r.name userName,       Group_Head__r.employee_id__c employeeID,  Group_Head__r.userrole.name roleName,   sum(Target_Revenue__c) target,       sum(Actual_Revenue__c) actual FROM sales_performance_Monthly_amgs__c WHERE year__c = :year  AND month__c in :months  AND Group_Head__c <> null  AND segment__r.group_segment_name__c <> null  ' +
            //AND Group_Head__r.userrole.name like \' 'Group Head - %\' 
            ' GROUP BY segment__r.group_segment_name__c,       Group_Head__r.id, Group_Head__r.IsActive,  Group_Head__r.managerId, Group_Head__r.manager.IsActive, Group_Head__r.manager.managerId, Group_Head__r.manager.manager.IsActive,         Group_Head__r.name,         Group_Head__r.employee_id__c, Group_Head__r.userrole.name' // Combine SOQL GH
            /*
            Combine_SOQL_SM__c = 'SELECT  Sales_Manager__r.name userName, Sales_Manager__r.employee_id__c employeeID, Sales_Manager__r.userrole.name roleName,  Sales_Manager__r.id userSFID,  Sales_Manager__r.IsActive userIsActive, Sales_Manager__r.managerId managerSFID, Sales_Manager__r.manager.IsActive managerIsActive, Sales_Manager__r.manager.managerId managerManagerSFID, Sales_Manager__r.manager.manager.IsActive managerManagerIsActive, group_head__c groupheadid,  sum(Target__c) target, sum(Actual__c) actual  FROM sales_incentive__c  WHERE year__c = :year AND quarter__c = :quarter AND Type__c = \'Revenue Total\' AND isUsed__c = true AND segment__c <> NULL AND Sales_Manager__r.employee_id__c <> NULL AND Sales_Manager__r.userrole.name like \'Head - %\'  GROUP BY  Sales_Manager__r.name, Sales_Manager__r.employee_id__c, Sales_Manager__r.userrole.name, Sales_Manager__r.id, Sales_Manager__r.IsActive,  Sales_Manager__r.managerId, Sales_Manager__r.manager.IsActive, Sales_Manager__r.manager.managerId, Sales_Manager__r.manager.manager.IsActive, group_head__c',

            Combine_SOQL_GH__c = 'SELECT  Group_Head__r.name userName, Group_Head__r.employee_id__c employeeID, Group_Head__r.userrole.name roleName, Group_Head__r.id userSFID,  Group_Head__r.IsActive userIsActive,  Group_Head__r.managerId managerSFID, Group_Head__r.manager.IsActive managerIsActive, Group_Head__r.manager.managerId managerManagerSFID, Group_Head__r.manager.manager.IsActive managerManagerIsActive,  sum(Target__c) target, sum(Actual__c) actual  FROM sales_incentive__c  WHERE year__c = :year AND quarter__c = :quarter AND Type__c = \'Revenue Total\' AND isUsed__c = true AND Group_Head__c <> null AND segment__r.group_segment_name__c <> null AND Group_Head__r.userrole.name like \'Group Head - %\'  GROUP BY  Group_Head__r.name, Group_Head__r.employee_id__c, Group_Head__r.userrole.name, Group_Head__r.id, Group_Head__r.IsActive,  Group_Head__r.managerId, Group_Head__r.manager.IsActive, Group_Head__r.manager.managerId, Group_Head__r.manager.manager.IsActive' 
            */
        );
        insert sobj;

        //collection rate quarterlu
        Collection_Rate_Quarterly__c collRateObj = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q1_90002724',        // Name
            Quarter__c = 'Q1',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 83.08,               // Coll Ratio
            Employee_ID__c = '90002724',         // Employee ID
            Sales_Person__c = AMobj.id,       // Sales Person
            Unique_ID__c = 'CRQ_21Q1_90002724'  // Unique ID
            );
        insert collRateObj;

        collRateObj = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q1_90003798',        // Name
            Quarter__c = 'Q1',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 63.08,               // Coll Ratio
            Employee_ID__c = '90003798',         // Employee ID
            Sales_Person__c = salesmanagerObj.id,       // Sales Person
            Unique_ID__c = 'CRQ_21Q1_90003798'  // Unique ID
            );
        insert collRateObj;

        
        collRateObj = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q1_90007879',        // Name
            Quarter__c = 'Q1',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 93.08,               // Coll Ratio
            Employee_ID__c = '90007879',         // Employee ID
            Sales_Person__c = groupHeadobj.id,       // Sales Person
            Unique_ID__c = 'CRQ_21Q1_90007879'  // Unique ID
            );
        insert collRateObj;

        //sinc payout setting
        SInc_Payout_Setting__c payOutSettingObj = new SInc_Payout_Setting__c(
            Name = 'PAY_21Q1_0-75',                    // Name
            Sales_Incentive_Workspace__c = siwObj.id,  // Sales Incentive Workspace
            Coll_Rate_Greater_Than__c = 0.00,            // Coll Rate Greater Than (>=)
            Coll_Rate_Less_Than__c = 75.00,               // Coll Rate Les Than (<)
            Payout__c = 70.00                           // Payout
        );
        insert payOutSettingObj;

        //sinc achievemnt setting

        SInc_Achievement_Setting__c achSettingObj = new SInc_Achievement_Setting__c(
            Name = 'SI ACH 21Q1 New Revenue',          // Incentive  Name
            Sales_Incentive_Workspace__c = siwObj.id,  // Sales Incentive Workspace
            Revenue_Type__c = 'New Revenue',             // Revenue Type
            Min__c = 0.00,                               // Min
            Max__c = 120.00                             // Max
        );
        insert achSettingObj;

        // sales incentive weighted
        SInc_Weighted_Setting__c sincWeightSettingObj = new SInc_Weighted_Setting__c(
            Name = '2021_ALL-Gross-Adds fixed links-AM-10%',// Sales Incentive Weighted Name
            Sales_Incentive_Workspace__c = siwObj.id,       // Sales Incentive Workspace
            Revenue_Type__c = 'Gross-Adds Fixed Links',       // Revenue Type
            Weighted__c = 10,                                 // Weighted
            Segment__c = segmentObj.id,                         // Segment
            Role_Level__c = 'AM'                             // Role Level
            );
        insert sincWeightSettingObj;
        
              //tiering performance score setting
        SInc_Tiering_Performance_Score_Settings__c sincTeringPerSettingObj = new SInc_Tiering_Performance_Score_Settings__c(
            Name = '2021 - New Employee : < 90 %',  // Name
            segment__c = segmentObj.id,
            Sales_Incentive_Workspace__c = siwObj.id,  // Sales Incentive Workspace
            Employee_Category__c = 'New Employee',       // Employee Category
            Greater_Than_Equal__c = 0,                   // Greater Than Equal ( >= )
            Less_Than__c = 90,                           // Less Than (<)
            Score__c = 0                                // Score
        );
        insert sincTeringPerSettingObj;


        Test.startTest();
        Sales_Incentive_Workspace__c sinWorkspaceOBJ = new Sales_Incentive_Workspace__c();
    
        sinWorkspaceOBJ.year__c = '2021';
        sinWorkspaceOBJ.quarter__c = 'Q1';
        sinWorkspaceOBJ.Mode_Data__c = 'Auto Calculate';
        insert sinWorkspaceOBJ;



        ApexPages.StandardController sc = new ApexPages.StandardController(sinWorkspaceOBJ);
        SalesIncentiveWorkspaceController sinWorkspanceConOBJ = new SalesIncentiveWorkspaceController(sc);
        
		sinWorkspanceConOBJ.year = sinWorkspaceOBJ.year__c;
        sinWorkspanceConOBJ.quarter = sinWorkspaceOBJ.quarter__c;
        sinWorkspanceConOBJ.attachRelatedObjects();
        sinWorkspanceConOBJ.putRevenueData();
        sinWorkspanceConOBJ.putAchievementData();
        sinWorkspanceConOBJ.putWeightedData();
        sinWorkspanceConOBJ.putTotalAchievementData();
        sinWorkspanceConOBJ.putRevenueDataSMGH();
        sinWorkspanceConOBJ.putAchievementData();
        sinWorkspanceConOBJ.putWeightedData();
        sinWorkspanceConOBJ.putTotalAchievementData();
        sinWorkspanceConOBJ.putCollectionRateData();
        sinWorkspanceConOBJ.putFinalIncentiveData();
        
        sinWorkspanceConOBJ.refreshData();

        Test.stopTest();

    }

    @isTest static void schenario2CloneSetting() {
        User groupHeadobj=[SELECT id, userroleid FROM User WHERE Profile.Name='Sales Group Head' AND UserRole.Name='Group Head - Key Account Management' AND IsActive=true LIMIT 1];

        User salesManagerobj=[SELECT id, userroleid FROM User WHERE Profile.Name='Sales Manager' AND UserRole.Name='Head - Banking & Financial Services' AND IsActive=true LIMIT 1];

        User AMobj=[SELECT id, userroleId FROM user WHERE Profile.Name='Sales' AND UserRole.Name='Banking & Financial Services' AND IsActive=true LIMIT 1];


        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services', // Segment Name
            Group_Segment_Name__c = 'LE', // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services' // Unique_ID
        );
        insert segmentObj;

        Sales_Incentive_Workspace__c siwObj = new Sales_Incentive_Workspace__c(
            Name = 'Sales Incentive for Q1 2021', // Name
            Year__c = '2021', // Year
            Quarter__c = 'Q4' // Quarter
        );
        insert siwObj;

        //collection rate quarterlu
        Collection_Rate_Quarterly__c collRateObj = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q4_90002724',        // Name
            Quarter__c = 'Q4',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 83.08,               // Coll Ratio
            Employee_ID__c = '90002724',         // Employee ID
            Sales_Person__c = AMobj.id,       // Sales Person
            Unique_ID__c = 'CRQ_21Q1_90002724'  // Unique ID
            );
        insert collRateObj;
        
        collRateObj = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q4_90003798',        // Name
            Quarter__c = 'Q4',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 63.08,               // Coll Ratio
            Employee_ID__c = '90003798',         // Employee ID
            Sales_Person__c = salesmanagerObj.id,       // Sales Person
            Unique_ID__c = 'CRQ_21Q1_90003798'  // Unique ID
            );
        insert collRateObj;

        collRateObj = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q4_90007879',        // Name
            Quarter__c = 'Q4',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 93.08,               // Coll Ratio
            Employee_ID__c = '90007879',         // Employee ID
            Sales_Person__c = groupHeadobj.id,       // Sales Person
            Unique_ID__c = 'CRQ_21Q1_90007879'  // Unique ID
            );
        insert collRateObj;

        //sinc payout setting
        SInc_Payout_Setting__c payOutSettingObj = new SInc_Payout_Setting__c(
            Name = 'PAY_21Q1_0-75',                    // Name
            Sales_Incentive_Workspace__c = siwObj.id,  // Sales Incentive Workspace
            Coll_Rate_Greater_Than__c = 0.00,            // Coll Rate Greater Than (>=)
            Coll_Rate_Less_Than__c = 75.00,               // Coll Rate Les Than (<)
            Payout__c = 70.00                           // Payout
        );
        insert payOutSettingObj;

        //sinc achievemnt setting
        SInc_Achievement_Setting__c achSettingObj = new SInc_Achievement_Setting__c(
            Name = 'SI ACH 21Q1 New Revenue',          // Incentive  Name
            Sales_Incentive_Workspace__c = siwObj.id,  // Sales Incentive Workspace
            Revenue_Type__c = 'New Revenue',             // Revenue Type
            Min__c = 0.00,                               // Min
            Max__c = 120.00                             // Max
        );
        insert achSettingObj;

        // sales incentive weighted
        SInc_Weighted_Setting__c sincWeightSettingObj = new SInc_Weighted_Setting__c(
            Name = '2021_ALL-Gross-Adds fixed links-AM-10%',// Sales Incentive Weighted Name
            Sales_Incentive_Workspace__c = siwObj.id,       // Sales Incentive Workspace
            Revenue_Type__c = 'Gross-Adds Fixed Links',       // Revenue Type
            Weighted__c = 10,                                 // Weighted
            Segment__c = segmentObj.id,                         // Segment
            Role_Level__c = 'AM'                             // Role Level
            );
        insert sincWeightSettingObj;
        

        //tiering performance score setting
        SInc_Tiering_Performance_Score_Settings__c sincTeringPerSettingObj = new SInc_Tiering_Performance_Score_Settings__c(
            Name = '2021 - New Employee : < 90 %',  // Name
            segment__c = segmentObj.id,
            Sales_Incentive_Workspace__c = siwObj.id,  // Sales Incentive Workspace
            Employee_Category__c = 'New Employee',       // Employee Category
            Greater_Than_Equal__c = 0,                   // Greater Than Equal ( >= )
            Less_Than__c = 90,                           // Less Than (<)
            Score__c = 0                                // Score
        );
        insert sincTeringPerSettingObj;



        Test.startTest();

        
        SInc_Total_Achievement_Setting__c totAchSettingObj = new SInc_Total_Achievement_Setting__c(
            Name = 'ME\tIndirect Sales\tTerritory Corporate Sales\tAM; SM',
            Segment__c = segmentObj.id,            
            Sales_Incentive_Workspace__c = siwObj.id,              
            Role_Levels__c = 'GH'                  
            //Sales_Incentive_Types__c = 'Revenue Total;New Revenue;Net-Adds Mobile;Net-Adds Fixed Links;Gross-Adds Fixed Links;Partnership Revenue'
        );
        insert totAchSettingObj; 

        SInc_Main_KPI_Item__c SIncMainKPIItemObj = new SInc_Main_KPI_Item__c(
            TotalAchievementSetting__c = totAchSettingObj.id,// Total Achievement Setting
            KPIName__c = 'Revenue Total',              // KPI Name
            Composition__c = 60                       // Composition
        );
        insert SIncMainKPIItemObj;

        SInc_Other_KPI_Item__c SIncOtherKPIItemobj1 = new SInc_Other_KPI_Item__c(
            TotalAchievementSetting__c = totAchSettingObj.id,// Total Achievement Setting
            KPIName__c = 'New Revenue',                // KPI Name
            Composition__c = 10                       // Composition
        );
        insert SIncOtherKPIItemobj1;

        SInc_Other_KPI_Item__c SIncOtherKPIItemobj2 = new SInc_Other_KPI_Item__c(
            TotalAchievementSetting__c = totAchSettingObj.id,// Total Achievement Setting
            KPIName__c = 'Gross-Adds Mobile',            
            Composition__c = 10                       // Composition
        );
        insert SIncOtherKPIItemobj2;

        SInc_Other_KPI_Item__c SIncOtherKPIItemobj3 = new SInc_Other_KPI_Item__c(
            TotalAchievementSetting__c = totAchSettingObj.id,// Total Achievement Setting
            KPIName__c = 'Pipeline PO',                // KPI Name
            Composition__c = 20                       // Composition
        );
        insert SIncOtherKPIItemobj3;

        Sales_Incentive_Workspace__c sinWorkspaceOBJ = new Sales_Incentive_Workspace__c();
        sinWorkspaceOBJ.year__c = '2022';
        sinWorkspaceOBJ.quarter__c = 'Q1';
        insert sinWorkspaceOBJ;

        ApexPages.StandardController sc = new ApexPages.StandardController(sinWorkspaceOBJ);
        SalesIncentiveWorkspaceController sinWorkspanceConOBJ = new SalesIncentiveWorkspaceController(sc);
		sinWorkspanceConOBJ.year = sinWorkspaceOBJ.Year__c;
        sinWorkspanceConOBJ.quarter = sinWorkspaceOBJ.Quarter__c;

        sinWorkspanceConOBJ.cloneSettingData();

        Test.stopTest();


    }

    @isTest static void schenario3_Q3Q4() {
        Test.startTest();

        Sales_Incentive_Workspace__c sinWorkspaceOBJ = new Sales_Incentive_Workspace__c();
        sinWorkspaceOBJ.year__c = '2021';
        sinWorkspaceOBJ.quarter__c = 'Q3';
        insert sinWorkspaceOBJ;
        SalesIncentiveWorkspaceController sinWorkspanceConOBJ = new SalesIncentiveWorkspaceController(sinWorkspaceOBJ);

        Sales_Incentive_Workspace__c sinWorkspaceOBJ2 = new Sales_Incentive_Workspace__c(
            Name = 'Sales Incentive Workspace for Q2 2022',               // Name
            Year__c = '2022',                                               // Year
            Quarter__c = 'Q2'                                        // Quarter
           
        );
        insert sinWorkspaceOBJ2;

        sinWorkspanceConOBJ = new SalesIncentiveWorkspaceController(sinWorkspaceOBJ2);

        sinWorkspaceOBJ = new Sales_Incentive_Workspace__c();
        sinWorkspaceOBJ.year__c = '2021';
        sinWorkspaceOBJ.quarter__c = 'Q4';
        insert sinWorkspaceOBJ;

        SInc_Sales_Person_Setting__c sincSalesPerson =  new SInc_Sales_Person_Setting__c(
            Name = 'SETT_PERSON_22Q1_90007857',                                         // SInc Sales Person Setting Name
            //Sales_Person__c = AMobj.id,                                                // Sales Person
            Employee_Id__c = '90007857',                                                  // Employee Id
            Year__c = '2021',                                                             // Year
            unique_id__c = 'SETT_PERSON_22Q1_90007857',                                   // unique id
            Quarter__c = 'Q3',                                                            // Quarter
            Sales_Incentive_Workspace__c = sinWorkspaceOBJ2.id,
            Revenue_Type__c = 'Revenue Total;New Revenue;Pipeline PO;Gross-Adds Mobile'  // Revenue Type
        );
        insert sincSalesPerson;

        sinWorkspanceConOBJ = new SalesIncentiveWorkspaceController(sinWorkspaceOBJ);
    	sinWorkspanceConOBJ.year = sinWorkspaceOBJ.year__c;
        sinWorkspanceConOBJ.quarter =sinWorkspaceOBJ.quarter__c;
        sinWorkspanceConOBJ.cloneSincSalesPersonSetting();


        Test.stopTest();

    }

    @isTest static void schenario4_pipelineData() {
        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.undelete', Is_Active__c=true));
        insert lstTriggerController;
        
        User groupHeadobj=[SELECT id, userroleid FROM User WHERE Profile.Name='Sales Group Head' AND UserRole.Name='Group Head - Key Account Management' AND IsActive=true LIMIT 1];
        User AMobj=[SELECT id, userroleId, employee_id__c FROM user WHERE Profile.Name='Sales' AND UserRole.Name='Banking & Financial Services' AND IsActive=true LIMIT 1];
        User salesManagerobj=[SELECT id, userroleid, employee_id__c FROM User WHERE Profile.Name='Sales Manager' AND UserRole.Name='Head - Banking & Financial Services' AND IsActive=true LIMIT 1];

        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMGSObj;

        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMObj;

        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprMObj;
        

        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services', // Segment Name
            Group_Segment_Name__c = 'LE', // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services' // Unique_ID
        );
        insert segmentObj;

        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'Connectivity Mobile', // Group Service Name
            Unique_ID__c = 'Connectivity Mobile', // Unique ID
            Type__c = 'BAU' // Type
        );
        insert groupServiceObj;

        Sales_Performance_Monthly_AM__c sprAMobjs = new Sales_Performance_Monthly_AM__c(
            Name = 'SPR_2101_90002724', // Name
            Period_Date__c = date.newInstance(2021, 01, 01), // Period Date
            Year__c = '2021', // Year
            Month__c = '1', // Month
            Group_Head__c = groupHeadobj.id, // Group Head
            Sales_Manager__c = salesManagerobj.id, // Sales Manager
            AM__c = AMobj.id // AM,
        );
        insert sprAMobjs;
        system.debug('hasil sprAMobjs*' + sprAMobjs);

        id accRecType = Schema.SObjectType.account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        // === parent account  ====
          Account AccParentObj = new Account(
          Name = 'PT Bank CIMB Niaga Tbk [View Hierarchy]',
          OwnerId = AMobj.id,                                                  // Account Name
          RecordTypeId = accRecType,                                                                          // Account Record Type
          BP_Number__c = '703705',                                                                             // BP Number
          Assign_To__c = AMobj.id,                                                                    // Assign To
          Organization_Type__c = 'Head Office',                                                                // Organization Type
          Type = 'Customer',                                                                                   // Type
          Phone = '021-5460555',                                                                               // Phone
          Unique_Name__c = 'Gd Menara Asia Lt.3(HO)',                                                          // Unique Name
          Keyword__c = 'Kristen Penabur',  
          Customer_Type__c = 'NONGSM',                                                                         // Customer Type
          Payer_For_GSM_Invoice__c = false,                                                                    // Payer For GSM Invoice
          term_of_payment__c = 'Z030 Within 30 Days Due Net',                                                  // Term of Payment
          Company_Group__c = 'CIMB NIAGA',                                                                     // Company_Group
          Customer_VAT_Name__c = 'PT Bank CIMB Niaga Tbk',                                                     // Customer VAT Name
          Summary_Billing__c = false,                                                                          // Summary Billing
          Is_New_Customer__c = false,                                                                          // Is New Customer
          Using_HO_Billing_Address__c = false,                                                                 // Using HO Billing Address
          Relocation_Street_1__c = 'ATM Perum. Taman Narogong Indah Blok A21 No.51A Bekasi (Geser 10 meter)',  // Relocation Street 1
          No_NPWP__c = '013106687091000',
  
          ShippingStreet = 'JL TG DUREN RAYA NO 4 GD BLOK E LT 5 TANJUNG DUREN UTARA - GROGOL PETAMBURAN JAKARTA BARAT'                                                                      // No NPWP
        );
        insert AccParentObj;
  
        // == branch account ===
        Account accObj = new Account(
            Name = 'Yay. Badan Pendidikan Kristen Penabur',                  // Account Name
            RecordTypeId = accRecType,
            OwnerId = AMobj.id,                                       // Account Record Type
            BP_Number__c = '759529',                                           // BP Number
            Assign_To__c = AMobj.id,                                        // Assign To
            Organization_Type__c = 'Head Office',                              // Organization Type
            Type = 'Customer',                                                 // Type
            Website = 'https://bpkpenabur.or.id',                              // Website
            NumberOfEmployees = 50000,                                      // Employees
            Unique_Name__c = 'Kristen Penabur TG Duren',                       // Unique Name
            Keyword__c = 'Kristen Penabur',                                    // Keyword
            Customer_Type__c = 'NONGSM',                                       // Customer Type
            Industry = 'Education',                                            // Industry
            Payer_For_GSM_Invoice__c = false,                                  // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',                // Term of Payment
            Customer_VAT_Name__c = 'Yay. Badan Pendidikan Kristen Penabur',    // Customer VAT Name
            Customer_VAT_Name_2__c = 'Yay. Badan Pendidikan Kristen Penabur',  // Customer VAT Name 2
            Summary_Billing__c = false,                                        // Summary Billing
            Is_New_Customer__c = false,                                        // Is New Customer
            Approval_Status__c = 'Approved',                                   // Approval Status
            Using_HO_Billing_Address__c = false,                               // Using HO Billing Address
            No_NPWP__c = '013878293036000',
            ShippingStreet = 'JL TG DUREN RAYA NO 4 GD BLOK E LT 5 TANJUNG DUREN UTARA - GROGOL PETAMBURAN JAKARTA BARAT'
        );
        insert accObj;
        
        Product2 productObj = new Product2(
            Name = 'DADSPOS-01',                 // Product Name
            Family = 'MOBILE',
            group_service__c = groupServiceObj.id,       
            IsActive = true, // Group Service
            Revenue_Type__c = 'One Time'
        );
        insert productObj;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );

        //custom setting for pipeline 
        AMTopListDetailReport__c reportidList = new AMTopListDetailReport__c();
        reportidList.Name = 'Pipeline';
        reportidList.Value__c = '00ON0000001KYRDMA4';
        insert reportidList;


        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Pricebook2 DADSPOSPricebook = new Pricebook2( name = 'DADSPOS-01',
            IsActive = true
        );
        insert DADSPOSPricebook;

        PricebookEntry DADSPOSPbe = new PricebookEntry(
            Pricebook2Id = DADSPOSPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert DADSPOSPbe;
        
        id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Digital Advertising').getRecordTypeId();
        Opportunity oppObj = new Opportunity(
            RecordTypeId = oppRecType,                          // Opportunity Record Type
            trial__c = false, 
            OwnerId = AMobj.id,                                    // trial
            Service_Group__c = 'GSM',                            // Service Group
            Sales_Manager_Owner__c = salesManagerobj.id,                // Sales Manager Owner
            Name = 'pipeline',                                   // Opportunity Name
            AccountId = AccParentObj.id,                             // Account Name
            CloseDate = Date.newInstance(2021, 01, 01),                // Target Closed Date
            Actual_Closed_Date__c = Date.newInstance (2021, 01, 01),    // Closed Date
            PO_Date__c = Date.newInstance(2021, 01, 01),              // PO Date
            StageName = 'Prospecting',                           // Stage
            Probability = 30,                                    // Probability (%)
            Amount = 6.925,                                      // Amount
            Advertiser_ID__c = 'asd',                            // Advertiser ID
                         // Extend Campaign
            Remark__c = 'Approved',                              // Remark
            BA_Doc_is_uploaded__c = false,                       // BA Doc is uploaded
            Mark_as_Sales_Revenue__c = true,
            Pricebook2id = DADSPOSPricebook.Id ,
            BP_VAT__c = AccParentObj.id              // Mark as Sales Revenue
        );

        insert oppObj;
    
        OpportunityLineItem OppLineObj = new OpportunityLineItem(
            OpportunityId = oppObj.id,                                 // Sales Price
            Product2Id = productObj.id,                      // Product
            Request_QTY__c = 1250,                          // Request QTY.
            quantity = 125000,                             // Quantity
            TotalPrice = 1.250,                                  // Total Price
            Contract_Start_Date__c = Date.newInstance(2021, 01, 01),           // Injection Item
            Contract_End_Date__c = Date.newInstance(2021, 01, 01),    // Contract End Date
            Billing_Type__c = 'Monthly',                         // Billing Type
            Temp_Sales_Price__c = 10.00000,                      // Temp Sales Price
            Mark_as_Revenue_OppProduct__c = true,                // Sales Revenue Rel
            Is_Pipeline__c = true,                              // Is Pipeline
            Is_Pipeline_PO__c = true,                           // Is Pipeline PO
            is_Forecast_Revenue__c = false, 
            PricebookEntryId  = DADSPOSPbe.id
        
        );
        insert OppLineObj;

        oppObj.Campaign_Start_Date__c = Date.newInstance(2021, 01, 01);  // Campaign Start Date
        oppObj.Advertiser_Name__c = 'asd';                          // Advertiser Name
        oppObj.Campaign_End_Date__c = Date.newInstance(2021, 01, 01);    // Campaign End Date
        oppObj.Connection_Type__c = 'API' ;                         // Connection Type
        oppObj.Extend_Campaign__c = false;        
        oppObj.stageName = 'Negotiatoin';
        update oppObj;  

        
        id StrRecType = Schema.SObjectType.Sales_target__c.getRecordTypeInfosByName().get('Target Pipeline PO').getRecordTypeId();
        Sales_Target__c strObj1 = new Sales_Target__c(
            Name = 'STR_2110_90006125_PipelinePO',          // Sales Target Name
            RecordTypeId = StrRecType,                       // Record Type
            Type__c = 'Target Pipeline PO',                   // Type
            Year__c = '2021',                                 // Year
            Month__c = '1',                                  // Month
            Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id,  // Sales Performance Monthly AMGS
            Sales_Performance_Monthly_AM__c = sprM_AMObj.id,    // Sales Performance Monthly AM
            Amount__c = 259.551,                              // Amount
            AM_Employee_ID__c = '90006125'                      // AM Employee ID
        );
        insert strObj1;
        
        Sales_Incentive_Workspace__c siwObj = new Sales_Incentive_Workspace__c(
            Name = 'Sales Incentive for Q1 2021', // Name
            Year__c = '2021', // Year
            Quarter__c = 'Q1', // Quarter
            mode_data__c = 'auto calculate'
        );
        insert siwObj;

        Sales_Incentive__c sincobj = new Sales_Incentive__c(
            Name = 'SIN_21Q1_AM_90002724_New Revenue', // Sales Incentive Name
           // RecordTypeId = RecTypeId, // Record Type
            Year__c = '2021', // Year
            Sales_Incentive_Workspace__c = siwObj.id, // Sales Incentive Workspace
            Quarter__c = 'Q1', // Quarter
            Period_Date__c = Date.newInstance(2021, 07, 05), // Period Date
            Sales_Person__c = AMobj.id, // Sales Person
            sales_manager__c = salesManagerobj.id,
            group_head__c = groupHeadobj.id,
            isUsed__c = true,
            segment__c = SegmentObj.id,
            Group_Segment__c = 'LE', // Group Segment
            Role_Level__c = 'AM', // Role Level
            Type__c = 'Pipeline PO', // Type
            Achievement__c = 0.00, // Achievement
            Target__c = 240091444, // Target
            Weighted__c = 15.00, // Weighted
            Actual__c = 210091444, // Actual
            Unique_ID__c = 'SIN_21Q1_AM_90002724_New_Revenue' // Unique ID
        );
        system.debug('sincobj ==' + sincobj);

          // sales target 
          id strRecTypeId = Schema.SObjectType.Sales_target__c.getRecordTypeInfosByName().get('Target Pipeline PO').getRecordTypeId();
          Sales_Target__c strobj = new Sales_Target__c(
              Name = 'STR_2101_90007138_Managed IT-Data Center_pipelinepo', // Name
              RecordTypeId = strRecTypeId, // Record Type
              Year__c = '2021', // Year
              Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id, // Sales Performance Monthly AMGS
              Month__c = '1', // Month
              AM__c = AMobj.id, // AM
              Period_date__c = Date.newInstance(2021, 01, 01), // Period date
              Group_Service__c = groupServiceObj.id, // Group Service
              Amount__c = 31141, // Amount
              Type__c = 'Target Pipeline PO', // Type
              Group_Service_Type__c = 'New Revenue', // Group Service Type
              Sales_Performance_Monthly_AM__c = sprM_AMObj.id, // Sales Performance Monthly AM
              Segment__c = SegmentObj.id, // Segment
              Sales_Manager__c = salesManagerobj.id, // Sales Manager
              Group_Head__c = groupHeadobj.id, // Group Head
              AM_Employee_ID__c = AMobj.employee_id__c, // AM Employee ID
              Group_Service_Name__c = 'Managed IT-Data Center', // Group Service Name
  
              Unique_ID__c = 'STR_2101_90007138_Managed IT-Data Center_pipelinepo' // Unique_ID
          );
          system.debug('strobj ==' + strobj);
          insert strobj;
        
        insert sincobj;
			Sinc_Weighted_Setting__c weightedSincObj = new Sinc_Weighted_Setting__c(
         	Name = 'SETT_Weighted_2022Q1_ALL LE_Gross-Adds Fixed Links_AM',        // Sales Incentive Weighted Name
            Sales_Incentive_Workspace__c = siwObj.id,                              // Sales Incentive Workspace
            Revenue_Type__c = 'Gross-Adds Fixed Links',                              // Revenue Type
            Unique_ID__c = 'SETT_Weighted_2022Q1_ALL LE_Gross-Adds Fixed Links_AM',  // Unique ID
            Weighted__c = 5.00,                                                      // Weighted
            Segment__c = SegmentObj.id,                                                // Segment
            Role_Level__c = 'AM' 
        
        );
        insert weightedSincObj;

        Sinc_Revenue_Data_Source_Setting__c datasourceobj = new Sinc_Revenue_Data_Source_Setting__c( 
            Revenue_Type__c = 'Pipeline PO',    // Revenue Type
            SOQL_Type__c = 'SEPARATE', // SOQL Type
            Is_Active__c = true,   // Is Active
            
            Target_SOQL_AM__c = 'SELECT  segment__r.group_segment_name__c groupSegmentName, segment__r.name segmentName, segment__c segmentSFID,  AM__r.name userName, AM__r.employee_id__c employeeID, AM__r.id userSFID,  AM__r.IsActive userIsActive,  AM__r.managerId managerSFID, AM__r.manager.IsActive managerIsActive, AM__r.manager.managerId managerManagerSFID, AM__r.manager.manager.IsActive managerManagerIsActive, sales_manager__c salesManagerId, group_head__c groupHeadId,  sum(Target_Pipeline_PO__c) target  FROM sales_performance_Monthly_am__c  WHERE year__c = :year AND month__c in :months AND segment__c <> NULL  GROUP BY segment__r.group_segment_name__c, segment__r.name, segment__c, AM__r.name, AM__r.employee_id__c, AM__r.id, AM__r.IsActive,  AM__r.managerId, AM__r.manager.IsActive, AM__r.manager.managerId, AM__r.manager.manager.IsActive, sales_manager__c, group_head__c',  // Target SOQL AM

            Target_SOQL_SM__c = 'SELECT  Sales_Manager__r.name userName, Sales_Manager__r.employee_id__c employeeID, Sales_Manager__r.userrole.name roleName, Sales_Manager__r.id userSFID,  Sales_Manager__r.IsActive userIsActive,  Sales_Manager__r.managerId managerSFID, Sales_Manager__r.manager.IsActive managerIsActive, Sales_Manager__r.manager.managerId managerManagerSFID, Sales_Manager__r.manager.manager.IsActive managerManagerIsActive, group_head__c groupHeadId,  sum(target__C) target  FROM sales_incentive__c  WHERE  year__c = :year  AND quarter__c = :quarter AND segment__c <> NULL and isused__c = true and type__c = \'Pipeline PO\' AND Sales_Manager__r.employee_id__c <> NULL AND Sales_Manager__r.userrole.name like \'Head - %\'  GROUP BY  Sales_Manager__r.name, Sales_Manager__r.employee_id__c, Sales_Manager__r.userrole.name, Sales_Manager__r.id, Sales_Manager__r.IsActive,  Sales_Manager__r.managerId, Sales_Manager__r.manager.IsActive, Sales_Manager__r.manager.managerId, Sales_Manager__r.manager.manager.IsActive, group_head__c',        // Target SOQL SM
            
            Target_SOQL_GH__c = 'SELECT Group_Head__r.name userName, Group_Head__r.employee_id__c employeeID, Group_Head__r.userrole.name roleName, Group_Head__r.id userSFID,  Group_Head__r.IsActive userIsActive,  Group_Head__r.managerId managerSFID, Group_Head__r.manager.IsActive managerIsActive, Group_Head__r.manager.managerId managerManagerSFID, Group_Head__r.manager.manager.IsActive managerManagerIsActive,  sum(target__c) target  FROM sales_incentive__c  WHERE  year__c = :year AND quarter__c = :quarter AND Group_Head__c <> null and isused__c = true and type__c = \'pipeline po\' AND segment__r.group_segment_name__c <> null AND Group_Head__r.userrole.name like \'Group Head - %\'  GROUP BY  Group_Head__r.name, Group_Head__r.employee_id__c, Group_Head__r.userrole.name, Group_Head__r.id, Group_Head__r.IsActive,  Group_Head__r.managerId, Group_Head__r.manager.IsActive, Group_Head__r.manager.managerId, Group_Head__r.manager.manager.IsActive',  // Target SOQL GH
  
            Actual_SOQL_AM__c = 'SELECT  ownerid userSFID, owner.IsActive userIsActive, owner.managerId managerSFID, owner.manager.IsActive managerIsActive, owner.manager.managerId managerManagerSFID, owner.manager.manager.IsActive managerManagerIsActive, owner.name userName, owner.employee_id__c employeeID, owner.userrole.name roleName, Sales_Manager_Owner__c salesManagerId, GM_Sales_of_Owner__c groupHeadId,  sum(amount) actual  FROM opportunity  WHERE ( ( Actual_Closed_Date_Year__c= :year AND Actual_Closed_Date_Quarter__c= :quarter )  OR ( Actual_Closed_Date_Year__c= :nextQuarterYear AND Actual_Closed_Date_Quarter__c= :nextQuarterQuarter ) )  AND Is_Pipeline_PO__c = TRUE AND createdDate <= :quarterEndDate AND (owner.employee_id__c <> null OR owner.employee_id__c <> \'\')   GROUP BY  owner.name, owner.employee_id__c, owner.userrole.name, ownerid , owner.IsActive , owner.managerId , owner.manager.IsActive , owner.manager.managerId , owner.manager.manager.IsActive,  Sales_Manager_Owner__c, GM_Sales_of_Owner__c', // Actual SOQL AM
  
            Actual_SOQL_SM__c = 'SELECT  Sales_Manager__r.name userName, Sales_Manager__r.employee_id__c employeeID, Sales_Manager__r.userrole.name roleName, Sales_Manager__r.id userSFID,  Sales_Manager__r.IsActive userIsActive,  Sales_Manager__r.managerId managerSFID, Sales_Manager__r.manager.IsActive managerIsActive, Sales_Manager__r.manager.managerId managerManagerSFID, Sales_Manager__r.manager.manager.IsActive managerManagerIsActive, group_head__c groupHeadId,  sum(actual__c) actual  FROM sales_incentive__c  WHERE  year__c = :year AND quarter__c = :quarter AND segment__c <> NULL and isused__c = true and type__c = \'Pipeline PO\' AND Sales_Manager__r.employee_id__c <> NULL AND Sales_Manager__r.userrole.name like \'Head - %\'  GROUP BY  Sales_Manager__r.name, Sales_Manager__r.employee_id__c, Sales_Manager__r.userrole.name, Sales_Manager__r.id, Sales_Manager__r.IsActive,  Sales_Manager__r.managerId, Sales_Manager__r.manager.IsActive, Sales_Manager__r.manager.managerId, Sales_Manager__r.manager.manager.IsActive, group_head__c', // Actual SOQL SM
  
            Actual_SOQL_GH__c = 'SELECT  Group_Head__r.name userName, Group_Head__r.employee_id__c employeeID, Group_Head__r.userrole.name roleName, Group_Head__r.id userSFID,  Group_Head__r.IsActive userIsActive,  Group_Head__r.managerId managerSFID, Group_Head__r.manager.IsActive managerIsActive, Group_Head__r.manager.managerId managerManagerSFID, Group_Head__r.manager.manager.IsActive managerManagerIsActive,  sum(actual__c) actual  FROM sales_incentive__c  WHERE  year__c = :year AND quarter__c = :quarter AND Group_Head__c <> null and isused__c = true and type__c = \'pipeline PO\' AND segment__r.group_segment_name__c <> null AND Group_Head__r.userrole.name like \'Group Head - %\'  GROUP BY  Group_Head__r.name, Group_Head__r.employee_id__c, Group_Head__r.userrole.name, Group_Head__r.id, Group_Head__r.IsActive,  Group_Head__r.managerId, Group_Head__r.manager.IsActive, Group_Head__r.manager.managerId, Group_Head__r.manager.manager.IsActive'  // Actual SOQL GH
        );
        insert datasourceobj;

        system.debug(' ==  datasourceobj: ' +  datasourceobj);

        
        Test.startTest();

        oppObj.StageName = 'Implementation';
        oppObj.Probability = 50;
        update oppObj;

        system.debug ('=== opportunity data : '+ [select id, name, stagename, target_close_date_year__c, target_close_date_quarter__c, Is_Pipeline_PO__c from opportunity where id = :oppObj.id] );

        // List<Sales_Target__c> stList = [select id, name, year__c, month__c, segment__c, Sales_Performance_Monthly_AM__c from  Sales_Target__c];
        // List<Sales_Performance_Monthly_AM__c> sprList = [select id, name, year__c, month__c, segment__c, Target_Pipeline_PO__c from  Sales_Performance_Monthly_AM__c where id = :stList[0].Sales_Performance_Monthly_AM__c];

        
        ApexPages.StandardController sc = new ApexPages.StandardController(siwObj);
        SalesIncentiveWorkspaceController sinWorkspanceConOBJ = new SalesIncentiveWorkspaceController(sc);
		sinWorkspanceConOBJ.year = siwObj.year__c;
        sinWorkspanceConOBJ.quarter = siwObj.quarter__c;
        sinWorkspanceConOBJ.putRevenueData();
        sinWorkspanceConOBJ.putRevenueDataSMGH();
 		sinWorkspanceConOBJ.putWeightedData();
        sinWorkspanceConOBJ.putTotalAchievementData();
        
	//	sinWorkspanceConOBJ.putTotalAchievementData();
  		
        
        Test.stopTest();
    }

}