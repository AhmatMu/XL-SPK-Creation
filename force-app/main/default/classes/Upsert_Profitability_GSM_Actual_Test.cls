@isTest()
public class Upsert_Profitability_GSM_Actual_Test {
    static testMethod void myUnitTest1() {
        insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Id recordTypeId_ProfitabilityGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('GSM').getRecordTypeId();

        List<ProfitabilityController__c> EmailSettingList = new list<ProfitabilityController__c>();
        
        ProfitabilityController__c EmailSettingList_1 = new ProfitabilityController__c(); //space
        EmailSettingList_1.Name = 'Email_Notif_BatchClass';
        EmailSettingList_1.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_1.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_1);
        insert EmailSettingList;
        
        List<PNL_GSM_Setting_Actual__c> PNL_GSM_Setting_ActualList = new list<PNL_GSM_Setting_Actual__c>();

        PNL_GSM_Setting_Actual__c PNL_GSM_Setting_Actual_1 = new PNL_GSM_Setting_Actual__c();
        PNL_GSM_Setting_Actual_1.Name = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Margin__c = 0;
        PNL_GSM_Setting_Actual_1.Revenue_Category__c = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Active__c = true;
        PNL_GSM_Setting_ActualList.add(PNL_GSM_Setting_Actual_1);

