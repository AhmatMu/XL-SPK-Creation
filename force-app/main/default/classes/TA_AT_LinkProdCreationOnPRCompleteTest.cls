@isTest
private class TA_AT_LinkProdCreationOnPRCompleteTest {
    static testMethod void testAfterUpdate() {
        
        insert new Transaction__c(transactionID__c = 1);
        Circuit__c circuitRec = new Circuit__c(
            Name = '23456' // CID
        );
        
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

            Type__c = 'BA', // Size Document
            Product_Code__c = 'NAP', // Default Document Name
            Template__c = docRec.Id
        );
        insert TmcRec;
        
        insert circuitRec;
        Link__c link = new Link__c(
            Company_Name__c = 'SOJATEK JEMBER',   // Company Name
            Capacity_Bandwidth__c = '1',            // Capacity Bandwidth
            Name = '03-00052',                      // CID/Link ID
            UoM__c = 'Gbps',                        // UoM
            Link_ID__c = '03-00052',                // Link ID
            Partner__c = false,                     // Partner
            Status_Link__c = 'IN_SERVICE',          // Status Link
            Service_Type__c = 'NAP',                // Service Type
            Site_A_Name__c = '0017F00002qEgQW',     // Site A Name
            BP_Site_A__c = '764040',                // BP Site A
            Lastmile_Type_A__c = 'OPTIC',           // Lastmile Type A
            Free_Link__c = false,                   // Free Link
            Is_Trial__c = false,                    // Is Trial
            Trial_Service_Type__c = 'Upgrade',      // Trial Service Type
            Trial_Capacity_Bandwith__c = '1240',    // Trial Capacity Bandwith
            Trial_UOM_Bandwith__c = 'Mbps',         // Trial UOM Bandwith
            CID__c = '03-00052',                    // CID *
            CID_RelD__c = circuitRec.Id        // CID RelD
        );
        insert link;
        
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account accObj = new Account(
            Kwitansi__c = false,                                                      // Kwitansi
            Faktur_Pajak__c = false,                                                    // Faktur Pajak
            Summary_Billing__c = false,                                                 // Summary Billing
            summary_invoice__c = false,                                                 // summary invoice
            Name = 'PT Solusi Jasa Teknologi',                         // Account Name
            RecordTypeId = RecordTypeAccId,                                                 // Account Record Type
            BP_Number__c = '763451',                                                    // BP Number
            Organization_Type__c = 'Head Office',                                       // Organization Type
            Type = 'Customer',                                                          // Type
            Phone = '0251.7559955',                                                     // Phone
            Keyword__c = 'Solusi jaya',                                                 // Keyword
            Customer_Type__c = 'NONGSM',                                                // Customer Type
            Payer_For_GSM_Invoice__c = false,                                           // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',                         // Term of Payment
            Customer_VAT_Name__c = 'PT Solusi Jasa Teknologi',                          // Customer VAT Name
            Is_New_Customer__c = false,                                                 // Is New Customer
            Approval_Status__c = 'Approved',                                            // Approval Status
            Using_HO_Billing_Address__c = false,                                        // Using HO Billing Address
            No_NPWP__c = '946965548404000',                                             // No NPWP
            NPWP_Expired_Date__c = System.today().addMonths(1),                           // NPWP Expired Date
            Bad_Debt_Status__c = 'False',                                               // Bad Debt Status
            Bad_Debt_Last_Checking_Date__c = System.today().addMonths(2)  // Bad Debt Last Checking Date
        );
        insert accObj;
        
