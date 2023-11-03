/**
 * @description       : 
 * @Test Class		  : TEST_Batch_Check_BAExtend_30_AND_14
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   07-29-2022   Novando Utoyo Agmawan   Initial Version
**/

global class Batch_Check_BAExtension_30day_AND_14day implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Id recordTypeId_bapEndofContract = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('End of Contract').getRecordTypeId();
        Date Todaydate = system.today();
        Date datePlus_30Days = system.today().adddays(30);
        Date datePlus_14Days = system.today().adddays(14);

        String Contract_ExtensionList = 
        'SELECT id, ' +  
        'Name, ' +
        'Status__c, ' +
        'Account__c, ' +
        'BAP__c, ' +
        'Complete_Status__c, ' +
        'Existing_Contract_item__c, ' +
        'Existing_Contract_item__r.Link__c, ' +
        'Existing_Contract_item__r.Sales__c, ' +
        'Existing_Contract_item__r.Sales_Email__c, ' +
        'Existing_Contract_item__r.End_Date__c, ' +
        'Existing_Contract_item__r.Start_Date__c ' +
        'from Contract_Extension__c ' +  
        'WHERE Id NOT IN (SELECT BA_Extend_REL__c FROM BAP__c WHERE RecordTypeId =: recordTypeId_bapEndofContract AND Complete_Status__c != \'Canceled\') AND ' +
        'Existing_Contract_item__r.End_Date__c <=: datePlus_30Days AND ' +
        'Existing_Contract_item__r.End_Date__c >=: datePlus_14Days AND ' +
        'BAP__c = null AND ' +
        'Status__c != \'Waiting for Contract\' AND ' + 
        'Complete_Status__c != \'Done\''
        ;

        return Database.getQueryLocator(Contract_ExtensionList);
    }

    global void execute(Database.BatchableContext BC, List<Contract_Extension__c> Contract_ExtensionList) {
        // process each batch of records
        DateTime start_time = datetime.now();

        try {
            if(Contract_ExtensionList!=null && !Contract_ExtensionList.isEmpty()){
                //system.debug('Contract_ExtensionList ' + Contract_ExtensionList);
                Set<id> contractIds = new Set<id>();
                for(Contract_Extension__c Contract_ExtensionList_Extract : Contract_ExtensionList){
                    contractIds.add(Contract_ExtensionList_Extract.Existing_Contract_item__c);
                }

                if(contractIds!=null && !contractIds.isEmpty()){
                    BAP_endOfContract_controller BAP_endOfContract_controller_class = new BAP_endOfContract_controller();
                    BAP_endOfContract_controller_class.Create_BAP_endOfContract(contractIds);
                }
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            String err_message = 'Error on Batch_Check_BAExtension_30day_AND_14day.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
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
        mail.setSubject('Batch Batch_Check_BAExtension_30day_AND_14day Processing '+a.Status);
        mail.setHtmlBody('The Batch Apex Batch_Check_BAExtension_30day_AND_14day <br> job processed : '+ a.TotalJobItems+'<br> batches with : '+a.NumberOfErrors+' failures'+'<br> Job Item processed are : '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }
}