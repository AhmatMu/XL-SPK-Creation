/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 03-09-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   02-22-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest()
public class ProductOnBoarding_Test {
    static testMethod void myUnitTest1() {
        Id recordTypeId_LicensedBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();

        Id recordTypeId_ProjectBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id recordTypeId_SIMCardBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id recordTypeId_SubscriptionBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id recordTypeId_UsageBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        Id recordTypeId_General_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('General').getRecordTypeId();

        Id recordTypeId_LicensedBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();

        Id recordTypeId_ProjectBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id recordTypeId_SIMCardBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id recordTypeId_SubscriptionBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id recordTypeId_UsageBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController1 = new Trigger_Controller__c(
            Name = 'Trigger_NPRTicket',
            Is_Active__c = True
        );
        lstTriggerController.add(TriggerController1);

        Trigger_Controller__c TriggerController2 = new Trigger_Controller__c(
            Name = 'Trigger_ContentVersion_V2',
            Is_Active__c = True
        );
        lstTriggerController.add(TriggerController2);

        insert lstTriggerController;

        New_Product_Registration_Ticket__c NewProductRegistrationTicket_SubscriptionBased = new New_Product_Registration_Ticket__c(
            Name = 'test4',
            Category__c = 'Subscription Based',
            RecordTypeId = recordTypeId_General_ProductOnboarding,
            Sim_Type__c = 'Postpaid',
            Site_Type__c = 'One Site',
            Approval_Status__c = 'Approved',
            Survey_Type__c = 'Auto Complete',
            Project_Type__c = 'Generic',
            Price_Book_Name__c = 'Test New Pricebook2',
            Price_Book_Active__c = true,
            Price_Book_Description__c = 'test',
            IsAgreement__c = false,
            Is_Standard_Price_Book__c = false
        );
        insert NewProductRegistrationTicket_SubscriptionBased;

        NPRTicketProduct__c NPRTicketProduct_LicensedBased = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_LicensedBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Licensed Based',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_LicensedBased;

        NPRTicketProduct__c NPRTicketProduct_ProjectBased_Generic = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_ProjectBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Project Based - Generic',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_ProjectBased_Generic;

        NPRTicketProduct__c NPRTicketProduct_ProjectBased_Bulkshare = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_ProjectBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Project Based - Bulkshare',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_ProjectBased_Bulkshare;

        NPRTicketProduct__c NPRTicketProduct_SIMCardBased_Postpaid = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_SIMCardBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'SIM-Card Based - Postpaid',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_SIMCardBased_Postpaid;

        NPRTicketProduct__c NPRTicketProduct_SIMCardBased_Prepaid = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_SIMCardBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'SIM-Card Based - Prepaid',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_SIMCardBased_Prepaid;

        NPRTicketProduct__c NPRTicketProduct_SIMCardBased_DeviceBundling = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_SIMCardBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'SIM-Card Based - Device Bundling',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_SIMCardBased_DeviceBundling;

        NPRTicketProduct__c NPRTicketProduct_SubscriptionBased = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_SubscriptionBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Subscription Based',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_SubscriptionBased;

        NPRTicketProduct__c NPRTicketProduct_UsageBased = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_UsageBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Usage Based',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_UsageBased;

        NPRTicketDocTempalate__c  NPRTicketDocTempalate = new NPRTicketDocTempalate__c(
            Name = 'BA_TEMPLATE',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            Product_Code__c = 'test1',
            Service_Type__c = 'Newlink'
            //Type__c = ''
        );
        insert NPRTicketDocTempalate;

        Price_Plan__c PricePlan_Rec = new Price_Plan__c(
            Name = 'testPricePlan',
            Full_Name__c = 'testPricePlan'
        );
        insert PricePlan_Rec;

        Group_Service__c GroupService_Rec = new Group_Service__c(
            Name = 'TestGroupService',
            Unique_ID__c = 'TestGroupService',
            Type__c = 'New Revenue',
            Search_Term__c = 'Group Service'
        );
        insert GroupService_Rec;

        Device__c Device_Rec = new Device__c(
            Name = 'testDeviceRelated',
            Brand__c = 'Apple'
        );
        insert Device_Rec;

        AO__c AO_Rec = new AO__c(
            Name = 'testAORelated',
            AO_Code__c = '11123451', 
            Description__c = 'testAORelated',
            Full_Name__c = 'testAORelated'
        );
        insert AO_Rec;

        string csvfile1_valid = 'Id,Name,New_Product_Code__c,Existing_Product_Code__c,Charge_Type__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Group_Service__c,List_Price__c,UoM_Bandwidth__c,Price_Plan_Related__c,SAP_Code__c,Distribution_Channel__c,Device_Related__c,Bandwidth__c,AO_Related__c\n,,Test,Test1,MPLS,Recurring,test,GSM,test,TestGroupService,1000,Mbps,testPricePlan,test,test,testDeviceRelated,100,testAORelated';

        ContentVersion contentVersion_csvfile1_valid = new ContentVersion(
                Title = 'csvfile1_valid.csv',
                PathOnClient = 'csvfile1_valid.csv',
                VersionData = Blob.valueOf(csvfile1_valid),
                IsMajorVersion = true,
                ContentLocation='S'
            );
        insert contentVersion_csvfile1_valid; 

        string csvfile1_invalid = 'Id,Name,New_Product_Code__c,Existing_Product_Code__c,Charge_Type__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Group_Service__c,List_Price__c,UoM_Bandwidth__c,Price_Plan_Related__c,SAP_Code__c,Distribution_Channel__c,Device_Related__c,Bandwidth__c,AO_Related__c\n,,Test,,MPLS123,Recurring,test,GSM,test,TestGroupService,1000,Mbps,testPricePlan,test,test,testDeviceRelated,100,testAORelated';

        ContentVersion ContentVersion_csvfile1_invalid = new ContentVersion(
                Title = 'csvfile1_invalid.csv',
                PathOnClient = 'csvfile1_invalid.csv',
                VersionData = Blob.valueOf(csvfile1_invalid),
                IsMajorVersion = true,
                ContentLocation='S'
            );
        insert ContentVersion_csvfile1_invalid; 

        ContentVersion docs_valid1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion_csvfile1_valid.Id LIMIT 1];

