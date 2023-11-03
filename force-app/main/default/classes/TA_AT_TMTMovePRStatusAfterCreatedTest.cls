/**
* @description       : 
* @author            : Diky Nurosid
* @group             : 
* @last modified on  : 09-29-2022
* @last modified by  : Diky Nurosid
**/
@isTest(seealldata=false)
public class TA_AT_TMTMovePRStatusAfterCreatedTest {
    
    @testSetup static void setup() {
        // in test === trialmonitoringticketservicestest.TrialMonitoringTicketServicesTest ===
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
        
        Profile salesProfile = [SELECT id FROM Profile WHERE name = 'Sales'];
        Profile solutionProfile = [SELECT id FROM Profile WHERE name = 'Solution'];
        Profile projectCoordinatorProfile = [SELECT id FROM Profile WHERE name = 'Project Coordinator'];
        Profile salesAdminProfile = [SELECT id FROM Profile WHERE name = 'Sales Admin'];
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
            
            UserRole RoleObj = new UserRole(
                Name = 'Technical Financial Services',
                DeveloperName = 'Technical_Financial_Services'
            );
            insert RoleObj;
            User salesUser = new User(
                UserRoleId = RoleObj.Id, // Role
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
                Grade__c = '15', // Grade
                Employee_Category__c = 'Existing Employee' // Employee Category
            );
            insert salesUser;
            
            User solutionUser = new User(
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
                LanguageLocaleKey = 'en_US',
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
                LanguageLocaleKey = 'en_US',                                    
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
                LanguageLocaleKey = 'en_US', 
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
        }
        
        insert new Transaction__c(transactionID__c = 1);
        Circuit__c circuitRec = new Circuit__c(
            Name = '23456' // CID
        );
        
        insert circuitRec;
        
        insert New SR_PR__c(SR_Number__c = 1, PR_Number__c = 1);
        
        insert New Link_CID__c(Name = 'X',
                               CID_APN__c = 1, CID_ISP__c = 1, CID_LL__c = 1, CID_MDS__c = 1, CID_MPLS__c = 1, CID_NAP__c = 1, CID_VOIP__c = 1, CID_CL__c = 1, CID_FLEET__c = 1, CID_IAAS__c = 1, CID_ISPHRB__c = 1, CID_ISPUPTO__c = 1, CID_L2VPN__c = 1, CID_MCA__c = 1, CID_NAPMIX__c = 1, CID_SSLVPN__c = 1, CID_VLL__c = 1, CID_ISPFTTX__c = 1, CID_VPLS__c = 1, CID_GSMPBX__c = 1, CID_HPABX__c = 1, CID_SMSB__c = 1, CID_WEB2SMS__c = 1, CID_MPLSWAN__c = 1, CID_NAPXLIX__c = 1, CID_ISPPROMO__c = 1, CID_VCON__c = 1, CID_4G_Access__c = 1, CID_4GACCESS__c = 1, CID_TELINS__c = 1, CID_SDWAN__c = 1, CID_SMART__c = 1, CID_DIRECTPEERING__c = 1, CID_MNCPE__c = 1);
        
        ID accountHORT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
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
            ShippingStreet = 'dsdsdsds'
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
            BP_Site_A__c = '762675', // BP Site A
            Free_Link__c = false, // Free Link
            ID__c = '24514', // ID
            CID__c = '12-00165', // CID *
            BU__c = 'ENTERPRISE', // BU
            CID_RelD__c = circuitRec.Id, // CID RelD
            Trial_UOM_Bandwith__c = 'Mbps',
            Trial_Capacity_Bandwith__c = '10',
            Trial_Start_Date__c = Date.newInstance(2022, 2, 7),
            Trial_End_Date__c = Date.newInstance(2022, 2, 9),
            trial_service_type__c = 'newlink'
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
            Product_Code__c = 'L2VPN', // Default Document Name
            Template__c = docRec.Id
        );
        insert TmcRec;
        
