@isTest
public class ProfitabilityHistoryActual_Week_Test {

    static testMethod void myUnitTest1() {
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();
        Id recordTypeId_ProfitabilityIot = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('IOT MCA').getRecordTypeId();
        insert new Transaction__c(transactionID__c = 1);

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

        Profitability__c ProfitabilityForecats = new Profitability__c();
        ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
        ProfitabilityForecats.Name = 'Testing';
        ProfitabilityForecats.Account__c = accTest.Id;
        //ProfitabilityForecats.Opportunity__c = O.Id;
        ProfitabilityForecats.Status__c = 'Forecast';
        ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
        ProfitabilityForecats.Deal_Price__c = 10000;
        ProfitabilityForecats.One_Time_Revenue__c = 10000;
        Insert ProfitabilityForecats;

        Test.startTest();
        Datetime nextSchedule = system.now().addSeconds(3);

        String hour = String.valueOf( nextSchedule.hour());
        String min = String.valueOf( nextSchedule.minute()); 
        String ss = String.valueOf( nextSchedule.second());
        String sDay = string.valueof( nextSchedule.day() ); 
        String sYear = string.valueof( nextSchedule.year() );
        String sMonth = string.valueof( nextSchedule.month() );

        String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

        ProfitabilityHistory_Schedule_Week test1 = new ProfitabilityHistory_Schedule_Week(datetime.newInstanceGmt(2021, 07, 05)); 
        System.schedule('ProfitabilityHistory_Schedule_Week ' + String.valueOf(system.now()), nextFireTime, test1);

        ProfitabilityHistory_Schedule_Month test2 = new ProfitabilityHistory_Schedule_Month(datetime.newInstanceGmt(2021, 07, 05)); 
        System.schedule('ProfitabilityHistory_Schedule_Month ' + String.valueOf(system.now()), nextFireTime, test2);

        ProfitabilityHistory_Schedule_Year test3 = new ProfitabilityHistory_Schedule_Year(datetime.newInstanceGmt(2021, 07, 05)); 
        System.schedule('ProfitabilityHistory_Schedule_Year ' + String.valueOf(system.now()), nextFireTime, test3);
        Test.stopTest();
    }

}