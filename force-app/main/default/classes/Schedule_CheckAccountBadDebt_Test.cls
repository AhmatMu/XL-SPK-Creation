@istest
public with sharing class Schedule_CheckAccountBadDebt_Test {
   
    @TestSetup
    static void makeData(){
        //custom setting for query condition
        Sobject_Query_Condition__c sobjectQueryConditionSettings = new Sobject_Query_Condition__c();
        sobjectQueryConditionSettings.name = 'Schedule_CheckAccountBadDebt';
        sobjectQueryConditionSettings.Automation_Name__c = 'opptyListCondition';
        sobjectQueryConditionSettings.Object_Name__c = 'Opportunity';
        sobjectQueryConditionSettings.Where_Condition__c = 'prospecting;survey;negotiation;quotation final';

        insert sobjectQueryConditionSettings;

        id accRecType = Schema.SObjectType.account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        // === parent account  ====

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

        Transaction__c settings = new Transaction__c();
        settings.transactionID__c = 68756;
        settings.Temporary_LA_or_IDCom__c = 2499;

        insert settings;


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

        Account accObj = new Account(
            Name = 'PT Bank CIMB Niaga Tbk [View Hierarchy]',  // Account Name
            RecordTypeId = accRecType,                          // Account Record Type
            BP_Number__c = '710124',                             // BP Number
            Organization_Type__c = 'Branch',                     // Organization Type
            Type = 'Customer',                                   // Type
            ParentId = AccParentObj.id,   
            Unique_Name__c = 'Jakarta Menara Asia Lt.10',  
            Bad_Debt_Status__c = 'true',
            Bad_Debt_Last_Checking_Date__c = datetime.newInstance(2022, 9, 15, 13, 30, 0),
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



        Pricebook2 DADSPOSPricebook = new Pricebook2( name = 'DADSPOS-01',
                                                     IsActive = true
                                                    );

        id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Digital Advertising').getRecordTypeId();
        Opportunity oppObj = new Opportunity(
            RecordTypeId = oppRecType,                          // Opportunity Record Type
            trial__c = false, 
            OwnerId = AMobj.id,                                    // trial
            Service_Group__c = 'GSM',                            // Service Group
            Name = 'opptyTest2',                                   // Opportunity Name
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

        Opportunity oppObj2 = new Opportunity(
            RecordTypeId = oppRecType,                          // Opportunity Record Type
            trial__c = false, 
            OwnerId = AMobj.id,                                    // trial
            Service_Group__c = 'GSM',                            // Service Group
            Name = 'oppty test 2',                                   // Opportunity Name
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
        
        insert oppObj2;
    }

    @isTest 
    static void Schedule_CheckAccountBadDebtTest(){



        test.startTest();

        Schedule_CheckAccountBadDebt scheduleObj = new Schedule_CheckAccountBadDebt ();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, scheduleObj);

        test.stopTest();
    }
}