/**
 * @description       : 
 * @author            : Andre Prasetya
 * @group             : 
 * @last modified on  : 03-16-2022
 * @last modified by  : Diky Nurosid
**/
@isTest(seealldata = false)
private class Trigger_Opportunity_Profitabilty_v2Test{

    static testMethod void testProvitabiltyIOT(){
        insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Id recordTypeId_ProfitabilityIot = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('IOT MCA').getRecordTypeId();
        
        Id RecordTypeId_Opportunity_NonGSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();

        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
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
                Using_HO_Billing_Address__c = false                             
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
            contractTest.AccountId = accTest.Id;
            contractTest.Account_BP_Payer__c = accTest.Id;
            contractTest.Start_Date__c = System.today();
            contractTest.End_Date__c = System.today();
            contractTest.Account_BP_VAT__c = accTest.Id;
            contractTest.Contract_Term__c = 12;
            contractTest.Billing_Type__c = 'Monthly';
            contractTest.Price__c = 1213;
            contractTest.SAP_ID__c = '351';
            contractTest.Quantity__c = 1;
            contractTest.Periode_UOM__c = 'Month';
            contractTest.Bandwidth_filled__c = 512;
            contractTest.Bandwidth_UoM_filled__c = 'Kbps';
            contractTest.Account_Site_A_BP_Site__c = accTest.Id;
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
                Site_A_Name__c = accTest.Id,
                Contract_Item_Rel__c = contractTest.Id,
                Free_Link__c = false,
                Selected__c = false,
                Partner__c = false                                                                    
            );
            insert linkTest;

            O.Accountid=accTest.id;
            O.Account_Site_A__c=accTest.id;
            O.Account_Site_B__c=accTest2.id;
            O.StageName='Prospecting';
            O.Name='Tes';
            //O.Link_Related__c=linkTest.id;
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id= Test.getStandardPricebookId();
            O.Periode_UOM__c='Month';
            O.BP_Payer__c=accTest2.id;
            O.BP_Vat__c=accTest2.id;
            O.Service_Type__c = 'Newlink';
            O.RecordTypeId = RecordTypeId_Opportunity_NonGSM;
            O.Amount = 1111;
            insert O;
        
            Profitability__c ProfitabilityForecats = new Profitability__c();
            ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityIot;
            ProfitabilityForecats.Name = 'Testing';
            ProfitabilityForecats.Account__c = O.AccountId;
            ProfitabilityForecats.Opportunity__c = O.Id;
            ProfitabilityForecats.Status__c = 'Forecast';
            ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
            ProfitabilityForecats.Deal_Price__c = 10000;
            ProfitabilityForecats.One_Time_Revenue__c = 10000;
            Insert ProfitabilityForecats;
            
            O.Profitability__c = ProfitabilityForecats.Id;
            update O;

