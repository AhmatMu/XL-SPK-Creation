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
private class test_updatetemporaryLA {

    static testMethod void CreateLATest() {
        // TO DO: implement unit test
        Test.startTest();
          SingleRequestMock getToken = new SingleRequestMock(200, 'success',  '{"token":"2345678908765435467890"}', null);

        SingleRequestMock createLA = new SingleRequestMock(200,'success','{"headers":{"status":"success","service":"createla","request_id":"c7b24f83-c7f6-3fab-9342-ddf3254426a6"},"body":{"data":{"success":true,"message":"la record has been saved","sl_id":"504","sld_id":[]}}}',null);
         SingleRequestMock updateLA= new SingleRequestMock(200,'success','{"headers":{"status":"success","service":"updatela","request_id":"503b1811-1dfb-acde-a750-0410bc8e51e6"},"body":{"data":{"success":true,"message":"la record has been updated","sl_id":509,"sld_id":[]}}}',null);
         Map<String, HttpCalloutMock> endpoint2TestResp =new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_CreateLA_Endpoint, createLA);
         endpoint2TestResp.put(Label.REST_TransDB_CreateLA_Endpoint, updateLA);
        RecordType RCBP=[SELECT id FROM RecordType WHERE Name='BP'];
        RecordType RCLA=[SELECT id FROM RecordType WHERE Name='LA'];
         HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);     
          Test.setMock(HttpCalloutMock.class, multiCalloutMock);
          Account ParentA=new Account();
         ParentA=[SELECT id,bp_number__c FROM Account WHERE BP_Number__c!='' AND Organization_type__c='Head Office' LIMIT 1];
          Account ChildA=new Account();
          ChildA.Name='Child';
          ChildA.Recordtypeid=RCLA.id;
          ChildA.Organization_Type__c='Branch';
          ChildA.parentid=parentA.id;
          ChildA.No_NPWP__c='123';
          ChildA.NO_SIUP__C='321';
          ChildA.NO_TDP__c='111';
          ChildA.Fax='021-9477744';
          ChildA.Akta_Notaris__c='00872';
          ChildA.Invoice_Via__c='Email';
          ChildA.Phone='021-0878333';
          ChildA.SKUB__c='22933';
          ChildA.No_Legal__c='209874';
          ChildA.Faktur_Pajak__c=true;
          ChildA.Kwitansi__c=true;
          ChildA.summary_invoice__c=true;    
          insert ChildA;
          ChildA.sl_id__c='0';
          ChildA.summary_invoice__c=false;
          update ChildA;
          ChildA.kwitansi__c=true;
          update ChildA;
                  
    }
}