/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 08-01-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   02-02-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class TEST_BAP_endOfContract_controller {
    @testSetup 
    static void setupRecord() {
        Profile pf= [Select Id from profile where Name='System Administrator' OR Name='Systemadministrator']; 
        Profile pf_solution= [Select Id from profile where Name='Solution']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId;

        User user_1=new User(
            firstname = 'Contract', 
            lastName = 'Manager', 
            email = uniqueName + '@test1' + orgId + '.org', 
            Username = uniqueName + '@test1' + orgId + '.org', 
            EmailEncodingKey = 'ISO-8859-1', 
            Alias = uniqueName.substring(18, 23), 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US', 
            ProfileId = pf.Id,
            isactive = TRUE
        ); 
        insert user_1;
        
        User user_2=new User(
            firstname = 'Sales', 
            lastName = 'Admin', 
            email = uniqueName + '@tes2' + orgId + '.org', 
            Username = uniqueName + '@test2' + orgId + '.org', 
            EmailEncodingKey = 'ISO-8859-1', 
            Alias = uniqueName.substring(18, 23), 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US', 
            ProfileId = pf.Id,
            isactive = TRUE,
            ManagerId = user_1.id
        ); 
        insert user_2;

        User user_3=new User(
            firstname = 'ABC3', 
            lastName = 'XYZ3', 
            email = uniqueName + '@test3' + orgId + '.org', 
            Username = uniqueName + '@test3' + orgId + '.org', 
            EmailEncodingKey = 'ISO-8859-1', 
            Alias = uniqueName.substring(18, 23), 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US', 
            ProfileId = pf_solution.Id,
            isactive = TRUE,
            ManagerId = user_2.id
        ); 
        insert user_3;

        User user_4=new User(
            firstname = 'ABC3', 
            lastName = 'XYZ3', 
            email = uniqueName + '@test4' + orgId + '.org', 
            Username = uniqueName + '@test4' + orgId + '.org', 
            EmailEncodingKey = 'ISO-8859-1', 
            Alias = uniqueName.substring(18, 23), 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US', 
            ProfileId = pf.Id,
            isactive = TRUE,
            ManagerId = user_2.id
        ); 
        insert user_4;

        List<Email_Notif_Contract_Extension_Setting__c> EmailSettingList = new list<Email_Notif_Contract_Extension_Setting__c>();

        Email_Notif_Contract_Extension_Setting__c EmailSettingList_1 = new Email_Notif_Contract_Extension_Setting__c(); //space
        EmailSettingList_1.Name = 'Email_1_100Hari_Setting';
        EmailSettingList_1.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_1.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_1);

        Email_Notif_Contract_Extension_Setting__c EmailSettingList_2 = new Email_Notif_Contract_Extension_Setting__c(); //koma
        EmailSettingList_2.Name = 'Email_1_95Hari_Setting';
        EmailSettingList_2.Additional_toAddress__c = 'test@gmail.com,test@gmail.com,test@gmail.com';
        EmailSettingList_2.Additional_toCCAddress__c =  'test@gmail.com,test@gmail.com,test@gmail.com';
        EmailSettingList.add(EmailSettingList_2);

        Email_Notif_Contract_Extension_Setting__c EmailSettingList_3 = new Email_Notif_Contract_Extension_Setting__c(); //pipe
        EmailSettingList_3.Name = 'Email_1_60Hari_Setting';
        EmailSettingList_3.Additional_toAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com|test@gmail.com';
        EmailSettingList_3.Additional_toCCAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com|test@gmail.com';
        EmailSettingList.add(EmailSettingList_3);

        Email_Notif_Contract_Extension_Setting__c EmailSettingList_4 = new Email_Notif_Contract_Extension_Setting__c(); //koma and space
        EmailSettingList_4.Name = 'Email_1_90Hari_Setting';
        EmailSettingList_4.Additional_toAddress__c = 'test@gmail.com, test@gmail.com, test@gmail.com, test@gmail.com';
        EmailSettingList_4.Additional_toCCAddress__c = 'test@gmail.com, test@gmail.com, test@gmail.com, test@gmail.com';
        EmailSettingList.add(EmailSettingList_4);

        Email_Notif_Contract_Extension_Setting__c EmailSettingList_5 = new Email_Notif_Contract_Extension_Setting__c(); //pipe and space
        EmailSettingList_5.Name = 'Email_2_14Hari_Setting';
        EmailSettingList_5.Additional_toAddress__c = 'test@gmail.com| test@gmail.com| test@gmail.com| test@gmail.com';
        EmailSettingList_5.Additional_toCCAddress__c = 'test@gmail.com| test@gmail.com| test@gmail.com| test@gmail.com';
        EmailSettingList.add(EmailSettingList_5);

        Email_Notif_Contract_Extension_Setting__c EmailSettingList_6 = new Email_Notif_Contract_Extension_Setting__c(); //pipe and koma
        EmailSettingList_6.Name = 'Email_2_30Hari_Setting';
        EmailSettingList_6.Additional_toAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com|test@gmail.com';
        EmailSettingList_6.Additional_toCCAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com|test@gmail.com';
        EmailSettingList.add(EmailSettingList_6);

        Email_Notif_Contract_Extension_Setting__c EmailSettingList_7 = new Email_Notif_Contract_Extension_Setting__c(); //pipe and koma and space
        EmailSettingList_7.Name = 'Email_3_NoticeAdmin_Setting';
        EmailSettingList_7.Additional_toAddress__c = 'test@gmail.com, test@gmail.com | test@gmail.com;test@gmail.com';
        EmailSettingList_7.Additional_toCCAddress__c = 'test@gmail.com, test@gmail.com | test@gmail.com;test@gmail.com';
        EmailSettingList.add(EmailSettingList_7);

        Email_Notif_Contract_Extension_Setting__c EmailSettingList_8 = new Email_Notif_Contract_Extension_Setting__c();
        EmailSettingList_8.Name = 'Email_Notif_BatchClass';
        EmailSettingList_8.Additional_toAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
        EmailSettingList_8.Additional_toCCAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
        EmailSettingList.add(EmailSettingList_8);

        insert EmailSettingList;

        insert new Transaction__c(transactionID__c = 1);

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        Account accTest = new Account();
        accTest.RecordTypeId = accountRecordTypeId;
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
        accTest.Ownerid = user_3.Id;
        /*accTest.Billing_Address_Province__c = 'jawa tengah';   
        accTest.Billing_Address_City__c = 'kota surakarta';
        accTest.Shipping_Address_Province__c = 'jawa tengah';
        accTest.Shipping_Address_City__c = 'kota surakarta';*/
        Insert accTest;

        Account accTest2 = new Account(
            Name = 'PT Bank MayBank Indonesia Tbk',                       
            RecordTypeId = accountRecordTypeId,                                     
            BP_Number__c = '707310',                                        
            Organization_Type__c = 'Head Office',                                
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
            Ownerid = user_4.Id /*,
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

        Contact CON =new COntact();
        Con.LastName='USer BA Print ';
        Con.Title='Bos';
        Con.Email='Tes@SF.com';
        Con.AccountID= accTest2.Id;
        insert Con;

        AccountContactRelation AC3=[SELECT id,roles FROM AccountContactRelation WHERE AccountID=:accTest2.Id AND ContactID=:Con.id];
        AC3.Roles='PIC BA Recipient';
        update AC3;

        Contract contract_1 = new Contract();
        contract_1.name ='CI TEST';
        contract_1.Accountid= accTest2.Id;
        contract_1.Account_BP_Payer__c = accTest.Id;
        contract_1.Start_Date__c = system.today(); 
        contract_1.End_Date__c = system.today().adddays(100);                   
        contract_1.Account_BP_VAT__c = accTest2.Id;
        contract_1.Contract_Term__c = 12;
        contract_1.Billing_Type__c = 'Monthly';
        contract_1.Price__c = 1213;
        contract_1.SAP_ID__c = '351';
        contract_1.Quantity__c = 1;
        contract_1.Periode_UOM__c = 'Month';
        contract_1.Bandwidth_filled__c = 512;
        contract_1.Bandwidth_UoM_filled__c = 'Kbps';
        contract_1.Account_Site_A_BP_Site__c = accTest2.Id;  
        contract_1.Product_Charge_Type_filled__c = 'Recurring';      
        contract_1.Auto_Renewal__c = false; 
        contract_1.Extension_Created__c = false;
        contract_1.Active__c = true;
        insert contract_1;

        Contract contract_2 = new Contract();
        contract_2.name ='CI TEST 2';
        contract_2.Accountid= accTest2.Id;
        contract_2.Account_BP_Payer__c = accTest.Id;
        contract_2.Start_Date__c = system.today(); 
        contract_2.End_Date__c = system.today().adddays(95);                   
        contract_2.Account_BP_VAT__c = accTest2.Id;
        contract_2.Contract_Term__c = 12;
        contract_2.Billing_Type__c = 'Monthly';
        contract_2.Price__c = 1213;
        contract_2.SAP_ID__c = '351';
        contract_2.Quantity__c = 1;
        contract_2.Periode_UOM__c = 'Month';
        contract_2.Bandwidth_filled__c = 512;
        contract_2.Bandwidth_UoM_filled__c = 'Kbps';
        contract_2.Account_Site_A_BP_Site__c = accTest2.Id;  
        contract_2.Product_Charge_Type_filled__c = 'Recurring';      
        contract_2.Auto_Renewal__c = false; 
        contract_2.Extension_Created__c = false;
        contract_2.Active__c = true;     
        insert contract_2;

        Link__c linkTest = new Link__c(
            Name = '02-02021',                                  
            BU__c = 'ENTERPRISE',
            CID__c = '02-02021',                          
            ID__c = '3281',                       
            Status_Link__c = 'IN_SERVICE',
            Company_Name__c = 'Bank Maybank Indonesia Tbk',
            Service_Type__c = 'VOIP',
            Contract_Item__c = '3001207-351',
            BP_Site_A__c = '707310', 
            Capacity_Bandwidth__c = '512',
            UoM__c = 'Kbps',
            Routepath__c = '707310 BII KCP Pondok Candra Surabaya - POP BWA Rungkut (STARCOM) POP BWA Rungkut (STARCOM) - EC-SBRKO-01 EC-SBRKO-01',
            CID_RelD__c = Circuit_Test.Id,
            Link_ID__c = '007C362L84',
            Site_A_Name__c = accTest2.Id,
            Contract_Item_Rel__c = contract_1.Id,
            Free_Link__c = true,
            Selected__c = false,
            Partner__c = false                                                                    
        );
        insert linkTest;

        contract_1.Link__c = linkTest.Id;
        update contract_1;

        Link__c linkTest2 = new Link__c(
            Name = '02-02021',                                  
            BU__c = 'ENTERPRISE',
            CID__c = '02-02021',                          
            ID__c = '3281',                       
            Status_Link__c = 'IN_SERVICE',
            Company_Name__c = 'Bank Maybank Indonesia Tbk',
            Service_Type__c = 'VOIP',
            Contract_Item__c = '3001207-351',
            BP_Site_A__c = '707310', 
            Capacity_Bandwidth__c = '512',
            UoM__c = 'Kbps',
            Routepath__c = '707310 BII KCP Pondok Candra Surabaya - POP BWA Rungkut (STARCOM) POP BWA Rungkut (STARCOM) - EC-SBRKO-01 EC-SBRKO-01',
            CID_RelD__c = Circuit_Test.Id,
            Link_ID__c = '007C362L84',
            Site_A_Name__c = accTest2.Id,
            Contract_Item_Rel__c = contract_2.Id,
            Free_Link__c = true,
            Selected__c = false,
            Partner__c = false                                                                    
        );
        insert linkTest2;

        List<Contract_Extension__c> Contract_Extension_List = new list<Contract_Extension__c>();

        Contract_Extension__c Contract_Extension_1 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_1',
            Existing_Contract_item__c = contract_1.Id,     
            Extension_Start_Date__c = system.today(),    
            Link__c = linkTest.id,                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = accTest2.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_1);

        Contract_Extension__c Contract_Extension_2 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_2',
            Existing_Contract_item__c = contract_2.Id,     
            Extension_Start_Date__c = system.today(),    
            Link__c = linkTest2.Id,                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = accTest2.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_2);

        insert Contract_Extension_List;
    }

    @isTest
    static void Method_1(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, Going_To_Days__c, name, BA_Print__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.Link__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Existing_Contract_item__r.Sales__c, Existing_Contract_item__r.Sales_Email__c, Existing_Contract_item__r.Start_Date__c, Link__c, Link__r.Name, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c FROM Contract_Extension__c];

        List<user> userList = [SELECT id,email FROM User];

        List<Link__c> linkList = [SELECT Id, Contract_Item_Rel__c FROM Link__c];
        
        system.debug('linkList : ' + linkList);

        Set<Id> setContractIds = new set<Id>();

        for(Link__c linkList_Extract : linkList){
            setContractIds.add(linkList_Extract.Contract_Item_Rel__c);
        }

        List<Contract> contractList = [SELECT Id, Name, Link__c, extension_created__c, Link__r.Link_id__c, Accountid, Price__c, Start_Date__c, End_Date__C, Account.Name, Account.Segmentation__c, Contract_ID__c, SAP_ID__c, Product__c, Product__r.SAP_Code__c, Sales__c, Account.Owner.Email, Account.Ownerid, Status, Active__c, Contract_Term__c, Periode_UOM__c FROM Contract WHERE Id IN:setContractIds];

        Test.startTest();
        Set<id> contractIds = new Set<id>();
        List<BAP__c> newBAP_List = new List<BAP__c>();
        Id recordTypeId_bapEndofContract = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('End of Contract').getRecordTypeId();

        for(Contract_Extension__c ContractExtension_List_Extract : Contract_Extension_Lists){
            BAP__c bapEndofContract = new BAP__c(
            RecordTypeId = recordTypeId_bapEndofContract,                                  
            Name = '[BAP-EOC] ' + ContractExtension_List_Extract.Link__r.Name + ' - ' + ContractExtension_List_Extract.Link__r.Link_ID__c,
            Type_of_Request__c = 'Pemutusan',         
            Customer__c = ContractExtension_List_Extract.Account__c,                      
            Request_Status__c = 'Draft',
            Link__c = ContractExtension_List_Extract.Existing_Contract_item__r.Link__c, 
            PIC_Name__c = ContractExtension_List_Extract.Existing_Contract_item__r.Sales__c,
            PIC_Phone__c = Label.BAP_EndOfContract_PIC_Phone,                             
            PIC_email__c = ContractExtension_List_Extract.Existing_Contract_item__r.Sales_Email__c,
            PIC_Position__c = 'Accouunt Manager',                 
            Reason__c = 'Kontrak berakhir atau tidak diperpanjang',
            Note__c = 'This termination proces are related to BA extension No : ' + ContractExtension_List_Extract.Name,   
            BA_Extend_REL__c = ContractExtension_List_Extract.Id,
            Terminate_Date__c = ContractExtension_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(1),
            Contract_Start_Date__c = ContractExtension_List_Extract.Existing_Contract_item__r.Start_Date__c,
            Contract_End_Date__c = ContractExtension_List_Extract.Existing_Contract_item__r.End_Date__c
            //Sirkit__c = 'Sirkit',
        );
            newBAP_List.add(bapEndofContract);
            contractIds.add(ContractExtension_List_Extract.Existing_Contract_item__c);
        }
        Insert newBAP_List;

        if(contractIds!=null && !contractIds.isEmpty()){
            BAP_endOfContract_controller BAP_endOfContract_controller_class = new BAP_endOfContract_controller();
            BAP_endOfContract_controller_class.Create_BAP_endOfContract(contractIds);
        }
        Test.stopTest();
    }

}