@isTest
private class Test_REST_Links  {

    static testMethod void myUnitTestAddLink() {
        // TO DO: implement unit test
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/links';
        restRequest.httpMethod = 'POST';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header":{"service":"addlink","request_id":"657878986879"},"body":{"data":{"cid":"01-01059","bu":"ENTERPRISE","id":"9760","status_link":"IN_SERVICE","company_name":"Wahana Ottomitra Multiartha Finance, PT (WOM)","service_type":"LL","contract_item":"3000681-5","bp_site_a":"706914","bp_site_b":"703007","capacity_bandwidth":"4","uom":"mbps","routepath":"706914 WOM Nap Info - PC064 BII - JNB Bintaro Office - 703007 PT Bank Maybank Indonesia Tbk Jakarta","link_id":"004C425L2"}}}');
        RestContext.request = restRequest;
        REST_Links.doPost();

    }

    static testMethod void myUnitTestUpdateLink() {
        // TO DO: implement unit test
        
        Link__c l = new Link__c();
        l.name='hoho';
        l.ID__c='123455432';
        
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/links';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header":{"service":"updatelink","request_id":"657878986879"},"body":{"data":{"cid":"01-01059","bu":"ENTERPRISE","id":"123455432","status_link":"IN_SERVICE","company_name":"Wahana Ottomitra Multiartha Finance, PT (WOM)","service_type":"LL","contract_item":"3000681-5","bp_site_a":"706914","bp_site_b":"703007","capacity_bandwidth":"4","uom":"mbps","routepath":"706914 WOM Nap Info - PC064 BII - JNB Bintaro Office - 703007 PT Bank Maybank Indonesia Tbk Jakarta","link_id":"004C425L2"}}}');
        RestContext.request = restRequest;
        REST_Links.doPut();

    }    
}