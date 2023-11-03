/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 10-31-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
global with sharing class REST_ObjectLease_Callout {
    public static String token;
    public static Boolean doCallOut = false;


    public static void getAccessToken(){
        Datetime startDate = System.now();
    
        String callID = AppUtils.getNewGUID();
        String responseMsg;
        String tokenStatusMsg = '';
        String result = '';
        String errorMsg;
        String request;
        String endpoint;
    
        Http httpObj = new Http();
        HttpRequest httpRequestObj = new HttpRequest(); 
    
        List<Easy_Ops_API_Setting__c> restGetTokenToEasyOps = [
            SELECT Password__c, URI__c, URL__c, Username__c 
            FROM Easy_Ops_API_Setting__c 
            WHERE Name = 'getToken2'
        ];

        Call_Log__c callLogObj = new Call_Log__c();
        try {  
            if (restGetTokenToEasyOps != null && !restGetTokenToEasyOps.isEmpty()) {
                endpoint = restGetTokenToEasyOps[0].URI__c + restGetTokenToEasyOps[0].URL__c;
    
                httpRequestObj.setEndpoint(endpoint);
                httpRequestObj.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                httpRequestObj.setMethod('POST');
                httpRequestObj.setTimeout(120000);
    
                // Construct the form data
                String formData = 'password=' + EncodingUtil.urlEncode(restGetTokenToEasyOps[0].Password__c, 'UTF-8') +
                    '&username=' + EncodingUtil.urlEncode(restGetTokenToEasyOps[0].Username__c, 'UTF-8');

                System.debug('=== formData : ' + formData);
    
                httpRequestObj.setBody(formData);
    
                HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
    
                request = String.ValueOf(httpRequestObj);
                System.debug('=== request_getAccessToken : '+ request);
    
                result = httpResponseObj.getBody();
                System.debug('=== result1 : '+ result);
    
                if (httpResponseObj.getStatusCode() == 200) {
                    Map<String, Object> responsemap = (Map<String, Object>) JSON.deserializeUntyped(httpResponseObj.getBody());
                    token = (String) responsemap.get('token');
                    tokenStatusMsg = 'Success';
                    doCallOut = true;
                    System.debug ('================= response responsemap : ' + responsemap );
                    System.debug ('================= response token : ' + token );
                } else {
                    tokenStatusMsg = 'Failed';
                }
            }
        } catch (Exception e) {
            //-- error handling for callout
            System.debug ('============== error found at Call-Out ==============');
    
            tokenStatusMsg = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_ObjectLease_Callout.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            System.debug ('===== errorMsg : ' + errorMsg);
        }
    
        Datetime endDate = System.now();
    
        callLogObj.CallerFrom__c           = 'Salesforce'; 
        callLogObj.Endpoint__c             = endpoint;
        callLogObj.Type__c                 = 'Callout';
        callLogObj.Request_Message__c      = request;
        callLogObj.Response_Message__c     = result;
        callLogObj.Method__c               = 'POST';
        callLogObj.Status__c               = tokenStatusMsg;
        callLogObj.Request_ID__c           = callId;
        callLogObj.Request_Start_Time__c   = startDate;
        callLogObj.Response_End_Time__c    = endDate;
        // insert log;
    }   
    
    @future (Callout=true)
    public static void requestObjectLeaseCreationToEasyOpsByObjectLeaseId(Id objLeaseId){
        List<Easy_Ops_API_Setting__c> restObjectLeaseCalloutToEasyOps = [
            SELECT Password__c, URI__c, URL__c, Username__c 
            FROM Easy_Ops_API_Setting__c 
            WHERE Name = 'sync_object_lease'
        ];
        
        if (restObjectLeaseCalloutToEasyOps != null && !restObjectLeaseCalloutToEasyOps.isEmpty()) {
            getAccessToken();

            Datetime requestStartTime = Datetime.now();

            String URI;
            String bodyMessage;
            String status = 'failed';
            Integer responseCode;
            String responseMsg;
            String errorMsg;
            String result;
            String callId = AppUtils.getNewGUID();
            String endPoint;
            

            // get object lease
            Object_Lease__c objLeaseRec = [
                SELECT Id, Name, Object_Lease_Type__c, Object_Lease_Id__c, is_Active__c
                FROM Object_Lease__c
                WHERE Id =: objLeaseId
            ];
            System.debug('=== objLeaseRec : ' + objLeaseRec);

            // create request body
            OBJECT_LEASE_REQUEST objectLeaseObj = new OBJECT_LEASE_REQUEST();
            objectLeaseObj.request_id   = callId;
            objectLeaseObj.name         = objLeaseRec.Name;
            objectLeaseObj.type         = objLeaseRec.Object_Lease_Type__c;

            System.debug('=== objectLeaseObj : ' + objectLeaseObj);


            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();
            Call_Log__c callLogObj = new Call_Log__c();

            if (doCallOut) {
                try {
                    System.debug('============ try to do call out ===========');
                    
                    System.debug('=== token : ' + token);


                    String reqBody = JSON.serialize(objectLeaseObj);
                    System.debug('=== reqBody : ' + reqBody);


                    // endpoint object lease or vendor service
                    endPoint = restObjectLeaseCalloutToEasyOps[0].URI__c + restObjectLeaseCalloutToEasyOps[0].URL__c;
                    URI = restObjectLeaseCalloutToEasyOps[0].URI__c;

                    httpRequestObj.setTimeout(120000);
                    httpRequestObj.setEndpoint(endpoint);
                    httpRequestObj.setHeader('Content-Type', 'application/json');
                    httpRequestObj.setHeader('Accept', 'application/json');
                    httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
                    httpRequestObj.setMethod('POST');
                    httpRequestObj.setBody(reqBody);

                    System.debug('=== httpRequestObj : ' + String.valueOf(httpRequestObj));

                    bodyMessage = reqBody;
                    System.debug('=== bodyMessage : ' + bodyMessage);

                    Datetime startDate = System.now();

                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                    result = httpResponseObj.getBody();
                    responseMsg = result;

                    System.debug('=== result httpResponse : ' + result);
                    System.debug('=== result status : ' + httpResponseObj.getStatus());
                    System.debug('=== result status code : ' + httpResponseObj.getStatusCode());


                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(result);
                    Map<String, Object> dataMap = (Map<String, Object>)(responseMap.get('data'));
                    
            
                    if (responseMap.containsKey('status') != null) {
                        System.debug('===== response responseMap : ' + responseMap);
                        System.debug('===== response dataMap : ' + dataMap);
                        System.debug('===== response status : ' + (Integer)responseMap.get('status'));
                        System.debug('===== response get guid : ' + (String)dataMap.get('guid'));

                        MetadataTriggerHandler.bypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
                        
                        Integer errorCode = (Integer)responseMap.get('status');

                        if (errorCode == 200) {
                            status = 'success';

                            objLeaseRec.Object_Lease_Id__c  = (String)dataMap.get('guid');
                            objLeaseRec.status__c           = 'Registered';
                            objLeaseRec.is_Active__c        = true;

                            update objLeaseRec;
                        } else {
                            status = 'failed';
                            errorMsg = JSON.serialize(responseMap);

                            objLeaseRec.status__c       = 'Draft';
                            objLeaseRec.is_Active__c    = false;

                            update objLeaseRec;
                        }
                    } else {
                        status = 'failed';
                        errorMsg = result;

                        objLeaseRec.status__c       = 'Draft';
                        objLeaseRec.is_Active__c    = false;

                       update objLeaseRec;
                    }
                    MetadataTriggerHandler.clearBypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
                    
                } catch (Exception e) {
                    SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                    status = 'Failed';
                    errorMsg = errorMsg +  '. Error on REST_ObjectLease_Callout.requestObjectLeaseCreationToEasyOpsByObjectLeaseId method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    SYSTEM.DEBUG ('===== errorMsg : '  + errorMsg);  
                }

                // put to Call_log obj
                callLogObj.type__c                 = 'Callout';
                callLogObj.request_start_time__c   = requestStartTime;
                callLogObj.method__c               = 'POST';
                callLogObj.callerFrom__c           = 'Salesforce';
                callLogObj.endpoint__c             = endpoint;
                callLogObj.uri__c                  = URI;
                callLogObj.request_message__c      = bodyMessage;
                callLogObj.status__c               = status;
                callLogObj.response_message__c     = responseMsg;
                callLogObj.Error_Message__c        = errorMsg;
                callLogObj.Request_ID__c           = callId;
                callLogObj.response_end_time__c    = Datetime.now();

                insert callLogObj;
            }
        }
    }

    @future(Callout=true)
    public static void requestObjectLeaseUpdatedToEasyOpsByGUID(String objLeaseGUID, String newObjLeaseRec, String oldObjLeaseRec){
        System.debug('===objLeaseGUID : ' + objLeaseGUID);
        System.debug('===newObjLeaseRec : ' + newObjLeaseRec);
        System.debug('===oldObjLeaseRec : ' + oldObjLeaseRec);


        List<Easy_Ops_API_Setting__c> restObjectLeaseCalloutToEasyOps = [
            SELECT Password__c, URI__c, URL__c, Username__c 
            FROM Easy_Ops_API_Setting__c 
            WHERE Name = 'sync_object_lease'
        ];

        if (restObjectLeaseCalloutToEasyOps != null && !restObjectLeaseCalloutToEasyOps.isEmpty()) {
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMessage;
            string status = 'failed';
            integer responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String callId = AppUtils.getNewGUID();
            String endpoint;

            // get object lease
            Object_Lease__c objLeaseRec = [
                SELECT Id, Name, Object_Lease_Type__c, Object_Lease_Id__c, is_Active__c, status__c
                FROM Object_Lease__c
                WHERE Object_Lease_Id__c =: objLeaseGUID
            ];
            System.debug('=== objLeaseRec : ' + objLeaseRec);
            
            OBJECT_LEASE_UPDATE_REQUEST objectLeaseObj = new OBJECT_LEASE_UPDATE_REQUEST();
            objectLeaseObj.request_id   = callId;
            objectLeaseObj.id           = objLeaseRec.Object_Lease_Id__c;
            objectLeaseObj.name         = objLeaseRec.Name;
            objectLeaseObj.type         = objLeaseRec.Object_Lease_Type__c;
            objectLeaseObj.is_active    = objLeaseRec.is_Active__c; 
            

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();
            Call_Log__c callLogObj = new Call_Log__c();

            if (doCallOut) {
                try {
                    System.debug('============ try to do call out ===========');
                    
                    System.debug('=== token : ' + token);

                    String reqBody = JSON.serialize(objectLeaseObj);
                    System.debug('=== reqBody : ' + reqBody);

                    // endpoint object lease or vendor service
                    endPoint = restObjectLeaseCalloutToEasyOps[0].URI__c + restObjectLeaseCalloutToEasyOps[0].URL__c;
                    URI = restObjectLeaseCalloutToEasyOps[0].URI__c;

                    httpRequestObj.setTimeout(120000);
                    httpRequestObj.setEndpoint(endpoint);
                    httpRequestObj.setHeader('Content-Type', 'application/json');
                    httpRequestObj.setHeader('Accept', 'application/json');
                    httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
                    httpRequestObj.setMethod('POST');
                    httpRequestObj.setBody(reqBody);

                    System.debug('=== httpRequestObj : ' + String.valueOf(httpRequestObj));

                    bodyMessage = reqBody;

                    Datetime startDate = System.now();

                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                    result = httpResponseObj.getBody();
                    responseMsg = result;

                    System.debug('=== result httpResponse : ' + result);
                    System.debug('=== result status : ' + httpResponseObj.getStatus());
                    System.debug('=== result status code : ' + httpResponseObj.getStatusCode());

                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(result);

                    if (responseMap.containsKey('status') != null) {
                        System.debug('=== in status not null ===');
                        System.debug('===== response responseMap : ' + responseMap);
                        System.debug('===== response status : ' + (Integer)responseMap.get('status'));
                        
                        Integer errorCode = (Integer)responseMap.get('status');

                        if (errorCode == 200) {
                            System.debug('=== in status 200 or success ===');
                            status = 'success';

                            objLeaseRec.status__c       = 'Registered';
                            objLeaseRec.is_Active__c    = true;

                            MetadataTriggerHandler.bypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
                            update objLeaseRec;
                        } else {
                            System.debug('=== in status not 200 ===');
                            status = 'failed';
                            errorMsg = JSON.serialize(responseMap);

                            Object newObjectLeaseRecObj = JSON.deserializeUntyped(newObjLeaseRec);
                            Object oldObjectLeaseRecObj = JSON.deserializeUntyped(oldObjLeaseRec);
                            System.debug('=== newObjectLeaseRecObj : ' + newObjectLeaseRecObj);
                            System.debug('=== oldObjectLeaseRecObj : ' + oldObjectLeaseRecObj);

							Map<String, Object> newObjectLeaseRecMap = (Map<String, Object>)newObjectLeaseRecObj;
							Map<String, Object> oldObjectLeaseRecMap = (Map<String, Object>)oldObjectLeaseRecObj;
                            System.debug('=== newObjectLeaseRecMap : ' + newObjectLeaseRecMap);
                            System.debug('=== oldObjectLeaseRecMap : ' + oldObjectLeaseRecMap);

                            Object_Lease__c objectLeaseRollBack = new Object_Lease__c();
                            objectLeaseRollBack.Id = (Id)oldObjectLeaseRecMap.get('Id');
                            
                            // status field rollback
                            if ((String)newObjectLeaseRecMap.get('status__c') != (String)oldObjectLeaseRecMap.get('status__c')) {
                                System.debug('=== in status field rollback ===');
                                System.debug('=== newValue : ' + (String)newObjectLeaseRecMap.get('status__c'));
                                System.debug('=== oldValue : ' + (String)oldObjectLeaseRecMap.get('status__c'));

                                objectLeaseRollBack.status__c = (String)oldObjectLeaseRecMap.get('status__c');
                            }
                            // name field rollback
                            if ((String)newObjectLeaseRecMap.get('Name') != (String)oldObjectLeaseRecMap.get('Name')) {
                                System.debug('=== in name field rollback ===');
                                System.debug('=== newValue : ' + (String)newObjectLeaseRecMap.get('Name'));
                                System.debug('=== oldValue : ' + (String)oldObjectLeaseRecMap.get('Name'));

                                objectLeaseRollBack.Name = (String)oldObjectLeaseRecMap.get('Name');
                            }
                            // object least type field rollback
                            if ((String)newObjectLeaseRecMap.get('Object_Lease_Type__c') != (String)oldObjectLeaseRecMap.get('Object_Lease_Type__c')) {
                                System.debug('=== in object least type field rollback ===');
                                System.debug('=== newValue : ' + (String)newObjectLeaseRecMap.get('Object_Lease_Type__c'));
                                System.debug('=== oldValue : ' + (String)oldObjectLeaseRecMap.get('Object_Lease_Type__c'));

                                objectLeaseRollBack.Object_Lease_Type__c = (String)oldObjectLeaseRecMap.get('Object_Lease_Type__c');
                            }
                            // is active field rollback
                            if ((Boolean)newObjectLeaseRecMap.get('is_Active__c') != (Boolean)oldObjectLeaseRecMap.get('is_Active__c')) {
                                System.debug('=== in object least type field rollback ===');
                                System.debug('=== newValue : ' + (Boolean)newObjectLeaseRecMap.get('is_Active__c'));
                                System.debug('=== oldValue : ' + (Boolean)oldObjectLeaseRecMap.get('is_Active__c'));

                                objectLeaseRollBack.is_Active__c = (Boolean)oldObjectLeaseRecMap.get('is_Active__c');
                            }

                            System.debug('=== objectLeaseRollBack : ' + objectLeaseRollBack);
                            
                            MetadataTriggerHandler.bypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
                            update objectLeaseRollBack;
                        }
                    } else {
                        System.debug('=== in status null ===');
                        status = 'failed';
                        errorMsg = result;

                        Object newObjectLeaseRecObj = JSON.deserializeUntyped(newObjLeaseRec);
                        Object oldObjectLeaseRecObj = JSON.deserializeUntyped(oldObjLeaseRec);
                        System.debug('=== newObjectLeaseRecObj : ' + newObjectLeaseRecObj);
                        System.debug('=== oldObjectLeaseRecObj : ' + oldObjectLeaseRecObj);

                        Map<String, Object> newObjectLeaseRecMap = (Map<String, Object>)newObjectLeaseRecObj;
                        Map<String, Object> oldObjectLeaseRecMap = (Map<String, Object>)oldObjectLeaseRecObj;
                        System.debug('=== newObjectLeaseRecMap : ' + newObjectLeaseRecMap);
                        System.debug('=== oldObjectLeaseRecMap : ' + oldObjectLeaseRecMap);

                        Object_Lease__c objectLeaseRollBack = new Object_Lease__c();
                        objectLeaseRollBack.Id = (Id)oldObjectLeaseRecMap.get('Id');
                        
                        // status field rollback
                        if ((String)newObjectLeaseRecMap.get('status__c') != (String)oldObjectLeaseRecMap.get('status__c')) {
                            System.debug('=== in status field rollback ===');
                            System.debug('=== newValue : ' + (String)newObjectLeaseRecMap.get('status__c'));
                            System.debug('=== oldValue : ' + (String)oldObjectLeaseRecMap.get('status__c'));

                            objectLeaseRollBack.status__c = (String)oldObjectLeaseRecMap.get('status__c');
                        }
                        // name field rollback
                        if ((String)newObjectLeaseRecMap.get('Name') != (String)oldObjectLeaseRecMap.get('Name')) {
                            System.debug('=== in name field rollback ===');
                            System.debug('=== newValue : ' + (String)newObjectLeaseRecMap.get('Name'));
                            System.debug('=== oldValue : ' + (String)oldObjectLeaseRecMap.get('Name'));

                            objectLeaseRollBack.Name = (String)oldObjectLeaseRecMap.get('Name');
                        }
                        // object least type field rollback
                        if ((String)newObjectLeaseRecMap.get('Object_Lease_Type__c') != (String)oldObjectLeaseRecMap.get('Object_Lease_Type__c')) {
                            System.debug('=== in object least type field rollback ===');
                            System.debug('=== newValue : ' + (String)newObjectLeaseRecMap.get('Object_Lease_Type__c'));
                            System.debug('=== oldValue : ' + (String)oldObjectLeaseRecMap.get('Object_Lease_Type__c'));

                            objectLeaseRollBack.Object_Lease_Type__c = (String)oldObjectLeaseRecMap.get('Object_Lease_Type__c');
                        }
                        // is active field rollback
                        if ((Boolean)newObjectLeaseRecMap.get('is_Active__c') != (Boolean)oldObjectLeaseRecMap.get('is_Active__c')) {
                            System.debug('=== in object least type field rollback ===');
                            System.debug('=== newValue : ' + (Boolean)newObjectLeaseRecMap.get('is_Active__c'));
                            System.debug('=== oldValue : ' + (Boolean)oldObjectLeaseRecMap.get('is_Active__c'));

                            objectLeaseRollBack.is_Active__c = (Boolean)oldObjectLeaseRecMap.get('is_Active__c');
                        }

                        System.debug('=== objectLeaseRollBack : ' + objectLeaseRollBack);
                        
                        MetadataTriggerHandler.bypass('TA_AT_ObjLeasedAftUpd_UpdateObjLeased');
                        update objectLeaseRollBack;
                    }
                } catch (Exception e) {
                    SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                    status = 'Failed';
                    errorMsg = errorMsg +  '. Error on REST_ObjectLease_Callout.requestObjectLeaseUpdatedToEasyOpsByGUID method - Async::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    SYSTEM.DEBUG ('===== errorMsg : '  + errorMsg);  
                }

                // put to Call_log obj
                callLogObj.type__c                 = 'Callout';
                callLogObj.request_start_time__c   = requestStartTime;
                callLogObj.method__c               = 'POST';
                callLogObj.callerFrom__c           = 'Salesforce';
                callLogObj.endpoint__c             = endpoint;
                callLogObj.uri__c                  = URI;
                callLogObj.request_message__c      = bodyMessage;
                callLogObj.status__c               = status;
                callLogObj.response_message__c     = responseMsg;
                callLogObj.Error_Message__c        = errorMsg;
                callLogObj.Request_ID__c           = callId;
                callLogObj.response_end_time__c    = Datetime.now();
                
                insert callLogObj; 
            }
        }
    }

    global class GET_TOKEN_REQUEST {
        global String username {get; set;}
        global String password {get; set;}
    }

    global class GET_TOKEN_RESPONSE {
        global String token {get; set;}
    }

    global class OBJECT_LEASE_REQUEST{
        public String name; // Router
        public String type; // COGS
        public String request_id; // b51e0126-8d20-6b10-5676-59568d16c885
    }

    global class OBJECT_LEASE_UPDATE_REQUEST {
        public String request_id; // b51e0126-8d20-6b10-5676-59568d16c885 // saat call
        public String id; // d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3
        public String name; // Router
        public String type; // COGS
        public Boolean is_active; // true or false
    }
}