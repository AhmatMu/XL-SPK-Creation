/* ====================================================================================================
* Class Name		        : Upsert_Profitability_GSM_Actual_Batch
* Test Class		        : Upsert_Profitability_GSM_Actual_Test
* Created By		        : Novando Utoyo Agmawan
* Created Date		        : 08/2021
* Created Description		: - 
* 					          - 
* Updated By               :
* Updated Date	            :
* Updated Description		: - 
* 					          - 
* ====================================================================================================
*/

global class Upsert_Profitability_GSM_Actual_Batch implements Database.Batchable<AggregateResult>{
    public Date scheduleRunDateTimes;

    global Upsert_Profitability_GSM_Actual_Batch(Date scheduleRunDateTimes) {
        this.scheduleRunDateTimes = scheduleRunDateTimes;
	}
    
    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        List<Sales_Revenue__c> SalesRevenueLast_List = [SELECT Period_Date__c FROM Sales_Revenue__c WHERE Type__c = 'Actual Revenue' ORDER BY Period_Date__c DESC LIMIT 1];

        Integer MonthValue = SalesRevenueLast_List[0].Period_Date__c.month();
        Integer YearValue = SalesRevenueLast_List[0].Period_Date__c.year();
        Set<String> ravenueCategorySet = new Set<String>();

        List<PNL_GSM_Setting_Actual__c> PNL_GSM_Setting_ActualList = [
            SELECT Id,
            Margin__c,
            Revenue_Category__c,
            Active__c
            FROM PNL_GSM_Setting_Actual__c
            WHERE Active__c = True
        ];
        
        if(PNL_GSM_Setting_ActualList!=null && !PNL_GSM_Setting_ActualList.isEmpty()){
            for(PNL_GSM_Setting_Actual__c PNL_GSM_Setting_ActualList_Extract : PNL_GSM_Setting_ActualList){
                ravenueCategorySet.add(PNL_GSM_Setting_ActualList_Extract.Revenue_Category__c);
            }
        }
        
        String query = 'SELECT ' +
            'Revenue_Category__r.Name revenueCategory, ' +
            'Customer__c customerId, ' +
            'Customer__r.BP_Number__c customer_BP_Number, ' +
            'Customer__r.ParentId customer_ParentId, ' +
            'Customer__r.Parent.BP_Number__c customer_ParentId_BP_Number, ' +
            'Customer__r.Organization_Type__c customer_Organization_Type, ' +
            'Customer__r.OwnerId customer_OwnerId, ' +
            'Customer__r.Owner.IsActive customer_OwnerId_activeStatus, ' +
            'Customer__r.Owner.ManagerId customer_ManagerId, ' +
            'Customer__r.Owner.Manager.IsActive customer_ManagerId_activeStatus, ' +
            'Customer__r.Owner.Manager.ManagerId customer_Manager_ManagerId, ' +
            'Customer__r.Owner.Manager.Manager.IsActive customer_Manager_ManagerId_activeStatus, ' +
            'Group_Service__r.Name groupService, ' +
            'SUM(Amount__c) Amount ' + 
            'FROM Sales_Revenue__c ' + 
            'where Type__c = \'Actual Revenue\' AND ' + 
            'Customer__c != null AND ' +
            'Revenue_Category__c != null AND ' +
            //'Revenue_Category__r.Name IN : ravenueCategorySet AND ' + 
            'CALENDAR_MONTH(Period_Date__c) = ' + MonthValue  + ' AND ' + 
            'CALENDAR_YEAR(Period_Date__c) = ' +  YearValue  + ' ' + 
            'GROUP BY Revenue_Category__r.Name, Customer__c, Customer__r.BP_Number__c, Customer__r.ParentId, Customer__r.Parent.BP_Number__c, Customer__r.Organization_Type__c, Customer__r.OwnerId, Customer__r.Owner.IsActive, Customer__r.Owner.ManagerId, Customer__r.Owner.Manager.IsActive, Customer__r.Owner.Manager.ManagerId, Customer__r.Owner.Manager.Manager.IsActive, Group_Service__r.Name';
        return new AggregateResultIterable(query);
    } 
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){ 
        DateTime start_time = datetime.now();
        try {
            List<AggregateResult> AggregateResultList = new List<AggregateResult>();
            
            if(scope!=null && !scope.isEmpty()){
                for(sObject sObj : scope) {
                    AggregateResultList.add((AggregateResult)sObj);
                }
                System.debug('>>>>  AggregateResultList : ' + AggregateResultList);
                
                if(AggregateResultList!=null && !AggregateResultList.isEmpty()){
                    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName();
                    Schema.RecordTypeInfo rtInfo_Gsm =  rtMapByName.get('GSM');
                    Id recordTypeId_Gsm = rtInfo_Gsm.getRecordTypeId();

                    list<AM_Portfolio_Mapping__c> AM_Portfolio_List = [SELECT id, AM__c, Portfolio_Management_Support__c FROM AM_Portfolio_Mapping__c WHERE Status__c='Active'];

                    list<User> UserList = [SELECT Id, Name, Username From User WHERE name = 'System Administrator' LIMIT 1];
                    
                    Map<String,String> AM_Portfolio_Map = new Map<String,String>();

                    for(AM_Portfolio_Mapping__c AM_Portfolio_List_extract : AM_Portfolio_List){
                        AM_Portfolio_Map.put(AM_Portfolio_List_extract.AM__c, AM_Portfolio_List_extract.Portfolio_Management_Support__c);
                    }

                    Map<String,Decimal> marginSettingMap = new Map<String,Decimal>();
                    
                    List<PNL_GSM_Setting_Actual__c> PNL_GSM_Setting_ActualList = [
                        SELECT Id,
                        Margin__c,
                        Revenue_Category__c,
                        Active__c
                        FROM PNL_GSM_Setting_Actual__c
                        WHERE Active__c = True
                    ];
                    
                    if(PNL_GSM_Setting_ActualList!=null && !PNL_GSM_Setting_ActualList.isEmpty()){
                        for(PNL_GSM_Setting_Actual__c PNL_GSM_Setting_ActualList_Extract : PNL_GSM_Setting_ActualList){
                            marginSettingMap.put(PNL_GSM_Setting_ActualList_Extract.Revenue_Category__c.touppercase(), PNL_GSM_Setting_ActualList_Extract.Margin__c/100);
                        }
                    }

                    List<Profitability__c> NewProfitability_ForecatsList = new List<Profitability__c>();
                    Set<Id> All_NewProfitability_ForecatsIds = new Set<Id>();

                    for(AggregateResult AggregateResultList_Extract : AggregateResultList){
                        if(marginSettingMap.get(String.valueOf(AggregateResultList_Extract.get('revenueCategory')).touppercase()) != null){
                            Profitability__c ProfitabilityForecats = new Profitability__c();
                            if( (String)AggregateResultList_Extract.get('customer_Organization_Type') == 'Head Office' ){
                                ProfitabilityForecats.recordTypeId = recordTypeId_Gsm;
                                ProfitabilityForecats.ProfitabilityGSM_Id__c = (String)AggregateResultList_Extract.get('customer_BP_Number') + '_' + (String)AggregateResultList_Extract.get('revenueCategory');

                                /*if( (Boolean)AggregateResultList_Extract.get('customer_OwnerId_activeStatus') != false ){
                                    ProfitabilityForecats.OwnerId = (String)AggregateResultList_Extract.get('customer_OwnerId');
                                }else if( (Boolean)AggregateResultList_Extract.get('customer_ManagerId_activeStatus') != false  ){
                                    ProfitabilityForecats.OwnerId = (String)AggregateResultList_Extract.get('customer_ManagerId');
                                }else if( (Boolean)AggregateResultList_Extract.get('customer_Manager_ManagerId_activeStatus') != false  ){
                                    ProfitabilityForecats.OwnerId = (String)AggregateResultList_Extract.get('customer_Manager_ManagerId');
                                }*/

                                ProfitabilityForecats.OwnerId = UserList[0].Id;

                                ProfitabilityForecats.Solution_PIC__c = AM_Portfolio_Map.get((String)AggregateResultList_Extract.get('customer_OwnerId'));
                                ProfitabilityForecats.Name = (String)AggregateResultList_Extract.get('customer_BP_Number') + '_' + (String)AggregateResultList_Extract.get('revenueCategory');
                                ProfitabilityForecats.Margin_GSM__c = marginSettingMap.get(String.valueOf(AggregateResultList_Extract.get('revenueCategory')).touppercase()) * (Decimal)AggregateResultList_Extract.get('Amount');
                                ProfitabilityForecats.Revenue_Category__c = (String)AggregateResultList_Extract.get('revenueCategory');
                                ProfitabilityForecats.Group_Service__c = (String)AggregateResultList_Extract.get('groupService');
                                ProfitabilityForecats.Deal_Price__c = (Decimal)AggregateResultList_Extract.get('Amount');
                                ProfitabilityForecats.Account__c = (String)AggregateResultList_Extract.get('customerId');
                                ProfitabilityForecats.Account_2__c = (String)AggregateResultList_Extract.get('customerId');
                                //ProfitabilityForecats.Opportunity__c = OpportunityLineItemList_Extract.opportunity.Id;
                                ProfitabilityForecats.PNL_GSM__c = marginSettingMap.get(String.valueOf(AggregateResultList_Extract.get('revenueCategory')).touppercase()) * 100;
                                ProfitabilityForecats.BP__c = (String)AggregateResultList_Extract.get('customer_BP_Number');
                                ProfitabilityForecats.BP_HO__c = (String)AggregateResultList_Extract.get('customer_BP_Number');
                                ProfitabilityForecats.Status__c = 'Actual';
                                ProfitabilityForecats.Stage__c = 'Actual Cost is Complete';
                                NewProfitability_ForecatsList.add(ProfitabilityForecats);
                            }else if(
                                (String)AggregateResultList_Extract.get('customer_Organization_Type') == 'Branch' || 
                                (String)AggregateResultList_Extract.get('customer_Organization_Type') == 'Holding'
                            ){
                                ProfitabilityForecats.recordTypeId = recordTypeId_Gsm;
                                ProfitabilityForecats.ProfitabilityGSM_Id__c = (String)AggregateResultList_Extract.get('customer_BP_Number') + '_' + (String)AggregateResultList_Extract.get('revenueCategory');

                                /*if( (Boolean)AggregateResultList_Extract.get('customer_OwnerId_activeStatus') != false ){
                                    ProfitabilityForecats.OwnerId = (String)AggregateResultList_Extract.get('customer_OwnerId');
                                }else if( (Boolean)AggregateResultList_Extract.get('customer_ManagerId_activeStatus') != false  ){
                                    ProfitabilityForecats.OwnerId = (String)AggregateResultList_Extract.get('customer_ManagerId');
                                }else if( (Boolean)AggregateResultList_Extract.get('customer_Manager_ManagerId_activeStatus') != false  ){
                                    ProfitabilityForecats.OwnerId = (String)AggregateResultList_Extract.get('customer_Manager_ManagerId');
                                }*/

                                ProfitabilityForecats.OwnerId = UserList[0].Id;

                                ProfitabilityForecats.Solution_PIC__c = AM_Portfolio_Map.get((String)AggregateResultList_Extract.get('customer_OwnerId'));
                                ProfitabilityForecats.Name = (String)AggregateResultList_Extract.get('customer_BP_Number') + '_' + (String)AggregateResultList_Extract.get('revenueCategory');
                                ProfitabilityForecats.Margin_GSM__c = marginSettingMap.get(String.valueOf(AggregateResultList_Extract.get('revenueCategory')).touppercase()) * (Decimal)AggregateResultList_Extract.get('Amount');
                                ProfitabilityForecats.Revenue_Category__c = (String)AggregateResultList_Extract.get('revenueCategory');
                                ProfitabilityForecats.Group_Service__c = (String)AggregateResultList_Extract.get('groupService');
                                ProfitabilityForecats.Deal_Price__c = (Decimal)AggregateResultList_Extract.get('Amount');
                                ProfitabilityForecats.Account__c = (String)AggregateResultList_Extract.get('customer_ParentId');
                                ProfitabilityForecats.Account_2__c = (String)AggregateResultList_Extract.get('customerId');
                                //ProfitabilityForecats.Opportunity__c = OpportunityLineItemList_Extract.opportunity.Id;
                                ProfitabilityForecats.PNL_GSM__c = marginSettingMap.get(String.valueOf(AggregateResultList_Extract.get('revenueCategory')).touppercase()) * 100;
                                ProfitabilityForecats.BP__c = (String)AggregateResultList_Extract.get('customer_BP_Number');
                                ProfitabilityForecats.BP_HO__c = (String)AggregateResultList_Extract.get('customer_ParentId_BP_Number');
                                ProfitabilityForecats.Status__c = 'Actual';
                                ProfitabilityForecats.Stage__c = 'Actual Cost is Complete';
                                NewProfitability_ForecatsList.add(ProfitabilityForecats);
                            }
                        }
                    }
                    Database.SaveResult[] insertNewProfitability_ForecatsList = Database.insert(NewProfitability_ForecatsList, true);

                    System.debug('>>>>  insertNewProfitability_ForecatsList 211 : ' + insertNewProfitability_ForecatsList);
                }
            }
        }catch (Exception e) {
            String err_message = 'Error on Upsert_Profitability_GSM_Actual_Batch.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations, example : send email for status
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Use the below code will send an email to User about the status
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
                          a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                          a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        
        List<string> List_toAddress = new List<string>();
        List<string> List_toCCAddress = new List<string>();
        List<ProfitabilityController__c> EmailSettingList = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c FROM ProfitabilityController__c WHERE Name =: 'Email_Notif_BatchClass'];
        
        if(EmailSettingList!=null && !EmailSettingList.isEmpty()){
            String batch_ToAddress = EmailSettingList[0].Additional_toAddress__c;
            String batch_toCCAddress = EmailSettingList[0].Additional_toCCAddress__c;
            
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
        mail.setSubject('Batch Upsert_Profitability_GSM_Actual_Batch Processing '+a.Status);
        mail.setHtmlBody('The Batch Apex Upsert_Profitability_GSM_Actual_Batch <br> job processed : '+ a.TotalJobItems+'<br> batches with : '+a.NumberOfErrors+' failures'+'<br> Job Item processed are : '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }
}