@isTest
public with sharing class TA_AT_VendorObjLeaseAftUpd_UpdVendrTest {
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

        // create object lease
        Object_Lease__c objLeaseReq = new Object_Lease__c();
        objLeaseReq.Name                    = 'Office Lease';
        objLeaseReq.Object_Lease_Type__c    = 'COGS';
        objLeaseReq.status__c               = 'Draft';
        objLeaseReq.Object_Lease_Id__c      = '';
        objLeaseReq.is_Active__c            = true;
        objLeaseReq.OwnerId                 = userReq.Id;

        MetadataTriggerHandler.bypass('TA_AT_ObjLeaseAftIns_CreateObjLeased');
        insert objLeaseReq;
        
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

        // create vendor object lease
        Vendor_Object_Lease__c volReq = new Vendor_Object_Lease__c();
        volReq.Object_Lease__c  = objLeaseReq.Id;
        volReq.Vendor__c        = vendorReq.Id;
        volReq.Garansi_SLA__c   = 25;
        volReq.is_Active__c     = true;
        volReq.OwnerId          = userReq.Id;

        MetadataTriggerHandler.bypass('TA_AT_VendorObjLeasedAftIns_UpdateVendor');
        insert volReq;
    }

    static testmethod void vendorObjLeaseTriggerUpdate(){
        Vendor_Object_Lease__c volRec = [SELECT Id FROM Vendor_Object_Lease__c WHERE Vendor__r.Name = 'PT SRC Indonesia'];

        Test.startTest();
        volRec.Garansi_SLA__c = 30;

        update volRec;
        Test.stopTest();
    }
}