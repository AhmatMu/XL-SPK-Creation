@isTest(seealldata=true)
private class Test_OrderMSISDN {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account A=New Account();
        A.Name='tes';
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Type='Competitor';
        //A.Account_Type__c ='BP'
        A.Organization_type__c='Head Office';
        insert A;
        
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM'];
        
        
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        //MyOppty.AccountId = lstAcc[0].id;
        MyOppty.AccountId = A.id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
        MyOppty.RecordTypeId = recTypeOppty.id;
        insert MyOppty;
        system.debug('=== MyOppty id nya'+MyOppty.id);
        //RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - New LA'];
        
       // List<Order> lstOrder = [Select id, Name,Status From Order Where OrderNumber = '00000198'];
       // system.debug('=== lstOrder size nya '+lstOrder.size());
        
        Order MyOrder = New Order();
        MyOrder.AccountId = A.id; 
        MyOrder.OpportunityId = MyOppty.id;
        MyOrder.EffectiveDate = system.today();
        MyOrder.Name = 'POSTpaid Activation - New LA';
        MyOrder.Service_Type__c = 'New Number';
        //MyOrder.LA__c = A.id;
        MyOrder.Min_Commitment__c = true;
        MyOrder.RecordTypeId = system.label.RT_ORDER_Prepaid_Tagging_New_IDCOM;
        MyOrder.Type = 'Postpaid Activation';
        MyOrder.Status = 'Draft';
        MyOrder.Pending_Reason__c = 'POSTpaid Activaton';
        MyOrder.Phone__c = '0812321313';
        
        //
        MyOrder.COMNAME__c = 'CAD';
        MyOrder.COMTYPE__c = 'GADGET';
        MyOrder.ID_COM_Number__c = 'CAD';   
        insert MyOrder;
        
        
        Product2 MyProduct = new Product2();
        MyProduct.Name = 'BIZ - Booster (Postpaid) - 1GB';
        MyProduct.ProductCode = 'POSTPAID';
        MyProduct.Family = 'GSM';
        MyProduct.Revenue_Type__c = 'Recurring';
        insert MyProduct;
        
        MSISDN__c MyMsisdn = new MSISDN__c();
        MyMsisdn.Account__c = A.id;
        MyMsisdn.Name = '6287799912301';
        MyMsisdn.MSISDN_No__c = '8962199912300001';
        MyMsisdn.Label__c = 'test label';
        MyMsisdn.ICCID__c = '8962199912300001';
        //MyMsisdn.Status__c = '';
        //MyMsisdn.Dealer_Account__c = lstAcc[0].id;
        insert MyMsisdn;
        system.debug('=== MyMsisdn id nya'+MyMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn = new Order_MSISDN__c();
        OrdMsisdn.Name = '6287799900001';
        OrdMsisdn.ICCID__c = '896219990000001';
        OrdMsisdn.CL__c = 145000;
        OrdMsisdn.Order__c= MyOrder.id;
        OrdMsisdn.MSISDN__c = MyMsisdn.id;
        OrdMsisdn.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert OrdMsisdn;
        system.debug('=== OrdMsisdn id nya'+OrdMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn1 = new Order_MSISDN__c();
        OrdMsisdn1.Name = '6287799900001';
        OrdMsisdn1.ICCID__c = '896219990000001';
        OrdMsisdn1.CL__c = 145000;
        OrdMsisdn1.Order__c= MyOrder.id;
        OrdMsisdn1.MSISDN__c = MyMsisdn.id;
        OrdMsisdn1.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert OrdMsisdn1;
        
        
        
        
        test.startTest();
        //string OrdId = '8017F000006q283QAA';
        OrderMSISDN.CheckOrderMSISDNStatus(MyOrder.id);
        test.stopTest();
    }
}