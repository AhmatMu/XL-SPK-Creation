@isTest(seealldata=true)
private class Test_OrderController {

    static testMethod void myUnitTestActivation() {
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='LA'];
        List<Account> lstAcc = [Select id, Name From Account Where recordtypeid =:RT.id and organization_type__c = 'Head Office'];
        
        /*Account A=New Account();
        A.Name='tes'; 
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Type='Competitor';
       
        A.Organization_type__c='Head Office';
        insert A;
        */
        system.debug('=== account id nya'+lstAcc[0].id);
        string A = lstAcc[0].id;
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM'];
        
        Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        MyOppty.AccountId = lstAcc[0].id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
        MyOppty.Pricebook2id=PB.id;
        MyOppty.RecordTypeId = recTypeOppty.id;
        insert MyOppty;
        system.debug('=== MyOppty id nya'+MyOppty.id);
        //RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - New LA'];
        
       // List<Order> lstOrder = [Select id, Name,Status From Order Where OrderNumber = '00000198'];
       // system.debug('=== lstOrder size nya '+lstOrder.size());
        
        Order MyOrder = New Order();
        MyOrder.AccountId = lstAcc[0].id;
        MyOrder.OpportunityId = MyOppty.id;
        MyOrder.EffectiveDate = system.today();
        MyOrder.Name = 'POSTpaid Activation - New LA';
        MyOrder.Service_Type__c = 'New Number';
        myorder.Pricebook2id=PB.id;
        //MyOrder.LA__c = A.id;
        MyOrder.Min_Commitment__c = true;
        MyOrder.RecordTypeId = system.label.RT_ORDER_Prepaid_Tagging_New_IDCOM;
        MyOrder.Type = 'Postpaid Activation';
        MyOrder.Status = 'Draft';
        MyOrder.Pending_Reason__c = 'POSTpaid Activaton';
        MyOrder.Phone__c = '0812321313';
        MyOrder.NPWP_No__c = '21361732131';
        MyOrder.OU__c = 'test';
        MyOrder.Address_street__c = 'street';
        MyOrder.Address_State_Province__c = 'my province';
        MyOrder.Address_City__c = 'my city';
        MyOrder.Address_Postal_Code__c = '12313';
        MyOrder.Address_Country__c = 'countru';
        MyOrder.PIC_Name__c='ATest';
        myorder.PIC_Date_of_Birth__c=system.today().addyears(-18);
        myorder.Mobile_Phone__c='998129102';
        myorder.PIC_Email__c='tes@saasten.com';
        MyOrder.COMNAME__c = 'CAD';
        MyOrder.COMTYPE__c = 'GADGET';
        MyOrder.ID_COM_Number__c = 'CAD';   
        insert MyOrder;
        system.debug('=== MyOrder id nya '+MyOrder.id);
        system.debug('=== MyOrder Name nya '+MyOrder.Name);
        system.debug('=== order.opp :'+ MyOrder.OpportunityId );
        
        
        /*
        Product2 MyProduct = new Product2();
        MyProduct.Name = 'BIZ - Booster (Postpaid) - 1GB';
        MyProduct.ProductCode = 'POSTPAID';
        MyProduct.Family = 'GSM';
        MyProduct.Revenue_Type__c = 'Recurring';
        insert MyProduct;
        */

        
       
