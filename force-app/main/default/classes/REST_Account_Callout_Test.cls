/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-30-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class REST_Account_Callout_Test {
    static testmethod void CRUD1(){
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
        List<Contact> List_contactRec = new List<Contact>();
        List_contactRec.add(ContacReq);

        REST_Account_Callout_Invoke.Requests request = new REST_Account_Callout_Invoke.Requests();
        request.accountRec = accountDealer1;
        request.List_contactRec = List_contactRec;

        List<REST_Account_Callout_Invoke.Requests> List_request = new  List<REST_Account_Callout_Invoke.Requests>();
        List_request.add(request);

        REST_Account_Callout_Invoke.execute(List_request);
        Test.stopTest();
    }

    static testmethod void test_createPartner_sync(){
        List<IdexPro_API_Setting__c> List_IdexProAPISetting = new List<IdexPro_API_Setting__c>();

        IdexPro_API_Setting__c IdexProAPISetting1 = new IdexPro_API_Setting__c();
        IdexProAPISetting1.Name = 'getToken';
        IdexProAPISetting1.Username__c = 'admin';
        IdexProAPISetting1.Password__c = 'admin';
        IdexProAPISetting1.Client_Secret__c = 'vnrkhb57g9fcvf6btzn4ddheyqq53j2t';
        IdexProAPISetting1.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting1.URL__c = '/api/auth';
        List_IdexProAPISetting.add(IdexProAPISetting1);

        IdexPro_API_Setting__c IdexProAPISetting2 = new IdexPro_API_Setting__c();
        IdexProAPISetting2.Name = 'createPartner';
        IdexProAPISetting2.Username__c = '';
        IdexProAPISetting2.Password__c = '';
        IdexProAPISetting1.Client_Secret__c = '';
        IdexProAPISetting2.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting2.URL__c = '/api/xl/bizon/partner/create';
        List_IdexProAPISetting.add(IdexProAPISetting2);

        insert List_IdexProAPISetting;

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

        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        S.IdexPro_Value_Name__c='9347';
        insert S;

        Test.startTest();
        SingleRequestMock getToken = new SingleRequestMock(
            200,
            'success',
            '{"access_token":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw","token_type":"bearer","expires_in":1673249287831}',
            null
        );

        SingleRequestMock methodExecute = new SingleRequestMock(
            200,
            'success',
            '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190175,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"6211122","outletType":null,"outletSize":0,"mobileNo":"62322233","lastName":"Agmawan","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Usama","faxNo":null,"emailAddress":"testing020101@gmail.com","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189810}],"partnerAddresses":[{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Billing Address","addressId":4134952},{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Shipping Address","addressId":4134953}],"dealerName":"PT Profesional Internet Indonesia","dealerId":"90185670"}],"message":"Partner Created Successfully","status":"OK","code":"200"}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();

        endpoint2TestResp.put(IdexProAPISetting1.URI__c + IdexProAPISetting1.URL__c, getToken) ; 
        endpoint2TestResp.put(IdexProAPISetting2.URI__c + IdexProAPISetting2.URL__c, methodExecute); 
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        String postBody = '{"basicDetails":{"accountName":"PT Profesional Internet Indonesia","accountRecordType":"Dealer","distType":11,"channelSubType":1,"channelCategory":11,"sourceWarehouse":9347,"accountBPNumber":"762395","channelType":11},"taxDetails":{"npwpType":"Company","npwpNo":"933779373625000","npwpName":"PT Profesional Internet Indonesia 24112022","npwpAddress":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor, Kademangan Kota Probolinggo","npwpAddressCity":"Probolinggo","npwpAddressState":"Kademangan","npwpAddressPostalCode":"1234","npwpAddressStreet":"Jl Bendi GG Pandawa"},"addresses":[{"addressType":"Billing Address","addressStreet":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","addressDistrict":"dist1","addressCity":"city1","addressProvince":"prov1","addressCountry":"Indonesia","addressPostalCode":"67225"}],"otherDetails":{"custClass":"5","setToErp":"No","costCenter":"COSA001"},"contacts":[{"refId":"con-1234567890","roleName":"Contact Person","firstName":"Usama","lastName":"Agmawan","PhoneNo":"11122","mobileNo":"322233","emailAddress":"testing020101@gmail.com"}],"requestInfo":{"apiRequestId":"1b063d0c-34ef-11ed-a261-11112332","requestor":"bizcare"}}';

        REST_Account_Callout.createPartner_sync(postBody);
        Test.stopTest();
    }

    static testmethod void test_createPartner_sync2(){
        List<IdexPro_API_Setting__c> List_IdexProAPISetting = new List<IdexPro_API_Setting__c>();

        IdexPro_API_Setting__c IdexProAPISetting1 = new IdexPro_API_Setting__c();
        IdexProAPISetting1.Name = 'getToken';
        IdexProAPISetting1.Username__c = 'admin';
        IdexProAPISetting1.Password__c = 'admin';
        IdexProAPISetting1.Client_Secret__c = 'vnrkhb57g9fcvf6btzn4ddheyqq53j2t';
        IdexProAPISetting1.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting1.URL__c = '/api/auth';
        List_IdexProAPISetting.add(IdexProAPISetting1);

        IdexPro_API_Setting__c IdexProAPISetting2 = new IdexPro_API_Setting__c();
        IdexProAPISetting2.Name = 'createPartner';
        IdexProAPISetting2.Username__c = '';
        IdexProAPISetting2.Password__c = '';
        IdexProAPISetting1.Client_Secret__c = '';
        IdexProAPISetting2.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting2.URL__c = '/api/xl/bizon/partner/create';
        List_IdexProAPISetting.add(IdexProAPISetting2);

        insert List_IdexProAPISetting;

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

        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        S.IdexPro_Value_Name__c='9347';
        insert S;

        Contact ContacReq = new Contact();
        ContacReq.LastName = 'Wiryo';
        ContacReq.Accountid = acc.id;
        ContacReq.Firstname = 'Yohn';
        ContacReq.MobilePhone = '0288282';
        ContacReq.Email = 'testing020101@gmail.com';
        insert ContacReq;

        Test.startTest();
        SingleRequestMock getToken = new SingleRequestMock(
            200,
            'success',
            '{"access_token":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw","token_type":"bearer","expires_in":1673249287831}',
            null
        );

        SingleRequestMock methodExecute = new SingleRequestMock(
            200,
            'success',
            '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190175,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"6211122","outletType":null,"outletSize":0,"mobileNo":"62322233","lastName":"Agmawan","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Usama","faxNo":null,"emailAddress":"testing020101@gmail.com","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189810}],"partnerAddresses":[{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Billing Address","addressId":4134952},{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Shipping Address","addressId":4134953}],"dealerName":"PT Profesional Internet Indonesia","dealerId":"90185670"}],"message":"Partner Created Successfully","status":"OK","code":"200"}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();

        endpoint2TestResp.put(IdexProAPISetting1.URI__c + IdexProAPISetting1.URL__c, getToken) ; 
        endpoint2TestResp.put(IdexProAPISetting2.URI__c + IdexProAPISetting2.URL__c, methodExecute); 
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        String postBody = '{"basicDetails":{"accountName":"PT Profesional Internet Indonesia","accountRecordType":"Dealer","distType":11,"channelSubType":1,"channelCategory":11,"sourceWarehouse":9347,"accountBPNumber":"762395","channelType":11},"taxDetails":{"npwpType":"Company","npwpNo":"933779373625000","npwpName":"PT Profesional Internet Indonesia 24112022","npwpAddress":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor, Kademangan Kota Probolinggo","npwpAddressCity":"Probolinggo","npwpAddressState":"Kademangan","npwpAddressPostalCode":"1234","npwpAddressStreet":"Jl Bendi GG Pandawa"},"addresses":[{"addressType":"Billing Address","addressStreet":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","addressDistrict":"dist1","addressCity":"city1","addressProvince":"prov1","addressCountry":"Indonesia","addressPostalCode":"67225"}],"otherDetails":{"custClass":"5","setToErp":"No","costCenter":"COSA001"},"contacts":[{"refId":"con-1234567890","roleName":"Contact Person","firstName":"Usama","lastName":"Agmawan","PhoneNo":"11122","mobileNo":"322233","emailAddress":"testing020101@gmail.com"}],"requestInfo":{"apiRequestId":"1b063d0c-34ef-11ed-a261-11112332","requestor":"bizcare"}}';

        REST_Account_Callout.createPartner_sync(postBody);
        Test.stopTest();
    }

    static testmethod void test_createPartner_async(){
        List<IdexPro_API_Setting__c> List_IdexProAPISetting = new List<IdexPro_API_Setting__c>();

        IdexPro_API_Setting__c IdexProAPISetting1 = new IdexPro_API_Setting__c();
        IdexProAPISetting1.Name = 'getToken';
        IdexProAPISetting1.Username__c = 'admin';
        IdexProAPISetting1.Password__c = 'admin';
        IdexProAPISetting1.Client_Secret__c = 'vnrkhb57g9fcvf6btzn4ddheyqq53j2t';
        IdexProAPISetting1.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting1.URL__c = '/api/auth';
        List_IdexProAPISetting.add(IdexProAPISetting1);

        IdexPro_API_Setting__c IdexProAPISetting2 = new IdexPro_API_Setting__c();
        IdexProAPISetting2.Name = 'createPartner';
        IdexProAPISetting2.Username__c = '';
        IdexProAPISetting2.Password__c = '';
        IdexProAPISetting1.Client_Secret__c = '';
        IdexProAPISetting2.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting2.URL__c = '/api/xl/bizon/partner/create';
        List_IdexProAPISetting.add(IdexProAPISetting2);

        insert List_IdexProAPISetting;

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

        Id accountRecordTypeId_dealer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

        Account accountDealer1 = new Account(
            Name = 'Account Dealer 1',
            RecordTypeId = accountRecordTypeId_dealer,
            ParentId = acc.Id,
            DealerID__c = '90185647',
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
        CR.Roles = 'Contact Person';
        insert CR;

        Contact ContacReq2 = new Contact();
        ContacReq2.LastName = 'joko';
        ContacReq2.Accountid = acc.id;
        ContacReq2.Firstname = 'toni';
        ContacReq2.MobilePhone = '54545454';
        ContacReq2.Email = 'Fail222@fail222.com';
        insert ContacReq2;

        AccountContactRelation CR2 = new AccountContactRelation();
        CR2.AccountID = accountDealer1.id;
        CR2.Contactid = ContacReq2.id;
        CR2.Roles = 'Contact Person';
        insert CR2;

        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        S.IdexPro_Value_Name__c='9347';
        insert S;

        Test.startTest();
        SingleRequestMock getToken = new SingleRequestMock(
            200,
            'success',
            '{"access_token":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw","token_type":"bearer","expires_in":1673249287831}',
            null
        );

        SingleRequestMock methodExecute = new SingleRequestMock(
            200,
            'success',
            '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190175,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"6211122","outletType":null,"outletSize":0,"mobileNo":"62322233","lastName":"Agmawan","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Usama","faxNo":null,"emailAddress":"testing020101@gmail.com","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189810}],"partnerAddresses":[{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Billing Address","addressId":4134952},{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Shipping Address","addressId":4134953}],"dealerName":"PT Profesional Internet Indonesia","dealerId":"90185670"}],"message":"Partner Created Successfully","status":"OK","code":"200"}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();

        endpoint2TestResp.put(IdexProAPISetting1.URI__c + IdexProAPISetting1.URL__c, getToken) ; 
        endpoint2TestResp.put(IdexProAPISetting2.URI__c + IdexProAPISetting2.URL__c, methodExecute); 
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<Contact> List_Contact = new List<Contact>();
        List_Contact.add(ContacReq);
        List_Contact.add(ContacReq2);

        REST_Account_Callout.createPartner_async(json.serialize(accountDealer1),json.serialize(List_Contact));
        Test.stopTest();
    }

    static testmethod void test_validatePartner_sync(){
        List<IdexPro_API_Setting__c> List_IdexProAPISetting = new List<IdexPro_API_Setting__c>();

        IdexPro_API_Setting__c IdexProAPISetting1 = new IdexPro_API_Setting__c();
        IdexProAPISetting1.Name = 'getToken';
        IdexProAPISetting1.Username__c = 'admin';
        IdexProAPISetting1.Password__c = 'admin';
        IdexProAPISetting1.Client_Secret__c = 'vnrkhb57g9fcvf6btzn4ddheyqq53j2t';
        IdexProAPISetting1.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting1.URL__c = '/api/auth';
        List_IdexProAPISetting.add(IdexProAPISetting1);

        IdexPro_API_Setting__c IdexProAPISetting2 = new IdexPro_API_Setting__c();
        IdexProAPISetting2.Name = 'validatePartner';
        IdexProAPISetting2.Username__c = '';
        IdexProAPISetting2.Password__c = '';
        IdexProAPISetting1.Client_Secret__c = '';
        IdexProAPISetting2.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting2.URL__c = '/api/xl/bizon/partner/validate';
        List_IdexProAPISetting.add(IdexProAPISetting2);

        insert List_IdexProAPISetting;

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

        Id accountRecordTypeId_dealer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

        Account accountDealer1 = new Account(
            Name = 'Account Dealer 1',
            RecordTypeId = accountRecordTypeId_dealer,
            ParentId = acc.Id,
            DealerID__c = '90185647',
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
        CR.Roles = 'Contact Person';
        insert CR;

        Contact ContacReq2 = new Contact();
        ContacReq2.LastName = 'joko';
        ContacReq2.Accountid = acc.id;
        ContacReq2.Firstname = 'toni';
        ContacReq2.MobilePhone = '54545454';
        ContacReq2.Email = 'Fail222@fail222.com';
        insert ContacReq2;

        AccountContactRelation CR2 = new AccountContactRelation();
        CR2.AccountID = accountDealer1.id;
        CR2.Contactid = ContacReq2.id;
        CR2.Roles = 'Contact Person';
        insert CR2;

        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        S.IdexPro_Value_Name__c='9347';
        insert S;

        Test.startTest();
        SingleRequestMock getToken = new SingleRequestMock(
            200,
            'success',
            '{"access_token":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw","token_type":"bearer","expires_in":1673249287831}',
            null
        );

        SingleRequestMock methodExecute = new SingleRequestMock(
            200,
            'success',
            '{"partnerDetails":[{"dealerId":"90185427","salesChannelName":"PT Profesional Internet Indonesia","phoneNo":"6202183273293","emailAddress":"testing261002@gmail.com","userId":null,"channelType":"BUSOL - Community","channelSubType":null,"channelCategory":"","address":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor,Kota Probolinggo,Kademangan,JAWA TIMUR,Indonesia,67225","partnerProfiles":[{"profileId":11189727,"address":null,"birthDate":null,"birthPlace":null,"city":null,"country":null,"emailAddress":"testing261002@gmail.com","faxNo":null,"firstName":"Usama","gender":null,"homePhoneNo":"62null","identityNo":null,"lastName":"Agmawan","mobileNo":"62673434343","outletSize":0,"outletType":null,"phoneNo":"6202183273293","postalCode":0,"profileType":"Contact Person","province":null,"salesChannelId":11190003,"title":null,"menu4_actionFlag":null}]}]}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();

        endpoint2TestResp.put(IdexProAPISetting1.URI__c + IdexProAPISetting1.URL__c, getToken) ; 
        endpoint2TestResp.put(IdexProAPISetting2.URI__c + IdexProAPISetting2.URL__c, methodExecute); 
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<Contact> List_Contact = new List<Contact>();
        List_Contact.add(ContacReq);
        List_Contact.add(ContacReq2);

        REST_Account_Callout.validatePartner_sync(accountDealer1.Id,'BUSOL - Community',accountDealer1.Name,accountDealer1.DealerID__c);
        Test.stopTest();
    }

    static testmethod void test_modificationPartner_sync(){
        List<IdexPro_API_Setting__c> List_IdexProAPISetting = new List<IdexPro_API_Setting__c>();

        IdexPro_API_Setting__c IdexProAPISetting1 = new IdexPro_API_Setting__c();
        IdexProAPISetting1.Name = 'getToken';
        IdexProAPISetting1.Username__c = 'admin';
        IdexProAPISetting1.Password__c = 'admin';
        IdexProAPISetting1.Client_Secret__c = 'vnrkhb57g9fcvf6btzn4ddheyqq53j2t';
        IdexProAPISetting1.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting1.URL__c = '/api/auth';
        List_IdexProAPISetting.add(IdexProAPISetting1);

        IdexPro_API_Setting__c IdexProAPISetting2 = new IdexPro_API_Setting__c();
        IdexProAPISetting2.Name = 'modificationPartner';
        IdexProAPISetting2.Username__c = '';
        IdexProAPISetting2.Password__c = '';
        IdexProAPISetting1.Client_Secret__c = '';
        IdexProAPISetting2.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting2.URL__c = '/api/xl/bizon/partner/update/';
        List_IdexProAPISetting.add(IdexProAPISetting2);

        insert List_IdexProAPISetting;

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

        Id accountRecordTypeId_dealer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

        Account accountDealer1 = new Account(
            Name = 'Account Dealer 1',
            RecordTypeId = accountRecordTypeId_dealer,
            ParentId = acc.Id,
            DealerID__c = '90185647',
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
        CR.Roles = 'Contact Person';
        insert CR;

        Contact ContacReq2 = new Contact();
        ContacReq2.LastName = 'joko';
        ContacReq2.Accountid = acc.id;
        ContacReq2.Firstname = 'toni';
        ContacReq2.MobilePhone = '54545454';
        ContacReq2.Email = 'Fail222@fail222.com';
        insert ContacReq2;

        AccountContactRelation CR2 = new AccountContactRelation();
        CR2.AccountID = accountDealer1.id;
        CR2.Contactid = ContacReq2.id;
        CR2.Roles = 'Contact Person';
        insert CR2;

        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        S.IdexPro_Value_Name__c='9347';
        insert S;

        Test.startTest();
        SingleRequestMock getToken = new SingleRequestMock(
            200,
            'success',
            '{"access_token":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw","token_type":"bearer","expires_in":1673249287831}',
            null
        );

        SingleRequestMock methodExecute = new SingleRequestMock(
            200,
            'success',
            '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190164,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"62081715151515","outletType":null,"outletSize":0,"mobileNo":"62null","lastName":"Iqbal","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Muhammad","faxNo":null,"emailAddress":"muhammadiqbal@dealerberkah2.id","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189800}],"partnerAddresses":[{"street":"Mahajandau, Kec. Dusun Hilir, Kabupaten Barito Selatan, Kalimantan Tengah 73762,Kab. Barito Selatan,Dusun Hilir,KALIMANTAN TENGAH,Indonesia,73762","salesChannelId":11190164,"province":"prov2","postalCode":73762,"country":"Indonesia","city":"city11","district":"dist104","addressType":"Billing Address","addressId":4134933},{"street":"Mahajandau, Kec. Dusun Hilir, Kabupaten Barito Selatan, Kalimantan Tengah 73762,Kab. Barito Selatan,Dusun Hilir,KALIMANTAN TENGAH,Indonesia,73762","salesChannelId":11190164,"province":"prov2","postalCode":73762,"country":"Indonesia","city":"city11","district":"dist104","addressType":"Shipping Address","addressId":4134932}],"dealerName":"Dealer Berkah 2","dealerId":"90185648"}],"message":"Partner Updated Successfully","status":"OK","code":"200"}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();

        endpoint2TestResp.put(IdexProAPISetting1.URI__c + IdexProAPISetting1.URL__c, getToken) ; 
        endpoint2TestResp.put(IdexProAPISetting2.URI__c + IdexProAPISetting2.URL__c, methodExecute); 
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        String postBody = '{"addresses":[{"addressProvince":"prov5","addressCountry":"Indonesia","addressPostalCode":"12345","addressStreet":"Cirebon Raya No 137, Kab Cirebon Jawa Barat","addressType":"Billing Address","addressDistrict":"dist833","addressCity":"city68"}],"taxDetails":{"npwpAddressState":"","npwpAddressStreet":"Cirebon Raya No 137, Kab Cirebon Jawa Barat","npwpType":"company","npwpNo":"123455555","npwpName":"MAJU JAYA PERSADA","npwpAddressCity":"Cirebon","npwpAddressPostalCode":"12345"},"otherDetails":{"custClass":"5","costCenter":"COSA001","setToErp":"No"},"basicDetails":{"accountName":"PT Maju Bersama"},"requestInfo":{"apiRequestId":"3e2040e9-d984-4da6-9410-a35d0e26000d","requestor":"bizcare"},"contacts":[{"firstName":"Zara","lastName":"Sometime","emailAddress":"zara.something@gmail.com","roleName":"Contact Person","mobileNo":null,"sfContactRecordID":"'+ ContacReq.Id +'","phoneNo":"6282727272"}]}';

        REST_Account_Callout.modificationPartner_sync(postBody, accountDealer1.Id);
        Test.stopTest();
    }

    static testmethod void test_modificationPartner_async(){
        List<IdexPro_API_Setting__c> List_IdexProAPISetting = new List<IdexPro_API_Setting__c>();

        IdexPro_API_Setting__c IdexProAPISetting1 = new IdexPro_API_Setting__c();
        IdexProAPISetting1.Name = 'getToken';
        IdexProAPISetting1.Username__c = 'admin';
        IdexProAPISetting1.Password__c = 'admin';
        IdexProAPISetting1.Client_Secret__c = 'vnrkhb57g9fcvf6btzn4ddheyqq53j2t';
        IdexProAPISetting1.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting1.URL__c = '/api/auth';
        List_IdexProAPISetting.add(IdexProAPISetting1);

        IdexPro_API_Setting__c IdexProAPISetting2 = new IdexPro_API_Setting__c();
        IdexProAPISetting2.Name = 'modificationPartner';
        IdexProAPISetting2.Username__c = '';
        IdexProAPISetting2.Password__c = '';
        IdexProAPISetting1.Client_Secret__c = '';
        IdexProAPISetting2.URI__c = 'http://18.139.13.108:9086';
        IdexProAPISetting2.URL__c = '/api/xl/bizon/partner/update/';
        List_IdexProAPISetting.add(IdexProAPISetting2);

        insert List_IdexProAPISetting;

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

        Id accountRecordTypeId_dealer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

        Account accountDealer1 = new Account(
            Name = 'Account Dealer 1',
            RecordTypeId = accountRecordTypeId_dealer,
            ParentId = acc.Id,
            DealerID__c = '90185647',
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
        ContacReq.Idexpro_ProfileID__c = 'sasa32332';
        insert ContacReq;
        
        AccountContactRelation CR = new AccountContactRelation();
        CR.AccountID = accountDealer1.id;
        CR.Contactid = ContacReq.id;
        CR.Roles = 'Contact Person';
        insert CR;

        Contact ContacReq2 = new Contact();
        ContacReq2.LastName = 'joko';
        ContacReq2.Accountid = accountDealer1.id;
        ContacReq2.Firstname = 'toni';
        ContacReq2.MobilePhone = '54545454';
        ContacReq2.Email = 'Fail222@fail222.com';
        ContacReq2.Idexpro_ProfileID__c = 'sasa32332';
        insert ContacReq2;

        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        S.IdexPro_Value_Name__c='9347';
        insert S;

        Test.startTest();
        SingleRequestMock getToken = new SingleRequestMock(
            200,
            'success',
            '{"access_token":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw","token_type":"bearer","expires_in":1673249287831}',
            null
        );

        SingleRequestMock methodExecute = new SingleRequestMock(
            200,
            'success',
            '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190164,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"62081715151515","outletType":null,"outletSize":0,"mobileNo":"62null","lastName":"Iqbal","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Muhammad","faxNo":null,"emailAddress":"muhammadiqbal@dealerberkah2.id","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189800}],"partnerAddresses":[{"street":"Mahajandau, Kec. Dusun Hilir, Kabupaten Barito Selatan, Kalimantan Tengah 73762,Kab. Barito Selatan,Dusun Hilir,KALIMANTAN TENGAH,Indonesia,73762","salesChannelId":11190164,"province":"prov2","postalCode":73762,"country":"Indonesia","city":"city11","district":"dist104","addressType":"Billing Address","addressId":4134933},{"street":"Mahajandau, Kec. Dusun Hilir, Kabupaten Barito Selatan, Kalimantan Tengah 73762,Kab. Barito Selatan,Dusun Hilir,KALIMANTAN TENGAH,Indonesia,73762","salesChannelId":11190164,"province":"prov2","postalCode":73762,"country":"Indonesia","city":"city11","district":"dist104","addressType":"Shipping Address","addressId":4134932}],"dealerName":"Dealer Berkah 2","dealerId":"90185648"}],"message":"Partner Updated Successfully","status":"OK","code":"200"}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();

        endpoint2TestResp.put(IdexProAPISetting1.URI__c + IdexProAPISetting1.URL__c, getToken) ; 
        endpoint2TestResp.put(IdexProAPISetting2.URI__c + IdexProAPISetting2.URL__c, methodExecute); 
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        String oldRecord = '{"attributes":{"type":"Account","url":"/services/data/v56.0/sobjects/Account/'+accountDealer1.Id+'"},"Channel_Type__c":"11","LastModifiedDate":"2022-11-25T01:24:36.000+0000","Account_Type__c":"Dealer","Dealer_VAT_Name__c":"MAJU MUNDUR","Update_Dealer_IdexPro_Status__c":"Success","VAT_Address_to_BSS__c":"Kraton Raya No 27, Jogja 15143 Kraton  12345","Owner_Email__c":"doddy.kusumadhynata@saasten.com","Payer_For_GSM_Invoice__c":false,"Name":"PT Maju Bersama","Record_ID__c":"'+accountDealer1.Id+'","Dealer_VAT_Type__c":"Company","Sent_to_ERP__c":false,"BP_Number_Unique_Name__c":" - ","Is_New_Customer__c":false,"CreatedById":"0057F0000040z8sQAA","District_IdexPro__c":"a2m1m000000HBAWAA4","DataSource__c":"BizCare","Distributor_Type__c":"11","AccountSource":"Website","Summary_Billing__c":false,"No_NPWP__c":"987654321","Postal_Code_IdexPro__c":"12345","IsDeleted":false,"Province_IdexPro__c":"a2k1m000000HAgWAAW","Organization_Type__c":"Branch","Invoice_Name__c":"PT Maju Bersama ","Conversion_from_lead__c":false,"ShippingStreet":"Kraton Raya No 27, Jogja 15143","Temporary_LA_or_IDCom__c":"2598.0","District_IdexPro_Code__c":"dist443","summary_invoice__c":false,"City_IdexPro_Code__c":"city43","Billing_Address_to_BSS__c":"   ","ShippingPostalCode":"12345","CreatedDate":"2022-11-24T09:30:29.000+0000","SLOC__c":"a0M7F000006IM0fUAG","Channel_Category__c":"11","Id":"'+accountDealer1.Id+'","Using_HO_Billing_Address__c":false,"Data_Quality_Score__c":20,"City_IdexPro__c":"a2l1m000000AkF9AAK","Idexpro_ShippingAddressId__c":"4134915","DealerID__c":"90185638","SLOC_IdexPro_Value__c":"9347","Data_Quality_Description__c":"Missing: Industry, Rating, Complete Address, Type","Bad_Debt_Status__c":"False","OwnerId":"0057F0000040z8sQAA","Phone":"62837837681","Channel_Sub_Type__c":"1","RecordTypeId":"0121m0000019j9WAAQ","ShippingCity":"Kraton","Customer_Class__c":"5","Idexpro_BillingAddressId__c":"4134914","TOP_Value__c":0,"City_IdexPro_Value__c":"Kota Yogyakarta","ParentId":"0011m00000bz3acAAA","Province_IdexPro_Code__c":"prov4","Owner_Manager_Name__c":"System Administrator","Bizstore_Complete__c":false,"Owner_Role_Level__c":"AM","SystemModstamp":"2022-11-25T01:24:36.000+0000","Faktur_Pajak__c":false,"Parent_BP_Number__c":"759399","Cost_Center__c":"COSA001","BillingCountry":"Indonesia","Dealer_Status__c":"Active","Kwitansi__c":false,"LastModifiedById":"0057F0000040z8sQAA","Street_IdexPro__c":"Kraton Raya No 27, Jogja 15143"}';

        REST_Account_Callout.modificationPartner_async(accountDealer1.Id, ContacReq2.Id, oldRecord);
        Test.stopTest();
    }

    static testmethod void test_sendEmailNotifFailed(){
        List<Dealer_Email_Setting__c> List_DealerEmailSetting = new List<Dealer_Email_Setting__c>();

        Dealer_Email_Setting__c DealerEmailSetting1 = new Dealer_Email_Setting__c();
        DealerEmailSetting1.Name = 'Dealer Creation Failed Info';
        DealerEmailSetting1.Email_Template_Name__c = 'Dealer_Creation_Failed_Info';
        DealerEmailSetting1.Additional_toAddress__c = '';
        DealerEmailSetting1.Additional_toCCAddress__c = 'novando.agmawan@saasten.com;doddy.kusumadhynata@saasten.com;muhammad.iqbal@saasten.com;novi.fajariasih@saasten.com;usamah.ridha@saasten.com';
        List_DealerEmailSetting.add(DealerEmailSetting1);

        Dealer_Email_Setting__c DealerEmailSetting2 = new Dealer_Email_Setting__c();
        DealerEmailSetting2.Name = 'Dealer Update Failed Info';
        DealerEmailSetting2.Email_Template_Name__c = 'Dealer_Update_Failed_Info	';
        DealerEmailSetting2.Additional_toAddress__c = '';
        DealerEmailSetting2.Additional_toCCAddress__c = 'novando.agmawan@saasten.com;doddy.kusumadhynata@saasten.com;muhammad.iqbal@saasten.com;novi.fajariasih@saasten.com;usamah.ridha@saasten.com';
        List_DealerEmailSetting.add(DealerEmailSetting2);

        insert List_DealerEmailSetting;

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

        Id accountRecordTypeId_dealer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

        Account accountDealer1 = new Account(
            Name = 'Account Dealer 1',
            RecordTypeId = accountRecordTypeId_dealer,
            ParentId = acc.Id,
            DealerID__c = '90185647',
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
        ContacReq.Idexpro_ProfileID__c = 'sasa32332';
        insert ContacReq;
        
        AccountContactRelation CR = new AccountContactRelation();
        CR.AccountID = accountDealer1.id;
        CR.Contactid = ContacReq.id;
        CR.Roles = 'Contact Person';
        insert CR;

        Contact ContacReq2 = new Contact();
        ContacReq2.LastName = 'joko';
        ContacReq2.Accountid = accountDealer1.id;
        ContacReq2.Firstname = 'toni';
        ContacReq2.MobilePhone = '54545454';
        ContacReq2.Email = 'Fail222@fail222.com';
        ContacReq2.Idexpro_ProfileID__c = 'sasa32332';
        insert ContacReq2;

        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        S.IdexPro_Value_Name__c='9347';
        insert S;

        Test.startTest();
        REST_Account_Callout.sendEmailNotifFailed('Dealer Update Failed Info', accountDealer1.Id, ContacReq2.Id);

        REST_Account_Callout.sendEmailNotifFailed('Dealer Creation Failed Info', accountDealer1.Id, ContacReq2.Id);
        Test.stopTest();
    }
}