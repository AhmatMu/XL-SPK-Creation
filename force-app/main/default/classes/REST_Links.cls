@RestResource(urlMapping='/links/*')
global with sharing class REST_Links {

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
    
    class ErrBody {
        Except except; 
        
        ErrBody () {
           except = new Except();
        }
    }
    
    global class RESTResult{
        Header header;
        ErrBody body;        
        RESTResult(){
            header= new Header();
            body= new ErrBody();
        }
    }
    
    
    global class RESTResultX{
        String Status;
        String Message;
        
        RESTResultX(String Status, String Message){
            this.Status = Status;
            this.Message = Message;
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
     * THIS METHOD FOR ADD/INSERT NEW LINKS PROCESS
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
        
        string cid ;
        string bu ;
        string id;
        string statusLink ;
        string companyName ;
        string serviceType ;
        string contractItem ;
        string BPSiteA ;
        string BPSiteB ;
        string capacityBandwidth ;
        string uom ;
        string routepath ;
        string linkId ;
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'POST';
        calllog.request_start_time__c = datetime.now();

        Link__c[] tmpLinks = new List <Link__c>();                        
        
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

                    if (service != 'addlink') {
                        // the service is NOT RELEVANT
                        status = 'failed';
                        errMessage = 'The service is not relevant.';
                        errCode = '1';

                    } else {
                        // Get Link Record data
                        id = AppUtils.getStringDataOnMap(mapRec , 'id');
                        System.debug(' ============ SQL : SELECT id FROM Link__c WHERE id__c = ' + id);
                        if (! (AppUtils.isKeysetNotFound(id) || id=='' ) ){
                                tmpLinks = [SELECT id FROM Link__c WHERE id__c = :id  LIMIT 1 ];
                                system.debug('============ tmpLinks : ' + tmpLinks);
                                
                                if (tmpLinks.size() >0){
                                    status = 'failed';
                                    errMessage = 'Cannot add the data, the ID is already exists in the system.';
                                }
                        } 
                    }

                    // IF STATUS is NOT FAILED
                    if (status<>'failed') {
                        // if using list data :
                        // List <Object> objList = (List<Object>) appUtils.getListDataOnMap(paramMap,'body::data');
                        
                        
                        List <Link__c> listLink = new List <Link__c>();
                   
                   //for (Object oo : objList) {
                       //Map<string, Object> mapRec = (Map<string, Object>) oo;
                       
                       Link__c oLink = new Link__c();
                       
                       cid = AppUtils.getStringDataOnMap(mapRec , 'cid');
                       bu = AppUtils.getStringDataOnMap(mapRec , 'bu');
                       
                       statusLink = AppUtils.getStringDataOnMap(mapRec , 'status_link');
                       companyName = AppUtils.getStringDataOnMap(mapRec , 'company_name');
                       serviceType = AppUtils.getStringDataOnMap(mapRec , 'service_type');
                       contractItem = AppUtils.getStringDataOnMap(mapRec , 'contract_item');
                       BPSiteA = AppUtils.getStringDataOnMap(mapRec , 'bp_site_a');
                       BPSiteB = AppUtils.getStringDataOnMap(mapRec , 'bp_site_b');
                       capacityBandwidth = AppUtils.getStringDataOnMap(mapRec , 'capacity_bandwidth');
                       uom = AppUtils.getStringDataOnMap(mapRec , 'uom');
                       routepath = AppUtils.getStringDataOnMap(mapRec , 'routepath');
                       linkId = AppUtils.getStringDataOnMap(mapRec , 'link_id');
                       
                       //TODO: handle for KEYSET NOT FOUND - DONE
                       //TODO: setup Opportunity that used the CID that inserted 
                       //TODO: handling for partial error on dataset (one of data list) 
                       
                       
                       if (AppUtils.isKeysetNotFound(cid) || cid=='' ) {
                           // CID not found or empty
                           status = 'failed';
                           errMessage = 'CID not found on the data. ';
                           errCode = '1';
                       }    
                       if (AppUtils.isKeysetNotFound(id) || id=='' ) {
                           status = 'failed';
                           errMessage = errMessage + 'ID not found on the data. ';
                           errCode = '1';
                           
                       } 
                       if (AppUtils.isKeysetNotFound(linkId) || linkId=='' ) {
                           status = 'failed';
                           errMessage = errMessage + 'Link Id not found on the data. ';
                           errCode = '1';
                            
                       }
                       
                       if (status != 'failed') {
                           oLink.name = AppUtils.isKeysetNotFound(cid) ? null : cid;  //<<
                           oLink.cid__c = AppUtils.isKeysetNotFound(cid) ? null : cid;
                           oLink.bu__c = AppUtils.isKeysetNotFound(bu) ? null : bu;
                           oLink.id__c = AppUtils.isKeysetNotFound(id) ? null : id;
                           oLink.status_link__c = AppUtils.isKeysetNotFound(statusLink) ? null : statusLink;
                           oLink.company_name__c = AppUtils.isKeysetNotFound(companyName) ? null : companyName;
                           oLink.service_type__c = AppUtils.isKeysetNotFound(serviceType) ? null : serviceType;
                           oLink.contract_item__c = AppUtils.isKeysetNotFound(contractItem) ? null : contractItem;
                           oLink.bp_site_a__c = AppUtils.isKeysetNotFound(BPSiteA) ? null : BPSiteA;
                           oLink.bp_site_b__c = AppUtils.isKeysetNotFound(BPSiteB) ? null : BPSiteB;
                           oLink.capacity_bandwidth__c = AppUtils.isKeysetNotFound(capacityBandwidth) ? null : capacityBandwidth;
                           oLink.uom__c = AppUtils.isKeysetNotFound(uom) ? null : uom;
                           oLink.routepath__c = AppUtils.isKeysetNotFound(routePath) ? null : routePath;
                           oLink.link_id__c = AppUtils.isKeysetNotFound(linkId) ? null : linkId;
                           oLink.record_info__c='insert from external system';


                            //--- UPDATE Site_A_Name__c and Site_B_Name__c (related ID) on link 
                            if(oLink.bp_site_a__c != '' && oLink.bp_site_a__c != null){
                                List<Account> accs = [select id, BP_Number__c from account where BP_Number__c = :oLink.bp_site_a__c AND RecordType.Name = 'BP'];
                                oLink.Site_A_Name__c = null;
                                if (accs.size()>0) {
                                    oLink.Site_A_Name__c = accs[0].id;
                                }
                            }
                            
                            oLink.Site_B_Name__c = null;
                            if(oLink.bp_site_b__c != '' && oLink.bp_site_b__c != null){
                                List<Account> accs = [select id, BP_Number__c from account where BP_Number__c = :oLink.bp_site_b__c AND RecordType.Name = 'BP'];
                                if (accs.size()>0 && oLink.bp_site_b__c!='' && oLink.bp_site_b__c!=null) {
                                    oLink.Site_B_Name__c = accs[0].id;
                                }
                            }
                            //-----------------------------------------------------------------

                           listLink.add (oLink); 
                        }
                   //} end od for
                   
                        if (status != 'failed'){
                            insert listLink;
                            errCode = '0';


                            //--- UPDATE field di CID (link) related opportunity ---
                            
                            // get id of link,
                            Link__c tmpLink = [select id, name from link__C where name= :cid LIMIT 1 ];
                            string tmpLinkID = tmpLink.id;

                            List <Opportunity> opps = [ select id from opportunity where  CID__c=:cid  ] ;
                            for (Opportunity opp : opps) {
                                opp.Link_Related__c = tmpLinkID;
                            }
                            // update link_related on opportunities 
                            update opps;
                            //--------------------------------------------------------





                        }
                   }   // .close from the status is not FAILED

                }   
                system.debug('============ requestid : ' + requestid );
                 
                /* -----end of process---- */
                
            }
            catch (Exception e) {
                status ='failed';
                errMessage = e.getmessage() + ' - error line : '  + e.getLineNumber();
                errCode = '1';
                
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
     * THIS METHOD FOR LINKS UPDATE PROCESS
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
        
        string cid ;
        string bu ;
        string id;
        string statusLink ;
        string companyName ;
        string serviceType ;
        string contractItem ;
        string BPSiteA ;
        string BPSiteB ;
        string capacityBandwidth ;
        string uom ;
        string routepath ;
        string linkId ;
        
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

                   if (service != 'updatelink') {
                       // the service is NOT RELEVANT

                       status = 'failed';
                       errMessage = 'the service is not relevant';
                       errCode = '1';
                   }
                   else {
                        // the service name is RELEVANT
                        
                        Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');

                        List <Link__c> listLink = new List <Link__c>();
                       
                        Link__c oLink = new Link__c();
                        
                        cid = AppUtils.getStringDataOnMap(mapRec , 'cid');
                        bu = AppUtils.getStringDataOnMap(mapRec , 'bu');
                        id = AppUtils.getStringDataOnMap(mapRec , 'id');
                        statusLink = AppUtils.getStringDataOnMap(mapRec , 'status_link');
                        companyName = AppUtils.getStringDataOnMap(mapRec , 'company_name');
                        serviceType = AppUtils.getStringDataOnMap(mapRec , 'service_type');
                        contractItem = AppUtils.getStringDataOnMap(mapRec , 'contract_item');
                        BPSiteA = AppUtils.getStringDataOnMap(mapRec , 'bp_site_a');
                        BPSiteB = AppUtils.getStringDataOnMap(mapRec , 'bp_site_b');
                        capacityBandwidth = AppUtils.getStringDataOnMap(mapRec , 'capacity_bandwidth');
                        uom = AppUtils.getStringDataOnMap(mapRec , 'uom');
                        routepath = AppUtils.getStringDataOnMap(mapRec , 'routepath');
                        linkId = AppUtils.getStringDataOnMap(mapRec , 'link_id');
                        
                        //TODO: handle for KEYSET NOT FOUND - DONE
                        //TODO: setup Opportunity that used the CID that inserted 
                        //TODO: handling for partial error on dataset (one of data list) 

                        List <Link__c> tmpLinks = new List <Link__c>() ;
                        //Link__c[] tmpLinks = new List <Link__c>();
                        //Link__c tmpLink = new Link__c();
                        
                        String linksSFId = ''; 


                        // Get Link Record data
                        System.debug(' ============ SQL : SELECT id FROM Link__c WHERE id__c = ' + id);
                        if (! (AppUtils.isKeysetNotFound(id) || id=='' ) ){
                                tmpLinks = [SELECT id FROM Link__c WHERE id__c = :id  LIMIT 1 ];
                                system.debug('============ tmpLinks : ' + tmpLinks);
                                
                                if (tmpLinks.size() > 0){
                                    oLink = tmpLinks[0];
                                    status = 'success';
                                }
                                else {
                                    status = 'failed';
                                    errMessage = 'ID not found on the data. ';
                                    errCode = '1';
                                }
                        }

                        if (AppUtils.isKeysetNotFound(id) || id=='' ) {
                            status = 'failed';
                            errMessage = 'ID not found on the data. ';
                            errCode = '1';
                        }            

                        if (status != 'failed') {
                            // oLink.id__c = AppUtils.isKeysetNotFound(id) ? null : id;

                            if (!AppUtils.isKeysetNotFound(linkid)) oLink.name = cid;  //<<
                            if (!AppUtils.isKeysetNotFound(bu)) oLink.bu__c = bu;
                            if (!AppUtils.isKeysetNotFound(companyName)) oLink.company_name__c = companyName;
                            if (!AppUtils.isKeysetNotFound(statusLink)) oLink.status_link__c = statusLink;
                            if (!AppUtils.isKeysetNotFound(serviceType)) oLink.service_type__c = serviceType;                            
                            if (!AppUtils.isKeysetNotFound(BPSiteA)) oLink.bp_site_a__c = BPSiteA;
                            if (!AppUtils.isKeysetNotFound(BPSiteB)) oLink.bp_site_b__c = BPSiteB;                            
                            if (!AppUtils.isKeysetNotFound(routePath)) oLink.routepath__c = routePath;
                            if (!AppUtils.isKeysetNotFound(linkID)) oLink.link_id__c = linkId;
                            
                            /* 2019-02-22 by doddy : ditutup karena selama proses upgrade/downgrade dimana contract baru belum terbentuk di SAP maka bandwidth, uom, dan contract jangan diupdate 
                            if (!AppUtils.isKeysetNotFound(contractItem)) oLink.contract_item__c = contractItem;
                            if (!AppUtils.isKeysetNotFound(uom)) oLink.uom__c = uom;
                            if (!AppUtils.isKeysetNotFound(capacityBandwidth)) oLink.capacity_bandwidth__c = capacityBandwidth;
                            */
                            
                            oLink.record_info__c='last update from external system';
                            
                            //--- UPDATE Site_A_Name__c and Site_B_Name__c (related ID) on link 
                            if(oLink.bp_site_a__c != '' && oLink.bp_site_a__c != null){
                                List<Account> accs = [select id, BP_Number__c from account where BP_Number__c = :oLink.bp_site_a__c AND RecordType.Name = 'BP'];
                                oLink.Site_A_Name__c = null;
                                if (accs.size()>0) {
                                    oLink.Site_A_Name__c = accs[0].id;
                                }
                            }
                            
                            oLink.Site_B_Name__c = null;
                            if(oLink.bp_site_b__c != '' && oLink.bp_site_b__c != null){
                                List<Account> accs = [select id, BP_Number__c from account where BP_Number__c = :oLink.bp_site_b__c AND RecordType.Name = 'BP'];
                                if (accs.size()>0 && oLink.bp_site_b__c!='' && oLink.bp_site_b__c!=null) {
                                    oLink.Site_B_Name__c = accs[0].id;
                                }
                            }
                            //-----------------------------------------------------------------


                            listLink.add (oLink); 
                            }     
                            System.debug('=================== oLink : ' + oLink);
                    
                            if (status != 'failed'){
                                update listLink;
                                errCode = '0';
                            } 

                    }   // .close from the service name is relevant

                }
                system.debug('============ requestid : ' + requestid );
                 
                /* -----end of process---- */                                                            

            }
            catch (Exception e) {
                status ='failed';
                errMessage = e.getmessage() + ' - error line : '  + e.getLineNumber();
                errCode = '1';
                
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


        //RESTResultX restResult = new RESTResultX('', ''); 
        //return restResult ;    
    }
    
}