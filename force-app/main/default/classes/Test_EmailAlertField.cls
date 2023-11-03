@isTest(seealldata=true)
  
public class Test_EmailAlertField {
     static testMethod void emailalertfield() {
     	
        // TO DO: implement unit test
         RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM Leased Line' AND SobjectType='Opportunity' LIMIT 1];
         Product2 Ptime=[SELECT id, Bandwidth__c, UoM_Bandwidth__c  FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
         Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='703803'
                    order by createddate asc LIMIT 1];
         
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
        Contract contractObj = new Contract(
            name = '3001674-5',
            Accountid = A.id,
            status = 'draft'
        );
        Insert contractObj;
         SYSTEM.DEBUG('==== contractObj : ' + contractObj);
         
         Link__c linkObj = new Link__c(
             BU__c = 'ENTERPRISE',                                      // BU
             ID__c = '22623',                                             // ID
             Name = '23-00016',                                           // CID/Link ID
             CID__c = '23-00016',                                         // CID *
             Link_ID__c = '029C1219L3',                                   // Link ID
             Status_Link__c = 'IN_SERVICE',                                  // Status Link
             Company_Name__c = 'Link IT, PT',                             // Company Name
             Service_Type__c = 'Cloud',                                   // Service Type
             Contract_Item__c = '3001674-5',                              // Contract Item
             BP_Site_A__c = '754437',                                     // BP Site A
             Capacity_Bandwidth__c = '1',                                 // Capacity Bandwidth
             Site_A_Name__c = A.Id,                          // Site A Name
             UoM__c = 'Others',                                           // UoM
             CID_RelD__c = cl.id,                             // CID RelD
             Free_Link__c = true,                                        // Free Link
             Contract_Item_Rel__c = contractObj.Id,                    // Contract Item Rel
             Partner__c = false,                                          // Partner
             Routepath__c = '754437 PT Link IT Linkit360-App (Cloud) -',  // Routepath
             Selected__c = false                                         // Selected
         );
         system.debug('------ insert link '+ linkobj);
         
         insert linkObj;
         
         
        //
         
         Opportunity O=new Opportunity();
         String OpportunityID='';
         system.runas(U){
          
             O.Accountid=HQ.id;
             O.Account_Site_A__c=HQ.id;
             O.Service_Type__c = 'newlink';
             O.Account_Site_B__c=A.id;
             O.StageName='Prospecting';
             O.recordtypeid = rt.id;
             O.Name='Tes';
             O.Link_Related__c=linkObj.id;
             O.CloseDate=system.today().adddays(10);
             O.Pricebook2id=PB.id;
             O.Periode_UOM__c='Month';
             
             O.BP_Payer__c=A.id;
             O.BP_Vat__c=A.id;
             insert O;
             system.debug('link relatednya :'+O.Link_Related__c);
             system.debug('Oppty ID nya :'+O.id);
             
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
             O.Service_Type__c='Upgrade';
             O.LastMile_Type__c='Radio';
             O.Expected_RFS_Date__c=system.today().addmonths(3);
             O.Contract_Periode__c=12;
             O.Periode_Uom__c='Day';
             O.StageName='survey';
             O.BW_before__c = linkObj.UoM__c;
             O.BW_after__c = String.valueOf( Ptime.Bandwidth__c);
             O.Uom_BW_After__c = String.valueOf(Ptime.UoM_Bandwidth__c);
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
             //O.Link_Related__c=L.id;
             
             SYSTEM.DEBUG ('===== siap update opportunity stage to survey');
             SYSTEM.DEBUG ('===== oppty : ' + o);
             SYSTEM.DEBUG ('===== oppty.recordtypename : ' + o.recordtype.name);
             
             update O;
             
             
             test.starttest();
             OLI2.Note_From_Solution__c = 'hello';
             update OLI2; 		
     		 system.debug('================ di sini broww'+ oli2);
     		 
			 test.stoptest();
     	
        } 
        
     }

	static testMethod void recurringNewLink() {
     	
        // TO DO: implement unit test
         RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM Leased Line' AND SobjectType='Opportunity' LIMIT 1];
         Product2 Ptime=[SELECT id, Bandwidth__c, UoM_Bandwidth__c  FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
         Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='703803'  order by createddate asc LIMIT 1];
         
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
             Free_Link__c = true,                                        // Free Link
             //Contract_Item_Rel__c = c.Id,                    // Contract Item Rel
             Partner__c = false,                                          // Partner
             Routepath__c = '754437 PT Link IT Linkit360-App (Cloud) -',  // Routepath
             Selected__c = false                                         // Selected
         );
         insert L;
         
         
        //test.starttest();
         
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
          system.debug('link relatednya :'+O.Link_Related__c);
          system.debug('Oppty ID nya :'+O.id);
      
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
          O.Service_Type__c='Upgrade';
          O.LastMile_Type__c='Radio';
          O.Expected_RFS_Date__c=system.today().addmonths(3);
          O.Contract_Periode__c=12;
          O.Periode_Uom__c='Day';
          O.StageName='survey';
          O.BW_before__c = l.UoM__c;
          O.BW_after__c = String.valueOf( Ptime.Bandwidth__c);
          O.Uom_BW_After__c = String.valueOf(Ptime.UoM_Bandwidth__c);
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
          //O.Link_Related__c=L.id;
          
          SYSTEM.DEBUG ('===== siap update opportunity stage to survey');
          SYSTEM.DEBUG ('===== oppty : ' + o);
          SYSTEM.DEBUG ('===== oppty.recordtypename : ' + o.recordtype.name);
            
          update O;
            
          

     	
        } 
        //test.stoptest();
     }
}