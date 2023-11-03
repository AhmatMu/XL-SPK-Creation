@isTest
public class TEST_REST_BAP_Temp_Isolation_Callout_v1 {

    @testSetup 
    static void setupRecord() {
        Id recordTypeId_bapTempIsolation = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Temporary Isolation').getRecordTypeId();
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        insert new Transaction__c(transactionID__c = 1);

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController=new Trigger_Controller__c();
        TriggerController.Name = 'Trigger_Bap_v2';
        TriggerController.Is_Active__c = True;
        lstTriggerController.add(TriggerController);

        Trigger_Controller__c TriggerController1=new Trigger_Controller__c();
        TriggerController1.Name = 'Trigger_EDA';
        TriggerController1.Is_Active__c = True;
        lstTriggerController.add(TriggerController1);
        insert lstTriggerController;

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

        BAP__c bapTest = new BAP__c(
            RecordTypeId = recordTypeId_bapTempIsolation,
            BAP_ID__c = '9311',                                     
            Name = 'BAP 02-08491 PT Permata uang Tbk',
            Request_Date__c = System.today(),
            Type_of_Request__c = 'Isolasi Sementara',             
            Terminate_Date__c = System.today(),           
            Customer__c = accTest.Id,                              
            Request_Status__c = 'Draft',
            Link__c = linkTest.Id,                       
            Sirkit__c = 'PT wahana',                                
            Isolation_Start_Date__c = System.today(),     
            Address2__c = 'jalan orchid',                           
            Isolation_End_Date__c = System.today(),       
            PIC_Name__c = 'radhitya',                               
            Isolation_Desire_End_Date__c = System.today(),
            PIC_Phone__c = '123456788',                             
            PIC_email__c = 'testt@gmail.com',                       
            PIC_Position__c = 'SIT',                                
            Bandwidth_UOM__c = 'mbps',                              
            Reason__c = 'Harga (Commercial Issue)',                 
            Note__c = 'Testt SIT',                                  
            Remark__c = 'Process Isolation EDA',                                                   
            Contract_Start_Date__c = System.today(),                
            Contract_End_Date__c = System.today()         
        );
        insert bapTest;

        EDA__c EdaSubmitTempIsolation = new EDA__c(
            Name = 'Temporary Isolation ' + bapTest.Name,
            Document_Type__c = 'IOM',
            IOM_Type__c = 'Temporary Isolation',
            EDA_Status__c = 'Draft',
            Related_Customer__c = bapTest.Customer__c,
            BAP__c = bapTest.Id,
            Summary__c = 
            'Request to Process Temporary Isolation : ' + '\n' +
            'Link ID : ' + bapTest.CID__c + '\n' +
            'BA Isolation : ' + bapTest.Id + '\n' +
            'Customer : ' + bapTest.Customer__c + '\n' +
            'Start Isolation Date : ' + bapTest.Isolation_Start_Date__c + '\n' +
            'End Isolation Date : ' + bapTest.Isolation_End_Date__c
        );
        insert EdaSubmitTempIsolation;

        bapTest.EDA__c = EdaSubmitTempIsolation.Id;
        update bapTest;
    }

