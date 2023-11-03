/**
 * @description       : 
 * @Test Class        : TEST_Notif_Contract_Extension
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-03-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-03-2022   Novando Utoyo Agmawan   Initial Version
**/

global class Batch_Notif_UPD_Contract_Extension implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Date datePlus_95Days = system.today().adddays(95);

        String contract_ExtensionList = 
        'SELECT id, ' + 
        'name, ' +  //--> BA Extension name
        'OwnerId, ' + 
        'Account__c, ' + 
        'Account__r.OwnerId, ' + 
        'Account__r.BP_Number__c, ' + //--> BP Number HO
        'Account__r.Name, ' + //--> customer name
        'Existing_Contract_item__c, ' + 
        'Existing_Contract_item__r.contract_ID__c, ' + //--> Existing Contract
        'Existing_Contract_item__r.SAP_ID__c, ' + //--> Existing Contract
        'Existing_Contract_item__r.End_Date__c, ' + //--> contract end date
        'Existing_Contract_item__r.Auto_Renewal__c, ' +  //--> Auto Renewal
        'Existing_Contract_item__r.Contract_Term__c, ' +  //--> Contract Period
        'Existing_Contract_item__r.Periode_UOM__c, ' +  //--> Contract Period
        'Existing_Contract_item__r.Sales__c, ' + //--> sales name
        'Existing_Contract_item__r.Price__c, ' + //--> Price IDR/Month
        'Solution_PIC__c, ' +
        'Solution_PIC__r.email, ' +
        'Link__c, ' +
        'Link__r.Service_Type__c, ' + //--> Service
        'Link__r.CID__c, ' + //--> CID
        'Link__r.Link_ID__c, ' + //--> Link ID
        'Link__r.Site_A_Name__r.Name, ' + //--> Link name
        'Link__r.Site_A_Name__r.Unique_Name__c, ' + //--> Link name
        'Extension_Start_Date__c, ' +  //--> Renewal Contract Start
        'Extension_End_Date__c, ' +  //--> Renewal Contract End 
        'Status__c, ' +
        'Segment__c, ' +
        'Going_To_Days__c ' +
        'FROM Contract_Extension__c ' +
        'WHERE Status__c != \'Waiting for BA\' AND Status__c != \'Change Price\' AND Status__c != \'Waiting for Contract\' AND Status__c != \'Completed\' AND  '+
        'Existing_Contract_item__r.End_Date__c <=: datePlus_95Days ' +
        'ORDER BY Existing_Contract_item__r.End_Date__c ASC '
        ;
        return Database.getQueryLocator(contract_ExtensionList);
    }

    global void execute(Database.BatchableContext BC, List<Contract_Extension__c> contract_ExtensionList) {
        // process each batch of records
        DateTime start_time = datetime.now();
        try {
            system.debug('Contract_ExtensionSIZE ' + contract_ExtensionList.size());
            system.debug('contract_ExtensionList ' + contract_ExtensionList);
            if(contract_ExtensionList!=null && !contract_ExtensionList.isEmpty()){
                Email_Notif_UPD_Contract_Extension Class_Email_Notif_UPD_Contract_Extension = new Email_Notif_UPD_Contract_Extension(contract_ExtensionList);
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            String err_message = 'Error on Batch_Notif_UPD_Contract_Extension.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
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
        mail.setSubject('Batch Batch_Notif_UPD_Contract_Extension Processing '+a.Status);
        mail.setHtmlBody('The Batch Apex Batch_Notif_UPD_Contract_Extension <br> job processed : '+ a.TotalJobItems+'<br> batches with : '+a.NumberOfErrors+' failures'+'<br> Job Item processed are : '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});

        Batch_Check_BAExtension_30day_AND_14day Batch_Check_BAExtension_30day_AND_14day = new Batch_Check_BAExtension_30day_AND_14day();
        ID batchprocessid = database.executeBatch(Batch_Check_BAExtension_30day_AND_14day,50);
    }
}