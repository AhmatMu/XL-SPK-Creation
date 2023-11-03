trigger Trigger_ContentDocumentLink on ContentDocumentLink (after insert, before delete) {

    //ContentDocumentLinkTriggerHandler handler = new ContentDocumentLinkTriggerHandler();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            // Check Upload File Type
            //handler.isSharingAllowed(Trigger.new);
            
            // insert file data into Opportunity Attachments object 
            List<Opportunity_Attachment__c> oas = new List<Opportunity_Attachment__c>();
            for (ContentDocumentLink cdl: trigger.new) {
                string LinkedEntityId = cdl.LinkedEntityId;
                if (LinkedEntityId.substring(0, 3) =='006'){      //---only for opporttunity          
                     Opportunity_Attachment__c oa = new  Opportunity_Attachment__c();
                     oa.ContentDocumentLink_ID__c = cdl.id;
                     oa.ContentVersion_ID__c = ''; //todo: find this value with query
                     oa.EasyOps_ID__c = '';
                     oa.Opportunity__c  = cdl.LinkedEntityId;
                     oa.ContentDocumentId__c = cdl.ContentDocumentId;
                     oa.Status__c = 'Uploaded';
                     
                     string cdlID = cdl.ID;
                     ContentDocumentLink tmpCdl = [select id , ContentDocument.title from ContentDocumentLink where id= :cdlID];
                     oa.Title__c = tmpCdl.ContentDocument.title;
                     system.debug('================= cdl.ContentDocument.title :' + tmpCdl.ContentDocument.title );
                     oas.add (oa);
                 }
            }
            insert oas;

            // --> START Updating by Vando 22 Januari 2021
            // insert files data into eda from BAP
            list<ContentDocumentLink> cdl_List = new list<ContentDocumentLink>();
            for (ContentDocumentLink cdl: trigger.new) {
                String LinkedEntityIdFormatBAP = cdl.LinkedEntityId;
                if(LinkedEntityIdFormatBAP.substring(0, 3) =='a09'){ //---only for BAP  
                    List<EDA__c> EdaList = [SELECT Id, BAP__c FROM EDA__c WHERE BAP__c =:LinkedEntityIdFormatBAP];

                    for(EDA__c EdaListExtract : EdaList){
                        ContentDocumentLink cdl2 = new ContentDocumentLink();
                        cdl2.LinkedEntityId = EdaListExtract.Id;
                        cdl2.ContentDocumentId = cdl.ContentDocumentId;
                        cdl2.ShareType = 'V';
                        cdl2.Visibility = 'AllUsers';
                        cdl_List.add(cdl2);
                    }
                }
            }
            insert cdl_List;
            // --> END Updating by Vando 22 Januari 2021

        }
        
    }
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            for (ContentDocumentLink cdl: trigger.old) {
                
                string LinkedEntityId = cdl.LinkedEntityId;
                if (LinkedEntityId.substring(0, 3) =='006'){  //---only for opporttunity          
                    string ContentDocumentLinkID = cdl.id;
                    List<Opportunity_Attachment__c> oas = [select id from Opportunity_Attachment__c
                        where ContentDocumentLink_ID__c=:ContentDocumentLinkID ];
                    
                    delete oas;
                }
            }
        }
    
    }
}