            O.Amount = 2222;
            O.Link_Related__c = linkTest.Id;
            update O;
        }
    }

    static testMethod void testProvitabiltyGSMNegotiation(){
         insert new Transaction__c(transactionID__c = 1);
        //-- GET RecordType of GSM Activation opportuntiy
        Id opptyGSMActivationRTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();

        //-- GET REcordType of BP Account
        Id accountBPRTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        //-- CREATE Account
        Account accountRec = new Account(
            Name = 'PT. PRIMAFOOD INTERNATIONAL',                // Account Name
            RecordTypeId = accountBPRTypeId,                            // Account Record Type
            BP_Number__c = '759416',                               // BP Number
            Organization_Type__c = 'Head Office',                  // Organization Type
            Type = 'Customer',                                     // Type
            Keyword__c = 'Primafood',                              // Keyword
            Customer_Type__c = 'NONGSM',                           // Customer Type
            Payer_For_GSM_Invoice__c = false,                      // Payer For GSM Invoice
            LA_Number__c = '91470032',                             // LA or Community Code
            term_of_payment__c = 'Z030 Within 30 Days Due Net',    // Term of Payment
            Company_Group__c = 'PT. PRIMAFOOD INTERNATIONAL',      // Company_Group
            Customer_VAT_Name__c = 'PT. PRIMAFOOD INTERNATIONAL',  // Customer VAT Name
            //Is_New_Customer__c = false,                            // Is New Customer
            //Kwitansi__c = false,                                   // Kwitansi
            //Faktur_Pajak__c = false,                               // Faktur Pajak
            //Summary_Billing__c = false,                            // Summary Billing
            //summary_invoice__c = false,                            // summary invoice
            //Approval_Status__c = 'Approved',                       // Approval Status
            Using_HO_Billing_Address__c = false,                   // Using HO Billing Address
            No_NPWP__c = '020391769056000',                        // No NPWP
            No_SIUP__c = '281/24/1.PB.7/31.72/-1.824.27/e/2017',   // No SIUP
            SIUP_Expired_Date__c = Date.valueOf('2022-10-09'),     // SIUP Expired Date
            No_TDP__c = '09.01.1.46.13792',                        // No TDP
            TDP_Expired_Date__c = Date.valueOf('2021-05-11'),      // TDP Expired Date
            No_Akta__c = 'NO.06',                                  // No Akta
            Akta_Expired_Date__c = Date.valueOf('2022-08-23')     // Akta Expired Date
        );
        insert accountRec;

        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );

        //-- CREATE Pricebook 
        Pricebook2 pricebookRec = new Pricebook2(Name='GSM Activation', IsActive = true);
        insert pricebookRec;

        Group_Service__c groupServiceRec = new Group_Service__c (Name = 'MOBILE', search_term__c = 'MOBILE');
        insert groupServiceRec;

        Product2 productRec = new Product2(
            name = 'BIZ Starter Postpaid'
            , group_service__c = groupServiceRec.id
            , family = 'GSM'
            , Product_Code2__c = 'Postpaid'
            , Revenue_Type__c = 'Recurring'
            //, ao_related__c = aoRec.id,
            //, priceplan_related__c = pricePlanRec.id
        );
        insert productRec;

        //Create the PricebookEntry
        PricebookEntry priceBookEntrySTDRec = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = productRec.Id,
            UnitPrice = 5000,
            IsActive = true
        );
        Insert priceBookEntrySTDRec;

        PricebookEntry priceBookEntryRec = new PricebookEntry(
            Pricebook2Id = pricebookRec.Id,
            Product2Id = productRec.Id,
            UnitPrice = 5000,
            IsActive = true
        );
        Insert priceBookEntryRec;


        //-- Create Opportunity 
        Opportunity opptyRec = new Opportunity(
            RecordTypeId = opptyGSMActivationRTypeId,                          // Opportunity Record Type
            Name = 'PRIMAFOOD 1# LAMPUNG',                       // Opportunity Name
            AccountId = accountRec.Id,                             // Account Name
            CloseDate = Date.valueOf('2021-09-03'),              // Target Closed Date
            Actual_Closed_Date__c = Date.valueOf('2021-09-03'),  // Closed Date
            StageName = 'Prospecting',                       // Stage
            Pricebook2Id = pricebookRec.Id
        );
        insert opptyRec;


        //-- Create Opportunity PRODUCT
        OpportunitylineItem oliRec = new OpportunitylineItem();
        oliRec.unitprice = 5000;
        oliRec.quantity = 1;
        oliRec.billing_type__c = 'Monthly';
        oliRec.Revenue_Type__c = 'Recurring';
        oliRec.opportunityID = opptyRec.id;
        oliRec.PricebookEntryId  = priceBookEntryRec.id;
        insert oliRec;

        system.debug (' == opptyRec : ' + opptyRec);
        system.debug (' == opptyRec.Product_Count__c : ' + opptyRec.Product_Count__c);

        test.starttest();
            opptyRec.StageName = 'Negotiation';
            update opptyRec;

            oliRec.quantity = 2;
            update oliRec;
        test.stoptest();
    }

    static testMethod void testProvitabiltyGSMNegotiationChangeQuantity(){
         insert new Transaction__c(transactionID__c = 1);
        //-- GET RecordType of GSM Activation opportuntiy
        Id opptyGSMActivationRTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simcard Postpaid/Prepaid').getRecordTypeId();

        //-- GET REcordType of BP Account
        Id accountBPRTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        //-- CREATE Account
        Account accountRec = new Account(
            Name = 'PT. PRIMAFOOD INTERNATIONAL',                // Account Name
            RecordTypeId = accountBPRTypeId,                            // Account Record Type
            BP_Number__c = '759416',                               // BP Number
            Organization_Type__c = 'Head Office',                  // Organization Type
            Type = 'Customer',                                     // Type
            Keyword__c = 'Primafood',                              // Keyword
            Customer_Type__c = 'NONGSM',                           // Customer Type
            Payer_For_GSM_Invoice__c = false,                      // Payer For GSM Invoice
            LA_Number__c = '91470032',                             // LA or Community Code
            term_of_payment__c = 'Z030 Within 30 Days Due Net',    // Term of Payment
            Company_Group__c = 'PT. PRIMAFOOD INTERNATIONAL',      // Company_Group
            Customer_VAT_Name__c = 'PT. PRIMAFOOD INTERNATIONAL',  // Customer VAT Name
            //Is_New_Customer__c = false,                            // Is New Customer
            //Kwitansi__c = false,                                   // Kwitansi
            //Faktur_Pajak__c = false,                               // Faktur Pajak
            //Summary_Billing__c = false,                            // Summary Billing
            //summary_invoice__c = false,                            // summary invoice
            //Approval_Status__c = 'Approved',                       // Approval Status
            Using_HO_Billing_Address__c = false,                   // Using HO Billing Address
            No_NPWP__c = '020391769056000',                        // No NPWP
            No_SIUP__c = '281/24/1.PB.7/31.72/-1.824.27/e/2017',   // No SIUP
            SIUP_Expired_Date__c = Date.valueOf('2022-10-09'),     // SIUP Expired Date
            No_TDP__c = '09.01.1.46.13792',                        // No TDP
            TDP_Expired_Date__c = Date.valueOf('2021-05-11'),      // TDP Expired Date
            No_Akta__c = 'NO.06',                                  // No Akta
            Akta_Expired_Date__c = Date.valueOf('2022-08-23')     // Akta Expired Date
        );
        insert accountRec;

        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );

        //-- CREATE Pricebook 
        Pricebook2 pricebookRec = new Pricebook2(Name='GSM Activation', IsActive = true);
        insert pricebookRec;

        Group_Service__c groupServiceRec = new Group_Service__c (Name = 'MOBILE', search_term__c = 'MOBILE');
        insert groupServiceRec;

        Product2 productRec = new Product2(
            name = 'BIZ Starter Postpaid'
            , group_service__c = groupServiceRec.id
            , family = 'GSM'
            , Product_Code2__c = 'Postpaid'
            , Revenue_Type__c = 'Recurring'
            //, ao_related__c = aoRec.id,
            //, priceplan_related__c = pricePlanRec.id
        );
        insert productRec;

        //Create the PricebookEntry
        PricebookEntry priceBookEntrySTDRec = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = productRec.Id,
            UnitPrice = 5000,
            IsActive = true
        );
        Insert priceBookEntrySTDRec;

        PricebookEntry priceBookEntryRec = new PricebookEntry(
            Pricebook2Id = pricebookRec.Id,
            Product2Id = productRec.Id,
            UnitPrice = 5000,
            IsActive = true
        );
        Insert priceBookEntryRec;


        //-- Create Opportunity 
        Opportunity opptyRec = new Opportunity(
            RecordTypeId = opptyGSMActivationRTypeId,                          // Opportunity Record Type
            Name = 'PRIMAFOOD 1# LAMPUNG',                       // Opportunity Name
            AccountId = accountRec.Id,                             // Account Name
            CloseDate = Date.valueOf('2021-09-03'),              // Target Closed Date
            Actual_Closed_Date__c = Date.valueOf('2021-09-03'),  // Closed Date
            StageName = 'Prospecting',                       // Stage
            Pricebook2Id = pricebookRec.Id
        );
        insert opptyRec;

        //-- Create Opportunity PRODUCT
        OpportunitylineItem oliRec = new OpportunitylineItem();
        oliRec.unitprice = 5000;
        oliRec.quantity = 1;
        oliRec.billing_type__c = 'Monthly';
        oliRec.Revenue_Type__c = 'Recurring';
        oliRec.opportunityID = opptyRec.id;
        oliRec.PricebookEntryId  = priceBookEntryRec.id;
        insert oliRec;

        system.debug (' == opptyRec : ' + opptyRec);
        system.debug (' == opptyRec.Product_Count__c : ' + opptyRec.Product_Count__c);

        opptyRec.StageName = 'Negotiation';
        update opptyRec;

        test.starttest();
            oliRec.quantity = 2;
            update oliRec;
        test.stoptest();
    }
    
    static testMethod void testProvitabiltyGSMClosedWon(){
         insert new Transaction__c(transactionID__c = 1);
        //-- GET RecordType of GSM Activation opportuntiy
        Id opptyGSMActivationRTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simcard Postpaid/Prepaid').getRecordTypeId();

        //-- GET REcordType of BP Account
        Id accountBPRTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        //-- CREATE Account
        Account accountRec = new Account(
            Name = 'PT. PRIMAFOOD INTERNATIONAL',                // Account Name
            RecordTypeId = accountBPRTypeId,                            // Account Record Type
            BP_Number__c = '759416',                               // BP Number
            Organization_Type__c = 'Head Office',                  // Organization Type
            Type = 'Customer',                                     // Type
            Keyword__c = 'Primafood',                              // Keyword
            Customer_Type__c = 'NONGSM',                           // Customer Type
            Payer_For_GSM_Invoice__c = false,                      // Payer For GSM Invoice
            LA_Number__c = '91470032',                             // LA or Community Code
            term_of_payment__c = 'Z030 Within 30 Days Due Net',    // Term of Payment
            Company_Group__c = 'PT. PRIMAFOOD INTERNATIONAL',      // Company_Group
            Customer_VAT_Name__c = 'PT. PRIMAFOOD INTERNATIONAL',  // Customer VAT Name
            //Is_New_Customer__c = false,                            // Is New Customer
            //Kwitansi__c = false,                                   // Kwitansi
            //Faktur_Pajak__c = false,                               // Faktur Pajak
            //Summary_Billing__c = false,                            // Summary Billing
            //summary_invoice__c = false,                            // summary invoice
            //Approval_Status__c = 'Approved',                       // Approval Status
            Using_HO_Billing_Address__c = false,                   // Using HO Billing Address
            No_NPWP__c = '020391769056000',                        // No NPWP
            No_SIUP__c = '281/24/1.PB.7/31.72/-1.824.27/e/2017',   // No SIUP
            SIUP_Expired_Date__c = Date.valueOf('2022-10-09'),     // SIUP Expired Date
            No_TDP__c = '09.01.1.46.13792',                        // No TDP
            TDP_Expired_Date__c = Date.valueOf('2021-05-11'),      // TDP Expired Date
            No_Akta__c = 'NO.06',                                  // No Akta
            Akta_Expired_Date__c = Date.valueOf('2022-08-23')     // Akta Expired Date
        );
        insert accountRec;

        //-- GET REcordType of LA Account
        Id accountLARTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LA').getRecordTypeId();

        //-- CREATE LA Account
        Account LAAccountRec = new Account(
            name = 'LA Account',
            RecordTypeId = accountLARTypeId,
            parentid = accountRec.id,
            Organization_Type__c = 'Branch',
            LA_Number__c = '1234'

        );
        insert LAAccountRec ;

        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );

        //-- CREATE Pricebook 
        Pricebook2 pricebookRec = new Pricebook2(Name='GSM Activation', IsActive = true);
        insert pricebookRec;

        Group_Service__c groupServiceRec = new Group_Service__c (Name = 'MOBILE', search_term__c = 'MOBILE');
        insert groupServiceRec;

        AO__c aoRec = new AO__c(name = 'AO GPRS MMS', full_name__c = 'AO GPRS MMS');
        insert aoRec;

        Price_Plan__c pricePlanRec = new Price_Plan__c(name = 'BIZ Starter', full_name__c = 'BIZ Starter');
        insert pricePlanRec;

        Product2 productRec = new Product2(
            name = 'BIZ Starter Postpaid'
            , group_service__c = groupServiceRec.id
            , family = 'GSM'
            , Product_Code2__c = 'Postpaid'
            , Revenue_Type__c = 'Recurring'
            , ao_related__c = aoRec.id
            , price_plan_related__c = pricePlanRec.id
        );
        insert productRec;

        //Create the PricebookEntry
        PricebookEntry priceBookEntrySTDRec = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = productRec.Id,
            UnitPrice = 5000,
            IsActive = true
        );
        Insert priceBookEntrySTDRec;

        PricebookEntry priceBookEntryRec = new PricebookEntry(
            Pricebook2Id = pricebookRec.Id,
            Product2Id = productRec.Id,
            UnitPrice = 5000,
            IsActive = true
        );
        Insert priceBookEntryRec;


        //-- Create Opportunity 
        Opportunity opptyRec = new Opportunity(
            RecordTypeId = opptyGSMActivationRTypeId,                          // Opportunity Record Type
            Name = 'PRIMAFOOD 1# LAMPUNG',                       // Opportunity Name
            AccountId = accountRec.Id,                             // Account Name
            CloseDate = Date.valueOf('2021-09-03'),              // Target Closed Date
            Actual_Closed_Date__c = Date.valueOf('2021-09-03'),  // Closed Date
            StageName = 'Prospecting',                       // Stage
            Pricebook2Id = pricebookRec.Id
        );
        insert opptyRec;

        


        //-- Create Opportunity PRODUCT
        OpportunitylineItem oliRec = new OpportunitylineItem();
        oliRec.unitprice = 5000;
        oliRec.quantity = 1;
        oliRec.billing_type__c = 'Monthly';
        oliRec.Revenue_Type__c = 'Recurring';
        oliRec.opportunityID = opptyRec.id;
        oliRec.PricebookEntryId  = priceBookEntryRec.id;
        insert oliRec;

        system.debug (' == opptyRec : ' + opptyRec);
        system.debug (' == opptyRec.Product_Count__c : ' + opptyRec.Product_Count__c);

        opptyRec.StageName = 'Negotiation';
        update opptyRec;

        system.debug (' == opptyRec.Profitability__c : ' + opptyRec.Profitability__c);


        //-- create MSISDN
        MSISDN__c msisdnRec = new MSISDN__c();
        msisdnRec.Account__c = AccountRec.id;
        msisdnRec.Name = '6287799912301';
        msisdnRec.MSISDN_No__c = '8962199912300001';
        msisdnRec.Label__c = 'test label';
        msisdnRec.ICCID__c = '8962199912300001';
        insert msisdnRec;

        //-- Create ORDER Activation
        Order orderRec = New Order();
        orderRec.AccountId = accountRec.id;
        orderRec.OpportunityId = opptyRec.id;
        orderRec.EffectiveDate = system.today();
        orderRec.Name = 'POSTpaid Activation - New LA';
        orderRec.Service_Type__c = 'New Number';
        orderRec.LA__c = LAAccountRec.id;
        orderRec.Min_Commitment__c = true;
        orderRec.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('POSTpaid Activation - Existing LA').getRecordTypeId();
        orderRec.Type = 'Postpaid Activation';
        orderRec.Status = 'Draft';
        insert orderRec;

        //-- tidak perlu dibuat -- sudah dibuatkan pakai automation 
        /*
        OrderItem orderItemRec = new OrderItem();
        orderItemRec.unitprice = 5000;
        orderItemRec.quantity = 1;
        orderItemRec.orderid = orderRec.id;
        orderItemRec.PricebookEntryId  = priceBookEntryRec.id;
        insert orderItemRec;
        */
    

        //== create order MSISDN
        Order_MSISDN__c orderMSISDNRec = new Order_MSISDN__c();
        orderMSISDNRec.Name = '6287799900001';
        orderMSISDNRec.ICCID__c = '896219990000001';
        orderMSISDNRec.CL__c = 145000;
        orderMSISDNRec.Order__c= orderRec.id;
        orderMSISDNRec.MSISDN__c = msisdnRec.id;
        orderMSISDNRec.AO__c = 'AO GPRS MMS';
        orderMSISDNRec.Priceplan__c = 'BIZ Starter';
        insert orderMSISDNRec;
        
        orderMSISDNRec.status__c = 'Success';
        update orderMSISDNRec; 


        test.starttest();
            orderRec.Status = 'Complete';
            update orderRec;

            opptyRec.StageName = 'Closed Won';
            update opptyRec;
        test.stoptest();
    }

    static testMethod void testProvitabiltyGSMClosedLost(){
         insert new Transaction__c(transactionID__c = 1);
                //-- GET RecordType of GSM Activation opportuntiy
                Id opptyGSMActivationRTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simcard Postpaid/Prepaid').getRecordTypeId();

                //-- GET REcordType of BP Account
                Id accountBPRTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
                //-- CREATE Account
                Account accountRec = new Account(
                    Name = 'PT. PRIMAFOOD INTERNATIONAL',                // Account Name
                    RecordTypeId = accountBPRTypeId,                            // Account Record Type
                    BP_Number__c = '759416',                               // BP Number
                    Organization_Type__c = 'Head Office',                  // Organization Type
                    Type = 'Customer',                                     // Type
                    Keyword__c = 'Primafood',                              // Keyword
                    Customer_Type__c = 'NONGSM',                           // Customer Type
                    Payer_For_GSM_Invoice__c = false,                      // Payer For GSM Invoice
                    LA_Number__c = '91470032',                             // LA or Community Code
                    term_of_payment__c = 'Z030 Within 30 Days Due Net',    // Term of Payment
                    Company_Group__c = 'PT. PRIMAFOOD INTERNATIONAL',      // Company_Group
                    Customer_VAT_Name__c = 'PT. PRIMAFOOD INTERNATIONAL',  // Customer VAT Name
                    //Is_New_Customer__c = false,                            // Is New Customer
                    //Kwitansi__c = false,                                   // Kwitansi
                    //Faktur_Pajak__c = false,                               // Faktur Pajak
                    //Summary_Billing__c = false,                            // Summary Billing
                    //summary_invoice__c = false,                            // summary invoice
                    //Approval_Status__c = 'Approved',                       // Approval Status
                    Using_HO_Billing_Address__c = false,                   // Using HO Billing Address
                    No_NPWP__c = '020391769056000',                        // No NPWP
                    No_SIUP__c = '281/24/1.PB.7/31.72/-1.824.27/e/2017',   // No SIUP
                    SIUP_Expired_Date__c = Date.valueOf('2022-10-09'),     // SIUP Expired Date
                    No_TDP__c = '09.01.1.46.13792',                        // No TDP
                    TDP_Expired_Date__c = Date.valueOf('2021-05-11'),      // TDP Expired Date
                    No_Akta__c = 'NO.06',                                  // No Akta
                    Akta_Expired_Date__c = Date.valueOf('2022-08-23')     // Akta Expired Date
                );
                insert accountRec;
        
                //-- GET REcordType of LA Account
                Id accountLARTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LA').getRecordTypeId();
        
                //-- CREATE LA Account
                Account LAAccountRec = new Account(
                    name = 'LA Account',
                    RecordTypeId = accountLARTypeId,
                    parentid = accountRec.id,
                    Organization_Type__c = 'Branch',
                    LA_Number__c = '1234'
        
                );
                insert LAAccountRec ;
        
                //Instantiate the Pricebook2 record with StandardPricebookId
                Pricebook2 standardPricebook = new Pricebook2(
                    Id = Test.getStandardPricebookId(),
                    IsActive = true
                );
        
                //-- CREATE Pricebook 
                Pricebook2 pricebookRec = new Pricebook2(Name='GSM Activation', IsActive = true);
                insert pricebookRec;
        
                Group_Service__c groupServiceRec = new Group_Service__c (Name = 'MOBILE', search_term__c = 'MOBILE');
                insert groupServiceRec;
        
                Product2 productRec = new Product2(
                    name = 'BIZ Starter Postpaid'
                    , group_service__c = groupServiceRec.id
                    , family = 'GSM'
                    , Product_Code2__c = 'Postpaid'
                    , Revenue_Type__c = 'Recurring'
                    //, ao_related__c = aoRec.id,
                    //, priceplan_related__c = pricePlanRec.id
                );
                insert productRec;
        
                //Create the PricebookEntry
                PricebookEntry priceBookEntrySTDRec = new PricebookEntry(
                    Pricebook2Id = standardPricebook.Id,
                    Product2Id = productRec.Id,
                    UnitPrice = 5000,
                    IsActive = true
                );
                Insert priceBookEntrySTDRec;
        
                PricebookEntry priceBookEntryRec = new PricebookEntry(
                    Pricebook2Id = pricebookRec.Id,
                    Product2Id = productRec.Id,
                    UnitPrice = 5000,
                    IsActive = true
                );
                Insert priceBookEntryRec;
        
        
                //-- Create Opportunity 
                Opportunity opptyRec = new Opportunity(
                    RecordTypeId = opptyGSMActivationRTypeId,                          // Opportunity Record Type
                    Name = 'PRIMAFOOD 1# LAMPUNG',                       // Opportunity Name
                    AccountId = accountRec.Id,                             // Account Name
                    CloseDate = Date.valueOf('2021-09-03'),              // Target Closed Date
                    Actual_Closed_Date__c = Date.valueOf('2021-09-03'),  // Closed Date
                    StageName = 'Prospecting',                       // Stage
                    Pricebook2Id = pricebookRec.Id
                );
                insert opptyRec;
        
                
        
        
                //-- Create Opportunity PRODUCT
                OpportunitylineItem oliRec = new OpportunitylineItem();
                oliRec.unitprice = 5000;
                oliRec.quantity = 1;
                oliRec.billing_type__c = 'Monthly';
                oliRec.Revenue_Type__c = 'Recurring';
                oliRec.opportunityID = opptyRec.id;
                oliRec.PricebookEntryId  = priceBookEntryRec.id;
                insert oliRec;
        
                system.debug (' == opptyRec : ' + opptyRec);
                system.debug (' == opptyRec.Product_Count__c : ' + opptyRec.Product_Count__c);
        
                opptyRec.StageName = 'Negotiation';
                update opptyRec;

                system.debug (' == opptyRec.Profitability__c : ' + opptyRec.Profitability__c);
                
                /*
        
                //-- create MSISDN
                MSISDN__c msisdnRec = new MSISDN__c();
                msisdnRec.Account__c = AccountRec.id;
                msisdnRec.Name = '6287799912301';
                msisdnRec.MSISDN_No__c = '8962199912300001';
                msisdnRec.Label__c = 'test label';
                msisdnRec.ICCID__c = '8962199912300001';
                insert msisdnRec;
        
                //-- Create ORDER Activation
                Order orderRec = New Order();
                orderRec.AccountId = accountRec.id;
                orderRec.OpportunityId = opptyRec.id;
                orderRec.EffectiveDate = system.today();
                orderRec.Name = 'POSTpaid Activation - New LA';
                orderRec.Service_Type__c = 'New Number';
                orderRec.LA__c = LAAccountRec.id;
                orderRec.Min_Commitment__c = true;
                orderRec.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('POSTpaid Activation - Existing LA').getRecordTypeId();
                orderRec.Type = 'Postpaid Activation';
                orderRec.Status = 'Draft';
                insert orderRec;
            
        
                //== create order MSISDN
                Order_MSISDN__c orderMSISDNRec = new Order_MSISDN__c();
                orderMSISDNRec.Name = '6287799900001';
                orderMSISDNRec.ICCID__c = '896219990000001';
                orderMSISDNRec.CL__c = 145000;
                orderMSISDNRec.Order__c= orderRec.id;
                orderMSISDNRec.MSISDN__c = msisdnRec.id;
                insert orderMSISDNRec;
                
                orderMSISDNRec.status__c = 'Success';
                update orderMSISDNRec;
        
                orderRec.Status = 'Complete';
                update orderRec;
                */
        
        
                test.starttest();
                    opptyRec.StageName = 'Closed Lost';
                    update opptyRec;
            
                test.stoptest();
    }

}