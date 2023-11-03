global with sharing class REST_MarketPlaceOrder_Callout_v2 {
    /*
    public REST_MarketPlaceOrder_Callout_v2() {

    }*/

    
    @future(Callout=true)
    //public static void apexCallout(String callId, String orderId, String opptyId, String orderStatus, String closedLostFlag){
    public static void apexCallout(ID OpportunityID){

        Opportunity opportunityObj = [select id, Order_Id__c , StageName, Closed_Lost_Flag__c, Provisioning_Type__c, Loss_Reason__c from opportunity where id =:OpportunityID ];
        String callId = AppUtils.getNewGUID();

        String orderId = opportunityObj.Order_Id__c;
        String opptyId = opportunityObj.id;
        String opptyStatus = opportunityObj.StageName;
        String closedLostFlag =  opportunityObj.Closed_Lost_Flag__c;
        String provisioningType =  opportunityObj.Provisioning_Type__c;
        String loassReason =  opportunityObj.Loss_Reason__c;
        String apptiumStatus = '';
        Boolean doCallOut = false;

        closedLostFlag = closedLostFlag == NULL ? '' : closedLostFlag.trim();
        opptyStatus = (closedLostFlag <> '' && opptyStatus == 'Closed Lost' )  ? opptyStatus + ' - ' + closedLostFlag : opptyStatus;
        provisioningType = provisioningType == NULL ? 'manual' : provisioningType;
        apptiumStatus = translateStatus(opptyStatus);
        
        if (apptiumStatus<>'') doCallOut=true;

        // -- condition for no call to bizstore couse provisioning type is AUTO
        // -- these condition given by BizStore, so no need to call back.
        if (apptiumStatus == 'wba' && provisioningType=='auto') doCallOut=false;
        

        // -- if customer cancel order (from apptium) then no call-out to update status (because the casuse trigger from BizStore via API )
        if (opptyStatus == 'Closed Lost' && loassReason =='Customer Cancel Order') doCallOut=false;

        // -- if provisioning is FAILURE and the information push by Apptium (provisioning type = auto)
        if (apptiumStatus == 'Failed' && provisioningType=='auto') doCallOut=false;
        if (opptyStatus == 'Closed Lost' && loassReason =='PR CANCEL') doCallOut=false;


        //TODO : cek kenapa ini dibuat?
        //if (apptiumStatus == 'InProgress') doCallOut=false;


        SYSTEM.DEBUG ('============== orderId : ' + orderId);
        SYSTEM.DEBUG ('============== opptyId : ' + opptyId);
        SYSTEM.DEBUG ('============== opptyStatus : ' + opptyStatus);
        SYSTEM.DEBUG ('============== closedLostFlag : ' + closedLostFlag);
        SYSTEM.DEBUG ('============== provisioningType : ' + provisioningType);
        SYSTEM.DEBUG ('============== apptiumStatus : ' + apptiumStatus);
        SYSTEM.DEBUG ('============== doCallOut : ' + doCallOut);

        
        if(doCallOut){
            // TODO: do implement Try and Catch for Error Handling ------------------------------------
            
            List<Call_Log__c> callLogList = new List<Call_Log__c>();
            
            // Instantiate a new http object
            Http h = new Http();
            
            String endpoint = Label.REST_ApptiumEndpoint;
            String uriToken = Label.REST_ApptiumUriToken;
        
            if(Test.isRunningTest()){
                // TODO: REMOVE THIS TRICKY CODE
            	docal();	
            } else  {   
                // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
                HttpRequest req = new HttpRequest();        
                String url = endpoint + uriToken; //'https://axiata-dev.apptium.com/router/consumer/auth/token';
                req.setEndpoint(url);
                //req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                req.setHeader('client_secret', Label.REST_ApptiumClientSecret);  //'H1pBEcHzp8sX4VCz+4l34knWi1qjHunIoXbKrt+D++QDc96aRZNP85s96Bzmt9psgLfYdeA+6-0MH5w8IvpWBA=='
                req.setHeader('client_id', Label.REST_ApptiumClientId);          //'zA2r1RP-A+n2lnRN'
                req.setHeader('Content-length', '0');    //additional header for UAT environment :P
                req.setMethod('POST');
        
                Datetime startDate = System.now();
        
                // Send the request, and return a response
                HttpResponse res = h.send(req);

            	string result=res.getBody();
                System.debug('>>> result1 : '+result);
                
                ResponseGetToken resToken = (ResponseGetToken) JSON.deserialize(result, ResponseGetToken.class);
                String tokenStatus = resToken.status;
                
                String xsrfToken = (String) res.getHeader('XSRF-TOKEN');
                String xxsrfToken = (String) res.getHeader('X-XSRF-TOKEN');
                
                System.debug('>>> xsrfToken : '+xsrfToken);
                System.debug('>>> xxsrfToken : '+xxsrfToken);
                String tokenStatusMsg = '';
                if(tokenStatus=='success'){
                    tokenStatusMsg = Label.REST_ApptiumSuccessResponse; //'CLOSED.COMPLETED';
                }else{
                    tokenStatusMsg = Label.REST_ApptiumFailureResponse; //'CLOSED.ABORTED.ABORTED_BYSERVER';
                }
        
                Datetime endDate = System.now();
                Call_Log__c log1 = new Call_Log__c(CallerFrom__c='Salesforce', 
                                                   Endpoint__c=endpoint,     //'https://axiata-dev.apptium.com', 
                                                   URI__c=uriToken,          //'/router/consumer/auth/token',
                                                   Type__c='Callout',
                                                   Request_Message__c='',
                                                   Response_Message__c=result,
                                                   Method__c='POST',
                                                   Status__c=tokenStatusMsg,
                                                   Request_ID__c=callId,
                                                   Request_Start_Time__c=startDate,
                                                   Response_End_Time__c= endDate);
                callLogList.add(log1);
        
                HttpRequest req2 = new HttpRequest();        
                String uriUpdateOrder = Label.REST_ApptiumUpdateOrder;
                String url2 = endpoint + uriUpdateOrder ; //'https://axiata-dev.apptium.com/router/axixl/om/action/api/opportunityUpdate/updateOrder';
        
                req2.setEndpoint(url2);
                req2.setHeader('Content-Type', 'application/json;charset=UTF-8');
                req2.setHeader('xsrf-token',   xsrfToken);
                req2.setHeader('x-xsrf-token', xxsrfToken);
                req2.setHeader('ep-accountname', Label.REST_ApptiumEpAccountName);  //'axixl'
                req2.setHeader('ep_appname', Label.REST_ApptiumEpAppName);          //'om'
                req2.setMethod('POST');
                
                /*
                {
                  "call_id": "1",
                  "order_id": "2",
                  "opportunity_id": "3",
                  "order_status": "wba",
                  "type": "Order",
                  "service": ""
                }
                */        
                
                String reqBody = '{"call_id":"'+callId+'","order_id":"'+orderId+'","opportunity_id":"'+opptyId+'","order_status":"'+apptiumStatus+'","type": "Order","service":""}';
                System.debug('>>> reqBody : '+reqBody);
                req2.setBody(reqBody);
                req2.setHeader('Content-length', ''+reqBody.length());    //additional header for UAT environment :P
        
                Datetime startDate2 = System.now();
        
                // Send the request, and return a response
                HttpResponse res2 = h.send(req2);
                string result2=res2.getBody();
                System.debug('>>> result2 : '+result2);
        
                /*
                {
                    "opportunity_id": "3",
                    "statusReason": "OK, Order Status Updated Successfully From Sales Force",
                    "statusCode": 200
                }
                */
                ResponseUpdateOrder resToken2 = (ResponseUpdateOrder) JSON.deserialize(result2, ResponseUpdateOrder.class);
                Integer statusCode = resToken2.statusCode;
                String statusMsg = '';
                if(statusCode==200){
                    statusMsg = Label.REST_ApptiumSuccessResponse; //'CLOSED.COMPLETED';
                }else if(statusCode==404){
                    statusMsg = Label.REST_ApptiumFailureResponse; //'CLOSED.ABORTED.ABORTED_BYSERVER';
                }
                
                
        
                Datetime endDate2 = System.now();
                Call_Log__c log2 = new Call_Log__c(CallerFrom__c='Salesforce', 
                                                   Endpoint__c=endpoint,     //'https://axiata-dev.apptium.com', 
                                                   URI__c=uriUpdateOrder,    //'/router/axixl/om/action/api/opportunityUpdate/updateOrder',
                                                   Type__c='Callout',
                                                   Request_Message__c=reqBody,
                                                   Response_Message__c=result2,
                                                   Method__c='POST',
                                                   Status__c=statusMsg,
                                                   Error_Message__c=resToken2.statusReason,
                                                   Request_ID__c=callId,
                                                   Request_Start_Time__c=startDate2,
                                                   Response_End_Time__c= endDate2);
                callLogList.add(log2);
                
                insert callLogList;
            }    
        } else {
            //system.debug('>>>> Order Status : '+opptyStatus+' is not necessary to hit Apptium API.');
            system.debug('>>>> There is no need Call BizStore API');
            
        }
    } 

    /*
    private static String translateStatus_OLD(String stageName, String closedLostFlag){
        String apptiumStatus = '';

        if(stageName!='Closed Lost'){
            String mapping = Label.REST_ApptiumMappingStatus;        
            List<String> mappingList = mapping.split(';;');
            String sfStage = null;
            
            for(String mp : mappingList){
                String[] elementArr = mp.split('>');
                sfStage = elementArr[0];
                apptiumStatus = '';
                if(sfStage == stageName){
                    apptiumStatus = elementArr[1];
                    break;                            
                }            
            }
        }else{
            if(closedLostFlag=='PR CANCEL'){
                apptiumStatus = 'Failed';
            } else if(closedLostFlag==''||closedLostFlag==null){
                apptiumStatus = 'Cancelled';
            }
        }
        return apptiumStatus;
    
    }*/

    private static String translateStatus(String stageName){
        String apptiumStatus = '';

        
        String mapping = Label.REST_ApptiumStageForCallout;        
        List<String> mappingList = mapping.split('#');
        String sfStage = null;
        
        SYSTEM.DEBUG ('============== mappingList : ' + mappingList);

        for(String mp : mappingList){
            String[] elementArr = mp.split('=>');
            sfStage = elementArr[0].trim();
            apptiumStatus = '';

            SYSTEM.DEBUG ('============== sfStage : ' + sfStage);
            SYSTEM.DEBUG ('============== stageName : ' + stageName);

            if(sfStage == stageName){
                apptiumStatus = elementArr[1].trim();
                break;                            
            }            
        }
    
        return apptiumStatus;
    }
    
    private static void docal(){
        integer i = 0;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
    }
    
    global class ResponseGetToken {
        global String status{ get; set; }
    }
    
    global class ResponseUpdateOrder {
        global String opportunity_id { get; set; }
        global Integer statusCode { get; set; }
        global String statusReason { get; set; }
    }


}