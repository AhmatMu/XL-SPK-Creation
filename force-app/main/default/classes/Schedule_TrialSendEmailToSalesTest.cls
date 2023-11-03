/**
 * @description       : 
 * @author            : Andre Prasetya
 * @group             : 
 * @last modified on  : 03-24-2022
 * @last modified by  : Andre Prasetya
**/

@isTest
private class Schedule_TrialSendEmailToSalesTest {

    //setup
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
        setting.Days_need_confirmation_to_Sales__c = 3.0;
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
            Product_Code__c = 'MPLS',   // Default Document Name
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
            Name='testProduct',
            isActive=true,
            Revenue_Type__c='One Time',
            Family = 'Non-GSM',                       // Product Family
            Product_Code2__c='MPLS'
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
    //test send email to sales
        @isTest static void sendEmailConfirmationToSales(){
        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Pricebook2 ONESITEPriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Internet_Dedicated_Karawang'];
        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
                          FROM User WHERE lastName = 'AnnisaTEST'];
        Contact contactRec = [SELECT id FROM Contact WHERE email = 'mr.bagus.khairuzzaman@gmail.com.invalid']; 
        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
                             FROM User 
                             WHERE lastName = 'MuhidTEST'
                            ];
        Link__c linkRec = [select id, Name from Link__c WHERE Link_ID__c='020C7849L1_TEST'];
        Id recordtypeTMTId = Schema.SObjectType.Trial_Monitoring_Ticket__c.getRecordTypeInfosByName().get('New Link Trial-to-Production').getRecordTypeId();
        Trial_Monitoring_Ticket__c TMTObj = new Trial_Monitoring_Ticket__c(
            RecordTypeId = recordtypeTMTId,                                          // Record Type
            Link_Conversion_Ticket_Stage__c = 'On Going Trial',                     // Trial Monitoring Ticket Stage
            Trial_Service_Type__c = 'Newlink',                                      // Trial Service Type
            Link_Conversion_Ticket_Status__c = 'Waiting Customer Confirmation',                        // Trial Monitoring Ticket Status
            Trial_Start_Date__c = Date.newInstance(2022,1,30),                        // Trial Start Date
            Trial_Reminder_Date__c = Date.newInstance(2022,2,3),                      // Trial Reminder Date
            Trial_End_Date__c = Date.newInstance(2022,2,5),                           // Trial End Date
            Trial_Reminder_Date_Move_Implementation__c = Date.newInstance(2022,2,4),  // Trial Reminder Date Move Implementation
            Trial_Capacity_Bandwith__c = null,                                      // Trial Capacity Bandwith
            Trial_Reminder_Date_Project_Coordinator__c = Date.newInstance(2022,2,2),  // Trial Reminder Date Project Coordinator
            Trial_UOM_Bandwith__c = null,                                           // Trial UOM Bandwith
            Link__c = linkRec.Id,                                                  // Link
            // Opportunity_Creation_Rel__c = 'undefined',                              // Opportunity Creation Rel
            PR_Rel__c = null,                                                // PR Rel
            EDA_Rel__c = null,                                                      // EDA Rel
            Extend_Trial_Approval_Status__c = null,                                 // Extend Trial Approval Status
            Reason_to_No_Production__c = null,                                      // Reason to No Production
            Doc_COF_Is_Uploaded__c = false,                                         // Doc COF Is Uploaded
            Is_Confirmed__c = false                                                 // Is Confirmed
        );
        insert TMTObj;
        
        List<Trial_Monitoring_Ticket__c> TrialMonitoringTicketList =[SELECT id, name, PR_Rel__r.Project_Coordinator_Email__c, owner.email FROM Trial_Monitoring_Ticket__c WHERE Link_Conversion_Ticket_Stage__c ='On Going Trial' AND Link_Conversion_Ticket_Status__c ='Waiting Customer Confirmation'];
      

            test.starttest();
            Schedule_TrialSendEmailToSales trialSendEmailtoSalesObj = new Schedule_TrialSendEmailToSales();
            
            String chron = '0 0 23 * * ?';        
            system.schedule('Test Sched', chron,  trialSendEmailtoSalesObj);
            test.stopTest(); 
    }
}