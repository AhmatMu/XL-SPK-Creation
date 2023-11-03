/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest(seealldata = true)
private class testSR_PR {
    
    static testmethod void syncBP() {
        Account A = [SELECT id, Name FROM Account LIMIT 1];
        A.Name = 'test';
        update A;
        Scheduled_Process__c sp = [select id, jobid__c from Scheduled_Process__c order by createddate DESC LIMIT 1];
        SyncBPToEasyOps.updateBP(A.id, SP.Jobid__c);
    }
    
    static testmethod void TriggerSRPR() {
        //		   user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        
        user userObj = [SELECT id from user WHERE Name = 'Nityo Triantono'
                        LIMIT 1
                       ];
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
                         LIMIT 1
                        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c = 'LL-02'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c = 'Head Office'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
                    ];
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign; PIC BA Recipient; PIC BA Print';
        insert CR;
        
        //novi , add data vendor 10 maret 2021
        Vendor__c datavendor = new Vendor__c();
        datavendor.name = 'test vendor';
        datavendor.type__c = 'Partner';
        datavendor.listemail__c = 'vendor@test.com;vendor1@test.com;vendor2@test.com';
        datavendor.Ownerid = userObj.id;
        insert datavendor;
        
        Create_PR_SR CPS = new Create_PR_SR();
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                               ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        
        /*Vendor__c V = [SELECT id from Vendor__c where type__c = 'Partner'
LIMIT 1
];*/
        
        Vendor__c vendorObj = new  Vendor__c (
            name = 'PT Centratama Menara Indonesia',
            Type__c = 'Partner',
            ListEmail__c = 'bro@gmail.com; sis@gmail.com'
        );
        insert vendorObj;
        
        Opportunity O2 = new Opportunity();
        o2.ownerid = userObj.id;
        O2.Accountid = HQ.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = A.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Contract_Periode__c = 12;
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = A.id;
        O2.BP_Vat__c = A.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2;
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        
        
