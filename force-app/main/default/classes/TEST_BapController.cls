@isTest
public class TEST_BapController {

    @testSetup 
    static void setupRecord() {
        Id recordTypeId_bapTempIsolation = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Temporary Isolation').getRecordTypeId();
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        insert new Transaction__c(transactionID__c = 1);

        Account accTest = new Account();
        accTest.RecordTypeId = recordTypeId_accBP;
        accTest.Name = 'TEST';
        accTest.Unique_Name__c = 'TEST';
        accTest.NumberOfEmployees = 2;
        accTest.Company_Group__c = 'Perusahaan Asing';
        accTest.Customer_VAT_Name__c = 'sdfskdjfsjdf';
        accTest.Customer_Type__c = 'NONGSM';
        accTest.No_NPWP__c = 'ojsnonjsdf';
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
        accTest.BP_Number__c = '730250';
        accTest.Bizstore_Complete__c = false;
        Insert accTest;

        /*insert new Link_CID__c(CID_4GACCESS__c = 1);

        Circuit__c circuitTest = new Circuit__c(
            Name = 'Auto'
        );
        insert circuitTest;*/

        Link__c linkTest = new Link__c(
            Name = '02-04340',                                                                        
            BU__c = 'ENTERPRISE',                                                                     
            ID__c = '123455',                                                                         
            Status_Link__c = 'IN_SERVICE',                                                            
            Company_Name__c = 'Wahana Dunia Serenada',                                                
            Service_Type__c = 'MPLS',                                                                 
            Contract_Item__c = '3003032-13',                                                          
            BP_Site_A__c = '730250',                                                                  
            Capacity_Bandwidth__c = '8',                                                              
            UoM__c = 'Mbps',                                                                          
            Routepath__c = '730250 Wahaa Dunia Serenada (HO) - 7788 teluk puyuh - 9923 Haruan Basaru',
            //CID_RelD__c = circuitTest.Id,                                                                
            Link_ID__c = '007CL24',                                                                   
            Site_A_Name__c = accTest.Id,                                                             
            //Contract_Item_Rel__c = 'undefined',                                                       
            Free_Link__c = true,                                                                     
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
            //Link__c = linkTest.Id,                       
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
            //EDA__c = EdaSubmitTempIsolation.Id,                                   
            Contract_Start_Date__c = System.today(),      
            //EDA_for_Extend_Isolation__c = EdaExtendTempIsolation.Id,              
            Contract_End_Date__c = System.today()         
        );
        insert bapTest;

        EDA__c EdaSubmitTempIsolation = new EDA__c(
            Name = 'Temporary Isolation ' + bapTest.Name,
            Document_Type__c = 'IOM',
            IOM_Type__c = 'Temporary Isolation',
            EDA_Status__c = 'Draft',
            Related_Customer__c = bapTest.Customer__c,
            BAP__c = bapTest.Id,
            Summary__c = 
            'Request to Process Temporary Isolation : ' + '\n' +
            'Link ID : ' + bapTest.CID__c + '\n' +
            'BA Isolation : ' + bapTest.Id + '\n' +
            'Customer : ' + bapTest.Customer__c + '\n' +
            'Start Isolation Date : ' + bapTest.Isolation_Start_Date__c + '\n' +
            'End Isolation Date : ' + bapTest.Isolation_End_Date__c
        );
        insert EdaSubmitTempIsolation;

        EDA__c EdaExtendTempIsolation = new EDA__c(
            Name = 'Extend Temporary Isolation ' + bapTest.Name,
            Document_Type__c = 'IOM',
            IOM_Type__c = 'Extend Temporary Isolation',
            EDA_Status__c = 'Draft',
            Related_Customer__c = bapTest.Customer__c,
            BAP__c = bapTest.Id,
            Summary__c = 
            'Request to Process Temporary Isolation : ' + '\n' +
            'Link ID : ' + bapTest.CID__c + '\n' +
            'BA Isolation : ' + bapTest.Id + '\n' +
            'Customer : ' + bapTest.Customer__c + '\n' +
            'Start Isolation Date : ' + bapTest.Isolation_Start_Date__c + '\n' +
            'End Isolation Date : ' + bapTest.Isolation_Desire_End_Date__c
        );
        insert EdaExtendTempIsolation;
    }

    @isTest
    static void Update_BAPTempIsolationStatus_Draft(){
        List<BAP__c> bapList = [SELECT Id FROM BAP__c];
        
        if(bapList!=null && !bapList.isEmpty()){
            BapController BapController_class = new BapController();
            BapController_class.Update_BAPTempIsolationStatus_Draft(bapList[0].Id);
        }
    }

    @isTest
    static void Update_BAPTempIsolationStatus_ProcessIsolation(){
        List<BAP__c> bapList = [SELECT Id FROM BAP__c];

        if(bapList!=null && !bapList.isEmpty()){
            BapController BapController_class = new BapController();
            BapController_class.Update_BAPTempIsolationStatus_ProcessIsolation(bapList[0].Id);
        }
    }

    @isTest
    static void Update_BAPTempIsolationStatus_Rejected_BacktoDraft(){
        List<BAP__c> bapList = [SELECT Id FROM BAP__c];

        if(bapList!=null && !bapList.isEmpty()){
            BapController BapController_class = new BapController();
            BapController_class.Update_BAPTempIsolationStatus_Rejected_BacktoDraft(bapList[0].Id);
        }
    }

    @isTest
    static void Update_BAPTempIsolationStatus_EndDate(){
        List<BAP__c> bapList = [SELECT Id FROM BAP__c];

        if(bapList!=null && !bapList.isEmpty()){
            BapController BapController_class = new BapController();
            BapController_class.Update_BAPTempIsolationStatus_EndDate(bapList[0].Id);
        }
    }

}