@isTest
public with sharing class TA_AT_ObjLeaseAftIns_CreateObjLeasedTest {
    static testmethod void objLeaseTriggerCreate(){
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
        objLeaseCreationReq.status__c               = 'Draft';
        objLeaseCreationReq.Object_Lease_Id__c      = '';
        objLeaseCreationReq.is_Active__c            = true;
        objLeaseCreationReq.OwnerId                 = userReq.Id;

        Test.startTest();
        insert objLeaseCreationReq;
        Test.stopTest();
    }
}