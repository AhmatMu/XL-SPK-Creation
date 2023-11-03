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
@isTest
private class test_updateopportunitystage {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
       RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/simcardorder/';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header":{"service":"updatesimcardactivation","request_id":"650000000150"},"body":{"data":{"opportunity_no":"1534391033051","stage":"Implementation"}}}');
        RestContext.request = restRequest;  
        REST_UpdateOpportunityStageOrder.doPut();
         restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/simcardactivation/';
          REST_UpdateOpportunityStage.doPut();
        
    }
}