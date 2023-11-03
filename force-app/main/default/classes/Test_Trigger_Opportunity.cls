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
@isTest(seealldata=true)
public class Test_Trigger_Opportunity {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
       // insert new Transaction__c(TransactionID__c = 1); 
        
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        //ga ke detect
        //Account A=[SELECT id,Ownerid from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
       //Account A=[SELECT id, Ownerid from Account where Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                            Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                            EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');
        insert U;
		
        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;
     
        test.starttest();
        
     

		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accountRecordTypeId;
        acc.Name = 'TEST';
        acc.Unique_Name__c = 'TEST';
        acc.NumberOfEmployees = 2;
        acc.Company_Group__c = 'Perusahaan Asing';
        acc.Customer_VAT_Name__c = 'sdfskdjfsjdf';
        acc.Customer_Type__c = 'NONGSM';
        acc.No_NPWP__c = '123456789123455';
        acc.BillingStreet = 'hive';
        acc.BillingState = 'hive';
        acc.BillingCity = 'hive';
        acc.BillingCountry = 'hive';
        acc.BillingPostalCode = 'hive';
        acc.ShippingStreet = 'hive';
        acc.ShippingState = 'hive';
        acc.ShippingCity = 'hive';
        acc.ShippingCountry = 'hive';
        acc.ShippingPostalCode = 'hive';
        acc.Billing_Building_Name__c = 'hive';
        acc.Shipping_Building_Name__c = 'hive';
        acc.Field_Source__c = 'Bizstore Customer Registration';
        acc.Organization_Type__c = 'Head Office';
        acc.Type = 'Customer';
        acc.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        acc.OU__c = '1';
        acc.Industry = 'Agriculture';
        acc.BP_Number__c = '1xx12';
        acc.Bizstore_Complete__c = false;
        Insert acc;
        
        Account acc1 = new Account();
        acc1.RecordTypeId = accountRecordTypeId;
        acc1.Name = 'TESsT';
        acc1.Unique_Name__c = 'TEsST';
        acc1.NumberOfEmployees = 2;
        acc1.Company_Group__c = 'Perusahaan Asing';
        acc1.Customer_VAT_Name__c = 'sdfskdjfsjdf';
        acc1.Customer_Type__c = 'NONGSM';
        acc1.No_NPWP__c = '123456789123456';
        acc1.BillingStreet = 'hive';
        acc1.BillingState = 'hive';
        acc1.BillingCity = 'hive';
        acc1.BillingCountry = 'hive';
        acc1.BillingPostalCode = 'hive';
        acc1.ShippingStreet = 'hive';
        acc1.ShippingState = 'hive';
        acc1.ShippingCity = 'hive';
        acc1.ShippingCountry = 'hive';
        acc1.ShippingPostalCode = 'hive';
        acc1.Billing_Building_Name__c = 'hive';
        acc1.Shipping_Building_Name__c = 'hive';
        acc1.Field_Source__c = 'Bizstore Customer Registration';
        acc1.Organization_Type__c = 'Head Office';
        acc1.Type = 'Customer';
        acc1.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        acc1.OU__c = '1';
        acc1.Industry = 'Agriculture';
        acc1.BP_Number__c = '1xx12';
        acc1.Bizstore_Complete__c = false;
        Insert acc1;
       
       // User U=[SELECT id FROM User WHERE ID=:Acc.ownerid];
       
        
        
       Contact conc = new Contact();
        conc.AccountId = Acc1.Id;
        conc.LastName = 'Abharaham';
        conc.Email = 'apake@gmail.com';
        insert conc;
        
        

		AccountContactRelation CR=new AccountContactRelation();
   
            CR.AccountID=Acc.id;
            CR.Contactid=Conc.id;
            CR.Roles='PIC BA Print';
            insert CR;
        
        conc = new Contact();
        conc.AccountId = Acc1.Id;
        conc.LastName = 'Muhammad Surya Ramadhan';
        conc.Email = 'apaloe@gmail.com';
        insert conc;
        
