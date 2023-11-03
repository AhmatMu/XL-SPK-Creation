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
private class test_updateprinformation {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
          
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where  Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        test.starttest();
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
        	
        	O.Accountid=A.id;
        	O.Account_Site_A__c=A.id;
        	O.RecordTypeid=rt.id;
        	O.StageName='Prospecting';
        	O.Name='Tes';
        	O.CloseDate=system.today().adddays(10);
        	O.Pricebook2id=PB.id;
        	O.PR__c='10333';
        	O.SR__c='0222';
        		O.Service_Type__c='NewLink';
        	O.LastMile_Type__c='Radio';
        	O.Expected_RFS_Date__c=system.today().addmonths(3);
        	O.Contract_Periode__c=12;
        	O.Periode_Uom__c='Year';
        	O.StageName='survey';
        	O.SR__c='22222';
        	 o.Project_Coordinator__c='90006544 Nancy Citraningrum';
        	 O.PKS_Number__c='2334';
        	insert O;
        	OpportunityLineItem OLI2=new OpportunityLineItem();
        	OLI2.Product2id=Precurring.id;
        	OLI2.OpportunityID=O.id;
        	OLI2.revenue_type__c='Recurring';
        	OLI2.UnitPrice=50000000;
        	OLI2.Quantity=1;
        	OLI2.Billing_Type__c='Monthly';
        	insert OLI2;
        }
        updatePRInformation.UpdatePRInformationUpdate(String.valueof(O.id));
        
    }
      static testMethod void myUnitTestLeasedLine() {
        // TO DO: implement unit test
           /*
           sebelum deploy , makesure beberapa hal:
           - validation rules opportunity "survey is mandatory" non aktif
           -accountid field di opportunity lookup filternya dimatikan
           -contoh account dummy makesure head officenya punya pic ba print & pic ba recipient
           -contoh branch account dummy makesure punya pic site
           -makesure sf id nya sebelum naik ke production , sf id ganti sf id production
           */
     /*
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
         Account HQ=[SELECT id from Account where Organization_Type__c='Head Office' AND Name='PT BESS Finance' AND Ownerid=:u.id LIMIT 1];
        Account A=[SELECT id from Account where ID='0017F00000RM6h3QAD' AND ParentID=:HQ.id AND Ownerid=:u.id LIMIT 1];
           Link__C L=[SELECT id FROM Link__c where ID='a077F000003X0FjQAK'];
        
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        test.starttest();
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
        	
        	O.Accountid=HQ.id;
        	O.Account_Site_A__c=HQ.id;
        	O.Account_Site_B__c=A.id;
        	O.StageName='Prospecting';
        	O.Name='Tes';
        	O.Link_Related__c=L.id;
        	O.CloseDate=system.today().adddays(10);
        	O.Pricebook2id=PB.id;
        	O.Periode_Uom__c='Month';
        	insert O;
      
        	
        	OpportunityLineItem OLI2=new OpportunityLineItem();
        	OLI2.Product2id=Precurring.id;
        	OLI2.OpportunityID=O.id;
        	OLI2.revenue_type__c='Recurring';
        	OLI2.UnitPrice=50000000;
        	OLI2.Quantity=1;
        	OLI2.Billing_Type__c='Monthly';
        	insert OLI2;
        	O.Service_Type__c='Relocation';
        	O.LastMile_Type__c='Radio';
        	O.Expected_RFS_Date__c=system.today().addmonths(3);
        	O.Contract_Periode__c=12;
        	
        	O.StageName='survey';
        	O.SR__c='22222';
        	O.COF_Number__c='4';
        	 o.Project_Coordinator__c='90006544 Nancy Citraningrum';
        	update O;
        /*	O.Site_B_Relocation_Street__c='Baker Street';
        	O.Site_A_Relocation_Street__c='Elm Street';
        	O.StageName='Waiting for Contract';
        	update O;
       /* 	O.BP_Payer__c=A.id;
        	O.BP_Vat__c=A.id;
        	update O;
        	
           updatePRInformation.UpdatePRInformationUpdate(String.valueof(O.id));
        } 
        test.stoptest();*/
     }
      static testMethod void deleteopportunityLineItem() {
        // TO DO: implement unit test
          
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where  Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        test.starttest();
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
        	
        	O.Accountid=A.id;
        	O.Account_Site_A__c=A.id;
        	O.RecordTypeid=rt.id;
        	O.StageName='Prospecting';
        	O.Name='Tes';
        	O.CloseDate=system.today().adddays(10);
        	O.Pricebook2id=PB.id;
        	O.PR__c='10333';
        	O.SR__c='0222';
        		O.Service_Type__c='NewLink';
        	O.LastMile_Type__c='Radio';
        	O.Expected_RFS_Date__c=system.today().addmonths(3);
        	O.Contract_Periode__c=12;
        	O.Periode_Uom__c='Year';
        	O.StageName='survey';
        	O.SR__c='22222';
        	 o.Project_Coordinator__c='90006544 Nancy Citraningrum';
        	 O.PKS_Number__c='2334';
        	insert O;
        	OpportunityLineItem OLI2=new OpportunityLineItem();
        	OLI2.Product2id=Precurring.id;
        	OLI2.OpportunityID=O.id;
        	OLI2.revenue_type__c='Recurring';
        	OLI2.UnitPrice=50000000;
        	OLI2.Quantity=1;
        	OLI2.Billing_Type__c='Monthly';
        	insert OLI2;
        	
        	
        	delete OLI2;
        	
        }
        
      }
}