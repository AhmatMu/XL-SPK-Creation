@isTest
private class Test_REST_BAPs_v2  {

    
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

        Id TerminationRecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan'; 
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c= 'a077F000003X0ZFQA0' ; //'a077F000003X0ILQA0'; //'a077F000003WzDrQAK' 
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
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        
        insert bap;
        
        
        bap.Request_Status__c = 'Submit';
        update bap;
        string bapid; string typeOfRequest; string customer; string cid; string sirkit; string address;
        string pic; string picPhone; string picEmail; string picPosition; string bandwidth;
        string bandwidthUom; string requestDate; string terminateDate; string reason; 
        string note; string userCreate ; string request_status; string iom_file_link; string termination_for_nonautorenewal;
    
        integer approveType ;
        string approveEmail;
        string approveDate;

        bapid = bap.BAP_ID__c;
        typeOfRequest = bap.Type_of_Request__c;
        customer = bap.Customer__c;
        cid = bap.CID__c;
        sirkit = bap.Sirkit__c;
        address = bap.Address2__c;
        pic = bap.PIC_Name__c;
        picPhone = bap.PIC_Phone__c; 
        picEmail = bap.PIC_email__c;
        picPosition = bap.PIC_Position__c;
        if (!String.isBlank(picPosition)) {
            picPosition = picPosition.replace(';',',');
        }

        bandwidth = bap.Bandwidth_rel__c;
        bandwidthUom = bap.UoM_rel__c;
        
        bap.Request_Date__c = system.today();
        
        Date d = bap.Request_Date__c;
        Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
        requestDate = dt.format ('yyyy-MM-dd') ; 
        
        d = bap.Terminate_Date__c;
        dt = datetime.newInstance(d.year(), d.month(),d.day());
        terminateDate = dt.format('yyyy-MM-dd');
        
        reason = bap.Reason__c;
        note = bap.Note__c;
        userCreate = bap.CreatedBy_email__C;
        iom_file_link = null;

        if (bapid <> '' && bapid <> null) {
            request_status = 'Operation Review';    //-- for re-SUBMIT and update BAP
        } else {
            request_status = null; 
        }
        
        termination_for_nonautorenewal= 'false';
                            
