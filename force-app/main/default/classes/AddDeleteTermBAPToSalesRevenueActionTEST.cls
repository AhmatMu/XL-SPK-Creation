@istest
private class AddDeleteTermBAPToSalesRevenueActionTEST {
    @IsTest
    static void methodName(){

        
        Sales_Performance_General__c customSettingObj = new Sales_Performance_General__c();
        
        customSettingObj.Name = 'SRV Criteria - BAP Link Churn';
        customSettingObj.Value__c = 'SRV Criteria - BAP Link Churn';
        customSettingObj.Format__c = 'String';
        
        insert customSettingObj;
        
        
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Account accObj = new Account(
            Name = 'PT Bank HSBC Indonesia',                                              // Account Name
            RecordTypeId = RecordTypeAccId,                                                     // Account Record Type
            BP_Number__c = '700816',                                                        // BP Number
            //Assign_To__c = 'undefined',                                                     // Assign To
            Organization_Type__c = 'Head Office',                                           // Organization Type
            Type = 'Customer',                                                              // Type
            Unique_Name__c = 'Jakarta Menara Mulia',                                        // Unique Name
            Customer_Type__c = 'NONGSM',                                                    // Customer Type
            Payer_For_GSM_Invoice__c = false,                                               // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',                             // Term of Payment
            Company_Group__c = 'THE HONGKONG SHANGHAI BANKING CORPORATION LIMITED (HSBC)',  // Company_Group
            Customer_VAT_Name__c = 'PT. BANK HSBC INDONESIA',                               // Customer VAT Name
            Summary_Billing__c = false,                                                     // Summary Billing
            Using_HO_Billing_Address__c = false,                                            // Using HO Billing Address
            Relocation_Street_1__c = 'MMU Lt 23 (ruang server) Jakarta',                    // Relocation Street 1
            No_NPWP__c = '013862420091000'                                                 // No NPWP
            );
        insert accObj;

        Link__c linkObj = new Link__c(
            ID__c = '11807',                                       // ID
            CID__c = '12-00106',                                     // CID *
            BU__c = 'ENTERPRISE',                                    // BU
            //CID_RelD__c = 'undefined',                               // CID RelD
            Name = '12-00106',                                       // CID/Link ID
            Company_Name__c = 'PT Bank HSBC Indonesia',              // Company Name
            Link_ID__c = '020C247L44',                               // Link ID
            Contract_Item__c = '3001063-27',                         // Contract Item
            Status_Link__c = 'IN_SERVICE',                           // Status Link
            Routepath__c = '723115 PT Bank HSBC Indonesia ATM Ciputra World Surabaya Surabaya - 1541 GUNDIH JAW-JI-SBY-2408 - SNB Surabaya Network Building - RAWAPENING HUT GRAHA XL - PC027 WTC JAW-JK-KYB-2711 - 722776 HSBC WTC 1 Lt.5 Jl. Jend.Sudirman Kav.29-31, Karet Jakarta Selatan 12920',  // Routepath
            Service_Type__c = 'L2VPN',                               // Service Type
            BP_Site_A__c = '723115',                                 // BP Site A
            BP_Site_B__c = '722776',                                 // BP Site B
            Site_A_Name__c = accObj.id,                            // Site A Name
            //Site_B_Name__c = 'undefined',                            // Site B Name
            Capacity_Bandwidth__c = '64',                            // Capacity Bandwidth
            UoM__c = 'Kbps',                                         // UoM
            Free_Link__c = true,                                    // Free Link
            Partner__c = false                                      // Partner
 
            );
        insert linkObj; 



        //addTerminationBAPData
        Id RecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();
        BAP__c bapObj = new BAP__c(
            BAP_No__c = 'BAP-11052021-15452',                                         // BAP No
            BAP_ID__c = '15453',                                                        // BAP ID
            Request_Status__c = 'Draft',                                  // Request Status
            Name = 'BAP 12-00106 PT Bank HSBC Indonesia  ATM Ciputra World Surabaya',   // BAP Name
            Links_Info__c = '1. 020C247L44',                                            // Links Info
            Type_of_Request__c = 'Pemutusan',                                           // Type of Request
            Customer__c = accObj.id,                                                  // Customer
            Approval_Flag__c = 'Tidak',                                                 // Approval Flag
            Pernah_Disubmit__c = false,                                                 // Pernah Disubmit
            Sirkit__c = 'PT Bank HSBC Indonesia  ATM Ciputra World Surabaya',           // Sirkit
            PIC_Name__c = 'Yuniarto Nugroho',                                           // PIC Name
            RecordTypeId = RecordTypeId,                                                 // Record Type
            PIC_Phone__c = '0818938333',                                                // PIC Phone
            PIC_email__c = 'yuniartonugroho@hsbc.co.id',                                // PIC email
            PIC_Position__c = 'IT Infrastructure',                                      // PIC Position
            Request_Date__c = Date.newinstance (2021,05,11),                               // Submit Date
            Terminate_Date__c = Date.newinstance (2021,06,11),                             // Terminate Date
            Reason__c = 'Kontrak berakhir atau tidak diperpanjang',                     // Reason
            Note__c = 'Kontrak Berakhir dan tidak diperpanjang',                        // Note
            Pinalty_Flag__c = false,                                                    // Pinalty Flag
            Pinalty__c = 0,                                                           // Pinalty
            //Mirroring_Status__c = 'Success',   
            Mark_as_Churn_Link_Sales_Revenue__c = false,                                         // Mirroring Status
            Lebih_Tagih__c = 0,                                                       // Lebih Tagih
            Cost_Flag__c = false,                                                       // Cost Flag
            Cost__c = 0,                                                              // Cost
            IsBackDate__c = false,                                                      // IsBackDate / IsEarly
            IsPenalty__c = false,     
            Mirroring_Status__c = 'Success' ,                                                  // IsPenalty
            //Sales_Group_Head__c = 'undefined',                                          // Sales Group Head
            IsCostPartner__c = false ,                                                  // Cost Partner > 100jt
            //Stamp_Stage_Submit__c = Datetime.valueOf('11-05-2021 17:28:00'),            // Stamp Stage Submit
            //Stamp_Stage_Sent_to_Customer__c = Datetime.valueOf('14-05-2021 06:05:00'),  // Stamp Stage Sent to Customer
            //Stamp_Stage_Operation_Review__c = Datetime.valueOf('11-05-2021 17:28:00')  // Stamp Stage Operation Review
            link__c = linkObj.id,
            Address2__c = 'jl. cempaka VI'
            );

            insert bapObj;

            bapObj.Request_Status__c = 'Submit';
            //bapObj.Complete_Status__c = 'Done';    
            bapObj.Mark_as_Churn_Link_Sales_Revenue__c = true;
            update bapObj;
            List<BAP__c> bapList =  new List<BAP__c> ();
            bapList.add(bapObj);

            bapList = [SELECT Id, OwnerId, Name, RecordTypeId, CreatedById, LastModifiedById, BAP_No__c, CID__c, Note__c, PIC_email__c, PIC_Name__c, PIC_Phone__c, PIC_Position__c, Reason__c, Request_Date__c, Request_Status__c, Sirkit__c, Terminate_Date__c, Type_of_Request__c, Address__c, BAP_ID__c, Bandwidth_rel__c, Customer__c, Links_Info__c, Mirroring_Status__c, UoM_rel__c, Contract_End_Date__c, Contract_Start_Date__c, Cost_Flag__c, Cost__c, IsBackDate__c, IsCostPartner__c, IsPenalty__c, Lebih_Tagih__c, Pinalty_Flag__c, Pinalty__c, IoM_Approval_Status__c, Sales_Group_Head__c, Approval_Flag__c, Pernah_Disubmit__c, Default_Terminate_Date__c, Link_Service_Type__c, Stamp_Stage_Complete__c, Stamp_Stage_IOM_Approval__c, Stamp_Stage_Operation_Review__c, Stamp_Stage_Sent_to_Customer__c, Stamp_Stage_Sent_to_Finance__c, Stamp_Stage_Submit__c, Aging_Sent_to_Customer__c, AM_Employee_ID__c, Customer_BP_No__c, Sales_Revenue_Rel__c, Mark_as_Churn_Link_Sales_Revenue__c, Complete_Status__c, Recordtype_Name__c, Request_Status_Full__c   
            FROM BAP__c
            WHERE id =:bapObj.id];
            
                test.startTest();
            system.debug (' == bapObj1 : '  +bapObj);
            AddDeleteTermBAPToSalesRevenueAction.addDeleteTermBAPToSalesRevenueAction( bapList );
            system.debug (' == bapObj2 : '  +bapObj);
            bapObj.Request_Status__c = 'Complete';
            bapObj.Complete_status__c = 'Done';
            bapObj.Mark_as_Churn_Link_Sales_Revenue__c = True;
            system.debug (' == bapObj3 : '  +bapObj);

            update bapObj;

            //bapList.add(bapObj);

            bapList = [SELECT Id, OwnerId, Name, RecordTypeId, CreatedById, LastModifiedById, BAP_No__c, CID__c, Note__c, PIC_email__c, PIC_Name__c, PIC_Phone__c, PIC_Position__c, Reason__c, Request_Date__c, Request_Status__c, Sirkit__c, Terminate_Date__c, Type_of_Request__c, Address__c, BAP_ID__c, Bandwidth_rel__c, Customer__c, Links_Info__c, Mirroring_Status__c, UoM_rel__c, Contract_End_Date__c, Contract_Start_Date__c, Cost_Flag__c, Cost__c, IsBackDate__c, IsCostPartner__c, IsPenalty__c, Lebih_Tagih__c, Pinalty_Flag__c, Pinalty__c, IoM_Approval_Status__c, Sales_Group_Head__c, Approval_Flag__c, Pernah_Disubmit__c, Default_Terminate_Date__c, Link_Service_Type__c, Stamp_Stage_Complete__c, Stamp_Stage_IOM_Approval__c, Stamp_Stage_Operation_Review__c, Stamp_Stage_Sent_to_Customer__c, Stamp_Stage_Sent_to_Finance__c, Stamp_Stage_Submit__c, Aging_Sent_to_Customer__c, AM_Employee_ID__c, Customer_BP_No__c, Sales_Revenue_Rel__c, Mark_as_Churn_Link_Sales_Revenue__c, Complete_Status__c, Recordtype_Name__c, Request_Status_Full__c   
            FROM BAP__c
            WHERE id =:bapObj.id];


            AddDeleteTermBAPToSalesRevenueAction.addDeleteTermBAPToSalesRevenueAction( bapList  );

            test.stopTest();
            
            /*
            insert bapObj;
        
            bapObj.Request_Status__c = 'Submit';
            //bapObj.Complete_Status__c = 'Done';    
            bapObj.Mark_as_Churn_Link_Sales_Revenue__c = true;
            update bapObj;
            List<BAP__c> bapList =  new List<BAP__c> ();
            bapList.add(bapObj);
       
            
        test.startTest();

        AddDeleteTermBAPToSalesRevenueAction.addDeleteTermBAPToSalesRevenueAction( bapList );

        bapObj.Request_Status__c = 'Complete';
        bapObj.Complete_Status__c = 'Done';
        bapObj.Mark_as_Churn_Link_Sales_Revenue__c = true;

        update bapObj;


        AddDeleteTermBAPToSalesRevenueAction.addDeleteTermBAPToSalesRevenueAction( bapList  );

        test.stopTest();


*/
/*
        Test.startTest();
        //System.runAs(contextuser){

        AddDeleteTermBAPToSalesRevenueAction.addDeleteTermBAPToSalesRevenueAction( bapList );

            bapObj.Request_Status__c = 'Draft';
            bapObj.Mark_as_Churn_Link_Sales_Revenue__c = false;
            update bapObj;
            bapList =  new List<BAP__c> ();
            bapList.add(bapObj);

            bapObj.Request_Status__c = 'Complete';
            bapObj.Complete_Status__c = 'Done';
            bapObj.Mark_as_Churn_Link_Sales_Revenue__c = true;
    
            update bapObj;

            AddDeleteTermBAPToSalesRevenueAction.addDeleteTermBAPToSalesRevenueAction( bapList  );

        //}
        Test.stopTest();
        */

        
        
    }
}