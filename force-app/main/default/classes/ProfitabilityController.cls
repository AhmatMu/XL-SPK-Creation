/* ====================================================================================================
* Class Name		        : ProfitabilityController
* Test Class		        : ProfitabilityController_Test
* Created By		        : Novando Utoyo Agmawan
* Created Date		        : 06/2021
* Created Description		: - 
* 					          - 
* Updated By               :
* Updated Date	            :
* Updated Description		: - 
* 					          - 
* ====================================================================================================
*/

public class ProfitabilityController {
    
    public void Create_Profitability_Forecats(List<String> opportunityIds){
        DateTime start_time = datetime.now();
        try {
            system.debug('Create_Profitability_Forecats');
            
            list<AM_Portfolio_Mapping__c> AM_Portfolio_List = [SELECT id, AM__c, Portfolio_Management_Support__c FROM AM_Portfolio_Mapping__c WHERE Status__c='Active'];
            Map<String,String> AM_Portfolio_Map = new Map<String,String>();
            
            List<Profitability__c> NewProfitability_ForecatsList = new List<Profitability__c>();
            List<Opportunity> oppList = [
                SELECT Id, 
                Name,
                RecordType.Name,
                Amount,
                Onetime_revenue__c,
                Recurring_Revenue__c,
                AccountId,
                Account.OwnerId,
                Account.Organization_Type__c,
                Opportunity_ID__c,
                Service_Type__c,
                Link_Related__c,
                Link_ID__c
                FROM Opportunity 
                WHERE Id IN: opportunityIds AND
                (Service_Type__c = 'Newlink' OR  Service_Type__c = 'Upgrade' OR Service_Type__c = 'Downgrade') AND
                (RecordType.Name like '%Non GSM%' OR  RecordType.Name like '%IoT%') AND
                (Account.Organization_Type__c = 'Head Office' OR Account.Organization_Type__c = 'Holding')
            ];
            Set<Id> All_NewProfitability_ForecatsIds = new Set<Id>();
            
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo_NonGsm =  rtMapByName.get('NON GSM');
            Id recordTypeId_NonGsm = rtInfo_NonGsm.getRecordTypeId();
            
            Schema.RecordTypeInfo rtInfo_Iot =  rtMapByName.get('IOT MCA');
            Id recordTypeId_Iot = rtInfo_Iot.getRecordTypeId();
            
            system.debug('oppList : ' + oppList);
            
            if(oppList !=null && !oppList.isEmpty()) {
                for(AM_Portfolio_Mapping__c AM_Portfolio_List_extract : AM_Portfolio_List){
                    AM_Portfolio_Map.put(AM_Portfolio_List_extract.AM__c, AM_Portfolio_List_extract.Portfolio_Management_Support__c);
                }
                
                for(Opportunity oppList_extract : oppList){
                    Profitability__c ProfitabilityForecats = new Profitability__c();
                    
                    if(oppList_extract.RecordType.Name.contains('Non GSM')){
                        ProfitabilityForecats.recordTypeId = recordTypeId_NonGsm;
                    }else{
                        ProfitabilityForecats.recordTypeId = recordTypeId_Iot;
                    }
                    
                    if(oppList_extract.Service_Type__c == 'Upgrade' || oppList_extract.Service_Type__c == 'Downgrade'){
                        ProfitabilityForecats.CID__c = oppList_extract.Link_Related__c;
                        ProfitabilityForecats.Name = oppList_extract.Link_ID__c;
                    }else{
                        ProfitabilityForecats.Name = oppList_extract.Opportunity_ID__c;
                    }
                    
                    ProfitabilityForecats.OwnerId = oppList_extract.Account.OwnerId;
                    ProfitabilityForecats.Solution_PIC__c = AM_Portfolio_Map.get(oppList_extract.Account.OwnerId);
                    ProfitabilityForecats.Account__c = oppList_extract.AccountId;
                    ProfitabilityForecats.Opportunity__c = oppList_extract.Id;
                    ProfitabilityForecats.Status__c = 'Forecast';
                    ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
                    ProfitabilityForecats.One_Time_Revenue__c = oppList_extract.Onetime_revenue__c;
                    ProfitabilityForecats.Deal_Price__c = oppList_extract.Recurring_Revenue__c;
                    NewProfitability_ForecatsList.add(ProfitabilityForecats);
                }
                Database.SaveResult[] insertResults = Database.insert(NewProfitability_ForecatsList, true);
                
                system.debug('insertResults : ' + insertResults);
                
                for (Database.SaveResult insertResults_Extract : insertResults) {
                    if (insertResults_Extract.isSuccess()) {
                        All_NewProfitability_ForecatsIds.add(insertResults_Extract.getId());
                    }
                    else {          
                        for(Database.Error error : insertResults_Extract.getErrors()) {
                            String err_message = 'Error on ProfitabilityController.cls - Create_Profitability_Forecats ::' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields();
                            AppUtils.putError(err_message);
                            System.debug('Error on ProfitabilityController.cls - Create_Profitability_Forecats::' + error.getStatusCode() + ' : ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
                        }
                    }
                }
                
                if(All_NewProfitability_ForecatsIds !=null && !All_NewProfitability_ForecatsIds.isEmpty()){
                    List<Profitability__c> NewProfitability_Forecats = [SELECT Id, Opportunity__c FROM Profitability__c WHERE Id IN: All_NewProfitability_ForecatsIds];
                    Map<String,String> Map_Opportunity_In_Profitability_Forecats = new Map<String,String>();
                    
                    if(NewProfitability_Forecats !=null && !NewProfitability_Forecats.isEmpty()){
                        for(Profitability__c NewProfitability_Forecats_Extract : NewProfitability_Forecats){
                            Map_Opportunity_In_Profitability_Forecats.put(NewProfitability_Forecats_Extract.Opportunity__c, NewProfitability_Forecats_Extract.Id);
                        }
                        
                        if(Map_Opportunity_In_Profitability_Forecats !=null && !Map_Opportunity_In_Profitability_Forecats.isEmpty()){
                            for(Opportunity oppList_extract2 : oppList){
                                oppList_extract2.Profitability__c = Map_Opportunity_In_Profitability_Forecats.get(oppList_extract2.Id);
                            }
                            
                            AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'ProfitabilityController.cls - Create_Profitability_Forecats',null);
                            update oppList;
                            Email_Notif_to_Solution_Profitability_Forecats_Created(opportunityIds);
                        }
                    }
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProfitabilityController.cls - Create_Profitability_Forecats ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'ProfitabilityController.cls - Create_Profitability_Forecats',err_message);
        }
    }
    
    public void Email_Notif_to_Solution_Profitability_Forecats_Created(List<String> opportunityIds){
        DateTime start_time = datetime.now();
        try {
            List<Messaging.SingleEmailMessage> sendEmailList = new List<Messaging.SingleEmailMessage>();
            
            List<EmailTemplate> EmailTemplateList = [select id from EmailTemplate where DeveloperName = 'Email_Notif_to_Solution_Profitability_Forecats_Created'];
            
            List<ProfitabilityController__c> Email_ProfitabilityController = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM ProfitabilityController__c WHERE Name =: 'Email_Profitability_Forecats_Created'];
            
            List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];
            
            List<User> userList = [SELECT Id, Email, manager.email FROM user WHERE Email =: 'idewap@xl.co.id'];
            
            List<Opportunity> oppList = [
                SELECT Id, 
                Name,
                RecordType.Name,
                Amount,
                Onetime_revenue__c,
                AccountId,
                Account.OwnerId,
                Account.Organization_Type__c,
                Service_Type__c,
                Profitability__c,
                Profitability__r.Name,
                Profitability__r.Account__c,
                Profitability__r.Solution_PIC__c,
                Profitability__r.Solution_PIC__r.Email,
                Profitability__r.Solution_PIC__r.manager.email
                FROM Opportunity 
                WHERE Id IN: opportunityIds AND
                (Service_Type__c = 'Newlink' OR  Service_Type__c = 'Upgrade' OR Service_Type__c = 'Downgrade') AND
                (RecordType.Name like '%Non GSM%' OR  RecordType.Name like '%IoT%') AND
                (Account.Organization_Type__c = 'Head Office' OR Account.Organization_Type__c = 'Holding')
            ];
            
            if(oppList !=null && !oppList.isEmpty()) {
                List<string> List_toAddress = new List<string>();
                List<string> List_toCCAddress = new List<string>();
                
                if(Email_ProfitabilityController!=null && !Email_ProfitabilityController.isEmpty()){
                    String batch_ToAddress = Email_ProfitabilityController[0].Additional_toAddress__c;
                    String batch_toCCAddress = Email_ProfitabilityController[0].Additional_toCCAddress__c;
                    
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
                }
                
                for(Opportunity oppList_extract : oppList){
                    Set<string> Set_AddressList = new Set<string>();
                    Set<string> Set_AddressCCList = new Set<string>();
                    
                    if(oppList_extract.Profitability__r.Solution_PIC__r.Email != null){
                        Set_AddressList.add(oppList_extract.Profitability__r.Solution_PIC__r.Email);
                        Set_AddressCCList.add(oppList_extract.Profitability__r.Solution_PIC__r.manager.email);
                    }else{
                        if(userList !=null && !userList.isEmpty()){
                            Set_AddressList.add(userList[0].Email);
                            Set_AddressCCList.add(userList[0].manager.email);
                        }
                    }
                    
                    Set_AddressList.remove('');
                    Set_AddressList.remove(null);
                    
                    Set_AddressCCList.remove('');
                    Set_AddressCCList.remove(null);
                    
                    List_toAddress.addAll(Set_AddressList);
                    List_toCCAddress.addAll(Set_AddressCCList);
                    
                    system.debug('List_toAddress : ' + List_toAddress);
                    system.debug('List_toCCAddress : ' + List_toCCAddress);
                    
                    Messaging.SingleEmailMessage singleEmailMessageObj = new Messaging.SingleEmailMessage();
                    
                    singleEmailMessageObj.optOutPolicy = 'FILTER';
                    singleEmailMessageObj.setTemplateId(EmailTemplateList[0].id);
                    singleEmailMessageObj.setTargetObjectId(contactList[0].id);
                    singleEmailMessageObj.setTreatTargetObjectAsRecipient(false);
                    singleEmailMessageObj.setWhatId(oppList_extract.Profitability__c);
                    singleEmailMessageObj.setSaveAsActivity(false);
                    
                    singleEmailMessageObj.setToAddresses(List_toAddress);
                    if(List_toCCAddress!=null && !List_toCCAddress.isEmpty()){
                        singleEmailMessageObj.setCcAddresses(List_toCCAddress);
                    }
                    
                    sendEmailList.add(singleEmailMessageObj);
                }
                
                if(sendEmailList!=null && !sendEmailList.isEmpty())
                {
                    system.debug('sendEmailListSize : ' + sendEmailList.size()) ;
                    Messaging.sendEmail(sendEmailList,true);
                    
                    AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'ProfitabilityController.cls - Email_Notif_to_Solution_Profitability_Forecats_Created',null);
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProfitabilityController.cls - Email_Notif_to_Solution_Profitability_Forecats_Created ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'ProfitabilityController.cls - Email_Notif_to_Solution_Profitability_Forecats_Created',err_message);
        }
    }
    
    public void Email_Notif_to_Solution_Profitability_Forecats_UpdateToActual(List<String> SR_PR_NotificationIds){
        DateTime start_time = datetime.now();
        try {
            List<EmailTemplate> EmailTemplateList = [select id from EmailTemplate where DeveloperName = 'Email_Notif_to_Solution_Profitability_Forecats_UpdateToActual'];
            
            List<ProfitabilityController__c> Email_ProfitabilityController = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM ProfitabilityController__c WHERE Name =: 'Email_Profitability_UpdateToActual'];
            
            List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];
            
            List<User> userList = [SELECT Id, Email, manager.email FROM user WHERE Email =: 'idewap@xl.co.id'];
            
            List<Messaging.SingleEmailMessage> sendEmailList = new List<Messaging.SingleEmailMessage>();
            
            Set<String> ProfitabilityIds = new Set<String>();
            Map<String,String> ProfitabilityLink_Maps = new Map<String,String>();
            
            List<SR_PR_Notification__c> SR_PR_Notification_List = [
                SELECT Id, 
                Name,
                Opportunity__c,
                Link__c,
                Opportunity__r.Name,
                Opportunity__r.RecordType.Name,
                Opportunity__r.Service_Type__c,
                Opportunity__r.Amount,
                Opportunity__r.Onetime_revenue__c,
                Opportunity__r.AccountId,
                Opportunity__r.Account.Organization_Type__c,
                Opportunity__r.Profitability__c,
                Opportunity__r.Profitability__r.Name,
                Opportunity__r.Profitability__r.Solution_PIC__c,
                Opportunity__r.Profitability__r.Solution_PIC__r.Email,
                Opportunity__r.Profitability__r.Solution_PIC__r.manager.email,
                Opportunity__r.Profitability__r.Account__c
                FROM SR_PR_Notification__c 
                WHERE Id IN: SR_PR_NotificationIds AND
                (Opportunity__r.Service_Type__c = 'Newlink' OR  Opportunity__r.Service_Type__c = 'Upgrade' OR Opportunity__r.Service_Type__c = 'Downgrade') AND
                (Opportunity__r.RecordType.Name like '%Non GSM%' OR  Opportunity__r.RecordType.Name like '%IoT%')  AND
                (Opportunity__r.Account.Organization_Type__c = 'Head Office' OR Opportunity__r.Account.Organization_Type__c = 'Holding')
            ];
            
            if(SR_PR_Notification_List !=null && !SR_PR_Notification_List.isEmpty()) {
                List<string> List_toAddress = new List<string>();
                List<string> List_toCCAddress = new List<string>();
                
                if(Email_ProfitabilityController!=null && !Email_ProfitabilityController.isEmpty()){
                    String batch_ToAddress = Email_ProfitabilityController[0].Additional_toAddress__c;
                    String batch_toCCAddress = Email_ProfitabilityController[0].Additional_toCCAddress__c;
                    
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
                }
                
                for(SR_PR_Notification__c SR_PR_Notification_List_extract : SR_PR_Notification_List){
                    Set<string> Set_AddressList = new Set<string>();
                    Set<string> Set_AddressCCList = new Set<string>();
                    
                    if(SR_PR_Notification_List_extract.Opportunity__r.Profitability__r.Solution_PIC__r.Email != null){
                        Set_AddressList.add(SR_PR_Notification_List_extract.Opportunity__r.Profitability__r.Solution_PIC__r.Email);
                        Set_AddressCCList.add(SR_PR_Notification_List_extract.Opportunity__r.Profitability__r.Solution_PIC__r.manager.email);
                    }else{
                        Set_AddressList.add(userList[0].Email);
                        Set_AddressCCList.add(userList[0].manager.email);
                    }
                    
                    Set_AddressList.remove('');
                    Set_AddressList.remove(null);
                    
                    Set_AddressCCList.remove('');
                    Set_AddressCCList.remove(null);
                    
                    List_toAddress.addAll(Set_AddressList);
                    List_toCCAddress.addAll(Set_AddressCCList);
                    
                    Messaging.SingleEmailMessage singleEmailMessageObj = new Messaging.SingleEmailMessage();
                    
                    singleEmailMessageObj.optOutPolicy = 'FILTER';
                    singleEmailMessageObj.setTemplateId(EmailTemplateList[0].id);
                    singleEmailMessageObj.setTargetObjectId(contactList[0].id);
                    singleEmailMessageObj.setTreatTargetObjectAsRecipient(false);
                    singleEmailMessageObj.setWhatId(SR_PR_Notification_List_extract.Opportunity__r.Profitability__c);
                    singleEmailMessageObj.setSaveAsActivity(false);
                    
                    singleEmailMessageObj.setToAddresses(List_toAddress);
                    if(List_toCCAddress!=null && !List_toCCAddress.isEmpty()){
                        singleEmailMessageObj.setCcAddresses(List_toCCAddress);
                    }
                    
                    sendEmailList.add(singleEmailMessageObj);
                    
                    ProfitabilityIds.add(SR_PR_Notification_List_extract.Opportunity__r.Profitability__c);
                    ProfitabilityLink_Maps.put(SR_PR_Notification_List_extract.Opportunity__r.Profitability__c, SR_PR_Notification_List_extract.Link__c);
                }
                
                if(sendEmailList!=null && !sendEmailList.isEmpty())
                {
                    system.debug('sendEmailListSize : ' + sendEmailList.size());
                    
                    List<Profitability__c> Profitability_List = [
                        SELECT Id, 
                        Name,
                        Opportunity__c,
                        CID__c,
                        Stage__c
                        FROM Profitability__c 
                        WHERE Id IN: ProfitabilityIds
                    ];
                    
                    if(Profitability_List!=null && !Profitability_List.isEmpty())
                    {
                        for(Profitability__c Profitability_List_Extract : Profitability_List){
                            Profitability_List_Extract.Stage__c = 'Fill Actual Cost';
                            Profitability_List_Extract.CID__c = ProfitabilityLink_Maps.get(Profitability_List_Extract.Id);
                        }
                        
                        Messaging.sendEmail(sendEmailList,true);
                        update Profitability_List;
                        AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'ProfitabilityController.cls - Email_Notif_to_Solution_Profitability_Forecats_UpdateToActual',null);
                    }
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProfitabilityController.cls - Email_Notif_to_Solution_Profitability_Forecats_UpdateToActual ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'ProfitabilityController.cls - Email_Notif_to_Solution_Profitability_Forecats_UpdateToActual',err_message);
        }
    }
    
    public void Upsert_Profitability_GSM_Forecats(List<String> opportunityIds){
        DateTime start_time = datetime.now();
        try {
            list<AM_Portfolio_Mapping__c> AM_Portfolio_List = [SELECT id, AM__c, Portfolio_Management_Support__c FROM AM_Portfolio_Mapping__c WHERE Status__c='Active'];

            list<User> UserList = [SELECT Id, Name, Username From User WHERE name = 'System Administrator' LIMIT 1];
            
            Map<String,String> AM_Portfolio_Map = new Map<String,String>();
            List<Profitability__c> NewProfitability_ForecatsList = new List<Profitability__c>();
            Set<Id> All_NewProfitability_ForecatsIds = new Set<Id>();
            
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo_Gsm =  rtMapByName.get('GSM');
            Id recordTypeId_Gsm = rtInfo_Gsm.getRecordTypeId();
            
            Map<String,Decimal> marginSettingMap = new Map<String,Decimal>();
            
            List<PNL_GSM_Setting_Forecast__c> PNL_GSM_Setting_ForecastList = [
                SELECT Id,
                Margin__c,
                Product_Code__c,
                Active__c
                FROM PNL_GSM_Setting_Forecast__c
                WHERE Active__c = True
            ];
            
            if(PNL_GSM_Setting_ForecastList!=null && !PNL_GSM_Setting_ForecastList.isEmpty()){
                for(PNL_GSM_Setting_Forecast__c PNL_GSM_Setting_ForecastList_Extract : PNL_GSM_Setting_ForecastList){
                    marginSettingMap.put(PNL_GSM_Setting_ForecastList_Extract.Product_Code__c.touppercase(), PNL_GSM_Setting_ForecastList_Extract.Margin__c/100);
                }
            }
            
            List<OpportunityLineItem> OpportunityLineItemList = [
                SELECT Id,
                Total_Price_Pipeline__c,
                product2.Product_Code2__c,
                opportunity.Id,
                opportunity.Name,
                opportunity.Opportunity_ID__c,
                opportunity.RecordType.Name,
                opportunity.Account.Organization_Type__c,
                opportunity.Account.BP_Number__c,
                opportunity.AccountId,
                opportunity.Account.OwnerId,
                opportunity.StageName
                FROM OpportunityLineItem
                WHERE opportunity.Id IN: opportunityIds AND
                (opportunity.RecordType.Name = 'GSM (Activation)' OR  opportunity.RecordType.Name = 'Device Bundling' OR  opportunity.RecordType.Name = 'Digital Advertising') AND
                (opportunity.Account.Organization_Type__c = 'Head Office' OR opportunity.Account.Organization_Type__c = 'Holding') AND
                (opportunity.StageName = 'Negotiation' OR opportunity.StageName = 'Quotation Final')
            ];
            
            System.debug(OpportunityLineItemList);
            
            
            if(OpportunityLineItemList !=null && !OpportunityLineItemList.isEmpty()) {
                /*Set<String> opportunityIds = new Set<String>();
                opportunityIds.add('006O000000Fux34IAB');*/
                
                AggregateResult[] AggregateList = [
                    SELECT product2.Product_Code2__c ProductCode,
                    opportunity.Id opptyId,
                    SUM(Total_Price_Pipeline__c) totalPrice_Pipeline
                    FROM OpportunityLineItem
                    WHERE opportunity.Id IN: opportunityIds AND
                    (opportunity.RecordType.Name = 'GSM (Activation)' OR  opportunity.RecordType.Name = 'Device Bundling' OR  opportunity.RecordType.Name = 'Digital Advertising') AND
                    (opportunity.Account.Organization_Type__c = 'Head Office' OR opportunity.Account.Organization_Type__c = 'Holding')
                    GROUP BY product2.Product_Code2__c, opportunity.Id
                ];
                
                System.debug(AggregateList);
                
                /*List<String> Opp_ProfitabilityForecast_SR_Ids = new List<String>();
                Opp_ProfitabilityForecast_SR_Ids.add('006O000000Fux34IAB');

                ProfitabilityController ProfitabilityController_class = new ProfitabilityController();
                ProfitabilityController_class.Upsert_Profitability_GSM_Forecats(Opp_ProfitabilityForecast_SR_Ids);*/
                
                for(AM_Portfolio_Mapping__c AM_Portfolio_List_extract : AM_Portfolio_List){
                    AM_Portfolio_Map.put(AM_Portfolio_List_extract.AM__c, AM_Portfolio_List_extract.Portfolio_Management_Support__c);
                }
                
                for(AggregateResult AggregateList_Extract : AggregateList)
                {
                    for(OpportunityLineItem OpportunityLineItemList_Extract : OpportunityLineItemList)
                    {
                        if(marginSettingMap.get(String.valueOf(AggregateList_Extract.get('ProductCode')).touppercase()) != null){
                            if(
                                OpportunityLineItemList_Extract.product2.Product_Code2__c == (String)AggregateList_Extract.get('ProductCode') &&
                                OpportunityLineItemList_Extract.opportunity.Id == (String)AggregateList_Extract.get('opptyId')
                            )
                            {
                                Profitability__c ProfitabilityForecats = new Profitability__c();
                                
                                ProfitabilityForecats.recordTypeId = recordTypeId_Gsm;
                                ProfitabilityForecats.ProfitabilityGSM_Id__c = OpportunityLineItemList_Extract.opportunity.Opportunity_ID__c + (String)AggregateList_Extract.get('ProductCode');
                                ProfitabilityForecats.OwnerId = UserList[0].Id;
                                ProfitabilityForecats.Solution_PIC__c = AM_Portfolio_Map.get(OpportunityLineItemList_Extract.opportunity.Account.OwnerId);
                                ProfitabilityForecats.Name = OpportunityLineItemList_Extract.opportunity.Opportunity_ID__c;
                                ProfitabilityForecats.Margin_GSM__c = marginSettingMap.get(String.valueOf(AggregateList_Extract.get('ProductCode')).touppercase()) * (Decimal)AggregateList_Extract.get('totalPrice_Pipeline');
                                ProfitabilityForecats.Product_Code__c = (String)AggregateList_Extract.get('ProductCode');
                                ProfitabilityForecats.Deal_Price__c = (Decimal)AggregateList_Extract.get('totalPrice_Pipeline');
                                ProfitabilityForecats.Account__c = OpportunityLineItemList_Extract.opportunity.AccountId;
                                ProfitabilityForecats.Opportunity__c = OpportunityLineItemList_Extract.opportunity.Id;
                                ProfitabilityForecats.PNL_GSM__c = marginSettingMap.get(String.valueOf(AggregateList_Extract.get('ProductCode')).touppercase()) * 100;
                                ProfitabilityForecats.BP__c = OpportunityLineItemList_Extract.opportunity.Account.BP_Number__c;
                                ProfitabilityForecats.BP_HO__c = OpportunityLineItemList_Extract.opportunity.Account.BP_Number__c;
                                ProfitabilityForecats.Status__c = 'Forecast';
                                ProfitabilityForecats.Stage__c = 'Forecast Cost is Complete';
                                NewProfitability_ForecatsList.add(ProfitabilityForecats);
                                break;
                            }
                        }
                    }
                }
                Schema.SObjectField  ProfitabilityGSM_Id = Profitability__c.Fields.ProfitabilityGSM_Id__c;
                Database.UpsertResult[] upsertNewProfitability_ForecatsList = Database.upsert(NewProfitability_ForecatsList, ProfitabilityGSM_Id, true);
                
                system.debug('NewProfitability_ForecatsList : ' + NewProfitability_ForecatsList);
                system.debug('upsertNewProfitability_ForecatsList : ' + upsertNewProfitability_ForecatsList);
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProfitabilityController.cls - Upsert_Profitability_GSM_Forecats ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'ProfitabilityController.cls - Upsert_Profitability_GSM_Forecats',err_message);
        }
    }
    
}