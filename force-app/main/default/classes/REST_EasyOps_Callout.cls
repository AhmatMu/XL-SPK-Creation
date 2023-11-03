/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 07-07-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   08-18-2022   Diky Nurosid   Initial Version
 * 2.0   05-07-2023   Muhammad Bustamil Adamm Update Methode
**/

global with sharing class REST_EasyOps_Callout {
    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String token;
    public static Boolean doCallOut = false;
    
    public static void getAccessToken() {
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
    
        //ganti ke easyops custom setting
        List<Easy_Ops_API_Setting__c> REST_EasyOps_Callout = [SELECT Password__c, URI__c, URL__c, Username__c FROM Easy_Ops_API_Setting__c WHERE Name = 'getToken2'];
    
        try {  
            if (REST_EasyOps_Callout != null && !REST_EasyOps_Callout.isEmpty()) {
                endpoint = REST_EasyOps_Callout[0].URI__c + REST_EasyOps_Callout[0].URL__c;
    
                httpRequestObj.setEndpoint(endpoint);
                httpRequestObj.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                httpRequestObj.setMethod('POST');
                httpRequestObj.setTimeout(120000);
    
                // Construct the form data
                String formData = 'password=' + EncodingUtil.urlEncode(REST_EasyOps_Callout[0].Password__c, 'UTF-8') +
                    '&username=' + EncodingUtil.urlEncode(REST_EasyOps_Callout[0].Username__c, 'UTF-8');
    
                httpRequestObj.setBody(formData);
    
                HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
    
                request = String.ValueOf(httpRequestObj);
                System.debug('>>> request_getAccessToken : '+ request);
    
                result = httpResponseObj.getBody();
                System.debug('>>> result1 : '+ result);
    
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
            errorMsg = errorMsg +  '. Error on REST_EasyOps_Callout.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            System.debug ('===== errorMsg : ' + errorMsg);
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
    public static void CreateSPK(ID custRegTicketID){
        SYSTEM.DEBUG ('============== in REST_EasyOps_Callout class, create ticket method ==============' );

        //custom setting
        List<Easy_Ops_API_Setting__c> REST_EasyOps_Callout = [SELECT Password__c, URI__c, URL__c, Username__c FROM Easy_Ops_API_Setting__c WHERE Name = 'createSPK'];

        if(REST_EasyOps_Callout!=null && !REST_EasyOps_Callout.isEmpty()){
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

            // Create the request body
            Map<String, Object> requestBody = new Map<String, Object>();
            
 
            List<Map<String, Object>> dataList = new List<Map<String, Object>>();
            Map<String, Object> dataMap = new Map<String, Object>();
            dataMap.put('cid', '29-00004');
            dataMap.put('pr_number', 'PR-2212-005000'); 
            dataMap.put('sf_spk_id', 'SPK_01');
            dataMap.put('link_id','038C563L5');
            dataMap.put('bp_number', '762416');
            dataMap.put('bp_site_a', '762562');
            dataMap.put('bp_site_b', '769155');
            dataMap.put('uom','Mbps');
            dataMap.put('spk_date','2023-02-06');
            dataMap.put('spk_type', 'Installation');
            dataMap.put('spk_type_add','BWA');
            dataMap.put('spk_description', 'relokasi ATM');
            dataMap.put('location','PERUMAHAN SIDOKARE ASRI BLOK AX NO. 14 RT. 021 RW. 006 SEPANDE CANDI');
            dataMap.put('notification_sr','SR-2210-006088');
            dataMap.put('type_of_project','project');
            dataMap.put('start_date','2023-02-06');
            dataMap.put('end_date', '2023-02-10');
            dataMap.put('site', 'A');
            dataMap.put('pic_cus_name', 'Welly');
            dataMap.put('pic_cus_contact', '08113611111');
            dataMap.put('user_created', 'shar*****@xl.co.id');
            dataMap.put('capacity', '5');
            dataMap.put('capacity_before' ,'2');
            dataMap.put('branch_name','test');
            dataMap.put('vlan', '-');
            dataMap.put('pq_number', '-');
            dataMap.put('service_type', 'LL');
            dataMap.put('partner_id', '122331');
            dataMap.put('object_lease_type','BWA');
            dataMap.put('object_lease_description','converter');
            dataMap.put('partner_pic', 'Agungdjaja Rachman');
            dataMap.put('partner_email','Agung@smartlintas.com');
            dataMap.put('partner_phone', '087882861111');
            dataMap.put('partner_address', 'Cosa Building, 4th Floor, Jl. Tomang Raya No.70, RT.1/RW.3, Jatipulo, Kec. Palmerah, Jakarta, Daerah Khusus Ibukota Jakarta 11430');
            dataMap.put('spk_number_related', '');

            dataList.add(dataMap);

            requestBody.put('data', dataList);
            requestBody.put('request_id', callId);
           

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   

            if (doCallOut) {
                try {
                    //-- do call out
                    SYSTEM.DEBUG ('============== try to do call out ==============');

                    String reqBody = JSON.serialize(requestBody);
                    
                    System.debug('>>> reqBody : '+reqBody);

                    endpoint = REST_EasyOps_Callout[0].URI__c + REST_EasyOps_Callout[0].URL__c;

                    httpRequestObj.setTimeout(120000);
                    httpRequestObj.setEndpoint(endpoint);
                    httpRequestObj.setHeader('Content-Type', 'application/json');
                    if(Test.isRunningTest()){
                        token = 'Bearer 2121sa';
                    }
                    httpRequestObj.setHeader('Accept', 'application/json');
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
                    errorMsg = errorMsg +  '. Error on REST_EasyOps_Callout.createSPK method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
                }

                // put callout information then save the data on Call_Log object
                Call_Log__c calllog = new Call_Log__c();
                calllog.type__c='Callout';
                calllog.request_start_time__c = requestStartTime;
                calllog.method__c = 'POST';
                calllog.callerFrom__c = 'Salesforce';
                calllog.endpoint__c = endpoint ;
                calllog.uri__c = uri ; 
                calllog.request_message__c = bodyMesage;
                calllog.status__c = status;
                calllog.response_message__c = responseMsg;            
                calllog.Error_Message__c = errorMsg;
                calllog.Salesforce_ID_1__c = custRegTicketID;
                calllog.Request_ID__c= callId;
                calllog.response_end_time__c = datetime.now();     
                callLogList.add(calllog);

                insert callLogList;
            }
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