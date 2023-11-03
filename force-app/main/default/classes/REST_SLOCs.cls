@RestResource(urlMapping='/slocs/*')
global with sharing class REST_SLOCs {

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
    
    class DataSLOC {
        string sloc_sfid = '';
    }    
    
    class Body {
        Except except; 
        DataSloc data; 
        
        Body () { 
           data  = new DataSLOC();
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
     * THIS METHOD FOR ADD/INSERT NEW SLOC 
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
        
        string slocSFID;
        String slocID;
        String slocName;
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'POST';
        calllog.request_start_time__c = datetime.now();

        List<SLOC__C> tmpSLOCs = new List <SLOC__c>(); 
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

                    if (service != 'addsloc') {
                        // the service is NOT RELEVANT
                        status = 'failed';
                        errMessage = 'The service is not relevant.';
                        errCode = '1';

                    } else {
                        // Get SLOC Record data
                        slocID = AppUtils.getStringDataOnMap(mapRec , 'sloc_id');
                        slocName = AppUtils.getStringDataOnMap(mapRec , 'sloc_name');
                        System.debug(' ============ SQL : SELECT SLOC_ID__c FROM SLOC__c WHERE SLOC_ID__c = ' + slocID);
                        if (! (AppUtils.isKeysetNotFound(slocID) || slocID=='' ) ){
                                tmpSLOCs = [SELECT SLOC_ID__c FROM SLOC__c WHERE SLOC_ID__c = :slocID LIMIT 1 ];
                                system.debug('============ tmpSLOCs : ' + tmpSLOCs);
                                
                                if (tmpSLOCs.size() >0){
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
                       
                        SLOC__c oSLOC = new SLOC__c ();       
                        List <SLOC__c> listSLOC = new List <SLOC__c>();                
                       
                        slocName = AppUtils.getStringDataOnMap(mapRec , 'sloc_name');

                       if (AppUtils.isKeysetNotFound(slocID) || slocID=='' ) {
                           // CID not found or empty
                           status = 'failed';
                           errMessage = 'Sloc ID not found on the data. ';
                           errCode = '1';
                       } 

                       if (status != 'failed') {
                           oSLOC.SLOC_ID__c =  AppUtils.isKeysetNotFound(slocID) ? null : slocID;  
                           oSLOC.name =  AppUtils.isKeysetNotFound(slocName) ? null : slocName;  
                           
                           listSLOC.add (oSLOC); 
                        }
                   //} end od for
                   
                        if (status != 'failed'){
                            insert listSLOC;
                            errCode = '0';
                            SLOC__c sloc = [select id from SLOC__c where SLOC_ID__c  =:slocID order by createddate desc limit 1];
                            slocSFID = sloc.id;
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
                errMessage = 'Error on POST SLOC method.::' + e.getmessage() + '::' + e.getLineNumber() ;
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


    /*
     * THIS METHOD FOR SLOCs UPDATE PROCESS
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
        
        string slocSFID;
        string slocID;
        string slocName;
        
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

                   if (service != 'updatesloc') {
                       // the service is NOT RELEVANT

                       status = 'failed';
                       errMessage = 'the service is not relevant';
                       errCode = '1';
                   }
                   else {
                        // the service name is RELEVANT
                        
                        Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');

                        SLOC__c oSLOC = new SLOC__c ();       
                        List <SLOC__c> listSLOCs = new List <SLOC__c>();                

                        slocSFID = AppUtils.getStringDataOnMap(mapRec , 'sloc_sfid');
                        slocID = AppUtils.getStringDataOnMap(mapRec , 'sloc_id');
                        slocName = AppUtils.getStringDataOnMap(mapRec , 'sloc_name');
                        
                        List <SLOC__C> tmpSLOCs = new List <SLOC__C>() ;
                        
                        // Get SLOC Record data
                        System.debug(' ============ SQL : SELECT id FROM SLOC__c WHERE id = ' + slocSFID);
                        if (! (AppUtils.isKeysetNotFound(slocID) || slocID=='' ) ){
                                tmpSLOCs = [SELECT id FROM SLOC__c WHERE id = :slocSFID  LIMIT 1 ];
                                system.debug('============ tmpSLOCs : ' + tmpSLOCs);
                                
                                if (tmpSLOCs.size() > 0){
                                    oSLOC = tmpSLOCs[0];
                                    status = 'success';
                                }
                                else {
                                    status = 'failed';
                                    errMessage = 'Salesforce ID not found on the data. ';
                                    errCode = '1';
                                }
                        }

                        if (AppUtils.isKeysetNotFound(slocID) || slocID=='' ) {
                            status = 'failed';
                            errMessage = 'Salesforce ID not found on the data. ';
                            errCode = '1';
                        }            

                        if (status != 'failed') {
                            oSLOC.sloc_id__c=  AppUtils.isKeysetNotFound(slocID) ? null : slocID;
                            oSLOC.name=  AppUtils.isKeysetNotFound(slocName) ? null : slocName;

                            listSLOCs.add (oSloc); 
                            }     
                            System.debug('=================== oSloc : ' + oSloc);
                    
                            if (status != 'failed'){
                                update listSLOCs;
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
                errMessage = 'Error on PUT SLOC method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }
            
            // put response data 
            RESTResult restResult = new RESTResult(); 
            restResult.header.service = service;
            restResult.header.request_id = requestid;
            restResult.header.response_id = AppUtils.getUniqueNumber();
            restResult.header.status = status;
            restResult.body.data.sloc_sfid = slocSFID; 
            restResult.body.except.error_message = errMessage;
            restResult.body.except.error_code = errCode;
            
            // put callout information then save the data on Call_Log object
            calllog.response_end_time__c = datetime.now();     
            calllog.response_message__c = JSON.serialize(restResult) ;      
            insert calllog;
            
            return restResult ;

    }
    
}