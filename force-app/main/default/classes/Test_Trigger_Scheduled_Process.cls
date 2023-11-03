/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 30-08-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   30-08-2022   Doddy Prima   Initial Version
**/
@isTest(seealldata=true)
private class Test_Trigger_Scheduled_Process {
    static testMethod void taggingTest () {

        //-- GET user, Pricebook, and PricebookEntry
        /*
        User userObj = [SELECT ID From User WHERE Name='Nityo Triantono'];
        Pricebook2 pricebookObj = [SELECT id FROM Pricebook2 WHERE Name='GSM Activation']; 
        PricebookEntry pricebookEntryObj = [SELECT id FROM PricebookEntry WHERE Pricebook2id=:pricebookObj.id and product2.isactive=true  LIMIT 1];

        //-- Create Account 
        Account accountObj = New Account();
        accountObj.Name = 'tes';
        accountObj.BillingStreet = 'Jl. S Parman';
        accountObj.BillingCity = 'Jakarta';
        accountObj.BillingPostalCode = '14460';
        accountObj.BillingState = 'DKI Jakarta';
        accountObj.Organization_type__c = 'Head Office';
        accountObj.OU__c = '1234';
        insert accountObj;

        //-- Create Opportunity
        Opportunity opportunityObj = new Opportunity();
        opportunityObj.Accountid = accountObj.id;
        opportunityObj.StageName = 'Prospecting';
        opportunityObj.Name = 'Tes';
        opportunityObj.CloseDate = system.today();
        opportunityObj.Pricebook2id = pricebookObj.id;
        opportunityObj.Periode_UOM__c = 'Month'; 
        opportunityObj.BP_Payer__c = accountObj.id;
        opportunityObj.BP_Vat__c = accountObj.id;
        insert opportunityObj;

        //-- Create Opportunity Line Item 
        OpportunityLineItem oppLineItemObj = new OpportunityLineItem();
        oppLineItemObj.Quantity = 100;
        oppLineItemObj.pricebookentryid = pricebookEntryObj.id;
        oppLineItemObj.opportunityid = opportunityObj.id;
        oppLineItemObj.UnitPrice = 10000;
        insert oppLineItemObj;

        //-- Create SLOC
        SLOC__c slocObj = new SLOC__c();
        slocObj.Name = 'Tes';
        slocObj.Sloc_id__c = '123';
        insert slocObj;

        //-- Create Order
        Order orderObj = New Order();
        orderObj.AccountID = accountObj.id;
        orderObj.Name = 'Tes Order';
        orderObj.Status = 'Draft';
        
        orderObj.recordtypeid = system.label.RT_ORDER_PREPAID_NEW;
        orderObj.EffectiveDate = system.today();
        orderObj.opportunityID = opportunityObj.id;

        /*
        orderObj.SLOC__c = slocObj.id;
        orderObj.Nama_Account__c = 'Tes Account';
        orderObj.pic_name__c = 'Tes Contact';
        orderObj.OU__c = '1234';
        */

        /*
        orderObj.ID_COM_Number__c = 'A' ;
        orderObj.COMNAME__c = 'B' ;
        orderObj.COMTYPE__c = 'C' ;

        insert orderObj;

        //-- Create Order Line Item
        OrderItem orderLineItemObj = new OrderItem(OrderId = orderObj.id, PricebookEntryId = pricebookEntryObj.ID, Quantity = 1, UnitPrice = 300);
        insert orderLineItemObj;


        //-- Create MSISDN
        MSISDN__c msisdnObj1 = new MSISDN__c();
        msisdnObj1.Account__c = accountObj.id;
        msisdnObj1.Name = '6287799912301';
        msisdnObj1.MSISDN_No__c = '8962199912300001';
        msisdnObj1.Label__c = 'test label 01';
        msisdnObj1.ICCID__c = '8962199912300001';
        insert msisdnObj1;
        system.debug('=== msisdnObj1 : ' + msisdnObj1);
        
        MSISDN__c msisdnObj2= new MSISDN__c();
        msisdnObj2.Account__c = accountObj.id;
        msisdnObj2.Name = '62877999124444';
        msisdnObj2.MSISDN_No__c = '89621999123000444';
        msisdnObj2.Label__c = 'test label 02';
        msisdnObj2.ICCID__c = '8962199912300444';
        insert msisdnObj2;
        system.debug('=== msisdnObj2 : ' + msisdnObj2);


        //-- Create Order_MSISDN
        List <Order_MSISDN__c> orderMSISDNList = New List <Order_MSISDN__c>();
        Order_MSISDN__c orderMSISDNObj = new Order_MSISDN__c();
        orderMSISDNObj.Name = '6287799912301';
        orderMSISDNObj.ICCID__c = '8962199912300001';
        orderMSISDNObj.CL__c = 145000;
        orderMSISDNObj.Order__c= orderObj.id;
        orderMSISDNObj.MSISDN__c = msisdnObj1.id;
        orderMSISDNObj.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert orderMSISDNObj;
        orderMSISDNList.add(orderMSISDNObj);

        orderMSISDNObj = new Order_MSISDN__c();
        orderMSISDNObj.Name = '62877999124444';
        orderMSISDNObj.ICCID__c = '8962199912300444';
        orderMSISDNObj.CL__c = 145000;
        orderMSISDNObj.Order__c= orderObj.id;
        orderMSISDNObj.MSISDN__c = msisdnObj2.id;
        orderMSISDNObj.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert orderMSISDNObj;
        orderMSISDNList.add(orderMSISDNObj);

        */

        /*
        orderObj.Status = 'Tagging Process';
        update orderObj;
        */


        Test.startTest();

        //-- Create Schedule Process
        Scheduled_Process__c scheduleProcessObj = new Scheduled_Process__c();
        scheduleProcessObj.Parameter1__c = null;//orderObj.id;
        scheduleProcessObj.Parameter2__c = '{"data_limit" : 10, "group_no" : 1}';
        scheduleProcessObj.type__c = 'Callout GSMTagging';
        insert scheduleProcessObj;


        //-- Update Schedule Process
        scheduleProcessObj.is_Last_Schedule_of_Group__c = true;
        scheduleProcessObj.status__c = 'Failed';
        update scheduleProcessObj;

        scheduleProcessObj.status__c = 'Success';
        update scheduleProcessObj;



        test.stoptest();
    }

