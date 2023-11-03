/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 06-08-2022
 * @last modified by  : Diky Nurosid
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   21-03-2022   Doddy Prima   Initial Version
 * 1.1   06-08-2022   Diky Nurosid  Add ReferenceID in BodyTagging
**/
global with sharing class REST_Tagging_Callout {
    public REST_Tagging_Callout() {

    }

    
 

    public static string accessToken = null;
    public static string tokenResponseMessage = null;

    public static boolean commcodeIsAvailable = false;
    public string responseMessage {get;set;}

    

    //private static void getAccessToken () {
    public static void getAccessToken () {
        string errorMsg='';
        
        //string endpoint = 'https://apigw.xl.co.id/commercial/oauth/create-token';  //--TODO : put this value to custom label
        //string endpoint = label.REST_Exelcom_GetToken_EndPoint;  //--TODO : put this value to custom label
        
        //-- new way
        CommunityToolsAPISetting__c commAPISetting = CommunityToolsAPISetting__c.getOrgDefaults ();
        string endpoint = commAPISetting.TokenRequest_Endpoint__c;
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        //req.setMethod('POST');
        req.setMethod(commAPISetting.TokenRequest_Method__c);
        req.setTimeout(integer.valueOf(commAPISetting.RequestTimeout_General__c));
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        /*OLD way
        string clientId = label.REST_Exelcom_GetToken_ClientId;      
        string clientSecret = label.REST_Exelcom_GetToken_ClientSecret;
        string grantType = label.REST_Exelcom_GetToken_grandType;
        */
        //-- new way
        string clientId = commAPISetting.TokenRequest_ClientID__c;      
        string clientSecret = commAPISetting.TokenRequest_ClientSecret__c;
        string grantType = commAPISetting.TokenRequest_GrantType__c;
        
        String payload = 'client_id='+EncodingUtil.urlEncode(clientId,'UTF-8')
            + '&client_secret='+EncodingUtil.urlEncode(clientSecret,'UTF-8')
            + '&grant_type=' + grantType;
        
        System.debug(payload);
        req.setBody(payload);
        
        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;
        
        
        http = new Http();

        //response = http.send(req);
        
        if (!Test.isRunningTest())
            response = http.send(req);
        else {
            response.setStatusCode(200); response.setStatus('OK'); response.setBody('{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}');
        } 
        
        //string responseMsg = response.getBody ();
        tokenResponseMessage = response.getBody ();
        
            
        System.debug ('================= response message : ' + tokenResponseMessage);
        System.debug ('================= response status : ' + response.getStatus());
        System.debug ('================= response Code : ' + response.getStatusCode());
        System.debug ('================= response Header: ' + response.getHeaderKeys());
        /* response sample
            response message : {"access_token":"k47aujb3r5ge33r6ksfr38v5","token_type":"bearer","expires_in":3600}

        */
        try {
            Map <String, Object> responseMap = (Map <String, Object>) JSON.deserializeUntyped(tokenResponseMessage);
            accessToken = (string) responseMap.get('access_token');

        }
        catch (Exception e) {
            errorMsg = 'Error on REST_Tagging_Callout.getToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + tokenResponseMessage +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            accessToken = null;
            system.debug ('===== errorMsg : ' + errorMsg);

        }
    
        
    }


    /**
     * * TAGGING FUNCTION
     * 
     */

    @future(callout=true) 
    public static void requestTaggingByGroup (string orderid, integer groupNo, integer dataLimit, string scheduledProcessID ) {
        
        system.debug('===== masuk method requestTaggingByGroup ');

        system.debug('orderid nya: '+orderid);
        system.debug('groupNo nya: '+groupNo);
        system.debug('dataLimit nya: '+dataLimit);
        system.debug('scheduledProcessID nya: '+scheduledProcessID);


        //List<Order_MSISDN__c> OrdList = [SELECT Id, name FROM Order_MSISDN__c WHERE order__c =: orderid limit 10];
        //List<Order_MSISDN__c> OrdList = [SELECT name, order__r.ID_COM_Number__c, order__r.COMTYPE__c  FROM Order_MSISDN__c WHERE order__c =: orderid limit 5];
        

        integer dataOffset = (groupNo -1 )* dataLimit;
        List<Order_MSISDN__c> orderMSISDNList = [ SELECT id, name, order__r.ID_COM_Number__c, order__r.COMTYPE__c  
                                            FROM Order_MSISDN__c 
                                            WHERE order__c =: orderid 
                                            //AND PC_Notes__c = 'test'
                                            order by createddate, id 
                                            limit :dataLimit
                                            offset :dataOffset];  

        system.debug('orderMSISDNList size nya: '+orderMSISDNList.size());
        system.debug('orderMSISDNList nya: '+orderMSISDNList);
        
        integer temp;
        string msisdn = '';
        string comcode = '';
        string comtype = '';
        string refId = '';
        getAccessToken();
        
        
        list<BodyTagging> taggingRequest = new list<BodyTagging>();
        list<SP_MSISDN__c> spMSISDNList = new list<SP_MSISDN__c>();

        for (temp=0; temp<orderMSISDNList.size(); temp++){
            system.debug('===  masuk looping tagging ke- '+temp);
            system.debug('temp ke-: '+temp);
            msisdn = orderMSISDNList[temp].Name;
            msisdn = msisdn.trim().replace('\'','').replace('/','');        //--clean value

            comcode = orderMSISDNList[temp].order__r.ID_COM_Number__c;
            comtype = orderMSISDNList[temp].order__r.COMTYPE__c;
            refId = orderMSISDNList[temp].Id; 
            system.debug('msisdn nya: '+msisdn);
            system.debug('comcode nya: '+comcode);
            system.debug('comtype nya: '+comtype);
            system.debug('referenceId nya: '+refId);


            BodyTagging tmpBodyTagging = new BodyTagging();
            
            tmpBodyTagging.msisdn = msisdn;
            tmpBodyTagging.commcode=comcode;
            tmpBodyTagging.commtype = comtype ;
            tmpBodyTagging.comm_priority = '1';
            tmpBodyTagging.comm_priority_type= 'T';
            tmpBodyTagging.referenceId= refId; //update by diky

            /**
             * TODO: fill data
            tmpBodyTagging.commcode = ...
            tmpBodyTagging.commcode = ...
            tmpBodyTagging.commcode = ...

            dst ..
            */

            taggingRequest.add (tmpBodyTagging);



            /* tutup dulu 
            SP_MSISDN__c tmpSPMISISDN = new SP_MSISDN__c();
            tmpSPMISISDN.name= msisdn;
            tmpSPMISISDN.Order_MSISDN__c = ordList[temp].id;
            tmpSPMISISDN.Scheduled_Process__c = scheduledProcessID;
            spMSISDNList.add(tmpSPMISISDN);
            */

        }

        /* tutup dulu */
        //* ToDo : implement try and catch
        //insert spMSISDNList;


        system.debug ('======== taggingRequest : ' + JSON.serialize(taggingRequest));
        
        string jsonString=JSON.serialize(taggingRequest);


        taggingComm(jsonString, scheduledProcessID);


    }

    //@future(callout=true)
    public static void taggingComm (string jsonString, string scheduledProcessID) {   //, integer groupNo ){
        system.debug ('==== in REST_Tagging_Callout.taggingComm ');

        //-- create requesst-id  [xxx-scheduled-processid][yyMMddhhss][00=groupno]
        //string dtNow = system.now().format('yyMMddhhss');
        //string gNo = String.valueOf(groupNo).leftPad(2, '0');
        //string requestID = scheduledProcessID.substring(12, 15) + dtNow + gNo;
        string requestID = scheduledProcessID; //-- * pakai scheduledProcessID untuk request_id 

        string requestID_short;
        string endPoint;
        string URI;
        string requestMsg ;
        string responseMsg ;
        Integer responseCode ;
        string status=null;
        string errorMsg='';
        //string jsonString;
        string orderID=null;

        string cURL = '';

        Datetime requestStartTime = datetime.now();
        //endpoint = 'https://apigw.xl.co.id/commercial/api/v1/commtools/';       //--TODO : put this value to custom label
        //OLD way
        //endpoint = label.REST_Exelcom_GSM_Endpoint; 
        //URI = 'add-subscriber';
        
        //-- new way
        CommunityToolsAPISetting__c commAPISetting = CommunityToolsAPISetting__c.getOrgDefaults ();
        endpoint = commAPISetting.TaggingCommunity_Endpoint__c;
        

        //-- get access token first
        /*if(accessToken == null){
            getAccessToken();
        }*/ 
        getAccessToken();
        system.debug ('==== accessToken : ' +  accessToken);
        
        if (accessToken != null) {
            //--request to community check
            
            //endpoint = 'https://apigw.xl.co.id/commercial/api/v1/commtools/';       //--TODO : put this value to custom label
            //URI = 'add-subscriber';
            //requestID = AppUtils.getNewGUID() ;
            //requestID_short = requestID.right(16);
            
            String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

            HttpRequest req = new HttpRequest();
			//old way
            //req.setEndpoint(endpoint + URI);
            
            //new way
            req.setEndpoint(endpoint);
            //req.setMethod('POST');
            req.setMethod(commAPISetting.TaggingCommunity_Method__c);
            req.setTimeout(integer.valueOf(commAPISetting.RequestTimeout_General__c));
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);    //--access token sample : k47aujb3r5ge33r6ksfr38v5
            req.setHeader('channel', 'WEB');
            req.setHeader('requestdate', requestDate); // '2020-03-06T15:16:00');        
            //req.setHeader('requestid', requestID);         
            //req.setHeader('requestid', requestID_short);


            //req.setHeader('requestid', '1111');         
            req.setHeader('requestid', requestID);         


            //set body
            //Body oBody = new Body();
            //oBody.msisdn = msisdn;
            //oBody.commcode=commcode;
            //oBody.commtype = commtype ;
            //oBody.comm_priority = comm_priority;
            //oBody.comm_priority_type= comm_priority_type;
                
                //jsonString = JSON.serialize(oBody);
                //system.debug ('================= oBody1 :' + oBody );    
                //system.debug ('================= oBody2 :' + jsonString );
                
                
            req.setBody(jsonString);

            cURL = 'curl -X POST \\ ' + '\r\n' ;
            //old way
            //cURL = cURL + '  ' + endpoint + URI + ' \\ ' + '\r\n' ;
            //new way
            cURL = cURL + '  ' + endpoint + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'authorization: Bearer ' + accessToken + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'Accept: application/json'  + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'cache-control: no-cache'  + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'channel: WEB' + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'content-type: application/json'  + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'requestdate: ' + requestDate  + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'requestid: ' + requestID + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -d ' + '\'' + jsonString + '\'' ;

            
            try {
                //status = 'success';
                Http http = new Http();
                HTTPResponse response = new HTTPResponse() ;

                http = new Http();
                if (!Test.isRunningTest())
                response = http.send(req);
                responseMsg = response.getBody ();
                responseCode = response.getStatusCode();
                //responseMsg = string.valueof(responseCode);
                System.debug ('================= request message  end point: ' + endpoint);
                System.debug ('================= response message Code : ' + response.getStatusCode() );
                
                
                //Map <String, Object> responseMap = (Map <String, Object>) JSON.deserializeUntyped(responseMsg);
                //string commcode = (string) responseMap.get('commcode');
                // string error = (string) responseMap.get('error');
                
                System.debug ('================= response message body: ' + response.getBody ());
                    
                
                // string status = '';
                    
                if (responseCode == 201) {
                    //--response is success
                    //--TODO: do something
                    /*List<Order_MSISDN__c> lstOrdMsisdns = [SELECT id, Name, Status__c, order__c 
                                                            FROM Order_MSISDN__c 
                                                            WHERE order__r.ID_COM_Number__c =:commcode];
                    for (Order_MSISDN__c lorm :lstOrdMsisdns){
                        lorm.Status__c = 'Success';
                    }
                    update lstOrdMsisdns;                   
                    */                  
                    status = 'Success';

                } else {
                    //--response is failed
                    status = 'Failed';
                    errorMsg = responseMsg;
                    apputils.puterror(errorMsg);


                }

            } catch (Exception e) {
                status = 'Failed';
                errorMsg = 'Error on REST_Tagging_Callout.taggingComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                //accessToken = null;
                //responseMsg;
                system.debug ('===== errorMsg : ' + errorMsg);

            }

            
            
        
        } else {
            //--Access Token not Available
            //--TODO: Do something
            responseMsg = tokenResponseMessage;
            status = 'Failed';
            errorMsg = 'Access Token not Available';
            system.debug ('===== errorMsg : ' + errorMsg);


        }

        //-- * update Scheduled_Process__c status
        List<Scheduled_Process__c> tmpSPList = [select id, order_related__c, status__c, request_ID__c from Scheduled_Process__c where id =:scheduledProcessID];
        
        if (tmpSPList.size() == 1) {
            tmpSPList[0].status__c = status;
            tmpSPList[0].request_ID__c = requestID;
            update tmpSPList[0];

            orderID = tmpSPList[0].order_related__c;
        }
        //----------------------------------------
        


        //-- FAILED HANDLING ---------------------
        system.debug('====== order id : '+orderid);
        List<Order> orderList = [SELECT id, Status FROM Order WHERE id =:orderid];

        try {
            if(status == 'Failed'){
                for (order ord :orderList){
                    ord.status = 'Draft';
                }
                update orderList;
            }
        } catch (Exception e) {
            status = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Tagging_Callout.taggingComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
        
        // put callout information then save the data on Call_Log object
        Call_Log__c calllog = new Call_Log__c();
        
        //calllog.request_ID__c= requestID_short;
        //calllog.request_ID__c= '1111';
        calllog.request_ID__c= requestID;

        calllog.type__c='Callout';
        calllog.request_start_time__c = requestStartTime;
        //calllog.method__c = 'POST';
        calllog.method__c = commAPISetting.TaggingCommunity_Method__c;
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
        calllog.uri__c = uri ; 
        calllog.request_message__c = jsonString;
        calllog.status__c = status;
        calllog.response_message__c = string.valueof(responseCode)+' '+responseMsg;            
        calllog.Error_Message__c = errorMsg;
        calllog.Salesforce_ID_1__c = scheduledProcessID;
        calllog.scheduled_process_related__c = scheduledProcessID;
        calllog.order_related__c = orderID;
        calllog.response_end_time__c = datetime.now();    
        calllog.cURL__c = cURL.left(131070); 
        insert calllog;


        
    }









    /**
     * * TAGGING CHECK FUNCTION
     * 
     */




    @future(callout=true) 
    public static void requestTaggingCheckByGroup (string orderid, integer groupNo, integer dataLimit, string scheduledProcessID) {
        system.debug('===== masuk method requestTaggingCheckByGroup ');

        system.debug('orderid nya: '+orderid);
        system.debug('groupNo nya: '+groupNo);
        system.debug('dataLimit nya: '+dataLimit);
        system.debug('scheduledProcessID nya: '+scheduledProcessID);

        // ** SAMPAI SINI **\\
        /**
         * * pakai SP_MSISDN
         */



        integer dataOffset = (groupNo -1 )* dataLimit;
        /*
        List<Order_MSISDN__c> OrdList = [ SELECT name
                                            FROM Order_MSISDN__c 
                                            WHERE order__c =: orderid 
                                            //AND PC_Notes__c = 'test'
                                            order by createddate, id 
                                            limit :dataLimit
                                            offset :dataOffset];*/

        //-- * get parent scheduledProcessID (TAGGING)

        Scheduled_Process__c  parentSP = [select id, Scheduled_Process_Related__c from Scheduled_Process__c where id =:scheduledProcessID];
        string parentScheduledProcessID = parentSP.Scheduled_Process_Related__c;


        List<SP_MSISDN__c> spMSISDNist = [ SELECT name, Order_MSISDN__r.MSISDN__c
                                            FROM SP_MSISDN__c 
                                            WHERE Scheduled_Process__c =: parentScheduledProcessID 
                                            //AND PC_Notes__c = 'test'
                                            order by createddate, id 
                                            limit :dataLimit
                                            offset :dataOffset
                                            ];                                    

        system.debug('spMSISDNist size nya: '+spMSISDNist.size());
        system.debug('spMSISDNist nya: '+spMSISDNist);
        
        integer temp;
        string msisdn = '';
        string comcode = '';
        string comtype = '';
        getAccessToken();
        
        
        list<TaggingCheck> taggingCheckRequest = new list<TaggingCheck>();
        
        
        string bodyMesage = '['; 
        if (spMSISDNist.size() >0) {
            for (temp=0; temp<spMSISDNist.size(); temp++){
                system.debug('===  masuk looping tagging ke- '+temp);
                system.debug('temp ke-: '+temp);
                msisdn = spMSISDNist[temp].Name;
                msisdn = msisdn.trim().replace('\'','').replace('/','');        //--clean value

                bodyMesage = bodyMesage + '"' + msisdn + '",';
            }
            bodyMesage = bodyMesage.LEFT(bodyMesage.LENGTH() -1);
        }
        bodyMesage = bodyMesage + ']';


        system.debug ('======== bodyMesage : ' + bodyMesage);
        
        taggingCommCheck(bodyMesage, scheduledProcessID);
    }
    
    //@future(callout=true) 
    public static void taggingCommCheck (string bodyMesage,  string scheduledProcessID ){
        
        string requestID;
        string requestID_short;
        string endPoint;
        string URI;
        string requestMsg ;
        string responseMsg ;
        Integer responseCode ;
        string status=null;
        string errorMsg='';
        string orderID = '';
        string cURL = '';

        Datetime requestStartTime = datetime.now();
        //old way
        //endpoint = label.REST_Exelcom_GSM_Endpoint; 
        //URI = 'tagging-status';
        
        //--new way
        CommunityToolsAPISetting__c commAPISetting = CommunityToolsAPISetting__c.getOrgDefaults ();
        endpoint = commAPISetting.TaggingStatusCommunity_Endpoint__c;


        Scheduled_Process__c tmpSP = [select id, order_related__c, status__c, request_ID__c, is_last_schedule_of_group__c from Scheduled_Process__c where id =:scheduledProcessID];
        requestID =  tmpSP.request_ID__c;
        orderID = tmpSP.order_related__c;

        getAccessToken();
        system.debug ('==== accessToken : ' +  accessToken); 
        
        if (accessToken != null) {
            
            //requestID = AppUtils.getNewGUID() ;
            //requestID_short = requestID.right(5);
            String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

            HttpRequest req = new HttpRequest();

            //old way
            //req.setEndpoint(endpoint + URI);
            
            //new way
            req.setEndpoint(endpoint);
            //req.setMethod('POST'); 
            req.setMethod(commAPISetting.TaggingStatusCommunity_Method__c);
            req.setTimeout(integer.valueOf(commAPISetting.RequestTimeout_General__c));
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);    //--access token sample : k47aujb3r5ge33r6ksfr38v5
            req.setHeader('channel', 'WEB');
            req.setHeader('requestdate', requestDate) ; //'2020-03-06T15:16:00');        
            req.setHeader('requestid', requestID);         
            //req.setHeader('requestid', requestID_short);
            //req.setHeader('requestid', '1111');         
            
            req.setBody(bodyMesage);

            cURL = 'curl -X POST \\ ' + '\r\n' ;
            //old way
            //cURL = cURL + '  ' + endpoint + URI + ' \\ ' + '\r\n' ;
            //new way
            cURL = cURL + '  ' + endpoint + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'authorization: Bearer ' + accessToken + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'Accept: application/json'  + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'cache-control: no-cache'  + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'channel: WEB' + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'content-type: application/json'  + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'requestdate: ' + requestDate  + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -H ' + '\'' + 'requestid: ' + requestID + '\'' + ' \\ ' + '\r\n' ;
            cURL = cURL + '  -d ' + '\'' + bodyMesage + '\'' ;

            
            try {
                //status = 'success';
                Http http = new Http();
                HTTPResponse response = new HTTPResponse() ;

                http = new Http();
                /*if (!Test.isRunningTest())
                response = http.send(req);
                */
                if (!Test.isRunningTest())
		            response = http.send(req);
		        else {
		            response.setStatusCode(200); response.setStatus('OK'); response.setBody('[{"msisdn":"6283895100530","status":"SUCCESS"},{"msisdn":"6283895100585","status":"FAILED"}]');
		        }  
                
                responseMsg = response.getBody ();
                responseCode = response.getStatusCode();
                //responseMsg = string.valueof(responseCode);
                System.debug ('================= request message  end point: ' + endpoint);
                System.debug ('================= response message Code : ' + response.getStatusCode() );
                System.debug ('================= response message body: ' + response.getBody ());
                
                
                
                if (responseCode == 200) {
                                    
                    status = 'Success';
                    //errorMsg = responseMsg;

                    // TODO : update msisdn status . 
                    /* response sample data
                        [ {
                        "msisdn": "6283895100530",
                        "status": "SUCCESS"
                        },
                        {
                        "msisdn": "6283895100585",
                        "status": "FAILED"
                        } ] */
                        
                    /*----------------------------------------------------------------*/
                    String jsonResponse = '{"data": ' + responseMsg + '}';
                    Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
                    List <Object> objList = (List<Object>)  AppUtils.getListDataOnMap(paramMap, 'data');
                    System.debug('objList nya : ' + objList); 
                    
                    string msisdn = '';
                    string msisdnStatus = '';
                    string errorCode ='';
                    integer temp;
    
                    //List <string> mssisdnStringList = new List <string> ();
                    List <string> mssisdnStringListSuccess = new List <string> ();
                    List <string> mssisdnStringListFailed = new List <string> ();
                    
                    Map <string , ErrorInfo> errorMap = new  Map <string , ErrorInfo>();
                    
                    for (Object obj : objList) {
                        Map<String, Object> tmpMapRec = (Map<String, Object>) obj;
                        msisdn = AppUtils.getStringDataOnMap(tmpMapRec, 'msisdn') ;
                        msisdnStatus = AppUtils.getStringDataOnMap(tmpMapRec, 'status');
                        errorCode = AppUtils.getStringDataOnMap(tmpMapRec, 'error');
                        
                        System.debug('msisdn nya : ' + msisdn);
                        System.debug('msisdn nya : ' + msisdnStatus);
                        
                        if (msisdnStatus == 'SUCCESS'){
                            mssisdnStringListSuccess.add(msisdn);
                        }   
                        
                        if (msisdnStatus == 'FAILED'){
                            mssisdnStringListFailed.add(msisdn);

                            ErrorInfo errorInfoObj = new ErrorInfo ();
                            errorInfoObj.ErrorCode = (errorCode==null) ? '' : errorCode;
								
                            for (Tagging_Untagging_Error_Definition__c TUEDObj : Tagging_Untagging_Error_Definition__c.getAll().values()) {
                                if (TUEDObj.Error_Code__c == errorCode && TUEDObj.type__c == 'Tagging') {
                                    errorInfoObj.ErrorDescription = TUEDObj.For_User_Description__c;
                                    errorInfoObj.ErrorDescriptionSystem = TUEDObj.System_Description__c;
                                }
                                
                            }
                            
                            errorMap.put (msisdn, errorInfoObj);

                        }   
                        
                        //mssisdnStringList.add(msisdn);
                    } 
                    //system.debug('mssisdnStringList nya :'+mssisdnStringList);
                    system.debug('mssisdnStringListSuccess nya :'+mssisdnStringListSuccess);
                    system.debug('mssisdnStringListFailed nya :'+mssisdnStringListFailed);
                    
                    //Update Tagging Status Failed 
                    List<Order_MSISDN__c> LstmsisdnSuccess = [select id,status__c, msisdn__r.name , Error_Description__c, Error_Code__c, Error_Description_System__c
                                                                from Order_MSISDN__c 
                                                                WHERE Order__c = :orderID AND msisdn__r.name IN :mssisdnStringListSuccess];

                    system.debug('LstmsisdnSuccess size nya :'+LstmsisdnSuccess.size());
                    system.debug('LstmsisdnSuccess  nya :'+LstmsisdnSuccess);
                    
                    for(Order_MSISDN__c LstOrderMsisdnSuccess : LstmsisdnSuccess){	
                            LstOrderMsisdnSuccess.status__c = 'Success';	
                            LstOrderMsisdnSuccess.Error_Description__c = '';
                            LstOrderMsisdnSuccess.Error_Code__c = ''; 
                            LstOrderMsisdnSuccess.Error_Description_System__c = '';
                    }                        
                    update LstmsisdnSuccess;
                    
                    List<Order_MSISDN__c> LstmsisdnFailed = null;

                    if (system.label.TAGGING_CHECK_FAILED_UPDATE_MODE == 'IGNORE SUCCESS') {
                        //Update Tagging Status Failed
                        LstmsisdnFailed = [select id,status__c , msisdn__r.name
                                                from Order_MSISDN__c 
                                                WHERE msisdn__r.name IN :mssisdnStringListFailed
                                                AND status__c != 'Success'
                                                ];
                    
                    } else if (system.label.TAGGING_CHECK_FAILED_UPDATE_MODE == 'NORMAL') {
                        //Update Tagging Status Failed
                        LstmsisdnFailed = [select id,status__c , msisdn__r.name
                                                from Order_MSISDN__c 
                                                WHERE msisdn__r.name IN :mssisdnStringListFailed
                                                ];
                    }

                    system.debug('LstmsisdnFailed size nya :'+LstmsisdnFailed.size());
                    system.debug('LstmsisdnFailed  nya :'+LstmsisdnFailed);
                    
                    for(Order_MSISDN__c LstOrderMsisdnFailed : LstmsisdnFailed){
                            LstOrderMsisdnFailed.status__c = 'Failed';	
                            
                            ErrorInfo errorInfoObj = (ErrorInfo) errorMap.get(LstOrderMsisdnFailed.msisdn__r.name);
                            LstOrderMsisdnFailed.Error_Description__c = errorInfoObj.errorDescription;
                            LstOrderMsisdnFailed.Error_Code__c = errorInfoObj.errorCode; 
                            LstOrderMsisdnFailed.Error_Description_System__c = errorInfoObj.errorDescriptionSystem;
                    }                        
                    update LstmsisdnFailed;
                    
                    /* --- TUTUP DULU
                    List<Order_MSISDN__c> LstOrderNotSuccess = [select id,status__c from Order_MSISDN__c WHERE Order__c =:orderID AND status__c != 'Success'];
                    //system.debug('LstOrderNotSuccess size nya :'+LstOrderNotSuccess.size());
                    if (LstOrderNotSuccess.size()== 0){
                        List<Order> LorderQuery = [SELECT id, status FROM order WHERE id=:orderID];                     
                        for(Order OQ : LorderQuery){
                            OQ.status = 'Complete';
                        }                        
                        update LorderQuery;
                    }
                    */

                    //* ---- CREATE SCHEDULER FOR CHECK ALL MSISDN_ORDER STATUS -------
                    if (tmpSP.is_last_schedule_of_group__c == TRUE) {
                        integer jeda = 1 ; //-- in minute
                        Datetime nextSchedule = system.now().addMinutes(jeda);
                        string sYear = string.valueof( nextSchedule.year() );
                        string sMonth = string.valueof( nextSchedule.month() );
                        string sDay = string.valueof( nextSchedule.day() ); 
                        string sHour = string.valueof( nextSchedule.Hour() );
                        string sMinute = string.valueof( nextSchedule.minute() );
                        
                        string sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
                        system.debug ('============ sch :' + sch);

                        string jobTitle = 'CheckAllOrder_MSISDNStatus ' + sch + ' (Order ID : ' +  orderID + ')';
                
                        //-- create schedule process (consist of information related to data tobe process, see on parameter2 )
                        Scheduled_Process__c sp = new Scheduled_Process__c();
                        sp.Execute_Plan__c = nextSchedule;
                        sp.Type__c = 'Check All Order_MSISDN Status';
                        sp.parameter1__c = orderID;
                        sp.parameter2__c =  '';
                        sp.parameter3__c = '';  //--nanti diisi jobID
                        sp.jobid__c = '';       //--nanti diisi jobID
                        sp.order_related__c = orderID;
                        sp.title__c = jobTitle;  
                        sp.notes1__c = 'Parameter1 = OrderID; Parameter3 = JobID';
                        insert sp;
                        //-------------------------------------


                        //-- create Schedule Process Service --------------------------------------
                        Scheduled_Process_Services sps = new Scheduled_Process_Services();
                        sps.jobType = sp.Type__c;   
                        sps.scheduledProcessID = sp.id;  // <<-- this is the key

                        //-- create scheduler
                        string jobID = system.schedule(jobTitle, sch, sps);

                        sp.jobid__c = jobID;
                        sp.title__c = jobTitle;
                        sp.parameter3__c = jobID;

                        update sp;
                    }
                    //----------------------------------------------------------------------

                    //* ---- END of CREATE SCHEDULER ------------------------------------------ *****

                    
                    
                    //system.debug('Lstmsisdn update nya :'+Lstmsisdn[0].status__c);
                    
                    /*-------------------------------------------------------------------*/ 
                    /* select data di Order_MSISDN__c  where order__c = orderID and masisdn/name in (response msdisn yang Success)

                    for (response) {
                        status__c = 'Success'

                    }

                        /* select data di Order_MSISDN__c  where order__c = orderID and masisdn/name in (response msdisn yang FAiled)

                    for (response) {
                        status__c = 'Failed'

                    }

                    buat Process Builder untuk Order_MSISDN__c, 
                    nama : Set_MSISDN_Status
                    jika status == Success dan RT tagging 
                        set tagged__c di MSISDN__c = TRUE
                        
                    */





                } else {
                    //--response is failed
                    status = 'Failed';
                    errorMsg = responseMsg;
                    //apputils.puterror(errorMsg);

                }

            } catch (Exception e) {
                status = 'Failed';
                errorMsg = 'Error on REST_Tagging_Callout.taggingCommCheck method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                accessToken = null;
                //responseMsg;
                system.debug ('===== errorMsg : ' + errorMsg);
            }

            
            
        
        } else {
            //--Access Token not Available
            //--TODO: Do something
            responseMsg = tokenResponseMessage;
            status = 'Failed';
            errorMsg = 'Access Token not Available';
            system.debug ('===== errorMsg : ' + errorMsg);

        }


        //-- * update Scheduled_Process__c status
            
        tmpSP.status__c = status;
        //tmpSP.request_ID__c = requestID;
        update tmpSP;
        //----------------------------------------


        //-- FAILED HANDLING ---------------------
        system.debug('====== order id : '+orderid);
        List<Order> orderList = [SELECT id, Status FROM Order WHERE id =:orderid];

        try {
            if(status == 'Failed'){
                orderList[0].GSMTaggingCheck_Status__c = 'No Status' ; update orderList;
                orderList[0].GSMTaggingCheck_Status__c = 'Failed' ; update orderList;
            }
            else if(status == 'Success'){
                orderList[0].GSMTaggingCheck_Status__c = 'No Status' ; update orderList;
                orderList[0].GSMTaggingCheck_Status__c = 'Success' ; update orderList;
            }

        } catch (Exception e) {
            status = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Tagging_Callout.taggingCommCheck method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);

        }

        // put callout information then save the data on Call_Log object
        Call_Log__c calllog = new Call_Log__c();
        //calllog.request_ID__c= requestID_short;
        //calllog.request_ID__c= '1111';
        calllog.request_ID__c= requestID;

        calllog.type__c='Callout';
        calllog.request_start_time__c = requestStartTime;
        //calllog.method__c = 'POST';
        calllog.method__c = commAPISetting.TaggingStatusCommunity_Method__c;
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
        calllog.uri__c = uri ; 
        calllog.request_message__c = bodyMesage;
        calllog.status__c = status;
        calllog.response_message__c = string.valueof(responseCode)+' '+responseMsg;            
        calllog.Error_Message__c = errorMsg;
        calllog.Salesforce_ID_1__c = scheduledProcessID;
        calllog.scheduled_process_related__c = scheduledProcessID;
        calllog.order_related__c = tmpSP.order_related__c;
        calllog.response_end_time__c = datetime.now();     
        calllog.cURL__c = cURL.left(131070);
        insert calllog;

        //-- TODO :: put call-id to scheduled process
        //-- 
        Scheduled_Process__c sp = new Scheduled_Process__c();
        sp.id = scheduledProcessID;
        sp.status__c = status;
        update sp;
        


    }

    class BodyTagging {
        String commcode = null;
        String commtype = null;
        String msisdn = null;
        String comm_priority = null;
        String comm_priority_type = null;
        String referenceId= null; //-- reference id update diky 8/6/2022
    }
    
    class TaggingCheck {
        String msisdn = null;
    }
    

    class ErrorInfo {
        string msisdn;
        string errorDescription;
        string errorCode;
        string errorDescriptionSystem;
    }
}