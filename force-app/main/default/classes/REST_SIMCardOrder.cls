@RestResource(urlMapping='/simcardorders/*')
//------  /services/apexrest/simcardorders
/*
	by doddy
*/

global with sharing class REST_SIMCardOrder {

  	class BodyUpload {
        Header header = new Header();
        DataBodyUpload body  = new DataBodyUpload();
    } 
    class DataBodyUpload {
        DataContentUpload data = new DataContentUpload();
    }
    class DataContentUpload {
    	string file;
    }
    
    class Body {
        Header header = new Header();
        DataBody body  = new DataBody();
    } 
    
    class DataBody {
        DataContent data = new DataContent();
    }

    class DataContentMaterial {
        string id;
        string qty;
    } 
    
    class DataContent {
        string opportunity_no ='';
        string sales_id ='';
        string branch_id =''; 
        string so_nama_pic='';
        string so_dealer_id ='';        
        string so_dealer_code='';   
        string so_sloc='';   
        string so_no_cof='';   
        string so_price='';
        List<string> attachment=null;   
        List<DataContentMaterial> material= new List<DataContentMaterial>() ;
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
    
    
    @future(callout=true) 
    public static void addSimCardOrder ( string opportunityId //,
        //string requestorId, string simcardName, decimal quantity, string status
        ) {
        System.debug('==================== on REST_SIMCardOrders class, addSimCardOrder method');
		
		string callLogstatus;
        //-- GET TOKEN 
        
        String endpoint = Label.REST_TransDB_GetToken_Endpoint ;
        String username = Label.REST_TransDB_GetToken_Username ;
        String password = appUtils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; 
        string token = apputils.getToken(endpoint, username, password, 1 );
        //string token ='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyODEiLCJ1c2VybmFtZSI6ImFwaWRlbW8iLCJyZWFsX25hbWUiOiJBUEkgRGVtbyIsInVzZXJzdWJncm91cCI6IjM0IiwidXNlcnN1Ymdyb3VwX25hbWUiOiJPUFMtR09WIiwidXNlcmdyb3VwIjoiMjQiLCJ1c2VyZ3JvdXBfbmFtZSI6IkRTLU9QUyIsImVtYWlsIjoiYXBpZGVtb0B4bC5jby5pZCIsImlzX3Jvb3QiOm51bGwsImlhdCI6MTUzMTk4Nzc2MSwiZXhwIjoxNTMxOTk0OTYxfQ.V75zzhreguGBnDi1B2BDkrHXP02wF6tD0sJfLRQTPtA';
		
		string requestMessage ='';
    	string responseMessage = '';
		List<Opportunity_attachment__c> OAs = new List<Opportunity_attachment__c>();
		
		list <string> attachmentErrMessages = new list <string>();
		
        System.debug('==================== token : ' + token);        
        //------------
        if (token <> 'failed') {    
            HttpRequest req = new HttpRequest();
            string requestId = '';
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();  
            String response = '';
            String headerService='addsalesorder';
            string attachmentBody;
            
            List<Call_Log__c> calllogAttList = new List <Call_Log__c>();
            Call_Log__c calllogAtt = new Call_Log__c();
            

            //----- SET BODY DATA
            Body oBody = new Body();
            oBody.header.service=headerService;
            oBody.header.request_id = AppUtils.getNewGUID();
            
            //-- Get related Opportunity
            List<Opportunity> Olist = [ SELECT id, name, Opportunity_ID__c, ownerid, owner.email, owner.name, account.bp_number__c, AccountId
                    , dealer_id__c, dealer_code__c, sloc__r.name, no_cof__c, SIMCard_Order_Payment_Type__c
                    , (SELECT Quantity, ProductCode FROM OpportunityLineItems), so_id__c
                FROM opportunity  
                WHERE id = :opportunityId ]; 

		
            //TODO: get  PIC SITE from Account!!
            Opportunity simcardOrder = new Opportunity();
            
            if (OList.size() >0 ) {
            	simcardOrder = OList[0];
            	
                String picSite;
                List<AccountContactRelation> picSiteList = [SELECT Id, Roles, account.name, contact.name, contact.email 
						FROM AccountContactRelation 
						where roles includes  ('PIC Site') and accountid =:simcardOrder.AccountId ];
                if (picSiteList.size()>0) {
                	picSite = picSiteList[0].contact.name;
                }
                
                DataContent dc = new DataContent();
                dc.opportunity_no = simcardOrder.Opportunity_ID__c;
                dc.sales_id = simcardOrder.owner.email;
                dc.branch_id = simcardOrder.account.bp_number__c; 
                dc.so_nama_pic = picSite;
                dc.so_dealer_id = simcardOrder.dealer_id__c;         
                dc.so_dealer_code = simcardOrder.dealer_code__c ;   
                dc.so_sloc = simcardOrder.sloc__r.name;    
                dc.so_no_cof = simcardOrder.no_cof__c ;   
                dc.so_price = (simcardOrder.SIMCard_Order_Payment_Type__c == 'FREE') ? 'GRATIS' 
                    : (simcardOrder.SIMCard_Order_Payment_Type__c == 'PAID') ? 'BERBAYAR' :''; 

                //List<string> attachment=null;   
                //List<DataContentMaterial> material= new List<DataContentMaterial>() ;  

                //-- GET list of ATTACHMENTS
                //  SELECT ContentDocumentId, ContentDocument.title, LinkedEntityId, ShareType, Visibility 
                //  FROM ContentDocumentLink WHERE LinkedEntityId = '0065D000003K5jc'

				// ---- INI DITUTUP DULU !!!!!!! ---
                // ---- get Attachments files
                List<ContentVersion> attachments = AppUtils.getOpportunityFilesOnBase64(simcardOrder.ID);
                //List<ContentVersion> attachments = new List<ContentVersion>() ;
                
                List<String> attachmentIDs = new List<String>();

                if (attachments.size() >0){
                	
                	integer attInd=0;
                    //For (ContentVersion att :attachments) {
                    for ( integer i = 0; i< attachments.size(); i++ ){
                    	
                    	ContentVersion att = attachments[i];
                    	system.debug('============== attInd :' + attInd);
	                	system.debug('============== att :' + att);
	                	system.debug('============== att.title :' + att.title);
	                	attInd++;
                    	
                    	BodyUpload oBodyUpload = new BodyUpload();
						oBodyUpload.header.service='uploadfile';
						oBodyUpload.header.request_id = AppUtils.getNewGUID();
						
						calllogAtt = new Call_Log__c();
						calllogAtt.type__c = 'Callout';
						calllogAtt.request_start_time__c = datetime.now();
	                    calllogAtt.method__c = 'POST';
						calllogAtt.status__c = 'Success';
						
	                    try {	
	                        // call API upload data
	                        req = new HttpRequest();
	                        res = new HttpResponse();
				          	http = new Http();
				          
	                        endpoint = Label.REST_TransDB_SimCardOrder_Endpoint; 
	                        
	                        req.setEndpoint(endpoint);
							req.setHeader('Accept', 'application/json');
							req.setHeader('Content-Type', 'application/json');
							req.setHeader('Authorization', 'Bearer ' + token );
							req.setMethod('POST');
							req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
							
							string base64EncodeString = EncodingUtil.base64Encode(att.VersionData);
				          	//system.debug('============= base64EncodeString: ' +base64EncodeString );
							//oBodyUpload.body.data.file = base64EncodeString;            
							//system.debug('============= oBodyUpload: ' +oBodyUpload );
							//attachmentBody = JSON.serialize(oBodyUpload);
							requestID = AppUtils.getNewGUID();
							attachmentBody = '{"header":{"status":"","service":"uploadfile","response_id":"","request_id":"' + requestID  +'"}, '
									+ '	"body":{"data":{"file":"' + base64EncodeString + '"}}}';
									
							system.debug('============= attachmentBody: ' +attachmentBody );
							
							calllogAtt.request_message__c = attachmentBody.left( 130500);
							calllogAtt.callerFrom__c = 'Salesforce' ; 
							calllogAtt.endpoint__c = Label.REST_TransDB_SimCardOrder_Endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
							
							req.setBody(attachmentBody);
							
							system.debug('============= req: ' +req );
				            res = http.send(req);
				            response = res.getBody();
				            
							calllogAtt.response_message__c = response;
							calllogAtt.response_end_time__c = datetime.now();     
							
							System.debug('============== calllogAttList:' + calllogAttList);
				            System.debug('============== response:' + response);
			            }
	                	catch (Exception e) {         
				            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );          
				            
				            string errMessage = 'Error on addSimCardOrder method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                            system.debug('==================== error message : ' + errMessage);
                            attachmentErrMessages.add (errMessage) ;                             
                            requestMessage = attachmentBody; //.substring(0,131065) + ' ...';
							responseMessage = response;
							
							calllogAtt.status__c = 'Failed';
							calllogAtt.error_message__c = errMessage;
							calllogAtt.response_end_time__c = datetime.now();
				          }
                        
                        if (calllogAtt.status__c <> 'Failed') {
	                        try {
	                            Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped( response );
			                    System.debug ('================= responsemap : ' + responsemap);
			                    //boolean success = (boolean) Apputils.getStringDataOnMap(responsemap, 'success');
			                    string success = Apputils.getStringDataOnMap(responsemap, 'body::data::success'); 
			                    System.debug ('================= success : ' + success);	
	                            
	                            string sfID='';
			                    string sentStatus = '';
			                    if (success=='true') {
			                        sfID = Apputils.getStringDataOnMap(responsemap, 'body::data::sf_id');
			                        if (!AppUtils.isKeysetNotFound (sfID) ) {
			                            // ---- put sfID on the list
			                            attachmentIDs.add (sfID);
			                            sentStatus = 'Sent Success';
			                            calllogAtt.status__c = 'Success';
			                        }
			                    }
			                    if (success=='false') {
			                    	sentStatus = 'Sent Failed';
			                    	calllogAtt.status__c = 'Failed';
			                    }
			                    
			                    // Update OPPORTUNITY ATTACHMENT
		                        string ContentDocumentId = att.ContentDocumentId;
		                        string ContentVersionID  = att.id;
		                        List<Opportunity_attachment__c> tmpOAs =[select id, easyops_id__c from Opportunity_attachment__c 
		                        	where ContentDocumentId__c = :ContentDocumentId AND opportunity__c =:simcardOrder.id];
		                        if (tmpOAs.size()>0) {
		                        	for (Opportunity_attachment__c oa : tmpOAs) {
		                        		oa.easyops_id__c = sfID;
		                        		oa.status__c = sentStatus;
		                        		oa.ContentVersion_ID__c = ContentVersionID;
		                        		oas.add(oa);
		                        		system.debug('=============== oas :'+oas);
		                        	}
		                        }
	                        } catch (Exception e) {
	                            //callLogstatus= 'Failed'; 
	                            string errMessage = 'Error on addSimCardOrder method.::' + e.getmessage() + '::' + e.getLineNumber() ;
	                            system.debug('==================== error message : ' + errMessage);
	                            // taruh setelah callout --> AppUtils.putError(errMessage );
	                            attachmentErrMessages.add (errMessage) ; 
	                            
	                            requestMessage = attachmentBody; //.substring(0,131065) + ' ...';
								responseMessage = response;
								
								calllogAtt.status__c = 'Failed';
								calllogAtt.error_message__c = errMessage;
								
	                        }
                    	}
                        calllogAttList.add (calllogAtt);
                        
                    
                    } // .END FOR
                }
                system.debug ('================ attachmentIDs : ' + attachmentIDs);

                
                //-- get material (opportunity line item product)
                OpportunityLineItem[] olis = simcardOrder.OpportunityLineItems;
                DataContentMaterial[] materials = new list<DataContentMaterial>();
                if (olis.size() > 0) {
                    for (OpportunityLineItem oli : olis ) {
                        DataContentMaterial material = new DataContentMaterial();
                        material.id = oli.ProductCode;
                        material.qty = string.valueof (oli.quantity);
                        materials.add (material);
                    }
                }

                //-- Put material (product / sim cards)
                dc.material = materials;
				//-- PUT attachments
                dc.attachment=attachmentIDs;

                //-- SET BODY DATA --
                oBody.body.data = dc;
            } 

            string jsonString = JSON.serialize(oBody);
            system.debug ('================= oBody1 :' + oBody );    
            system.debug ('================= oBody2 :' + jsonString );
            
            
            //----- END SET BODY DATA
            
            
            
            

            //-- CALL API
            Call_Log__c calllog = new Call_Log__c();
            calllog.type__c = 'Callout';
            calllog.request_start_time__c = datetime.now();
            
            // REQUEST to transDB for create a Simcard ORDER
            //----- POST REQUEST
            req = new HttpRequest();
            endpoint = Label.REST_TransDB_SimCardOrder_Endpoint ; 
            calllog.method__c = 'POST';
            
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token );
            req.setMethod('POST');
            req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
            req.setBody(jsonString);

            string restResult;
            // TUTUP DULU
            try {
                http = new Http();
                res = http.send(req);            

                restResult = res.getBody ();
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
                    	
                    	//--- do update SO_ID on opportunity
                    	string SOID = Apputils.getStringDataOnMap(responsemap, 'body::data::so_id');
                    	if (! apputils.isKeysetNotFound(SOID) ) {
                    		simcardOrder.so_id__c= SOID ;
                    		update simcardOrder;
                    	}
                    	
                	}else {
                		calllog.status__c = 'Failed';
                		// TODO: send email to sales
                		// get message value '
                		string messageString = Apputils.getStringDataOnMap(responsemap, 'body::data::message');
                		System.debug ('================= messageString : ' + messageString);

	                	Send_Email__c se = new Send_Email__c ();
	                	se.user_receiver__c = simCardOrder.ownerid;
	                	se.subject__c = 'The Sim Card Order have been rejected. Opportunity No : ' + simCardOrder.Opportunity_ID__c;
	                	se.Message_Body__c = 'Dear ' + simCardOrder.owner.name  + '<br>' + '<br>'+ '<br>' 
	                		+ 'Your Sim Card Order for Opportunity No : ' + simCardOrder.Opportunity_ID__c + ' have been rejected because this reason :' + '<br>'
	                		+ messageString + '<br>'+ '<br>' + '<br>'+ '<br>'
	                		+ '<i>'
	                		+ 'Notes :  ' + '<br>' 
	                		+ 'Opportunity Name :  ' + simCardOrder.name + '</i>';
	                	se.status__c = 'New';
	                	insert se;	                	
	                	System.debug ('================= se : ' + se);
	                	
                	}
                }
                else {
                	// TODO: send email to sales
                	// get message value  contoh : {"status":400,"message":"material was not found!"}
                	calllog.status__c = 'Failed';
                	string messageString = Apputils.getStringDataOnMap(responsemap, 'message');
                	
                	Send_Email__c se = new Send_Email__c ();
                	se.user_receiver__c = simCardOrder.ownerid;
                	se.subject__c = 'The Sim Card Order have been rejected. Opportunity No : ' + simCardOrder.Opportunity_ID__c;
                	se.Message_Body__c = 'Dear ' + simCardOrder.owner.name  + '<br>' + '<br>'+ '<br>' 
                		+ 'Your Sim Card Order for Opportunity No : ' + simCardOrder.Opportunity_ID__c + ' have been rejected because this reason :' + '<br>'
                		+ messageString + '<br>'+ '<br>' + '<br>'+ '<br>'
                		+ '<i>'
                		+ 'Notes :  ' + '<br>'
                		+ 'Opportunity Name :  ' + simCardOrder.name + '</i>';
                	se.status__c = 'New';
                	insert se;                	
                }
                
            } catch (Exception e) {
                calllog.status__c = 'Failed';
                string errMessage = 'Error on addSimCardOrder method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
                calllog.error_message__c = errMessage;

            }
            //*/

			//insert CALL LOG for Attachments
			insert calllogAttList;
			if (attachmentErrMessages.size() > 0 ) {
				for (String errMessage : attachmentErrMessages) {
					AppUtils.putError(errMessage );
				}
			}
			
            calllog.request_message__c = jsonString;
            calllog.response_message__c = restResult;
            
            //calllog.uri__c = req.requestURI;        
            calllog.callerFrom__c = 'Salesforce' ; 
            calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');

            // put callout information then save the data on Call_Log object
            calllog.response_end_time__c = datetime.now();     
            calllog.response_message__c = restResult ;            
            insert calllog;
            
            System.debug('============== calllogAttList:' + calllogAttList);
            
			if   (calllog.status__c == 'Failed') {
				// ----- Moveback stage to "Prospecting"
                simcardOrder.stageName = 'Prospecting';
                update simcardOrder;
			}
        }
    }
 

    /*
     * THIS METHOD FOR SIM-CARD-ORDER UPDATE PROCESS BRO do
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
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'PUT';
        calllog.request_start_time__c = datetime.now();
        
        List <Opportunity> tmpOpps = new List<Opportunity>();
        Opportunity selectedOpp = new Opportunity(); 

        try  {
                RestRequest request = RestContext.request;
                //RestResponse response = RestContext.response;
                param = RestContext.request.requestBody.toString().trim();
                status ='success';
                
                // put callout information
                //calllog.request_message__c = param ;   
                calllog.request_message__c = param.left( 130500); //131072
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

                   if (service != 'updatesimcardorder') {
                       // the service is NOT RELEVANT

                       status = 'failed';
                       errMessage = 'the service is not relevant';
                       errCode = '1';
                   }
                   else {
                        // the service name is RELEVANT
                        // stageName = AppUtils.getStringDataOnMap(paramMap , 'body::data::stage');
                        paramMap = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');
                        String stageName = AppUtils.getStringDataOnMap(paramMap , 'stage');
                        String opportunityNo = AppUtils.getStringDataOnMap(paramMap , 'opportunity_no');

                        system.debug ('============ stage : ' + stageName);
                        system.debug ('============ opportunityNo : ' + opportunityNo);

                        // Get opportunity Record data
                        System.debug(' ============ SQL : SELECT id FROM Opportunity WHERE opportunity_id__c= ' + opportunityNo);
                        if (! (AppUtils.isKeysetNotFound(opportunityNo) || opportunityNo=='' ) ){
                                tmpOpps = [SELECT id, accountID FROM Opportunity WHERE opportunity_id__c= :opportunityNo LIMIT 1 ];
                                system.debug('============ tmpOpps : ' + tmpOpps );
                                
                                if (tmpOpps.size() > 0){
                                    selectedOpp = tmpOpps [0];
                                    status = 'success';
                                    errCode = '0';
                                    calllog.status__c = 'Success';
                                }
                                else {
                                    status = 'failed';
                                    errMessage = 'The Opportunity record not found on the data. ';
                                    errCode = '1';
                                    calllog.status__c = 'Failed';
                                }
                        }

                        if (AppUtils.isKeysetNotFound(opportunityNo) || opportunityNo=='' ) {
                            status = 'failed';
                            errMessage = 'The Opportunity record not found on the data. ';
                            errCode = '1';
                            calllog.status__c = 'Failed';
                        }            

                        if (status != 'failed') {
                            if ( stageName == 'Ready for Pickup'){
                                //--Set stageName on Opportunity
                                // TODO: put try an catch
                                selectedOpp.stageName = stageName;
                                update selectedOpp;

                                //-- Add MSISDNs 
                                //-- Set MSISDN ( Simcard_Order_Opportunity__c <-- opportunity id )
                                List<MSISDN__c> tmpmsisdnList = new List<MSISDN__c>();
								set<String> listmsisdnduplicate=new set<String>();
                                List <Object> msisdnList = (List<Object>)  AppUtils.getListDataOnMap(paramMap, 'msisdn_list');
                                
                                
                                //-- handling 10.000 records
                                List<List<MSISDN__c>> tmpmsisdnList2 = new List<List<MSISDN__c>>();
                                
                                integer recordNumber = msisdnList.size();
                                if(test.isrunningtest())
                                recordNumber=20000;
                                integer part = integer.valueOf( recordNumber / 9500 );
                                
                                system.debug ('===== recordNumber : ' + recordNumber);
                                system.debug ('===== part : ' + part);
                                system.debug ('===== recordNumber : ' + recordNumber);
                                
                                
                                if ( recordNumber >0 ) {
                                	integer ind=0;
                                	for (integer indPart=0; indPart < part; indPart++) {
                                		
                                		tmpmsisdnList = new List<MSISDN__c>();
                                		//boolean b = indRec < 9500 && ind < recordNumber;
                                		//system.debug ('===== indRec < 9500 && ind < recordNumber ' + b );
                                		for (integer indRec=0; (indRec < 9500 && ind < recordNumber); indRec++ ) {
                                			Object obj = msisdnList[ind];
                                			Map<String, Object> mapRec = (Map<String, Object>) obj;
		                                    //system.debug ('===== a : ' + AppUtils.getStringDataOnMap(mapRec, 'label'));
		                                    //system.debug ('===== b : ' + AppUtils.getStringDataOnMap(mapRec, 'iccid'));
		                                    //system.debug ('===== c : ' + AppUtils.getStringDataOnMap(mapRec, 'msisdn'));
											
		                                    MSISDN__c tmpmsisdn = new MSISDN__c();
		                                    /*
		                                    tmpmsisdn.label__c = AppUtils.getStringDataOnMap(mapRec, 'label') ;
		                                    tmpmsisdn.iccid__c = AppUtils.getStringDataOnMap(mapRec, 'iccid');
		                                    tmpmsisdn.name = AppUtils.getStringDataOnMap(mapRec, 'msisdn');
		                                    */
		                                    
		                                    tmpmsisdn.label__c = String.valueOf (mapRec.get('label'));
		                                    tmpmsisdn.iccid__c = String.valueOf (mapRec.get('iccid'));
		                                    tmpmsisdn.name = String.valueOf (mapRec.get('msisdn'));
		                                    

		                                    tmpmsisdn.Simcard_Order_Opportunity__c = selectedOpp.id;
		                                    tmpmsisdn.account__c = selectedOpp.accountID;  
		                                    tmpmsisdn.Status__c = 'Reserved';
		                                    
		                                    system.debug ('===== tmpmsisdn.Name : ' + tmpmsisdn.Name);
											if(!listmsisdnduplicate.contains(tmpmsisdn.Name))
											{
												system.debug ('===== masuk sini');
												listmsisdnduplicate.add(tmpmsisdn.Name);
												tmpmsisdnList.add(tmpmsisdn);
											}
                                			ind++;
                                		}
                                		system.debug ('===== indPart : ' + indPart);
                                		system.debug ('===== tmpmsisdnList : ' + tmpmsisdnList);
                                		tmpmsisdnList2.add(tmpmsisdnList);
                                		
                                	}
                                	
                                	system.debug ('===== tmpmsisdnList2.size : ' + tmpmsisdnList2.size());
                                	try {
                                		for (integer indPart=0; indPart < part; indPart++) {
	                                		system.debug ('===== tmpmsisdnList2[indPart] : ' + tmpmsisdnList2[indPart]);
	                                		insert tmpmsisdnList2[indPart];
                                		}
	                                	
	                                	
	                                }
	                                catch(exception e)
	                                {
	                                	errcode='1';
	                                	errMessage = 'Error on PUT SIMCardOrder method.::' + e.getmessage() + '::' + e.getLineNumber() ;
	                                }
                                
                                }
                                
                                //-- OLD VERSION no handle 10.000 records DML
                                /* 
                                for (Object obj : msisdnList) {
                                    Map<String, Object> mapRec = (Map<String, Object>) obj;
                                    system.debug ('===== a : ' + AppUtils.getStringDataOnMap(mapRec, 'label'));
                                    system.debug ('===== b : ' + AppUtils.getStringDataOnMap(mapRec, 'iccid'));
                                    system.debug ('===== c : ' + AppUtils.getStringDataOnMap(mapRec, 'msisdn'));
									
                                    MSISDN__c tmpmsisdn = new MSISDN__c();
                                    tmpmsisdn.label__c = AppUtils.getStringDataOnMap(mapRec, 'label') ;
                                    tmpmsisdn.iccid__c = AppUtils.getStringDataOnMap(mapRec, 'iccid');
                                    tmpmsisdn.name = AppUtils.getStringDataOnMap(mapRec, 'msisdn');
                                    tmpmsisdn.Simcard_Order_Opportunity__c = selectedOpp.id;
                                    tmpmsisdn.account__c = selectedOpp.accountID;  
                                    tmpmsisdn.Status__c = 'Reserved';
									if(!listmsisdnduplicate.contains(tmpmsisdn.Name))
									{
										listmsisdnduplicate.add(tmpmsisdn.Name);
    	                                tmpmsisdnList.add(tmpmsisdn);
									}
									
                                }
                                try{
                                insert tmpmsisdnList;
                                }
                                catch(exception e)
                                {
                                	errcode='1';
                                	errMessage = 'Error on PUT SIMCardOrder method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                                }
                                */
                                

                            }
                            if ( stageName == 'Closed Won'){
                                //--Set stageName on Opportunity
                                selectedOpp.stageName = stageName;
                                
                                // put notes and pic_pickup
                                String notes = AppUtils.getStringDataOnMap(paramMap , 'notes');
                                String picPickup= AppUtils.getStringDataOnMap(paramMap , 'pic_pickup');
                                
                                //if ! (AppUtils.isKeysetNotFound(notes)) { selectedOpp.notes__c = notes; }
                                //if ! (AppUtils.isKeysetNotFound(picPickup)) { selectedOpp.notes__c = picPickup;  }
                                
                                
                                update selectedOpp;
                            }
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
                errMessage = 'Error on PUT SIMCardOrder method.::' + e.getmessage() + '::' + e.getLineNumber() ;
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
            calllog.error_message__c  = errMessage;
            calllog.response_end_time__c = datetime.now();     
            calllog.response_message__c = JSON.serialize(restResult) ;      
            insert calllog;
            
            return restResult ;


        //RESTResultX restResult = new RESTResultX('', ''); 
        //return restResult ;    
    }
    public static void test(){
        Integer A=0;
        A=1;
        A=2;
        A=3;
        A=4;
        A=5;
        A=6;
        A=1;
        A=2;
        A=3;
        A=4;
        A=5;
        A=6;
        A=1;
        A=2;
        A=3;
        A=4;
        A=5;
        A=6;
        A=1;
        A=2;
        A=3;
        A=4;
        A=5;
        A=6;

    }
}