    static testMethod void unTaggingTest () {

        /*
        //-- GET user, Pricebook, and PricebookEntry
        User userObj = [SELECT ID From User WHERE Name='Nityo Triantono'];
        Pricebook2 pricebookObj = [SELECT id FROM Pricebook2 WHERE Name='GSM Activation']; 
        PricebookEntry pricebookEntryObj = [SELECT id FROM PricebookEntry WHERE Pricebook2id=:pricebookObj.id and product2.isactive=true  LIMIT 1];

        //-- Create Account 
        Account accountObj = New Account();
        accountObj.Name = 'tes';
        accountObj.BillingStreet = 'Jl. S Parman';
        accountObj.BillingCity = 'Jakarta';
        accountObj.BillingPostalCode = '14460';
        accountObj.BillingState = 'DKI Jakarta';
        accountObj.Organization_type__c = 'Head Office';
        accountObj.OU__c = '1234';
        insert accountObj;

        //-- Create Opportunity
        Opportunity opportunityObj = new Opportunity();
        opportunityObj.Accountid = accountObj.id;
        opportunityObj.StageName = 'Prospecting';
        opportunityObj.Name = 'Tes';
        opportunityObj.CloseDate = system.today();
        opportunityObj.Pricebook2id = pricebookObj.id;
        opportunityObj.Periode_UOM__c = 'Month'; 
        opportunityObj.BP_Payer__c = accountObj.id;
        opportunityObj.BP_Vat__c = accountObj.id;
        insert opportunityObj;

        //-- Create Opportunity Line Item 
        OpportunityLineItem oppLineItemObj = new OpportunityLineItem();
        oppLineItemObj.Quantity = 100;
        oppLineItemObj.pricebookentryid = pricebookEntryObj.id;
        oppLineItemObj.opportunityid = opportunityObj.id;
        oppLineItemObj.UnitPrice = 10000;
        insert oppLineItemObj;

        //-- Create SLOC
        SLOC__c slocObj = new SLOC__c();
        slocObj.Name = 'Tes';
        slocObj.Sloc_id__c = '123';
        insert slocObj;

        //-- Create Order
        Order orderObj = New Order();
        orderObj.AccountID = accountObj.id;
        orderObj.Name = 'Tes Order';
        orderObj.Status = 'Draft';
        
        orderObj.recordtypeid = system.label.RT_ORDER_PREPAID_NEW;
        orderObj.EffectiveDate = system.today();
        orderObj.opportunityID = opportunityObj.id;

        /*
        orderObj.SLOC__c = slocObj.id;
        orderObj.Nama_Account__c = 'Tes Account';
        orderObj.pic_name__c = 'Tes Contact';
        orderObj.OU__c = '1234';
        */

        /*
        orderObj.ID_COM_Number__c = 'A' ;
        orderObj.COMNAME__c = 'B' ;
        orderObj.COMTYPE__c = 'C' ;

        insert orderObj;

        //-- Create Order Line Item
        OrderItem orderLineItemObj = new OrderItem(OrderId = orderObj.id, PricebookEntryId = pricebookEntryObj.ID, Quantity = 1, UnitPrice = 300);
        insert orderLineItemObj;


        //-- Create MSISDN
        MSISDN__c msisdnObj1 = new MSISDN__c();
        msisdnObj1.Account__c = accountObj.id;
        msisdnObj1.Name = '6287799912301';
        msisdnObj1.MSISDN_No__c = '8962199912300001';
        msisdnObj1.Label__c = 'test label 01';
        msisdnObj1.ICCID__c = '8962199912300001';
        insert msisdnObj1;
        system.debug('=== msisdnObj1 : ' + msisdnObj1);
        
        MSISDN__c msisdnObj2= new MSISDN__c();
        msisdnObj2.Account__c = accountObj.id;
        msisdnObj2.Name = '62877999124444';
        msisdnObj2.MSISDN_No__c = '89621999123000444';
        msisdnObj2.Label__c = 'test label 02';
        msisdnObj2.ICCID__c = '8962199912300444';
        insert msisdnObj2;
        system.debug('=== msisdnObj2 : ' + msisdnObj2);


        //-- Create Order_MSISDN
        List <Order_MSISDN__c> orderMSISDNList = New List <Order_MSISDN__c>();
        Order_MSISDN__c orderMSISDNObj = new Order_MSISDN__c();
        orderMSISDNObj.Name = '6287799912301';
        orderMSISDNObj.ICCID__c = '8962199912300001';
        orderMSISDNObj.CL__c = 145000;
        orderMSISDNObj.Order__c= orderObj.id;
        orderMSISDNObj.MSISDN__c = msisdnObj1.id;
        orderMSISDNObj.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert orderMSISDNObj;
        orderMSISDNList.add(orderMSISDNObj);

        orderMSISDNObj = new Order_MSISDN__c();
        orderMSISDNObj.Name = '62877999124444';
        orderMSISDNObj.ICCID__c = '8962199912300444';
        orderMSISDNObj.CL__c = 145000;
        orderMSISDNObj.Order__c= orderObj.id;
        orderMSISDNObj.MSISDN__c = msisdnObj2.id;
        orderMSISDNObj.RecordTypeId = label.RT_ORDER_MSISDN_UnTagging_Order;
        insert orderMSISDNObj;
        orderMSISDNList.add(orderMSISDNObj);

        /*
        orderObj.Status = 'Tagging Process';
        update orderObj;
        */

        

        Test.startTest();

        //-- Create Schedule Process
        Scheduled_Process__c scheduleProcessObj = new Scheduled_Process__c();
        scheduleProcessObj.Parameter1__c = null; //orderObj.id;
        scheduleProcessObj.Parameter2__c = '{"data_limit" : 10, "group_no" : 1}';
        scheduleProcessObj.type__c = 'Callout GSMUnTagging';
        insert scheduleProcessObj;


        //-- Update Schedule Process
        scheduleProcessObj.is_Last_Schedule_of_Group__c = true;
        scheduleProcessObj.status__c = 'Failed';
        update scheduleProcessObj;

        scheduleProcessObj.status__c = 'Success';
        update scheduleProcessObj;



        test.stoptest();
    }    
}