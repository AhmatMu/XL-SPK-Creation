@isTest(seealldata=true)
public with sharing class Test_REST_Material {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
         
		SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock readAvailableMaterial = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"availablematerial","request_id":"1234567890"},"body":{"total":1,"list":[{"id_material":"9","material":"SP0K4GPOSTPAID-JKT","sloc":"BUSL","available":900}]}}',
                                                   null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
                                   
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_Material_Endpoint, readAvailableMaterial);
        
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
        
        Pricebook2 pb = [select id, name from pricebook2 where name='GSM-Material General' limit 1];
        
        Order O=New Order();
		O.AccountID=acc.id;
		O.Status='Draft';
		O.SLOC__c=S.id;
		O.EffectiveDate=system.today();
		O.pricebook2id = pb.id;
        insert O;
        
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id and product2.name='SP0K4GPOSTPAID-JKT' LIMIT 1];      	
       	OrderItem oi = new OrderItem(OrderId = O.id, PricebookEntryId = pbe.ID, Quantity = 1, UnitPrice = 300);
        insert oi;
        
        REST_Material.readAvailableMaterialOnOrder(o.id); 
         
         
         
        test.stoptest();
    }
    
    
    
    
    
}