        Product2 PrdOrder = [SELECT id , ao_related__r.name , price_plan_related__r.name FROM Product2 WHERE 
            ao_related__r.name = 'AO_Post_M2M_50MB_Tier1_25K_NonAMR'
            AND price_plan_related__r.name = 'FWT OFFER'
            LIMIT 1];
        system.debug ('== PrdOrder : ' +  PrdOrder);
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Product2Id=:PrdOrder.id and pricebook2id=:PB.id LIMIT 1];
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.Quantity=100;
        OLI.pricebookentryid=PBE.id;
        OLI.opportunityid=MyOppty.id;
        OLI.UnitPrice=10000;
        insert OLI;

        OrderItem OrdItem = New OrderItem();
        OrdItem.OrderId = MyOrder.id;
        OrdItem.PricebookEntryId=  PBE.id;
        OrdItem.Quantity = oli.quantity;
        OrdItem.UnitPrice = 10000;
        insert OrdItem; 
        system.debug('=== OrdItem id nya'+OrdItem.id);
        
        MSISDN__c MyMsisdn = new MSISDN__c();
        MyMsisdn.Account__c = lstAcc[0].id;
        MyMsisdn.Name = '6287799912301';
        MyMsisdn.MSISDN_No__c = '8962199912300001';
        MyMsisdn.Label__c = 'test label';
        MyMsisdn.ICCID__c = '8962199912300001';
        MyMsisdn.Order_SIM_Card_Related__c = MyOrder.Id;
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

        //OrdMsisdn.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert OrdMsisdn;
        system.debug('=== OrdMsisdn id nya'+OrdMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn1 = new Order_MSISDN__c();
        OrdMsisdn1.Name = '6287799900001';
        OrdMsisdn1.ICCID__c = '896219990000001';
        OrdMsisdn1.CL__c = 145000;
        OrdMsisdn1.Order__c= MyOrder.id;
        OrdMsisdn1.MSISDN__c = MyMsisdn.id;
        //OrdMsisdn1.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        
        OrdMsisdn1.ao__c = 'AO_Post_M2M_50MB_Tier1_25K_NonAMR';
        OrdMsisdn1.priceplan__c = 'FWT OFFER';
        OrdMsisdn1.status__c = 'Success';
        insert OrdMsisdn1;
        
        string orderID =MyOrder.id;
        
        Test.startTest();
        ordercontroller OC=new OrderController();
        myorder.Status='Ready for Pickup';
        update myorder;
        OC.updateonSIMCARDORDER(myorder);

        myorder.Status='Activation in Review';
        update myorder;
        OC.updateOnActivationOrder(myorder);
        
        myorder.Status='Activation in Review';
        update myorder;
        OC.updateOnTaggingOrder(myorder);
        
        myorder.Status='Complete';
        update myorder;
        OrdMsisdn1.status__c='Success';
        update OrdMsisdn1;
        OC.updateOnActivationOrder(myorder);
        
        OC.deleteOnOrderMSISDN(myorder,OrdMsisdn1);
        test.stoptest();
    }


    static testMethod void myUnitTestTagging() {
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='LA'];
        List<Account> lstAcc = [Select id, Name From Account Where recordtypeid =:RT.id and organization_type__c = 'Head Office'];
        
        /*Account A=New Account();
        A.Name='tes'; 
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Type='Competitor';
       
        A.Organization_type__c='Head Office';
        insert A;
        */
        system.debug('=== account id nya'+lstAcc[0].id);
        string A = lstAcc[0].id;
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM'];
        
        Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        MyOppty.AccountId = lstAcc[0].id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
        MyOppty.Pricebook2id=PB.id;
        MyOppty.RecordTypeId = recTypeOppty.id;
        insert MyOppty;
        system.debug('=== MyOppty id nya'+MyOppty.id);
        //RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - New LA'];
        
       // List<Order> lstOrder = [Select id, Name,Status From Order Where OrderNumber = '00000198'];
       // system.debug('=== lstOrder size nya '+lstOrder.size());
        
        Order MyOrder = New Order();
        MyOrder.AccountId = lstAcc[0].id;
        MyOrder.OpportunityId = MyOppty.id;
        MyOrder.EffectiveDate = system.today();
        MyOrder.Name = 'POSTpaid Activation - New LA';
        MyOrder.Service_Type__c = 'New Number';
        myorder.Pricebook2id=PB.id;
        //MyOrder.LA__c = A.id;
        MyOrder.Min_Commitment__c = true;
        MyOrder.RecordTypeId = system.label.RT_ORDER_Prepaid_Tagging_New_IDCOM;
        MyOrder.Type = 'Postpaid Activation';
        MyOrder.Status = 'Draft';
        MyOrder.Pending_Reason__c = 'POSTpaid Activaton';
        MyOrder.Phone__c = '0812321313';
        MyOrder.NPWP_No__c = '21361732131';
        MyOrder.OU__c = 'test';
        MyOrder.Address_street__c = 'street';
        MyOrder.Address_State_Province__c = 'my province';
        MyOrder.Address_City__c = 'my city';
        MyOrder.Address_Postal_Code__c = '12313';
        MyOrder.Address_Country__c = 'countru';
        MyOrder.PIC_Name__c='ATest';
        myorder.PIC_Date_of_Birth__c=system.today().addyears(-18);
        myorder.Mobile_Phone__c='998129102';
        myorder.PIC_Email__c='tes@saasten.com';
        MyOrder.COMNAME__c = 'CAD';
        MyOrder.COMTYPE__c = 'GADGET';
        MyOrder.ID_COM_Number__c = 'CAD';   
        insert MyOrder;
        system.debug('=== MyOrder id nya '+MyOrder.id);
        system.debug('=== MyOrder Name nya '+MyOrder.Name);
        system.debug('=== order.opp :'+ MyOrder.OpportunityId );
        
        
        /*
        Product2 MyProduct = new Product2();
        MyProduct.Name = 'BIZ - Booster (Postpaid) - 1GB';
        MyProduct.ProductCode = 'POSTPAID';
        MyProduct.Family = 'GSM';
        MyProduct.Revenue_Type__c = 'Recurring';
        insert MyProduct;
        */

        
       
        Product2 PrdOrder = [SELECT id FROM Product2 WHERE Name='BIZ - Booster (Postpaid) - 1GB' LIMIT 1];
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Product2Id=:PrdOrder.id and pricebook2id=:PB.id LIMIT 1];
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.Quantity=100;
        OLI.pricebookentryid=PBE.id;
        OLI.opportunityid=MyOppty.id;
        OLI.UnitPrice=10000;
        insert OLI;

        OrderItem OrdItem = New OrderItem();
        OrdItem.OrderId = MyOrder.id;
        OrdItem.PricebookEntryId=  PBE.id;
        OrdItem.Quantity = oli.quantity;
        OrdItem.UnitPrice = 10000;
        insert OrdItem; 
        system.debug('=== OrdItem id nya'+OrdItem.id);
        
        MSISDN__c MyMsisdn = new MSISDN__c();
        MyMsisdn.Account__c = lstAcc[0].id;
        MyMsisdn.Name = '6287799912301';
        MyMsisdn.MSISDN_No__c = '8962199912300001';
        MyMsisdn.Label__c = 'test label';
        MyMsisdn.ICCID__c = '8962199912300001';
        MyMsisdn.Order_SIM_Card_Related__c = MyOrder.Id;
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
        
        string orderID =MyOrder.id;
        
        Test.startTest();
        ordercontroller OC=new OrderController();
        myorder.Status='Ready for Pickup';
        update myorder;
        OC.updateonSIMCARDORDER(myorder);
        myorder.Status='Activation in Review';
        update myorder;
        OC.updateOnActivationOrder(myorder);
        myorder.Status='Tagging Process';
        update myorder;
        OC.updateOnTaggingOrder(myorder);
        myorder.Status='Complete';
        update myorder;
        OrdMsisdn1.status__c='Success';
        update OrdMsisdn1;
        OC.updateOnTaggingOrder(myorder);
        //OC.updateOnActivationOrder(myorder);
        OC.deleteOnOrderMSISDN(myorder,OrdMsisdn1);
        test.stoptest();
    }
    
    static testMethod void myUnitTestUntagging() {
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='LA'];
        List<Account> lstAcc = [Select id, Name From Account Where recordtypeid =:RT.id and organization_type__c = 'Head Office'];
        
        /*Account A=New Account();
        A.Name='tes'; 
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Type='Competitor';
       
        A.Organization_type__c='Head Office';
        insert A;
        */
        system.debug('=== account id nya'+lstAcc[0].id);
        string A = lstAcc[0].id;
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM'];
        
        Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        MyOppty.AccountId = lstAcc[0].id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
        MyOppty.Pricebook2id=PB.id;
        MyOppty.RecordTypeId = recTypeOppty.id;
        insert MyOppty;
        system.debug('=== MyOppty id nya'+MyOppty.id);
        //RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - New LA'];
        
       // List<Order> lstOrder = [Select id, Name,Status From Order Where OrderNumber = '00000198'];
       // system.debug('=== lstOrder size nya '+lstOrder.size());
        
        Order MyOrder = New Order();
        MyOrder.AccountId = lstAcc[0].id;
        MyOrder.OpportunityId = MyOppty.id;
        MyOrder.EffectiveDate = system.today();
        MyOrder.Name = 'POSTpaid Activation - New LA';
        MyOrder.Service_Type__c = 'New Number';
        myorder.Pricebook2id=PB.id;
        //MyOrder.LA__c = A.id;
        MyOrder.Min_Commitment__c = true;
        MyOrder.RecordTypeId = system.label.RT_ORDER_PREPAID_UNTAGGING_EXISTING;
        MyOrder.Type = 'Postpaid Activation';
        MyOrder.Status = 'Draft';
        MyOrder.Pending_Reason__c = 'POSTpaid Activaton';
        MyOrder.Phone__c = '0812321313';
        MyOrder.NPWP_No__c = '21361732131';
        MyOrder.OU__c = 'test';
        MyOrder.Address_street__c = 'street';
        MyOrder.Address_State_Province__c = 'my province';
        MyOrder.Address_City__c = 'my city';
        MyOrder.Address_Postal_Code__c = '12313';
        MyOrder.Address_Country__c = 'countru';
        MyOrder.PIC_Name__c='ATest';
        myorder.PIC_Date_of_Birth__c=system.today().addyears(-18);
        myorder.Mobile_Phone__c='998129102';
        myorder.PIC_Email__c='tes@saasten.com';
        MyOrder.COMNAME__c = 'CAD';
        MyOrder.COMTYPE__c = 'GADGET';
        MyOrder.ID_COM_Number__c = 'CAD';   
        insert MyOrder;
        system.debug('=== MyOrder id nya '+MyOrder.id);
        system.debug('=== MyOrder Name nya '+MyOrder.Name);
        system.debug('=== MyOrder.OpportunityId ::'+ MyOrder.OpportunityId);
        
        
        /*
        Product2 MyProduct = new Product2();
        MyProduct.Name = 'BIZ - Booster (Postpaid) - 1GB';
        MyProduct.ProductCode = 'POSTPAID';
        MyProduct.Family = 'GSM';
        MyProduct.Revenue_Type__c = 'Recurring';
        insert MyProduct;
        */

        
       
        Product2 PrdOrder = [SELECT id FROM Product2 WHERE Name='BIZ - Booster (Postpaid) - 1GB' LIMIT 1];
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Product2Id=:PrdOrder.id and pricebook2id=:PB.id LIMIT 1];
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.Quantity=100;
        OLI.pricebookentryid=PBE.id;
        OLI.opportunityid=MyOppty.id;
        OLI.UnitPrice=10000;
        insert OLI;

        OrderItem OrdItem = New OrderItem();
        OrdItem.OrderId = MyOrder.id;
        OrdItem.PricebookEntryId=  PBE.id;
        OrdItem.Quantity = oli.Quantity;
        OrdItem.UnitPrice = 10000;
        insert OrdItem; 
        system.debug('=== OrdItem id nya'+OrdItem.id);
        system.debug('=== OrdItem.Quantity :' +  OrdItem.Quantity);
        
        MSISDN__c MyMsisdn = new MSISDN__c();
        MyMsisdn.Account__c = lstAcc[0].id;
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
        OrdMsisdn.RecordTypeId = label.RT_ORDER_MSISDN_Untagging_Order;
        insert OrdMsisdn;
        system.debug('=== OrdMsisdn id nya'+OrdMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn1 = new Order_MSISDN__c();
        OrdMsisdn1.Name = '6287799900001';
        OrdMsisdn1.ICCID__c = '896219990000001';
        OrdMsisdn1.CL__c = 145000;
        OrdMsisdn1.Order__c= MyOrder.id;
        OrdMsisdn1.MSISDN__c = MyMsisdn.id;
        OrdMsisdn1.RecordTypeId = label.RT_ORDER_MSISDN_Untagging_Order;
        insert OrdMsisdn1;
        
        string orderID =MyOrder.id;
        
        Test.startTest();
        ordercontroller OC=new OrderController();
        myorder.Status='Ready for Pickup';
        update myorder;
        OC.updateonSIMCARDORDER(myorder);
        myorder.Status='Activation in Review';
        update myorder;
        OC.updateOnActivationOrder(myorder);
        myorder.Status='Untagging Process';
        update myorder;
        OC.updateOnUnTaggingOrder(myorder);
        myorder.Status='Complete';
        update myorder;
        OrdMsisdn1.status__c='Success';
        update OrdMsisdn1;
        OC.updateOnUnTaggingOrder(myorder);
        //OC.updateOnActivationOrder(myorder);
        OC.deleteOnOrderMSISDN(myorder,OrdMsisdn1);
        test.stoptest();

    }
     
}