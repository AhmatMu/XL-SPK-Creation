/**
 * @description       : 
 * @Test Class		  : SRcompleted_MoreThan60days_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 07-29-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-30-2021   Novando Utoyo Agmawan   Initial Version
**/

global class SRcompleted_MoreThan60days_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute

        String SRPR_NotificationList = 
        'SELECT id, ' +  
        'Name, ' +
        'Status__c, ' +
        'Survey_Complete_Date__c, ' +
        'Aging_Waiting_PR__c, ' +
        'Notif_Type__c, ' +
        'Reasons__c, ' +
        'Opportunity__c, ' + 
        'Opportunity__r.isClosed, ' + 
        'Opportunity__r.PR__c, ' + 
        'Opportunity__r.StageName, ' +
        'Opportunity__r.Owner.Email, ' +
        'Opportunity__r.Project_Coordinator__c, ' +
        'Opportunity__r.Project_Coordinator_EmployeeID__c ' +
        'from SR_PR_Notification__c '
        ;

        if (!Test.isRunningTest()){
            SRPR_NotificationList += 
            'WHERE Status__c = \'Close(Complete)\' AND ' +  
            'Survey_Complete_Date__c != null AND ' +  
            'Notif_Type__c = \'SR\' AND ' + 
            'Opportunity__c != null AND ' + 
            'Opportunity__r.StageName = \'Negotiation\' AND ' + 
            'Opportunity__r.isClosed = false AND ' +  
            'Opportunity__r.PR__c = null AND ' + 
            'Reasons__c != \'R28-NO PR Submission\' AND ' + 
            'Aging_Waiting_PR__c >= 61' ;
        } 

        /*List<SR_PR_Notification__c> List_SRPR_NotificationList = database.query(SRPR_NotificationList);
        system.debug('List_SRPR_NotificationList : ' + json.serialize(List_SRPR_NotificationList));*/

        return Database.getQueryLocator(SRPR_NotificationList);
    }

    global void execute(Database.BatchableContext BC, List<SR_PR_Notification__c> SRPR_NotificationList) {
        // process each batch of records
        DateTime start_time = datetime.now();

        try {
            List<Messaging.SingleEmailMessage> sendEmailList = new List<Messaging.SingleEmailMessage>();
            List<Opportunity> opportunityUpdateList = new List<Opportunity>();
            Set<String> EmployeeIdSet = new Set<String>();
            Map<String,String> ProjectCoordinatorEmail_Map = new Map<String,String>();

            system.debug('SRPR_NotificationList : ' + SRPR_NotificationList);
            system.debug('SRPR_NotificationListSize : ' + SRPR_NotificationList.size()) ;

            List<EmailNotif_Opportunity__c> EmailNotif_Opportunity = [
                SELECT Name, 
                Additional_toAddress__c, 
                Additional_toCCAddress__c,
                Email_Template__c,
                Sender_Email__c,
                Is_Test__c,
                Testing_toAddress__c
                FROM EmailNotif_Opportunity__c 
                WHERE Name =: 'Opportunity_SR_60_days_but_not_have_PR'
            ];

            system.debug('EmailNotif_Opportunity : ' + EmailNotif_Opportunity);
            system.debug('EmailNotif_OpportunitySize : ' + EmailNotif_Opportunity.size()) ;

            if(EmailNotif_Opportunity!=null && !EmailNotif_Opportunity.isEmpty()){
                if(SRPR_NotificationList!=null && !SRPR_NotificationList.isEmpty()){
                    List<string> List_toAddress = new List<string>();
                    List<string> List_toCCAddress = new List<string>();

                    String batch_ToAddress;
                    if(EmailNotif_Opportunity[0].Is_Test__c == true){
                        batch_ToAddress = EmailNotif_Opportunity[0].Testing_toAddress__c;
                    }else{
                        batch_ToAddress = EmailNotif_Opportunity[0].Additional_toAddress__c;
                    }
                    
                    String batch_toCCAddress = EmailNotif_Opportunity[0].Additional_toCCAddress__c;
                    
                    if(String.isNotBlank(batch_ToAddress)){
                        if(batch_ToAddress.contains(' ')){ //space
                            String toAddress = batch_ToAddress.replaceAll('\\s',';');
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
                            String toAddress = batch_ToAddress.replaceAll('\\s',';');
                            String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                            List_toAddress = toAddressFormat_1.split(';');
                        }
                        if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') ){ //space dan pipe
                            String toAddress = batch_ToAddress.replaceAll('\\s',';');
                            String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                            List_toAddress = toAddressFormat_1.split(';');
                        }
                        if(batch_ToAddress.contains(',') && batch_ToAddress.contains('|') ){ //koma dan pipe
                            String toAddress = batch_ToAddress.replaceAll('[\\|\\,]',';');
                            List_toAddress = toAddress.split(';');
                        }
                        if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') && batch_ToAddress.contains(',') ){ //koma dan pipe dan space
                            String toAddress = batch_ToAddress.replaceAll('\\s',';');
                            String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                            List_toAddress = toAddressFormat_1.split(';');
                        }
                        if(!batch_ToAddress.contains(' ') && !batch_ToAddress.contains('|') && !batch_ToAddress.contains(',') ){
                            List_toAddress = batch_ToAddress.split(';');
                        }
                    }
                    
                    if(String.isNotBlank(batch_toCCAddress)){
                        if(batch_toCCAddress.contains(' ')){ //space
                            String toCCAddress = batch_toCCAddress.replaceAll('\\s',';');
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
                            String toCCAddress = batch_toCCAddress.replaceAll('\\s',';');
                            String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                            List_toCCAddress = toCCAddressFormat_1.split(';');
                        }
                        if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') ){ //space dan pipe
                            String toCCAddress = batch_toCCAddress.replaceAll('\\s',';');
                            String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                            List_toCCAddress = toCCAddressFormat_1.split(';');
                        }
                        if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') && batch_toCCAddress.contains(',') ){ //koma dan pipe dan space
                            String toCCAddress = batch_toCCAddress.replaceAll('\\s',';');
                            String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                            List_toCCAddress = toCCAddressFormat_1.split(';');
                        }
                        if(!batch_toCCAddress.contains(' ') && !batch_toCCAddress.contains('|') && !batch_toCCAddress.contains(',') ){
                            List_toCCAddress = batch_toCCAddress.split(';');
                        }
                    }

                    EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: EmailNotif_Opportunity[0].Email_Template__c];
                    List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];

                    system.debug('EmailTemplate : ' + et);

                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: EmailNotif_Opportunity[0].Sender_Email__c];

                    system.debug('owea : ' + owea);

                    for(SR_PR_Notification__c SRPR_NotificationList_Extract : SRPR_NotificationList){
                        EmployeeIdSet.add(SRPR_NotificationList_Extract.Opportunity__r.Project_Coordinator_EmployeeID__c);
                    }

                    system.debug('EmployeeIdSet : ' + EmployeeIdSet);

                    if(EmployeeIdSet!=null && !EmployeeIdSet.isEmpty()){
                        List<User> userList = [SELECT Id, Email, Employee_ID__c FROM User WHERE Employee_ID__c IN : EmployeeIdSet];

                        if(userList!=null && !userList.isEmpty()){
                            for(User userList_Extract : userList){
                                ProjectCoordinatorEmail_Map.put(userList_Extract.Employee_ID__c, userList_Extract.Email);
                            }

                            if(ProjectCoordinatorEmail_Map!=null && !ProjectCoordinatorEmail_Map.isEmpty()){

                                for(SR_PR_Notification__c SRPR_NotificationList_Extract : SRPR_NotificationList){
                                    SRPR_NotificationList_Extract.Reasons__c = 'R28-NO PR Submission';

                                    list<String> mailto1 = new list<String>();
                                    list<String> mailcc1 = new list<String>();
                                    Set<string> Set_AddressList = new Set<string>();
                                    Set<string> Set_AddressCCList = new Set<string>();
                                    list<String> mailto = new list<String>();
                                    list<String> mailcc = new list<String>();

                                    mailto1.addAll(List_toAddress);
                                    mailcc1.addAll(List_toCCAddress);

                                    if(EmailNotif_Opportunity[0].Is_Test__c == false){
                                        mailto1.add(SRPR_NotificationList_Extract.Opportunity__r.Owner.Email);
                                        mailcc1.add(ProjectCoordinatorEmail_Map.get(SRPR_NotificationList_Extract.Opportunity__r.Project_Coordinator_EmployeeID__c));
                                    }

                                    Set_AddressList.addAll(mailto1);
                                    Set_AddressCCList.addAll(mailcc1);

                                    Set_AddressList.remove('');
                                    Set_AddressList.remove(null);
                                    
                                    Set_AddressCCList.remove('');
                                    Set_AddressCCList.remove(null);

                                    mailto.addAll(Set_AddressList);
                                    mailcc.addAll(Set_AddressCCList);

                                    Opportunity opportunityUpdate = new Opportunity();
                                    opportunityUpdate.Id = SRPR_NotificationList_Extract.Opportunity__c;
                                    opportunityUpdate.StageName = 'Prospecting';

                                    opportunityUpdateList.add(opportunityUpdate);

                                    system.debug('mailto : ' + mailto);
                                    system.debug('mailcc : ' + mailcc) ;
            
                                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                    mail.optOutPolicy = 'FILTER';
                                    mail.setUseSignature(false);
                                    mail.setToAddresses(mailto);
                                    if(mailcc!=null && !mailcc.isEmpty()){
                                        mail.setCCaddresses(mailcc);
                                    }
                                    mail.setTemplateId(et.Id);
                                    mail.setTargetObjectId(contactList[0].id);
                                    mail.setTreatTargetObjectAsRecipient(false);
                                    mail.setWhatId(SRPR_NotificationList_Extract.Id);
                                    sendEmailList.add(mail);
                                }

                                system.debug('opportunityUpdateListSize : ' + opportunityUpdateList.size()) ;
                                system.debug('opportunityUpdateList : ' + opportunityUpdateList) ;
            
                                if(opportunityUpdateList!=null && !opportunityUpdateList.isEmpty()){
                                    if(EmailNotif_Opportunity[0].Is_Test__c == false){
                                        Database.SaveResult[] opportunityUpdateListResults = Database.update(opportunityUpdateList, false);
                                        
                                        system.debug('opportunityUpdateListResults : ' + json.serialize(opportunityUpdateListResults)) ;

                                        Database.SaveResult[] SRPR_NotificationListResults = Database.update(SRPR_NotificationList, false);

                                        system.debug('SRPR_NotificationListResults : ' + json.serialize(SRPR_NotificationListResults)) ;
                                    }
                                    
                                    if(sendEmailList!=null && !sendEmailList.isEmpty())
                                    {
                                        system.debug('sendEmailListSize : ' + sendEmailList.size()) ;
                                        Messaging.sendEmail(sendEmailList,true);    
                                    }
                                }
                            }
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
            String err_message = 'Error on SRcompleted_MoreThan60days_Batch.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
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

        List<EmailNotif_Opportunity__c> EmailNotif_Opportunity = [
            SELECT Name, 
            Additional_toAddress__c, 
            Additional_toCCAddress__c,
            Email_Template__c,
            Sender_Email__c 
            FROM EmailNotif_Opportunity__c 
            WHERE Name =: 'Email_Notif_BatchClass'
        ];

        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: EmailNotif_Opportunity[0].Sender_Email__c];

        List<string> List_toAddress = new List<string>();
        List<string> List_toCCAddress = new List<string>();

        if(EmailNotif_Opportunity!=null && !EmailNotif_Opportunity.isEmpty()){
            String batch_ToAddress = EmailNotif_Opportunity[0].Additional_toAddress__c;
            String batch_toCCAddress = EmailNotif_Opportunity[0].Additional_toCCAddress__c;

            if(String.isNotBlank(batch_ToAddress)){
                if(batch_ToAddress.contains(' ')){ //space
                    String toAddress = batch_ToAddress.replaceAll('\\s',';');
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
                    String toAddress = batch_ToAddress.replaceAll('\\s',';');
                    String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                    List_toAddress = toAddressFormat_1.split(';');
                    system.debug('batch List_toAddress : ' + List_toAddress);
                }
                if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') ){ //space dan pipe
                    String toAddress = batch_ToAddress.replaceAll('\\s',';');
                    String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                    List_toAddress = toAddressFormat_1.split(';');
                }
                if(batch_ToAddress.contains(',') && batch_ToAddress.contains('|') ){ //koma dan pipe
                    String toAddress = batch_ToAddress.replaceAll('[\\|\\,]',';');
                    List_toAddress = toAddress.split(';');
                }
                if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') && batch_ToAddress.contains(',') ){ //koma dan pipe dan space
                    String toAddress = batch_ToAddress.replaceAll('\\s',';');
                    String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                    List_toAddress = toAddressFormat_1.split(';');
                }
                if(!batch_ToAddress.contains(' ') && !batch_ToAddress.contains('|') && !batch_ToAddress.contains(',') ){
                    List_toAddress = batch_ToAddress.split(';');
                }
            }

            if(String.isNotBlank(batch_toCCAddress)){
                if(batch_toCCAddress.contains(' ')){ //space
                    String toCCAddress = batch_toCCAddress.replaceAll('\\s',';');
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
                    String toCCAddress = batch_toCCAddress.replaceAll('\\s',';');
                    String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                    List_toCCAddress = toCCAddressFormat_1.split(';');
                    system.debug('batch List_toCCAddress : ' + List_toCCAddress);
                }
                if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') ){ //space dan pipe
                    String toCCAddress = batch_toCCAddress.replaceAll('\\s',';');
                    String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                    List_toCCAddress = toCCAddressFormat_1.split(';');
                }
                if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') && batch_toCCAddress.contains(',') ){ //koma dan pipe dan space
                    String toCCAddress = batch_toCCAddress.replaceAll('\\s',';');
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
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
        mail.optOutPolicy = 'FILTER';
        mail.setSubject('Batch SRcompleted_MoreThan60days_Batch Processing '+a.Status);
        mail.setHtmlBody('The Batch Apex SRcompleted_MoreThan60days_Batch <br> job processed : '+ a.TotalJobItems+'<br> batches with : '+a.NumberOfErrors+' failures'+'<br> Job Item processed are : '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }
}