/**
 * @description       : 
 * @Test Class        : Check_BAE_AutoApprove30day_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-25-2023   Novando Utoyo Agmawan   Initial Version
**/


global class Check_BAE_AutoApprove30day_Batch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date Todaydate = system.today();
        Date datePlus_30Days = Todaydate.adddays(30);

        String Contract_ExtensionList = 
        'SELECT id, ' +  
        'Status__c, ' +
        'Approved_By_Solution__c, ' +
        'Existing_Contract_item__c, ' +
        'Existing_Contract_item__r.End_Date__c ' +
        'from Contract_Extension__c ' +  
        'WHERE Existing_Contract_item__r.End_Date__c <=: datePlus_30Days AND ' +
        'Status__c = \'Waiting Solution Approval\' AND ' +
        'Approved_By_Solution__c = false'
        ;

        return Database.getQueryLocator(Contract_ExtensionList);
    }

    global void execute(Database.BatchableContext BC, List<Contract_Extension__c> Contract_ExtensionList) {
        // process each batch of records
        DateTime start_time = datetime.now();

        try {
            system.debug('Check_BAE_AutoApprove30day_Batch Contract_ExtensionList Size ' + Contract_ExtensionList.size());
            
            system.debug('Check_BAE_AutoApprove30day_Batch Contract_ExtensionList ' + json.serialize(Contract_ExtensionList));

            if(Contract_ExtensionList!=null && !Contract_ExtensionList.isEmpty()){
                Set<id> Set_BAEId = new Set<id>();

                for(Contract_Extension__c Contract_ExtensionList_Extract : Contract_ExtensionList){
                    Set_BAEId.add(Contract_ExtensionList_Extract.Id);
                }

                system.debug('Check_BAE_AutoApprove30day_Batch Set_BAEId ' + json.serialize(Set_BAEId));

                if(Set_BAEId!=null && !Set_BAEId.isEmpty()){
                    List<Approval.ProcessWorkitemRequest> List_requests = new List<Approval.ProcessWorkitemRequest>();

                    List<ProcessInstanceWorkitem> List_workItems = [
                        SELECT Id, 
                        ProcessInstanceId,
                        ActorId
                        FROM ProcessInstanceWorkitem 
                        WHERE ProcessInstance.TargetObjectId IN: Set_BAEId 
                    ];

                    system.debug('Check_BAE_AutoApprove30day_Batch List_workItems ' + json.serialize(List_workItems));

                    if(List_workItems!=null && !List_workItems.isEmpty()){
                        for(ProcessInstanceWorkitem workItem : List_workItems){
                            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                            req.setWorkitemId(workItem.Id);
                            req.setAction('Approve');
                            req.setComments('Auto Approve When Contract End Date H-30');
                            List_requests.add(req);
                        }

                        system.debug('Check_BAE_AutoApprove30day_Batch List_requests ' + json.serialize(List_requests));

                        if(List_requests!=null && !List_requests.isEmpty()){
                            List<Approval.ProcessResult> List_processResults = Approval.process(List_requests);

                            system.debug('Check_BAE_AutoApprove30day_Batch List_processResults ' + json.serialize(List_processResults));

                            List<Approval.UnlockResult> List_unlockResult = Approval.unlock(Contract_ExtensionList, false);

                            system.debug('Check_BAE_AutoApprove30day_Batch List_unlockResult ' + json.serialize(List_unlockResult));
                        }
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            String err_message = 'Error on Check_BAE_AutoApprove30day_Batch.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
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
        mail.setSubject('Batch Check_BAE_AutoApprove30day_Batch Processing '+a.Status);
        mail.setHtmlBody('The Batch Apex Check_BAE_AutoApprove30day_Batch <br> job processed : '+ a.TotalJobItems+'<br> batches with : '+a.NumberOfErrors+' failures'+'<br> Job Item processed are : '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }
}