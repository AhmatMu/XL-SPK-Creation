/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-27-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   12-27-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class REST_SAPGetPrice_Callout_v1_Test {
    static testmethod void CRUD1(){
        List<SAP_API_Setting__c> List_SAPAPISetting = new List<SAP_API_Setting__c>();

        SAP_API_Setting__c SAPAPISetting1 = new SAP_API_Setting__c();
        SAPAPISetting1.Name = 'getToken';
        SAPAPISetting1.Username__c = 'apihanaconnectivity';
        SAPAPISetting1.Password__c = 'J@karta99';
        SAPAPISetting1.URI__c = 'https://oauthasservices-cbed89630.ap1.hana.ondemand.com';
        SAPAPISetting1.URL__c = '/oauth2/api/v1/token?grant_type=client_credentials';
        List_SAPAPISetting.add(SAPAPISetting1);

        SAP_API_Setting__c SAPAPISetting2 = new SAP_API_Setting__c();
        SAPAPISetting2.Name = 'SOPriceCheck';
        SAPAPISetting2.Username__c = '';
        SAPAPISetting2.Password__c = '';
        SAPAPISetting2.URI__c = 'https://l200409-iflmap.hcisbp.ap1.hana.ondemand.com';
        SAPAPISetting2.URL__c = '/http/eso/sopricecheck/uat';
        List_SAPAPISetting.add(SAPAPISetting2);

        insert List_SAPAPISetting;

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
        CR.Roles='Contact Person';
        insert CR;

        Pricebook2 PB_GSMMaterialGeneral = new Pricebook2(
            Name='GSM-Material General',
            Service_group__c='GSM',
            GSM_Type__c = 'Material',
            IsActive=true
        );
        insert PB_GSMMaterialGeneral;
		
        Product2 pro2 = new Product2(
            Name = 'SP0KJIT-JKT',
            isActive = true,
            SIM_Type__c = 'Reg - Prepaid',
            Product_Code2__c = 'Prepaid',
            ProductCode = 'Prepaid',
            Revenue_Type__c = 'One Time',
            Family = 'Material'
        );
        insert pro2;

        PricebookEntry pbEntrySTDREC = new PricebookEntry(
            Product2Id = pro2.id,  // Product
            IsActive = true,                   // Active
            Pricebook2Id = Test.getStandardPricebookId(),  // Price Book
            UnitPrice = 52.500,                // List Price
            UseStandardPrice = false          // Use Standard Price
        );
        insert pbEntrySTDREC;
        
        PricebookEntry PBE_GSMMaterialGeneral = new PricebookEntry(
            Product2Id = pro2.id,  // Product
            IsActive = true,                   // Active
            Pricebook2Id = PB_GSMMaterialGeneral.id,  // Price Book
            UnitPrice = 12.500,                // List Price
            UseStandardPrice = false          // Use Standard Price
        );
        insert PBE_GSMMaterialGeneral;

        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        insert S;

        Id orderRecordTypeId_GSMSIMCard = Schema.SObjectType.Order.getRecordTypeInfosByName().get('GSM SIM Card').getRecordTypeId();

        Order orderRec = New Order();
        orderRec.AccountID = acc.id;
        orderRec.Status = 'Draft';
        orderRec.SLOC__c = S.id;
        orderRec.recordtypeid = orderRecordTypeId_GSMSIMCard;
        orderRec.Pricebook2id = PB_GSMMaterialGeneral.id;
        orderRec.EffectiveDate = system.today();
        orderRec.SIMCard_Order_Payment_Type__c = 'FREE';
        insert orderRec;

        orderRec.Pricebook2id = PB_GSMMaterialGeneral.id;
        update orderRec;

        OrderItem plcLineItem = new OrderItem(
            OrderId = orderRec.id, 
            Product2id = pro2.id,
            PricebookEntryId = PBE_GSMMaterialGeneral.id,
            Quantity = 1, 
            UnitPrice = 300);
        insert plcLineItem;

        Test.startTest();
        SingleRequestMock getToken = new SingleRequestMock(
            200,
            'success',
            '{"access_token":"90c05dfbf7ba4a30cdefb83e79148e","token_type":"Bearer","expires_in":86400,"scope":""}',
            null
        );

        SingleRequestMock sapChekPrice = new SingleRequestMock(
            200,
            'success',
            '{"part_request_hdr_id":"1","item":[{"partrequestid":"1-1","revision":"SP0KJIT-JKT","price":"10000.00 ","status":"1","reason":"success"}]}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();

        endpoint2TestResp.put(SAPAPISetting1.URI__c + SAPAPISetting1.URL__c, getToken) ; 
        endpoint2TestResp.put(SAPAPISetting2.URI__c + SAPAPISetting2.URL__c, sapChekPrice); 
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Set<String> Set_OrderProductId = new Set<String>();
        Set_OrderProductId.add(plcLineItem.Id);

        Set<String> Set_ProductId = new Set<String>();
        Set_ProductId.add(plcLineItem.Product2id);

        REST_SAPGetPrice_Callout_v1.getPriceSAP(Set_OrderProductId, Set_ProductId, false);

        REST_SAPGetPrice_Callout_v1.getPriceSAP(Set_OrderProductId, Set_ProductId, true);
        Test.stopTest();
    }
}