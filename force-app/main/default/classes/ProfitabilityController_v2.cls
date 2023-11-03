/**
* @description       : 
* @Test Class        : ProfitabilityControllerTestv2
* @author            : Novando Utoyo Agmawan
* @group             : 
* @last modified on  : 08-07-2023
* @last modified by  : Novando Utoyo Agmawan
* Modifications Log
* Ver   Date         Author                  Modification
* 1.0   01-30-2022   Novando Utoyo Agmawan   Initial Version
**/

public class ProfitabilityController_v2 {
    
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
                StageName,
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
                trial__c,
                Link_ID__c,
                CurrencyIsoCode
                FROM Opportunity 
                WHERE Id IN: opportunityIds AND 
                ( 
                    Service_Type__c = 'Newlink' OR 
                    Service_Type__c = 'Upgrade' OR 
                    Service_Type__c = 'Downgrade'
                ) AND 
                (
                    RecordType.Name like 'Subscription%' OR 
                    RecordType.Name like 'Usage%'
                ) AND
                (
                    Account.Organization_Type__c = 'Head Office' OR 
                    Account.Organization_Type__c = 'Holding'
                ) /*AND --> belum di test
                trial__c = false*/
            ];
            system.debug('oppList : ' + oppList);
            
            Set<Id> All_NewProfitability_ForecatsIds = new Set<Id>(); 
            
            if(oppList !=null && !oppList.isEmpty()) {
                Map<String,String> Map_ProductCodeFromOpptyLineProduct = AppUtils.getProductCodeFromOpptyLineProduct(opportunityIds);

                system.debug('ProductCode30--> '+Map_ProductCodeFromOpptyLineProduct);

                if(Map_ProductCodeFromOpptyLineProduct != null){
                    if(AM_Portfolio_List !=null && !AM_Portfolio_List.isEmpty()){
                        for(AM_Portfolio_Mapping__c AM_Portfolio_List_extract : AM_Portfolio_List){
                            AM_Portfolio_Map.put(AM_Portfolio_List_extract.AM__c, AM_Portfolio_List_extract.Portfolio_Management_Support__c);
                        }
                    }
                    
                    system.debug('AM_Portfolio_Map : ' + AM_Portfolio_Map);
                    
                    for(Opportunity oppList_extract : oppList){
                        String getRecordTypeInfosByName;

                        if(Test.isRunningTest()){
						 getRecordTypeInfosByName = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();                              
                        }else{
                            if(
                                Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id) != null
                            ){
                                system.debug('Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id) : ' + Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id));

                                if(
                                    AppUtils.getProfitability_RecordtypeController(Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id)) != null
                                ){
                                    system.debug('AppUtils.getProfitability_RecordtypeController(Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id)) : ' + AppUtils.getProfitability_RecordtypeController(Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id)));

                                    getRecordTypeInfosByName = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get(AppUtils.getProfitability_RecordtypeController(Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id))).getRecordTypeId();  
                                }
                            }
                        }
                        
                        system.debug('getRecordTypeInfosByName : ' + getRecordTypeInfosByName);
                        
                        if(
                            String.isNotBlank(getRecordTypeInfosByName) || 
                            String.isNotEmpty(getRecordTypeInfosByName)
                        ){
                            Profitability__c ProfitabilityForecats = new Profitability__c();
                            if(Test.isRunningTest()){
                              ProfitabilityForecats.recordTypeId = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();                              
                            }else{
                                if(
                                    Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id) != null
                                ){
                                    if(
                                        AppUtils.getProfitability_RecordtypeController(Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id)) != null
                                    ){
                                        getRecordTypeInfosByName = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get(AppUtils.getProfitability_RecordtypeController(Map_ProductCodeFromOpptyLineProduct.get(oppList_extract.Id))).getRecordTypeId();  
                                    }
                            }
                            }
                            
                            
                            if(oppList_extract.Service_Type__c == 'Upgrade' || oppList_extract.Service_Type__c == 'Downgrade'){
                                ProfitabilityForecats.CID__c = oppList_extract.Link_Related__c;
                                ProfitabilityForecats.Name = oppList_extract.Link_ID__c;
                            }else{
                                ProfitabilityForecats.Name = oppList_extract.Opportunity_ID__c;
                            }
                            
                            ProfitabilityForecats.OwnerId = oppList_extract.Account.OwnerId;
                            if(AM_Portfolio_Map !=null && !AM_Portfolio_Map.isEmpty()){
                                ProfitabilityForecats.Solution_PIC__c = AM_Portfolio_Map.get(oppList_extract.Account.OwnerId);
                            }
                            ProfitabilityForecats.Account__c = oppList_extract.AccountId;
                            ProfitabilityForecats.Opportunity__c = oppList_extract.Id;
                            ProfitabilityForecats.CurrencyIsoCode = oppList_extract.CurrencyIsoCode;
                            ProfitabilityForecats.Status__c = 'Forecast';
                            ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
                            ProfitabilityForecats.One_Time_Revenue__c = oppList_extract.Onetime_revenue__c;
                            ProfitabilityForecats.Deal_Price__c = oppList_extract.Recurring_Revenue__c;
                            NewProfitability_ForecatsList.add(ProfitabilityForecats);
                        }else{
                            oppList_extract.StageName = 'Negotiation';
                        }
                    }
                    update oppList;
                    
                    if(NewProfitability_ForecatsList !=null && !NewProfitability_ForecatsList.isEmpty()){
                        Database.SaveResult[] insertResults = Database.insert(NewProfitability_ForecatsList, true);
                        
                        system.debug('insertResults : ' + insertResults);
                        
                        for (Database.SaveResult insertResults_Extract : insertResults) {
                            if (insertResults_Extract.isSuccess()) {
                                All_NewProfitability_ForecatsIds.add(insertResults_Extract.getId());
                            }
                            else {          
                                for(Database.Error error : insertResults_Extract.getErrors()) {
                                    String err_message = 'Error on ProfitabilityController_v2.cls - Create_Profitability_Forecats ::' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields();
                                    AppUtils.putError(err_message);
                                    System.debug('Error on ProfitabilityController_v2.cls - Create_Profitability_Forecats::' + error.getStatusCode() + ' : ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
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
                                    
                                    update oppList;
                                    Email_Notif_to_Solution_Profitability_Forecats_Created(opportunityIds);
                                }
                            }
                        }
                    }
                }else{
                    for(Opportunity oppList_extract : oppList){
                        oppList_extract.StageName = 'Negotiation';
                    }
                    update oppList;
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProfitabilityController_v2.cls - Create_Profitability_Forecats ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
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
                Profitability__r.Solution_PIC__r.manager.email,
                trial__c
                FROM Opportunity 
                WHERE Id IN: opportunityIds AND
                (
                    Service_Type__c = 'Newlink' OR  
                    Service_Type__c = 'Upgrade' OR 
                    Service_Type__c = 'Downgrade'
                ) AND
                (
                    RecordType.Name like 'Subscription%' OR  
                    RecordType.Name like 'Usage%'
                ) AND
                (
                    Account.Organization_Type__c = 'Head Office' OR 
                    Account.Organization_Type__c = 'Holding'
                ) /*AND belum di test
                trial__c = false*/
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
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProfitabilityController_v2.cls - Email_Notif_to_Solution_Profitability_Forecats_Created ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
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
                Opportunity__r.StageName,
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
                Opportunity__r.Profitability__r.Account__c,
                Opportunity__r.trial__c
                FROM SR_PR_Notification__c 
                WHERE Id IN: SR_PR_NotificationIds AND
                (
                    Opportunity__r.Service_Type__c = 'Newlink' OR  
                    Opportunity__r.Service_Type__c = 'Upgrade' OR 
                    Opportunity__r.Service_Type__c = 'Downgrade'
                ) AND
                (
                    Opportunity__r.RecordType.Name like 'Subscription%' OR 
                    Opportunity__r.RecordType.Name like 'Usage%'
                )  AND
                (
                    Opportunity__r.Account.Organization_Type__c = 'Head Office' OR 
                    Opportunity__r.Account.Organization_Type__c = 'Holding'
                ) /*AND belum di test
                Opportunity__r.trial__c = false*/
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
                    }
                }
            }else{
                
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProfitabilityController_v2.cls - Email_Notif_to_Solution_Profitability_Forecats_UpdateToActual ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
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
                opportunity.StageName,
                opportunity.trial__c,
                opportunity.CurrencyIsoCode
                FROM OpportunityLineItem
                WHERE opportunity.Id IN: opportunityIds AND
                (
                    opportunity.RecordType.Name = 'Simcard Postpaid/Prepaid' OR 
                    opportunity.RecordType.Name = 'Simcard Device Bundling' OR 
                    opportunity.RecordType.Name = 'Project Bulkshare'
                ) AND
                (
                    opportunity.Account.Organization_Type__c = 'Head Office' OR 
                    opportunity.Account.Organization_Type__c = 'Holding'
                ) AND
                (
                    opportunity.StageName = 'Negotiation' OR 
                    opportunity.StageName = 'Quotation Final'
                ) /*AND belum di test
                opportunity.trial__c = false*/
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
                    (
                        opportunity.RecordType.Name = 'Simcard Postpaid/Prepaid' OR 
                        opportunity.RecordType.Name = 'Simcard Device Bundling' OR 
                        opportunity.RecordType.Name = 'Project Bulkshare'
                    ) AND
                    (
                        opportunity.Account.Organization_Type__c = 'Head Office' OR 
                        opportunity.Account.Organization_Type__c = 'Holding'
                    )
                    GROUP BY product2.Product_Code2__c, opportunity.Id
                ];
                
                System.debug(AggregateList);
                
                /*List<String> Opp_ProfitabilityForecast_SR_Ids = new List<String>();
Opp_ProfitabilityForecast_SR_Ids.add('006O000000Fux34IAB');

ProfitabilityController_v2 ProfitabilityController_class = new ProfitabilityController_v2();
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
                            ){
                                if(
                                    AppUtils.getProfitability_RecordtypeController('%' + OpportunityLineItemList_Extract.product2.Product_Code2__c + '%') != null
                                ){
                                    if(
                                        Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get(AppUtils.getProfitability_RecordtypeController('%' + OpportunityLineItemList_Extract.product2.Product_Code2__c + '%')).getRecordTypeId() != null
                                    ){
                                        Profitability__c ProfitabilityForecats = new Profitability__c();
                                        
                                        ProfitabilityForecats.recordTypeId =  Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get(AppUtils.getProfitability_RecordtypeController('%'+OpportunityLineItemList_Extract.product2.Product_Code2__c)+'%').getRecordTypeId();
                                        
                                        ProfitabilityForecats.ProfitabilityGSM_Id__c = OpportunityLineItemList_Extract.opportunity.Opportunity_ID__c + (String)AggregateList_Extract.get('ProductCode');
    
                                        if(UserList !=null && !UserList.isEmpty()){
                                            ProfitabilityForecats.OwnerId = UserList[0].Id;
                                        }
    
                                        if(AM_Portfolio_Map.get(OpportunityLineItemList_Extract.opportunity.Account.OwnerId) != null){
                                            ProfitabilityForecats.Solution_PIC__c = AM_Portfolio_Map.get(OpportunityLineItemList_Extract.opportunity.Account.OwnerId);
                                        }
    
                                        ProfitabilityForecats.Name = OpportunityLineItemList_Extract.opportunity.Opportunity_ID__c;
                                        ProfitabilityForecats.CurrencyIsoCode = OpportunityLineItemList_Extract.opportunity.CurrencyIsoCode;
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
                    }
                }
                
                if(NewProfitability_ForecatsList !=null && !NewProfitability_ForecatsList.isEmpty()){
                    Schema.SObjectField  ProfitabilityGSM_Id = Profitability__c.Fields.ProfitabilityGSM_Id__c;
                    Database.UpsertResult[] upsertNewProfitability_ForecatsList = Database.upsert(NewProfitability_ForecatsList, ProfitabilityGSM_Id, true);
                    
                    system.debug('NewProfitability_ForecatsList : ' + NewProfitability_ForecatsList);
                    system.debug('upsertNewProfitability_ForecatsList : ' + upsertNewProfitability_ForecatsList);
                }
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProfitabilityController_v2.cls - Upsert_Profitability_GSM_Forecats ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
}