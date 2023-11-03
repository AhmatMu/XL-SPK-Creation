@isTest(seealldata=true)
public with sharing class Test_Trigger_Opportunity_for_PO_Date {
	
    static testMethod void testMethod_nonGSM() {
    	user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Simcard Postpaid/Prepaid'
            LIMIT 1
        ];
    	
        Account acc = new Account ();
        //acc.Name ='Test';
        //insert acc;
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        acc = a;

		Contact cont = new Contact();
		cont.lastName ='Doddy';
		cont.accountid = acc.id;
		insert cont;
		
        Opportunity opp = new Opportunity();
        opp.name = 'TEst';
        opp.StageName ='Prospecting';
        opp.CloseDate = date.today();
        opp.accountid = acc.id;
        opp.RecordTypeId = rt.id;
        
        
        Test.startTest(); 
		// -- non GSM
		Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
		opp.Pricebook2id=PB.id;
		opp.CloseDate=system.today().adddays(10);
		opp.Periode_UOM__c='Month';
		opp.BP_payer__C = A.id;
		opp.BP_vat__C = A.id;   
		
		opp.Service_Type__c='Newlink';
        opp.LastMile_Type__c='Radio';
        opp.Expected_RFS_Date__c=system.today().addmonths(3);
        opp.Contract_Periode__c=12;
        opp.Periode_Uom__c='Year';
        opp.StageName='survey';
        opp.SR__c='22222';
        opp.Project_Coordinator__c='90006544 Nancy Citraningrum';
        opp.PKS_Number__c='222';
        insert opp;
          		
		opp.stagename ='Quotation Final';
		
        update opp;


        
     	Test.stopTest();
    }

    static testMethod void testMethod_GSM_SIMCardOrder() {
    	user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
    	
        Account acc = new Account ();
        //acc.Name ='Test';
        //insert acc;
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        acc = a;

		Contact cont = new Contact();
		cont.lastName ='Doddy';
		cont.accountid = acc.id;
		insert cont;
		
        Opportunity opp = new Opportunity();
        opp.name = 'TEst';
        opp.StageName ='Prospecting';
        opp.CloseDate = date.today();
        opp.accountid = acc.id;
        
        
        Test.startTest(); 
		// -- non GSM
		Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='GSM-Material General'];
		opp.Pricebook2id=PB.id;
		opp.CloseDate=system.today().adddays(10);
		opp.Periode_UOM__c='Month';
		opp.BP_payer__C = A.id;
		opp.BP_vat__C = A.id;   
		
		opp.Service_Type__c='NewLink';
        opp.LastMile_Type__c='Radio';
        opp.Expected_RFS_Date__c=system.today().addmonths(3);
        opp.Contract_Periode__c=12;
        opp.Periode_Uom__c='Year';
        opp.StageName='survey';
        opp.SR__c='22222';
        opp.Project_Coordinator__c='90006544 Nancy Citraningrum';
        opp.PKS_Number__c='222';
        insert opp;
          		
		opp.stagename ='Quotation Final';
        update opp;
		opp.stagename ='Implementation';
        update opp;

        
     	Test.stopTest();
    }
    
    static testMethod void testMethod_GSM_Activation() {
    	user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
    	
        Account acc = new Account ();
        //acc.Name ='Test';
        //insert acc;
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        acc = a;

		Contact cont = new Contact();
		cont.lastName ='Doddy';
		cont.accountid = acc.id;
		insert cont;
		
        Opportunity opp = new Opportunity();
        opp.name = 'TEst';
        opp.StageName ='Prospecting';
        opp.CloseDate = date.today();
        opp.accountid = acc.id;
        
        
        Test.startTest(); 
		// -- non GSM
		Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='GSM-Package General'];
		opp.Pricebook2id=PB.id;
		opp.CloseDate=system.today().adddays(10);
		opp.Periode_UOM__c='Month';
		opp.BP_payer__C = A.id;
		opp.BP_vat__C = A.id;   
		
		opp.Service_Type__c='NewLink';
        opp.LastMile_Type__c='Radio';
        opp.Expected_RFS_Date__c=system.today().addmonths(3);
        opp.Contract_Periode__c=12;
        opp.Periode_Uom__c='Year';
        opp.StageName='survey';
        opp.SR__c='22222';
        opp.Project_Coordinator__c='90006544 Nancy Citraningrum';
        opp.PKS_Number__c='222';
        insert opp;
          		
		opp.stagename ='Submit PO';
		
        update opp;


        
     	Test.stopTest();
    }            
}