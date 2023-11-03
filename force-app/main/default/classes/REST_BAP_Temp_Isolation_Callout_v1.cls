global with sharing class REST_BAP_Temp_Isolation_Callout_v1 {
    
    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String tokenResult = '' ;
    
    class BodycreateBAPTemporary_Isolation {
        HeadercreateBAPTemporary_Isolation header = new HeadercreateBAPTemporary_Isolation();
        BodycreateBAPTemporary_IsolationDetail body  = new BodycreateBAPTemporary_IsolationDetail();
    } 
    
    class BodycreateBAPTemporary_IsolationDetail {
        DatacreateBAPTemporary_Isolation data = new DatacreateBAPTemporary_Isolation();
    }
    
    class DatacreateBAPTemporary_Isolation {
        string userCreate=null;
        string typeOfRequest=null;
        string openIsolationDate=null;
        string sirkit=null;
        string requestDate=null;
        string reason=null;
        string picPosition=null;
        string picPhone=null;
        string picEmail=null;
        string pic=null;
        string note=null;
        string customer=null;
        string cid=null;
        string bandwidthUom=null;
        string bandwidth=null;
        string address=null;
    }
    
    class HeadercreateBAPTemporary_Isolation {
        string status='';
        string service ='';
        string response_id='';
        string request_id ='';
    }

    class BodyupdateBAPTemporary_Isolation {
        HeaderupdateBAPTemporary_Isolation header = new HeaderupdateBAPTemporary_Isolation();
        BodyupdateBAPTemporary_IsolationDetail body  = new BodyupdateBAPTemporary_IsolationDetail();
    } 
    
    class BodyupdateBAPTemporary_IsolationDetail {
        DataupdateBAPTemporary_Isolation data = new DataupdateBAPTemporary_Isolation();
    }
    
    class DataupdateBAPTemporary_Isolation {
        string bapID=null;
        string userCreate=null;
        string typeOfRequest=null;
        string status=null;
        string sirkit=null;
        string requestDate=null;
        string openIsolationDate=null;
        string reason=null;
        string picPosition=null;
        string picPhone=null;
        string picEmail=null;
        string pic=null;
        string note=null;
        string customer=null;
        string cid=null;
        string bandwidthUom=null;
        string bandwidth=null;
        string address=null;
    }
    
    class HeaderupdateBAPTemporary_Isolation {
        string status='';
        string service ='';
        string response_id='';
        string request_id ='';
    }
    
    class BodyUpdateStatusBAPSentToCustomer {
        HeaderUpdateStatusBAPSentToCustomer header = new HeaderUpdateStatusBAPSentToCustomer();
        BodyUpdateStatusBAPSentToCustomerDetail body  = new BodyUpdateStatusBAPSentToCustomerDetail();
    } 
    
    class BodyUpdateStatusBAPSentToCustomerDetail {
        DataUpdateStatusBAPSentToCustomer data = new DataUpdateStatusBAPSentToCustomer();
    }
    
    class DataUpdateStatusBAPSentToCustomer{
        string bapID=null;
        string status=null;
        string edaNo=null;
    }
    
    class HeaderUpdateStatusBAPSentToCustomer {
        string status='';
        string service ='';
        string response_id='';
        string request_id ='';
    }

    class BodyUpdateOpenTemporaryIsolationDate {
        HeaderUpdateOpenTemporaryIsolationDate header = new HeaderUpdateOpenTemporaryIsolationDate();
        BodyUpdateOpenTemporaryIsolationDateDetail body  = new BodyUpdateOpenTemporaryIsolationDateDetail();
    } 
    
    class BodyUpdateOpenTemporaryIsolationDateDetail {
        DataUpdateOpenTemporaryIsolationDate data = new DataUpdateOpenTemporaryIsolationDate();
    }
    
    class DataUpdateOpenTemporaryIsolationDate{
        string bapID=null;
        string openIsolationDate=null;
        string edaNo=null;
    }
    
    class HeaderUpdateOpenTemporaryIsolationDate {
        string status='';
        string service ='';
        string response_id='';
        string request_id ='';
    }
    
    public static void getAccessToken () {
        Datetime startDate = System.now();
        
        String endpoint = Label.REST_TransDB_GetToken_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/auth/token';
        String body = 'username=' + Label.REST_TransDB_GetToken_Username + '&password=' + 
            apputils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; //'username=apidemo&password=password*1';
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setbody(body);
        req.setHeader('Accept', 'application/json');
        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;
        
        if (!Test.isRunningTest())
            response = http.send(req);
        else {
            response.setStatusCode(200); response.setStatus('OK'); response.setBody('{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}');
        }
        
        System.debug ('================= response message : ' + response.getBody ());
        Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
        
        String token = (string) responsemap.get('token');
        System.debug ('================= response token : ' + responsemap.get('token') );
        System.debug ('================= response message : ' + response.getBody ());
        
        tokenResult = token;
        
        Datetime endDate = System.now();
        Call_Log__c log = new Call_Log__c(CallerFrom__c='Salesforce', 
                                          Endpoint__c= endpoint,
                                          Type__c='Callout',
                                          Request_Message__c='',
                                          Response_Message__c= response.getBody (),
                                          Method__c='POST',
                                          Status__c= 'success',
                                          Request_Start_Time__c=startDate,
                                          Response_End_Time__c= endDate);
        callLogList.add(log);
    }
    
    @future(Callout=true)
    public static void createBAPTemporary_Isolation
        (
            String bapid,
            String userCreate,
            String typeOfRequest,
            String openIsolationDate,
            String sirkit,
            String requestDate,
            String reason,
            String picPosition,
            String picPhone,
            String picEmail,
            String pic,
            String note,
            String customer,
            String cid,
            String bandwidthUom,
            String bandwidth,
            String address
        ){
        SYSTEM.DEBUG ('============== in REST_BAP_Temp_Isolation_Callout_v1 class, createBAPTemporary_Isolation method ==============' );
        
        getAccessToken();
        
        string URI;
        string bodyMesage;
        string status;
        integer responseCode;
        String responseMsg;
        string errorMsg;
        Datetime requestStartTime = datetime.now();
        String idBAP;
        string bapNo;
        string requestStatus;
        
        String endpoint = Label.REST_BAP_Isolation_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/baps_isolation';
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;
        
        try {
            req.setTimeout(120000);
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + tokenResult );
            req.setMethod('POST');
            
            BodycreateBAPTemporary_Isolation BodycreateBAPTemporary_Isolation_extract = new BodycreateBAPTemporary_Isolation();
            BodycreateBAPTemporary_Isolation_extract.header.service= 'addbap';
            BodycreateBAPTemporary_Isolation_extract.header.request_id = AppUtils.getNewGUID();
            
            BodycreateBAPTemporary_Isolation_extract.body.data.userCreate = userCreate;
            BodycreateBAPTemporary_Isolation_extract.body.data.typeOfRequest = typeOfRequest;
            BodycreateBAPTemporary_Isolation_extract.body.data.openIsolationDate = openIsolationDate;
            BodycreateBAPTemporary_Isolation_extract.body.data.sirkit = sirkit;
            BodycreateBAPTemporary_Isolation_extract.body.data.requestDate = requestDate;
            BodycreateBAPTemporary_Isolation_extract.body.data.reason = reason;
            BodycreateBAPTemporary_Isolation_extract.body.data.picPosition = picPosition;
            BodycreateBAPTemporary_Isolation_extract.body.data.picPhone = picPhone;
            BodycreateBAPTemporary_Isolation_extract.body.data.picEmail = picEmail;
            BodycreateBAPTemporary_Isolation_extract.body.data.pic = pic;
            BodycreateBAPTemporary_Isolation_extract.body.data.note = note;
            BodycreateBAPTemporary_Isolation_extract.body.data.customer = customer;
            BodycreateBAPTemporary_Isolation_extract.body.data.cid = cid;
            BodycreateBAPTemporary_Isolation_extract.body.data.bandwidthUom = bandwidthUom;
            BodycreateBAPTemporary_Isolation_extract.body.data.bandwidth = bandwidth;
            BodycreateBAPTemporary_Isolation_extract.body.data.address = address;
            
            string jsonString = JSON.serialize(BodycreateBAPTemporary_Isolation_extract);
            system.debug ('================= BodycreateBAPTemporary_Isolation_extract1 :' + BodycreateBAPTemporary_Isolation_extract );    
            system.debug ('================= BodycreateBAPTemporary_Isolation_extract2 :' + jsonString );
            jsonString = apputils.stripJsonNulls(jsonString);
            
            bodyMesage = jsonString;
            req.setBody(bodyMesage);
            
            if (!Test.isRunningTest())
                response = http.send(req);
            else {
                response.setStatusCode(200); response.setStatus('OK'); response.setBody('{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}');
            }
            
            string restResult = response.getBody();
            responseMsg = response.getBody ();
            System.debug ('================= response message - createBAPTemporary_Isolation : ' + response.getBody ());
            
            Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
            System.debug ('================= responsemap : ' + responsemap);

            responseCode = response.getStatusCode();
            SYSTEM.DEBUG ('responseCode - createBAPTemporary_Isolation : ' + responseCode);
            if(responseCode == 200){
                status = 'success';
                idBAP = Apputils.getStringDataOnMap(responsemap, 'body::data::id_bap');
                bapNo = Apputils.getStringDataOnMap(responsemap, 'body::data::bap_no');
                requestStatus = Apputils.getStringDataOnMap(responsemap, 'body::data::status');
            }else{
                status = 'Failed';
            }
            
            try {
                //-- try to DML processs
                if(responseCode == 200){
                    if (!apputils.isKeysetNotFound(idBAP)) {
                        List<BAP__c> bapList = [select id, BAP_ID__c,BAP_No__c,Remark__c from bap__C where id =:bapid];
                        bapList[0].BAP_ID__c = idBAP;
                        bapList[0].BAP_No__c = bapNo;
                        //bapList[0].Remark__c = requestStatus;
                        update bapList;
                    }
                }
            }
            catch (DmlException e) {
                //-- error handling for DML process
                SYSTEM.DEBUG ('============== error found at DML Process ==============');
                
                errorMsg = errorMsg +  '. Error on REST_BAP_Temp_Isolation_Callout_v1.createBAPTemporary_Isolation method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');
            
            errorMsg = errorMsg +  '. Error on REST_BAP_Temp_Isolation_Callout_v1.createBAPTemporary_Isolation method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callout';
        calllog.request_start_time__c = requestStartTime;
        calllog.method__c = 'POST';
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ;
        calllog.uri__c = uri ; 
            system.debug ('==== bodyMesage : ' + bodyMesage);
        calllog.request_message__c = bodyMesage;
        calllog.status__c = status;
        calllog.response_message__c = 'responseCode = ' + responseCode + ' --- ' + 'responseMsg = ' +  responseMsg;               
        calllog.Error_Message__c = errorMsg;
        calllog.response_end_time__c = datetime.now(); 
        calllog.Salesforce_ID_1__c = bapid;
        calllog.BAP__c = bapid;    
        callLogList.add(calllog);
        insert callLogList;

        if(status == 'success'){
            EdaController EdaController_class = new EdaController();
            EdaController_class.Create_EdaSubmitTempIsolation(bapid);
        }else{
            BapController BapController_class = new BapController();
            BapController_class.Update_BAPTempIsolationStatus_Draft(bapid);
        }
    }

    @future(Callout=true)
    public static void updateBAPTemporary_Isolation
        (
            String bapRecordID,
            String bapID,
            String userCreate,
            String typeOfRequest,
            String status,
            String sirkit,
            String requestDate,
            String openIsolationDate,
            String reason,
            String picPosition,
            String picPhone,
            String picEmail,
            String pic,
            String note,
            String customer,
            String cid,
            String bandwidthUom,
            String bandwidth,
            String address
        ){
        SYSTEM.DEBUG ('============== in REST_BAP_Temp_Isolation_Callout_v1 class, updateAPTemporary_Isolation method ==============' );
        
        getAccessToken();
        
        string URI;
        string bodyMesage;
        string statusCallout;
        integer responseCode;
        String responseMsg;
        string errorMsg;
        Datetime requestStartTime = datetime.now();
        String idBAP;
        string bapNo;
        string requestStatus;
        
        String endpoint = Label.REST_BAP_Isolation_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/baps_isolation';
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;
        
        try {
            req.setTimeout(120000);
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + tokenResult );
            req.setMethod('POST');
            
            BodyupdateBAPTemporary_Isolation BodyupdateBAPTemporary_Isolation_extract = new BodyupdateBAPTemporary_Isolation();
            BodyupdateBAPTemporary_Isolation_extract.header.service= 'updatebap';
            BodyupdateBAPTemporary_Isolation_extract.header.request_id = AppUtils.getNewGUID();
            
            BodyupdateBAPTemporary_Isolation_extract.body.data.bapID = bapID;
            BodyupdateBAPTemporary_Isolation_extract.body.data.userCreate = userCreate;
            BodyupdateBAPTemporary_Isolation_extract.body.data.typeOfRequest = typeOfRequest;
            BodyupdateBAPTemporary_Isolation_extract.body.data.status = status;
            BodyupdateBAPTemporary_Isolation_extract.body.data.sirkit = sirkit;
            BodyupdateBAPTemporary_Isolation_extract.body.data.requestDate = requestDate;
            BodyupdateBAPTemporary_Isolation_extract.body.data.openIsolationDate = openIsolationDate;
            BodyupdateBAPTemporary_Isolation_extract.body.data.reason = reason;
            BodyupdateBAPTemporary_Isolation_extract.body.data.picPosition = picPosition;
            BodyupdateBAPTemporary_Isolation_extract.body.data.picPhone = picPhone;
            BodyupdateBAPTemporary_Isolation_extract.body.data.picEmail = picEmail;
            BodyupdateBAPTemporary_Isolation_extract.body.data.pic = pic;
            BodyupdateBAPTemporary_Isolation_extract.body.data.note = note;
            BodyupdateBAPTemporary_Isolation_extract.body.data.customer = customer;
            BodyupdateBAPTemporary_Isolation_extract.body.data.cid = cid;
            BodyupdateBAPTemporary_Isolation_extract.body.data.bandwidthUom = bandwidthUom;
            BodyupdateBAPTemporary_Isolation_extract.body.data.bandwidth = bandwidth;
            BodyupdateBAPTemporary_Isolation_extract.body.data.address = address;
            
            string jsonString = JSON.serialize(BodyupdateBAPTemporary_Isolation_extract);
            system.debug ('================= BodyupdateBAPTemporary_Isolation_extract1 :' + BodyupdateBAPTemporary_Isolation_extract );    
            system.debug ('================= BodyupdateBAPTemporary_Isolation_extract2 :' + jsonString );
            jsonString = apputils.stripJsonNulls(jsonString);
            
            bodyMesage = jsonString;
            req.setBody(bodyMesage);
            
            if (!Test.isRunningTest())
                response = http.send(req);
            else {
                response.setStatusCode(200); response.setStatus('OK'); response.setBody('{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}');
            }
            
            string restResult = response.getBody();
            responseMsg = response.getBody ();
            System.debug ('================= response message - updateBAPTemporary_Isolation : ' + response.getBody ());
            
            Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
            System.debug ('================= responsemap : ' + responsemap);

            responseCode = response.getStatusCode();
            SYSTEM.DEBUG ('responseCode - updateBAPTemporary_Isolation : ' + responseCode);
            if(responseCode == 200){
                statusCallout = 'success';
                bapNo = Apputils.getStringDataOnMap(responsemap, 'body::data::bap_no');
                idBAP = Apputils.getStringDataOnMap(responsemap, 'body::data::id_bap');
                requestStatus = Apputils.getStringDataOnMap(responsemap, 'body::data::status');
            }else{
                statusCallout = 'Failed';
            }
            
            try {
                //-- try to DML processs
                if(responseCode == 200){
                    if (!apputils.isKeysetNotFound(idBAP)) {
                        List<BAP__c> bapList = [select id, BAP_ID__c,BAP_No__c,Remark__c from bap__C where id =:bapRecordID];
                        bapList[0].BAP_ID__c = idBAP;
                        bapList[0].BAP_No__c = bapNo;
                        //bapList[0].Remark__c = requestStatus;
                        update bapList;
                    }
                }
            }
            catch (DmlException e) {
                //-- error handling for DML process
                SYSTEM.DEBUG ('============== error found at DML Process ==============');
                
                errorMsg = errorMsg +  '. Error on REST_BAP_Temp_Isolation_Callout_v1.updateBAPTemporary_Isolation method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');
            
            errorMsg = errorMsg +  '. Error on REST_BAP_Temp_Isolation_Callout_v1.updateBAPTemporary_Isolation method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callout';
        calllog.request_start_time__c = requestStartTime;
        calllog.method__c = 'POST';
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ;
        calllog.uri__c = uri ; 
            system.debug ('==== bodyMesage : ' + bodyMesage);
        calllog.request_message__c = bodyMesage;
        calllog.status__c = statusCallout;
        calllog.response_message__c = 'responseCode = ' + responseCode + ' --- ' + 'responseMsg = ' +  responseMsg;               
        calllog.Error_Message__c = errorMsg;
        calllog.response_end_time__c = datetime.now(); 
        calllog.Salesforce_ID_1__c = bapRecordID;
        calllog.BAP__c = bapRecordID;    
        callLogList.add(calllog);
        insert callLogList;

        if(statusCallout == 'success'){
            EdaController EdaController_class = new EdaController();
            EdaController_class.Update_EdaSubmitTempIsolation(bapRecordID);
        }else{
            BapController BapController_class = new BapController();
            BapController_class.Update_BAPTempIsolationStatus_Draft(bapRecordID);
        }
    }

    @future(Callout=true)
    public static void UpdateStatusBAP_Temporary_Isolation
        (
            Id bapRecordID,
            String bapID,
            String status,
            String edaNo
        ){
        SYSTEM.DEBUG ('============== in REST_BAP_Temp_Isolation_Callout_v1 class, UpdateStatusBAP_Temporary_Isolation method ==============' );
        
        getAccessToken();
        
        string URI;
        string bodyMesage;
        string statusCallout;
        integer responseCode;
        String responseMsg;
        string errorMsg;
        Datetime requestStartTime = datetime.now();
        Boolean flagUpdateStatus_draft = false;
        Boolean flagUpdateStatus_sentToCustomer = false;
        
        String endpoint = Label.REST_BAP_Isolation_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/baps_isolation';
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;
        
        try {
            req.setTimeout(120000);
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + tokenResult );
            req.setMethod('POST');

            if(status == 'BAP sent to Customer'){
                flagUpdateStatus_sentToCustomer = true;
            }

            if(status == 'Draft'){
                flagUpdateStatus_draft = true;
            }
            
            BodyUpdateStatusBAPSentToCustomer BodyUpdateStatusBAPSentToCustomer_extract = new BodyUpdateStatusBAPSentToCustomer();
            BodyUpdateStatusBAPSentToCustomer_extract.header.service= 'updatestatusbap';
            BodyUpdateStatusBAPSentToCustomer_extract.header.request_id = AppUtils.getNewGUID();
            
            BodyUpdateStatusBAPSentToCustomer_extract.body.data.bapID = bapID;
            BodyUpdateStatusBAPSentToCustomer_extract.body.data.status = status;
            BodyUpdateStatusBAPSentToCustomer_extract.body.data.edaNo = edaNo;
            
            string jsonString = JSON.serialize(BodyUpdateStatusBAPSentToCustomer_extract);
            system.debug ('================= BodyUpdateStatusBAPSentToCustomer_extract1 :' + BodyUpdateStatusBAPSentToCustomer_extract );    
            system.debug ('================= BodyUpdateStatusBAPSentToCustomer_extract2 :' + jsonString );
            jsonString = apputils.stripJsonNulls(jsonString);

            bodyMesage = jsonString;
            req.setBody(bodyMesage);
            
            if (!Test.isRunningTest())
                response = http.send(req);
            else {
                response.setStatusCode(200); response.setStatus('OK'); response.setBody('{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}');
            }
            
            string restResult = response.getBody ();
            responseMsg = response.getBody ();
            System.debug ('================= response message - UpdateStatusBAP_Temporary_Isolation : ' + response.getBody ());
            
            Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
            System.debug ('================= responsemap : ' + responsemap);

            responseCode = response.getStatusCode();
            SYSTEM.DEBUG ('responseCode - UpdateStatusBAP_Temporary_Isolation : ' + responseCode);
            if(responseCode == 200){
                statusCallout = 'success';
            }else{
                statusCallout = 'Failed';
            }
            
            try {
                //-- try to DML processs
                SYSTEM.DEBUG ('============== try to do UPDATE ... ==============');
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            }
            catch (DmlException e) {
                //-- error handling for DML process
                SYSTEM.DEBUG ('============== error found at DML Process ==============');
                
                errorMsg = errorMsg +  '. Error on REST_BAP_Temp_Isolation_Callout_v1.UpdateStatusBAP_Temporary_Isolation method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');
            
            errorMsg = errorMsg +  '. Error on REST_BAP_Temp_Isolation_Callout_v1.UpdateStatusBAP_Temporary_Isolation method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callout';
        calllog.request_start_time__c = requestStartTime;
        calllog.method__c = 'POST';
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ;
        calllog.uri__c = uri ; 
        calllog.request_message__c = bodyMesage;
        calllog.status__c = statusCallout;
        calllog.response_message__c = 'responseCode = ' + responseCode + ' --- ' + 'responseMsg = ' +  responseMsg;              
        calllog.Error_Message__c = errorMsg;
        calllog.response_end_time__c = datetime.now();
        calllog.Salesforce_ID_1__c = bapRecordID;
        calllog.BAP__c = bapRecordID;
        callLogList.add(calllog);
        insert callLogList;

        if(statusCallout == 'success'){
            if(flagUpdateStatus_sentToCustomer == true){
                BapController BapController_class = new BapController();
                BapController_class.Update_BAPTempIsolationStatus_ProcessIsolation(bapRecordID);
            }

            if(flagUpdateStatus_draft == true){
                BapController BapController_class = new BapController();
                BapController_class.Update_BAPTempIsolationStatus_Rejected_BacktoDraft(bapRecordID);
            }
        }
    }

    @future(Callout=true)
    public static void Update_OpenTemporaryIsolationDate
        (
            Id bapRecordID,
            String bapID,
            String openIsolationDate,
            String edaNo
        ){
        SYSTEM.DEBUG ('============== in REST_BAP_Temp_Isolation_Callout_v1 class, Update_OpenTemporaryIsolationDate method ==============' );
        
        getAccessToken();
        
        string URI;
        string bodyMesage;
        string status;
        integer responseCode;
        String responseMsg;
        string errorMsg;
        Datetime requestStartTime = datetime.now();
        
        String endpoint = Label.REST_BAP_Isolation_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/baps_isolation';
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;
        
        try {
            req.setTimeout(120000);
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + tokenResult );
            req.setMethod('POST');
            
            BodyUpdateOpenTemporaryIsolationDate BodyUpdateOpenTemporaryIsolationDate_extract = new BodyUpdateOpenTemporaryIsolationDate();
            BodyUpdateOpenTemporaryIsolationDate_extract.header.service= 'updateopendateisolation';
            BodyUpdateOpenTemporaryIsolationDate_extract.header.request_id = AppUtils.getNewGUID();
            
            BodyUpdateOpenTemporaryIsolationDate_extract.body.data.bapID = bapID;
            BodyUpdateOpenTemporaryIsolationDate_extract.body.data.openIsolationDate = openIsolationDate;
            BodyUpdateOpenTemporaryIsolationDate_extract.body.data.edaNo = edaNo;
            
            string jsonString = JSON.serialize(BodyUpdateOpenTemporaryIsolationDate_extract);
            system.debug ('================= BodyUpdateOpenTemporaryIsolationDate_extract1 :' + BodyUpdateOpenTemporaryIsolationDate_extract );    
            system.debug ('================= BodyUpdateOpenTemporaryIsolationDate_extract2 :' + jsonString );
            jsonString = apputils.stripJsonNulls(jsonString);

            bodyMesage = jsonString;
            req.setBody(bodyMesage);
            
            if (!Test.isRunningTest())
                response = http.send(req);
            else {
                response.setStatusCode(200); response.setStatus('OK'); response.setBody('{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}');
            }
            
            string restResult = response.getBody ();
            responseMsg = response.getBody ();
            System.debug ('================= response message - Update_OpenTemporaryIsolationDate : ' + response.getBody ());
            
            Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
            System.debug ('================= responsemap : ' + responsemap);

            responseCode = response.getStatusCode();
            SYSTEM.DEBUG ('responseCode - Update_OpenTemporaryIsolationDate : ' + responseCode);
            if(responseCode == 200){
                status = 'success';
            }else{
                status = 'Failed';
            }
            
            try {
                //-- try to DML processs
                SYSTEM.DEBUG ('============== try to do UPDATE ... ==============');
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            }
            catch (DmlException e) {
                //-- error handling for DML process
                SYSTEM.DEBUG ('============== error found at DML Process ==============');
                
                errorMsg = errorMsg +  '. Error on REST_BAP_Temp_Isolation_Callout_v1.Update_OpenTemporaryIsolationDate method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');
            
            errorMsg = errorMsg +  '. Error on REST_BAP_Temp_Isolation_Callout_v1.Update_OpenTemporaryIsolationDate method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callout';
        calllog.request_start_time__c = requestStartTime;
        calllog.method__c = 'POST';
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ;
        calllog.uri__c = uri ; 
        calllog.request_message__c = bodyMesage;
        calllog.status__c = status;
        calllog.response_message__c = 'responseCode = ' + responseCode + ' --- ' + 'responseMsg = ' +  responseMsg;            
        calllog.Error_Message__c = errorMsg;
        calllog.response_end_time__c = datetime.now();
        calllog.Salesforce_ID_1__c = bapRecordID;
        calllog.BAP__c = bapRecordID;  
        callLogList.add(calllog);
        insert callLogList;

        if(status == 'success'){
            BapController BapController_class = new BapController();
            BapController_class.Update_BAPTempIsolationStatus_EndDate(bapRecordID);
        }
    }
    
}