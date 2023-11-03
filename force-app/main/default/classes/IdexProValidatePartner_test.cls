/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 12-27-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-28-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class IdexProValidatePartner_test {
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
        ContacReq.Accountid = accountDealer1.id;
        ContacReq.Firstname = 'Yohn';
        ContacReq.MobilePhone = '0288282';
        ContacReq.Email = 'Fail@fail.com';
        insert ContacReq;

        AccountContactRelation CR = new AccountContactRelation();
        CR.AccountID = acc.id;
        CR.Contactid = ContacReq.id;
        CR.Roles='Contact Person';
        insert CR;

        Test.startTest();
        IdexProValidatePartner_ctrl.getAccount(accountDealer1.Id);

        IdexProValidatePartner_ctrl.validatePartner(accountDealer1.Id, 'BUSOL - Community');

        string jsonDealerInfo = '{"dealerId":"90185648","salesChannelName":"Dealer Berkah 2","phoneNo":"62081715151515","emailAddress":"muhammadiqbal@dealerberkah2.id","userId":null,"channelType":"BUSOL - Community","channelSubType":null,"channelCategory":"","address":"Mahajandau, Kec. Dusun Hilir, Kabupaten Barito Selatan, Kalimantan Tengah 73762,Kab. Barito Selatan,Dusun Hilir,KALIMANTAN TENGAH,Indonesia,73762","partnerProfiles":[{"profileId":11189800,"address":null,"birthDate":null,"birthPlace":null,"city":null,"country":null,"emailAddress":"muhammadiqbal@dealerberkah2.id","faxNo":null,"firstName":"Muhammad","gender":null,"homePhoneNo":"62null","identityNo":null,"lastName":"Iqbal","mobileNo":"62null","outletSize":0,"outletType":null,"phoneNo":"62081715151515","postalCode":null,"profileType":"Contact Person","province":null,"salesChannelId":11190164,"title":null,"menu4_actionFlag":null}]}';

        IdexProValidatePartner_ctrl.updateDealerRecords(jsonDealerInfo,accountDealer1.Id);

        accountDealer1.DealerID__c = null;
        update accountDealer1;

        IdexProValidatePartner_ctrl.updateDealerRecords(jsonDealerInfo,accountDealer1.Id);
        Test.stopTest();
    }
}