        insert PNL_GSM_Setting_ActualList;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'idewap@xl.co.id', 
                           Username = uniqueName + '@test' + orgId + '.org', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = uniqueName.substring(18, 23), 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = pf.Id
                          ); 
        insert uu;

        Account accTest = new Account();
        accTest.RecordTypeId = recordTypeId_accBP;
        accTest.Name = 'Bank Maybank Indonesia Tbk';
        accTest.Unique_Name__c = 'Sentral Senayan Building 3';
        accTest.NumberOfEmployees = 2;
        accTest.Summary_Billing__c = false;
        accTest.Payer_For_GSM_Invoice__c = false;
        accTest.Using_HO_Billing_Address__c = false;
        accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
        accTest.Customer_VAT_Name__c = 'BANK MAYBANK INDONESIA TBK';
        accTest.Customer_Type__c = 'NONGSM';
        accTest.No_NPWP__c = '013093232091000';
        accTest.BillingStreet = 'hive';
        accTest.BillingState = 'hive';
        accTest.BillingCity = 'hive';
        accTest.BillingCountry = 'hive';
        accTest.BillingPostalCode = 'hive';
        accTest.ShippingStreet = 'hive';
        accTest.ShippingState = 'hive';
        accTest.ShippingCity = 'hive';
        accTest.ShippingCountry = 'hive';
        accTest.ShippingPostalCode = 'hive';
        accTest.Billing_Building_Name__c = 'hive';
        accTest.Shipping_Building_Name__c = 'hive';
        accTest.Field_Source__c = 'Bizstore Customer Registration';
        accTest.Organization_Type__c = 'Head Office';
        accTest.Type = 'Customer';
        accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        accTest.OU__c = '1';
        accTest.Industry = 'Agriculture';
        accTest.BP_Number__c = '714197';
        accTest.Bizstore_Complete__c = false;
        Insert accTest;
        
        Account accTest2 = new Account(
            Name = 'PT Bank MayBank Indonesia Tbk',                         
            RecordTypeId = recordTypeId_accBP,                                     
            BP_Number__c = '707310',                                        
            Organization_Type__c = 'Branch',                                
            Type = 'Customer',                                              
            ParentId = accTest.Id,                                         
            Unique_Name__c = 'KCP Surabaya Pondok Candra',                  
            Customer_Type__c = 'NONGSM',                                    
            Payer_For_GSM_Invoice__c = false,                               
            term_of_payment__c = 'Z030 Within 30 Days Due Net',             
            Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)',
            Customer_VAT_Name__c = 'PT Bank MayBank Indonesia Tbk',         
            Summary_Billing__c = false,                                     
            Using_HO_Billing_Address__c = false                             
        );
        insert accTest2;
        
        Profitability__c ProfitabilityForecats = new Profitability__c();
        ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityGsm;
        ProfitabilityForecats.Name = 'Testing';
        ProfitabilityForecats.Account__c = accTest.Id;
        ProfitabilityForecats.Account_2__c = accTest2.Id;
        ProfitabilityForecats.Status__c = 'Actual';
        ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
        ProfitabilityForecats.Deal_Price__c = 10000;
        ProfitabilityForecats.One_Time_Revenue__c = 10000;
        Insert ProfitabilityForecats;

        Revenue_Category__c revenueCategory = new Revenue_Category__c();
        revenueCategory.Name = 'Postpaid';
        revenueCategory.Full_Name__c = 'Postpaid';
        Insert revenueCategory;

        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMGSObj;

        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMObj;

        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'Connectivity Mobile',
            Unique_ID__c = 'Connectivity Mobile',
            Type__c = 'BAU'
        );
        insert groupServiceObj;

        List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        
        Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue';
        salesRevenueObj.month__c = '6';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = 'Postpaid';
        salesRevenueObj.customer_bp_no__c = '707310';
        salesRevenueObj.Customer__c = accTest2.Id;
        salesRevenueObj.amount__c = 10000000;
        salesRevenueObj.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj);

        Sales_Revenue__c salesRevenueObj2 = new Sales_Revenue__c();
        salesRevenueObj2.type__c = 'Actual Revenue';
        salesRevenueObj2.month__c = '6';
        salesRevenueObj2.year__c = '2021';
        salesRevenueObj2.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj2.AM_Employee_ID__c = '90004036';
        salesRevenueObj2.revenue_category_name__c = 'Postpaid';
        salesRevenueObj2.customer_bp_no__c = '714197';
        salesRevenueObj2.Customer__c = accTest.Id;
        salesRevenueObj2.amount__c = 10000000;
        salesRevenueObj2.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj2.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj2.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj2.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj2);

        insert salesRevenueList;

        
        test.starttest();
            Datetime nextSchedule = system.now().addSeconds(3);

            String hour = String.valueOf( nextSchedule.hour());
            String min = String.valueOf( nextSchedule.minute()); 
            String ss = String.valueOf( nextSchedule.second());
            String sDay = string.valueof( nextSchedule.day() ); 
            String sYear = string.valueof( nextSchedule.year() );
            String sMonth = string.valueof( nextSchedule.month() );

            String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

            Upsert_Profitability_GSM_Actual_Schedule test1 = new Upsert_Profitability_GSM_Actual_Schedule(); 
            System.schedule('Upsert_Profitability_GSM_Actual_Schedule ' + String.valueOf(system.now()), nextFireTime, test1);
        test.stoptest();
    }

    static testMethod void myUnitTest2() {
        insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Id recordTypeId_ProfitabilityGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('GSM').getRecordTypeId();

        List<ProfitabilityController__c> EmailSettingList = new list<ProfitabilityController__c>();
        
        ProfitabilityController__c EmailSettingList_1 = new ProfitabilityController__c(); //koma
        EmailSettingList_1.Name = 'Email_Notif_BatchClass';
        EmailSettingList_1.Additional_toAddress__c = 'test@gmail.com,test@gmail.com,test@gmail.com';
        EmailSettingList_1.Additional_toCCAddress__c = 'test@gmail.com,test@gmail.com,test@gmail.com';
        EmailSettingList.add(EmailSettingList_1);
        insert EmailSettingList;
        
        List<PNL_GSM_Setting_Actual__c> PNL_GSM_Setting_ActualList = new list<PNL_GSM_Setting_Actual__c>();

        PNL_GSM_Setting_Actual__c PNL_GSM_Setting_Actual_1 = new PNL_GSM_Setting_Actual__c();
        PNL_GSM_Setting_Actual_1.Name = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Margin__c = 0;
        PNL_GSM_Setting_Actual_1.Revenue_Category__c = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Active__c = true;
        PNL_GSM_Setting_ActualList.add(PNL_GSM_Setting_Actual_1);

        insert PNL_GSM_Setting_ActualList;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'idewap@xl.co.id', 
                           Username = uniqueName + '@test' + orgId + '.org', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = uniqueName.substring(18, 23), 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = pf.Id
                          ); 
        insert uu;

        Account accTest = new Account();
        accTest.RecordTypeId = recordTypeId_accBP;
        accTest.Name = 'Bank Maybank Indonesia Tbk';
        accTest.Unique_Name__c = 'Sentral Senayan Building 3';
        accTest.NumberOfEmployees = 2;
        accTest.Summary_Billing__c = false;
        accTest.Payer_For_GSM_Invoice__c = false;
        accTest.Using_HO_Billing_Address__c = false;
        accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
        accTest.Customer_VAT_Name__c = 'BANK MAYBANK INDONESIA TBK';
        accTest.Customer_Type__c = 'NONGSM';
        accTest.No_NPWP__c = '013093232091000';
        accTest.BillingStreet = 'hive';
        accTest.BillingState = 'hive';
        accTest.BillingCity = 'hive';
        accTest.BillingCountry = 'hive';
        accTest.BillingPostalCode = 'hive';
        accTest.ShippingStreet = 'hive';
        accTest.ShippingState = 'hive';
        accTest.ShippingCity = 'hive';
        accTest.ShippingCountry = 'hive';
        accTest.ShippingPostalCode = 'hive';
        accTest.Billing_Building_Name__c = 'hive';
        accTest.Shipping_Building_Name__c = 'hive';
        accTest.Field_Source__c = 'Bizstore Customer Registration';
        accTest.Organization_Type__c = 'Head Office';
        accTest.Type = 'Customer';
        accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        accTest.OU__c = '1';
        accTest.Industry = 'Agriculture';
        accTest.BP_Number__c = '714197';
        accTest.Bizstore_Complete__c = false;
        Insert accTest;
        
        Account accTest2 = new Account(
            Name = 'PT Bank MayBank Indonesia Tbk',                         
            RecordTypeId = recordTypeId_accBP,                                     
            BP_Number__c = '707310',                                        
            Organization_Type__c = 'Branch',                                
            Type = 'Customer',                                              
            ParentId = accTest.Id,                                         
            Unique_Name__c = 'KCP Surabaya Pondok Candra',                  
            Customer_Type__c = 'NONGSM',                                    
            Payer_For_GSM_Invoice__c = false,                               
            term_of_payment__c = 'Z030 Within 30 Days Due Net',             
            Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)',
            Customer_VAT_Name__c = 'PT Bank MayBank Indonesia Tbk',         
            Summary_Billing__c = false,                                     
            Using_HO_Billing_Address__c = false                             
        );
        insert accTest2;

        Revenue_Category__c revenueCategory = new Revenue_Category__c();
        revenueCategory.Name = 'Postpaid';
        revenueCategory.Full_Name__c = 'Postpaid';
        Insert revenueCategory;

        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMGSObj;

        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMObj;

        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'Connectivity Mobile',
            Unique_ID__c = 'Connectivity Mobile',
            Type__c = 'BAU'
        );
        insert groupServiceObj;

        List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        
        Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue';
        salesRevenueObj.month__c = '6';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = 'Postpaid';
        salesRevenueObj.customer_bp_no__c = '707310';
        salesRevenueObj.Customer__c = accTest2.Id;
        salesRevenueObj.amount__c = 10000000;
        salesRevenueObj.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj);

        Sales_Revenue__c salesRevenueObj2 = new Sales_Revenue__c();
        salesRevenueObj2.type__c = 'Actual Revenue';
        salesRevenueObj2.month__c = '6';
        salesRevenueObj2.year__c = '2021';
        salesRevenueObj2.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj2.AM_Employee_ID__c = '90004036';
        salesRevenueObj2.revenue_category_name__c = 'Postpaid';
        salesRevenueObj2.customer_bp_no__c = '714197';
        salesRevenueObj2.Customer__c = accTest.Id;
        salesRevenueObj2.amount__c = 10000000;
        salesRevenueObj2.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj2.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj2.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj2.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj2);

        insert salesRevenueList;

        
        test.starttest();
            Datetime nextSchedule = system.now().addSeconds(3);

            String hour = String.valueOf( nextSchedule.hour());
            String min = String.valueOf( nextSchedule.minute()); 
            String ss = String.valueOf( nextSchedule.second());
            String sDay = string.valueof( nextSchedule.day() ); 
            String sYear = string.valueof( nextSchedule.year() );
            String sMonth = string.valueof( nextSchedule.month() );

            String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

            Upsert_Profitability_GSM_Actual_Schedule test1 = new Upsert_Profitability_GSM_Actual_Schedule(); 
            System.schedule('Upsert_Profitability_GSM_Actual_Schedule ' + String.valueOf(system.now()), nextFireTime, test1);
        test.stoptest();
    }

    static testMethod void myUnitTest3() {
        insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Id recordTypeId_ProfitabilityGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('GSM').getRecordTypeId();

        List<ProfitabilityController__c> EmailSettingList = new list<ProfitabilityController__c>();
        
        ProfitabilityController__c EmailSettingList_1 = new ProfitabilityController__c(); //pipe
        EmailSettingList_1.Name = 'Email_Notif_BatchClass';
        EmailSettingList_1.Additional_toAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com';
        EmailSettingList_1.Additional_toCCAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com';
        EmailSettingList.add(EmailSettingList_1);
        insert EmailSettingList;
        
        List<PNL_GSM_Setting_Actual__c> PNL_GSM_Setting_ActualList = new list<PNL_GSM_Setting_Actual__c>();

        PNL_GSM_Setting_Actual__c PNL_GSM_Setting_Actual_1 = new PNL_GSM_Setting_Actual__c();
        PNL_GSM_Setting_Actual_1.Name = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Margin__c = 0;
        PNL_GSM_Setting_Actual_1.Revenue_Category__c = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Active__c = true;
        PNL_GSM_Setting_ActualList.add(PNL_GSM_Setting_Actual_1);

        insert PNL_GSM_Setting_ActualList;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'idewap@xl.co.id', 
                           Username = uniqueName + '@test' + orgId + '.org', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = uniqueName.substring(18, 23), 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = pf.Id
                          ); 
        insert uu;

        Account accTest = new Account();
        accTest.RecordTypeId = recordTypeId_accBP;
        accTest.Name = 'Bank Maybank Indonesia Tbk';
        accTest.Unique_Name__c = 'Sentral Senayan Building 3';
        accTest.NumberOfEmployees = 2;
        accTest.Summary_Billing__c = false;
        accTest.Payer_For_GSM_Invoice__c = false;
        accTest.Using_HO_Billing_Address__c = false;
        accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
        accTest.Customer_VAT_Name__c = 'BANK MAYBANK INDONESIA TBK';
        accTest.Customer_Type__c = 'NONGSM';
        accTest.No_NPWP__c = '013093232091000';
        accTest.BillingStreet = 'hive';
        accTest.BillingState = 'hive';
        accTest.BillingCity = 'hive';
        accTest.BillingCountry = 'hive';
        accTest.BillingPostalCode = 'hive';
        accTest.ShippingStreet = 'hive';
        accTest.ShippingState = 'hive';
        accTest.ShippingCity = 'hive';
        accTest.ShippingCountry = 'hive';
        accTest.ShippingPostalCode = 'hive';
        accTest.Billing_Building_Name__c = 'hive';
        accTest.Shipping_Building_Name__c = 'hive';
        accTest.Field_Source__c = 'Bizstore Customer Registration';
        accTest.Organization_Type__c = 'Head Office';
        accTest.Type = 'Customer';
        accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        accTest.OU__c = '1';
        accTest.Industry = 'Agriculture';
        accTest.BP_Number__c = '714197';
        accTest.Bizstore_Complete__c = false;
        Insert accTest;
        
        Account accTest2 = new Account(
            Name = 'PT Bank MayBank Indonesia Tbk',                         
            RecordTypeId = recordTypeId_accBP,                                     
            BP_Number__c = '707310',                                        
            Organization_Type__c = 'Branch',                                
            Type = 'Customer',                                              
            ParentId = accTest.Id,                                         
            Unique_Name__c = 'KCP Surabaya Pondok Candra',                  
            Customer_Type__c = 'NONGSM',                                    
            Payer_For_GSM_Invoice__c = false,                               
            term_of_payment__c = 'Z030 Within 30 Days Due Net',             
            Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)',
            Customer_VAT_Name__c = 'PT Bank MayBank Indonesia Tbk',         
            Summary_Billing__c = false,                                     
            Using_HO_Billing_Address__c = false                             
        );
        insert accTest2;

        Revenue_Category__c revenueCategory = new Revenue_Category__c();
        revenueCategory.Name = 'Postpaid';
        revenueCategory.Full_Name__c = 'Postpaid';
        Insert revenueCategory;

        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMGSObj;

        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMObj;

        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'Connectivity Mobile',
            Unique_ID__c = 'Connectivity Mobile',
            Type__c = 'BAU'
        );
        insert groupServiceObj;

        List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        
        Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue';
        salesRevenueObj.month__c = '6';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = 'Postpaid';
        salesRevenueObj.customer_bp_no__c = '707310';
        salesRevenueObj.Customer__c = accTest2.Id;
        salesRevenueObj.amount__c = 10000000;
        salesRevenueObj.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj);

        Sales_Revenue__c salesRevenueObj2 = new Sales_Revenue__c();
        salesRevenueObj2.type__c = 'Actual Revenue';
        salesRevenueObj2.month__c = '6';
        salesRevenueObj2.year__c = '2021';
        salesRevenueObj2.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj2.AM_Employee_ID__c = '90004036';
        salesRevenueObj2.revenue_category_name__c = 'Postpaid';
        salesRevenueObj2.customer_bp_no__c = '714197';
        salesRevenueObj2.Customer__c = accTest.Id;
        salesRevenueObj2.amount__c = 10000000;
        salesRevenueObj2.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj2.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj2.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj2.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj2);

        insert salesRevenueList;

        
        test.starttest();
            Datetime nextSchedule = system.now().addSeconds(3);

            String hour = String.valueOf( nextSchedule.hour());
            String min = String.valueOf( nextSchedule.minute()); 
            String ss = String.valueOf( nextSchedule.second());
            String sDay = string.valueof( nextSchedule.day() ); 
            String sYear = string.valueof( nextSchedule.year() );
            String sMonth = string.valueof( nextSchedule.month() );

            String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

            Upsert_Profitability_GSM_Actual_Schedule test1 = new Upsert_Profitability_GSM_Actual_Schedule(); 
            System.schedule('Upsert_Profitability_GSM_Actual_Schedule ' + String.valueOf(system.now()), nextFireTime, test1);
        test.stoptest();
    }

    static testMethod void myUnitTest4() {
        insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Id recordTypeId_ProfitabilityGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('GSM').getRecordTypeId();

        List<ProfitabilityController__c> EmailSettingList = new list<ProfitabilityController__c>();
        
        ProfitabilityController__c EmailSettingList_1 = new ProfitabilityController__c(); //space dan koma
        EmailSettingList_1.Name = 'Email_Notif_BatchClass';
        EmailSettingList_1.Additional_toAddress__c = 'test@gmail.com, test@gmail.com, test@gmail.com, test@gmail.com';
        EmailSettingList_1.Additional_toCCAddress__c = 'test@gmail.com, test@gmail.com, test@gmail.com, test@gmail.com';
        EmailSettingList.add(EmailSettingList_1);
        insert EmailSettingList;
        
        List<PNL_GSM_Setting_Actual__c> PNL_GSM_Setting_ActualList = new list<PNL_GSM_Setting_Actual__c>();

        PNL_GSM_Setting_Actual__c PNL_GSM_Setting_Actual_1 = new PNL_GSM_Setting_Actual__c();
        PNL_GSM_Setting_Actual_1.Name = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Margin__c = 0;
        PNL_GSM_Setting_Actual_1.Revenue_Category__c = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Active__c = true;
        PNL_GSM_Setting_ActualList.add(PNL_GSM_Setting_Actual_1);

        insert PNL_GSM_Setting_ActualList;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'idewap@xl.co.id', 
                           Username = uniqueName + '@test' + orgId + '.org', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = uniqueName.substring(18, 23), 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = pf.Id
                          ); 
        insert uu;

        Account accTest = new Account();
        accTest.RecordTypeId = recordTypeId_accBP;
        accTest.Name = 'Bank Maybank Indonesia Tbk';
        accTest.Unique_Name__c = 'Sentral Senayan Building 3';
        accTest.NumberOfEmployees = 2;
        accTest.Summary_Billing__c = false;
        accTest.Payer_For_GSM_Invoice__c = false;
        accTest.Using_HO_Billing_Address__c = false;
        accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
        accTest.Customer_VAT_Name__c = 'BANK MAYBANK INDONESIA TBK';
        accTest.Customer_Type__c = 'NONGSM';
        accTest.No_NPWP__c = '013093232091000';
        accTest.BillingStreet = 'hive';
        accTest.BillingState = 'hive';
        accTest.BillingCity = 'hive';
        accTest.BillingCountry = 'hive';
        accTest.BillingPostalCode = 'hive';
        accTest.ShippingStreet = 'hive';
        accTest.ShippingState = 'hive';
        accTest.ShippingCity = 'hive';
        accTest.ShippingCountry = 'hive';
        accTest.ShippingPostalCode = 'hive';
        accTest.Billing_Building_Name__c = 'hive';
        accTest.Shipping_Building_Name__c = 'hive';
        accTest.Field_Source__c = 'Bizstore Customer Registration';
        accTest.Organization_Type__c = 'Head Office';
        accTest.Type = 'Customer';
        accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        accTest.OU__c = '1';
        accTest.Industry = 'Agriculture';
        accTest.BP_Number__c = '714197';
        accTest.Bizstore_Complete__c = false;
        Insert accTest;
        
        Account accTest2 = new Account(
            Name = 'PT Bank MayBank Indonesia Tbk',                         
            RecordTypeId = recordTypeId_accBP,                                     
            BP_Number__c = '707310',                                        
            Organization_Type__c = 'Branch',                                
            Type = 'Customer',                                              
            ParentId = accTest.Id,                                         
            Unique_Name__c = 'KCP Surabaya Pondok Candra',                  
            Customer_Type__c = 'NONGSM',                                    
            Payer_For_GSM_Invoice__c = false,                               
            term_of_payment__c = 'Z030 Within 30 Days Due Net',             
            Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)',
            Customer_VAT_Name__c = 'PT Bank MayBank Indonesia Tbk',         
            Summary_Billing__c = false,                                     
            Using_HO_Billing_Address__c = false                             
        );
        insert accTest2;

        Revenue_Category__c revenueCategory = new Revenue_Category__c();
        revenueCategory.Name = 'Postpaid';
        revenueCategory.Full_Name__c = 'Postpaid';
        Insert revenueCategory;

        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMGSObj;

        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMObj;

        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'Connectivity Mobile',
            Unique_ID__c = 'Connectivity Mobile',
            Type__c = 'BAU'
        );
        insert groupServiceObj;

        List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        
        Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue';
        salesRevenueObj.month__c = '6';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = 'Postpaid';
        salesRevenueObj.customer_bp_no__c = '707310';
        salesRevenueObj.Customer__c = accTest2.Id;
        salesRevenueObj.amount__c = 10000000;
        salesRevenueObj.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj);

        Sales_Revenue__c salesRevenueObj2 = new Sales_Revenue__c();
        salesRevenueObj2.type__c = 'Actual Revenue';
        salesRevenueObj2.month__c = '6';
        salesRevenueObj2.year__c = '2021';
        salesRevenueObj2.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj2.AM_Employee_ID__c = '90004036';
        salesRevenueObj2.revenue_category_name__c = 'Postpaid';
        salesRevenueObj2.customer_bp_no__c = '714197';
        salesRevenueObj2.Customer__c = accTest.Id;
        salesRevenueObj2.amount__c = 10000000;
        salesRevenueObj2.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj2.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj2.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj2.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj2);

        insert salesRevenueList;

        
        test.starttest();
            Datetime nextSchedule = system.now().addSeconds(3);

            String hour = String.valueOf( nextSchedule.hour());
            String min = String.valueOf( nextSchedule.minute()); 
            String ss = String.valueOf( nextSchedule.second());
            String sDay = string.valueof( nextSchedule.day() ); 
            String sYear = string.valueof( nextSchedule.year() );
            String sMonth = string.valueof( nextSchedule.month() );

            String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

            Upsert_Profitability_GSM_Actual_Schedule test1 = new Upsert_Profitability_GSM_Actual_Schedule(); 
            System.schedule('Upsert_Profitability_GSM_Actual_Schedule ' + String.valueOf(system.now()), nextFireTime, test1);
        test.stoptest();
    }

    static testMethod void myUnitTest5() {
        insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Id recordTypeId_ProfitabilityGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('GSM').getRecordTypeId();

        List<ProfitabilityController__c> EmailSettingList = new list<ProfitabilityController__c>();
        
        ProfitabilityController__c EmailSettingList_1 = new ProfitabilityController__c(); //koma dan pipe
        EmailSettingList_1.Name = 'Email_Notif_BatchClass';
        EmailSettingList_1.Additional_toAddress__c = 'test@gmail.com,test@gmail.com|test@gmail.com';
        EmailSettingList_1.Additional_toCCAddress__c = 'test@gmail.com,test@gmail.com|test@gmail.com';
        EmailSettingList.add(EmailSettingList_1);
        insert EmailSettingList;
        
        List<PNL_GSM_Setting_Actual__c> PNL_GSM_Setting_ActualList = new list<PNL_GSM_Setting_Actual__c>();

        PNL_GSM_Setting_Actual__c PNL_GSM_Setting_Actual_1 = new PNL_GSM_Setting_Actual__c();
        PNL_GSM_Setting_Actual_1.Name = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Margin__c = 0;
        PNL_GSM_Setting_Actual_1.Revenue_Category__c = 'Postpaid';
        PNL_GSM_Setting_Actual_1.Active__c = true;
        PNL_GSM_Setting_ActualList.add(PNL_GSM_Setting_Actual_1);

        insert PNL_GSM_Setting_ActualList;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'idewap@xl.co.id', 
                           Username = uniqueName + '@test' + orgId + '.org', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = uniqueName.substring(18, 23), 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = pf.Id
                          ); 
        insert uu;

        Account accTest = new Account();
        accTest.RecordTypeId = recordTypeId_accBP;
        accTest.Name = 'Bank Maybank Indonesia Tbk';
        accTest.Unique_Name__c = 'Sentral Senayan Building 3';
        accTest.NumberOfEmployees = 2;
        accTest.Summary_Billing__c = false;
        accTest.Payer_For_GSM_Invoice__c = false;
        accTest.Using_HO_Billing_Address__c = false;
        accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
        accTest.Customer_VAT_Name__c = 'BANK MAYBANK INDONESIA TBK';
        accTest.Customer_Type__c = 'NONGSM';
        accTest.No_NPWP__c = '013093232091000';
        accTest.BillingStreet = 'hive';
        accTest.BillingState = 'hive';
        accTest.BillingCity = 'hive';
        accTest.BillingCountry = 'hive';
        accTest.BillingPostalCode = 'hive';
        accTest.ShippingStreet = 'hive';
        accTest.ShippingState = 'hive';
        accTest.ShippingCity = 'hive';
        accTest.ShippingCountry = 'hive';
        accTest.ShippingPostalCode = 'hive';
        accTest.Billing_Building_Name__c = 'hive';
        accTest.Shipping_Building_Name__c = 'hive';
        accTest.Field_Source__c = 'Bizstore Customer Registration';
        accTest.Organization_Type__c = 'Head Office';
        accTest.Type = 'Customer';
        accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        accTest.OU__c = '1';
        accTest.Industry = 'Agriculture';
        accTest.BP_Number__c = '714197';
        accTest.Bizstore_Complete__c = false;
        Insert accTest;
        
        Account accTest2 = new Account(
            Name = 'PT Bank MayBank Indonesia Tbk',                         
            RecordTypeId = recordTypeId_accBP,                                     
            BP_Number__c = '707310',                                        
            Organization_Type__c = 'Branch',                                
            Type = 'Customer',                                              
            ParentId = accTest.Id,                                         
            Unique_Name__c = 'KCP Surabaya Pondok Candra',                  
            Customer_Type__c = 'NONGSM',                                    
            Payer_For_GSM_Invoice__c = false,                               
            term_of_payment__c = 'Z030 Within 30 Days Due Net',             
            Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)',
            Customer_VAT_Name__c = 'PT Bank MayBank Indonesia Tbk',         
            Summary_Billing__c = false,                                     
            Using_HO_Billing_Address__c = false                             
        );
        insert accTest2;

        Revenue_Category__c revenueCategory = new Revenue_Category__c();
        revenueCategory.Name = 'Postpaid';
        revenueCategory.Full_Name__c = 'Postpaid';
        Insert revenueCategory;

        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMGSObj;

        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c(name = '{DEFAULT}', year__c = '2021', month__c = '1');
        insert sprM_AMObj;

        Group_Service__c groupServiceObj = new Group_Service__c(
            Name = 'Connectivity Mobile',
            Unique_ID__c = 'Connectivity Mobile',
            Type__c = 'BAU'
        );
        insert groupServiceObj;

        List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        
        Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue';
        salesRevenueObj.month__c = '6';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = 'Postpaid';
        salesRevenueObj.customer_bp_no__c = '707310';
        salesRevenueObj.Customer__c = accTest2.Id;
        salesRevenueObj.amount__c = 10000000;
        salesRevenueObj.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj);

        Sales_Revenue__c salesRevenueObj2 = new Sales_Revenue__c();
        salesRevenueObj2.type__c = 'Actual Revenue';
        salesRevenueObj2.month__c = '6';
        salesRevenueObj2.year__c = '2021';
        salesRevenueObj2.Period_Date__c = date.newInstance(2021, 06, 06);
        salesRevenueObj2.AM_Employee_ID__c = '90004036';
        salesRevenueObj2.revenue_category_name__c = 'Postpaid';
        salesRevenueObj2.customer_bp_no__c = '714197';
        salesRevenueObj2.Customer__c = accTest.Id;
        salesRevenueObj2.amount__c = 10000000;
        salesRevenueObj2.Revenue_Category__c = revenueCategory.Id;
        salesRevenueObj2.Group_Service__c = groupServiceObj.Id;
        salesRevenueObj2.Sales_Performance_Monthly_AMGS__c = sprM_AMGSObj.id;
        salesRevenueObj2.Sales_Performance_Monthly_AM__c = sprM_AMObj.id;
        salesRevenueList.add (salesRevenueObj2);

        insert salesRevenueList;

        
        test.starttest();
            Datetime nextSchedule = system.now().addSeconds(3);

            String hour = String.valueOf( nextSchedule.hour());
            String min = String.valueOf( nextSchedule.minute()); 
            String ss = String.valueOf( nextSchedule.second());
            String sDay = string.valueof( nextSchedule.day() ); 
            String sYear = string.valueof( nextSchedule.year() );
            String sMonth = string.valueof( nextSchedule.month() );

            String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

            Upsert_Profitability_GSM_Actual_Schedule test1 = new Upsert_Profitability_GSM_Actual_Schedule(); 
            System.schedule('Upsert_Profitability_GSM_Actual_Schedule ' + String.valueOf(system.now()), nextFireTime, test1);
        test.stoptest();
    }
}