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
private class Test_Trigger_Order_Item {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
            User U=[SELECT ID From User WHERE Name='Nityo Triantono'];
        Account A=New Account();
        A.Name='tes';
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Organization_type__c='Head Office';
        insert A;
        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        insert S;
         Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='Device Bundling'];
         PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id LIMIT 1];
         Opportunity Op=new Opportunity();
         Op.Accountid=A.id;
         Op.StageName='Prospecting';
         Op.Name='Tes';
         Op.CloseDate=system.today().adddays(10);
         Op.Pricebook2id=PB.id;
         Op.Periode_UOM__c='Month';
         
         Op.BP_Payer__c=A.id;
         Op.BP_Vat__c=A.id;
         insert Op;
         OpportunityLineItem OLI=new OpportunityLineItem();
         OLI.Quantity=100;
         OLI.pricebookentryid=PBE.id;
         OLI.opportunityid=Op.id;
         OLI.UnitPrice=10000;
         insert OLI;
         Order O=New Order();
            O.AccountID=A.id;
            O.Status='Draft';
            O.SLOC__c=S.id;
            O.recordtypeid=system.label.RT_ORDER_DEVICEBUNDLING_NEW;
            O.Pricebook2id=PB.id;
            O.opportunityID=Op.id;
            O.EffectiveDate=system.today();
            insert O;
  OrderItem plcLineItem = new OrderItem(OrderId = O.id, PricebookEntryId = pbe.ID, Quantity = 1, UnitPrice = 300);
        insert plcLineItem;
        plclineItem.quantity=4;
        update plclineitem;
        delete plclineitem;
    }
    static testMethod void myUnitTestGSMSIMCARD() {
        // TO DO: implement unit test
            User U=[SELECT ID From User WHERE Name='Nityo Triantono'];
        Account A=New Account();
        A.Name='tes';
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Organization_type__c='Head Office';
        insert A;
        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        insert S;
         Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM-Material General'];
         PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id LIMIT 1];
         Opportunity Op=new Opportunity();
         Op.Accountid=A.id;
         Op.StageName='Prospecting';
         Op.Name='Tes';
         Op.CloseDate=system.today().adddays(10);
         Op.Pricebook2id=PB.id;
         Op.Periode_UOM__c='Month';
         
         Op.BP_Payer__c=A.id;
         Op.BP_Vat__c=A.id;
         insert Op;
         OpportunityLineItem OLI=new OpportunityLineItem();
         OLI.Quantity=100;
         OLI.pricebookentryid=PBE.id;
         OLI.opportunityid=Op.id;
         OLI.UnitPrice=100;
         insert OLI;
         Order O=New Order();
            O.AccountID=A.id;
            O.Status='Draft';
            O.SLOC__c=S.id;
            O.recordtypeid=system.label.RT_ORDER_GSM_SIM_Card;
            O.Pricebook2id=PB.id;
            O.opportunityID=Op.id;
            O.EffectiveDate=system.today();
            insert O;
  OrderItem plcLineItem = new OrderItem(OrderId = O.id, PricebookEntryId = pbe.ID, Quantity = 1, UnitPrice = 300);
        insert plcLineItem;
        plclineItem.quantity=4;
        update plclineitem;

        plclineItem.quantity=4;
        update plclineitem;

        delete plclineitem;
    }
}