global with sharing class REST_Vendor_Callout {
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
            errorMsg = errorMsg +  '. Error on REST_Vendor_Callout.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            System.debug ('===== errorMsg : ' + errorMsg);
        }
    
        Datetime endDate = System.now();
    
        // put to call log obj
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

    @future(Callout=true)
    public static void requestVendorCreationToEasyOpsByVendorId(Id VendorId, String newVendorRec, String oldVendorRec, String newVOLRec, String oldVOLRec, String newSPKTRec, String oldSPKTRec){
        System.debug('----In requestVendorCreationToEasyOpsByVendorId----');

        System.debug('===VendorId : ' + VendorId);

        // new rec
        System.debug('===newVendorRec : ' + newVendorRec);
        System.debug('===newVOLRec : ' + newVOLRec);
        System.debug('===newSPKTRec : ' + newSPKTRec);

        // old rec
        System.debug('===oldVendorRec : ' + oldVendorRec);
        System.debug('===oldVOLRec : ' + oldVOLRec);
        System.debug('===oldSPKTRec : ' + oldSPKTRec);

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
            integer responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String endpoint;
            string status = 'failed';
            String callId = AppUtils.getNewGUID();

            // data vendor
            Vendor__c vendorRec = [
                SELECT Id, VendorId__c, Name, Address__c, Phone__c, listemail__c, PIC__c, SPK_to_PMIS__c, is_Active__c, status__c
                FROM Vendor__c
                WHERE Id =: VendorId
            ];
            System.debug('=== vendorRec : ' + vendorRec);

            // data vendor object lease
            List<Vendor_Object_Lease__c> vendorObjectLeaseList = [ 
                SELECT Id, Name, Object_Lease__c, Object_Lease_Name__c, Object_Lease_Type__c, is_Active__c, Vendor__c, Garansi_SLA__c, VOL_Id__c
                FROM Vendor_Object_Lease__c
                WHERE Vendor__c =: VendorId 
            ];
            System.debug('=== vendorObjectLeaseList : ' + vendorObjectLeaseList);
            System.debug('=== vendorObjectLeaseList.Size : ' + vendorObjectLeaseList.size());

            // set object lease id
            Set<Id> objectLeaseIds = new Set<Id>();
            for (Vendor_Object_Lease__c vendorObjectLeaseRec : vendorObjectLeaseList) {
                objectLeaseIds.add(vendorObjectLeaseRec.Object_Lease__c);
            }

            // data object lease
            List<Object_Lease__c> objectLeaseList = [
                SELECT Id, Name, Object_Lease_Type__c, Object_Lease_Id__c
                FROM Object_Lease__c
                WHERE Id IN: objectLeaseIds
            ];
            System.debug('=== objectLeaseList : ' + objectLeaseList);
            System.debug('=== objectLeaseList.size : ' + objectLeaseList.size());

            // data vendor spk type
            List<Vendor_SPK_Type__c> vendorSPKTypeList = [
                SELECT Id, Vendor__c, SPK_Type__c, Need_PO__c, SPKT_Id__c
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


            List<VENDOR_OBJECT_LEASE_CREATION> vendorObjectLeaseCreationList = new List<VENDOR_OBJECT_LEASE_CREATION>();

            for (Vendor_Object_Lease__c vendorObjectLeaseRec :vendorObjectLeaseList) {
                VENDOR_OBJECT_LEASE_CREATION createVendorObj = new VENDOR_OBJECT_LEASE_CREATION();
                createVendorObj.name            = vendorObjectLeaseRec.Object_Lease_Name__c; //'Test2';
                createVendorObj.type            = vendorObjectLeaseRec.Object_Lease_Type__c; //'COGS';
                createVendorObj.garansi_sla     = String.valueOf(vendorObjectLeaseRec.Garansi_SLA__c); //12;
                createVendorObj.is_active       = vendorObjectLeaseRec.is_Active__c; //false;
                createVendorObj.id              = (vendorObjectLeaseRec.VOL_Id__c != null) ? vendorObjectLeaseRec.VOL_Id__c : ''; // 9ab56877-1c0f-4836-810d-a2d78acb77c8
                vendorObjectLeaseCreationList.add(createVendorObj);                
            }
            createPartnerObj.object_lease = vendorObjectLeaseCreationList; // {"object_lease": [{"name": "Test2","type": COGS,"garansi_sla": "12","is_active": false}]}
        
            System.debug('=== vendorObjectLeaseCreationList : ' + vendorObjectLeaseCreationList);
            

            List<VENDOR_SPK_TYPE_CREATION> vendorSPKTypeCreationList = new List<VENDOR_SPK_TYPE_CREATION>();

            for (Vendor_SPK_Type__c vendorSPKTypeRec :vendorSPKTypeList) {
                VENDOR_SPK_TYPE_CREATION createSPKPOObj = new VENDOR_SPK_TYPE_CREATION();
                createSPKPOObj.spk_type    = vendorSPKTypeRec.SPK_Type__c; //'Installation';
                createSPKPOObj.need_po     = vendorSPKTypeRec.Need_PO__c; //false;
                createSPKPOObj.id          = (vendorSPKTypeRec.SPKT_Id__c != null) ? vendorSPKTypeRec.SPKT_Id__c : ''; // 9ab56877-1c0f-4836-810d-a2d78acb77c8
                vendorSPKTypeCreationList.add(createSPKPOObj);                
            }
            createPartnerObj.spk_need_po = vendorSPKTypeCreationList; // {"spk_need_po":[{"spk_type": Installation,"need_po": false}]}
        
            System.debug('=== vendorSPKTypeCreationList : ' + vendorSPKTypeCreationList);
            System.debug('=== createPartnerObj : ' + createPartnerObj);

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();
            Call_Log__c callLogObj = new Call_Log__c();

            
            if (doCallOut) {
                try {
                    SYSTEM.DEBUG ('============== try to do call out ==============');

                    System.debug('=== token :' + token);

                    String reqBody = JSON.serialize(createPartnerObj);
                    System.debug('=== reqBody : ' + reqBody);

                    // endpoint sync partner
                    endpoint = restSyncPartnerCalloutToEasyOps[0].URI__c + restSyncPartnerCalloutToEasyOps[0].URL__c;
                    URI      = restSyncPartnerCalloutToEasyOps[0].URI__c;
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

                    
                    if (responseMap.containsKey('status')) {
                        System.debug('===== response status : ' + (Integer)responseMap.get('status'));
                        System.debug('=== result responseMap : ' + responseMap);

                        Integer errorCode = (Integer)responseMap.get('status');

                        if (errorCode == 200) {
                            status = 'success';
                            
                            // update vendor
                            vendorRec.status__c     = 'Registered';
                            vendorRec.VendorId__c   = createPartnerObj.partner_id;
                            vendorRec.is_Active__c  = true;

                            update vendorRec;

                            // list of (vendorObjectLease - vendorSPKType - ref object lease)
                            if ((Map<String, Object>)(responseMap.get('data')) != null) {
                                Map<String, Object> dataMap     = (Map<String, Object>)(responseMap.get('data'));
                                System.debug('=== dataMap : ' + dataMap);
        
                                // update vendor object lease
                                if ((List<Object>)dataMap.get('object_lease') != null) {
                                    System.debug('=== in map object_lease ===');
        
                                    List<Object> resObjectLeaseList    = (List<Object>)dataMap.get('object_lease');
                                    String guidObjectLease;
                                    String nameObjectLease;
                                    String typeObjectLease;
                                    String garansiSLAObjectLease;
        
                                    for (Object objectLeaseRec : resObjectLeaseList) {
                                        Map<String, Object> objectLeaseRecMap = (Map<String, Object>)(objectLeaseRec);
        
                                        guidObjectLease          = (String)objectLeaseRecMap.get('guid');
                                        nameObjectLease          = (String)objectLeaseRecMap.get('name');
                                        typeObjectLease          = (String)objectLeaseRecMap.get('type');
                                        garansiSLAObjectLease    = (String)objectLeaseRecMap.get('garansi_sla');
                                    }

                                    if (!resObjectLeaseList.isEmpty()) {
                                        List<Vendor_Object_Lease__c> newVendorObjectLeaseList = new List<Vendor_Object_Lease__c>();
                                        for (Vendor_Object_Lease__c vendorObjectLeaseRec :vendorObjectLeaseList) {
                                            vendorObjectLeaseRec.VOL_Id__c      = (vendorObjectLeaseRec.Object_Lease_Name__c == nameObjectLease && vendorObjectLeaseRec.Object_Lease_Type__c == typeObjectLease && vendorObjectLeaseRec.VOL_Id__c == null) ? guidObjectLease : vendorObjectLeaseRec.VOL_Id__c;
                                            vendorObjectLeaseRec.is_Active__c   = true;
    
                                            System.debug('vendorObjectLeaseRec.VOL_Id__c : ' + vendorObjectLeaseRec.VOL_Id__c);
                                            newVendorObjectLeaseList.add(vendorObjectLeaseRec);
                                        }
                                        update newVendorObjectLeaseList;
                                    }
                                }
        
                                // update vendor spk type
                                if ((List<Object>)dataMap.get('spk_need_po') != null) {
                                    System.debug('=== in map spk_need_po ===');
        
                                    List<Object> resSpkNeedPOList      = (List<Object>)dataMap.get('spk_need_po');
                                    String guidSPKNeedPO;
                                    String spkTypeSPKNeedPO;
                                    String needPOSPKNeedPO;
        
                                    for (Object spkNeedPORec : resSpkNeedPOList) {
                                        Map<String, Object> spkNeedPORecMap = (Map<String, Object>)(spkNeedPORec);
        
                                        guidSPKNeedPO    = (String)spkNeedPORecMap.get('guid');
                                        spkTypeSPKNeedPO = (String)spkNeedPORecMap.get('spk_type');
                                        needPOSPKNeedPO  = (String)spkNeedPORecMap.get('need_po'); // 0=false, 1=true
                                    }

                                    if (!resSpkNeedPOList.isEmpty()) {
                                        List<Vendor_SPK_Type__c> newVendorSPKTypeList = new List<Vendor_SPK_Type__c>();
                                        for (Vendor_SPK_Type__c vendorSPKTypeRec :vendorSPKTypeList) {
                                            Boolean newNeedPOSPKNeedPO = (needPOSPKNeedPO == string.valueOf('1')) ? true : false;
                                            vendorSPKTypeRec.SPKT_Id__c = (vendorSPKTypeRec.SPK_Type__c == spkTypeSPKNeedPO && vendorSPKTypeRec.Need_PO__c == newNeedPOSPKNeedPO && vendorSPKTypeRec.SPKT_Id__c == null) ? guidSPKNeedPO : vendorSPKTypeRec.SPKT_Id__c;
    
                                            newVendorSPKTypeList.add(vendorSPKTypeRec);
                                        }
                                        update newVendorSPKTypeList;
                                    }
                                }
        
                                // update new ref object lease
                                if ((List<Object>)dataMap.get('new_ref_object_lease') != null) {
                                    System.debug('=== in map new_ref_object_lease ===');
        
                                    List<Object> resNewObjectLeaseList = (List<Object>)dataMap.get('new_ref_object_lease');
                                    String guidNewObjectLease;
                                    String nameNewObjectLease;
                                    String typeNewObjectLease;
        
                                    for (Object newObjectLeaseRec : resNewObjectLeaseList) {
                                        Map<String, Object> newObjectLeaseRecMap = (Map<String, Object>)(newObjectLeaseRec);
        
                                        guidNewObjectLease = (String)newObjectLeaseRecMap.get('guid');
                                        nameNewObjectLease = (String)newObjectLeaseRecMap.get('name');
                                        typeNewObjectLease = (String)newObjectLeaseRecMap.get('type');
                                    }

                                    if (!resNewObjectLeaseList.isEmpty()) {
                                        List<Object_Lease__c> newObjectLeaseList = new List<Object_Lease__c>();
                                        for (Object_Lease__c objectLeaseRec : objectLeaseList) {
                                            objectLeaseRec.Object_Lease_Id__c = (objectLeaseRec.Name == nameNewObjectLease && objectLeaseRec.Object_Lease_Type__c == typeNewObjectLease && objectLeaseRec.Object_Lease_Id__c == null) ? guidNewObjectLease : objectLeaseRec.Object_Lease_Id__c;
    
                                            newObjectLeaseList.add(objectLeaseRec);
                                        }
                                        update newObjectLeaseList;
                                    }
                                }
                            }
                        } else {
                            status = 'failed';
                            errorMsg = JSON.serialize(responseMap);

                            // vendor update rollback
                            if (oldVendorRec != null) {
                                System.debug('=== in vendor update rollback ===');

                                Object newVendorRecordObj = JSON.deserializeUntyped(newVendorRec);
                                Object oldVendorRecordObj = JSON.deserializeUntyped(oldVendorRec);
                                System.debug('=== newVendorRecordObj : ' + newVendorRecordObj);
                                System.debug('=== oldVendorRecordObj : ' + oldVendorRecordObj);

                                Map<String, Object> newVendorRecordMap = (Map<String, Object>)newVendorRecordObj;
                                Map<String, Object> oldVendorRecordMap = (Map<String, Object>)oldVendorRecordObj;
                                System.debug('=== newVendorRecordMap : ' + newVendorRecordMap);
                                System.debug('=== oldVendorRecordMap : ' + oldVendorRecordMap);
    
                                Vendor__c vendorRollBack = new Vendor__c();
                                vendorRollBack.Id = (Id)oldVendorRecordMap.get('Id');

                                // name field rollback
                                if ((String)newVendorRecordMap.get('Name') != (String)oldVendorRecordMap.get('Name')) {
                                    System.debug('=== in name field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorRecordMap.get('Name'));
                                    System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('Name'));
                                    
                                    vendorRollBack.Name = (String)oldVendorRecordMap.get('Name');
                                }
                                // vendorid field rollback
                                if ((String)newVendorRecordMap.get('VendorId__c') != (String)oldVendorRecordMap.get('VendorId__c')) {
                                    System.debug('=== in vendorId field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorRecordMap.get('VendorId__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('VendorId__c'));

                                    vendorRollBack.VendorId__c = (String)oldVendorRecordMap.get('VendorId__c');
                                }
                                // pic field rollback
                                if ((String)newVendorRecordMap.get('PIC__c') != (String)oldVendorRecordMap.get('PIC__c')) {
                                    System.debug('=== in pic field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorRecordMap.get('PIC__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('PIC__c'));

                                    vendorRollBack.PIC__c = (String)oldVendorRecordMap.get('PIC__c');
                                }
                                // type field rollback
                                if ((String)newVendorRecordMap.get('Type__c') != (String)oldVendorRecordMap.get('Type__c')) {
                                    System.debug('=== in type field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorRecordMap.get('Type__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('Type__c'));

                                    vendorRollBack.Type__c = (String)oldVendorRecordMap.get('Type__c');
                                }
                                // phone field rollback
                                if ((String)newVendorRecordMap.get('Phone__c') != (String)oldVendorRecordMap.get('Phone__c')) {
                                    System.debug('=== in phone field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorRecordMap.get('Phone__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('Phone__c'));

                                    vendorRollBack.Phone__c = (String)oldVendorRecordMap.get('Phone__c');
                                }
                                // spk to pmis field rollback
                                if ((Boolean)newVendorRecordMap.get('SPK_to_PMIS__c') != (Boolean)oldVendorRecordMap.get('SPK_to_PMIS__c')) {
                                    System.debug('=== in spk to pmis field rollback ===');
                                    System.debug('=== newValue : ' + (Boolean)newVendorRecordMap.get('SPK_to_PMIS__c'));
                                    System.debug('=== oldValue : ' + (Boolean)oldVendorRecordMap.get('SPK_to_PMIS__c'));

                                    vendorRollBack.SPK_to_PMIS__c = (Boolean)oldVendorRecordMap.get('SPK_to_PMIS__c');
                                }
                                // is active field rollback
                                if ((Boolean)newVendorRecordMap.get('is_Active__c') != (Boolean)oldVendorRecordMap.get('is_Active__c')) {
                                    System.debug('=== in is active field rollback ===');
                                    System.debug('=== newValue : ' + (Boolean)newVendorRecordMap.get('is_Active__c'));
                                    System.debug('=== oldValue : ' + (Boolean)oldVendorRecordMap.get('is_Active__c'));

                                    vendorRollBack.is_Active__c = (Boolean)oldVendorRecordMap.get('is_Active__c');
                                }
                                // status field rollback
                                if ((String)newVendorRecordMap.get('status__c') != (String)oldVendorRecordMap.get('status__c')) {
                                    System.debug('=== in status field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorRecordMap.get('status__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('status__c'));

                                    vendorRollBack.status__c = (String)oldVendorRecordMap.get('status__c');
                                }
                                // listemail field rollback
                                if ((String)newVendorRecordMap.get('listemail__c') != (String)oldVendorRecordMap.get('listemail__c')) {
                                    System.debug('=== in listemail field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorRecordMap.get('listemail__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('listemail__c'));

                                    vendorRollBack.listemail__c = (String)oldVendorRecordMap.get('listemail__c');
                                }
                                // address field rollback
                                if ((String)newVendorRecordMap.get('Address__c') != (String)oldVendorRecordMap.get('Address__c')) {
                                    System.debug('=== in address field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorRecordMap.get('Address__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('Address__c'));

                                    vendorRollBack.Address__c = (String)oldVendorRecordMap.get('Address__c');
                                }

                                System.debug('=== vendorRollBack : ' + vendorRollBack);
    
                                MetadataTriggerHandler.bypass('TA_AT_VendorAftUpd_CallToUpdateVendor');
                                update vendorRollBack; 
                                MetadataTriggerHandler.clearBypass('TA_AT_VendorAftUpd_CallToUpdateVendor');
                            }

                            // vendor_object_lease update rollback
                            if (oldVOLRec != null) {
                                System.debug('=== in vendor_object_lease update rollback ===');

                                Object newVendorObjectLeaseRecordObj = JSON.deserializeUntyped(newVOLRec);
                                Object oldVendorObjectLeaseRecordObj = JSON.deserializeUntyped(oldVOLRec);
                                System.debug('=== newVendorObjectLeaseRecordObj : ' + newVendorObjectLeaseRecordObj);
                                System.debug('=== oldVendorObjectLeaseRecordObj : ' + oldVendorObjectLeaseRecordObj);

                                Map<String, Object> newVendorObjectLeaseRecordMap = (Map<String, Object>)newVendorObjectLeaseRecordObj;
                                Map<String, Object> oldVendorObjectLeaseRecordMap = (Map<String, Object>)oldVendorObjectLeaseRecordObj;
                                System.debug('=== newVendorObjectLeaseRecordMap : ' + newVendorObjectLeaseRecordMap);
                                System.debug('=== oldVendorObjectLeaseRecordMap : ' + oldVendorObjectLeaseRecordMap);
    
                                Vendor_Object_Lease__c volRollBack = new Vendor_Object_Lease__c();
                                volRollBack.Id = (Id)oldVendorObjectLeaseRecordMap.get('Id');

                                // object lease field rollback
                                if ((String)newVendorObjectLeaseRecordMap.get('Object_Lease__c') != (String)oldVendorObjectLeaseRecordMap.get('Object_Lease__c')) {
                                    System.debug('=== in object lease field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorObjectLeaseRecordMap.get('Object_Lease__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorObjectLeaseRecordMap.get('Object_Lease__c'));

                                    volRollBack.Object_Lease__c = (String)oldVendorObjectLeaseRecordMap.get('Object_Lease__c');
                                } 
                                // vendor field rollback
                                if ((String)newVendorObjectLeaseRecordMap.get('Vendor__c') != (String)oldVendorObjectLeaseRecordMap.get('Vendor__c')) {
                                    System.debug('=== in vendor field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorObjectLeaseRecordMap.get('Vendor__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorObjectLeaseRecordMap.get('Vendor__c'));

                                    volRollBack.Vendor__c = (String)oldVendorObjectLeaseRecordMap.get('Vendor__c');
                                } 
                                // garansi sla field rollback
                                if ((Decimal)newVendorObjectLeaseRecordMap.get('Garansi_SLA__c') != (Decimal)oldVendorObjectLeaseRecordMap.get('Garansi_SLA__c')) {
                                    System.debug('=== in garansi sla field rollback ===');
                                    System.debug('=== newValue : ' + (Decimal)newVendorObjectLeaseRecordMap.get('Garansi_SLA__c'));
                                    System.debug('=== oldValue : ' + (Decimal)oldVendorObjectLeaseRecordMap.get('Garansi_SLA__c'));

                                    volRollBack.Garansi_SLA__c  = (Decimal)oldVendorObjectLeaseRecordMap.get('Garansi_SLA__c');
                                }
                                // is active field rollback
                                if ((Boolean)newVendorObjectLeaseRecordMap.get('is_Active__c') != (Boolean)oldVendorObjectLeaseRecordMap.get('is_Active__c')) {
                                    System.debug('=== in is active field rollback ===');
                                    System.debug('=== newValue : ' + (Boolean)newVendorObjectLeaseRecordMap.get('is_Active__c'));
                                    System.debug('=== oldValue : ' + (Boolean)oldVendorObjectLeaseRecordMap.get('is_Active__c'));

                                    volRollBack.is_Active__c = (Boolean)oldVendorObjectLeaseRecordMap.get('is_Active__c');
                                }

                                System.debug('===  volRollBack : ' + volRollBack);

                                MetadataTriggerHandler.bypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');
                                update volRollBack;
                                MetadataTriggerHandler.clearBypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');
                            }

                            // vendor_spk_type update rollback
                            if (oldSPKTRec != null) {
                                System.debug('=== in vendor_spk_type update rollback ===');

                                Object newVendorSPKTypeRecordObj = JSON.deserializeUntyped(newSPKTRec);
                                Object oldVendorSPKTypeRecordObj = JSON.deserializeUntyped(oldSPKTRec);
                                System.debug('=== newVendorSPKTypeRecordObj : ' + newVendorSPKTypeRecordObj);
                                System.debug('=== oldVendorSPKTypeRecordObj : ' + oldVendorSPKTypeRecordObj);

                                Map<String, Object> newVendorSPKTypeRecordMap = (Map<String, Object>)newVendorSPKTypeRecordObj;
                                Map<String, Object> oldVendorSPKTypeRecordMap = (Map<String, Object>)oldVendorSPKTypeRecordObj;
                                System.debug('=== newVendorSPKTypeRecordMap : ' + newVendorSPKTypeRecordMap);
                                System.debug('=== oldVendorSPKTypeRecordMap : ' + oldVendorSPKTypeRecordMap);

                                Vendor_SPK_Type__c spktRollBack = new Vendor_SPK_Type__c();
                                spktRollBack.Id = (Id)oldVendorSPKTypeRecordMap.get('Id');

                                // spk type field rollback
                                if ((String)newVendorSPKTypeRecordMap.get('SPK_Type__c') != (String)oldVendorSPKTypeRecordMap.get('SPK_Type__c')) {
                                    System.debug('=== in spk type field rollback ===');
                                    System.debug('=== newValue : ' + (String)newVendorSPKTypeRecordMap.get('SPK_Type__c'));
                                    System.debug('=== oldValue : ' + (String)oldVendorSPKTypeRecordMap.get('SPK_Type__c'));

                                    spktRollBack.SPK_Type__c = (String)oldVendorSPKTypeRecordMap.get('SPK_Type__c');
                                }
                                // need po field rollback
                                if ((Boolean)newVendorSPKTypeRecordMap.get('Need_PO__c') != (Boolean)oldVendorSPKTypeRecordMap.get('Need_PO__c')) {
                                    System.debug('=== in spk type field rollback ===');
                                    System.debug('=== newValue : ' + (Boolean)newVendorSPKTypeRecordMap.get('Need_PO__c'));
                                    System.debug('=== oldValue : ' + (Boolean)oldVendorSPKTypeRecordMap.get('Need_PO__c'));
                                    
                                    spktRollBack.Need_PO__c = (Boolean)oldVendorSPKTypeRecordMap.get('Need_PO__c');
                                }

                                System.debug('=== spktRollBack : ' + spktRollBack);

                                MetadataTriggerHandler.bypass('TA_AT_VendorSPKTypeAftUpd_UpdateVendor');
                                update spktRollBack;
                                MetadataTriggerHandler.clearBypass('TA_AT_VendorSPKTypeAftUpd_UpdateVendor');
                            }
                        }
                    } else {
                        status = 'failed';
                        errorMsg = result;

                        // vendor update rollback
                        if (oldVendorRec != null) {
                            System.debug('=== in vendor update rollback ===');

                            Object newVendorRecordObj = JSON.deserializeUntyped(newVendorRec);
                            Object oldVendorRecordObj = JSON.deserializeUntyped(oldVendorRec);
                            System.debug('=== newVendorRecordObj : ' + newVendorRecordObj);
                            System.debug('=== oldVendorRecordObj : ' + oldVendorRecordObj);

                            Map<String, Object> newVendorRecordMap = (Map<String, Object>)newVendorRecordObj;
                            Map<String, Object> oldVendorRecordMap = (Map<String, Object>)oldVendorRecordObj;
                            System.debug('=== newVendorRecordMap : ' + newVendorRecordMap);
                            System.debug('=== oldVendorRecordMap : ' + oldVendorRecordMap);

                            Vendor__c vendorRollBack = new Vendor__c();
                            vendorRollBack.Id = (Id)oldVendorRecordMap.get('Id');

                            // name field rollback
                            if ((String)newVendorRecordMap.get('Name') != (String)oldVendorRecordMap.get('Name')) {
                                System.debug('=== in name field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorRecordMap.get('Name'));
                                System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('Name'));
                                
                                vendorRollBack.Name = (String)oldVendorRecordMap.get('Name');
                            }
                            // vendorid field rollback
                            if ((String)newVendorRecordMap.get('VendorId__c') != (String)oldVendorRecordMap.get('VendorId__c')) {
                                System.debug('=== in vendorId field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorRecordMap.get('VendorId__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('VendorId__c'));

                                vendorRollBack.VendorId__c = (String)oldVendorRecordMap.get('VendorId__c');
                            }
                            // pic field rollback
                            if ((String)newVendorRecordMap.get('PIC__c') != (String)oldVendorRecordMap.get('PIC__c')) {
                                System.debug('=== in pic field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorRecordMap.get('PIC__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('PIC__c'));

                                vendorRollBack.PIC__c = (String)oldVendorRecordMap.get('PIC__c');
                            }
                            // type field rollback
                            if ((String)newVendorRecordMap.get('Type__c') != (String)oldVendorRecordMap.get('Type__c')) {
                                System.debug('=== in type field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorRecordMap.get('Type__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('Type__c'));

                                vendorRollBack.Type__c = (String)oldVendorRecordMap.get('Type__c');
                            }
                            // phone field rollback
                            if ((String)newVendorRecordMap.get('Phone__c') != (String)oldVendorRecordMap.get('Phone__c')) {
                                System.debug('=== in phone field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorRecordMap.get('Phone__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('Phone__c'));

                                vendorRollBack.Phone__c = (String)oldVendorRecordMap.get('Phone__c');
                            }
                            // spk to pmis field rollback
                            if ((Boolean)newVendorRecordMap.get('SPK_to_PMIS__c') != (Boolean)oldVendorRecordMap.get('SPK_to_PMIS__c')) {
                                System.debug('=== in spk to pmis field rollback ===');
                                System.debug('=== newValue : ' + (Boolean)newVendorRecordMap.get('SPK_to_PMIS__c'));
                                System.debug('=== oldValue : ' + (Boolean)oldVendorRecordMap.get('SPK_to_PMIS__c'));

                                vendorRollBack.SPK_to_PMIS__c = (Boolean)oldVendorRecordMap.get('SPK_to_PMIS__c');
                            }
                            // is active field rollback
                            if ((Boolean)newVendorRecordMap.get('is_Active__c') != (Boolean)oldVendorRecordMap.get('is_Active__c')) {
                                System.debug('=== in is active field rollback ===');
                                System.debug('=== newValue : ' + (Boolean)newVendorRecordMap.get('is_Active__c'));
                                System.debug('=== oldValue : ' + (Boolean)oldVendorRecordMap.get('is_Active__c'));

                                vendorRollBack.is_Active__c = (Boolean)oldVendorRecordMap.get('is_Active__c');
                            }
                            // status field rollback
                            if ((String)newVendorRecordMap.get('status__c') != (String)oldVendorRecordMap.get('status__c')) {
                                System.debug('=== in status field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorRecordMap.get('status__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('status__c'));

                                vendorRollBack.status__c = (String)oldVendorRecordMap.get('status__c');
                            }
                            // listemail field rollback
                            if ((String)newVendorRecordMap.get('listemail__c') != (String)oldVendorRecordMap.get('listemail__c')) {
                                System.debug('=== in listemail field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorRecordMap.get('listemail__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('listemail__c'));

                                vendorRollBack.listemail__c = (String)oldVendorRecordMap.get('listemail__c');
                            }
                            // address field rollback
                            if ((String)newVendorRecordMap.get('Address__c') != (String)oldVendorRecordMap.get('Address__c')) {
                                System.debug('=== in address field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorRecordMap.get('Address__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorRecordMap.get('Address__c'));

                                vendorRollBack.Address__c = (String)oldVendorRecordMap.get('Address__c');
                            }

                            System.debug('=== vendorRollBack : ' + vendorRollBack);

                            MetadataTriggerHandler.bypass('TA_AT_VendorAftUpd_CallToUpdateVendor');
                            update vendorRollBack; 
                            MetadataTriggerHandler.clearBypass('TA_AT_VendorAftUpd_CallToUpdateVendor');
                        }

                        // vendor_object_lease update rollback
                        if (oldVOLRec != null) {
                            System.debug('=== in vendor_object_lease update rollback ===');

                            Object newVendorObjectLeaseRecordObj = JSON.deserializeUntyped(newVOLRec);
                            Object oldVendorObjectLeaseRecordObj = JSON.deserializeUntyped(oldVOLRec);
                            System.debug('=== newVendorObjectLeaseRecordObj : ' + newVendorObjectLeaseRecordObj);
                            System.debug('=== oldVendorObjectLeaseRecordObj : ' + oldVendorObjectLeaseRecordObj);

                            Map<String, Object> newVendorObjectLeaseRecordMap = (Map<String, Object>)newVendorObjectLeaseRecordObj;
                            Map<String, Object> oldVendorObjectLeaseRecordMap = (Map<String, Object>)oldVendorObjectLeaseRecordObj;
                            System.debug('=== newVendorObjectLeaseRecordMap : ' + newVendorObjectLeaseRecordMap);
                            System.debug('=== oldVendorObjectLeaseRecordMap : ' + oldVendorObjectLeaseRecordMap);

                            Vendor_Object_Lease__c volRollBack = new Vendor_Object_Lease__c();
                            volRollBack.Id = (Id)oldVendorObjectLeaseRecordMap.get('Id');

                            // object lease field rollback
                            if ((String)newVendorObjectLeaseRecordMap.get('Object_Lease__c') != (String)oldVendorObjectLeaseRecordMap.get('Object_Lease__c')) {
                                System.debug('=== in object lease field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorObjectLeaseRecordMap.get('Object_Lease__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorObjectLeaseRecordMap.get('Object_Lease__c'));

                                volRollBack.Object_Lease__c = (String)oldVendorObjectLeaseRecordMap.get('Object_Lease__c');
                            } 
                            // vendor field rollback
                            if ((String)newVendorObjectLeaseRecordMap.get('Vendor__c') != (String)oldVendorObjectLeaseRecordMap.get('Vendor__c')) {
                                System.debug('=== in vendor field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorObjectLeaseRecordMap.get('Vendor__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorObjectLeaseRecordMap.get('Vendor__c'));

                                volRollBack.Vendor__c = (String)oldVendorObjectLeaseRecordMap.get('Vendor__c');
                            } 
                            // garansi sla field rollback
                            if ((Decimal)newVendorObjectLeaseRecordMap.get('Garansi_SLA__c') != (Decimal)oldVendorObjectLeaseRecordMap.get('Garansi_SLA__c')) {
                                System.debug('=== in garansi sla field rollback ===');
                                System.debug('=== newValue : ' + (Decimal)newVendorObjectLeaseRecordMap.get('Garansi_SLA__c'));
                                System.debug('=== oldValue : ' + (Decimal)oldVendorObjectLeaseRecordMap.get('Garansi_SLA__c'));

                                volRollBack.Garansi_SLA__c  = (Decimal)oldVendorObjectLeaseRecordMap.get('Garansi_SLA__c');
                            }
                            // is active field rollback
                            if ((Boolean)newVendorObjectLeaseRecordMap.get('is_Active__c') != (Boolean)oldVendorObjectLeaseRecordMap.get('is_Active__c')) {
                                System.debug('=== in is active field rollback ===');
                                System.debug('=== newValue : ' + (Boolean)newVendorObjectLeaseRecordMap.get('is_Active__c'));
                                System.debug('=== oldValue : ' + (Boolean)oldVendorObjectLeaseRecordMap.get('is_Active__c'));

                                volRollBack.is_Active__c = (Boolean)oldVendorObjectLeaseRecordMap.get('is_Active__c');
                            }

                            System.debug('===  volRollBack : ' + volRollBack);

                            MetadataTriggerHandler.bypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');
                            update volRollBack;
                            MetadataTriggerHandler.clearBypass('TA_AT_VendorObjLeaseAftUpd_UpdateVendor');
                        }

                        // vendor_spk_type update rollback
                        if (oldSPKTRec != null) {
                            System.debug('=== in vendor_spk_type update rollback ===');

                            Object newVendorSPKTypeRecordObj = JSON.deserializeUntyped(newSPKTRec);
                            Object oldVendorSPKTypeRecordObj = JSON.deserializeUntyped(oldSPKTRec);
                            System.debug('=== newVendorSPKTypeRecordObj : ' + newVendorSPKTypeRecordObj);
                            System.debug('=== oldVendorSPKTypeRecordObj : ' + oldVendorSPKTypeRecordObj);

                            Map<String, Object> newVendorSPKTypeRecordMap = (Map<String, Object>)newVendorSPKTypeRecordObj;
                            Map<String, Object> oldVendorSPKTypeRecordMap = (Map<String, Object>)oldVendorSPKTypeRecordObj;
                            System.debug('=== newVendorSPKTypeRecordMap : ' + newVendorSPKTypeRecordMap);
                            System.debug('=== oldVendorSPKTypeRecordMap : ' + oldVendorSPKTypeRecordMap);

                            Vendor_SPK_Type__c spktRollBack = new Vendor_SPK_Type__c();
                            spktRollBack.Id = (Id)oldVendorSPKTypeRecordMap.get('Id');
                            
                            // spk type field rollback
                            if ((String)newVendorSPKTypeRecordMap.get('SPK_Type__c') != (String)oldVendorSPKTypeRecordMap.get('SPK_Type__c')) {
                                System.debug('=== in spk type field rollback ===');
                                System.debug('=== newValue : ' + (String)newVendorSPKTypeRecordMap.get('SPK_Type__c'));
                                System.debug('=== oldValue : ' + (String)oldVendorSPKTypeRecordMap.get('SPK_Type__c'));

                                spktRollBack.SPK_Type__c = (String)oldVendorSPKTypeRecordMap.get('SPK_Type__c');
                            }
                            // need po field rollback
                            if ((Boolean)newVendorSPKTypeRecordMap.get('Need_PO__c') != (Boolean)oldVendorSPKTypeRecordMap.get('Need_PO__c')) {
                                System.debug('=== in spk type field rollback ===');
                                System.debug('=== newValue : ' + (Boolean)newVendorSPKTypeRecordMap.get('Need_PO__c'));
                                System.debug('=== oldValue : ' + (Boolean)oldVendorSPKTypeRecordMap.get('Need_PO__c'));
                                
                                spktRollBack.Need_PO__c = (Boolean)oldVendorSPKTypeRecordMap.get('Need_PO__c');
                            }

                            System.debug('=== spktRollBack : ' + spktRollBack);

                            MetadataTriggerHandler.bypass('TA_AT_VendorSPKTypeAftUpd_UpdateVendor');
                            update spktRollBack;
                            MetadataTriggerHandler.clearBypass('TA_AT_VendorSPKTypeAftUpd_UpdateVendor');
                        }
                    }
                } catch (Exception e) {
                    SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                    status = 'Failed';
                    errorMsg = errorMsg + '. Error on REST_Vendor_Callout.requestVendorCreationToEasyOpsByVendorId method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' ' + responseMsg + '::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);  
                }

                // put to call_log obj
                callLogObj.type__c                 = 'Callout';
                callLogObj.request_start_time__c   = requestStartTime;
                callLogObj.method__c               = 'POST';
                callLogObj.callerFrom__c           = 'Salesforce';
                callLogObj.endpoint__c             = endpoint;
                callLogObj.uri__c                  = URI;
                callLogObj.request_message__c      = bodyMesage;
                callLogObj.status__c               = status;
                callLogObj.response_message__c     = responseMsg;
                callLogObj.Error_Message__c        = errorMsg;
                callLogObj.Request_ID__c           = callId;
                callLogObj.response_end_time__c    = Datetime.now();
            }
            insert callLogObj;
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
        public List<VENDOR_OBJECT_LEASE_CREATION> object_lease;
        public LISt<VENDOR_SPK_TYPE_CREATION> spk_need_po;
    }

    global class VENDOR_OBJECT_LEASE_CREATION {
        public String name; // Converter
        public String type; // COGS
        public String garansi_sla; // 96
        public Boolean is_active; // true / false 
        public String id; // 01aa4d10-b8ce-4fa2-9249-29627970f634
    }

    global class VENDOR_SPK_TYPE_CREATION {
        public String spk_type; // Installation
        public Boolean need_po; // true / false
        public String id; // ""
    }
}