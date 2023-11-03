/**
 * @description       : 
 * @Test Class		  : TEST_Notif_TerminationNonAutoRenewal
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   07-29-2022   Novando Utoyo Agmawan   Initial Version
**/

global class Batch_Notif_TerminationNonAutoRenewal implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Date datePlus_14Days = system.today().adddays(14);
        Date datePlus_30Days = system.today().adddays(30);
        Date datePlus_60Days = system.today().adddays(60);
        Date datePlus_90Days = system.today().adddays(90);
        Date datePlus_1Days = system.today().adddays(1);

        String contract_ExtensionList = 
        'SELECT id, ' + 
        'name, ' +  //--> BA Extension name
        'BA_Print__c, ' + 
        'BA_Print__r.Name, ' +
        'BA_Print__r.Email, ' +  // --> Email PIC BA Print
        'Account__c, ' + 
        'Account__r.Name, ' + //--> customer name
        'Existing_Contract_item__c, ' + 
        'Existing_Contract_item__r.End_Date__c, ' + //--> contract end date
        'Existing_Contract_item__r.Product__r.Name, ' + //--> product name
        'Link__c, ' +
        'Link__r.Link_ID__c, ' + //--> LID
        'Link__r.Site_A_Name__r.Name, ' + //--> site name
        'Link__r.Site_A_Name__r.Unique_Name__c, ' + //--> site name
        'Account_Manager__c, ' +
        'Account_Manager__r.Name, ' +
        'Account_Manager__r.Email, ' +
        'Account_Manager__r.ManagerId, ' + 
        'Account_Manager__r.Manager_of_Manager__c, ' +
        'Status__c, ' +
        'Complete_Status__c, ' +
        'BAP__c, ' +
        'BAP__r.Name, ' +
        'BAP__r.BAP_No__c, ' +
        'Email_Tenar_Count__c, ' +
        'Going_To_Days__c ' +
        'FROM Contract_Extension__c ' +
        'WHERE ( Status__c = \'Fill BA Recipient and BA Print\' OR Status__c = \'Waiting Solution Approval\' OR Status__c = \'Waiting for BA\' OR Status__c = \'Completed\' ) ' +
        'AND Complete_Status__c != \'Done\' ' +
        'AND ( Existing_Contract_item__r.End_Date__c =: datePlus_14Days OR ' +
        'Existing_Contract_item__r.End_Date__c =: datePlus_30Days OR ' +
        'Existing_Contract_item__r.End_Date__c =: datePlus_60Days OR ' +
        'Existing_Contract_item__r.End_Date__c =: datePlus_90Days OR ' +
        'Existing_Contract_item__r.End_Date__c =: datePlus_1Days ) '
        ;

        return Database.getQueryLocator(contract_ExtensionList);
    }

    global void execute(Database.BatchableContext BC, List<Contract_Extension__c> contract_ExtensionList) {
        // process each batch of records
        DateTime start_time = datetime.now();
        try {
            if(contract_ExtensionList!=null && !contract_ExtensionList.isEmpty()){
                Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(contract_ExtensionList,false);
            }
        }catch (Exception e) {
            String err_message = 'Error on Batch_Notif_TerminationNonAutoRenewal.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
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
        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c WHERE Name =: 'Email_Notif_BatchClass'];

        if(EmailTerminationNonAutoRenewal_Setting_List!=null && !EmailTerminationNonAutoRenewal_Setting_List.isEmpty()){
            String batch_ToAddress = EmailTerminationNonAutoRenewal_Setting_List[0].Additional_toAddress__c;
            String batch_toCCAddress = EmailTerminationNonAutoRenewal_Setting_List[0].Additional_toCCAddress__c;

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
        mail.setSubject('Batch Batch_Notif_TerminationNonAutoRenewal Processing '+a.Status);
        mail.setHtmlBody('The Batch Apex Batch_Notif_TerminationNonAutoRenewal <br> job processed : '+ a.TotalJobItems+'<br> batches with : '+a.NumberOfErrors+' failures'+'<br> Job Item processed are : '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }

}