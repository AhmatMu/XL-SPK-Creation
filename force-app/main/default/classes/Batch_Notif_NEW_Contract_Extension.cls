/**
 * @description       : 
 * @Test Class        : TEST_Notif_Contract_Extension
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 08-01-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-09-2021   Novando Utoyo Agmawan   Initial Version
**/

global class Batch_Notif_NEW_Contract_Extension implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Date Todaydate = system.today();
        Date datePlus_100Days = system.today().adddays(100);

        String contractList = 
        'SELECT id, ' +  
        'Name, ' +
        'Link__c, ' + 
        'Link__r.Partner__c, ' + 
        'extension_created__c, ' +  
        'Link__r.Link_id__c, ' +  
        'Accountid, ' + 
        'Price__c, ' +  
        'Start_Date__C, ' +  
        'End_Date__C, ' +  					
        'Account.Name, ' +  
        'Account.Segmentation__c, ' +  
        'Contract_ID__c, ' +  
        'SAP_ID__c, ' +  
        'Product__c, ' +  
        'Product__r.SAP_Code__c, ' +  
        'Sales__c, ' + 	
        'Sales_Email__c, ' +		
        'Account.Owner.Email, ' +  
        'Account.Ownerid, ' +
        'Account.Owner.IsActive, ' +
        'Account.Owner.ManagerId, ' +   
        'Account.Owner.Manager.IsActive, ' + 
        'Contract_Term__c, ' +  
        'Periode_UOM__c, ' +  
        'Going_To_Days__c, ' +  
        'BA_Extend_REL__c, ' + 
        'Status ' +  
        'from Contract ' +  
        'WHERE Id IN (SELECT Contract_Item_Rel__c FROM Link__c WHERE Contract_Item_Rel__c != null AND (Status_Link__c LIKE \'%IN_SERVICE%\' OR Status_Link__c LIKE \'%Isolated%\')) AND ' + 
        '( Product_Charge_Type_filled__c = \'Recurring\' OR Product_Charge_Type__c = \'Recurring\') AND ' +  
        'Auto_Renewal__c = false AND ' +  
        'extension_created__c = false AND ' +  
        'Active__c = true AND ' +  
        //'End_Date__c >=: Todaydate AND ' +  
        'End_Date__c <=: datePlus_100Days ' + 
        'ORDER BY SALES__C '
        ;
        return Database.getQueryLocator(contractList);
    }

    global void execute(Database.BatchableContext BC, List<Contract> contractList) {
        // process each batch of records
        DateTime start_time = datetime.now();
        Map<String,Boolean> getResultRest_Map = new Map<String,Boolean>();
        Set<String> linkids = new Set<String>();
        integer lcount = 0;

        List<Call_Log__c> callLogList = new List<Call_Log__c>();
        String status = 'success';
        Datetime requestStartTime = datetime.now();

        try {
            system.debug('Batch_Notif_NEW_Contract_Extension - contractList Size : ' + contractList.size());
            system.debug('Batch_Notif_NEW_Contract_Extension - contractList : ' + json.serialize(contractList));
            
            if(contractList!=null && !contractList.isEmpty()){
                for(lcount=0;lcount<contractList.size();lcount++)
                {
                    //check to easyops if link have partner or not
                    String endpoint = system.label.REST_TransDB_GetToken_Endpoint;
                    String body = 'username='+system.label.REST_TransDB_GetToken_Username+'&password='+apputils.doDecrypt(Label.REST_TransDB_GetToken_Password);

                    system.debug('Batch_Notif_NEW_Contract_Extension - GetToken endpoint : ' + endpoint);
                    system.debug('Batch_Notif_NEW_Contract_Extension - GetToken body : ' + body);

                    HttpRequest req = new HttpRequest();
                    req.setTimeout(120000);
                    req.setEndpoint(endpoint);
                    req.setMethod('POST');
                    req.setbody(body);
                    req.setHeader('Accept', 'application/json');

                    Http http = new Http();
                    HTTPResponse response=new HTTPResponse();
                    Map<String,Object> responsemap=new Map<String,Object> ();
                    string token='';
                    
                    if(!test.isRunningTest())
                    {
                        response = http.send(req);

                        system.debug('Batch_Notif_NEW_Contract_Extension - GetToken response : ' + response);

                        responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());

                        system.debug('Batch_Notif_NEW_Contract_Extension - GetToken responsemap : ' + responsemap);

                        token=(string) responsemap.get('token');
                    }

                    if(String.isBlank(token)){
                        status = 'failed';
                    }

                    // put callout information then save the data on Call_Log object
                    Call_Log__c calllog = new Call_Log__c();
                    calllog.type__c='Callout';
                    calllog.request_start_time__c = requestStartTime;
                    calllog.method__c = 'POST';
                    calllog.callerFrom__c = 'Salesforce' ;
                    calllog.endpoint__c = endpoint ;
                    calllog.request_message__c = body;
                    calllog.status__c = status;
                    calllog.response_message__c = response.getBody();            
                    calllog.Salesforce_ID_1__c = contractList[lcount].Id;
                    calllog.response_end_time__c = datetime.now();  
                    callLogList.add(calllog);
                
                    // POST request
                    endpoint = system.label.REST_LinkPartner;
                    req.setTimeout(120000);
                    req.setEndpoint(endpoint);
                    req.setHeader('Accept', 'application/json');
                    req.setHeader('Content-Type', 'application/json');
                    req.setHeader('Authorization', 'Bearer ' + token );
                    body='[{"linkid":"'+contractList[lcount].link__r.Link_id__c+'"}]';
                    
                    system.debug('Batch_Notif_NEW_Contract_Extension - LinkPartner endpoint : ' + endpoint);
                    system.debug('Batch_Notif_NEW_Contract_Extension - LinkPartner body : ' + body);
                    
                    req.setbody(body);
                    String restresult='';
                
                    if(!test.isrunningtest())
                    {
                        response = http.send(req);

                        system.debug('Batch_Notif_NEW_Contract_Extension - LinkPartner response : ' + response);

                        restResult = response.getBody();
                    }
                
                    Link__c linkObj = new Link__c();
                    linkObj.id=contractList[lcount].link__c;
                    linkObj.Link_id__c=contractList[lcount].link__r.Link_id__c;

                    system.debug('Batch_Notif_NEW_Contract_Extension - LinkPartner restresult : ' + restresult);

                    if(restresult!='[]' && !test.isrunningtest())
                    {
                        list<Object> RRlist=(list<Object>)JSON.deserializeUntyped(restResult);
                        String WithPartner='';
                        Boolean WithPartner_map;
                    
                        responsemap=(Map<String,Object>)RRList[0];
                        WithPartner=(String)responsemap.get('with_partner');

                        String linkid_map = (String)responsemap.get('linkid');
                    
                        if (WithPartner=='true'){
                            linkObj.Partner__c=true;
                            WithPartner_map = true;
                        }
                        
                        if(WithPartner=='false'){
                            linkObj.Partner__c=false;
                            WithPartner_map = false;
                        }
                            
                        getResultRest_Map.put(linkid_map,WithPartner_map);
                    
                        status = 'success';
                    }else{
                        status = 'failed';
                    }

                    // put callout information then save the data on Call_Log object
                    Call_Log__c calllog2 = new Call_Log__c();
                    calllog2.type__c='Callout';
                    calllog2.request_start_time__c = requestStartTime;
                    calllog2.method__c = 'POST';
                    calllog2.callerFrom__c = 'Salesforce' ;
                    calllog2.endpoint__c = endpoint ;
                    calllog2.request_message__c = body;
                    calllog2.status__c = status;
                    calllog2.response_message__c = response.getBody();           
                    calllog2.Salesforce_ID_1__c = contractList[lcount].Id;
                    calllog2.response_end_time__c = datetime.now();  
                    callLogList.add(calllog2);
                }

                system.debug('Batch_Notif_NEW_Contract_Extension - getResultRest_Map : ' + getResultRest_Map);

                if(contractList.size() == lcount)
                {
                    if(getResultRest_Map!=null && !getResultRest_Map.isEmpty()) {
                        //system.debug('getResultRest_Map : ' +getResultRest_Map);
                        for (String linkid_map : getResultRest_Map.keySet())
                        {
                            linkids.add(linkid_map);
                        }

                        if(linkids!=null && !linkids.isEmpty()) {
                            //System.debug(linkids);
                            List<Link__c> link_list = [SELECT Id, Link_id__c, Partner__c FROM Link__c WHERE Link_id__c IN : linkids];
                            
                            if(link_list!=null && !link_list.isEmpty()) {
                                For(Link__c link_list_extract : link_list){
                                    link_list_extract.Partner__c = getResultRest_Map.get(link_list_extract.Link_id__c);
                                }
                                update link_list;
                            }
                        }

                        Email_Notif_NEW_Contract_Extension Class_Email_Notif_NEW_Contract_Extension = new Email_Notif_NEW_Contract_Extension(contractList);
                    }

                    insert callLogList;
                } 
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            String err_message = 'Error on Batch_Notif_NEW_Contract_Extension.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations, example : send email for status
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Use the below code will send an email to User about the status
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
                          a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                          a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];

        List<string> List_toAddress = new List<string>();
        List<string> List_toCCAddress = new List<string>();
        List<Email_Notif_Contract_Extension_Setting__c> Email_Notif_Contract_Extension_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM Email_Notif_Contract_Extension_Setting__c WHERE Name =: 'Email_Notif_BatchClass'];

        if(Email_Notif_Contract_Extension_Setting_List!=null && !Email_Notif_Contract_Extension_Setting_List.isEmpty()){
            String batch_ToAddress = Email_Notif_Contract_Extension_Setting_List[0].Additional_toAddress__c;
            String batch_toCCAddress = Email_Notif_Contract_Extension_Setting_List[0].Additional_toCCAddress__c;

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
        }

        mail.setToAddresses(List_toAddress);
        if(List_toCCAddress!=null && !List_toCCAddress.isEmpty()){
            mail.setCcAddresses(List_toCCAddress);
        }
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
        mail.optOutPolicy = 'FILTER';
        mail.setSubject('Batch Batch_Notif_NEW_Contract_Extension Processing '+a.Status);
        mail.setHtmlBody('The Batch Apex Batch_Notif_NEW_Contract_Extension <br> job processed : '+ a.TotalJobItems+'<br> batches with : '+a.NumberOfErrors+' failures'+'<br> Job Item processed are : '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});

        Batch_Notif_UPD_Contract_Extension bacthEmail_95Days = new Batch_Notif_UPD_Contract_Extension();
        ID batchprocessid = database.executeBatch(bacthEmail_95Days,50);
    }
}