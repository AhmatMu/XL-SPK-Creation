@isTest
public with sharing class TA_AT_VendorAftUpd_UpdateVendorTest {
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

        // create vendor
        Vendor__c vendorReq = new Vendor__c();
        vendorReq.Name              = 'PT SRC Indonesia';
        vendorReq.VendorId__c       = '887766';
        vendorReq.listemail__c      = 'src1@gmail.com;src2@gmail.com;src3@gmail.com;';
        vendorReq.PIC__c            = 'src 1';
        vendorReq.type__c           = 'Vendor';
        vendorReq.Phone__c          = '08764678634';
        vendorReq.SPK_to_PMIS__c    = false;
        vendorReq.is_Active__c      = true;
        vendorReq.Address__c        = 'Jl. ketapang';
        vendorReq.OwnerId           = userReq.Id;

        MetadataTriggerHandler.bypass('TA_AT_VendorAftIns_CallToCreateVendor');
        insert vendorReq;
    }

    static testmethod void vendorTriggerUpdate() {
        Vendor__c vendorRec = [SELECT Id FROM Vendor__c WHERE Name = 'PT SRC Indonesia'];

        Test.startTest();
        vendorRec.PIC__c = 'src 2';

        update vendorRec;
        Test.stopTest();
    }
}