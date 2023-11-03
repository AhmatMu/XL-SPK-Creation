@isTest(seealldata=true)
public class ApptiumConsumerTest {

    static testMethod void testUpdateOppty01() {
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        
        Account acc = new Account ();
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        acc = a;

        Test.startTest(); 
        Contact cont = new Contact();
        cont.lastName ='wanka';
        cont.accountid = acc.id;
        insert cont;
        
        Opportunity opp = new Opportunity();
        opp.name = 'TEst';
        opp.StageName ='Prospecting';
        opp.CloseDate = date.today();
        opp.accountid = acc.id;

        // -- non GSM
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        opp.Pricebook2id=PB.id;
        opp.CloseDate=system.today().adddays(10);
        opp.Periode_UOM__c='Month';
        opp.BP_payer__C = A.id;
        opp.BP_vat__C = A.id;   
        
        opp.Service_Type__c='NewLink';
        opp.LastMile_Type__c='Radio';
        opp.Expected_RFS_Date__c=system.today().addmonths(3);
        opp.Contract_Periode__c=12;
        opp.Periode_Uom__c='Month';
        opp.StageName='survey';
        opp.SR__c='22222';
        opp.Project_Coordinator__c='90006544 Nancy Citraningrum';
        opp.PKS_Number__c='222';
        insert opp;
        
        OpportunityLineItem OLI2=new OpportunityLineItem();
        OLI2.Product2id=Precurring.id;
        OLI2.OpportunityID=opp.id;
        OLI2.revenue_type__c='Recurring';
        OLI2.UnitPrice=50000000;
        OLI2.Quantity=1;
        OLI2.Contract_Start_Date__c= date.today();
        OLI2.Contract_End_Date__c= date.today();
        OLI2.Billing_Type__c='Monthly';
        insert OLI2;
        list<Opportunity> listopp=new list<Opportunity>();
       
        opp.stagename ='Waiting for BA';
           Update opp;
           listopp.add(opp);
        apptiumAPICallout.invokeApexCallout(listOpp); 
       
       
    
        opp.BW_after__c= '1';
        opp.Uom_BW_After__c='1';
        opp.Account_Site_A__c = acc.Id;
        opp.stagename ='Waiting for Contract';
     //   Update opp;
        
        opp.stagename ='Closed Won';
     //   Update opp;

        Test.stopTest();
        
    }

    static testMethod void testUpdateOppty02() {
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        
        Account acc = new Account ();
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        acc = a;

        Test.startTest(); 

        Contact cont = new Contact();
        cont.lastName ='Wanka2';
        cont.accountid = acc.id;
        insert cont;
        
        Opportunity opp = new Opportunity();
        opp.name = 'TEst2';
        opp.StageName ='Prospecting';
        opp.CloseDate = date.today();
        opp.accountid = acc.id;

        // -- non GSM
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        opp.Pricebook2id=PB.id;
        opp.CloseDate=system.today().adddays(10);
        opp.Periode_UOM__c='Month';
        opp.BP_payer__C = A.id;
        opp.BP_vat__C = A.id;   
        
        opp.Service_Type__c='NewLink';
        opp.LastMile_Type__c='Radio';
        opp.Expected_RFS_Date__c=system.today().addmonths(3);
        opp.Contract_Periode__c=12;
        opp.Periode_Uom__c='Month';
        opp.StageName='survey';
        opp.SR__c='22222';
        opp.Project_Coordinator__c='90006544 Nancy Citraningrum';
        opp.PKS_Number__c='222';
        insert opp;
        
        opp.stagename ='Closed Lost';
        opp.Loss_Reason__c = 'Price';
        opp.Loss_Reason_Description__c = 'bla bla';
        opp.Closed_Lost_Flag__c = 'PR CANCEL';
   //     Update opp;

        Test.stopTest();
        
    }
    
}