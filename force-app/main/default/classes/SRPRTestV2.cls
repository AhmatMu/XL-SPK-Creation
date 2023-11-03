/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 10-13-2023
 * @last modified by  : Novando Utoyo Agmawan
 **/
@isTest(seealldata = false)

public with sharing class SRPRTestV2 {

  @testSetup static void setup() {

    System.runAs(new User(Id = UserInfo.getUserId())) {
      EmailTemplate et = new EmailTemplate();
      et.isActive = true;
      et.Name = 'Email Template Testing';
      et.DeveloperName = 'Test_Template';
      et.TemplateType = 'text';
      et.Subject = 'Reminder to confirm customer for Link Trial';
      et.FolderId = UserInfo.getUserId();
      et.Body = 'test email';
      // et.HtmlValue = '<p>Dear {!relatedTo.UserRole.Name},</p><p>Need your action for Notification because this notif in trial date termination on Trial Monitoring Ticket and need your confirmation this link will be to production or not. if go to production, please update trial monitoring ticket status.</p><c:TrialLinkComponent roleIdValue="{!relatedTo.UserRoleId}" />'; 

      insert et; //error in this line
    }
    System.runAs(new User(Id = UserInfo.getUserId())) {
      EmailTemplate et2 = new EmailTemplate();
      et2.isActive = true;
      et2.Name = 'Oppty Trial - Email when Opportunity created Prod';
      et2.DeveloperName = 'Oppty_Trial_Email';
      et2.TemplateType = 'text';
      et2.Subject = 'Opportunity Creation';
      et2.FolderId = UserInfo.getUserId();
      et2.Body = 'test email';
      // et.HtmlValue = '<p>Dear {!relatedTo.UserRole.Name},</p><p>Need your action for Notification because this notif in trial date termination on Trial Monitoring Ticket and need your confirmation this link will be to production or not. if go to production, please update trial monitoring ticket status.</p><c:TrialLinkComponent roleIdValue="{!relatedTo.UserRoleId}" />'; 

      insert et2; //error in this line
    }

    system.runAs(new user(id = userinfo.getUserId())){
      Id RecordTypeTMTId = Schema.SObjectType.Trial_Monitoring_Ticket__c.getRecordTypeInfosByName().get('New Link Trial-to-Production').getRecordTypeId();

        Trial_Monitoring_Ticket__c tmtObj = new Trial_Monitoring_Ticket__c();
          
        tmtObj.RecordTypeId = RecordTypeTMTId;                                            // Record Type
        tmtObj.Link_Conversion_Ticket_Stage__c = 'On Going Trial';                      // Trial Monitoring Ticket Stage
        tmtObj.Trial_Service_Type__c = 'newlink';                                     // Trial Service Type
        tmtObj.Link_Conversion_Ticket_Status__c = 'Production';                         // Trial Monitoring Ticket Status
        tmtObj.Trial_Start_Date__c = system.today();                         // Trial Start Date
        tmtObj.Trial_Reminder_Date__c = system.today();                      // Trial Reminder Date
        tmtObj.Trial_End_Date__c = system.today();                           // Trial End Date
        tmtObj.Trial_Reminder_Date_Move_Implementation__c = system.today();  // Trial Reminder Date Move Implementation
        tmtObj.Trial_Capacity_Bandwith__c = '500';                                      // Trial Capacity Bandwith
        tmtObj.Trial_Reminder_Date_Project_Coordinator__c = system.today();  // Trial Reminder Date Project Coordinator
        tmtObj.Trial_UOM_Bandwith__c = 'Mbps';                                          // Trial UOM Bandwith
        //tmtObj.Opportunity_Creation_Rel__c = 'undefined';                               // Opportunity Trial-to-PRODUCTION
        tmtObj.Doc_COF_Is_Uploaded__c = false;                                       // Doc COF Is Uploaded
        tmtObj.Is_Confirmed__c = false;                                                 // Is Confirmed
        
        insert tmtObj;  
    }

    TrialLinkConversionEmailSetting__c settingEmailSalesConfirmation = new TrialLinkConversionEmailSetting__c();
    settingEmailSalesConfirmation.Name = 'Email Confirmation to Sales';
    settingEmailSalesConfirmation.AdditionalBccEmailAddress__c = 'diky.nurosid@saasten.com';
    settingEmailSalesConfirmation.AdditionalCCEmailAddress__c = 'dikynurosid@gmail.com,diky.nurosid@saasten.com';
    settingEmailSalesConfirmation.AdditionalToEmailAddress__c = 'dickynurosid@gmail.com';
    settingEmailSalesConfirmation.EmailTemplateName__c = 'Email Template Testing';
    settingEmailSalesConfirmation.SenderEmailAddress__c = 'Sales';
    insert settingEmailSalesConfirmation;
    TrialLinkConversionEmailSetting__c settingEmailSegment = new TrialLinkConversionEmailSetting__c();
    settingEmailSegment.Name = 'Email Notification Segments';
    settingEmailSegment.AdditionalBccEmailAddress__c = 'diky.nurosid@saasten.com';
    settingEmailSegment.AdditionalCCEmailAddress__c = 'dikynurosid@gmail.com,diky.nurosid@saasten.com';
    settingEmailSegment.AdditionalToEmailAddress__c = 'dickynurosid@gmail.com';
    settingEmailSegment.EmailTemplateName__c = 'Email Template Testing';
    settingEmailSegment.SenderEmailAddress__c = 'Sales';
    insert settingEmailSegment;

    TrialLinkConversionEmailSetting__c settingEmailCustomer = new TrialLinkConversionEmailSetting__c();
    settingEmailCustomer.Name = 'Email Notification to Customer';
    settingEmailCustomer.AdditionalBccEmailAddress__c = 'diky.nurosid@saasten.com';
    settingEmailCustomer.AdditionalCCEmailAddress__c = 'OperationRevenueManagement@xl.co.id.invalid, SalesSupport@xl.co.id.invalid';
    settingEmailCustomer.AdditionalToEmailAddress__c = 'dickynurosid@gmail.com';
    settingEmailCustomer.EmailTemplateName__c = 'Email Template Testing';
    settingEmailCustomer.SenderEmailAddress__c = 'operationrevenuemanagement@xl.co.id';
    insert settingEmailCustomer;

    TrialLinkConversionEmailSetting__c settingEmailExpired = new TrialLinkConversionEmailSetting__c();
    settingEmailExpired.Name = 'Email Notification If Trial Is Expired';
    settingEmailExpired.AdditionalBccEmailAddress__c = 'diky.nurosid@saasten.com';
    settingEmailExpired.AdditionalCCEmailAddress__c = 'OperationRevenueManagement@xl.co.id.invalid, SalesSupport@xl.co.id.invalid';
    settingEmailExpired.AdditionalToEmailAddress__c = 'dickynurosid@gmail.com';
    settingEmailExpired.EmailTemplateName__c = 'Email Template Testing';
    settingEmailExpired.SenderEmailAddress__c = 'operationrevenuemanagement@xl.co.id';
    insert settingEmailExpired;

    TrialLinkConversionGENERALSetting__c setting = new TrialLinkConversionGENERALSetting__c();
    setting.Days_before_end_date_to_implementation__c = 3.0;
    setting.Days_Before_remind_Project_Coordinator__c = 1.0;
    setting.Days_Before_of_Ticket_Creation__c = 3.0;
    insert setting;

    insert new Transaction__c(transactionID__c = 1);
    Circuit__c circuitRec = new Circuit__c(
      Name = '23456' // CID
    );

    insert circuitRec;
    insert New SR_PR__c(SR_Number__c = 1, PR_Number__c = 1);

    insert New Link_CID__c(Name = 'X',
      CID_APN__c = 1, CID_ISP__c = 1, CID_LL__c = 1, CID_MDS__c = 1, CID_MPLS__c = 1, CID_NAP__c = 1, CID_VOIP__c = 1, CID_CL__c = 1, CID_FLEET__c = 1, CID_IAAS__c = 1, CID_ISPHRB__c = 1, CID_ISPUPTO__c = 1, CID_L2VPN__c = 1, CID_MCA__c = 1, CID_NAPMIX__c = 1, CID_SSLVPN__c = 1, CID_VLL__c = 1, CID_ISPFTTX__c = 1, CID_VPLS__c = 1, CID_GSMPBX__c = 1, CID_HPABX__c = 1, CID_SMSB__c = 1, CID_WEB2SMS__c = 1, CID_MPLSWAN__c = 1, CID_NAPXLIX__c = 1, CID_ISPPROMO__c = 1, CID_VCON__c = 1, CID_4G_Access__c = 1, CID_4GACCESS__c = 1, CID_TELINS__c = 1, CID_SDWAN__c = 1, CID_SMART__c = 1, CID_DIRECTPEERING__c = 1, CID_MNCPE__c = 1);

    ID accountHORT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

    Profile salesProfile = [SELECT id FROM Profile WHERE name = 'Sales'];
    Profile solutionProfile = [SELECT id FROM Profile WHERE name = 'Solution'];
    Profile projectCoordinatorProfile = [SELECT id FROM Profile WHERE name = 'Project Coordinator'];
    Profile salesAdminProfile = [SELECT id FROM Profile WHERE name = 'Sales Admin'];
    //UserRole Role = [SELECT Id, Name, LastModifiedById, DeveloperName FROM UserRole WHERE DeveloperName = 'Banking_Financial_Services'];
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

    User projectCoordinatorUser = new User(
      //UserRoleId = 'undefined',                                                  // Role
      Alias = 'nancy', // Alias
      Email = 'nancycitranigrum@xl.co.id', // Email
      ProfileId = projectCoordinatorProfile.Id, // Profile
      Username = 'nancycitranigrum@xl.co.id.TEST', // Username
      IsActive = true, // Active
      CommunityNickname = 'nancyTEST', // Nickname
      lastName = 'Nancy Citraningrum',
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
    accRec.OwnerId = salesUser.id;
    update accRec;

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

    Link__c link1REC = new Link__c(
      Company_Name__c = 'CV. LINTASSEMESTA BERTUAH RAYA', // Company Name
      Capacity_Bandwidth__c = '10', // Capacity Bandwidth
      Name = '12-00165', // CID/Link ID
      UoM__c = 'Mbps', // UoM
      Link_ID__c = '020C7849L1_TEST', // Link ID
      Partner__c = false, // Partner
      Status_Link__c = 'UNDER_PROJECT', // Status Link
      Service_Type__c = 'MPLS', // Service Type
      Routepath__c = '762675 CV Lintas Semesta Bertua Raya ..', // Routepath
      Site_A_Name__c = accRec.id, // Site A Name
      Is_Trial__c = true,
      // Site_B_Name__c = null,                           // Site B Name
      BP_Site_A__c = '762675', // BP Site A
      // BP_Site_B__c = '762676',                                // BP Site B
      //Contract_Item__c = '3002592-1',                         // Contract Item
      //   Contract_Item_Rel__c = contractItemREC.id,                     // Contract Item Rel
      Free_Link__c = false, // Free Link
      ID__c = '24514', // ID
      CID__c = '12-00165', // CID *
      BU__c = 'ENTERPRISE', // BU
      CID_RelD__c = circuitRec.Id, // CID RelD
      Trial_UOM_Bandwith__c = 'Mbps',
      Trial_Capacity_Bandwith__c = '10',
      Trial_Start_Date__c = Date.newInstance(2022, 2, 7),
      Trial_End_Date__c = Date.newInstance(2022, 2, 9)
    );
    insert link1REC;

    //-- create Group Service
    Group_Service__c groupService1REC = new Group_Service__c(
      Name = 'FIXED', // Group Service Name
      Unique_ID__c = 'FIXED', // Unique ID
      Type__c = 'BAU', // Type
      Search_Term__c = 'Group Service' // Search Term
    );
    insert groupService1REC;

    // Insert Document Template
    Pdf_Template__c docRec = new Pdf_Template__c(
      Name = 'ONE SITE DOCUMENT TEMPLATE TEST', // Pdf Template Name
      Main_Object__c = 'Opportunity', // Main Object
      Size_Document__c = 'A4', // Size Document
      Default_Document_Name__c = 'NEWLINK SUBSCRIPTION', // Default Document Name
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
      Product_Code__c = 'MPLS', // Default Document Name
      Template__c = docRec.Id
    );
    insert TmcRec;
    Template_Mapping__c TmcRec2 = new Template_Mapping__c(
      Name = 'L2VPN TEMPLATE', // Main Object
      Type__c = 'BA', // Size Document
      Product_Code__c = 'L2VPN', // Default Document Name
      Template__c = docRec.Id
    );
    insert TmcRec2;

    Pricebook2 pb22 = new Pricebook2(
      Name = 'Internet_Dedicated_Karawang',
      Service_group__c = 'Non-GSM',
      Product_Category__c = 'Subscription Based',
      SiteType__c = 'One Site',
      SurveyType__c = 'Standard',
      IsActive = true
    );
    insert pb22;

    Pricebook2 pb23 = new Pricebook2(
      Name = 'Internet_Dedicated_Karawang_TwoSite',
      Service_group__c = 'Non-GSM',
      Product_Category__c = 'Subscription Based',
      SiteType__c = 'Two Site',
      SurveyType__c = 'Standard',
      IsActive = true
    );
    insert pb23;

    //Instantiate the Pricebook2 record with StandardPricebookId
    Pricebook2 standardPricebookREC = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );
    //Execute an update DML on the Pricebook2 record, to make IsStandard to true
    Update standardPricebookREC;

    Product2 pro2 = new Product2(
      Name = 'testProduct',
      Group_Service__c = groupService1REC.id, // Group Service
      Family = 'Non-GSM',
      isActive = true,
      Revenue_Type__c = 'One Time',
      Product_Code2__c = 'MPLS'
    );
    insert pro2;
    Product2 pro3 = new Product2(
      Name = 'Installation testProduct2', // Product Name
      Group_Service__c = groupService1REC.id, // Group Service
      Family = 'Non-GSM', // Product Family
      IsActive = false, // Active
      SAP_Code__c = 'L2VPN-01', // SAP Code
      Product_Code2__c = 'L2VPN', // Product Code
      Revenue_Type__c = 'One Time' // Charge Type
    );
    insert pro3;

    Product2 pro4 = new Product2(
      Name = 'Reccuring testProduct2', // Product Name
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
    insert pro4;

    PricebookEntry pbEntrySTDREC = new PricebookEntry(
      Product2Id = pro2.id, // Product
      IsActive = true, // Active
      Pricebook2Id = standardPricebookREC.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntrySTDREC;

    PricebookEntry pbEntrySTDREC2 = new PricebookEntry(
      Product2Id = pro3.id, // Product
      IsActive = true, // Active
      Pricebook2Id = standardPricebookREC.id, // Price Book
      UnitPrice = 12.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntrySTDREC2;

    PricebookEntry pbEntrySTDREC3 = new PricebookEntry(
      Product2Id = pro4.id, // Product
      IsActive = true, // Active
      Pricebook2Id = standardPricebookREC.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntrySTDREC3;

    PricebookEntry pbEntry = new PricebookEntry(
      Product2Id = pro2.id, // Product
      IsActive = true, // Active
      Pricebook2Id = pb22.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntry;

    PricebookEntry pbEntry2 = new PricebookEntry(
      Product2Id = pro3.id, // Product
      IsActive = true, // Active
      Pricebook2Id = pb23.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntry2;

    PricebookEntry pbEntry3 = new PricebookEntry(
      Product2Id = pro4.id, // Product
      IsActive = true, // Active
      Pricebook2Id = pb23.id, // Price Book
      UnitPrice = 52.500, // List Price
      UseStandardPrice = false // Use Standard Price
    );
    insert pbEntry3;

  }

  @isTest static void PRMoveStageWBA() {

    Contact contactRec = [SELECT Id FROM Contact WHERE lastName = 'Goodboy'];
    Circuit__c circuitObj = [SELECT Id FROM Circuit__c WHERE Name = '23456'];
    User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'AnnisaTEST'
    ];

    User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'MuhidTEST'
    ];

    User projectCoordinatorUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'Nancy Citraningrum'
    ];

    Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST'];
    Pricebook2 ONESITEPriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Internet_Dedicated_Karawang'];
    Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'ONE SITE DOCUMENT TEMPLATE TEST'];

    Opportunity oppREC = new Opportunity();
    system.runas(salesUser) {
      Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink Trial').getRecordTypeId();
      //-- create Opportunity
      oppREC = new Opportunity(
        RecordTypeId = RecordTypeOppId, // Opportunity Record Type
        Service_Type__c = 'Newlink', // Service Type
        //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
        Auto_Renewal__c = false, // Auto Renewal
        trial__c = false, // trial
        //PIC_BA_Print__c = 'undefined',                                              // PIC BA Print
        Auto_Renewal_Periode__c = 3, // Auto Renewal Periode
        Auto_Renewal_UOM__c = 'Bulan', // Auto Renewal UOM
        //Profitability__c = 'undefined',                                             // Profitability
        Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)', // Opportunity Name
        AccountId = accRec.id, // Account Name
        Solution_PIC__c = solutionUser.id, // Solution PIC
        CloseDate = Date.valueOf('2021-08-23'), // Target Closed Date
        Actual_Closed_Date__c = Date.valueOf('2021-08-20'), // Actual Closed Date
        BP_Payer__c = accRec.id, // BP Payer
        Expected_RFS_Date__c = Date.valueOf('2021-04-30'), // Expected RFS Date
        BP_VAT__c = accRec.id, // BP VAT
        PO_Date__c = Date.valueOf('2021-04-23'), // PO Date
        Contract_Periode__c = 1, // Contract Periode
        StageName = 'Prospecting', // Stage
        Periode_UOM__c = 'week', // Periode UOM
        Probability = 100, // Probability (%)
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
      oppRec.Pricebook2id = ONESITEPriceBookREC.id;
      update oppREC;
      //-- create opportunity product instalation
      ID standardPriceBookId = Test.getStandardPricebookId();
      PricebookEntry pbEntryOneSite2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'testProduct'
        and pricebook2.id !=: standardPriceBookId
      ];
      OpportunityLineItem oliInstREC = new OpportunityLineItem(
        OpportunityId = oppREC.id, // Opportunity
        UnitPrice = 10000, // Sales Price
        PricebookEntryId = pbEntryOneSite2REC.id,
        //Product2Id = '01t7F000006CcUR',                       // Product
        Request_QTY__c = 1, // QTY Request
        Quantity = 1.00, // Quantity
        //TotalPrice = 10.000,                                  // Total Price
        Revenue_Type__c = 'One Time', // Charge Type
        //      Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
        //      Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
        //  Billing_Type__c = 'Monthly',                          // Billing Type
        Is_Pipeline__c = false, // Is Pipeline
        is_Forecast_Revenue__c = false, // is Forecast Revenue
        Is_Pipeline_PO__c = false, // Is Pipeline PO
        Mark_as_Revenue_Pipeline_OLD__c = false // Mark as Revenue Pipeline OLD
        //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
      );
      insert oliInstREC;
      //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
      oppREC.StageName = 'Survey';
      oppREC.Probability = 25;
      update oppREC;

      //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
      oppREC.StageName = 'Quotation Final';
      // oppREC.Project_Coordinator_User__c =projectCoordinatorUser.Id ;
      oppREC.Probability = 40;
      update oppREC;

      List < Opportunity > oppList = New List < Opportunity > ();
      oppList.add(oppREC);
      List < Approval.UnlockResult > ulrList = Approval.unlock(oppList, false);
    }
    Link__c linkRec = [select id, Name from Link__c WHERE Link_ID__c = '020C7849L1_TEST'];

    Id RecordTypeProfId = Schema.SObjectType.profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();
    
    Profitability__c profRec = new Profitability__c(
      Name = '020C8023L1',                                           // Profitability Name
      Account__c = accRec.id,                                        // Customer
      CID__c = linkRec.id,                                            // CID
      Opportunity__c = oppREC.id,                                    // Opportunity
      Cost_Last_Update__c = system.today(),  // Cost Last Update
      Status__c = 'Forecast',                                          // Status
      Stage__c = 'Forecast Cost is Complete',                          // Stage
      Overhead_Value__c = 0,                                           // Overhead Value
      Solution_PIC__c = solutionUser.ID,                                   // Solution PIC
      Leased_Line_Cost__c = 10.000,                                    // Leased Line Cost
      Last_Mile_Loc_A__c = 5.000,                                      // Last Mile Loc A
      Last_Mile_Loc_B__c = 5.000,                                      // Last Mile Loc B
      Converter_Loc_A__c = 2.000,                                      // Converter Loc A
      Converter_Loc_B__c = 2.000,                                      // Converter Loc B
      Pull_Cable_Loc_A__c = 2.000,                                     // Pull Cable Loc A
      BM_Loc_A__c = 2.000,                                             // BM Loc A
      Pull_Cable_Loc_B__c = 2.000,                                     // Pull Cable Loc B
      BM_Loc_B__c = 2.000,                                             // BM Loc B
      One_Time_Revenue__c = 0,                                         // One Time Revenue
      RecordTypeId = RecordTypeProfId
    );
    insert profRec;

    Test.startTest();

    //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
    
    //SR_PR_Notification__c SRPRec = [select id, Name from SR_PR_Notification__c WHERE Name='PR-2201-002636'];
    oppREC.StageName = 'Implementation';
    oppREC.Probability = 50;
    oppREC.Link_Related__c = linkRec.id;
    update oppREC;

    oppREC.profitability__c = profRec.id;
    update oppREC;
    Create_PR_SR_V2 createPRSRObj = new Create_PR_SR_V2();
    createPRSRObj.CreatePR(oppREC);

    oppREC = [select id, Link_Related__c, PR_Rel__c from Opportunity WHERE id =: oppREC.Id];
    SR_PR_Notification__c srprNotifRec = [select id, recordtype.name, status__c from SR_PR_Notification__c WHERE id =: oppREC.PR_Rel__c];
    system.debug('srprNotifRec.recordtype ---->' + srprNotifRec.recordtype.name);
    // srprNotifRec.Status__c = 'Rejected';

    Id RecordTypePRoneId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR One Site Trial').getRecordTypeId();

    srprNotifRec.recordTypeId = RecordTypePRoneId;
    srprNotifRec.Trial__c = true;
    srprNotifRec.End_Date_Trial__c = null; // End Date Trial
    srprNotifRec.Start_Date_Trial__c = null;
    update srprNotifRec;

    srprNotifRec.Notif_Date__c = Date.newInstance(2022, 7, 2); // Notif Date
    srprNotifRec.Normal_RFS__c = Date.newInstance(2022, 2, 21); // Normal RFS
    srprNotifRec.Exp_RFS_Date__c = Date.newInstance(2022, 2, 8); // Exp RFS Date
    srprNotifRec.Customer_RFS_Date__c = Date.newInstance(2022, 2, 8); // Customer RFS Date
    srprNotifRec.Project_Complete_Date__c = Date.newInstance(2022, 2, 7); // Project Complete Date
    srprNotifRec.BA_Sent_Date__c = Date.newInstance(2022, 2, 8); // BA Sent Date
    srprNotifRec.WFI_Date__c = Date.newInstance(2022, 2, 8); // WFI Date
    srprNotifRec.Billing_Start_Date__c = Date.newInstance(2022, 2, 7); // Billing Start Date

    srprNotifRec.WBA_Required_File__c = TRUE;
    srprNotifRec.BA_Receive_Date__c = Date.newInstance(2022, 2, 7);

    srprNotifRec.Status__c = 'Waiting Berita Acara';
    update srprNotifRec;

    srprNotifRec.Status__c = 'on going trial';
    update srprNotifRec;

    srprNotifRec.BA_Receive_Date__c = date.newInstance(2021, 12, 10);
    update srprNotifRec;
    srprNotifRec.Status__c = 'Complete';
    update srprNotifRec;

    system.runas(salesUser) {
      srprNotifRec.Status__c = 'Complete';
      update srprNotifRec;
    }
    test.stopTest();
  }

  static testMethod void opportunityTrial() {
    Contact contactRec = [SELECT Id FROM Contact WHERE lastName = 'Goodboy'];
    Circuit__c circuitObj = [SELECT Id FROM Circuit__c WHERE Name = '23456'];
    User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'AnnisaTEST'
    ];

    User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'MuhidTEST'
    ];

    Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST'];
    Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Internet_Dedicated_Karawang_TwoSite'];
    Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'ONE SITE DOCUMENT TEMPLATE TEST'];

    Opportunity oppREC = new Opportunity();
    system.runas(salesUser) {
      ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Newlink').getRecordTypeId();

      //-- create Opportunity
      oppREC = new Opportunity(
        RecordTypeId = nonGSMLeasedLineRT, // Opportunity Record Type
        Service_Type__c = 'Newlink', // Service Type
        //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
        Auto_Renewal__c = true, // Auto Renewal
        trial__c = TRUE, // trial
        //PIC_BA_Print__c = 'undefined',                                              // PIC BA Print
        Auto_Renewal_Periode__c = 3, // Auto Renewal Periode
        Auto_Renewal_UOM__c = 'minggu', // Auto Renewal UOM
        //Profitability__c = 'undefined',                                             // Profitability
        Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)', // Opportunity Name
        AccountId = accRec.id, // Account Name
        Solution_PIC__c = solutionUser.id, // Solution PIC
        CloseDate = Date.newInstance(2022, 02, 23), // Target Closed Date
        Actual_Closed_Date__c = Date.newInstance(2022, 02, 23), // Actual Closed Date
        BP_Payer__c = accRec.id, // BP Payer
        Expected_RFS_Date__c = Date.newInstance(2022, 02, 30), // Expected RFS Date
        BP_VAT__c = accRec.id, // BP VAT
        PO_Date__c = Date.newInstance(2022, 02, 23), // PO Date
        Contract_Periode__c = 10, // Contract Periode
        StageName = 'Prospecting', // Stage
        Periode_UOM__c = 'day', // Periode UOM
        Probability = 100, // Probability (%)
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

      //-- create opportunity product instalation
      ID standardPriceBookId = Test.getStandardPricebookId();
      PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Installation testProduct2'
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
      insert oliInstREC;

      PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Reccuring testProduct2'
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
      insert oliREC;

      //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
      oppREC.StageName = 'Survey';
      oppREC.Probability = 25;
      update oppREC;

    }

    Test.startTest();
    Id RecordTypeSRId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('SR Two Site').getRecordTypeId();
    SR_PR_Notification__c srobj = new SR_PR_Notification__c(
      Name = 'SR-2202-003346', // SR/PR Notification Name
      RecordTypeId = RecordTypeSRId, // Record Type
      Notif_Type__c = 'SR', // Notif Type
      Project_Type__c = 'New', // Project Type
      Opportunity__c = oppREC.Id, // Opportunity
      Status__c = 'Open', // Status
      Project_Name__c = 'MPLS - PT SANO KOMUNIKASI,BULELENG BALI', // Project Name
      Services__c = 'MPLS', // Services
      Site_A__c = accRec.Id, // Site A
      PIC_Site__c = contactRec.Id, // PIC Site
      Survey_Type__c = 'P2MP', // Survey Type
      Capacity_Before__c = '0', // Capacity Before
      UOM_before__c = 'Kbps', // UOM before
      ECRF_Request__c = false, // ECRF Request
      Capacity_After__c = '32', // Capacity After
      UOM_After__c = 'Kbps', // UOM After
      Notif_Date__c = Date.newInstance(2022, 2, 3), // Notif Date
      Normal_RFS__c = Date.newInstance(2022, 2, 3), // Normal RFS
      Assign_Date__c = Date.newInstance(2022, 2, 3), // Assign Date
      Survey_Date__c = Date.newInstance(2022, 2, 3), // Survey Date
      Survey_Complete_Date__c = Date.newInstance(2022, 2, 3), // Survey Complete Date
      Solution_Complete_Date__c = Date.newInstance(2022, 2, 3), // Solution Complete Date
      Solution_Request_Date__c = Date.newInstance(2022, 2, 3), // Solution Request Date
      Result_Date__c = Date.newInstance(2022, 2, 3) // Result Date
    );
    insert srobj;
    srobj.Project_Coordinator_Text__c = '90007525 Sri Hartanto';
    update srobj;
    oppREC.Project_Coordinator__c = '90007525 Sri Hartanto';
    update oppREC;
    srobj.Status__c = 'Assigned';
    update srobj;

    srobj.Status__c = 'In Progress';
    update srobj;

    srobj.Status__c = 'Close(Complete)';
    update srobj;

    //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
    oppREC.StageName = 'Quotation Final';
    oppREC.Probability = 40;
    update oppREC;

    List < Opportunity > oppList = New List < Opportunity > ();
    oppList.add(oppREC);
    List < Approval.UnlockResult > ulrList = Approval.unlock(oppList, false);
    //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
    oppREC.StageName = 'Implementation';
    oppREC.Probability = 50;
    update oppREC;

    Create_PR_SR_V2 createPRSRObj = new Create_PR_SR_V2();
    createPRSRObj.CreatePR(oppREC);
    oppREC = [select id, Link_Related__c, PR_Rel__c from Opportunity WHERE id =: oppREC.Id];
    SR_PR_Notification__c srprNotifRec = [select id, recordtype.name, status__c from SR_PR_Notification__c WHERE id =: oppREC.PR_Rel__c];

    Id RecordTypePRoneId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR One Site Trial').getRecordTypeId();

    srprNotifRec.recordTypeId = RecordTypePRoneId;
    srprNotifRec.Notif_Date__c = Date.newInstance(2022, 7, 2); // Notif Date
    srprNotifRec.Normal_RFS__c = Date.newInstance(2022, 2, 21); // Normal RFS
    srprNotifRec.Exp_RFS_Date__c = Date.newInstance(2022, 2, 8); // Exp RFS Date
    srprNotifRec.Customer_RFS_Date__c = Date.newInstance(2022, 2, 8); // Customer RFS Date
    srprNotifRec.Project_Complete_Date__c = Date.newInstance(2022, 2, 7); // Project Complete Date
    srprNotifRec.BA_Sent_Date__c = Date.newInstance(2022, 2, 8); // BA Sent Date
    srprNotifRec.WFI_Date__c = Date.newInstance(2022, 2, 8); // WFI Date
    srprNotifRec.Billing_Start_Date__c = Date.newInstance(2022, 2, 7); // Billing Start Date
    srprNotifRec.End_Date_Trial__c = Date.newInstance(2022, 2, 9); // End Date Trial
    srprNotifRec.Start_Date_Trial__c = Date.newInstance(2022, 2, 7);
    srprNotifRec.WBA_Required_File__c = TRUE;
    srprNotifRec.BA_Receive_Date__c = Date.newInstance(2022, 2, 7);

    update srprNotifRec;

    srprNotifRec.Status__c = 'Waiting Berita Acara';
    update srprNotifRec;

    oppREC.StageName = 'Waiting for BA';
    update oppREC;

    srprNotifRec.status__c = 'On going trial';
    update srprNotifRec;

    srprNotifRec.BA_Receive_Date__c = date.newInstance(2021, 12, 10);
    update srprNotifRec;
    srprNotifRec.Status__c = 'Complete';
    update srprNotifRec;

    oppREC.StageName = 'Closed Won';
    update oppREC;
    oppREC.Actual_Closed_Date__c = Date.newInstance(2022, 02, 23);
    update oppREC;

    Test.stopTest();

  }

  static testMethod void schenarioClose() {
    Contact contactRec = [SELECT Id FROM Contact WHERE lastName = 'Goodboy'];
    Circuit__c circuitObj = [SELECT Id FROM Circuit__c WHERE Name = '23456'];
    User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'AnnisaTEST'
    ];

    user sysAdmin = [SELECT Id, Username, lastName, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName like '%Administrator%'
    ];

    User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'MuhidTEST'
    ];

    Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST'];
    Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Internet_Dedicated_Karawang_TwoSite'];
    Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'ONE SITE DOCUMENT TEMPLATE TEST'];

    Opportunity oppREC = new Opportunity();

    system.runas(salesUser) {
      ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Newlink').getRecordTypeId();

      //-- create Opportunity
      oppREC = new Opportunity(
        RecordTypeId = nonGSMLeasedLineRT, // Opportunity Record Type
        Service_Type__c = 'Newlink', // Service Type
        //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
        Auto_Renewal__c = false, // Auto Renewal
        trial__c = TRUE, // trial
        //PIC_BA_Print__c = 'undefined',                                              // PIC BA Print
        Auto_Renewal_Periode__c = 3, // Auto Renewal Periode
        Auto_Renewal_UOM__c = 'hari', // Auto Renewal UOM
        //Profitability__c = 'undefined',                                             // Profitability
        Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)', // Opportunity Name
        AccountId = accRec.id, // Account Name
        Solution_PIC__c = solutionUser.id, // Solution PIC
        CloseDate = Date.newInstance(2022, 02, 23), // Target Closed Date
        Actual_Closed_Date__c = Date.newInstance(2022, 02, 23), // Actual Closed Date
        BP_Payer__c = accRec.id, // BP Payer
        Expected_RFS_Date__c = Date.newInstance(2022, 02, 30), // Expected RFS Date
        BP_VAT__c = accRec.id, // BP VAT
        PO_Date__c = Date.newInstance(2022, 02, 23), // PO Date
        Contract_Periode__c = 7, // Contract Periode
        StageName = 'Prospecting', // Stage
        Periode_UOM__c = 'day', // Periode UOM
        Probability = 100, // Probability (%)
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

      //-- create opportunity product instalation
      ID standardPriceBookId = Test.getStandardPricebookId();
      PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Installation testProduct2'
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
      insert oliInstREC;

      PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Reccuring testProduct2'
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
      insert oliREC;

      //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
      oppREC.StageName = 'Survey';
      oppREC.Probability = 25;
      update oppREC;
      Id RecordTypeSRId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('SR Two Site').getRecordTypeId();
      SR_PR_Notification__c srobj = new SR_PR_Notification__c(
        Name = 'SR-2202-003346', // SR/PR Notification Name
        RecordTypeId = RecordTypeSRId, // Record Type
        Notif_Type__c = 'SR', // Notif Type
        Project_Type__c = 'New', // Project Type
        Opportunity__c = oppREC.Id, // Opportunity
        Status__c = 'Open', // Status
        Project_Name__c = 'MPLS - PT SANO KOMUNIKASI,BULELENG BALI', // Project Name
        Services__c = 'MPLS', // Services
        Site_A__c = accRec.Id, // Site A
        PIC_Site__c = contactRec.Id, // PIC Site
        Survey_Type__c = 'P2MP', // Survey Type
        Capacity_Before__c = '0', // Capacity Before
        UOM_before__c = 'Kbps', // UOM before
        ECRF_Request__c = false, // ECRF Request
        Capacity_After__c = '32', // Capacity After
        UOM_After__c = 'Kbps', // UOM After
        Notif_Date__c = Date.newInstance(2022, 2, 3), // Notif Date
        Normal_RFS__c = Date.newInstance(2022, 2, 3), // Normal RFS
        Assign_Date__c = Date.newInstance(2022, 2, 3), // Assign Date
        Survey_Date__c = Date.newInstance(2022, 2, 3), // Survey Date
        Survey_Complete_Date__c = Date.newInstance(2022, 2, 3), // Survey Complete Date
        Solution_Complete_Date__c = Date.newInstance(2022, 2, 3), // Solution Complete Date
        Solution_Request_Date__c = Date.newInstance(2022, 2, 3), // Solution Request Date
        Result_Date__c = Date.newInstance(2022, 2, 3) // Result Date
      );
      insert srobj;

      system.runAs(sysAdmin) {
        srobj.Project_Coordinator_Text__c = '90007525 Sri Hartanto';
        update srobj;
  
        oppREC.Project_Coordinator__c = '90007525 Sri Hartanto';
        update oppREC;
        srobj.Status__c = 'Assigned';
        update srobj;
  
        srobj.Status__c = 'In Progress';
        update srobj;

        Test.startTest();
        // oppREC = [select id, Link_Related__c, SR__c from Opportunity WHERE id = :oppREC.Id];
        SR_PR_Notification__c srprNotifRec = [select id, recordtype.name, Reasons__c, status__c from SR_PR_Notification__c WHERE Name = 'SR-2202-003346'];
        srprNotifRec.Reasons__c = 'R07 No Production';
        srprNotifRec.Status__c = 'Close(Not Deliver)';
        update srprNotifRec;

        Test.stopTest();
      }
    }
  }

  static testMethod void schenarioCloseCancel() {
    Contact contactRec = [SELECT Id FROM Contact WHERE lastName = 'Goodboy'];
    Circuit__c circuitObj = [SELECT Id FROM Circuit__c WHERE Name = '23456'];
    User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'AnnisaTEST'
    ];

    user sysAdmin = [SELECT Id, Username, lastName, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName like '%Administrator%'
    ];

    User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'MuhidTEST'
    ];

    Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST'];
    Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Internet_Dedicated_Karawang_TwoSite'];
    Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'ONE SITE DOCUMENT TEMPLATE TEST'];

    Opportunity oppREC = new Opportunity();
    system.runas(salesUser) {
      ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Newlink').getRecordTypeId();

      //-- create Opportunity
      oppREC = new Opportunity(
        RecordTypeId = nonGSMLeasedLineRT, // Opportunity Record Type
        Service_Type__c = 'Newlink', // Service Type
        //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
        Auto_Renewal__c = false, // Auto Renewal
        trial__c = TRUE, // trial
        //PIC_BA_Print__c = 'undefined',                                              // PIC BA Print
        Auto_Renewal_Periode__c = 3, // Auto Renewal Periode
        Auto_Renewal_UOM__c = 'Minggu', // Auto Renewal UOM
        //Profitability__c = 'undefined',                                             // Profitability
        Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)', // Opportunity Name
        AccountId = accRec.id, // Account Name
        Solution_PIC__c = solutionUser.id, // Solution PIC
        CloseDate = Date.newInstance(2022, 02, 23), // Target Closed Date
        Actual_Closed_Date__c = Date.newInstance(2022, 02, 23), // Actual Closed Date
        BP_Payer__c = accRec.id, // BP Payer
        Expected_RFS_Date__c = Date.newInstance(2022, 02, 30), // Expected RFS Date
        BP_VAT__c = accRec.id, // BP VAT
        PO_Date__c = Date.newInstance(2022, 02, 23), // PO Date
        Contract_Periode__c = 1, // Contract Periode
        StageName = 'Prospecting', // Stage
        Periode_UOM__c = 'day', // Periode UOM
        Probability = 100, // Probability (%)
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

      //-- create opportunity product instalation
      ID standardPriceBookId = Test.getStandardPricebookId();
      PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Installation testProduct2'
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
      insert oliInstREC;

      PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Reccuring testProduct2'
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
      insert oliREC;

      //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
      oppREC.StageName = 'Survey';
      oppREC.Probability = 25;
      update oppREC;
      Id RecordTypeSRId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('SR Two Site').getRecordTypeId();
      SR_PR_Notification__c srobj = new SR_PR_Notification__c(
        Name = 'SR-2202-003346', // SR/PR Notification Name
        RecordTypeId = RecordTypeSRId, // Record Type
        Notif_Type__c = 'SR', // Notif Type
        Project_Type__c = 'New', // Project Type
        Opportunity__c = oppREC.Id, // Opportunity
        Status__c = 'Open', // Status
        Project_Name__c = 'MPLS - PT SANO KOMUNIKASI,BULELENG BALI', // Project Name
        Services__c = 'MPLS', // Services
        Site_A__c = accRec.Id, // Site A
        PIC_Site__c = contactRec.Id, // PIC Site
        Survey_Type__c = 'P2MP', // Survey Type
        Capacity_Before__c = '0', // Capacity Before
        UOM_before__c = 'Kbps', // UOM before
        ECRF_Request__c = false, // ECRF Request
        Capacity_After__c = '32', // Capacity After
        UOM_After__c = 'Kbps', // UOM After
        Notif_Date__c = Date.newInstance(2022, 2, 3), // Notif Date
        Normal_RFS__c = Date.newInstance(2022, 2, 3), // Normal RFS
        Assign_Date__c = Date.newInstance(2022, 2, 3), // Assign Date
        Survey_Date__c = Date.newInstance(2022, 2, 3), // Survey Date
        Survey_Complete_Date__c = Date.newInstance(2022, 2, 3), // Survey Complete Date
        Solution_Complete_Date__c = Date.newInstance(2022, 2, 3), // Solution Complete Date
        Solution_Request_Date__c = Date.newInstance(2022, 2, 3), // Solution Request Date
        Result_Date__c = Date.newInstance(2022, 2, 3) // Result Date
      );
      insert srobj;
      system.runAs(sysAdmin) {
        srobj.Project_Coordinator_Text__c = '90007525 Sri Hartanto';
        update srobj;
        oppREC.Project_Coordinator__c = '90007525 Sri Hartanto';
        update oppREC;
        srobj.Status__c = 'Assigned';
        update srobj;

        srobj.Status__c = 'In Progress';
        update srobj;

        Test.startTest();
        // oppREC = [select id, Link_Related__c, SR__c from Opportunity WHERE id = :oppREC.Id];
        SR_PR_Notification__c srprNotifRec = [select id, recordtype.name, Reasons__c, status__c from SR_PR_Notification__c WHERE Name = 'SR-2202-003346'];
        srprNotifRec.Reasons__c = 'R07 No Production';
        srprNotifRec.Status__c = 'Close(Cancel)';
        update srprNotifRec;

        Test.stopTest();
      }
    }
  }

  static testMethod void schenarioRejected() {
    Contact contactRec = [SELECT Id FROM Contact WHERE lastName = 'Goodboy'];
    Circuit__c circuitObj = [SELECT Id FROM Circuit__c WHERE Name = '23456'];
    User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'AnnisaTEST'
    ];

    user sysAdmin = [SELECT Id, Username, lastName, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName like '%Administrator%'
    ];

    User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'MuhidTEST'
    ];

    Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST'];
    Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Internet_Dedicated_Karawang_TwoSite'];
    Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'ONE SITE DOCUMENT TEMPLATE TEST'];

    Opportunity oppREC = new Opportunity();
    system.runas(salesUser) {
      ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Newlink').getRecordTypeId();

      //-- create Opportunity
      oppREC = new Opportunity(
        RecordTypeId = nonGSMLeasedLineRT, // Opportunity Record Type
        Service_Type__c = 'Newlink', // Service Type
        //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
        Auto_Renewal__c = false, // Auto Renewal
        trial__c = TRUE, // trial
        //PIC_BA_Print__c = 'undefined',                                              // PIC BA Print
        Auto_Renewal_Periode__c = 3, // Auto Renewal Periode
        Auto_Renewal_UOM__c = 'hari', // Auto Renewal UOM
        //Profitability__c = 'undefined',                                             // Profitability
        Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)', // Opportunity Name
        AccountId = accRec.id, // Account Name
        Solution_PIC__c = solutionUser.id, // Solution PIC
        CloseDate = Date.newInstance(2022, 02, 23), // Target Closed Date
        Actual_Closed_Date__c = Date.newInstance(2022, 02, 23), // Actual Closed Date
        BP_Payer__c = accRec.id, // BP Payer
        Expected_RFS_Date__c = Date.newInstance(2022, 02, 30), // Expected RFS Date
        BP_VAT__c = accRec.id, // BP VAT
        PO_Date__c = Date.newInstance(2022, 02, 23), // PO Date
        Contract_Periode__c = 1, // Contract Periode
        StageName = 'Prospecting', // Stage
        Periode_UOM__c = 'week', // Periode UOM
        Probability = 100, // Probability (%)
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

      //-- create opportunity product instalation
      ID standardPriceBookId = Test.getStandardPricebookId();
      PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Installation testProduct2'
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
      insert oliInstREC;

      PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Reccuring testProduct2'
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
      insert oliREC;

      //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
      oppREC.StageName = 'Survey';
      oppREC.Probability = 25;
      update oppREC;

      system.runAs(sysAdmin){
        Id RecordTypeSRId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('SR Two Site').getRecordTypeId();
        SR_PR_Notification__c srobj = new SR_PR_Notification__c(
          Name = 'SR-2202-003346', // SR/PR Notification Name
          RecordTypeId = RecordTypeSRId, // Record Type
          Notif_Type__c = 'SR', // Notif Type
          Project_Type__c = 'New', // Project Type
          Opportunity__c = oppREC.Id, // Opportunity
          Status__c = 'Open', // Status
          Project_Name__c = 'MPLS - PT SANO KOMUNIKASI,BULELENG BALI', // Project Name
          Services__c = 'MPLS', // Services
          Site_A__c = accRec.Id, // Site A
          PIC_Site__c = contactRec.Id, // PIC Site
          Survey_Type__c = 'P2MP', // Survey Type
          Capacity_Before__c = '0', // Capacity Before
          UOM_before__c = 'Kbps', // UOM before
          ECRF_Request__c = false, // ECRF Request
          Capacity_After__c = '32', // Capacity After
          UOM_After__c = 'Kbps', // UOM After
          Notif_Date__c = Date.newInstance(2022, 2, 3), // Notif Date
          Normal_RFS__c = Date.newInstance(2022, 2, 3), // Normal RFS
          Assign_Date__c = Date.newInstance(2022, 2, 3), // Assign Date
          Survey_Date__c = Date.newInstance(2022, 2, 3), // Survey Date
          Survey_Complete_Date__c = Date.newInstance(2022, 2, 3), // Survey Complete Date
          Solution_Complete_Date__c = Date.newInstance(2022, 2, 3), // Solution Complete Date
          Solution_Request_Date__c = Date.newInstance(2022, 2, 3), // Solution Request Date
          Result_Date__c = Date.newInstance(2022, 2, 3),
          Project_Coordinator_Text__c = '90007525 Sri Hartanto'
          // Result Date
        );
        insert srobj;
  
        oppREC.Project_Coordinator__c = '90007525 Sri Hartanto';
        update oppREC;
        srobj.Status__c = 'Assigned';
        update srobj;
  
        srobj.Status__c = 'In Progress';
        update srobj;
      
  
      Test.startTest();
      // oppREC = [select id, Link_Related__c, SR__c from Opportunity WHERE id = :oppREC.Id];
      SR_PR_Notification__c srprNotifRec = [select id, recordtype.name, Reasons__c, status__c from SR_PR_Notification__c WHERE Name = 'SR-2202-003346'];
      srprNotifRec.Reasons__c = 'R07 No Production';
      srprNotifRec.Status__c = 'Rejected';
      update srprNotifRec;
  
      Test.stopTest();
      }
    }
  }
  static testMethod void schenarioPRCancel() {
    Contact contactRec = [SELECT Id FROM Contact WHERE lastName = 'Goodboy'];
    Circuit__c circuitObj = [SELECT Id FROM Circuit__c WHERE Name = '23456'];
    User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'AnnisaTEST'
    ];

    user sysAdmin = [SELECT Id, Username, lastName, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName like '%Administrator%'
    ];

    User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'MuhidTEST'
    ];

    User projectCoordinatorUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c
      FROM User
      WHERE lastName = 'Nancy Citraningrum'
    ];

    Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST'];
    Pricebook2 ONESITEPriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Internet_Dedicated_Karawang'];
    Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'ONE SITE DOCUMENT TEMPLATE TEST'];

    Opportunity oppREC = new Opportunity();
    system.runas(salesUser) {
      Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink Trial').getRecordTypeId();
      //-- create Opportunity
      oppREC = new Opportunity(
        RecordTypeId = RecordTypeOppId, // Opportunity Record Type
        Service_Type__c = 'Newlink', // Service Type
        //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
        Auto_Renewal__c = false, // Auto Renewal
        trial__c = TRUE, // trial
        //PIC_BA_Print__c = 'undefined',                                              // PIC BA Print
        Auto_Renewal_Periode__c = 3, // Auto Renewal Periode
        Auto_Renewal_UOM__c = 'Bulan', // Auto Renewal UOM
        //Profitability__c = 'undefined',                                             // Profitability
        Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)', // Opportunity Name
        AccountId = accRec.id, // Account Name
        Solution_PIC__c = solutionUser.id, // Solution PIC
        CloseDate = Date.valueOf('2021-08-23'), // Target Closed Date
        Actual_Closed_Date__c = Date.valueOf('2021-08-20'), // Actual Closed Date
        BP_Payer__c = accRec.id, // BP Payer
        Expected_RFS_Date__c = Date.valueOf('2021-04-30'), // Expected RFS Date
        BP_VAT__c = accRec.id, // BP VAT
        PO_Date__c = Date.valueOf('2021-04-23'), // PO Date
        Contract_Periode__c = 1, // Contract Periode
        StageName = 'Prospecting', // Stage
        Periode_UOM__c = 'Week', // Periode UOM
        Probability = 100, // Probability (%)
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
      oppRec.Pricebook2id = ONESITEPriceBookREC.id;
      update oppREC;
      //-- create opportunity product instalation
      ID standardPriceBookId = Test.getStandardPricebookId();
      PricebookEntry pbEntryOneSite2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'testProduct'
        and pricebook2.id !=: standardPriceBookId
      ];
      OpportunityLineItem oliInstREC = new OpportunityLineItem(
        OpportunityId = oppREC.id, // Opportunity
        UnitPrice = 10000, // Sales Price
        PricebookEntryId = pbEntryOneSite2REC.id,
        //Product2Id = '01t7F000006CcUR',                       // Product
        Request_QTY__c = 1, // QTY Request
        Quantity = 1.00, // Quantity
        //TotalPrice = 10.000,                                  // Total Price
        Revenue_Type__c = 'One Time', // Charge Type
        //      Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
        //      Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
        //  Billing_Type__c = 'Monthly',                          // Billing Type
        Is_Pipeline__c = false, // Is Pipeline
        is_Forecast_Revenue__c = false, // is Forecast Revenue
        Is_Pipeline_PO__c = false, // Is Pipeline PO
        Mark_as_Revenue_Pipeline_OLD__c = false // Mark as Revenue Pipeline OLD
        //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
      );
      insert oliInstREC;
      //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
      oppREC.StageName = 'Survey';
      oppREC.Probability = 25;
      update oppREC;

      //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
      oppREC.StageName = 'Quotation Final';
      // oppREC.Project_Coordinator_User__c =projectCoordinatorUser.Id ;
      oppREC.Probability = 40;
      update oppREC;

      List < Opportunity > oppList = New List < Opportunity > ();
      oppList.add(oppREC);
      List < Approval.UnlockResult > ulrList = Approval.unlock(oppList, false);

      system.runAs(sysAdmin) {
        Test.startTest();
        //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
        Link__c linkRec = [select id, Name from Link__c WHERE Link_ID__c = '020C7849L1_TEST'];
        //SR_PR_Notification__c SRPRec = [select id, Name from SR_PR_Notification__c WHERE Name='PR-2201-002636'];
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        oppREC.Link_Related__c = linkRec.id;
        update oppREC;
        Create_PR_SR_V2 createPRSRObj = new Create_PR_SR_V2();
        createPRSRObj.CreatePR(oppREC);

        oppREC = [select id, Link_Related__c, PR_Rel__c from Opportunity WHERE id =: oppREC.Id];
        SR_PR_Notification__c srprNotifRec = [select id, recordtype.name, status__c from SR_PR_Notification__c WHERE id =: oppREC.PR_Rel__c];
        system.debug('srprNotifRec.recordtype ---->' + srprNotifRec.recordtype.name);

        Id RecordTypeSRPRId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR One Site Trial').getRecordTypeId();
        srprNotifRec.recordTypeId = RecordTypeSRPRId;

        oppREC.loss_reason__c = 'others';
        oppREC.Loss_Reason_Description__c = 'test';
        srprNotifRec.Reasons__c = 'R05 XL Schedule';
        //srprNotifRec.Status__c = 'cancel';
        update srprNotifRec;

        Test.stopTest();
      }
    }
  }
}