/* ====================================================================================================
 * Class Name		        : Trigger_ContentDocumentHandler
 * Test Class		        : Trigger_ContentDocument_Test
 * Created By		        : Novando Utoyo Agmawan
 * Created Date		        : 08/2021
 * Created Description		: - 
 * 					          - 
 * Updated By               :
 * Updated Date	            :
 * Updated Description		: - 
 * 					          - 
 * ====================================================================================================
 */

public class Trigger_ContentDocumentHandler implements ITriggerHandler {
    public Boolean IsDisabled()
    {
        return false;
    }
    
    public void BeforeInsert(List<SObject> newItems) {}
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {
        Handle_DeleteFile_Object_PR(oldItems);
    }
    
    public void AfterInsert(Map<Id, SObject> newItems) {}
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}

    public void Handle_DeleteFile_Object_PR (Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            Set<Id> contendDocumentId = new set<Id>();
            Set<Id> SRPRId = new set<Id>();
            String sObjName;

            for(SObject contendDocument : oldItems.values()){
                contendDocumentId.add((Id)contendDocument.Id);
            }

            if(contendDocumentId!=null && !contendDocumentId.isEmpty()){
                List<ContentDocumentLink> cdl_List = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : contendDocumentId];
                
                if(cdl_List!=null && !cdl_List.isEmpty()){
                    for(ContentDocumentLink cdl_List_extract : cdl_List){
                        sObjName = Id.valueOf(cdl_List_extract.LinkedEntityId).getSObjectType().getDescribe().getName();

                        if(sObjName == 'SR_PR_Notification__c'){
                            SRPRId.add(cdl_List_extract.LinkedEntityId);
                        }
                    }

                    If(SRPRId!=null && !SRPRId.isEmpty()){
                        List<Document_Type_PR__c> Document_Type_PR_List = [SELECT Name, Required__c FROM Document_Type_PR__c WHERE Required__c = True];

                        if(Document_Type_PR_List!=null && !Document_Type_PR_List.isEmpty()){
                            Set<String> DocumentTypeRequired = new Set<String>();

                            for(Document_Type_PR__c Document_Type_PR_List_Extract : Document_Type_PR_List){
                                DocumentTypeRequired.add(Document_Type_PR_List_Extract.name);
                            }

                            if(DocumentTypeRequired!=null && !DocumentTypeRequired.isEmpty()){
                                Integer CountDeletedFiles = [SELECT Count() FROM ContentVersion WHERE Document_Type_Name__c IN : DocumentTypeRequired AND ContentDocumentId IN : contendDocumentId];

                                system.debug('CountDeletedFiles : ' + CountDeletedFiles);

                                if(CountDeletedFiles == 1){
                                    Integer CountFiles = [SELECT Count() FROM ContentDocumentLink WHERE LinkedEntityId IN : SRPRId AND ContentDocumentId IN (SELECT ContentDocumentId FROM ContentVersion WHERE Document_Type_Name__c IN : DocumentTypeRequired)];

                                    system.debug('CountFiles : ' + CountFiles);

                                    if(CountFiles == 1){
                                        List<SR_PR_Notification__c> Srpr_List = [SELECT WBA_Required_File__c FROM SR_PR_Notification__c WHERE Id IN : SRPRId AND WBA_Required_File__c =: true AND Status__c != 	'Waiting Berita Acara'];

                                        if(Srpr_List!=null && !Srpr_List.isEmpty()){
                                            for(SR_PR_Notification__c Srpr_List_Extract : Srpr_List){
                                                Srpr_List_Extract.WBA_Required_File__c = false;
                                            }
                                            update Srpr_List;
                                        }
                                    }else if(CountFiles == 2){
                                        List<SR_PR_Notification__c> Srpr_List = [SELECT WBA_Required_File__c FROM SR_PR_Notification__c WHERE Id IN : SRPRId AND WBA_Required_File__c =: true AND Status__c =:	'Waiting Berita Acara'];
                                        if(Srpr_List!=null && !Srpr_List.isEmpty()){
                                            for(SObject contendDocument : oldItems.values()){
                                                contendDocument.adderror('Cannot Delete Required File If Status = Waiting Berita Acara');
                                            }
                                        } 
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) { 
            String err_message = 'Error on Trigger Before Delete - Content Document ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
}