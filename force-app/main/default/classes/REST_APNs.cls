@RestResource(urlMapping='/apns/*')
global with sharing class REST_APNs {

    class Header {
        string service='';
        string request_id ='';
        string response_id='';
        string status ='';
    }
    
    class Except {
        string error_code='';
        string error_message = '';
    }
    class DataAPN {
        string apn_sfid = '';
    }    
    
    class Body {
        Except except; 
        DataApn data; 
        
        Body () {
           data  = new DataAPN();
           except = new Except();
        }
    }    
    
    global class RESTResult{
        Header header;
        Body body;        
        RESTResult(){
            header= new Header();
            body= new Body();
        }
    }
    
    
    
/*    
    @HttpGet

    global static RESTResultX doGet(){
        
        RESTResultX restResult = new RESTResultX('', ''); 
        return restResult ;
    }
*/    

    /*
     * THIS METHOD FOR ADD/INSERT NEW APN 
     *
     */
    @HttpPost
    global static RESTResult doPost(){
        String param ='';
        String status ='';
        String service ='';
        String requestid ='';
        String errMessage ='-';
        String errCode ='-';
        
        String ipAddressRequestCameFrom='';
        String currentRequestURL;
        String sfdcBaseURL;     
        String uniqueNumber;
        
        string apnSFID;   
        
        String apnID;
        String apnName;
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'POST';
        calllog.request_start_time__c = datetime.now();

        List<APN__C> tmpAPNs = new List <APN__c>(); 
        try  {
                RestRequest request = RestContext.request;
                //RestResponse response = RestContext.response;
                param = RestContext.request.requestBody.toString().trim();
                status ='success';
                
                // put callout information
                calllog.request_message__c = param ;
                calllog.response_message__c = status;
                calllog.status__c = status ;
                calllog.uri__c = request.requestURI;
                
                ipAddressRequestCameFrom = request.remoteAddress;
                system.debug ('============= ipAddressRequestCameFrom : ' + ipAddressRequestCameFrom );
                system.debug ('============= request.headers          : ' + request.headers);
                system.debug ('============= request.httpMethod       : ' + request.httpMethod);
                system.debug ('============= request.params           : ' + request.params);
                system.debug ('============= request.remoteAddress    : ' + request.remoteAddress);
                system.debug ('============= request.requestBody      : ' + request.requestBody);
                system.debug ('============= request.requestURI       : ' + request.requestURI);
                system.debug ('============= request.resourcePath     : ' + request.resourcePath);
                
                // Get the base URL.
                sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                System.debug('Base URL: ' + sfdcBaseURL );       
                
                // Get the URL for the current request.
                currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
                System.debug('Current request URL: ' + currentRequestURL); 
                
                calllog.callerFrom__c = ipAddressRequestCameFrom ;
                calllog.endpoint__c = currentRequestURL.replace (calllog.uri__c,'');                
                
                /* -- MAIN PROCESS -- */                 
                Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped(param);
                system.debug('============ paramMap  : ' + paramMap );
                
                if(paramMap.size() > 0){   
                   Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');
 
                   requestid = AppUtils.getStringDataOnMap(paramMap , 'header::request_id');
                   service = AppUtils.getStringDataOnMap(paramMap , 'header::service');

                    if (service != 'addapn') {
                        // the service is NOT RELEVANT
                        status = 'failed';
                        errMessage = 'The service is not relevant.';
                        errCode = '1';

                    } else {
                        // Get APN Record data
                        apnID = AppUtils.getStringDataOnMap(mapRec , 'apn_id');
                        apnName = AppUtils.getStringDataOnMap(mapRec , 'apn_name');
                        System.debug(' ============ SQL : SELECT APN_ID__c FROM APN__c WHERE APN_ID__c = ' + apnID);
                        if (! (AppUtils.isKeysetNotFound(apnID) || apnID=='' ) ){
                                tmpAPNs = [SELECT APN_ID__c FROM APN__c WHERE APN_ID__c = :apnID LIMIT 1 ];
                                system.debug('============ tmpAPNs : ' + tmpAPNs);
                                
                                if (tmpAPNs.size() >0){
                                    status = 'failed';
                                    errMessage = 'Cannot add the data, the ID is already exists in the system.';
                                }
                        } 
                    }

                    // IF STATUS is NOT FAILED
                    if (status<>'failed') {
                        // if using list data :
                        // List <Object> objList = (List<Object>) appUtils.getListDataOnMap(paramMap,'body::data');
                   //for (Object oo : objList) {
                       //Map<string, Object> mapRec = (Map<string, Object>) oo;
                       
                        APN__c oAPN = new APN__c ();       
                        List <APN__c> listAPN = new List <APN__c>();                
                       
                        apnName = AppUtils.getStringDataOnMap(mapRec , 'apn_name');

                       if (AppUtils.isKeysetNotFound(apnID) || apnID=='' ) {
                           // CID not found or empty
                           status = 'failed';
                           errMessage = 'APN ID not found on the data. ';
                           errCode = '1';
                       } 

                       if (status != 'failed') {
                           oAPN.APN_ID__c =  AppUtils.isKeysetNotFound(apnID) ? null : apnID;  
                           oAPN.name =  AppUtils.isKeysetNotFound(apnName) ? null : apnName;  
                           listAPN.add (oAPN); 
                        }
                   //} end od for
                   
                        if (status != 'failed'){
                            insert listAPN;
                            errCode = '0';
                            APN__c apn = [select id from APN__c where APN_ID__c  =:apnID order by createddate desc limit 1];
                            apnSFID = apn.id;
                        }
                   }   // .close from the status is not FAILED

                }   
                system.debug('============ requestid : ' + requestid );
                 
                /* -----end of process---- */
                
            }
            catch (Exception e) {
                status ='failed';
                errCode = '1';
                calllog.status__c = 'Failed';
                errMessage = 'Error on POST APPN method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }
            
            // put response data 
            RESTResult restResult = new RESTResult(); 
            restResult.header.service = service;
            restResult.header.request_id = requestid;
            restResult.header.response_id = AppUtils.getUniqueNumber();
            restResult.header.status = status;
            restResult.body.data.apn_sfid = apnSFID; 
            restResult.body.except.error_message = errMessage;
            restResult.body.except.error_code = errCode;
            
            // put callout information then save the data on Call_Log object
            calllog.response_end_time__c = datetime.now();     
            calllog.response_message__c = JSON.serialize(restResult) ;            
            insert calllog;
            
            return restResult ;
    }


    /*
     * THIS METHOD FOR APNs UPDATE PROCESS
     *
     */
    @HttpPut
    global static RESTResult doPut(){

        String param ='';
        String status ='';
        String service ='';
        String requestid ='';
        String errMessage ='-';
        String errCode ='-';
        
        String ipAddressRequestCameFrom='';
        String currentRequestURL;
        String sfdcBaseURL;
        
        string apnSFID;
        string apnID;
        string apnName;
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'PUT';
        calllog.request_start_time__c = datetime.now();

        try  {
                RestRequest request = RestContext.request;
                //RestResponse response = RestContext.response;
                param = RestContext.request.requestBody.toString().trim();
                status ='success';
                
                // put callout information
                calllog.request_message__c = param ;
                calllog.response_message__c = status;
                calllog.status__c = status ;
                calllog.uri__c = request.requestURI;
                
                ipAddressRequestCameFrom = request.remoteAddress;
                system.debug ('============= ipAddressRequestCameFrom : ' + ipAddressRequestCameFrom );
                system.debug ('============= ipAddressRequestCameFrom : ' + ipAddressRequestCameFrom );
                system.debug ('============= request.headers          : ' + request.headers);
                system.debug ('============= request.httpMethod       : ' + request.httpMethod);
                system.debug ('============= request.params           : ' + request.params);
                system.debug ('============= request.remoteAddress    : ' + request.remoteAddress);
                system.debug ('============= request.requestBody      : ' + request.requestBody);
                system.debug ('============= request.requestURI       : ' + request.requestURI);
                system.debug ('============= request.resourcePath     : ' + request.resourcePath);

                // Get the base URL.
                sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                System.debug('Base URL: ' + sfdcBaseURL );       
                
                // Get the URL for the current request.
                currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
                System.debug('Current request URL: ' + currentRequestURL); 
                
                calllog.callerFrom__c = ipAddressRequestCameFrom ;                   
                calllog.endpoint__c = currentRequestURL.replace (calllog.uri__c,'');                
                

                /* -- MAIN PROCESS -- */
                Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped(param);
                system.debug('============ paramMap  : ' + paramMap );
                
                if(paramMap.size() > 0){   
                   requestid = AppUtils.getStringDataOnMap(paramMap , 'header::request_id');
                   service = AppUtils.getStringDataOnMap(paramMap , 'header::service');

                   if (service != 'updateapn') {
                       // the service is NOT RELEVANT

                       status = 'failed';
                       errMessage = 'the service is not relevant';
                       errCode = '1';
                   }
                   else {
                        // the service name is RELEVANT
                        
                        Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');

                        APN__c oAPN = new APN__c ();       
                        List <APN__c> listAPNs = new List <APN__c>();                

                        apnSFID = AppUtils.getStringDataOnMap(mapRec , 'apn_sfid');
                        apnID = AppUtils.getStringDataOnMap(mapRec , 'apn_id');
                        apnName = AppUtils.getStringDataOnMap(mapRec , 'apn_name');
                        
                        List <APN__C> tmpAPNs = new List <APN__C>() ;
                        
                        // Get APN Record data
                        System.debug(' ============ SQL : SELECT id FROM APN__c WHERE id = ' + apnSFID);
                        if (! (AppUtils.isKeysetNotFound(apnID) || apnID=='' ) ){
                                tmpAPNs = [SELECT id FROM APN__c WHERE id = :apnSFID  LIMIT 1 ];
                                system.debug('============ tmpAPNs : ' + tmpAPNs);
                                
                                if (tmpAPNs.size() > 0){
                                    oAPN = tmpAPNs[0];
                                    status = 'success';
                                }
                                else {
                                    status = 'failed';
                                    errMessage = 'Salesforce ID not found on the data. ';
                                    errCode = '1';
                                }
                        }

                        if (AppUtils.isKeysetNotFound(apnID) || apnID=='' ) {
                            status = 'failed';
                            errMessage = 'Salesforce ID not found on the data. ';
                            errCode = '1';
                        }            

                        if (status != 'failed') {
                            oAPN.apn_id__c=  AppUtils.isKeysetNotFound(apnID) ? null : apnID;
                            oAPN.name=  AppUtils.isKeysetNotFound(apnName) ? null : apnName;

                            listAPNs.add (oAPN); 
                            }     
                            System.debug('=================== oAPN : ' + oAPN);
                    
                            if (status != 'failed'){
                                update listAPNs;
                                errCode = '0';
                            } 

                    }   // .close from the service name is relevant

                }
                system.debug('============ requestid : ' + requestid );
                 
                /* -----end of process---- */                                                            

            }
            catch (Exception e) {
                status ='failed';
                errCode = '1';
                
                calllog.status__c = 'Failed';
                errMessage = 'Error on PUT APN method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }
            
            // put response data 
            RESTResult restResult = new RESTResult(); 
            restResult.header.service = service;
            restResult.header.request_id = requestid;
            restResult.header.response_id = AppUtils.getUniqueNumber();
            restResult.header.status = status;
            restResult.body.except.error_message = errMessage;
            restResult.body.except.error_code = errCode;
            
            // put callout information then save the data on Call_Log object
            calllog.response_end_time__c = datetime.now();     
            calllog.response_message__c = JSON.serialize(restResult) ;      
            insert calllog;
            
            return restResult ;

    }
    
}