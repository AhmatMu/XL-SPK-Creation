/**
* @description       : 
* @author            : Andre Prasetya
* @group             : 
* @last modified on  : 03-01-2022
* @last modified by  : Andre Prasetya
**/



@isTest
public class TrialMonitoringTicketAddRecordsActTest {
      @testSetup static void setup() {
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            EmailTemplate et = new EmailTemplate(); 
            et.isActive = true; 
            et.Name = 'Email Template Testing'; 
            et.DeveloperName = 'Test_Template'; 
            et.TemplateType = 'text';
            et.Subject = 'Reminder to confirm customer for Link Trial';
            et.FolderId = UserInfo.getUserId(); 
            et.Body = 'test email';
            // et.HtmlValue = '<p>Dear {!relatedTo.UserRole.Name},</p><p>Need your action for Notification because this notif in trial date termination on Trial Monitoring Ticket and need your confirmation this link will be to production or not. if go to production, please update trial monitoring ticket status.</p><c:TrialLinkComponent roleIdValue="{!relatedTo.UserRoleId}" />'; 
            
            insert et;  //error in this line
        }
        System.runAs(new User(Id=UserInfo.getUserId())){
            EmailTemplate et2 = new EmailTemplate(); 
            et2.isActive = true; 
            et2.Name = 'Oppty Trial - Email when Opportunity created Prod'; 
            et2.DeveloperName = 'Oppty_Trial_Email'; 
            et2.TemplateType = 'text';
            et2.Subject = 'Opportunity Creation';
            et2.FolderId = UserInfo.getUserId(); 
            et2.Body = 'test email';
            // et.HtmlValue = '<p>Dear {!relatedTo.UserRole.Name},</p><p>Need your action for Notification because this notif in trial date termination on Trial Monitoring Ticket and need your confirmation this link will be to production or not. if go to production, please update trial monitoring ticket status.</p><c:TrialLinkComponent roleIdValue="{!relatedTo.UserRoleId}" />'; 
            
            insert et2;  //error in this line
        }
        
        TrialLinkConversionEmailSetting__c settingEmailSalesConfirmation = new TrialLinkConversionEmailSetting__c();
        settingEmailSalesConfirmation.Name = 'Email Confirmation to Sales';
        settingEmailSalesConfirmation.AdditionalBccEmailAddress__c = 'diky.nurosid@saasten.com';
        settingEmailSalesConfirmation.AdditionalCCEmailAddress__c = 'dikynurosid@gmail.com,diky.nurosid@saasten.com';
        settingEmailSalesConfirmation.AdditionalToEmailAddress__c = 'dickynurosid@gmail.com';
        settingEmailSalesConfirmation.EmailTemplateName__c = 'Email Template Testing';
        settingEmailSalesConfirmation.SenderEmailAddress__c='Sales';
        insert settingEmailSalesConfirmation;
        TrialLinkConversionEmailSetting__c settingEmailSegment = new TrialLinkConversionEmailSetting__c();
        settingEmailSegment.Name = 'Email Notification Segments';
        settingEmailSegment.AdditionalBccEmailAddress__c = 'diky.nurosid@saasten.com';
        settingEmailSegment.AdditionalCCEmailAddress__c = 'dikynurosid@gmail.com,diky.nurosid@saasten.com';
        settingEmailSegment.AdditionalToEmailAddress__c = 'dickynurosid@gmail.com';
        settingEmailSegment.EmailTemplateName__c = 'Email Template Testing';
        settingEmailSegment.SenderEmailAddress__c='Sales';
        insert settingEmailSegment;
        
        TrialLinkConversionEmailSetting__c settingEmailCustomer = new TrialLinkConversionEmailSetting__c();
        settingEmailCustomer.Name = 'Email Notification to Customer';
        settingEmailCustomer.AdditionalBccEmailAddress__c = 'diky.nurosid@saasten.com';
        settingEmailCustomer.AdditionalCCEmailAddress__c = 'OperationRevenueManagement@xl.co.id.invalid, SalesSupport@xl.co.id.invalid';
        settingEmailCustomer.AdditionalToEmailAddress__c = 'dickynurosid@gmail.com';
        settingEmailCustomer.EmailTemplateName__c = 'Email Template Testing';
        settingEmailCustomer.SenderEmailAddress__c='operationrevenuemanagement@xl.co.id';
        insert settingEmailCustomer;
        
