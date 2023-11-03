/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-27-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   02-22-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest()
public class Trigger_NPRTicketHandler_Test {
    static testMethod void myUnitTest1() {
        Id recordTypeId_LicensedBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();

        Id recordTypeId_ProjectBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id recordTypeId_SIMCardBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id recordTypeId_SubscriptionBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id recordTypeId_UsageBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        Id recordTypeId_General_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('General').getRecordTypeId();

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController1 = new Trigger_Controller__c(
            Name = 'Trigger_NPRTicket',
            Is_Active__c = True
        );
        lstTriggerController.add(TriggerController1);

        Trigger_Controller__c TriggerController2 = new Trigger_Controller__c(
            Name = 'Trigger_NPRTicket2',
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

        test.starttest();
        NewProductRegistrationTicket_SubscriptionBased.Move_Stage_From_Trigger__c = true;
        update NewProductRegistrationTicket_SubscriptionBased;

        NewProductRegistrationTicket_SubscriptionBased.Approval_Status__c = 'Inreview';
        update NewProductRegistrationTicket_SubscriptionBased;

        NewProductRegistrationTicket_SubscriptionBased.Approval_Status__c = 'Approved';
        update NewProductRegistrationTicket_SubscriptionBased;

        NewProductRegistrationTicket_SubscriptionBased.Approval_Status__c = 'Rejected';
        update NewProductRegistrationTicket_SubscriptionBased;

        NewProductRegistrationTicket_SubscriptionBased.Resend_Email__c = true;
        update NewProductRegistrationTicket_SubscriptionBased;

        delete NewProductRegistrationTicket_SubscriptionBased;
        undelete NewProductRegistrationTicket_SubscriptionBased;
        test.stoptest();
    }
}