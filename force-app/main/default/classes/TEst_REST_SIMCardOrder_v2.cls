@isTest(seealldata=true)
public with sharing class TEst_REST_SIMCardOrder_v2 {
   static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
         
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock CreateSalesOrder = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"addsalesorder","request_id":"58722c67-aec5-3f62-8605-28bc376b2d7a"},"body":{"data":{"success":true,"message":"Record has been saved","so_id":"38","sod_id":["103"],"sf_id":[]}}}',
                                                   null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_SimCardOrder_Endpoint, CreateSalesOrder);
        
        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        
        User U=[SELECT ID From User WHERE Name='Nityo Triantono'];
        Account acc = [select id from account where organization_type__c ='Head Office' limit 1];
        /*
        Account A=New Account();
        A.Name='tes';
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Organization_type__c='Head Office';
        insert A;*/
        
        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        insert S;
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM (Activation)'];
        
        Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id LIMIT 1];
        //Product2 PrdOrder = [SELECT id FROM Product2 WHERE name='z-dummy-product1' LIMIT 1];
        //PricebookEntry PBE=[SELECT id, product2id FROM PricebookEntry WHERE Pricebook2id=:PB.id and product2.name= 'z-dummy-product1' LIMIT 1];      	
        
        RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - New LA'];

        Opportunity Op = New Opportunity();
        Op.Name = 'Test GSM Activation';
        Op.Project_Group__c = 'Test Activation';
        Op.CloseDate = system.today();
        Op.AccountId = acc.id;
        Op.StageName = 'Prospecting';
        Op.Amount = 2250000;
        Op.Pricebook2id=PB.id;
    
        insert Op;

        OpportunityLineItem OLI=new OpportunityLineItem();
         OLI.Quantity=100;
         OLI.pricebookentryid=PBE.id;
         OLI.opportunityid=Op.id;
         OLI.UnitPrice=10000;
         insert OLI;


        Order Ord=New Order();
		Ord.AccountID=acc.id;
		Ord.opportunityId = Op.id;
		Ord.Status='Draft';
		Ord.SLOC__c=S.id;
		Ord.EffectiveDate=system.today();
		Ord.pricebook2id = pb.id;
		Ord.RecordTypeId = recTypeOrder.id;
        insert Ord;

        
        
        
        system.debug ('===== pb.id : ' + pb.id); 
        system.debug ('===== PBE.id : ' + PBE.id);
        //system.debug ('===== PBE.product2id : ' + PBE.product2id);
        

        //OrderItem oi          = new OrderItem(OrderId = O.id, PricebookEntryId = pbe.ID, Quantity = 1, UnitPrice = 300);
        //insert oi;
        
        /*
        OrderItem oi = new OrderItem(OrderId = '8015D000000TRX3QAO', PricebookEntryId = PBE.id, Quantity = 1, UnitPrice = 300);
        insert oi;
        
        
        OrderItem oi = new OrderItem(OrderId = '8015D000000TRX3QAO', Product2Id = '01t5D000002hYTQQA2', 
                                    PricebookEntryId = '01u5D000006CXxOQAW', Quantity = 1, UnitPrice = 300);
        insert oi;*/
        
        
        
        
        	// add attachments:
            String yourFiles = 'Lets assume this is your binary string of the files';
 
			ContentVersion conVer = new ContentVersion();
			conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
			conVer.PathOnClient = 'ionicLogo.png'; // The files name, extension is very important here which will help the file in preview.
			conVer.Title = 'Proposal '; // Display name of the files
			conVer.VersionData = EncodingUtil.base64Decode(yourFiles); // converting your binary string to Blog
			insert conVer;
			
			
			// First get the content document Id from ContentVersion
			Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
			 
			//Create ContentDocumentLink
			ContentDocumentLink cDe = new ContentDocumentLink();
			cDe.ContentDocumentId = conDoc;
			cDe.LinkedEntityId = Ord.Id; // you can use objectId,GroupId etc
			cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
			//cDe.Visibility = 'InternalUsers';
			insert cDe;
			
			/*
			 Opportunity_Attachment__c oa = new  Opportunity_Attachment__c();
             oa.ContentDocumentLink_ID__c = cDe.id;
             oa.ContentVersion_ID__c = ''; //todo: find this value with query
             oa.EasyOps_ID__c = '';
             oa.Opportunity__c  = cDe.LinkedEntityId;
             oa.ContentDocumentId__c = cDe.ContentDocumentId;
             oa.Status__c = 'Sent Failed';
			
			insert oa;
			*/
			
			// .end of add attachments
        
        REST_SIMCardOrder_v2.addSimCardOrder(ord.id); 
        
        
         
		//=================================================================================
		//-- doPut
		//---------------------------------------------------------------------------------
		//Order orderRec=[SELECT order_id__c FROM order LIMIT 1];
      	Order orderRec = [select id , order_id__c from Order where id =:ord.id];
      	system.debug('=== orderRec.order_id__c : ' + orderRec.order_id__c);
      	
      	//
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/simcardorders';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
   		
   		     
        //-- READY FOR PICKUP 
        //restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardorder","request_id":"650000000146"},"body":{"data":{"opportunity_no":"'+Op.Opportunity_ID__c+'","stage":"Ready for Pickup","msisdn_list":[{"label":"","iccid":"8962115331282820822","msisdn":"6287885020103"},{"label":"","iccid":"8962115331282820830","msisdn":"6287885020104"},{"label":"","iccid":"8962115331282820848","msisdn":"6287885020105"},{"label":"","iccid":"8962115331282820855","msisdn":"6287885020106"},{"label":"","iccid":"8962115331282820863","msisdn":"6287885020107"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020108"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020109"},{"label":"","iccid":"8962115331282820707","msisdn":"6287885010091"},{"label":"","iccid":"8962115331282820699","msisdn":"6287885010090"},{"label":"","iccid":"8962115331282820715","msisdn":"6287885010092"}]}}}');
        restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardorder","request_id":"650000000146"},"body":{"data":{"order_no":"'+orderRec.order_id__c +'","stage":"Ready for Pickup","msisdn_list":[{"label":"","iccid":"8962115331282820822","msisdn":"6287885020103"},{"label":"","iccid":"8962115331282820830","msisdn":"6287885020104"},{"label":"","iccid":"8962115331282820848","msisdn":"6287885020105"},{"label":"","iccid":"8962115331282820855","msisdn":"6287885020106"},{"label":"","iccid":"8962115331282820863","msisdn":"6287885020107"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020108"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020109"},{"label":"","iccid":"8962115331282820707","msisdn":"6287885010091"},{"label":"","iccid":"8962115331282820699","msisdn":"6287885010090"},{"label":"","iccid":"8962115331282820715","msisdn":"6287885010092"}]}}}');
        RestContext.request = restRequest;
        REST_SIMCardOrder_v2.doput();
        
        
        //-- COMPLETE
        //restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardorder","request_id":"650000000146"},"body":{"data":{"opportunity_no":"'+Op.Opportunity_ID__c+'","stage":"Ready for Pickup","msisdn_list":[{"label":"","iccid":"8962115331282820822","msisdn":"6287885020103"},{"label":"","iccid":"8962115331282820830","msisdn":"6287885020104"},{"label":"","iccid":"8962115331282820848","msisdn":"6287885020105"},{"label":"","iccid":"8962115331282820855","msisdn":"6287885020106"},{"label":"","iccid":"8962115331282820863","msisdn":"6287885020107"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020108"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020109"},{"label":"","iccid":"8962115331282820707","msisdn":"6287885010091"},{"label":"","iccid":"8962115331282820699","msisdn":"6287885010090"},{"label":"","iccid":"8962115331282820715","msisdn":"6287885010092"}]}}}');
        restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardorder","request_id":"657878986879"},"body":{"data":{"order_no":"'+orderRec.order_id__c+'","stage":"Complete","notes":"keterangan ...","pic_pickup":"Faris trala"}}}');
        RestContext.request = restRequest;
        REST_SIMCardOrder_v2.doput();
		
        test.stoptest();
    }   
    
    
}