        TrialLinkConversionEmailSetting__c settingEmailExpired = new TrialLinkConversionEmailSetting__c();
        settingEmailExpired.Name = 'Email Notification If Trial Is Expired';
        settingEmailExpired.AdditionalBccEmailAddress__c = 'diky.nurosid@saasten.com';
        settingEmailExpired.AdditionalCCEmailAddress__c = 'OperationRevenueManagement@xl.co.id.invalid, SalesSupport@xl.co.id.invalid';
        settingEmailExpired.AdditionalToEmailAddress__c = 'dickynurosid@gmail.com';
        settingEmailExpired.EmailTemplateName__c = 'Email Template Testing';
        settingEmailExpired.SenderEmailAddress__c='operationrevenuemanagement@xl.co.id';
        insert settingEmailExpired;
        
        TrialLinkConversionGENERALSetting__c setting = new TrialLinkConversionGENERALSetting__c();
        setting.Days_before_end_date_to_implementation__c = 3.0;
        setting.Days_Before_remind_Project_Coordinator__c = 1.0;
        setting.Days_Before_of_Ticket_Creation__c = 3.0;
        insert setting;
        
        insert new Transaction__c(transactionID__c = 1);
        Circuit__c circuitRec = new Circuit__c(
            Name = '23456'   // CID
        );
        
        insert circuitRec;
        insert New SR_PR__c (SR_Number__c = 1, PR_Number__c = 1);
        
        insert New Link_CID__c(Name = 'X',
                               CID_APN__c = 1, CID_ISP__c = 1, CID_LL__c = 1, CID_MDS__c = 1, CID_MPLS__c = 1, CID_NAP__c = 1, CID_VOIP__c = 1, CID_CL__c = 1, CID_FLEET__c = 1, CID_IAAS__c = 1, CID_ISPHRB__c = 1, CID_ISPUPTO__c = 1, CID_L2VPN__c = 1, CID_MCA__c = 1, CID_NAPMIX__c = 1, CID_SSLVPN__c = 1, CID_VLL__c = 1, CID_ISPFTTX__c = 1, CID_VPLS__c = 1, CID_GSMPBX__c = 1, CID_HPABX__c = 1, CID_SMSB__c = 1, CID_WEB2SMS__c = 1, CID_MPLSWAN__c = 1, CID_NAPXLIX__c = 1, CID_ISPPROMO__c = 1, CID_VCON__c = 1, CID_4G_Access__c = 1, CID_4GACCESS__c = 1, CID_TELINS__c = 1, CID_SDWAN__c = 1, CID_SMART__c = 1, CID_DIRECTPEERING__c = 1, CID_MNCPE__c = 1);
        
        ID accountHORT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Profile salesProfile = [SELECT id FROM Profile WHERE name = 'Sales'];
        Profile solutionProfile  = [SELECT id FROM Profile WHERE name = 'Solution'];
        Profile projectCoordinatorProfile  = [SELECT id FROM Profile WHERE name = 'Project Coordinator'];
        Profile salesAdminProfile  = [SELECT id FROM Profile WHERE name = 'Sales Admin'];
        UserRole Role = [SELECT Id, Name, LastModifiedById, DeveloperName FROM UserRole WHERE DeveloperName  = 'Banking_Financial_Services'];
        User salesUser = new User(
            //UserRoleId = Role.Id,                                                  // Role
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
            //ManagerId = '0057F000002eQqQ',                                               // Manager
            ForecastEnabled = false,                                                     // Allow Forecasting
            MobilePhone = '081953119000',                                                // Mobile
            EmailEncodingKey = 'ISO-8859-1',  // Email Encoding
            Employee_ID__c = '90007498',                                                 // Employee ID
            //Sales_Group_Head__c = '0057F000005Tvn5',                                     // Sales Group Head
            Grade__c = '15',                                                             // Grade
            Employee_Category__c = 'Existing Employee'                                  // Employee Category
        );
        insert salesUser;
        
