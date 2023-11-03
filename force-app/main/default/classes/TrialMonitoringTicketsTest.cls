@isTest(seealldata = false)
private class TrialMonitoringTicketsTest {
    @testSetup static void setup() {
        insert new Transaction__c(transactionID__c = 1);
             
        ID accountHORT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        Profile salesProfile = [SELECT id FROM Profile WHERE name = 'Sales'];
        Profile solutionProfile  = [SELECT id FROM Profile WHERE name = 'Solution'];
        Profile projectCoordinatorProfile  = [SELECT id FROM Profile WHERE name = 'Project Coordinator'];
        Profile salesAdminProfile  = [SELECT id FROM Profile WHERE name = 'Sales Admin'];

        //User salesUser = [SELECT id FROM user WHERE alias = 'Annisa'];
        User salesUser = new User(
            //UserRoleId = salesUserRole.id,                                                  // Role
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
            //Product__c = '01t7F000008DrDT',                                    // Product
            //Contract_Header__c = 'a0R7F00000m7MZP',                            // Contract Header
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
    }

    static testMethod void subscriptionTwoSiteCreation () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Contact contactRec = [Select id From Contact Where lastname = 'Bagus'];
        Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Leased_Line'];
        Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'LL DOCUMENT TEMPLATE TEST'];
        Test.startTest();

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
                PIC_BA_Print__c = contactRec.id,                                              // PIC BA Print
                
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


            oppRec.Pricebook2id = leasedLinePriceBookREC.id;
            update oppREC;




