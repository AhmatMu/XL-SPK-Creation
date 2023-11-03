@isTest(seeAllData=false)
public class SetOpportunityAttributesTest {
    
    @testSetup
    static void createUser(){
        
        UserRole urHead = [SELECT Id FROM UserRole WHERE Name='Head - Banking & Financial Services'];
        UserRole urSales = [SELECT Id FROM UserRole WHERE Name='Banking & Financial Services'];
        
        Profile GHprofiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales' limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User GHUser = new User(  
            Alias = 'ahmad',                                                              // Alias
            Email = 'ahmad@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = GHprofiles.id,                                                     // Profile
            Username = 'ahmad@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '900078723',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'ahmad',
            LastName='murti',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US');
        insert GHUser;
        
        User salesManagerUser = new User(  
            Alias = 'ngibrit',                                                            // Alias
            Email = 'ngibrit@xl.co.id',                                                  // Email
            EmailEncodingKey='UTF-8',
            Username = 'ngibrit@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = GHUser.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003712',                                               // Employee ID
            firstName = 'ngibrit',
            LastName='banget',
            ProfileId = SMProfile.Id,
            UserRoleId = urHead.id);
        insert salesManagerUser;
        User salesUser = new User(  firstname = 'Ahmat',
                                  lastName = 'Murad',
                                  email = uniqueName + '@test' + orgId + '.org',
                                  Username = uniqueName + '@test' + orgId + '.org',
                                  EmailEncodingKey = 'ISO-8859-1',
                                  Alias = uniqueName.substring(18, 23),
                                  TimeZoneSidKey = 'America/Los_Angeles',
                                  LocaleSidKey = 'en_US',
                                  ManagerId = salesManagerUser.id,
                                  LanguageLocaleKey = 'en_US',
                                  ProfileId = AMProfile.id,
                                  UserRoleId = urSales.Id);
        insert salesUser;
    }
    
