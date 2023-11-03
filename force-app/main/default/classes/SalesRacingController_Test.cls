@isTest
public class SalesRacingController_Test {
    
    @isTest static void testSrcRevenue(){
        
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
        
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2020', month__c = '2');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2020', month__c = '2');
        insert sprM_AMObj;
        
        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2020', month__c = '2');
        insert sprMObj;
        
        
        
        // == user group head ====
        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'iqbals',                                                              // Alias
            Email = 'iqbals@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'iqbals@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '90007812',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'iqbals',
            LastName='junior',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        
        // ==== set user Sales manager =====
        
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'sudi',                                                            // Alias
            Email = 'sudi@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'sudi@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003712',                                               // Employee ID
            firstName = 'sukosulistiyo',
            LastName='sudi'
        );
        insert salesManagerobj;
        
        // == create user Account manager ==
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User AMobj = new User(                                              // Role
            Alias = 'ngebut',
            EmailEncodingKey='UTF-8',
            Email = 'ngebut@xl.co.id',                                                   // Email
            ProfileId = AMProfile.id,                                                     // Profile
            Username = 'ngebut@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002724',                                                 // Employee ID
            Sales_Group_Head__c = '0057F000005Tjc5',                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'ngebut',
            LastName='banged'
        );
        insert AMobj;
        
        
        id accRecType = Schema.SObjectType.account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        // === parent account  ====
        Account AccParentObj = new Account(
            Name = 'PT Bank CIMB Niaga Tbk [View Hierarchy]',                                                  // Account Name
            RecordTypeId = accRecType,                                                                          // Account Record Type
            BP_Number__c = '703705',                                                                             // BP Number
            Assign_To__c = '0057F000001r4el',                                                                    // Assign To
            Organization_Type__c = 'Head Office',                                                                // Organization Type
            Type = 'Customer',                                                                                   // Type
            Phone = '021-5460555',                                                                               // Phone
            Unique_Name__c = 'Gd Menara Asia Lt.3(HO)', 
            Keyword__c = 'TEKPEI',                                                         // Unique Name
            Customer_Type__c = 'NONGSM',                                                                         // Customer Type
            Payer_For_GSM_Invoice__c = false,                                                                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',                                                  // Term of Payment
            Company_Group__c = 'CIMB NIAGA',                                                                     // Company_Group
            Customer_VAT_Name__c = 'PT Bank CIMB Niaga Tbk',                                                     // Customer VAT Name
            Summary_Billing__c = false,                                                                          // Summary Billing
            Is_New_Customer__c = false,                                                                          // Is New Customer
            Using_HO_Billing_Address__c = false,                                                                 // Using HO Billing Address
            Relocation_Street_1__c = 'ATM Perum. Taman Narogong Indah Blok A21 No.51A Bekasi (Geser 10 meter)',  // Relocation Street 1
            No_NPWP__c = '013106687091000'                                                                      // No NPWP
        );
        insert AccParentObj;
        
        // == branch account ===
        Account accObj = new Account(
            Name = 'PT Bank CIMB Niaga Tbk [View Hierarchy]',  // Account Name
            RecordTypeId = accRecType,                          // Account Record Type
            BP_Number__c = '710124',                             // BP Number
            Organization_Type__c = 'Branch',                     // Organization Type
            Type = 'Customer',                                   // Type
            ParentId = AccParentObj.id,   
            Unique_Name__c = 'Jakarta Menara Asia Lt.10',  
            Keyword__c = 'TEKPEI',       // Unique Name
            Customer_Type__c = 'NONGSM',                         // Customer Type
            Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
            Company_Group__c = 'CIMB NIAGA',                     // Company_Group
            Customer_VAT_Name__c = 'PT Bank CIMB Niaga Tbk',     // Customer VAT Name
            Summary_Billing__c = false,                          // Summary Billing
            Is_New_Customer__c = false,                          // Is New Customer
            Using_HO_Billing_Address__c = false                 // Using HO Billing Address
        );
        insert accObj;
        
        
        // == create sales racing revenue ===
        
        sales_racing__c srcRevObj = new Sales_racing__c (
            
            name = 'racing 01',
            data_source__C = 'Revenue',
            period_start_date__c = date.newInstance(2020, 01, 01),
            period_end_date__c = date.newInstance(2020, 03, 30),
            As_of_Date__c = Datetime.newInstance(2020,1,30,11,10,10),
            Group_services__c = 'Connectivity Mobile',          
            Revenue_Category__c = 'BES' 
        ); 
        insert srcRevObj;
        
        //custom setting for revenue 
        AMTopListDetailReport__c reportidList = new AMTopListDetailReport__c();
        reportidList.Name = 'Revenue';
        reportidList.Value__c = '00ON0000001KYRDMA4';
        insert reportidList;
        
        // == create group service ==
        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'Connectivity Mobile',                  // Group Service Name
            Unique_ID__c = 'Connectivity Mobile',            // Unique ID
            Type__c = 'BAU'                  // Type
        );
        insert groupServiceObj;
        
        // == create revenue category ==
        Revenue_Category__c revCatobj = new Revenue_Category__c(
            Name = 'BES',                // Name
            Group_Service__c = groupServiceObj.id,  // Group Service
            Full_Name__c = 'BES'          // Full Name
        );
        insert revCatobj;
        
        
        // == create segment ==
        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services',        // Segment Name
            Group_Segment_Name__c = 'LE',                   // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services'  // Unique_ID
        );
        insert segmentObj;
        
        //== create sales performance amgs ====
        Sales_Performance_Monthly_AMGS__c sprAMGSobj = new Sales_Performance_Monthly_AMGS__c(
            Name = 'SPR_2001_90002724_FIXED',           // Name
            Period_Date__c = date.newInstance(2020, 01, 01),  // Period Date
            Year__c = '2020',                             // Year
            Group_Service_Type__c = groupServiceObj.Type__c,                // Group Service Type
            Group_Service__c = groupServiceObj.id,         // Group Service
            Month__c = '1',                               // Month
            Group_Head__c = groupHeadobj.id,            // Group Head
            Segment__c = SegmentObj.id,               // Segment
            Sales_Manager__c = salesManagerobj.id,         // Sales Manager
            AM__c = AMobj.id                   // AM
        );
        insert sprAMGSobj;
        system.debug('hasil sprAMGSobj*' + sprAMGSobj );
        //=== create sales performance am ===
        Sales_Performance_Monthly_AM__c sprAMobj = new Sales_Performance_Monthly_AM__c(
            Name = 'SPR_2001_90002724',                 // Name
            Period_Date__c = date.newInstance(2020, 01, 01),  // Period Date
            Year__c = '2020',                             // Year
            Month__c = '1',                               // Month
            AM__c = AMobj.id,                    // AM
            Segment__c = SegmentObj.id,               // Segment
            Sales_Manager__c = salesManagerobj.id,         // Sales Manager
            Group_Head__c = groupHeadobj.id            // Group Head
        );
        insert sprAMobj;
        
        //== create actual sales revenue 
        id RecType = Schema.SObjectType.sales_revenue__c.getRecordTypeInfosByName().get('Actual Revenue').getRecordTypeId();
        
        Sales_Revenue__c srvActObj = new Sales_Revenue__c(
            
            Name = 'SRV_2001_90002724_Revenue - BES_90002724_ActualRevenue',// Sales Revenue Name
            Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id,                         // Sales Performance Monthly AMGS
            Period_Date__c = date.newInstance(2020, 02, 01),                             // Period Date
            Sales_Performance_Monthly_AM__c = sprM_AMObj.id,  
            AM_Employee_ID__c = '90002724',                     // Sales Performance Monthly AM
            Year__c = '2020',                                                        // Year
            Month__c = '2',                                                          // Month
            Type__c = 'Actual Revenue',                                              // Type
            Revenue_Category_Name__c = 'BES',
            group_service__C = revCatobj.group_service__c,                                      // Revenue Category
            Amount__c = 7.000,                                                       // Amount
            Customer_BP_No__c = accObj.BP_Number__c         
        );
        insert srvActObj;   
        system.debug('srvActObj *jadi berapa ?*' + srvActObj);
        
        //// create am toplist 
        AM_Top_List__c amTopobj = new AM_Top_List__c(
            Name = '01.' + AMobj.name,// Name
            Sales_Racing__c = srcRevObj.id,  // Sales Racing
            AM__c = AMobj.id,            // AM
            Amount__c = 114.973            // Amount
        );
        insert amTopobj; 
        
        
        
        test.startTest();
        
        SalesRacingController srcControllerRC = new SalesRacingController(srcRevObj);
        srcControllerRC.generateAMTopList();
        srcControllerRC.saveAMTopList();
        
        test.stopTest();
        /*
test.startTest();
ApexPages.StandardController sc = new ApexPages.StandardController(srcRevObj);
SalesRacingReportController SalesRacingReportControllerObj = new SalesRacingReportController(sc);
SalesRacingReportControllerObj.getGroupServiceName();
SalesRacingReportControllerObj.revGroupServiceSelected = new List<String>();
SalesRacingReportControllerObj.revGroupServiceSelected.add('Connectivity MOBILE');
SalesRacingReportControllerObj.getRevenueCategories();
SalesRacingReportControllerObj.revCategoryNameSelected = new List<String>();
SalesRacingReportControllerObj.revCategoryNameSelected.add('BES');
SalesRacingReportControllerObj.viewDatatopAMData();
SalesRacingReportControllerObj.addRecordAMTopList();
test.stopTest();
*/ 
        
        
    }
    
    
    
    @isTest static void testRcSubscribeChurn(){
        
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
        
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprM_AMObj;
        
        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprMObj;
        
        // == user group head ====
        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'ternak',                                                              // Alias
            Email = 'ternak@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'ternak@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '90007812',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'ternak',
            LastName='kambing',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        
        // ==== set user Sales manager =====
        
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'bapak',                                                            // Alias
            Email = 'bapak@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'bapak@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003755',                                               // Employee ID
            firstName = 'bapak',
            LastName='budi'
        );
        insert salesManagerobj;
        
        // == create user Account manager ==
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User AMobj = new User(                                              // Role
            Alias = 'suci',
            EmailEncodingKey='UTF-8',
            Email = 'suci@xl.co.id',                                                   // Email
            ProfileId = AMProfile.id,                                                     // Profile
            Username = 'suci@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002723',                                                 // Employee ID
            Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'suci',
            LastName='banged'
        );
        insert AMobj;
        
        id recTypeSubs = Schema.SObjectType.sales_racing__c.getRecordTypeInfosByName().get('Subscribe').getRecordTypeId();
        sales_racing__c srcSubsObj = new Sales_racing__c (
            
            name = 'subs racing 01',
            data_source__C = 'Subscribe',
            recordTypeId = recTypeSubs,
            period_start_date__c = date.newInstance(2020, 01, 01),
            period_end_date__c = date.newInstance(2020, 03, 01),
            As_of_Date__c = Datetime.newInstance(2020,1,30,11,10,10),
            Service__c = 'POST',          
            Group_Price_Plans__c = 'BIZ' 
            
        ); 
        insert srcSubsObj; 
        
        //custom setting for subscribe 
        AMTopListDetailReport__c reportidList = new AMTopListDetailReport__c();
        reportidList.Name = 'Subscribe';
        reportidList.Value__c = '00ON0000001KYRDMA4';
        insert reportidList;
        
        // == create segment ==
        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services',        // Segment Name
            Group_Segment_Name__c = 'LE',                   // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services'  // Unique_ID
        );
        insert segmentObj;
        
        Sales_Performance_Monthly_AMGS__c sprAMGSobj = new Sales_Performance_Monthly_AMGS__c(
            Name = 'SPR_2001_90002724',           // Name
            Period_Date__c = date.newInstance(2020, 01, 01),  // Period Date
            Year__c = '2020',                             // Year
            Month__c = '1',                               // Month
            Group_Head__c = groupHeadobj.id,            // Group Head
            Segment__c = SegmentObj.id,               // Segment
            Sales_Manager__c = salesManagerobj.id,         // Sales Manager
            AM__c = AMobj.id                   // AM
        );
        insert sprAMGSobj;
        system.debug('hasil sprAMGSobj*' + sprAMGSobj );
        /*
//=== create sales performance am ===
Sales_Performance_Monthly_AM__c sprAMobj = new Sales_Performance_Monthly_AM__c(
Name = 'SPR_2001_90002724',                 // Name
Period_Date__c = date.newInstance(2021, 01, 01),  // Period Date
Year__c = '2020',                             // Year
Month__c = '1',                               // Month
AM__c = AMobj.id,                    // AM
Segment__c = SegmentObj.id,               // Segment
Sales_Manager__c = salesManagerobj.id,         // Sales Manager
Group_Head__c = groupHeadobj.id            // Group Head
);
insert sprAMobj;
*/
        id RecTypeSubsGross = Schema.SObjectType.sales_revenue__c.getRecordTypeInfosByName().get('Subscribe Gross Add').getRecordTypeId();
        
        Sales_revenue__c srvSubsChurnObj = new sales_revenue__c(
            
            Name = 'SRV_2001_90002724_Postpaid_POST_Pro Prio__SubscribeChurn',// Sales Revenue Name
            Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id,                    // Sales Performance Monthly AMGS
            Period_Date__c = date.newInstance(2020, 01, 01),                        // Period Date
            Sales_Performance_Monthly_AM__c = sprM_AMObj.id,                      // Sales Performance Monthly 
            Year__c = '2020',                                                   // Year
            Month__c = '1',                                                      // AM
            RecordTypeId = RecTypeSubsGross,                                         // Record Type
            Type__c = 'Subscribe Gross Add',                                        // Type
            Quantity__c = 1,                                                  // Quantity
            Subscription_Type__c = 'Postpaid',                                  // Subscription Type
            Group_Price_Plan__c = 'BIZ',                                   // Group Price Plan
            Service__c = 'POST',                                                // Service
            AM_Employee_ID__c = '90002724'                                     // AM Employee ID
            
        );
        
        insert srvSubsChurnObj;
        
        //// create am toplist 
        AM_Top_List__c amTopobj = new AM_Top_List__c(
            Name = '01. Goval Napitupulu',// Name
            Sales_Racing__c = srcSubsObj.id,  // Sales Racing
            AM__c = AMobj.id,            
            quantity__c = 114            // Amount
        );
        insert amTopobj; 
        
        test.startTest();
        
        SalesRacingController srcControllerRC = new SalesRacingController(srcSubsObj);
        srcControllerRC.generateAMTopList();
        srcControllerRC.saveAMTopList();
        test.stopTest();
        /*      


test.startTest();
ApexPages.StandardController SubsSc = new ApexPages.StandardController(srcSubsObj);
SalesRacingReportController SalesRacingSubsReportControllerObj = new SalesRacingReportController(SubsSc);
SalesRacingSubsReportControllerObj.serviceSelected = new List <String>();
SalesRacingSubsReportControllerObj.serviceSelected.add('POST');     

SalesRacingSubsReportControllerObj.getGroupPricePlan();
SalesRacingSubsReportControllerObj.groupPricePlanSelected = new List <String>();
SalesRacingSubsReportControllerObj.groupPricePlanSelected.add('BIZ');
SalesRacingSubsReportControllerObj.viewDatatopAMData();
SalesRacingSubsReportControllerObj.addRecordAMTopList();
test.stopTest();
*/
        
        
    }
    
    @isTest static void testRcLink(){
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
        
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprM_AMObj;
        
        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprMObj;
        
        
        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'ahmad',                                                              // Alias
            Email = 'ahmad@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'ahmad@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '900078723',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'ahmad',
            LastName='murti',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        
        // ==== set user Sales manager =====
        
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'ngibrit',                                                            // Alias
            Email = 'ngibrit@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'ngibrit@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003712',                                               // Employee ID
            firstName = 'ngibrit',
            LastName='banget'
        );
        insert salesManagerobj;
        
        // == create user Account manager ==
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User AMobj = new User(                                              // Role
            Alias = 'lenovo',
            EmailEncodingKey='UTF-8',
            Email = 'lenovo@xl.co.id',                                                   // Email
            ProfileId = AMProfile.id,                                                     // Profile
            Username = 'lenovo@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002732',                                                 // Employee ID
            Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'lenovo',
            LastName='ayee'
        );
        insert AMobj;
        
        id recTypeLink = Schema.SObjectType.sales_racing__c.getRecordTypeInfosByName().get('Link').getRecordTypeId();
        sales_racing__c LinkRcObj = new sales_racing__c(
            
            name = 'racing 03',
            data_source__C = 'Link',
            recordTypeId = recTypeLink,
            period_start_date__c = date.newInstance(2020, 01, 01),
            period_end_date__c = date.newInstance(2020, 03, 01),
            link_service_type__c = 'L2VPN'
            
        );
        insert LinkRcObj;
        
        //custom setting for Link 
        AMTopListDetailReport__c reportidList = new AMTopListDetailReport__c();
        reportidList.Name = 'Link';
        reportidList.Value__c = '00ON0000001KYRDMA4';
        insert reportidList;
        
        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services',        // Segment Name
            Group_Segment_Name__c = 'LE',                   // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services'  // Unique_ID
        );
        insert segmentObj;
        
        Sales_Performance_Monthly_AMGS__c sprAMGSobj = new Sales_Performance_Monthly_AMGS__c(
            Name = 'SPR_2001_90002724',           // Name
            Period_Date__c = date.newInstance(2020, 01, 01),  // Period Date
            Year__c = '2020',                             // Year
            Month__c = '1',                               // Month
            Group_Head__c = groupHeadobj.id,            // Group Head
            Segment__c = SegmentObj.id,               // Segment
            Sales_Manager__c = salesManagerobj.id,         // Sales Manager
            AM__c = AMobj.id                   // AM
            
        );
        insert sprAMGSobj;
        system.debug('hasil sprAMGSobj*' + sprAMGSobj );
        //=== create sales performance am ===
        Sales_Performance_Monthly_AM__c sprAMobj = new Sales_Performance_Monthly_AM__c(
            Name = 'SPR_2001_90002724',                 // Name
            Period_Date__c = date.newInstance(2021, 01, 01),  // Period Date
            Year__c = '2020',                             // Year
            Month__c = '1',                               // Month
            AM__c = AMobj.id,                    // AM
            Segment__c = SegmentObj.id,               // Segment
            Sales_Manager__c = salesManagerobj.id,         // Sales Manager
            Group_Head__c = groupHeadobj.id            // Group Head
        );
        insert sprAMobj;
        
        id RecTypeLinkGross = Schema.SObjectType.sales_revenue__c.getRecordTypeInfosByName().get('Link Gross Add').getRecordTypeId();
        
        Sales_revenue__c srvLinkChurnObj = new sales_revenue__c(
            
            Name = 'SRV_2107_90007477_714813_L2VPN_LinkChurn_PT. Artha Tunggal Mandiri',// Sales Revenue Name
            Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id,                    // Sales Performance Monthly AMGS
            Period_Date__c = date.newInstance(2020, 01, 01),                        // Period Date
            Sales_Performance_Monthly_AM__c = sprM_AMObj.id,                      // Sales Performance Monthly 
            Year__c = '2020',                                                   // Year
            Month__c = '1',                                                      // AM
            RecordTypeId = RecTypeLinkGross,                                         // Record Type
            Type__c = 'Link Gross Add',                                        // Type
            Quantity__c = 1,                                                  // Quantity
            link_service_type__c = 'L2VPN',                                              // Service
            AM_Employee_ID__c = '90002724'                                     // AM Employee ID
            
        );
        
        insert srvLinkChurnObj;
        
        test.startTest();
        
        SalesRacingController srcControllerRC = new SalesRacingController(LinkRcObj);
        srcControllerRC.generateAMTopList();
        test.stopTest();
        /*
test.startTest();

ApexPages.StandardController LinkSc = new ApexPages.StandardController(LinkRcObj);
SalesRacingReportController SalesRacingSubsReportControllerObj = new SalesRacingReportController(LinkSc);
SalesRacingSubsReportControllerObj.linkServiceTypeSelected = new List<String>();
SalesRacingSubsReportControllerObj.linkServiceTypeSelected.add('L2VPN');
SalesRacingSubsReportControllerObj.viewDatatopAMData();
SalesRacingSubsReportControllerObj.addRecordAMTopList();

test.stopTest();
*/
    }
    
    
    @isTest static void testRcPipeline(){
        
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
        
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMObj;
        
        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprMObj;
        
        //CUSTOM SETTING DEFAULT ID SPRamgs
        Sales_Performance_General__c sprAMGSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AMGS_DEFAULT_SFID', format__c='string', value__c =sprM_AMGSObj.id);
        insert sprAMGSettingObj;
        
        Sales_Performance_General__c sprAMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AM_DEFAULT_SFID', format__c='string', value__c =sprM_AMObj.id);
        insert sprAMSettingObj;
        
        Sales_Performance_General__c sprMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_DEFAULT_SFID', format__c='string', value__c =sprMObj.id);
        insert sprMSettingObj;
        
        
        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'dara',                                                              // Alias
            Email = 'dara@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'dara@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '90007843',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'dara',
            LastName='muda',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        
        // ==== set user Sales manager =====
        
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'merry',                                                            // Alias
            Email = 'merry@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'merry@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003754',                                               // Employee ID
            firstName = 'merry',
            LastName='you'
        );
        insert salesManagerobj;
        
        // == create user Account manager ==
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User AMobj = new User(                                              // Role
            Alias = 'kita',
            EmailEncodingKey='UTF-8',
            Email = 'kita@xl.co.id',                                                   // Email
            ProfileId = AMProfile.id,                                                     // Profile
            Username = 'kita@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002724',                                                 // Employee ID
            Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'kita',
            LastName='bisa'
        );
        insert AMobj;
        
        id recTypePipeline = Schema.SObjectType.sales_racing__c.getRecordTypeInfosByName().get('Pipeline').getRecordTypeId();
        sales_racing__c oppProdRcObj = new sales_racing__c(
            
            name = 'racing 03',
            data_source__C = 'Pipeline',
            recordTypeId = recTypePipeline,
            period_start_date__c = date.newInstance(2019, 01, 01),
            period_end_date__c = date.newInstance(2020, 03, 30),
            Stages__c = 'Prospecting',                          
            Group_services__c = 'MOBILE',
            Product_Name__c = 'DADSPOS-01'
            
        );
        insert oppProdRcObj;
        
        //==== create group service ===
        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'MOBILE',                  // Group Service Name
            Unique_ID__c = 'MOBILE',            // Unique ID
            Type__c = 'BAU'                  // Type
        );
        insert groupServiceObj;
        
        // == create revenue category ==
        Revenue_Category__c revCatobj = new Revenue_Category__c(
            Name = 'BES',                // Name
            Group_Service__c = groupServiceObj.id,  // Group Service
            Full_Name__c = 'BES'          // Full Name
        );
        insert revCatobj;
        
        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services',        // Segment Name
            Group_Segment_Name__c = 'LE',                   // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services'  // Unique_ID
        );
        insert segmentObj;
        
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
            CloseDate = Date.newInstance(2020, 01, 01),                // Target Closed Date
            Actual_Closed_Date__c = Date.newInstance (2020, 01, 01),    // Closed Date
            PO_Date__c = Date.newInstance(2020, 01, 01),              // PO Date
            StageName = 'Prospecting',                           // Stage
            Probability = 30,                                    // Probability (%)
            Amount = 6.925,                                      // Amount
            Advertiser_ID__c = 'asd',                            // Advertiser ID
            Campaign_Start_Date__c = Date.newInstance(2020, 01, 01),  // Campaign Start Date
            Advertiser_Name__c = 'asd',                          // Advertiser Name
            Campaign_End_Date__c = Date.newInstance(2020, 01, 01),    // Campaign End Date
            Connection_Type__c = 'API',                          // Connection Type
            Extend_Campaign__c = false,                          // Extend Campaign
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
            Contract_Start_Date__c = Date.newInstance(2020, 01, 01),           // Injection Item
            Contract_End_Date__c = Date.newInstance(2020, 01, 01),    // Contract End Date
            Billing_Type__c = 'Monthly',                         // Billing Type
            Temp_Sales_Price__c = 10.00000,                      // Temp Sales Price
            Mark_as_Revenue_OppProduct__c = true,                // Sales Revenue Rel
            Is_Pipeline__c = false,                              // Is Pipeline
            Is_Pipeline_PO__c = false,                           // Is Pipeline PO
            is_Forecast_Revenue__c = false, 
            PricebookEntryId  = DADSPOSPbe.id
            
        );
        insert OppLineObj;
        
        
        
        
        
        
        
        test.startTest();
        oppObj.Mark_as_Sales_Revenue__c = true;
        update oppObj;          
        
         ApexPages.StandardController oppProdSc = new ApexPages.StandardController(oppProdRcObj);
        SalesRacingReportController SalesRacingOppProductReportControllerObj = new SalesRacingReportController(oppProdSc);
        
        SalesRacingOppProductReportControllerObj.getOppStageName();
        SalesRacingOppProductReportControllerObj.stageNameSelected = new List<String>();
        SalesRacingOppProductReportControllerObj.stageNameSelected.add('Negotiation');

        SalesRacingOppProductReportControllerObj.getGroupServiceName();
        SalesRacingOppProductReportControllerObj.pipelineGroupServiceSelected = new List<String>();
        SalesRacingOppProductReportControllerObj.pipelineGroupServiceSelected.add('Mobile');

        


        SalesRacingController srcControllerRC = new SalesRacingController(oppProdRcObj);
        srcControllerRC.generateAMTopList();
        srcControllerRC.saveAMTopList();
        
        test.stopTest();
        
        
    }
    
    @isTest static void testRcPipeline1(){
        
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
        
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMObj;
        
        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprMObj;
        
        //CUSTOM SETTING DEFAULT ID SPRamgs
        Sales_Performance_General__c sprAMGSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AMGS_DEFAULT_SFID', format__c='string', value__c =sprM_AMGSObj.id);
        insert sprAMGSettingObj;
        
        Sales_Performance_General__c sprAMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AM_DEFAULT_SFID', format__c='string', value__c =sprM_AMObj.id);
        insert sprAMSettingObj;
        
        Sales_Performance_General__c sprMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_DEFAULT_SFID', format__c='string', value__c =sprMObj.id);
        insert sprMSettingObj;
        
        
        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'dara',                                                              // Alias
            Email = 'dara@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'dara@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '90007843',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'dara',
            LastName='muda',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        
        // ==== set user Sales manager =====
        
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'merry',                                                            // Alias
            Email = 'merry@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'merry@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003754',                                               // Employee ID
            firstName = 'merry',
            LastName='you'
        );
        insert salesManagerobj;
        
        // == create user Account manager ==
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User AMobj = new User(                                              // Role
            Alias = 'kita',
            EmailEncodingKey='UTF-8',
            Email = 'kita@xl.co.id',                                                   // Email
            ProfileId = AMProfile.id,                                                     // Profile
            Username = 'kita@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002724',                                                 // Employee ID
            Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'kita',
            LastName='bisa'
        );
        insert AMobj;
        
        
        
        
        id recTypePipeline = Schema.SObjectType.sales_racing__c.getRecordTypeInfosByName().get('Pipeline').getRecordTypeId();
        sales_racing__c salesRacingObj = new sales_racing__c(
            
            name = 'racing 03',
            data_source__C = 'Pipeline',
            all_product__c = false,
            recordTypeId = recTypePipeline,
            period_start_date__c = date.newInstance(2019, 01, 01),
            period_end_date__c = date.newInstance(2020, 03, 30),
            Stages__c = 'Waiting for Contract',                          
            Group_services__c = 'MOBILE',
            Product_Name__c = 'DADSPOS-01',
            Contract_Ticket_Status__c ='Review By Contract Manager'
            
        );
        insert salesRacingObj;
        
        //==== create group service ===
        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'MOBILE',                  // Group Service Name
            Unique_ID__c = 'MOBILE',            // Unique ID
            Type__c = 'BAU'                  // Type
        );
        insert groupServiceObj;
        
        // == create revenue category ==
        Revenue_Category__c revCatobj = new Revenue_Category__c(
            Name = 'BES',                // Name
            Group_Service__c = groupServiceObj.id,  // Group Service
            Full_Name__c = 'BES'          // Full Name
        );
        insert revCatobj;
        
        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services',        // Segment Name
            Group_Segment_Name__c = 'LE',                   // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services'  // Unique_ID
        );
        insert segmentObj;
        
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
        
        //addc ontract ticket
        
        id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Digital Advertising').getRecordTypeId();
        Opportunity oppObj = new Opportunity(
            RecordTypeId = oppRecType,                          // Opportunity Record Type
            trial__c = false, 
            OwnerId = AMobj.id,                                    // trial
            Service_Group__c = 'GSM',                            // Service Group
            Sales_Manager_Owner__c = salesManagerobj.id,                // Sales Manager Owner
            Name = 'pipeline',                                   // Opportunity Name
            AccountId = AccParentObj.id,                             // Account Name
            CloseDate = Date.newInstance(2020, 01, 01),                // Target Closed Date
            Actual_Closed_Date__c = Date.newInstance (2020, 01, 01),    // Closed Date
            PO_Date__c = Date.newInstance(2020, 01, 01),              // PO Date
            StageName = 'Waiting for Contract',                           // Stage
            Probability = 30,                                    // Probability (%)
            Amount = 6.925,                                      // Amount
            Advertiser_ID__c = 'asd',                            // Advertiser ID
            Campaign_Start_Date__c = Date.newInstance(2020, 01, 01),  // Campaign Start Date
            Advertiser_Name__c = 'asd',                          // Advertiser Name
            Campaign_End_Date__c = Date.newInstance(2020, 01, 01),    // Campaign End Date
            Connection_Type__c = 'API',                          // Connection Type
            Extend_Campaign__c = false,                          // Extend Campaign
            Remark__c = 'Approved',                              // Remark
            BA_Doc_is_uploaded__c = false,                       // BA Doc is uploaded
            Mark_as_Sales_Revenue__c = true,
            Pricebook2id = DADSPOSPricebook.Id ,
            BP_VAT__c = AccParentObj.id              // Mark as Sales Revenue
        );
        
        insert oppObj;
        
        //contract item
        Contract_Ticket__c conTickobj = new Contract_Ticket__c(
            Name = 'Contract Ticket for "test data" Opportunity',          // Name
            Full_Name__c = 'Contract Ticket for "test data" Opportunity',    // Full Name
            Account__c = AccParentObj.id,                                        // Account
            Not_Hit_to_SAP__c = false,                                       // Not Hit to SAP
            TicketStatus__c = 'Review By Contract Manager',                  // Ticket Status
            Opportunity__c = oppObj.id,                                    // Opportunity
            Review_by_Contract_Manager_Date__c = Date.newInstance(2020,01,01),  // Review by Contract Manager Date
            Review_by_Finance_Date__c = Date.newInstance(2020,01,01)           // Review by Finance Date
        );
        insert conTickobj;
        //injection item
        
        
        
        OpportunityLineItem OppLineObj = new OpportunityLineItem(
            OpportunityId = oppObj.id,                                 // Sales Price
            Product2Id = productObj.id,                      // Product
            Request_QTY__c = 1250,                          // Request QTY.
            quantity = 125000,                             // Quantity
            TotalPrice = 1.250,                                  // Total Price
            Contract_Start_Date__c = Date.newInstance(2020, 01, 01),           // Injection Item
            Contract_End_Date__c = Date.newInstance(2020, 01, 01),    // Contract End Date
            Billing_Type__c = 'Monthly',                         // Billing Type
            Temp_Sales_Price__c = 10.00000,                      // Temp Sales Price
            Mark_as_Revenue_OppProduct__c = true,                // Sales Revenue Rel
            Is_Pipeline__c = false,                              // Is Pipeline
            Is_Pipeline_PO__c = false,                           // Is Pipeline PO
            is_Forecast_Revenue__c = false, 
            PricebookEntryId  = DADSPOSPbe.id
            
        );
        insert OppLineObj;
        
        Injection_Item__c Injectobj = new Injection_Item__c(
            Name = 'DADSPOS-01',                    // Name
            Opportunity_Product__c = OppLineObj.id,     // Opportunity Product
            Opportunity__c = oppObj.id,             // Opportunity
            Request_QTY__c = 10000,                // Request QTY
            OppLineItemID__c = OppLineObj.id,  // OppLineItemID
            Actual_QTY__c = 9900                  // Actual QTY
        );
        insert Injectobj;
        
        OppLineObj.injection_item__c = Injectobj.id;
        update OppLineObj;
        
        test.startTest();
        oppObj.Mark_as_Sales_Revenue__c = true;
        oppObj.Contract_Ticket__c = conTickobj.id;
        update oppObj;          
        
        ApexPages.StandardController oppProdSc = new ApexPages.StandardController(salesRacingObj);
        SalesRacingReportController SalesRacingOppProductReportControllerObj = new SalesRacingReportController(oppProdSc);
        
        SalesRacingOppProductReportControllerObj.dataSourceSelectedValue = 'Transaction Data';

        SalesRacingOppProductReportControllerObj.getOppStageName();
        SalesRacingOppProductReportControllerObj.stageNameSelected = new List<String>();
        SalesRacingOppProductReportControllerObj.stageNameSelected.add('Waiting for Contract');

        SalesRacingController srcControllerRC = new SalesRacingController(salesRacingObj);
        srcControllerRC.generateAMTopList();
        srcControllerRC.saveAMTopList();


        
        test.stopTest();
    }

    @isTest static void testRcPipeline2(){
        
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
        
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMObj;
        
        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprMObj;
        
        //CUSTOM SETTING DEFAULT ID SPRamgs
        Sales_Performance_General__c sprAMGSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AMGS_DEFAULT_SFID', format__c='string', value__c =sprM_AMGSObj.id);
        insert sprAMGSettingObj;
        
        Sales_Performance_General__c sprAMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AM_DEFAULT_SFID', format__c='string', value__c =sprM_AMObj.id);
        insert sprAMSettingObj;
        
        Sales_Performance_General__c sprMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_DEFAULT_SFID', format__c='string', value__c =sprMObj.id);
        insert sprMSettingObj;
        
        
        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'dara',                                                              // Alias
            Email = 'dara@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'dara@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '90007843',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'dara',
            LastName='muda',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        
        // ==== set user Sales manager =====
        
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'merry',                                                            // Alias
            Email = 'merry@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'merry@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003754',                                               // Employee ID
            firstName = 'merry',
            LastName='you'
        );
        insert salesManagerobj;
        
        // == create user Account manager ==
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User AMobj = new User(                                              // Role
            Alias = 'kita',
            EmailEncodingKey='UTF-8',
            Email = 'kita@xl.co.id',                                                   // Email
            ProfileId = AMProfile.id,                                                     // Profile
            Username = 'kita@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002724',                                                 // Employee ID
            Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'kita',
            LastName='bisa'
        );
        insert AMobj;
        
        
        
        
        id recTypePipeline = Schema.SObjectType.sales_racing__c.getRecordTypeInfosByName().get('Pipeline').getRecordTypeId();
        sales_racing__c salesRacingObj = new sales_racing__c(
            
            name = 'racing 03',
            data_source__C = 'Pipeline',   
            all_product__c = false,
            recordTypeId = recTypePipeline,
            period_start_date__c = date.newInstance(2019, 01, 01),
            period_end_date__c = date.newInstance(2020, 03, 30),
            Stages__c = 'Negotiation',                          
            Group_services__c = 'MOBILE',
            Product_Name__c = 'DADSPOS-01',
            Contract_Ticket_Status__c ='Review By Contract Manager'
         
            
        );
        insert salesRacingObj;
        
        //==== create group service ===
        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'MOBILE',                  // Group Service Name
            Unique_ID__c = 'MOBILE',            // Unique ID
            Type__c = 'BAU'                  // Type
        );
        insert groupServiceObj;
        
        // == create revenue category ==
        Revenue_Category__c revCatobj = new Revenue_Category__c(
            Name = 'BES',                // Name
            Group_Service__c = groupServiceObj.id,  // Group Service
            Full_Name__c = 'BES'          // Full Name
        );
        insert revCatobj;
        
        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services',        // Segment Name
            Group_Segment_Name__c = 'LE',                   // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services'  // Unique_ID
        );
        insert segmentObj;
        
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
        
        //addc ontract ticket
        
        id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Digital Advertising').getRecordTypeId();
        Opportunity oppObj = new Opportunity(
            RecordTypeId = oppRecType,                          // Opportunity Record Type
            trial__c = false, 
            OwnerId = AMobj.id,                                    // trial
            Service_Group__c = 'GSM',                            // Service Group
            Sales_Manager_Owner__c = salesManagerobj.id,                // Sales Manager Owner
            Name = 'pipeline',                                   // Opportunity Name
            AccountId = AccParentObj.id,                             // Account Name
            CloseDate = Date.newInstance(2020, 01, 01),                // Target Closed Date
            Actual_Closed_Date__c = Date.newInstance (2020, 01, 01),    // Closed Date
            PO_Date__c = Date.newInstance(2020, 01, 01),              // PO Date
            StageName = 'Negotiation',                           // Stage
            Probability = 30,                                    // Probability (%)
            Amount = 6.925,                                      // Amount
            Advertiser_ID__c = 'asd',                            // Advertiser ID
            Campaign_Start_Date__c = Date.newInstance(2020, 01, 01),  // Campaign Start Date
            Advertiser_Name__c = 'asd',                          // Advertiser Name
            Campaign_End_Date__c = Date.newInstance(2020, 01, 01),    // Campaign End Date
            Connection_Type__c = 'API',                          // Connection Type
            Extend_Campaign__c = false,                          // Extend Campaign
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
            Contract_Start_Date__c = Date.newInstance(2020, 01, 01),           // Injection Item
            Contract_End_Date__c = Date.newInstance(2020, 01, 01),    // Contract End Date
            Billing_Type__c = 'Monthly',                         // Billing Type
            Temp_Sales_Price__c = 10.00000,                      // Temp Sales Price
            Mark_as_Revenue_OppProduct__c = true,                // Sales Revenue Rel
            Is_Pipeline__c = false,                              // Is Pipeline
            Is_Pipeline_PO__c = false,                           // Is Pipeline PO
            is_Forecast_Revenue__c = false, 
            PricebookEntryId  = DADSPOSPbe.id
            
        );
        insert OppLineObj;
        
        
        test.startTest();
        oppObj.Mark_as_Sales_Revenue__c = true;
        update oppObj;          
        
        ApexPages.StandardController oppProdSc = new ApexPages.StandardController(salesRacingObj);
        SalesRacingReportController SalesRacingOppProductReportControllerObj = new SalesRacingReportController(oppProdSc);
        
        SalesRacingOppProductReportControllerObj.getOppStageName();
        SalesRacingOppProductReportControllerObj.stageNameSelected = new List<String>();
        SalesRacingOppProductReportControllerObj.stageNameSelected.add('Negotiation');

        SalesRacingController srcControllerRC = new SalesRacingController(salesRacingObj);

        srcControllerRC.generateAMTopList();
        srcControllerRC.saveAMTopList();

        
        
        test.stopTest();
    }

    @isTest static void testRcPipeline3(){
        
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
        
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMObj;
        
        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprMObj;
        
        //CUSTOM SETTING DEFAULT ID SPRamgs
        Sales_Performance_General__c sprAMGSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AMGS_DEFAULT_SFID', format__c='string', value__c =sprM_AMGSObj.id);
        insert sprAMGSettingObj;
        
        Sales_Performance_General__c sprAMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AM_DEFAULT_SFID', format__c='string', value__c =sprM_AMObj.id);
        insert sprAMSettingObj;
        
        Sales_Performance_General__c sprMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_DEFAULT_SFID', format__c='string', value__c =sprMObj.id);
        insert sprMSettingObj;
        
        
        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'dara',                                                              // Alias
            Email = 'dara@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'dara@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '90007843',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'dara',
            LastName='muda',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        
        // ==== set user Sales manager =====
        
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'merry',                                                            // Alias
            Email = 'merry@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'merry@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003754',                                               // Employee ID
            firstName = 'merry',
            LastName='you'
        );
        insert salesManagerobj;
        
        // == create user Account manager ==
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User AMobj = new User(                                              // Role
            Alias = 'kita',
            EmailEncodingKey='UTF-8',
            Email = 'kita@xl.co.id',                                                   // Email
            ProfileId = AMProfile.id,                                                     // Profile
            Username = 'kita@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002724',                                                 // Employee ID
            Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'kita',
            LastName='bisa'
        );
        insert AMobj;
        
        id recTypePipeline = Schema.SObjectType.sales_racing__c.getRecordTypeInfosByName().get('Pipeline').getRecordTypeId();
        sales_racing__c salesRacingObj = new sales_racing__c(
            
            name = 'racing 04',
            data_source__C = 'Pipeline',
            all_product__c = true,
            recordTypeId = recTypePipeline,
            period_start_date__c = date.newInstance(2019, 01, 01),
            period_end_date__c = date.newInstance(2020, 03, 30),
            Stages__c = 'Closed Won',                          
            Group_services__c = 'MOBILE',
            Product_Name__c = 'DADSPOS-01',
            Contract_Ticket_Status__c ='Review By Contract Manager'
            
        );
        insert salesRacingObj;
        
        //==== create group service ===
        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'MOBILE',                  // Group Service Name
            Unique_ID__c = 'MOBILE',            // Unique ID
            Type__c = 'BAU'                  // Type
        );
        insert groupServiceObj;
        
        // == create revenue category ==
        Revenue_Category__c revCatobj = new Revenue_Category__c(
            Name = 'BES',                // Name
            Group_Service__c = groupServiceObj.id,  // Group Service
            Full_Name__c = 'BES'          // Full Name
        );
        insert revCatobj;
        
        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services',        // Segment Name
            Group_Segment_Name__c = 'LE',                   // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services'  // Unique_ID
        );
        insert segmentObj;
        
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
        
        //addc ontract ticket
        
        id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Digital Advertising').getRecordTypeId();
        Opportunity oppObj = new Opportunity(
            RecordTypeId = oppRecType,                          // Opportunity Record Type
            trial__c = false, 
            OwnerId = AMobj.id,                                    // trial
            Service_Group__c = 'GSM',                            // Service Group
            Sales_Manager_Owner__c = salesManagerobj.id,                // Sales Manager Owner
            Name = 'pipeline',                                   // Opportunity Name
            AccountId = AccParentObj.id,                             // Account Name
            CloseDate = Date.newInstance(2020, 01, 01),                // Target Closed Date
            Actual_Closed_Date__c = Date.newInstance (2020, 01, 01),    // Closed Date
            PO_Date__c = Date.newInstance(2020, 01, 01),              // PO Date
            StageName = 'Closed Won',                           // Stage
            Probability = 30,                                    // Probability (%)
            Amount = 6.925,                                      // Amount
            Advertiser_ID__c = 'asd',                            // Advertiser ID
            Campaign_Start_Date__c = Date.newInstance(2020, 01, 01),  // Campaign Start Date
            Advertiser_Name__c = 'asd',                          // Advertiser Name
            Campaign_End_Date__c = Date.newInstance(2020, 01, 01),    // Campaign End Date
            Connection_Type__c = 'API',                          // Connection Type
            Extend_Campaign__c = false,                          // Extend Campaign
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
            Contract_Start_Date__c = Date.newInstance(2020, 01, 01),           // Injection Item
            Contract_End_Date__c = Date.newInstance(2020, 01, 01),    // Contract End Date
            Billing_Type__c = 'Monthly',                         // Billing Type
            Temp_Sales_Price__c = 10.00000,                      // Temp Sales Price
            Mark_as_Revenue_OppProduct__c = true,                // Sales Revenue Rel
            Is_Pipeline__c = false,                              // Is Pipeline
            Is_Pipeline_PO__c = false,                           // Is Pipeline PO
            is_Forecast_Revenue__c = false, 
            PricebookEntryId  = DADSPOSPbe.id
            
        );
        insert OppLineObj;
        

            //contract item
            Contract_Ticket__c conTickobj = new Contract_Ticket__c(
                Name = 'Contract Ticket for "test data" Opportunity',          // Name
                Full_Name__c = 'Contract Ticket for "test data" Opportunity',    // Full Name
                Account__c = AccParentObj.id,                                        // Account
                Not_Hit_to_SAP__c = false,                                       // Not Hit to SAP
                TicketStatus__c = 'Review By Finance',                  // Ticket Status
                Opportunity__c = oppObj.id,                                    // Opportunity
                Review_by_Contract_Manager_Date__c = Date.newInstance(2020,01,01),  // Review by Contract Manager Date
                Review_by_Finance_Date__c = Date.newInstance(2020,01,01)           // Review by Finance Date
            );
            insert conTickobj;

            //injection item
            Injection_Item__c Injectobj = new Injection_Item__c(
                Name = 'DADSPOS-01',                    // Name
                Opportunity_Product__c = OppLineObj.id,     // Opportunity Product
                Opportunity__c = oppObj.id,             // Opportunity
                Request_QTY__c = 10000,                // Request QTY
                OppLineItemID__c = OppLineObj.id,  // OppLineItemID
                Actual_QTY__c = 9900                  // Actual QTY
            );
            insert Injectobj;
            
            OppLineObj.injection_item__c = Injectobj.id;
            update OppLineObj;
            
            test.startTest();
            oppObj.Mark_as_Sales_Revenue__c = true;
            oppObj.Contract_Ticket__c = conTickobj.id;
            update oppObj;          
            
            ApexPages.StandardController oppProdSc = new ApexPages.StandardController(salesRacingObj);
            SalesRacingReportController SalesRacingOppProductReportControllerObj = new SalesRacingReportController(oppProdSc);
            
            SalesRacingOppProductReportControllerObj.getOppStageName();
            SalesRacingOppProductReportControllerObj.stageNameSelected = new List<String>();
            SalesRacingOppProductReportControllerObj.stageNameSelected.add('Waiting for Contract');
    
            SalesRacingOppProductReportControllerObj.getContractTicketStatusName();
            SalesRacingOppProductReportControllerObj.contractTicketStatusSelected = new List<String>();
            SalesRacingOppProductReportControllerObj.contractTicketStatusSelected.add('Review by Finance');

            SalesRacingOppProductReportControllerObj.getGroupServiceName();
            SalesRacingOppProductReportControllerObj.pipelineGroupServiceSelected = new List<String>();
            SalesRacingOppProductReportControllerObj.pipelineGroupServiceSelected.add('DADSPOSPricebook');

            SalesRacingController srcControllerRC = new SalesRacingController(salesRacingObj);
            srcControllerRC.generateAMTopList();
            srcControllerRC.saveAMTopList();
            
            test.stopTest();
            
                //contract item
    }

    @isTest static void testRcPipeline4(){
        
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
        
        
        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprM_AMObj;
        
        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2020', month__c = '1');
        insert sprMObj;
        
        //CUSTOM SETTING DEFAULT ID SPRamgs
        Sales_Performance_General__c sprAMGSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AMGS_DEFAULT_SFID', format__c='string', value__c =sprM_AMGSObj.id);
        insert sprAMGSettingObj;
        
        Sales_Performance_General__c sprAMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AM_DEFAULT_SFID', format__c='string', value__c =sprM_AMObj.id);
        insert sprAMSettingObj;
        
        Sales_Performance_General__c sprMSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_DEFAULT_SFID', format__c='string', value__c =sprMObj.id);
        insert sprMSettingObj;
        
        
        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'dara',                                                              // Alias
            Email = 'dara@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'dara@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '90007843',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'dara',
            LastName='muda',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        
        // ==== set user Sales manager =====
        
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'merry',                                                            // Alias
            Email = 'merry@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'merry@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003754',                                               // Employee ID
            firstName = 'merry',
            LastName='you'
        );
        insert salesManagerobj;
        
        // == create user Account manager ==
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User AMobj = new User(                                              // Role
            Alias = 'kita',
            EmailEncodingKey='UTF-8',
            Email = 'kita@xl.co.id',                                                   // Email
            ProfileId = AMProfile.id,                                                     // Profile
            Username = 'kita@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002724',                                                 // Employee ID
            Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'kita',
            LastName='bisa'
        );
        insert AMobj;
        
        id recTypePipeline = Schema.SObjectType.sales_racing__c.getRecordTypeInfosByName().get('Pipeline').getRecordTypeId();
        sales_racing__c salesRacingObj = new sales_racing__c(
            
            name = 'racing 04',
            data_source__C = 'Pipeline',
            all_product__c = true,
            recordTypeId = recTypePipeline,
            period_start_date__c = date.newInstance(2019, 01, 01),
            period_end_date__c = date.newInstance(2020, 03, 30),
            Stages__c = 'Negotiation',                          
            Group_services__c = 'MOBILE'
            
        );
        insert salesRacingObj;
        
        //==== create group service ===
        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'MOBILE',                  // Group Service Name
            Unique_ID__c = 'MOBILE',            // Unique ID
            Type__c = 'BAU'                  // Type
        );
        insert groupServiceObj;
        
        // == create revenue category ==
        Revenue_Category__c revCatobj = new Revenue_Category__c(
            Name = 'BES',                // Name
            Group_Service__c = groupServiceObj.id,  // Group Service
            Full_Name__c = 'BES'          // Full Name
        );
        insert revCatobj;
        
        Segment__c segmentObj = new Segment__c(
            Name = 'Banking & Financial Services',        // Segment Name
            Group_Segment_Name__c = 'LE',                   // Group Segment Name
            Unique_ID__c = 'Banking & Financial Services'  // Unique_ID
        );
        insert segmentObj;
        
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
        
        //addc ontract ticket
        
        id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Digital Advertising').getRecordTypeId();
        Opportunity oppObj = new Opportunity(
            RecordTypeId = oppRecType,                          // Opportunity Record Type
            trial__c = false, 
            OwnerId = AMobj.id,                                    // trial
            Service_Group__c = 'GSM',                            // Service Group
            Sales_Manager_Owner__c = salesManagerobj.id,                // Sales Manager Owner
            Name = 'pipeline',                                   // Opportunity Name
            AccountId = AccParentObj.id,                             // Account Name
            CloseDate = Date.newInstance(2020, 01, 01),                // Target Closed Date
            Actual_Closed_Date__c = Date.newInstance (2020, 01, 01),    // Closed Date
            PO_Date__c = Date.newInstance(2020, 01, 01),              // PO Date
            StageName = 'Negotiation',                           // Stage
            Probability = 30,                                    // Probability (%)
            Amount = 6.925,                                      // Amount
            Advertiser_ID__c = 'asd',                            // Advertiser ID
            Campaign_Start_Date__c = Date.newInstance(2020, 01, 01),  // Campaign Start Date
            Advertiser_Name__c = 'asd',                          // Advertiser Name
            Campaign_End_Date__c = Date.newInstance(2020, 01, 01),    // Campaign End Date
            Connection_Type__c = 'API',                          // Connection Type
            Extend_Campaign__c = false,                          // Extend Campaign
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
            Contract_Start_Date__c = Date.newInstance(2020, 01, 01),           // Injection Item
            Contract_End_Date__c = Date.newInstance(2020, 01, 01),    // Contract End Date
            Billing_Type__c = 'Monthly',                         // Billing Type
            Temp_Sales_Price__c = 10.00000,                       // Sales Revenue Rel
            Is_Pipeline__c = false,                              // Is Pipeline
            Is_Pipeline_PO__c = false,                           // Is Pipeline PO
            is_Forecast_Revenue__c = false, 
            PricebookEntryId  = DADSPOSPbe.id
            
        );
        insert OppLineObj;

            //contract item
            Contract_Ticket__c conTickobj = new Contract_Ticket__c(
                Name = 'Contract Ticket for "test data" Opportunity',          // Name
                Full_Name__c = 'Contract Ticket for "test data" Opportunity',    // Full Name
                Account__c = AccParentObj.id,                                        // Account
                Not_Hit_to_SAP__c = false,                                       // Not Hit to SAP
                TicketStatus__c = 'Review By Contract Manager',                  // Ticket Status
                Opportunity__c = oppObj.id,                                    // Opportunity
                Review_by_Contract_Manager_Date__c = Date.newInstance(2020,01,01),  // Review by Contract Manager Date
                Review_by_Finance_Date__c = Date.newInstance(2020,01,01)           // Review by Finance Date
            );
            insert conTickobj;

            //injection item
            Injection_Item__c Injectobj = new Injection_Item__c(
                Name = 'DADSPOS-01',                    // Name
                Opportunity_Product__c = OppLineObj.id,     // Opportunity Product
                Opportunity__c = oppObj.id,             // Opportunity
                Request_QTY__c = 10000,                // Request QTY
                OppLineItemID__c = OppLineObj.id,  // OppLineItemID
                Actual_QTY__c = 9900                  // Actual QTY
            );
            insert Injectobj;
            
            OppLineObj.injection_item__c = Injectobj.id;
            update OppLineObj;
            
            test.startTest();
            oppObj.Mark_as_Sales_Revenue__c = true;
            oppObj.Contract_Ticket__c = conTickobj.id;
            update oppObj;          
            
            SalesRacingController srcControllerRC = new SalesRacingController(salesRacingObj);
            srcControllerRC.generateAMTopList();
            srcControllerRC.saveAMTopList();
            srcControllerRC.saveParameterAMTopList();
            
            test.stopTest();
            
    }

}