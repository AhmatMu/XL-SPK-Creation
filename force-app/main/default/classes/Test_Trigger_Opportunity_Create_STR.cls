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
public class Test_Trigger_Opportunity_Create_STR {

    static testMethod void testMethod_Create_STR() {
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
        opp.Periode_Uom__c='Year';
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
          
        opp.stagename ='Waiting for BA';
        Update opp;
    
        opp.BW_after__c= '1';
        opp.Uom_BW_After__c='MBps';
        opp.Account_Site_A__c = acc.Id;
        
        opp.stagename ='Waiting for Contract';
        Update opp;
        
        opp.stagename ='Waiting for BA';
        Update opp;
        
        opp.stagename ='Closed Won';
        Update opp;
        
        opp.stagename ='Waiting for Contract';
        Update opp;

        Test.stopTest();
    }      
}