        REST_BAPs_v2.mirroringBAP( bap.id, bapid,
            typeOfRequest, customer, cid, sirkit, address,
            pic, picPhone, picEmail, picPosition, bandwidth,
            bandwidthUom, requestDate, terminateDate, reason, 
            note, userCreate , request_status , iom_file_link, termination_for_nonautorenewal                  
            ); 
            test.stopTest();
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
        //Test.stopTest();
    }
    
    static testMethod void myUnitTestMirroringBAP_UpdatestatusBAP() {
        Test.startTest();
        
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock addBAP = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"updatestatusbap","request_id":"657878986879"},"body":{"data":{"bap_no":"BAP-07052018-8986","id_bap":"8987","status":"ChekingDataContract","request_status":"BA Sent to Customer"}}}',
                                                   null);
        /*                                          
        SingleRequestMock addBAP = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"updatestatusbap","request_id":"657878986879"},"body":{"data":{"userCreate":null,"typeOfRequest":null,"terminateDate":null,"status":"BAP Sent to Customer","sirkit":null,"sfid":null,"requestDate":null,"request_status":"BAP Sent to Customer","reason":null,"picPosition":null,"picPhone":null,"picEmail":null,"pic":null,"note":null,"customer":null,"cid":null,"bapID":"9024","bandwidthUom":null,"bandwidth":null,"approveType":null,"approveEmail":null,"approveDate":null,"address":null}}}',
                                                   null);                                           
		*/
        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_BAP_Endpoint, addBAP);
		HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        //ProcessAccountsContacts.processAccountsContacts();
        //System.assertEquals(/*check for expected results here...*/);

        Id TerminationRecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan'; 
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c= 'a077F000003X0ZFQA0' ; //'a077F000003X0ILQA0'; //'a077F000003WzDrQAK' 
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
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.IoM_File_Link__c ='https://cs72.lightning.force.com/lightning/r/ContentDocument/0695D000000YneNQAS/view';
        
        insert bap;
        
        /*
        list<BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        
        string bapsfid='';
        
        list<BAP__c> bapstmp2 =new list<BAP__c> ();
        BAP__c baptmp2 =new BAP__c();
        
        if (bapstmp.size()>0 ) { 
            bapsfid = bapstmp[0].id;
            bapstmp[0].request_status__C='BA Sent to Customer';
            system.debug ('================== bapsfid : ' + bapsfid);
            
            baptmp2.id= bapstmp[0].id;
            
            baptmp2.request_status__C='BA Sent to Customer';
            bapstmp2.add(baptmp2);
            system.debug ('================== bapstmp2 : ' + bapstmp2);
            update bapstmp2;
        }
        */
        bap.Request_Status__c = 'BA Sent to Customer';
        update bap;
        string bapid; string typeOfRequest; string customer; string cid; string sirkit; string address;
        string pic; string picPhone; string picEmail; string picPosition; string bandwidth;
        string bandwidthUom; string requestDate; string terminateDate; string reason; 
        string note; string userCreate ; string request_status; string iom_file_link; string termination_for_nonautorenewal;
    
        integer approveType ;
        string approveEmail;
        string approveDate;
        bapid = bap.BAP_ID__c;
        typeOfRequest = null;
        customer = null;
        cid = null;
        sirkit = null;
        address = null;
        pic = null;
        picPhone = null; 
        picEmail = null;
        picPosition = null;
        if (!String.isBlank(picPosition)) {
            picPosition = picPosition.replace(';',',');
        }

        bandwidth = null;
        bandwidthUom = null;
        
        //Date d = bap.Request_Date__c;
        //Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
        requestDate = null ; 
        
        //d = bap.Terminate_Date__c;
        //dt = datetime.newInstance(d.year(), d.month(),d.day());
        terminateDate = null;
        
        reason = null;
        note = null;
        userCreate = null;
        request_status = 'BAP Sent to Customer';

        list<ContentDistribution> CDList=[SELECT id,DistributionPublicUrl FROM ContentDistribution WHERE name=:BAP.name order by createddate desc];
        //BAP__c B=new BAP__c();
        //B.id=BAPid;
        //B.iom_file_link__c=CD2.DistributionPublicUrl;

        if ( CDList.size() > 0 ) {
            iom_file_link = CDList[0].DistributionPublicUrl;
        }

        termination_for_nonautorenewal = 'false';
     
        REST_BAPs_v2.mirroringBAP( bap.id, bapid,
        typeOfRequest, customer, cid, sirkit, address,
        pic, picPhone, picEmail, picPosition, bandwidth,
        bandwidthUom, requestDate, terminateDate, reason, 
        note, userCreate, request_status ,iom_file_link,termination_for_nonautorenewal                   
        );
        
        Test.stopTest();
    }
    
    static testMethod void myUnitTestMirroringBAP_UpdatestatusBAPCancel() {
        Test.startTest();
        
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock addBAP = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"updatestatusbap","request_id":"657878986879"},"body":{"data":{"bap_no":"BAP-07052018-8986","id_bap":"8987","status":"ChekingDataContract","request_status":"Canceled"}}}',
                                                   null);
        /*                                          
        SingleRequestMock addBAP = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"updatestatusbap","request_id":"657878986879"},"body":{"data":{"userCreate":null,"typeOfRequest":null,"terminateDate":null,"status":"BAP Sent to Customer","sirkit":null,"sfid":null,"requestDate":null,"request_status":"BAP Sent to Customer","reason":null,"picPosition":null,"picPhone":null,"picEmail":null,"pic":null,"note":null,"customer":null,"cid":null,"bapID":"9024","bandwidthUom":null,"bandwidth":null,"approveType":null,"approveEmail":null,"approveDate":null,"address":null}}}',
                                                   null);                                           
		*/
        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_BAP_Endpoint, addBAP);
		HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        //ProcessAccountsContacts.processAccountsContacts();
        //System.assertEquals(/*check for expected results here...*/);

        Id TerminationRecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan'; 
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c= 'a077F000003X0ZFQA0' ; //'a077F000003X0ILQA0'; //'a077F000003WzDrQAK' 
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
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.Complete_Status__c='Canceled';
        bap.IoM_File_Link__c ='https://cs72.lightning.force.com/lightning/r/ContentDocument/0695D000000YneNQAS/view';
        
        insert bap;
        
        
        
        bap.Request_Status__c = 'Complete';
        update bap;
        string bapid; string typeOfRequest; string customer; string cid; string sirkit; string address;
        string pic; string picPhone; string picEmail; string picPosition; string bandwidth;
        string bandwidthUom; string requestDate; string terminateDate; string reason; 
        string note; string userCreate ; string request_status; string iom_file_link; string termination_for_nonautorenewal;
    
        integer approveType ;
        string approveEmail;
        string approveDate;
        bapid = bap.BAP_ID__c;
        typeOfRequest = null;
        customer = null;
        cid = null;
        sirkit = null;
        address = null;
        pic = null;
        picPhone = null; 
        picEmail = null;
        picPosition = null;
        if (!String.isBlank(picPosition)) {
            picPosition = picPosition.replace(';',',');
        }

        bandwidth = null;
        bandwidthUom = null;
        
        //Date d = bap.Request_Date__c;
        //Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
        requestDate = null ; 
        
        //d = bap.Terminate_Date__c;
        //dt = datetime.newInstance(d.year(), d.month(),d.day());
        terminateDate = null;
        
        reason = null;
        note = null;
        userCreate = null;
        request_status = 'BAP Sent to Customer';

        list<ContentDistribution> CDList=[SELECT id,DistributionPublicUrl FROM ContentDistribution WHERE name=:BAP.name order by createddate desc];
        //BAP__c B=new BAP__c();
        //B.id=BAPid;
        //B.iom_file_link__c=CD2.DistributionPublicUrl;

        if ( CDList.size() > 0 ) {
            iom_file_link = CDList[0].DistributionPublicUrl;
        }

        termination_for_nonautorenewal = 'false';

     
        REST_BAPs_v2.mirroringBAP( bap.id, bapid,
        typeOfRequest, customer, cid, sirkit, address,
        pic, picPhone, picEmail, picPosition, bandwidth,
        bandwidthUom, requestDate, terminateDate, reason, 
        note, userCreate, request_status ,iom_file_link, termination_for_nonautorenewal                  
        );
        
        Test.stopTest();
    }
    
    
    static testMethod void myUnitTestMirroringBAP_UpdatestatusDraft() {
        Test.startTest();
        
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock addBAP = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"updatestatusbap","request_id":"657878986879"},"body":{"data":{"bap_no":"BAP-07052018-8986","id_bap":"8987","status":"ChekingDataContract","request_status":"Canceled"}}}',
                                                   null);
        /*                                          
        SingleRequestMock addBAP = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"updatestatusbap","request_id":"657878986879"},"body":{"data":{"userCreate":null,"typeOfRequest":null,"terminateDate":null,"status":"BAP Sent to Customer","sirkit":null,"sfid":null,"requestDate":null,"request_status":"BAP Sent to Customer","reason":null,"picPosition":null,"picPhone":null,"picEmail":null,"pic":null,"note":null,"customer":null,"cid":null,"bapID":"9024","bandwidthUom":null,"bandwidth":null,"approveType":null,"approveEmail":null,"approveDate":null,"address":null}}}',
                                                   null);                                           
		*/
        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_BAP_Endpoint, addBAP);
		HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        //ProcessAccountsContacts.processAccountsContacts();
        //System.assertEquals(/*check for expected results here...*/);

        Id TerminationRecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan'; 
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c= 'a077F000003X0ZFQA0' ; //'a077F000003X0ILQA0'; //'a077F000003WzDrQAK' 
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
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.IoM_File_Link__c ='https://cs72.lightning.force.com/lightning/r/ContentDocument/0695D000000YneNQAS/view';
        
        insert bap;
        
        
        
        bap.Request_Status__c = 'BA Sent to Customer';
        update bap;
        
        bap.Request_Status__c = 'Draft';
        update bap;
        
        string bapid; string typeOfRequest; string customer; string cid; string sirkit; string address;
        string pic; string picPhone; string picEmail; string picPosition; string bandwidth;
        string bandwidthUom; string requestDate; string terminateDate; string reason; 
        string note; string userCreate ; string request_status; string iom_file_link; string termination_for_nonautorenewal;
    
        integer approveType ;
        string approveEmail;
        string approveDate;
        bapid = bap.BAP_ID__c;
        typeOfRequest = null;
        customer = null;
        cid = null;
        sirkit = null;
        address = null;
        pic = null;
        picPhone = null; 
        picEmail = null;
        picPosition = null;
        if (!String.isBlank(picPosition)) {
            picPosition = picPosition.replace(';',',');
        }

        bandwidth = null;
        bandwidthUom = null;
        
        //Date d = bap.Request_Date__c;
        //Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
        requestDate = null ; 
        
        //d = bap.Terminate_Date__c;
        //dt = datetime.newInstance(d.year(), d.month(),d.day());
        terminateDate = null;
        
        reason = null;
        note = null;
        userCreate = null;
        request_status = 'Draft';

        list<ContentDistribution> CDList=[SELECT id,DistributionPublicUrl FROM ContentDistribution WHERE name=:BAP.name order by createddate desc];
        //BAP__c B=new BAP__c();
        //B.id=BAPid;
        //B.iom_file_link__c=CD2.DistributionPublicUrl;

        if ( CDList.size() > 0 ) {
            iom_file_link = CDList[0].DistributionPublicUrl;
        }

        termination_for_nonautorenewal = 'false';


     
        REST_BAPs_v2.mirroringBAP( bap.id, bapid,
        typeOfRequest, customer, cid, sirkit, address,
        pic, picPhone, picEmail, picPosition, bandwidth,
        bandwidthUom, requestDate, terminateDate, reason, 
        note, userCreate, request_status ,iom_file_link , termination_for_nonautorenewal                  
        );
        
        Test.stopTest();
    }
    
