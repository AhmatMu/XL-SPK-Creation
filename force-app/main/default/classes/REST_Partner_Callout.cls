global with sharing class REST_Partner_Callout {
    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String token;
    public static Boolean doCallOut = false;

    public static void getAccessToken(){
        Datetime startDate = System.now();
    
        String callID = AppUtils.getNewGUID();
        String responseMsg;
        String tokenStatusMsg = '';
        String result = '';
        String errorMsg;
        String request;
        String endpoint;
    
        Http httpObj = new Http();
        HttpRequest httpRequestObj = new HttpRequest(); 
    
        List<Easy_Ops_API_Setting__c> restGetTokenToEasyOps = [
            SELECT Password__c, URI__c, URL__c, Username__c 
            FROM Easy_Ops_API_Setting__c
            WHERE Name = 'getToken2'
        ];
    
        try {  
            if (restGetTokenToEasyOps != null && !restGetTokenToEasyOps.isEmpty()) {
                endpoint = restGetTokenToEasyOps[0].URI__c + restGetTokenToEasyOps[0].URL__c;
    
                httpRequestObj.setEndpoint(endpoint);
                httpRequestObj.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                httpRequestObj.setMethod('POST');
                httpRequestObj.setTimeout(120000);
    
                // Construct the form data
                String formData = 'password=' + EncodingUtil.urlEncode(restGetTokenToEasyOps[0].Password__c, 'UTF-8') +
                    '&username=' + EncodingUtil.urlEncode(restGetTokenToEasyOps[0].Username__c, 'UTF-8');
    
                httpRequestObj.setBody(formData);
    
                HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
    
                request = String.ValueOf(httpRequestObj);
                System.debug('>>> request_getAccessToken : '+ request);
    
                result = httpResponseObj.getBody();
                System.debug('>>> result1 : '+ result);
    
                if (httpResponseObj.getStatusCode() == 200) {
                    Map<String, Object> responsemap = (Map<String, Object>) JSON.deserializeUntyped(httpResponseObj.getBody());
                    token = (String) responsemap.get('token');
                    tokenStatusMsg = 'Success';
                    doCallOut = true;
                    System.debug ('================= response responsemap : ' + responsemap );
                    System.debug ('================= response token : ' + token );
                } else {
                    tokenStatusMsg = 'Failed';
                }
            }
        } catch (Exception e) {
            //-- error handling for callout
            System.debug ('============== error found at Call-Out ==============');
    
            tokenStatusMsg = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Partner_Callout.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            System.debug ('===== errorMsg : ' + errorMsg);
        }
    
        Datetime endDate = System.now();
    
        Call_Log__c log = new Call_Log__c();
        log.CallerFrom__c           = 'Salesforce'; 
        log.Endpoint__c             = endpoint; 
        log.Type__c                 = 'Callout';
        log.Request_Message__c      = request;
        log.Response_Message__c     = result;
        log.Method__c               = 'POST';
        log.Status__c               = tokenStatusMsg;
        log.Request_ID__c           = callId;
        log.Request_Start_Time__c   = startDate;
        log.Response_End_Time__c    = endDate;
        callLogList.add(log);
    }

    @future(Callout=true)
    public static void requestVendorCreationToEasyOpsByVendorId(Id VendorId){
        System.debug('----In requestVendorCreationToEasyOpsByVendorId----');

        List<Easy_Ops_API_Setting__c> restSyncPartnerCalloutToEasyOps = [
            SELECT Password__c, URI__c, URL__c, Username__c 
            FROM Easy_Ops_API_Setting__c 
            WHERE Name = 'SyncPatner'
        ];

        if (restSyncPartnerCalloutToEasyOps != null && !restSyncPartnerCalloutToEasyOps.isEmpty()) {
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status = 'failed';
            integer responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String callId = AppUtils.getNewGUID();
            String endpoint;

            // Data
            Vendor__c vendorRec = [
                SELECT Id, VendorId__c, Name, Address__c, Phone__c, listemail__c, PIC__c, SPK_to_PMIS__c, is_Active__c
                FROM Vendor__c
                WHERE Id =: VendorId
            ];
            System.debug('=== vendorRec : ' + vendorRec);

            List<Vendor_Object_Lease__c> vendorObjectLeaseList = [ 
                SELECT Id, Name, Object_Lease__c, Object_Lease_Name__c, Object_Lease_Type__c, is_Active__c, Vendor__c, Garansi_SLA__c
                FROM Vendor_Object_Lease__c
                WHERE Vendor__c =: VendorId 
            ];
            System.debug('=== vendorObjectLeaseList : ' + vendorObjectLeaseList);
            System.debug('=== vendorObjectLeaseList.Size : ' + vendorObjectLeaseList.size());

            List<Vendor_SPK_Type__c> vendorSPKTypeList = [
                SELECT Id, Vendor__c, SPK_Type__c, Need_PO__c
                FROM Vendor_SPK_Type__c
                WHERE Vendor__c =: VendorId
            ];
            System.debug('=== vendorSPKTypeList : ' + vendorSPKTypeList);
            System.debug('=== vendorSPKTypeList.Size : ' + vendorSPKTypeList.size());

            // request body
            PARTNER_CREATION createPartnerObj  = new PARTNER_CREATION();
            createPartnerObj.request_id        = callId;
            createPartnerObj.partner_id        = vendorRec.VendorId__c; //'12346';
            createPartnerObj.partner_name      = vendorRec.Name; //'test 1';
            createPartnerObj.partner_email     = vendorRec.listemail__c; //'test1@gmail.com';
            createPartnerObj.partner_address   = vendorRec.Address__c; //'jl. test 2';
            createPartnerObj.partner_pic       = vendorRec.PIC__c; //'test2';
            createPartnerObj.partner_phone     = vendorRec.Phone__c; //'09816825374';
            createPartnerObj.spk_to_pmis       = vendorRec.SPK_to_PMIS__c; //false;
            createPartnerObj.partner_is_active = vendorRec.is_Active__c; //true;


            List<VENDOR_CREATION> vendorCreationList = new List<VENDOR_CREATION>();

            for (Vendor_Object_Lease__c vendorObjectLeaseRec :vendorObjectLeaseList) {
                VENDOR_CREATION createVendorObj = new VENDOR_CREATION();
                createVendorObj.name            = vendorObjectLeaseRec.Object_Lease_Name__c; //'Test2';
                createVendorObj.type            = vendorObjectLeaseRec.Object_Lease_Type__c; //'COGS';
                createVendorObj.garansi_sla     = String.valueOf(vendorObjectLeaseRec.Garansi_SLA__c); //12;
                createVendorObj.is_active       = vendorObjectLeaseRec.is_Active__c; //false;
                vendorCreationList.add(createVendorObj);                
            }
            createPartnerObj.object_lease = vendorCreationList; // {"object_lease": [{"name": "Test2","type": COGS,"garansi_sla": "12","is_active": false}]}
        
            System.debug('=== vendorCreationList : ' + vendorCreationList);
            

            List<SPK_NEED_PO_CREATION> spkNeedPOCreationList = new List<SPK_NEED_PO_CREATION>();

            for (Vendor_SPK_Type__c vendorSPKTypeRec :vendorSPKTypeList) {
                SPK_NEED_PO_CREATION createSPKPOObj = new SPK_NEED_PO_CREATION();
                createSPKPOObj.spk_type    = vendorSPKTypeRec.SPK_Type__c; //'Installation';
                createSPKPOObj.need_po     = vendorSPKTypeRec.Need_PO__c; //false;
                spkNeedPOCreationList.add(createSPKPOObj);                
            }
            createPartnerObj.spk_need_po = spkNeedPOCreationList; // {"spk_need_po":[{"spk_type": Installation,"need_po": false}]}
        
            System.debug('=== spkNeedPOCreationList : ' + spkNeedPOCreationList);
            System.debug('=== createPartnerObj : ' + createPartnerObj);

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();

            if (doCallOut) {
                try {
                    SYSTEM.DEBUG ('============== try to do call out ==============');

                    System.debug('=== token :' + token);

                    String reqBody = JSON.serialize(createPartnerObj);
                    System.debug('=== reqBody : ' + reqBody);

                    // endpoint sync partner
                    endpoint = restSyncPartnerCalloutToEasyOps[0].URI__c + restSyncPartnerCalloutToEasyOps[0].URL__c;
                    System.debug('=== endpoint : ' + endpoint);

                    httpRequestObj.setTimeout(120000);
                    httpRequestObj.setEndpoint(endpoint);
                    httpRequestObj.setHeader('Content-Type', 'application/json');
                    httpRequestObj.setHeader('Accept', 'application/json');
                    httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
                    httpRequestObj.setMethod('POST');
                    httpRequestObj.setBody(reqBody);

                    System.debug('=== httpRequestObj : ' + String.valueOf(httpRequestObj));

                    bodyMesage = reqBody;

                    Datetime startDate = System.now();

                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                    result = httpResponseObj.getBody();
                    responseMsg = result;

                    System.debug('=== result httpResponse : ' + result);

                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(result);
                    Map<String, Object> dataMap = (Map<String, Object>)(responseMap.get('data'));

                    if (responseMap.containsKey('status')) {
                        System.debug('===== response responseMap : ' + responseMap);
                        System.debug('===== response status : ' + (Integer)responseMap.get('status'));

                        Integer errorCode = (Integer)responseMap.get('status');

                        if (errorCode == 200) {
                            status = 'success';
                        } else {
                            status = 'failed';
                            errorMsg = JSON.serialize(responseMap);
                        }
                    } else {
                        status = 'failed';
                        errorMsg = result;
                    }

                } catch (Exception e) {
                    SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                    status = 'Failed';
                    errorMsg = errorMsg + '. Error on REST_Partner_Callout.requestVendorCreationToEasyOpsByVendorId method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' ' + responseMsg + '::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);  
                }

                // put to call_log obj
                Call_Log__c callLog = new Call_Log__c();
                callLog.type__c                 = 'Callout';
                calllog.request_start_time__c   = requestStartTime;
                calllog.method__c               = 'POST';
                calllog.callerFrom__c           = 'Salesforce';
                calllog.endpoint__c             = endpoint;
                calllog.uri__c                  = URI;
                calllog.request_message__c      = bodyMesage;
                calllog.status__c               = status;
                calllog.response_message__c     = responseMsg;
                calllog.Error_Message__c        = errorMsg;
                calllog.Request_ID__c           = callId;
                calllog.response_end_time__c    = Datetime.now();
                callLogList.add(callLog);
            }
            insert callLogList;
        }
    }

    global class GET_TOKEN_REQUEST {
        global String username {get; set;}
        global String password {get; set;}
    }

    global class GET_TOKEN_RESPONSE {
        global String token {get; set;}
    }

    global class PARTNER_CREATION {
        public String request_id; // b51e0126-8d20-6b10-5676-59568d16c885
        public String partner_id; // 10310
        public String partner_name; // PT SISINDOKOM LINTASBUANA
        public String partner_email; // Setiawan1@sisindokom.com; ariyanti2@sisindokom.com
        public String partner_address; // Graha Sisindokom, Jl. Penataran No. 2, Pegangsaan. Jakarta Pusat 1 0320
        public String partner_pic; // Setiawan
        public String partner_phone; // (6221) 31900739
        public Boolean spk_to_pmis; // true / false 
        public Boolean partner_is_active; // true / false 
        public List<VENDOR_CREATION> object_lease;
        public LISt<SPK_NEED_PO_CREATION> spk_need_po;
    }

    global class VENDOR_CREATION {
        public String name; // Converter
        public String type; // COGS
        public String garansi_sla; // 96
        public Boolean is_active; // true / false 
    }

    global class SPK_NEED_PO_CREATION {
        public String spk_type; // Installation
        public Boolean need_po; // true / false
    }
}