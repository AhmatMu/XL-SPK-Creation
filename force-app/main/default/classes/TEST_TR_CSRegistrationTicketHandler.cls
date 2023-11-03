/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-24-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-24-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class TEST_TR_CSRegistrationTicketHandler {

    static testmethod void CRUD1(){
        insert new Transaction__c(transactionID__c = 1);

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController=new Trigger_Controller__c();
        TriggerController.Name = 'Trigger_CSRegistrationTicket';
        TriggerController.Is_Active__c = True;
        lstTriggerController.add(TriggerController);

        Trigger_Controller__c TriggerController1=new Trigger_Controller__c();
        TriggerController1.Name = 'Trigger_CSRegistrationDoc';
        TriggerController1.Is_Active__c = True;
        lstTriggerController.add(TriggerController1);
        insert lstTriggerController;

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
        acc.Billing_Address_Province__c = 'jawa tengah';
        acc.Billing_Address_City__c = 'kota surakarta';
        acc.Shipping_Address_Province__c = 'jawa tengah';
        acc.Shipping_Address_City__c = 'kota surakarta' ; 
        Insert acc;

        Id newRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('New').getRecordTypeId();

        Customer_Registration_Ticket__c customerRegistrationTicket = new Customer_Registration_Ticket__c();
        customerRegistrationTicket.RecordTypeId = newRecordTypeId;
        customerRegistrationTicket.Company_Type__c = 'new';
        customerRegistrationTicket.Company_Name__c = 'Test Admin Novando';
        customerRegistrationTicket.Stage__c = 'New';
        customerRegistrationTicket.BP_Number__c = '111';
        customerRegistrationTicket.Personal_Last_Name__c = 'Test Admin Novando';
        customerRegistrationTicket.Bizstore_Complete__c = false;
        insert customerRegistrationTicket;

        Customer_Registration_Document__c customerRegistrationDocument = new Customer_Registration_Document__c();
        customerRegistrationDocument.Name = 'semenaduk_siup.pdf';
        customerRegistrationDocument.Customer_Registration_Ticket__c = customerRegistrationTicket.id;
        customerRegistrationDocument.Document_Type_Name__c = 'SIUP';
        customerRegistrationDocument.Status__c = 'Approved';
        insert customerRegistrationDocument;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'semenaduk_siup.pdf';
        contentVersion.Document_Type_Name__c = 'SIUP';
        contentVersion.FirstPublishLocationId = customerRegistrationTicket.id;
        contentVersion.PathOnClient = 'semenaduk_siup.pdf';
        contentVersion.VersionData = Blob.valueOf('Test Content');
        contentVersion.IsMajorVersion = true;
        Insert contentVersion;

        Test.startTest();
        customerRegistrationTicket.Stage__c = 'Need To Revise';
        customerRegistrationTicket.Customer_Registration_Ticket_Status__c = 'Approved';
        customerRegistrationTicket.Company_Name_Status__c = 'Approved';
        customerRegistrationTicket.Personal_First_Name_Status__c = 'Approved';
        customerRegistrationTicket.Personal_Last_Name_Status__c = 'Approved';
        customerRegistrationTicket.Personal_Email_Status__c = 'Approved';
        customerRegistrationTicket.Personal_Phone_Status__c = 'Approved';
        customerRegistrationTicket.Industry_Status__c = 'Approved';
        customerRegistrationTicket.Company_Unique_Name_Status__c = 'Approved';
        customerRegistrationTicket.Number_Of_Employees_Status__c = 'Approved';
        customerRegistrationTicket.Company_Group_Status__c = 'Approved';
        customerRegistrationTicket.Company_Vat_Name_Status__c = 'Approved';
        customerRegistrationTicket.Npwp_No_Status__c = 'Approved';
        customerRegistrationTicket.Billing_Street_Status__c = 'Approved';
        customerRegistrationTicket.Billing_State_Status__c = 'Approved';
        customerRegistrationTicket.Billing_Building_Name_Status__c = 'Approved';
        customerRegistrationTicket.Billing_City_Status__c = 'Approved';
        customerRegistrationTicket.Billing_Country_Status__c = 'Approved';
        customerRegistrationTicket.Billing_Postal_Code_Status__c = 'Approved';
        customerRegistrationTicket.Shipping_Street_Status__c = 'Approved';
        customerRegistrationTicket.Shipping_State_Status__c = 'Approved';
        customerRegistrationTicket.Shipping_Building_Status__c = 'Approved';
        customerRegistrationTicket.Shipping_City_Status__c = 'Approved';
        customerRegistrationTicket.Shipping_Country_Status__c = 'Approved';
        customerRegistrationTicket.Shipping_Postal_Code_Status__c = 'Approved';
        customerRegistrationTicket.BP_Number_Status__c = 'Approved';
        customerRegistrationTicket.Existing_Account__c = true;
        customerRegistrationTicket.Account__c = acc.id;
        update customerRegistrationTicket;

        customerRegistrationTicket.Stage__c = 'Complete';
        update customerRegistrationTicket;

        customerRegistrationTicket.BP_Number__c = '1xx123';
        customerRegistrationTicket.Bizstore_Complete__c = true;
        update customerRegistrationTicket;

        acc.BP_Number__c = '1xx123';
        update acc;

        delete customerRegistrationTicket;
        undelete customerRegistrationTicket;
        Test.stopTest();
    }

    static testmethod void CRUD2(){
        insert new Transaction__c(transactionID__c = 1);

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController=new Trigger_Controller__c(); //Custom Setting for Contact Fields
        TriggerController.Name = 'Trigger_CSRegistrationTicket';
        TriggerController.Is_Active__c = True;
        lstTriggerController.add(TriggerController);

        Trigger_Controller__c TriggerController1=new Trigger_Controller__c();
        TriggerController1.Name = 'Trigger_CSRegistrationDoc';
        TriggerController1.Is_Active__c = True;
        lstTriggerController.add(TriggerController1);

        insert lstTriggerController;

        Account MyAccount=New Account();
        MyAccount.Name='tes';
        MyAccount.BillingStreet='Jl. S Parman';
        MyAccount.BillingCity='Jakarta';
        MyAccount.BillingPostalCode='14460';
        MyAccount.BillingState='DKI Jakarta';
        MyAccount.Organization_Type__c = 'Head Office';
        MyAccount.Type='Competitor';
        MyAccount.OU__c = '1234';
        MyAccount.BP_Number__c = '1x2x3xxx';
        MyAccount.Billing_Address_Province__c = 'jawa tengah';
        MyAccount.Billing_Address_City__c = 'kota surakarta';
        MyAccount.Shipping_Address_Province__c = 'jawa tengah';
        MyAccount.Shipping_Address_City__c = 'kota surakarta' ; 
        insert MyAccount;

        Id newRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('New').getRecordTypeId();

        Customer_Registration_Ticket__c customerRegistrationTicket = new Customer_Registration_Ticket__c();
        customerRegistrationTicket.RecordTypeId = newRecordTypeId;
        customerRegistrationTicket.Company_Type__c = 'existing';
        customerRegistrationTicket.Company_Name__c = 'Test Admin Novando';
        customerRegistrationTicket.Stage__c = 'New';
        customerRegistrationTicket.BP_Number__c = '1x2x3xxx';
        customerRegistrationTicket.Personal_Last_Name__c = 'Test Admin Novando';
        insert customerRegistrationTicket;

        Customer_Registration_Document__c customerRegistrationDocument = new Customer_Registration_Document__c();
        customerRegistrationDocument.Name = 'semenaduk_siup.pdf';
        customerRegistrationDocument.Customer_Registration_Ticket__c = customerRegistrationTicket.id;
        customerRegistrationDocument.Document_Type_Name__c = 'SIUP';
        customerRegistrationDocument.Status__c = 'Approved';
        insert customerRegistrationDocument;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'semenaduk_siup.pdf';
        contentVersion.Document_Type_Name__c = 'SIUP';
        contentVersion.FirstPublishLocationId = customerRegistrationTicket.id;
        contentVersion.PathOnClient = 'semenaduk_siup.pdf';
        contentVersion.VersionData = Blob.valueOf('Test Content');
        contentVersion.IsMajorVersion = true;
        Insert contentVersion;

        Test.startTest();
        customerRegistrationTicket.Stage__c = 'Need To Revise';
        customerRegistrationTicket.Customer_Registration_Ticket_Status__c = 'Approved';
        customerRegistrationTicket.Personal_First_Name_Status__c = 'Approved';
        customerRegistrationTicket.Personal_Last_Name_Status__c = 'Approved';
        customerRegistrationTicket.Personal_Email_Status__c = 'Approved';
        customerRegistrationTicket.Personal_Phone_Status__c = 'Approved';
        customerRegistrationTicket.Industry_Status__c = 'Approved';
        customerRegistrationTicket.BP_Number_Status__c = 'Approved';
        update customerRegistrationTicket;

        customerRegistrationTicket.Stage__c = 'Complete';
        update customerRegistrationTicket;
        delete customerRegistrationTicket;
        undelete customerRegistrationTicket;
        Test.stopTest();
    }

    static testmethod void CRUD3(){
        insert new Transaction__c(transactionID__c = 1);

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController=new Trigger_Controller__c();
        TriggerController.Name = 'Trigger_CSRegistrationTicket';
        TriggerController.Is_Active__c = True;
        lstTriggerController.add(TriggerController);

        Trigger_Controller__c TriggerController1=new Trigger_Controller__c();
        TriggerController1.Name = 'Trigger_CSRegistrationDoc';
        TriggerController1.Is_Active__c = True;
        lstTriggerController.add(TriggerController1);

        insert lstTriggerController;

        Id newRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('New').getRecordTypeId();

        Customer_Registration_Ticket__c customerRegistrationTicket = new Customer_Registration_Ticket__c();
        customerRegistrationTicket.RecordTypeId = newRecordTypeId;
        customerRegistrationTicket.Company_Type__c = 'new';
        customerRegistrationTicket.Company_Name__c = 'Test Admin Novando';
        customerRegistrationTicket.Stage__c = 'New';
        customerRegistrationTicket.BP_Number__c = '111';
        customerRegistrationTicket.Personal_Last_Name__c = 'Test Admin Novando';
        insert customerRegistrationTicket;

        Customer_Registration_Document__c customerRegistrationDocument = new Customer_Registration_Document__c();
        customerRegistrationDocument.Name = 'semenaduk_siup.pdf';
        customerRegistrationDocument.Customer_Registration_Ticket__c = customerRegistrationTicket.id;
        customerRegistrationDocument.Document_Type_Name__c = 'SIUP';
        customerRegistrationDocument.Status__c = 'Rejected';
        customerRegistrationDocument.Complete__c = True;
        insert customerRegistrationDocument;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'semenaduk_siup.pdf';
        contentVersion.Document_Type_Name__c = 'SIUP';
        contentVersion.FirstPublishLocationId = customerRegistrationTicket.id;
        contentVersion.PathOnClient = 'semenaduk_siup.pdf';
        contentVersion.VersionData = Blob.valueOf('Test Content');
        contentVersion.IsMajorVersion = true;
        Insert contentVersion;

        Test.startTest();
        customerRegistrationTicket.Customer_Registration_Ticket_Status__c = 'Rejected';
        customerRegistrationTicket.Company_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Personal_First_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Personal_Last_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Personal_Email_Status__c = 'Rejected';
        customerRegistrationTicket.Personal_Phone_Status__c = 'Rejected';
        customerRegistrationTicket.Industry_Status__c = 'Rejected';
        customerRegistrationTicket.Company_Unique_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Number_Of_Employees_Status__c = 'Rejected';
        customerRegistrationTicket.Company_Group_Status__c = 'Rejected';
        customerRegistrationTicket.Company_Vat_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Npwp_No_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_Street_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_State_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_Building_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_City_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_Country_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_Postal_Code_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_Street_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_State_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_Building_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_City_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_Country_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_Postal_Code_Status__c = 'Rejected';
        customerRegistrationTicket.BP_Number_Status__c = 'Rejected';
        update customerRegistrationTicket;

        customerRegistrationTicket.Stage__c = 'Need To Revise';
        update customerRegistrationTicket;

        customerRegistrationTicket.Stage__c = 'Need To Review';
        update customerRegistrationTicket;

        customerRegistrationTicket.Company_Type__c = 'existing';
        customerRegistrationTicket.Customer_Registration_Ticket_Status__c = 'Rejected';
        customerRegistrationTicket.Company_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Personal_First_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Personal_Last_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Personal_Email_Status__c = 'Rejected';
        customerRegistrationTicket.Personal_Phone_Status__c = 'Rejected';
        customerRegistrationTicket.Industry_Status__c = 'Rejected';
        customerRegistrationTicket.Company_Unique_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Number_Of_Employees_Status__c = 'Rejected';
        customerRegistrationTicket.Company_Group_Status__c = 'Rejected';
        customerRegistrationTicket.Company_Vat_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Npwp_No_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_Street_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_State_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_Building_Name_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_City_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_Country_Status__c = 'Rejected';
        customerRegistrationTicket.Billing_Postal_Code_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_Street_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_State_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_Building_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_City_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_Country_Status__c = 'Rejected';
        customerRegistrationTicket.Shipping_Postal_Code_Status__c = 'Rejected';
        customerRegistrationTicket.BP_Number_Status__c = 'Rejected';
        update customerRegistrationTicket;

        customerRegistrationDocument.Status__c = 'Rejected';
        update customerRegistrationDocument;

        customerRegistrationTicket.Stage__c = 'Need To Revise';
        update customerRegistrationTicket;

        customerRegistrationTicket.Stage__c = 'Need To Review';
        update customerRegistrationTicket;
        delete customerRegistrationTicket;
        undelete customerRegistrationTicket;
        Test.stopTest();
    }

}