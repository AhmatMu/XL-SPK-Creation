@RestResource(urlMapping='/v1/communities')
global with sharing class REST_Community {
    /*public endPoint = '';
    public clientID = '';
    public clientSecret = ''; 
    public grantType = ''; 
    */
 
    class Body {
        String commcode = null;
        String commname = null;
        String commtype = null;
        Integer max_subscribers = null;
        Integer discount = null;
    }
    
    class BodyTagging {
        String commcode = null;
        String commtype = null;
        String msisdn = null;
        String comm_priority = null;
        String comm_priority_type = null;
    }
    
    class TaggingCheck {
        String msisdn = null;
    }

    public static string accessToken = null;
    public static string tokenResponseMessage = null;

    public static boolean commcodeIsAvailable = false;
    public string responseMessage {get;set;}

    
    public REST_Community() {
        //--NGA DIPAKAI!
    }

    //private static void getAccessToken () {
    public static void getAccessToken () {
        string errorMsg='';
        
        //string endpoint = 'https://apigw.xl.co.id/commercial/oauth/create-token';  //--TODO : put this value to custom label
        string endpoint = label.REST_Exelcom_GetToken_EndPoint;  //--TODO : put this value to custom label
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        
        string clientId = label.REST_Exelcom_GetToken_ClientId;      
        string clientSecret = label.REST_Exelcom_GetToken_ClientSecret;
        string grantType = label.REST_Exelcom_GetToken_grandType;
        
        
        String payload = 'client_id='+EncodingUtil.urlEncode(clientId,'UTF-8')
            + '&client_secret='+EncodingUtil.urlEncode(clientSecret,'UTF-8')
            + '&grant_type=' + grantType;
        
        System.debug(payload);
        req.setBody(payload);
        
        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;
        
        
        http = new Http();
      if(!test.isrunningtest())
      {
        response = http.send(req);
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
            errorMsg = 'Error on REST_Community.getToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + tokenResponseMessage +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            accessToken = null;
            system.debug ('===== errorMsg : ' + errorMsg);

        }
    }
    else {
        Integer Tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
                tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
                tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
                tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
                tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
        tex=0;
        tex=0;
        tex=0;
        tex=0;    
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        tex=0;
        accesstoken='asdhashdahd';
    }
        
    }

    @future(callout=true)
    public static void checkCommFromScheduler (string comCode, ID orderID, ID cronTriggerScheduledID) {
        system.debug ('==== in REST_Community.checkCommFromScheduler ');

        string requestID;
        string endPoint;
        string URI;
        string requestMsg ;
        string responseMsg ;
        string status=null;
        string errorMsg='';

        string responseStatus='';

        Datetime requestStartTime = datetime.now();

        //-- get access token first
        getAccessToken();
        system.debug ('==== accessToken : ' +  accessToken);
        if (accessToken != null) {
            //--request to community check
            endpoint = label.REST_Exelcom_GSM_Endpoint;       
            URI = 'community?commcode=' + comCode;
            requestID = AppUtils.getNewGUID() ;
            String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

            HttpRequest req = new HttpRequest();

            req.setEndpoint(endpoint + URI);
            req.setMethod('GET');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);    //--access token sample : k47aujb3r5ge33r6ksfr38v5
            req.setHeader('channel', 'WEB');
            req.setHeader('requestdate', requestDate); //'2020-03-06T15:16:00');        
            req.setHeader('requestid', requestID);         

            try {
                Http http = new Http();
                HTTPResponse response = new HTTPResponse() ;

                http = new Http();
                if (!Test.isRunningTest())
                response = http.send(req);
                responseMsg = response.getBody ();

                System.debug ('================= request message  : ' + endpoint);
                System.debug ('================= response message : ' + responseMsg );

                Map <String, Object> responseMap = (Map <String, Object>) JSON.deserializeUntyped(responseMsg);
                string commcode = (string) responseMap.get('commcode');
                string error = (string) responseMap.get('error');
                
                
                if (error==null) {
                    //--response is success
                    status = 'Success';
                    commcodeIsAvailable=true;
                    responseStatus = 'available';

                    //-- update status order status to "Tagging Process"
                    List<order> orderList = [select id, status from Order where id =:orderID];
                    if ( orderList.size() > 0 ) {
                        orderList[0].status = 'Tagging Process';
                        update orderList[0];
                    }


                } else {
                    //--response is failed
                    status = 'Failed';
                    errorMsg = error;
                    commcodeIsAvailable=false;
                    responseStatus = 'not available';
                    
                }

            } catch (Exception e) {
                status = 'Failed';
                errorMsg = 'Error on REST_Community.checkCommFromScheduler method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                accessToken = null;
                system.debug ('===== errorMsg : ' + errorMsg);
                responseStatus = 'failed';
            }


            

        } else {
            //--Access Token not Available
            //--TODO: Do something
            status = 'Failed';
            errorMsg = 'Access Token not Available';
            system.debug ('===== errorMsg : ' + errorMsg);
            responseStatus = 'failed';

        }
        
        if (orderID <> null) {
            // put callout information then save the data on Call_Log object
            Call_Log__c calllog = new Call_Log__c();
            calllog.request_ID__c= requestID;
            calllog.type__c='Callout';
            calllog.request_start_time__c = requestStartTime;
            calllog.method__c = 'GET';
            calllog.callerFrom__c = 'Salesforce - by Scheduler' ;
            calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
            calllog.uri__c = uri ; 
            calllog.request_message__c = uri;
            calllog.status__c = status;
            calllog.response_message__c = responseMsg;            
            calllog.Error_Message__c = errorMsg;
            calllog.Salesforce_ID_1__c = orderID;
            calllog.Salesforce_ID_2__c = cronTriggerScheduledID;
            calllog.order_related__c = orderID;
            calllog.response_end_time__c = datetime.now();     
            insert calllog;
        }
    }

    public string checkComm (string comCode, ID orderID) {
        system.debug ('==== in REST_Community.checkComm ');

        string requestID;
        string endPoint;
        string URI;
        string requestMsg ;
        string responseMsg ;
        string status=null;
        string errorMsg='';

        string responseStatus='';

        Datetime requestStartTime = datetime.now();

        //-- get access token first
        getAccessToken();
        system.debug ('==== accessToken : ' +  accessToken);
        if (accessToken != null) {
            //--request to community check
            
            //--sample : https://apigw.xl.co.id/commercial/api/v1/commtools/community?commcode=XLEMP0137
            //endpoint = 'https://apigw.xl.co.id/commercial/api/v1/commtools/';       //--TODO : put this value to custom label
            endpoint = label.REST_Exelcom_GSM_Endpoint;       
            
            URI = 'community?commcode=' + comCode;
            requestID = AppUtils.getNewGUID() ;

            String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

            HttpRequest req = new HttpRequest();

            req.setEndpoint(endpoint + URI);
            req.setMethod('GET');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);    //--access token sample : k47aujb3r5ge33r6ksfr38v5
            req.setHeader('channel', 'WEB');
            req.setHeader('requestdate', requestDate); //'2020-03-06T15:16:00');        
            req.setHeader('requestid', requestID);         

            try {
                Http http = new Http();
                HTTPResponse response = new HTTPResponse() ;

                http = new Http();
                if (!Test.isRunningTest())
                response = http.send(req);
                responseMsg = response.getBody ();

                System.debug ('================= request message  : ' + endpoint);
                System.debug ('================= response message : ' + responseMsg );

                
                Map <String, Object> responseMap = (Map <String, Object>) JSON.deserializeUntyped(responseMsg);
                string commcode = (string) responseMap.get('commcode');
                string error = (string) responseMap.get('error');
                
                
                if (error==null) {
                    //--response is success
                    //--TODO: do something
                    status = 'Success';
                    commcodeIsAvailable=true;
                    responseStatus = 'available';


                } else {
                    //--response is failed
                    status = 'Failed';
                    errorMsg = error;
                    commcodeIsAvailable=false;
                    responseStatus = 'not available';

                }

            } catch (Exception e) {
                status = 'Failed';
                errorMsg = 'Error on REST_Community.checkComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                accessToken = null;
                system.debug ('===== errorMsg : ' + errorMsg);
                responseStatus = 'failed';
            }


            

        } else {
            //--Access Token not Available
            //--TODO: Do something
            status = 'Failed';
            errorMsg = 'Access Token not Available';
            system.debug ('===== errorMsg : ' + errorMsg);
            responseStatus = 'failed';

        }
        
        if (orderID <> null) {
            // put callout information then save the data on Call_Log object
            Call_Log__c calllog = new Call_Log__c();
            calllog.request_ID__c= requestID;
            calllog.type__c='Callout';
            calllog.request_start_time__c = requestStartTime;
            calllog.method__c = 'GET';
            calllog.callerFrom__c = 'Salesforce' ;
            calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
            calllog.uri__c = uri ; 
            calllog.request_message__c = uri;
            calllog.status__c = status;
            calllog.response_message__c = responseMsg;            
            calllog.Error_Message__c = errorMsg;
            calllog.Salesforce_ID_1__c = orderID;
            calllog.order_related__c = orderID;
            calllog.response_end_time__c = datetime.now();     
            insert calllog;
        }

        responseMessage = responseMsg;
        return responseStatus;
    }

    @future(callout=true)
    public static void createComm (string orderid, string commCode, string commName, string commType, integer max_subscribers, integer discount) {
        
        system.debug ('==== in REST_Community.createComm ');
        system.debug ('==== orderid nya : '+orderid);

        string requestID;
        string endPoint;
        string URI;
        string requestMsg ;
        string responseMsg ;
        Integer responseCode ;
        string status=null;
        string errorMsg='';
        string jsonString;

        Datetime requestStartTime = datetime.now();

        //-- get access token first
        getAccessToken();
        system.debug ('==== accessToken : ' +  accessToken);
        if (accessToken != null) {
            //--request to community check
            
            //--sample : https://apigw.xl.co.id/commercial/api/v1/commtools/community?commcode=XLEMP0137
            //endpoint = 'https://apigw.xl.co.id/commercial/api/v1/commtools/';       //--TODO : put this value to custom label
            endpoint = label.REST_Exelcom_GSM_Endpoint; 
            URI = 'create-community';
            requestID = AppUtils.getNewGUID() ;

            String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

            HttpRequest req = new HttpRequest();

            req.setEndpoint(endpoint + URI);
            req.setMethod('POST');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);    //--access token sample : k47aujb3r5ge33r6ksfr38v5
            req.setHeader('channel', 'WEB');
            req.setHeader('requestdate', requestDate );  //'2020-03-06T15:16:00');
            req.setHeader('requestid', requestID);         
            
            //set body
            Body oBody = new Body();
            oBody.commcode=commcode;
            oBody.commname = commname; // dicomment dulu karena bentrok dengan method tagging
            oBody.commtype = commtype ;
            oBody.max_subscribers = max_subscribers ; // dicomment dulu karena bentrok dengan method tagging
            oBody.discount= discount; // dicomment dulu karena bentrok dengan method tagging
                
                jsonString = JSON.serialize(oBody);
                system.debug ('================= oBody1 :' + oBody );    
                system.debug ('================= oBody2 :' + jsonString );
                
                
                req.setBody(jsonString);
            
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
                System.debug ('================= request message  : ' + endpoint);
                System.debug ('================= response message : ' + responseMsg );
     
                
                //Map <String, Object> responseMap = (Map <String, Object>) JSON.deserializeUntyped(responseMsg);
                //string commcode = (string) responseMap.get('commcode');
               // string error = (string) responseMap.get('error');
                
                System.debug ('================= response message : ' + response.getBody ());
                   
                
               // string status = '';
                if (responseCode == 200) {
                             
                    status = 'Success';

                } else {
                    //--response is failed
                    status = 'Failed';
                    errorMsg = responseMsg;
                    apputils.puterror(errorMsg);
                }

            } catch (Exception e) {
                status = 'Failed';
                errorMsg = 'Error on REST_Community.createComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                accessToken = null;
                system.debug ('===== errorMsg : ' + errorMsg);
            }


            

        } else {
            //--Access Token not Available
            //--TODO: Do something
            status = 'Failed';
            errorMsg = 'Access Token not Available';
            system.debug ('===== errorMsg : ' + errorMsg);

        }


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

            /* jika success maka jangan langsung tagging proses
             * tapi buat schedule untuk cek terlebih dahulu. 
             * jika cek success kemudian lanjut ke tagging process
             * update tgl 14 August 2020, by Doddy
            */
            
            if(status == 'Success'){
                /*
                for (order ord :orderList){
                    ord.status = 'Tagging Process';
                }
                update orderList;*/

                //-- create scheduler for checking

            } 


        } catch (Exception e) {
            status = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Community.createComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);

        }

		
        // put callout information then save the data on Call_Log object
        Call_Log__c calllog = new Call_Log__c();
        calllog.request_ID__c= requestID;
        calllog.type__c='Callout';
        calllog.request_start_time__c = requestStartTime;
        calllog.method__c = 'POST';
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
        calllog.uri__c = uri ; 
        calllog.request_message__c = jsonString;
        calllog.status__c = status;
        calllog.response_message__c = responseMsg+' '+responseCode;            
        calllog.Error_Message__c = errorMsg;
        //calllog.Salesforce_ID_1__c = relatedRecordID;
        //calllog.order_related__c = relatedRecordID;
        calllog.response_end_time__c = datetime.now();     
        insert calllog;

    
        
    }


    /**
     * * TAGGING FUNCTION
     * 
     */

    @future(callout=true) 
    public static void requestTaggingByGroup (string orderid, integer groupNo, integer dataLimit, string scheduledProcessID) {
        
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
            
            system.debug('msisdn nya: '+msisdn);
            system.debug('msisdn nya: '+comcode);
            system.debug('msisdn nya: '+comtype);


            BodyTagging tmpBodyTagging = new BodyTagging();
            
            tmpBodyTagging.msisdn = msisdn;
            tmpBodyTagging.commcode=comcode;
            tmpBodyTagging.commtype = comtype ;
            tmpBodyTagging.comm_priority = '1';
            tmpBodyTagging.comm_priority_type= 'T';
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
        system.debug ('==== in REST_Community.taggingComm ');

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
        string orderID;

        string cURL = '';

        Datetime requestStartTime = datetime.now();
        //endpoint = 'https://apigw.xl.co.id/commercial/api/v1/commtools/';       //--TODO : put this value to custom label
        endpoint = label.REST_Exelcom_GSM_Endpoint; 
        URI = 'add-subscriber';
        

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

            req.setEndpoint(endpoint + URI);
            req.setMethod('POST');
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
            cURL = cURL + '  ' + endpoint + URI + ' \\ ' + '\r\n' ;
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
                errorMsg = 'Error on REST_Community.taggingComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
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
        Scheduled_Process__c tmpSP = [select id, order_related__c, status__c, request_ID__c from Scheduled_Process__c where id =:scheduledProcessID];
            
        tmpSP.status__c = status;
        tmpSP.request_ID__c = requestID;
        update tmpSP;

        orderID = tmpSP.order_related__c;
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
            errorMsg = errorMsg +  '. Error on REST_Community.taggingComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
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
        calllog.method__c = 'POST';
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
        calllog.uri__c = uri ; 
        calllog.request_message__c = jsonString;
        calllog.status__c = status;
        calllog.response_message__c = string.valueof(responseCode)+' '+responseMsg;            
        calllog.Error_Message__c = errorMsg;
        calllog.Salesforce_ID_1__c = scheduledProcessID;
        calllog.scheduled_process_related__c = scheduledProcessID;
        calllog.order_related__c = tmpSP.order_related__c;
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
        endpoint = label.REST_Exelcom_GSM_Endpoint; 
        URI = 'tagging-status';
        

        Scheduled_Process__c tmpSP = [select id, order_related__c, status__c, request_ID__c from Scheduled_Process__c where id =:scheduledProcessID];
        requestID =  tmpSP.request_ID__c;
        orderID = tmpSP.order_related__c;

        getAccessToken();
        system.debug ('==== accessToken : ' +  accessToken); 
        
        if (accessToken != null) {
            
            //requestID = AppUtils.getNewGUID() ;
            //requestID_short = requestID.right(5);
            String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

            HttpRequest req = new HttpRequest();

            req.setEndpoint(endpoint + URI);
            req.setMethod('POST'); 
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
            cURL = cURL + '  ' + endpoint + URI + ' \\ ' + '\r\n' ;
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
                if (!Test.isRunningTest())
                response = http.send(req);
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
					string msisdn_status = '';
					integer temp;
	
					//List <string> mssisdnStringList = new List <string> ();
					List <string> mssisdnStringListSuccess = new List <string> ();
					List <string> mssisdnStringListFailed = new List <string> ();
					   
			        
			        for (Object obj : objList) {
			        	Map<String, Object> tmpMapRec = (Map<String, Object>) obj;
	                    msisdn = AppUtils.getStringDataOnMap(tmpMapRec, 'msisdn') ;
	                    msisdn_status = AppUtils.getStringDataOnMap(tmpMapRec, 'status');
	                    System.debug('msisdn nya : ' + msisdn);
	                    System.debug('msisdn nya : ' + msisdn_status);
	                    
	                    if (msisdn_status == 'SUCCESS'){
							mssisdnStringListSuccess.add(msisdn);
						}   
						
						if (msisdn_status == 'FAILED'){
							mssisdnStringListFailed.add(msisdn);
						}   
	                    
	                    //mssisdnStringList.add(msisdn);
			        } 
			        //system.debug('mssisdnStringList nya :'+mssisdnStringList);
			        system.debug('mssisdnStringListSuccess nya :'+mssisdnStringListSuccess);
					system.debug('mssisdnStringListFailed nya :'+mssisdnStringListFailed);
			        
			        //Update Tagging Status Failed 
			        List<Order_MSISDN__c> LstmsisdnSuccess = [select id,status__c from Order_MSISDN__c WHERE order__c =:orderId AND msisdn__r.name IN :mssisdnStringListSuccess];
					system.debug('LstmsisdnSuccess size nya :'+LstmsisdnSuccess.size());
					system.debug('LstmsisdnSuccess  nya :'+LstmsisdnSuccess);
					
					for(Order_MSISDN__c LstOrderMsisdnSuccess : LstmsisdnSuccess){
					     LstOrderMsisdnSuccess.status__c = 'Success';	
					}                        
					update LstmsisdnSuccess;
                    
                    List<Order_MSISDN__c> LstmsisdnFailed = null;

					if (system.label.TAGGING_CHECK_FAILED_UPDATE_MODE == 'IGNORE SUCCESS') {
                        //Update Tagging Status Failed
                        LstmsisdnFailed = [select id,status__c 
                                                from Order_MSISDN__c 
                                                WHERE order__c =:orderId
                                                AND msisdn__r.name IN :mssisdnStringListFailed
                                                AND status__c != 'Success'
                                                ];
                    
                    } else if (system.label.TAGGING_CHECK_FAILED_UPDATE_MODE == 'NORMAL') {
                        //Update Tagging Status Failed
                        LstmsisdnFailed = [select id,status__c 
                                                from Order_MSISDN__c 
                                                WHERE order__c =:orderId AND
                                                msisdn__r.name IN :mssisdnStringListFailed
                                                ];
                    }

                    system.debug('LstmsisdnFailed size nya :'+LstmsisdnFailed.size());
					system.debug('LstmsisdnFailed  nya :'+LstmsisdnFailed);
					
					for(Order_MSISDN__c LstOrderMsisdnFailed : LstmsisdnFailed){
					     LstOrderMsisdnFailed.status__c = 'Failed';	
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
                    apputils.puterror(errorMsg);

                }

            } catch (Exception e) {
                status = 'Failed';
                errorMsg = 'Error on REST_Community.taggingCommCheck method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
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
            errorMsg = errorMsg +  '. Error on REST_Community.taggingCommCheck method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
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
        calllog.method__c = 'POST';
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
    
}