    @isTest
    static void test_createBAPTemporary_Isolation(){
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock createBAPTemporary_Isolation = new SingleRequestMock(200,
        'success',
        '{"header": {"status": "","service": "addbap","response_id": "","request_id": "67eead60-7014-9410-25cc-ae20c0b8e5cd"},"body": {"data": {"userCreate": "kahfif@xl.co.id","typeOfRequest": "Isolir Sementara","openIsolationDate": "2020-12-01","sirkit": "PT Lotte Data Communication Indonesia  Alam Sutera Serpong","requestDate": "2020-12-02","reason": "Kontrak berakhir atau tidak diperpanjang","picPosition": "IT Business Manager","picPhone": "+6281310626406","picEmail": "safruddin@lottedata.id", "pic": "Safurddin","note": "XL support dibelakang Lintasartha","customer": "0017F00000RN1ZoQAL","cid": "02-04587","bandwidthUom": "Mbps","bandwidth": "2048","address": "Perumahan Alam Sutera Blok Sutera Niaga Kav. 2 Serpong Tangerang"}}}',
        null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_BAP_Isolation_Endpoint, createBAPTemporary_Isolation);
		HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<BAP__c> bapList = [SELECT Id, OwnerId, Type_of_Request__c, Isolation_End_Date__c, Sirkit__c, Isolation_Start_Date__c, Reason__c, PIC_Position__c, PIC_Phone__c, PIC_email__c, PIC_Name__c, Note__c, Customer__c, CID__c, UoM_rel__c, Bandwidth_rel__c, Address2__c FROM BAP__c];

        List<User> userList = [SELECT Email FROM User WHERE Id=:bapList[0].OwnerId];

        Id recordId = bapList[0].Id;
        String userCreate = userList[0].Email;
        String typeOfRequest = bapList[0].Type_of_Request__c;
        Date openIsolationDateValue = bapList[0].Isolation_End_Date__c;
        String openIsolationDate = openIsolationDateValue.year() + '-' + openIsolationDateValue.month() + '-' + openIsolationDateValue.day();
        String sirkit = bapList[0].Sirkit__c;
        Date requestDateValue = bapList[0].Isolation_Start_Date__c;
        String requestDate = requestDateValue.year() + '-' + requestDateValue.month() + '-' + requestDateValue.day();
        String reason = bapList[0].Reason__c;
        String picPosition = bapList[0].PIC_Position__c;
        String picPhone = bapList[0].PIC_Phone__c;
        String picEmail = bapList[0].PIC_email__c;
        String pic = bapList[0].PIC_Name__c;
        String note = bapList[0].Note__c;
        String customer = bapList[0].Customer__c;
        String cid = bapList[0].CID__c;
        String bandwidthUom = bapList[0].UoM_rel__c;
        String bandwidth = bapList[0].Bandwidth_rel__c;
        String address = bapList[0].Address2__c;

        REST_BAP_Temp_Isolation_Callout_v1.createBAPTemporary_Isolation(
            recordId,
            userCreate,
            typeOfRequest,
            openIsolationDate,
            sirkit,
            requestDate,
            reason,
            picPosition,
            picPhone,
            picEmail,
            pic,
            note,
            customer,
            cid,
            bandwidthUom,
            bandwidth,
            address
        );
    }

    @isTest
    static void updateBAPTemporary_Isolation(){
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock updateBAPTemporary_Isolation = new SingleRequestMock(200,
        'success',
        '{"header": {"status": "","service": "updatebap","response_id": "","request_id": "67eead60-7014-9410-25cc-ae20c0b8e5cd"},"body": {"data": {"bapID": "9294","userCreate": "kahfif@xl.co.id","typeOfRequest": "Isolasi Sementara","status": "Waiting IOM Approval","sirkit": "PT Lotte Data Communication Indonesia  Alam Sutera Serpong","requestDate": "2020-12-02","openIsolationDate": "2020-12-20","reason": "Kontrak berakhir atau tidak diperpanjang","picPosition": "IT Business Manager","picPhone": "+6281310626406","picEmail": "safruddin@lottedata.id","pic": "Safurddin","note": "XL support dibelakang Lintasartha","customer": "0017F00000RN1ZoQAL","cid": "02-04587","bandwidthUom": "Mbps","bandwidth": "2048","address": "Perumahan Alam Sutera Blok Sutera Niaga Kav. 2 Serpong Tangerang"}}}',
        null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_BAP_Isolation_Endpoint, updateBAPTemporary_Isolation);
		HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<BAP__c> bapList = [SELECT Id, BAP_ID__c, EDA__c, OwnerId, Type_of_Request__c, Isolation_End_Date__c, Sirkit__c, Isolation_Start_Date__c, Reason__c, PIC_Position__c, PIC_Phone__c, PIC_email__c, PIC_Name__c, Note__c, Customer__c, CID__c, UoM_rel__c, Bandwidth_rel__c, Address2__c FROM BAP__c];

        List<User> userList = [SELECT Email FROM User WHERE Id=:bapList[0].OwnerId];

        String recordId;
        String bapID;
        String userCreate;
        String typeOfRequest;
        String status;
        String sirkit;
        Date requestDateValue;
        String requestDate;
        Date openIsolationDateValue;
        String openIsolationDate;
        String reason;
        String picPosition;
        String picPhone;
        String picEmail;
        String pic;
        String note;
        String customer;
        String cid;
        String bandwidthUom;
        String bandwidth;
        String address;

        if(userList !=null && !userList.isEmpty()) {
            userCreate = userList[0].Email;
        }

        recordId = bapList[0].Id;
        bapID = bapList[0].BAP_ID__c;
        typeOfRequest = bapList[0].Type_of_Request__c;
        status = 'Waiting IOM Approval';
        sirkit = bapList[0].Sirkit__c;
        requestDateValue = bapList[0].Isolation_Start_Date__c;
        requestDate = requestDateValue.year() + '-' + requestDateValue.month() + '-' + requestDateValue.day();
        openIsolationDateValue = bapList[0].Isolation_End_Date__c;
        openIsolationDate = openIsolationDateValue.year() + '-' + openIsolationDateValue.month() + '-' + openIsolationDateValue.day();
        reason = bapList[0].Reason__c;
        picPosition = bapList[0].PIC_Position__c;
        picPhone = bapList[0].PIC_Phone__c;
        picEmail = bapList[0].PIC_email__c;
        pic = bapList[0].PIC_Name__c;
        note = bapList[0].Note__c;
        customer = bapList[0].Customer__c;
        cid = bapList[0].CID__c;
        bandwidthUom = bapList[0].UoM_rel__c;
        bandwidth = bapList[0].Bandwidth_rel__c;
        address = bapList[0].Address2__c;

        REST_BAP_Temp_Isolation_Callout_v1.updateBAPTemporary_Isolation(
            recordId,
            bapID,
            userCreate,
            typeOfRequest,
            status,
            sirkit,
            requestDate,
            openIsolationDate,
            reason,
            picPosition,
            picPhone,
            picEmail,
            pic,
            note,
            customer,
            cid,
            bandwidthUom,
            bandwidth,
            address
        );
    }

