/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-20-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-14-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest()
public class TEST_Trigger_ContractTicket{

@isTest
    static void testMethod1(){
        List<SAP_API_Setting__c> List_SAPAPISetting = new List<SAP_API_Setting__c>();

        SAP_API_Setting__c SAPAPISetting1 = new SAP_API_Setting__c();
        SAPAPISetting1.Name = 'SAPSoFreeMrc';
        SAPAPISetting1.Username__c = 'usernameTest1';
        SAPAPISetting1.Password__c = 'passwordTest1';
        SAPAPISetting1.URI__c = 'uriTest1';
        SAPAPISetting1.URL__c = 'urlTest1';
        List_SAPAPISetting.add(SAPAPISetting1);

        insert List_SAPAPISetting;

        insert new Transaction__c(transactionID__c = 1);

        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        Id RecordTypeId_Opportunity_NonGSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM').getRecordTypeId();

        Id RecordTypeId_Opportunity_GSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GSM (Activation)').getRecordTypeId();

        Profile pf = [Select Id from profile where Name='System Administrator'];

        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName = orgId+dateString+RandomId;

        User uu = new User(
            firstname = 'ABC', 
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
            accTest.Billing_Address_Province__c = 'jawa tengah';
            accTest.Billing_Address_City__c = 'kota surakarta';
            accTest.Shipping_Address_Province__c = 'jawa tengah';
            accTest.Shipping_Address_City__c = 'kota surakarta' ; 
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
                Using_HO_Billing_Address__c = false,
                Billing_Address_Province__c = 'jawa tengah',
                Billing_Address_City__c = 'kota surakarta',
                Shipping_Address_Province__c = 'jawa tengah',
                Shipping_Address_City__c = 'kota surakarta'                         
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

           //Create Product
            Product2 productObj = new Product2(Name = 'BIZ - Booster (Postpaid) - 1GB', Family = 'GSM', Product_Code2__c = 'Postpaid', Revenue_Type__c = 'Recurring', isActive = true);
            Insert productObj;

            //Create the PricebookEntry
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = productObj.Id,
                UnitPrice = 1020,
                IsActive = true
            );
            Insert pbe;

            Pricebook2 GSM_ActivationPricebook = new Pricebook2(
                name = 'GSM Activation',
                IsActive = true,
                GSM_Type__c = 'Package',
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

            O.Accountid=accTest.id;
            O.Account_Site_A__c=accTest.id;
            O.Account_Site_B__c=accTest2.id;
            O.StageName='Prospecting';
            O.Name='Tes';
            O.Link_Related__c=linkTest.id;
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id= Test.getStandardPricebookId();
            O.Periode_UOM__c='Month';
            O.BP_Payer__c=accTest2.id;
            O.BP_Vat__c=accTest2.id;
            O.Service_Type__c = 'Newlink';
            O.RecordTypeId = RecordTypeId_Opportunity_NonGSM;
            insert O;

            Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            tmpContract.Account__c = accTest.Id;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = O.id;
            insert tmpContract;

            contractTest.Contract_Ticket__c = tmpContract.id;
            update contractTest;

            Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
            CTI.Contract_Item__c = contractTest.id;
            CTI.Contract_Ticket__c = TmpContract.id;
            insert CTI;

            Scheduled_Process__c sp = new Scheduled_Process__c();
            sp.type__c = 'Callout SO';
            sp.status__c = 'Waiting';
            sp.Notes2__c = 'test1';
            sp.Execute_Plan__c = system.now();
            insert SP;

            test.starttest();
            tmpContract.ticketstatus__c='Pending';
            tmpContract.Pending_Reason__c='Gagal Bayar';
            update tmpContract;
            
            tmpContract.ticketstatus__c='Review By Finance';
            update tmpContract;
            
            tmpContract.TicketStatus__c= 'Complete';
            update tmpContract;
        }
    }
    
    /*static testMethod void doScenario1Test() {
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Account acc = new Account();  
        acc.Name = 'Test Admin Vando';
        acc.Organization_Type__c = 'Head Office';
        acc.recordtypeid = RecordTypeIdAccount;
        Insert acc;
        
        Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GSM').getRecordTypeId();
        
        //Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        
        
        Opportunity Opp = New Opportunity();
        Opp.Name = 'Test oppty';
        Opp.Project_Group__c = 'Test oppty';
        Opp.CloseDate = system.today();
        Opp.AccountId = acc.id;
        Opp.StageName = 'Prospecting';
        Opp.Amount = 2250000;
        Opp.Pricebook2id= PB.id;
        Opp.RecordTypeId = RecordTypeIdOpp;
        insert Opp;
        
        OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=Precurring.id;
          OLI2.OpportunityID=Opp.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=50000000;
          OLI2.Quantity=1;
        insert OLI2;
        
        Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
        //tmpContract.name = 'TEST test';
        tmpContract.Account__c = acc.Id;
        tmpContract.Currency__c = 'IDR';
        tmpContract.TicketStatus__c = 'Review By Contract Manager';
        tmpContract.Opportunity__c = Opp.id;
        insert tmpContract;
        
        Contract ci = new Contract();
        ci.name ='CI TEST';
        ci.Contract_Ticket__c = tmpContract.id;
        ci.Accountid=acc.id;
        ci.Opportunity__c=Opp.id;
        ci.Contract_Ticket__c=tmpContract.id;
        ci.Billing_Type__c=''; 
        ci.End_Date__c=system.today().addmonths(3);                   
        ci.start_Date__c=system.today().addmonths(3); 
        ci.Bill_Plan_End_Date__c=system.today().addyears(1);                 
        insert ci;
        
        Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
        CTI.Contract_Item__c=ci.id;
        CTI.Contract_Ticket__c=TmpContract.id;
        insert CTI;
        
        test.starttest();
        tmpContract.ticketstatus__c='Pending';
        tmpContract.Pending_Reason__c='Gagal Bayar';
        update tmpContract;
        
        tmpContract.ticketstatus__c='Review By Finance';
        update tmpContract;
        
        tmpContract.TicketStatus__c= 'Complete';
        update tmpContract;
        test.stoptest();
        
    }*/
    
}