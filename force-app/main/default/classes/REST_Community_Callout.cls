/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 15-04-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   xx-xx-xxxx   Doddy Prima   Initial Version
 * 1.1   05-01-2022   Doddy Prima   change response in checkCommFromScheduler (from object to List of Object)
 * 1.2   10-03-2022   Doddy Prima   Change endpoint mechanism (using custom setting)
 * 1.3   15-04-2022   Doddy Prima   error handling with response using single object json format 
**/

global with sharing class REST_Community_Callout {
    /*public endPoint = '';
    public clientID = '';
    public clientSecret = ''; 
    public grantType = ''; 
    */
 


public static string accessToken = null;
public static string tokenResponseMessage = null;

public static boolean commcodeIsAvailable = false;
public string responseMessage {get;set;}


public REST_Community_Callout() {
    //--NGA DIPAKAI!
}

//private static void getAccessToken () {
public static void getAccessToken () {
    string errorMsg='';
    
    //string endpoint = 'https://apigw.xl.co.id/commercial/oauth/create-token';  //--TODO : put this value to custom label
    //-- old way : string endpoint = label.REST_Exelcom_GetToken_EndPoint; \

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
    
    /* old way
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
        errorMsg = 'Error on REST_Community_Callout.getToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + tokenResponseMessage +'::' + e.getLineNumber();
        apputils.puterror(errorMsg);
        accessToken = null;
        system.debug ('===== errorMsg : ' + errorMsg);
    }

}

@future(callout=true)
public static void checkCommFromScheduler (string comCode, ID orderID, ID cronTriggerScheduledID) {
    system.debug ('==== in REST_Community_Callout.checkCommFromScheduler ');

    string requestID;
    string endPoint;
    string URI;
    string parameter;
    string requestMsg ;
    string responseMsg ;
    string status=null;
    string errorMsg='';

    string responseStatus='';
    string commcode;
    string error = null;

    Datetime requestStartTime = datetime.now();

    //-- get access token first
    getAccessToken();
    system.debug ('==== accessToken : ' +  accessToken);
    
    //-- get custom setting values
    CommunityToolsAPISetting__c commAPISetting = CommunityToolsAPISetting__c.getOrgDefaults ();

    if (accessToken != null) {
        //--request to community check
        //-- old way : endpoint = label.REST_Exelcom_GSM_Endpoint;       
        //-- old way : URI = 'community?commcode=' + comCode;

        //-- new way :
        endpoint = commAPISetting.GetCommunity_Endpoint__c;
        parameter = '?commcode=' + comCode;

        requestID = AppUtils.getNewGUID() ;
        String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint + parameter);
        //-- old way : req.setMethod('GET');
        req.setMethod(commAPISetting.GetCommunity_Method__c);   //-- new way

        req.setTimeout(integer.valueOf(commAPISetting.RequestTimeout_General__c));
        
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
            integer statusCode = response.getStatusCode();

            System.debug ('================= request message  : ' + endpoint);
            System.debug ('================= response message : ' + responseMsg );
            System.debug ('================= statusCode : ' + statusCode );

            //-- handling error response (the json format is not list)
            //-- {"error":"can't find community info","code":"400"}
            
            if (responseMsg.contains('error') || statusCode <> 200) {
                //-- error couse the community is not found
                error = 'the community is not found';
            }
            else {

                //-- previous format (object) : 
                //Map <String, Object> responseMap = (Map <String, Object>) JSON.deserializeUntyped(responseMsg);
                
                //-- new json format (list of object) -- Jan 5, 2021 by doddy . confirmation from XL that only first data that will used
                List< object > responseMapList = (List< object >) JSON.deserializeUntyped(responseMsg);
                Map <String, Object> responseMap = new Map <String, Object> ();
                if ( responseMapList.size() > 0 ) {
                    responseMap = (Map <String, Object>) responseMapList[0];
                }
                //-- end of new format 


                commcode = (string) responseMap.get('commcode');
                error = (string) responseMap.get('error');
            }
            
            if (error==null) {
                //--response is success
                status = 'Success';
                commcodeIsAvailable=true;
                responseStatus = 'available';

                //-- update status order status to "Tagging Process"
                List<order> orderList = [select id, status from Order where id =:orderID];
                if ( orderList.size() > 0 ) {
                    orderList[0].status = 'Tagging Process';
                    orderList[0].ID_COM_is_Created__c =  true;
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
            errorMsg = 'Error on REST_Community_Callout.checkCommFromScheduler method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
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
        calllog.method__c = commAPISetting.GetCommunity_Method__c;
        calllog.callerFrom__c = 'Salesforce - by Scheduler' ;
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
        calllog.uri__c = uri ; 
        calllog.request_message__c = endpoint + parameter;
        calllog.status__c = status;
        calllog.response_message__c = responseMsg;            
        calllog.Error_Message__c = errorMsg;
        calllog.Salesforce_ID_1__c = orderID;
        calllog.Salesforce_ID_2__c = cronTriggerScheduledID;
        calllog.order_related__c = orderID;
        calllog.response_end_time__c = datetime.now();     
        insert calllog;
    }

    system.debug ('=== responseStatus : ' + responseStatus);
}

public string checkComm (string comCode, ID orderID) {
    system.debug ('==== in REST_Community_Callout.checkComm ');

    string requestID;
    string endPoint;
    string parameter;
    string URI;
    string requestMsg ;
    string responseMsg ;
    string status=null;
    string errorMsg='';

    string responseStatus='';
    string commcode;
    string error = null;

    Datetime requestStartTime = datetime.now();

    //-- get access token first
    getAccessToken();
    system.debug ('==== accessToken : ' +  accessToken);

    //-- get custom setting values
    CommunityToolsAPISetting__c commAPISetting = CommunityToolsAPISetting__c.getOrgDefaults ();

    if (accessToken != null) {
        //--request to community check
        
        //--sample : https://apigw.xl.co.id/commercial/api/v1/commtools/community?commcode=XLEMP0137
        //endpoint = 'https://apigw.xl.co.id/commercial/api/v1/commtools/';       //--TODO : put this value to custom label
        
        //-- old way : endpoint = label.REST_Exelcom_GSM_Endpoint;
        //-- old way : URI = 'community?commcode=' + comCode;
        
        //-- new way
        endpoint = commAPISetting.GetCommunity_Endpoint__c;
        parameter = '?commcode=' + comCode;

        requestID = AppUtils.getNewGUID() ;

        String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

        HttpRequest req = new HttpRequest();

        //-- old way : req.setEndpoint(endpoint + URI);

        //-- new way :
        req.setEndpoint(endpoint + parameter);
        
        //-- old way : req.setMethod('GET');
        req.setMethod(commAPISetting.GetCommunity_Method__c);   //-- new way
        req.setTimeout(integer.valueOf(commAPISetting.RequestTimeout_General__c));

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
            integer statusCode = response.getStatusCode();

            System.debug ('================= request message  : ' + endpoint);
            System.debug ('================= response message : ' + responseMsg );
            System.debug ('================= statusCode : ' + statusCode );

            //-- handling error response (the json format is not list)
            //-- {"error":"can't find community info","code":"400"}
            
            if (responseMsg.contains('error') || statusCode <> 200) {
                //-- error couse the community is not found
                error = 'the community is not found';
            }
            else {

                //-- previous format (object) : 
                //Map <String, Object> responseMap = (Map <String, Object>) JSON.deserializeUntyped(responseMsg);
                
                //-- new json format (list of object) -- Jan 5, 2021 by doddy . confirmation from XL that only first data that will used
                List< object > responseMapList = (List< object >) JSON.deserializeUntyped(responseMsg);
                Map <String, Object> responseMap = new Map <String, Object> ();
                if ( responseMapList.size() > 0 ) {
                    responseMap = (Map <String, Object>) responseMapList[0];
                }
                //-- end of new format 

                commcode = (string) responseMap.get('commcode');
                error = (string) responseMap.get('error');
            }
            
            
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
            errorMsg = 'Error on REST_Community_Callout.checkComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
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
        calllog.method__c = commAPISetting.GetCommunity_Method__c;
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
        calllog.uri__c = uri ; 
        calllog.request_message__c = endpoint + parameter;
        calllog.status__c = status;
        calllog.response_message__c = responseMsg;            
        calllog.Error_Message__c = errorMsg;
        calllog.Salesforce_ID_1__c = orderID;
        calllog.order_related__c = orderID;
        calllog.response_end_time__c = datetime.now();     
        insert calllog;
    }

    system.debug ('=== responseStatus : ' + responseStatus);
    responseMessage = responseMsg;
    return responseStatus;
}

@future(callout=true)
public static void createComm (string orderid, string commCode, string commName, string commType, integer max_subscribers, integer discount) {
    
    system.debug ('==== in REST_Community_Callout.createComm ');
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

    //-- get custom setting values
    CommunityToolsAPISetting__c commAPISetting = CommunityToolsAPISetting__c.getOrgDefaults ();
        
    if (accessToken != null) {
        //--request to community check
        
        //--sample : https://apigw.xl.co.id/commercial/api/v1/commtools/community?commcode=XLEMP0137
        //endpoint = 'https://apigw.xl.co.id/commercial/api/v1/commtools/';       //--TODO : put this value to custom label
        //-- old way : endpoint = label.REST_Exelcom_GSM_Endpoint; 
        //-- old way : URI = 'create-community';
        
        //-- New Way :
        endpoint = commAPISetting.CreateCommunity_Endpoint__c;
        
        requestID = AppUtils.getNewGUID() ;

        String requestDate = DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ss');

        HttpRequest req = new HttpRequest();

        //-- old way : 
        //req.setEndpoint(endpoint + URI);
        //req.setMethod('POST');

        //-- new way :
        req.setEndpoint(endpoint);
        req.setMethod(commAPISetting.CreateCommunity_Method__c);
        req.setTimeout(integer.valueOf(commAPISetting.RequestTimeout_General__c));

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
            errorMsg = 'Error on REST_Community_Callout.createComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
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
    system.debug('====== status : '+status);
    try {
        //User usr = [SELECT Id FROM User WHERE Name='Saasten Dev'];
        //System.runAs(usr) {
            //system.debug('====== masuk 1 : ');
            if(status == 'Failed'){
                for (order ord :orderList){
                    ord.is_Need_Validation__c = false;
                    ord.status = 'Draft';
                    
                    system.debug(' ==  ord.is_Need_Validation__c >' +  ord.is_Need_Validation__c);
                    system.debug(' ==  ord.status >' +  ord.status);
                   
                }
                update orderList;
                system.debug('====== orderList : '+orderList);
				
            }
		
        /* jika success maka jangan langsung tagging proses
            * tapi buat schedule untuk cek terlebih dahulu. 
            * jika cek success kemudian lanjut ke tagging process
            * update tgl 14 August 2020, by Doddy
        */
        
        if(status == 'Success'){
             
            for (order ord :orderList){
                ord.is_Need_Validation__c = false;
                ord.status = 'Tagging Process';
            }
            update orderList;


            list<order> orderRecUpdate = new list<order>();
            for(order orderRec :orderList){
                if(orderRec.status == 'Tagging Process'){
                    orderRec.is_Need_Validation__c = true;
                    orderRecUpdate.add(orderRec);
                }
            }   
            update orderRecUpdate;
            

            //-- create scheduler for checking

        } 
       // }

    } catch (Exception e) {
        status = 'Failed';
        errorMsg = errorMsg +  '. Error on REST_Community_Callout.createComm method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
        apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);

    }

 

    // put callout information then save the data on Call_Log object
    Call_Log__c calllog = new Call_Log__c();
    calllog.request_ID__c= requestID;
    calllog.type__c='Callout';
    calllog.request_start_time__c = requestStartTime;
    calllog.method__c = commAPISetting.CreateCommunity_Method__c;
    calllog.callerFrom__c = 'Salesforce' ;
    calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
    calllog.uri__c = uri ; 
    calllog.request_message__c = jsonString;
    calllog.status__c = status;
    calllog.response_message__c = responseMsg+' '+responseCode;            
    calllog.Error_Message__c = errorMsg;
    //calllog.Salesforce_ID_1__c = relatedRecordID;
    calllog.order_related__c = orderid;
    calllog.response_end_time__c = datetime.now();     
    insert calllog;


    
}



    





    /*
    Structures
    */

    class Body {
        String commcode = null;
        String commname = null;
        String commtype = null;
        Integer max_subscribers = null;
        Integer discount = null;
    }
    
    
}