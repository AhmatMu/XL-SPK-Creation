/*-----------------------------------------------------------------------------------------------------------//
* Class Name	: TA_AT_AccountCollectionRatioSetBPAccTest
* Author		: ahmat zulkifli murad <ahmat.murad@saasten.com>
* Date			: 10 / 09 / 2022
* Description	: Description of the class
*
* Changes (version)
* -------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	-----------------------------------
* @version		1.0		2022-09-10		ahmat zulkifli murad	Created
* 
*-----------------------------------------------------------------------------------------------------------*/
@isTest
public class TA_AT_AccountCollectionRatioSetBPAccTest {

    @testSetup 
    static void RecordData(){

        Profile salesProfile = [SELECT id FROM Profile WHERE name = 'Sales' limit 1];
        
        
        User salesUser = new User(
            //UserRoleId = Role.Id,                                                  // Role
            Alias = 'Annisa', // Alias
            Email = 'annisas@xl.co.id', // Email
            ProfileId = salesProfile.id, // Profile
            Username = 'annisas@xl.co.id.TEST', // Username
            IsActive = true, // Active
            CommunityNickname = 'AnnisaTEST', // Nickname
            lastName = 'AnnisaTEST',
            UserPermissionsMarketingUser = true, // Marketing User
            Title = 'Account Manager Direct Sales and Events', // Title
            UserPermissionsOfflineUser = false, // Offline User
            Department = 'XL Business Solutions', // Department
            UserPermissionsKnowledgeUser = false, // Knowledge User
            UserPermissionsInteractionUser = true, // Flow User
            UserPermissionsSupportUser = false, // Service Cloud User
            TimeZoneSidKey = 'Asia/Jakarta', // Time Zone
            UserPermissionsLiveAgentUser = false, // Chat User
            LocaleSidKey = 'in_ID', // Locale
            LanguageLocaleKey = 'en_US', // Language
            //ManagerId = '0057F000002eQqQ',                                               // Manager
            ForecastEnabled = false, // Allow Forecasting
            MobilePhone = '081953119000', // Mobile
            EmailEncodingKey = 'ISO-8859-1', // Email Encoding
            Employee_ID__c = '90007498', // Employee ID
            //Sales_Group_Head__c = '0057F000005Tvn5',                                     // Sales Group Head
            Grade__c = '15', // Grade
            Employee_Category__c = 'Existing Employee' // Employee Category
        );
        insert salesUser;
        

        
        Id accountBPRecTypeId  = Schema.SObjectType.account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account accParentRec = new Account(
            Name = 'ACCURATE DIGITAL PARTNER',                 // Account Name
            //OwnerId = salesUser.id,
            RecordTypeId = accountBPRecTypeId,                          // Account Record Type
            BP_Number__c = '760701',                             // BP Number
            Organization_Type__c = 'Head Office',                // Organization Type
            Type = 'Customer',                                   // Type
            Unique_Name__c = 'Accurate Digital',                 // Unique Name
            Keyword__c = 'Partner Event',                        // Keyword
            Customer_Type__c = 'NONGSM',                         // Customer Type
            Industry = 'Media',                                  // Industry
            Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
            Is_New_Customer__c = false,                          // Is New Customer
            Kwitansi__c = false,                                 // Kwitansi
            Faktur_Pajak__c = false,                             // Faktur Pajak
            Summary_Billing__c = false,                          // Summary Billing
            summary_invoice__c = false,                          // summary invoice
            Approval_Status__c = 'Approved',                     // Approval Status
            Using_HO_Billing_Address__c = false                 // Using HO Billing Address
        );
        insert accParentRec; 

        Account accChildRecord = new Account(
            Name = 'Abhinawa Sumberdaya Asia',                 // Account Name
            //OwnerId = salesUser.id,
            RecordTypeId = accountBPRecTypeId,                          // Account Record Type
            BP_Number__c = '763440',                             // BP Number
            Organization_Type__c = 'Branch',                     // Organization Type
            ParentId = accParentRec.id,                              // Parent Account
            Type = 'Customer',                                   // Type
            Unique_Name__c = 'Abhinawa Cyber 1',                 // Unique Name
            Keyword__c = 'ABHINAWA',                             // Keyword
            Customer_Type__c = 'NONGSM',                         // Customer Type
            Industry = 'Telecommunications',                     // Industry
            Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
            Is_New_Customer__c = false,                          // Is New Customer
            Kwitansi__c = false,                                 // Kwitansi
            Faktur_Pajak__c = false,                             // Faktur Pajak
            Summary_Billing__c = false,                          // Summary Billing
            summary_invoice__c = false,                          // summary invoice
            Approval_Status__c = 'Approved',                     // Approval Status
            Using_HO_Billing_Address__c = false                 // Using HO Billing Address
        );
        insert accChildRecord;

        Transaction__c settings = new Transaction__c();
        settings.transactionID__c = 68756;
        settings.Temporary_LA_or_IDCom__c = 2499;

        insert settings;
        
    }

    @isTest
    static void setBPaccountLookupHO(){

    account accHO = [select id from account where bp_number__c = '760701' limit 1];
    account accBP = [select id from account where bp_number__c = '763440' limit 1];
    
    Account_Collection_Ratio__c accountCollectionRatioRec = new Account_Collection_Ratio__c(
        Aging_AR__c = 1,                                    // Aging AR
        BP_Invoice_LA_Number__c = '760701',                   // BP Invoice / LA Number
        Invoice_Period__c = Date.newInstance(2122, 4, 1),           // Invoice Period
        Sales_Employee_Id__c = '90007807',                      // Sales Employee Id
        Invoice_Amount__c = 450.000,                            // Invoice Amount
        Overall_Collection_Date__c = Date.newInstance(2122, 4, 1),  // Overall Collection Date
        On_Time_Collection_Date__c = Date.newInstance(2122, 4, 1),  // On Time Collection Date
        Overall_Payment__c = 450.000,                           // Overall Payment
        On_Time_Payment__c = 400.000,                           // On Time Payment
        External_Id__c = 'ACR_202204_760701'                   // External Id
        );
        
        test.startTest();
        insert accountCollectionRatioRec;
        test.stopTest();
        system.debug(' >> accountCollectionRatioRec << ' + accountCollectionRatioRec);
    }

    @isTest
    static void setBPaccountLookupBranch(){
    
        Account_Collection_Ratio__c accountCollectionRatioRec = new Account_Collection_Ratio__c(
            Aging_AR__c = 1,                                    // Aging AR
            BP_Invoice_LA_Number__c = '763440',                   // BP Invoice / LA Number
            Invoice_Period__c = Date.newInstance(2122, 4, 1),           // Invoice Period
            Sales_Employee_Id__c = '90007807',                      // Sales Employee Id
            Invoice_Amount__c = 450.000,                            // Invoice Amount
            Overall_Collection_Date__c = Date.newInstance(2122, 4, 1),  // Overall Collection Date
            On_Time_Collection_Date__c = Date.newInstance(2122, 4, 1),  // On Time Collection Date
            Overall_Payment__c = 450.000,                           // Overall Payment
            On_Time_Payment__c = 400.000,                           // On Time Payment
            External_Id__c = 'ACR_202204_763440'                   // External Id
            );

            test.startTest();
            
            insert accountCollectionRatioRec;

            test.stopTest();
            system.debug(' >> accountCollectionRatioRec << ' + accountCollectionRatioRec);

        }
}