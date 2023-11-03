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
private class test_set_bandwidth_emailalert {

    static testMethod void testemailalert() {
        // TO DO: implement unit test
         // TO DO: implement unit test
         RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
         Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
          Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='MPLS-02' AND Revenue_Type__c='Recurring' LIMIT 1];
          Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
         Account A=[SELECT id from Account where Name='PT BESS Finance' AND BP_Number__C='712822' AND ParentID=:HQ.id  LIMIT 1]; 
            Link__C L=[SELECT id FROM Link__c where Name='02-04034'];
            Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
            PricebookEntry PBE=[SELECT id from PricebookEntry WHERE Product2id=:Precurring.id AND Pricebook2id=:PB.id];
       
            User U=[SELECT id FROM User WHERE ID=:HQ.ownerid];
       
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Service_Type__c='Upgrade';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.BP_payer__C = A.id;
          O.BP_vat__C = A.id;
           O.Link_Related__c=L.id;     
          insert O;
      	  OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.Billing_Type__c='Monthly';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          OLI.PricebookEntryid=PBE.id;
          insert OLI;
       
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
           OLI2.Billing_Type__c='Monthly';
          insert OLI2;
          O.link_related__c=L.id;
          update O;
           setbandwidthbeforeafter.setbandwidth(O);
           setbandwidthbeforeafter.setbandwidth2(O.id,OLI2.id);
        }
        
    }
     static testMethod void testsetbandwidth() {
        // TO DO: implement unit test
         // TO DO: implement unit test
         RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
         Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
          Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
          Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
         Account A=[SELECT id from Account where Name='PT BESS Finance' AND BP_Number__C='712822' AND ParentID=:HQ.id  LIMIT 1]; 
            Link__C L=[SELECT id FROM Link__c where Name='02-04034'];
            Link__C L2=[SELECT id FROM Link__c where Name='02-04033'];
            Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
            PricebookEntry PBE=[SELECT id from PricebookEntry WHERE Product2id=:Precurring.id AND Pricebook2id=:PB.id];
            PricebookEntry PBE2=[SELECT id from PricebookEntry WHERE Product2id=:Ptime.id AND Pricebook2id=:PB.id];
      
            User U=[SELECT id FROM User WHERE ID=:HQ.ownerid];
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Service_Type__c='NewLink';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.BP_payer__C = A.id;
          O.BP_vat__C = A.id;
          insert O;
      	 
       
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.PricebookEntryid=PBE.id;
          OLI2.OpportunityID=O.id;
          OLI2.UnitPrice=50000000;
           OLI2.Billing_Type__c='Monthly';
          OLI2.Quantity=1;
          insert OLI2;
          O.link_related__c=L.id;
          update O;
            setbandwidthbeforeafter.setbandwidth(O);
           setbandwidthbeforeafter.setbandwidth2(O.id,OLI2.id);
           
        }
        
    }
    
     static testMethod void testsetbandwidth2() {
        // TO DO: implement unit test
         // TO DO: implement unit test
         RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
         Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
          Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
          Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
         Account A=[SELECT id from Account where Name='PT BESS Finance' AND BP_Number__C='712822' AND ParentID=:HQ.id  LIMIT 1]; 
            Link__C L=[SELECT id FROM Link__c where Name='02-04034'];
            Link__C L2=[SELECT id FROM Link__c where Name='02-04033'];
            Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
            PricebookEntry PBE=[SELECT id from PricebookEntry WHERE Product2id=:Precurring.id AND Pricebook2id=:PB.id];
            PricebookEntry PBE2=[SELECT id from PricebookEntry WHERE Product2id=:Ptime.id AND Pricebook2id=:PB.id];
      
            User U=[SELECT id FROM User WHERE ID=:HQ.ownerid];
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
         O.Service_Type__c='Upgrade';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
       
          O.Periode_UOM__c='Month';
         // O.BP_payer__C = A.id;
          //O.BP_vat__C = A.id;
           
          insert O;
      	 
       
          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.UnitPrice=50000000;
           OLI2.Billing_Type__c='Monthly';
          OLI2.Quantity=1;
          OLI2.PricebookEntryid=PBE.id;
          insert OLI2;
          O.Link_Related__c=L.id;
          update O;
             setbandwidthbeforeafter.setbandwidth(O);
           setbandwidthbeforeafter.setbandwidth2(O.id,OLI2.id);
           
        }
        
    }
        
}