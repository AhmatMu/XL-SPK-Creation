@RestResource(urlMapping='/baps/*')
global with sharing class REST_BAPs {

    class Body {
        Header header = new Header();
        BodyBAP body  = new BodyBAP();
    } 
    
    class BodyBAP {
        DataBAP data = new DataBAP();
    }
    
    class DataBAP {
        string bapID=null;
        string typeOfRequest=null;
        string customer=null;
        string cid=null;
        string sirkit=null;
        string address=null;
        string pic=null;
        string picPhone=null;
        string picEmail=null;
        string picPosition=null;
        string bandwidth=null;
        string bandwidthUom=null;
        string requestDate=null;
        string terminateDate=null;
        string reason=null;
        string note=null;
        string userCreate=null;

        integer approveType=null;
        string approveEmail=null;
        string approveDate=null;
    }
    
    /*
    class ApprovalBAP {
        string bapID='';
        integer approveType=0;
        string approveEmail='';
        string approveDate='';
    }*/

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
    
    /*
    global class RESTResultX{
        String Status;
        String Message;
        
        RESTResultX(String Status, String Message){
            this.Status = Status;
            this.Message = Message;
        }
    }*/

    @future(callout=true)
    public static void approvalBAP (string bapid,
        integer approveType, string approveEmail, string approveDate) 
    {   
        System.debug ('================= IN BAP APPROVAL CALL OUT');
        system.debug ('================== bapid : ' + bapid);
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callout';
        calllog.request_start_time__c = datetime.now();
        
        // get token
        String endpoint = Label.REST_TransDB_GetToken_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/auth/token';
        String body = 'username=' + Label.REST_TransDB_GetToken_Username + '&password=' + 
            apputils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; //'username=apidemo&password=password*1';
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setbody(body);
        req.setHeader('Accept', 'application/json');
        Http http = new Http();
        HTTPResponse response = http.send(req);

        System.debug ('================= response message : ' + response.getBody ());
        Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
        
        String token = (string) responsemap.get('token');
        System.debug ('================= response token : ' + responsemap.get('token') );
        System.debug ('================= response message : ' + response.getBody ());
                   
        // POST request
        endpoint = Label.REST_TransDB_BAP_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/baps';
        req.setEndpoint(endpoint);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token );
        
        system.debug ('================== bapid : ' + bapid);

        string headerService='approvebap';

        Body oBody = new Body();
        oBody.header.service=headerService;
        oBody.header.request_id = AppUtils.getNewGUID();
        oBody.body.data.bapID = bapid ;

        oBody.body.data.approveType = approveType ;
        oBody.body.data.approveEmail= approveEmail;
        oBody.body.data.approveDate = approveDate;
        
        string jsonString = JSON.serialize(oBody);
        system.debug ('================= oBody1 :' + oBody );    
        system.debug ('================= oBody2 :' + jsonString );
        
        jsonString = Apputils.stripJsonNulls(jsonString);
        req.setBody(jsonString);
        System.debug ('================= jsonString : ' + jsonString);
        response = http.send(req);


        string restResult = response.getBody ();
        System.debug ('================= response message : ' + response.getBody ());
        
        responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
        System.debug ('================= responsemap : ' + responsemap);
        
        
        string status = Apputils.getStringDataOnMap(responsemap, 'headers::status');
        if (!apputils.isKeysetNotFound (status)) {
            if (status=='success') {
            }
        }
        else {
            status ='failed';
            apputils.puterror('BAP ID : ' + bapid + ' Failed on approval, JsonResult=' + restResult + '::159'  );
                

            
        }
        // put callout information
        calllog.request_message__c = jsonString;
        calllog.response_message__c = response.getBody ();
        calllog.status__c = status; //Apputils.getStringDataOnMap(responsemap, 'headers::status');
        //calllog.uri__c = req.requestURI;        
        calllog.callerFrom__c = '' ; 
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');

        // put callout information then save the data on Call_Log object
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(restResult) ;            
        insert calllog;

    }

    
    @future(callout=true)
    public static void mirroringBAP ( string bapsfid, string bapid,
        string typeOfRequest, string customer, string cid, string sirkit, string address,
        string pic, string picPhone, string picEmail, string picPosition, string bandwidth,
        string bandwidthUom, string requestDate, string terminateDate, string reason, 
        string note, string userCreate    
        ) {
    //public static void addBAP () {
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callout';
        calllog.request_start_time__c = datetime.now();
        
        // REQUEST to transDB for create a BAP
        // get token
        
        String endpoint = Label.REST_TransDB_GetToken_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/auth/token';
        String body = 'username=' + Label.REST_TransDB_GetToken_Username + '&password=' + 
            apputils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; //'username=apidemo&password=password*1';
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setbody(body);
        req.setHeader('Accept', 'application/json');
        Http http = new Http();
        HTTPResponse response = http.send(req);
        
        System.debug ('================= response message : ' + response.getBody ());
        Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
        
        String token = (string) responsemap.get('token');
        System.debug ('================= response token : ' + responsemap.get('token') );
        System.debug ('================= response message : ' + response.getBody ());
                   
                   
        // POST request
        endpoint = Label.REST_TransDB_BAP_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/baps';
        req.setEndpoint(endpoint);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token );
        
        system.debug ('================== bapid : ' + bapid);
        string headerService='';
        if (bapid=='' || bapid == null) {
            headerService='addbap';
            req.setMethod('POST');
            calllog.method__c = 'POST';
            } 
        else {
            headerService='updatebap';
            req.setMethod('POST');
            calllog.method__c = 'POST';
            }
                    
        
        Body oBody = new Body();
        oBody.header.service=headerService;
        oBody.header.request_id = AppUtils.getNewGUID();
        oBody.body.data.bapID = bapid ;
        oBody.body.data.typeOfRequest = typeOfRequest ;
        oBody.body.data.customer= customer;
        oBody.body.data.cid = cid;
        oBody.body.data.sirkit= sirkit;
        oBody.body.data.address= address;
        oBody.body.data.pic= pic;
        oBody.body.data.picPhone= picPhone;
        oBody.body.data.picEmail= picEmail;
        oBody.body.data.picPosition= picPosition;
        oBody.body.data.bandwidth= bandwidth;
        oBody.body.data.bandwidthUom= bandwidthUom;
        oBody.body.data.requestDate= requestDate;
        oBody.body.data.terminateDate= terminateDate;
        oBody.body.data.reason= reason;
        oBody.body.data.note= note;
        oBody.body.data.userCreate= userCreate;
        
        string jsonString = JSON.serialize(oBody);
        system.debug ('================= oBody1 :' + oBody );    
        system.debug ('================= oBody2 :' + jsonString );
        
        
        req.setBody(jsonString);
        response = http.send(req);

        string restResult = response.getBody ();
        System.debug ('================= response message : ' + response.getBody ());
        
        responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
        System.debug ('================= responsemap : ' + responsemap);
        
        
        string status = Apputils.getStringDataOnMap(responsemap, 'headers::status');
        if (!apputils.isKeysetNotFound (status)) {
            if (status=='success') {
                string idBAP = Apputils.getStringDataOnMap(responsemap, 'body::data::id_bap');
                List<BAP__c> baps = [select id, name from bap__C c where id =:bapsfid];
                if (!apputils.isKeysetNotFound (idBAP)) {
                    // update ID BAP
                    baps[0].BAP_ID__c = idBAP;
                    baps[0].Mirroring_status__c = '';
                    update baps;
                }
                else {
                    // no BAP ID

                }

            }

        }
        else {
            status='Failed';
            // move back request status to Draft
            List<BAP__c> baps = [select id, name from bap__C c where id =:bapsfid];
            if (baps.size()>0) {
                string bapName=baps[0].name;
                System.debug('------------- bapName '+ bapName );

                /*
                User cont = baps[0].owner;
                // send email to Sales
                System.debug('------------- cont '+ cont );
                System.debug('------------- opo '+ baps[0].owner     );
                // Step 0: Create a master list to hold the emails we'll send
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                
                // Step 1: Create a new Email
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                // Step 2: Set list of people who should get the email
                List<String> sendTo = new List<String>();
                sendTo.add('doddy.kusumadhynata@saaten.com');
                mail.setToAddresses(sendTo);
                
                // Step 3: Set who the email is sent from
                mail.setReplyTo('doddy.prima@gmail.com');
                mail.setSenderDisplayName('Dopri');
                
                // (Optional) Set list of people who should be CC'ed
                List<String> ccTo = new List<String>();
                ccTo.add('doddy_prima@yahoo.com');
                mail.setCcAddresses(ccTo);

                // Step 4. Set email contents - you can use variables!
                mail.setSubject('BAP Name : ' + baps[0].name + ' cannot be submit' );
                String ebody = 'Dear ' + cont.FirstName + ', ';
                ebody += 'The BAP with name is ' + baps[0].name + ' cannot be summit.';
                ebody += 'The request status move back to Draft';
                ebody += 'Contact your system administration';
                mail.setHtmlBody(ebody);
                
                // Step 5. Add your email to the master list
                mails.add(mail);

                // Step 6: Send all emails in the master list
                Messaging.sendEmail(mails);
                */

                apputils.puterror('BAP Name : ' + baps[0].name + ' cannot be summit::At mirroringBAP, JsonResult=' + restResult + '::311'  );
                baps[0].request_status__c = 'Draft';
                baps[0].mirroring_status__c = 'failed';
                update baps;
            }
        }

        // put callout information
        calllog.request_message__c = jsonString;
        calllog.response_message__c = response.getBody ();
        calllog.status__c = status;
        //calllog.uri__c = req.requestURI;        
        calllog.callerFrom__c = '' ; 
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');

        // put callout information then save the data on Call_Log object
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(restResult) ;            
        insert calllog;
    }
    
    /*
    @HttpGet
    global static RESTResultX doGet(){
        
        RESTResultX restResult = new RESTResultX('', ''); 
        return restResult ;
    }
    */
    


    /*
     * THIS METHOD FOR BAP UPDATE PROCESS
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
        
        
        string BAPStatus;
        string BAPNo;
        string BAPID;
        string approvalIOM ;
        string remark;

        /*        
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
        */
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'PUT';
        calllog.request_start_time__c = datetime.now();
        
        List <BAP__c> tmpBAPs = new List <BAP__c>();
        List <BAP__c> listBAP= new List <BAP__c>();
        //BAP__c oBAP = new BAP__c();
        

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

                   if (service != 'updatebap') {
                       // the service is NOT RELEVANT

                       status = 'failed';
                       errMessage = 'the service is not relevant';
                       errCode = '1';
                   }
                   else {
                        // the service name is RELEVANT
                        
                        Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');

                        List <BAP__c> listLink = new List <BAP__c>();
                       
                        BAP__c oBAP = new BAP__c();
                        
                        BAPStatus = AppUtils.getStringDataOnMap(mapRec , 'bap_status');
                        BAPNo = AppUtils.getStringDataOnMap(mapRec , 'bap_no');
                        BAPID = AppUtils.getStringDataOnMap(mapRec , 'bap_id');
                        approvalIOM = AppUtils.getStringDataOnMap(mapRec , 'approval_iom');
                        remark = AppUtils.getStringDataOnMap(mapRec , 'remark');
                                                
                        
                        // Get BAP Record data
                        System.debug(' ============ SQL : SELECT id FROM BAP__c WHERE BAP_ID__c= ' + BAPID);
                        if (! (AppUtils.isKeysetNotFound(BAPID) || BAPID=='' ) ){
                                tmpBAPs = [SELECT id FROM BAP__c WHERE BAP_ID__c = : BAPID  LIMIT 1 ];
                                system.debug('============ tmpBAPs : ' + tmpBAPs );
                                
                                if (tmpBAPs .size() > 0){
                                    oBAP = tmpBAPs [0];
                                    status = 'success';
                                }
                                else {
                                    status = 'failed';
                                    errMessage = 'BAP not found on the data. ';
                                    errCode = '1';
                                }
                        }

                        if (AppUtils.isKeysetNotFound(BAPID) || BAPID=='' ) {
                            status = 'failed';
                            errMessage = 'BAP not found on the data. ';
                            errCode = '1';
                        }            

                        if (status != 'failed') {

                            if (!AppUtils.isKeysetNotFound(BAPStatus )) oBAP.BAP_Status__c= BAPStatus ;  //<<
                            if (!AppUtils.isKeysetNotFound(ApprovalIOM)) oBAP.Approval_IOM__c = ApprovalIOM;
                            if (!AppUtils.isKeysetNotFound(remark)) oBAP.Remark__c = Remark;
                            
                            oBAP.record_info__c='last update from external system';
                            
                                
                            listBAP.add (oBAP); 
                            }     
                            System.debug('=================== oBAP : ' + oBAP);
                            System.debug('=================== listBAP : ' + listBAP);
                    
                            if (status != 'failed'){
                                update listBAP;
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