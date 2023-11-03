@isTest
private class TA_AT_PresurveyCalloutOlympusTEST {
    @testSetup
    static void makeData(){

        Olympus_API_Setting__c  Olympus_APISetting_TowerCandidate = new Olympus_API_Setting__c();
        Olympus_APISetting_TowerCandidate.Name = 'calloutGetTowerCandidate';
        Olympus_APISetting_TowerCandidate.end_point__c = 'https://olympus.xlaxiata.id/sit/fiber-route/sales-force.invalid'; // invalid
        Olympus_APISetting_TowerCandidate.Method__c = 'POST';
        Olympus_APISetting_TowerCandidate.Timeout__c = 120000;
        Olympus_APISetting_TowerCandidate.Token_Key__c = 'dapiae2e9d4541c4930ea649e22667b68361';
        Olympus_APISetting_TowerCandidate.uri__c = '/proxy-olympus/v1/post-fibersalesforce.invalid'; // invalid
        Olympus_APISetting_TowerCandidate.url__c = 'https://gateway.egw.xl.co.id';
        Olympus_APISetting_TowerCandidate.header__c = 'xc-authorization: Bearer dapiae2e9d4541c4930ea649e22667b68361; Content-Type: application/json';
        insert Olympus_APISetting_TowerCandidate;

        Olympus_API_Setting__c olympusGetAccessTokenSettings = new Olympus_API_Setting__c();
        olympusGetAccessTokenSettings.Name = 'getAccessTokenOlympus';
        olympusGetAccessTokenSettings.end_point__c = 'https://olympus.xlaxiata.id/sit/fiber-route/sales-force.invalid'; // invalid
        olympusGetAccessTokenSettings.Method__c = 'POST';
        olympusGetAccessTokenSettings.Timeout__c = 120000;
        olympusGetAccessTokenSettings.Token_Key__c = 'dapiae2e9d4541c4930ea649e22667b68361';
        olympusGetAccessTokenSettings.uri__c = '/oauth.invalid'; // invalid
        olympusGetAccessTokenSettings.url__c = 'https://gateway.egw.xl.co.id';
        olympusGetAccessTokenSettings.Client_ID__c = 'FdKNuFjwgfYlpL4uEjL5rxBJwKQa';
        olympusGetAccessTokenSettings.Client_Secret__c = 'cB8WEz3Y5uuJVIgn03KFa6PkBYwa';
        olympusGetAccessTokenSettings.Grant_Type__c = 'client_credentials';
        olympusGetAccessTokenSettings.header__c = 'Content-Type: application/x-www-form-urlencoded; Cookie: __cf_bm=zaKnz2ZaF6TMEU908iX9vKTnG5yWOZZY_JF0T9vshKs-1687253639-0-AfHwWGAX5oofrhxkXdoW+Zn15PRLoWRYD8R8AEegGQPsto7klDqHJhcqEMDfu8wAL8nSALAoiIt9rZjQLF9/WTw=';

        insert olympusGetAccessTokenSettings;
    
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
            //ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002724',                                                 // Employee ID
            //Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'kita',
            LastName='bisa'
        );
        insert AMobj;
        
        // create user Solution
        Profile solProfile = [SELECT Id FROM Profile WHERE Name='Solution']; 
        User solobj = new User(                                              // Role
            Alias = 'kita',
            EmailEncodingKey='UTF-8',
            Email = 'kita@xl.co.id',                                                   // Email
            ProfileId = solProfile.id,                                                     // Profile
            Username = '1kita@xl.co.id',                                                // Username
            IsActive = true,                                                             // Active
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            Department = 'XL Business Solutions',                                        // Department
            //ManagerId = salesManagerobj.id,                                               // Manager
            MobilePhone = '+62 817737929',                                               // Mobile
            Employee_ID__c = '90002724',                                                 // Employee ID
            //Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
            Grade__c = '16',   
            firstName = 'kita',
            LastName='bisa'
        );
        insert solobj;
        
        // create account ho
        // create account ho
        id accRecType = Schema.SObjectType.account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
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
            
            /*
            Billing_Address_Province__c = 'jawa tengah',   
            Billing_Address_City__c = 'kota surakarta',
            Shipping_Address_Province__c = 'jawa tengah',
            Shipping_Address_City__c = 'kota surakarta',
            */
            
