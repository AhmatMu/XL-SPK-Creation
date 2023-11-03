@RestResource(urlMapping='/simcardactivationsXXX/*')
//------  /services/apexrest/simcardactivations
/*
    by doddy
*/

global with sharing class REST_SIMCardActivations {
    List<string> attachmentIDs = new List<string> (); 

  @future(callout=true)
  public static void CreateSalesActivation(String OpportunityID)
  {

    string endpoint = Label.REST_TransDB_GetToken_Endpoint ;
    string username = Label.REST_TransDB_GetToken_Username ;
    string password = appUtils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; 
    string token = apputils.getToken(endpoint, username, password, 1 );

    string requestMessage ='';
    string responseMessage = '';
    string callerFrom='';    

    Call_Log__c calllog = new Call_Log__c();
    calllog.type__c='Callout';
    calllog.request_start_time__c = datetime.now();
    calllog.method__c = 'POST';

    endPoint = Label.REST_TransDB_SimCardActivation_Endpoint;

	Opportunity O = null;
	
	List<Opportunity_attachment__c> OAs = new List<Opportunity_attachment__c>();

    if (token<>'failed') {

/*
  	 String endpoint = 'https://easy-ops.xl.co.id/dev/api/auth/token';
        String body = 'username=apidemo&password=password*1';
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
        
        Attachment attach = [select Body,ContentType,Name from Attachment limit 1];
*/
        try {
            O=[SELECT ID, Package_Product__r.product_id__c, SIMCard_Activation_Payment_Type__c, Account_LA_IDCOM__c, 
            		Account_LA_IDCOM__r.Account_type__c, APN__r.Name,Note__c,Service_Type__c, 
            		Price_Plan_Ref__r.Price_Plan_ID__c, //Price_Plan__c,
            		OU__c, APN__r.APN_ID__c,
            		Owner.email,Card_type__c,SIMCard_Order_Payment_Type__c,Opportunity_ID__c,Account.Account_type__c,
            		Account_LA_IDCOM__r.Temporary_LA_or_IDCom__c,Account_LA_IDCOM__r.LA_Number__c , sa_id__C
            	FROM Opportunity 
            	WHERE Opportunity_ID__c=:OpportunityID];
            OpportunityLineItem OLI=[SELECT id,productCode FROM OpportunityLineItem WHERE OpportunityID=:O.ID LIMIT 1];
            List<OpportunityLineItem> olis=[SELECT id,productCode, name , Product2.name,  Product2.AO_List__c FROM OpportunityLineItem WHERE OpportunityID=:O.ID  ];
            
            // ---- get MSISDN need to activate
            list<MSISDN__c> Msi=[SELECT name, ICCID__c,Label__c,MSISDN_No__c FROM Msisdn__c 
                WHERE Request_to_activate__c=true 
                    and Package_Activation_Opportunity__c=:O.id
                    and active__c <> true ];

            HttpRequest req = new HttpRequest();
            string requestId = '';
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();  
            String response ='';
            string attachmentBody;
		
		    // ---- get Attachments files
            List<ContentVersion> attachments = AppUtils.getOpportunityFilesOnBase64(O.ID);
            List<String> attachmentIDs = new List<String>();

			system.debug('============== attachments.size :' + attachments.size());
            if (attachments.size() >0){
            	integer attInd=0;
            	//List<Opportunity_attachment__c> OAs = new List<Opportunity_attachment__c>();  
            	
                //For (ContentVersion att :attachments) {
                for ( integer i = 0; i< attachments.size(); i++ ){
                		
                	ContentVersion att = attachments[i];
                	
                	system.debug('============== attInd :' + attInd);
                	system.debug('============== att :' + att);
                	system.debug('============== att.title :' + att.title);
                	attInd++;
                	
                	BodyUpload oBody = new BodyUpload();
					//oBody.header.service='uploadfilebulk';
					oBody.header.service='uploadfile';
					oBody.header.request_id = AppUtils.getNewGUID();

                	try {                  
			          req = new HttpRequest();
			          res = new HttpResponse();
			          http = new Http();
			          //endpoint = 'https://easy-ops.xl.co.id/dev/api/sales_order/'; 
			          endpoint = Label.REST_TransDB_SimCardActivation_Endpoint;
			          
			          	req.setEndpoint(endpoint);
						req.setHeader('Accept', 'application/json');
						req.setHeader('Content-Type', 'application/json');
						req.setHeader('Authorization', 'Bearer ' + token );
						req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
						req.setMethod('POST');
			          	
			          	string base64EncodeString = EncodingUtil.base64Encode(att.VersionData);
			          	system.debug('============= base64EncodeString: ' +base64EncodeString );
			          	
						oBody.body.data.file = base64EncodeString;            
						system.debug('============= oBody: ' +oBody );
						attachmentBody = JSON.serialize(oBody);
						system.debug('============= attachmentBody: ' +attachmentBody );
						req.setBody(attachmentBody);
						
			          //if (!Test.isRunningTest()) {      
			            res = http.send(req);
			            response = res.getBody();
			            System.debug('============== response:' + response);
			          //}
			          
                	}
                	catch (Exception e) {         
			            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
			          }
			          
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
	                        }
	                    }
	                    if (success=='false') {
	                    	sentStatus = 'Sent Failed';
	                    }
	                    
	                    // Update OPPORTUNITY ATTACHMENT
                        string ContentDocumentId = att.ContentDocumentId;
                        string ContentVersionID  = att.id;
                        List<Opportunity_attachment__c> tmpOAs =[select id, easyops_id__c from Opportunity_attachment__c 
                        	where ContentDocumentId__c = :ContentDocumentId AND opportunity__c =:O.id];
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
                            calllog.status__c = 'Failed';
                            string errMessage = 'Error on addSimCardActivation method. Attachment no: ' + attInd + '.::' + e.getmessage() + '::' + e.getLineNumber()  ;
                            system.debug('==================== error message : ' + errMessage);
                            AppUtils.putError(errMessage );
                            
                            requestMessage = attachmentBody; //.substring(0,131065) + ' ...';
							responseMessage = response;
                        }
                	
                	//-------- sampai sini
                
                } // .END FOR
                
                
            }
            system.debug ('================ attachmentIDs : ' + attachmentIDs);


    /*
            // POST request
            endpoint = 'https://easy-ops.xl.co.id/dev/api/sales_order/uploadBase64';
            req.setEndpoint(endpoint);
            //    req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'Application/JSON');
            req.setHeader('Authorization', 'Bearer ' + token );
            req.setmethod('POST');		
            String attachmentBody = '{"file":"'+EncodingUtil.base64Encode(attach.Body)+'"}';
            req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
            req.setbody(attachmentbody);
            system.debug(attachmentbody);
            
            res = http.send(req); 
            String Reply=res.getBody();
            system.debug(Reply);
    */		
			
			if (calllog.status__c <> 'Failed' || calllog.status__c == '' || calllog.status__c == null) {    
	            Body oBody = new Body();
	
	            oBody.header.service='addsalesactivation';
	            oBody.header.request_id = AppUtils.getNewGUID(); 
	            
	            oBody.body.data.sales_id=O.Owner.email;
	            //NGA PAKAI!! oBody.body.data.sa_ticket_number= '20180611130344';
	
	            string suffix  = (O.card_type__c=='PREPAID') ? 'Prepaid' : (O.card_type__c=='POSTPAID') ? 'Postpaid' : '';
	            if (O.service_type__c == 'Migrate') {
	                oBody.body.data.sa_type= O.service_type__c  + ' to Corp ' +  suffix ;
	            }else { oBody.body.data.sa_type= O.service_type__c; }
	
	
	            oBody.body.data.opportunity_no=O.Opportunity_ID__c;
	            oBody.body.data.type_account=O.Account_LA_IDCOM__r.Account_type__c;
	            oBody.body.data.sa_com=O.Account_LA_IDCOM__r.Account_type__c;
	
	            if(O.Account_LA_IDCOM__r.LA_Number__c!='' && O.Account_LA_IDCOM__r.LA_Number__c!=null)
	                oBody.body.data.no_account=O.Account_LA_IDCOM__r.LA_number__c;
	            else
	                oBody.body.data.no_account=O.Account_LA_IDCOM__r.Temporary_LA_or_IDCom__c;
	            
	
	            // -- get products , put on offers keyset
	            List<string> ls = new List<string> (); 
	            if (olis.size() > 0) {
	                for (OpportunityLineItem tmpOli : olis ) {
	                	//TODO: masukkan daftar AO pada multi line.. 
	                    //ls.add (tmpOli.Product2.name);
	                    
	                    if (tmpOli.product2.AO_List__c <> null && tmpOli.product2.AO_List__c <>'') {
		                    List<String> aolist = tmpOli.product2.AO_List__c.split('\r\n');
		                    for (String ao : aolist) {
		                    	ls.add (ao);
		                    }
	                    }
	                }
	            }
	
	
	            oBody.body.data.sa_ou= O.OU__c;
	            oBody.body.data.sa_product = O.Package_Product__r.product_id__c;
	            oBody.body.data.sa_card_type=O.Card_Type__c;
	            oBody.body.data.sa_payment_type=O.SIMCard_Activation_Payment_Type__c;
	            oBody.body.data.sa_price_plan=O.Price_Plan_Ref__r.Price_Plan_ID__c; //<<< ganti ini ya
	            oBody.body.data.sa_status='DRAFT';
	            oBody.body.data.note=O.Note__c;
	            oBody.body.data.sa_apn_corp=O.APN__r.APN_ID__c;
	            oBody.body.data.attachment= attachmentIDs ;
	            oBody.body.data.offer= ls;              
	
	            for(Msisdn__c Ms:MSI) {
	                msisdn_profile m=new msisdn_profile();
	                m.mp_label=Ms.Label__c;
	                m.mp_iccid=Ms.ICCID__c;
	                m.mp_msisdn=Ms.name;
	                oBody.body.data.msisdn_profile.add(m);
	            }
				            
	            string jsonString = JSON.serialize(oBody);	
	            req = new HttpRequest();
	            endpoint = Label.REST_TransDB_SimCardActivation_Endpoint ; 
	            calllog.method__c = 'POST';
	            
	            req.setEndpoint(endpoint);
	            req.setHeader('Accept', 'application/json');
	            req.setHeader('Content-Type', 'application/json');
	            req.setHeader('Authorization', 'Bearer ' + token );
	            req.setMethod('POST');
	            req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
	            req.setBody(jsonString);
	                        
	            system.debug('================= REQUEST message : ' + jsonstring);
	            requestMessage = jsonstring;
	            calllog.status__c = 'Success';
				
				
				string restResult;
	            try {
	                http = new Http();
	                /* TUTUP DULU 			//TODO: ini untuk test */
	                res = http.send(req);            
	
	                restResult = res.getBody ();
	                responseMessage = restResult;
	                System.debug ('================= response message : ' + restResult);
	                
	                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped( restResult );
	                System.debug ('================= responsemap : ' + responsemap);
	                
	                /*
	                // old way to get STATUS -- 
	                String status = Apputils.getStringDataOnMap(responsemap, 'headers::status');
	                if (! apputils.isKeysetNotFound(status) ) {
	                    calllog.status__c = status;
	                } else {
	                    calllog.status__c = 'Failed';
	                } */
	                
	                /* TODO: buat hanle sub status!!*/
                	string detailStatus = Apputils.getStringDataOnMap(responsemap, 'body::data::success');
                	if (detailStatus == 'true') {
                    	calllog.status__c = 'Success';
                    	
                    	//--- do update SA_ID on opportunity
                    	string SAID = Apputils.getStringDataOnMap(responsemap, 'body::data::sa_id');
                    	if (! apputils.isKeysetNotFound(SAID) ) {
                    		o.sa_id__c= SAID ;
                    		update o;
                    	}
                    	
                	}else {
                		calllog.status__c = 'Failed';
                		
                	}
                	
	                /**/
	                
	            } catch (Exception e) {
	                calllog.status__c = 'Failed';
	                string errMessage = 'Error on SIMCardActivation method.::' + e.getmessage() + '::' + e.getLineNumber() ;
	                system.debug('==================== error message : ' + errMessage);
	                AppUtils.putError(errMessage );
	
	            }
			}
        }catch (Exception e) {
            //status ='failed';
            //errCode = '1';
            calllog.status__c = 'Failed';
            string errMessage = 'Error on SIMCardActivation method.::' + e.getmessage() + '::' + e.getLineNumber() ;
            system.debug('==================== error message : ' + errMessage);
            AppUtils.putError(errMessage );
            responseMessage = errMessage;
            
            
        }
    
    } else {
        responseMessage = 'Get Token is failed';
    }
    calllog.request_message__c = requestMessage; //jsonString;
    calllog.response_message__c = responseMessage; //restResult;
    
    //calllog.uri__c = req.requestURI;        
    calllog.callerFrom__c = 'Salesforce' ; 
    calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');

    // put callout information then save the data on Call_Log object
    calllog.response_end_time__c = datetime.now();     
    //calllog.response_message__c = JSON.serialize(restResult) ;            
    insert calllog;
    
    if ( calllog.status__c == 'Failed') {
    	O.stageName = 'Prospecting';
        update O;
            
    }
    
    system.debug('=============== oas :'+oas);
    update OAs;
    system.debug('=============== oas :'+oas);
  }
  
  
  @future(callout=true)
  public static void UpdateSalesActivationForAttachments(String OpportunityID)
  {
  	// MAIN CONDITION
  	// IF STAGE : "SUBMIT ORDER" AND "IMPLEMENTATION"
  	// IF ANY SENT FAILED ON ATTACHMENTS
  	
  	//-- GET TOKEN
  	string endpoint = Label.REST_TransDB_GetToken_Endpoint ;
    string username = Label.REST_TransDB_GetToken_Username ;
    string password = appUtils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; 
    string token = apputils.getToken(endpoint, username, password, 1 );

    string requestMessage ='';
    string responseMessage = '';
    string callerFrom='';    

    Call_Log__c calllog = new Call_Log__c();
    calllog.type__c='Callout';
    calllog.request_start_time__c = datetime.now();
    calllog.method__c = 'POST';

    endPoint = Label.REST_TransDB_SimCardActivation_Endpoint;
	Opportunity O = null;
	
	List<string> attachmentIDs = new List<string> ();
	List<string> allAttachmentIDs = new List<string> ();
	
	List<opportunity_attachment__c> OAs = new List<opportunity_attachment__c>();
	
    if (token<>'failed') {
		try {
			
			List<Opportunity> listOpp=[SELECT ID, Package_Product__r.product_id__c, SIMCard_Activation_Payment_Type__c, Account_LA_IDCOM__c, 
            		Account_LA_IDCOM__r.Account_type__c, APN__r.Name,Note__c,Service_Type__c, 
            		Price_Plan_Ref__r.Price_Plan_ID__c, //Price_Plan__c,
            		OU__c, APN__r.APN_ID__c,
            		Owner.email,Card_type__c,SIMCard_Order_Payment_Type__c,Opportunity_ID__c,Account.Account_type__c,
            		Account_LA_IDCOM__r.Temporary_LA_or_IDCom__c,Account_LA_IDCOM__r.LA_Number__c , sa_id__C
            	FROM Opportunity 
            	WHERE Opportunity_ID__c=:OpportunityID];
            
            O=listOpp[0];	
            	
			//-- GET SENT FAILED ATTACHMENTS based on OPPORTUNITY ID
			List<string> ContentVersionIDs = new List<string>();
			List<opportunity_attachment__c> failedOAs= [select id, ContentVersion_ID__c from opportunity_attachment__c where Opportunity__c= :O.ID  AND status__c='Sent Failed'];
			List<opportunity_attachment__c> allOAs = [select id, ContentVersion_ID__c, status__c, EasyOps_ID__c from opportunity_attachment__c where Opportunity__c= :O.ID ];
			
			if (allOAs.size()>0) {
				
				integer attInd=0;
				/*
				for (opportunity_attachment__c oa : failedOAs) {
					ContentVersionIDs.add(oa.ContentVersion_ID__c);
				}
				
				List <contentversion> 
	                attachments = [select id, Checksum, ContentDocumentId
	                            , ContentLocation, ContentModifiedById
	                            , ContentModifiedDate, ContentSize, ContentUrl, Description
	                            , ExternalDataSourceId, ExternalDocumentInfo1
	                            , ExternalDocumentInfo2, 
	                            title, VersionData, VersionNumber
	                        from contentversion 
	                        where ID in :ContentVersionIDs];
				*/
				HttpRequest req = new HttpRequest();
	            string requestId = '';
	            Http http = new Http();
	            HTTPResponse res = new HTTPResponse();  
	            String response ='';
	            string attachmentBody;
            	
            	/** TUTUP DULU */
				////// if (attachments.size()>0){
						
					//List<opportunity_attachment__c> OAs = new List<opportunity_attachment__c>();
	                //for ( integer i = 0; i< attachments.size(); i++ ){
				for ( integer i = 0; i< allOAs.size(); i++ ){
                    system.debug('============== allOAs[i].status__c' + allOAs[i].status__c);
                    
	            	if (allOAs[i].status__c =='Sent Success') {
	            		allAttachmentIDs.add(allOAs[i].EasyOps_ID__c);	
	            		
	            	}   	
	                else if (allOAs[i].status__c <>'Sent Success') {
	                	//--- SENT ATTACHMENT VIA API TO EASYOPS
	            		
	                	
	                	//ContentVersion att = attachments[i];
	                	string ContentVersionID = allOAs[i].ContentVersion_ID__c;
	                	Contentversion 
			                att = [select id, Checksum, ContentDocumentId
			                            , ContentLocation, ContentModifiedById
			                            , ContentModifiedDate, ContentSize, ContentUrl, Description
			                            , ExternalDataSourceId, ExternalDocumentInfo1
			                            , ExternalDocumentInfo2, 
			                            title, VersionData, VersionNumber
			                        from contentversion 
			                        where ID =:ContentVersionID];
	                
	                	
	                	
	                	system.debug('============== attInd :' + attInd);
	                	system.debug('============== att :' + att);
	                	system.debug('============== att.title :' + att.title);
	                	attInd++;
	                	
	                	BodyUpload oBody = new BodyUpload();
						//oBody.header.service='uploadfilebulk';
						oBody.header.service='uploadfile';
						oBody.header.request_id = AppUtils.getNewGUID();
	
	                	try {                  
				          req = new HttpRequest();
				          res = new HttpResponse();
				          http = new Http();
				          //endpoint = 'https://easy-ops.xl.co.id/dev/api/sales_order/'; 
				          endpoint = Label.REST_TransDB_SimCardActivation_Endpoint;
				          
				          	req.setEndpoint(endpoint);
							req.setHeader('Accept', 'application/json');
							req.setHeader('Content-Type', 'application/json');
							req.setHeader('Authorization', 'Bearer ' + token );
							req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
							req.setMethod('POST');
				          	
				          	string base64EncodeString = EncodingUtil.base64Encode(att.VersionData);
				          	system.debug('============= base64EncodeString: ' +base64EncodeString );
				          	
							oBody.body.data.file = base64EncodeString;            
							system.debug('============= oBody: ' +oBody );
							attachmentBody = JSON.serialize(oBody);
							system.debug('============= attachmentBody: ' +attachmentBody );
							req.setBody(attachmentBody);
							
								
				          //if (!Test.isRunningTest()) {      
				            res = http.send(req);
				            response = res.getBody();
				            System.debug('============== response:' + response);
				          //}
				          
				          
	                	}
	                	catch (Exception e) {         
				            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
				          }
				          
				        try {
				        	calllog.status__c = 'Success';
				        	System.debug ('================= response : ' + response);
		                    Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped( response );
		                    System.debug ('================= responsemap : ' + responsemap);
		                    string success = Apputils.getStringDataOnMap(responsemap, 'body::data::success'); 
		                    System.debug ('================= success : ' + success);	                    
	
		                    string sfID='';
		                    string sentStatus = '';
		                    if (success=='true') {
		                        sfID = Apputils.getStringDataOnMap(responsemap, 'body::data::sf_id');
		                        if (!AppUtils.isKeysetNotFound (sfID) ) {
		                            // ---- put sfID on the list
		                            attachmentIDs.add (sfID);
		                            allAttachmentIDs.add(sfID);
		                            sentStatus = 'Sent Success';
		                        }
		                    }
		                    if (success=='false') {
		                    	sentStatus = 'Sent Failed';
		                    }
		                    
		                    // Update OPPORTUNITY ATTACHMENT
	                        string ContentDocumentId = att.ContentDocumentId;
	                        system.debug('=============== att :'+att);
	                        system.debug('=============== ContentDocumentId :'+ContentDocumentId);
	                        ContentVersionID  = att.id;
	                        List<Opportunity_attachment__c> tmpOAs =[select id, easyops_id__c from Opportunity_attachment__c 
	                        	where ContentDocumentId__c = :ContentDocumentId AND opportunity__c =:O.id];
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
	                            calllog.status__c = 'Failed';
	                            string errMessage = 'Error on UpdateSalesActivationForAttachments method. Attachment no: ' + attInd + '.::' + e.getmessage() + '::' + e.getLineNumber()  ;
	                            system.debug('==================== error message : ' + errMessage);
	                            AppUtils.putError(errMessage );
	                            
	                            requestMessage = attachmentBody;//.substring(0,131065) + ' ...';
								responseMessage = response;
	                        }
	                }    
				} // .END FOR
	                
				///// }
				
				system.debug ('================ attachmentIDs : ' + attachmentIDs);
				system.debug ('================ allattachmentIDs : ' + allattachmentIDs);
				
				system.debug('============== calllog.status__c '+  calllog.status__c );
				//-- CALL MAIN API (sales_activation)
				if (calllog.status__c <> 'Failed' || calllog.status__c == '' || calllog.status__c == null) {    
		            Body oBody = new Body();
		
		            oBody.header.service='editsalesactivation';
		            oBody.header.request_id = AppUtils.getNewGUID(); 
		            
		            oBody.body.data.sales_id=O.Owner.email;
		
		            string suffix  = (O.card_type__c=='PREPAID') ? 'Prepaid' : (O.card_type__c=='POSTPAID') ? 'Postpaid' : '';
		            if (O.service_type__c == 'Migrate') {
		                oBody.body.data.sa_type= O.service_type__c  + ' to Corp ' +  suffix ;
		            }else { oBody.body.data.sa_type= O.service_type__c; }
		
		            oBody.body.data.opportunity_no=O.Opportunity_ID__c;
		            oBody.body.data.type_account=O.Account_LA_IDCOM__r.Account_type__c;
		            oBody.body.data.sa_com=O.Account_LA_IDCOM__r.Account_type__c;
		            oBody.body.data.sa_id=O.sa_id__C;
		            
		            if(O.Account_LA_IDCOM__r.LA_Number__c!='' && O.Account_LA_IDCOM__r.LA_Number__c!=null)
		                oBody.body.data.no_account=O.Account_LA_IDCOM__r.LA_number__c;
		            else
		                oBody.body.data.no_account=O.Account_LA_IDCOM__r.Temporary_LA_or_IDCom__c;
		            
		
		            // -- get products , put on offers keyset
		            List<OpportunityLineItem> olis=[SELECT id,productCode, name , Product2.name,  Product2.AO_List__c FROM OpportunityLineItem WHERE OpportunityID=:O.ID  ];
            
		            List<string> ls = new List<string> (); 
		            if (olis.size() > 0) {
		                for (OpportunityLineItem tmpOli : olis ) {
		                	//--- masukkan daftar AO pada multi line.. 
		                    if (tmpOli.product2.AO_List__c <> null && tmpOli.product2.AO_List__c <>'') {
			                    List<String> aolist = tmpOli.product2.AO_List__c.split('\r\n');
			                    for (String ao : aolist) {
			                    	ls.add (ao);
			                    }
		                    }
		                }
		            }
		
		
		            oBody.body.data.sa_ou= O.OU__c;
		            oBody.body.data.sa_product = O.Package_Product__r.product_id__c;
		            oBody.body.data.sa_card_type=O.Card_Type__c;
		            oBody.body.data.sa_payment_type=O.SIMCard_Activation_Payment_Type__c;
		            oBody.body.data.sa_price_plan=O.Price_Plan_Ref__r.Price_Plan_ID__c; 
		            oBody.body.data.sa_status='DRAFT';
		            oBody.body.data.note=O.Note__c;
		            oBody.body.data.sa_apn_corp=O.APN__r.APN_ID__c;
		            oBody.body.data.attachment= allAttachmentIDs ;
		            oBody.body.data.offer= ls;              
		
					// ---- get MSISDN need to activate
		            list<MSISDN__c> Msi=[SELECT name, ICCID__c,Label__c,MSISDN_No__c FROM Msisdn__c 
		                WHERE Request_to_activate__c=true 
		                    and Package_Activation_Opportunity__c=:O.ID
		                    and active__c <> true ];
                    
		            for(Msisdn__c Ms:MSI) {
		                msisdn_profile m=new msisdn_profile();
		                m.mp_label=Ms.Label__c;
		                m.mp_iccid=Ms.ICCID__c;
		                m.mp_msisdn=Ms.name;
		                oBody.body.data.msisdn_profile.add(m);
		            }
					            
		            string jsonString = JSON.serialize(oBody);	
		            req = new HttpRequest();
		            endpoint = Label.REST_TransDB_SimCardActivation_Endpoint ; 
		            calllog.method__c = 'POST';
		            
		            req.setEndpoint(endpoint);
		            req.setHeader('Accept', 'application/json');
		            req.setHeader('Content-Type', 'application/json');
		            req.setHeader('Authorization', 'Bearer ' + token );
		            req.setMethod('POST');
		            req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
		            req.setBody(jsonString);
		                        
		            system.debug('================= REQUEST message : ' + jsonstring);
		            requestMessage = jsonstring;
		            calllog.status__c = 'Success';
					
					
					string restResult;
		            try {
		                http = new Http();
		                /* TUTUP DULU 			//TODO: ini untuk test */
		                res = http.send(req);            
		
		                restResult = res.getBody ();
		                responseMessage = restResult;
		                System.debug ('================= response message : ' + restResult);
		                
		                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped( restResult );
		                System.debug ('================= responsemap : ' + responsemap);
		                
		                // put Callin information
		                String status = Apputils.getStringDataOnMap(responsemap, 'headers::status');
		                if (! apputils.isKeysetNotFound(status) ) {
		                    calllog.status__c = status;
		                } else {
		                    calllog.status__c = 'Failed';
		                }
		                /**/
		                
		            } catch (Exception e) {
		                calllog.status__c = 'Failed';
		                string errMessage = 'Error on UpdateSalesActivationForAttachments method.::' + e.getmessage() + '::' + e.getLineNumber() ;
		                system.debug('==================== error message : ' + errMessage);
		                AppUtils.putError(errMessage );
		
		
		            }
				}				
				 
			
			} // .END IF any attachment  to re-send 
			

			
		}  
		catch (Exception e) {
	            calllog.status__c = 'Failed';
	            string errMessage = 'Error on UpdateSalesActivationForAttachments method.::' + e.getmessage() + '::' + e.getLineNumber() ;
	            system.debug('==================== error message : ' + errMessage);
	            AppUtils.putError(errMessage );
	            responseMessage = errMessage;	            
	    }
	
    }
    else {
        responseMessage = 'Get Token is failed';
    }
    
    
	                
    calllog.request_message__c = requestMessage; //jsonString;
    calllog.response_message__c = responseMessage; //restResult;
    
    //calllog.uri__c = req.requestURI;        
    calllog.callerFrom__c = 'Salesforce' ; 
    calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');

    // put callout information then save the data on Call_Log object
    calllog.response_end_time__c = datetime.now();     
    //calllog.response_message__c = JSON.serialize(restResult) ;            
    insert calllog;
    
	if (OAs.size()>0) {
		try {
			update OAs;
			system.debug('=============== oas :'+oas);
		}
		catch (Exception e) {
	            calllog.status__c = 'Failed';
	            string errMessage = 'Error on UpdateSalesActivationForAttachments method.::' + e.getmessage() + '::' + e.getLineNumber() ;
	            system.debug('==================== error message : ' + errMessage);
	            AppUtils.putError(errMessage );
	            responseMessage = errMessage;	            
	    }
	}
    
  }
  

  	class AttachmentReturn{
  		String uploaded;
  		String msg;
  		String sf_id;
  		String filename;
  		String filename_real;
  	}
  	
  	
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
    
    
    class DataContent {
        //String sa_ticket_number;
        String sa_type;
        String type_account;
        String no_account;
        String sa_ou;
        String sa_product;
        String sa_card_type;
        String sa_payment_type;
        String sa_price_plan;
        String sa_status;
        String note;
        String sa_apn_corp;
        //String attachment;
        List<String> attachment;
        List<String> offer;
        String sales_id;
        String opportunity_no;
        string sa_com;
        string sa_id;
        list<MSISDN_Profile> msisdn_profile=new list<MSISDN_Profile>();
    }
    
    
    class MSISDN_Profile{
    	String mp_label;
    	String mp_iccid;
    	String mp_msisdn;
		//String mp_credit_limit;
		//String mp_credit_type;
		//String mp_mincom;
		//String mp_pic;
    }
    
    class Header {
        string service='';
        string request_id ='';
    }
    
}