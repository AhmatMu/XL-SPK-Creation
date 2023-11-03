@isTest (seealldata = true)
public with sharing class Test_ReadAvailableMaterialInfo_Controlle {
     static testMethod void test1 (){
     	// TO DO: implement unit test
        User U=[SELECT ID From User WHERE Name='Nityo Triantono'];
        Account acc = [select id from account where organization_type__c ='Head Office' limit 1];
        /*
        Account A=New Account();
        A.Name='tes';
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Organization_type__c='Head Office';
        insert A;*/
        
        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        insert S;
        
        Pricebook2 pb = [select id, name from pricebook2 where name='GSM-Material General' limit 1];
        
        Order O=New Order();
		O.AccountID=acc.id;
		O.Status='Draft';
		O.SLOC__c=S.id;
		O.EffectiveDate=system.today();
		O.pricebook2id = pb.id;
        insert O;
        
    	test.starttest();   
		
		ApexPages.StandardController ramSC = new ApexPages.StandardController(O);       
       	ReadAvailableMaterialInfo_Controller ram = new ReadAvailableMaterialInfo_Controller (ramSC);
       	PageReference pr = ram.getInfo();
       	
 
       	PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id LIMIT 1];      	
       	OrderItem oi = new OrderItem(OrderId = O.id, PricebookEntryId = pbe.ID, Quantity = 1, UnitPrice = 300);
        insert oi;
       	PageReference pr2 = ram.getInfo();
       	
       	ram.refresh();
       	
       	test.stoptest();
		
     }
}