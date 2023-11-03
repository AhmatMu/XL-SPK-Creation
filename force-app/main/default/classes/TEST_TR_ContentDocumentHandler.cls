@isTest
public class TEST_TR_ContentDocumentHandler {
	static testmethod void UpdateOpportunityFlag(){
   		Test.startTest();
        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();
        Trigger_Controller__c TriggerController=new Trigger_Controller__c(); //Custom Setting for Contact Fields
        TriggerController.Name = 'Trigger_ContentDocument';
        TriggerController.Is_Active__c = True;
        lstTriggerController.add(TriggerController);
        
        Trigger_Controller__c TriggerController1=new Trigger_Controller__c(); //Custom Setting for Contact Fields
        TriggerController1.Name = 'Trigger_ContentDocument1';
        TriggerController1.Is_Active__c = True;
        lstTriggerController.add(TriggerController1);
        insert lstTriggerController;
        
        list<ContentDocumentLink_queryString__c	> ContentDocumentLink_queryString=new list<ContentDocumentLink_queryString__c	>();
        ContentDocumentLink_queryString__c	 TriggerController2=new ContentDocumentLink_queryString__c(); //Custom Setting for Contact Fields
        TriggerController2.Name = 'Condition_OppDoc';
        TriggerController2.String_Condition__c = 'ContentDocument.title like \'%BA%\' or ContentDocument.title like \'%Berita Acara%\' or ContentDocument.title like \'%Acceptance Letter%\'';
        ContentDocumentLink_queryString.add(TriggerController2);
        insert ContentDocumentLink_queryString;

        //create an Opportuntiy 
        Id opportunityId ;
        Id newOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Digital Advertising').getRecordTypeId();
        Opportunity Opp = new Opportunity();
            Opp.RecordTypeId = newOppRecordTypeId;
            Opp.Name = 'Test Admin ahmat';
            opp.BA_Doc_is_uploaded__c = true;
            opp.Remark__c = 'Approved';
            opp.CloseDate = date.today();
            opp.Campaign_Start_Date__c = date.today();
            opp.Campaign_end_Date__c = date.today();
        insert Opp;
        system.debug('======= opp'+ opp);
        
       ContentVersion varContentDocument = new ContentVersion();
        varContentDocument.Title = 'Berita Acara';
        varContentDocument.PathOnClient = 'Berita Acara.pdf';
        varContentDocument.FirstPublishLocationId = opp.Id;
        varContentDocument.VersionData = Blob.valueOf('Test Content');
        varContentDocument.IsMajorVersion = true;
        Insert varContentDocument;
        system.debug('====== varContentDocument' +varContentDocument);
        
        system.debug('====== varContentDocument.ContentDocumentId' +varContentDocument.ContentDocumentId);
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        system.debug('document =================' + documents);

       
        
        if(documents.size()>0){
            system.debug('document' + documents);
       	 	delete documents;               
        }
        
        
        Test.stopTest();
    	}
	
	}