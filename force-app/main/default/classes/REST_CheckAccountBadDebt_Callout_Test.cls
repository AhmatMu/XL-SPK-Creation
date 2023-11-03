/*-----------------------------------------------------------------------------------------------------------//
* Class Name	: REST_CheckAccountBadDebt_Callout_Test
* Author		: ahmat zulkifli murad <ahmat.murad@saasten.com>
* Date			: 10 / 09 / 2022
* Description	: Description of the class
*
* Changes (version)
* -------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	-----------------------------------
* @version		1.0		2022-09-10		ahmat zulkifli murad	Created
* 
*-----------------------------------------------------------------------------------------------------------*/
@istest(SeeAllData=false)
public class REST_CheckAccountBadDebt_Callout_Test {

    @TestSetup
    static void makeData(){

        //create custom setting
        REST_EasyOps_API_Settings__c accountBadDebtSettings = new REST_EasyOps_API_Settings__c();

        accountBadDebtSettings.accountBadDebt_Endpoint_GetToken__c = 'https://easy-ops.xl.co.id/dev/api/auth/token';
        accountBadDebtSettings.accountBadDebt_EndPoint_Request_BadDebt__c = 'https://easy-ops.xl.co.id/dev/api/report_invoice_collection_nongsm/invoice_bad_debt';
        accountBadDebtSettings.accountBadDebt_Method__c = 'POST';
        accountBadDebtSettings.accountBadDebt_Password__c = 'vE+/7B5Rbe5kAlHFl1I/sKw8NLCkxqxGo7lLyCGlptM=';
        accountBadDebtSettings.accountBadDebt_UserName__c = 'apidemo';

        insert accountBadDebtSettings;

        Transaction__c settings = new Transaction__c();
        settings.transactionID__c = 68756;
        settings.Temporary_LA_or_IDCom__c = 2499;

        insert settings;

        trigger_controller__c triggerControllerSetting = new trigger_controller__c ();
        triggerControllerSetting.Is_Active__c = true;
        triggerControllerSetting.name = 'Trigger_Account';

        insert triggerControllerSetting;

        Profile profiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        User groupHeadobj = new User(                                             // Role
            Alias = 'dara',                                                              // Alias
            Email = 'dara@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profiles.id,                                                     // Profile
            Username = 'dara1@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '90007843',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'dara',
            LastName='muda',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US'
        );
        insert groupHeadobj;
        system.debug(' == groupHeadobj :' + groupHeadobj );

        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'merry',                                                            // Alias
            Email = 'merry@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'merry@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003754',                                               // Employee ID
            firstName = 'merry',
            LastName='you'
        );
        insert salesManagerobj;
        system.debug(' == salesManagerobj : ' + salesManagerobj );

            Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
            User AMobj = new User(                                              // Role
                Alias = 'kita',
                EmailEncodingKey='UTF-8',
                Email = 'kita@xl.co.id',                                                   // Email
                ProfileId = AMProfile.id,                                                     // Profile
                Username = 'kita@xl.co.id',                                                // Username
                IsActive = true,                                                             // Active
                LocaleSidKey='en_US',
                TimeZoneSidKey=  'America/Los_Angeles',
                LanguageLocaleKey = 'en_US',
                Department = 'XL Business Solutions',                                        // Department
                ManagerId = salesManagerobj.id,                                               // Manager
                MobilePhone = '+62 817737929',                                               // Mobile
                Employee_ID__c = '90002724',                                                 // Employee ID
                Sales_Group_Head__c = groupHeadobj.id,                                     // Sales Group Head
                Grade__c = '16',   
                firstName = 'kita',
                LastName='bisa'
            );
            insert AMobj;
            system.debug(' == AMobj : ' + AMobj);