            //-- create opportunity product instalation
            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Installation L2VPN TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliInstREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 10000,                                   // Sales Price
                PricebookEntryId = pbEntryLL2REC.id,
                //Product2Id = '01t7F000006CcUR',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 10.000,                                  // Total Price
                Revenue_Type__c = 'One Time',                         // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
            );
            insert oliInstREC;


            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'L2VPN 500 Mbps TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;

            //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
            oppREC.StageName = 'Prospecting';
            oppREC.Probability = 25; 
            update oppREC;

            //ID NonGSMRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();   
            //oppREC.RecordTypeId = NonGSMRT;
            oppREC.StageName = 'Survey';
            update oppREC;

            //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;

            /*List<Opportunity> oppList = New List<Opportunity>();
            oppList.add(oppREC);
            List<Approval.UnlockResult> ulrList = Approval.unlock(oppList, true);*/
            
            //-- THEN TEST FOR STAGE MOVEMENT TO NEGOTTATION  (Rejection)
            /*
            oppREC.Quotation_Final_Approval__c = 'Rejected';
            oppREC.Quotation_Final_Rejection_Reason__c = 'belum sesuai';
            oppREC.StageName = 'Negotiation';
            oppREC.Probability = 30;
            update oppREC;

            //-- approval rejection
            //rejectRecord (oppREC);
            //--end of rejection
            

            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;

            */

            
        }

        //-- The stage move by non Sales

        //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        update oppREC;

        /*
        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
        oppREC.StageName = 'Waiting for BA';
        oppREC.Probability = 80;
        update oppREC;


        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        */



        Test.stopTest();

    }

    static testMethod void nonGSMLeasedLineCreation () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Contact contactRec = [Select id From Contact Where lastname = 'Bagus'];
        Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Leased_Line'];
        Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'LL DOCUMENT TEMPLATE TEST'];
        Test.startTest();

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
                PIC_BA_Print__c = contactRec.id,                                              // PIC BA Print
                
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


            oppRec.Pricebook2id = leasedLinePriceBookREC.id;
            update oppREC;




            //-- create opportunity product instalation
            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Installation L2VPN TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliInstREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 10000,                                   // Sales Price
                PricebookEntryId = pbEntryLL2REC.id,
                //Product2Id = '01t7F000006CcUR',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 10.000,                                  // Total Price
                Revenue_Type__c = 'One Time',                         // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
            );
            insert oliInstREC;


            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'L2VPN 500 Mbps TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;

            //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
            oppREC.StageName = 'Prospecting';
            oppREC.Probability = 25; 
            update oppREC;

            ID NonGSMRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();   
            oppREC.RecordTypeId = NonGSMRT;
            oppREC.StageName = 'Survey';
            update oppREC;

            //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;

            /*List<Opportunity> oppList = New List<Opportunity>();
            oppList.add(oppREC);
            List<Approval.UnlockResult> ulrList = Approval.unlock(oppList, true);*/
            
            //-- THEN TEST FOR STAGE MOVEMENT TO NEGOTTATION  (Rejection)
            /*
            oppREC.Quotation_Final_Approval__c = 'Rejected';
            oppREC.Quotation_Final_Rejection_Reason__c = 'belum sesuai';
            oppREC.StageName = 'Negotiation';
            oppREC.Probability = 30;
            update oppREC;

            //-- approval rejection
            //rejectRecord (oppREC);
            //--end of rejection
            

            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;

            */

            
        }

        //-- The stage move by non Sales

        //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        update oppREC;

        /*
        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
        oppREC.StageName = 'Waiting for BA';
        oppREC.Probability = 80;
        update oppREC;


        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        */



        Test.stopTest();

    }

   static testMethod void nonGSMLeasedLineCreationforBAPrintMoreThanOne () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Contact contactRec = [Select id From Contact Where lastname = 'Bagus'];
        Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Leased_Line'];
        Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'LL DOCUMENT TEMPLATE TEST'];
       
       
        AccountContactRelation acr2REC = [SELECT id, roles FROM AccountContactRelation WHERE contact.lastname =:'Goodboy'];
        acr2REC.roles = 'PIC Recipient Invoice;PIC BA Print;PIC BA Recipient;PIC Site;PIC Print Invoice';
        update acr2REC;
       
        Test.startTest();

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
                PIC_BA_Print__c = contactRec.id,                                              // PIC BA Print
                
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
            oppRec.Pricebook2id = leasedLinePriceBookREC.id;
            update oppREC;

            //-- create opportunity product instalation
            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Installation L2VPN TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliInstREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 10000,                                   // Sales Price
                PricebookEntryId = pbEntryLL2REC.id,
                //Product2Id = '01t7F000006CcUR',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 10.000,                                  // Total Price
                Revenue_Type__c = 'One Time',                         // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
            );
            insert oliInstREC;


            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'L2VPN 500 Mbps TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;

            //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
            oppREC.StageName = 'Prospecting';
            oppREC.Probability = 25; 
            update oppREC;

            ID NonGSMRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();   
            oppREC.RecordTypeId = NonGSMRT;
            oppREC.StageName = 'Survey';
            update oppREC;

            //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;
            
        }

        //-- The stage move by non Sales

        //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        update oppREC;

        /*
        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
        oppREC.StageName = 'Waiting for BA';
        oppREC.Probability = 80;
        update oppREC;


        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        */



        Test.stopTest();

    }



    static testMethod void nonGSMLeasedLineExistingLinkUPGRADECreation () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        User salesAdminUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'salesadminTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Link__c link1REC = [SELECT id FROM Link__c WHERE Link_ID__c = '020C7849L1_TEST'];
        Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Leased_Line'];
       	Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'LL DOCUMENT TEMPLATE TEST'];

        Opportunity oppREC = new Opportunity();
        system.runas(salesUser) {
            ID nonGSMLeasedELLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Upgrade').getRecordTypeId();   

            oppREC = new Opportunity(
                Service_Type__c = 'Upgrade',                                         // Service Type
                RecordTypeId = nonGSMLeasedELLineRT,                                            // Opportunity Record Type
                Auto_Renewal__c = false,                                               // Auto Renewal
                trial__c = false,                                                      // trial
                //PIC_BA_Print__c = acr1REC.id,                                         // PIC BA Print
                Auto_Renewal_Periode__c = 3,                                         // Auto Renewal Periode
                Auto_Renewal_UOM__c = 'Bulan',                                         // Auto Renewal UOM
                Name = 'Upgrade L2VPN to 300Mbps Makassar-Jakarta (Last Mile XL)',     // Opportunity Name
                AccountId = accRec.id,                                               // Account Name
                Solution_PIC__c = solutionUser.id,                                         // Solution PIC
                CloseDate = Date.valueOf('2021-12-10'),                                // Target Closed Date
                Actual_Closed_Date__c = Date.valueOf('2021-12-10'),                    // Actual Closed Date
                Description = 'Upgrade dari 30Mbps ke 1Gbps, Pre Survey 092021-2808',  // Description
                BP_Payer__c = accRec.id,                                             // BP Payer
                BP_VAT__c = accRec.id,                                               // BP VAT
                Contract_Periode__c = 12,                                            // Contract Periode
                StageName = 'Prospecting',                                             // Stage
                Periode_UOM__c = 'Month',                                              // Periode UOM
                Probability = 0,                                                       // Probability (%)
                Amount = 38000,                                                       // Amount
                COF_Number__c = '1',                                                   // COF Number
                Remark__c = 'Approved',                                                // Remark
                Account_Site_A__c = accRec.id,                                       // Account Site A (BP Site)
                Account_Site_B__c = accRec.id,                                       // Account Site B (BP Site)
                
                BW_before__c = '30',                                                   // Capacity before
                Uom_BW_Before__c = 'Mbps',                                             // Uom BW Before
                BW_after__c = '300',                                                   // Capacity after
                Uom_BW_After__c = 'Mbps',                                              // Uom BW After
                Lastmile_Type__c = 'Fiber',                                            // Lastmile Type
                Mark_as_Add_Link_Sales_Revenue__c = false,                             // Mark as Add Link (Sales Revenue)
                Mark_as_Sales_Revenue__c = false,                                      // Mark as Sales Revenue
            	Doc_Template__c = docRec.Id
            );
            insert oppREC;

            oppRec.Pricebook2id = leasedLinePriceBookREC.id;
            update oppRec;



            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'L2VPN 500 Mbps TEST' and pricebook2.id != :standardPriceBookId ];

            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;

            


        }

        Test.startTest();

        oppREC.Link_Related__c = link1REC.id;                                         // CID (Related)
        update oppREC;


        //System.runAs(salesAdminUser) {

            //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
            oppREC.StageName = 'Waiting for BA';
            oppREC.Probability = 80;
            update oppREC;
        //}


        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        


        Test.stopTest();
    }

    static testMethod void nonGSMLeasedLineExistingLinkRELOCATIONTwoSiteCreation () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Link__c link1REC = [SELECT id FROM Link__c WHERE Link_ID__c = '020C7849L1_TEST'];
        Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Leased_Line'];
        Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'LL DOCUMENT TEMPLATE TEST'];
            
        

        Opportunity oppREC = new Opportunity();
        system.runas(salesUser) {
            ID nonGSMLeasedELLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Newlink').getRecordTypeId();   

            oppREC = new Opportunity(
                Service_Type__c = 'Relocation',                                         // Service Type
                RecordTypeId = nonGSMLeasedELLineRT,                                            // Opportunity Record Type
                Auto_Renewal__c = false,                                               // Auto Renewal
                trial__c = false,                                                      // trial
                //PIC_BA_Print__c = 'undefined',                                         // PIC BA Print
                Auto_Renewal_Periode__c = 3,                                         // Auto Renewal Periode
                Auto_Renewal_UOM__c = 'Bulan',                                         // Auto Renewal UOM
                Name = 'Upgrade L2VPN to 300Mbps Makassar-Jakarta (Last Mile XL)',     // Opportunity Name
                AccountId = accRec.id,                                               // Account Name
                Solution_PIC__c = solutionUser.id,                                         // Solution PIC
                CloseDate = Date.valueOf('2021-12-10'),                                // Target Closed Date
                Actual_Closed_Date__c = Date.valueOf('2021-12-10'),                    // Actual Closed Date
                Description = 'Upgrade dari 30Mbps ke 1Gbps, Pre Survey 092021-2808',  // Description
                BP_Payer__c = accRec.id,                                             // BP Payer
                BP_VAT__c = accRec.id,                                               // BP VAT
                Contract_Periode__c = 12,                                            // Contract Periode
                StageName = 'Prospecting',                                             // Stage
                Periode_UOM__c = 'Month',                                              // Periode UOM
                Probability = 0,                                                       // Probability (%)
                Amount = 38000,                                                       // Amount
                COF_Number__c = '1',                                                   // COF Number
                Remark__c = 'Approved',                                                // Remark
                Account_Site_A__c = accRec.id,                                       // Account Site A (BP Site)
                Account_Site_B__c = accRec.id,                                       // Account Site B (BP Site)
                
                BW_before__c = '30',                                                   // Capacity before
                Uom_BW_Before__c = 'Mbps',                                             // Uom BW Before
                BW_after__c = '300',                                                   // Capacity after
                Uom_BW_After__c = 'Mbps',                                              // Uom BW After
                Lastmile_Type__c = 'Fiber',                                            // Lastmile Type
                Mark_as_Add_Link_Sales_Revenue__c = false,                             // Mark as Add Link (Sales Revenue)
                Mark_as_Sales_Revenue__c = false,                                      // Mark as Sales Revenue
            	Doc_Template__c = docRec.Id
            );
            insert oppREC;

            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'L2VPN 500 Mbps TEST' and pricebook2.id != :standardPriceBookId ];

            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;

            


        }

        Test.startTest();

        oppRec.Pricebook2id = leasedLinePriceBookREC.id;
        oppREC.Link_Related__c = link1REC.id;                                         // CID (Related)
        update oppREC;



        
        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
        oppREC.StageName = 'Waiting for BA';
        oppREC.Probability = 80;
        update oppREC;


        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        ID NonGSMRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM').getRecordTypeId();   
        oppREC.RecordTypeId = NonGSMRT;
        oppREC.StageName = 'Waiting for BA';
        update oppREC;

        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        


        Test.stopTest();
    }

    static testMethod void nonGSMLeasedLineExistingLinkRELOCATIONOneSiteCreation () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        //Contact contactRec2 = [SELECT id FROM Contact Where lastname = 'Bagus'];
        Link__c link1REC = [SELECT id FROM Link__c WHERE Link_ID__c = '020C7849L1_TEST'];
        Pricebook2 leasedLinePriceBookREC = [SELECT id from Pricebook2 WHERE name = 'Leased_Line'];
        Pdf_Template__c docRec = [SELECT Id From Pdf_Template__c WHERE Name = 'LL DOCUMENT TEMPLATE TEST'];
            
        Opportunity oppREC = new Opportunity();
        system.runas(salesUser) {
            ID nonGSMLeasedELLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();   

            oppREC = new Opportunity(
                Service_Type__c = 'Relocation',                                         // Service Type
                RecordTypeId = nonGSMLeasedELLineRT,                                            // Opportunity Record Type
                Auto_Renewal__c = false,                                               // Auto Renewal
                trial__c = false,                                                      // trial
                //PIC_BA_Print__c = contactRec2.id,                                         // PIC BA Print
                Auto_Renewal_Periode__c = 3,                                         // Auto Renewal Periode
                Auto_Renewal_UOM__c = 'Bulan',                                         // Auto Renewal UOM
                Name = 'Upgrade L2VPN to 300Mbps Makassar-Jakarta (Last Mile XL)',     // Opportunity Name
                AccountId = accRec.id,                                               // Account Name
                Solution_PIC__c = solutionUser.id,                                         // Solution PIC
                CloseDate = Date.valueOf('2021-12-10'),                                // Target Closed Date
                Actual_Closed_Date__c = Date.valueOf('2021-12-10'),                    // Actual Closed Date
                Description = 'Upgrade dari 30Mbps ke 1Gbps, Pre Survey 092021-2808',  // Description
                BP_Payer__c = accRec.id,                                             // BP Payer
                BP_VAT__c = accRec.id,                                               // BP VAT
                Contract_Periode__c = 12,                                            // Contract Periode
                StageName = 'Prospecting',                                             // Stage
                Periode_UOM__c = 'Month',                                              // Periode UOM
                Probability = 0,                                                       // Probability (%)
                Amount = 38000,                                                       // Amount
                COF_Number__c = '1',                                                   // COF Number
                Remark__c = 'Approved',                                                // Remark
                Account_Site_A__c = accRec.id,                                       // Account Site A (BP Site)
                Account_Site_B__c = accRec.id,                                       // Account Site B (BP Site)
                
                BW_before__c = '30',                                                   // Capacity before
                Uom_BW_Before__c = 'Mbps',                                             // Uom BW Before
                BW_after__c = '300',                                                   // Capacity after
                Uom_BW_After__c = 'Mbps',                                              // Uom BW After
                Lastmile_Type__c = 'Fiber',                                            // Lastmile Type
                Mark_as_Add_Link_Sales_Revenue__c = false,                             // Mark as Add Link (Sales Revenue)
                Mark_as_Sales_Revenue__c = false,                                      // Mark as Sales Revenue
            	Doc_Template__c = docRec.Id
            );
            insert oppREC;

            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'L2VPN 500 Mbps TEST' and pricebook2.id != :standardPriceBookId ];

            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;

            


        }

        Test.startTest();

        oppRec.Pricebook2id = leasedLinePriceBookREC.id;
        oppREC.Link_Related__c = link1REC.id;                                         // CID (Related)
        update oppREC;



        
        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
        oppREC.StageName = 'Waiting for BA';
        oppREC.Probability = 80;
        update oppREC;


        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        ID NonGSMRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM').getRecordTypeId();   
        oppREC.RecordTypeId = NonGSMRT;
        oppREC.StageName = 'Waiting for BA';
        update oppREC;

        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        


        Test.stopTest();
    }


    
    static testMethod void nonGSMNewLinkCreation () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Pricebook2 nonGSMPriceBookREC = [SELECT id, name from Pricebook2 WHERE name = 'Internet_Dedicated_Jakarta'];
            
        Test.startTest();

        Opportunity oppREC = new Opportunity();
        system.runas(salesUser) {
            ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Newlink').getRecordTypeId();   

            //-- create Opportunity
            oppREC = new Opportunity(
                Service_Type__c = 'Newlink',                       // Service Type
                //RecordTypeId = 'undefined',                          // Opportunity Record Type
                Auto_Renewal__c = true,                              // Auto Renewal
                trial__c = false,                                    // trial
                Auto_Renewal_Periode__c = 3,                       // Auto Renewal Periode
                Auto_Renewal_UOM__c = 'Bulan',                       // Auto Renewal UOM
                Name = 'IP Transit 1Gbps',                           // Opportunity Name
                Solution_PIC__c = solutionUser.id,                 // Solution PIC
                CloseDate = Date.valueOf('2021-12-10'),              // Target Closed Date
                AccountId = accRec.id,                       // Account Name
                Actual_Closed_Date__c = Date.valueOf('2021-12-10'),  // Actual Closed Date
                Expected_RFS_Date__c = Date.valueOf('2022-1-10'),
                StageName = 'Prospecting',                           // Stage
                Probability = 0,                                     // Probability (%)
                Contract_Periode__c = 12,                          // Contract Periode
                Amount = 183.000,                                    // Amount
                Periode_UOM__c = 'Month',                            // Periode UOM
                Remark__c = '',   // Remark
                LeadSource = 'Partner',                              // Lead Source
                BW_before__c = '0',                                  // Capacity before
                Uom_BW_Before__c = 'Mbps',                           // Uom BW Before
                BW_after__c = '1085',                                // Capacity after
                Uom_BW_After__c = 'Mbps',                            // Uom BW After
                //Sales_Manager_Owner__c = '0057F000002eQqQ',          // Sales Manager Owner
                Mark_as_Add_Link_Sales_Revenue__c = false,           // Mark as Add Link (Sales Revenue)
                Mark_as_Sales_Revenue__c = false,                     // Mark as Sales Revenue
                Project_Coordinator__c = '90006544 Nancy Citranigrum',
                PKS_Number__c = '123',
                cof_number__c = '456'

            );
            insert oppREC;

            oppRec.Pricebook2id = nonGSMPriceBookREC.id;
            update oppRec;

            opportunity opptyREC = [select id, Recordtypename__c, Pricebook2.Name, RecordType.Name from Opportunity where id = :oppREC.id];

            system.debug('=== oppREC 1 : ' + oppREC);
            system.debug('=== oppREC.Pricebook2.Name : ' + oppREC.Pricebook2.Name);
            system.debug('=== oppREC.RecordType.Name : ' + oppREC.RecordType.Name);
            system.debug('=== oppREC.Recordtypename__c : ' + oppREC.Recordtypename__c);



            //-- create opportunity product instalation
            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Instalasi ISP TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliInstREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 10000,                                   // Sales Price
                PricebookEntryId = pbEntryLL2REC.id,
                //Product2Id = '01t7F000006CcUR',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 10.000,                                  // Total Price
                Revenue_Type__c = 'One Time',                         // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
            );
            insert oliInstREC;


            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'NAP / IP Transit - 1085 Mbps TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;



            //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
            oppREC.StageName = 'Survey';
            oppREC.Probability = 25; 
            update oppREC;

            /*
            //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;

            List<Opportunity> oppList = New List<Opportunity>();
            oppList.add(oppREC);
            List<Approval.UnlockResult> ulrList = Approval.unlock(oppList, false);
            */


            //-- THEN TEST FOR STAGE MOVEMENT TO NEGOTTATION  (Rejection)
            /*
            oppREC.Quotation_Final_Approval__c = 'Rejected';
            oppREC.Quotation_Final_Rejection_Reason__c = 'belum sesuai';
            oppREC.StageName = 'Negotiation';
            oppREC.Probability = 30;
            update oppREC;

            //-- approval rejection
            //rejectRecord (oppREC);
            //--end of rejection
            

            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;

            */

            
        }

        //-- The stage move by non Sales

        //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        update oppREC;


        //-- SCHENARIO : Contract_Periode__c berubah 
        oppREC.Contract_Periode__c = 11;
        update oppREC;


        /*
        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
        oppREC.StageName = 'Waiting for BA';
        oppREC.Probability = 80;
        update oppREC;


        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        */



        Test.stopTest();

    }
    static testMethod void nonGSMRelocationCreation () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Link__c link1REC = [SELECT id FROM Link__c WHERE Link_ID__c = '020C7849L1_TEST'];
        
        Pricebook2 nonGSMPriceBookREC = [SELECT id, name from Pricebook2 WHERE name = 'Internet_Dedicated_Jakarta'];
        
            
        Test.startTest();

        Opportunity oppREC = new Opportunity();
        system.runas(salesUser) {
            ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Relocation').getRecordTypeId();   

            //-- create Opportunity
            oppREC = new Opportunity(
                Service_Type__c = 'Relocation',                       // Service Type
                //RecordTypeId = 'undefined',                          // Opportunity Record Type
                Auto_Renewal__c = true,                              // Auto Renewal
                trial__c = false,                                    // trial
                Auto_Renewal_Periode__c = 3,                       // Auto Renewal Periode
                Auto_Renewal_UOM__c = 'Bulan',                       // Auto Renewal UOM
                Name = 'IP Transit 1Gbps',                           // Opportunity Name
                Solution_PIC__c = solutionUser.id,                 // Solution PIC
                CloseDate = Date.valueOf('2021-12-10'),              // Target Closed Date
                AccountId = accRec.id,                       // Account Name
                Actual_Closed_Date__c = Date.valueOf('2021-12-10'),  // Actual Closed Date
                Expected_RFS_Date__c = Date.valueOf('2022-1-10'),
                StageName = 'Prospecting',                           // Stage
                Probability = 0,                                     // Probability (%)
                Contract_Periode__c = 12,                          // Contract Periode
                Amount = 183.000,                                    // Amount
                Periode_UOM__c = 'Month',                            // Periode UOM
                Remark__c = '',   // Remark
                LeadSource = 'Partner',                              // Lead Source
                BW_before__c = '0',                                  // Capacity before
                Uom_BW_Before__c = 'Mbps',                           // Uom BW Before
                BW_after__c = '1085',                                // Capacity after
                Uom_BW_After__c = 'Mbps',                            // Uom BW After
                //Sales_Manager_Owner__c = '0057F000002eQqQ',          // Sales Manager Owner
                Mark_as_Add_Link_Sales_Revenue__c = false,           // Mark as Add Link (Sales Revenue)
                Mark_as_Sales_Revenue__c = false,                     // Mark as Sales Revenue
                Project_Coordinator__c = '90006544 Nancy Citranigrum',
                PKS_Number__c = '123',
                cof_number__c = '456'


            );
            insert oppREC;

            oppRec.Pricebook2id = nonGSMPriceBookREC.id;
            oppREC.Link_Related__c = link1REC.id;                                         // CID (Related)
            update oppREC;

            opportunity opptyREC = [select id, Recordtypename__c, Pricebook2.Name, RecordType.Name from Opportunity where id = :oppREC.id];

            system.debug('=== oppREC 1 : ' + oppREC);
            system.debug('=== oppREC.Pricebook2.Name : ' + oppREC.Pricebook2.Name);
            system.debug('=== oppREC.RecordType.Name : ' + oppREC.RecordType.Name);
            system.debug('=== oppREC.Recordtypename__c : ' + oppREC.Recordtypename__c);

            //-- create opportunity product instalation
            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Instalasi ISP TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliInstREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 10000,                                   // Sales Price
                PricebookEntryId = pbEntryLL2REC.id,
                //Product2Id = '01t7F000006CcUR',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 10.000,                                  // Total Price
                Revenue_Type__c = 'One Time',                         // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
            );
            insert oliInstREC;


            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'NAP / IP Transit - 1085 Mbps TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;

            

            //-- Schenario : UPDATE TRIAL Field 
            oppREC.trial__c = true;
            update oppREC;

            //-- THEN TEST FOR STAGE MOVEMENT TO SURVEY 
            oppREC.StageName = 'Survey';
            oppREC.Probability = 25; 
            update oppREC;

            /*
            //-- THEN TEST FOR STAGE MOVEMENT TO QUOTATION FINAL 
            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;

            List<Opportunity> oppList = New List<Opportunity>();
            oppList.add(oppREC);
            List<Approval.UnlockResult> ulrList = Approval.unlock(oppList, false);
            */


            //-- THEN TEST FOR STAGE MOVEMENT TO NEGOTTATION  (Rejection)
            /*
            oppREC.Quotation_Final_Approval__c = 'Rejected';
            oppREC.Quotation_Final_Rejection_Reason__c = 'belum sesuai';
            oppREC.StageName = 'Negotiation';
            oppREC.Probability = 30;
            update oppREC;

            //-- approval rejection
            //rejectRecord (oppREC);
            //--end of rejection
            

            oppREC.StageName = 'Quotation Final';
            oppREC.Probability = 40;
            update oppREC;

            */

            
        }

        //-- The stage move by non Sales

        //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        update oppREC;

        /*
        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
        oppREC.StageName = 'Waiting for BA';
        oppREC.Probability = 80;
        update oppREC;
        

        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        
        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        */



        Test.stopTest();

    }  

    static testMethod void nonGSMRelocationWaitingForContract () { 

        User salesUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'AnnisaTEST'
        ];

        User solutionUser = [SELECT Id, Username, Department, Address, Email, MobilePhone, Alias, CommunityNickname, TimeZoneSidKey, UserRoleId, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, DelegatedApproverId, ManagerId, LastLoginDate, LastPasswordChangeDate, CreatedById, NumberOfFailedLogins, Employee_ID__c, Group_Segment__c, SM_Role_Name__c, AM_Role_Name__c, Group_Head_Name_of_Manager__c, Group_head_Role_Name_of_Manager__c 
        FROM User 
        WHERE lastName = 'MuhidTEST'
        ];

        Account accRec = [SELECT id FROM Account WHERE name = 'PT Khazanah Media Network Nusantara TEST' ];
        Link__c link1REC = [SELECT id FROM Link__c WHERE Link_ID__c = '020C7849L1_TEST'];
        //Contact contactRec1 = [SELECT id From Contact WHERE lastname = 'Bagus'];
        Pricebook2 nonGSMPriceBookREC = [SELECT id, name from Pricebook2 WHERE name = 'Internet_Dedicated_Jakarta'];
        
            
        

        Opportunity oppREC = new Opportunity();
        system.runas(salesUser) {
            ID nonGSMLeasedLineRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription Two Site Relocation').getRecordTypeId();   

            //-- create Opportunity
            oppREC = new Opportunity(
                Service_Type__c = 'Relocation',                       // Service Type
                //RecordTypeId = 'undefined',                          // Opportunity Record Type
                Auto_Renewal__c = true,                              // Auto Renewal
               //	PIC_BA_Print__c = contactRec1.id,
                trial__c = false,                                    // trial
                Auto_Renewal_Periode__c = 3,                       // Auto Renewal Periode
                Auto_Renewal_UOM__c = 'Bulan',                       // Auto Renewal UOM
                Name = 'IP Transit 1Gbps',                           // Opportunity Name
                Solution_PIC__c = solutionUser.id,                 // Solution PIC
                CloseDate = Date.valueOf('2021-12-10'),              // Target Closed Date
                AccountId = accRec.id,                       // Account Name
                Actual_Closed_Date__c = Date.valueOf('2021-12-10'),  // Actual Closed Date
                Expected_RFS_Date__c = Date.valueOf('2022-1-10'),
                StageName = 'Prospecting',                           // Stage
                Probability = 0,                                     // Probability (%)
                Contract_Periode__c = 12,                          // Contract Periode
                Amount = 183.000,                                    // Amount
                Periode_UOM__c = 'Month',                            // Periode UOM
                Remark__c = '',   // Remark
                LeadSource = 'Partner',                              // Lead Source
                BW_before__c = '0',                                  // Capacity before
                Uom_BW_Before__c = 'Mbps',                           // Uom BW Before
                BW_after__c = '1085',                                // Capacity after
                Uom_BW_After__c = 'Mbps',                            // Uom BW After
                //Sales_Manager_Owner__c = '0057F000002eQqQ',          // Sales Manager Owner
                Mark_as_Add_Link_Sales_Revenue__c = false,           // Mark as Add Link (Sales Revenue)
                Mark_as_Sales_Revenue__c = false,                     // Mark as Sales Revenue
                Project_Coordinator__c = '90006544 Nancy Citranigrum',
                PKS_Number__c = '123',
                cof_number__c = '456'


            );
            insert oppREC;

            oppRec.Pricebook2id = nonGSMPriceBookREC.id;
            oppREC.Link_Related__c = link1REC.id;                                         // CID (Related)
            update oppREC;

            opportunity opptyREC = [select id, Recordtypename__c, Pricebook2.Name, RecordType.Name from Opportunity where id = :oppREC.id];

            system.debug('=== oppREC 1 : ' + oppREC);
            system.debug('=== oppREC.Pricebook2.Name : ' + oppREC.Pricebook2.Name);
            system.debug('=== oppREC.RecordType.Name : ' + oppREC.RecordType.Name);
            system.debug('=== oppREC.Recordtypename__c : ' + oppREC.Recordtypename__c);

            //-- create opportunity product instalation
            ID standardPriceBookId = Test.getStandardPricebookId();
            PricebookEntry pbEntryLL2REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'Instalasi ISP TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliInstREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 10000,                                   // Sales Price
                PricebookEntryId = pbEntryLL2REC.id,
                //Product2Id = '01t7F000006CcUR',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 10.000,                                  // Total Price
                Revenue_Type__c = 'One Time',                         // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S8'             // Sales Revenue Rel
            );
            insert oliInstREC;


            PricebookEntry pbEntryLL1REC = [SELECT id FROM PricebookEntry WHERE product2.name = 'NAP / IP Transit - 1085 Mbps TEST' and pricebook2.id != :standardPriceBookId ];
            OpportunityLineItem oliREC = new OpportunityLineItem(
                OpportunityId = oppREC.id,                  // Opportunity
                UnitPrice = 13100,                                   // Sales Price
                PricebookEntryId = pbEntryLL1REC.id,
                //Product2Id = '01t7F000009Hd6I',                       // Product
                Request_QTY__c = 1,                                 // QTY Request
                Quantity = 1.00,                                    // Quantity
                //TotalPrice = 13.100,                                  // Total Price
                Revenue_Type__c = 'Recurring',                        // Charge Type
                Contract_Start_Date__c = system.today().addDays(5),  // Contract Start Date
                Contract_End_Date__c = system.today().addYears(1),    // Contract End Date
                Billing_Type__c = 'Monthly',                          // Billing Type
                Is_Pipeline__c = false,                               // Is Pipeline
                is_Forecast_Revenue__c = false,                       // is Forecast Revenue
                Is_Pipeline_PO__c = false,                            // Is Pipeline PO
                Mark_as_Revenue_Pipeline_OLD__c = false              // Mark as Revenue Pipeline OLD
                //Sales_Revenue_Rel__c = 'a1S7F000005I8S9'             // Sales Revenue Rel
            );
            insert oliREC;

            

            //-- Schenario : UPDATE TRIAL Field 
            oppREC.trial__c = true;
            update oppREC;

            
        }

        //-- The stage move by non Sales

        Test.startTest();
        
        //-- THEN TEST FOR STAGE MOVEMENT TO IMPLEMENTATION
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        update oppREC;

        /*
        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR BA 
        oppREC.StageName = 'Waiting for BA';
        oppREC.Probability = 80;
        update oppREC;
        */

        oppREC.trial__c = false;
        update oppREC;

        //-- THEN TEST FOR STAGE MOVEMENT TO WAITING FOR CONTRACT 
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;

        /*
        //-- THEN TEST FOR STAGE MOVEMENT TO CLOSED WON 
        oppREC.StageName = 'Closed Won';
        oppREC.Probability = 100;
        update oppREC;
        */

        Contract_Ticket__c contracTicketREC = new Contract_Ticket__c(
            Name = 'Contract Ticket for TEST',        // Name
            Full_Name__c = 'Contract Ticket for TEST',  // Full Name
            Account__c = accREC.id,                                             // Account
            Not_Hit_to_SAP__c = false,                                          // Not Hit to SAP
            TicketStatus__c = 'Pending',                                        // Ticket Status
            Pending_Reason__c = 'menunggu konfirmasi double BP site A 707358',  // Pending Reason
            First_Feedback_by_ORM__c = Date.valueOf('2021-10-22'),              // First Feedback by ORM
            Opportunity__c = oppRec.id,                                         // Opportunity
            Review_by_Contract_Manager_Date__c = Date.valueOf('2021-10-21'),    // Review by Contract Manager Date
            Pending_Date__c = Date.valueOf('2021-10-22'),                       // Pending Date
            Review_by_Finance_Date__c = Date.valueOf('2021-10-21')              // Review by Finance Date
        );
        insert contracTicketREC;

        //-- move back TO IMPLEMENTATION
        oppREC.StageName = 'Implementation';
        oppREC.Probability = 50;
        oppREC.Contract_Ticket__c = contracTicketREC.id;
        update oppREC;


        


        //-- Schenario : Move to 'Waiting for Contract' with opportunity have been contract ticket
        oppREC.StageName = 'Waiting for Contract';
        update oppREC;


        Test.stopTest();

    } 
}