/*
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
        system.debug ('================== endpoint 1: ' + Label.REST_TransDB_BAP_Endpoint_v2);
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_BAP_Endpoint_v2, approvalBAP);
		system.debug ('================== endpoint 2: ' + endpoint2TestResp); 
        
        HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        BAP__c bap = new BAP__c();
        
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c='a077F000003X0ZFQA0';
        bap.sirkit__c='testbro';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
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
 */   
    
    static testMethod void myUnitTestUpdateBAP() {
        Test.startTest();
        system.debug ('================== updatestatusBAP masuk : ');
        
        Id TerminationRecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c='a077F000003X0ZFQA0';
        bap.sirkit__c='testbro';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.bap_id__c='9024';
        
        insert bap;
        list<BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        
        string bapsfid='';     
        
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/v2/baps';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": {"request_id": "204412412","service": "updatebapiomapproval"},"body": {"data": {"bap_no": "","bap_id": "9024","orm": [{"pinalty_flag": 1,"pinalty": 0,"lebih_tagih": 10000,"start_date": "2020-01-02","end_date": "2020-01-02"}],"ocm": [{"cost_flag": 1,"cost": 1200000}]}}}');
        RestContext.request = restRequest;
        REST_BAPs_v2.doPut();        


        Test.stopTest();
    }

	static testMethod void myUnitTestUpdateBAPStatus() {
        Test.startTest();
        system.debug ('================== updatestatusBAP masuk : ');
        
        Id TerminationRecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c='a077F000003X0ZFQA0';
        bap.sirkit__c='testbro';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.bap_id__c='9024';
        
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
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/v2/baps';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": {"request_id": "204412412","service": "updatebapstatus"},"body": {"data": {"bap_id": "9024","status": "BAP Sent to Finance"}}}');
        RestContext.request = restRequest;
        REST_BAPs_v2.doPut();        


        Test.stopTest();
    }
    
    static testMethod void myUnitTestUpdateBAP_ErrorIdBAPNull() {
        Test.startTest();
        system.debug ('================== updatestatusBAP masuk : ');

        Id TerminationRecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c='a077F000003X0ZFQA0';
        bap.sirkit__c='testbro';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.bap_id__c='9024';
        
        insert bap;
        list<BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        
        string bapsfid='';
         
        
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/v2/baps';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": {"request_id": "204412412","service": "updatebapiomapproval"},"body": {"data": {"bap_no": "","bap_id": "001","orm": [{"pinalty_flag": 1,"pinalty": 0,"lebih_tagih": 10000,"start_date": "2020-01-02","end_date": "2020-01-02"}],"ocm": [{"cost_flag": 1,"cost": 1200000}]}}}');
        RestContext.request = restRequest;
        REST_BAPs_v2.doPut();        


        Test.stopTest();
    }
	    static testMethod void myUnitTestUpdateBAPStatus_ErrorIdBAPNull() {
        Test.startTest();
        system.debug ('================== updatestatusBAP masuk : ');
        
        Id TerminationRecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c='a077F000003X0ZFQA0';
        bap.sirkit__c='testbro';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.bap_id__c='9024';
        
        insert bap;
        list<BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        
        string bapsfid='';
         
        
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/v2/baps';
        restRequest.httpMethod = 'PUT';
        restRequest.remoteAddress = '111.111.1.111';
        restRequest.requestBody = Blob.valueof('{"header": {"request_id": "204412412","service": "updatebapstatus"},"body": {"data": {"bap_no": "","bap_id": "001","orm": [{"pinalty_flag": 1,"pinalty": 0,"lebih_tagih": 10000,"start_date": "2020-01-02","end_date": "2020-01-02"}],"ocm": [{"cost_flag": 1,"cost": 1200000}]}}}');
        RestContext.request = restRequest;
        REST_BAPs_v2.doPut();        


        Test.stopTest();
    }

}