        Account acc2Obj = new Account(
            Name = 'PT. SOLUSI JASA TEKNOLOGI',              // Account Name
            RecordTypeId = RecordTypeAccId,                                       // Account Record Type
            BP_Number__c = '764040',                                          // BP Number
            Organization_Type__c = 'Branch',                                  // Organization Type
            ParentId = accObj.Id,                                     // Parent Account
            Unique_Name__c = 'SOJATEK_98039001_CV. Tirta Prima Rasa Jember',  // Unique Name
            Keyword__c = 'Solusi jaya',                                       // Keyword
            Customer_Type__c = 'NONGSM',                                      // Customer Type
            Payer_For_GSM_Invoice__c = false,                                 // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',               // Term of Payment
            Company_Group__c = 'PT. SOLUSI JASA TEKNOLOGI',                   // Company_Group
            Customer_VAT_Name__c = 'PT. SOLUSI JASA TEKNOLOGI',               // Customer VAT Name
            Is_New_Customer__c = false,                                       // Is New Customer
            Approval_Status__c = 'Approved',                                  // Approval Status
            Using_HO_Billing_Address__c = false                              // Using HO Billing Address
        );
        insert acc2Obj;
        Contact contact = new Contact(
            LastName = 'Puji Hartanto',
            AccountId = acc2Obj.Id,              // Account Name
            Email = 'puji.hartanto@sojatek.com.invalid',  // Email
            Phone = '02517559955',                        // Phone
            MobilePhone = '081298779775'                 // Mobile
        );
        insert contact;
        Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();
        Opportunity opp = new Opportunity(
            Service_Type__c = 'Newlink',                                                     // Service Type
            RecordTypeId = RecordTypeOppId,                                                        // Opportunity Record Type
            Auto_Renewal__c = true,                                                            // Auto Renewal
            trial__c = false,                                                                  // trial
         //   PIC_BA_Print__c = '0037F00002L1IVj',                                               // PIC BA Print
            Auto_Renewal_Periode__c = 3,                                                     // Auto Renewal Periode
            Auto_Renewal_UOM__c = 'Bulan',                                                     // Auto Renewal UOM
         //   Profitability__c = 'a0v1m000002E2JJ',                                              
            update_target_closed_date_attemp__c = 0,                                         // Update Target Closed Date Attemp
            Name = '[TEST] Burstable NEW NAP SOJATEK Jember',                                  // Opportunity Name
         //   Solution_PIC__c = '0057F000002eQqS',                                               // Solution PIC
            CloseDate = System.today().addMonths(2),                                             // Target Closed Date
            AccountId = accObj.Id,                                                     // Account Name
            Target_Closed_Date_Message__c = 'You can only update Target Close Date 2 times.',  // Target Closed Date Message
            Actual_Closed_Date__c =System.today().addMonths(2),                                 // Closed Date
            PO_Date__c =System.today(),                                            // PO Date
            Expected_RFS_Date__c =System.today().addMonths(2),                                  // Expected RFS Date
            BP_Payer__c = accObj.Id,                                                   // BP Payer
            StageName = 'Prospecting',                                                      // Stage
            BP_VAT__c = accObj.Id,                                                     // BP VAT
            Probability = 80,                                                                  // Probability (%)
            Contract_Periode__c = 12,                                                        // Contract Periode
            Amount = 907815000.00,                                                             // Amount
            Periode_UOM__c = 'Month',                                                          // Periode UOM
            COF_Number__c = '123/USAMAH/123',                                                  // COF Number
            Remark__c = 'Approved',                                                            // Remark
          //  Account_Site_A__c = '0017F00002qEgQW',                                             // Account Site A (BP Site)
          //  Link_Related__c = 'a071m000003Yzx3',                                               // CID (Related)
            //   SR__c = '2303-003606',                                                             // SR
            Quotation_Final_Approval__c = 'Approved',                                          // Quotation Final Approval Status
            //  PR__c = '2303-002899',                                                             // PR
            //   PR_Rel__c = 'a0i1m000001l0su',                                                     // PR Rel
            LeadSource = 'Digital',                                                            // Lead Source
            BW_before__c = '0',                                                                // Capacity before
            Uom_BW_Before__c = 'Mbps',                                                         // Uom BW Before
            BW_after__c = '1240',                                                              // Capacity after
            Uom_BW_After__c = 'Mbps',                                                          // Uom BW After
            Uom_Quota__c = 'Gbps',                                                             // Uom Quota
            Lastmile_Type__c = 'Fiber',                                                        // Lastmile Type
            Project_Coordinator__c = '90006544 Nancy Citraningrum',                            // Project Coordinator
         //   Sales_Manager_Owner__c = '0057F000002eQpu',                                        // Sales Manager Owner
            Mark_as_Add_Link_Sales_Revenue__c = false,                                         // Mark as Add Link (Sales Revenue)
         //   GM_Sales_of_Owner__c = '0057F000005Tjc5',                                          // GM Sales of Owner
            Mark_as_Sales_Revenue__c = false,                                                  // Mark as Sales Revenue
           // Sales_Manager_for_Approval__c = '0057F000002eQpu',                                 // Sales Manager for Approval
           // Group_Head_for_Approval__c = '0057F000005Tjc5'                                    // Group Head for Approval
           Doc_Template__c = docRec.Id
        );
        insert opp;
        
        Group_Service__c groupService = new Group_Service__c(
            Name = 'FIXED',                  // Group Service Name
            Unique_ID__c = 'FIXED',            // Unique ID
            Type__c = 'BAU',                   // Type
            Search_Term__c = 'Group Service'  // Search Term
        );
        insert groupService;
        
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
        
