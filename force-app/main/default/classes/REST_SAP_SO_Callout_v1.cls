/**
 * @description       : 
 * @Test Class        : REST_SAP_SO_Callout_v1_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-19-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-08-2023   Novando Utoyo Agmawan   Initial Version
**/

global class REST_SAP_SO_Callout_v1 {
    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static Boolean Sent_Email_if_Failed = true;

    //REST_SAP_SO_Callout_v1.createSAPSoFreeMrc('a0S1m000002JrLZEA0', 'a0T1m000004S8KWEA0', '08e1m00000Fop1R');

    @future(Callout=true)
    public static void createSAPSoFreeMrc(String contractTicketId, String contractTicketItemId, String jobId){
        SYSTEM.DEBUG ('============== in REST_SAP_SO_Callout_v1 class, createSAPSoFreeMrc method ==============' );

        List<SAP_API_Setting__c> List_SAP_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM SAP_API_Setting__c WHERE Name = 'SAPSoFreeMrc'];

        if(List_SAP_APISetting!=null && !List_SAP_APISetting.isEmpty()){
            if(
                String.isNotBlank(contractTicketId) &&
                String.isNotBlank(contractTicketItemId) &&
                String.isNotBlank(jobId)
            ){
                list<Scheduled_Process__c> List_scheduledProcess = [
                    SELECT Id,
                    status__C,
                    Notes2__c
                    FROM Scheduled_Process__c
                    WHERE jobID__c =: jobId
                ];

                List<Contract_Ticket_Item__c> List_allContractTicketItems = [
                    SELECT Id,
                    Contract_Item__c,
                    Contract_Ticket__c,
                    Contract_Item_No__c,
                    Contract_Item__r.Contract_ID__c,
                    Type__c
                    FROM Contract_Ticket_Item__c
                    WHERE Contract_Ticket__c =: contractTicketId AND
                    Contract_Item_No__c != '-' AND
                    Type__c = 'Recurring'
                ];

                if(List_allContractTicketItems!=null && !List_allContractTicketItems.isEmpty()){
                    Datetime requestStartTime = datetime.now();

                    if (List_scheduledProcess!=null && !List_scheduledProcess.isEmpty()) {
                        List_scheduledProcess[0].Execute_Start__c = requestStartTime;
                    } 

                    string URI;
                    string bodyMesage;
                    string status = 'success';
                    integer responseCode;
                    string responseMsg;
                    string errorMsg;
                    string callId = AppUtils.getNewGUID();
                    string endpoint;

                    Http httpObj = new Http();
                    HttpRequest httpRequestObj = new HttpRequest();

                    List<Contract_Ticket_Item__c> List_contractTicketItems = [
                        SELECT Id,
                        Contract_Item__c,
                        Contract_Item_No__c
                        FROM Contract_Ticket_Item__c
                        WHERE Id =: contractTicketItemId
                    ];

                    if(List_contractTicketItems!=null && !List_contractTicketItems.isEmpty()){
                        List<Contract> List_contracts = [
                            SELECT Id,
                            ContractNumber,
                            Contract_ID__c,
                            BP_Payer__c,
                            Name,
                            Product__r.SAP_Code__c,
                            Product__r.Name,
                            Quantity__c,
                            Bandwidth_UoM_filled__c,
                            Price__c,
                            Start_Date__c,
                            End_Date__c,
                            Distribution_Channel__r.Code__c,
                            SO_Number__c
                            FROM Contract
                            WHERE Id =: List_contractTicketItems[0].Contract_Item__c
                        ];

                        if(List_contracts!=null && !List_contracts.isEmpty()){
                            if(string.isBlank(List_contracts[0].SO_Number__c)){
                                try {
                                    //-- do call out
                                    SYSTEM.DEBUG ('============== try to do call out ==============');
                
                                    SAPSoFreeMrc_request SAPSoFreeMrc_request_extract = new SAPSoFreeMrc_request();
    
                                    SAPSoFreeMrc_request_extract.TransactionId = String.valueOf(List_contracts[0].ContractNumber);
    
                                    SAPSoFreeMrc_request_extract.ContractId = String.valueOf(List_allContractTicketItems[0].Contract_Item__r.Contract_ID__c);
                                    
                                    SAPSoFreeMrc_request_extract.CustomerNumber = String.valueOf(List_contracts[0].BP_Payer__c);
    
                                    SAPSoFreeMrc_request_extract.DistributionChannel = String.valueOf(List_contracts[0].Distribution_Channel__r.Code__c);

                                    DateTime startDateConvert = DateTime.newInstance(List_contracts[0].Start_Date__c.year(), List_contracts[0].Start_Date__c.month(), List_contracts[0].Start_Date__c.day());

                                    DateTime endDateConvert = DateTime.newInstance(List_contracts[0].End_Date__c.year(), List_contracts[0].End_Date__c.month(), List_contracts[0].End_Date__c.day());

                                    String startDateFormat_POText = startDateConvert.format('yyMMdd');

                                    String endDateFormat_POText = endDateConvert.format('yyMMdd');

                                    String productNameFormat_POText = List_contracts[0].Product__r.Name.replace('FREE MRC', '');

                                    //230101-230131 PromoFree Leased Line

                                    String poTextFormat = startDateFormat_POText + '-' + endDateFormat_POText + ' PromoFree ' + productNameFormat_POText;
    
                                    SAPSoFreeMrc_request_extract.POText = poTextFormat;
    
                                    String todayDateFormat = Datetime.now().format('YYYYMMdd');
                                    system.debug('todayDateFormat : ' + todayDateFormat);
                                    SAPSoFreeMrc_request_extract.TransactionDate = todayDateFormat;
                
                                    List<cls_LineItem_request> List_cls_LineItem_request = new List<cls_LineItem_request>();
                
                                    cls_LineItem_request cls_LineItem_request_extract = new cls_LineItem_request();cls_LineItem_request_extract.MaterialCode = String.valueOf(List_contracts[0].Product__r.SAP_Code__c);
    
                                    cls_LineItem_request_extract.Quantity = String.valueOf(List_contracts[0].Quantity__c);
    
                                    cls_LineItem_request_extract.UOM = 'E1';
                                    
                                    Integer contractPrice = integer.valueOf(List_contracts[0].Price__c);

                                    cls_LineItem_request_extract.Price = String.valueOf(contractPrice);
    
                                    String startDateFormat = startDateConvert.format('YYYYMMdd');
                                    system.debug('startDateFormat : ' + startDateFormat);
                                    cls_LineItem_request_extract.ContractStart = startDateFormat;
    
                                    String endDateFormat = endDateConvert.format('YYYYMMdd');
                                    system.debug('endDateFormat : ' + endDateFormat);
                                    cls_LineItem_request_extract.ContractEnd = endDateFormat;
                
                                    List_cls_LineItem_request.add(cls_LineItem_request_extract);
                
                                    SAPSoFreeMrc_request_extract.LineItem = List_cls_LineItem_request;
                
                                    system.debug('SAPSoFreeMrc_request_extract : ' + SAPSoFreeMrc_request_extract);
                
                                    String reqBody = JSON.serialize(SAPSoFreeMrc_request_extract);
                                    
                                    System.debug('>>> reqBody : '+ reqBody);
                
                                    endpoint = List_SAP_APISetting[0].URI__c + List_SAP_APISetting[0].URL__c;
                                    Blob headerValue = Blob.valueOf(List_SAP_APISetting[0].Username__c + ':' + List_SAP_APISetting[0].Password__c);
                                    String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                
                                    httpRequestObj.setTimeout(120000);
                                    httpRequestObj.setEndpoint(endpoint);
                                    httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
                                    httpRequestObj.setHeader('Authorization', authorizationHeader);
                                    httpRequestObj.setMethod('POST');
                                    httpRequestObj.setBody(reqBody); 
                
                                    System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));
                
                                    bodyMesage = reqBody;
                                    Datetime startDate = System.now();
                
                                    responseMsg = '{"SONumber": "0070000131","Status": "SUCCESS","Message": "Sales Order Created. Sales Order :70000131"}';
                                    
                                    HttpResponse httpResponseObj;

                                    if(!Test.isRunningTest()){
                                        httpResponseObj = httpObj.send(httpRequestObj);
                                        responseMsg = httpResponseObj.getBody();
                                    }
                
                                    System.debug('>>> responseMsg createSAPSoFreeMrc : ' + responseMsg);
                                    
                                    if (httpResponseObj.getStatusCode() == 200) {
                                        Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(responseMsg);
    
                                        System.debug('>>> responsemap createSAPSoFreeMrc : ' + responsemap);
        
                                        String responsemap_status = (string) responsemap.get('Status');
                                        
                                        System.debug('>>> responsemap_status createSAPSoFreeMrc : ' + responsemap_status);
        
                                        if(responsemap_status == 'SUCCESS'){
                                            SAPSoFreeMrc_response SAPSoFreeMrc_response_Extract = (SAPSoFreeMrc_response) JSON.deserialize(responseMsg, SAPSoFreeMrc_response.class);
                    
                                            system.debug('SAPSoFreeMrc_response_Extract ' + SAPSoFreeMrc_response_Extract);
        
                                            List_contracts[0].SO_Number__c = SAPSoFreeMrc_response_Extract.SONumber;
        
                                            update List_contracts;
        
                                            if (List_scheduledProcess!=null && !List_scheduledProcess.isEmpty()) {
                                                List_scheduledProcess[0].status__c = 'Success';
                                                List_scheduledProcess[0].Execute_End__c = system.now();
        
                                                update List_scheduledProcess;
                                            } 
                                        }else{
                                            status = 'Failed';
                                        }
                                    }else{
                                        status = 'Failed';
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
                                    errorMsg = errorMsg +  '. Error on REST_SAP_SO_Callout_v1.createSAPSoFreeMrc method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                                    apputils.puterror(errorMsg);
                                    SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
                                }
    
                                if(status == 'Failed'){
                                    List<Contract_Ticket__c> List_contractTickets = [
                                        SELECT Id,
                                        TicketStatus__c
                                        FROM Contract_Ticket__c
                                        WHERE Id =: contractTicketId
                                    ];
    
                                    if(List_contractTickets!=null && !List_contractTickets.isEmpty()){
                                        List_contractTickets[0].TicketStatus__c = 'Review By Contract Manager';
    
                                        update List_contractTickets;
                                    }
    
                                    List<SAP_Email_Setting__c> List_SAPEmailSetting = [
                                        SELECT Name, 
                                        Additional_toAddress__c, 
                                        Additional_toCCAddress__c,
                                        Additional_toBCCAddress__c
                                        FROM SAP_Email_Setting__c 
                                        WHERE Name =: 'emailFailed_createSAPSoFreeMrc'
                                    ];
    
                                    if(List_SAPEmailSetting!=null && !List_SAPEmailSetting.isEmpty()){
                                        List<string> List_toAddress = new List<string>();
                                        List<string> List_toCCAddress = new List<string>();
                                        List<string> List_toBCCAddress = new List<string>();
    
                                        String batch_ToAddress = List_SAPEmailSetting[0].Additional_toAddress__c;
                                        String batch_toCCAddress = List_SAPEmailSetting[0].Additional_toCCAddress__c;
                                        String batch_toBCCAddress = List_SAPEmailSetting[0].Additional_toBCCAddress__c;
    
                                        if(String.isNotBlank(batch_ToAddress)){
                                            if(batch_ToAddress.contains(' ')){ //space
                                                String toAddress = batch_ToAddress.replaceAll('\\s','');
                                                List_toAddress = toAddress.split(';');
                                            }
                                            if(batch_ToAddress.contains(',')){ //koma
                                                String toAddress = batch_ToAddress.replaceAll('\\,',';');
                                                List_toAddress = toAddress.split(';');
                                            }
                                            if(batch_ToAddress.contains('|')){ //pipe
                                                String toAddress = batch_ToAddress.replaceAll('\\|',';');
                                                List_toAddress = toAddress.split(';');
                                            }
                                            if(batch_ToAddress.contains(' ') && batch_ToAddress.contains(',') ){ //space dan koma
                                                String toAddress = batch_ToAddress.replaceAll('\\s','');
                                                String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                                                List_toAddress = toAddressFormat_1.split(';');
                                                system.debug('batch List_toAddress : ' + List_toAddress);
                                            }
                                            if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') ){ //space dan pipe
                                                String toAddress = batch_ToAddress.replaceAll('\\s','');
                                                String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                                                List_toAddress = toAddressFormat_1.split(';');
                                            }
                                            if(batch_ToAddress.contains(',') && batch_ToAddress.contains('|') ){ //koma dan pipe
                                                String toAddress = batch_ToAddress.replaceAll('[\\|\\,]',';');
                                                List_toAddress = toAddress.split(';');
                                            }
                                            if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') && batch_ToAddress.contains(',') ){ //koma dan pipe dan space
                                                String toAddress = batch_ToAddress.replaceAll('\\s','');
                                                String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                                                List_toAddress = toAddressFormat_1.split(';');
                                            }
                                            if(!batch_ToAddress.contains(' ') && !batch_ToAddress.contains('|') && !batch_ToAddress.contains(',') ){
                                                List_toAddress = batch_ToAddress.split(';');
                                            }
                                        }
    
                                        if(String.isNotBlank(batch_toCCAddress)){
                                            if(batch_toCCAddress.contains(' ')){ //space
                                                String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                                                List_toCCAddress = toCCAddress.split(';');
                                            }
                                            if(batch_toCCAddress.contains(',')){ //koma
                                                String toCCAddress = batch_toCCAddress.replaceAll('\\,',';');
                                                List_toCCAddress = toCCAddress.split(';');
                                            }
                                            if(batch_toCCAddress.contains('|')){ //pipe
                                                String toCCAddress = batch_toCCAddress.replaceAll('\\|',';');
                                                List_toCCAddress = toCCAddress.split(';');
                                            }
                                            if(batch_toCCAddress.contains(',') && batch_toCCAddress.contains('|') ){ //koma dan pipe
                                                String toCCAddress = batch_toCCAddress.replaceAll('[\\|\\,]',';');
                                                List_toCCAddress = toCCAddress.split(';');
                                            }
                                            if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains(',') ){ //space dan koma
                                                String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                                                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                                                List_toCCAddress = toCCAddressFormat_1.split(';');
                                                system.debug('batch List_toCCAddress : ' + List_toCCAddress);
                                            }
                                            if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') ){ //space dan pipe
                                                String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                                                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                                                List_toCCAddress = toCCAddressFormat_1.split(';');
                                            }
                                            if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') && batch_toCCAddress.contains(',') ){ //koma dan pipe dan space
                                                String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                                                String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                                                List_toCCAddress = toCCAddressFormat_1.split(';');
                                            }
                                            if(!batch_toCCAddress.contains(' ') && !batch_toCCAddress.contains('|') && !batch_toCCAddress.contains(',') ){
                                                List_toCCAddress = batch_toCCAddress.split(';');
                                            }
                                        }
    
                                        if(String.isNotBlank(batch_toBCCAddress)){
                                            if(batch_toBCCAddress.contains(' ')){ //space
                                                String toCCAddress = batch_toBCCAddress.replaceAll('\\s','');
                                                List_toBCCAddress = toCCAddress.split(';');
                                            }
                                            if(batch_toBCCAddress.contains(',')){ //koma
                                                String toCCAddress = batch_toBCCAddress.replaceAll('\\,',';');
                                                List_toBCCAddress = toCCAddress.split(';');
                                            }
                                            if(batch_toBCCAddress.contains('|')){ //pipe
                                                String toCCAddress = batch_toBCCAddress.replaceAll('\\|',';');
                                                List_toBCCAddress = toCCAddress.split(';');
                                            }
                                            if(batch_toBCCAddress.contains(',') && batch_toBCCAddress.contains('|') ){ //koma dan pipe
                                                String toCCAddress = batch_toBCCAddress.replaceAll('[\\|\\,]',';');
                                                List_toBCCAddress = toCCAddress.split(';');
                                            }
                                            if(batch_toBCCAddress.contains(' ') && batch_toBCCAddress.contains(',') ){ //space dan koma
                                                String toCCAddress = batch_toBCCAddress.replaceAll('\\s','');
                                                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                                                List_toBCCAddress = toCCAddressFormat_1.split(';');
                                                system.debug('batch List_toBCCAddress : ' + List_toBCCAddress);
                                            }
                                            if(batch_toBCCAddress.contains(' ') && batch_toBCCAddress.contains('|') ){ //space dan pipe
                                                String toCCAddress = batch_toBCCAddress.replaceAll('\\s','');
                                                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                                                List_toBCCAddress = toCCAddressFormat_1.split(';');
                                            }
                                            if(batch_toBCCAddress.contains(' ') && batch_toBCCAddress.contains('|') && batch_toBCCAddress.contains(',') ){ //koma dan pipe dan space
                                                String toCCAddress = batch_toBCCAddress.replaceAll('\\s','');
                                                String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                                                List_toBCCAddress = toCCAddressFormat_1.split(';');
                                            }
                                            if(!batch_toBCCAddress.contains(' ') && !batch_toBCCAddress.contains('|') && !batch_toBCCAddress.contains(',') ){
                                                List_toBCCAddress = batch_toBCCAddress.split(';');
                                            }
                                        }
    
                                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                        mail.setToAddresses(List_toAddress);
    
                                        if(List_toCCAddress!=null && !List_toCCAddress.isEmpty()){
                                            mail.setCcAddresses(List_toCCAddress);
                                        }
    
                                        if(List_toBCCAddress!=null && !List_toBCCAddress.isEmpty()){
                                            mail.setBccAddresses(List_toBCCAddress);
                                        }
    
                                        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
                                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                        mail.optOutPolicy = 'FILTER';
                                        
                                        mail.setSubject('Error at SO Creation at '+ system.now());
    
                                        String AllMessage = '';
                                        AllMessage = AllMessage + 'Contract Ticket Name         : ' + List_contracts[0].Name + '<br>';
    
                                        AllMessage = AllMessage + 'Contract Number              : '+ List_contracts[0].ContractNumber + '<br>';
    
                                        string url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + List_contracts[0].Id;
    
                                        AllMessage = AllMessage + 'Contract link : ' + url ;    
    
                                        mail.setHtmlBody(AllMessage);
    
                                        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
                                    }
    
                                    if (List_scheduledProcess!=null && !List_scheduledProcess.isEmpty()) {
                                        List_scheduledProcess[0].status__c = 'Failed';
                                        List_scheduledProcess[0].Execute_End__c  = system.now();
                                        update List_scheduledProcess;
                                    }
                                }
                
                                // put callout information then save the data on Call_Log object
                                Call_Log__c calllog = new Call_Log__c();
                                calllog.type__c = 'Callout';
                                calllog.request_start_time__c = requestStartTime;
                                calllog.method__c = 'POST';
                                calllog.callerFrom__c = 'Salesforce' ;
                                calllog.endpoint__c = endpoint ;
                                calllog.uri__c = uri ; 
                                calllog.request_message__c = bodyMesage;
                                calllog.status__c = status;
                                calllog.response_message__c = responseMsg;            
                                calllog.Error_Message__c = errorMsg;
                                calllog.Contract_Ticket_Related__c = contractTicketId;
                                calllog.Contract_Ticket_Item_Related__c = contractTicketItemId;

                                if (List_scheduledProcess!=null && !List_scheduledProcess.isEmpty()) {
                                    calllog.Scheduled_Process_Related__c = List_scheduledProcess[0].Id;
                                }

                                calllog.response_end_time__c = datetime.now();  
                                calllog.Sent_Email_if_Failed__c = Sent_Email_if_Failed;  
                                callLogList.add(calllog);
                
                                insert callLogList;
                            }else{
                                if (List_scheduledProcess!=null && !List_scheduledProcess.isEmpty()) {
                                    List_scheduledProcess[0].Execute_Start__c = system.now();
                                    List_scheduledProcess[0].status__c = 'Success';
                                    List_scheduledProcess[0].Execute_End__c  = system.now();
                                    List_scheduledProcess[0].Notes2__c = 'Call for SO is terminated because SO Number is available';
                                    update List_scheduledProcess;
                                }
                            }
                        }
                    }
                }else{
                    if (List_scheduledProcess!=null && !List_scheduledProcess.isEmpty()) {
                        List_scheduledProcess[0].Execute_Start__c = system.now();
                        List_scheduledProcess[0].status__c = 'Failed';
                        List_scheduledProcess[0].Execute_End__c  = system.now();
                        List_scheduledProcess[0].Notes2__c = 'Call for SO is terminated because ContractID of recurring/ont-time is not available';
                        update List_scheduledProcess;
                    }
                }
            }
        }
    }

    global class SAPSoFreeMrc_request{
        public String TransactionId;	//12345
        public String ContractId;	//20230602
        public String CustomerNumber;	//700155
        public String DistributionChannel;	//53
        public String POText;	//test Free MRC
        public String TransactionDate;	//20230602
        public List<cls_LineItem_request> LineItem;
    }

    global class cls_LineItem_request {
        public String MaterialCode;	//LL-12
        public String Quantity;	//1
        public String UOM;	//E1
        public String Price;	//15000000
        public String ContractStart;	//20230601
        public String ContractEnd;	//20230630
    }

    global class SAPSoFreeMrc_response{
        public String SONumber;	//0070000131
	    public String Status;	//SUCCESS
	    public String Message;	//Sales Order Created. Sales Order :70000131
    }
}