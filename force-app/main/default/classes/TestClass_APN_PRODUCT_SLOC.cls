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
private class TestClass_APN_PRODUCT_SLOC {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
          RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://cs72.salesforce.com/services/apexrest/apns/';
        restRequest.httpMethod = 'POST';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": {"service": "addapn","request_id": "657878986879" },"body": {    "data": {   "apn_id": "1", "apn_name": "APN 1"}}}');
        RestContext.request = restRequest;
        REST_APNs.DoPost();
         restRequest.requestURI = 'https://cs72.salesforce.com/services/apexrest/apns/';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": {"service": "updateapn","request_id": "657878986879" },"body": {    "data": {   "apn_sfid": "1", "apn_name": "APN 1"}}}');
        RestContext.request = restRequest;
        REST_APNs.DoPut();
    }
     static testMethod void myUnitTest2()
     {
     	   RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://cs72.salesforce.com/services/apexrest/slocs/';
        restRequest.httpMethod = 'POST';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": { "service": "addsloc","request_id": "657878986879"}, "body": {"data": {"sloc_id": "1","sloc_name": "abc" }}}');
        RestContext.request = restRequest;
        REST_SLOCs.DoPost();
         restRequest.requestURI = 'https://cs72.salesforce.com/services/apexrest/slocs/';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": { "service": "updatesloc","request_id": "657878986879"}, "body": {"data": {"sloc_sfid": "1","sloc_name": "abc" }}}');
        RestContext.request = restRequest;
        REST_SLOCs.DoPut();
     }
      static testMethod void myUnitTest3()
     {
     	   RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://cs72.salesforce.com/services/apexrest/products/';
        restRequest.httpMethod = 'POST';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": {   "service": "addproduct", "request_id": "657878986879"},"body": { "data": {     "product_name": "SP0KDATALTEOP-JKT","product_code": "1","sap_code": "123321","product_description": "SP3 OP","product_family": "GSM","gsm_type": "Material", "sim_type": "Reg - Prepaid", "standard_price": 100}}}');
        RestContext.request = restRequest;
        REST_Products.DoPost();
         restRequest.requestURI = 'https://cs72.salesforce.com/services/apexrest/slocs/';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": {   "service": "updateproduct", "request_id": "657878986879"},"body": { "data": {  "product_sfid": "01t7F00000354WM",     "product_name": "SP0KDATALTEOP-JKT","product_code": "1","sap_code": "123321","product_description": "SP3 OP","product_family": "GSM","gsm_type": "Material", "sim_type": "Reg - Prepaid", "standard_price": 100}}}');
        RestContext.request = restRequest;
        REST_Products.DoPut();
     }
}