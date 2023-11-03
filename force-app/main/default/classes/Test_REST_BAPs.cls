@isTest
private class Test_REST_BAPs  {

    
    static testMethod void myUnitTestMirroringBAP() {
        Test.startTest();
        
        //Test.setMock(HttpCalloutMock.class, new MockHttpTransDBGetTokenResponseGenerator()   );
        //Test.setMock(HttpCalloutMock.class, new MockHttpMirroringBAPResponseGenerator()   );
        /*
        MockHttpResponseGenerator mockResponse = new MockHttpResponseGenerator();
        mockResponse.addResponse(Label.REST_TransDB_GetToken_Endpoint, '{"token":"2345678908765435467890"}');
        mockResponse.addResponse( Label.REST_TransDB_BAP_Endpoint, '{" headers ":{" status ":"success"," service ":"addbap"," request_id ":"657878986879"}," body ":{" data ":{" bap_no ":"BAP-07052018-8986"," id_bap ":"8987"," status ":"Cheking Data Contract"}}}');
        */

        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock addBAP = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"addbap","request_id":"657878986879"},"body":{"data":{"bap_no":"BAP-07052018-8986","id_bap":"8987","status":"ChekingDataContract"}}}',
                                                   null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_BAP_Endpoint, addBAP);

        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        //ProcessAccountsContacts.processAccountsContacts();
        //System.assertEquals(/*check for expected results here...*/);


        BAP__c bap = new BAP__c();
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RN0wOQAT';
        bap.Link__c= 'a077F000003WzDrQAK' ; //'a077F000003X0ILQA0';
        bap.sirkit__c='testbro';
        bap.Address2__c ='jl.cenrawasih';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Rekonfigurasi';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        
        insert bap;
        list<BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        
        string bapsfid='';
        
        list<BAP__c> bapstmp2 =new list<BAP__c> ();
        BAP__c baptmp2 =new BAP__c();
        
        if (bapstmp.size()>0 ) { 
            bapsfid = bapstmp[0].id;
            bapstmp[0].request_status__C='Final';
            
            
            baptmp2.id= bapstmp[0].id;
            baptmp2.request_status__C='Final';
            bapstmp2.add(baptmp2);
            
            update bapstmp2;
        }
        
        /*
        
        REST_BAPs.mirroringBAP( bapsfid , '',
                        'Pemutusan', 'BCA', '02-02884', 
                        '123', 'Divisi Teknologi Informasi Menara BCA Lt. ',
                        'do', '097867564,(098) 675-6454,', 
                        'do@gmail.com,dani@5mb.co.id', 'PIC UP Invoice;PIC CS,', 
                        '3',
                        'Mbps', 
                        '2018-10-10 10:10:10', '2018-10-10 10:10:10', 'reason', 
                        'note', 'do@gmail.com');
        
        /*
        REST_BAPs.mirroringBAP( bap.id, bapid,
                        typeOfRequest, customer, cid, sirkit, address,
                        pic, picPhone, picEmail, picPosition, bandwidth,
                        bandwidthUom, requestDate, terminateDate, reason, 
                        note, userCreate                     
                        );
    */
        Test.stopTest();
    }
    
    static testMethod void myUnitTestUpdateBAP() {
        Test.startTest();

        BAP__c bap = new BAP__c();
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RM06IQAT';
        bap.Link__c='a077F000003X0ILQA0';
        bap.sirkit__c='testbro';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Rekonfigurasi';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.bap_id__c='1234567890';
        
        insert bap;
        list<BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        
        string bapsfid='';
        /*
        list<BAP__c> bapstmp2 =new list<BAP__c> ();
        BAP__c baptmp2 =new BAP__c();
        
        if (bapstmp.size()>0 ) { 
            bapsfid = bapstmp[0].id;
            bapstmp[0].request_status__C='Final';
            
            
            baptmp2.id= bapstmp[0].id;
            baptmp2.request_status__C='Final';
            bapstmp2.add(baptmp2);
            
            update bapstmp2;
        } */       
        
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/baps';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header":{"service":"updatebap","request_id":"61234235267"},"body":{"data":{"bap_id":"1234567890","status":"waiting for .."}}}');
        RestContext.request = restRequest;
        REST_BAPs.doPut();        


        Test.stopTest();
    }

    static testMethod void myUnitTestapprovalBAP() {
        
        string bapid = '';
        string approveType = '';
        string approveEmail = '';
        string approveDate ='';
        //REST_BAPs.approvalBAP(bapid,
        //                approveType, approveEmail, approveDate) ;

        Test.startTest();

        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock approvalBAP = new SingleRequestMock(200,
                                                  'success',
                                                  '{" headers ":{" status ":"success"," service ":"approvebap"," request_id ":"657878986879"}," body ":{" data ":{" id_bap ":"8993"," status ":"BAP sent to Customer"," msg ":"Approve Senior GM Operation success"}}}',
                                                   null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_BAP_Endpoint, approvalBAP);

        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        BAP__c bap = new BAP__c();
        
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RM06IQAT';
        bap.Link__c='a077F000003X0ILQA0';
        bap.sirkit__c='testbro';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Rekonfigurasi';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.bap_id__c='1234567890';
        
        insert bap;
        list<BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        
        string bapsfid='';
        
        list<BAP__c> bapstmp2 =new list<BAP__c> ();
        BAP__c baptmp2 =new BAP__c();
        
        if (bapstmp.size()>0 ) { 
            
            // approval by Sales Manager
            baptmp2.id= bapstmp[0].id;
            baptmp2.Approval_Status_by_Sales_Manager__c = 'Approved';
            bapstmp2.add(baptmp2);
            update bapstmp2;

            bapstmp2 = new list<BAP__c> ();
            baptmp2.Approval_Status_by_GM_Sales__c = 'Approved';
            bapstmp2.add(baptmp2);
            update bapstmp2;

            bapstmp2 = new list<BAP__c> ();
            baptmp2.Approval_Status_by_Senior_GM_Operation__c = 'Approved';
            bapstmp2.add(baptmp2);
            update bapstmp2;

            
        }        

        Test.stopTest();

        

        // approval by GM 

        // approval by senior gm operation


    }
    
    

}