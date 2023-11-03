//@isTest
@isTest(seealldata=true)
private class Test_Rest_Community {

    
    static testMethod void myUnitTest1() {
        Test.startTest();
        
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'OK',
                                                         '{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}',
                                                         null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_Exelcom_GetToken_EndPoint, getToken);
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //REST_Community.getAccessToken();
        REST_Community objRESTCommunity = new REST_Community();
        string responseStatus = objRESTCommunity.checkComm('COTS', null);

        REST_Community.checkCommFromScheduler('COTS', null, null);

        
        //REST_Community.checkComm ('COTS', null);
        REST_Community.createComm ('222', 'WEDHOUS', 'WEDHOUS', 'WEDHOUS', 1, 20);
        //REST_Community.taggingComm('6287777089908', 'GAD', 'GADGET', '1', 'T');
               
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='LA'];
        List<Account> lstAcc = [Select id, Name From Account Where recordtypeid =:RT.id];
        
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
        
        
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        MyOppty.AccountId = lstAcc[0].id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
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
        //MyOrder.LA__c = A.id;
        MyOrder.Min_Commitment__c = true;
        MyOrder.RecordTypeId = system.label.RT_ORDER_Prepaid_Tagging_New_IDCOM;
        MyOrder.Type = 'Postpaid Activation';
        MyOrder.Status = 'Draft';
        MyOrder.Pending_Reason__c = 'POSTpaid Activaton';
        MyOrder.Phone__c = '0812321313';
        /*MyOrder.NPWP_No__c = '21361732131';
        MyOrder.OU__c = 'test';
        MyOrder.Address_street__c = 'street';
        MyOrder.Address_State_Province__c = 'my province';
        MyOrder.Address_City__c = 'my city';
        MyOrder.Address_Postal_Code__c = '12313';
        MyOrder.Address_Country__c = 'countru';
        */
        //
        MyOrder.COMNAME__c = 'CAD';
        MyOrder.COMTYPE__c = 'GADGET';
        MyOrder.ID_COM_Number__c = 'CAD';   
        insert MyOrder;
        system.debug('=== MyOrder id nya '+MyOrder.id);
        system.debug('=== MyOrder Name nya '+MyOrder.Name);
        
        
        
        Product2 MyProduct = new Product2();
        MyProduct.Name = 'BIZ - Booster (Postpaid) - 1GB';
        MyProduct.ProductCode = 'POSTPAID';
        MyProduct.Family = 'GSM';
        MyProduct.Revenue_Type__c = 'Recurring';
        insert MyProduct;
        
        //Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='BIZ - Booster (Postpaid) - 1GB'];
        //PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id LIMIT 1]; 
        /*Product2 PrdOrder = [SELECT id FROM Product2 WHERE id=:myProduct.id LIMIT 1];
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Product2Id=:PrdOrder.id LIMIT 1];
        
        OrderItem OrdItem = New OrderItem();
        OrdItem.OrderId = MyOrder.id;
        OrdItem.PricebookEntryId=  PBE.id;
        OrdItem.Quantity = 3;
        OrdItem.UnitPrice = 12000;
        insert OrdItem; 
        system.debug('=== OrdItem id nya'+OrdItem.id);
        */
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
        
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'OK',
                                                         '{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}',
                                                         null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_Exelcom_GetToken_EndPoint, getToken);
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //REST_Community.getAccessToken();
        //REST_Community.checkComm ('WEDHOUS', null);
        //REST_Community.createComm ('WEDHOUS', 'WEDHOUS', 'WEDHOUS', 1, 20);
        //REST_Community.taggingComm(jsonString, 'a0a5D000006W7tDQAS');
        Scheduled_Process__c  sp5 = new Scheduled_Process__c ();
        sp5.type__c = 'Callout GSMTagging';
        sp5.status__c = 'Waiting';
        sp5.parameter2__c='{"group_no":1, "data_limit":20}';
        sp5.parameter1__c=myorder.id;
        sp5.request_id__c='asasa';
        insert SP5;
        Scheduled_Process__c  sp6 = new Scheduled_Process__c ();
        sp6.type__c = 'Callout GSMTaggingCheck';
        sp6.status__c = 'Waiting';
        sp6.parameter2__c='{"group_no":1, "data_limit":20}';
        sp6.parameter1__c=myorder.id;
        sp6.request_id__c='asasa';
        insert SP6;
        REST_Community.requestTaggingByGroup(orderID,1,2,SP5.id); 
        REST_Community.requestTaggingCheckByGroup(orderID,1,2,SP6.id);
               
        Test.stopTest();
    }
    
}