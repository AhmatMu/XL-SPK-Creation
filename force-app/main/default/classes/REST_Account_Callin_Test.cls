/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 11-30-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-30-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class REST_Account_Callin_Test {
    static testmethod void testPostMethod(){
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
        acc.BP_Number__c = '762395';
        acc.Bizstore_Complete__c = false;
        Insert acc;

        Id accountRecordTypeId_dealer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

        Account accountDealer1 = new Account(
            Name = 'Account Dealer 1',
            RecordTypeId = accountRecordTypeId_dealer,
            ParentId = acc.Id,
            DealerID__c = null,
            Organization_Type__c = 'Branch',
            Dealer_Status__c = 'Active',
            Customer_Class__c = '5',
            Sent_to_ERP__c = false,
            Cost_Center__c = 'COSA001',
            Phone = '62817123456',
            Channel_Category__c = '11',
            //SLOC__c = 'undefined',
            Channel_Type__c = '11',
            Dealer_VAT_Type__c = 'Company',
            Channel_Sub_Type__c = '1',
            Dealer_VAT_Name__c = 'CV Berkah Bersama 1',
            Distributor_Type__c = '11',
            No_NPWP__c = '9876543212345678',
            NPWP_Expired_Date__c = system.today(),
            Street_IdexPro__c = 'Jl. Kalibaru Timur, Arjawinangun, Kec. Arjawinangun, Kabupaten Cirebon, Jawa Barat 45162',
            //Province_IdexPro__c = 'undefined',
            //City_IdexPro__c = 'undefined',
            //District_IdexPro__c = 'undefined',
            Postal_Code_IdexPro__c = '1200',
            Idexpro_BillingAddressId__c = '4134931',
            Idexpro_ShippingAddressId__c = '4134930', 
            Update_Dealer_IdexPro_Status__c = 'On Progress',
            DataSource__c = 'Salesforce Input Form'
        );
        insert accountDealer1;

        Contact ContacReq = new Contact();
        ContacReq.LastName = 'Wiryo';
        ContacReq.Accountid = acc.id;
        ContacReq.Firstname = 'Yohn';
        ContacReq.MobilePhone = '0288282';
        ContacReq.Email = 'Fail@fail.com';
        insert ContacReq;

        AccountContactRelation CR = new AccountContactRelation();
        CR.AccountID = accountDealer1.id;
        CR.Contactid = ContacReq.id;
        CR.Roles='Contact Person';
        insert CR;

        Test.startTest();
        String jsonBody = '{"basicDetails":{"accountName":"PT Profesional Internet Indonesia","accountRecordType":"Dealer","distType":11,"channelSubType":1,"channelCategory":11,"sourceWarehouse":9347,"accountBPNumber":"762395","channelType":11},"taxDetails":{"npwpType":"Company","npwpNo":"933779373625000","npwpName":"PT Profesional Internet Indonesia 24112022","npwpAddress":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor, Kademangan Kota Probolinggo","npwpAddressCity":"Probolinggo","npwpAddressState":"Kademangan","npwpAddressPostalCode":"1234","npwpAddressStreet":"Jl Bendi GG Pandawa"},"addresses":[{"addressType":"Billing Address","addressStreet":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","addressDistrict":"dist1","addressCity":"city1","addressProvince":"prov1","addressCountry":"Indonesia","addressPostalCode":"67225"}],"otherDetails":{"custClass":"5","setToErp":"No","costCenter":"COSA001"},"contacts":[{"refId":"con-1234567890","roleName":"Contact Person","firstName":"Usama","lastName":"Agmawan","PhoneNo":"0329333443","mobileNo":"4343","emailAddress":"testing241101@gmail.com"}],"requestInfo":{"apiRequestId":"1b063d0c-34ef-11ed-a261-11112332","requestor":"bizcare"}}';

        RestResponse response = new RestResponse(); 
        RestRequest request = new RestRequest();
        request.requestUri = 'https://xlaxiata-businesssolutions--partsb1.sandbox.my.salesforce.com/services/apexrest/v1/accounts';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonBody);
        
        RestContext.request = request;
        RestContext.response = response;
        REST_Account_Callin.cls_accountCreatedResponse res = REST_Account_Callin.doPost();
        Test.stopTest();
    }

    static testmethod void testPatchMethod(){
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
        acc.BP_Number__c = '762395';
        acc.Bizstore_Complete__c = false;
        Insert acc;

        Id accountRecordTypeId_dealer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

        Account accountDealer1 = new Account(
            Name = 'Account Dealer 1',
            RecordTypeId = accountRecordTypeId_dealer,
            ParentId = acc.Id,
            DealerID__c = null,
            Organization_Type__c = 'Branch',
            Dealer_Status__c = 'Active',
            Customer_Class__c = '5',
            Sent_to_ERP__c = false,
            Cost_Center__c = 'COSA001',
            Phone = '62817123456',
            Channel_Category__c = '11',
            //SLOC__c = 'undefined',
            Channel_Type__c = '11',
            Dealer_VAT_Type__c = 'Company',
            Channel_Sub_Type__c = '1',
            Dealer_VAT_Name__c = 'CV Berkah Bersama 1',
            Distributor_Type__c = '11',
            No_NPWP__c = '9876543212345678',
            NPWP_Expired_Date__c = system.today(),
            Street_IdexPro__c = 'Jl. Kalibaru Timur, Arjawinangun, Kec. Arjawinangun, Kabupaten Cirebon, Jawa Barat 45162',
            //Province_IdexPro__c = 'undefined',
            //City_IdexPro__c = 'undefined',
            //District_IdexPro__c = 'undefined',
            Postal_Code_IdexPro__c = '1200',
            Idexpro_BillingAddressId__c = '4134931',
            Idexpro_ShippingAddressId__c = '4134930', 
            Update_Dealer_IdexPro_Status__c = 'On Progress',
            DataSource__c = 'Salesforce Input Form'
        );
        insert accountDealer1;

        Contact ContacReq = new Contact();
        ContacReq.LastName = 'Wiryo';
        ContacReq.Accountid = accountDealer1.id;
        ContacReq.Firstname = 'Yohn';
        ContacReq.MobilePhone = '0288282';
        ContacReq.Email = 'Fail@fail.com';
        ContacReq.Idexpro_ProfileID__c = '322323232';
        insert ContacReq;

        /*AccountContactRelation CR = new AccountContactRelation();
        CR.AccountID = accountDealer1.id;
        CR.Contactid = ContacReq.id;
        CR.Roles='Contact Person';
        insert CR;*/

        Test.startTest();
        String jsonBody = '{"addresses":[{"addressProvince":"prov5","addressCountry":"Indonesia","addressPostalCode":"12345","addressStreet":"Cirebon Raya No 137, Kab Cirebon Jawa Barat","addressType":"Billing Address","addressDistrict":"dist833","addressCity":"city68"}],"taxDetails":{"npwpAddressState":"","npwpAddressStreet":"Cirebon Raya No 137, Kab Cirebon Jawa Barat","npwpType":"company","npwpNo":"123455555","npwpName":"MAJU JAYA PERSADA","npwpAddressCity":"Cirebon","npwpAddressPostalCode":"12345"},"otherDetails":{"custClass":"5","costCenter":"COSA001","setToErp":"No"},"basicDetails":{"accountName":"PT Maju Bersama"},"requestInfo":{"apiRequestId":"3e2040e9-d984-4da6-9410-a35d0e26000d","requestor":"bizcare"},"contacts":[{"firstName":"Zara","lastName":"Sometime","emailAddress":"zara.something@gmail.com","roleName":"Contact Person","mobileNo":null,"sfContactRecordID":"'+ContacReq.id+'","phoneNo":"6282727272"}]}';

        RestResponse response = new RestResponse(); 
        RestRequest request = new RestRequest();
        request.requestUri = 'https://xlaxiata-businesssolutions--partsb1.sandbox.my.salesforce.com/services/apexrest/v1/accounts';
        request.httpMethod = 'PATCH';
        request.requestBody = Blob.valueof(jsonBody);
        request.addParameter('id', accountDealer1.Id);
        
        RestContext.request = request;
        RestContext.response = response;
        REST_Account_Callin.cls_accountUpdatedResponse res = REST_Account_Callin.doPatch();
        Test.stopTest();
    }
}