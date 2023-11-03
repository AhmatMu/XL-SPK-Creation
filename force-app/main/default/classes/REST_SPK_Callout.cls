global with sharing  class REST_SPK_Callout {
    // public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String token;
    public static Boolean doCallOut = false;
   
    public static void getAccessToken() {
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
    
        //ganti ke easyops custom setting
        List<Easy_Ops_API_Setting__c> restGetTokenToEasyOps = [
            SELECT Password__c, URI__c, URL__c, Username__c 
            FROM Easy_Ops_API_Setting__c 
            WHERE Name = 'getToken2'
        ];

        Call_Log__c callLogObj = new Call_Log__c();
    
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
                System.debug('=== request_getAccessToken : '+ request);
    
                result = httpResponseObj.getBody();
                System.debug('=== result1 : '+ result);
    
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
            errorMsg = errorMsg +  '. Error on REST_SPK_Callout.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            System.debug ('===== errorMsg : ' + errorMsg);
        }
    
        Datetime endDate = System.now();
    
        callLogObj.CallerFrom__c           = 'Salesforce';
        callLogObj.Endpoint__c             = endpoint;
        callLogObj.Type__c                 = 'Callout';
        callLogObj.Request_Message__c      = request;
        callLogObj.Response_Message__c     = result;
        callLogObj.Method__c               = 'POST';
        callLogObj.Status__c               = tokenStatusMsg;
        callLogObj.Request_ID__c           = callId;
        callLogObj.Request_Start_Time__c   = startDate;
        callLogObj.Response_End_Time__c    = endDate;
    }

    @future(Callout=true) // by spk id
    public static void requestSPKCreationToEasyopsBySPKId(Set<Id> spkIds){
        SYSTEM.DEBUG ('============== in REST_SPK_Callout class, in requestSPKCreationToEasyopsBySPKId method ==============');
        System.debug('=== spkIds : ' + spkIds);
        // System.debug('=== oldSPkRecords : ' + oldSPkRecords);

        //custom setting
        List<Easy_Ops_API_Setting__c> restCreateOrUpdateSPKToEasyOps = [
            SELECT Password__c, URI__c, URL__c, Username__c 
            FROM Easy_Ops_API_Setting__c 
            WHERE Name = 'createSPK'
        ];

        if(restCreateOrUpdateSPKToEasyOps!=null && !restCreateOrUpdateSPKToEasyOps.isEmpty()){
            getAccessToken();

            List<SPK__c> SPKList = [
                SELECT Id, Name, SPK_Type__c, SPK_Description__c, Account__c, Opportunity__c, Need_PO__c, 
                    Status__c,  Project_Type__c, Project_Coordinator_Email__c, Site__c, BP_HO__c,
                    PQ_Number__c, Service_Type__c, CID__c, Service_Id__c, UOM__c, services__c,
                    Working_Start_Date__c, Working_End_Date__c, SPK_Date__c, 
                    PIC_Name__c, PIC_Contact__c, Capacity_Before__c, Capacity_After__c,
                    PR_Rel__c, PR_Rel__r.Name, PR_Rel__r.Site_A__r.BP_LA_Number__c, PR_Rel__r.Site_B__r.BP_LA_Number__c, 
                    SR_Rel__c, SR_Rel__r.name,
                    Object_Lease_Name__c, Object_Lease_Name__r.Name, Object_Lease_Description__c,
                    Partner_Name__c, Partner_Name__r.Name, Partner_Id__c, Partner_Phone__c, Partner_Email__c, Partner_Address__c,
                    Site_Assignment__c, Site_Assignment__r.BP_Number__c, Site_Assignment__r.BP_LA_Number__c, Site_Assignment__r.Name, BP_Site_Assignment__c, Address_Site_Assignment__c,
                    Other_Site_Assignment__c, Other_Site_Assignment__r.BP_Number__c, Other_Site_Assignment__r.BP_LA_Number__c, Other_Site_Assignment__r.Name, Other_BP_Site_Assignment__c, Other_Address_Site_Assignment__c
                FROM SPK__c 
                WHERE Id IN: spkIds 
                AND Status__c = 'Draft'
            ]; 
            system.debug('=== List SPK : ' + SPKList.size());

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

            List<Object> createSPKList = new List<Object>();
            Map<String, Object> requestBody = new Map<String, Object>();

            // Create the request body
            for (SPK__c spkRec : SPKList) {
                String linkId = spkRec.Service_Id__c;

                SPK_CREATION spkCreationObj = new SPK_CREATION();
                spkCreationObj.sf_spk_id                = spkRec.Id; //a361m0000006oWWAAY
                spkCreationObj.cid                      = null; //spkRec.CID__c; //29-00004 ==============================
                spkCreationObj.pr_number                = spkRec.PR_Rel__r.Name; //PR-2212-005000
                spkCreationObj.link_id                  = (linkId != null) ? linkId : ''; //038C563L5
                spkCreationObj.bp_number                = spkRec.BP_HO__c; //762416
                spkCreationObj.uom                      = spkRec.UOM__c; //Mbps
                spkCreationObj.spk_type                 = spkRec.SPK_Type__c; //Installation
                spkCreationObj.spk_description          = (spkRec.SPK_Description__c != null) ? spkRec.SPK_Description__c : ''; //relokasi ATM
                spkCreationObj.notification_sr          = spkRec.SR_Rel__r.name; //SR-2210-006088
                spkCreationObj.type_of_project          = spkRec.Project_Type__c; //project
                spkCreationObj.start_date               = spkRec.Working_Start_Date__c; //Date.newInstance(06, 02, 2023)
                spkCreationObj.end_date                 = spkRec.Working_End_Date__c; //Date.newInstance(10, 02, 2023)
                spkCreationObj.site                     = spkRec.Site__c; //A or B
                spkCreationObj.pic_cus_name             = spkRec.PIC_Name__c; //Welly
                spkCreationObj.pic_cus_contact          = spkRec.PIC_Contact__c; //08113611111
                spkCreationObj.user_created             = spkRec.Project_Coordinator_Email__c; //shar*****@xl.co.id
                spkCreationObj.capacity                 = spkRec.Capacity_After__c; //10
                spkCreationObj.capacity_before          = (spkRec.Capacity_Before__c != null) ? spkRec.Capacity_Before__c : ''; //-

                if (spkCreationObj.site == 'B'){
                    spkCreationObj.branch_name          = spkRec.Site_Assignment__r.Name; //PT Fiber Networks Indonesia Jakarta Selatan
                    spkCreationObj.location             = spkRec.Address_Site_Assignment__c; //PERUMAHAN SIDOKARE ASRI BLOK AX NO. 14 RT. 021 RW. 006 SEPANDE CANDI
                    spkCreationObj.bp_site_b            = spkRec.Site_Assignment__r.BP_LA_Number__c; //769155
                    spkCreationObj.bp_site_a            = (spkRec.Other_Site_Assignment__r.BP_LA_Number__c != null) ? spkRec.Other_Site_Assignment__r.BP_LA_Number__c : ''; //762562
                } 
                else if(spkCreationObj.site == 'A'){
                    spkCreationObj.branch_name          = spkRec.Site_Assignment__r.Name; //PT Fiber Networks Indonesia Jakarta Selatan
                    spkCreationObj.location             = spkRec.Address_Site_Assignment__c; //PERUMAHAN SIDOKARE ASRI BLOK AX NO. 14 RT. 021 RW. 006 SEPANDE CANDI
                    spkCreationObj.bp_site_a            = spkRec.Site_Assignment__r.BP_LA_Number__c; //762562
                    spkCreationObj.bp_site_b            = (spkRec.Other_Site_Assignment__r.BP_LA_Number__c != null) ? spkRec.Other_Site_Assignment__r.BP_LA_Number__c : ''; //769155
                }

                spkCreationObj.pq_number                = (spkRec.PQ_Number__c != null) ? spkRec.PQ_Number__c : ''; //-
                spkCreationObj.service_type             = spkRec.Service_Type__c; //LL
                spkCreationObj.object_lease_name        = spkRec.Object_Lease_Name__r.Name; //BWA
                spkCreationObj.object_lease_description = (spkRec.Object_Lease_Description__c != null) ? spkRec.Object_Lease_Description__c : ''; //Manage Service test1
                spkCreationObj.partner_id               = String.valueOf(spkRec.Partner_Id__c); //122331
                spkCreationObj.partner_pic              = spkRec.Partner_Name__r.Name; //Agungdjaja Rachman
                spkCreationObj.partner_email            = spkRec.Partner_Email__c; //agung@smartlintas.com; fxdeddys@smartlintas.com;
                spkCreationObj.partner_phone            = spkRec.Partner_Phone__c; //0878-8286-0977;
                spkCreationObj.partner_address          = spkRec.Partner_Address__c; //Cosa Building, 4th Floor, Jl. Tomang Raya No.70, RT.1/RW.3, Jatipulo, Kec. Palmerah, Jakarta, Daerah Khusus Ibukota Jakarta
                createSPKList.add(spkCreationObj);
            }

            requestBody.put('data', createSPKList);
            requestBody.put('request_id', callId);

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   
            Call_Log__c callLogObj = new Call_Log__c();


            if (doCallOut) {
                try {
                    //-- do call out
                    SYSTEM.DEBUG ('============== try to do call out ==============');

                    String reqBody = JSON.serialize(requestBody);
                    System.debug('=== reqBody : ' + reqBody);

                    endpoint = restCreateOrUpdateSPKToEasyOps[0].URI__c + restCreateOrUpdateSPKToEasyOps[0].URL__c;
                    URI = restCreateOrUpdateSPKToEasyOps[0].URI__c;

                    httpRequestObj.setTimeout(120000);
                    httpRequestObj.setEndpoint(endpoint);
                    httpRequestObj.setHeader('Content-Type', 'application/json');
                    httpRequestObj.setHeader('Accept', 'application/json');
                    httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
                    httpRequestObj.setMethod('POST');
                    httpRequestObj.setBody(reqBody); 

                    System.debug('=== httpRequestObj : '+ String.ValueOf(httpRequestObj));

                    bodyMesage = reqBody;
                    Datetime startDate = System.now();
            
                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                    System.debug('=== result : '+result);

                    result = httpResponseObj.getBody();
                    responseMsg = result;

                        Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);

                    if(responsemap.containsKey('status')){
                        System.debug ('================= response responsemap : ' + responsemap );
                        System.debug ('================= response status : ' +  (Integer)responsemap.get('status') );
                    
                        Integer errorCode = (Integer)responsemap.get('status');
                   
                        if(errorCode == 200) {
                            status = 'success';

                            List<SPK__c> newSPKList = new List<SPK__c>();
                            for (SPK__c spkDateRec : SPKList) {
                                spkDateRec.SPK_Date__c  = Date.today(); // stamping date today
                                spkDateRec.status__c    = 'Released';

                                newSPKList.add(spkDateRec);
                            }

                            update newSPKList;
                        } else {
                            status = 'failed';
                            errorMsg = json.serialize(responsemap);

                            List<SPK__c> newSPKList = new List<SPK__c>();
                            for (SPK__c spkStatusRec : SPKList) {
                                spkStatusRec.status__c = 'Draft';

                                newSPKList.add(spkStatusRec);
                            }

                            update newSPKList;
                        }
                    } else {
                        status = 'failed';
                        errorMsg = result;

                        List<SPK__c> newSPKList = new List<SPK__c>();
                        for (SPK__c spkStatusRec : SPKList) {
                            spkStatusRec.status__c = 'Draft';

                            newSPKList.add(spkStatusRec);
                        }

                        update newSPKList;
                    }
                }
                catch (Exception e) {
                    //-- error handling for callout
                    SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                    status = 'Failed';
                    errorMsg = errorMsg +  '. Error on REST_EasyOps_Callout.requestSPKCreationToEasyopsBySPKId method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    SYSTEM.DEBUG ('===== errorMsg : '  + errorMsg);
                }

                callLogObj.type__c                 ='Callout';
                callLogObj.request_start_time__c   = requestStartTime;
                callLogObj.method__c               = 'POST';
                callLogObj.callerFrom__c           = 'Salesforce';
                callLogObj.endpoint__c             = endpoint;
                callLogObj.uri__c                  = URI; 
                callLogObj.request_message__c      = bodyMesage;
                callLogObj.status__c               = status;
                callLogObj.response_message__c     = responseMsg;            
                callLogObj.Error_Message__c        = errorMsg;
                callLogObj.List_SPK_Ids__c         = String.valueOf(spkIds);
                callLogObj.Request_ID__c           = callId;
                callLogObj.response_end_time__c    = datetime.now();
            }
            insert callLogObj; 
        } 
    }

    @future(Callout=true) // by spk id
    public static void requestSPKCancelationBySPKId(Set<Id> spkIds){
        SYSTEM.DEBUG ('============== in REST_EasyOps_Callout class, cancel ticket method ==============' );
        System.debug('===spkIds : ' + spkIds);

        //custom setting
        List<Easy_Ops_API_Setting__c> REST_EasyOps_Callout = [
            SELECT Password__c, URI__c, URL__c, Username__c 
            FROM Easy_Ops_API_Setting__c 
            WHERE Name = 'cancelSPK'
        ];

        if(REST_EasyOps_Callout!=null && !REST_EasyOps_Callout.isEmpty()){
            getAccessToken();

            List<SPK__c> SPKList = [
                SELECT PR_Rel__c, Id, Name, Cancel_Reason__c, Status__c
                FROM SPK__c 
                WHERE Id IN: spkIds
                AND Status__c = 'Sent to Partner'
            ]; 
            system.debug('=== List SPK : ' + SPKList.size());

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

            // Create the request body
            List<Object> spkCancelationList = new List<Object>();
            Map<String, Object> requestBody = new Map<String, Object>();
            
            for (SPK__c spkRec : SPKList) {
                SPK_CANCELATION spkCancelationRec = new SPK_CANCELATION();
                spkCancelationRec.sf_spk_id    = spkRec.id;
                spkCancelationRec.reason       = spkRec.Cancel_Reason__c;
                spkCancelationList.add(spkCancelationRec);
            }

            requestBody.put('data', spkCancelationList);
            requestBody.put('request_id', callId);

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   
            Call_Log__c callLogObj = new Call_Log__c();

            if (doCallOut) {
                try {
                    //-- do call out
                    SYSTEM.DEBUG ('============== try to do call out ==============');

                    String reqBody = JSON.serialize(requestBody);
                    System.debug('=== reqBody : '+reqBody);

                    endpoint = REST_EasyOps_Callout[0].URI__c + REST_EasyOps_Callout[0].URL__c;
                    URI = REST_EasyOps_Callout[0].URI__c;

                    httpRequestObj.setTimeout(120000);
                    httpRequestObj.setEndpoint(endpoint);
                    httpRequestObj.setHeader('Content-Type', 'application/json');
                    httpRequestObj.setHeader('Accept', 'application/json');
                    httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
                    httpRequestObj.setMethod('POST');
                    httpRequestObj.setBody(reqBody); 

                    System.debug('=== httpRequestObj : '+ String.ValueOf(httpRequestObj));

                    bodyMesage = reqBody;
                    Datetime startDate = System.now();
            
                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                    System.debug('=== result : '+result);

                    result = httpResponseObj.getBody();
                    responseMsg = result;

                    Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(httpResponseObj.getBody());

                    if(responsemap.containsKey('status')){
                        System.debug('================= response responsemap : ' + responsemap );
                        System.debug('================= response status : ' +  (Integer)responsemap.get('status') );
                    
                        Integer errorCode = (Integer)responsemap.get('status');
                   
                        if(errorCode == 200) {
                            status = 'success';

                            List<SPK__c> newSPKList = new List<SPK__c>();
                            for (SPK__c spkRec : SPKList) {
                                spkRec.status__c = 'Canceled';

                                newSPKList.add(spkRec);
                            }

                            update newSPKList;
                        } else {
                            status = 'failed';
                            errorMsg = json.serialize(responsemap);
                        }
                    } else {
                        status = 'failed';
                        errorMsg = result;
                    }
                }
                catch (Exception e) {
                    //-- error handling for callout
                    SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                    status = 'Failed';
                    errorMsg = errorMsg +  '. Error on REST_EasyOps_Callout.requestSPKCancelationBySPKId method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    SYSTEM.DEBUG ('===== errorMsg : '  + errorMsg);
                }

                callLogObj.type__c                 ='Callout';
                callLogObj.request_start_time__c   = requestStartTime;
                callLogObj.method__c               = 'POST';
                callLogObj.callerFrom__c           = 'Salesforce';
                callLogObj.endpoint__c             = endpoint;
                callLogObj.uri__c                  = URI; 
                callLogObj.request_message__c      = bodyMesage;
                callLogObj.status__c               = status;
                callLogObj.response_message__c     = responseMsg;            
                callLogObj.Error_Message__c        = errorMsg;
                callLogObj.List_SPK_Ids__c         = String.valueOf(spkIds);
                callLogObj.Request_ID__c           = callId;
                callLogObj.response_end_time__c    = datetime.now();  
            }
            insert callLogObj; 
        } 
    }

    
    global class GET_TOKEN_REQUEST {
        global String username{ get; set; }
        global String password{ get; set; }
    }

    global class GET_TOKEN_RESPONSE {
        global String token{ get; set; }
    }

    global class SPK_CREATION {
        public String sf_spk_id; // a361m0000006s0FAAQ
        public String pr_number; // PR-2212-005000
        public String cid; // 01-03162
        public String link_id; // 012C8922L1
        public String bp_number; // 762416
        public String bp_site_a; // 762562
        public String bp_site_b; // 769155
        public String uom; // Mbps
        public String spk_type; // Installation
        public String spk_description; // relokasi ATM
        public String location; // PERUMAHAN SIDOKARE ASRI BLOK AX NO. 14 RT. 021 RW. 006 SEPANDE CANDI
        public String notification_sr; // SR-2210-006088
        public String type_of_project; // project
        public String site; // "A" / "B"
        public String pic_cus_name; // Welly 
        public String pic_cus_contact; // 08113611111
        public String user_created; // shartanto@xl.co.id 
        public String capacity; // 10
        public String capacity_before; // -
        public String branch_name; // PT Fiber Networks Indonesia Jakarta Selatan
        public String pq_number; // -
        public String service_type; // LL
        public String object_lease_name; // BWA
        public String object_lease_description; // Manage Service test1
        public String partner_pic; // Agungdjaja Rachman
        public String partner_email; // agung@smartlintas.com; fxdeddys@smartlintas.com
        public String partner_phone; // 0878-8286-0977
        public String partner_address; // Cosa Building, 4th Floor, Jl. Tomang Raya No.70, RT.1/RW.3, Jatipulo, Kec. Palmerah, Jakarta, Daerah Khusus Ibukota Jakarta
        public Date start_date; // 2023-02-06
        public Date end_date; // 2023-02-10
        public String partner_id; // 122331
    }

    global class SPK_CANCELATION {
        public String sf_spk_id; // a361m0000006s0FAAQ
        public String reason; // Cancel SPK
    }
}