    @isTest
    static void test_UpdateStatusBAP_Temporary_Isolation(){
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock UpdateStatusBAP_Temporary_Isolation = new SingleRequestMock(200,
        'success',
        '{"header": {"status": "","service": "updatestatusbap","response_id": "","request_id": "1adc1847-7380-dc6c-71df-7b88771947a0"},"body": {"data": {"bapID": "9294","status": "BAP sent to Customer","edaNo": "1111111"}}}',
        null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_BAP_Isolation_Endpoint, UpdateStatusBAP_Temporary_Isolation);
		HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<BAP__c> bapList = [SELECT Id, BAP_ID__c, EDA__c, OwnerId, Type_of_Request__c, Isolation_End_Date__c, Sirkit__c, Isolation_Start_Date__c, Reason__c, PIC_Position__c, PIC_Phone__c, PIC_email__c, PIC_Name__c, Note__c, Customer__c, CID__c, UoM_rel__c, Bandwidth_rel__c, Address2__c FROM BAP__c];

        List<EDA__c> edaList = [SELECT Id, EDA_Number__c FROM EDA__c WHERE Id=:bapList[0].EDA__c];

        Id edaRecordId = edaList[0].Id;
        Id bapIDFromEda = bapList[0].Id;
        String bapID = bapList[0].BAP_ID__c;
        String status = 'BAP sent to Customer';
        String edaNo = edaList[0].EDA_Number__c;

        REST_BAP_Temp_Isolation_Callout_v1.UpdateStatusBAP_Temporary_Isolation(
            bapIDFromEda,
            bapID,
            status,
            edaNo
        );
    }

    @isTest
    static void test_Update_OpenTemporaryIsolationDate(){
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock Update_OpenTemporaryIsolationDate = new SingleRequestMock(200,
        'success',
        '{"header": {"status": "","service": " updateopendateisolation","response_id": "","request_id": "1adc1847-7380-dc6c-71df-7b88771947a0"},"body": {"data": {"bapID": "9294","openIsolationDate": "2020-12-15","edaNo": "1111111"}}}',
        null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_BAP_Isolation_Endpoint, Update_OpenTemporaryIsolationDate);
		HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<BAP__c> bapList = [SELECT Id, BAP_ID__c, EDA__c, OwnerId, Type_of_Request__c, Isolation_End_Date__c, Sirkit__c, Isolation_Start_Date__c, Reason__c, PIC_Position__c, PIC_Phone__c, PIC_email__c, PIC_Name__c, Note__c, Customer__c, CID__c, UoM_rel__c, Bandwidth_rel__c, Address2__c FROM BAP__c];

        List<EDA__c> edaList = [SELECT Id, EDA_Number__c FROM EDA__c WHERE Id=:bapList[0].EDA__c];

        Id recordId = bapList[0].Id;
        String bapID = bapList[0].BAP_ID__c;
        Date openIsolationDateValue = bapList[0].Isolation_End_Date__c;
        String openIsolationDate = openIsolationDateValue.year() + '-' + openIsolationDateValue.month() + '-' + openIsolationDateValue.day();
        String edaNo = edaList[0].EDA_Number__c;

        REST_BAP_Temp_Isolation_Callout_v1.Update_OpenTemporaryIsolationDate(
            recordId,
            bapID,
            openIsolationDate,
            edaNo
        );
    }

}