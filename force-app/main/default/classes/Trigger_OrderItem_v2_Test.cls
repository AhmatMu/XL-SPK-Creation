/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-11-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   02-09-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest(seealldata=true)
public class Trigger_OrderItem_v2_Test {
    @isTest
    static void myUnitTest() {
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
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id AND IsActive = true LIMIT 1];

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

    @isTest
    static void myUnitTestGSMSIMCARD() {
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
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id AND IsActive = true LIMIT 1];

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