/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   02-02-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class TEST_Notif_TerminationNonAutoRenewal {

    @testSetup 
    static void setupRecord() {
        Profile pf= [Select Id from profile where Name='System Administrator' OR Name='Systemadministrator']; 
        Profile pf_solution= [Select Id from profile where Name='Solution']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId;

        
        User user_1=new User(
            firstname = 'ABC1', 
            lastName = 'XYZ1', 
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
            firstname = 'ABC2', 
            lastName = 'XYZ2', 
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

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailSettingList = new list<Email_TerminationNonAutoRenewal_Setting__c>();

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_1 = new Email_TerminationNonAutoRenewal_Setting__c(); //space
        EmailSettingList_1.Name = 'Email_1_14Hari_Setting';
        EmailSettingList_1.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_1.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_1.Additional_toBCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_1);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_2 = new Email_TerminationNonAutoRenewal_Setting__c(); //koma
        EmailSettingList_2.Name = 'Email_1_30Hari_Setting';
        EmailSettingList_2.Additional_toAddress__c = 'test@gmail.com,test@gmail.com,test@gmail.com';
        EmailSettingList_2.Additional_toCCAddress__c =  'test@gmail.com,test@gmail.com,test@gmail.com';
        EmailSettingList_2.Additional_toBCCAddress__c =  'test@gmail.com,test@gmail.com,test@gmail.com';
        EmailSettingList.add(EmailSettingList_2);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_3 = new Email_TerminationNonAutoRenewal_Setting__c(); //pipe
        EmailSettingList_3.Name = 'Email_1_60Hari_Setting';
        EmailSettingList_3.Additional_toAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com|test@gmail.com';
        EmailSettingList_3.Additional_toCCAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com|test@gmail.com';
        EmailSettingList_3.Additional_toBCCAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com|test@gmail.com';
        EmailSettingList.add(EmailSettingList_3);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_4 = new Email_TerminationNonAutoRenewal_Setting__c(); //koma and space
        EmailSettingList_4.Name = 'Email_1_90Hari_Setting';
        EmailSettingList_4.Additional_toAddress__c = 'test@gmail.com, test@gmail.com, test@gmail.com, test@gmail.com';
        EmailSettingList_4.Additional_toCCAddress__c = 'test@gmail.com, test@gmail.com, test@gmail.com, test@gmail.com';
        EmailSettingList_4.Additional_toBCCAddress__c = 'test@gmail.com, test@gmail.com, test@gmail.com, test@gmail.com';
        EmailSettingList.add(EmailSettingList_4);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_5 = new Email_TerminationNonAutoRenewal_Setting__c(); //pipe and space
        EmailSettingList_5.Name = 'Email_2_14Hari_Setting';
        EmailSettingList_5.Additional_toAddress__c = 'test@gmail.com| test@gmail.com| test@gmail.com| test@gmail.com';
        EmailSettingList_5.Additional_toCCAddress__c = 'test@gmail.com| test@gmail.com| test@gmail.com| test@gmail.com';
        EmailSettingList_5.Additional_toBCCAddress__c = 'test@gmail.com| test@gmail.com| test@gmail.com| test@gmail.com';
        EmailSettingList.add(EmailSettingList_5);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_6 = new Email_TerminationNonAutoRenewal_Setting__c(); //pipe and koma
        EmailSettingList_6.Name = 'Email_2_30Hari_Setting';
        EmailSettingList_6.Additional_toAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com|test@gmail.com';
        EmailSettingList_6.Additional_toCCAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com|test@gmail.com';
        EmailSettingList_6.Additional_toBCCAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com|test@gmail.com';
        EmailSettingList.add(EmailSettingList_6);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_7 = new Email_TerminationNonAutoRenewal_Setting__c(); //pipe and koma and space
        EmailSettingList_7.Name = 'Email_3_NoticeAdmin_Setting';
        EmailSettingList_7.Additional_toAddress__c = 'test@gmail.com, test@gmail.com | test@gmail.com;test@gmail.com';
        EmailSettingList_7.Additional_toCCAddress__c = 'test@gmail.com, test@gmail.com | test@gmail.com;test@gmail.com';
        EmailSettingList_7.Additional_toBCCAddress__c = 'test@gmail.com, test@gmail.com | test@gmail.com;test@gmail.com';
        EmailSettingList.add(EmailSettingList_7);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_8 = new Email_TerminationNonAutoRenewal_Setting__c();
        EmailSettingList_8.Name = 'Email_Notif_BatchClass';
        EmailSettingList_8.Additional_toAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
        EmailSettingList_8.Additional_toCCAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
        EmailSettingList_8.Additional_toBCCAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
        EmailSettingList.add(EmailSettingList_8);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_9 = new Email_TerminationNonAutoRenewal_Setting__c(); //space
        EmailSettingList_9.Name = 'Email_1_1Hari_Setting';
        EmailSettingList_9.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_9.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_9.Additional_toBCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_9);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_10 = new Email_TerminationNonAutoRenewal_Setting__c(); //space
        EmailSettingList_10.Name = 'Email_2_1Hari_Setting';
        EmailSettingList_10.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_10.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_10.Additional_toBCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_10);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_11 = new Email_TerminationNonAutoRenewal_Setting__c(); //space
        EmailSettingList_11.Name = 'Email_1_1_14Hari_Setting';
        EmailSettingList_11.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_11.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_11.Additional_toBCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_11);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_12 = new Email_TerminationNonAutoRenewal_Setting__c(); //space
        EmailSettingList_12.Name = 'Email_1_1_30Hari_Setting';
        EmailSettingList_12.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_12.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_12.Additional_toBCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_12);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_13 = new Email_TerminationNonAutoRenewal_Setting__c(); //space
        EmailSettingList_13.Name = 'Email_1_1_60Hari_Setting';
        EmailSettingList_13.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_13.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_13.Additional_toBCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_13);

        Email_TerminationNonAutoRenewal_Setting__c EmailSettingList_14 = new Email_TerminationNonAutoRenewal_Setting__c(); //space
        EmailSettingList_14.Name = 'Email_1_1_90Hari_Setting';
        EmailSettingList_14.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_14.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList_14.Additional_toBCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        EmailSettingList.add(EmailSettingList_14);

        insert EmailSettingList;

        insert new Transaction__c(transactionID__c = 1);

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accountRecordTypeId;
        acc.Name = 'TEST';
        acc.Unique_Name__c = 'TEST';
        acc.NumberOfEmployees = 2;
        acc.Company_Group__c = 'Perusahaan Asing';
        acc.Customer_VAT_Name__c = 'sdfskdjfsjdf';
        acc.Customer_Type__c = 'NONGSM';
        acc.No_NPWP__c = 'ojsnonjsdf';
        acc.BillingStreet = 'hive';
        acc.BillingState = 'hive';
        acc.BillingCity = 'hive';
        acc.BillingCountry = 'hive';
        acc.BillingPostalCode = 'hive';
        acc.ShippingStreet = 'hive';
        acc.ShippingState = 'hive';
        acc.ShippingCity = 'hive';
        acc.ShippingCountry = 'hive';
        acc.ShippingPostalCode = 'hive';
        acc.Billing_Building_Name__c = 'hive';
        acc.Shipping_Building_Name__c = 'hive';
        acc.Field_Source__c = 'Bizstore Customer Registration';
        acc.Organization_Type__c = 'Head Office';
        acc.Type = 'Customer';
        acc.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        acc.OU__c = '1';
        acc.Industry = 'Agriculture';
        acc.BP_Number__c = '1xx12';
        acc.Bizstore_Complete__c = false;
        Insert acc;

        Contact CON =new COntact();
        Con.LastName='USer BA Print ';
        Con.Title='Bos';
        Con.Email='Tes@SF.com';
        Con.AccountID= acc.Id;
        insert Con;

        AccountContactRelation AC3=[SELECT id,roles FROM AccountContactRelation WHERE AccountID=:acc.Id AND ContactID=:Con.id];
        AC3.Roles='PIC BA Recipient';
        update AC3;

        List<Contract> ContractList = new  List<Contract>();

        Contract contract_1 = new Contract();
        contract_1.name ='CI TEST';
        //contract_1.Contract_Ticket__c = tmpContract.id;
        contract_1.Accountid= acc.Id;
        //contract_1.Opportunity__c=O.id;
        contract_1.Billing_Type__c=''; 
        contract_1.End_Date__c = system.today().adddays(14);                   
        contract_1.start_Date__c = system.today().adddays(14); 
        contract_1.Bill_Plan_End_Date__c=system.today().addyears(1);                 
        ContractList.add(contract_1);

        Contract contract_2 = new Contract();
        contract_2.name ='CI TEST';
        //contract_2.Contract_Ticket__c = tmpContract.id;
        contract_2.Accountid= acc.Id;
        //contract_2.Opportunity__c=O.id;
        contract_2.Billing_Type__c=''; 
        contract_2.End_Date__c = system.today().adddays(30);                   
        contract_2.start_Date__c = system.today().adddays(30); 
        contract_2.Bill_Plan_End_Date__c=system.today().addyears(1);                 
        ContractList.add(contract_2);

        Contract contract_3 = new Contract();
        contract_3.name ='CI TEST';
        //contract_3.Contract_Ticket__c = tmpContract.id;
        contract_3.Accountid= acc.Id;
        //contract_3.Opportunity__c=O.id;
        contract_3.Billing_Type__c=''; 
        contract_3.End_Date__c = system.today().adddays(60);                   
        contract_3.start_Date__c = system.today().adddays(60); 
        contract_3.Bill_Plan_End_Date__c=system.today().addyears(1);                 
        ContractList.add(contract_3);

        Contract contract_4 = new Contract();
        contract_4.name ='CI TEST';
        //contract_4.Contract_Ticket__c = tmpContract.id;
        contract_4.Accountid= acc.Id;
        //contract_4.Opportunity__c=O.id;
        contract_4.Billing_Type__c=''; 
        contract_4.End_Date__c = system.today().adddays(90);                   
        contract_4.start_Date__c = system.today().adddays(90); 
        contract_4.Bill_Plan_End_Date__c=system.today().addyears(1);                 
        ContractList.add(contract_4);

        Contract contract_5 = new Contract();
        contract_5.name ='CI TEST';
        //contract_5.Contract_Ticket__c = tmpContract.id;
        contract_5.Accountid= acc.Id;
        //contract_5.Opportunity__c=O.id;
        contract_5.Billing_Type__c=''; 
        contract_5.End_Date__c = system.today().adddays(1);                   
        contract_5.start_Date__c = system.today().adddays(1); 
        contract_5.Bill_Plan_End_Date__c=system.today().addyears(1);                 
        ContractList.add(contract_5);

        insert ContractList;

        List<Contract_Extension__c> Contract_Extension_List = new list<Contract_Extension__c>();

        Contract_Extension__c Contract_Extension_1 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_1',
            Existing_Contract_item__c = contract_1.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
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
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_2);

        Contract_Extension__c Contract_Extension_3 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_3',
            Existing_Contract_item__c = contract_3.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_3);

        Contract_Extension__c Contract_Extension_4 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_4',
            Existing_Contract_item__c = contract_4.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_4);

        Contract_Extension__c Contract_Extension_5 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_5',
            Existing_Contract_item__c = contract_1.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            //BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_5);

        Contract_Extension__c Contract_Extension_6 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_6',
            Existing_Contract_item__c = contract_2.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            //BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_6);

        Contract_Extension__c Contract_Extension_7 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_7',
            Existing_Contract_item__c = contract_3.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            //BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_7);

        Contract_Extension__c Contract_Extension_8 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_8',
            Existing_Contract_item__c = contract_4.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            //BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_8);

        Contract_Extension__c Contract_Extension_9 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_4',
            Existing_Contract_item__c = contract_5.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_9);

        Contract_Extension__c Contract_Extension_10 = new Contract_Extension__c(
            Name = 'TEST Contract_Extension_5',
            Existing_Contract_item__c = contract_5.Id,     
            Extension_Start_Date__c = system.today(),    
            //Link__c = 'undefined',                       
            Extension_End_Date__c = system.today(),      
            Account_Manager__c = user_3.Id,            
            Link_Partner__c = false,                     
            Account__c = acc.Id,                    
            Status__c = 'Waiting for BA',
            Solution_PIC__c = user_3.Id,                 
            //BA_Print__c = Con.Id,                   
            Approved_By_Solution__c = false              
        );
        Contract_Extension_List.add(Contract_Extension_10);

        insert Contract_Extension_List;
    }

    @isTest
    static void EmailMethod_1(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, Going_To_Days__c, name, BA_Print__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Link__c, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c, BAP__c, BAP__r.BAP_No__c FROM Contract_Extension__c];

        List<Id> contract_ExtensionIds = new list<Id>();
        contract_ExtensionIds.add(Contract_Extension_Lists[0].id);

        Test.startTest();
        PageReference pageref=page.contractextensionba;
        pageref.getparameters().put('contractextensionid',Contract_Extension_Lists[0].id);
        Apexpages.StandardController sc = new Apexpages.StandardController(Contract_Extension_Lists[0]);
        ContractExtensionUtils CEU=new ContractExtensionUtils(sc);

        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail);

        Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(Contract_Extension_Lists,false);

        Schedule_Notif_TerminationNonAutoRenewal myClass = new Schedule_Notif_TerminationNonAutoRenewal();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Schedule_Notif_TerminationNonAutoRenewal', chron, myClass);

        Button_Emaill_SendBACustomer_Ctrl.SendEmailAction(contract_ExtensionIds);
        Button_Emaill_SendBACustomer_Ctrl.SendEmailActionTrigger(Contract_Extension_Lists[0].id);
        Test.stopTest();
    }

    @isTest
    static void EmailMethod_2(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, name, Going_To_Days__c, BA_Print__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Link__c, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c, BAP__c, BAP__r.BAP_No__c FROM Contract_Extension__c];

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c];

        for(Email_TerminationNonAutoRenewal_Setting__c EmailTerminationNonAutoRenewal_Setting_List_Extract : EmailTerminationNonAutoRenewal_Setting_List){
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c = 'test@gmail.com; test@gmail.com ; test@gmail.com; test@gmail.com';
        }
        update EmailTerminationNonAutoRenewal_Setting_List;

        Test.startTest();
        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail);

        Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(Contract_Extension_Lists,false);

        Schedule_Notif_TerminationNonAutoRenewal myClass = new Schedule_Notif_TerminationNonAutoRenewal();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Schedule_Notif_TerminationNonAutoRenewal', chron, myClass);
        Test.stopTest();
    }

    @isTest
    static void EmailMethod_3(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, name, Going_To_Days__c, BA_Print__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Link__c, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c, BAP__c, BAP__r.BAP_No__c FROM Contract_Extension__c];

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c];

        for(Email_TerminationNonAutoRenewal_Setting__c EmailTerminationNonAutoRenewal_Setting_List_Extract : EmailTerminationNonAutoRenewal_Setting_List){
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c = 'test@gmail.com,test@gmail.com,test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c = 'test@gmail.com,test@gmail.com,test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c = 'test@gmail.com,test@gmail.com,test@gmail.com';
        }
        update EmailTerminationNonAutoRenewal_Setting_List;

        Test.startTest();
        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail);

        Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(Contract_Extension_Lists,false);

        Schedule_Notif_TerminationNonAutoRenewal myClass = new Schedule_Notif_TerminationNonAutoRenewal();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Schedule_Notif_TerminationNonAutoRenewal', chron, myClass);
        Test.stopTest();
    }

    @isTest
    static void EmailMethod_4(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, name, Going_To_Days__c, BA_Print__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Link__c, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c, BAP__c, BAP__r.BAP_No__c FROM Contract_Extension__c];

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c];

        for(Email_TerminationNonAutoRenewal_Setting__c EmailTerminationNonAutoRenewal_Setting_List_Extract : EmailTerminationNonAutoRenewal_Setting_List){
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com|test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com|test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c = 'test@gmail.com|test@gmail.com|test@gmail.com|test@gmail.com';
        }
        update EmailTerminationNonAutoRenewal_Setting_List;

        Test.startTest();
        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail);

        Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(Contract_Extension_Lists,false);

        Schedule_Notif_TerminationNonAutoRenewal myClass = new Schedule_Notif_TerminationNonAutoRenewal();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Schedule_Notif_TerminationNonAutoRenewal', chron, myClass);
        Test.stopTest();
    }

    @isTest
    static void EmailMethod_5(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, name, Going_To_Days__c, BA_Print__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Link__c, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c, BAP__c, BAP__r.BAP_No__c FROM Contract_Extension__c];

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c];

        for(Email_TerminationNonAutoRenewal_Setting__c EmailTerminationNonAutoRenewal_Setting_List_Extract : EmailTerminationNonAutoRenewal_Setting_List){
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c = 'test@gmail.com, test@gmail.com ';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c = 'test@gmail.com, test@gmail.com ';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c = 'test@gmail.com, test@gmail.com ';
        }
        update EmailTerminationNonAutoRenewal_Setting_List;

        Test.startTest();
        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail);

        Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(Contract_Extension_Lists,false);

        Schedule_Notif_TerminationNonAutoRenewal myClass = new Schedule_Notif_TerminationNonAutoRenewal();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Schedule_Notif_TerminationNonAutoRenewal', chron, myClass);
        Test.stopTest();
    }

    @isTest
    static void EmailMethod_6(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, name, BA_Print__c, Going_To_Days__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Link__c, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c, BAP__c, BAP__r.BAP_No__c FROM Contract_Extension__c];

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c];

        for(Email_TerminationNonAutoRenewal_Setting__c EmailTerminationNonAutoRenewal_Setting_List_Extract : EmailTerminationNonAutoRenewal_Setting_List){
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com|test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com|test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c = 'test@gmail.com|test@gmail.com,test@gmail.com|test@gmail.com';
        }
        update EmailTerminationNonAutoRenewal_Setting_List;

        Test.startTest();
        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail);

        Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(Contract_Extension_Lists,false);

        Schedule_Notif_TerminationNonAutoRenewal myClass = new Schedule_Notif_TerminationNonAutoRenewal();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Schedule_Notif_TerminationNonAutoRenewal', chron, myClass);
        Test.stopTest();
    }

    @isTest
    static void EmailMethod_7(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, name, BA_Print__c, Going_To_Days__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Link__c, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c, BAP__c, BAP__r.BAP_No__c FROM Contract_Extension__c];

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c];

        for(Email_TerminationNonAutoRenewal_Setting__c EmailTerminationNonAutoRenewal_Setting_List_Extract : EmailTerminationNonAutoRenewal_Setting_List){
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c = 'test@gmail.com, test@gmail.com | test@gmail.com;test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c = 'test@gmail.com, test@gmail.com | test@gmail.com;test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c = 'test@gmail.com, test@gmail.com | test@gmail.com;test@gmail.com';
        }
        update EmailTerminationNonAutoRenewal_Setting_List;

        Test.startTest();
        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail);

        Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(Contract_Extension_Lists,false);

        Schedule_Notif_TerminationNonAutoRenewal myClass = new Schedule_Notif_TerminationNonAutoRenewal();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Schedule_Notif_TerminationNonAutoRenewal', chron, myClass);
        Test.stopTest();
    }

    @isTest
    static void EmailMethod_8(){
        List<Contract_Extension__c> Contract_Extension_Lists = [Select id, name, BA_Print__c, Going_To_Days__c, BA_Print__r.Name, BA_Print__r.Email, Account__c, Account__r.Name, Existing_Contract_item__c, Existing_Contract_item__r.End_Date__c, Existing_Contract_item__r.Product__r.Name, Link__c, Link__r.Link_ID__c, Link__r.Site_A_Name__r.Name, Link__r.Site_A_Name__r.Unique_Name__c, Account_Manager__c, Account_Manager__r.Name, Account_Manager__r.Email, Account_Manager__r.ManagerId, Account_Manager__r.Manager_of_Manager__c, BAP__c, BAP__r.BAP_No__c FROM Contract_Extension__c];

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c];

        for(Email_TerminationNonAutoRenewal_Setting__c EmailTerminationNonAutoRenewal_Setting_List_Extract : EmailTerminationNonAutoRenewal_Setting_List){
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
            EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c = 'test@gmail.com;test@gmail.com;test@gmail.com;test@gmail.com';
        }
        update EmailTerminationNonAutoRenewal_Setting_List;

        Test.startTest();
        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail);

        Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(Contract_Extension_Lists,false);

        Schedule_Notif_TerminationNonAutoRenewal myClass = new Schedule_Notif_TerminationNonAutoRenewal();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Schedule_Notif_TerminationNonAutoRenewal', chron, myClass);
        Test.stopTest();
    }

}