        ContentVersion docs_invalid1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: ContentVersion_csvfile1_invalid.Id LIMIT 1];

        test.starttest();
        ProductOnBoarding_Controller.getNewProductRegistrationTicket(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.GenerateLinkSalesforce();

        ProductOnBoarding_Controller.GetListViewId('New_Product_Registration_Ticket__c', 'All');

        ProductOnBoarding_Controller.updateExistingPricebookTicket(NewProductRegistrationTicket_SubscriptionBased.Id, null);

        ProductOnBoarding_Controller.updateRecordTicketStage2(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.updateRecordTicketStage3(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.updateRecordTicketStage4(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.updateRecordTicketSubscriptionBasedInfo(NewProductRegistrationTicket_SubscriptionBased.Id,null,null);

        ProductOnBoarding_Controller.updateRecordTicketProjectBasedInfo(NewProductRegistrationTicket_SubscriptionBased.Id,null);

        ProductOnBoarding_Controller.updateRecordTicketSIMCardBasedInfo(NewProductRegistrationTicket_SubscriptionBased.Id,null);

        String objectStr = 'New_Product_Registration_Ticket__c';
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objectStr);
        Sobject genericObject = convertType.newSObject();

        ProductOnBoarding_Controller.pickListValueDynamically(genericObject,'Sim_Type__c');

        ProductOnBoarding_Controller.search('New_Product_Registration_Ticket__c','Name','test',null,null);

        String TicketProductList = '[{"NewProductRegistrationTicket":"'+NewProductRegistrationTicket_SubscriptionBased.Id+'","Name":"test123","ExistingProductFamily":null,"NewProductFamily":"test","ExistingProductCode":null,"NewProductCode":"test","GroupService":null}]';

        ProductOnBoarding_Controller.saveRecordTicketProducts(TicketProductList,NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.getNPRTicketProducts(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.getPdfDownloadLink(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.readCSVFile(docs_valid1.ContentDocumentId,NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.readCSVFile(docs_invalid1.ContentDocumentId,NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.pickListValueProductCodeUnique(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.getNPRTicketDocTempalates(NewProductRegistrationTicket_SubscriptionBased.Id);

        String DocTemplateMappingList = '[{"NewProductRegistrationTicket":"a221m000000jgFRAAY","TemplateMappingName":null,"ProductCode":"Test1","ServiceType":"Newlink","DocTemplate":null}]';

        ProductOnBoarding_Controller.saveRecordDocTemplateMappings(DocTemplateMappingList, NewProductRegistrationTicket_SubscriptionBased.Id);

        String selectedRows = '[{"recordId":"'+NPRTicketProduct_UsageBased.Id+'","selected":true}] ';
        ProductOnBoarding_Controller.getSelectedTicketProductList(selectedRows);

        ProductOnBoarding_Controller.getAllFieldAPiNameTicketProductList();
        test.stoptest();
    }

    static testMethod void myUnitTest2() {
        Id recordTypeId_LicensedBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();

        Id recordTypeId_ProjectBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id recordTypeId_SIMCardBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id recordTypeId_SubscriptionBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id recordTypeId_UsageBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        Id recordTypeId_General_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('General').getRecordTypeId();

        Id recordTypeId_LicensedBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();

        Id recordTypeId_ProjectBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id recordTypeId_SIMCardBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id recordTypeId_SubscriptionBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id recordTypeId_UsageBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController1 = new Trigger_Controller__c(
            Name = 'Trigger_NPRTicket',
            Is_Active__c = True
        );
        lstTriggerController.add(TriggerController1);

        Trigger_Controller__c TriggerController2 = new Trigger_Controller__c(
            Name = 'Trigger_ContentVersion_V2',
            Is_Active__c = True
        );
        lstTriggerController.add(TriggerController2);

        insert lstTriggerController;

        New_Product_Registration_Ticket__c NewProductRegistrationTicket_SubscriptionBased = new New_Product_Registration_Ticket__c(
            Name = 'test4',
            Category__c = 'Subscription Based',
            RecordTypeId = recordTypeId_General_ProductOnboarding,
            Sim_Type__c = 'Postpaid',
            Site_Type__c = 'One Site',
            Approval_Status__c = 'Approved',
            Survey_Type__c = 'Auto Complete',
            Project_Type__c = 'Generic',
            Price_Book_Name__c = 'Test New Pricebook2',
            Price_Book_Active__c = true,
            Price_Book_Description__c = 'test',
            IsAgreement__c = false,
            Is_Standard_Price_Book__c = false
        );
        insert NewProductRegistrationTicket_SubscriptionBased;

        NPRTicketProduct__c NPRTicketProduct_LicensedBased = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_LicensedBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Licensed Based',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_LicensedBased;

        NPRTicketProduct__c NPRTicketProduct_ProjectBased_Generic = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_ProjectBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Project Based - Generic',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_ProjectBased_Generic;

        NPRTicketProduct__c NPRTicketProduct_ProjectBased_Bulkshare = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_ProjectBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Project Based - Bulkshare',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_ProjectBased_Bulkshare;

        NPRTicketProduct__c NPRTicketProduct_SIMCardBased_Postpaid = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_SIMCardBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'SIM-Card Based - Postpaid',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_SIMCardBased_Postpaid;

        NPRTicketProduct__c NPRTicketProduct_SIMCardBased_Prepaid = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_SIMCardBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'SIM-Card Based - Prepaid',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_SIMCardBased_Prepaid;

        NPRTicketProduct__c NPRTicketProduct_SIMCardBased_DeviceBundling = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_SIMCardBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'SIM-Card Based - Device Bundling',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_SIMCardBased_DeviceBundling;

        NPRTicketProduct__c NPRTicketProduct_SubscriptionBased = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_SubscriptionBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Subscription Based',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_SubscriptionBased;

        NPRTicketProduct__c NPRTicketProduct_UsageBased = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_UsageBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Usage Based',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true
        );
        insert NPRTicketProduct_UsageBased;

        NPRTicketDocTempalate__c  NPRTicketDocTempalate = new NPRTicketDocTempalate__c(
            Name = 'BA_TEMPLATE',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            Product_Code__c = 'test1',
            Service_Type__c = 'Newlink'
            //Type__c = ''
        );
        insert NPRTicketDocTempalate;

        Price_Plan__c PricePlan_Rec = new Price_Plan__c(
            Name = 'testPricePlan',
            Full_Name__c = 'testPricePlan'
        );
        insert PricePlan_Rec;

        Group_Service__c GroupService_Rec = new Group_Service__c(
            Name = 'TestGroupService',
            Unique_ID__c = 'TestGroupService',
            Type__c = 'New Revenue',
            Search_Term__c = 'Group Service'
        );
        insert GroupService_Rec;

        Device__c Device_Rec = new Device__c(
            Name = 'testDeviceRelated',
            Brand__c = 'Apple'
        );
        insert Device_Rec;

        AO__c AO_Rec = new AO__c(
            Name = 'testAORelated',
            AO_Code__c = '11123451', 
            Description__c = 'testAORelated',
            Full_Name__c = 'testAORelated'
        );
        insert AO_Rec;

        string csvfile1_valid = 'Id,Name,New_Product_Code__c,Existing_Product_Code__c,Charge_Type__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Group_Service__c,List_Price__c,UoM_Bandwidth__c,Price_Plan_Related__c,SAP_Code__c,Distribution_Channel__c,Device_Related__c,Bandwidth__c,AO_Related__c\n65656,dsds,Test,Test1,MPLS,Recurring,test,GSM,test,TestGroupService,1000,Mbps,testPricePlan,test,test,testDeviceRelated,100,testAORelated';

        ContentVersion contentVersion_csvfile1_valid = new ContentVersion(
                Title = 'csvfile1_valid.csv',
                PathOnClient = 'csvfile1_valid.csv',
                VersionData = Blob.valueOf(csvfile1_valid),
                IsMajorVersion = true,
                ContentLocation='S'
            );
        insert contentVersion_csvfile1_valid; 

        string csvfile1_invalid = 'Id,Name,New_Product_Code__c,Existing_Product_Code__c,Charge_Type__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Group_Service__c,List_Price__c,UoM_Bandwidth__c,Price_Plan_Related__c,SAP_Code__c,Distribution_Channel__c,Device_Related__c,Bandwidth__c,AO_Related__c\n656565,dsds,Test,,MPLS123,Recurring,test,GSM,test,TestGroupService,1000,Mbps,testPricePlan,test,test,testDeviceRelated,100,testAORelated';

        ContentVersion ContentVersion_csvfile1_invalid = new ContentVersion(
                Title = 'csvfile1_invalid.csv',
                PathOnClient = 'csvfile1_invalid.csv',
                VersionData = Blob.valueOf(csvfile1_invalid),
                IsMajorVersion = true,
                ContentLocation='S'
            );
        insert ContentVersion_csvfile1_invalid; 

        ContentVersion docs_valid1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion_csvfile1_valid.Id LIMIT 1];

        ContentVersion docs_invalid1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: ContentVersion_csvfile1_invalid.Id LIMIT 1];

        test.starttest();
        ProductOnBoarding_Controller.getNewProductRegistrationTicket(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.GenerateLinkSalesforce();

        ProductOnBoarding_Controller.GetListViewId('New_Product_Registration_Ticket__c', 'All');

        ProductOnBoarding_Controller.updateExistingPricebookTicket(NewProductRegistrationTicket_SubscriptionBased.Id, null);

        ProductOnBoarding_Controller.updateRecordTicketStage2(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.updateRecordTicketStage3(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.updateRecordTicketStage4(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.updateRecordTicketSubscriptionBasedInfo(NewProductRegistrationTicket_SubscriptionBased.Id,null,null);

        ProductOnBoarding_Controller.updateRecordTicketProjectBasedInfo(NewProductRegistrationTicket_SubscriptionBased.Id,null);

        ProductOnBoarding_Controller.updateRecordTicketSIMCardBasedInfo(NewProductRegistrationTicket_SubscriptionBased.Id,null);

        String objectStr = 'New_Product_Registration_Ticket__c';
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objectStr);
        Sobject genericObject = convertType.newSObject();

        ProductOnBoarding_Controller.pickListValueDynamically(genericObject,'Sim_Type__c');

        ProductOnBoarding_Controller.search('New_Product_Registration_Ticket__c','Name','test',null,null);

        String TicketProductList = '[{"NewProductRegistrationTicket":"'+NewProductRegistrationTicket_SubscriptionBased.Id+'","Name":"test123","ExistingProductFamily":null,"NewProductFamily":"test","ExistingProductCode":null,"NewProductCode":"test","GroupService":null}]';

        ProductOnBoarding_Controller.saveRecordTicketProducts(TicketProductList,NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.getNPRTicketProducts(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.getPdfDownloadLink(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.pickListValueProductCodeUnique(NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.getNPRTicketDocTempalates(NewProductRegistrationTicket_SubscriptionBased.Id);

        String DocTemplateMappingList = '[{"NewProductRegistrationTicket":"a221m000000jgFRAAY","TemplateMappingName":null,"ProductCode":"Test1","ServiceType":"Newlink","DocTemplate":null}]';

        ProductOnBoarding_Controller.saveRecordDocTemplateMappings(DocTemplateMappingList, NewProductRegistrationTicket_SubscriptionBased.Id);

        String selectedRows = '[{"recordId":"'+NPRTicketProduct_UsageBased.Id+'","selected":true}] ';
        ProductOnBoarding_Controller.getSelectedTicketProductList(selectedRows);

        ProductOnBoarding_Controller.getAllFieldAPiNameTicketProductList();
        
        ProductOnBoarding_Controller.readCSVFileUpdate(docs_valid1.ContentDocumentId,NewProductRegistrationTicket_SubscriptionBased.Id);

        ProductOnBoarding_Controller.readCSVFileUpdate(docs_invalid1.ContentDocumentId,NewProductRegistrationTicket_SubscriptionBased.Id);

        test.stoptest();
    }
}