        id accRecType = Schema.SObjectType.account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account AccParentObj = new Account(
            Name = 'PT Bank CIMB Niaga Tbk [View Hierarchy]',
            //OwnerId = AMobj.id,                                                  // Account Name
            RecordTypeId = accRecType,                                                                          // Account Record Type
            BP_Number__c = '703705',                                                                             // BP Number
            //Assign_To__c = AMobj.id,                                                                    // Assign To
            Organization_Type__c = 'Head Office',                                                                // Organization Type
            Type = 'Customer',                                                                                   // Type
            Phone = '021-5460555',                                                                               // Phone
            Unique_Name__c = 'Gd Menara Asia Lt.3(HO)',                                                          // Unique Name
            Keyword__c = 'Kristen Penabur',  
            Customer_Type__c = 'NONGSM',                                                                         // Customer Type
            Payer_For_GSM_Invoice__c = false,                                                                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',                                                  // Term of Payment
            Company_Group__c = 'CIMB NIAGA',                                                                     // Company_Group
            Customer_VAT_Name__c = 'PT Bank CIMB Niaga Tbk',                                                     // Customer VAT Name
            Summary_Billing__c = false,                                                                          // Summary Billing
            Is_New_Customer__c = false,                                                                          // Is New Customer
            Using_HO_Billing_Address__c = false,                                                                 // Using HO Billing Address
            Relocation_Street_1__c = 'ATM Perum. Taman Narogong Indah Blok A21 No.51A Bekasi (Geser 10 meter)',  // Relocation Street 1
            No_NPWP__c = '013106687091000',
            
            ShippingStreet = 'JL TG DUREN RAYA NO 4 GD BLOK E LT 5 TANJUNG DUREN UTARA - GROGOL PETAMBURAN JAKARTA BARAT'                                                                      // No NPWP
        );
        insert AccParentObj;
        system.debug(' == AccParentObj : '+ AccParentObj);

        Account accObj = new Account(
            Name = 'PT Bank CIMB Niaga Tbk [View Hierarchy]',  // Account Name
            RecordTypeId = accRecType,                          // Account Record Type
            //OwnerId = AMobj.id,
            //Assign_To__c = AMobj.id,
            BP_Number__c = '710124',                             // BP Number
            Organization_Type__c = 'Branch',                     // Organization Type
            Type = 'Customer',                                   // Type
            ParentId = AccParentObj.id,   
            Unique_Name__c = 'Jakarta Menara Asia Lt.10',  
            Keyword__c = 'TEKPEI',       // Unique Name
            Customer_Type__c = 'NONGSM',                         // Customer Type
            Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
            Company_Group__c = 'CIMB NIAGA',                     // Company_Group
            Customer_VAT_Name__c = 'PT Bank CIMB Niaga Tbk',     // Customer VAT Name
            Summary_Billing__c = false,                          // Summary Billing
            Is_New_Customer__c = false,                          // Is New Customer
            Using_HO_Billing_Address__c = false                 // Using HO Billing Address
        );
        insert accObj;
        system.debug(' == accObj : '+ accObj);