        CPS.CreateSR(O2);
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c FROM SR_PR_Notification__c WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: OLI.Opportunityid LIMIT 1
                                    ];
        SP3.Survey_Lastmile_type__c = 'Lastmile by Partner';
         // ADD SERVICES
        SP3.services__c = 'LL';
        
        SP3.Status__c = 'Assigned';
        SP3.Survey_type__c = 'P2P';
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        update SP3;
        SP3.Solution_Partner_Approval__c = 'Approved';
        SP3.Status__c = 'In Progress';
        SP3.Partner_Name__c = vendorObj.id;
        update SP3;
        //test021121
        SP3.Status__c='Close(Not Deliver)';
        SP3.Reasons__c = 'R04 Cust Schedule';
        update SP3;
        SP3.Status__c = 'Close(Cancel)';
        update SP3;
        SP3.Status__c = 'Rejected';
        update SP3;
        SP3.Status__c = 'Close(Complete)';
        update SP3;
        CPS.CreatePR(O2);
        
        test.startTest();
        SR_PR_notification__c SP4 = [SELECT id FROM SR_PR_Notification__c WHERE notif_type__c = 'PR'
                                     and Opportunity__c =: OLI.Opportunityid LIMIT 1
                                    ];
        SP4.Account__c = A.id;
        SP4.Trial__c = true;
        SP4.Billing_Start_Date__c = system.today();
        SP4.Project_Complete_Date__c = system.today();
        SP4.Status__c = 'Waiting Berita Acara';
        update SP4;
        test.stopTest();
        
    }
    
    static testmethod void sendemailSRPR() {
        user userObj = [SELECT id from user WHERE Name like '%Nityo%'
                        LIMIT 1
                       ];
        
        RecordType rt = [SELECT id FROM RecordType WHERE Name like '%Non GSM%'
                         LIMIT 1
                        ];
        
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c like '%LL-02%'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c like '%Head Office%'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        
        
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
                    ];
        
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        
        //novi , add data vendor 10 maret 2021
        Vendor__c datavendor = new Vendor__c();
        datavendor.name = 'test vendor';
        datavendor.type__c = 'Vendor';
        datavendor.listemail__c = 'vendor@test.com;vendor1@test.com;vendor2@test.com';
        datavendor.Ownerid = userObj.id;
        insert datavendor;
        
        Create_PR_SR CPS = new Create_PR_SR();
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                                ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        
        Vendor__c vendorObj = new  Vendor__c (
            Name = 'PT Centratama Menara Indonesia', // Vendor Name
            Type__c = 'Vendor',                       // Type
            ListEmail__c = 'bro@gmail.com; sis@gmail.com'
        );
        insert vendorObj;
        
        system.debug('vendor =' + vendorObj);
        
        Opportunity O2 = new Opportunity();
        O2.ownerid = userObj.id;
        O2.Accountid = a.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = a.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Contract_Periode__c = 12;
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = a.id;
        O2.BP_Vat__c = a.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2; 
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        CPS.CreateSR(O2);
        
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c, Opportunity__c, Project_Name__c, Name, Project_type__c, 
                                     Capacity_After__c, UOM_After__c, Project_Coordinator_Text__c, Services__c, Site_A__c, Site_B__c 
                                     FROM SR_PR_Notification__c 
                                     WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: O2.id LIMIT 1
                                    ];
        

      

        Test.startTest();
        
        SP3.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP3.Status__c = 'Close(Complete)';
        SP3.Survey_type__c = 'P2P';
        SP3.Vendor__c = vendorObj.id;
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        SP3.Services__c = 'LL';
        update SP3;

        List<EmailNotif_SRPR__c> EmailNotif_SRPR_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM EmailNotif_SRPR__c];

        for(EmailNotif_SRPR__c EmailNotif_SRPR_List_Extract : EmailNotif_SRPR_List){
            EmailNotif_SRPR_List_Extract.Additional_toAddress__c = 'test@gmail.com test@gmail.com test@gmail.com';
            EmailNotif_SRPR_List_Extract.Additional_toCCAddress__c ='test@gmail.com test@gmail.com test@gmail.com';
        }
        update EmailNotif_SRPR_List;

        SendEmailSRPR.sendemailtoVendor(SP3);
        SendEmailSRPR.sendemailAssigned(SP3);
        SendEmailSRPR.sendemailCloseSR(SP3);
        CPS.CreatePR(O2);
        CPS.setAutorenewal(5, 'Month');
        
      SR_PR_notification__c SP4 = [SELECT id FROM SR_PR_Notification__c 
                                     WHERE notif_type__c = 'PR' 
                                     and Opportunity__c =: O2.id LIMIT 1];

        
          SP4.Status__c = 'Cancel';
          SP4.Reasons__c = 'R14 BA Not Assigned';
          
          update SP4;

        for(EmailNotif_SRPR__c EmailNotif_SRPR_List_Extract : EmailNotif_SRPR_List){
            EmailNotif_SRPR_List_Extract.Additional_toAddress__c = 'test@gmail.com test@gmail.com test@gmail.com';
            EmailNotif_SRPR_List_Extract.Additional_toCCAddress__c ='test@gmail.com test@gmail.com test@gmail.com';
        }
        update EmailNotif_SRPR_List;

        SendEmailSRPR.sendemailtoVendor(SP3);
        SendEmailSRPR.sendemailAssigned(SP3);
        SendEmailSRPR.sendemailCloseSR(SP3);
       test.stopTest();
    }

    static testmethod void sendemailSRPR2() {
        user userObj = [SELECT id from user WHERE Name like '%Nityo%'
                        LIMIT 1
                       ];
        
        RecordType rt = [SELECT id FROM RecordType WHERE Name like '%Non GSM%'
                         LIMIT 1
                        ];
        
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c like '%LL-02%'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c like '%Head Office%'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        
        
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
        ];
        
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        
        //novi , add data vendor 10 maret 2021
        Vendor__c datavendor = new Vendor__c();
        datavendor.name = 'test vendor';
        datavendor.type__c = 'Vendor';
        datavendor.listemail__c = 'vendor@test.com;vendor1@test.com;vendor2@test.com';
        datavendor.Ownerid = userObj.id;
        insert datavendor;
        
        Create_PR_SR CPS = new Create_PR_SR();
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                                ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        
        Vendor__c vendorObj = new  Vendor__c (
            Name = 'PT Centratama Menara Indonesia', // Vendor Name
            Type__c = 'Vendor',                       // Type
            ListEmail__c = 'bro@gmail.com; sis@gmail.com'
        );
        insert vendorObj;
        
        system.debug('vendor =' + vendorObj);
        
        Opportunity O2 = new Opportunity();
        O2.ownerid = userObj.id;
        O2.Accountid = a.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = a.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Contract_Periode__c = 12;
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = a.id;
        O2.BP_Vat__c = a.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2; 
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        CPS.CreateSR(O2);
        
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c, Opportunity__c, Project_Name__c, Name, Project_type__c, 
                                     Capacity_After__c, UOM_After__c, Project_Coordinator_Text__c, Services__c, Site_A__c, Site_B__c 
                                     FROM SR_PR_Notification__c 
                                     WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: O2.id LIMIT 1
                                    ];
        

      

        Test.startTest();
        
        SP3.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP3.Status__c = 'Close(Complete)';
        SP3.Survey_type__c = 'P2P';
        SP3.Vendor__c = vendorObj.id;
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        SP3.Services__c = 'LL';
        update SP3;

        List<EmailNotif_SRPR__c> EmailNotif_SRPR_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM EmailNotif_SRPR__c];

        for(EmailNotif_SRPR__c EmailNotif_SRPR_List_Extract : EmailNotif_SRPR_List){
            EmailNotif_SRPR_List_Extract.Additional_toAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com';
            EmailNotif_SRPR_List_Extract.Additional_toCCAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com';
        }
        update EmailNotif_SRPR_List;

        SendEmailSRPR.sendemailtoVendor(SP3);
        SendEmailSRPR.sendemailAssigned(SP3);
        SendEmailSRPR.sendemailCloseSR(SP3);
        CPS.CreatePR(O2);
        CPS.setAutorenewal(5, 'Month');
        
      SR_PR_notification__c SP4 = [SELECT id FROM SR_PR_Notification__c 
                                     WHERE notif_type__c = 'PR' 
                                     and Opportunity__c =: O2.id LIMIT 1];

        
          SP4.Status__c = 'Cancel';
          SP4.Reasons__c = 'R14 BA Not Assigned';
          
          update SP4;

        for(EmailNotif_SRPR__c EmailNotif_SRPR_List_Extract : EmailNotif_SRPR_List){
            EmailNotif_SRPR_List_Extract.Additional_toAddress__c = 'test@gmail.com test@gmail.com,test@gmail.com';
            EmailNotif_SRPR_List_Extract.Additional_toCCAddress__c ='test@gmail.com test@gmail.com,test@gmail.com';
        }
        update EmailNotif_SRPR_List;

        SendEmailSRPR.sendemailtoVendor(SP3);
        SendEmailSRPR.sendemailAssigned(SP3);
        SendEmailSRPR.sendemailCloseSR(SP3);
       test.stopTest();
    }

    static testmethod void sendemailSRPR3() {
        user userObj = [SELECT id from user WHERE Name like '%Nityo%'
                        LIMIT 1
                       ];
        
        RecordType rt = [SELECT id FROM RecordType WHERE Name like '%Non GSM%'
                         LIMIT 1
                        ];
        
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c like '%LL-02%'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c like '%Head Office%'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        
        
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
        ];


        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        
        //novi , add data vendor 10 maret 2021
        Vendor__c datavendor = new Vendor__c();
        datavendor.name = 'test vendor';
        datavendor.type__c = 'Vendor';
        datavendor.listemail__c = 'vendor@test.com;vendor1@test.com;vendor2@test.com';
        datavendor.Ownerid = userObj.id;
        insert datavendor;
        
        Create_PR_SR CPS = new Create_PR_SR();
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                                ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        
        
        Vendor__c vendorObj = new  Vendor__c (
            Name = 'PT Centratama Menara Indonesia', // Vendor Name
            Type__c = 'Vendor',                       // Type
            ListEmail__c = 'bro@gmail.com; sis@gmail.com'
        );
        insert vendorObj;
        
        system.debug('vendor =' + vendorObj);
        
        Opportunity O2 = new Opportunity();
        O2.ownerid = userObj.id;
        O2.Accountid = a.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = a.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Contract_Periode__c = 12;
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = a.id;
        O2.BP_Vat__c = a.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2; 
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        CPS.CreateSR(O2);
        
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c, Opportunity__c, Project_Name__c, Name, Project_type__c, 
                                     Capacity_After__c, UOM_After__c, Project_Coordinator_Text__c, Services__c, Site_A__c, Site_B__c 
                                     FROM SR_PR_Notification__c 
                                     WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: O2.id LIMIT 1
                                    ];
        

      

        Test.startTest();
        
        SP3.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP3.Status__c = 'Close(Complete)';
        SP3.Survey_type__c = 'P2P';
        SP3.Vendor__c = vendorObj.id;
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        SP3.Services__c = 'LL';
        update SP3;

        List<EmailNotif_SRPR__c> EmailNotif_SRPR_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM EmailNotif_SRPR__c];

        for(EmailNotif_SRPR__c EmailNotif_SRPR_List_Extract : EmailNotif_SRPR_List){
            EmailNotif_SRPR_List_Extract.Additional_toAddress__c = 'test@gmail.com test@gmail.com|test@gmail.com';
            EmailNotif_SRPR_List_Extract.Additional_toCCAddress__c = 'test@gmail.com test@gmail.com|test@gmail.com';
        }
        update EmailNotif_SRPR_List;

        SendEmailSRPR.sendemailtoVendor(SP3);
        SendEmailSRPR.sendemailAssigned(SP3);
        SendEmailSRPR.sendemailCloseSR(SP3);
        CPS.CreatePR(O2);
        CPS.setAutorenewal(5, 'Month');
        
      SR_PR_notification__c SP4 = [SELECT id FROM SR_PR_Notification__c 
                                     WHERE notif_type__c = 'PR' 
                                     and Opportunity__c =: O2.id LIMIT 1];

        
          SP4.Status__c = 'Cancel';
          SP4.Reasons__c = 'R14 BA Not Assigned';
          
          update SP4;

        for(EmailNotif_SRPR__c EmailNotif_SRPR_List_Extract : EmailNotif_SRPR_List){
            EmailNotif_SRPR_List_Extract.Additional_toAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com';
            EmailNotif_SRPR_List_Extract.Additional_toCCAddress__c ='test@gmail.com|test@gmail.com,test@gmail.com';
        }
        update EmailNotif_SRPR_List;

        SendEmailSRPR.sendemailtoVendor(SP3);
        SendEmailSRPR.sendemailAssigned(SP3);
        SendEmailSRPR.sendemailCloseSR(SP3);
       test.stopTest();
    }

    static testmethod void sendemailSRPR4() {
        user userObj = [SELECT id from user WHERE Name like '%Nityo%'
                        LIMIT 1
                       ];
        
        RecordType rt = [SELECT id FROM RecordType WHERE Name like '%Non GSM%'
                         LIMIT 1
                        ];
        
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c like '%LL-02%'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c like '%Head Office%'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        
        
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
        ];

        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        
        //novi , add data vendor 10 maret 2021
        Vendor__c datavendor = new Vendor__c();
        datavendor.name = 'test vendor';
        datavendor.type__c = 'Vendor';
        datavendor.listemail__c = 'vendor@test.com;vendor1@test.com;vendor2@test.com';
        datavendor.Ownerid = userObj.id;
        insert datavendor;
        
        Create_PR_SR CPS = new Create_PR_SR();
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                                ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        
        
        Vendor__c vendorObj = new  Vendor__c (
            Name = 'PT Centratama Menara Indonesia', // Vendor Name
            Type__c = 'Vendor',                       // Type
            ListEmail__c = 'bro@gmail.com; sis@gmail.com'
        );
        insert vendorObj;
        
        system.debug('vendor =' + vendorObj);
        
        Opportunity O2 = new Opportunity();
        O2.ownerid = userObj.id;
        O2.Accountid = a.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = a.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Contract_Periode__c = 12;
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = a.id;
        O2.BP_Vat__c = a.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2; 
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        CPS.CreateSR(O2);
        
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c, Opportunity__c, Project_Name__c, Name, Project_type__c, 
                                     Capacity_After__c, UOM_After__c, Project_Coordinator_Text__c, Services__c, Site_A__c, Site_B__c 
                                     FROM SR_PR_Notification__c 
                                     WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: O2.id LIMIT 1
                                    ];
        

      

        Test.startTest();
        
        SP3.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP3.Status__c = 'Close(Complete)';
        SP3.Survey_type__c = 'P2P';
        SP3.Vendor__c = vendorObj.id;
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        SP3.Services__c = 'LL';
        update SP3;

        List<EmailNotif_SRPR__c> EmailNotif_SRPR_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM EmailNotif_SRPR__c];

        for(EmailNotif_SRPR__c EmailNotif_SRPR_List_Extract : EmailNotif_SRPR_List){
            EmailNotif_SRPR_List_Extract.Additional_toAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com test@gmail.com';
            EmailNotif_SRPR_List_Extract.Additional_toCCAddress__c ='test@gmail.com|test@gmail.com,test@gmail.com test@gmail.com';
        }
        update EmailNotif_SRPR_List;

        SendEmailSRPR.sendemailtoVendor(SP3);
        SendEmailSRPR.sendemailAssigned(SP3);
        SendEmailSRPR.sendemailCloseSR(SP3);
        CPS.CreatePR(O2);
        CPS.setAutorenewal(5, 'Month');
        
      SR_PR_notification__c SP4 = [SELECT id FROM SR_PR_Notification__c 
                                     WHERE notif_type__c = 'PR' 
                                     and Opportunity__c =: O2.id LIMIT 1];

        
          SP4.Status__c = 'Cancel';
          SP4.Reasons__c = 'R14 BA Not Assigned';
          
          update SP4;

        for(EmailNotif_SRPR__c EmailNotif_SRPR_List_Extract : EmailNotif_SRPR_List){
            EmailNotif_SRPR_List_Extract.Additional_toAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
            EmailNotif_SRPR_List_Extract.Additional_toCCAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
        }
        update EmailNotif_SRPR_List;

        SendEmailSRPR.sendemailtoVendor(SP3);
        SendEmailSRPR.sendemailAssigned(SP3);
        SendEmailSRPR.sendemailCloseSR(SP3);
       test.stopTest();
    }
    
    static testMethod void SRPRTriggerTask() {
        user userObj = [SELECT id from user WHERE Name = 'Nityo Triantono'
                        LIMIT 1
                       ];
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
                         LIMIT 1
                        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c = 'LL-02'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c = 'Head Office'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
                    ];
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                               ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        Create_PR_SR CPS = new Create_PR_SR();
        
        Opportunity O2 = new Opportunity();
        O2.ownerid = userObj.id;
        O2.Accountid = HQ.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = A.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = A.id;
        O2.BP_Vat__c = A.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2;
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        CPS.CreateSR(O2);
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c FROM SR_PR_Notification__c WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: OLI.Opportunityid LIMIT 1
                                    ];
        SP3.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP3.Status__c = 'Close(Complete)';
        SP3.Survey_type__c = 'P2P';
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        update SP3;
        CPS.CreatePR(O2);
        SR_PR_notification__c SP4 = [SELECT id FROM SR_PR_Notification__c WHERE notif_type__c = 'PR'
                                     and Opportunity__c =: OLI.Opportunityid LIMIT 1
                                    ];
        list < Task > Tlist = [SELECT id, Activity_Number__c, ActivityDate FROM Task WHERE Whatid =: SP4.id];
        if (tlist.size() > 0)
            delete Tlist[0];
        Task T = new Task();
        T.whatid = SP4.id;
        T.subject = 'Test';
        T.Activity_Number__c = 1;
        T.Start_Date__c = system.today();
        T.ActivityDate = system.today().adddays(3);
        T.Active__c = true;
        
        test.startTest();
        insert T;
        T.status = 'Completed';
        update T;
        test.stopTest();
    }
    
    static testMethod void CreateSRPRReplicatePR() {
        // TO DO: implement unit test
        user userObj = [SELECT id from user WHERE Name = 'Nityo Triantono'
                        LIMIT 1
                       ];
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
                         LIMIT 1
                        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c = 'LL-02'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c = 'Head Office'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
                    ];
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                               ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        Opportunity O1 = [SELECT id, ownerid, name, international_bw__c, local_bw__c, service_type__c, router_type__c, accountid, solution_pic__c, SR_Status__c, Account_Site_A__c, UOM_BW_Before__c, UOM_BW_After__c, BW_Before__c, BW_After__c, Account_Site_A_Full_Address__c, SR__c, Project_Coordinator__c, Expected_RFS_Date__c, Lastmile_type__c, trial__c, link_related__c FROM Opportunity WHERE RecordTypeName__c LIKE '%VOIP%'
                          AND Probability > 30 ORDER BY Lastmodifieddate DESC LIMIT 1
                         ];
        Create_PR_SR CPS = new Create_PR_SR();
        CPS.CreateSR(O1);
        O1.project_coordinator__c = '90006544 Nancy Citraningrum';
        update O1;
        SR_PR_notification__c SP1 = [SELECT id, Status__c FROM SR_PR_Notification__c WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: O1.id LIMIT 1
                                    ];
        if (SP1.Status__c != 'Close(Complete)') {
            SP1.Status__c = 'Close(Complete)';
            SP1.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
            
            SP1.Survey_type__c = 'P2P';
            SP1.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
            SP1.Survey_Complete_date__c = system.today();
            update SP1;
            
        }
        CPS.CreatePR(O1);
        SR_PR_notification__c SP2 = [SELECT id FROM SR_PR_Notification__c WHERE notif_type__c = 'PR'
                                     and Opportunity__c =: O1.id LIMIT 1
                                    ];
        Scheduled_Process__c sprocess = [select id, jobid__c from Scheduled_Process__c order by createddate DESC LIMIT 1];
        ReplicatePRToEasyOps.ReplicatePR(SP2.id, sprocess.jobid__c);
        Opportunity O2 = new Opportunity();
        O2.ownerid = userObj.id;
        O2.Accountid = HQ.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = A.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = A.id;
        O2.BP_Vat__c = A.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2;
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        CPS.CreateSR(O2);
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c FROM SR_PR_Notification__c WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: OLI.Opportunityid LIMIT 1
                                    ];
        SP3.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP3.Status__c = 'Close(Complete)';
        SP3.Survey_type__c = 'P2P';
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        
        test.startTest();
        update SP3;
        CPS.CreatePR(O2);
        test.stopTest();
        
        //-- tutup sementara : SR_PR_Notification__c SP=[SELECT id from SR_PR_Notification__c LIMIT 1];
        //    CPS.CreateTask('Gitu D',false,1,system.today(),system.today(),SP);
        
    }
    
    static testmethod void CancelNotDeliver() {
        user userObj = [SELECT id from user WHERE Name = 'Nityo Triantono'
                        LIMIT 1
                       ];
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
                         LIMIT 1
                        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c = 'LL-02'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c = 'Head Office'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
                    ];
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        Create_PR_SR CPS = new Create_PR_SR();
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                               ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        
        /*

        
        Vendor__c vendorObj = new  Vendor__c (
            name = 'PT Centratama Menara Indonesia',
            Type__c = 'Vendor',
            ListEmail__c = 'bro@gmail.com; sis@gmail.com'
        );
        insert vendorObj;
        
        Opportunity O2 = new Opportunity();
        o2.ownerid = userObj.id;
        O2.Accountid = HQ.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = A.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Contract_Periode__c = 12;
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = A.id;
        O2.BP_Vat__c = A.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2;
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        CPS.CreateSR(O2);
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c, Opportunity__c, Project_Name__c, Name, Project_type__c, Capacity_After__c, UOM_After__c, Project_Coordinator_Text__c, Services__c, Site_A__c, Site_B__c FROM SR_PR_Notification__c WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: OLI.Opportunityid LIMIT 1
                                    ];
        SP3.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP3.Status__c = 'Close(Not Deliver)';
        SP3.Reasons__c = 'R04 Cust Schedule';
        SP3.Survey_type__c = 'P2P';
        SP3.Vendor__c = vendorObj.id;
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        
        test.startTest();
        update SP3;
        //SendEmailSRPR.sendemailtoVendor(SP3);
        // SendEmailSRPR.sendemailAssigned(SP3);
        // SendEmailSRPR.sendemailCloseSR(SP3);
        CPS.CreatePR(O2);
        CPS.setAutorenewal(5, 'Month');
        //SR_PR_notification__c SP4=[SELECT id FROM SR_PR_Notification__c WHERE notif_type__c='PR' and Opportunity__c=:OLI.Opportunityid LIMIT 1];
        //SP4.Status__c='Cancel';
        //SP4.Reasons__c='R14 BA Not Assigned';
        //update SP4;
        //
        
        test.stopTest();
    }
    
    static testmethod void StatusAssigned() {
        user userObj = [SELECT id from user WHERE Name = 'Nityo Triantono'
                        LIMIT 1
                       ];
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
                         LIMIT 1
                        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c = 'LL-02'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c = 'Head Office'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
                    ];
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        
        //novi , add data vendor 10 maret 2021
        Vendor__c datavendor = new Vendor__c();
        datavendor.name = 'test vendor';
        datavendor.type__c = 'Vendor';
        datavendor.listemail__c = 'vendor@test.com;vendor1@test.com;vendor2@test.com';
        datavendor.Ownerid = userObj.id;
        insert datavendor;
        
        Create_PR_SR CPS = new Create_PR_SR();
        Product2 PRecurring2 = [SELECT id FROM Product2 WHERE SAP_Code__c = 'MPLS-02'
                                AND Revenue_Type__c = 'Recurring'
                                LIMIT 1
                               ];
        Pricebook2 PB2 = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        
        /*
Vendor__c V = [SELECT id from Vendor__c where type__c = 'Vendor'
LIMIT 1
]; */
        
        Vendor__c vendorObj = new  Vendor__c (
            name = 'PT Centratama Menara Indonesia',
            Type__c = 'Vendor',
            ListEmail__c = 'bro@gmail.com; sis@gmail.com'
        );
        insert vendorObj;
        
        Opportunity O2 = new Opportunity();
        o2.ownerid = userObj.id;
        O2.Accountid = HQ.id;
        O2.Account_Site_A__c = HQ.id;
        O2.Account_Site_B__c = A.id;
        O2.StageName = 'Prospecting';
        O2.Name = 'Tes';
        O2.Link_Related__c = L.id;
        O2.CloseDate = system.today().adddays(10);
        O2.Pricebook2id = PB2.id;
        O2.Periode_UOM__c = 'Month';
        O2.Contract_Periode__c = 12;
        O2.Service_type__c = 'NewLink';
        O2.BP_Payer__c = A.id;
        O2.BP_Vat__c = A.id;
        O2.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        insert O2;
        OpportunityLineItem OLI = new OpportunityLineItem();
        OLI.Product2id = Precurring2.id;
        OLI.OpportunityID = O2.id;
        OLI.revenue_type__c = 'Recurring';
        
        OLI.UnitPrice = 50000000;
        OLI.Quantity = 1;
        OLI.Billing_Type__c = 'Monthly';
        OLI.Contract_Start_Date__c = system.today().adddays(-3);
        OLI.Contract_End_Date__c = system.today().adddays(3);
        insert OLI;
        CPS.CreateSR(O2);
        SR_PR_notification__c SP3 = [SELECT id, Survey_lastmile_type__c, Opportunity__c, Project_Name__c, Name, Project_type__c, Capacity_After__c, UOM_After__c, Project_Coordinator_Text__c, Services__c, Site_A__c, Site_B__c FROM SR_PR_Notification__c WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: OLI.Opportunityid LIMIT 1
                                    ];
        SP3.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP3.Status__c = 'Assigned';
        SP3.Survey_type__c = 'P2P';
        SP3.Vendor__c = vendorObj.id;
        SP3.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP3.Survey_Complete_date__c = system.today();
        
        test.startTest();
        update SP3;
        CPS.CreatePR(O2);
        CPS.setAutorenewal(5, 'Month');
        test.stopTest();
    }
    
    /*
static testMethod void CreateSRPRReplicatePR() {
// TO DO: implement unit test
RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
RecordType opptyrt=[SELECT id FROM RecordType WHERE Name = 'Non GSM Voip' LIMIT 1];

Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];

Account HQ=[SELECT id from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
Account A=[SELECT id from Account where Name='PT BESS Finance' AND BP_Number__C='712822' AND ParentID=:HQ.id  LIMIT 1]; 
Link__C L=[SELECT id FROM Link__c where Name='02-04034'];
Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];

RecordType accRT=[SELECT id, name FROM RecordType WHERE Name='BP' LIMIT 1];

Account myAccHQ = new Account(
Name = 'PT Bank CIMB Niaga Tbk',                                                                   // Account Name
RecordTypeId = accRT.id,                                                                          // Account Record Type
BP_Number__c = '703705',                                                                             // BP Number
Organization_Type__c = 'Head Office',                                                                // Organization Type
Type = 'Customer',                                                                                   // Type
Phone = '021-5460555',                                                                               // Phone
Unique_Name__c = 'Gd Menara Asia Lt.3(HO)',                                                          // Unique Name
Customer_Type__c = 'NONGSM',                                                                         // Customer Type
Payer_For_GSM_Invoice__c = false,                                                                    // Payer For GSM Invoice
term_of_payment__c = 'Z030 Within 30 Days Due Net',                                                  // Term of Payment
Company_Group__c = 'CIMB NIAGA',                                                                     // Company_Group
Customer_VAT_Name__c = 'PT Bank CIMB Niaga Tbk',                                                     // Customer VAT Name
Summary_Billing__c = false,                                                                          // Summary Billing
Using_HO_Billing_Address__c = false,                                                                 // Using HO Billing Address
Relocation_Street_1__c = 'ATM Perum. Taman Narogong Indah Blok A21 No.51A Bekasi (Geser 10 meter)',  // Relocation Street 1
No_NPWP__c = '013106687091000'                                                                      // No NPWP
);
insert myAccHQ;

Account myAccBR = new Account(
Name = 'PT Bank CIMB Niaga Tbk',  
ParentId = myAccHQ.id,                                                                 // Account Name
RecordTypeId = accRT.id,                                                                          // Account Record Type
BP_Number__c = '703705',                                                                             // BP Number
Organization_Type__c = 'Branch',                                                                // Organization Type
Type = 'Customer',                                                                                   // Type
Phone = '021-5460555',                                                                               // Phone
Unique_Name__c = 'Gd Menara Asia Lt.3(HO)',                                                          // Unique Name
Customer_Type__c = 'NONGSM',                                                                         // Customer Type
Payer_For_GSM_Invoice__c = false,                                                                    // Payer For GSM Invoice
term_of_payment__c = 'Z030 Within 30 Days Due Net',                                                  // Term of Payment
Company_Group__c = 'CIMB NIAGA',                                                                     // Company_Group
Customer_VAT_Name__c = 'PT Bank CIMB Niaga Tbk',                                                     // Customer VAT Name
Summary_Billing__c = false,                                                                          // Summary Billing
Using_HO_Billing_Address__c = false,                                                                 // Using HO Billing Address
Relocation_Street_1__c = 'ATM Perum. Taman Narogong Indah Blok A21 No.51A Bekasi (Geser 10 meter)',  // Relocation Street 1
No_NPWP__c = '013106687091000'                                                                      // No NPWP
);
insert myAccBR;

Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
AccountContactRelation CR=new AccountContactRelation();
Contact myContact=new Contact();
myContact.LastName='Wiryo';
myContact.Accountid=HQ.id;
myContact.Firstname='Yohn';
myContact.MobilePhone='0288282';
myContact.Email='Fail@fail.com';
insert myContact;
CR.AccountID=myAccHQ.id;
CR.Contactid=myContact.id;
CR.Roles='PIC Site;PIC BA Sign';
insert CR;

Link__c mylink = new Link__c(
Name = '-00000',                                                                                                                                                             // CID/Link ID
BU__c = 'ENTERPRISE',                                                                                                                                                          // BU
CID__c = '-00000',                                                                                                                                                             // CID *
ID__c = '23903',                                                                                                                                                               // ID
Status_Link__c = 'UNDER_PROJECT',                                                                                                                                              // Status Link
Company_Name__c = 'PT Bank CIMB Niaga Tbk',                                                                                                                                    // Company Name
Service_Type__c = '4GAccess',                                                                                                                                                  // Service Type
BP_Site_A__c = '725205',                                                                                                                                                       // BP Site A
Capacity_Bandwidth__c = '128',                                                                                                                                                 // Capacity Bandwidth
UoM__c = 'Kbps',                                                                                                                                                               // UoM
Routepath__c = '725205 PT Bank CIMB Niaga Tbk ATM Alfamart Ruko Taman Semanan 2 (KB09) Jakarta Barat - PT Smart Lintas, (SLM) PT Smart Lintas, (SLM) - Cyber01 GEDUNG CYBER',  // Routepath
//CID_RelD__c = 'undefined',                                                                                                                                                     // CID RelD
Link_ID__c = '038C563L6',                                                                                                                                                      // Link ID
Site_A_Name__c = myAccBR.id,                                                                                                                                                  // Site A Name
Free_Link__c = false,                                                                                                                                                          // Free Link
Selected__c = false,                                                                                                                                                           // Selected
Partner__c = false                                                                                                                                                            // Partner
);
insert mylink;


User solutionUser = [SELECT id from User where profile.Name = 'Solution' limit 1];
Product2 PRecurring2=[SELECT id FROM Product2 WHERE SAP_Code__c ='MPLS-02' AND Revenue_Type__c='Recurring' LIMIT 1];
Pricebook2 PB2=[SELECT id from PriceBook2 WHERE Name='MPLS'];
//---------------------------------------------------------------------------------------------------
Opportunity myOppty = new Opportunity(
Service_Type__c = 'Newlink',                                     	        // Service Type
RecordTypeId = opptyRT.id,                                               	   // Opportunity Record Type
Project_Group__c = 'CIMB New ATM Indomaret Pasar Kemis Siliwangi (TS0Y)',  // Project Group
Auto_Renewal__c = false,                                                   // Auto Renewal
trial__c = false,                                                          // trial
PIC_BA_Print__c = myContact.id,                                             // PIC BA Print
Auto_Renewal_Periode__c = 3,                                             // Auto Renewal Periode
Auto_Renewal_UOM__c = 'Bulan',                                             // Auto Renewal UOM
Name = 'CIMB New ATM Indomaret Pasar Kemis Siliwangi (TS0Y)',              // Opportunity Name
Solution_PIC__c = solutionUser.id,                                             // Solution PIC
CloseDate = Date.valueOf('2020-07-30'),                                     // Target Closed Date
AccountId = myAccHQ.id,                                                   // Account Name
Actual_Closed_Date__c = Date.valueOf('2020-07-30'),                         // Closed Date
PO_Date__c = Date.valueOf('2020-07-30'),                                    // PO Date
Description = 'CIMB New ATM Indomaret Pasar Kemis Siliwangi (TS0Y)',       // Description
Expected_RFS_Date__c = Date.valueOf('2020-07-30'),                          // Expected RFS Date
BP_Payer__c = myAccBR.id,                                                 // BP Payer
StageName = 'Implementation',                                              // Stage
BP_VAT__c = myAccBR.id,                                                   // BP VAT
Probability = 50,                                                          // Probability (%)
Contract_Periode__c = 12,                                                // Contract Periode
Amount = 5908,                                                            // Amount
Periode_UOM__c = 'Month',                                                  // Periode UOM
COF_Number__c = '125/Enterprise/IX/2018',                                  // COF Number
Remark__c = 'Approved',                                                    // Remark
Account_Site_A__c = myAccHQ.id,                                           // Account Site A (BP Site)
Link_Related__c = mylink.id,                                             // CID (Related)
SR__c = '2007-001280',                                                     // SR
SR_Status__c = 'Close(Complete)',                                          // SR Status
Quotation_Final_Approval__c = 'Approved',                                  // Quotation Final Approval Status
PR__c = '2007-000955',                                                     // PR
BW_before__c = '0',                                                        // Capacity before
Uom_BW_Before__c = 'Kbps',                                                 // Uom BW Before
BW_after__c = '128',                                                       // Capacity after
Uom_BW_After__c = 'Kbps',                                                  // Uom BW After
Project_Coordinator__c = '90006544 Nancy Citraningrum',                    // Project Coordinator
Pricebook2id=PB2.id
);
insert myOppty;
OpportunityLineItem myOLI=new OpportunityLineItem();
myOLI.Product2id=Precurring2.id;
myOLI.OpportunityID=myOppty.id;
myOLI.revenue_type__c='Recurring';
myOLI.UnitPrice=50000000;
myOLI.Quantity=1;
myOLI.Billing_Type__c='Monthly';
myOLI.Contract_Start_Date__c=system.today().adddays(-3);
myOLI.Contract_End_Date__c=system.today().adddays(3);
insert myOLI;
//---------------------------------------------------------------------------------------------------
//Opportunity O1=[SELECT id,name,international_bw__c,local_bw__c,service_type__c,router_type__c,accountid,solution_pic__c,SR_Status__c,Account_Site_A__c,UOM_BW_Before__c,UOM_BW_After__c,BW_Before__c,BW_After__c,Account_Site_A_Full_Address__c,SR__c,Project_Coordinator__c,Expected_RFS_Date__c,Lastmile_type__c,trial__c,link_related__c FROM Opportunity WHERE RecordTypeName__c LIKE '%VOIP%'  AND Probability>30 ORDER BY Lastmodifieddate DESC LIMIT 1];
Opportunity O1=myOppty;
Create_PR_SR CPS=new Create_PR_SR();
CPS.CreateSR(O1);
//myOppty.project_coordinator__c='90006544 Nancy Citraningrum';
//update myOppty;
SR_PR_notification__c SP1=[SELECT id,Status__c FROM SR_PR_Notification__c WHERE notif_type__c='SR' and Opportunity__c=:O1.id LIMIT 1];
if(SP1.Status__c!='Close(Complete)')
{	
SP1.Status__c='Close(Complete)';
SP1.Survey_Lastmile_type__c='Lastmile by XL\'s MW';
SP1.Survey_type__c='P2P';
SP1.Project_Coordinator_Text__c='90006544 Nancy Citraningrum';
SP1.Survey_Complete_date__c=system.today();
update SP1;	

}
CPS.CreatePR(O1);
SR_PR_notification__c SP2=[SELECT id FROM SR_PR_Notification__c WHERE notif_type__c='PR' and Opportunity__c=:myOppty.id LIMIT 1];
Scheduled_Process__c sprocess = [select id, jobid__c from Scheduled_Process__c order by createddate DESC LIMIT 1];
ReplicatePRToEasyOps.ReplicatePR(SP2.id,sprocess.jobid__c);
Opportunity O2=new Opportunity();
O2.Accountid=HQ.id;
O2.Account_Site_A__c=HQ.id;
O2.Account_Site_B__c=A.id;
O2.StageName='Prospecting';
O2.Name='Tes';
O2.Link_Related__c=L.id;
O2.CloseDate=system.today().adddays(10);
O2.Pricebook2id=PB2.id;
O2.Periode_UOM__c='Month';
O2.Service_type__c='NewLink';
O2.BP_Payer__c=A.id;
O2.BP_Vat__c=A.id;
O2.Project_Coordinator__c='90006544 Nancy Citraningrum';
insert O2;

OpportunityLineItem OLI=new OpportunityLineItem();
OLI.Product2id=Precurring2.id;
OLI.OpportunityID=O2.id;
OLI.revenue_type__c='Recurring';

OLI.UnitPrice=50000000;
OLI.Quantity=1;
OLI.Billing_Type__c='Monthly';
OLI.Contract_Start_Date__c=system.today().adddays(-3);
OLI.Contract_End_Date__c=system.today().adddays(3);
insert OLI;
CPS.CreateSR(O2);
SR_PR_notification__c SP3=[SELECT id,Survey_lastmile_type__c FROM SR_PR_Notification__c WHERE notif_type__c='SR' and Opportunity__c=:OLI.Opportunityid LIMIT 1];
SP3.Survey_Lastmile_type__c='Lastmile by XL\'s MW';
SP3.Status__c='Close(Complete)';
SP3.Survey_type__c='P2P';
SP3.Project_Coordinator_Text__c='90006544 Nancy Citraningrum';
SP3.Survey_Complete_date__c=system.today();
update SP3;
CPS.CreatePR(O2);

SR_PR_Notification__c SP=[SELECT id from SR_PR_Notification__c LIMIT 1];
CPS.CreateTask('Gitu D',false,1,system.today(),system.today(),SP);

}
*/
    static testMethod void CreateSRPRLL() {
        // TO DO: implement unit test
        user userObj = [SELECT id from user WHERE Name = 'Nityo Triantono'
                        LIMIT 1
                       ];
        
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
                         LIMIT 1
                        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
                          AND Revenue_Type__c = 'One Time'
                          LIMIT 1
                         ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c = 'LL-02'
                               AND Revenue_Type__c = 'Recurring'
                               LIMIT 1
                              ];
        Account HQ = [SELECT id from Account where Organization_Type__c = 'Head Office'
                      AND BP_Number__c = '706531'
                      LIMIT 1
                     ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
                     AND BP_Number__C = '712822'
                     AND ParentID =: HQ.id LIMIT 1
                    ];
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Create_PR_SR CPS = new Create_PR_SR();
        Opportunity O3 = new Opportunity();
        O3.ownerid = userObj.id;
        
        O3.Accountid = HQ.id;
        O3.Account_Site_A__c = HQ.id;
        O3.Account_Site_B__c = A.id;
        O3.StageName = 'Prospecting';
        O3.Service_type__c = 'NewLink';
        O3.Name = 'Tes';
        O3.Link_Related__c = L.id;
        O3.CloseDate = system.today().adddays(10);
        O3.Pricebook2id = PB.id;
        O3.Periode_UOM__c = 'Month';
        o3.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        O3.BP_Payer__c = A.id;
        O3.BP_Vat__c = A.id;
        insert O3;
        OpportunityLineItem OLI2 = new OpportunityLineItem();
        OLI2.Product2id = Precurring.id;
        OLI2.OpportunityID = O3.id;
        OLI2.revenue_type__c = 'Recurring';
        OLI2.UnitPrice = 50000000;
        OLI2.Quantity = 1;
        OLI2.Billing_Type__c = 'Monthly';
        OLI2.Contract_Start_Date__c = system.today().adddays(-3);
        OLI2.Contract_End_Date__c = system.today().adddays(3);
        insert OLI2;
        CPS.CreateSR(O3);
        SR_PR_notification__c SP5 = [SELECT id FROM SR_PR_Notification__c WHERE notif_type__c = 'SR'
                                     and Opportunity__c =: OLI2.Opportunityid LIMIT 1
                                    ];
        SP5.Survey_Lastmile_type__c = 'Lastmile by XL\'s MW';
        SP5.Status__c = 'Close(Complete)';
        SP5.Survey_type__c = 'P2P';
        SP5.Project_Coordinator_Text__c = '90006544 Nancy Citraningrum';
        SP5.Survey_Complete_date__c = system.today();
        
        test.startTest();
        update SP5;
        CPS.CreatePR(O3);
        SR_PR_notification__c SP6 = [SELECT id FROM SR_PR_Notification__c WHERE notif_type__c = 'PR'
                                     and Opportunity__c =: OLI2.Opportunityid LIMIT 1
                                    ];
        
        test.stopTest();
        
    }
    
    
    
    
    static testMethod void PreviewSendWBA() {
        // TO DO: implement unit test
        Opportunity O = [SELECT id, name, service_type__c, router_type__c, accountid, solution_pic__c, SR_Status__c, Account_Site_A__c, UOM_BW_Before__c, UOM_BW_After__c, BW_Before__c, BW_After__c, Account_Site_A_Full_Address__c, SR__c, Project_Coordinator__c, Expected_RFS_Date__c, Lastmile_type__c, trial__c, auto_renewal__c FROM Opportunity WHERE StageName = 'Implementation'
                         AND Amount > 0 AND PIC_BA_Print__c != null AND SR__c != null ORDER BY CREATEDDATE DESC LIMIT 1
                        ];
        test.starttest();
        O.Trial__c = true;
        O.Auto_Renewal__c = true;
        update O;
        list < SR_PR_Notification__c > listSRPR = [SELECT id FROM SR_PR_Notification__c WHERE Opportunity__c =: O.id AND Notif_type__c = 'PR'];
        
        SR_PR_Notification__c PRtes = new SR_PR_Notification__c();
        if (listSRPR.size() > 0) {
            delete listSRPR;
        }
        PRTes.notif_type__c = 'PR';
        PRTes.account__c = O.Accountid;
        PRTes.Opportunity__c = O.id;
        PRTes.site_a__c = O.Account_site_a__c;
        PRTes.services__c = 'Voip';
        PRTes.BA_Sent_Date__c = system.today();
        PRTes.Status__c = 'Waiting for BA';
        PRTes.Project_Complete_Date__c = system.today();
        SR_PR__c SPN = SR_PR__c.getorgdefaults();
        String month = '';
        String year = '';
        if (system.today().month() < 10) {
            month = '0' + String.valueof(system.today().month());
        } else {
            month = String.valueof(system.today().month());
        }
        year = String.valueof(system.today().year()).right(2);
        String todaymonthyear = year + month;
        String PRNumber = todaymonthyear + '-' + String.valueof(SPN.PR_Number__c);
        PRNumber = PRNumber.replace('.0', '');
        PRTes.Name = 'PR-' + PRNumber;
        if (O.Service_type__c == 'NewLink')
            PRTes.Project_type__c = 'New';
        else
            PRTes.Project_type__c = O.Service_Type__c;
        PRTes.Status__c = 'In Progress';
        
        PRTes.Notif_Date__c = system.today();
        PRTes.Normal_RFS__c = system.today().adddays(6);
        PRTes.UOM_Before__c = O.UOM_BW_Before__c;
        PRTes.Exp_RFS_Date__c = O.Expected_RFS_Date__c;
        PRTes.UOM_After__c = O.UOM_BW_After__c;
        PRTes.Capacity_Before__c = O.BW_Before__c;
        PRTes.Capacity_After__c = O.BW_After__c;
        PRTes.Project_Coordinator_Text__c = O.Project_Coordinator__c;
        insert PRTes;
        
        
        apexpages.standardcontroller sc = new apexpages.standardcontroller(O);
        
        sendwbautils swu = new sendwbautils(SC);
        wbautils wu = new wbautils(SC);
        PageReference sendwba = Page.sendwba;
        sendwba.getParameters().put('Id', String.valueOf(O.id));
        Test.setCurrentPage(sendwba);
        swu.sendemail();
        swu.cancel();
        test.stoptest();
        
    }
    
    static testMethod void SRPRMarketplace() {
        Opportunity O = [SELECT id, ownerid, name, service_type__c, router_type__c, accountid, solution_pic__c, SR_Status__c, Account_Site_A__c, UOM_BW_Before__c, UOM_BW_After__c, BW_Before__c, BW_After__c, Account_Site_A_Full_Address__c, SR__c, Project_Coordinator__c, Expected_RFS_Date__c, Lastmile_type__c, trial__c, auto_renewal__c FROM Opportunity WHERE StageName = 'Implementation'
                         AND Amount > 0 AND PIC_BA_Print__c != null ORDER BY CREATEDDATE DESC LIMIT 1
                        ];
        Create_PR_SR CPS = new Create_PR_SR();
        CPS.createSRComplete(O);
        CPS.CreatePRMarketplace(O);
    }
    
    
}