/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 03-17-2023
 * @last modified by  : Diky Nurosid
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   26-12-2022   Doddy Prima   Initial Version
**/
@istest(seealldata=false)
private class Sample1Test {
    /*
    @IsTest
    static void createContract(){
        
        //-- set static value 
        //todo : change to record creation statement
        ID accountID = '0017F00002fUm3oQAC';
        ID productID = '01t7F00000354WUQAY';
        ID contractHeaderID = 'a0R1m0000014NgrEAE';


        //-- create contract
        Contract sobj = new Contract(
            Name = 'Contract: MPLS - 512 Kbps',               // Contract Name
            AccountId = accountID,
            Last_Transaction_ID__c = 'CI0547729',               // Last Transaction ID
            Full_Name__c = 'Contract: MPLS - 512 Kbps',         // Full Name
            Account_BP_Payer__c = accountID, // '0017F00000RM06D',            // Account BP Payer
            Start_Date__c = Date.valueOf('2022-11-18'), //Date.valueOf('18-11-2022'),         // Start Date
            End_Date__c = Date.valueOf('2023-08-31'),  //Date.valueOf('31-08-2023'),           // End Date
            Account_BP_VAT__c = accountID, // '0017F00000RN0yZ',              // Account BP VAT
            Contract_Term__c = 12,                            // Contract Term
            ContractTerm = 12,                                // Contract Term (months)
            Billing_Type__c = 'Monthly',                        // Billing Type
            Product__c = productID,     //'01t7F00000354WJ',                     // Product
            Contract_Header__c = contractHeaderID,  //'a0R7F00000Huw7Z',             // Contract Header
            Price__c = 4950000,                             // Price
            Contract_ID__c = '3001281',                         // Contract ID
            Quantity__c = 1,                                  // Quantity
            SAP_ID__c = '133',                                  // Contract Item
            Periode_UOM__c = 'Month',                           // Periode UOM
            Extension_Created__c = false,                       // Extension Created
            Bandwidth_filled__c = 512,                        // Bandwidth
            Bandwidth_Before_Filled__c = 128,                 // Bandwidth Before
            Bandwidth_UoM_filled__c = 'Kbps',                   // Bandwidth UoM
            Bandwidth_Before_UoM_filled__c = 'Kbps',            // Bandwidth Before UoM
            Product_SAP_Code__c = 'MPLS-02',                    // Product SAP Code
            Product_Charge_Type_filled__c = 'Recurring',        // Product Charge Type
            //Previous_Contract__c = '8007F000000QXU0',           // Previous Contract
            Previous_Contract_Header_ID_filled__c = '3001431',  // Previous Contract Header ID
            Previous_Contract_Item_No_filled__c = '581',        // Previous Contract Item No
            Status = 'Draft',                       // Status
            Auto_Renewal__c = true,                             // Auto Renewal
            Active__c = true,                                   // Active
            Account_Site_A_BP_Site__c = accountID,  //'0017F00000RN0zV',      // Account Site A (BP Site)
            //Opportunity__c = '0067F000017wkAO',                 // Opportunity
            Project_Type__c = 'UPGR'                           // Project Type
            );

            insert sobj;
    }
	*/
    
    
    @IsTest
    static void createLinks() {
        
        //-- set static value 
        //todo : change to record creation statement
        ID accountID = '0017F00002fUm3oQAC';
        ID contracItemID = '8001m0000005mcXAAQ';
        
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        insert new Transaction__c(transactionID__c = 1);
        
        
        //-- create Account
        Account accRec = new Account(
            Kwitansi__c = false,                               // Kwitansi
            Faktur_Pajak__c = false,                             // Faktur Pajak
            Summary_Billing__c = false,                          // Summary Billing
            summary_invoice__c = false,                          // summary invoice
            Name = 'PT Internetwork Komunikasi Indonesia',       // Account Name
            RecordTypeId = recordTypeId_accBP,                          // Account Record Type
            BP_Number__c = '762239',                             // BP Number
            Organization_Type__c = 'Head Office',                     // Organization Type
            ////ParentId = 'undefined',                              // Parent Account
            Type = 'Customer',                                   // Type
            Unique_Name__c = 'Internetwork Meranti',             // Unique Name
            Keyword__c = 'INTERNETWORK',                         // Keyword
            Customer_Type__c = 'NONGSM',                         // Customer Type
            Industry = 'Telecommunications',                     // Industry
            Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
            OU__c = '0',                                         // OU
            Is_New_Customer__c = false,                          // Is New Customer
            Approval_Status__c = 'Approved',                     // Approval Status
            Using_HO_Billing_Address__c = false                 // Using HO Billing Address
        );
        insert accRec;
        accountID = accRec.id;
        
        //-- create contract
        Contract contractRec = new Contract(
            Name = 'Contract: MPLS - 512 Kbps',               // Contract Name
            AccountId = accountID,
            Last_Transaction_ID__c = 'CI0547729',               // Last Transaction ID
            Full_Name__c = 'Contract: MPLS - 512 Kbps',         // Full Name
            Account_BP_Payer__c = accountID, // '0017F00000RM06D',            // Account BP Payer
            Start_Date__c = Date.valueOf('2022-11-18'), //Date.valueOf('18-11-2022'),         // Start Date
            End_Date__c = Date.valueOf('2023-08-31'),  //Date.valueOf('31-08-2023'),           // End Date
            Account_BP_VAT__c = accountID, // '0017F00000RN0yZ',              // Account BP VAT
            Contract_Term__c = 12,                            // Contract Term
            ContractTerm = 12,                                // Contract Term (months)
            Billing_Type__c = 'Monthly',                        // Billing Type
            ///Product__c = productID,     //'01t7F00000354WJ',                     // Product
            //Contract_Header__c = contractHeaderID,  //'a0R7F00000Huw7Z',             // Contract Header
            Price__c = 4950000,                             // Price
            Contract_ID__c = '3001281',                         // Contract ID
            Quantity__c = 1,                                  // Quantity
            SAP_ID__c = '133',                                  // Contract Item
            Periode_UOM__c = 'Month',                           // Periode UOM
            Extension_Created__c = false,                       // Extension Created
            Bandwidth_filled__c = 512,                        // Bandwidth
            Bandwidth_Before_Filled__c = 128,                 // Bandwidth Before
            Bandwidth_UoM_filled__c = 'Kbps',                   // Bandwidth UoM
            Bandwidth_Before_UoM_filled__c = 'Kbps',            // Bandwidth Before UoM
            Product_SAP_Code__c = 'MPLS-02',                    // Product SAP Code
            Product_Charge_Type_filled__c = 'Recurring',        // Product Charge Type
            //Previous_Contract__c = '8007F000000QXU0',           // Previous Contract
            Previous_Contract_Header_ID_filled__c = '3001431',  // Previous Contract Header ID
            Previous_Contract_Item_No_filled__c = '581',        // Previous Contract Item No
            Status = 'Draft',                       // Status
            Auto_Renewal__c = true,                             // Auto Renewal
            Active__c = true,                                   // Active
            Account_Site_A_BP_Site__c = accountID,  //'0017F00000RN0zV',      // Account Site A (BP Site)
            //Opportunity__c = '0067F000017wkAO',                 // Opportunity
            Project_Type__c = 'UPGR'                           // Project Type
        );

        insert contractRec;
    	contracItemID = contractRec.id;
    
        
        List<Link__c> linkList = new List<Link__c>();
        for(integer ind = 1; ind<=50; ind++){
            
            Link__c sobj = new Link__c(
                Company_Name__c = 'PT Bank Sinarmas',  // Company Name
                Capacity_Bandwidth__c = '512',           // Capacity Bandwidth
                Name = 'LINKTEST-' + ind, 	//'02-05747',                       // Circuit ID (CID)
                UoM__c = 'Kbps',                         // UoM
                Link_ID__c = '007C383L202',              // Service ID
                Partner__c = false,                      // Partner
                Status_Link__c = 'IN_SERVICE',           // Status Service ID
                Service_Type__c = 'MPLS',                // Service Type
                Routepath__c = '719450 Bank Sinarmas KK Plaju Palembang Palembang SUM-SS-ENT-719450 - DA73 DA73_SimpangAssegaf SUM-SS-PLG-0590 - EH33 XL OFFICE PALEMBANG SUM-SS-PLG-0477',  // Routepath
                Site_A_Name__c = accountID,            // Site A Name
                BP_Site_A__c = '719450',                 // BP Site A
                Contract_Item__c = '3001281-133',        // Contract Item
                Contract_Item_Rel__c = contracItemID,      // Contract Item Rel
               // isBursable__c='TRUE',                      // Brustable Flag
                Free_Link__c = false,                    // Free Link
                ID__c = '11259',                         // ID
                CID__c = '02-05747',                     // CID *
                BU__c = 'ENTERPRISE',                    // BU
                //CID_RelD__c = 'undefined',               // CID RelD
                Is_Trial__c = false,                     // Is Trial
                Trial_Service_Type__c = 'Upgrade'       // Trial Service Type
            );
            linkList.add(sobj);
        }
        system.debug('=== Jumlah List Link yang di Insert : ' + linkList.size());
        insert linkList;
        
        
    }
   /* 
    @isTest
    static void runBatch(){
		createLinks();
        Test.startTest(); 
        
        //Batch_CreateBrustableContract batchObj = new Batch_CreateBrustableContract();
        //Database.executeBatch(batchObj, 200);
        
        List<String> linkIDList = new List<String>();
        List<Link__c> linkList = [SELECT ID FROM Link__c WHERE name like 'LINKTEST%'];
        
        system.debug ('=== linkList.size() : ' + linkList.size() );
        for (Link__c linkRec : linkList) {
            linkIDList.add(linkRec.id);
        }
        
        Batch_CreateBrustableContract batchObj = new Batch_CreateBrustableContract(linkIDList);
        Database.executeBatch(batchObj, 10);
        
        
        Test.stopTest();
    
    }
        */ 

    
    
    
    
}