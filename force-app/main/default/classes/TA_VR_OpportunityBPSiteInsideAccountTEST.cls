/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 08-08-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
@isTest
public with sharing class TA_VR_OpportunityBPSiteInsideAccountTEST {
    static testMethod void updateOppBPPayer(){

       insert new Transaction__c(transactionID__c = 1);
       Circuit__c circuitRec = new Circuit__c(
           Name = '23456' // CID
       );
       
       insert circuitRec;
       insert New SR_PR__c(SR_Number__c = 1, PR_Number__c = 1);
       
       insert New Link_CID__c(
            Name = 'X',
            CID_APN__c = 1, 
            CID_ISP__c = 1, 
            CID_LL__c = 1, 
            CID_MDS__c = 1, 
            CID_MPLS__c = 1, 
            CID_NAP__c = 1, 
            CID_VOIP__c = 1, 
            CID_CL__c = 1, 
            CID_FLEET__c = 1, 
            CID_IAAS__c = 1, 
            CID_ISPHRB__c = 1, 
            CID_ISPUPTO__c = 1, 
            CID_L2VPN__c = 1, 
            CID_MCA__c = 1, 
            CID_NAPMIX__c = 1, 
            CID_SSLVPN__c = 1, 
            CID_VLL__c = 1, 
            CID_ISPFTTX__c = 1, 
            CID_VPLS__c = 1, 
            CID_GSMPBX__c = 1, 
            CID_HPABX__c = 1, 
            CID_SMSB__c = 1, 
            CID_WEB2SMS__c = 1, 
            CID_MPLSWAN__c = 1, 
            CID_NAPXLIX__c = 1, 
            CID_ISPPROMO__c = 1, 
            CID_VCON__c = 1, 
            CID_4G_Access__c = 1, 
            CID_4GACCESS__c = 1, 
            CID_TELINS__c = 1, 
            CID_SDWAN__c = 1, 
            CID_SMART__c = 1, 
            CID_DIRECTPEERING__c = 1, 
            CID_MNCPE__c = 1
        );

       
       
       ID accountHORT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
       
       Profile salesProfile = [SELECT id FROM Profile WHERE name = 'Sales'];
       Profile solutionProfile  = [SELECT id FROM Profile WHERE name = 'Solution'];
       Profile projectCoordinatorProfile  = [SELECT id FROM Profile WHERE name = 'Project Coordinator'];
       Profile salesAdminProfile  = [SELECT id FROM Profile WHERE name = 'Sales Admin'];
       
       
       User salesUser = new User(
           
           Alias = 'Annisa',                                                            // Alias
           Email = 'annisas@xl.co.id',                                                  // Email
           ProfileId = salesProfile.id,                                                     // Profile
           Username = 'annisas@xl.co.id.TEST',                                               // Username
           IsActive = true,                                                             // Active
           CommunityNickname = 'AnnisaTEST',  // Nickname
           lastName  = 'AnnisaTEST',
           UserPermissionsMarketingUser = true,                                         // Marketing User
           Title = 'Account Manager Direct Sales and Events',                           // Title
           UserPermissionsOfflineUser = false,                                          // Offline User
           Department = 'XL Business Solutions',                                        // Department
           UserPermissionsKnowledgeUser = false,                                        // Knowledge User
           UserPermissionsInteractionUser = true,                                       // Flow User
           UserPermissionsSupportUser = false,                                          // Service Cloud User
           TimeZoneSidKey = 'Asia/Jakarta',        // Time Zone
           UserPermissionsLiveAgentUser = false,                                        // Chat User
           LocaleSidKey = 'in_ID',                                     // Locale
           LanguageLocaleKey = 'en_US',                                               // Language
           ForecastEnabled = false,                                                     // Allow Forecasting
           MobilePhone = '081953119000',                                                // Mobile
           EmailEncodingKey = 'ISO-8859-1',  // Email Encoding
           Employee_ID__c = '90007498',                                                 // Employee ID
           Grade__c = '15',                                                             // Grade
           Employee_Category__c = 'Existing Employee'                                  // Employee Category
       );
       insert salesUser;
       
       User solutionUser = new User(
           Alias = 'Muhid',                                                             // Alias
           Email = 'muhida@xl.co.id',                                                   // Email
           ProfileId = solutionProfile.Id,                                                     // Profile
           Username = 'muhida@xl.co.id.TEST',                                                // Username
           IsActive = true,                                                             // Active
           CommunityNickname = 'MuhidTEST',   // Nickname
           lastName  = 'MuhidTEST',
           UserPermissionsMarketingUser = false,                                        // Marketing User
           UserPermissionsOfflineUser = false,                                          // Offline User
           Department = 'XL Business Solutions',                                        // Department
           UserPermissionsKnowledgeUser = false,                                        // Knowledge User
           UserPermissionsInteractionUser = false,                                      // Flow User
           UserPermissionsSupportUser = false,                                          // Service Cloud User
           TimeZoneSidKey = 'Asia/Jakarta',        // Time Zone
           UserPermissionsLiveAgentUser = false,                                        // Chat User
           LocaleSidKey = 'in_ID',                                     // Locale
           LanguageLocaleKey = 'en_US',                                               // Language
           ForecastEnabled = false,                                                     // Allow Forecasting
           MobilePhone = '+62 87779770777',                                             // Mobile
           EmailEncodingKey = 'ISO-8859-1',  // Email Encoding
           Employee_ID__c = '90004892'                                                 // Employee ID
       );
       insert solutionUser;
       
       User projectCoordinatorUser = new User(
           //UserRoleId = 'undefined',                                                  // Role
           Alias = 'nancy',                                                             // Alias
           Email = 'nancycitranigrum@xl.co.id',                                                   // Email
           ProfileId = projectCoordinatorProfile.Id,                                                     // Profile
           Username = 'nancycitranigrum@xl.co.id.TEST',                                                // Username
           IsActive = true,                                                             // Active
           CommunityNickname = 'nancyTEST',   // Nickname
           lastName  = 'Nancy Citranigrum',
           UserPermissionsMarketingUser = false,                                        // Marketing User
           UserPermissionsOfflineUser = false,                                          // Offline User
           Department = 'XL Business Solutions',                                        // Department
           UserPermissionsKnowledgeUser = false,                                        // Knowledge User
           UserPermissionsInteractionUser = false,                                      // Flow User
           UserPermissionsSupportUser = false,                                          // Service Cloud User
           TimeZoneSidKey = 'Asia/Jakarta',        // Time Zone
           UserPermissionsLiveAgentUser = false,                                        // Chat User
           LocaleSidKey = 'in_ID',                                     // Locale
           LanguageLocaleKey = 'en_US',                                               // Language
           ForecastEnabled = false,                                                     // Allow Forecasting
           MobilePhone = '+62 87779770777',                                             // Mobile
           EmailEncodingKey = 'ISO-8859-1',  // Email Encoding
           Employee_ID__c = '90006544'                                                 // Employee ID
       );
       insert projectCoordinatorUser;
       
       User salesAdminUser = new User(
           Alias = 'sadmin',                                                             // Alias
           Email = 'salesadmin@xl.co.id',                                                   // Email
           ProfileId = salesAdminProfile.Id,                                                     // Profile
           Username = 'salesadminTEST@xl.co.id.TEST',                                                // Username
           IsActive = true,                                                             // Active
           CommunityNickname = 'salesadminTEST',   // Nickname
           lastName  = 'salesadminTEST',
           UserPermissionsMarketingUser = false,                                        // Marketing User
           UserPermissionsOfflineUser = false,                                          // Offline User
           Department = 'XL Business Solutions',                                        // Department
           UserPermissionsKnowledgeUser = false,                                        // Knowledge User
           UserPermissionsInteractionUser = false,                                      // Flow User
           UserPermissionsSupportUser = false,                                          // Service Cloud User
           TimeZoneSidKey = 'Asia/Jakarta',        // Time Zone
           UserPermissionsLiveAgentUser = false,                                        // Chat User
           LocaleSidKey = 'in_ID',                                     // Locale
           LanguageLocaleKey = 'en_US',                                               // Language
           ForecastEnabled = false,                                                     // Allow Forecasting
           MobilePhone = '+62 87779770777',                                             // Mobile
           EmailEncodingKey = 'ISO-8859-1',  // Email Encoding
           Employee_ID__c = '90006544'                                                 // Employee ID
       );
       insert salesAdminUser;
       
       AM_Portfolio_Mapping__c amPortofolioMappingREC = new AM_Portfolio_Mapping__c(
           AM__c = salesUser.id,                          // AM
           Portfolio_Management_Support__c = solutionUser.id,  // Portfolio Management Support
           Status__c = 'Active'                           // Status
       );
       insert amPortofolioMappingREC;
       
       Account accRec = new Account(
           Name = 'PT Khazanah Media Network Nusantara TEST',                // Account Name
           RecordTypeId = accountHORT,                                    // Account Record Type
           BP_Number__c = '763278',                                       // BP Number
           Organization_Type__c = 'Head Office',                          // Organization Type
           Type = 'Customer',                                             // Type
           Unique_Name__c = 'Kapuas',                                     // Unique Name
           Customer_Type__c = 'NONGSM',                                   // Customer Type
           Industry = 'Telecommunications',                               // Industry
           Payer_For_GSM_Invoice__c = false,                              // Payer For GSM Invoice
           term_of_payment__c = 'Z030 Within 30 Days Due Net',            // Term of Payment
           Customer_VAT_Name__c = 'PT Khazanah Media Network Nusantara',  // Customer VAT Name
           Is_New_Customer__c = false,                                    // Is New Customer
           Kwitansi__c = false,                                           // Kwitansi
           Faktur_Pajak__c = false,                                       // Faktur Pajak
           summary_invoice__c = false,                                    // Summary Invoice
           Summary_Billing__c = false,                                    // Summary Billing
           Approval_Status__c = 'Approved',                               // Approval Status
           Using_HO_Billing_Address__c = false,                           // Using HO Billing Address
           No_NPWP__c = '723434791711000',                                // No NPWP
           Relocation_Street_1__c = 'reloc ke suatu tempat',
           ShippingStreet = 'dsdsdsds',
           Billing_Address_Province__c = 'jawa tengah',   
           Billing_Address_City__c = 'kota surakarta',
           Shipping_Address_Province__c = 'jawa tengah',
           Shipping_Address_City__c = 'kota surakarta'
       );
       insert accRec;
       accRec.OwnerId = salesUser.id;
       update  accRec;

       Account accRec2 = new Account(
        Name = 'PT Bajing loncat TEST',                // Account Name
        RecordTypeId = accountHORT,                                    // Account Record Type
        BP_Number__c = '763279',                                       // BP Number
        Organization_Type__c = 'Head Office',                          // Organization Type
        Type = 'Customer',                                             // Type
        Unique_Name__c = 'Kapuas',                                     // Unique Name
        Customer_Type__c = 'NONGSM',                                   // Customer Type
        Industry = 'Telecommunications',                               // Industry
        Payer_For_GSM_Invoice__c = false,                              // Payer For GSM Invoice
        term_of_payment__c = 'Z030 Within 30 Days Due Net',            // Term of Payment
        Customer_VAT_Name__c = 'PT Khazanah Media Network Nusantara',  // Customer VAT Name
        Is_New_Customer__c = false,                                    // Is New Customer
        Kwitansi__c = false,                                           // Kwitansi
        Faktur_Pajak__c = false,                                       // Faktur Pajak
        summary_invoice__c = false,                                    // Summary Invoice
        Summary_Billing__c = false,                                    // Summary Billing
        Approval_Status__c = 'Approved',                               // Approval Status
        Using_HO_Billing_Address__c = false,                           // Using HO Billing Address
        No_NPWP__c = '723434781711000',                                // No NPWP
        Relocation_Street_1__c = 'reloc ke suatu tempat',
        ShippingStreet = 'dsdsdsds',
        Billing_Address_Province__c = 'jawa tengah',   
        Billing_Address_City__c = 'kota surakarta',
        Shipping_Address_Province__c = 'jawa tengah',
        Shipping_Address_City__c = 'kota surakarta'
            
       );
       insert accRec2;
       accRec2.OwnerId = salesUser.id;
       update  accRec2;
       
       Contact contact1REC = new Contact(
           AccountId = accRec.id,                  // Account Name
           Email = 'mr.bagus.khairuzzaman@gmail.com.invalid',  // Email
           MobilePhone = '085286136041',               // Mobile
           lastName = 'Bagus'
       );
       insert contact1REC;

    Account accChild = new Account(
        Name = 'PT Bajing loncat TEST',                // Account Name
        RecordTypeId = accountHORT,                                    // Account Record Type
        parentId = accRec.id,
        BP_Number__c = '763279',                                       // BP Number
        Organization_Type__c = 'Branch',                          // Organization Type
        Type = 'Customer',                                             // Type
        Unique_Name__c = 'Kapuas',                                     // Unique Name
        Customer_Type__c = 'NONGSM',                                   // Customer Type
        Industry = 'Telecommunications',                               // Industry
        Payer_For_GSM_Invoice__c = false,                              // Payer For GSM Invoice
        term_of_payment__c = 'Z030 Within 30 Days Due Net',            // Term of Payment
        Customer_VAT_Name__c = 'PT Khazanah Media Network Nusantara',  // Customer VAT Name
        Is_New_Customer__c = false,                                    // Is New Customer
        Kwitansi__c = false,                                           // Kwitansi
        Faktur_Pajak__c = false,                                       // Faktur Pajak
        summary_invoice__c = false,                                    // Summary Invoice
        Summary_Billing__c = false,                                    // Summary Billing
        Approval_Status__c = 'Approved',                               // Approval Status
        Using_HO_Billing_Address__c = false,                           // Using HO Billing Address
        No_NPWP__c = '723434781711000',                                // No NPWP
        Relocation_Street_1__c = 'reloc ke suatu tempat',
        ShippingStreet = 'dsdsdsds',
        Billing_Address_Province__c = 'jawa tengah',   
        Billing_Address_City__c = 'kota surakarta',
        Shipping_Address_Province__c = 'jawa tengah',
        Shipping_Address_City__c = 'kota surakarta'
    );
    insert accChild;
    accChild.OwnerId = salesUser.id;

    update accChild;

    Account accChild1 = new Account(
        Name = 'PT Bajing loncat TEST1',                // Account Name
        RecordTypeId = accountHORT,                                    // Account Record Type
        parentId = accRec.id,
        BP_Number__c = '763279',                                       // BP Number
        Organization_Type__c = 'Branch',                          // Organization Type
        Type = 'Customer',                                             // Type
        Unique_Name__c = 'Kapuas',                                     // Unique Name
        Customer_Type__c = 'NONGSM',                                   // Customer Type
        Industry = 'Telecommunications',                               // Industry
        Payer_For_GSM_Invoice__c = false,                              // Payer For GSM Invoice
        term_of_payment__c = 'Z030 Within 30 Days Due Net',            // Term of Payment
        Customer_VAT_Name__c = 'PT Khazanah Media Network Nusantara',  // Customer VAT Name
        Is_New_Customer__c = false,                                    // Is New Customer
        Kwitansi__c = false,                                           // Kwitansi
        Faktur_Pajak__c = false,                                       // Faktur Pajak
        summary_invoice__c = false,                                    // Summary Invoice
        Summary_Billing__c = false,                                    // Summary Billing
        Approval_Status__c = 'Approved',                               // Approval Status
        Using_HO_Billing_Address__c = false,                           // Using HO Billing Address
        No_NPWP__c = '723434781711000',                                // No NPWP
        Relocation_Street_1__c = 'reloc ke suatu tempat',
        ShippingStreet = 'dsdsdsds',
        Billing_Address_Province__c = 'jawa tengah',   
        Billing_Address_City__c = 'kota surakarta',
        Shipping_Address_Province__c = 'jawa tengah',
        Shipping_Address_City__c = 'kota surakarta'
    );
    insert accChild1;
    accChild1.OwnerId = salesUser.id;

    update accChild1;
       
       
       Contact contact2REC = new Contact(
           AccountId = accRec.id,                  // Account Name
           Email = 'good.boy@gmail.com.invalid',  // Email
           MobilePhone = '085286111111',               // Mobile
           lastName = 'Goodboy'
       );
       insert contact2REC;
       
       AccountContactRelation acr1REC = [SELECT id, roles FROM AccountContactRelation WHERE contactId = :contact1REC.id];
       acr1REC.roles = 'PIC Recipient Invoice;PIC BA Print;PIC BA Recipient;PIC Site;PIC Print Invoice';
       update acr1REC;
       
       AccountContactRelation acr2REC = [SELECT id, roles FROM AccountContactRelation WHERE contactId = :contact2REC.id];
       acr2REC.roles = 'PIC Recipient Invoice;PIC BA Recipient;PIC Site;PIC Print Invoice';
       update acr2REC;
       
       
       AccountContactRelation acr3REC = [SELECT id, roles FROM AccountContactRelation WHERE contactId = :contact2REC.id];
       acr3REC.roles = 'PIC Recipient Invoice;PIC BA Recipient;PIC Site;PIC Print Invoice';
       update acr3REC;
        
       //-- Create CONTRACT ----
       Contract contractItemREC = new Contract(
           Name = 'Contract TEST',        // Contract Name
           Last_Transaction_ID__c = 'CI0395532',                              // Last Transaction ID
           Full_Name__c = 'Contract: TEST',  // Full Name
           Accountid = accRec.id, 
           Account_BP_Payer__c = accRec.id,                           // Account BP Payer
           Start_Date__c = Date.valueOf('2021-02-11'),                        // Start Date
           End_Date__c = Date.valueOf('2021-11-30'),                          // End Date
           Account_BP_VAT__c = accRec.id,                             // Account BP VAT
           Billing_Type__c = 'Monthly',                                       // Billing Type
           Price__c = 636356,                                              // Price
           Contract_ID__c = '3002482',                                        // Contract ID
           Quantity__c = 1,                                                 // Quantity
           SAP_ID__c = '37',                                                  // Contract Item
           Extension_Created__c = false,                                      // Extension Created
           Product_SAP_Code__c = 'PWFH-01',                                   // Product SAP Code
           Product_Charge_Type_filled__c = 'One Time',                        // Product Charge Type
           Status = 'Draft',                                                 // Status
           Auto_Renewal__c = false,                                           // Auto Renewal
           Active__c = true,                                                  // Active
           //Opportunity__c = '0067F000011Rcny',                                // Opportunity
           Project_Type__c = 'NEW',                                           // Project Type
           Bandwidth_filled__c = 000,                                      // Bandwidth
           Contract_Term__c = 12
       );
       insert contractItemREC;
       
       contractItemREC.status = 'Active';
       update contractItemREC;
       
       Link__c link1REC = new Link__c(
           Company_Name__c = 'CV. LINTASSEMESTA BERTUAH RAYA',   // Company Name
           Capacity_Bandwidth__c = '30',                           // Capacity Bandwidth
           Name = '12-00165',                                      // CID/Link ID
           UoM__c = 'Mbps',                                        // UoM
           Link_ID__c = '020C7849L1_TEST',                              // Link ID
           Partner__c = false,                                     // Partner
           Status_Link__c = 'UNDER_PROJECT',                       // Status Link
           Service_Type__c = 'L2VPN',                              // Service Type
           Routepath__c = '762675 CV Lintas Semesta Bertua Raya ..',  // Routepath
           Site_A_Name__c = accRec.id,                           // Site A Name
           Site_B_Name__c = null,                           // Site B Name
           BP_Site_A__c = '762675',                                // BP Site A
           BP_Site_B__c = '762676',                                // BP Site B
           Contract_Item__c = '3002592-1',                         // Contract Item
           Contract_Item_Rel__c = contractItemREC.id,                     // Contract Item Rel
           Free_Link__c = false,                                   // Free Link
           ID__c = '24514',                                        // ID
           CID__c = '12-00165',                                    // CID *
           BU__c = 'ENTERPRISE',                                   // BU
           CID_RelD__c = null                              // CID RelD
       );
       insert link1REC;
       
       Link__c link2REC = new Link__c(
           Company_Name__c = 'CV. LINTASSEMESTA BERTUAH RAYA',   // Company Name
           Capacity_Bandwidth__c = '30',                           // Capacity Bandwidth
           Name = '12-999999',                                      // CID/Link ID
           UoM__c = 'Mbps',                                        // UoM
           Link_ID__c = '99999999_TEST2',                              // Link ID
           Partner__c = false,                                     // Partner
           Status_Link__c = 'UNDER_PROJECT',                       // Status Link
           Service_Type__c = 'L2VPN',                              // Service Type
           Routepath__c = '762675 CV Lintas Semesta Bertua Raya ..',  // Routepath
           Site_A_Name__c = accRec.id,                           // Site A Name
           Site_B_Name__c = null,                           // Site B Name
           BP_Site_A__c = '762675',                                // BP Site A
           BP_Site_B__c = '762676',                                // BP Site B
           Contract_Item__c = '3002592-1',                         // Contract Item
           Contract_Item_Rel__c = contractItemREC.id,                     // Contract Item Rel
           Free_Link__c = false,                                   // Free Link
           ID__c = '24514',                                        // ID
           CID__c = '12-00165',                                    // CID *
           BU__c = 'ENTERPRISE',                                   // BU
           CID_RelD__c = null                              // CID RelD
       );
       insert link2REC;
       
       //-- create Group Service
       Group_Service__c groupService1REC = new Group_Service__c(
           Name = 'FIXED',                  // Group Service Name
           Unique_ID__c = 'FIXED',            // Unique ID
           Type__c = 'BAU',                   // Type
           Search_Term__c = 'Group Service'  // Search Term
       );
       insert groupService1REC;
       
       //-- PRICEBOOK & Product
       PricebookEntry pbEntrySTDREC = new PricebookEntry();
       
       Pricebook2 leasedLinePriceBookREC = new Pricebook2(
           Name = 'Leased_Line',        // Price Book Name
           Service_Group__c = 'Non-GSM',  // Service Group
           IsActive = true,               // Active
           IsAgreement__c = false        // IsAgreement
           
       );
       insert leasedLinePriceBookREC;
       
       //Instantiate the Pricebook2 record with StandardPricebookId
       Pricebook2 standardPricebookREC = new Pricebook2(
           Id = Test.getStandardPricebookId(),
           IsActive = true
       );
       //Execute an update DML on the Pricebook2 record, to make IsStandard to true
       Update standardPricebookREC;
       
       Product2 productLL1REC = new Product2(
           Name = 'L2VPN 500 Mbps TEST',             // Product Name
           Group_Service__c = groupService1REC.id,  // Group Service
           Bandwidth__c = 500,                  // Bandwidth
           Family = 'Non-GSM',                       // Product Family
           UoM_Bandwidth__c = 'Mbps',             // UoM Bandwidth
           IsActive = false,                      // Active
           SAP_Code__c = 'L2VPN-02',              // SAP Code
           Product_Code2__c = 'L2VPN',            // Product Code
           Revenue_Type__c = 'Recurring',         // Charge Type
           Description = 'L2VPN 500 Mbps'        // Product Description
       );
       insert productLL1REC;
       
       //-- leased line installation
       Product2 productLL2REC = new Product2(
           Name = 'Installation L2VPN TEST',         // Product Name
           Group_Service__c = groupService1REC.id,  // Group Service
           Family = 'Non-GSM',                       // Product Family
           IsActive = false,                      // Active
           SAP_Code__c = 'L2VPN-01',              // SAP Code
           Product_Code2__c = 'L2VPN',            // Product Code
           Revenue_Type__c = 'One Time'          // Charge Type
       );
       insert productLL2REC;
       
       //-- add pricebook-entry to standard procebook
       pbEntrySTDREC = new PricebookEntry(
           Product2Id = productLL1REC.id,  // Product
           IsActive = true,                   // Active
           Pricebook2Id = standardPricebookREC.id,  // Price Book
           UnitPrice = 52.500,                // List Price
           UseStandardPrice = false          // Use Standard Price
       );
       insert pbEntrySTDREC;
       
       PricebookEntry pbEntryLL1REC = new PricebookEntry(
           Product2Id = productLL1REC.id,  // Product
           IsActive = true,                   // Active
           Pricebook2Id = leasedLinePriceBookREC.id,  // Price Book
           UnitPrice = 52.500,                // List Price
           UseStandardPrice = false          // Use Standard Price
       );
       insert pbEntryLL1REC;
       
       
       // INSTALATION
       //-- add pricebook-entry to standard procebook
       pbEntrySTDREC = new PricebookEntry(
           Product2Id = productLL2REC.id,  // Product
           IsActive = true,                   // Active
           Pricebook2Id = standardPricebookREC.id,  // Price Book
           UnitPrice = 10.000,                // List Price
           UseStandardPrice = false          // Use Standard Price
       );
       insert pbEntrySTDREC;
       
       PricebookEntry pbEntryLL2REC = new PricebookEntry(
           Product2Id = productLL2REC.id,  // Product
           IsActive = true,                   // Active
           Pricebook2Id = leasedLinePriceBookREC.id,  // Price Book
           UnitPrice = 10.000,                // List Price
           UseStandardPrice = false          // Use Standard Price
       );
       insert pbEntryLL2REC;
       
       
       // -- pricebook non GSM ----------------------------------------------------------------
       Pricebook2 nonGSMPriceBookREC = new Pricebook2(
           Name = 'Internet_Dedicated_Jakarta',        // Price Book Name
           Service_Group__c = 'Non-GSM',  // Service Group
           IsActive = true,               // Active
           IsAgreement__c = true,        // IsAgreement
           for_product__c = 'Non-GSM'
       );
       insert nonGSMPriceBookREC;
       
       Product2 product1REC = new Product2(
           Name = 'NAP / IP Transit - 1085 Mbps TEST',      // Product Name
           Group_Service__c = groupService1REC.id,         // Group Service
           Bandwidth__c = 1085,                       // Bandwidth
           Family = 'Non-GSM',                              // Product Family
           UoM_Bandwidth__c = 'Mbps',                    // UoM Bandwidth
           IsActive = true,                              // Active
           SAP_Code__c = 'NAP-02',                       // SAP Code
           Product_Code2__c = 'ISP',                     // Product Code
           Revenue_Type__c = 'Recurring',                // Charge Type
           Description = 'Standard IP transit product'  // Product Description        
           
       );
       insert product1REC;
       
       //-- installation
       Product2 product2REC = new Product2(
           Name = 'Instalasi ISP TEST',                           // Product Name
           Group_Service__c = groupService1REC.id,               // Group Service
           Family = 'Non-GSM',                                    // Product Family
           IsActive = true,                                    // Active
           SAP_Code__c = 'ISP-01',                             // SAP Code
           Product_Code2__c = 'ISP',                           // Product Code
           Revenue_Type__c = 'One Time',                       // Charge Type
           Description = 'Installation for ISP / IP Transit'  // Product Description
           
       );
       insert product2REC;
       
       //-- add pricebook-entry to standard procebook
       pbEntrySTDREC = new PricebookEntry(
           Product2Id = product1REC.id,  // Product
           IsActive = true,                   // Active
           Pricebook2Id = standardPricebookREC.id,  // Price Book
           UnitPrice = 52.500,                // List Price
           UseStandardPrice = false          // Use Standard Price
       );
       insert pbEntrySTDREC;
       
       
       PricebookEntry pbEntry1REC = new PricebookEntry(
           Product2Id = product1REC.id,  // Product
           IsActive = true,                   // Active
           Pricebook2Id = nonGSMPriceBookREC.id,  // Price Book
           UnitPrice = 52.500,                // List Price
           UseStandardPrice = false          // Use Standard Price
       );
       insert pbEntry1REC;
       
       // INSTALATION
       //-- add pricebook-entry to standard procebook
       pbEntrySTDREC = new PricebookEntry(
           Product2Id = product2REC.id,  // Product
           IsActive = true,                   // Active
           Pricebook2Id = standardPricebookREC.id,  // Price Book
           UnitPrice = 10.000,                // List Price
           UseStandardPrice = false          // Use Standard Price
       );
       insert pbEntrySTDREC;
       
       PricebookEntry pbEntry2REC = new PricebookEntry(
           Product2Id = product2REC.id,  // Product
           IsActive = true,                   // Active
           Pricebook2Id = nonGSMPriceBookREC.id,  // Price Book
           UnitPrice = 10.000,                // List Price
           UseStandardPrice = false          // Use Standard Price
       );
       insert pbEntry2REC;
       // Insert Document Template
       Pdf_Template__c docRec = new Pdf_Template__c(
           Name = 'LL DOCUMENT TEMPLATE TEST',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        // Pdf Template Name
           Main_Object__c = 'Opportunity',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            // Main Object
           Size_Document__c = 'A4',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Size Document
           Default_Document_Name__c = 'LL_Relocation',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                // Default Document Name
           Margin_Top__c = 4.00,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    // Margin Top
           Margin_Bottom__c = 4.00,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 // Margin Bottom
           Margin_Right__c = 1.70,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  // Margin Right
           Margin_Left__c = 1.70,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Margin Left
           Unit_Document__c = 'cm',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Unit Document
           Type_Document__c = 'potrait',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              // Type Document
           Content_Footer_Margin__c = 50.00,
           Content_Header_Margin__c = 50.00, // Content Footer Margin
           Tex_Area_1__c = 'BERITA ACARA Selanjutnya disebut <table border="1" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td colspan="1" rowspan="1">Name</td><td colspan="1" rowspan="1">Qty</td><td colspan="1" rowspan="1">Price</td></tr><tr><td colspan="1" rowspan="1">%%OpportunityLineItem::Name%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::Quantity%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::UnitPrice%%</td></tr></tbody></table>, %%Opportunity::PR_Rel__r.Billing_Start_Date_IND__c%%\n\nBank Maybank Indonesia Tbk PT. XL Axiata TBK  %%StaticResource::signaturesigit%% Sigit Suhardono\n\n \n\n\n\t\t\tDiisi Oleh XL\n\n\t\t\tQuotation Number: %%Opportunity::PR_Rel__r.Opportunity_ID__c%%PR Notification: %%Opportunity::PR_Rel__r.Name%%Project ID: EWO Survey Number: SME: No\n\t\t\t',  // Tex Area 1
           Header__c = ' \n\t\t\t\t\t\tXL AXIATA\n\t\t\t \n\n\n \n',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  // Header
           Footer__c = ' \t\t\tXL AXIATA \n\n'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       // Footer
       );
       insert docRec;
       
       Template_Mapping__c TmcRec = new Template_Mapping__c(
           Name = 'ISP TEMPLATE',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           // Main Object
           Type__c = 'BA',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Size Document
           Product_Code__c = 'ISP',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                // Default Document Name
           Template__c = docRec.Id
       );
       insert TmcRec;
       
       TmcRec = new Template_Mapping__c(
           Name = 'L2VPN TEMPLATE',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           // Main Object
           Type__c = 'BA',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Size Document
           Product_Code__c = 'L2VPN',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                // Default Document Name
           Template__c = docRec.Id
       );
       insert TmcRec;
       
       Customer_Type_Mapping__c CTMRec = new Customer_Type_Mapping__c(
           Customer_Type__c = 'NONGSM',                                                                // Customer Type
           Product_Code__c = 'SSLVPN;Collocation;ISP;ISPUpTO;L2VPN;LL;MPLS;NAP;NAPMIX;SD-WAN;VLL;VPLS'  // Product Code
       );
       insert CTMRec;
       
       test.starttest();
       Opportunity oppREC = new Opportunity();
       system.runas(salesUser) {
           ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Newlink').getRecordTypeId();   
           
           //-- create Opportunity
           oppREC = new Opportunity(
               RecordTypeId = nonGSMLeasedLineRT,                                               // Opportunity Record Type
               Service_Type__c = 'Newlink',                                                // Service Type
               //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
               Auto_Renewal__c = false,                                                    // Auto Renewal
               trial__c = false,                                                           // trial
               PIC_BA_Print__c = contact1REC.id,                                              // PIC BA Print
               Auto_Renewal_Periode__c = 3,                                              // Auto Renewal Periode
               Auto_Renewal_UOM__c = 'Bulan',                                              // Auto Renewal UOM
               Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)',  // Opportunity Name
               AccountId = accRec.id,                                                    // Account Name
               Solution_PIC__c = solutionUser.id,                                              // Solution PIC
               CloseDate = Date.valueOf('2021-08-23'),                                     // Target Closed Date
               Actual_Closed_Date__c = Date.valueOf('2021-08-20'),                         // Actual Closed Date
               BP_Payer__c = accRec2.id,                                                  // BP Payer
               Expected_RFS_Date__c = Date.valueOf('2021-04-30'),                          // Expected RFS Date
               BP_VAT__c = accRec.id,                                                    // BP VAT
               PO_Date__c = Date.valueOf('2021-04-23'),                                    // PO Date
               Contract_Periode__c = 12,                                                 // Contract Periode
               StageName = 'Prospecting',                                                   // Stage
               Periode_UOM__c = 'Month',                                                   // Periode UOM
               Probability = 100,                                                          // Probability (%)
               Amount = 23.100,                                                            // Amount
               COF_Number__c = '1',                                                        // COF Number
               Remark__c = null,                                                     // Remark
               Approval_Status__c = null,                                            // Solution Approval Status
               Link_Related__c = null,                                              // CID (Related)
               CID__c = '12-00170',                                                        // CID
               SR__c = '2103-002457',                                                      // SR
               PR_Status__c = 'COM',                                                       // PR Status
               LeadSource = 'Partner',                                                     // Lead Source
               BW_before__c = '0',                                                         // Capacity before
               Uom_BW_Before__c = 'Mbps',                                                  // Uom BW Before
               BW_after__c = '500',                                                        // Capacity after
               Uom_BW_After__c = 'Mbps',                                                   // Uom BW After
               Lastmile_Type__c = 'Fiber',                                                 // Lastmile Type
               Quotation_Final_Approval__c = null,                                   // Quotation Final Approval Status
               Project_Coordinator__c = '90007525 Sri Hartanto',                           // Project Coordinator
               Mark_as_Add_Link_Sales_Revenue__c = false,                                  // Mark as Add Link (Sales Revenue)
               Mark_as_Sales_Revenue__c = false,                                         // Mark as Sales Revenue
               Doc_Template__c = docRec.Id
           );
           insert oppREC;
           //oppRec.Pricebook2id = leasedLinePriceBookREC.id;
           oppREC.Account_Site_A__c = accChild.id;                                            // Account Site A (BP Site) 
           oppREC.Account_Site_B__c = accChild1.id; 

           update oppREC;
          
       }
       
       Test.stopTest();
   }
}