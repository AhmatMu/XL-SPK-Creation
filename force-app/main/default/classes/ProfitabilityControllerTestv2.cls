/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 08-07-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   08-07-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest()
public class ProfitabilityControllerTestv2 {
    @testSetup static void setup() {
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            EmailTemplate et2 = new EmailTemplate(); 
            et2.isActive = true; 
            et2.Name = 'SRPR - Notification SR'; 
            et2.DeveloperName = 'SRPR_Notification_SR'; 
            et2.TemplateType = 'text';
            et2.Subject = 'SRPR Creation';
            et2.FolderId = UserInfo.getUserId(); 
            et2.Body = 'test email';
            // et.HtmlValue = '<p>Dear {!relatedTo.UserRole.Name},</p><p>Need your action for Notification because this notif in trial date termination on Trial Monitoring Ticket and need your confirmation this link will be to production or not. if go to production, please update trial monitoring ticket status.</p><c:TrialLinkComponent roleIdValue="{!relatedTo.UserRoleId}" />'; 
            
            insert et2;  //error in this line
        }
        System.runAs(new User(Id=UserInfo.getUserId())){
            EmailTemplate et3 = new EmailTemplate(); 
            et3.isActive = true; 
            et3.Name = 'SRPR - Notification PR'; 
            et3.DeveloperName = 'SRPR_Notification_PR'; 
            et3.TemplateType = 'text';
            et3.Subject = 'SRPR Creation';
            et3.FolderId = UserInfo.getUserId(); 
            et3.Body = 'test email';
            // et.HtmlValue = '<p>Dear {!relatedTo.UserRole.Name},</p><p>Need your action for Notification because this notif in trial date termination on Trial Monitoring Ticket and need your confirmation this link will be to production or not. if go to production, please update trial monitoring ticket status.</p><c:TrialLinkComponent roleIdValue="{!relatedTo.UserRoleId}" />'; 
            
            insert et3;  //error in this line
        }
        
        ProfitabilityController__c EmailSettingList_1 = new ProfitabilityController__c(); //space
        EmailSettingList_1.Name = 'Email_Profitability_Forecats_Created';
        EmailSettingList_1.Additional_toAddress__c = 'diky.nurosid@saasten.com,a@gmail.com|b@gmail.com d@gmail.com-e@gmail.com';
        EmailSettingList_1.Additional_toCCAddress__c = 'diky.nurosid@saasten.com,a@gmail.com|b@gmail.com d@gmail.com-e@gmail.com';
        insert EmailSettingList_1;
       // EmailSettingList.add(EmailSettingList_1);
        
        ProfitabilityController__c EmailSettingList_2 = new ProfitabilityController__c(); //space
        EmailSettingList_2.Name = 'Email_Profitability_UpdateToActual';
        EmailSettingList_2.Additional_toAddress__c = 'diky.nurosid@saasten.com,a@gmail.com|b@gmail.com d@gmail.com - e@gmail.com';
        EmailSettingList_2.Additional_toCCAddress__c = 'diky.nurosid@saasten.com,a@gmail.com|b@gmail.com d@gmail.com - e@gmail.com';
        insert EmailSettingList_2;
        
          List<PNL_GSM_Setting_Forecast__c> PNL_GSM_Setting_ForecastList = new list<PNL_GSM_Setting_Forecast__c>();

        PNL_GSM_Setting_Forecast__c PNL_GSM_Setting_Forecast_1 = new PNL_GSM_Setting_Forecast__c();
        PNL_GSM_Setting_Forecast_1.Name = 'Postpaid';
        PNL_GSM_Setting_Forecast_1.Margin__c = 0;
        PNL_GSM_Setting_Forecast_1.Product_Code__c = 'Postpaid';
        PNL_GSM_Setting_Forecast_1.Active__c = true;
        PNL_GSM_Setting_ForecastList.add(PNL_GSM_Setting_Forecast_1);

