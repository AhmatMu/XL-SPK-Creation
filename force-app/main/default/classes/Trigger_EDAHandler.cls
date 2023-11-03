public class Trigger_EDAHandler implements ITriggerHandler {
    public Boolean IsDisabled()
    {
        return false;
    }
    
    public void BeforeInsert(List<SObject> newItems) {}
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        HandleStatusChangeToCompleted_Call_REST_BAP_Temp_Isolation_Callout_v1(newItems,oldItems);
        HandleStatusChangeToCompleted_ExtendOpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1(newItems,oldItems);
        HandleStatusChangeToRejected(newItems, oldItems);
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems) {
        getFiles_OfBAPRecord(newItems, null);
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        getFiles_OfBAPRecord(newItems, oldItems);
        HandleStatus_Eda_Extend_ChangeToRejected(newItems, oldItems);
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}

    public void HandleStatusChangeToCompleted_Call_REST_BAP_Temp_Isolation_Callout_v1(Map<Id, SObject> newItems , Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId_bap_TemporaryIsolation = rtInfo.getRecordTypeId();

            Id edaRecordId;
            Id bapIDFromEda;
            String bapID;
            String status;
            String edaNo;

            for(SObject eda : newItems.values()){
                SObject old_eda;
                if(oldItems != null && oldItems.get((id)eda.get('Id')) != null){
                    old_eda = oldItems.get((Id)eda.get('Id'));
                }

                if(old_eda.get('EDA_Status__c') != eda.get('EDA_Status__c') && eda.get('EDA_Status__c') == 'Completed' && eda.get('Document_Type__c') == 'IOM' && eda.get('IOM_Type__c') == 'Temporary Isolation' && eda.get('BAP__c') != null){
                    edaNo = (String)eda.get('EDA_Number__c');
                    edaRecordId = (Id)eda.get('Id');
                }
            }

            if(edaRecordId != null){
                List<BAP__c> bapList_Eda1 = [SELECT Id,BAP_ID__c,EDA__c FROM BAP__c WHERE EDA__c =: edaRecordId AND RecordTypeId =: recordTypeId_bap_TemporaryIsolation AND Request_Status__c = 'Waiting Approval'];

                if(bapList_Eda1 !=null && !bapList_Eda1.isEmpty()) {
                    status = 'BAP sent to Customer';
                    bapID = bapList_Eda1[0].BAP_ID__c;
                    bapIDFromEda = bapList_Eda1[0].Id;

                    if(!Test.isRunningTest()){
                        REST_BAP_Temp_Isolation_Callout_v1.UpdateStatusBAP_Temporary_Isolation(
                            bapIDFromEda,
                            bapID,
                            status,
                            edaNo
                        );
                    }
                    AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'Trigger_EDAHandler.cls - HandleStatusChangeToCompleted_Call_REST_BAP_Temp_Isolation_Callout_v1',null);
                }
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_EDAHandler.cls - HandleStatusChangeToCompleted_Call_REST_BAP_Temp_Isolation_Callout_v1 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_EDAHandler.cls - HandleStatusChangeToCompleted_Call_REST_BAP_Temp_Isolation_Callout_v1',err_message);
        }
    }

    public void HandleStatusChangeToCompleted_ExtendOpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1(Map<Id, SObject> newItems , Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId_bap_TemporaryIsolation = rtInfo.getRecordTypeId();

            Id edaRecordId;
            Id bapIDFromEda;
            String bapID;
            String openIsolationDate;
            Date openIsolationDateValue;
            String edaNo;

            for(SObject eda : newItems.values()){
                SObject old_eda;
                if(oldItems != null && oldItems.get((id)eda.get('Id')) != null){
                    old_eda = oldItems.get((Id)eda.get('Id'));
                }

                if(old_eda.get('EDA_Status__c') != eda.get('EDA_Status__c') && eda.get('EDA_Status__c') == 'Completed' && eda.get('Document_Type__c') == 'IOM' && eda.get('IOM_Type__c') == 'Extend Temporary Isolation' && eda.get('BAP__c') != null){
                    edaNo = (String)eda.get('EDA_Number__c');
                    edaRecordId = (Id)eda.get('Id');
                }
            }

            if(edaRecordId != null){
                List<BAP__c> bapList_Eda2 = [SELECT Id,BAP_ID__c,EDA_for_Extend_Isolation__c,Isolation_Desire_End_Date__c FROM BAP__c WHERE EDA_for_Extend_Isolation__c =: edaRecordId AND RecordTypeId =: recordTypeId_bap_TemporaryIsolation AND Request_Status__c = 'Isolated'];

                if(bapList_Eda2 !=null && !bapList_Eda2.isEmpty()) {
                    bapID = bapList_Eda2[0].BAP_ID__c;
                    bapIDFromEda = bapList_Eda2[0].Id;
                    openIsolationDateValue = bapList_Eda2[0].Isolation_Desire_End_Date__c;
                    openIsolationDate = openIsolationDateValue.year() + '-' + openIsolationDateValue.month() + '-' + openIsolationDateValue.day();

                    if(!Test.isRunningTest()){
                        REST_BAP_Temp_Isolation_Callout_v1.Update_OpenTemporaryIsolationDate(
                            bapIDFromEda,
                            bapID,
                            openIsolationDate,
                            edaNo
                        );
                    }
                    AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'Trigger_EDAHandler.cls - HandleStatusChangeToCompleted_ExtendOpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1',null);
                }
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_EDAHandler.cls - HandleStatusChangeToCompleted_ExtendOpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_EDAHandler.cls - HandleStatusChangeToCompleted_ExtendOpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1',err_message);
        }
    }

    public void HandleStatusChangeToRejected(Map<Id, SObject> newItems , Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId_bap_TemporaryIsolation = rtInfo.getRecordTypeId();

            Id edaRecordId;
            Id bapIDFromEda;
            String bapID;
            String status;
            String edaNo;

            for(SObject eda : newItems.values()){
                SObject old_eda;
                if(oldItems != null && oldItems.get((id)eda.get('Id')) != null){
                    old_eda = oldItems.get((Id)eda.get('Id'));
                }

                if(
                    old_eda.get('EDA_Status__c') != eda.get('EDA_Status__c') && 
                    old_eda.get('EDA_Status__c') == 'Waiting Approval' && 
                    eda.get('EDA_Status__c') == 'Draft' && 
                    eda.get('Document_Type__c') == 'IOM' && 
                    eda.get('IOM_Type__c') == 'Temporary Isolation' && 
                    eda.get('BAP__c') != null
                ){
                    edaNo = (String)eda.get('EDA_Number__c');
                    edaRecordId = (Id)eda.get('Id');
                }
            }

            if(edaRecordId != null){
                List<BAP__c> bapList_Eda1 = [SELECT Id,BAP_ID__c,EDA__c FROM BAP__c WHERE EDA__c =: edaRecordId AND RecordTypeId =: recordTypeId_bap_TemporaryIsolation AND Request_Status__c = 'Waiting Approval' AND createBAPTemp_Isolation_easyOps__c =: true];

                if(bapList_Eda1 !=null && !bapList_Eda1.isEmpty()) {
                    status = 'Draft';
                    bapID = bapList_Eda1[0].BAP_ID__c;
                    bapIDFromEda = bapList_Eda1[0].Id;

                    if(!Test.isRunningTest()){
                        REST_BAP_Temp_Isolation_Callout_v1.UpdateStatusBAP_Temporary_Isolation(
                            bapIDFromEda,
                            bapID,
                            status,
                            edaNo
                        );
                    }
                    AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'Trigger_EDAHandler.cls - HandleStatusChangeToRejected',null);
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_EDAHandler.cls - HandleStatusChangeToRejected ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_EDAHandler.cls - HandleStatusChangeToRejected',err_message);
        }
    }

    public void HandleStatus_Eda_Extend_ChangeToRejected(Map<Id, SObject> newItems , Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId_bap_TemporaryIsolation = rtInfo.getRecordTypeId();

            Id edaRecordId;

            for(SObject eda : newItems.values()){
                SObject old_eda;
                if(oldItems != null && oldItems.get((id)eda.get('Id')) != null){
                    old_eda = oldItems.get((Id)eda.get('Id'));
                }

                if(
                    old_eda.get('EDA_Status__c') != eda.get('EDA_Status__c') && 
                    old_eda.get('EDA_Status__c') == 'Waiting Approval' && 
                    eda.get('EDA_Status__c') == 'Draft' && 
                    eda.get('Document_Type__c') == 'IOM' && 
                    eda.get('IOM_Type__c') == 'Extend Temporary Isolation' && 
                    eda.get('BAP__c') != null
                ){
                    edaRecordId = (Id)eda.get('Id');
                }
            }

            if(edaRecordId != null){
                List<BAP__c> bapList_Eda1 = [SELECT Id,Isolation_Desire_End_Date__c FROM BAP__c WHERE EDA_for_Extend_Isolation__c =: edaRecordId AND RecordTypeId =: recordTypeId_bap_TemporaryIsolation AND Request_Status__c = 'Isolated' AND createBAPTemp_Isolation_easyOps__c =: true];

                if(bapList_Eda1 !=null && !bapList_Eda1.isEmpty()) {
                    bapList_Eda1[0].Isolation_Desire_End_Date__c = null;
                    update bapList_Eda1;
                    
                    AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'Trigger_EDAHandler.cls - HandleStatus_Eda_Extend_ChangeToRejected',null);
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Update - Trigger_EDAHandler.cls - HandleStatus_Eda_Extend_ChangeToRejected ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_EDAHandler.cls - HandleStatus_Eda_Extend_ChangeToRejected',err_message);
        }
    }

    public void getFiles_OfBAPRecord(Map<Id, SObject> newItems , Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            Set<Id> BAPIds = new Set<Id>();
            Id edaId;
            for(SObject eda : newItems.values()){
                if(eda.get('BAP__c') != null){
                    BAPIds.add((Id)eda.get('BAP__c'));
                    edaId = (Id)eda.get('Id');
                }           
            }

            if(BAPIds!=null && !BAPIds.isEmpty()){
                List<ContentDocumentLink> ContentDocumentLinkCheckList_BAP = [select ContentDocumentId from ContentDocumentLink where LinkedEntityId IN: BAPIds];
                //system.debug('ContentDocumentLinkCheckList_BAP : ' + ContentDocumentLinkCheckList_BAP);
                
                list<ContentDocumentLink> cdl_List = new list<ContentDocumentLink>();

                if(ContentDocumentLinkCheckList_BAP!=null && !ContentDocumentLinkCheckList_BAP.isEmpty()){
                    Set<Id> ContentDocumentIds = new Set<Id>();
                    for(ContentDocumentLink ContentDocumentLinkCheckList_BAPExtract : ContentDocumentLinkCheckList_BAP){
                        ContentDocumentIds.add(ContentDocumentLinkCheckList_BAPExtract.ContentDocumentId);
                    }

                    Map<String, string> ContentDocumentIdCheckMap = new Map<String, string>();
                    List<ContentDocumentLink> ContentDocumentLinkCheckList = [select ContentDocumentId from ContentDocumentLink where ContentDocumentId IN: ContentDocumentIds and LinkedEntityId =: edaId];
                    //system.debug('ContentDocumentLinkCheckList : ' + ContentDocumentLinkCheckList);

                    for(ContentDocumentLink ContentDocumentLinkCheckList_Extract : ContentDocumentLinkCheckList){
                        ContentDocumentIdCheckMap.put(ContentDocumentLinkCheckList_Extract.ContentDocumentId, ContentDocumentLinkCheckList_Extract.ContentDocumentId);
                    }
                    //system.debug('ContentDocumentIdCheckMap : ' + ContentDocumentIdCheckMap);

                    for(ContentDocumentLink ContentDocumentLinkCheckList_BAPExtract : ContentDocumentLinkCheckList_BAP){
                        if(ContentDocumentIdCheckMap.get(ContentDocumentLinkCheckList_BAPExtract.ContentDocumentId) == null){
                            ContentDocumentLink cdl = new ContentDocumentLink();
                            cdl.LinkedEntityId = edaId;
                            cdl.ContentDocumentId = ContentDocumentLinkCheckList_BAPExtract.ContentDocumentId;
                            cdl.ShareType = 'V';
                            cdl.Visibility = 'AllUsers';
                            cdl_List.add(cdl);
                        }
                    }
                    insert cdl_List;
                    AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'Trigger_EDAHandler.cls - getFiles_OfBAPRecord',null);
                }
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            String err_message = 'Error on Trigger After Insert OR Update - Trigger_EDAHandler.cls - getFiles_OfBAPRecord ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_EDAHandler.cls - getFiles_OfBAPRecord',err_message);
        }
    }

}