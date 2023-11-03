@isTest
public class TEST_TR_ContentVersionHandler_V2Test {
	
    static testmethod void CRUD1(){
        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

   /*     Trigger_Controller__c TriggerController=new Trigger_Controller__c(); //Custom Setting for Contact Fields
        TriggerController.Name = 'Trigger_ContentVersion';
        TriggerController.Is_Active__c = false;
        lstTriggerController.add(TriggerController);
*/
        Trigger_Controller__c TriggerController1=new Trigger_Controller__c();
        TriggerController1.Name = 'Trigger_ContentVersion_v2';
        TriggerController1.Is_Active__c = True;
        lstTriggerController.add(TriggerController1);
        /*
        Trigger_Controller__c TriggerController2=new Trigger_Controller__c();
        TriggerController2.Name = 'Trigger_ContentVersion3';
        TriggerController2.Is_Active__c = True;
        lstTriggerController.add(TriggerController2);
*/
        insert lstTriggerController;

        Id newRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('New').getRecordTypeId();
            Customer_Registration_Ticket__c customerRegistrationTicket = new Customer_Registration_Ticket__c();
            customerRegistrationTicket.RecordTypeId = newRecordTypeId;
            customerRegistrationTicket.Company_Type__c = 'new';
            customerRegistrationTicket.Company_Name__c = 'Test Admin Novando';
        insert customerRegistrationTicket;

            Customer_Registration_Document__c customerRegistrationDocument = new Customer_Registration_Document__c();
            customerRegistrationDocument.Name = 'semenaduk_siup.pdf';
            customerRegistrationDocument.Customer_Registration_Ticket__c = customerRegistrationTicket.id;
            customerRegistrationDocument.Document_Type_Name__c = 'SIUP';
        insert customerRegistrationDocument;

            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'semenaduk_siup.pdf';
            contentVersion.Document_Type_Name__c = 'SIUP';
            contentVersion.FirstPublishLocationId = customerRegistrationTicket.id;
            contentVersion.PathOnClient = 'semenaduk_siup.pdf';
            contentVersion.VersionData = Blob.valueOf('Test Content');
            contentVersion.IsMajorVersion = true;
        Insert contentVersion;
    
            ContentVersion contentVersion2 = new ContentVersion();
            contentVersion2.Title = 'semenaduk_siup.pdf';
            contentVersion2.Document_Type_Name__c = 'SIUP';
            contentVersion2.FirstPublishLocationId = customerRegistrationTicket.id;
            contentVersion2.PathOnClient = 'semenaduk_siup.pdf';
            contentVersion2.VersionData = Blob.valueOf('Test Content');
            contentVersion2.IsMajorVersion = true;
        Insert contentVersion2;

        Test.startTest();
            contentVersion2.Title = 'semenaduk_siup1.pdf';
            update contentVersion2;
        Test.stopTest();
		
        Id opportunityId ;
        Id newOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Project Bulkshare').getRecordTypeId();
            Opportunity Opp = new Opportunity();
                Opp.RecordTypeId = newOppRecordTypeId;
                Opp.Name = 'Test Admin ahmat';
                opp.BA_Doc_is_uploaded__c = false;
                opp.Remark__c = 'Approved';
                opp.RecordTypeId = newOppRecordTypeId;
                opp.CloseDate = date.today();
                opp.Campaign_Start_Date__c = date.today();
                opp.Campaign_end_Date__c = date.today();
        insert Opp;
             
        ContentVersion contentVersion3 = new ContentVersion();
            contentVersion3.Title = 'Berita Acara.pdf';
            contentVersion3.PathOnClient = 'Berita Acara.pdf';
            contentVersion3.FirstPublishLocationId = opp.Id;
            contentVersion3.VersionData = Blob.valueOf('Test Content');
            contentVersion3.IsMajorVersion = true;
        Insert contentVersion3;
        
       		opp.BA_Doc_is_uploaded__c = true;
        update opp;
        
    }

}