    @istest 
    static void addOpptyAMRelated(){
        
        Product2 productObj = new Product2(Name = 'Mincom VoIP - Rp 15,000,000', Family = 'NGSM', productcode = 'VOIP', Revenue_Type__c = 'Recurring');
        Insert productObj;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        Pricebook2 voipPricebook = new Pricebook2( name = 'VoIP',
                                                  IsActive = true
                                                 );
        insert voipPricebook;
        
        PricebookEntry voipPbe = new PricebookEntry(
            Pricebook2Id = voipPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert voipPbe;
        User sales = [SELECT Id FROM User WHERE firstname = 'Ahmat' AND lastName = 'Murad' Limit 1];
        User SM = [SELECT Id FROM User WHERE username = 'ngibrit@xl.co.id' Limit 1];
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account accObj = new Account(
            Name = 'PT Teknologi Perdana Indonesia',                // Account Name
            OwnerId = sales.id,
            RecordTypeId = RecordTypeAccId,                               // Account Record Type
            BP_Number__c = '752858',                                  // BP Number
            Organization_Type__c = 'Head Office',                     // Organization Type
            Type = 'Customer',                                        // Type
            Unique_Name__c = 'Jakarta Wisma NH',                      // Unique Name
            Keyword__c = 'TEKPEI',                                    // Keyword
            Customer_Type__c = 'NONGSM',                              // Customer Type
            Payer_For_GSM_Invoice__c = false,                         // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',       // Term of Payment
            Company_Group__c = 'TEKNOLOGI PERDANA',                   // Company_Group
            Customer_VAT_Name__c = 'PT Teknologi Perdana Indonesia',  // Customer VAT Name
            Summary_Billing__c = false,                               // Summary Billing
            Using_HO_Billing_Address__c = false                      // Using HO Billing Address
        );
        insert accObj;
        system.runAs(sales)  {
            
            //insert oppty
            Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM VoIP').getRecordTypeId();
            Opportunity oppObj = new Opportunity(
                Service_Type__c = 'Newlink',                       // Service Type
                RecordTypeId = RecordTypeOppId,                          // Opportunity Record Type
                //   OwnerId = sales.id,
                sales_manager_owner__c = SM.id,
                Project_Group__c = 'VOIP Maxima',                    // Project Group
                Auto_Renewal__c = false,                             // Auto Renewal
                trial__c = false,                                    // trial
                Name = 'VOIP Maxima',                                // Opportunity Name
                AccountId = accObj.id,                             // Account Name
                //Solution_PIC__c = 'undefined',                       // Solution PIC
                CloseDate =  Date.newInstance(2021,06, 30) ,              // Target Closed Date
                Actual_Closed_Date__c =  Date.newInstance(2021,06,30) ,  // Closed Date
                Contract_Periode__c = 12,                          // Contract Periode
                StageName = 'Prospecting',                           // Stage
                Probability = 0,                                     // Probability (%)
                Amount = 15000,                                     // Amount
                Remark__c = 'Approved',                              // Remark
                LeadSource = 'Other',                                // Lead Source
                BW_before__c = '0',                                  // Capacity before
                Uom_BW_Before__c = 'Kbps',                           // Uom BW Before
                BW_after__c = '0',                                   // Capacity after
                Uom_BW_After__c = 'Kbps',                            // Uom BW After
                Pricebook2id = voipPricebook.id,
                Mark_as_Sales_Revenue__c = false 
            );
            insert oppObj; 
            
            //insert oli
            OpportunitylineItem oliObj = new OpportunitylineItem(
                unitprice = 10000,
                quantity = 2,
                billing_type__c = 'Monthly',
                Revenue_Type__c = 'Recurring',
                opportunityID = oppObj.id,
                PricebookEntryId  = voipPbe.id
            );        
            insert oliObj;
            //SetOpportunityAttributes oppAttributes = new SetOpportunityAttributes();
            
        }
        test.startTest();
        List<Opportunity> Opplist = [SELECT id, ownerid FROM Opportunity];
        SetOpportunityAttributes.SetOpportunityAttributes(Opplist);
        test.stopTest();
    }
    
    @istest 
    static void addOpptySMRelated(){
        
        Product2 productObj = new Product2(Name = 'Mincom VoIP - Rp 15,000,000', Family = 'NGSM', productcode = 'VOIP', Revenue_Type__c = 'Recurring');
        Insert productObj;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        Pricebook2 voipPricebook = new Pricebook2( name = 'VoIP',
                                                  IsActive = true
                                                 );
        insert voipPricebook;
        
        PricebookEntry voipPbe = new PricebookEntry(
            Pricebook2Id = voipPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert voipPbe;
        User sales = [SELECT Id FROM User WHERE firstname = 'Ahmat' AND lastName = 'Murad' Limit 1];
        User SM = [SELECT Id FROM User WHERE username = 'ngibrit@xl.co.id' Limit 1];
        User GH = [SELECT Id FROM User WHERE username = 'ahmad@xl.co.id' Limit 1];
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account accObj = new Account(
            Name = 'PT Teknologi Perdana Indonesia',                // Account Name
            OwnerId = SM.id,
            RecordTypeId = RecordTypeAccId,                               // Account Record Type
            BP_Number__c = '752858',                                  // BP Number
            Organization_Type__c = 'Head Office',                     // Organization Type
            Type = 'Customer',                                        // Type
            Unique_Name__c = 'Jakarta Wisma NH',                      // Unique Name
            Keyword__c = 'TEKPEI',                                    // Keyword
            Customer_Type__c = 'NONGSM',                              // Customer Type
            Payer_For_GSM_Invoice__c = false,                         // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',       // Term of Payment
            Company_Group__c = 'TEKNOLOGI PERDANA',                   // Company_Group
            Customer_VAT_Name__c = 'PT Teknologi Perdana Indonesia',  // Customer VAT Name
            Summary_Billing__c = false,                               // Summary Billing
            Using_HO_Billing_Address__c = false                      // Using HO Billing Address
        );
        insert accObj;
        system.runAs(SM)  {
            
            //insert oppty
            Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM VoIP').getRecordTypeId();
            Opportunity oppObj = new Opportunity(
                Service_Type__c = 'Newlink',                       // Service Type
                RecordTypeId = RecordTypeOppId,                          // Opportunity Record Type
                //   OwnerId = sales.id,
                sales_manager_owner__c = GH.id,
                Project_Group__c = 'VOIP Maxima',                    // Project Group
                Auto_Renewal__c = false,                             // Auto Renewal
                trial__c = false,                                    // trial
                Name = 'VOIP Maxima',                                // Opportunity Name
                AccountId = accObj.id,                             // Account Name
                //Solution_PIC__c = 'undefined',                       // Solution PIC
                CloseDate =  Date.newInstance(2021,06, 30) ,              // Target Closed Date
                Actual_Closed_Date__c =  Date.newInstance(2021,06,30) ,  // Closed Date
                Contract_Periode__c = 12,                          // Contract Periode
                StageName = 'Prospecting',                           // Stage
                Probability = 0,                                     // Probability (%)
                Amount = 15000,                                     // Amount
                Remark__c = 'Approved',                              // Remark
                LeadSource = 'Other',                                // Lead Source
                BW_before__c = '0',                                  // Capacity before
                Uom_BW_Before__c = 'Kbps',                           // Uom BW Before
                BW_after__c = '0',                                   // Capacity after
                Uom_BW_After__c = 'Kbps',                            // Uom BW After
                Pricebook2id = voipPricebook.id,
                Mark_as_Sales_Revenue__c = false 
            );
            insert oppObj; 
            
            //insert oli
            OpportunitylineItem oliObj = new OpportunitylineItem(
                unitprice = 10000,
                quantity = 2,
                billing_type__c = 'Monthly',
                Revenue_Type__c = 'Recurring',
                opportunityID = oppObj.id,
                PricebookEntryId  = voipPbe.id
            );        
            insert oliObj;
            //SetOpportunityAttributes oppAttributes = new SetOpportunityAttributes();
            
        }
        test.startTest();
        List<Opportunity> Opplist = [SELECT id, ownerid FROM Opportunity];
        SetOpportunityAttributes.SetOpportunityAttributes(Opplist);
        test.stopTest();
    }
}