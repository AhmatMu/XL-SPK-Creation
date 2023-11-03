@isTest
public class TEST_REST_BAP_Temp_Isolation_Callin_v1 {

    @testSetup 
    static void setupRecord() {
        Id recordTypeId_bapTempIsolation = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Temporary Isolation').getRecordTypeId();
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        insert new Transaction__c(transactionID__c = 1);

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController=new Trigger_Controller__c();
        TriggerController.Name = 'Trigger_Bap_v2';
        TriggerController.Is_Active__c = True;
        lstTriggerController.add(TriggerController);

        Trigger_Controller__c TriggerController1=new Trigger_Controller__c();
        TriggerController1.Name = 'Trigger_Bap_v2_2';
        TriggerController1.Is_Active__c = True;
        lstTriggerController.add(TriggerController1);
        insert lstTriggerController;

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

        BAP__c bapTest = new BAP__c(
            RecordTypeId = recordTypeId_bapTempIsolation,
            BAP_ID__c = '9311',                                     
            Name = 'BAP 02-08491 PT Permata uang Tbk',
            Request_Date__c = System.today(),
            Type_of_Request__c = 'Isolasi Sementara',             
            Terminate_Date__c = System.today(),           
            Customer__c = accTest.Id,                              
            Request_Status__c = 'Draft',
            Link__c = linkTest.Id,                       
            Sirkit__c = 'PT wahana',                                
            Isolation_Start_Date__c = System.today(),     
            Address2__c = 'jalan orchid',                           
            Isolation_End_Date__c = System.today(),       
            PIC_Name__c = 'radhitya',                               
            Isolation_Desire_End_Date__c = System.today(),
            PIC_Phone__c = '123456788',                             
            PIC_email__c = 'testt@gmail.com',                       
            PIC_Position__c = 'SIT',                                
            Bandwidth_UOM__c = 'mbps',                              
            Reason__c = 'Harga (Commercial Issue)',                 
            Note__c = 'Testt SIT',                                  
            Remark__c = 'Process Isolation EDA',                                                   
            Contract_Start_Date__c = System.today(),                
            Contract_End_Date__c = System.today()         
        );
        insert bapTest;
    }

    @isTest
    static void testPutMethod(){
        List<BAP__c> bapList = [SELECT Id,BAP_ID__c,Request_Status__c,Remark__c FROM BAP__c];

        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/v1/bap_temporary_isolations';
        restRequest.httpMethod = 'PUT';
        restRequest.requestBody = Blob.valueof('{"header": {"request_id": "1234567890","service": "updatebaptistatus"},"body": {"data": {"bap_id": "9311","status": "Isolated"}}}');
        RestContext.request = restRequest;
        REST_BAP_Temp_Isolation_Callin_v1.doPut();   
    }

    @isTest
    static void testPutMethod2(){
        List<BAP__c> bapList = [SELECT Id,BAP_ID__c,Request_Status__c,Remark__c FROM BAP__c];

        RestRequest restRequest = new RestRequest();
        restRequest.requestURI = 'https://test.salesforce.com/services/apexrest/v1/bap_temporary_isolations';
        restRequest.httpMethod = 'PUT';
        restRequest.requestBody = Blob.valueof('{"header": {"request_id": "1234567890","service": "updatebaptistatus"},"body": {"data": {"bap_id": "9311","status": "Complete"}}}');
        RestContext.request = restRequest;
        REST_BAP_Temp_Isolation_Callin_v1.doPut();   
    }

}