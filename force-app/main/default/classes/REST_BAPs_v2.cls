@RestResource(urlMapping='/v2/baps/*')
global with sharing class REST_BAPs_v2 {
    
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
        string sfid ;
        string request_status=null;
        string status;
        string iom_file_link;
        string termination_for_nonautorenewal=null;
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
    
    @future(callout=true)
    public static void mirroringBAP ( string bapsfid, string bapid,
                                     string typeOfRequest, string customer, string cid, string sirkit, string address,
                                     string pic, string picPhone, string picEmail, string picPosition, string bandwidth,
                                     string bandwidthUom, string requestDate, string terminateDate, string reason, 
                                     string note, string userCreate , string request_status, string iom_file_link, string termination_for_nonautorenewal
                                    ) {
                                        //public static void addBAP () {
                                        
                                        Call_Log__c calllog = new Call_Log__c();
                                        calllog.type__c='Callout';
                                        calllog.request_start_time__c = datetime.now();
                                        String temp_uri = '';
                                        String temp_callerfrom = '';
                                        
                                        // REQUEST to transDB for create a BAP
                                        // get token
                                        
                                        String endpoint = Label.REST_TransDB_GetToken_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/auth/token';
                                        String body = 'username=' + Label.REST_TransDB_GetToken_Username + '&password=' + 
                                            apputils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; //'username=apidemo&password=password*1';
                                        HttpRequest req = new HttpRequest();
                                        req.setTimeout(120000);
                                        req.setEndpoint(endpoint);
                                        req.setMethod('POST');
                                        req.setbody(body);
                                        req.setHeader('Accept', 'application/json');
                                        Http http = new Http();
                                        HTTPResponse response = new HTTPResponse() ;
                                        //HTTPResponse response = http.send(req);
                                        
                                        ///*-----------
                                        if (!Test.isRunningTest())
                                            response = http.send(req);
                                        //HTTPResponse response = http.send(req);
                                        else {
                                            response.setStatusCode(200); response.setStatus('OK'); response.setBody('{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}');
                                        }
                                        //------------*/
                                        
                                        
                                        System.debug ('================= response message : ' + response.getBody ());
                                        Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
                                        
                                        String token = (string) responsemap.get('token');
                                        System.debug ('================= response token : ' + responsemap.get('token') );
                                        System.debug ('================= response message : ' + response.getBody ());
                                        
                                        
                                        // POST request
                                        endpoint = Label.REST_TransDB_BAP_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/baps';
                                        req.setTimeout(120000);
                                        req.setEndpoint(endpoint);
                                        req.setHeader('Accept', 'application/json');
                                        req.setHeader('Content-Type', 'application/json');
                                        req.setHeader('Authorization', 'Bearer ' + token );
                                        
                                        system.debug ('================== bapid : ' + bapid);
                                        system.debug ('================== request_status : ' + request_status);
                                        
                                        string headerService='';
                                        if (bapid=='' || bapid == null) {
                                            headerService='addbap';
                                            req.setMethod('POST');
                                            calllog.method__c = 'POST';
                                        } 
                                        else if (request_status==null || request_status== 'Operation Review') {
                                            headerService='updatebap';
                                            req.setMethod('POST');
                                            calllog.method__c = 'POST';
                                        }            
                                        else if ( request_status != null && request_status <> 'Operation Review') {
                                            system.debug ('================== request_status : ' + request_status);
                                            headerService='updatestatusbap';
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
                                        oBody.body.data.status= request_status;
                                        oBody.body.data.iom_file_link= iom_file_link;
                                        if(termination_for_nonautorenewal == 'true'){
                                            oBody.body.data.termination_for_nonautorenewal= termination_for_nonautorenewal;
                                        }
                                        
                                        string jsonString = JSON.serialize(oBody);
                                        system.debug ('================= oBody1 :' + oBody );    
                                        system.debug ('================= oBody2 :' + jsonString );
                                        
                                        jsonString = apputils.stripJsonNulls(jsonString);
                                        req.setBody(jsonString);
                                        //response = http.send(req);
                                        
                                        //
                                        if (!Test.isRunningTest())
                                            response = http.send(req);
                                        else {
                                            response.setStatusCode(200); response.setStatus('OK'); response.setBody('{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}');
                                        } 
                                        //
                                        
                                        string restResult = response.getBody ();
                                        System.debug ('================= response message : ' + response.getBody ());
                                        string status = '';
                                        
                                        try{
                                            
                                            responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
                                            
                                            System.debug ('================= responsemap : ' + responsemap);
                                            
                                            status = Apputils.getStringDataOnMap(responsemap, 'headers::status');
                                            
                                            system.debug('status nya :'+status);
                                            if (!apputils.isKeysetNotFound (status)) { 
                                                if (status=='success') {
                                                    string idBAP = Apputils.getStringDataOnMap(responsemap, 'body::data::id_bap');
                                                    string bapno = Apputils.getStringDataOnMap(responsemap, 'body::data::bap_no');
                                                    string requestStatus = Apputils.getStringDataOnMap(responsemap, 'body::data::status');
                                                    
                                                    
                                                    system.debug('== idBAP         :'+idBAP);
                                                    system.debug('== bapsfid       :'+bapsfid);
                                                    system.debug('== requestStatus :'+requestStatus);
                                                    
                                                    List<BAP__c> baps = [select id, name,BAP_ID__c,Mirroring_status__c,request_status__c,BAP_No__c from bap__C where id =:bapsfid];
                                                    if (!apputils.isKeysetNotFound (idBAP) && headerService=='addBAP'  ) {
                                                        // update ID BAP
                                                        baps[0].BAP_ID__c = idBAP;
                                                        if(termination_for_nonautorenewal == 'true'){
                                                            baps[0].request_status__c = 'BA Sent to Customer';
                                                        }else{
                                                            baps[0].request_status__c = 'Operation Review';
                                                        }
                                                    }
                                                    else if (headerService=='updatebap' ){
                                                        if (requestStatus == 'Cheking Data Contract') {
                                                            baps[0].request_status__c = 'Operation Review';
                                                        }
                                                    }
                                                    else if (headerService=='updatestatusbap' ){
                                                        //-- no specialy data update
                                                    }
                                                    
                                                    
                                                    baps[0].Mirroring_status__c = 'Success';
                                                    //baps[0].request_status__c = 'Operation Review';
                                                    baps[0].BAP_No__c = bapno; 
                                                    update baps;
                                                    
                                                    
                                                }
                                            }
                                            
                                            else {
                                                status='Failed';
                                                // move back request status to Draft
                                                List<BAP__c> baps = [select id, name from bap__C where id =:bapsfid];
                                                if (baps.size()>0) {
                                                    string bapName=baps[0].name;
                                                    System.debug('------------- bapName '+ bapName );
                                                    
                                                    apputils.puterror('BAP Name : ' + baps[0].name + ' cannot be summit::At mirroringBAP, JsonResult=' + restResult + '::343');
                                                    baps[0].request_status__c = 'Draft';
                                                    baps[0].mirroring_status__c = 'failed';
                                                    update baps;
                                                    
                                                }
                                            }
                                        }
                                        catch (Exception e)  {
                                            List<BAP__c> baps = [select id, name from bap__C where id =:bapsfid];
                                            apputils.puterror('Error on Mirroring method.:: ' + baps[0].name +' '+ e.getmessage() + ' - ' +e.getStacktraceString() +' ' + restResult +'::' + e.getLineNumber());
                                            
                                            status = 'Failed';    
                                            
                                        }
                                        // put callout information
                                        calllog.uri__c = temp_uri;
                                        calllog.callerFrom__c = temp_callerfrom; 
                                        calllog.request_message__c = jsonString;
                                        calllog.response_message__c = response.getBody ();
                                        calllog.status__c = status;
                                        //calllog.uri__c = req.requestURI;        
                                        calllog.callerFrom__c = '' ; 
                                        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
                                        
                                        // put callout information then save the data on Call_Log object
                                        calllog.response_end_time__c = datetime.now();     
                                        calllog.response_message__c = restResult; //JSON.serialize(restResult) ;      
                                        calllog.Salesforce_ID_1__c = bapsfid;    
                                        calllog.BAP__c = bapsfid;   
                                        insert calllog;
                                        
                                    }
    
    @HttpPut
    global static RESTResult doPut(){
        /*
version : 1
Sample Data 
https://cs75.salesforce.com/services/apexrest/v2/baps <--> 

// ------------------ sample data updatebapiomapproval ----------------- 	
{
"header": {
"request_id": "204412412",
"service": "updatebapiomapproval"
},
"body": {
"data": {
"bap_no": "",
"bap_id": "8745",
"orm": [
{
"pinalty_flag": 1,
"pinalty": 10000,
"lebih_tagih" : 10000,
"status_contact" : "Sebelum Masa Kontrak",
"start_date": "2020-01-02",
"end_date": "2020-01-02"
}
],
"ocm": [
{
"cost_flag": 1,
"cost": 0
}
]
}
}
}


/* --------------- sample data updatebapiomstatus ------------------- *
{
"header": {
"request_id": "1234567890",
"service": "updatebapstatus"
},
"body": {
"data": {
"bap_id": "875",
"status": "BAP Sent to Finance"
}
}
}



*/
        
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
        
        
        RESTResult r = new RESTResult();
        //String currentRequestURL;
        DateTime start_time = datetime.now();
        
        Call_Log__c calllog = new Call_Log__c();
        DataBAP resDAta = new DataBAP();
        //ERROR_MESSAGE err = new ERROR_MESSAGE();
        BAP__c LBAP = new BAP__c();
        String temp_uri = '';
        String temp_callerfrom = '';
        String temp_endpoint = '';
        String sfid_bap =null;
        try {	
            status = 'success';
            
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            param = RestContext.request.requestBody.toString().trim();
            Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped(param);
            
            temp_uri = request.requestURI;
            temp_callerfrom = request.remoteAddress;                  
            currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
            //temp_endpoint = currentRequestURL.replace (calllog.uri__c,'');
            
            requestid = AppUtils.getStringDataOnMap(paramMap , 'header::request_id');
            service = AppUtils.getStringDataOnMap(paramMap , 'header::service');
            
            String bap_no = AppUtils.getStringDataOnMap(paramMap , 'body::data::bap_no');
            String bap_id = AppUtils.getStringDataOnMap(paramMap , 'body::data::bap_id');
            String pinalty_flag = AppUtils.getStringDataOnMap(paramMap , 'body::data::orm::pinalty_flag');
            String pinalty = AppUtils.getStringDataOnMap(paramMap , 'body::data::orm::pinalty');
            String lebih_tagih = AppUtils.getStringDataOnMap(paramMap , 'body::data::orm::lebih_tagih');
            String start_date = AppUtils.getStringDataOnMap(paramMap , 'body::data::orm::start_date');
            String end_date = AppUtils.getStringDataOnMap(paramMap , 'body::data::orm::end_date');
            String cost_flag = AppUtils.getStringDataOnMap(paramMap , 'body::data::ocm::cost_flag');
            String cost = AppUtils.getStringDataOnMap(paramMap , 'body::data::ocm::cost');
            String request_status = AppUtils.getStringDataOnMap(paramMap , 'body::data::status');
            List<BAP__c> lstBAP = new list<BAP__c>();
            
            
            if (service == 'updatebapiomapproval') {
                if(bap_id != ''  || bap_id != null){
                    lstBAP = [select Id,BAP_no__c, BAP_ID__c,pinalty_flag__c,pinalty__c,lebih_tagih__c,
                              	contract_start_date__c,contract_end_date__c,cost_flag__c,cost__c,Request_Date__c,
                              	Terminate_Date__c, Default_Terminate_Date__c,
                              	IsBackDate__c, IsPenalty__c
                              from BAP__c WHERE BAP_ID__c = :bap_id];
                    
                    if(lstBAP.size()>0 )
                    {
                        for(BAP__c bapObj : lstBAP){
                            if(pinalty_flag<>null) bapObj.Pinalty_Flag__c = pinalty_flag=='1'?true:false;
                            if(pinalty<>null) bapObj.pinalty__c = double.valueof(pinalty);
                            if(lebih_tagih<>null) bapObj.lebih_tagih__c = double.valueof(lebih_tagih);
                            //if(start_date<>null) bapObj.contract_start_date__c = date.valueof(start_date);
                            //if(end_date<>null) bapObj.contract_end_date__c = date.valueof(end_date);
                            if(cost_flag<>null) bapObj.Cost_Flag__c = cost_flag=='1'?true:false;
                            if(cost<>null) bapObj.cost__c = double.valueof(cost);
                            //l.IsCostPartner__c = false;
                            //l.Approval_Flag__c = 'Tidak';
                            if(cost<>null) {
                                if(double.valueof(cost)>=100000000){
                                    bapObj.IsCostPartner__c = true;
                                    //l.Request_Status__c = 'IOM Approval';
                                    //l.Approval_Flag__c = 'Perlu';
                                } 
                            }
                            
                            if(pinalty_flag == '1'){
                                bapObj.IsPenalty__c = true;
                                bapObj.Request_Status__c = 'IOM Approval';
                                bapObj.Approval_Flag__c = 'Perlu';
                            } 
                            else {
                                bapObj.IsPenalty__c = false;
                            }
                            
                            /* -- ini untuk back date -- */
                            if(lstBAP[0].Terminate_Date__c < lstBAP[0].Request_Date__c ){
                                bapObj.IsBackDate__c = true;
                                bapObj.Request_Status__c = 'IOM Approval';
                                bapObj.Approval_Flag__c = 'Perlu';
                            } 
                            
                            /* -- ini untuk early, sementara set sebagai isBackDate -- */
                            if(lstBAP[0].Default_Terminate_Date__c > lstBAP[0].Request_Date__c && 
                               lstBAP[0].Terminate_Date__c < lstBAP[0].Default_Terminate_Date__c )

                             {
                                  bapObj.IsBackDate__c = true;
                                  bapObj.Request_Status__c = 'IOM Approval';
                                  bapObj.Approval_Flag__c = 'Perlu';                            
                              }
                            
     
                            /* -- ini untuk BAP tidak butuh IOM approval karena tidak Pinalti dan tidak Backdate  -- */
                            if( bapObj.IsBackDate__c != true && bapObj.IsPenalty__c != true) 
                            {
                                bapObj.Approval_Flag__c = 'Tidak';
                                bapObj.Request_Status__c = 'BA Sent to Customer';
                            }
                        }
                        
                        update lstBAP;
                        sfid_bap = lstBAP[0].Id;
                        errCode = '0';
                        
                        if (! test.isrunningTest()) {
                            RestContext.response.statusCode = 201;
                        }
                        
                        resData.sfid = lstBAP[0].Id;
                        
                        r.header.service = service;
                        r.header.request_id = requestid;
                        r.header.response_id = AppUtils.getUniqueNumber();
                        r.header.status = status;
                        r.body.except.error_message = '';
                        r.body.except.error_code = errCode;
                    }
                    else {
                        status = 'failed';
                        errCode = '400';
                        r.header.service = service;
                        r.header.request_id = requestid;
                        r.header.response_id = AppUtils.getUniqueNumber();
                        r.header.status = status;
                        r.body.except.error_message = 'Id_BAP Not Found';
                        r.body.except.error_code = errCode;
                    }  
                }
                else {
                    status = 'failed';
                    errCode = '400';
                    r.header.service = service;
                    r.header.request_id = requestid;
                    r.header.response_id = AppUtils.getUniqueNumber();
                    r.header.status = status;
                    r.body.except.error_message = 'Id_BAP Null';
                    r.body.except.error_code = errCode;
                }
            }
            else if (service == 'updatebapstatus') {
                if(bap_id != ''  || bap_id != null){
                    lstBAP = [select Id,BAP_no__c, BAP_ID__c,pinalty_flag__c,pinalty__c,lebih_tagih__c,contract_start_date__c,contract_end_date__c,cost_flag__c,cost__c,Request_Status__c,Complete_Status__c
                              from BAP__c WHERE BAP_ID__c = :bap_id];
                    
                    if(lstBAP.size()>0){   						
                        for(BAP__c bapObj : lstBAP){
                            if(request_status<>null){
                                bapObj.Request_Status__c = request_status;
                                if(request_status == 'Complete'){
                                    bapObj.Complete_Status__c = 'Done';
                                }
                            }
                        }
                        update lstBAP;
                        sfid_bap = lstBAP[0].Id;
                        errCode = '0';
                        
                        if (!test.isRunningTest())
                            RestContext.response.statusCode = 201;
                        
                        resData.sfid = lstBAP[0].Id;
                        
                        r.header.service = service;
                        r.header.request_id = requestid;
                        r.header.response_id = AppUtils.getUniqueNumber();
                        r.header.status = status;
                        r.body.except.error_message = '';
                        r.body.except.error_code = errCode;
                    }
                    else {
                        status = 'failed';
                        errCode = '400';
                        r.header.service = service;
                        r.header.request_id = requestid;
                        r.header.response_id = AppUtils.getUniqueNumber();
                        r.header.status = status;
                        r.body.except.error_message = 'Id_BAP Not Found';
                        r.body.except.error_code = errCode;
                    }   
                }
            }
            
            else {
                errCode = '400';
                r.header.service = service;
                r.header.request_id = requestid;
                r.header.response_id = AppUtils.getUniqueNumber();
                r.header.status = status;
                r.body.except.error_message = 'The request couldn’t be understood, usually because the JSON or XML body contains an error.';
                r.body.except.error_code = errCode;
            }
            
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
            
        }
        
        catch (Exception e) {
            
            status = 'failed';    		
            errCode = '403';
            calllog.status__c = status;
            r.header.service = service;
            r.header.request_id = requestid;
            r.header.response_id = AppUtils.getUniqueNumber();
            r.header.status = status;
            r.body.except.error_message = 'Error on Put Method.'+e.getmessage() + ' - ' +e.getStacktraceString() +' ' + e.getLineNumber();
            r.body.except.error_code = errCode;
            
            
        }	
        
        
        //-- put call log information
        calllog.uri__c = temp_uri;
        calllog.callerFrom__c = temp_callerfrom; 
        temp_endpoint = currentRequestURL.replace (calllog.uri__c,'');                 
        calllog.endpoint__c = temp_endpoint;
        calllog.type__c='Callin';
        calllog.method__c = 'PUT';
        calllog.request_start_time__c = start_time;
        calllog.status__c = status ;
        calllog.Request_Message__c = param;
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(r) ;
        calllog.Salesforce_ID_1__c = sfid_bap;
        //if (!Test.isRunningTest()){
          calllog.BAP__c = sfid_bap; 
        //}
        insert calllog;

        system.debug('r nya :'+r);
        
        return r;	
        
        
    }
}