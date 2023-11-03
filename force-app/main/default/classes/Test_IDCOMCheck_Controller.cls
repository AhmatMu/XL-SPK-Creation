@isTest(seealldata=true)
private class  Test_IDCOMCheck_Controller {
    static testMethod void test1 (){

        test.starttest();

        Account acc = [select id from account where organization_type__c ='Head Office' limit 1];
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM (Activation)'];
        
        Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id LIMIT 1];
        //Product2 PrdOrder = [SELECT id FROM Product2 WHERE name='z-dummy-product1' LIMIT 1];
        //PricebookEntry PBE=[SELECT id, product2id FROM PricebookEntry WHERE Pricebook2id=:PB.id and product2.name= 'z-dummy-product1' LIMIT 1];      	
        
        RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'Prepaid Tagging - New ID COM'];

        Opportunity Op = New Opportunity();
        Op.Name = 'Test GSM taggging';
        Op.Project_Group__c = 'Test taggging';
        Op.CloseDate = system.today();
        Op.AccountId = acc.id;
        Op.StageName = 'Prospecting';
        Op.Amount = 2250000;
        Op.Pricebook2id=PB.id;
    
        insert Op;

        OpportunityLineItem OLI=new OpportunityLineItem();
         OLI.Quantity=100;
         OLI.pricebookentryid=PBE.id;
         OLI.opportunityid=Op.id;
         OLI.UnitPrice=10000;
         insert OLI;


        Order Ord=New Order();
		Ord.AccountID=acc.id;
		Ord.opportunityId = Op.id;
		Ord.Status='Draft';
		
		Ord.EffectiveDate=system.today();
		Ord.pricebook2id = pb.id;
		Ord.RecordTypeId = recTypeOrder.id;
        insert Ord;


        ApexPages.StandardController sc = new ApexPages.StandardController(Ord);
        IDCOMCheck_Controller ICCController = new IDCOMCheck_Controller (SC); 

        ICCController.responseStatus = 'available'; 
        ICCController.IDCOMNumber = '-';
        ICCController.check();

        ICCController.responseStatus = 'not available';
        ICCController.IDCOMNumber = '-';
        ICCController.check();

        ICCController.responseStatus = 'failed';
        ICCController.IDCOMNumber = '-';
        ICCController.check();

        test.stoptest();

    }

}