        User solutionUser = new User(
            //UserRoleId = 'undefined',                                                  // Role
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
            //DelegatedApproverId = '0057F000002NJcg',                                     // Delegated Approver
            //ManagerId = '0057F000002NJcg',                                               // Manager
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
            //DelegatedApproverId = '0057F000002NJcg',                                     // Delegated Approver
            //ManagerId = '0057F000002NJcg',                                               // Manager
            ForecastEnabled = false,                                                     // Allow Forecasting
            MobilePhone = '+62 87779770777',                                             // Mobile
            EmailEncodingKey = 'ISO-8859-1',  // Email Encoding
            Employee_ID__c = '90006544'                                                 // Employee ID
        );
        insert projectCoordinatorUser;
        
        User salesAdminUser = new User(
            //UserRoleId = 'undefined',                                                  // Role
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
            //DelegatedApproverId = '0057F000002NJcg',                                     // Delegated Approver
            //ManagerId = '0057F000002NJcg',                                               // Manager
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
            ShippingStreet = 'dsdsdsds'
        );
        insert accRec;
        accRec.OwnerId = salesUser.id;
        update  accRec;
        
        Contact contact1REC = new Contact(
            AccountId = accRec.id,                  // Account Name
            Email = 'mr.bagus.khairuzzaman@gmail.com.invalid',  // Email
            MobilePhone = '085286136041',               // Mobile
            lastName = 'Bagus'
        );
        insert contact1REC;
        
        
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
        
        Link__c link1REC = new Link__c(
            Company_Name__c = 'CV. LINTASSEMESTA BERTUAH RAYA',   // Company Name
            Capacity_Bandwidth__c = '10',                           // Capacity Bandwidth
            Name = '12-00165',                                      // CID/Link ID
            UoM__c = 'Mbps',                                        // UoM
            Link_ID__c = '020C7849L1_TEST',                              // Link ID
            Partner__c = false,                                     // Partner
            Status_Link__c = 'UNDER_PROJECT',                       // Status Link
            Service_Type__c = 'MPLS',                              // Service Type
            Routepath__c = '762675 CV Lintas Semesta Bertua Raya ..',  // Routepath
            Site_A_Name__c = accRec.id,                           // Site A Name
            Is_Trial__c = true,
            // Site_B_Name__c = null,                           // Site B Name
            BP_Site_A__c = '762675',                                // BP Site A
            // BP_Site_B__c = '762676',                                // BP Site B
            //Contract_Item__c = '3002592-1',                         // Contract Item
            //   Contract_Item_Rel__c = contractItemREC.id,                     // Contract Item Rel
            Free_Link__c = false,                                   // Free Link
            ID__c = '24514',                                        // ID
            CID__c = '12-00165',                                    // CID *
            BU__c = 'ENTERPRISE',                                   // BU
            CID_RelD__c = circuitRec.Id,                              // CID RelD
            Trial_UOM_Bandwith__c = 'Mbps',
            Trial_Capacity_Bandwith__c = '10',
            Trial_Start_Date__c = Date.newInstance(2022, 2, 7),
            Trial_End_Date__c = Date.newInstance(2022, 2, 9)
        );
        insert link1REC;
        