        CR=new AccountContactRelation();
        CR.AccountID=Acc.id;
        CR.Contactid=Conc.id;
        CR.Roles='PIC BA Print';
        insert CR;
		        
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=Acc.id;
          O.Account_Site_A__c=Acc.id;
          O.PIC_BA_Print__c = conc.Id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.Contract_Periode__c=12;
          O.Service_type__c='newlink';
          O.BP_payer__C = Acc.id;
          O.BP_vat__C = Acc.id;          
          insert O;
      
        /*  OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;*/
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          insert OLI2;
            
          O.Service_Type__c='NewLink';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Month';
          O.StageName='survey';
          O.SR__c='22222';
            o.BP_VAT__c = acc.id;
           o.Project_Coordinator__c='90006544 Nancy Citraningrum';
        
          
          
              O.StageName='Quotation Final';
          O.PKS_Number__c='222';
            update O;
     //      update O;
           OpportunityID=O.id;
        
        }  
        
        
        // profile p2=[SELECT id FROM Profile WHERE Name='Sales Support & Admin'];
       //  user u2=[SELECT id from user WHERE Profileid=:p2.id AND isActive=true LIMIT 1];
         system.runas(U){
           O.Quotation_Final_Approval__c='Approved';
           O.Service_Type__c = 'Upgrade';  
           update O;
        
         }
         test.stoptest();
    
         
    }
    
     static testMethod void myUnitTest2() {
        // TO DO: implement unit test
           
     
       
       RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        //Account A=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
        Account A=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='760724' and RecordTypeId = '0127F000000WXQMQA4' LIMIT 1 ];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
           Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                            Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                            EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');
        insert U;
        
        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;

         
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        test.starttest();
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
           O.Contract_Periode__c=12;
          O.Service_type__c='Upgrade';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          insert O;
      
        /*  OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;*/
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Billing_Type__c='Monthly';
          OLI2.Quantity=1;
          OLI2.Contract_Start_Date__c=system.today();
          insert OLI2;
          O.Service_Type__c='NewLink';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Week';
          O.StageName='survey';
          O.SR__c='22222';
           o.Project_Coordinator__c='90006544 Nancy Citraningrum';
          update O;
          
     //     HitsapComDocumentSapSoap.UpdateOpportunitySurvey(O.id);
     //     HitsapComDocumentSapSoap.UpdateOpportunityImplementation(O.id);
        }
        test.stoptest();
     }
     
    static testMethod void myUnitTest3() {
        // TO DO: implement unit test

       RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='MPLS-02' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id,OwnerID from Account WHERE Organization_Type__c='Head Office' AND BP_Number__c='701111' LIMIT 1];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                            Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                            EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');
        insert U;
        
        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;

        
        test.starttest();
        Opportunity O=new Opportunity();
        String OpportunityID='';
       
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
         O.Service_Type__c='NewLink';

          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.BP_Payer__c=A.id;
          O.BP_Vat__c=A.id;
          insert O;
       /*   OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;*/
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OLI2.Contract_Start_Date__c=system.today().adddays(-3);
          OLI2.Contract_End_Date__c=system.today().adddays(3);
           OLI2.Revenue_type__c='One Time';
          insert OLI2;
           
          O.Service_Type__c='NewLink';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Month';
          O.StageName='Waiting for Contract';
          O.GSM_Product_List__c='';
          O.SR__c='22222';
           o.Project_Coordinator__c='90006544 Nancy Citraningrum';
           O.BW_Before__c='0';
           O.BW_After__c='1';
           O.UOM_BW_After__c='MBPS';
           O.UOM_BW_Before__c='MBPS';
           update O;
          O.StageName='Closed Won';
        
       //  update O;
          test.stoptest();
    }
    
    /*
     static testMethod void digitalAdvetisingTest() {
        // TO DO: implement unit test

        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%DADS%' AND Revenue_Type__c='One Time' LIMIT 1];
        //Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='MPLS-02' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id,OwnerID from Account WHERE Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Bulkshare'];
           Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                            Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                            EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');
        insert U;
        test.starttest();
         
        Opportunity O=new Opportunity();
        String OpportunityID='';
       
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
     	  O.Service_Group__c = 'GSM';

          O.Name='XlDigital - Advertising';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.BP_Payer__c=A.id;
          O.BP_Vat__c=A.id;
          o.Service_Type__c='Newlink';
          insert O;
         
          OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000;
          OLI.Contract_Start_Date__c=system.today().adddays(-3);
          OLI.Contract_End_Date__c=system.today().adddays(3);
          OLI.Quantity=100;
          insert OLI;
         
         Injection_Item__c intems = new Injection_Item__c();
         intems.Opportunity__c = o.id;
         intems.OppLineItemID__c = OLI.Id;
         intems.Request_QTY__c = OLI.Quantity;
         
         insert intems;
         
         /*
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OLI2.Contract_Start_Date__c=system.today().adddays(-3);
          OLI2.Contract_End_Date__c=system.today().adddays(3);
           OLI2.Revenue_type__c='One Time';
          insert OLI2;
           
       
          O.Contract_Periode__c=12;
          O.StageName='Implementation';
          O.Is_Submit_to_ORM__c = true;
          o.Project_Coordinator__c='90006544 Nancy Citraningrum';
          
           update O;
         
         intems.Actual_QTY__c = 99;
         update intems;
         
          O.StageName='Closed Won';
        
       //  update O;
          test.stoptest();
    }
   */

     static testMethod void myUnitTestLeasedLine() {
        // TO DO: implement unit test
         RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM Leased Line' AND SobjectType='Opportunity' LIMIT 1];
         Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
         Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
         
         Account A=[SELECT id from Account where Name='PT Ambhara Duta Shanti (ADSNet)' 
                    AND BP_Number__C='700001' AND ParentID=:HQ.id  LIMIT 1]; 
         
         //Link__C L=[SELECT id FROM Link__c where ID__c ='02-04034'];
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                           Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                           EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');   
          
        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;
		
         
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
            AccountContactRelation CR=new AccountContactRelation();
            Contact C=new Contact();
            C.LastName='Wiryo';
            C.Accountid=HQ.id;
            C.Firstname='Yohn';
            C.MobilePhone='0288282';
            C.Email='Fail@fail.com';
            insert C;
            CR.AccountID=A.id;
            CR.Contactid=C.id;
            CR.Roles='PIC BA Print;PIC SITE';
            insert CR;
         
         Circuit__c cl = new Circuit__c(
             Name = '02-09628',   // CID
             Services__c = 'MPLS'  // Services
         );
		insert cl;
         
         Link__c L = new Link__c(
             BU__c = 'ENTERPRISE',                                      // BU
             ID__c = '22623',                                             // ID
             Name = '23-00016',                                           // CID/Link ID
             CID__c = '23-00016',                                         // CID *
             Link_ID__c = '029C1219L3',                                   // Link ID
             Status_Link__c = 'EXPIRED',                                  // Status Link
             Company_Name__c = 'Link IT, PT',                             // Company Name
             Service_Type__c = 'Cloud',                                   // Service Type
             Contract_Item__c = '3001674-5',                              // Contract Item
             BP_Site_A__c = '754437',                                     // BP Site A
             Capacity_Bandwidth__c = '1',                                 // Capacity Bandwidth
             Site_A_Name__c = A.Id,                          // Site A Name
             UoM__c = 'Others',                                           // UoM
             CID_RelD__c = cl.id,                             // CID RelD
             Free_Link__c = false,                                        // Free Link
             //Contract_Item_Rel__c = c.Id,                    // Contract Item Rel
             Partner__c = false,                                          // Partner
             Routepath__c = '754437 PT Link IT Linkit360-App (Cloud) -',  // Routepath
             Selected__c = false                                         // Selected
         );
         insert L;
         
         
         
         
        test.starttest();
         
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=HQ.id;
          O.Account_Site_A__c=HQ.id;
          O.Service_Type__c = 'Newlink';
          O.Account_Site_B__c=A.id;
          O.StageName='Prospecting';
          O.recordtypeid = rt.id;
          O.Name='Tes';
          O.Link_Related__c=L.id;
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          
          O.BP_Payer__c=A.id;
          O.BP_Vat__c=A.id;
          insert O;
      
        /*  OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;*/
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OLI2.Contract_Start_Date__c=system.today().adddays(-3);
          OLI2.Contract_End_Date__c=system.today().adddays(3);
          insert OLI2;
          O.Service_Type__c='Relocation';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Day';
          O.StageName='survey';
          O.Account_Site_A__c=a.Id;
          O.SR__c='22222';
          O.COF_Number__c='4';
          o.Project_Coordinator__c='90006544 Nancy Citraningrum';
          O.Site_B_Relocation_Street__c='Baker Street';
          O.Site_A_Relocation_Street__c='Elm Street';
            
            //O.StageName='Waiting for Contract';
          o.PIC_Contact_Data_Email__c= C.Email;
          o.PIC_B_Email__c= C.Email;
          o.PIC_A_Email__c= C.Email;
          
          SYSTEM.DEBUG ('===== siap update opportunity stage to survey');
          SYSTEM.DEBUG ('===== oppty : ' + o);
          SYSTEM.DEBUG ('===== oppty.recordtypename : ' + o.recordtype.name);
            
          update O;

     //     HitsapComDocumentSapSoap.UpdateOpportunitySurvey(O.id);
     //     HitsapComDocumentSapSoap.UpdateOpportunityImplementation(O.id);
        } 
        test.stoptest();
     }

     static testMethod void myUnitTestLeasedLineWFC() {
        // TO DO: implement unit test
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM Leased Line' AND SobjectType='Opportunity' LIMIT 1];
         Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
         Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
         
         Account A=[SELECT id from Account where Name='PT Ambhara Duta Shanti (ADSNet)' 
                    AND BP_Number__C='700001' AND ParentID=:HQ.id  LIMIT 1]; 
         
         //Link__C L=[SELECT id FROM Link__c where ID__c ='02-04034'];
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                           Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                           EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');   
          
        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;

         
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
            AccountContactRelation CR=new AccountContactRelation();
            Contact C=new Contact();
            C.LastName='Wiryo';
            C.Accountid=HQ.id;
            C.Firstname='Yohn';
            C.MobilePhone='0288282';
            C.Email='Fail@fail.com';
            insert C;
            CR.AccountID=A.id;
            CR.Contactid=C.id;
            CR.Roles='PIC BA Print;PIC SITE';
            insert CR;
        
        Circuit__c cl = new Circuit__c(
             Name = '02-09628',   // CID
             Services__c = 'MPLS'  // Services
         );
		insert cl;
         
         Link__c L = new Link__c(
             BU__c = 'ENTERPRISE',                                      // BU
             ID__c = '22623',                                             // ID
             Name = '23-00016',                                           // CID/Link ID
             CID__c = '23-00016',                                         // CID *
             Link_ID__c = '029C1219L3',                                   // Link ID
             Status_Link__c = 'EXPIRED',                                  // Status Link
             Company_Name__c = 'Link IT, PT',                             // Company Name
             Service_Type__c = 'Cloud',                                   // Service Type
             Contract_Item__c = '3001674-5',                              // Contract Item
             BP_Site_A__c = '754437',                                     // BP Site A
             Capacity_Bandwidth__c = '1',                                 // Capacity Bandwidth
             Site_A_Name__c = A.Id,                          // Site A Name
             UoM__c = 'Others',                                           // UoM
             CID_RelD__c = cl.id,                             // CID RelD
             Free_Link__c = false,                                        // Free Link
             //Contract_Item_Rel__c = c.Id,                    // Contract Item Rel
             Partner__c = false,                                          // Partner
             Routepath__c = '754437 PT Link IT Linkit360-App (Cloud) -',  // Routepath
             Selected__c = false                                         // Selected
         );
         insert L;
         
        test.starttest();
         
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=HQ.id;
          O.Account_Site_A__c=HQ.id;
          O.Service_Type__c = 'Newlink';
          O.Account_Site_B__c=A.id;
          O.StageName='Prospecting';
          O.recordtypeid = rt.id;
          O.Name='Tes';
          O.Link_Related__c=L.id;
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          
          O.BP_Payer__c=A.id;
          O.BP_Vat__c=A.id;
          insert O;
      
        /*  OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;*/
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OLI2.Contract_Start_Date__c=system.today().adddays(-3);
          OLI2.Contract_End_Date__c=system.today().adddays(3);
          insert OLI2;
          O.Service_Type__c='Relocation';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Day';
          O.StageName='survey';
          O.Account_Site_A__c=a.Id;
          O.SR__c='22222';
          O.COF_Number__c='4';
          o.Project_Coordinator__c='90006544 Nancy Citraningrum';
          O.Site_B_Relocation_Street__c='Baker Street';
          O.Site_A_Relocation_Street__c='Elm Street';
             
          O.StageName='Waiting for Contract';
          o.PIC_Contact_Data_Email__c= C.Email;
          o.PIC_B_Email__c= C.Email;
          o.PIC_A_Email__c= C.Email;
          
          SYSTEM.DEBUG ('===== siap update opportunity stage to Waiting for Contract');
          SYSTEM.DEBUG ('===== oppty : ' + o);
          SYSTEM.DEBUG ('===== oppty.recordtypename : ' + o.recordtype.name);
            
          update O;
         
          
     //     HitsapComDocumentSapSoap.UpdateOpportunitySurvey(O.id);
     //     HitsapComDocumentSapSoap.UpdateOpportunityImplementation(O.id);
        } 
        test.stoptest();
     }
 
      static testMethod void myUnitTestLeasedLineWFCWithContractTicket () {
        // TO DO: implement unit test
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM Leased Line' AND SobjectType='Opportunity' LIMIT 1];
         Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
         Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
         
         Account A=[SELECT id from Account where Name='PT Ambhara Duta Shanti (ADSNet)' 
                    AND BP_Number__C='700001' AND ParentID=:HQ.id  LIMIT 1]; 
         
         //Link__C L=[SELECT id FROM Link__c where ID__c ='02-04034'];
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                           Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                           EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');   
          
        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;

         
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
            AccountContactRelation CR=new AccountContactRelation();
            Contact C=new Contact();
            C.LastName='Wiryo';
            C.Accountid=HQ.id;
            C.Firstname='Yohn';
            C.MobilePhone='0288282';
            C.Email='Fail@fail.com';
            insert C;
            CR.AccountID=A.id;
            CR.Contactid=C.id;
            CR.Roles='PIC BA Print;PIC SITE';
            insert CR;
        
        Circuit__c cl = new Circuit__c(
             Name = '02-09628',   // CID
             Services__c = 'MPLS'  // Services
         );
		insert cl;
         
         Link__c L = new Link__c(
             BU__c = 'ENTERPRISE',                                      // BU
             ID__c = '22623',                                             // ID
             Name = '23-00016',                                           // CID/Link ID
             CID__c = '23-00016',                                         // CID *
             Link_ID__c = '029C1219L3',                                   // Link ID
             Status_Link__c = 'EXPIRED',                                  // Status Link
             Company_Name__c = 'Link IT, PT',                             // Company Name
             Service_Type__c = 'Cloud',                                   // Service Type
             Contract_Item__c = '3001674-5',                              // Contract Item
             BP_Site_A__c = '754437',                                     // BP Site A
             Capacity_Bandwidth__c = '1',                                 // Capacity Bandwidth
             Site_A_Name__c = A.Id,                          // Site A Name
             UoM__c = 'Others',                                           // UoM
             CID_RelD__c = cl.id,                             // CID RelD
             Free_Link__c = false,                                        // Free Link
             //Contract_Item_Rel__c = c.Id,                    // Contract Item Rel
             Partner__c = false,                                          // Partner
             Routepath__c = '754437 PT Link IT Linkit360-App (Cloud) -',  // Routepath
             Selected__c = false                                         // Selected
         );
         insert L;
         
        test.starttest();
          


         
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=HQ.id;
          O.Account_Site_A__c=HQ.id;
          O.Service_Type__c = 'Newlink';
          O.Account_Site_B__c=A.id;
          O.StageName='Prospecting';
          O.recordtypeid = rt.id;
          O.Name='Tes';
          O.Link_Related__c=L.id;
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          
          O.BP_Payer__c=A.id;
          O.BP_Vat__c=A.id;
            
          insert O;
            
          Contract_Ticket__c contractTicketObj = new Contract_Ticket__c(
              Name = 'Contract Ticket for "Testing Oppty Digital Rewards" Opportunity',        // Name
              Full_Name__c = 'Contract Ticket for "Testing Oppty Digital Rewards" Opportunity',  // Full Name
              Account__c = A.id,                                                    // Account
              Not_Hit_to_SAP__c = false,                                                         // Not Hit to SAP
              TicketStatus__c = 'Review By Contract Manager',                                    // Ticket Status
              Opportunity__c = O.id,                                                // Opportunity
              Review_by_Contract_Manager_Date__c = Date.valueOf('2021-02-02')//,                    // Review by Contract Manager Date
              //Review_by_Finance_Date__c = Date.valueOf('2021')                             // Review by Finance Date
            );
        insert contractTicketObj;  
      
        /*  OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;*/
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OLI2.Contract_Start_Date__c=system.today().adddays(-3);
          OLI2.Contract_End_Date__c=system.today().adddays(3);
          insert OLI2;
          O.Service_Type__c='Relocation';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Day';
          O.StageName='survey';
          O.Account_Site_A__c=a.Id;
          O.SR__c='22222';
          O.COF_Number__c='4';
          o.Project_Coordinator__c='90006544 Nancy Citraningrum';
          O.Site_B_Relocation_Street__c='Baker Street';
          O.Site_A_Relocation_Street__c='Elm Street';
          O.contract_ticket__c = contractTicketObj.id;   
          O.StageName='Waiting for Contract';
          o.PIC_Contact_Data_Email__c='';
          o.PIC_B_Email__c='';
          o.PIC_A_Email__c='';
          
          SYSTEM.DEBUG ('===== siap update opportunity stage to Waiting for Contract with Contract Ticket');
          SYSTEM.DEBUG ('===== oppty : ' + o);
          SYSTEM.DEBUG ('===== oppty.recordtypename : ' + o.recordtype.name);
            
          update O;
         
          
     //     HitsapComDocumentSapSoap.UpdateOpportunitySurvey(O.id);
     //     HitsapComDocumentSapSoap.UpdateOpportunityImplementation(O.id);
        } 
        test.stoptest();
     }
    
    
    static testMethod void myUnitTestRelocation2() {
        // TO DO: implement unit test
        
       RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
        
        
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id,OwnerID from Account where  Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
        User U=[SELECT id FROM User WHERE ID=:A.ownerid];

        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;

        
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
       
        Opportunity O=new Opportunity();
          OpportunityLineItem OLI=new OpportunityLineItem();
          OpportunityLineItem OLI2=new OpportunityLineItem();
        String OpportunityID='';
        system.runas(U){ 
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.Service_Type__c='newlink';  
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.BP_Payer__c=A.id;
          O.BP_Vat__c=A.id;
          O.BW_After__c='5';
          insert O;
      
        
        /*  OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;
        */
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OLI2.Contract_Start_Date__c=system.today().adddays(-3);
          OLI2.Contract_End_Date__c=system.today().adddays(3);
          insert OLI2;
        }
        
          O.Service_Type__c='Relocation';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Week';
          O.SR__c='22222';
          O.Site_A_Relocation_Street__c='Elm Street';
           o.Project_Coordinator__c='90006544 Nancy Citraningrum';          
          O.StageName='Waiting For Contract';
          O.PKS_Number__c='222';
            update O;
       }
    
      static testMethod void testContractServices() {
        // TO DO: implement unit test

        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id,Ownerid from Account where  Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
        User U=[SELECT id FROM User WHERE ID=:A.ownerid];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
       
        Opportunity O=new Opportunity();
         Contract ci = new Contract();
        String OpportunityID='';
        
          
          Link__c L=new Link__c();
        
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.service_type__c='Upgrade';
          insert O;
          
            ci.name ='CI TEST';
//         ci.Contract_Ticket__c = tmpContract.id;
          ci.Accountid=A.id;
          ci.Opportunity__c=O.id;
         
          insert Ci;
          
           
          L.Name='0877722';
          L.contract_item_rel__c=ci.id;
          L.Link_ID__c = o.Link_ID__c;
          insert L;
      
          OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          OLI.Billing_Type__c='Monthly';
          insert OLI;
          
          O.link_related__c=L.id;
          update O;
        
        }
        
        Contract_Services CS=new Contract_Services();
     //   CS.CreateContractsFromOpportunity(String.valueof(O.id));
     }
    
    
    static testMethod void myUnitTestRelocation() {
        // TO DO: implement unit test
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id,ownerid FROM Account where Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                          Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                          EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');   
        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;

        
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Service_Type__c='relocation';
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.BP_Payer__c=A.id;
          O.BP_VAT__c=A.id;
          O.BW_After__c='5';
          insert O;
      
          OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
        //  insert OLI;
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OLI2.Contract_Start_Date__c=system.today().adddays(-3);
          OLI2.Contract_End_Date__c=system.today().adddays(3);
          insert OLI2;
        }
          O.Service_Type__c = 'Newlink';
         
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Month';
          O.SR__c='22222';
          O.Site_A_Relocation_Street__c='Elm Street';
           o.Project_Coordinator__c='90006544 Nancy Citraningrum';          
          O.StageName='Waiting For Contract';
          O.PKS_Number__c='222';
            update O;
       }
   		
    
   static testMethod void newLinkValidationTest() {
        // TO DO: implement unit test
        
       RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
       Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
       Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
       Account A=[SELECT id,Ownerid from Account where Organization_Type__c='Head Office' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
       User U=[SELECT id FROM User WHERE ID=:A.ownerid];
       Profile p = [SELECT Id FROM Profile WHERE Name='Solution']; 
       User Us = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                         Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                         EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');   

       //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;

       Account tmpAcc = new Account();
       tmpAcc.name = 'temp';
       tmpAcc.term_of_payment__c = 'Z030 Within 30 Days Due Net';
       insert tmpAcc;
       
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.service_type__c = 'Newlink'; 
          O.Accountid=A.id;
          o.Solution_PIC__c= us.Id;
          O.Account_Site_A__c=tmpAcc.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          insert O;
          
          O.BP_payer__C = tmpAcc.id;
          O.BP_vat__C = tmpAcc.id;
          update O;

        
        }  
        test.stoptest();
  }
    
    
        static testMethod void trialChanged() {
        // TO DO: implement unit test
        
       // insert new Transaction__c(TransactionID__c = 1); 
        
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' AND SobjectType='Opportunity' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        //ga ke detect
        //Account A=[SELECT id,Ownerid from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
       //Account A=[SELECT id, Ownerid from Account where Organization_Type__c='Head Office' AND BP_Number__c='703803' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User U = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                            Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                            EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');
        insert U;
		
        //-- SET AM Portfolio Mapping
		//-- TODO: change be better         
        User solutionUser = [select id, name from user where Employee_ID__c='90004892']; 
        
        AM_Portfolio_Mapping__c AMPMapping = new AM_Portfolio_Mapping__c ();
        AMPMapping.AM__c = u.id;
        AMPMapping.Portfolio_Management_Support__c = solutionUser.id;
        AMPMapping.Status__c = 'Active';
		insert AMPMapping;
     
        test.starttest();
        
     

		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accountRecordTypeId;
        acc.Name = 'TEST';
        acc.Unique_Name__c = 'TEST';
        acc.NumberOfEmployees = 2;
        acc.Company_Group__c = 'Perusahaan Asing';
        acc.Customer_VAT_Name__c = 'sdfskdjfsjdf';
        acc.Customer_Type__c = 'NONGSM';
        acc.No_NPWP__c = '123456789123455';
        acc.BillingStreet = 'hive';
        acc.BillingState = 'hive';
        acc.BillingCity = 'hive';
        acc.BillingCountry = 'hive';
        acc.BillingPostalCode = 'hive';
        acc.ShippingStreet = 'hive';
        acc.ShippingState = 'hive';
        acc.ShippingCity = 'hive';
        acc.ShippingCountry = 'hive';
        acc.ShippingPostalCode = 'hive';
        acc.Billing_Building_Name__c = 'hive';
        acc.Shipping_Building_Name__c = 'hive';
        acc.Field_Source__c = 'Bizstore Customer Registration';
        acc.Organization_Type__c = 'Head Office';
        acc.Type = 'Customer';
        acc.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        acc.OU__c = '1';
        acc.Industry = 'Agriculture';
        acc.BP_Number__c = '1xx12';
        acc.Bizstore_Complete__c = false;
        Insert acc;
        
        Account acc1 = new Account();
        acc1.RecordTypeId = accountRecordTypeId;
        acc1.Name = 'TESsT';
        acc1.Unique_Name__c = 'TEsST';
        acc1.NumberOfEmployees = 2;
        acc1.Company_Group__c = 'Perusahaan Asing';
        acc1.Customer_VAT_Name__c = 'sdfskdjfsjdf';
        acc1.Customer_Type__c = 'NONGSM';
        acc1.No_NPWP__c = '123456789123456';
        acc1.BillingStreet = 'hive';
        acc1.BillingState = 'hive';
        acc1.BillingCity = 'hive';
        acc1.BillingCountry = 'hive';
        acc1.BillingPostalCode = 'hive';
        acc1.ShippingStreet = 'hive';
        acc1.ShippingState = 'hive';
        acc1.ShippingCity = 'hive';
        acc1.ShippingCountry = 'hive';
        acc1.ShippingPostalCode = 'hive';
        acc1.Billing_Building_Name__c = 'hive';
        acc1.Shipping_Building_Name__c = 'hive';
        acc1.Field_Source__c = 'Bizstore Customer Registration';
        acc1.Organization_Type__c = 'Head Office';
        acc1.Type = 'Customer';
        acc1.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        acc1.OU__c = '1';
        acc1.Industry = 'Agriculture';
        acc1.BP_Number__c = '1xx12';
        acc1.Bizstore_Complete__c = false;
        Insert acc1;
       
       // User U=[SELECT id FROM User WHERE ID=:Acc.ownerid];
       
        
        
       Contact conc = new Contact();
        conc.AccountId = Acc1.Id;
        conc.LastName = 'Abharaham';
        conc.Email = 'apake@gmail.com';
        insert conc;
        
        

		AccountContactRelation CR=new AccountContactRelation();
   
            CR.AccountID=Acc.id;
            CR.Contactid=Conc.id;
            CR.Roles='PIC BA Print';
            insert CR;
        
        conc = new Contact();
        conc.AccountId = Acc1.Id;
        conc.LastName = 'Muhammad Surya Ramadhan';
        conc.Email = 'apaloe@gmail.com';
        insert conc;
        
        CR=new AccountContactRelation();
        CR.AccountID=Acc.id;
        CR.Contactid=Conc.id;
        CR.Roles='PIC BA Print';
        insert CR;
		        
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=Acc.id;
          O.Account_Site_A__c=Acc.id;
          O.PIC_BA_Print__c = conc.Id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.Contract_Periode__c=12;
          O.Service_type__c='newlink';
          O.BP_payer__C = Acc.id;
          O.BP_vat__C = Acc.id;          
          insert O;
      
        /*  OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;*/
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
          insert OLI2;
            
          O.Service_Type__c='NewLink';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Month';
          O.StageName='survey';
          O.SR__c='22222';
            o.BP_VAT__c = acc.id;
           o.Project_Coordinator__c='90006544 Nancy Citraningrum';
        
          
          
              O.StageName='Quotation Final';
          O.PKS_Number__c='222';
            update O;
     //      update O;
           OpportunityID=O.id;
        
        }  
        
        
        // profile p2=[SELECT id FROM Profile WHERE Name='Sales Support & Admin'];
       //  user u2=[SELECT id from user WHERE Profileid=:p2.id AND isActive=true LIMIT 1];
         system.runas(U){
           O.Quotation_Final_Approval__c='Approved';
           O.Service_Type__c = 'Upgrade'; 
             O.trial__c = true;
           update O;
        
         }
         test.stoptest();
    
         
    }
}