@isTest
public with sharing class REST_Vendor_Callout_Test {
    @TestSetup
    public static void makeData(){
        insert new Transaction__c(
            transactionID__c = 125,
            Temporary_LA_or_IDCom__c = 2499
        );
            
        // create custom setting
        Easy_Ops_API_Setting__c getToken = new Easy_Ops_API_Setting__c();
        getToken.name           = 'getToken2';
        getToken.uri__c         = 'https://easy-ops.xl.co.id/dev/api';
        getToken.url__c         = '/auth/token';
        getToken.Username__c    = 'apidemo';
        getToken.Password__c    = 'Password*1';
        insert getToken;

        Easy_Ops_API_Setting__c sync_partner = new Easy_Ops_API_Setting__c();
        sync_partner.name          = 'SyncPatner';
        sync_partner.uri__c        = 'https://easy-ops.xl.co.id/dev/api';
        sync_partner.url__c        = '/sync_partner';
        sync_partner.Username__c   = '';
        sync_partner.Password__c   = '';
        insert sync_partner;

        // create user
        User userReq = new User();
        userReq.FirstName           = 'user';
        userReq.LastName            = 'test';
        userReq.Email               = 'user****@gmail.com';
        userReq.Username            = 'user****@gmail.com';
        userReq.Alias               = 'userT';
        userReq.TimeZoneSidKey      = string.valueOf(UserInfo.getTimeZone());
        userReq.LocaleSidKey        = UserInfo.getLocale();
        userReq.EmailEncodingKey    = 'ISO-8859-1';
        userReq.LanguageLocaleKey   = UserInfo.getLanguage();
        userReq.ProfileId           = UserInfo.getProfileId();
        insert userReq;

        // create vendor
        Vendor__c vendorReq = new Vendor__c();
        vendorReq.Name              = 'PT SRC Indonesia';
        vendorReq.vendorId__c       = '887766';
        vendorReq.listemail__c      = 'src1@gmail.com;src2@gmail.com;src3@gmail.com;';
        vendorReq.PIC__c            = 'src 1';
        vendorReq.type__c           = 'Vendor';
        vendorReq.Phone__c          = '08764678634';
        vendorReq.SPK_to_PMIS__c    = false;
        vendorReq.is_Active__c      = true;
        vendorReq.Address__c        = 'Jl. ketapang';
        vendorReq.OwnerId           = userReq.Id;

        MetadataTriggerHandler.bypass('TA_AT_VendorAftIns_CallToCreateVendor');
        MetadataTriggerHandler.bypass('TA_AT_VendorAftUpd_CallToUpdateVendor');
        insert vendorReq;

        // create object lease
        Object_Lease__c objLeaseReq = new Object_Lease__c();
        objLeaseReq.name                    = 'Office Lease';
        objLeaseReq.Object_Lease_Type__c    = 'COGS';
        objLeaseReq.status__c               = 'Registered';
        objLeaseReq.is_Active__c            = true;

        MetadataTriggerHandler.bypass('TA_AT_ObjLeaseAftIns_CreateObjLeased');
        MetadataTriggerHandler.bypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
        insert objLeaseReq;

        // create vendor object lease
        Vendor_Object_Lease__c volReq = new Vendor_Object_Lease__c();
        volReq.Object_Lease__c  = objLeaseReq.Id;
        volReq.Vendor__c        = vendorReq.Id;
        volReq.Garansi_SLA__c   = 25;
        volReq.is_Active__c     = true;

        MetadataTriggerHandler.bypass('TA_AT_VendorObjLeasedAftIns_UpdateVendor');
        MetadataTriggerHandler.bypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');
        insert volReq;

        // create vendor spk type
        Vendor_SPK_Type__c spktReq = new VEndor_SPK_Type__c();
        spktReq.Vendor__c   = vendorReq.Id;
        spktReq.SPK_Type__c = 'Installation';
        spktReq.Need_PO__c  = true;

        MetadataTriggerHandler.bypass('TA_AT_VendorSPKTypeAftIns_UpdateVendor');
        MetadataTriggerHandler.bypass('TA_AT_VendorSPKTypeAftUpd_UpdateVendor');
        insert spktReq;
    }

    static testmethod void vendorCreation(){
        // get user record from make data
        user usr = [SELECT Id FROM user WHERE username = 'user****@gmail.com'];

        // generate mock
        SingleRequestMock getAccessToken = new SingleRequestMock(
            200,
            'success',
            '{"token":"2345678908765435467890"}',
            null
        );

        SingleRequestMock reqPartnerCreation = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","partner_id":"12345"}}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_EasyOps_GetToken_Endpoint, getAccessToken);
        endpoint2TestResp.put(label.REST_EasyOps_PartnerCreation_Endpoint, reqPartnerCreation);

        System.debug('=== endpoint2TestResp : ' + endpoint2TestResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        System.debug('=== multiCalloutMock : ' + multiCalloutMock);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();

        // create vendor
        Vendor__c vendorReq = new Vendor__c();
        vendorReq.Name              = 'PT SRC Indonesia';
        vendorReq.vendorId__c       = '887766';
        vendorReq.listemail__c      = 'src1@gmail.com;src2@gmail.com;src3@gmail.com;';
        vendorReq.PIC__c            = 'src 1';
        vendorReq.type__c           = 'Vendor';
        vendorReq.Phone__c          = '08764678634';
        vendorReq.SPK_to_PMIS__c    = false;
        vendorReq.is_Active__c      = true;
        vendorReq.Address__c        = 'Jl. ketapang';
        vendorReq.OwnerId           = usr.Id;

        MetadataTriggerHandler.clearBypass('TA_AT_VendorAftIns_CallToCreateVendor');
        MetadataTriggerHandler.clearBypass('TA_AT_VendorAftUpd_CallToUpdateVendor');

        insert vendorReq;

        MetadataTriggerHandler.bypass('TA_AT_VendorAftIns_CallToCreateVendor');
        MetadataTriggerHandler.bypass('TA_AT_VendorAftUpd_CallToUpdateVendor');

        Test.stopTest();
    }

    static testmethod void vendorUpdate(){
        // get vendor record from make data
        Vendor__c vendorRec = [SELECT Id, PIC__c, listemail__c FROM Vendor__c WHERE VendorId__c = '887766'];

        // generate mock
        SingleRequestMock getAccessToken = new SingleRequestMock(
            200,
            'success',
            '{"token":"2345678908765435467890"}',
            null
        );

        SingleRequestMock reqPartnerCreation = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","partner_id":"12345"}}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_EasyOps_GetToken_Endpoint, getAccessToken);
        endpoint2TestResp.put(label.REST_EasyOps_PartnerCreation_Endpoint, reqPartnerCreation);

        System.debug('=== endpoint2TestResp : ' + endpoint2TestResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        System.debug('=== multiCalloutMock : ' + multiCalloutMock);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();

        MetadataTriggerHandler.clearBypass('TA_AT_VendorAftUpd_CallToUpdateVendor');

        // update data and call trigger handler update vendor
        vendorRec.PIC__c        = 'src 2';
        vendorRec.listemail__c  = 'src1@gmail.com;src2@gmail.com;src3@gmail.com;src4@gmail.com;';

        update vendorRec;

        MetadataTriggerHandler.bypass('TA_AT_VendorAftUpd_CallToUpdateVendor');

        Test.stopTest();
    }

    static testmethod void vendorObjectLeaseUpdate(){
        // get vendor record from make data
        Vendor__c vendorRec = [SELECT Id, PIC__c, listemail__c FROM Vendor__c WHERE VendorId__c = '887766'];

        // get vendor object lease record from make data
        Vendor_Object_Lease__c volRec = [SELECT Id, Garansi_SLA__c FROM Vendor_Object_Lease__c WHERE Vendor__c =: vendorRec.Id];

        // generate mock
        SingleRequestMock getAccessToken = new SingleRequestMock(
            200,
            'success',
            '{"token":"2345678908765435467890"}',
            null
        );

        SingleRequestMock reqPartnerCreation = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","partner_id":"12345"}}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_EasyOps_GetToken_Endpoint, getAccessToken);
        endpoint2TestResp.put(label.REST_EasyOps_PartnerCreation_Endpoint, reqPartnerCreation);

        System.debug('=== endpoint2TestResp : ' + endpoint2TestResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        System.debug('=== multiCalloutMock : ' + multiCalloutMock);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();

        MetadataTriggerHandler.clearBypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');
        
        // update data and call trigger handler update vendor
        volRec.Garansi_SLA__c   = 30;
        
        update volRec;
        
        MetadataTriggerHandler.bypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');

        Test.stopTest();
    }

    static testmethod void vendorSPKTypeUpdate(){
        // get vendor record from make data
        Vendor__c vendorRec = [SELECT Id, PIC__c, listemail__c FROM Vendor__c WHERE VendorId__c = '887766'];

        // get vendor SPK Type record from make data
        Vendor_SPK_Type__c spktRec = [SELECT Id, SPK_Type__c, Need_PO__c FROM Vendor_SPK_Type__c WHERE Vendor__c =: vendorRec.Id];

        // generate mock
        SingleRequestMock getAccessToken = new SingleRequestMock(
            200,
            'success',
            '{"token":"2345678908765435467890"}',
            null
        );

        SingleRequestMock reqPartnerCreation = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","partner_id":"12345"}}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_EasyOps_GetToken_Endpoint, getAccessToken);
        endpoint2TestResp.put(label.REST_EasyOps_PartnerCreation_Endpoint, reqPartnerCreation);

        System.debug('=== endpoint2TestResp : ' + endpoint2TestResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        System.debug('=== multiCalloutMock : ' + multiCalloutMock);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();

        MetadataTriggerHandler.clearBypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');
        
        // update data and call trigger handler update vendor
        spktRec.SPK_Type__c   = 'Relocation';
        spktRec.Need_PO__c    = false;
        
        update spktRec;
        
        MetadataTriggerHandler.bypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');

        Test.stopTest();
    }
}