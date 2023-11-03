@isTest(seealldata=true)	
public with sharing class Test_BatchInsertOpportunityLineItem {    
    static testMethod void testMethod1() {
    	
    	list<pricebook2> pbList = [select id, name from pricebook2 where name='MPLS'];
        
    	list<pricebookentry> pbEntryList = [select id, Product2.name, product2id from pricebookentry where 
        										Pricebook2Id=:pbList[0].id and
												(Product2.name = 'MPLS - 1 Mbps' or Product2.name = 'Instalasi MPLS' )];  
        Account acc = [select id from Account where organization_type__c ='Head Office' limit 1];
        
    	List <Opportunity> oppList = new List <Opportunity>();
		Opportunity tmpOpp = new Opportunity();
		tmpOpp.Project_Group__c = 'Test Group Opp';
		tmpOpp.Opportunity_Group_Related__c = null;
		tmpOpp.Opportunity_Group_Item_Related__c = null;
		
		tmpOpp.service_type__c = 'Newlink';
		tmpOpp.name = 'Oppty Name';
		tmpOpp.Accountid = acc.id;
		tmpOpp.CloseDate = system.today();
		tmpOpp.Expected_RFS_Date__c = system.today();
		tmpOpp.LeadSource = null;
		
		tmpOpp.BP_Payer__c = acc.id;
		tmpOpp.BP_VAT__c = acc.id;
		
		tmpOpp.Contract_Periode__c = 12;
		  
		tmpOpp.stageName = 'Prospecting';
		tmpOpp.Periode_UOM__c = 'Month';
		tmpOpp.Description = 'Desc';
		
		tmpOpp.Account_Site_A__c = acc.id;
		tmpOpp.Account_Site_B__c = null;
		
		tmpOpp.Link_Related__c = null;
		
		tmpOpp.Pricebook2id = pbList[0].id;
		
		tmpOpp.Product_List__c = pbEntryList[0].product2id + ';' + pbEntryList[1].product2id;
		tmpOpp.Product_Price_List__c = '1000;2000';
		
		//oppList.add(tmpOpp);
		insert tmpOpp;
		
		//-- opp line items
		List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = tmpOpp.id;
		oli.Product2Id	= pbEntryList[0].product2id;
		oli.Quantity = 1;
		oliList.add(oli);
		
		oli = new OpportunityLineItem();
		oli.OpportunityId = tmpOpp.id;
		oli.Product2Id	= pbEntryList[1].product2id;
		oli.Quantity = 2;
		oliList.add(oli);
					    			    	
    	Test.startTest(); 
        
        
        BatchInsertOpportunityLineItem biOLI = new BatchInsertOpportunityLineItem(oliList);
    	database.executeBatch(biOLI);
    
        Test.stopTest();
    }
}