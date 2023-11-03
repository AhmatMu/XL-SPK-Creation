@isTest
public with sharing class REST_ObjectLease_Callout_Test {

    @TestSetup
    public static void makeData(){
        // create custom setting
        Easy_Ops_API_Setting__c getToken = new Easy_Ops_API_Setting__c();
        getToken.name           = 'getToken2';
        getToken.uri__c         = 'https://easy-ops.xl.co.id/dev/api';
        getToken.url__c         = '/auth/token';
        getToken.Username__c    = 'apidemo';
        getToken.Password__c    = 'Password*1';
        insert getToken;

        Easy_Ops_API_Setting__c sync_object_lease = new Easy_Ops_API_Setting__c();
        sync_object_lease.name          = 'sync_object_lease';
        sync_object_lease.uri__c        = 'https://easy-ops.xl.co.id/dev/api';
        sync_object_lease.url__c        = '/sync_object_lease';
        sync_object_lease.Username__c   = '';
        sync_object_lease.Password__c   = '';
        insert sync_object_lease;

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

        // create call log for handling test class
        Call_Log__c callLogReq = new Call_Log__c();
        callLogReq.Type__c                  = 'Callout';
        callLogReq.request_start_time__c    = null;
        callLogReq.method__c                = '';
        callLogReq.callerFrom__c            = '';
        callLogReq.endpoint__c              = '';
        callLogReq.uri__c                   = '';
        callLogReq.request_message__c       = '';
        callLogReq.status__c                = '';
        callLogReq.response_message__c      = '';
        callLogReq.Error_Message__c         = '';
        callLogReq.Request_ID__c            = '';
        callLogReq.response_end_time__c     = null;
        insert callLogReq;

        Object_Lease__c objLeaseCreationReq = new Object_Lease__c();
        objLeaseCreationReq.Name                    = 'Office Lease';
        objLeaseCreationReq.Object_Lease_Type__c    = 'COGS';
        objLeaseCreationReq.status__c               = 'Registered';
        objLeaseCreationReq.Object_Lease_Id__c      = '42dbaabb-42f3-4d87-991a-b21784d4c759';
        objLeaseCreationReq.is_Active__c            = true;
        objLeaseCreationReq.OwnerId                 = userReq.Id;

        MetadataTriggerHandler.bypass('TA_AT_ObjLeaseAftIns_CreateObjLeased');
        MetadataTriggerHandler.bypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
        insert objLeaseCreationReq;
    }

    static testmethod void objectLeaseCreation(){
        // get user record from make data
        User usr = [SELECT Id FROM User WHERE username = 'user****@gmail.com'];

        // generate mock
        SingleRequestMock getAccessToken = new SingleRequestMock(
            200,
            'success',
            '{"token":"2345678908765435467890"}',
            null
        );

        SingleRequestMock reqObjectLeaseCreation = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","name":"converter"}}',
            null
        );

        SingleRequestMock reqObjectLeaseUpdated = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","name":"Office Lease"}}}',
            null
        );

        Map<String, HttpCalloutMock> endpoint3TestResp = new Map<String, HttpCalloutMock>();
        endpoint3TestResp.put(Label.REST_EasyOps_GetToken_Endpoint, getAccessToken);
        endpoint3TestResp.put(Label.REST_EasyOps_ObjectLease_Endpoint, reqObjectLeaseCreation);
        endpoint3TestResp.put(Label.REST_EasyOps_ObjectLease_Endpoint, reqObjectLeaseUpdated);

        System.debug('=== endpoint3TestResp : ' + endpoint3TestResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint3TestResp);
        System.debug('=== multiCalloutMock : ' + multiCalloutMock);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();

        MetadataTriggerHandler.clearBypass('TA_AT_ObjLeaseAftIns_CreateObjLeased');
        MetadataTriggerHandler.clearBypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
        
        // create object lease
        Object_Lease__c objLeaseCreationReq = new Object_Lease__c();
        objLeaseCreationReq.Name                    = 'Office Lease';
        objLeaseCreationReq.Object_Lease_Type__c    = 'SITAC';
        objLeaseCreationReq.status__c               = 'Draft';
        objLeaseCreationReq.Object_Lease_Id__c      = '';
        objLeaseCreationReq.is_Active__c            = false;
        objLeaseCreationReq.OwnerId                 = usr.Id;

        insert objLeaseCreationReq;

        MetadataTriggerHandler.bypass('TA_AT_ObjLeaseAftIns_CreateObjLeased');
        MetadataTriggerHandler.bypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
        
        Test.stopTest();
    }

    static testmethod void objectLeaseUpdate(){
        // get object lease record from make data
        Object_Lease__c objectLeaseRec = [SELECT Id, Owner.Alias FROM Object_Lease__c WHERE Owner.Alias = 'userT'];

        // generate mock
        SingleRequestMock getAccessToken = new SingleRequestMock(
            200,
            'success',
            '{"token":"2345678908765435467890"}',
            null
        );

        SingleRequestMock reqObjectLeaseCreation = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","name":"converter"}}',
            null
        );

        SingleRequestMock reqObjectLeaseUpdated = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","name":"Office Lease"}}}',
            null
        );

        Map<String, HttpCalloutMock> endpoint3TestResp = new Map<String, HttpCalloutMock>();
        endpoint3TestResp.put(Label.REST_EasyOps_GetToken_Endpoint, getAccessToken);
        endpoint3TestResp.put(Label.REST_EasyOps_ObjectLease_Endpoint, reqObjectLeaseCreation);
        endpoint3TestResp.put(Label.REST_EasyOps_ObjectLease_Endpoint, reqObjectLeaseUpdated);

        System.debug('=== endpoint3TestResp : ' + endpoint3TestResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint3TestResp);
        System.debug('=== multiCalloutMock : ' + multiCalloutMock);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        Test.startTest();

        MetadataTriggerHandler.clearBypass('TA_AT_ObjLeaseAftIns_CreateObjLeased');
        MetadataTriggerHandler.clearBypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
        
        objectLeaseRec.Object_Lease_Type__c = 'SITAC';

        update objectLeaseRec;

        MetadataTriggerHandler.bypass('TA_AT_ObjLeaseAftIns_CreateObjLeased');
        MetadataTriggerHandler.bypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
        
        Test.stopTest();
    }
}