        /*
        Invoice__c Invoiceobj = new Invoice__c(
            Invoice_Number__c = '703705',                             // Invoice Number
            Total_Amount__c = 15.950,                                     // Total Amount
            //Invoice_Date__c = Datetime.valueOf('2-18-2022 12:00 AM:00'),  // Invoice Date
            BillingAccountId__c = AccParentObj.id,                            // Billing Account
            Status__c = 'Unpaid'                                         // Status
            );

            insert Invoiceobj;
            */

    }   

    @istest static void checkAccountBadDebtRequestSyncAsyncTrue(){

        set<string> accBPNumber = new set <string>();
        list<account> accObjList = [select id, name, bp_number__c, ownerid, owner.name from account where bp_number__c = '710124'];
        list<account> AccParentObj = [select id, name, bp_number__c, ownerid, owner.name from account where bp_number__c = '703705' limit 1];
        for(account values :accObjList){
            accBPNumber.add(values.bp_number__c);
        }

        

        user amObj = [select id, profile.id, profile.Name from user where employee_id__c = '90002724' limit 1];

        //invoice__c invoice = [select id from invoice__c where BillingAccountId__c = : AccParentObj.id ];
        
        Pricebook2 DADSPOSPricebook = new Pricebook2( name = 'DADSPOS-01', IsActive = true );

        test.startTest();
        REST_EasyOps_API_Settings__c accountBadDebtSettings = REST_EasyOps_API_Settings__c.getOrgDefaults();

        // create test RequestMock untuk single request

        SingleRequestMock getTokenEasyOps = new SingleRequestMock(200,
                'success',
                '{"token":"eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI4OGVkY2NhNS1lY2Y4LTQ3YmMtYjFkZS1kNDg3ZTMxNjcxMWIiLCJzdWIiOiJhcGlkZW1vIiwiZXhwIjoxNjY1MzAzOTM0fQ.5BMwQy_kfRr6WG5MmEwqE0ZlsLOyEDBb7v1NfbYK7E4"}',
                null);
                
        SingleRequestMock responseInvoiceBadDebt = new SingleRequestMock(200,
         'success',
         '{"data":[{"bad_debt":true,"bp_number":"754938","invoice":[{"invoice_number":"TERAPI","posting_date":"2020-02-2000:00:00","amount":"2377419","external_id":"e845259f-b7b4-4fb3-8e25-687fdcb08493","customer_id":"754938"},{"invoice_number":"DMAROPR","posting_date":"2020-02-2000:00:00","customer_id":"754938","amount":"1650000","external_id":"f23f4091-86cb-41d3-aa31-18f5ec109c45"},{"invoice_number":"DMAROPR","posting_date":"2020-02-2000:00:00","external_id":"ab9b4f96-1013-4b26-a4b0-39fd84cccdca","customer_id":"754938","amount":"1650000"}]},{"bad_debt":true,"bp_number":"752739","invoice":[{"amount":"24","invoice_number":"90183190","customer_id":"752739","posting_date":"2021-02-1000:00:00","external_id":"650493be-b815-4c17-98ba-bc766fa85820"},{"external_id":"77515ad2-edaf-42b9-94d0-4a233de01f2a","amount":"3607500","customer_id":"752739","invoice_number":"90513021","posting_date":"2022-08-1000:00:00"}]}],"requestId":"BD_20220824_162600"}',
          null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(accountBadDebtSettings.accountBadDebt_Endpoint_GetToken__c, getTokenEasyOps);
        endpoint2TestResp.put(accountBadDebtSettings.accountBadDebt_EndPoint_Request_BadDebt__c, responseInvoiceBadDebt);
		HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        //call method
        REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestSync(accBPNumber);
        REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestAsync(accBPNumber);

       test.stopTest();
       
    }

    @istest static void checkAccountBadDebtRequestSyncAsyncFalse(){

        set<string> setAccBPNumber = new set<string>();
        list <account> accObjList = [select id, name, bp_number__c, ownerid, owner.name from account where bp_number__c = '710124' limit 1];

        account AccParentObj = [select id, name, bp_number__c, ownerid, owner.name from account where bp_number__c = '703705' limit 1];

        for(account values :accObjList){
            setAccBPNumber.add(values.bp_number__c);
        }


        user amObj = [select id, profile.id, profile.Name from user where employee_id__c = '90002724' limit 1];
        
        Pricebook2 DADSPOSPricebook = new Pricebook2( name = 'DADSPOS-01', IsActive = true );

    
        test.startTest();
        REST_EasyOps_API_Settings__c accountBadDebtSettings = REST_EasyOps_API_Settings__c.getOrgDefaults();

        // create test RequestMock untuk single request

        SingleRequestMock getTokenEasyOps = new SingleRequestMock(200,
                'success',
                '{"token":"eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI4OGVkY2NhNS1lY2Y4LTQ3YmMtYjFkZS1kNDg3ZTMxNjcxMWIiLCJzdWIiOiJhcGlkZW1vIiwiZXhwIjoxNjY1MzAzOTM0fQ.5BMwQy_kfRr6WG5MmEwqE0ZlsLOyEDBb7v1NfbYK7E4"}',
                null);
                
        SingleRequestMock responseInvoiceBadDebt = new SingleRequestMock(200,
         'success',
         '{"request_id": "BD_20220824_762395","bp_number": "762395","bad_debt": false,"invoice":[]}',
          null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(accountBadDebtSettings.accountBadDebt_Endpoint_GetToken__c, getTokenEasyOps);
        endpoint2TestResp.put(accountBadDebtSettings.accountBadDebt_EndPoint_Request_BadDebt__c, responseInvoiceBadDebt);
		HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        //call method
        REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestSync(setAccBPNumber);
        REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestAsync(setAccBPNumber);

       test.stopTest();
    }    
}