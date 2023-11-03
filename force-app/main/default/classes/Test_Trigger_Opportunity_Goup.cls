@isTest(seealldata=true)	
public with sharing class Test_Trigger_Opportunity_Goup {    
    static testMethod void testMethod1() {
        
        Test.startTest(); 
        Opportunity_Group__c ogNew = new Opportunity_Group__c();
        list<pricebook2> pbList = [select id, name from pricebook2 where name='MPLS'];
        ogNew.Price_book__c = pbList[0].id;
        
        list<pricebookentry> pbEntryList = [select id, Product2.name, product2id from pricebookentry where 
        										Pricebook2Id=:ogNew.Price_book__c and
												(Product2.name = 'MPLS - 1 Mbps' or Product2.name = 'Instalasi MPLS' )];  
        
        ogNew.Product__c = pbEntryList[0].product2id;
        ogNew.Product_installation__c = pbEntryList[1].product2id;
        
        insert ogNew;
        
        Test.stopTest();
        
    }
      
}