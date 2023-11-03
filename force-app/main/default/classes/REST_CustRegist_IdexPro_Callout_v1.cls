/**
 * @description       : 
 * @Test Class        : REST_CustRegist_IdexPro_Callout_v1_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 09-06-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-06-2022   Novando Utoyo Agmawan   Initial Version
**/

global with sharing class REST_CustRegist_IdexPro_Callout_v1 {
    //global REST_CustRegist_IdexPro_Callout_v1(){}

    //REST_CustRegist_IdexPro_Callout_v1.UpdateTicketRegistration('a111m000001JgfbAAC');

    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String token;
    public static Boolean doCallOut = false;
    
    public static void getAccessToken(){
        Datetime startDate = System.now();

        String callID = AppUtils.getNewGUID();
        String responseMsg ;
        String tokenStatusMsg = '';
        string result = '';
        string errorMsg;
        string request;
        String endpoint;

        Http httpObj = new Http();
        HttpRequest httpRequestObj = new HttpRequest(); 

        List<IdexPro_API_Setting__c> List_IdexPro_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM IdexPro_API_Setting__c WHERE Name = 'getToken_Stagging'];
        
        try {  
            if(List_IdexPro_APISetting!=null && !List_IdexPro_APISetting.isEmpty()){
                endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c;

                GET_TOKEN_REQUEST GET_TOKEN_REQUEST_obj = new GET_TOKEN_REQUEST();
                GET_TOKEN_REQUEST_obj.password = List_IdexPro_APISetting[0].Password__c;
                GET_TOKEN_REQUEST_obj.username = List_IdexPro_APISetting[0].Username__c;
                
                String reqBody = JSON.serialize(GET_TOKEN_REQUEST_obj);

                System.debug('>>> reqBody : '+ reqBody);

                httpRequestObj.setEndpoint(endpoint);
                httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
                httpRequestObj.setBody(reqBody);
                httpRequestObj.setMethod('POST');
                httpRequestObj.setTimeout(120000);
    
                HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
    
                request = String.ValueOf(httpRequestObj);
                System.debug('>>> request_getAccessToken : '+ request);
    
                result=httpResponseObj.getBody();
                System.debug('>>> result1 : '+ result);
    
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(httpResponseObj.getBody ());
                token = (string) responsemap.get('token');
                
                System.debug ('================= response responsemap : ' + responsemap );
                System.debug ('================= response token : ' + token );
                
                if(String.isNotBlank(token)){
                    tokenStatusMsg = 'Success';
                    doCallOut = true;
                }else{
                    tokenStatusMsg = 'Failed';
                }
            }
        }
        catch (Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');

            tokenStatusMsg = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_CustRegist_IdexPro_Callout_v1.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

        Datetime endDate = System.now();

        Call_Log__c log = new Call_Log__c(
            CallerFrom__c = 'Salesforce', 
            Endpoint__c = endpoint, 
            Type__c = 'Callout',
            Request_Message__c = request,
            Response_Message__c = result,
            Method__c = 'POST',
            Status__c = tokenStatusMsg,
            Request_ID__c = callId,
            Request_Start_Time__c = startDate,
            Response_End_Time__c = endDate
        );
        callLogList.add(log);
    }

    @future(Callout=true)
    public static void UpdateTicketRegistration (ID custRegTicketID){
        SYSTEM.DEBUG ('============== in REST_CustRegist_IdexPro_Callout_v1 class, UpdateTicketRegistration method ==============' );

        List<IdexPro_API_Setting__c> List_IdexPro_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM IdexPro_API_Setting__c WHERE Name = 'UpdateTicketRegistration_Stagging'];

        if(List_IdexPro_APISetting!=null && !List_IdexPro_APISetting.isEmpty()){
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status;
            integer responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String callId = AppUtils.getNewGUID();
            String endpoint;

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   

            Customer_Registration_Ticket__c custRegTicketObj = null;

            //if(custRegTicketID!=null && !custRegTicketID.isEmpty()){
            
                system.debug('custRegTicketObj : ' + custRegTicketObj);

                if (doCallOut) {
                    try {
                        //-- do call out
                        SYSTEM.DEBUG ('============== try to do call out ==============');

                        //system.debug('CustomerRegistrationTicketDetail_extract : ' + CustomerRegistrationTicketDetail_extract);

                        String reqBody = JSON.serialize('');
                        
                        System.debug('>>> reqBody : '+reqBody);

                        endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c;

                        httpRequestObj.setTimeout(120000);
                        httpRequestObj.setEndpoint(endpoint);
                        httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
                        if(Test.isRunningTest()){
                            token = 'Bearer 2121sa';
                        }
                        httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
                        httpRequestObj.setMethod('POST');
                        httpRequestObj.setBody(reqBody); 

                        System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));

                        bodyMesage = reqBody;
                        Datetime startDate = System.now();
                
                        HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                        result = httpResponseObj.getBody();
                        System.debug('>>> result : '+result);

                        Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
                        
                        System.debug ('================= response responsemap : ' + responsemap );
                        System.debug ('================= response status : ' +  (Integer)responsemap.get('status') );
                        
                        Integer errorCode = (Integer)responsemap.get('status');

                        if(errorCode == 200){
                            status = 'success';
                            responseMsg = json.serialize(responsemap);
                        }
                        else if(errorCode == 500){
                            status = 'failed';
                            errorMsg = json.serialize(responsemap);
                        }
                    }
                    catch (Exception e) {
                        //-- error handling for callout
                        SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                        status = 'Failed';
                        errorMsg = errorMsg +  '. Error on REST_CustRegist_IdexPro_Callout_v1.UpdateTicketRegistration method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                        apputils.puterror(errorMsg);
                        SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
                    }

                    // put callout information then save the data on Call_Log object
                    Call_Log__c calllog = new Call_Log__c();
                    calllog.type__c='Callout';
                    calllog.request_start_time__c = requestStartTime;
                    calllog.method__c = 'POST';
                    calllog.callerFrom__c = 'Salesforce' ;
                    calllog.endpoint__c = endpoint ;
                    calllog.uri__c = uri ; 
                    calllog.request_message__c = bodyMesage;
                    calllog.status__c = status;
                    calllog.response_message__c = responseMsg;            
                    calllog.Error_Message__c = errorMsg;
                    calllog.Salesforce_ID_1__c = custRegTicketID;
                    calllog.Customer_Registration_Ticket__c = custRegTicketID;
                    calllog.response_end_time__c = datetime.now();     
                    callLogList.add(calllog);

                    insert callLogList;
                }
            //}
        }

    } 

    global class GET_TOKEN_REQUEST {
        global String username{ get; set; }
        global String password{ get; set; }
    }

    global class GET_TOKEN_RESPONSE {
        global String token{ get; set; }
    }
}