@RestResource(urlMapping='/simcardproductionrequests/*')
global with sharing class REST_SIMCardRequest {
    // SIM CARD PRODUCTION REQUEST!!

    class Body {
        Header header = new Header();
        DataBody body  = new DataBody();
    } 
    
    class DataBody {
        DataContent data = new DataContent();
    }

    class DataContentDetail {
        string sfd_material;
        string branch_id;
        string sfd_qty;
    }
    
    class DataContent {
        string request_id ='';
        string sf_kode_forecast ='';
        string sales_id =''; // <-- email 
        string simcard_request_no='';
        string sf_sales_id ='';        
        string status='';   // <-- 1:DRAFT 2:SUBMIT 3:REJECT 4:REQUEST CHANNEL 5:ACK 6:ALL
        List<DataContentDetail> material= new List<DataContentDetail>() ;

    }
    
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
    
    @future(callout=true)
    public static void addSimCardRequest ( string requestid//,
        //string requestorId, string simcardName, decimal quantity, string status
        ) {
        System.debug('==================== on REST_SIMCardRequests class, addSimCardRequest method');
		List<SimCard_Production_Request_HEader__c>  header = new List<SimCard_Production_Request_HEader__c>();
        //-- GET TOKEN 
        
        String endpoint = Label.REST_TransDB_GetToken_Endpoint ;
        String username = Label.REST_TransDB_GetToken_Username ;
        String password = appUtils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; 
        string token = apputils.getToken(endpoint, username, password, 1 );
        //string token ='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyODEiLCJ1c2VybmFtZSI6ImFwaWRlbW8iLCJyZWFsX25hbWUiOiJBUEkgRGVtbyIsInVzZXJzdWJncm91cCI6IjM0IiwidXNlcnN1Ymdyb3VwX25hbWUiOiJPUFMtR09WIiwidXNlcmdyb3VwIjoiMjQiLCJ1c2VyZ3JvdXBfbmFtZSI6IkRTLU9QUyIsImVtYWlsIjoiYXBpZGVtb0B4bC5jby5pZCIsImlzX3Jvb3QiOm51bGwsImlhdCI6MTUzMTk4Nzc2MSwiZXhwIjoxNTMxOTk0OTYxfQ.V75zzhreguGBnDi1B2BDkrHXP02wF6tD0sJfLRQTPtA';

        System.debug('==================== token : ' + token);        
        //------------
        if (token <> 'failed') {    
            Call_Log__c calllog = new Call_Log__c();
            calllog.type__c='Callout';
            calllog.request_start_time__c = datetime.now();
            
            // REQUEST to transDB for create a Simcard request
            //----- POST REQUEST
            HttpRequest req = new HttpRequest();
            endpoint = Label.REST_TransDB_SalesForecast_Endpoint ; //'https://easy-ops.xl.co.id/dev/api/sales_forecast'; 
            String headerService='addsalesforecast';
            calllog.method__c = 'POST';
            
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token );
            req.setMethod('POST');
            req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
            
            //----- SET BODY DATA
            string forecastCode;
            string salesEmail='';
            string salesID='';
            string simcardRequestNo = '';

            Body oBody = new Body();
            oBody.header.service=headerService;
            oBody.header.request_id = AppUtils.getNewGUID();
            
            header = [select id, name, owner.email, createddate, owner.name,  ownerid, Status__c  
            	from SimCard_Production_Request_HEader__c 
                where id= :requestId ];
            
            if (header.size() > 0) {
                salesEmail = header[0].owner.email;
                datetime dt = header[0].createddate;
                //forecastCode = CASE(MONTH(DATEVALUE(dt), 1, "JAN", 2, "FEB", 3, "MAR",  4, "APR",  5, "MAY",  6, "JUN", 7, "JUL", 8, "AUG", 9, "SEP", 10, "OCT", 11, "NOV", 12, "DEC", "None") &
                //    YEAR(DATEVALUE(dt) + ' ' + header[0].owner.name;
                forecastCode = dt.format('MMMMYYYY') + ' ' + header[0].owner.name;
                forecastCode = forecastCode.touppercase();
                salesID = header[0].ownerid;
                simcardRequestNo = header[0].name; 
            }

            List<SimCard_Production_Request_Detail__c> details = [select id, Simcard__c, Material_code__C, Quantity__c, Account__c, Account__r.bp_number__c  from SimCard_Production_Request_Detail__c
                where SimCard_Production_Request_Header__c = :requestId];
            
            List<DataContentDetail> tmpDataContentDetails = new List<DataContentDetail>();
            DataContentDetail tmpDataContentDetail = null;
            
            if (details.size() >0 ) {
                for (SimCard_Production_Request_Detail__c detail : details) {
                    tmpDataContentDetail = new DataContentDetail();
                    tmpDataContentDetail.sfd_material  = detail.Material_code__C;
                    tmpDataContentDetail.branch_id = detail.Account__r.bp_number__c;                    
                    tmpDataContentDetail.sfd_qty  = string.valueOf (detail.Quantity__c);
                    tmpDataContentDetails.add (tmpDataContentDetail);
                }
            }

            oBody.body.data.request_id = requestId;
            oBody.body.data.sf_kode_forecast = forecastCode; 
            oBody.body.data.sales_id = salesEmail;  // <-- email
            oBody.body.data.simcard_request_no = simcardRequestNo;
            oBody.body.data.sf_sales_id = salesID;
            oBody.body.data.status = 'SUBMIT';
            oBody.body.data.material= tmpDataContentDetails; 

            string jsonString = JSON.serialize(oBody);
            system.debug ('================= oBody1 :' + oBody );    
            system.debug ('================= oBody2 :' + jsonString );
            
            req.setBody(jsonString);
            //----- END SET BODY DATA

            //-- CALL API
            string restResult;

            try {
                Http http = new Http();
                HTTPResponse response = http.send(req);            

                restResult = response.getBody ();
                System.debug ('================= response message : ' + restResult);
                
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped( restResult );
                System.debug ('================= responsemap : ' + responsemap);

                // put callout information
                String status = Apputils.getStringDataOnMap(responsemap, 'headers::status');
                if (! apputils.isKeysetNotFound(status) ) {
                    /* TODO: buat hanle sub status!!*/
                	string detailStatus = Apputils.getStringDataOnMap(responsemap, 'body::data::success');
                	if (detailStatus == 'true') {
                    	calllog.status__c = 'Success';
                	}else {
                		calllog.status__c = 'Failed';
                	}
                	/**/
                    //calllog.status__c = status;
                } else {
                    calllog.status__c = 'Failed';
                }
            } catch (Exception e) {
                calllog.status__c = 'Failed';
                string errMessage = 'Error on addSimCardRequest method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }
			
			// SET status to "IN PROGRESS" if hit process is SUCCESSFUL or back to "DRAFT" if FAILED 
			IF (calllog.status__c == 'Success') {
				header[0].status__c = 'In Progress';
				header[0].In_Progress_date__c =  Date.valueOf(System.Now());
			} 
			else IF (calllog.status__c == 'Failed') {
				header[0].status__c = 'Draft';
			} 
			update header[0];

            
            //calllog.uri__c = req.requestURI;        
            calllog.callerFrom__c = 'Salesforce' ; 
            calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');

            // put callout information then save the data on Call_Log object
            calllog.response_end_time__c = datetime.now();
            calllog.request_message__c = jsonString;     
            calllog.response_message__c = restResult ;            
            insert calllog;

        }
    }
    

    /*
     * THIS METHOD FOR SIM-CARD-REQUEST UPDATE PROCESS
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
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'PUT';
        calllog.request_start_time__c = datetime.now();
        
        List <BAP__c> tmpBAPs = new List <BAP__c>();
        List <BAP__c> listBAP= new List <BAP__c>();
        

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

                   if (service != 'updatesimcardrequest') {
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
                        
                        string simcardRequestNo = AppUtils.getStringDataOnMap(mapRec , 'simcard_request_no');
                        string SPRStatus = AppUtils.getStringDataOnMap(mapRec , 'status');

                        List<SimCard_Production_Request_Header__c> tmpSPRs = new List<SimCard_Production_Request_Header__c>();                  
                        SimCard_Production_Request_Header__c tmpSPR = new SimCard_Production_Request_Header__c();                  

                        // Get simcard_request  Record data
                        System.debug(' ============ SQL : SELECT id FROM SimCard_Production_Request_Header__c WHERE name= ' + simcardRequestNo);
                        if (! (AppUtils.isKeysetNotFound(simcardRequestNo) || simcardRequestNo=='' ) ){
                                tmpSPRs = [SELECT id FROM SimCard_Production_Request_Header__c WHERE name = :simcardRequestNo  LIMIT 1 ];
                                system.debug('============ tmpSPRs : ' + tmpSPRs );
                                
                                if (tmpSPRs .size() > 0){
                                    tmpSPR = tmpSPRs [0];
                                    status = 'success';
                                    
                                    //-- Get Materials Percentage
                                    List<Simcard_Production_Request_Detail__c> SPRDList = new List<Simcard_Production_Request_Detail__c>();
                                    List <Object> materialList = (List<Object>)  AppUtils.getListDataOnMap(mapRec, 'material');
                                    for (Object obj : materialList) {
                                    	Map<String, Object> tmpMapRec = (Map<String, Object>) obj;
                                    	String materialID = AppUtils.getStringDataOnMap(tmpMapRec, 'sfd_material') ;
                                    	String percentage = AppUtils.getStringDataOnMap(tmpMapRec, 'percentage') ;
                                    	
                                    	System.debug('=================== materialID : ' + materialID);
                                    	System.debug('=================== percentage : ' + percentage);
                                    	
                                    	List<Simcard_Production_Request_Detail__c> tmpSPRDList = [select id, Simcard__r.name, Material_Code__c, percentage__c 
                                    			from Simcard_Production_Request_Detail__c 
												where SimCard_Production_Request_Header__c = :tmpSPR.id
													and Material_Code__c=:materialID ];
										
										System.debug('=================== tmpSPRDList : ' + tmpSPRDList);
										
										if (tmpSPRDList.size() > 0) {
											tmpSPRDList[0].percentage__C= double.valueof(percentage) ;
											SPRDList.add(tmpSPRDList[0]);
										}
                                    }
                                    System.debug('=================== SPRDList : ' + SPRDList); 
                                    update SPRDList; //-- << update percentage
                                    
                                    
                                }
                                else {
                                    status = 'failed';
                                    errMessage = 'SIM Card Production Request record not found on the data. ';
                                    errCode = '1';
                                }
                        }

                        if (AppUtils.isKeysetNotFound(simcardRequestNo) || simcardRequestNo=='' ) {
                            status = 'failed';
                            errMessage = 'SIM Card Production Request record not found on the data. ';
                            errCode = '1';
                        }            

                        if (status != 'failed') {
                            if (!AppUtils.isKeysetNotFound(status )) 
                            	tmpSPR.Status__c= SPRStatus ;  //<<
                            	
                            	
                            	
                            	if (SPRStatus == 'Complete') {
                            		List<SimCard_Production_Request_Detail__c> details = [select id, Simcard__c, Material_code__C, Quantity__c 
                            				from SimCard_Production_Request_Detail__c
							                where SimCard_Production_Request_Header__c = :tmpSPR.id];
                            		
                            	}
                            
                            }     
                            System.debug('=================== oBAP : ' + oBAP);
                            System.debug('=================== listBAP : ' + listBAP);
                    
                            if (status != 'failed'){
                                //update listBAP;
                                update tmpSPR;
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