        insert PNL_GSM_Setting_ForecastList;
        Profile salesProfile = [SELECT id FROM Profile WHERE name = 'Sales'];
        Profile solutionProfile  = [SELECT id FROM Profile WHERE name = 'Solution'];
        Profile projectCoordinatorProfile  = [SELECT id FROM Profile WHERE name = 'Project Coordinator'];
        Profile salesAdminProfile  = [SELECT id FROM Profile WHERE name = 'Sales Admin'];
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
            lastName  = 'Nancy Citraningrum',
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
    }

    static testMethod void myUnitTest1() {
        insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();
        
        Id RecordTypeId_SR_PR = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR One Site').getRecordTypeId();
        
        Id RecordTypeId_Opportunity_NonGSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();

        Id RecordTypeId_Opportunity_GSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simcard Postpaid/Prepaid').getRecordTypeId();

        List<PNL_GSM_Setting_Forecast__c> PNL_GSM_Setting_ForecastList = new list<PNL_GSM_Setting_Forecast__c>();

        PNL_GSM_Setting_Forecast__c PNL_GSM_Setting_Forecast_1 = new PNL_GSM_Setting_Forecast__c();
        PNL_GSM_Setting_Forecast_1.Name = 'Postpaid';
        PNL_GSM_Setting_Forecast_1.Margin__c = 0;
        PNL_GSM_Setting_Forecast_1.Product_Code__c = 'Postpaid';
        PNL_GSM_Setting_Forecast_1.Active__c = true;
        PNL_GSM_Setting_ForecastList.add(PNL_GSM_Setting_Forecast_1);

        insert PNL_GSM_Setting_ForecastList;

        
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
        Opportunity O2 = new Opportunity();
        
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
            /*accTest.Billing_Address_Province__c = 'jawa tengah';   
            accTest.Billing_Address_City__c = 'kota surakarta';
            accTest.Shipping_Address_Province__c = 'jawa tengah';
            accTest.Shipping_Address_City__c = 'kota surakarta';*/
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
                Using_HO_Billing_Address__c = false/*,
                Billing_Address_Province__c = 'jawa tengah',
                Billing_Address_City__c = 'kota surakarta',
                Shipping_Address_Province__c = 'jawa tengah',
                Shipping_Address_City__c = 'kota surakarta'*/                      
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
 		Group_Service__c groupService= new Group_Service__c(
            Name = 'FIXED',                  // Group Service Name
            Unique_ID__c = 'FIXED',            // Unique ID
            Type__c = 'BAU',                   // Type
            Search_Term__c = 'Group Service'  // Search Term
        );
        insert groupService;
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
            Group_Service__c = groupService.id,  // Group Service
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
        
           //Create Product
           Product2 productObj = new Product2(Name = 'ATM Niaga MPLS - 32Kbps', Family = 'Non-GSM', Product_Code2__c = 'MPLS', Revenue_Type__c = 'Recurring', isActive = true);
           Insert productObj;

            //Create the PricebookEntry
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = productObj.Id,
                UnitPrice = 1020,
                IsActive = true
            );
            Insert pbe;
           
           /*
           Pricebook2 GSM_ActivationPricebook = new Pricebook2( name = 'GSM Activation',
               IsActive = true,
               GSM_Type__c = 'Package',
               Product_Category__c='SIM-Card Based',
               GSMProductType__c = 'Postpaid/Prepaid',
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
           */


           Pricebook2 SubscriptionPricebook = new Pricebook2( name = 'Sub Pricebook - MPLS',
               IsActive = true,
               Product_Category__c='Subscription Based',
               SiteType__c = 'One Site',
               SurveyType__c = 'Standard'
           );
           insert SubscriptionPricebook;

           PricebookEntry MPLSPbe = new PricebookEntry(
               Pricebook2Id = SubscriptionPricebook.Id,
               Product2Id = productObj.Id,
               UnitPrice = 1020,
               IsActive = true
           );
           Insert MPLSPbe;
           

            O.Accountid=accTest.id;
            O.Account_Site_A__c=accTest.id;
            O.Account_Site_B__c=accTest2.id;
            O.StageName='Prospecting';
            O.Name='TesSUBS';
            O.Link_Related__c=linkTest.id;
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id= Test.getStandardPricebookId();
            O.Periode_UOM__c='Month';
            O.BP_Payer__c=accTest2.id;
            O.BP_Vat__c=accTest2.id;
            O.Service_Type__c = 'Newlink';
            O.RecordTypeId = RecordTypeId_Opportunity_NonGSM;
            O.CurrencyIsoCode = 'IDR';
            insert O;
            
            OpportunitylineItem oliObjnonGsm = new OpportunitylineItem();
            oliObjnonGsm.unitprice = 10000;
            oliObjnonGsm.quantity = 2;
            oliObjnonGsm.billing_type__c = 'Monthly';
            oliObjnonGsm.Revenue_Type__c = 'Recurring';
            oliObjnonGsm.opportunityID = O.id;
            oliObjnonGsm.PricebookEntryId  = pbe.id;
            insert oliObjnonGsm;

            O2.Accountid=accTest.id;
            O2.Account_Site_A__c=accTest.id;
            O2.Account_Site_B__c=accTest2.id;
            O2.StageName='Prospecting';
            O2.Name='TesMPLS';
            O2.Link_Related__c=linkTest.id;
            O2.CloseDate=system.today().adddays(10);
            O2.Pricebook2id= SubscriptionPricebook.id;
            O2.Periode_UOM__c='Month';
            O2.BP_Payer__c=accTest2.id;
            O2.BP_Vat__c=accTest2.id;
            O2.Service_Type__c = 'NewLink';
            O2.CurrencyIsoCode = 'IDR';
            //O2.RecordTypeId = RecordTypeId_Opportunity_GSM;
            insert O2;

            OpportunitylineItem oliObj = new OpportunitylineItem();
            oliObj.unitprice = 10000;
            oliObj.quantity = 2;
            oliObj.billing_type__c = 'Monthly';
            oliObj.Revenue_Type__c = 'Recurring';
            oliObj.opportunityID = O2.id;
            oliObj.PricebookEntryId  = MPLSPbe.id;
            insert oliObj;

            O2.StageName = 'Negotiation';
            update O2;
        }
        
        Profitability__c ProfitabilityForecats = new Profitability__c();
        ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
        ProfitabilityForecats.Name = 'Testing';
        ProfitabilityForecats.Account__c = O.AccountId;
        ProfitabilityForecats.Opportunity__c = O.Id;
        ProfitabilityForecats.Status__c = 'Forecast';
        ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
        ProfitabilityForecats.Deal_Price__c = 10000;
        ProfitabilityForecats.One_Time_Revenue__c = 10000;
        Insert ProfitabilityForecats;
        
        SR_PR_Notification__c SR_PR_Notification_obj = new SR_PR_Notification__c(
            Name = 'PR-2106-015370',
            RecordTypeId = RecordTypeId_SR_PR,
            Notif_Type__c = 'PR',
            Project_Type__c = 'New',
            Services__c = 'MPLS',
            Project_Name__c = 'MPLS - PT Bank Central Asia Tbk,Jakarta Wisma BCA II',
            Status__c = 'In Progress',
            No_SR_khusus_PR__c = '2106-020235',
            Project_Coordinator_Text__c = '90002952 Abdul Hafidz kasim',
            Capacity_Before__c = '8',
            UOM_before__c = 'Mbps',
            Type_of_Lastmile__c = 'BWA P2P',
            Link_ID__c = '007CL26',
            Capacity_After__c = '100',
            UOM_After__c = 'Mbps',
            CID__c = '12131121',
            Opportunity__c = O.Id
        );
        insert SR_PR_Notification_obj;
        
        test.starttest();
        List<String> opportunityIds = new List<String>();
        opportunityIds.add(o.id);
        opportunityIds.add(o2.id);
        
        List<String> SR_PR_NotificationIds = new List<String>();
        SR_PR_NotificationIds.add(SR_PR_Notification_obj.id);
        //AppUtils.getProductCodeFromOpptyLineProduct(opportunityIds);
        ProfitabilityController_v2 ProfitabilityController_class = new ProfitabilityController_v2();
        ProfitabilityController_class.Create_Profitability_Forecats(opportunityIds);
        ProfitabilityController_class.Upsert_Profitability_GSM_Forecats(opportunityIds);
        ProfitabilityController_class.Email_Notif_to_Solution_Profitability_Forecats_UpdateToActual(SR_PR_NotificationIds);
        ProfitabilityController_class.Email_Notif_to_Solution_Profitability_Forecats_Created(opportunityIds);
        system.debug('oppId-->'+opportunityIds);
        test.stoptest();
    }
}