        //-- create Group Service
        Group_Service__c groupService1REC = new Group_Service__c(
            Name = 'FIXED',                  // Group Service Name
            Unique_ID__c = 'FIXED',            // Unique ID
            Type__c = 'BAU',                   // Type
            Search_Term__c = 'Group Service'  // Search Term
        );
        insert groupService1REC;
        
        
        // Insert Document Template
        Pdf_Template__c docRec = new Pdf_Template__c(
            Name = 'ONE SITE DOCUMENT TEMPLATE TEST',     // Pdf Template Name
            Main_Object__c = 'Opportunity',         // Main Object
            Size_Document__c = 'A4',                // Size Document
            Default_Document_Name__c = 'NEWLINK SUBSCRIPTION',   // Default Document Name
            Margin_Top__c = 4.00,                 // Margin Top
            Margin_Bottom__c = 4.00,              // Margin Bottom
            Margin_Right__c = 1.70,               // Margin Right
            Margin_Left__c = 1.70,                // Margin Left
            Unit_Document__c = 'cm',                // Unit Document
            Type_Document__c = 'potrait',           // Type Document
            Content_Footer_Margin__c = 50.00,
            Content_Header_Margin__c = 50.00, // Content Footer Margin
            Tex_Area_1__c = 'BERITA ACARA Selanjutnya disebut <table border="1" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td colspan="1" rowspan="1">Name</td><td colspan="1" rowspan="1">Qty</td><td colspan="1" rowspan="1">Price</td></tr><tr><td colspan="1" rowspan="1">%%OpportunityLineItem::Name%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::Quantity%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::UnitPrice%%</td></tr></tbody></table>, %%Opportunity::PR_Rel__r.Billing_Start_Date_IND__c%%\n\nBank Maybank Indonesia Tbk PT. XL Axiata TBK  %%StaticResource::signaturesigit%% Sigit Suhardono\n\n \n\n\n\t\t\tDiisi Oleh XL\n\n\t\t\tQuotation Number: %%Opportunity::PR_Rel__r.Opportunity_ID__c%%PR Notification: %%Opportunity::PR_Rel__r.Name%%Project ID: EWO Survey Number: SME: No\n\t\t\t',  // Tex Area 1
            Header__c = ' \n\t\t\t\t\t\tXL AXIATA\n\t\t\t \n\n\n \n',   // Header
            Footer__c = ' \t\t\tXL AXIATA \n\n'    // Footer
        );
        insert docRec;
        
        Template_Mapping__c TmcRec = new Template_Mapping__c(
            Name = 'ISP TEMPLATE',        // Main Object
            Type__c = 'BA',                // Size Document
            Product_Code__c = 'L2VPN',   // Default Document Name
            Template__c = docRec.Id
        );
        insert TmcRec;
        
        Pricebook2 pb22 = new Pricebook2(
            Name='Internet_Dedicated_Karawang',
            Service_group__c='Non-GSM',
            Product_Category__c='Subscription Based',
            SiteType__c='One Site',
            SurveyType__c='Standard',
            IsActive=true
        );
        insert pb22;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebookREC = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebookREC;
        
