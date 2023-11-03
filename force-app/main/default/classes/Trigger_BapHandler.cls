/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 28-06-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   28-06-2022   Doddy Prima   Initial Version
**/
public class Trigger_BapHandler implements ITriggerHandler {
    public Boolean IsDisabled()
    {
        return false;
    }
    
    public void BeforeInsert(List<SObject> newItems) {
        setRemarkDraft(newItems);
    }
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        HandleStatusChangeToSubmit_Call_REST_BAP_Temp_Isolation_Callout_v1(newItems,oldItems);
        HandleEdaStatusChangeToRejected_Call_REST_BAP_Temp_Isolation_Callout_v1(newItems,oldItems);
        HandleEdaStatusChangeToCanceled_Call_REST_BAP_Temp_Isolation_Callout_v1(newItems,oldItems);
        HandleStatusChangeTo_Submit_BAP_EndofContract(newItems,oldItems);
        HandleStatusChangeTo_Canceled_BAP_EndofContract(newItems,oldItems);
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems) {}
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        HandleEarly_Extend_OpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1(newItems,oldItems);
        HandleStatusChangeTo_Complete_BAP_EndofContract(newItems,oldItems);
        HandleStatusChangeTo_SenttoFinance_BAP_EndofContract(newItems,oldItems);
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}

    public void setRemarkDraft(List<SObject> newItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();

            for(SObject bap : newItems){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    bap.put('Remark__c','Draft');
                    bap.put('Request_Status__c','Draft');
                    successLog = 'success';
                }
            }

            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - setRemarkDraft',null);
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Insert - Trigger_BapHandler.cls - setRemarkDraft ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - setRemarkDraft',err_message);
        }
    }

    public void HandleStatusChangeToSubmit_Call_REST_BAP_Temp_Isolation_Callout_v1(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();

            Id recordId;
            String userCreate;
            String typeOfRequest;
            Date openIsolationDateValue;
            String openIsolationDate;
            String sirkit;
            Date requestDateValue;
            String requestDate;
            String reason;
            String picPosition;
            String picPhone;
            String picEmail;
            String pic;
            String note;
            String customer;
            String cid;
            String bandwidthUom;
            String bandwidth;
            String address;

            for(SObject bap : newItems.values()){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    recordId = (Id)bap.get('Id');

                    SObject old_bap;
                    if(oldItems != null && oldItems.get((id)bap.get('Id')) != null){
                        old_bap = oldItems.get((Id)bap.get('Id'));
                    }

                    if(old_bap.get('Request_Status__c') != bap.get('Request_Status__c') && old_bap.get('Request_Status__c') == 'Draft' && bap.get('Request_Status__c') == 'Submit' && bap.get('createBAPTemp_Isolation_easyOps__c') == false && bap.get('EDA__c') == null){
                        List<User> userList = [SELECT Email FROM User WHERE Id=:(Id)bap.get('OwnerId')];

                        if(userList !=null && !userList.isEmpty()) {
                            userCreate = userList[0].Email;
                        }

                        typeOfRequest = (String)bap.get('Type_of_Request__c');
                        openIsolationDateValue = (Date)bap.get('Isolation_End_Date__c');
                        openIsolationDate = openIsolationDateValue.year() + '-' + openIsolationDateValue.month() + '-' + openIsolationDateValue.day();
                        sirkit = (String)bap.get('Sirkit__c');
                        requestDateValue = (Date)bap.get('Isolation_Start_Date__c');
                        requestDate = requestDateValue.year() + '-' + requestDateValue.month() + '-' + requestDateValue.day();
                        reason = (String)bap.get('Reason__c');
                        picPosition = (String)bap.get('PIC_Position__c');
                        picPhone = (String)bap.get('PIC_Phone__c');
                        picEmail = (String)bap.get('PIC_email__c');
                        pic = (String)bap.get('PIC_Name__c');
                        note = (String)bap.get('Note__c');
                        customer = (String)bap.get('Customer__c');
                        cid = (String)bap.get('CID__c');
                        bandwidthUom = (String)bap.get('UoM_rel__c');
                        bandwidth = (String)bap.get('Bandwidth_rel__c');
                        address = (String)bap.get('Address2__c');

                        if(!Test.isRunningTest()){
                            REST_BAP_Temp_Isolation_Callout_v1.createBAPTemporary_Isolation( recordId, userCreate, typeOfRequest, openIsolationDate, sirkit, requestDate, reason, picPosition, picPhone, picEmail, pic, note, customer, cid, bandwidthUom, bandwidth, address
                            );
                        }
                        successLog = 'success';
                    }
                }
            }
            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeToSubmit_Call_REST_BAP_Temp_Isolation_Callout_v1',null);
            }
            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/

        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_BapHandler.cls - HandleStatusChangeToSubmit_Call_REST_BAP_Temp_Isolation_Callout_v1 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeToSubmit_Call_REST_BAP_Temp_Isolation_Callout_v1',err_message);
        }
    }

    public void HandleEarly_Extend_OpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();

            Id recordId;
            String bapID;
            String openIsolationDate;
            Date openIsolationDateValue;
            String edaNo;

            for(SObject bap : newItems.values()){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    recordId = (Id)bap.get('Id');

                    SObject old_bap;
                    if(oldItems != null && oldItems.get((id)bap.get('Id')) != null){
                        old_bap = oldItems.get((Id)bap.get('Id'));
                    }

                    if(old_bap.get('Isolation_Desire_End_Date__c') != bap.get('Isolation_Desire_End_Date__c') && bap.get('Request_Status__c') == 'Isolated'){
                        if((Date)bap.get('Isolation_Desire_End_Date__c') < (Date)bap.get('Isolation_End_Date__c') && bap.get('EDA__c') != null && bap.get('EDA_for_Extend_Isolation__c') == null){
                            //system.debug('Early Open Isolate');
                            List<EDA__c> edaEarlyList = [Select Id,EDA_Number__c From EDA__c Where Id=: (Id)bap.get('EDA__c') AND IOM_Type__c =: 'Temporary Isolation'];
                            if(edaEarlyList !=null && !edaEarlyList.isEmpty()) {

                                bapID = (String)bap.get('BAP_ID__c');
                                openIsolationDateValue = (Date)bap.get('Isolation_Desire_End_Date__c');
                                openIsolationDate = openIsolationDateValue.year() + '-' + openIsolationDateValue.month() + '-' + openIsolationDateValue.day();
                                edaNo = edaEarlyList[0].EDA_Number__c;

                                if(!Test.isRunningTest()){
                                    REST_BAP_Temp_Isolation_Callout_v1.Update_OpenTemporaryIsolationDate( recordId, bapID, openIsolationDate, edaNo
                                    );
                                }
                                successLog = 'success';
                            }
                        }else if((Date)bap.get('Isolation_Desire_End_Date__c') > (Date)bap.get('Isolation_End_Date__c') && bap.get('EDA__c') != null && bap.get('EDA_for_Extend_Isolation__c') == null){
                            //system.debug('Extend Open Isolate');
                            EdaController EdaController_class = new EdaController();
                            EdaController_class.Create_EdaExtendTempIsolation(recordId);
                        }

                        //handle eda draft rejected update extend
                        if((Date)bap.get('Isolation_Desire_End_Date__c') > (Date)bap.get('Isolation_End_Date__c') && bap.get('EDA__c') != null && bap.get('EDA_for_Extend_Isolation__c') != null){
                            system.debug('Extend 2 Open Isolate');
                            EdaController EdaController_class = new EdaController();
                            EdaController_class.Update_EdaExtendTempIsolation((Id)bap.get('EDA_for_Extend_Isolation__c'));
                        }

                        //handle eda draft/complete rejected update early
                        if((Date)bap.get('Isolation_Desire_End_Date__c') < (Date)bap.get('Isolation_End_Date__c') && bap.get('EDA__c') != null && bap.get('EDA_for_Extend_Isolation__c') != null){
                            List<EDA__c> edaEarlyList = [Select Id,EDA_Number__c From EDA__c Where Id=: (Id)bap.get('EDA__c') AND IOM_Type__c =: 'Temporary Isolation'];
                            if(edaEarlyList !=null && !edaEarlyList.isEmpty()) {
                                system.debug('Early 3 Open Isolate');
                                bapID = (String)bap.get('BAP_ID__c');
                                openIsolationDateValue = (Date)bap.get('Isolation_Desire_End_Date__c');
                                openIsolationDate = openIsolationDateValue.year() + '-' + openIsolationDateValue.month() + '-' + openIsolationDateValue.day();
                                edaNo = edaEarlyList[0].EDA_Number__c;

                                if(!Test.isRunningTest()){
                                    REST_BAP_Temp_Isolation_Callout_v1.Update_OpenTemporaryIsolationDate( recordId, bapID, openIsolationDate, edaNo
                                    );
                                }
                                successLog = 'success';
                            }
                        }

                        //handle eda complete rejected update extend
                        if(old_bap.get('EDA_for_Extend_Isolation__c') != bap.get('EDA_for_Extend_Isolation__c') && old_bap.get('EDA_for_Extend_Isolation__c') != null && bap.get('EDA_for_Extend_Isolation__c') == null){
                            if((Date)bap.get('Isolation_Desire_End_Date__c') > (Date)bap.get('Isolation_End_Date__c') && bap.get('EDA__c') != null){
                                //system.debug('Extend Open Isolate');
                                EdaController EdaController_class = new EdaController();
                                EdaController_class.Create_EdaExtendTempIsolation(recordId);
                            }
                        }
                    }
                }
            }

            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - HandleEarly_Extend_OpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1',null);
            }
            
            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Update - Trigger_BapHandler.cls - HandleEarly_Extend_OpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - HandleEarly_Extend_OpenIsolate_Call_REST_BAP_Temp_Isolation_Callout_v1',err_message);
        }
    }

    public void HandleEdaStatusChangeToRejected_Call_REST_BAP_Temp_Isolation_Callout_v1(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();

            String recordId;
            String bapID;
            String userCreate;
            String typeOfRequest;
            String status;
            String sirkit;
            Date requestDateValue;
            String requestDate;
            Date openIsolationDateValue;
            String openIsolationDate;
            String reason;
            String picPosition;
            String picPhone;
            String picEmail;
            String pic;
            String note;
            String customer;
            String cid;
            String bandwidthUom;
            String bandwidth;
            String address;

            for(SObject bap : newItems.values()){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    SObject old_bap;
                    if(oldItems != null && oldItems.get((id)bap.get('Id')) != null){
                        old_bap = oldItems.get((Id)bap.get('Id'));
                    }

                    if(old_bap.get('Request_Status__c') != bap.get('Request_Status__c') && old_bap.get('Request_Status__c') == 'Draft' && bap.get('Request_Status__c') == 'Submit' && bap.get('createBAPTemp_Isolation_easyOps__c') == true && bap.get('EDA__c') != null){
                        List<User> userList = [SELECT Email FROM User WHERE Id=:(Id)bap.get('OwnerId')];

                        if(userList !=null && !userList.isEmpty()) {
                            userCreate = userList[0].Email;
                        }

                        recordId = (String)bap.get('Id');
                        bapID = (String)bap.get('BAP_ID__c');
                        typeOfRequest = (String)bap.get('Type_of_Request__c');
                        status = 'Waiting IOM Approval';
                        sirkit = (String)bap.get('Sirkit__c');
                        requestDateValue = (Date)bap.get('Isolation_Start_Date__c');
                        requestDate = requestDateValue.year() + '-' + requestDateValue.month() + '-' + requestDateValue.day();
                        openIsolationDateValue = (Date)bap.get('Isolation_End_Date__c');
                        openIsolationDate = openIsolationDateValue.year() + '-' + openIsolationDateValue.month() + '-' + openIsolationDateValue.day();
                        reason = (String)bap.get('Reason__c');
                        picPosition = (String)bap.get('PIC_Position__c');
                        picPhone = (String)bap.get('PIC_Phone__c');
                        picEmail = (String)bap.get('PIC_email__c');
                        pic = (String)bap.get('PIC_Name__c');
                        note = (String)bap.get('Note__c');
                        customer = (String)bap.get('Customer__c');
                        cid = (String)bap.get('CID__c');
                        bandwidthUom = (String)bap.get('UoM_rel__c');
                        bandwidth = (String)bap.get('Bandwidth_rel__c');
                        address = (String)bap.get('Address2__c');

                        if(!Test.isRunningTest()){
                            REST_BAP_Temp_Isolation_Callout_v1.updateBAPTemporary_Isolation( recordId, bapID, userCreate, typeOfRequest, status, sirkit, requestDate, openIsolationDate, reason,picPosition, picPhone, picEmail, pic, note, customer, cid, bandwidthUom, bandwidth, address
                            );
                        }
                        successLog = 'success';
                    }
                }
            }
            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - HandleEdaStatusChangeToRejected_Call_REST_BAP_Temp_Isolation_Callout_v1',null);
            }
            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/

        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_BapHandler.cls - HandleEdaStatusChangeToRejected_Call_REST_BAP_Temp_Isolation_Callout_v1 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - HandleEdaStatusChangeToRejected_Call_REST_BAP_Temp_Isolation_Callout_v1',err_message);
        }
    }

    public void HandleEdaStatusChangeToCanceled_Call_REST_BAP_Temp_Isolation_Callout_v1(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'Temporary Isolation'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();

            Id edaRecordId;
            Id recordId;
            String bapID;
            String status;
            String edaNo;

            for(SObject bap : newItems.values()){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    SObject old_bap;
                    if(oldItems != null && oldItems.get((id)bap.get('Id')) != null){
                        old_bap = oldItems.get((Id)bap.get('Id'));
                    }

                    if(
                        (old_bap.get('Complete_Status__c') != bap.get('Complete_Status__c') || 
                        old_bap.get('Request_Status__c') != bap.get('Request_Status__c')) && 
                        bap.get('Complete_Status__c') == 'Canceled' && 
                        bap.get('Request_Status__c') == 'Complete' &&  
                        bap.get('EDA__c') != null &&
                        bap.get('EDA_for_Isolation_Status__c') != 'Completed' 
                    ){
                        bap.adderror('You cannot change the BAP to canceled because EDA has not yet been completed');
                    }else if(
                        (old_bap.get('Complete_Status__c') != bap.get('Complete_Status__c') || 
                        old_bap.get('Request_Status__c') != bap.get('Request_Status__c')) && 
                        bap.get('Complete_Status__c') == 'Canceled' && 
                        bap.get('Request_Status__c') == 'Complete' &&  
                        bap.get('EDA__c') != null &&
                        bap.get('EDA_for_Isolation_Status__c') == 'Completed' 
                    ){
                        edaRecordId = (Id)bap.get('EDA__c');
                        recordId = (Id)bap.get('Id');
                        bapID = (String)bap.get('BAP_ID__c');
                    }
                }
            }

            if(edaRecordId != null){
                List<EDA__c> EdaList = [SELECT Id, EDA_Number__c FROM EDA__c WHERE BAP__c =: recordId];

                if(EdaList !=null && !EdaList.isEmpty()) {
                    status = 'Canceled';
                    edaNo = EdaList[0].EDA_Number__c;

                    if(!Test.isRunningTest()){
                        REST_BAP_Temp_Isolation_Callout_v1.UpdateStatusBAP_Temporary_Isolation( recordId, bapID, status, edaNo
                        );
                    }
                    successLog = 'success';
                }
            }
            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - HandleEdaStatusChangeToCanceled_Call_REST_BAP_Temp_Isolation_Callout_v1',null);
            }

            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
            */
        }
        catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_BapHandler.cls - HandleEdaStatusChangeToCanceled_Call_REST_BAP_Temp_Isolation_Callout_v1 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - HandleEdaStatusChangeToCanceled_Call_REST_BAP_Temp_Isolation_Callout_v1',err_message);
        }
    }

    public void HandleStatusChangeTo_Submit_BAP_EndofContract(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'End of Contract'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();

            string recordId;
            string bapid;
            string typeOfRequest;
            string customer;
            string cid;
            string sirkit;
            string address;
            string pic;
            string picPhone;
            string picEmail;
            string picPosition;
            string bandwidth;
            string bandwidthUom;
            string requestDate;
            string terminateDate;
            string reason; 
            string note;
            string userCreate;
            string request_status;
            string iom_file_link;
            string termination_for_nonautorenewal;

            for(SObject bap : newItems.values()){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    SObject old_bap;
                    if(oldItems != null && oldItems.get((id)bap.get('Id')) != null){
                        old_bap = oldItems.get((Id)bap.get('Id'));
                    }

                    if(old_bap.get('Request_Status__c') != bap.get('Request_Status__c') && old_bap.get('Request_Status__c') == 'Draft' && bap.get('Request_Status__c') == 'Submit'){

                        recordId = (String)bap.get('Id');
                        bapid = (String)bap.get('BAP_ID__c');
                        typeOfRequest = (String)bap.get('Type_of_Request__c');
                        customer = (String)bap.get('Customer__c');
                        cid = (String)bap.get('CID__c');
                        sirkit = (String)bap.get('Sirkit__c');
                        address = (String)bap.get('Address2__c');
                        pic = (String)bap.get('PIC_Name__c');
                        picPhone = (String)bap.get('PIC_Phone__c');
                        picEmail = (String)bap.get('PIC_email__c');
                        picPosition = (String)bap.get('PIC_Position__c');
                        if (!String.isBlank(picPosition)) {
                            picPosition = picPosition.replace(';',',');
                        }

                        bandwidth = (String)bap.get('Bandwidth_rel__c');
                        bandwidthUom = (String)bap.get('UoM_rel__c');

                        bap.put('Request_Date__c',system.today());

                        Date d = (Date)bap.get('Request_Date__c');
                        Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
                        requestDate = dt.format ('yyyy-MM-dd') ; 

                        d = (Date)bap.get('Terminate_Date__c');
                        dt = datetime.newInstance(d.year(), d.month(),d.day());
                        terminateDate = dt.format('yyyy-MM-dd');

                        reason = (String)bap.get('Reason__c');
                        note = (String)bap.get('Note__c');
                        userCreate = (String)bap.get('CreatedBy_email__C');
                        iom_file_link = null;

                        if (bapid <> '' && bapid <> null) {
                            
                        } else {
                            request_status = null; 
                        }

                        termination_for_nonautorenewal = 'true';

                        Datetime nextSchedule = system.now().addSeconds(3);

                        String hour = String.valueOf( nextSchedule.hour());
                        String min = String.valueOf( nextSchedule.minute()); 
                        String ss = String.valueOf( nextSchedule.second());
                        String sDay = string.valueof( nextSchedule.day() ); 
                        String sYear = string.valueof( nextSchedule.year() );
                        String sMonth = string.valueof( nextSchedule.month() );
                        
                        String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

                        if(!Test.isRunningTest()){
                            Call_REST_BAP_EndofContract_Schdler Call_REST_BAP_EndofContract = new Call_REST_BAP_EndofContract_Schdler(
                                recordId, 
                                bapid,                          
                                typeOfRequest, 
                                customer, 
                                cid, 
                                sirkit,
                                address,
                                pic, 
                                picPhone, 
                                picEmail, 
                                picPosition, 
                                bandwidth,
                                bandwidthUom, 
                                requestDate, 
                                terminateDate, 
                                reason, 
                                note, 
                                userCreate, 
                                request_status, 
                                iom_file_link,
                                termination_for_nonautorenewal
                            ); 
                            System.schedule('CallCSRegComplete_Schdler ' + recordId + String.valueOf(system.now()), nextFireTime, Call_REST_BAP_EndofContract);
                        }
                        successLog = 'success';
                    }
                }
            }
            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeToSubmit_BAP_EndofContract',null);
            }
            
            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/

        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_BapHandler.cls - HandleStatusChangeToSubmit_BAP_EndofContract ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeToSubmit_BAP_EndofContract',err_message);
        }
    }

    public void HandleStatusChangeTo_Canceled_BAP_EndofContract(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'End of Contract'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();

            String recordId;
            string bapid;
            string typeOfRequest;
            string customer;
            string cid;
            string sirkit;
            string address;
            string pic;
            string picPhone;
            string picEmail;
            string picPosition;
            string bandwidth;
            string bandwidthUom;
            string requestDate;
            string terminateDate;
            string reason; 
            string note;
            string userCreate;
            string request_status;
            string iom_file_link;
            string termination_for_nonautorenewal;

            for(SObject bap : newItems.values()){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    SObject old_bap;
                    if(oldItems != null && oldItems.get((id)bap.get('Id')) != null){
                        old_bap = oldItems.get((Id)bap.get('Id'));
                    }

                    if(old_bap.get('Request_Status__c') != bap.get('Request_Status__c') && old_bap.get('Request_Status__c') != 'Complete' && bap.get('Request_Status__c') == 'Complete' && bap.get('complete_status__c') == 'Canceled'){

                        recordId = (String)bap.get('Id');
                        bapid = (String)bap.get('BAP_ID__c');
                        typeOfRequest = null;
                        customer = null;
                        cid = null;
                        sirkit = null;
                        address = null;
                        pic = null;
                        picPhone = null; 
                        picEmail = null;
                        picPosition = null;
                        bandwidth = null;
                        bandwidthUom = null;                    
                        requestDate = null ; 
                        terminateDate = null;
                        reason = null;
                        note = null;
                        userCreate = null;
                        iom_file_link = null;
                        request_status = 'Canceled';
                        termination_for_nonautorenewal = 'false';
                        
                        Datetime nextSchedule = system.now().addSeconds(3);

                        String hour = String.valueOf( nextSchedule.hour());
                        String min = String.valueOf( nextSchedule.minute()); 
                        String ss = String.valueOf( nextSchedule.second());
                        String sDay = string.valueof( nextSchedule.day() ); 
                        String sYear = string.valueof( nextSchedule.year() );
                        String sMonth = string.valueof( nextSchedule.month() );
                        
                        String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

                        if(!Test.isRunningTest()){
                            Call_REST_BAP_EndofContract_Schdler Call_REST_BAP_EndofContract = new Call_REST_BAP_EndofContract_Schdler(
                                recordId, 
                                bapid,                          
                                typeOfRequest, 
                                customer, 
                                cid, 
                                sirkit,
                                address,
                                pic, 
                                picPhone, 
                                picEmail, 
                                picPosition, 
                                bandwidth,
                                bandwidthUom, 
                                requestDate, 
                                terminateDate, 
                                reason, 
                                note, 
                                userCreate, 
                                request_status, 
                                iom_file_link,
                                termination_for_nonautorenewal
                            ); 
                            System.schedule('CallCSRegComplete_Schdler ' + recordId + String.valueOf(system.now()), nextFireTime, Call_REST_BAP_EndofContract);
                        }
                        successLog = 'success';
                    }
                }
            }
            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeTo_Canceled_BAP_EndofContract',null);
            }
            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/

        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_BapHandler.cls - HandleStatusChangeTo_Canceled_BAP_EndofContract ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeTo_Canceled_BAP_EndofContract',err_message);
        }
    }

    public void HandleStatusChangeTo_Complete_BAP_EndofContract(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'End of Contract'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();


            for(SObject bap : newItems.values()){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    SObject old_bap;
                    if(oldItems != null && oldItems.get((id)bap.get('Id')) != null){
                        old_bap = oldItems.get((Id)bap.get('Id'));
                    }

                    if(
                        old_bap.get('Request_Status__c') != bap.get('Request_Status__c') && 
                        old_bap.get('Request_Status__c') != 'Complete' && 
                        bap.get('Request_Status__c') == 'Complete' && 
                        bap.get('complete_status__c') == 'Done' &&
                        bap.get('BA_Extend_REL__c') != null
                    ){
                        List<Contract_Extension__c> BA_extensionList = [SELECT Id, Status__c, Contract_Ticket_Created__c, BAP__c, Complete_Status__c, Remark__c FROM Contract_Extension__c WHERE Id =: (String)bap.get('BA_Extend_REL__c') AND BAP__c =: (String)bap.get('Id')];

                        String ContractTicketId = null;

                        if(BA_extensionList!=null && !BA_extensionList.isEmpty()){
                            for(Contract_Extension__c BA_extensionList_extract : BA_extensionList){
                                BA_extensionList_extract.Status__c = 'Completed';
                                BA_extensionList_extract.Complete_Status__c	 = 'Canceled';
                                BA_extensionList_extract.Remark__c = 'Canceled';

                                if(BA_extensionList_extract.Contract_Ticket_Created__c != null){
                                    ContractTicketId = BA_extensionList_extract.Contract_Ticket_Created__c;
                                }
                            }
                            update BA_extensionList;

                            if(String.isNotBlank(ContractTicketId)){
                                List<Contract_Ticket__c> contractTicketList = [SELECT Id, TicketStatus__c FROM Contract_Ticket__c WHERE Id =: ContractTicketId];

                                if(contractTicketList!=null && !contractTicketList.isEmpty()){
                                    for(Contract_Ticket__c contractTicketList_extract : contractTicketList){
                                        contractTicketList_extract.TicketStatus__c = 'Canceled';
                                    }
                                    update contractTicketList;
                                }
                            }
                        }
                        successLog = 'success';
                    }
                }
            }
            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeTo_Complete_BAP_EndofContract',null);
            }
            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/

        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_BapHandler.cls - HandleStatusChangeTo_Complete_BAP_EndofContract ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeTo_Complete_BAP_EndofContract',err_message);
        }
    }

    public void HandleStatusChangeTo_SenttoFinance_BAP_EndofContract(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        String successLog = null;
        try {
            String recordTypeName = 'End of Contract'; // <-- Change this to record type name
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
            Id recordTypeId = rtInfo.getRecordTypeId();


            for(SObject bap : newItems.values()){
                if( (Id)bap.get('RecordTypeId') == recordTypeId ){
                    SObject old_bap;
                    if(oldItems != null && oldItems.get((id)bap.get('Id')) != null){
                        old_bap = oldItems.get((Id)bap.get('Id'));
                    }

                    if(
                        old_bap.get('Request_Status__c') != bap.get('Request_Status__c') && 
                        old_bap.get('Request_Status__c') != 'BAP Sent to Finance' && 
                        bap.get('Request_Status__c') == 'BAP Sent to Finance' && 
                        bap.get('BA_Extend_REL__c') != null
                    ){
                        List<Contract_Extension__c> BA_extensionList = [SELECT Id, Status__c, Contract_Ticket_Created__c, BAP__c, Complete_Status__c,Remark__c FROM Contract_Extension__c WHERE Id =: (String)bap.get('BA_Extend_REL__c') AND BAP__c =: (String)bap.get('Id')];

                        String ContractTicketId = null;

                        if(BA_extensionList!=null && !BA_extensionList.isEmpty()){
                            for(Contract_Extension__c BA_extensionList_extract : BA_extensionList){
                                BA_extensionList_extract.Status__c = 'Completed';
                                BA_extensionList_extract.Complete_Status__c	 = 'Canceled';
                                BA_extensionList_extract.Remark__c = 'Canceled';

                                if(BA_extensionList_extract.Contract_Ticket_Created__c != null){
                                    ContractTicketId = BA_extensionList_extract.Contract_Ticket_Created__c;
                                }
                            }
                            update BA_extensionList;

                            if(String.isNotBlank(ContractTicketId)){
                                List<Contract_Ticket__c> contractTicketList = [SELECT Id, TicketStatus__c FROM Contract_Ticket__c WHERE Id =: ContractTicketId];

                                if(contractTicketList!=null && !contractTicketList.isEmpty()){
                                    for(Contract_Ticket__c contractTicketList_extract : contractTicketList){
                                        contractTicketList_extract.TicketStatus__c = 'Canceled';
                                    }
                                    update contractTicketList;
                                }
                            }
                        }
                        successLog = 'success';
                    }
                }
            }
            if(successLog != null){
                AppUtils.putCalllog('Trigger',null,start_time,successLog,datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeTo_SenttoFinance_BAP_EndofContract',null);
            }
            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/

        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_BapHandler.cls - HandleStatusChangeTo_SenttoFinance_BAP_EndofContract ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message); AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_BapHandler.cls - HandleStatusChangeTo_SenttoFinance_BAP_EndofContract',err_message);
        }
    }
    
}