            ShippingStreet = 'JL TG DUREN RAYA NO 4 GD BLOK E LT 5 TANJUNG DUREN UTARA - GROGOL PETAMBURAN JAKARTA BARAT'                                                                      // No NPWP
        );
        //trigger_controller__c triggercontrollerAccount = trigger_controller__c.getValues('Trigger_Account');
        //triggercontrollerAccount.Is_Active__c = false;
        TriggerBase.bypass('Account');
        
        insert AccParentObj;
        
        TriggerBase.clearBypass('Account');
        //triggercontrollerAccount.Is_Active__c = true;
        //update triggercontrollerAccount;
        
        //create ampportofolio
        AM_Portfolio_Mapping__c amPortobj = new AM_Portfolio_Mapping__c(
          AM__c = AMobj.id,                          // AM
          Portfolio_Management_Support__c = solobj.id,  // Portfolio Management Support
          Status__c = 'Active'                           // Status
        );
        insert amPortobj;  

        //CREATE CUST SETTING PRESURVEY TRIGGER

        Trigger_Controller__c triggercontroller = new Trigger_Controller__c();
        triggercontroller.Is_Active__c = true;
        triggercontroller.name = 'Trigger_Presurvey';

        insert triggercontroller;

        // create custom setting Presurvey General
        Presurvey_General_Setting__c csGeneralSetting = new Presurvey_General_Setting__c();
        csGeneralSetting.name = 'Counting_Call_API';
        csGeneralSetting.API_Call_Interval_for_Get_Tower__c = 1;
        csGeneralSetting.API_Call_Max_for_Get_Tower__c = 12;

        insert csGeneralSetting;
    }  

    @testVisible    
    private static String generateRandomString(Integer len) {
        final String chars = 'xaxPmno2IDdEwLzbtEvhv6oG1RDT6xQJX3MvF4amaDQ9TUvHgJfdbodlllPTnnuw';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
    @testVisible
    private static String generateRandomNumber(Integer len) {
        final String chars = '0129875346';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }    
    @isTest
    public static void testInsertPresurveyWithAccount(){
        System.debug('===== TestPresurveyTriggerHandler.testInsertPresurveyWithAccount =====');
        System.debug('===== Starting Setup Test Data =====');
       
        User usr = [SELECT id from user WHERE LastName = 'bisa' and IsActive = TRUE LIMIT 1];
        Account acc = [SELECT id,Name from Account where Organization_Type__c='Head Office' LIMIT 1];
        AM_Portfolio_Mapping__c solmapp = [SELECT id,Portfolio_Management_Support__c,AM__c,Status__c from AM_Portfolio_Mapping__c where Status__c = 'Active' LIMIT 1];
        system.debug('solmapp: ' + json.serialize(solmapp));
        system.debug('acc: ' + json.serialize(acc));
        system.debug('usr: ' + json.serialize(acc));

        System.debug('===== Starting Test ====='); 
        System.RunAs( usr ){  

            Presurvey__c presurvey = new Presurvey__c();
            presurvey.Customer_Name__c                  = acc.Name;
            presurvey.OwnerId                           = usr.id;
            presurvey.Account__c                        = acc.Id;
            presurvey.Solution_PIC__c                   = solmapp.Portfolio_Management_Support__c;
            presurvey.Capacity__c                       = 10;
            presurvey.UoM_Capacity__c                   = 'Mbps';
            presurvey.Presurvey_Status__c               = 'Draft';
            presurvey.Customer_Requirement__c           = 'For Test Purposed Only.\nSingleRecord ';
            presurvey.Service_Group__c                  = 'NON GSM';
            presurvey.Service__c                        = 'MPLS';
            presurvey.Province_Site_A__c                = 'Sumatera Selatan';
            presurvey.Coordinate_Site_A__Latitude__s    = 0;
            presurvey.Coordinate_Site_A__Longitude__s   = 113.867569;
            presurvey.Coordinate_Site_B__Latitude__s    = 0;
            presurvey.Coordinate_Site_B__Longitude__s   = 113.867569;
            presurvey.City_Site_A__c                    = 'Kabupaten Musi Banyuasin';
            presurvey.Need_Tower_Candidate_Site_A__c    = false;
            presurvey.Need_Tower_Candidate_Site_B__c    = true;
            presurvey.Location_Site_A__c                = generateRandomString(40);
            presurvey.Update_Source__c                  = 'User';
            presurvey.In_Progress_Status__c             = null;
            presurvey.Get_Tower_API_Call_Number__c      = 0;

            insert presurvey;

            Test.startTest();

            presurvey.Presurvey_Status__c           = 'Submit';
            presurvey.In_Progress_Status__c         = 'Need to Request';
            presurvey.Get_Tower_API_Call_Number__c  = 1;

            update presurvey;

            Test.stopTest();           
       }  
    }

    /*
    @isTest
    static void testExceptionFail(){
        User usr = [SELECT id from user WHERE LastName = 'bisa' and IsActive = TRUE LIMIT 1];
        Account acc = [SELECT id,Name from Account where Organization_Type__c='Head Office' LIMIT 1];
        AM_Portfolio_Mapping__c solmapp = [SELECT id,Portfolio_Management_Support__c,AM__c,Status__c from AM_Portfolio_Mapping__c where Status__c = 'Active' LIMIT 1];

        Presurvey__c presurvey = new Presurvey__c();
        presurvey.Customer_Name__c = acc.Name;
        presurvey.OwnerId = usr.id;
        presurvey.Account__c = acc.Id;
        presurvey.Solution_PIC__c = solmapp.Portfolio_Management_Support__c;
        presurvey.Capacity__c = 10;
        presurvey.UoM_Capacity__c = 'Mbps';
        presurvey.Presurvey_Status__c = 'Draft';
        presurvey.Customer_Requirement__c = 'For Test Purposed Only.\nSingleRecord ';
        presurvey.Service_Group__c = 'NON GSM';
        presurvey.Service__c = 'MPLS';
        presurvey.Province_Site_A__c = 'Sumatera Selatan';
        presurvey.Coordinate_Site_A__Latitude__s=0;
        presurvey.Coordinate_Site_A__Longitude__s=113.867569;
        presurvey.Coordinate_Site_B__Latitude__s=0;
        presurvey.Coordinate_Site_B__Longitude__s=113.867569;
        presurvey.City_Site_A__c = 'Kabupaten Musi Banyuasin';
        presurvey.Need_Tower_Candidate_Site_A__c=false;
        presurvey.Need_Tower_Candidate_Site_B__c=true;
        presurvey.Location_Site_A__c = generateRandomString(40);
        presurvey.Update_Source__c = 'Integration';
        presurvey.In_Progress_Status__c = null;
        presurvey.Get_Tower_API_Call_Number__c = 0;

        insert presurvey;
        
    
            test.startTest();
        System.runAs(usr){
            try{
                presurvey.Update_Source__c = 'Integrations';
            } catch (DmlException ex) {
                System.assertEquals('Insert failed. First exception on row 0; first error: INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, Update Source: bad value for restricted picklist field: Integrations: [Update_Source__c]', ex.getMessage());
            }  
            test.stopTest();
        }
    }
    */
}