/**
 * @description       : 
 * @author            : ahmat zulkifli murad
 * @group             : 
 * @last modified on  : 10-11-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   05-10-2022   ahmat zulkifli murad    Initial Version
**/

@isTest
public with sharing class OpportunityServiceTEST {

  @TestSetup
  static void makeData() {
    trigger_controller__c triggerController = new trigger_controller__c();
    triggerController.name = 'Trigger_Oppty_V2_Val_onQuotFinal';
    triggerController.Is_Active__c = true;
    triggerController.Description__c = 'test';
    insert triggerController;

    insert new Transaction__c(transactionID__c = 1);

    ID accountHORT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

    Profile salesProfile = [SELECT id FROM Profile WHERE name = 'Sales'];
    Profile adminProfile = [SELECT id FROM Profile WHERE name = 'System Administrator'];
    Profile solutionProfile = [SELECT id FROM Profile WHERE name = 'Solution'];
    Profile projectCoordinatorProfile = [SELECT id FROM Profile WHERE name = 'Project Coordinator'];
    Profile salesAdminProfile = [SELECT id FROM Profile WHERE name = 'Sales Admin'];


    Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
    User groupHeadobj = new User(                                             // Role
        Alias = 'dara',                                                              // Alias
        Email = 'dara@xl.co.id',                                                   // Email
        EmailEncodingKey='UTF-8',
        ProfileId = profiles.id,                                                     // Profile
        Username = 'dara@xl.co.id',                                                // Username
        IsActive = true,   															 // Nickname
        ForecastEnabled = false,                                                     // Allow Forecasting
        Employee_ID__c = '90007843',                                                 // Employee ID
        phone ='021-90', 
        mobilephone='0812', 
        firstName = 'dara',
        LastName='muda',
        LocaleSidKey='en_US',
        TimeZoneSidKey=  'America/Los_Angeles',
        LanguageLocaleKey = 'en_US'
    );
    insert groupHeadobj;
    Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'merry',                                                            // Alias
            Email = 'merry@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'merry@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003754',                                               // Employee ID
            firstName = 'merry',
            LastName='you'
        );
        insert salesManagerobj;

    //User salesUser = [SELECT id FROM user WHERE alias = 'Annisa'];
    User salesUser = new User(
      //UserRoleId = salesUserRole.id,                                                  // Role
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
      ManagerId = salesManagerobj.id,                                               // Manager
      ForecastEnabled = false, // Allow Forecasting
      MobilePhone = '081953119000', // Mobile
      EmailEncodingKey = 'ISO-8859-1', // Email Encoding
      Employee_ID__c = '90007498', // Employee ID
      //Sales_Group_Head__c = '0057F000005Tvn5',                                     // Sales Group Head
      Grade__c = '15', // Grade
      Employee_Category__c = 'Existing Employee' // Employee Category
    );
    insert salesUser;

    User solutionUser = new User(
      //UserRoleId = 'undefined',                                                  // Role
      Alias = 'Muhid', // Alias
      Email = 'muhida@xl.co.id', // Email
      ProfileId = solutionProfile.Id, // Profile
      Username = 'muhida@xl.co.id.TEST', // Username
      IsActive = true, // Active
      CommunityNickname = 'MuhidTEST', // Nickname
      lastName = 'MuhidTEST',
      UserPermissionsMarketingUser = false, // Marketing User
      UserPermissionsOfflineUser = false, // Offline User
      Department = 'XL Business Solutions', // Department
      UserPermissionsKnowledgeUser = false, // Knowledge User
      UserPermissionsInteractionUser = false, // Flow User
      UserPermissionsSupportUser = false, // Service Cloud User
      TimeZoneSidKey = 'Asia/Jakarta', // Time Zone
      UserPermissionsLiveAgentUser = false, // Chat User
      LocaleSidKey = 'in_ID', // Locale
      LanguageLocaleKey = 'en_US', // Language
      //DelegatedApproverId = '0057F000002NJcg',                                     // Delegated Approver
      //ManagerId = '0057F000002NJcg',                                               // Manager
      ForecastEnabled = false, // Allow Forecasting
      MobilePhone = '+62 87779770777', // Mobile
      EmailEncodingKey = 'ISO-8859-1', // Email Encoding
      Employee_ID__c = '90004892' // Employee ID
    );
    insert solutionUser;

    User adminUser = new User(
      //UserRoleId = 'undefined',                                                  // Role
      Alias = 'admns', // Alias
      Email = 'king@xl.co.id.inv', // Email
      ProfileId = adminProfile.Id, // Profile
      Username = 'king@xl.co.id.TEST', // Username
      IsActive = true, // Active
      CommunityNickname = 'adminset', // Nickname
      lastName = 'adminAja',
      UserPermissionsMarketingUser = false, // Marketing User
      UserPermissionsOfflineUser = false, // Offline User
      Department = 'XL Business Solutions', // Department
      UserPermissionsKnowledgeUser = false, // Knowledge User
      UserPermissionsInteractionUser = false, // Flow User
      UserPermissionsSupportUser = false, // Service Cloud User
      TimeZoneSidKey = 'Asia/Jakarta', // Time Zone
      UserPermissionsLiveAgentUser = false, // Chat User
      LocaleSidKey = 'in_ID', // Locale
      LanguageLocaleKey = 'en_US', // Language
      //DelegatedApproverId = '0057F000002NJcg',                                     // Delegated Approver
      //ManagerId = '0057F000002NJcg',                                               // Manager
      ForecastEnabled = false, // Allow Forecasting
      MobilePhone = '+62 87779770777', // Mobile
      EmailEncodingKey = 'ISO-8859-1', // Email Encoding
      Employee_ID__c = '900004892' // Employee ID
    );
    insert adminUser;

    User projectCoordinatorUser = new User(
      //UserRoleId = 'undefined',                                                  // Role
      Alias = 'nancy', // Alias
      Email = 'nancycitranigrum@xl.co.id', // Email
      ProfileId = projectCoordinatorProfile.Id, // Profile
      Username = 'nancycitranigrum@xl.co.id.TEST', // Username
      IsActive = true, // Active
      CommunityNickname = 'nancyTEST', // Nickname
      lastName = 'Nancy Citranigrum',
      UserPermissionsMarketingUser = false, // Marketing User
      UserPermissionsOfflineUser = false, // Offline User
      Department = 'XL Business Solutions', // Department
      UserPermissionsKnowledgeUser = false, // Knowledge User
      UserPermissionsInteractionUser = false, // Flow User
      UserPermissionsSupportUser = false, // Service Cloud User
      TimeZoneSidKey = 'Asia/Jakarta', // Time Zone
      UserPermissionsLiveAgentUser = false, // Chat User
      LocaleSidKey = 'in_ID', // Locale
      LanguageLocaleKey = 'en_US', // Language
      //DelegatedApproverId = '0057F000002NJcg',                                     // Delegated Approver
      //ManagerId = '0057F000002NJcg',                                               // Manager
      ForecastEnabled = false, // Allow Forecasting
      MobilePhone = '+62 87779770777', // Mobile
      EmailEncodingKey = 'ISO-8859-1', // Email Encoding
      Employee_ID__c = '90006544' // Employee ID
    );
    insert projectCoordinatorUser;

    User salesAdminUser = new User(
      //UserRoleId = 'undefined',                                                  // Role
      Alias = 'sadmin', // Alias
      Email = 'salesadmin@xl.co.id', // Email
      ProfileId = salesAdminProfile.Id, // Profile
      Username = 'salesadminTEST@xl.co.id.TEST', // Username
      IsActive = true, // Active
      CommunityNickname = 'salesadminTEST', // Nickname
      lastName = 'salesadminTEST',
      UserPermissionsMarketingUser = false, // Marketing User
      UserPermissionsOfflineUser = false, // Offline User
      Department = 'XL Business Solutions', // Department
      UserPermissionsKnowledgeUser = false, // Knowledge User
      UserPermissionsInteractionUser = false, // Flow User
      UserPermissionsSupportUser = false, // Service Cloud User
      TimeZoneSidKey = 'Asia/Jakarta', // Time Zone
      UserPermissionsLiveAgentUser = false, // Chat User
      LocaleSidKey = 'in_ID', // Locale
      LanguageLocaleKey = 'en_US', // Language
      //DelegatedApproverId = '0057F000002NJcg',                                     // Delegated Approver
      //ManagerId = '0057F000002NJcg',                                               // Manager
      ForecastEnabled = false, // Allow Forecasting
      MobilePhone = '+62 87779770777', // Mobile
      EmailEncodingKey = 'ISO-8859-1', // Email Encoding
      Employee_ID__c = '90006544' // Employee ID
    );
    insert salesAdminUser;

    AM_Portfolio_Mapping__c amPortofolioMappingREC = new AM_Portfolio_Mapping__c(
      AM__c = salesUser.id, // AM
      Portfolio_Management_Support__c = solutionUser.id, // Portfolio Management Support
      Status__c = 'Active' // Status
    );
    insert amPortofolioMappingREC;

    Account accRec = new Account(
      ownerid = salesUser.id,
      Name = 'PT Khazanah Media Network Nusantara TEST', // Account Name
      RecordTypeId = accountHORT, // Account Record Type
      BP_Number__c = '763278', // BP Number
      Organization_Type__c = 'Head Office', // Organization Type
      Type = 'Customer', // Type
      Unique_Name__c = 'Kapuas', // Unique Name
      Customer_Type__c = 'NONGSM', // Customer Type
      Industry = 'Telecommunications', // Industry
      Payer_For_GSM_Invoice__c = false, // Payer For GSM Invoice
      term_of_payment__c = 'Z030 Within 30 Days Due Net', // Term of Payment
      Customer_VAT_Name__c = 'PT Khazanah Media Network Nusantara', // Customer VAT Name
      Is_New_Customer__c = false, // Is New Customer
      Kwitansi__c = false, // Kwitansi
      //Bad_Debt_Status__c = 'true',
      //Bad_Debt_Last_Checking_Date__c = dateTime.newInstance(2022, 09, 09, 09, 09, 09),
      Faktur_Pajak__c = false, // Faktur Pajak
      summary_invoice__c = false, // Summary Invoice
      Summary_Billing__c = false, // Summary Billing
      Approval_Status__c = 'Approved', // Approval Status
      Using_HO_Billing_Address__c = false, // Using HO Billing Address
      No_NPWP__c = '723434791711000', // No NPWP
      Relocation_Street_1__c = 'reloc ke suatu tempat',
      ShippingStreet = 'dsdsdsds',
      Billing_Address_Province__c = 'jawa tengah',
      Billing_Address_City__c = 'kota surakarta',
      Shipping_Address_Province__c = 'jawa tengah',
      Shipping_Address_City__c = 'kota surakarta' 
    );
    insert accRec;

    Contact contact1REC = new Contact(
      AccountId = accRec.id, // Account Name
      Email = 'mr.bagus.khairuzzaman@gmail.com.invalid', // Email
      MobilePhone = '085286136041', // Mobile
      lastName = 'Bagus'
    );
    insert contact1REC;

    Contact contact2REC = new Contact(
      AccountId = accRec.id, // Account Name
      Email = 'good.boy@gmail.com.invalid', // Email
      MobilePhone = '085286111111', // Mobile
      lastName = 'Goodboy'
    );
    insert contact2REC;

    AccountContactRelation acr1REC = [SELECT id, roles FROM AccountContactRelation WHERE contactId =: contact1REC.id];
    acr1REC.roles = 'PIC Recipient Invoice;PIC BA Print;PIC BA Recipient;PIC Site;PIC Print Invoice';
    update acr1REC;

    AccountContactRelation acr2REC = [SELECT id, roles FROM AccountContactRelation WHERE contactId =: contact2REC.id];
    acr2REC.roles = 'PIC Recipient Invoice;PIC BA Recipient;PIC Site;PIC Print Invoice';
    update acr2REC;

    AccountContactRelation acr3REC = [SELECT id, roles FROM AccountContactRelation WHERE contactId =: contact2REC.id];
    acr3REC.roles = 'PIC Recipient Invoice;PIC BA Recipient;PIC Site;PIC Print Invoice';
    update acr3REC;

    //-- Create CONTRACT ----
    Contract contractItemREC = new Contract(
      Name = 'Contract TEST', // Contract Name
      Last_Transaction_ID__c = 'CI0395532', // Last Transaction ID
      Full_Name__c = 'Contract: TEST', // Full Name
      Accountid = accRec.id,
      Account_BP_Payer__c = accRec.id, // Account BP Payer
      Start_Date__c = Date.valueOf('2021-02-11'), // Start Date
      End_Date__c = Date.valueOf('2021-11-30'), // End Date
      Account_BP_VAT__c = accRec.id, // Account BP VAT
      Billing_Type__c = 'Monthly', // Billing Type
      //Product__c = '01t7F000008DrDT',                                    // Product
      //Contract_Header__c = 'a0R7F00000m7MZP',                            // Contract Header
      Price__c = 636356, // Price
      Contract_ID__c = '3002482', // Contract ID
      Quantity__c = 1, // Quantity
      SAP_ID__c = '37', // Contract Item
      Extension_Created__c = false, // Extension Created
      Product_SAP_Code__c = 'PWFH-01', // Product SAP Code
      Product_Charge_Type_filled__c = 'One Time', // Product Charge Type
      Status = 'Draft', // Status
      Auto_Renewal__c = false, // Auto Renewal
      Active__c = true, // Active
      //Opportunity__c = '0067F000011Rcny',                                // Opportunity
      Project_Type__c = 'NEW', // Project Type
      Bandwidth_filled__c = 000, // Bandwidth
      Contract_Term__c = 12
    );
    insert contractItemREC;

    contractItemREC.status = 'Active';
    update contractItemREC;

    Link__c link1REC = new Link__c(
      Company_Name__c = 'CV. LINTASSEMESTA BERTUAH RAYA', // Company Name
      Capacity_Bandwidth__c = '30', // Capacity Bandwidth
      Name = '12-00165', // CID/Link ID
      UoM__c = 'Mbps', // UoM
      Link_ID__c = '020C7849L1_TEST', // Link ID
      Partner__c = false, // Partner
      Status_Link__c = 'UNDER_PROJECT', // Status Link
      Service_Type__c = 'L2VPN', // Service Type
      Routepath__c = '762675 CV Lintas Semesta Bertua Raya ..', // Routepath
      Site_A_Name__c = accRec.id, // Site A Name
      Site_B_Name__c = null, // Site B Name
      BP_Site_A__c = '762675', // BP Site A
      BP_Site_B__c = '762676', // BP Site B
      Contract_Item__c = '3002592-1', // Contract Item
      Contract_Item_Rel__c = contractItemREC.id, // Contract Item Rel
      Free_Link__c = false, // Free Link
      ID__c = '24514', // ID
      CID__c = '12-00165', // CID *
      BU__c = 'ENTERPRISE', // BU
      CID_RelD__c = null // CID RelD
    );
    insert link1REC;

    Link__c link2REC = new Link__c(
      Company_Name__c = 'CV. LINTASSEMESTA BERTUAH RAYA', // Company Name
      Capacity_Bandwidth__c = '30', // Capacity Bandwidth
      Name = '12-999999', // CID/Link ID
      UoM__c = 'Mbps', // UoM
      Link_ID__c = '99999999_TEST2', // Link ID
      Partner__c = false, // Partner
      Status_Link__c = 'UNDER_PROJECT', // Status Link
      Service_Type__c = 'L2VPN', // Service Type
      Routepath__c = '762675 CV Lintas Semesta Bertua Raya ..', // Routepath
      Site_A_Name__c = accRec.id, // Site A Name
      Site_B_Name__c = null, // Site B Name
      BP_Site_A__c = '762675', // BP Site A
      BP_Site_B__c = '762676', // BP Site B
      Contract_Item__c = '3002592-1', // Contract Item
      Contract_Item_Rel__c = contractItemREC.id, // Contract Item Rel
      Free_Link__c = false, // Free Link
      ID__c = '24514', // ID
      CID__c = '12-00165', // CID *
      BU__c = 'ENTERPRISE', // BU
      CID_RelD__c = null // CID RelD
    );
    insert link2REC;

    //-- create Group Service
    Group_Service__c groupService1REC = new Group_Service__c(
      Name = 'FIXED', // Group Service Name
      Unique_ID__c = 'FIXED', // Unique ID
      Type__c = 'BAU', // Type
      Search_Term__c = 'Group Service' // Search Term
    );
    insert groupService1REC;

    //-- PRICEBOOK & Product
    PricebookEntry pbEntrySTDREC = new PricebookEntry();

    Pricebook2 leasedLinePriceBookREC = new Pricebook2(
      Name = 'Leased_Line', // Price Book Name
      Service_Group__c = 'Non-GSM', // Service Group
      IsActive = true, // Active
      IsAgreement__c = false // IsAgreement

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
      Name = 'L2VPN 500 Mbps TEST', // Product Name
      Group_Service__c = groupService1REC.id, // Group Service
      Bandwidth__c = 500, // Bandwidth
      Family = 'Non-GSM', // Product Family
      UoM_Bandwidth__c = 'Mbps', // UoM Bandwidth
      IsActive = false, // Active
      SAP_Code__c = 'L2VPN-02', // SAP Code
      Product_Code2__c = 'L2VPN', // Product Code
      Revenue_Type__c = 'Recurring', // Charge Type
      Description = 'L2VPN 500 Mbps' // Product Description
    );
    insert productLL1REC;

    //-- leased line installation
    Product2 productLL2REC = new Product2(
      Name = 'Installation L2VPN TEST', // Product Name
      Group_Service__c = groupService1REC.id, // Group Service
      Family = 'Non-GSM', // Product Family
      IsActive = false, // Active
      SAP_Code__c = 'L2VPN-01', // SAP Code
      Product_Code2__c = 'L2VPN', // Product Code
      Revenue_Type__c = 'One Time' // Charge Type
    );
    insert productLL2REC;

    //-- add pricebook-entry to standard procebook
    pbEntrySTDREC = new PricebookEntry(
      Product2Id = productLL1REC.id, // Product
      IsActive = true, // Active
      Pricebook2Id = standardPricebookREC.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntrySTDREC;

    PricebookEntry pbEntryLL1REC = new PricebookEntry(
      Product2Id = productLL1REC.id, // Product
      IsActive = true, // Active
      Pricebook2Id = leasedLinePriceBookREC.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntryLL1REC;

    // INSTALATION
    //-- add pricebook-entry to standard procebook
    pbEntrySTDREC = new PricebookEntry(
      Product2Id = productLL2REC.id, // Product
      IsActive = true, // Active
      Pricebook2Id = standardPricebookREC.id, // Price Book
      UnitPrice = 10.000, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntrySTDREC;

    PricebookEntry pbEntryLL2REC = new PricebookEntry(
      Product2Id = productLL2REC.id, // Product
      IsActive = true, // Active
      Pricebook2Id = leasedLinePriceBookREC.id, // Price Book
      UnitPrice = 10.000, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntryLL2REC;

    // -- pricebook non GSM ----------------------------------------------------------------
    Pricebook2 nonGSMPriceBookREC = new Pricebook2(
      Name = 'Internet_Dedicated_Jakarta', // Price Book Name
      Service_Group__c = 'Non-GSM', // Service Group
      IsActive = true, // Active
      IsAgreement__c = true, // IsAgreement
      for_product__c = 'Non-GSM'
    );
    insert nonGSMPriceBookREC;

    Product2 product1REC = new Product2(
      Name = 'NAP / IP Transit - 1085 Mbps TEST', // Product Name
      Group_Service__c = groupService1REC.id, // Group Service
      Bandwidth__c = 1085, // Bandwidth
      Family = 'Non-GSM', // Product Family
      UoM_Bandwidth__c = 'Mbps', // UoM Bandwidth
      IsActive = true, // Active
      SAP_Code__c = 'NAP-02', // SAP Code
      Product_Code2__c = 'ISP', // Product Code
      Revenue_Type__c = 'Recurring', // Charge Type
      Description = 'Standard IP transit product' // Product Description        

    );
    insert product1REC;

    //-- installation
    Product2 product2REC = new Product2(
      Name = 'Instalasi ISP TEST', // Product Name
      Group_Service__c = groupService1REC.id, // Group Service
      Family = 'Non-GSM', // Product Family
      IsActive = true, // Active
      SAP_Code__c = 'ISP-01', // SAP Code
      Product_Code2__c = 'ISP', // Product Code
      Revenue_Type__c = 'One Time', // Charge Type
      Description = 'Installation for ISP / IP Transit' // Product Description

    );
    insert product2REC;

    //-- add pricebook-entry to standard procebook
    pbEntrySTDREC = new PricebookEntry(
      Product2Id = product1REC.id, // Product
      IsActive = true, // Active
      Pricebook2Id = standardPricebookREC.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntrySTDREC;

    PricebookEntry pbEntry1REC = new PricebookEntry(
      Product2Id = product1REC.id, // Product
      IsActive = true, // Active
      Pricebook2Id = nonGSMPriceBookREC.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntry1REC;

    // INSTALATION
    //-- add pricebook-entry to standard procebook
    pbEntrySTDREC = new PricebookEntry(
      Product2Id = product2REC.id, // Product
      IsActive = true, // Active
      Pricebook2Id = standardPricebookREC.id, // Price Book
      UnitPrice = 10.000, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntrySTDREC;

    PricebookEntry pbEntry2REC = new PricebookEntry(
      Product2Id = product2REC.id, // Product
      IsActive = true, // Active
      Pricebook2Id = nonGSMPriceBookREC.id, // Price Book
      UnitPrice = 10.000, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntry2REC;
    // Insert Document Template
    Pdf_Template__c docRec = new Pdf_Template__c(
      Name = 'LL DOCUMENT TEMPLATE TEST', // Pdf Template Name
      Main_Object__c = 'Opportunity', // Main Object
      Size_Document__c = 'A4', // Size Document
      Default_Document_Name__c = 'LL_Relocation', // Default Document Name
      Margin_Top__c = 4.00, // Margin Top
      Margin_Bottom__c = 4.00, // Margin Bottom
      Margin_Right__c = 1.70, // Margin Right
      Margin_Left__c = 1.70, // Margin Left
      Unit_Document__c = 'cm', // Unit Document
      Type_Document__c = 'potrait', // Type Document
      Content_Footer_Margin__c = 50.00,
      Content_Header_Margin__c = 50.00, // Content Footer Margin
      Tex_Area_1__c = 'BERITA ACARA Selanjutnya disebut <table border="1" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td colspan="1" rowspan="1">Name</td><td colspan="1" rowspan="1">Qty</td><td colspan="1" rowspan="1">Price</td></tr><tr><td colspan="1" rowspan="1">%%OpportunityLineItem::Name%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::Quantity%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::UnitPrice%%</td></tr></tbody></table>, %%Opportunity::PR_Rel__r.Billing_Start_Date_IND__c%%\n\nBank Maybank Indonesia Tbk PT. XL Axiata TBK  %%StaticResource::signaturesigit%% Sigit Suhardono\n\n \n\n\n\t\t\tDiisi Oleh XL\n\n\t\t\tQuotation Number: %%Opportunity::PR_Rel__r.Opportunity_ID__c%%PR Notification: %%Opportunity::PR_Rel__r.Name%%Project ID: EWO Survey Number: SME: No\n\t\t\t', // Tex Area 1
      Header__c = ' \n\t\t\t\t\t\tXL AXIATA\n\t\t\t \n\n\n \n', // Header
      Footer__c = ' \t\t\tXL AXIATA \n\n' // Footer
    );
    insert docRec;

    Template_Mapping__c TmcRec = new Template_Mapping__c(
      Name = 'ISP TEMPLATE', // Main Object
      Type__c = 'BA', // Size Document
      Product_Code__c = 'ISP', // Default Document Name
      Template__c = docRec.Id
    );
    insert TmcRec;

    TmcRec = new Template_Mapping__c(
      Name = 'L2VPN TEMPLATE', // Main Object
      Type__c = 'BA', // Size Document
      Product_Code__c = 'L2VPN', // Default Document Name
      Template__c = docRec.Id
    );
    insert TmcRec;
  }

  @isTest
  public static void OpportunityServiceTEST() {

    //custom setting for query condition
    Sobject_Query_Condition__c OpportunityService_BadDebtStatus = new Sobject_Query_Condition__c();
    OpportunityService_BadDebtStatus.name = 'OpportunityService_BadDebtStatus';
    OpportunityService_BadDebtStatus.Automation_Name__c = 'OpportunityService';
    OpportunityService_BadDebtStatus.Object_Name__c = 'Opportunity';
    OpportunityService_BadDebtStatus.Where_Condition__c = 'True';

    insert OpportunityService_BadDebtStatus;

    Sobject_Query_Condition__c OpportunityService_QuotApprovalStatus = new Sobject_Query_Condition__c();
    OpportunityService_QuotApprovalStatus.name = 'OpportunityService_QuotApprovalStatus';
    OpportunityService_QuotApprovalStatus.Automation_Name__c = 'OpportunityService';
    OpportunityService_QuotApprovalStatus.Object_Name__c = 'Opportunity';
    OpportunityService_QuotApprovalStatus.Where_Condition__c = 'Approved';

    insert OpportunityService_QuotApprovalStatus;

    Sobject_Query_Condition__c OpportunityService_StageName = new Sobject_Query_Condition__c();
    OpportunityService_StageName.name = 'OpportunityService_StageName';
    OpportunityService_StageName.Automation_Name__c = 'OpportunityService';
    OpportunityService_StageName.Object_Name__c = 'Opportunity';
    OpportunityService_StageName.Where_Condition__c = 'Quotation Final;';

    insert OpportunityService_StageName;

    User salesgroupHead = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'muda'
    ];

    User salesManager = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'you'
    ];
    
    User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'AnnisaTEST'
    ];

    User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'MuhidTEST'
    ];

    User adminUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'adminAja'
    ];

    Account accRec = [SELECT id, Bad_Debt_Status__c, Bad_Debt_Last_Checking_Date__c FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST'];
    Contact contactRec = [Select id From Contact Where lastname = 'Bagus'];
    Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Leased_Line'];
    Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'LL DOCUMENT TEMPLATE TEST'];

    Opportunity oppREC = new Opportunity();

    ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Newlink').getRecordTypeId();
      //-- create Opportunity
      oppREC = new Opportunity(
        OwnerId = salesUser.id,
        RecordTypeId = nonGSMLeasedLineRT, // Opportunity Record Type
        Service_Type__c = 'Newlink', // Service Type
        //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
        Auto_Renewal__c = false, // Auto Renewal
        trial__c = false, // trial
        PIC_BA_Print__c = contactRec.id, // PIC BA Print

        Auto_Renewal_Periode__c = 3, // Auto Renewal Periode
        Auto_Renewal_UOM__c = 'Bulan', // Auto Renewal UOM
        //Profitability__c = 'undefined',                                             // Profitability
        Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)', // Opportunity Name
        AccountId = accRec.id, // Account Name
        Solution_PIC__c = solutionUser.id, // Solution PIC
        CloseDate = Date.newInstance(2022, 09, 09), // Target Closed Date
        Actual_Closed_Date__c = Date.newInstance(2022, 09, 09), // Actual Closed Date
        BP_Payer__c = accRec.id, // BP Payer
        Expected_RFS_Date__c = Date.newInstance(2022, 09, 09), // Expected RFS Date
        BP_VAT__c = accRec.id, // BP VAT
        PO_Date__c = Date.newInstance(2022, 09, 09), // PO Date
        Contract_Periode__c = 2, // Contract Periode
        StageName = 'Prospecting', // Stage
        Periode_UOM__c = 'week', // Periode UOM
        //Probability = 100, // Probability (%)
        Amount = 23.100, // Amount
        COF_Number__c = '1', // COF Number
        Remark__c = null, // Remark
        Approval_Status__c = null, // Solution Approval Status
        Account_Site_A__c = accRec.id, // Account Site A (BP Site) 
        Account_Site_B__c = accRec.id, // Account Site B (BP Site)
        Link_Related__c = null, // CID (Related)
        CID__c = '12-00170', // CID
        SR__c = '2103-002457', // SR
        //SR_Status__c = 'Close(Complete)',                                           // SR Status
        //PR__c = '2104-001944',                                                      // PR
        PR_Status__c = 'COM', // PR Status
        LeadSource = 'Partner', // Lead Source
        BW_before__c = '0', // Capacity before
        Uom_BW_Before__c = 'Mbps', // Uom BW Before
        BW_after__c = '500', // Capacity after
        Uom_BW_After__c = 'Mbps', // Uom BW After
        Lastmile_Type__c = 'Fiber', // Lastmile Type
        Quotation_Final_Approval__c = null, // Quotation Final Approval Status
        Project_Coordinator__c = '90007525 Sri Hartanto', // Project Coordinator
        Mark_as_Add_Link_Sales_Revenue__c = false, // Mark as Add Link (Sales Revenue)
        Mark_as_Sales_Revenue__c = false, // Mark as Sales Revenue
        Doc_Template__c = docRec.Id
      );
      insert oppREC;

      oppRec.Pricebook2id = leasedLinePriceBookREC.id;
      update oppREC;

      List < OpportunityLineItem > oliToInsertList = new List < OpportunityLineItem > ();

      //-- create opportunity product instalation
      ID standardPriceBookId = Test.getStandardPricebookId();
      PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Installation L2VPN TEST'
        and pricebook2.id !=: standardPriceBookId
      ];
      OpportunityLineItem oliInstREC = new OpportunityLineItem(
        OpportunityId = oppREC.id, // Opportunity
        UnitPrice = 10000, // Sales Price
        PricebookEntryId = pbEntryLL2REC.id,
        //Product2Id = '01t7F000006CcUR',                       // Product
        Request_QTY__c = 1, // QTY Request
        Quantity = 1.00, // Quantity
        //TotalPrice = 10.000,                                  // Total Price
        Revenue_Type__c = 'One Time', // Charge Type
        Contract_Start_Date__c = system.today().addDays(5), // Contract Start Date
        Contract_End_Date__c = system.today().addYears(1), // Contract End Date
        Billing_Type__c = 'Monthly', // Billing Type
        Is_Pipeline__c = false, // Is Pipeline
        is_Forecast_Revenue__c = false, // is Forecast Revenue
        Is_Pipeline_PO__c = false, // Is Pipeline PO
        Mark_as_Revenue_Pipeline_OLD__c = false // Mark as Revenue Pipeline OLD
        //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
      );
      oliToInsertList.add(oliInstREC);

      PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'L2VPN 500 Mbps TEST'
        and pricebook2.id !=: standardPriceBookId
      ];
      OpportunityLineItem oliREC = new OpportunityLineItem(
        OpportunityId = oppREC.id, // Opportunity
        UnitPrice = 13100, // Sales Price
        PricebookEntryId = pbEntryLL1REC.id,
        //Product2Id = '01t7F000009Hd6I',                       // Product
        Request_QTY__c = 1, // QTY Request
        Quantity = 1.00, // Quantity
        //TotalPrice = 13.100,                                  // Total Price
        Revenue_Type__c = 'Recurring', // Charge Type
        Contract_Start_Date__c = system.today().addDays(5), // Contract Start Date
        Contract_End_Date__c = system.today().addYears(1), // Contract End Date
        Billing_Type__c = 'Monthly', // Billing Type
        Is_Pipeline__c = false, // Is Pipeline
        is_Forecast_Revenue__c = false, // is Forecast Revenue
        Is_Pipeline_PO__c = false, // Is Pipeline PO
        Mark_as_Revenue_Pipeline_OLD__c = false // Mark as Revenue Pipeline OLD
        //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
      );
      oliToInsertList.add(oliREC);

      insert oliToInsertList;

      TriggerBase.bypass('Opportunity');
      //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
    
      system.runAs(adminUser){
      oppREC.StageName = 'Negotiation';
      update oppREC;
      }

      EDA__c EDARec = new EDA__c(
        Name = 'IOM Bad Debt for Opportunity 2209-031280', // EDA Name
        Document_Type__c = 'IOM', // Document Type
        IOM_Type__c = 'Allow Bad Debt Account', // IOM Type
        Remark__c = 'Completed', // Remark
        EDA_Status__c = 'Draft', // EDA Status
        Related_Customer__c = oppREC.accountId, // Related Customer
        Summary__c = 'Test Approved by System, because as now Account has no Bad Debt', // Summary
        approver_incharge__c = 'Saasten Dev5', // approver incharge
        Submission_Date__c = Date.newInstance(2022, 09, 09), // Submission Date
        Opportunity__c = oppREC.id, // Opportunity                                    // Auto Approved By System
        Recipient_1__c = 'ahmat.murad@saasten.com', // Recipient 1
        Approver_1__c = solutionUser.id, // Approver 1
        Recipient_2__c = 'ahmat.murad@saasten.com', // Recipient 2
        Recipient_3__c = 'ahmat.murad@saasten.com', // Recipient 3
        Approver_2__c = solutionUser.id, // Approver 2
        Recipient_4__c = 'ahmat.murad@saasten.com', // Recipient 4
        Recipient_5__c = 'ahmat.murad@saasten.com', // Recipient 5
        Approver_3__c = solutionUser.id, // Approver 3
        Approver_4__c = solutionUser.id, // Approver 4
        Rejected__c = false, // Rejected
        Mark_as_Revenue_EDA_Waiving__c = false // Mark as Revenue EDA Waiving
      );

      insert EDARec;

      oppREC.bad_debt_eda__C = EDARec.id;
      update oppREC;

      test.startTest();
      EDARec.EDA_Status__c = 'Submitted';    
      update EDARec;

      system.runAs(adminUser) {
        accRec.Bad_Debt_Status__c = 'true';
        accRec.Bad_Debt_Last_Checking_Date__c = Datetime.newInstance(2022, 09, 09, 09, 09, 09);
        update accRec;

        oppREC.quotation_final_approval__c = 'Approved';
        update oppREC;

      }

      //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL -- seharusnya dilakukan sales, tapi karena dari sebelumnya dari "survey" maka nanti kena VR
      system.runAs(adminUser){
        oppREC.StageName = 'Quotation Final';
        //oppREC.Probability = 40;
        update oppREC;
      }
      
      OpportunityService.badDebtOppAdjustment();

      TriggerBase.clearBypass('Opportunity');

      test.stopTest();
  }

  @isTest
  public static void CreateFreeMRCOpptyProducts_TEST() {
    Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
    
    Id RecordTypeId_SR_PR = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR 4G Access').getRecordTypeId();
    
    Id RecordTypeId_Opportunity_NonGSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM').getRecordTypeId();
    
    Profile pf= [Select Id from profile where Name='System Administrator']; 
    
    String orgId=UserInfo.getOrganizationId(); 
    String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
    Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
    String uniqueName=orgId+dateString+RandomId; 
    User uu = new User(
        firstname = 'ABC', 
        lastName = 'XYZ', 
        email = 'idewap@xl.co.id', 
        Username = uniqueName + '@test' + orgId + '.org', 
        EmailEncodingKey = 'ISO-8859-1', 
        Alias = uniqueName.substring(18, 23), 
        TimeZoneSidKey = 'America/Los_Angeles', 
        LocaleSidKey = 'en_US', 
        LanguageLocaleKey = 'en_US', 
        ProfileId = pf.Id
    ); 
    insert uu;
    
    Opportunity O = new Opportunity();
    
    system.runas(uu){
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
        accTest.Billing_Address_Province__c = 'jawa tengah';
        accTest.Billing_Address_City__c = 'kota surakarta';
        accTest.Shipping_Address_Province__c = 'jawa tengah';
        accTest.Shipping_Address_City__c = 'kota surakarta' ; 
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
            Using_HO_Billing_Address__c = false,
            Billing_Address_Province__c = 'jawa tengah',
            Billing_Address_City__c = 'kota surakarta',
            Shipping_Address_Province__c = 'jawa tengah',
            Shipping_Address_City__c = 'kota surakarta'                           
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
        contractTest.Product_Charge_Type_filled__c = 'Recurring';
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
        
        AccountContactRelation CR=new AccountContactRelation();
        Contact C=new Contact();
        C.LastName='Wiryo';
        C.Accountid=accTest.id;
        C.Firstname='Yohn';
        C.MobilePhone='0288282';
        C.Email='Fail@fail.com';
        insert C;
        
        CR.AccountID=accTest2.id;
        CR.Contactid=C.id;
        CR.Roles='PIC Site;PIC BA Sign';
        insert CR;

        //Create Product
        Product2 productObj = new Product2(
            Name = 'BIZ - Booster (Postpaid)', 
            Family = 'GSM', 
            Product_Code2__c = 'Postpaid', 
            SAP_Code__c = 'LL-02', 
            Revenue_Type__c = 'Recurring', 
            isActive = true
        );
        Insert productObj;

        //Create Product
        Product2 productObj2 = new Product2(
            Name = 'FREE MRC - BIZ - Booster (Postpaid)', 
            Family = 'GSM', 
            Product_Code2__c = 'Postpaid', 
            SAP_Code__c = 'LL-12', 
            Revenue_Type__c = 'Recurring', 
            isActive = true
        );
        Insert productObj2;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Pricebook2 GSM_ActivationPricebook = new Pricebook2(
            name = 'GSM Activation',
            IsActive = true,
            GSM_Type__c = 'Package',
            Service_Group__c = 'GSM'
        );
        insert GSM_ActivationPricebook;

        PricebookEntry GSM_ActivationPbe = new PricebookEntry(
            Pricebook2Id = GSM_ActivationPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert GSM_ActivationPbe;

        O.Accountid=accTest.id;
        O.Account_Site_A__c=accTest.id;
        O.Account_Site_B__c=accTest2.id;
        O.StageName='Prospecting';
        O.Name='Tes';
        O.CloseDate=system.today().adddays(10);
        O.Pricebook2id= Test.getStandardPricebookId();
        O.Periode_UOM__c='Month';
        O.BP_Payer__c=accTest2.id;
        O.BP_Vat__c=accTest2.id;
        O.Service_Type__c = 'Newlink';
        O.RecordTypeId = RecordTypeId_Opportunity_NonGSM;
        O.Contract_Periode__c = 1;
        insert O;

        O.Free_MRC_Periode_Month_Invoice__c = '1';
        update O;

        OpportunitylineItem oliObjnonGsm = new OpportunitylineItem();
        oliObjnonGsm.unitprice = 10000;
        oliObjnonGsm.quantity = 2;
        oliObjnonGsm.billing_type__c = 'Monthly';
        oliObjnonGsm.Revenue_Type__c = 'Recurring';
        oliObjnonGsm.opportunityID = O.id;
        oliObjnonGsm.PricebookEntryId  = pbe.id;
        oliObjnonGsm.Product2Id = productObj.Id;
        insert oliObjnonGsm;

        OpportunitylineItem oliObjnonGsm2 = new OpportunitylineItem();
        oliObjnonGsm2.unitprice = 10000;
        oliObjnonGsm2.quantity = 2;
        oliObjnonGsm2.billing_type__c = 'Monthly';
        oliObjnonGsm2.Revenue_Type__c = 'Recurring';
        oliObjnonGsm2.opportunityID = O.id;
        oliObjnonGsm2.PricebookEntryId  = pbe.id;
        oliObjnonGsm2.Product2Id = productObj2.Id;
        insert oliObjnonGsm2;

      SAP_Material_Code__c SAPMaterialCodeRec = new SAP_Material_Code__c(
          Recurring_Material_Code__c = 'LL-02',
          Free_Material_Code__c = 'LL-12',
          Discocunt_Material_Code__c = ''
      );
      insert SAPMaterialCodeRec;

      Test.startTest();

      OpportunityService.CreateFreeMRCOpptyProducts(O.id, system.today());

      Test.stopTest();
    }
  }
}