        Pricebook2 pb22 = new Pricebook2(
            Name = 'Internet_Dedicated_Karawang',
            Service_group__c = 'Non-GSM',
            Product_Category__c = 'Subscription Based',
            SiteType__c = 'One Site',
            SurveyType__c = 'Standard',
            IsActive = true
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
        insert pro2;
        
        PricebookEntry pbEntrySTDREC = new PricebookEntry(
            Product2Id = pro2.id, // Product
            IsActive = true, // Active
            Pricebook2Id = standardPricebookREC.id, // Price Book
            UnitPrice = 52.500, // List Price
            UseStandardPrice = false // Use Standard Price
        );
        insert pbEntrySTDREC;
        
        PricebookEntry pbEntry = new PricebookEntry(
            Product2Id = pro2.id, // Product
            IsActive = true, // Active
            Pricebook2Id = pb22.id, // Price Book
            UnitPrice = 52.500, // List Price
            UseStandardPrice = false // Use Standard Price
        );
        insert pbEntry;

        SR_PR_Notification__c srprObj = new SR_PR_Notification__c(
            Name = 'PR-2209-002864',                                             // SR/PR Notification Name
            Project_Type__c = 'New',                                               // Project Type
            //Opportunity__c = 'undefined',                                          // Opportunity
            Project_Name__c = 'ISP - PT SANO KOMUNIKASI,POP XL Site 2545 Lovina',  // Project Name
            Status__c = 'Waiting For Integration',                                 // Status
            Notif_Type__c = 'PR',                                                  // Notif Type
            Services__c = 'ISP',                                                   // Services
            //Link__c = 'undefined',                                                 // Link
            Proof_of_Change_PR_Trial_Is_Upload__c = false,                         // Proof of Change PR Trial Is Upload
            //Circuit__c = 'undefined',                                              // Circuit
            //Site_A__c = 'undefined',                                               // Site A
            CID__c = '03-00046',                                                   // CID
            //PIC_Site__c = 'undefined',                                             // PIC Site
            Link_ID__c = '03-00046',                                               // Link ID
            Capacity_Before__c = '0',                                              // Capacity Before
            UOM_before__c = 'Mbps',                                                // UOM before
            Customer_Request_Lastmile_type__c = 'Radio',                           // Customer Request Lastmile type
            Capacity_After__c = '10',                                              // Capacity After
            Type_of_Lastmile__c = 'iPASOLINK',                                     // Type of Lastmile
            UOM_After__c = 'Mbps',                                                 // UOM After
            WBA_Required_File__c = false,                                          // Customer Confirmation File Upload
            Notif_Date__c = Date.newInstance(2022, 9, 17),//Date.valueOf('9-28-2022'),                             // Notif Date
            Normal_RFS__c = Date.newInstance(2022, 9, 17),                            // Normal RFS
            Exp_RFS_Date__c = date.newInstance(2022, 9, 17),                          // Exp RFS Date
            Customer_RFS_Date__c = date.newInstance(2022, 9, 17),                     // Customer RFS Date
            Project_Complete_Date__c = Date.newInstance(2022, 9, 17),                  // Project Complete Date
            WFI_Date__c = Date.newInstance(2022, 9, 17),                               // WFI Date
            Billing_Start_Date__c = Date.newInstance(2022, 9, 17),                     // Billing Start Date
            WBA_Required_File_Date__c = Date.newInstance(2022, 9, 17),                 // Customer Confirmation File Upload Date
            Trial__c = true,                                                      // Trial
            End_Date_Trial__c = Date.newInstance(2022, 9, 17),                        // End Date Trial
            Start_Date_Trial__c = Date.newInstance(2022, 9, 17)                    // Start Date Trial
            //RecordTypeId = 'undefined'                                            // Record Type
            );
        insert srprObj;
    }

    @isTest static void afterInsertTMT(){

        SR_PR_Notification__c srprRec = [select id from SR_PR_Notification__c limit 1];
    
        Trial_Monitoring_Ticket__c TMTObj = new Trial_Monitoring_Ticket__c(
        //RecordTypeId = 'undefined',                                             // Record Type
        Link_Conversion_Ticket_Stage__c = 'On Going Trial',                       // Trial Monitoring Ticket Stage
        Trial_Service_Type__c = 'Newlink',                                        // Trial Service Type
        Link_Conversion_Ticket_Status__c = 'Waiting Customer Confirmation',       // Trial Monitoring Ticket Status
        Trial_Start_Date__c = Date.newInstance(2022, 9, 17),                          // Trial Start Date
        Trial_Reminder_Date__c = Date.newInstance(2022, 9, 17),                       // Trial Reminder Date
        Trial_End_Date__c = Date.newInstance(2022, 9, 17),                           // Trial End Date
        Trial_Reminder_Date_Move_Implementation__c = Date.newInstance(2022, 9, 17),  // Trial Reminder Date Move Implementation
        Trial_Capacity_Bandwith__c = '10',                                        // Trial Capacity Bandwith
        Trial_Reminder_Date_Project_Coordinator__c = Date.newInstance(2022, 9, 17),  // Trial Reminder Date Project Coordinator
        Trial_UOM_Bandwith__c = 'Mbps',                                           // Trial UOM Bandwith
        //Link__c = 'undefined',                                                    // Link
        PR_Rel__c = srprRec.id,                                                  // PR TRIAL
        Doc_COF_Is_Uploaded__c = false,                                           // Doc COF Is Uploaded
        Is_Confirmed__c = false                                                  // Is Confirmed
        );
    
    test.startTest();

    insert TMTObj;

    test.stopTest();
    }
}