        Product2 product = new Product2(
            Name = 'Burstable NAP 500 Mbps',                                 // Product Name
            Group_Service__c = groupService.Id,                              // Group Service
            Bandwidth__c = 500,                                              // Bandwidth
            Family = 'NGSM',                                                   // Product Family
            UoM_Bandwidth__c = 'Mbps',                                         // UoM Bandwidth
            IsActive = true,                                                   // Active
            Revenue_Type__c = 'Burstable',                                     // Charge Type
            Description = 'Product for Burstable Charge (burstable traffic)',  // Product Description
            Product_Code2__c = 'NAP'                                          // Product Code
        );
        insert product;
        
        PricebookEntry pbEntrySTDREC = new PricebookEntry(
            Product2Id = product.id, // Product
            IsActive = true, // Active
            Pricebook2Id = standardPricebookREC.id, // Price Book
            UnitPrice = 52.500, // List Price
            UseStandardPrice = false // Use Standard Price
        );
        insert pbEntrySTDREC;

        PricebookEntry pbEntry = new PricebookEntry(
            Product2Id = product.id, // Product
            IsActive = true, // Active
            Pricebook2Id = pb22.id, // Price Book
            UnitPrice = 52.500, // List Price
            UseStandardPrice = false // Use Standard Price
        );
        insert pbEntry;
         ID standardPriceBookId = Test.getStandardPricebookId();
          PricebookEntry pbEntryOneSite = [SELECT id FROM PricebookEntry WHERE product2.name = 'Burstable NAP 500 Mbps'
            and pricebook2.id !=: standardPriceBookId
          ];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,                 // Opportunity
            Product2Id = product.Id,                      // Product
            Billing_Type__c = 'Monthly',                         // Billing Type
            PricebookEntryId = pbEntryOneSite.id,
            Revenue_Type__c = 'Burstable',                       // Charge Type
            UnitPrice = 50000000.00,                             // Sales Price
            Quantity = 1.00,                                   // Quantity
            QTY_Actual__c = 0.00,                              // QTY Actual
            Contract_Start_Date__c = System.today(),  // Contract Start Date
            Contract_End_Date__c =System.today().addMonths(12)    // Contract End Date
        );
        insert oli;
       
        Id RecordTypeSRId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('SR One Site').getRecordTypeId();
        SR_PR_Notification__c SRObj = new SR_PR_Notification__c(
            Name = 'SR-2303-003606',                                                                         // SR/PR Notification Name
            Notif_Type__c = 'SR',                                                                              // Notif Type
            Opportunity__c = opp.Id,                                                                // Opportunity
            Project_Type__c = 'New',                                                                           // Project Type
            Services__c = 'ISP',                                                                               // Services
            Project_Name__c = 'ISP - PT. SOLUSI JASA TEKNOLOGI,SOJATEK_98039001_CV. Tirta Prima Rasa Jember',  // Project Name
            Status__c = 'Close(Complete)',                                                                     // Status
            substatus__c = 'Profitability Cost Complete',                                                      // Sub Status
            RecordTypeId = RecordTypeSRId,                                                                        // Record Type
            Site_A__c =acc2Obj.id,                                                                     // Site A
            PIC_Site__c = contact.Id,                                                                   // PIC Site
            Link_ID__c = '03-00052',                                                                           // Link ID
            Survey_Type__c = 'P2P',                                                                            // Survey Type
            Survey_LastMile_Type__c = 'Lastmile by XL\'s FO',                                                   // Survey LastMile Type
            ECRF_Request__c = false,                                                                           // ECRF Request
            Protocol__c = 'BGP',                                                                               // Protocol
            Type_of_Lastmile__c = 'OPTIC',                                                                     // Type of Lastmile
            Threshold_Tier_1__c = 0.00,                                                                        // Threshold Tier 1
            Discount_Tier_1__c = 0,                                                                            // Discount Tier 1
            Threshold_Tier_2__c = 0.00,                                                                        // Threshold Tier 2
            Discount_Tier_2__c = 0,                                                                            // Discount Tier 2
            Threshold_Tier_3__c = 0.00,                                                                        // Threshold Tier 3
            Discount_Tier_3__c = 0,                                                                            // Discount Tier 3
            Capacity_Before__c = '0',                                                                          // Capacity Before
            UOM_before__c = 'Mbps',                                                                            // UOM before
            Capacity_After__c = '1240',                                                                        // Capacity After
            UOM_After__c = 'Mbps',                                                                             // UOM After
            Notif_Date__c = System.today(),                                                         // Notif Date
            Assign_Date__c = System.today(),                                                        // Assign Date
            Survey_Date__c = System.today(),                                                        // Survey Date
            Survey_Complete_Date__c = System.today(),                                               // Survey Complete Date
            Normal_RFS__c =System.today(),                                                         // Normal RFS
            Result_Date__c =System.today(),                                                        // Result Date
            Project_Coordinator_Text__c = '90006544 Nancy Citraningrum'
        );
        insert SRObj;
        opp.SR__c = SRObj.Name;
        update opp;
         Test.startTest();
        
        opp.StageName = 'Implementation';
        update opp;
        
        Id RecordTypePRId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR One Site').getRecordTypeId();
        SR_PR_Notification__c PRobj = new SR_PR_Notification__c(
            Name = 'PR-2303-002899',                                                                         // SR/PR Notification Name
            Notif_Type__c = 'PR',                                                                              // Notif Type
            Opportunity__c = opp.id,                                                                // Opportunity
            Project_Type__c = 'New',                                                                           // Project Type
            Services__c = 'ISP',                                                                               // Services
            Project_Name__c = 'ISP - PT. SOLUSI JASA TEKNOLOGI,SOJATEK_98039001_CV. Tirta Prima Rasa Jember',  // Project Name
            Status__c = 'Complete',                                                                            // Status
            RecordTypeId = RecordTypePRId,                                                                        // Record Type
            Site_A__c = acc2Obj.Id,                                                                     // Site A
          //  PIC_Site__c = '0037F00002L1IVj',                                                                   // PIC Site
            Circuit__c = circuitRec.Id,                                                                    // Circuit
            CID__c = '03-00052',                                                                               // CID
            Trial__c = false,                                                                                  // Trial
            Link_ID__c = '03-00052',                                                                           // Link ID
            ECRF_Request__c = false,                                                                           // ECRF Request
            Protocol__c = 'BGP',                                                                               // Protocol
            WBA_Required_File__c = true,                                                                       // Customer Confirmation File Upload
            Type_of_Lastmile__c = 'OPTIC',                                                                     // Type of Lastmile
            Capacity_Before__c = '0',                                                                          // Capacity Before
            UOM_before__c = 'Mbps',                                                                            // UOM before
            Capacity_After__c = '1240',                                                                        // Capacity After
            UOM_After__c = 'Mbps',                                                                             // UOM After
            Threshold_Tier_1__c = 0.00,                                                                        // Threshold Tier 1
            Discount_Tier_1__c = 0,                                                                            // Discount Tier 1
            Threshold_Tier_2__c = 0.00,                                                                        // Threshold Tier 2
            Discount_Tier_2__c = 0,                                                                            // Discount Tier 2
            Threshold_Tier_3__c = 0.00,                                                                        // Threshold Tier 3
            Discount_Tier_3__c = 0,                                                                            // Discount Tier 3
            Notif_Date__c = System.today(),                                                         // Notif Date
            Normal_RFS__c =System.today().addMonths(1),                                                         // Normal RFS
            Exp_RFS_Date__c =System.today().addMonths(1),                                                       // Exp RFS Date
            Customer_RFS_Date__c = System.today().addMonths(1),                                                  // Customer RFS Date
            WFI_Date__c = System.today(),                                                           // WFI Date
            Billing_Start_Date__c = System.today(),                                                 // Billing Start Date
            BA_Receive_Date__c = System.today(),                                                    // BA Receive Date
            Project_Complete_Date__c =System.today(),                                              // Project Complete Date
            WBA_Required_File_Date__c = System.today()                                            // Customer Confirmation File Upload Date
        );
        insert PRobj;
        opp.PR__c = PRobj.Name;
        opp.PR_Rel__c = PRobj.Id;
        update opp;
        
        
       
        // Panggil method afterUpdate()
        List<SR_PR_Notification__c> newList = [SELECT Id, Status__c, Opportunity__c, Link_ID__c, Link__c FROM SR_PR_Notification__c WHERE Id = :PRobj.Id];
        List<SR_PR_Notification__c> oldList = [SELECT Id, Status__c FROM SR_PR_Notification__c WHERE Id = :PRobj.Id];
        new TA_AT_LinkProdCreationOnPRComplete().afterUpdate(newList, oldList);
        Test.stopTest();
        
        // Verifikasi apakah record Link_Product__c berhasil dibuat dengan benar
        List<Link_Product__c> linkProductList = [SELECT Name, Link__c, Product__c, Product_ID__c, Sales_Price__c, Type__c FROM Link_Product__c];
        System.assertEquals(1, linkProductList.size());
        Link_Product__c linkProduct = linkProductList[0];
        System.assertEquals('LINK001_Test Product', linkProduct.Name);
        System.assertEquals(PRobj.Link__c, linkProduct.Link__c);
        
    }
}