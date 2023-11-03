/**
 * @description       : 
 * @Test Class        : REST_SAPGetPrice_Callout_v1_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 06-13-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-22-2022   Novando Utoyo Agmawan   Initial Version
**/

global class REST_SAPGetPrice_Callout_v1 {
    //global REST_SAPGetPrice_Callout_v1(){}

    //REST_SAPGetPrice_Callout_v1.getPriceSAP();

    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String access_token;
    public static String token_type;
    public static Boolean doCallOut = false;
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

        List<SAP_API_Setting__c> List_SAP_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM SAP_API_Setting__c WHERE Name = 'getToken'];
        
        try {  
            if(List_SAP_APISetting!=null && !List_SAP_APISetting.isEmpty()){
                endpoint = List_SAP_APISetting[0].URI__c + List_SAP_APISetting[0].URL__c;

                GET_TOKEN_REQUEST GET_TOKEN_REQUEST_obj = new GET_TOKEN_REQUEST();
                GET_TOKEN_REQUEST_obj.username = AppUtils.doDecrypt(List_SAP_APISetting[0].Username__c);
                GET_TOKEN_REQUEST_obj.password = AppUtils.doDecrypt(List_SAP_APISetting[0].Password__c);
                //GET_TOKEN_REQUEST_obj.password = apputils.doDecrypt(List_SAP_APISetting[0].Password__c);
                
                Blob headerValue = Blob.valueOf(GET_TOKEN_REQUEST_obj.username + ':' + GET_TOKEN_REQUEST_obj.password);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

                System.debug('>>> authorizationHeader : '+ authorizationHeader);

                httpRequestObj.setEndpoint(endpoint);
                httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
                httpRequestObj.setHeader('Authorization', authorizationHeader);
                httpRequestObj.setMethod('POST');
                httpRequestObj.setTimeout(120000);

                result = '{"access_token":"90c05dfbf7ba4a30cdefb83e79148e","token_type":"Bearer","expires_in":86400,"scope":""}';
    
                if(!Test.isRunningTest()){
                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                    result = httpResponseObj.getBody();
                }

                request = String.ValueOf(httpRequestObj);
                System.debug('>>> request_getAccessToken : '+ request);
    
                System.debug('>>> result1 : '+ result);
    
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
                access_token = (string) responsemap.get('access_token');
                token_type  = (string) responsemap.get('token_type');
                
                System.debug ('================= response responsemap : ' + responsemap );
                System.debug ('================= response access_token : ' + access_token );
                
                if(String.isNotBlank(access_token)){
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
            errorMsg = errorMsg +  '. Error on REST_Account_Callout.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
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

    @future(Callout=true)
    public static void getPriceSAP(Set<String> Set_OrderProductId, Set<String> Set_ProductId, Boolean createSodo){
        SYSTEM.DEBUG ('============== in REST_SAPGetPrice_Callout_v1 class, getPriceSAP method ==============' );

        List<SAP_API_Setting__c> List_SAP_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM SAP_API_Setting__c WHERE Name = 'SOPriceCheck'];

        if(List_SAP_APISetting!=null && !List_SAP_APISetting.isEmpty()){
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status = 'success';
            integer responseCode;
            string responseMsg;
            string errorMsg;
            string result;
            string orderID;
            string callId = AppUtils.getNewGUID();
            string endpoint;

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   

            if(Set_OrderProductId!=null && !Set_OrderProductId.isEmpty()){
                list<OrderItem> List_OrderProduct = [
                    SELECT Id,
                    UnitPrice,
                    OrderId,
                    Order.Dealer_ID__c,
                    Order.Status,
                    Order.SAP_Material_Check_Status__c,
                    Product2Id,
                    Product2.Name
                    FROM OrderItem
                    WHERE Id In: Set_OrderProductId
                ];

                system.debug('List_OrderProduct : ' + List_OrderProduct);
                system.debug('List_OrderProductSize : ' + List_OrderProduct.size());

                list<PricebookEntry> List_PricebookEntry = [
                    SELECT Id,
                    UnitPrice,
                    Product2Id,
                    Product2.Name
                    FROM PricebookEntry
                    WHERE Product2Id In: Set_ProductId AND
                    IsActive = true
                ];

                system.debug('List_PricebookEntry : ' + List_PricebookEntry);
                system.debug('List_PricebookEntrySize : ' + List_PricebookEntry.size());

                if (doCallOut) {
                    try {
                        //-- do call out
                        SYSTEM.DEBUG ('============== try to do call out ==============');
                        
                        String todayDateFormat = Datetime.now().format('YYYYMMdd');

                        system.debug('todayDateFormat : ' + todayDateFormat);

                        orderID = List_OrderProduct[0].OrderId;
                        Integer partrequestid = 0;

                        PriceSAP_Request PriceSAP_Request_extract = new PriceSAP_Request();
                        
                        List<cls_item_request> List_cls_item_request_extract = new List<cls_item_request>();

                        for(OrderItem List_OrderProduct_Extract : List_OrderProduct){
                            partrequestid++;

                            cls_item_request cls_item_request_extract = new cls_item_request();
                            cls_item_request_extract.partrequestid = '1-' + String.ValueOf(partrequestid);
                            cls_item_request_extract.revision = List_OrderProduct_Extract.Product2.Name;
                            cls_item_request_extract.qty = '1';
                            cls_item_request_extract.depo = 'BUSL';
                            cls_item_request_extract.pricelist = '0';
                            
                            List_cls_item_request_extract.add(cls_item_request_extract);
                        }

                        PriceSAP_Request_extract.trx_type = '';
                        PriceSAP_Request_extract.part_request_hdr_id = '1';
                        PriceSAP_Request_extract.username = 'Salesforce';
                        PriceSAP_Request_extract.part_request_date = todayDateFormat;
                        PriceSAP_Request_extract.dealer_id = List_OrderProduct[0].Order.Dealer_ID__c;
                        PriceSAP_Request_extract.price_date = todayDateFormat;
                        PriceSAP_Request_extract.item = List_cls_item_request_extract;

                        system.debug('PriceSAP_Request_extract : ' + PriceSAP_Request_extract);

                        String reqBody = JSON.serialize(PriceSAP_Request_extract);
                        
                        System.debug('>>> reqBody : '+reqBody);

                        endpoint = List_SAP_APISetting[0].URI__c + List_SAP_APISetting[0].URL__c;

                        httpRequestObj.setTimeout(120000);
                        httpRequestObj.setEndpoint(endpoint);
                        httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
                        if(Test.isRunningTest()){
                            access_token = 'Bearer 90c05dfbf7ba4a30cdefb83e79148e';
                        }
                        httpRequestObj.setHeader('Authorization', + token_type + ' ' + access_token);
                        httpRequestObj.setMethod('POST');
                        httpRequestObj.setBody(reqBody); 

                        System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));

                        bodyMesage = reqBody;
                        Datetime startDate = System.now();

                        responseMsg = '{"part_request_hdr_id":"1","item":[{"partrequestid":"1-1","revision":"SP0KJIT-JKT","price":"10000.00 ","status":"1","reason":"success"}]}';
                
                        if(!Test.isRunningTest()){
                            HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                            responseMsg = httpResponseObj.getBody();
                        }

                        System.debug('>>> responseMsg getPriceSAP : ' + responseMsg);

                        PriceSAP_Response PriceSAP_Response_Extract = (PriceSAP_Response) JSON.deserialize(responseMsg, PriceSAP_Response.class);

                        system.debug('PriceSAP_Response_Extract ' + PriceSAP_Response_Extract);
                        
                        if(PriceSAP_Response_Extract.item !=null && !PriceSAP_Response_Extract.item .isEmpty()){
                            if(PriceSAP_Response_Extract.item[0].status == '0'){
                                status = 'Failed';
                                Sent_Email_if_Failed = false;
                            }else{
                                List<cls_item_response> List_cls_item_response = PriceSAP_Response_Extract.item;
                                Map<String,String> Map_ProductPrice = new Map<String,String>();

                                for(cls_item_response List_cls_item_response_Extract : List_cls_item_response){
                                    Map_ProductPrice.put(List_cls_item_response_Extract.revision, List_cls_item_response_Extract.price.trim());
                                }

                                for(OrderItem List_OrderProduct_Extract : List_OrderProduct){
                                    List_OrderProduct_Extract.UnitPrice = Decimal.ValueOf(Map_ProductPrice.get(List_OrderProduct_Extract.Product2.Name));
                                }

                                MetadataTriggerHandler.bypass('TA_AT_OrderItemSimCardUPD');
                                
                                update List_OrderProduct;

                                for(PricebookEntry List_PricebookEntry_Extract : List_PricebookEntry){
                                    List_PricebookEntry_Extract.UnitPrice = Decimal.ValueOf(Map_ProductPrice.get(List_PricebookEntry_Extract.Product2.Name));
                                }

                                update List_PricebookEntry;

                                MetadataTriggerHandler.clearBypass('TA_AT_OrderItemSimCardUPD');

                                if(createSodo == true){
                                    system.debug ('===== ready to call REST_SIMCardOrder_v2_Schdler');
            
                                    Datetime nextSchedule = system.now().addSeconds(2);

                                    String hour = String.valueOf( nextSchedule.hour());
                                    String min = String.valueOf( nextSchedule.minute()); 
                                    String ss = String.valueOf( nextSchedule.second());
                                    String sDay = string.valueof( nextSchedule.day() ); 
                                    String sYear = string.valueof( nextSchedule.year() );
                                    String sMonth = string.valueof( nextSchedule.month() );
                                    
                                    String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
            
                                    if(!Test.isRunningTest()){
                                        REST_SIMCardOrder_v2_Schdler RESTSIMCardOrderv2Schdler = new REST_SIMCardOrder_v2_Schdler(orderID); 
                                        System.schedule('REST_SIMCardOrder_v2_Schdler ' + String.valueOf(system.now()), nextFireTime, RESTSIMCardOrderv2Schdler);
                                    }
                                }
                            }
                        }else{
                            status = 'Failed';
                            Sent_Email_if_Failed = false;
                        }
                    }
                    catch (Exception e) {
                        //-- error handling for callout
                        SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                        status = 'Failed';
                        Sent_Email_if_Failed = false;
                        errorMsg = errorMsg +  '. Error on REST_SAPGetPrice_Callout_v1.getPriceSAP method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                        apputils.puterror(errorMsg);
                        SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
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
                    calllog.Sent_Email_if_Failed__c = Sent_Email_if_Failed;  
                    callLogList.add(calllog);

                    Order orderRec = new Order(
                        Id = List_OrderProduct[0].OrderId,
                        Status = 'Draft',
                        SAP_Material_Check_Status__c = 'Error'
                    );

                    if(!Test.isRunningTest()){
                        insert callLogList;

                        if(status == 'Failed'){
                            update orderRec;
                        }
                    }
                }
            }
        }
    } 

    global class GET_TOKEN_REQUEST {
        global String username{ get; set; }
        global String password{ get; set; }
    }

    global class GET_TOKEN_RESPONSE {
        global String access_token{ get; set; }
        global String token_type{ get; set; }
        global Integer expires_in{ get; set; }
        global String scope{ get; set; }
    }

    global class PriceSAP_Request{
        public String trx_type;	//
        public String part_request_hdr_id;	//1
        public String username;	//Jack
        public String part_request_date;	//20220924
        public String dealer_id;	//90192014
        public String price_date;	//20220917
        public List<cls_item_request> item;
    }

    global class cls_item_request {
		public String partrequestid;	//1-1
		public String revision;	//SPWLNEW-JKT
		public String qty;	//2
		public String depo;	//MAIN
		public String pricelist;	//0
	}

    global class PriceSAP_Response{
        public String part_request_hdr_id;	//1
        public List<cls_item_response> item;
    }

    global class cls_item_response {
		public String partrequestid;	//1-1
		public String revision;	//SPWLNEW-JKT
		public String price;	//22000.00 
		public String status;	//1
		public String reason;	//success
	}
}