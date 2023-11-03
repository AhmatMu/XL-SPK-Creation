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
private class test_REST_SIMCardOrder {

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
      	  user u=[SELECT id from user WHERE Name='Yopi Apriyana' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='GSM (Simcard Order)' LIMIT 1];
        
         Account A=[SELECT id from Account where BP_number__c='720830' LIMIT 1];
        Product2 P=[SELECT id FROM Product2 WHERE Name='SP0KDATALTEOP-BDG' AND FamilY='GSM' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name ='GSM-Material General'];
      
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
        	
        	O.Accountid=A.id;
        	O.RecordTypeid=rt.id;
        	O.StageName='Submit Order';
        	O.Name='Tes';
        	O.CloseDate=system.today().adddays(10);
        	O.Pricebook2id=PB.id;
        	O.SIMCard_Order_Payment_Type__c='FREE';
        	O.Cost_Center__c='500';
        	O.GL_Account__c='Netty';
        	O.Service_Group__c='GSM';
        	O.Product_Interest__c='GSM';
        	insert O;
        		OpportunityLineItem OLI=new OpportunityLineItem();
        	OLI.Product2id=P.id;
        	OLI.OpportunityID=O.id;
        	OLI.revenue_type__c='One Time';
        	PricebookEntry PBE=[SELECT id from PricebookEntry WHERE Product2id=:P.id AND Pricebook2id=:pB.ID];
        	OLI.PricebookEntryId=PBE.id;
        	OLI.UnitPrice=10000000;
        	OLI.Quantity=1;
        	insert OLI;
        }
        
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
			cDe.LinkedEntityId = O.Id; // you can use objectId,GroupId etc
			cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
			//cDe.Visibility = 'InternalUsers';
			insert cDe;
			
			
			 Opportunity_Attachment__c oa = new  Opportunity_Attachment__c();
             oa.ContentDocumentLink_ID__c = cDe.id;
             oa.ContentVersion_ID__c = ''; //todo: find this value with query
             oa.EasyOps_ID__c = '';
             oa.Opportunity__c  = cDe.LinkedEntityId;
             oa.ContentDocumentId__c = cDe.ContentDocumentId;
             oa.Status__c = 'Sent Failed';
			
				insert oa;
			// .end of add attachments		
        
        
        
        O.StageName='Order Fulfillment';
        update O;
      	REST_SIMCardOrder.addSimCardOrder(O.id);
      	
      	Opportunity OP=[SELECT Opportunity_ID__c FROM Opportunity LIMIT 1];
      	
      	//Opportunity OP=O;
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/simcardorders';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
   		
   		     
        //-- READY FOR PICKUP 
        //restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardorder","request_id":"650000000146"},"body":{"data":{"opportunity_no":"'+Op.Opportunity_ID__c+'","stage":"Ready for Pickup","msisdn_list":[{"label":"","iccid":"8962115331282820822","msisdn":"6287885020103"},{"label":"","iccid":"8962115331282820830","msisdn":"6287885020104"},{"label":"","iccid":"8962115331282820848","msisdn":"6287885020105"},{"label":"","iccid":"8962115331282820855","msisdn":"6287885020106"},{"label":"","iccid":"8962115331282820863","msisdn":"6287885020107"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020108"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020109"},{"label":"","iccid":"8962115331282820707","msisdn":"6287885010091"},{"label":"","iccid":"8962115331282820699","msisdn":"6287885010090"},{"label":"","iccid":"8962115331282820715","msisdn":"6287885010092"}]}}}');
        restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardorder","request_id":"650000000146"},"body":{"data":{"opportunity_no":"'+Op.Opportunity_ID__c+'","stage":"Ready for Pickup","msisdn_list":[{"label":"","iccid":"8962115331282820822","msisdn":"6287885020103"},{"label":"","iccid":"8962115331282820830","msisdn":"6287885020104"},{"label":"","iccid":"8962115331282820848","msisdn":"6287885020105"},{"label":"","iccid":"8962115331282820855","msisdn":"6287885020106"},{"label":"","iccid":"8962115331282820863","msisdn":"6287885020107"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020108"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020109"},{"label":"","iccid":"8962115331282820707","msisdn":"6287885010091"},{"label":"","iccid":"8962115331282820699","msisdn":"6287885010090"},{"label":"","iccid":"8962115331282820715","msisdn":"6287885010092"}]}}}');
        RestContext.request = restRequest;
        REST_SIMCardOrder.doput();
        
        
        //-- CLOSED WON 
        //restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardorder","request_id":"650000000146"},"body":{"data":{"opportunity_no":"'+Op.Opportunity_ID__c+'","stage":"Ready for Pickup","msisdn_list":[{"label":"","iccid":"8962115331282820822","msisdn":"6287885020103"},{"label":"","iccid":"8962115331282820830","msisdn":"6287885020104"},{"label":"","iccid":"8962115331282820848","msisdn":"6287885020105"},{"label":"","iccid":"8962115331282820855","msisdn":"6287885020106"},{"label":"","iccid":"8962115331282820863","msisdn":"6287885020107"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020108"},{"label":"","iccid":"8962115331282820871","msisdn":"6287885020109"},{"label":"","iccid":"8962115331282820707","msisdn":"6287885010091"},{"label":"","iccid":"8962115331282820699","msisdn":"6287885010090"},{"label":"","iccid":"8962115331282820715","msisdn":"6287885010092"}]}}}');
        restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardorder","request_id":"657878986879"},"body":{"data":{"opportunity_no":"'+Op.Opportunity_ID__c+'","stage":"Closed Won","notes":"keterangan ...","pic_pickup":"Faris trala"}}}');
        RestContext.request = restRequest;
        REST_SIMCardOrder.doput();
        REST_SIMCardOrder.test();
        
    }
}