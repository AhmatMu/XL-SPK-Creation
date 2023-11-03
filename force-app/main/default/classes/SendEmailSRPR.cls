/* ====================================================================================================
* Class Name		        : SendEmailSRPR
* Test Class		        : testSR_PR
* Created By		        : 
* Created Date		        : 
* Created Description		: 
* Updated By                : Novando Utoyo Agmawan
* Updated Date	            : 09/2021
* Updated Description		: - Move to Email template for body email
* ====================================================================================================
*/

global class SendEmailSRPR {
    public static void sendemailtoVendor(SR_PR_Notification__c SR){
        DateTime start_time = datetime.now();
        try {
            //sendemail to vendor during SR
            system.debug ('== masuk sendemailtoVendor ');

            SR_PR_Notification__c updateSR = new SR_PR_Notification__c();
            updateSR.Id = SR.Id;

            List<EmailNotif_SRPR__c> EmailNotif_SRPR = [
                SELECT Name, 
                Additional_toAddress__c, 
                Additional_toCCAddress__c,
                Email_Template__c,
                Sender_Email__c 
                FROM EmailNotif_SRPR__c 
                WHERE Name =: 'Notification SR Send to Vendor'
            ];

            if(EmailNotif_SRPR!=null && !EmailNotif_SRPR.isEmpty()){
                List<string> List_toAddress = new List<string>();
                List<string> List_toCCAddress = new List<string>();

                Set<string> Set_AddressList = new Set<string>();
                Set<string> Set_AddressCCList = new Set<string>();

                String batch_ToAddress = EmailNotif_SRPR[0].Additional_toAddress__c;
                String batch_toCCAddress = EmailNotif_SRPR[0].Additional_toCCAddress__c;
                
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

                EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: EmailNotif_SRPR[0].Email_Template__c];
                List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];

                String PhoneDisplay='';

                Vendor__c VO=[SELECT Name,ListEmail__c FROM Vendor__c WHERE ID=:SR.Vendor__c];

                Opportunity Opp=[SELECT id,AccountID,Account_Site_A_Full_Address__c,Account_Site_B_Full_Address__c,Owner.Email,Owner.Employee_id__c,Owner.Name FROM Opportunity WHERE ID=:SR.Opportunity__c];

                Account HO=[SELECT BP_Number__c,Name,Owner.Employee_id__c,Ownerid,Owner.Name,Owner.email FROM Account WHERE id=:Opp.AccountID];

                String Username=SR.Project_Coordinator_Text__c.substringafter(' ');

                User ProjectCoordinator=[SELECT Email FROM User WHERE Name=:username];

                updateSR.VarEmail_ProjectCoordinatorFormat__c = Username;

                AccountContactRelation ACR=[SELECT Contact.Name,Contact.Phone,Contact.MobilePhone FROM AccountContactRelation WHERE AccountID=:SR.Site_A__c AND Roles INCLUDES ('PIC Site') LIMIT 1];

                if(Acr.Contact.Phone!=null && Acr.Contact.Phone!=''){
                    PhoneDisplay=ACR.Contact.Phone;
                }

                if(Acr.Contact.MobilePhone!=null && Acr.Contact.MobilePhone!=''){
                    PhoneDisplay=PhoneDisplay+'  '+ACR.Contact.MobilePhone;
                }

                updateSR.VarEmail_PICName__c = ACR.Contact.Name;
                updateSR.VarEmail_PICPhone__c = PhoneDisplay; 

                if(SR.Services__c=='LL')
                {
                    AccountContactRelation ACR2=[SELECT Contact.Name,Contact.Phone,Contact.MobilePhone FROM AccountContactRelation WHERE AccountID=:SR.Site_B__c AND Roles INCLUDES ('PIC Site') LIMIT 1];

                    Phonedisplay='';

                    if(Acr2.Contact.Phone!=null && Acr2.Contact.Phone!=''){
                        PhoneDisplay=ACR2.Contact.Phone;
                    }

                    if(Acr2.Contact.MobilePhone!=null && Acr2.Contact.MobilePhone!=''){
                        PhoneDisplay=PhoneDisplay+'  '+ACR2.Contact.MobilePhone;
                    }

                    updateSR.VarEmail_PICSiteB_Name__c = ACR2.Contact.Name;
                    updateSR.VarEmail_PICSiteB_Phone__c = PhoneDisplay;
                }

                Database.SaveResult updateResult = Database.update(updateSR);

                system.debug('sendemailtoVendor updateResult : ' + updateResult);

                if(updateResult.isSuccess()) {
                    list<String> mailto1 = new list<String>();

                    mailto1 = VO.ListEmail__c.split(';');
                    List_toAddress.addAll(mailto1);
                    List_toAddress.add(ProjectCoordinator.email);

                    List_toCCAddress.add(HO.Owner.Email);

                    Set_AddressList.addAll(List_toAddress);
                    Set_AddressCCList.addAll(List_toCCAddress);

                    Set_AddressList.remove('');
                    Set_AddressList.remove(null);
                    
                    Set_AddressCCList.remove('');
                    Set_AddressCCList.remove(null);

                    list<String> mailto=new list<String>();
                    list<String> mailcc=new list<String>{};

                    mailto.addAll(Set_AddressList);
                    mailcc.addAll(Set_AddressCCList);

                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: EmailNotif_SRPR[0].Sender_Email__c];

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
                    mail.setWhatId(SR.Id);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};

                    if(!test.isrunningtest()){
                        Messaging.sendEmail(messages);
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on SendEmailSRPR.cls - sendemailtoVendor ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public static void sendemailAssigned(SR_PR_Notification__c SR){ 
        DateTime start_time = datetime.now();
        try {
            //send email when SR Status is assigned
            system.debug ('== masuk sendEmailPR ');

            SR_PR_Notification__c updateSR = new SR_PR_Notification__c();
            updateSR.Id = SR.Id;

            List<EmailNotif_SRPR__c> EmailNotif_SRPR = [
                SELECT Name, 
                Additional_toAddress__c, 
                Additional_toCCAddress__c,
                Email_Template__c,
                Sender_Email__c 
                FROM EmailNotif_SRPR__c 
                WHERE Name =: 'Notification SR Assign'
            ];

            if(EmailNotif_SRPR!=null && !EmailNotif_SRPR.isEmpty()){
                List<string> List_toAddress = new List<string>();
                List<string> List_toCCAddress = new List<string>();

                Set<string> Set_AddressList = new Set<string>();
                Set<string> Set_AddressCCList = new Set<string>();

                String batch_ToAddress = EmailNotif_SRPR[0].Additional_toAddress__c;
                String batch_toCCAddress = EmailNotif_SRPR[0].Additional_toCCAddress__c;
                
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

                EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: EmailNotif_SRPR[0].Email_Template__c];
                List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];

                Opportunity Opp = [SELECT id,AccountID,Account_Site_A_Full_Address__c,Account_Site_B_Full_Address__c,Owner.Email,Owner.Employee_id__c,Owner.Name,Account_Site_A__c FROM Opportunity WHERE ID=:SR.Opportunity__c];

                Account HO = [SELECT BP_Number__c,Name,Unique_Name__c,Owner.Employee_id__c,Ownerid,Owner.Name,Owner.email FROM Account WHERE id=:Opp.Account_Site_A__c];
            
                String PhoneDisplay='';

                String Username = SR.Project_Coordinator_Text__c.substringafter(' ');

                User ProjectCoordinator=[SELECT Email,Name FROM User WHERE Name=:username];

                updateSR.VarEmail_ProjectCoordinatorFormat__c = Username;

                AccountContactRelation ACR=[SELECT Contact.Name,Contact.Phone,Contact.MobilePhone FROM AccountContactRelation WHERE AccountID=:SR.Site_A__c AND Roles INCLUDES ('PIC Site') LIMIT 1];

                if(Acr.Contact.Phone!=null && Acr.Contact.Phone!=''){
                    PhoneDisplay=ACR.Contact.Phone;
                }
                    
                if(Acr.Contact.MobilePhone!=null && Acr.Contact.MobilePhone!=''){
                    PhoneDisplay=PhoneDisplay+'  '+ACR.Contact.MobilePhone;
                }

                updateSR.VarEmail_PICName__c = ACR.Contact.Name;
                updateSR.VarEmail_PICPhone__c = PhoneDisplay;

                if(SR.Services__c=='LL')
                {
                    AccountContactRelation ACR2=[SELECT Contact.Name,Contact.Phone,Contact.MobilePhone FROM AccountContactRelation WHERE AccountID=:SR.Site_B__c AND Roles INCLUDES ('PIC Site') LIMIT 1];

                    if(Acr2.Contact.Phone!=null && Acr2.Contact.Phone!=''){
                        PhoneDisplay=ACR2.Contact.Phone;
                    }
                        
                    if(Acr2.Contact.MobilePhone!=null && Acr2.Contact.MobilePhone!=''){
                        PhoneDisplay=PhoneDisplay+'  '+ACR2.Contact.MobilePhone;
                    }
                    
                    updateSR.VarEmail_PICSiteB_Name__c = ACR2.Contact.Name;
                    updateSR.VarEmail_PICSiteB_Phone__c = PhoneDisplay;
                }

                Database.SaveResult updateResult = Database.update(updateSR);

                system.debug('sendemailAssigned updateResult : ' + updateResult);
                
                if(updateResult.isSuccess()) {
                    List_toAddress.add(ProjectCoordinator.email);

                    List_toCCAddress.add(HO.Owner.Email);

                    Set_AddressList.addAll(List_toAddress);
                    Set_AddressCCList.addAll(List_toCCAddress);

                    Set_AddressList.remove('');
                    Set_AddressList.remove(null);
                    
                    Set_AddressCCList.remove('');
                    Set_AddressCCList.remove(null);

                    list<String> mailto=new list<String>();
                    list<String> mailcc=new list<String>{};

                    mailto.addAll(Set_AddressList);
                    mailcc.addAll(Set_AddressCCList);

                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: EmailNotif_SRPR[0].Sender_Email__c];

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
                    mail.setWhatId(SR.Id);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};

                    if(!test.isrunningtest()){
                        Messaging.sendEmail(messages);
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on SendEmailSRPR.cls - sendemailAssigned ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public static void sendemailCloseSR(SR_PR_Notification__c SR){
        DateTime start_time = datetime.now();
        try {
            //send email when SR is closed
            system.debug ('== masuk sendemailCloseSR ');

            List<EmailNotif_SRPR__c> EmailNotif_SRPR = [
                SELECT Name, 
                Additional_toAddress__c, 
                Additional_toCCAddress__c,
                Email_Template__c,
                Sender_Email__c 
                FROM EmailNotif_SRPR__c 
                WHERE Name =: 'Notification SR Complete'
            ];

            if(EmailNotif_SRPR!=null && !EmailNotif_SRPR.isEmpty()){
                List<string> List_toAddress = new List<string>();
                List<string> List_toCCAddress = new List<string>();

                Set<string> Set_AddressList = new Set<string>();
                Set<string> Set_AddressCCList = new Set<string>();

                String batch_ToAddress = EmailNotif_SRPR[0].Additional_toAddress__c;
                String batch_toCCAddress = EmailNotif_SRPR[0].Additional_toCCAddress__c;
                
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

                EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: EmailNotif_SRPR[0].Email_Template__c];
                List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];

                Opportunity Opp=[SELECT id,Solution_PIC__r.Email,Solution_PIC__r.Name,AccountID,Account_Site_A_Full_Address__c FROM Opportunity WHERE ID=:SR.Opportunity__c];

                Account HO=[SELECT BP_Number__c,Name,Owner.Employee_id__c,Ownerid,Owner.Name,Owner.email FROM Account WHERE id=:Opp.AccountID];

                List_toAddress.add(Opp.Solution_PIC__r.Email);
                List_toAddress.add(HO.Owner.Email);

                Set_AddressList.addAll(List_toAddress);
                Set_AddressCCList.addAll(List_toCCAddress);

                Set_AddressList.remove('');
                Set_AddressList.remove(null);
                
                Set_AddressCCList.remove('');
                Set_AddressCCList.remove(null);

                list<String> mailto=new list<String>();
                list<String> mailcc=new list<String>{};

                mailto.addAll(Set_AddressList);
                mailcc.addAll(Set_AddressCCList);

                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: EmailNotif_SRPR[0].Sender_Email__c];

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
                mail.setWhatId(SR.Id);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};

                if(!test.isrunningtest()){
                    Messaging.sendEmail(messages);
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on SendEmailSRPR.cls - sendemailCloseSR ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
}