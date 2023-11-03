/*-----------------------------------------------------------------------------------------------------------//
 * Class Name	: REST_CheckAccountBadDebt_Callout
 * Author		: ahmat zulkifli murad <ahmat.murad@saasten.com>
 * Date			: 10 / 09 / 2022
 * Description	: Description of the class
 *
 * Changes (version)
 * -------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	-----------------------------------
 *  @version		1.0		2022-09-10		ahmat zulkifli murad	Created
 * 
 *-----------------------------------------------------------------------------------------------------------*/
global with sharing class REST_CheckAccountBadDebt_Callout {

    public static List < Call_Log__c > callLogList = new List < Call_Log__c > ();
    public static String token;
    public static string tokenResponseMessage = null;
    public static string formatDateTime = 'yyyy-mm-dd hh:mm:ss';

    public static void getAccessToken() {
        DateTime startDate = system.now();

        String CallID = AppUtils.getNewGUID();
        String responseMsg;
        String tokenStatusMsg;
        String result;
        string errorMsg;
        String request;
        string endpoint;

        try {

            REST_EasyOps_API_Settings__c accountBadDebtSettings = REST_EasyOps_API_Settings__c.getOrgDefaults();

            GET_TOKEN_REQUEST GET_TOKEN_REQUEST_Obj = new GET_TOKEN_REQUEST();
            GET_TOKEN_REQUEST_Obj.password = accountBadDebtSettings.accountBadDebt_password__c;
            GET_TOKEN_REQUEST_Obj.username = accountBadDebtSettings.accountBadDebt_username__c;

            String reqBody = 'username=' + GET_TOKEN_REQUEST_Obj.username + '&password=' +
                apputils.doDecrypt(GET_TOKEN_REQUEST_Obj.password);

            system.debug(' reqBody >> ' + reqBody);
            endPoint = accountBadDebtSettings.accountBadDebt_Endpoint_GetToken__c;

            HttpRequest HttpRequestObj = new HttpRequest();

            httpRequestObj.setTimeout(120000);
            HttpRequestObj.setEndpoint(endPoint);
            httpRequestObj.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            httpRequestObj.setHeader('Accept', 'application/Json');
            httpRequestObj.setMethod(accountBadDebtSettings.accountBadDebt_Method__c);

            HttpRequestObj.setBody(reqBody);
            system.debug('HttpRequestObj: ' +  HttpRequestObj);
            system.debug('System.HttpRequest: ' +  httpRequestObj.getBody());

            request = string.valueOf(HttpRequestObj);
            system.debug('request: ' + request);

            http httpObj = new http();
            HTTPResponse httpResponseObj = new HTTPResponse();
            httpResponseObj = httpObj.send(httpRequestObj);
            responseMsg = string.valueOf(httpResponseObj);

            tokenResponseMessage = httpResponseObj.getBody();
            System.debug('>>> tokenResponseMessage : ' + tokenResponseMessage);

            if (httpResponseObj.getBody() != null || httpResponseObj.getBody() != '') {
                Map < String, Object > responsemap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponseObj.getBody());

                token = (string) responsemap.get('token');
                System.debug('================= response token : ' + token);
            }

            if (String.isNotBlank(token)) {
                tokenStatusMsg = 'Success';
            } else {
                tokenStatusMsg = 'failed';
                errorMsg = tokenResponseMessage;
            }

            Datetime endDate = System.now();

        }
        Catch(Exception e) {
            tokenStatusMsg = 'Failed';
            errorMsg = errorMsg + '. Error on REST_CheckAccountBadDebt_Callout.getAccessToken method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' ' + responseMsg + '::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
    }

    public static list < account > checkAccountBadDebtRequestSync(set < string > accountBPNumbers) {
        system.debug(' =========== inside method REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestSync');

        DateTime startDate = system.now();

        string status;
        String responseMsg;
        string errorMsg;
        String badDebStatusMessages;
        string result;
        String callId = AppUtils.getNewGUID();
        Boolean BadDebtStatus;

        string invoiceNumber;
        string external_id;

        integer responseCode;

        integer totalAmount;
        string totalAmountString;

        datetime invoiceDate;
        String invoiceDateString;

        list < object > bodyData = new list < object > ();
        //Set<string> accountBPNumbers = new Set<string>();
        set < id > Accountids = new set < id > ();
        list < string > listExternalId = new list < string > ();
        list < Account > accountList = new list < Account > ();
        List < Account > accountListUpdate = new list < Account > ();

        try {

            getAccessToken();
            system.debug(' == getAccessToken >' + token);

            if (token != null) {

                system.debug('accountBPNumbers >> ' + accountBPNumbers);
                DateTime todaysDate = system.now();
                String dateTimeFormat = todaysDate.format('yyyyMMddhhmmss');
                String timeNow = dateTimeFormat.right(6);
                string dateNow = dateTimeFormat.left(8);

                String request_id = 'BD' + '_' + dateNow + '_' + timeNow;

                GET_BODY_REQUEST GET_BODY_REQUEST_Obj = new GET_BODY_REQUEST();
                GET_BODY_REQUEST_Obj.request_id = request_id;
                GET_BODY_REQUEST_Obj.bp_number = accountBPNumbers;

                accountList = [select id, bp_number__c, BP_LA_Number__c, bad_debt_status__c from account where BP_LA_Number__c in: accountBPNumbers];

                map < string, id > accountMap = new map < string, id > ();
                for (account accountRec: accountList) {
                    accountMap.put(accountRec.BP_LA_Number__c, accountRec.id);
                }

                // need update using set account id

                system.debug('GET_BODY_REQUEST_Obj :' + GET_BODY_REQUEST_Obj);
                system.debug('GET_BODY_REQUEST_Obj.bp_number :' + GET_BODY_REQUEST_Obj.bp_number);
                String reqBodys = json.serialize(GET_BODY_REQUEST_Obj);
                system.debug(' reqBodys in Json >> ' + reqBodys);

                REST_EasyOps_API_Settings__c accountBadDebtSettings = REST_EasyOps_API_Settings__c.getOrgDefaults();

                Http httpObj = new Http();
                HttpRequest httpRequestObj = new HttpRequest();

                httpRequestObj.setEndpoint(accountBadDebtSettings.accountBadDebt_EndPoint_Request_BadDebt__c);
                httpRequestObj.setMethod(accountBadDebtSettings.accountBadDebt_Method__c);
                httpRequestObj.setHeader('Content-Type', 'application/json');
                httpRequestObj.setHeader('Accept', 'application/json');
                httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
                httpRequestObj.setTimeout(120000);
                httpRequestObj.setBody(reqBodys);

                String reqMessage = string.valueOf(httpRequestObj);
                system.debug(' == reqMessage : ' + reqMessage);

                Http http = new Http();
                HTTPResponse httpResponseObj = new HTTPResponse();
                httpResponseObj = http.send(httpRequestObj);
                system.debug(' >> response getBadDebt : ' + httpResponseObj);

                String stringResponseBody;
                stringResponseBody = httpResponseObj.getBody();

                //untuk testing
                //stringResponseBody = '{"data":[{"bad_debt":false,"bp_number":"762395","invoice":[{"invoice_number":"9012381","posting_date":"2020-02-2000:00:00","amount":"2377419","external_id":"e845259f-b7b4-4fas3-8e25-687fdcb08493","customer_id":"754938"},{"invoice_number":"DMAROPR","posting_date":"2020-02-2000:00:00","customer_id":"754938","amount":"1650000","external_id":"f23f4091-86cb-41d3-aa31-18f5ec109c45"},{"invoice_number":"DMAROPR","posting_date":"2020-02-2000:00:00","external_id":"ab9b4f96-1013-4b26-a4b0-39fd84cccdca","customer_id":"754938","amount":"1650000"}]}],"requestId":"BD_20220824_162600"}';

                System.debug('>>> httpResponseObj.getBody(); : ' + stringResponseBody);

                if (stringResponseBody != null) {
                    badDebStatusMessages = 'Success';
                    Map < String, Object > responsemap = (Map < String, Object > ) JSON.deserializeUntyped(stringResponseBody);
                    system.debug(' == responsemap > ' + responsemap);

                    list < Object > invoiceBodyNewList = new list < Object > ();
                    list < INVOICE_OBJECT > invoiceBodyObjList = new list < INVOICE_OBJECT > ();
                    for (object dataObj: (List < Object > ) responsemap.get('data')) {
                        Map < String, Object > dataObjAtt = (Map < String, Object > ) dataObj;
                        BadDebtStatus = (Boolean) dataObjAtt.get('bad_debt');
                        string BpNumber = (string) dataObjAtt.get('bp_number');
                        invoiceBodyNewList = (List < Object > ) dataObjAtt.get('invoice');
                        id Accountid = accountMap.get(BpNumber);
                        Accountids.add(Accountid);

                        for (object invObjRec: invoiceBodyNewList) {
                            Map < String, Object > mapRec = (Map < String, Object > ) invObjRec;
                            external_id = (string) mapRec.get('external_id');
                            listExternalId.add(external_id);

                            INVOICE_OBJECT INVOBJECT = new INVOICE_OBJECT();
                            INVOBJECT.amount = (string) mapRec.get('amount');
                            INVOBJECT.external_id = (string) mapRec.get('external_id');
                            INVOBJECT.invoice_number = (string) mapRec.get('invoice_number');
                            INVOBJECT.posting_date = (string) mapRec.get('posting_date');
                            INVOBJECT.account_id = Accountid;
                            invoiceBodyObjList.add(INVOBJECT);

                        }
                        system.debug('invoiceBodyObjList = ' + invoiceBodyObjList);

                    }

                    system.debug(' BadDebtStatus >> ' + BadDebtStatus);

                    set < String > setInvoiceExternalId = new set < String > ();
                    accountListUpdate = [select id, name, bp_number__c, bad_debt_status__c from account where id in: Accountids];
                    list < account > accountNewList = new list < account > ();
                    if (accountListUpdate != null) {
                        
                        List<Trigger_Controller__c> triggerControllerList = [
                            SELECT id, Is_Active__c 
                            FROM Trigger_Controller__c 
                            WHERE name = 'Trigger_Account'
                        ];

                        for (account accountListRecord: accountListUpdate) {

                            accountListRecord.bad_debt_status__c = string.valueOf(BadDebtStatus);
                            accountListRecord.Bad_Debt_Last_Checking_Date__c = system.now();

                            accountNewList.add(accountListRecord);
                        }

                        //-- Deactive the trigger account
                        if (triggerControllerList <> null) {
                            triggerControllerList[0].Is_Active__c = FALSE;
                            update triggerControllerList;
                        }

                        //update accountNewList;
                        Database.SaveResult[] updateResults = Database.update(accountNewList, false);
                        for (Database.SaveResult updateResults_Extract : updateResults) {
                            if (updateResults_Extract.isSuccess()) {
                                system.debug(' success update account ');
                            }
                            else {          
                                for(Database.Error error : updateResults_Extract.getErrors()) {
                                    String err_message = 'Error on Rest_checkAccountBadDebt.cls - update accountNewList ::' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields();
                                    AppUtils.putError(err_message);
                                    System.debug('Error on Rest_checkAccountBadDebt.cls - update accountNewList ::' + error.getStatusCode() + ' : ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
                                }
                            }
                        }

                        // -- reActive the trigger account
                        if (triggerControllerList <> null) {
                            triggerControllerList[0].Is_Active__c = TRUE;
                            update triggerControllerList;
                        }

                        SYSTEM.debug(' after update accountNewList ' + accountNewList);
                    }

                    if (BadDebtStatus == true) {

                        list < invoice__c > invoiceList = [SELECT Id, OwnerId, Name, CreatedById, LastModifiedById, Invoice_Number__c, Total_Amount__c, BillingAccountId__c, BillingAccountId__r.bad_debt_status__c FROM Invoice__c WHERE BillingAccountId__c in: Accountids];
                        system.debug('invoiceList >> ' + invoiceList);

                        //untuk insert invoice status
                        list < invoice__c > invoiceNewList = new list < invoice__c > ();
                        system.debug('invoiceBodyNewList.size > ' + invoiceBodyNewList.size());

                        upsertInvoice(invoiceBodyObjList);

                        if (invoiceList.size() > 0) {

                            system.debug(' accountid for query > ' + AccountIds);
                            system.debug(' listExternalId for query > ' + listExternalId);

                            list < invoice__c > checkInvoiceList = [SELECT Id, OwnerId, Name, CreatedById, LastModifiedById, Invoice_Number__c, Total_Amount__c, BillingAccountId__c, BillingAccountId__r.bad_debt_status__c FROM Invoice__c WHERE BillingAccountId__c in: Accountids and external_id__c NOT in: listExternalId];

                            system.debug('checkInvoiceList >>' + checkInvoiceList);
                            system.debug('checkInvoiceList.SIZE() >>' + checkInvoiceList.size());

                            if (checkInvoiceList != NULL) {

                                for (invoice__c invoiceRecord: checkInvoiceList) {

                                    system.debug('invoiceRecord' + invoiceRecord);
                                    invoiceRecord.status__c = 'paid';

                                    invoiceNewList.add(invoiceRecord);
                                }

                                update invoiceNewList;

                            }
                        }
                    } else if (BadDebtStatus == false) {

                        system.debug(' in bad debt status = false');

                        list < invoice__c > invoiceNewList = new list < invoice__c > ();

                        list < invoice__c > invoiceList = [SELECT Id, OwnerId, Name, CreatedById, LastModifiedById, Invoice_Number__c, Total_Amount__c, BillingAccountId__c, BillingAccountId__r.bad_debt_status__c FROM Invoice__c WHERE BillingAccountId__c in: Accountids];

                        if (invoiceList.size() > 0) {

                            for (invoice__c invoiceRecords: invoiceList) {

                                invoiceRecords.status__c = 'paid';

                                invoiceNewList.add(invoiceRecords);
                            }

                            update invoiceNewList;
                            
                        }
                    }
                }

                Datetime endDate = System.now();

                Call_Log__c log = new Call_Log__c(
                    CallerFrom__c = 'Salesforce',
                    Endpoint__c = accountBadDebtSettings.accountBadDebt_EndPoint_Request_BadDebt__c,
                    Type__c = 'Callout',
                    //status__c = 'success',
                    Request_Message__c = reqMessage,
                    Response_Message__c = responseMsg,
                    Method__c = 'POST',
                    Status__c = badDebStatusMessages,
                    Request_ID__c = callId,
                    Request_Start_Time__c = startDate,
                    Response_End_Time__c = endDate
                );
                callLogList.add(log);
            }

        } catch (Exception e) {
            errorMsg = errorMsg + '. Error on REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestSync method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' ' + responseMsg + '::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
        return accountListUpdate;
    }

    //multiple account status
    @future(callout = true)
    public static void checkAccountBadDebtRequestAsync(set < string > accountBPNumbers) {
        system.debug(' =========== inside method REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestSync');

        DateTime startDate = system.now();

        string status;
        String responseMsg;
        string errorMsg;
        String badDebStatusMessages;
        string result;
        String callId = AppUtils.getNewGUID();
        Boolean BadDebtStatus;

        string invoiceNumber;
        string external_id;

        integer responseCode;

        integer totalAmount;
        string totalAmountString;

        datetime invoiceDate;
        String invoiceDateString;

        list < object > bodyData = new list < object > ();
        //Set<string> accountBPNumbers = new Set<string>();
        set < id > Accountids = new set < id > ();
        list < string > listExternalId = new list < string > ();
        list < Account > accountList = new list < Account > ();
        List < Account > accountListUpdate = new list < Account > ();

        try {

            getAccessToken();
            system.debug(' == getAccessToken >' + token);

            if (token != null) {

                //loop opportunitylist
                system.debug('accountBPNumbers = ' + accountBPNumbers);
                DateTime todaysDate = system.now();
                String dateTimeFormat = todaysDate.format('yyyyMMddhhmmss');
                String timeNow = dateTimeFormat.right(6);
                string dateNow = dateTimeFormat.left(8);

                String request_id = 'BD' + '_' + dateNow + '_' + timeNow;

                GET_BODY_REQUEST GET_BODY_REQUEST_Obj = new GET_BODY_REQUEST();
                GET_BODY_REQUEST_Obj.request_id = request_id;
                GET_BODY_REQUEST_Obj.bp_number = accountBPNumbers;

                accountList = [select id, bp_number__c, BP_LA_Number__c, bad_debt_status__c from account where BP_LA_Number__c in: accountBPNumbers];

                map < string, id > accountMap = new map < string, id > ();
                for (account accountRec: accountList) {
                    accountMap.put(accountRec.BP_LA_Number__c, accountRec.id);
                }

                // need update using set account id

                system.debug('GET_BODY_REQUEST_Obj :' + GET_BODY_REQUEST_Obj);
                system.debug('GET_BODY_REQUEST_Obj.bp_number :' + GET_BODY_REQUEST_Obj.bp_number);
                String reqBodys = json.serialize(GET_BODY_REQUEST_Obj);
                system.debug(' reqBodys in Json >> ' + reqBodys);

                REST_EasyOps_API_Settings__c accountBadDebtSettings = REST_EasyOps_API_Settings__c.getOrgDefaults();

                Http httpObj = new Http();
                HttpRequest httpRequestObj = new HttpRequest();

                httpRequestObj.setEndpoint(accountBadDebtSettings.accountBadDebt_EndPoint_Request_BadDebt__c);
                httpRequestObj.setMethod(accountBadDebtSettings.accountBadDebt_Method__c);
                httpRequestObj.setHeader('Content-Type', 'application/json');
                httpRequestObj.setHeader('Accept', 'application/json');
                httpRequestObj.setHeader('Authorization', 'Bearer ' + token);
                httpRequestObj.setTimeout(120000);
                httpRequestObj.setBody(reqBodys);

                String reqMessage = string.valueOf(httpRequestObj);
                system.debug(' == reqMessage : ' + reqMessage);

                Http http = new Http();
                HTTPResponse httpResponseObj = new HTTPResponse();
                httpResponseObj = http.send(httpRequestObj);
                system.debug(' >> response getBadDebt : ' + httpResponseObj);

                String stringResponseBody;
                stringResponseBody = httpResponseObj.getBody();

                //untuk testing
               // stringResponseBody = '{"data":[{"bad_debt":true,"bp_number":"754938","invoice":[{"invoice_number":"DMAROPR","posting_date":"2020-02-2000:00:00","amount":"2377419","external_id":"e845259f-b7b4-4fb3-8e25-687fdcqweb08493","customer_id":"754938"},{"invoice_number":"DMAROPR","posting_date":"2020-02-2000:00:00","customer_id":"754938","amount":"1650000","external_id":"f23f4091-86cb-41d3-aa31-18f5esac109c45"},{"invoice_number":"DMAROPR","posting_date":"2020-02-2000:00:00","external_id":"ab9b4f96-1013-4b26-a4b0-39fd84cccsddca","customer_id":"754938","amount":"1650000"}]},{"bad_debt":true,"bp_number":"752739","invoice":[{"amount":"24","invoice_number":"90183190","customer_id":"752739","posting_date":"2021-02-1000:00:00","external_id":"650493be-b815-4c17-98ba-bc766fa8582ad0"},{"external_id":"77515ad2-edaf-42b9-94d0-4a233de01f2dsda","amount":"3607500","customer_id":"752739","invoice_number":"90513021","posting_date":"2022-08-1000:00:00"}]}],"requestId":"BD_20220824_162600"}';

                System.debug('>>> httpResponseObj.getBody(); : ' + stringResponseBody);

                if (stringResponseBody != null) {
                    badDebStatusMessages = 'Success';
                    Map < String, Object > responsemap = (Map < String, Object > ) JSON.deserializeUntyped(stringResponseBody);
                    system.debug(' == responsemap > ' + responsemap);

                    list < Object > invoiceBodyNewList = new list < Object > ();
                    list < INVOICE_OBJECT > invoiceBodyObjList = new list < INVOICE_OBJECT > ();
                    for (object dataObj: (List < Object > ) responsemap.get('data')) {
                        Map < String, Object > dataObjAtt = (Map < String, Object > ) dataObj;
                        BadDebtStatus = (Boolean) dataObjAtt.get('bad_debt');
                        string BpNumber = (string) dataObjAtt.get('bp_number');
                        invoiceBodyNewList = (List < Object > ) dataObjAtt.get('invoice');
                        id Accountid = accountMap.get(BpNumber);
                        Accountids.add(Accountid);

                        for (object invObjRec: invoiceBodyNewList) {
                            Map < String, Object > mapRec = (Map < String, Object > ) invObjRec;
                            external_id = (string) mapRec.get('external_id');
                            listExternalId.add(external_id);

                            INVOICE_OBJECT INVOBJECT = new INVOICE_OBJECT();
                            INVOBJECT.amount = (string) mapRec.get('amount');
                            INVOBJECT.external_id = (string) mapRec.get('external_id');
                            INVOBJECT.invoice_number = (string) mapRec.get('invoice_number');
                            INVOBJECT.posting_date = (string) mapRec.get('posting_date');
                            INVOBJECT.account_id = Accountid;
                            invoiceBodyObjList.add(INVOBJECT);

                        }
                    }

                    // add json body to tempporary variable

                    set < String > setInvoiceExternalId = new set < String > ();

                    accountListUpdate = [select id, name, bp_number__c, bad_debt_status__c, Customer_VAT_Name__c from account where id in: Accountids];
                    system.debug(' accountListUpdate >> ' + accountListUpdate.size());
                    system.debug('invoiceBodyObjList.size() ' + invoiceBodyObjList.size());
                    system.debug(' invoiceBodyNewListSize >> ' + invoiceBodyNewList.size());
                    system.debug(' invoiceBodyNewList >> ' + invoiceBodyNewList);

                    list < account > accountNewList = new list < account > ();
                    if (accountListUpdate != null) {
                        //list for active deactive trigger account
                        List<Trigger_Controller__c> triggerControllerList = [
                            SELECT id, Is_Active__c 
                            FROM Trigger_Controller__c 
                            WHERE name = 'Trigger_Account'
                        ];

                        for (account accountRecord: accountListUpdate) {

                            accountRecord.bad_debt_status__c = string.valueOf(BadDebtStatus);
                            accountRecord.Bad_Debt_Last_Checking_Date__c = system.now();
                            accountRecord.Name = accountRecord.Name.left(40);
                            if (accountRecord.Customer_VAT_Name__c != null) {
                                accountRecord.Customer_VAT_Name__c = accountRecord.Customer_VAT_Name__c.left(40);
                            }
                            accountNewList.add(accountRecord);
                        }
                        
                        //-- Deactive the trigger account 
                        if (triggerControllerList <> null) {
                            triggerControllerList[0].Is_Active__c = FALSE;
                            update triggerControllerList;
                        }

                        //update accountNewList;
                        Database.SaveResult[] updateResults = Database.update(accountNewList, false);
                        for (Database.SaveResult updateResults_Extract : updateResults) {
                            if (updateResults_Extract.isSuccess()) {
                                system.debug(' success update account ');
                            }
                            else {          
                                for(Database.Error error : updateResults_Extract.getErrors()) {
                                    String err_message = 'Error on Rest_checkAccountBadDebt.cls - update accountNewList ::' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields();
                                    AppUtils.putError(err_message);
                                    System.debug('Error on Rest_checkAccountBadDebt.cls - update accountNewList ::' + error.getStatusCode() + ' : ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
                                }
                            }
                        }

                        //re-Active the trigger account
                        if (triggerControllerList <> null) {
                            triggerControllerList[0].Is_Active__c = TRUE;
                            update triggerControllerList;
                        }
                        

                        SYSTEM.debug(' after update accountNewList ' + accountNewList);

                    }

                    if (BadDebtStatus == true) {
                        system.debug(' in BadDebtStatus = true');
                        list < invoice__c > invoiceList = [SELECT Id, OwnerId, Name, CreatedById, LastModifiedById, Invoice_Number__c, Total_Amount__c, BillingAccountId__c, BillingAccountId__r.bad_debt_status__c FROM Invoice__c WHERE BillingAccountId__c in: Accountids];
                        system.debug('invoiceList >> ' + invoiceList);

                        //untuk insert invoice status
                        list < invoice__c > invoiceNewList = new list < invoice__c > ();

                        system.debug('invoiceBodyNewList.size > ' + invoiceBodyNewList.size());

                        upsertInvoice(invoiceBodyObjList);

                        if (invoiceList.size() > 0) {

                            system.debug(' accountid for query > ' + AccountIds);
                            system.debug(' listExternalId for query > ' + listExternalId);

                            list < invoice__c > checkInvoiceList = [SELECT Id, OwnerId, Name, CreatedById, LastModifiedById, Invoice_Number__c, Total_Amount__c, BillingAccountId__c, BillingAccountId__r.bad_debt_status__c FROM Invoice__c WHERE BillingAccountId__c in: Accountids and external_id__c NOT in: listExternalId];

                            system.debug('checkInvoiceList >>' + checkInvoiceList);
                            system.debug('checkInvoiceList.SIZE() >>' + checkInvoiceList.size());

                            if (checkInvoiceList != NULL) {

                                for (invoice__c invoiceRecord: checkInvoiceList) {

                                    system.debug('invoiceRecord' + invoiceRecord);
                                    invoiceRecord.status__c = 'paid';

                                    invoiceNewList.add(invoiceRecord);
                                }

                                update invoiceNewList;

                            }
                        }
                    } else if (BadDebtStatus == false) {

                        system.debug(' in bad debt status = false');

                        list < invoice__c > invoiceNewList = new list < invoice__c > ();

                        list < invoice__c > invoiceList = [SELECT Id, OwnerId, Name, CreatedById, LastModifiedById, Invoice_Number__c, Total_Amount__c, BillingAccountId__c, BillingAccountId__r.bad_debt_status__c FROM Invoice__c WHERE BillingAccountId__c in: Accountids];

                        if (invoiceList.size() > 0) {

                            for (invoice__c invoiceRecords: invoiceList) {

                                invoiceRecords.status__c = 'paid';

                                invoiceNewList.add(invoiceRecords);
                            }

                            update invoiceNewList;
                        }
                    }
                }

                Datetime endDate = System.now();

                Call_Log__c log = new Call_Log__c(
                    CallerFrom__c = 'Salesforce',
                    Endpoint__c = accountBadDebtSettings.accountBadDebt_EndPoint_Request_BadDebt__c,
                    Type__c = 'Callout',
                    //status__c = 'success',
                    Request_Message__c = reqMessage,
                    Response_Message__c = responseMsg,
                    Method__c = 'POST',
                    Status__c = badDebStatusMessages,
                    Request_ID__c = callId,
                    Request_Start_Time__c = startDate,
                    Response_End_Time__c = endDate
                );
                callLogList.add(log);
            }

        } catch (Exception e) {
            errorMsg = errorMsg + '. Error on REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestSync method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' ' + responseMsg + '::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
    }

    //to do: creat new method checkAccountBadDebtRequest sync to get return badDebt status
    public static void upsertInvoice(list < INVOICE_OBJECT > invoiceList) {

        list < invoice__c > invoiceNewList = new list < invoice__c > ();

        system.debug('invoice Size : ' + invoiceList.size());
        for (INVOICE_OBJECT invoiceObj: invoiceList) {

            dateTime convertinvoiceDate = apputils.strToDateTime(invoiceObj.posting_date, formatDateTime);
            invoice__c invoiceRec = new invoice__c();

            invoiceRec.Invoice_Number__c = invoiceObj.invoice_number;
            invoiceRec.Total_Amount__c = decimal.valueOf(invoiceObj.amount);
            invoiceRec.Invoice_Date__c = convertinvoiceDate;
            invoiceRec.BillingAccountId__c = invoiceObj.account_id;
            invoiceRec.external_id__c = invoiceObj.external_id;
            invoiceRec.Status__c = 'Unpaid';

            invoiceNewList.add(invoiceRec);
        }

        upsert invoiceNewList external_id__c;
    }

    global class GET_TOKEN_REQUEST {
        global String username {
            get;
            set;
        }
        global String password {
            get;
            set;
        }
    }

    global class GET_BODY_REQUEST {
        global string request_id {
            get;
            set;
        }
        global set < string > bp_number {
            get;
            set;
        }
    }

    global class INVOICE_OBJECT {
        global string posting_date {
            get;
            set;
        }
        global string amount {
            get;
            set;
        }
        global string invoice_number {
            get;
            set;
        }
        global string external_id {
            get;
            set;
        }
        global id account_id {
            get;
            set;
        }

    }

}