@istest
private class test_BAP_IOM_Approval {
    static testMethod void test_BAP_IOM_Approval() {
        Test.startTest();
        
         // novi, 8 feb 2021, update sender dan cc approval iom BAP
        // gh Ops
       	/*userrole gh_ops = [select id from userrole where name LIKE '%Group Head - operations%'];
        User user_gh_ops = new User();
        user_gh_ops.firstName = 'gh';
        user_gh_ops.lastName = 'ops';
        user_gh_ops.userroleID = gh_ops.id; 
        user_gh_ops.username = 'gh_ops@test.com';
        user_gh_ops.email = 'gh_ops@test.com';
        user_gh_ops.Alias = 'go';
        user_gh_ops.TimeZoneSidKey = 'America/Los_Angeles';
        user_gh_ops.EmailEncodingKey = 'UTF-8';
        user_gh_ops.LanguageLocaleKey = 'en_US';
        user_gh_ops.LocaleSidKey = 'en_US';
        insert user_gh_ops;
        
        system.debug('*** gh = ' + gh_ops);
        
        //Head Technical & Contact
        userrole head_cts = [select id from userrole where name LIKE '%Head - Technical & Contact Center%'];
        User user_head_cts = new User();
        user_head_cts.firstName = 'head';
        user_head_cts.lastName = 'cts';
        user_head_cts.userroleID = head_cts.id; 
        user_head_cts.username = 'head_cts@test.com';
        user_head_cts.email = 'head_cts@test.com';
        user_head_cts.Alias = 'hcts';
        user_head_cts.TimeZoneSidKey = 'America/Los_Angeles';
        user_head_cts.EmailEncodingKey = 'UTF-8';
        user_head_cts.LanguageLocaleKey = 'en_US';
        user_head_cts.LocaleSidKey = 'en_US';
        insert user_head_cts;
        
        system.debug('*** head_cts = ' + head_cts);
        
        //Head Operations Management
        userrole head_om = [select id from userrole where name LIKE 'Head - Operations Management'];
        User user_head_om = new User();
        user_head_om.firstName = 'head';
        user_head_om.lastName = 'om';
        user_head_om.userroleID = head_om.id; 
        user_head_om.username = 'head_om@test.com';
        user_head_om.email = 'head_om@test.com';
        user_head_om.Alias = 'hom';
        user_head_om.TimeZoneSidKey = 'America/Los_Angeles';
        user_head_om.EmailEncodingKey = 'UTF-8';
        user_head_om.LanguageLocaleKey = 'en_US';
        user_head_om.LocaleSidKey = 'en_US';
        insert user_head_om;
        
        system.debug('*** head_om = ' + head_om );*/
        
        
        // ** Edited by novi **
        
        
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
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        insert new Transaction__c(transactionID__c = 1);

        Account accTest = new Account();
        accTest.RecordTypeId = recordTypeId_accBP;
        accTest.Name = 'Bank Maybank Indonesia Tbk';
        accTest.Unique_Name__c = 'Sentral Senayan Building 3';
        accTest.NumberOfEmployees = 2;
        accTest.Summary_Billing__c = false;
        accTest.Payer_For_GSM_Invoice__c = false;
        accTest.Using_HO_Billing_Address__c = false;
        accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
        accTest.Customer_VAT_Name__c = 'BANK MAYBANK INDONESIA TBK';
        accTest.Customer_Type__c = 'NONGSM';
        accTest.No_NPWP__c = '013093232091000';
        accTest.BillingStreet = 'hive';
        accTest.BillingState = 'hive';
        accTest.BillingCity = 'hive';
        accTest.BillingCountry = 'hive';
        accTest.BillingPostalCode = 'hive';
        accTest.ShippingStreet = 'hive';
        accTest.ShippingState = 'hive';
        accTest.ShippingCity = 'hive';
        accTest.ShippingCountry = 'hive';
        accTest.ShippingPostalCode = 'hive';
        accTest.Billing_Building_Name__c = 'hive';
        accTest.Shipping_Building_Name__c = 'hive';
        accTest.Field_Source__c = 'Bizstore Customer Registration';
        accTest.Organization_Type__c = 'Head Office';
        accTest.Type = 'Customer';
        accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        accTest.OU__c = '1';
        accTest.Industry = 'Agriculture';
        accTest.BP_Number__c = '714197';
        accTest.Bizstore_Complete__c = false;
        Insert accTest;

        Account accTest2 = new Account(
        Name = 'PT Bank MayBank Indonesia Tbk',                         
        RecordTypeId = recordTypeId_accBP,                                     
        BP_Number__c = '707310',                                        
        Organization_Type__c = 'Branch',                                
        Type = 'Customer',                                              
        ParentId = accTest.Id,                                         
        Unique_Name__c = 'KCP Surabaya Pondok Candra',                  
        Customer_Type__c = 'NONGSM',                                    
        Payer_For_GSM_Invoice__c = false,                               
        term_of_payment__c = 'Z030 Within 30 Days Due Net',             
        Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)',
        Customer_VAT_Name__c = 'PT Bank MayBank Indonesia Tbk',         
        Summary_Billing__c = false,                                     
        Using_HO_Billing_Address__c = false                             
        );
        insert accTest2;

