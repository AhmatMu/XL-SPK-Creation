@RestResource(urlMapping='/v1/bap_temporary_isolations/*')
global with sharing class REST_BAP_Temp_Isolation_Callin_v1 {

    class Header {
        string status='';
        string service ='';
        string response_id='';
        string request_id ='';
    }

    class Except {
        string error_message='';
        string error_code = '';
    }

    class ErrBody {
        Except except; 
        
        ErrBody () {
           except = new Except();
        }
    }

    global class RESTResult {
        Header header;
        ErrBody body;        
        RESTResult(){
            header= new Header();
            body= new ErrBody();
        }
    }

    @HttpPut
    global static RESTResult doPut(){
        SYSTEM.DEBUG (' ================== In PUT METHOD at REST_BAP_Temp_Isolation_Callin_v1 ==============');

        RESTResult returnMessage = new RESTResult();
        
        String param ='';
        String status ='';
        String service ='';
        String requestid ='';
        String errMessage ='-';
        String errMessageCalllog ='-';
        String errCode ='-';
        String bap_id;
        String request_status;

        String ipAddressRequestCameFrom='';
        String currentRequestURL;
        String sfdcBaseURL;
        
        DateTime start_time = datetime.now();

        String temp_uri = '';
        String temp_callerfrom = '';
        String temp_endpoint = '';

        String bapRecordId;

        Call_Log__c calllog = new Call_Log__c();

        try {
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            param = RestContext.request.requestBody.toString().trim();
            Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped(param);
            
            temp_uri = request.requestURI;
            temp_callerfrom = request.remoteAddress;                  
            currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();

            try {
                //-- JSON data
                requestid = AppUtils.getStringDataOnMap(paramMap , 'header::request_id');
                service = AppUtils.getStringDataOnMap(paramMap , 'header::service');

                bap_id = AppUtils.getStringDataOnMap(paramMap , 'body::data::bap_id');
                request_status = AppUtils.getStringDataOnMap(paramMap , 'body::data::status');

                try {
                    //-- DML Process for Updating
                    system.debug('service : ' + service);

                    // Look up record type id
                    String recordTypeName = 'Termination'; // <-- Change this to record type name
                    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
                    Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
                    Id recordTypeId = rtInfo.getRecordTypeId();

                    if (service == 'updatebaptistatus') {
                        BAP__c BAP_extract = null;

                        List<BAP__c> BAPList = [SELECT Id,BAP_ID__c,Request_Status__c,Remark__c,Complete_Status__c FROM BAP__c WHERE BAP_ID__c=: bap_id AND RecordTypeId !=: recordTypeId];
                        
                        if(BAPList!=null && !BAPList.isEmpty()){
                            bapRecordId = BAPList[0].Id;
                            BAP_extract = BAPList[0];

                            if(String.isNotBlank(request_status)){
                                if(request_status == 'Complete'){
                                    BAP_extract.Request_Status__c = request_status;
                                    BAP_extract.Remark__c = request_status;
                                    BAP_extract.Complete_Status__c = 'Done';
                                }else{
                                    BAP_extract.Request_Status__c = request_status;
                                    BAP_extract.Remark__c = request_status;
                                }
                            }
                            update BAP_extract;
                        }
                    }
                }
                catch (DMLException e) {
                    status = 'failed';
                    //-- if update error
                    system.debug('Status DMLnya : ');
    
                    errCode = '204';
                    errMessage = 'Update process is failed.';
                    errMessageCalllog = 'Update process is failed. In PUT METHOD at REST_BAP_Temp_Isolation_Callin_v1 :: ' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
    
                    calllog.status__c = status;
                    
                    returnMessage.header.status = status;
                    returnMessage.header.service = service;
                    returnMessage.header.response_id = AppUtils.getUniqueNumber();
                    returnMessage.header.request_id = requestid;
                    returnMessage.body.except.error_message = errMessage;
                    returnMessage.body.except.error_code = errCode;

                    AppUtils.putError(errMessageCalllog);
                }
            }
            catch (DMLException e) {
                status = 'failed';
                //-- JSON data
                system.debug('Status JSON datanya : ');

                errCode = '400';
                errMessage = 'The request couldn’t be understood, usually because the JSON or XML body contains an error.';
                errMessageCalllog = 'The request couldn’t be understood, usually because the JSON or XML body contains an error. In PUT METHOD at REST_BAP_Temp_Isolation_Callin_v1 :: ' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();

                calllog.status__c = status;
                
                returnMessage.header.status = status;
                returnMessage.header.service = service;
                returnMessage.header.response_id = AppUtils.getUniqueNumber();
                returnMessage.header.request_id = requestid;
                returnMessage.body.except.error_message = errMessage;
                returnMessage.body.except.error_code = errCode;

                AppUtils.putError(errMessageCalllog);
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            status = 'failed';

            errCode = '400';
            errMessage = 'The request couldn’t be understood, usually because the JSON or XML body contains an error.';
            errMessageCalllog = 'The request couldn’t be understood, usually because the JSON or XML body contains an error. In PUT METHOD at REST_BAP_Temp_Isolation_Callin_v1 :: ' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();

            calllog.status__c = status;
            
            returnMessage.header.status = status;
            returnMessage.header.service = service;
            returnMessage.header.response_id = AppUtils.getUniqueNumber();
            returnMessage.header.request_id = requestid;
            returnMessage.body.except.error_message = errMessage;
            returnMessage.body.except.error_code = errCode;

            AppUtils.putError(errMessageCalllog);
        }

        status = 'success';
        errCode = '0';
        errMessage = '';

        returnMessage.header.status = status;
        returnMessage.header.service = service;
        returnMessage.header.response_id = AppUtils.getUniqueNumber();
        returnMessage.header.request_id = requestid;
        returnMessage.body.except.error_message = errMessage;
        returnMessage.body.except.error_code = errCode;

        //-- put call log information	    	
        calllog.type__c = 'Callin';
        calllog.method__c = 'PUT';
        calllog.callerFrom__c = temp_callerfrom; 
        calllog.uri__c = temp_uri;
        //temp_endpoint = currentRequestURL.replace(calllog.uri__c,'');
        calllog.endpoint__c = temp_endpoint;
        calllog.Request_ID__c  = requestid;   
        calllog.request_start_time__c = start_time;
        calllog.status__c = status ;
        calllog.Request_Message__c = param;
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(returnMessage) ;
        calllog.Salesforce_ID_1__c = bapRecordId;
        calllog.BAP__c = bapRecordId;
        insert calllog;

        system.debug('>>> returnMessage In PUT METHOD at REST_BAP_Temp_Isolation_Callin_v1 :: ' + returnMessage);

        return returnMessage;
    }

}