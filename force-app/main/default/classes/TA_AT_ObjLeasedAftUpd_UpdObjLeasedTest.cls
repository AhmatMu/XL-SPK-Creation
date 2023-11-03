@isTest
public with sharing class TA_AT_ObjLeasedAftUpd_UpdObjLeasedTest {
    @TestSetup
    static void makeData(){
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
    
        Object_Lease__c objLeaseCreationReq = new Object_Lease__c();
        objLeaseCreationReq.Name                    = 'Office Lease';
        objLeaseCreationReq.Object_Lease_Type__c    = 'COGS';
        objLeaseCreationReq.status__c               = 'Registered';
        objLeaseCreationReq.Object_Lease_Id__c      = '42dbaabb-42f3-4d87-991a-b21784d4c759';
        objLeaseCreationReq.is_Active__c            = true;
        objLeaseCreationReq.OwnerId                 = userReq.Id;

        MetadataTriggerHandler.bypass('TA_AT_ObjLeaseAftIns_CreateObjLeased');
        insert objLeaseCreationReq;
    }   

    static testmethod void objLeaseTriggerUpdated() {
        Object_Lease__c objLeaseRec = [SELECT Id FROM Object_Lease__c WHERE Object_Lease_Id__c = '42dbaabb-42f3-4d87-991a-b21784d4c759'];
        System.debug('=== objLeaseRec : ' + objLeaseRec);

        Test.startTest();
        objLeaseRec.Object_Lease_Type__c = 'SITAC';

        update objLeaseRec;
        Test.stopTest();
    }
}