        Circuit__c  Circuit_Test = new Circuit__c(
            Name = '02-02021',
            datacode__c = 'circuitimport_201801'
        );
        insert Circuit_Test;

        Contract contractTest = new Contract();
        contractTest.Name = '[SAP] Contract Item of MPLS - 512 Kbps';
        contractTest.Full_Name__c = '[SAP] Contract Item of MPLS - 512 Kbps';
        contractTest.AccountId = accTest2.Id;
        contractTest.Account_BP_Payer__c = accTest.Id;
        contractTest.Start_Date__c = System.today();
        contractTest.End_Date__c = System.today();
        contractTest.Account_BP_VAT__c = accTest2.Id;
        contractTest.Contract_Term__c = 12;
        contractTest.Billing_Type__c = 'Monthly';
        contractTest.Price__c = 1213;
        contractTest.SAP_ID__c = '351';
        contractTest.Quantity__c = 1;
        contractTest.Periode_UOM__c = 'Month';
        contractTest.Bandwidth_filled__c = 512;
        contractTest.Bandwidth_UoM_filled__c = 'Kbps';
        contractTest.Account_Site_A_BP_Site__c = accTest2.Id;
        insert contractTest;

        Link__c linkTest = new Link__c(
            Name = '02-02021',                                  
            BU__c = 'ENTERPRISE',
            CID__c = '02-02021',                          
            ID__c = '3281',                       
            Status_Link__c = 'IN_SERVICE',
            Company_Name__c = 'Bank Maybank Indonesia Tbk',
            Service_Type__c = 'MPLS',
            Contract_Item__c = '3001207-351',
            BP_Site_A__c = '707310', 
            Capacity_Bandwidth__c = '512',
            UoM__c = 'Kbps',
            Routepath__c = '707310 BII KCP Pondok Candra Surabaya - POP BWA Rungkut (STARCOM) POP BWA Rungkut (STARCOM) - EC-SBRKO-01 EC-SBRKO-01',
            CID_RelD__c = Circuit_Test.Id,
            Link_ID__c = '007C362L84',
            Site_A_Name__c = accTest2.Id,
            Contract_Item_Rel__c = contractTest.Id,
            Free_Link__c = false,
            Selected__c = false,
            Partner__c = false                                                                    
        );
        insert linkTest;

        BAP__c bap = new BAP__c();
        bap.RecordTypeId = TerminationRecordTypeId;
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c = accTest.Id;
        bap.Link__c= linkTest.Id;
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
        bap.contract_start_date__c=date.newInstance(2020, 4, 21);
        bap.contract_end_date__c=date.newInstance(2021, 4, 21);
        bap.Approval_Remark__c = 'Request for CEO Approval';
        insert bap;
       
        ApexPages.StandardController sc = new ApexPages.StandardController(bap);
        BAPUtils BU=new BAPUtils(sc);
        BAP_IoM_Approval BIA=new BAP_IoM_Approval(sc);
        BIA.isBackdateFlag=TRUE;
        BIA.isPenaltyFlag=TRUE;
        BIA.isBackDateToggle=TRUE;
        BIA.isPenaltyToggle=TRUE;
        BIA.isCostPartnerFlag=FALSE;
        BIA.pencetSubmit();
        BIA.isCostPartnerFlag=TRUE;
        BIA.pencetSubmit();
        BIA.isPenaltyToggle=FALSE;
        BIA.pencetSubmit();
        BIA.isBackDateToggle=FALSE;
        BIA.isPenaltyToggle=TRUE;
        BIA.isCostPartnerFlag=FALSE;
        BIA.pencetSubmit();
        BIA.isCostPartnerFlag=TRUE;
        BIA.pencetSubmit();
        BIA.isPenaltyToggle=FALSE;
        BIA.pencetSubmit();
        BIA.isBackdateFlag=TRUE;
        BIA.isPenaltyFlag=FALSE;
        BIA.isBackDateToggle=TRUE;
        BIA.isCostPartnerFlag=FALSE;
        BIA.pencetSubmit();
        bia.isCostPartnerFlag=TRUE;
        BIA.pencetSubmit();
        BIA.isBackDateToggle=FALSE;
        BIA.isCostPartnerFlag=FALSE;
        bia.pencetSubmit();
        BIA.isPenaltyFlag=TRUE;
        BIA.isBackdateFlag=FALSE;
        BIA.isPenaltyToggle=TRUE;
        BIA.isCostPartnerFlag=FALSE;
        BIA.pencetSubmit();
        BIA.isCostPartnerFlag=TRUE;
        BIA.pencetSubmit();
        BIA.isPenaltyToggle=FALSE;
        BIA.pencetSubmit();
        
    }
}