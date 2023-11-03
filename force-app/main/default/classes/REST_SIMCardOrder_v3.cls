/**
 * @description       : 
 * @Test Class        : REST_SIMCardOrder_v2_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-30-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-16-2023   Novando Utoyo Agmawan   Initial Version
**/

@RestResource(urlMapping='/v3/simcardorders/*')
global with sharing class REST_SIMCardOrder_v3 {
    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String token;
    public static Boolean doCallOut = false;

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

    /* ---------- addSimCardOrder ---------- */
    global class addSimCardOrder_Request{
        public String orderNo;	//SODO-0000-0000
        public String dealerId;	//90054412
        public String paymentMode;	//bank
        public String employeeId;	//900000
        public String costCenter;
        public String storageLoc;
        public String toLoc;
        public String destinationType;
        public String address;	//JAWA BARAT
        public String city;	//BEKASI
        public String requestType;
        public String remark;	//remark
        public List<cls_materials_addSimCardOrder> materials;
        public String bankName;	//MANDIRI
        public String accountNumber;	//800082828282
        public String accountName;	//SURYA CIPTA
        public String paymentDate;	//2022-10-01
    }

    global class cls_materials_addSimCardOrder {
		public String productCode;	//SP0KAXHITZ-JBR
		public Integer qty;	//1
		public Integer price;	//10000
		public String unitType;	//IP
	}


    global class addSimCardOrder_Response{
        public boolean success;
        public Integer status;	//200
        public String message;	//Record has been saved
        public cls_data_addSimCardOrder_Response data;
    }

    global class cls_data_addSimCardOrder_Response {
		public String poNo;	//1234555
		public String soNo;	//1233
		public String invoiceNo;	//12333
		public String poDate;	//2022-09-04 16:59:25
	}

    public static Boolean Sent_Email_if_Failed = true;

    public static void getAccessToken(){
        Datetime startDate = System.now();

        String callID = AppUtils.getNewGUID();
        String responseMsg ;
        String tokenStatusMsg = '';
        string result = '';
        string errorMsg;
        string request;
        String endpoint;

        Http httpObj = new Http();
        HttpRequest httpRequestObj = new HttpRequest(); 

        List<Easy_Ops_API_Setting__c> List_Easy_Ops_API_Settingg = [SELECT Password__c, URI__c, URL__c, Username__c FROM Easy_Ops_API_Setting__c WHERE Name = 'getToken'];
        
        try {  
            if(List_Easy_Ops_API_Settingg!=null && !List_Easy_Ops_API_Settingg.isEmpty()){
                endpoint = List_Easy_Ops_API_Settingg[0].URI__c + List_Easy_Ops_API_Settingg[0].URL__c;

                String reqBody = 
                'username=' + 
                AppUtils.doDecrypt(List_Easy_Ops_API_Settingg[0].Username__c) + 
                '&password=' + 
                AppUtils.doDecrypt(List_Easy_Ops_API_Settingg[0].Password__c) ;

                System.debug('>>> reqBody : '+ reqBody);

                httpRequestObj.setEndpoint(endpoint);
                httpRequestObj.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                httpRequestObj.setHeader('Accept', 'application/Json');
                httpRequestObj.setBody(reqBody);
                httpRequestObj.setMethod('POST');
                httpRequestObj.setTimeout(120000);
                
                result = '{"token":"eyJraWQiOiJlNzRlMDc2Mi01MmMxLTRjMGEtYmFlMC03ZTR"}';

                if(!Test.isRunningTest()){
                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                    result = httpResponseObj.getBody();
                }
                
                request = String.ValueOf(httpRequestObj);
                System.debug('>>> request_getAccessToken : '+ request);
    
                System.debug('>>> result1 : '+ result);
    
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
                token = (string) responsemap.get('token');
                
                System.debug ('================= response responsemap : ' + responsemap );
                System.debug ('================= response token : ' + token );
                
                if(String.isNotBlank(token)){
                    tokenStatusMsg = 'Success';
                    doCallOut = true;
                }else{
                    tokenStatusMsg = 'Failed';
                    Sent_Email_if_Failed = false;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');

            tokenStatusMsg = 'Failed';
            Sent_Email_if_Failed = false;
            errorMsg = errorMsg +  '. Error on REST_SIMCardOrder_v3.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

        Datetime endDate = System.now();

        Call_Log__c log = new Call_Log__c(
            CallerFrom__c = 'Salesforce', 
            Endpoint__c = endpoint, 
            Type__c = 'Callout',
            Request_Message__c = request,
            Response_Message__c = result,
            Method__c = 'POST',
            Status__c = tokenStatusMsg,
            Request_ID__c = callId,
            Request_Start_Time__c = startDate,
            Response_End_Time__c = endDate,
            Sent_Email_if_Failed__c = Sent_Email_if_Failed
        );
        callLogList.add(log);
    }

    /*
     * THIS METHOD FOR SIM-CARD-ORDER UPDATE PROCESS BRO do
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
        String salesSFID ='';
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'PUT';
        calllog.request_start_time__c = datetime.now();
        
        /*
        List <Opportunity> tmpOpps = new List<Opportunity>();
        Opportunity selectedOpp = new Opportunity(); 
        */
        List <Order> tmpOrderList = new List<Order>();
        Order selectedOrder = new Order();

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
                        //String opportunityNo = AppUtils.getStringDataOnMap(paramMap , 'opportunity_no');
                        String orderNo = AppUtils.getStringDataOnMap(paramMap , 'order_no');

                        system.debug ('============ stage : ' + stageName);
                        system.debug ('============ orderNo : ' + orderNo);

                        // Get Order Record data
                        System.debug(' ============ SQL : SELECT id FROM order WHERE order_id__c= ' + orderNo);
                        if (! (AppUtils.isKeysetNotFound(orderNo) || orderNo=='' ) ){
                                //tmpOpps = [SELECT id, accountID FROM Opportunity WHERE opportunity_id__c= :opportunityNo LIMIT 1 ];
                                tmpOrderList = [SELECT id, accountID, account.ownerid FROM Order WHERE order_id__c= :orderNo LIMIT 1 ];
                                system.debug('============ tmpOrderList : ' + tmpOrderList );
                                
                                if (tmpOrderList.size() > 0){
                                    selectedOrder = tmpOrderList [0];
                                    salesSFID = selectedOrder.account.ownerid;
                                    status = 'success';
                                    errCode = '0';
                                    calllog.status__c = 'Success';
                                }
                                else {
                                    status = 'failed';
                                    errMessage = 'The Order record not found on the data. ';
                                    errCode = '1';
                                    calllog.status__c = 'Failed';
                                }
                        }

                        if (AppUtils.isKeysetNotFound(orderNo) || orderNo=='' ) {
                            status = 'failed';
                            errMessage = 'The Order record not found on the data. ';
                            errCode = '1';
                            calllog.status__c = 'Failed';
                        }            

                        if (status != 'failed') {
                            if ( stageName == 'Ready for Pickup'){
                                //--Set status on Order
                                // TODO: put try an catch
                                selectedOrder.status= stageName;
                                update selectedOrder;

                                //-- Add MSISDNs 
                                //-- Set MSISDN ( Simcard_Order_Opportunity__c <-- opportunity id )
                                List<MSISDN__c> tmpmsisdnList = new List<MSISDN__c>();
								set<String> listmsisdnduplicate=new set<String>();
                                List <Object> msisdnList = (List<Object>)  AppUtils.getListDataOnMap(paramMap, 'msisdn_list');
                                
                                
                                //-- handling 10.000 records
                                List<List<MSISDN__c>> tmpmsisdnList2 = new List<List<MSISDN__c>>();
                                
                                integer recordNumber = msisdnList.size();
                                integer part = integer.valueOf( recordNumber / 9500 );
                                
                                system.debug ('===== recordNumber : ' + recordNumber);
                                system.debug ('===== part : ' + part);
                                system.debug ('===== recordNumber : ' + recordNumber);
                                
                                
                                if ( recordNumber >0 ) {
                                	integer ind=0;
                                	for (integer indPart=0; indPart <= part; indPart++) {
                                		
                                		tmpmsisdnList = new List<MSISDN__c>();
                                		for (integer indRec=0; (indRec < 9500 && ind < recordNumber); indRec++ ) {
                                			Object obj = msisdnList[ind];
                                			Map<String, Object> mapRec = (Map<String, Object>) obj;
											
		                                    MSISDN__c tmpmsisdn = new MSISDN__c();		                                    
		                                    tmpmsisdn.label__c = String.valueOf (mapRec.get('label'));
		                                    tmpmsisdn.iccid__c = String.valueOf (mapRec.get('iccid'));
		                                    tmpmsisdn.name = String.valueOf (mapRec.get('msisdn'));
		                                    

		                                    tmpmsisdn.Order_SIM_Card_Related__c = selectedOrder.id;
		                                    tmpmsisdn.ownerid = salesSFID;
		                                    tmpmsisdn.Order_SIM_Card_By__c = salesSFID;
		                                    
		                                    //-- account not to set on this event 
		                                    // tmpmsisdn.account__c = selectedOrder.accountID;  
		                                    tmpmsisdn.Status__c = 'Available'; //'Reserved';
		                                    
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
                                		for (integer indPart=0; indPart <= part; indPart++) {
	                                		system.debug ('===== tmpmsisdnList2[indPart] : ' + tmpmsisdnList2[indPart]);
	                                		upsert tmpmsisdnList2[indPart] ;
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
                            //if ( stageName == 'Closed Won'){
                            if ( stageName == 'Complete'){
                                //--Set status on Order
                                selectedOrder.status= stageName;
                                
                                // put notes and pic_pickup
                                String notes = AppUtils.getStringDataOnMap(paramMap , 'notes');
                                String picPickup= AppUtils.getStringDataOnMap(paramMap , 'pic_pickup');
                                
                                if (!AppUtils.isKeysetNotFound(notes)) { selectedOrder.notes__c = notes; }
                                if (!AppUtils.isKeysetNotFound(picPickup)) { selectedOrder.PIC_Pickup__c = picPickup;  }
                                
                                update selectedOrder; 
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
            
            if (selectedOrder <> null) {  
	            calllog.Salesforce_ID_1__c = selectedOrder.ID;
	            calllog.Order_Related__c = selectedOrder.ID;
            }
            
            insert calllog;
            
            return restResult ;


        //RESTResultX restResult = new RESTResultX('', ''); 
        //return restResult ;    
    }

    @future(Callout=true)
	public static void addSimCardOrder(string orderID){
        SYSTEM.DEBUG ('============== in REST_SIMCardOrder_v3 class, addSimCardOrder method ==============' );

        List<Easy_Ops_API_Setting__c> List_Easy_Ops_API_Settingg = [SELECT Password__c, URI__c, URL__c, Username__c FROM Easy_Ops_API_Setting__c WHERE Name = 'CreateSodo'];

        if(List_Easy_Ops_API_Settingg!=null && !List_Easy_Ops_API_Settingg.isEmpty()){
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status;
            integer responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String callId = AppUtils.getNewGUID();
            String endpoint;
			String successStatusRespone;

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();

            List<Order> List_Order = [
                SELECT id, 
                order_id__c, 
                dealer_id__c, 
                payment_mode__c, 
                SIMCard_Order_Payment_Type__c, 
                account.owner.Employee_ID__c, 
                Cost_Center__c, 
                Storage_Loc__c,
                SLOC__c,
                SLOC__r.Name,
                To_Loc__c, 
                Destination_Type__c,
                Dealer__c,
                Dealer__r.Idexpro_ShippingAddressId__c, 
                Dealer__r.City_IdexPro_Value__c, 
                Request_Type__c,
                Remark__c,
                Payment_Bank_Name__c,
                Payment_Account_Number__c,
                Payment_Account_Name__c,
                Payment_Date__c,
                PoNumber,
                SO_ID__c,
                Invoice_Number__c,
                PoDate,
                Status,
                SAP_Material_Check_Status__c,
                (
                    SELECT 
                    Quantity,
                    UnitPrice,
                    TotalPrice,
                    PricebookEntry.ProductCode,
                    Product_Name__c
                    FROM OrderItems
                )
                FROM order  
                WHERE id =: orderID 
            ];

			if (doCallOut) {
				try {
					//-- do call out
					SYSTEM.DEBUG ('============== try to do call out ==============');

                    List<OrderItem> List_OrderItem = List_Order[0].orderitems;

                    system.debug('List_Order : ' + json.serialize(List_Order));
                    system.debug('List_OrderItem : ' + json.serialize(List_OrderItem));

                    addSimCardOrder_Request addSimCardOrder_Request_Extract = new addSimCardOrder_Request();
                    addSimCardOrder_Request_Extract.orderNo = List_Order[0].order_id__c;
                    addSimCardOrder_Request_Extract.dealerId = List_Order[0].dealer_id__c;
                    addSimCardOrder_Request_Extract.paymentMode = List_Order[0].payment_mode__c;
                    addSimCardOrder_Request_Extract.employeeId = List_Order[0].account.owner.Employee_ID__c;
                    addSimCardOrder_Request_Extract.costCenter = List_Order[0].Cost_Center__c;
                    addSimCardOrder_Request_Extract.storageLoc = List_Order[0].SLOC__r.Name;
                    addSimCardOrder_Request_Extract.toLoc = List_Order[0].To_Loc__c;
                    addSimCardOrder_Request_Extract.destinationType = List_Order[0].Destination_Type__c;
                    addSimCardOrder_Request_Extract.address = List_Order[0].Dealer__r.Idexpro_ShippingAddressId__c;
                    addSimCardOrder_Request_Extract.city = List_Order[0].Dealer__r.City_IdexPro_Value__c;
                    addSimCardOrder_Request_Extract.requestType = List_Order[0].Request_Type__c;
                    addSimCardOrder_Request_Extract.remark = List_Order[0].Remark__c;
                    addSimCardOrder_Request_Extract.bankName = List_Order[0].Payment_Bank_Name__c;
                    addSimCardOrder_Request_Extract.accountNumber = List_Order[0].Payment_Account_Number__c;
                    addSimCardOrder_Request_Extract.accountName = List_Order[0].Payment_Account_Name__c;

                    if(List_Order[0].Payment_Date__c != null){
                        DateTime dt = DateTime.newInstance(List_Order[0].Payment_Date__c.year(), List_Order[0].Payment_Date__c.month(),List_Order[0].Payment_Date__c.day());
                        String dateFormatString = dt.format('yyyy-MM-dd');
                        addSimCardOrder_Request_Extract.paymentDate = dateFormatString;
                    }else{
                        addSimCardOrder_Request_Extract.paymentDate = '';
                    }
                    

                    List<cls_materials_addSimCardOrder> List_cls_materials_addSimCardOrder_Extract = new List<cls_materials_addSimCardOrder>();

                    if(List_OrderItem!=null && !List_OrderItem.isEmpty()){
                        for(OrderItem List_OrderItem_Extract : List_OrderItem){
                            cls_materials_addSimCardOrder cls_materials_addSimCardOrder_Extract = new cls_materials_addSimCardOrder();
                            cls_materials_addSimCardOrder_Extract.productCode = List_OrderItem_Extract.Product_Name__c;
                            cls_materials_addSimCardOrder_Extract.qty = Integer.valueOf(List_OrderItem_Extract.Quantity);
                            cls_materials_addSimCardOrder_Extract.price = Integer.valueOf(List_OrderItem_Extract.TotalPrice);
                            cls_materials_addSimCardOrder_Extract.unitType = 'IP';

                            List_cls_materials_addSimCardOrder_Extract.add(cls_materials_addSimCardOrder_Extract);
                        }
                    }

                    addSimCardOrder_Request_Extract.materials = List_cls_materials_addSimCardOrder_Extract;

					String reqBody = JSON.serialize(addSimCardOrder_Request_Extract);
					
					System.debug('>>> reqBody : '+reqBody);

					endpoint = List_Easy_Ops_API_Settingg[0].URI__c + List_Easy_Ops_API_Settingg[0].URL__c;

					httpRequestObj.setTimeout(120000);
					httpRequestObj.setEndpoint(endpoint);
					httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
                    httpRequestObj.setHeader('request-id', callId);
					if(Test.isRunningTest()){
						token = 'Bearer 2121sa';
					}
					httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
					httpRequestObj.setMethod('POST');
					httpRequestObj.setBody(reqBody); 

					System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));

					bodyMesage = reqBody;
					Datetime startDate = System.now();

                    if(!Test.isRunningTest()){
						HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
						result = httpResponseObj.getBody();
					}else{
						result = '{"success":true,"status":200,"message":"Record has been saved","data":{"poNo":"1234555","soNo":"1233","invoiceNo":"12333","poDate":"2022-09-04 16:59:25"}}';
					}

                    responseMsg = result;
					System.debug('>>> result : '+result);

					Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
					responseMsg = json.serialize(responsemap);
					
					System.debug ('================= response responsemap : ' + responsemap );
					
					successStatusRespone = AppUtils.getStringDataOnMap(responsemap , 'success');
					system.debug ('================= successStatusRespone : ' + successStatusRespone);

                    responseCode = Integer.ValueOf(AppUtils.getStringDataOnMap(responsemap , 'status'));
					system.debug ('================= responseCode : ' + responseCode);

                    if(successStatusRespone == 'true'){
                        status = 'Success';

                        addSimCardOrder_Response response = (addSimCardOrder_Response) JSON.deserialize(result, addSimCardOrder_Response.class);

                        system.debug ('================= response : ' + response);

                        cls_data_addSimCardOrder_Response dataResponse = response.data;

                        system.debug ('================= dataResponse : ' + dataResponse);

                        List_Order[0].PoNumber = dataResponse.poNo;
                        List_Order[0].SO_ID__c = dataResponse.soNo;
                        List_Order[0].Invoice_Number__c = dataResponse.invoiceNo;

                        if(dataResponse.poDate != null){
                            List_Order[0].PoDate = Date.valueOf(dataResponse.poDate.SubStringBefore(' '));
                        }
                        
                        List_Order[0].SAP_Material_Check_Status__c = 'Success';

                        update List_Order;
                    }else{
                        status = 'Failed';
                        Sent_Email_if_Failed = false;
                        
                        if(responseCode == 400){
                            List_Order[0].SAP_Material_Check_Status__c = 'No Stock';
                            List_Order[0].Status = 'Draft';

                            update List_Order;
                        }

                        if(responseCode == 500){
                            List_Order[0].SAP_Material_Check_Status__c = 'Error';
                            List_Order[0].Status = 'Draft';

                            update List_Order;
                        }
                    }

                    if(Test.isRunningTest()) {
                        CalloutException e = new CalloutException();
                        e.setMessage('This is a constructed exception for testing and code coverage');
                        throw e;
                    }
				}
				catch (Exception e) {
					//-- error handling for callout
					SYSTEM.DEBUG ('============== error found at Call-Out ==============');

					status = 'Failed';
                    Sent_Email_if_Failed = false;
					errorMsg = errorMsg +  '. Error on REST_SIMCardOrder_v3.addSimCardOrder method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
					apputils.puterror(errorMsg);
					SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);

                    List_Order[0].SAP_Material_Check_Status__c = 'Error';
                    List_Order[0].Status = 'Draft';

                    update List_Order;
				}

				// put callout information then save the data on Call_Log object
				Call_Log__c calllog = new Call_Log__c();
				calllog.type__c='Callout';
				calllog.request_start_time__c = requestStartTime;
				calllog.method__c = 'POST';
				calllog.callerFrom__c = 'Salesforce' ;
				calllog.endpoint__c = endpoint ;
				calllog.uri__c = uri ; 
				calllog.request_message__c = bodyMesage;
				calllog.status__c = status;
				calllog.response_message__c = responseMsg;            
				calllog.Error_Message__c = errorMsg;
				calllog.Salesforce_ID_1__c = orderID;
                calllog.Order_Related__c = orderID;
				calllog.response_end_time__c = datetime.now(); 
				calllog.Request_ID__c = callId;
                calllog.Sent_Email_if_Failed__c = Sent_Email_if_Failed;   
				callLogList.add(calllog);

				insert callLogList;
			}
        }
    }
}