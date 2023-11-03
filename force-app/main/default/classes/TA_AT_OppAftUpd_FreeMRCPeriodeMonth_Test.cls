/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-11-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-11-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class TA_AT_OppAftUpd_FreeMRCPeriodeMonth_Test {
    static testMethod void myUnitTest1() {
        insert new Transaction__c(transactionID__c = 1);
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Id RecordTypeId_SR_PR = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR 4G Access').getRecordTypeId();
        
        Id RecordTypeId_Opportunity_NonGSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM').getRecordTypeId();
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
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
            contractTest.Product_Charge_Type_filled__c = 'Recurring';
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
            Product2 productObj = new Product2(
                Name = 'FREE MRC - BIZ - Booster (Postpaid)', 
                Family = 'GSM', 
                Product_Code2__c = 'Postpaid', 
                Revenue_Type__c = 'Recurring', 
                isActive = true
            );
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
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id= Test.getStandardPricebookId();
            O.Periode_UOM__c='Month';
            O.BP_Payer__c=accTest2.id;
            O.BP_Vat__c=accTest2.id;
            O.Service_Type__c = 'Newlink';
            O.RecordTypeId = RecordTypeId_Opportunity_NonGSM;
            O.Contract_Periode__c = 1;
            insert O;

            OpportunitylineItem oliObjnonGsm = new OpportunitylineItem();
            oliObjnonGsm.unitprice = 10000;
            oliObjnonGsm.quantity = 2;
            oliObjnonGsm.billing_type__c = 'Monthly';
            oliObjnonGsm.Revenue_Type__c = 'Recurring';
            oliObjnonGsm.opportunityID = O.id;
            oliObjnonGsm.PricebookEntryId  = pbe.id;
            insert oliObjnonGsm;

            Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            tmpContract.Account__c = accTest.Id;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = O.id;
            insert tmpContract;

            contractTest.Product__c = productObj.id;
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
            insert SP;
        }
        
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
            Opportunity__c = O.Id,
            Billing_Start_Date__c = system.today()
        );
        insert SR_PR_Notification_obj;

        SAP_Material_Code__c SAPMaterialCodeRec = new SAP_Material_Code__c(
            Recurring_Material_Code__c = 'LL-02',
            Free_Material_Code__c = 'LL-12',
            Discocunt_Material_Code__c = ''
        );
        insert SAPMaterialCodeRec;

        Test.startTest();

        O.Free_MRC_Periode_Month_Invoice__c = '1';
        update O;

        Test.stopTest();
    }
}