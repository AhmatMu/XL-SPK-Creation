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
private class test_REST_SIMCARDRequest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
         Test.startTest();
          SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock SCR = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"addsalesforecast","request_id":"01521beb-7c7f-bfa6-32a2-bc5b2875d469"},"body":{"data":{"success":true,"message":"Record has been saved.","sf_id":"179","sfd_id":["1479"]}}}',
                                                   null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_SalesForecast_Endpoint, SCR);
        
        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        SimCard_Production_Request_HEader__c SCPRH=new  SimCard_Production_Request_HEader__c();
        SCPRH.status__c='Draft';
        SCPRH.ownerid=userinfo.getuserid();
        insert SCPRH;
        Simcard_Production_Request_Detail__c SCPRD=new Simcard_Production_Request_Detail__c();
        SCPRD.SimCard_Production_Request_Header__c=SCPRH.id;
        Product2 P=[SELECT id FROM Product2 WHERE GSM_Type__c='Material' AND FamilY='GSM' LIMIT 1];
        SCPRD.simcard__c=P.id;
        SCPRD.Quantity__c=5;
        insert SCPRD;
        SCPRH.Status__c='Submit';
        update SCPRH;
        SCPRH.Status__c='Draft';
        update SCPRH;
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/simcardproductionrequests/';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardrequest","request_id":"650000000143"},"body":{"data":{"simcard_request_no":"SCRH-20180815-00018","status":"Complete"}}}');
        RestContext.request = restRequest;
        REST_SIMCardRequest.doput();
    }
}