        Product2 pro2 = new Product2(
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
        insert pro2;
        
        PricebookEntry pbEntrySTDREC = new PricebookEntry(
            Product2Id = pro2.id,  // Product
            IsActive = true,                   // Active
            Pricebook2Id = standardPricebookREC.id,  // Price Book
            UnitPrice = 52.500,                // List Price
            UseStandardPrice = false          // Use Standard Price
        );
        insert pbEntrySTDREC;
        
        PricebookEntry pbEntry = new PricebookEntry(
            Product2Id = pro2.id,  // Product
            IsActive = true,                   // Active
            Pricebook2Id = pb22.id,  // Price Book
            UnitPrice = 52.500,                // List Price
            UseStandardPrice = false          // Use Standard Price
        );
        insert pbEntry;
        
    }
        @isTest static void AddRecordTMT(){
        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
                          FROM User 
                          WHERE lastName = 'AnnisaTEST'
                         ];
        
        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
                             FROM User 
                             WHERE lastName = 'MuhidTEST'
                            ];
        
        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Pricebook2 ONESITEPriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Internet_Dedicated_Karawang'];
         Contact contactRec = [SELECT id FROM Contact WHERE email = 'mr.bagus.khairuzzaman@gmail.com.invalid']; 
        Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'ONE SITE DOCUMENT TEMPLATE TEST'];
         Circuit__c circuitObj = new Circuit__c(
            Name = '09-00002',          // CID
            Services__c = 'Collocation'  // Services
        );
        insert circuitObj;
        
        Opportunity oppREC = new Opportunity();
        system.runas(salesUser) {
           // Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink Trial').getRecordTypeId();
           Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM').getRecordTypeId();
            //-- create Opportunity
            oppREC = new Opportunity(
                RecordTypeId = RecordTypeOppId,                                               // Opportunity Record Type
                Service_Type__c = 'Newlink',                                                // Service Type
                //Contract_Ticket__c = 'undefined',                                           // Contract Ticket
                Auto_Renewal__c = false,                                                    // Auto Renewal
                trial__c = TRUE,                                                           // trial
                //PIC_BA_Print__c = 'undefined',                                              // PIC BA Print
                Auto_Renewal_Periode__c = 3,                                              // Auto Renewal Periode
                Auto_Renewal_UOM__c = 'Bulan',                                              // Auto Renewal UOM
                //Profitability__c = 'undefined',                                             // Profitability
                Name = 'L2VPN 500Mbps Banjarmasin-Batulicin Kab Tanah Bumbu (POP to POP)',  // Opportunity Name
                AccountId = accRec.id,                                                    // Account Name
                Solution_PIC__c = solutionUser.id,                                              // Solution PIC
                CloseDate = Date.valueOf('2021-08-23'),                                     // Target Closed Date
                Actual_Closed_Date__c = Date.valueOf('2021-08-20'),                         // Actual Closed Date
                BP_Payer__c = accRec.id,                                                  // BP Payer
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
                Account_Site_A__c = accRec.id,                                            // Account Site A (BP Site) 
                Account_Site_B__c = accRec.id,                                            // Account Site B (BP Site)
                Link_Related__c = null,                                              // CID (Related)
                CID__c = '12-00170',                                                        // CID
                SR__c = '2103-002457',                                                      // SR
                //SR_Status__c = 'Close(Complete)',                                           // SR Status
                //PR__c = '2104-001944',                                                      // PR
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
            oppRec.Pricebook2id = ONESITEPriceBookREC.id;
            update oppREC;
            //-- create opportunity product instalation
            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryOneSite2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'L2VPN 500 Mbps TEST' and pricebook2.id !=:standardPriceBookId ];
            OpportunityLineItem oliInstREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 10000,                                   // Sales Price
                PricebookEntryId = pbEntryOneSite2REC.id,
                //Product2Id = '01t7F000006CcUR',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 10.000,                                  // Total Price
                Revenue_Type__c = 'One Time',                         // Charge Type
                //      Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                //      Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                //  Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
            );
            insert oliInstREC;
            //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
            oppREC.StageName = 'Survey';
            oppREC.Probability = 25; 
            update oppREC;
            //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;
            
            List<Opportunity> oppList = New List<Opportunity>();
            oppList.add(oppREC);
            List<Approval.UnlockResult> ulrList = Approval.unlock(oppList, false);
        }
        
        Test.startTest();
        //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
        Link__c linkRec = [select id, Name from Link__c WHERE Link_ID__c='020C7849L1_TEST'];
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        oppREC.Link_Related__c = linkRec.id;
        update oppREC;
        
        //Create_PR_SR_v2 createPRSRRObj = new Create_PR_SR_v2();
     /*   Create_PR_SR createPRSRRObj = new Create_PR_SR();
        createPRSRRObj.CreatePR(oppREC);
        system.debug('createPRSRRObj-->'+createPRSRRObj);
        system.debug('oppREC ==='+ oppREC);*/
    SR_PR_Notification__c SRPRObj = new SR_PR_Notification__c(
            Name = 'PR-2201-002636',                             // SR/PR Notification Name
            Project_Type__c = 'New',                               // Project Type
            Opportunity__c = oppREC.Id,                          // Opportunity
            Project_Name__c = '4G Access - AKUN TESTINGxxx,null',  // Project Name
            
            Notif_Type__c = 'PR',                                  // Notif Type
            substatus__c = null,                                   // Sub Status
            Services__c = '4G Access',                             // Services
            Comment_Description__c = null,                         // Description (Project Notes)
            Last_Activity_Update__c = null,                        // Last Activity Update
            Reasons__c = 'None',                        // Reasons
            Proof_of_Change_PR_Trial_Is_Upload__c = false,         // Proof of Change PR Trial Is Upload
            Trial_Monitoring_Ticket_Rel__c = null,                 // Trial Monitoring Ticket Rel
            Last_modified_by_trial_ticket__c = null,               // Last modified by trial ticket
            Circuit__c = circuitObj.Id,                              // Circuit
            Site_A__c = accRec.Id,                               // Site A
            CID__c = '29-00007',                                   // CID
            PIC_Site__c = contactRec.Id,                             // PIC Site
            Link_ID__c = '80-019201',                              // Link ID
            IP_LAN__c = null,                                      // IP LAN
            Capacity_Before__c = '0',                              // Capacity Before
            MSISDN__c = null,                                      // MSISDN
            UOM_before__c = null,                                  // UOM before
            Customer_Request_Lastmile_type__c = 'Simcard 3G',      // Customer Request Lastmile type
            Capacity_After__c = null,                              // Capacity After
            Type_of_Lastmile__c = 'SAF',                           // Type of Lastmile
            UOM_After__c = null,                                   // UOM After
            CPE_Managed_By__c = null,                              // CPE Managed By
            WBA_Required_File__c = true,                          // Customer Confirmation File Upload
            Notif_Date__c = Date.newInstance(2022, 1, 28),            // Notif Date
            Normal_RFS__c = Date.newInstance(2022,2,27),             // Normal RFS
            Exp_RFS_Date__c = Date.newInstance(2022,3,2),            // Exp RFS Date
            Customer_RFS_Date__c = Date.newInstance(2022,2,2),       // Customer RFS Date
            Project_Complete_Date__c = Date.newInstance(2022,2,2),   // Project Complete Date
            BA_Sent_Date__c = Date.newInstance(2022,2,3),            // BA Sent Date
            WFI_Date__c = Date.newInstance(2022,2,2),               // WFI Date
            BA_Receive_Date__c = Date.newInstance(2022,2,2),         // BA Receive Date
            Billing_Start_Date__c = Date.newInstance(2022,2,2),      // Billing Start Date
            WBA_Required_File_Date__c = Date.newInstance(2022,2,2),  // Customer Confirmation File Upload Date
            Trial__c = true,                                      // Trial
            End_Date_Trial__c = Date.newInstance(2022,4,28),         // End Date Trial
            Start_Date_Trial__c = Date.newInstance(2022,2,3),       // Start Date Trial
            Project_Coordinator_Email__c ='diky.nurosid@saasten.com',
            Project_Coordinator_Text__c = 'Nancy Citraningrum', //Project Coord
          
 			Status__c = 'Waiting For Integration'                              // Status
            //   RecordTypeId = 'undefined'                            // Record Type
            
        );
        
        insert SRPRObj;
        SRPRObj.Status__c= 'Waiting Berita Acara';
        update SRPRObj;
        

        oppREC = [select id, Link_Related__c, PR_Rel__c from Opportunity WHERE id = :oppREC.Id];
        SR_PR_Notification__c srprNotifRec = [select id, recordtype.name, status__c from SR_PR_Notification__c WHERE id = :oppREC.PR_Rel__c ];
        system.debug('srprNotifRec.recordtype ---->'+srprNotifRec.recordtype.name);
        srprNotifRec.Notif_Date__c = Date.newInstance(2022, 7, 2);                                            // Notif Date
        // srprNotifRec.Normal_RFS__c = Date.newInstance(2022, 2, 21);                                           // Normal RFS
        srprNotifRec.Exp_RFS_Date__c = Date.newInstance(2022, 2, 8);                                         // Exp RFS Date
        srprNotifRec.Customer_RFS_Date__c = Date.newInstance(2022, 2, 8);                                    // Customer RFS Date
        srprNotifRec.Project_Complete_Date__c = Date.newInstance(2022, 2, 8);                                 // Project Complete Date
        srprNotifRec.BA_Sent_Date__c = Date.newInstance(2022, 2, 8);                                        // BA Sent Date
        srprNotifRec.WFI_Date__c = Date.newInstance(2022, 2, 8);                                            // WFI Date
        srprNotifRec.Billing_Start_Date__c = Date.newInstance(2022, 2, 7);                                   // Billing Start Date
        // srprNotifRec.End_Date_Trial__c = Date.newInstance(2022, 2, 9);                                      // End Date Trial
        //  srprNotifRec.Start_Date_Trial__c = Date.newInstance(2022, 2, 7);
        srprNotifRec.Status__c = 'Waiting Berita Acara';
        
        update srprNotifRec;
        srprNotifRec.BA_Receive_Date__c = date.newInstance(2021, 12, 10);
        update srprNotifRec;
        
   
        List<link__c> linkList =[SELECT Id,is_Trial__c FROM Link__c];
  		TrialMonitoringTicketAddRecordsAction.addTrialTicketMonitoringRecords(linkList);
  		Test.stopTest();
         
    }
}