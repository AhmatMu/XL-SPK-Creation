@isTest
public class Trigger_ContentDocument_Test {
    static testmethod void CRUD1(){
        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController=new Trigger_Controller__c(); //Custom Setting for Contact Fields
        TriggerController.Name = 'Trigger_ContentDocument';
        TriggerController.Is_Active__c = True;
        lstTriggerController.add(TriggerController);

        Trigger_Controller__c TriggerController1=new Trigger_Controller__c();
        TriggerController1.Name = 'Trigger_ContentDocument1';
        TriggerController1.Is_Active__c = True;
        lstTriggerController.add(TriggerController1);
        insert lstTriggerController;

        Document_Type_PR__c Document_Type_PR = new Document_Type_PR__c();
        Document_Type_PR.Name = 'Customer Email Confirmation';
        Document_Type_PR.Required__c = True;
        Insert Document_Type_PR;

        Id RecordTypeId = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR 4G Access').getRecordTypeId();

        SR_PR_Notification__c SR_PR_Notification_obj = new SR_PR_Notification__c(
            Name = 'PR-2106-015370',
            RecordTypeId = RecordTypeId,
            Notif_Type__c = 'PR',
            Project_Type__c = 'Upgrade',
            Services__c = 'MPLS',
            Project_Name__c = 'MPLS - PT Bank Central Asia Tbk,Jakarta Wisma BCA II',
            Status__c = 'In Progress',
            No_SR_khusus_PR__c = '2106-020235',
            Project_Coordinator_Text__c = '90002952 Abdul Hafidz kasim',
            Capacity_Before__c = '8',
            UOM_before__c = 'Mbps',
            Type_of_Lastmile__c = 'BWA P2P',
            Link_ID__c = '007CL26',
            Capacity_After__c = '100',
            UOM_After__c = 'Mbps',
            CID__c = '12131121'
        );
        insert SR_PR_Notification_obj;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'semenaduk_siup.pdf';
        contentVersion.Document_Type_Name__c = 'Customer Email Confirmation';
        contentVersion.FirstPublishLocationId = SR_PR_Notification_obj.id;
        contentVersion.PathOnClient = 'semenaduk_siup.pdf';
        contentVersion.VersionData = Blob.valueOf('Test Content');
        contentVersion.IsMajorVersion = true;
        Insert contentVersion;

        Test.startTest();
        List<ContentDocument> ContentDocumentList = [select id from ContentDocument];
        Delete ContentDocumentList;
        Undelete ContentDocumentList;
        Test.stopTest();
    }
}