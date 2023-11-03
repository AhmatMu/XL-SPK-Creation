@isTest(seealldata=true)
public class AccountProfitabilityController_Test {

    static testMethod void forecast() {
        //insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;

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

        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
        Account A=[SELECT id from Account where Name='PT BESS Finance' AND BP_Number__C='712822' AND ParentID=:HQ.id  LIMIT 1]; 
        Link__C L=[SELECT id FROM Link__c where Name='02-04034'];
        User U=[SELECT id FROM User WHERE ID=:HQ.ownerid];
          
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
        AccountContactRelation CR=new AccountContactRelation();
        Contact C=new Contact();
        C.LastName='Wiryo';
        C.Accountid=HQ.id;
        C.Firstname='Yohn';
        C.MobilePhone='0288282';
        C.Email='Fail@fail.com';
        insert C;

        CR.AccountID=A.id;
        CR.Contactid=C.id;
        CR.Roles='PIC Site;PIC BA Sign';
        insert CR;

        Opportunity O=new Opportunity();
        system.runas(U){
            O.Accountid=HQ.id;
            O.Account_Site_A__c=HQ.id;
            O.Account_Site_B__c=A.id;
            O.StageName='Prospecting';
            O.Name='Tes';
            O.Link_Related__c=L.id;
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id=PB.id;
            O.Periode_UOM__c='Month';
            O.BP_Payer__c=A.id;
            O.BP_Vat__c=A.id;
            O.Service_Type__c = 'Newlink';
            insert O;

            OpportunityLineItem OLI2=new OpportunityLineItem();
            OLI2.Product2id=Precurring.id;
            OLI2.OpportunityID=O.id;
            OLI2.revenue_type__c='Recurring';
            OLI2.UnitPrice=50000000;
            OLI2.Quantity=1;
            OLI2.Billing_Type__c='Monthly';
            OLI2.Contract_Start_Date__c=system.today().adddays(-3);
            OLI2.Contract_End_Date__c=system.today().adddays(3);
            insert OLI2;
        }

        Profitability__c ProfitabilityForecats = new Profitability__c();
        ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
        ProfitabilityForecats.Name = 'Testing';
        ProfitabilityForecats.Account__c = O.AccountId;
        ProfitabilityForecats.Opportunity__c = O.Id;
        ProfitabilityForecats.Status__c = 'Forecast';
        //ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
        ProfitabilityForecats.Stage__c = 'Forecast Cost is Complete';
        ProfitabilityForecats.opportunity__c = o.id;
        ProfitabilityForecats.Deal_Price__c = 10000;
        ProfitabilityForecats.One_Time_Revenue__c = 10000;
        Insert ProfitabilityForecats;

        test.starttest();
            system.runas(uu){
                Test.setCurrentPageReference(new PageReference('Page.AccountProfitabilityPage')); 
                System.currentPageReference().getParameters().put('id', String.valueOf(HQ.id));
        
                apexpages.standardcontroller sc=new apexpages.standardcontroller(HQ ); //ProfitabilityForecats);
                AccountProfitabilityController AccountProfitability = new AccountProfitabilityController(sc);
                AccountProfitability.beginning();
                AccountProfitability.next();
                //AccountProfitability.previous();
                //AccountProfitability.last();
                AccountProfitability.getDisableNext();
                AccountProfitability.getDisablePrevious();
                AccountProfitability.getDisableSelectAll();
                AccountProfitability.getRenderPage();
                AccountProfitability.getOpps();
                
                AccountProfitability.oppsw[0].isSelected = true;     
                AccountProfitability.processSelected();
                AccountProfitability.selectedOpportunityListIds.add(ProfitabilityForecats.Id);
                
                //AccountProfitability.previous();
                //AccountProfitability.last();
            

            }
        test.stoptest();
    }
    
    
    static testMethod void actual() {
        //insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;

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

        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
        Account A=[SELECT id from Account where Name='PT BESS Finance' AND BP_Number__C='712822' AND ParentID=:HQ.id  LIMIT 1]; 
        Link__C L=[SELECT id FROM Link__c where Name='02-04034'];
        User U=[SELECT id FROM User WHERE ID=:HQ.ownerid];
          
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
        AccountContactRelation CR=new AccountContactRelation();
        Contact C=new Contact();
        C.LastName='Wiryo';
        C.Accountid=HQ.id;
        C.Firstname='Yohn';
        C.MobilePhone='0288282';
        C.Email='Fail@fail.com';
        insert C;

        CR.AccountID=A.id;
        CR.Contactid=C.id;
        CR.Roles='PIC Site;PIC BA Sign';
        insert CR;

        Opportunity O=new Opportunity();
        system.runas(U){
            O.Accountid=HQ.id;
            O.Account_Site_A__c=HQ.id;
            O.Account_Site_B__c=A.id;
            O.StageName='Prospecting';
            O.Name='Tes';
            O.Link_Related__c=L.id;
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id=PB.id;
            O.Periode_UOM__c='Month';
            O.BP_Payer__c=A.id;
            O.BP_Vat__c=A.id;
            O.Service_Type__c = 'Newlink';
            insert O;

            OpportunityLineItem OLI2=new OpportunityLineItem();
            OLI2.Product2id=Precurring.id;
            OLI2.OpportunityID=O.id;
            OLI2.revenue_type__c='Recurring';
            OLI2.UnitPrice=50000000;
            OLI2.Quantity=1;
            OLI2.Billing_Type__c='Monthly';
            OLI2.Contract_Start_Date__c=system.today().adddays(-3);
            OLI2.Contract_End_Date__c=system.today().adddays(3);
            insert OLI2;
        }

        Profitability__c ProfitabilityForecats = new Profitability__c();
        ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
        ProfitabilityForecats.Name = 'Testing';
        ProfitabilityForecats.Account__c = O.AccountId;
        ProfitabilityForecats.Opportunity__c = O.Id;
        ProfitabilityForecats.Status__c = 'Actual';
        //ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
        ProfitabilityForecats.Stage__c = 'Fill Actual Cost';
        ProfitabilityForecats.opportunity__c = o.id;
        ProfitabilityForecats.Deal_Price__c = 10000;
        ProfitabilityForecats.One_Time_Revenue__c = 10000;
        Insert ProfitabilityForecats;

        test.starttest();
            system.runas(uu){
                Test.setCurrentPageReference(new PageReference('Page.AccountProfitabilityPage')); 
                System.currentPageReference().getParameters().put('id', String.valueOf(HQ.id));
        
                apexpages.standardcontroller sc=new apexpages.standardcontroller(HQ ); //ProfitabilityForecats);
                AccountProfitabilityController AccountProfitability = new AccountProfitabilityController(sc);
                AccountProfitability.beginning();
                AccountProfitability.next();
                //AccountProfitability.previous();
                //AccountProfitability.last();
                AccountProfitability.getDisableNext();
                AccountProfitability.getDisablePrevious();
                AccountProfitability.getDisableSelectAll();
                AccountProfitability.getRenderPage();
                AccountProfitability.getOpps();
                
                //AccountProfitability.oppsw[0].isSelected = true;
                AccountProfitability.processSelected();
                AccountProfitability.selectedOpportunityListIds.add(ProfitabilityForecats.Id);
                
            

            }
        test.stoptest();
    }

    
    static testMethod void forecastUpgrade() {
        //insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu = new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;

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

        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%Leased%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE SAP_Code__c ='LL-02' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account HQ=[SELECT id,OwnerID from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
        Account A=[SELECT id from Account where Name='PT BESS Finance' AND BP_Number__C='712822' AND ParentID=:HQ.id  LIMIT 1]; 
        Link__C L=[SELECT id FROM Link__c where Name='02-04034'];
        User U=[SELECT id FROM User WHERE ID=:HQ.ownerid];
          
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='Leased_Line'];
        AccountContactRelation CR=new AccountContactRelation();
        Contact C=new Contact();
        C.LastName='Wiryo';
        C.Accountid=HQ.id;
        C.Firstname='Yohn';
        C.MobilePhone='0288282';
        C.Email='Fail@fail.com';
        insert C;

        CR.AccountID=A.id;
        CR.Contactid=C.id;
        CR.Roles='PIC Site;PIC BA Sign';
        insert CR;

        Opportunity O=new Opportunity();
        system.runas(U){
            O.Accountid=HQ.id;
            O.Account_Site_A__c=HQ.id;
            O.Account_Site_B__c=A.id;
            O.StageName='Prospecting';
            O.Name='Tes';
            O.Link_Related__c=L.id;
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id=PB.id;
            O.Periode_UOM__c='Month';
            O.BP_Payer__c=A.id;
            O.BP_Vat__c=A.id;
            O.Service_Type__c = 'Upgrade';
            insert O;

            OpportunityLineItem OLI2=new OpportunityLineItem();
            OLI2.Product2id=Precurring.id;
            OLI2.OpportunityID=O.id;
            OLI2.revenue_type__c='Recurring';
            OLI2.UnitPrice=50000000;
            OLI2.Quantity=1;
            OLI2.Billing_Type__c='Monthly';
            OLI2.Contract_Start_Date__c=system.today().adddays(-3);
            OLI2.Contract_End_Date__c=system.today().adddays(3);
            insert OLI2;
        }

        Profitability__c ProfitabilityForecats = new Profitability__c();
        ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
        ProfitabilityForecats.Name = 'Testing';
        ProfitabilityForecats.Account__c = O.AccountId;
        ProfitabilityForecats.Opportunity__c = O.Id;
        ProfitabilityForecats.Status__c = 'Forecast';
        //ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
        ProfitabilityForecats.Stage__c = 'Forecast Cost is Complete';
        ProfitabilityForecats.opportunity__c = o.id;
        ProfitabilityForecats.Deal_Price__c = 10000;
        ProfitabilityForecats.One_Time_Revenue__c = 10000;
        Insert ProfitabilityForecats;

        test.starttest();
            system.runas(uu){
                Test.setCurrentPageReference(new PageReference('Page.AccountProfitabilityPage')); 
                System.currentPageReference().getParameters().put('id', String.valueOf(HQ.id));
        
                apexpages.standardcontroller sc=new apexpages.standardcontroller(HQ ); //ProfitabilityForecats);
                AccountProfitabilityController AccountProfitability = new AccountProfitabilityController(sc);
                AccountProfitability.beginning();
                AccountProfitability.next();
                //AccountProfitability.previous();
                //AccountProfitability.last();
                AccountProfitability.getDisableNext();
                AccountProfitability.getDisablePrevious();
                AccountProfitability.getDisableSelectAll();
                AccountProfitability.getRenderPage();
                AccountProfitability.getOpps();
                
                AccountProfitability.oppsw[0].isSelected = true;     
                AccountProfitability.processSelected();
                AccountProfitability.selectedOpportunityListIds.add(ProfitabilityForecats.Id);
                
                //AccountProfitability.previous();
                //AccountProfitability.last();
            

            }
        test.stoptest();
    }
}