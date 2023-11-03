@isTest
public class PresurveyTriggerTEST {
    public static List<Tower_Candidate__c> towerCandidateList = new List<Tower_Candidate__c>();

    @testSetup
    static void makeData(){
        // create user AM
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
            // COMENT DULU
            Billing_Address_Province__c = 'jawa tengah',   
            Billing_Address_City__c = 'kota surakarta',
            Shipping_Address_Province__c = 'jawa tengah',
            Shipping_Address_City__c = 'kota surakarta',
            */
            ShippingStreet = 'JL TG DUREN RAYA NO 4 GD BLOK E LT 5 TANJUNG DUREN UTARA - GROGOL PETAMBURAN JAKARTA BARAT'                                                                      
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

            
            Test.startTest();
            //Presurvey__c  presurvey = PresurveyDataFactory.generateNewPresurveyWithAccount(acc, usr.Id);

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

            insert presurvey;

            presurvey.Presurvey_Status__c = 'Submit';
            presurvey.Update_Source__c = 'Integration';

            update presurvey;

            System.debug('===== Presurvey inserted : psId : '+presurvey.Id+' =====');
            //validate single insert
           
            Presurvey__c tobeSubmitPs = [Select Id, Customer_Name__c, Solution_PIC__c, Account__c from Presurvey__c where Id =:presurvey.Id ];
            system.debug('tobeSubmitPs: ' + json.serialize(tobeSubmitPs));
            System.debug('===== presurvey.id :  '+presurvey.Id+ ' <> tobeSubmitPs.id :'+tobeSubmitPs.Id+' =====');
            System.assertEquals(acc.Name, tobeSubmitPs.Customer_Name__c);
            System.debug('===== Solution solmapp :  '+solmapp.Portfolio_Management_Support__c+ ' <> Solution tobeSubmitPs:'+tobeSubmitPs.Solution_PIC__c+' =====');
            System.assertEquals(solmapp.Portfolio_Management_Support__c, tobeSubmitPs.Solution_PIC__c);

            Lead generatedLead = [Select Id, Presurvey__c, Company, Business_Partner__c, LeadSource, Status from Lead where Presurvey__c =:tobeSubmitPs.Id LIMIT 1];    
            system.debug('generatedLead: ' + generatedLead);
            System.debug('===== Lead.id :  '+generatedLead.Id);
            System.assert(generatedLead!=Null);
            System.assertEquals(generatedLead.Business_Partner__c, acc.Id);
            System.assertEquals(generatedLead.company, acc.Name);
           
            Test.stopTest();           
       }  
    }
    /*
    // coment dulu
    @isTest
    public static void TestInsertPresurveyWithoutAccount(){
       System.debug('===== TestPresurveyTriggerHandler.testInsertPresurveyWithAccount =====');
        System.debug('===== Starting Setup Test Data =====');
       
        User usr=[SELECT id from user WHERE Name='Yopi Apriyana' and IsActive = TRUE LIMIT 1];
        Account acc =[SELECT id,Name from Account where Organization_Type__c = 'Head Office' LIMIT 1];
        AM_Portfolio_Mapping__c solmapp = [SELECT id, Portfolio_Management_Support__c,AM__c,Status__c from AM_Portfolio_Mapping__c where Status__c = 'Active' LIMIT 1];
          
        System.debug('===== Starting Test ====='); 
        System.RunAs( usr ){
            Test.startTest();
            Presurvey__c  presurvey = PresurveyDataFactory.generateNewPresurvey(usr.Id);
            insert presurvey;

            presurvey.ownerid = usr.id;
            update presurvey;
            //validate single insert
            System.debug('===== Presurvey inserted : psId : '+presurvey.Id+' =====');
           
            Presurvey__c tobeSubmitPs = [Select Id, Customer_Name__c, Solution_PIC__c, Account__c from Presurvey__c where Id =:presurvey.Id ];
            System.debug('===== presurvey.customer :  '+presurvey.Customer_Name__c+ ' <> tobeSubmitPs.customer :'+presurvey.Customer_Name__c+' =====');
            System.assertEquals(presurvey.Customer_Name__c, tobeSubmitPs.Customer_Name__c);
            System.debug('===== Solution solmapp :  '+solmapp.Portfolio_Management_Support__c+ ' <> Solution tobeSubmitPs:'+tobeSubmitPs.Solution_PIC__c+' =====');
            System.assertEquals(solmapp.Portfolio_Management_Support__c, tobeSubmitPs.Solution_PIC__c);
            tobeSubmitPs.Presurvey_Status__c = 'Submit';
            update tobeSubmitPs;
           
            Lead generatedLead = [Select Id, Presurvey__c, Company, LeadSource, Status from Lead where Presurvey__c =:tobeSubmitPs.Id LIMIT 1];
            System.debug('===== Lead.id :  '+generatedLead.Id);
            System.assert(generatedLead!=Null);            
            System.assertEquals(generatedLead.company, tobeSubmitPs.Customer_Name__c);
           
            Test.stopTest();           
       }
    }
    */
}