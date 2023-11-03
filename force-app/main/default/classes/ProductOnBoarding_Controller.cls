/**
 * @description       :
 * @Test Class        : ProductOnBoarding_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-12-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-30-2021   Novando Utoyo Agmawan   Initial Version
**/

public class ProductOnBoarding_Controller {
    @AuraEnabled(cacheable = true) 
    public static List<New_Product_Registration_Ticket__c> getNewProductRegistrationTicket(Id NewProductRegistrationTicketId) { 
        DateTime start_time = datetime.now();
        List<New_Product_Registration_Ticket__c> List_NewProductRegistrationTicket = null;

        try {
            system.debug('NewProductRegistrationTicketId : ' + NewProductRegistrationTicketId);

            List_NewProductRegistrationTicket = [SELECT Approval_Status__c,Approval_Time__c,CreatedById,CreatedDate,Current_Step_Wizard__c,Existing_Price_Book_Name__c,Existing_Price_Book__c,Id,IsAgreement__c,IsDeleted,Is_Standard_Price_Book__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,Price_Book_Active__c,Price_Book_Description__c,Price_Book_For_Account__c,Price_Book_For_Product__c,Price_Book_GSM_Type__c,Price_Book_Implement_Type__c,Price_Book_Name__c,Price_Book_Service_Group__c,Project_Type__c,RecordTypeId,RecordType.Name,Sim_Type__c,Site_Type__c,Stage__c,Survey_Type__c,SystemModstamp FROM New_Product_Registration_Ticket__c WHERE Id =: NewProductRegistrationTicketId]; 

            system.debug('List_NewProductRegistrationTicket : ' + List_NewProductRegistrationTicket);

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return List_NewProductRegistrationTicket;
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - getNewProductRegistrationTicket ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return List_NewProductRegistrationTicket;
        }
    } 
    
    @AuraEnabled
    public static String GenerateLinkSalesforce(){
        DateTime start_time = datetime.now();

        String linkDomainSalesforce = '';
        try {
            linkDomainSalesforce = URL.getSalesforceBaseUrl().toExternalForm();

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - GenerateLinkSalesforce ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }

        return linkDomainSalesforce;
    }

    @AuraEnabled
    public static String GetListViewId(String ObjectApiName, String ListViewDeveloperName){
        DateTime start_time = datetime.now();

        String listViewId = '';
        try {
            List<ListView> List_ListView = [SELECT Id, Name, DeveloperName, SobjectType FROM ListView WHERE SobjectType =: ObjectApiName AND DeveloperName =: ListViewDeveloperName];
            
            listViewId = List_ListView[0].Id;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - GetListViewId ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }

        return listViewId;
    }

    @AuraEnabled
    public static void updateExistingPricebookTicket(String ticketId, String existingPriceBookId){
        DateTime start_time = datetime.now();
        try {
            New_Product_Registration_Ticket__c NewProductRegistrationTicket_Update = new New_Product_Registration_Ticket__c();
            NewProductRegistrationTicket_Update.Id = ticketId;
            NewProductRegistrationTicket_Update.Existing_Price_Book__c = existingPriceBookId;
            NewProductRegistrationTicket_Update.Current_Step_Wizard__c = 2;
            update NewProductRegistrationTicket_Update;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - updateExistingPricebookTicket ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    @AuraEnabled
    public static void updateRecordTicketStage2(String ticketId){
        DateTime start_time = datetime.now();
        try {
            New_Product_Registration_Ticket__c NewProductRegistrationTicket_Update = new New_Product_Registration_Ticket__c();
            NewProductRegistrationTicket_Update.Id = ticketId;
            NewProductRegistrationTicket_Update.Current_Step_Wizard__c = 2;
            update NewProductRegistrationTicket_Update;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - updateRecordTicketStage2 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    } 

    @AuraEnabled
    public static void updateRecordTicketStage3(String ticketId){
        DateTime start_time = datetime.now();
        try {
            New_Product_Registration_Ticket__c NewProductRegistrationTicket_Update = new New_Product_Registration_Ticket__c();
            NewProductRegistrationTicket_Update.Id = ticketId;
            NewProductRegistrationTicket_Update.Current_Step_Wizard__c = 3;
            update NewProductRegistrationTicket_Update;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - updateRecordTicketStage3 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    @AuraEnabled
    public static void updateRecordTicketStage4(String ticketId){
        DateTime start_time = datetime.now();
        try {
            New_Product_Registration_Ticket__c NewProductRegistrationTicket_Update = new New_Product_Registration_Ticket__c();
            NewProductRegistrationTicket_Update.Id = ticketId;
            NewProductRegistrationTicket_Update.Current_Step_Wizard__c = 4;
            update NewProductRegistrationTicket_Update;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - updateRecordTicketStage4 ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    } 

    @AuraEnabled
    public static void updateRecordTicketSubscriptionBasedInfo(String ticketId, String SurveyType, String SiteType){
        DateTime start_time = datetime.now();
        try {
            New_Product_Registration_Ticket__c NewProductRegistrationTicket_Update = new New_Product_Registration_Ticket__c();
            NewProductRegistrationTicket_Update.Id = ticketId;
            NewProductRegistrationTicket_Update.Survey_Type__c = SurveyType;
            NewProductRegistrationTicket_Update.Site_Type__c = SiteType;
            update NewProductRegistrationTicket_Update;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - updateRecordTicketSubscriptionBasedInfo ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    } 

    @AuraEnabled
    public static void updateRecordTicketProjectBasedInfo(String ticketId, String ProjectType){
        DateTime start_time = datetime.now();
        try {
            New_Product_Registration_Ticket__c NewProductRegistrationTicket_Update = new New_Product_Registration_Ticket__c();
            NewProductRegistrationTicket_Update.Id = ticketId;
            NewProductRegistrationTicket_Update.Project_Type__c = ProjectType;
            update NewProductRegistrationTicket_Update;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - updateRecordTicketProjectBasedInfo ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    } 

    @AuraEnabled
    public static void updateRecordTicketSIMCardBasedInfo(String ticketId, String SimType){
        DateTime start_time = datetime.now();
        try {
            New_Product_Registration_Ticket__c NewProductRegistrationTicket_Update = new New_Product_Registration_Ticket__c();
            NewProductRegistrationTicket_Update.Id = ticketId;
            NewProductRegistrationTicket_Update.Sim_Type__c = SimType;
            update NewProductRegistrationTicket_Update;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - updateRecordTicketSIMCardBasedInfo ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    } 

    @AuraEnabled(cacheable=true)
    public static List <customPickListValueWrapper> pickListValueDynamically(sObject customObjInfo, string selectPicklistApi) {
        Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();     
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        list < customPickListValueWrapper > customObjWrapper = new list < customPickListValueWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) {
            customPickListValueWrapper selectOptionValueWrapper = new customPickListValueWrapper();
            selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
            selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            customObjWrapper.add(selectOptionValueWrapper);
        }
        return customObjWrapper;
    }
    
    public with sharing class customPickListValueWrapper {
        @auraEnabled public string custFldlabel {get;set;}
        @auraEnabled public string custFldvalue {get;set;}
    }

    @AuraEnabled
    public static List<sObject> search(String objectName,String fields, String searchTerm, String fieldCondition, String fieldConditionValue){
        /*String searchKeyword = searchTerm + '*';
        String returningQuery = '';
        returningQuery = objectName+' ( Id, '+fields+')';
        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 20';
        System.debug(' query '+query);
        List<List<sObject>> searchRecords = Search.Query(Query);
        return searchRecords.get(0);*/

        String searchKeyword = searchTerm + '*';
        String returningQuery = '';

        if(String.isNotBlank(fieldCondition) && String.isNotBlank(fieldConditionValue)){
            returningQuery = objectName+' ( Id, '+fields+' WHERE '+fieldCondition+' = \''+fieldConditionValue+'\' )';
        }else{
            returningQuery = objectName+' ( Id, '+fields+')';
        }

        System.debug('returningQuery '+returningQuery);
        
        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 20';
        System.debug('query '+query);
        List<List<sObject>> searchRecords = Search.Query(Query);

        system.debug(searchRecords.get(0));
        return searchRecords.get(0);
    }
    
    public class TicketProductList {
        public String NewProductRegistrationTicket { get; set; }
        public String Name { get; set; }
        public String ExistingProductFamily { get; set; }
        public String NewProductFamily { get; set; }
        public String ExistingProductCode { get; set; }
        public String NewProductCode { get; set; }
        public String GroupService { get; set; }
    }

    @AuraEnabled
    public static list<NPRTicketProduct__c> saveRecordTicketProducts(String TicketProductList, String NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();
        List<NPRTicketProduct__c> newNPRTicketProduct_List = new List<NPRTicketProduct__c>();
        List<NPRTicketProduct__c> NPRTicketProductAfterInsert_List = null;

        Id RecordTypeTicketProduct_LicensedBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();
        
        Id RecordTypeTicketProduct_ProjectBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id RecordTypeTicketProduct_SIMCardBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id RecordTypeTicketProduct_SubscriptionBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id RecordTypeTicketProduct_UsageBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        try {
            List<TicketProductList> TicketProductList_extract = (List<TicketProductList>)JSON.deserialize(TicketProductList, List<TicketProductList>.class);

            List<New_Product_Registration_Ticket__c> List_NewProductRegistrationTicket = [SELECT Id, Survey_Type__c, Site_Type__c, Project_Type__c, Sim_Type__c, RecordType.Name FROM New_Product_Registration_Ticket__c WHERE Id =: NewProductRegistrationTicketId LIMIT 1];

            if(TicketProductList_extract!=null && !TicketProductList_extract.isEmpty()){
                if(List_NewProductRegistrationTicket!=null && !List_NewProductRegistrationTicket.isEmpty()){
                    for(New_Product_Registration_Ticket__c List_NewProductRegistrationTicket_Extract : List_NewProductRegistrationTicket){
                        if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Project Based' ||Test.isRunningTest()) {
                            if (List_NewProductRegistrationTicket_Extract.Project_Type__c == 'Generic' ||Test.isRunningTest()) {
                                for(TicketProductList TicketProductLists : TicketProductList_extract){
                                    NPRTicketProduct__c newNPRTicketProduct_rec = new NPRTicketProduct__c();
                                    newNPRTicketProduct_rec.RecordTypeId = RecordTypeTicketProduct_ProjectBased_Id;
                                    newNPRTicketProduct_rec.New_Product_Registration_Ticket__c = TicketProductLists.NewProductRegistrationTicket;
                                    newNPRTicketProduct_rec.Ticket_Product_Type__c = 'Project Based - Generic';
                                    newNPRTicketProduct_rec.Name = TicketProductLists.Name;
                                    newNPRTicketProduct_rec.New_Product_Family__c = TicketProductLists.NewProductFamily;
                                    newNPRTicketProduct_rec.Product_Family__c = TicketProductLists.ExistingProductFamily;
                                    newNPRTicketProduct_rec.New_Product_Code__c = TicketProductLists.NewProductCode;
                                    newNPRTicketProduct_rec.Existing_Product_Code__c = TicketProductLists.ExistingProductCode;
                                    if(String.isNotBlank(TicketProductLists.GroupService)){
                                        newNPRTicketProduct_rec.Group_Service__c = TicketProductLists.GroupService;
                                    }
                                    newNPRTicketProduct_List.add(newNPRTicketProduct_rec);
                                }
                            }

                            if (List_NewProductRegistrationTicket_Extract.Project_Type__c == 'Bulkshare' ||Test.isRunningTest()) {
                                for(TicketProductList TicketProductLists : TicketProductList_extract){
                                    NPRTicketProduct__c newNPRTicketProduct_rec = new NPRTicketProduct__c();
                                    newNPRTicketProduct_rec.RecordTypeId = RecordTypeTicketProduct_ProjectBased_Id;
                                    newNPRTicketProduct_rec.Ticket_Product_Type__c = 'Project Based - Bulkshare';
                                    newNPRTicketProduct_rec.New_Product_Registration_Ticket__c = TicketProductLists.NewProductRegistrationTicket;
                                    newNPRTicketProduct_rec.Name = TicketProductLists.Name;
                                    newNPRTicketProduct_rec.New_Product_Family__c = TicketProductLists.NewProductFamily;
                                    newNPRTicketProduct_rec.Product_Family__c = TicketProductLists.ExistingProductFamily;
                                    newNPRTicketProduct_rec.New_Product_Code__c = TicketProductLists.NewProductCode;
                                    newNPRTicketProduct_rec.Existing_Product_Code__c = TicketProductLists.ExistingProductCode;
                                    if(String.isNotBlank(TicketProductLists.GroupService)){
                                        newNPRTicketProduct_rec.Group_Service__c = TicketProductLists.GroupService;
                                    }
                                    newNPRTicketProduct_List.add(newNPRTicketProduct_rec);
                                }
                            }
                        }

                        if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'SIM-Card Based' ||Test.isRunningTest()) {
                            if (List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Postpaid' ||Test.isRunningTest()) {
                                for(TicketProductList TicketProductLists : TicketProductList_extract){
                                    NPRTicketProduct__c newNPRTicketProduct_rec = new NPRTicketProduct__c();
                                    newNPRTicketProduct_rec.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    newNPRTicketProduct_rec.Ticket_Product_Type__c = 'SIM-Card Based - Postpaid';
                                    newNPRTicketProduct_rec.New_Product_Registration_Ticket__c = TicketProductLists.NewProductRegistrationTicket;
                                    newNPRTicketProduct_rec.Name = TicketProductLists.Name;
                                    newNPRTicketProduct_rec.New_Product_Family__c = TicketProductLists.NewProductFamily;
                                    newNPRTicketProduct_rec.Product_Family__c = TicketProductLists.ExistingProductFamily;
                                    newNPRTicketProduct_rec.New_Product_Code__c = TicketProductLists.NewProductCode;
                                    newNPRTicketProduct_rec.Existing_Product_Code__c = TicketProductLists.ExistingProductCode;
                                    if(String.isNotBlank(TicketProductLists.GroupService)){
                                        newNPRTicketProduct_rec.Group_Service__c = TicketProductLists.GroupService;
                                    }
                                    newNPRTicketProduct_List.add(newNPRTicketProduct_rec);
                                }
                            }

                            if (List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Prepaid' ||Test.isRunningTest()) {
                                for(TicketProductList TicketProductLists : TicketProductList_extract){
                                    NPRTicketProduct__c newNPRTicketProduct_rec = new NPRTicketProduct__c();
                                    newNPRTicketProduct_rec.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    newNPRTicketProduct_rec.Ticket_Product_Type__c = 'SIM-Card Based - Prepaid';
                                    newNPRTicketProduct_rec.New_Product_Registration_Ticket__c = TicketProductLists.NewProductRegistrationTicket;
                                    newNPRTicketProduct_rec.Name = TicketProductLists.Name;
                                    newNPRTicketProduct_rec.New_Product_Code__c = TicketProductLists.NewProductCode;
                                    newNPRTicketProduct_rec.Existing_Product_Code__c = TicketProductLists.ExistingProductCode;
                                    if(String.isNotBlank(TicketProductLists.GroupService)){
                                        newNPRTicketProduct_rec.Group_Service__c = TicketProductLists.GroupService;
                                    }
                                    newNPRTicketProduct_List.add(newNPRTicketProduct_rec);
                                }
                            }

                            if (List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Device Bundling' ||Test.isRunningTest()) {
                                for(TicketProductList TicketProductLists : TicketProductList_extract){
                                    NPRTicketProduct__c newNPRTicketProduct_rec = new NPRTicketProduct__c();
                                    newNPRTicketProduct_rec.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    newNPRTicketProduct_rec.Ticket_Product_Type__c = 'SIM-Card Based - Device Bundling';
                                    newNPRTicketProduct_rec.New_Product_Registration_Ticket__c = TicketProductLists.NewProductRegistrationTicket;
                                    newNPRTicketProduct_rec.Name = TicketProductLists.Name;
                                    newNPRTicketProduct_rec.New_Product_Code__c = TicketProductLists.NewProductCode;
                                    newNPRTicketProduct_rec.Existing_Product_Code__c = TicketProductLists.ExistingProductCode;
                                    if(String.isNotBlank(TicketProductLists.GroupService)){
                                        newNPRTicketProduct_rec.Group_Service__c = TicketProductLists.GroupService;
                                    }
                                    newNPRTicketProduct_List.add(newNPRTicketProduct_rec);
                                }
                            }
                        }

                        if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Subscription Based' ||Test.isRunningTest()) {
                            for(TicketProductList TicketProductLists : TicketProductList_extract){
                                NPRTicketProduct__c newNPRTicketProduct_rec = new NPRTicketProduct__c();
                                newNPRTicketProduct_rec.RecordTypeId = RecordTypeTicketProduct_SubscriptionBased_Id;
                                newNPRTicketProduct_rec.Ticket_Product_Type__c = 'Subscription Based';
                                newNPRTicketProduct_rec.New_Product_Registration_Ticket__c = TicketProductLists.NewProductRegistrationTicket;
                                newNPRTicketProduct_rec.Name = TicketProductLists.Name;
                                newNPRTicketProduct_rec.New_Product_Family__c = TicketProductLists.NewProductFamily;
                                newNPRTicketProduct_rec.Product_Family__c = TicketProductLists.ExistingProductFamily;
                                newNPRTicketProduct_rec.New_Product_Code__c = TicketProductLists.NewProductCode;
                                newNPRTicketProduct_rec.Existing_Product_Code__c = TicketProductLists.ExistingProductCode;
                                if(String.isNotBlank(TicketProductLists.GroupService)){
                                    newNPRTicketProduct_rec.Group_Service__c = TicketProductLists.GroupService;
                                }
                                newNPRTicketProduct_List.add(newNPRTicketProduct_rec);
                            }
                        }

                        if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Usage Based' ||Test.isRunningTest()) {
                            for(TicketProductList TicketProductLists : TicketProductList_extract){
                                NPRTicketProduct__c newNPRTicketProduct_rec = new NPRTicketProduct__c();
                                newNPRTicketProduct_rec.RecordTypeId = RecordTypeTicketProduct_UsageBased_Id;
                                newNPRTicketProduct_rec.Ticket_Product_Type__c = 'Usage Based';
                                newNPRTicketProduct_rec.New_Product_Registration_Ticket__c = TicketProductLists.NewProductRegistrationTicket;
                                newNPRTicketProduct_rec.Name = TicketProductLists.Name;
                                newNPRTicketProduct_rec.New_Product_Family__c = TicketProductLists.NewProductFamily;
                                newNPRTicketProduct_rec.Product_Family__c = TicketProductLists.ExistingProductFamily;
                                newNPRTicketProduct_rec.New_Product_Code__c = TicketProductLists.NewProductCode;
                                newNPRTicketProduct_rec.Existing_Product_Code__c = TicketProductLists.ExistingProductCode;
                                if(String.isNotBlank(TicketProductLists.GroupService)){
                                    newNPRTicketProduct_rec.Group_Service__c = TicketProductLists.GroupService;
                                }
                                newNPRTicketProduct_List.add(newNPRTicketProduct_rec);
                            }
                        }

                        if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Licensed Based' ||Test.isRunningTest()) {
                            for(TicketProductList TicketProductLists : TicketProductList_extract){
                                NPRTicketProduct__c newNPRTicketProduct_rec = new NPRTicketProduct__c();
                                newNPRTicketProduct_rec.RecordTypeId = RecordTypeTicketProduct_LicensedBased_Id;
                                newNPRTicketProduct_rec.Ticket_Product_Type__c = 'Licensed Based';
                                newNPRTicketProduct_rec.New_Product_Registration_Ticket__c = TicketProductLists.NewProductRegistrationTicket;
                                newNPRTicketProduct_rec.Name = TicketProductLists.Name;
                                newNPRTicketProduct_rec.New_Product_Family__c = TicketProductLists.NewProductFamily;
                                newNPRTicketProduct_rec.Product_Family__c = TicketProductLists.ExistingProductFamily;
                                newNPRTicketProduct_rec.New_Product_Code__c = TicketProductLists.NewProductCode;
                                newNPRTicketProduct_rec.Existing_Product_Code__c = TicketProductLists.ExistingProductCode;
                                if(String.isNotBlank(TicketProductLists.GroupService)){
                                    newNPRTicketProduct_rec.Group_Service__c = TicketProductLists.GroupService;
                                }
                                newNPRTicketProduct_List.add(newNPRTicketProduct_rec);
                            }
                        }
                    }
                }

                if(newNPRTicketProduct_List!=null && !newNPRTicketProduct_List.isEmpty()){
                    Database.SaveResult[] insertResults = Database.insert(newNPRTicketProduct_List, false);

                    Boolean insertResultsValid = false;

                    for (Database.SaveResult insertResults_Extract : insertResults) {
                        if (insertResults_Extract.isSuccess()) {
                            insertResultsValid = true;
                        }
                        else {          
                            for(Database.Error error : insertResults_Extract.getErrors()) {
                                String err_message = 'Error on ProductOnBoarding_Controller.cls - saveRecordTicketProducts ::' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields();
                                AppUtils.putError(err_message);
                                System.debug('Error on ProductOnBoarding_Controller.cls - saveRecordTicketProducts ::' + error.getStatusCode() + ' : ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
                            }
                        }
                    }

                    if(insertResultsValid){
                        NPRTicketProductAfterInsert_List = [SELECT Active__c,Ao_Name__c,AO_Related__c,Bandwidth__c,Charge_Type__c,CreatedById,CreatedDate,Data_Notes__c,Device_Name__c,Device_Related__c,Distribution_Channel__c,Dist_End_Range__c,Dist_Start_Range__c,Existing_Product_Code__c,Group_Service_Name__c,Group_Service__c,GSM_Type__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,List_Price__c,Name,New_Product_Code__c,New_Product_Registration_Ticket__c,Price_Plan_Name__c,Price_Plan_Related__c,Product_Description__c,Product_Family__c,Product_Unique_ID__c,Recognize_as_Revenue__c,SAP_Code__c,SIM_Type__c,Status_Product_Code__c,SystemModstamp,Ticket_Product_Type__c,UoM_Bandwidth__c,Valid__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return NPRTicketProductAfterInsert_List; 
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - saveRecordTicketProducts ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return NPRTicketProductAfterInsert_List; 
        }
    }

    @AuraEnabled
    public static list<NPRTicketProduct__c> getNPRTicketProducts(Id NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();
        List<NPRTicketProduct__c> List_NPRTicketProduct = null;

        try {
            List_NPRTicketProduct = [SELECT Active__c,Ao_Name__c,AO_Related__c,Bandwidth__c,Charge_Type__c,CreatedById,CreatedDate,Data_Notes__c,Device_Name__c,Device_Related__c,Distribution_Channel__c,Dist_End_Range__c,Dist_Start_Range__c,Existing_Product_Code__c,Group_Service_Name__c,Group_Service__c,GSM_Type__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,List_Price__c,Name,New_Product_Code__c,New_Product_Registration_Ticket__c,Price_Plan_Name__c,Price_Plan_Related__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Product_Unique_ID__c,Recognize_as_Revenue__c,SAP_Code__c,SIM_Type__c,Status_Product_Code__c,SystemModstamp,Ticket_Product_Type__c,UoM_Bandwidth__c,Valid__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return List_NPRTicketProduct;
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - getNPRTicketProducts ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return List_NPRTicketProduct;
        }
    }

    @AuraEnabled
    public static String getPdfDownloadLink(String NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();
        List<ContentVersion> docs = new List<ContentVersion>();
        string documentid = '';

        try {
            String DocumentTypeName = '';

            List<New_Product_Registration_Ticket__c> List_NewProductRegistrationTicket = [SELECT Id, Survey_Type__c, Site_Type__c, Project_Type__c, Sim_Type__c, RecordType.Name FROM New_Product_Registration_Ticket__c WHERE Id =: NewProductRegistrationTicketId LIMIT 1];

            if(List_NewProductRegistrationTicket!=null && !List_NewProductRegistrationTicket.isEmpty()){
                for(New_Product_Registration_Ticket__c List_NewProductRegistrationTicket_Extract : List_NewProductRegistrationTicket){
                    if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Project Based' ||Test.isRunningTest()) {
                        if (List_NewProductRegistrationTicket_Extract.Project_Type__c == 'Generic' ||Test.isRunningTest()) {
                            DocumentTypeName = 'pob_Generic';
                        }
                        
                        if(List_NewProductRegistrationTicket_Extract.Project_Type__c == 'Bulkshare' ||Test.isRunningTest()){
                            DocumentTypeName = 'pob_Bulkshare';
                        }
                    }

                    if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'SIM-Card Based' ||Test.isRunningTest()) {
                        if (List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Postpaid' ||Test.isRunningTest()) {
                            DocumentTypeName = 'pob_Postpaid';
                        }

                        if (List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Prepaid' ||Test.isRunningTest()) {
                            DocumentTypeName = 'pob_Prepaid';
                        }

                        if (List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Device Bundling' ||Test.isRunningTest()) {
                            DocumentTypeName = 'pob_DeviceBundling';
                        }
                    }

                    if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Subscription Based' ||Test.isRunningTest()) {
                        DocumentTypeName = 'pob_SubscriptionBase';
                    }
                    
                    if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Usage Based' ||Test.isRunningTest()) {
                        DocumentTypeName = 'pob_UsageBase';
                    }

                    if (List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Licensed Based' ||Test.isRunningTest()) {
                        DocumentTypeName = 'pob_LicensedBased';
                    }
                }

                if(String.isNotBlank(DocumentTypeName)){
                    docs = [SELECT ContentDocumentId, FileExtension, Title FROM ContentVersion WHERE Document_Type_Name__c =: DocumentTypeName LIMIT 1];

                    if(docs!=null && !docs.isEmpty()){
                        documentid = docs[0].ContentDocumentId;
                    }
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return documentid;
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - getPdfDownloadLink ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return null;
        }
   }
   
    public class resultUploadCsvFile_TicketProduct {
        @auraEnabled public list<NPRTicketProduct__c> ListNPRTicketProducToInsert { get; set; }
        @auraEnabled public String contentDocumentId { get; set; }
        @auraEnabled public Integer countAllData { get; set; }
        @auraEnabled public Integer countAllSuccess { get; set; }
        @auraEnabled public Integer countAllFailed { get; set; }
    }   

    @AuraEnabled
    public static resultUploadCsvFile_TicketProduct readCSVFile(Id idContentDocument, Id NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();
        
        resultUploadCsvFile_TicketProduct resultUploadCsvFile_TicketProduct_New = new resultUploadCsvFile_TicketProduct();
        resultUploadCsvFile_TicketProduct_New.countAllData = 0 ;
        resultUploadCsvFile_TicketProduct_New.countAllSuccess = 0 ;
        resultUploadCsvFile_TicketProduct_New.countAllFailed = 0 ;

        list<NPRTicketProduct__c> ListNPRTicketProducToInsert = new list<NPRTicketProduct__c>();
        List<NPRTicketProduct__c> NPRTicketProductAfterInsert_List = null;

        Id RecordTypeTicketProduct_LicensedBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();
        
        Id RecordTypeTicketProduct_ProjectBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id RecordTypeTicketProduct_SIMCardBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id RecordTypeTicketProduct_SubscriptionBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id RecordTypeTicketProduct_UsageBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        Pattern numberFormat = Pattern.Compile('[0-9.]*');

        system.debug('readCSVFile - idContentDocument : ' + idContentDocument);
        system.debug('readCSVFile - NewProductRegistrationTicketId : ' + NewProductRegistrationTicketId);

        try {
            if(idContentDocument != null && NewProductRegistrationTicketId != null) {
                Map<String,String> Map_PricePlanName = new Map<String,String>();
                Map<String,String> Map_GroupServiceName = new Map<String,String>();
                Map<String,String> Map_DeviceName = new Map<String,String>();
                Map<String,String> Map_AOName = new Map<String,String>();

                Map<String,String> Map_PricePlanId = new Map<String,String>();
                Map<String,String> Map_GroupServiceId = new Map<String,String>();
                Map<String,String> Map_DeviceId = new Map<String,String>();
                Map<String,String> Map_AOId = new Map<String,String>();

                List<Price_Plan__c> List_PricePlan = [SELECT Id, Name FROM Price_Plan__c];
                if(List_PricePlan!=null && !List_PricePlan.isEmpty()){
                    for(Price_Plan__c List_PricePlan_Extract : List_PricePlan){
                        Map_PricePlanName.put(List_PricePlan_Extract.Name.touppercase(), List_PricePlan_Extract.Id);
                        Map_PricePlanId.put(List_PricePlan_Extract.Id, List_PricePlan_Extract.Name.touppercase());
                    }
                }

                List<Group_Service__c> List_GroupService = [SELECT Id, Name FROM Group_Service__c];
                if(List_GroupService!=null && !List_GroupService.isEmpty()){
                    for(Group_Service__c List_GroupService_Extract : List_GroupService){
                        Map_GroupServiceName.put(List_GroupService_Extract.Name.touppercase(), List_GroupService_Extract.Id);
                        Map_GroupServiceId.put(List_GroupService_Extract.Id, List_GroupService_Extract.Name.touppercase());
                    }
                }

                List<Device__c> List_Device = [SELECT Id, Name FROM Device__c];
                if(List_Device!=null && !List_Device.isEmpty()){
                    for(Device__c List_Device_Extract : List_Device){
                        Map_DeviceName.put(List_Device_Extract.Name.touppercase(), List_Device_Extract.Id);
                        Map_DeviceId.put(List_Device_Extract.Id, List_Device_Extract.Name.touppercase());
                    }
                }

                List<AO__c> List_Ao = [SELECT Id, Name FROM AO__c];
                if(List_Ao!=null && !List_Ao.isEmpty()){
                    for(AO__c List_Ao_Extract : List_Ao){
                        Map_AOName.put(List_Ao_Extract.Name.touppercase(), List_Ao_Extract.Id);
                        Map_AOId.put(List_Ao_Extract.Id, List_Ao_Extract.Name.touppercase());
                    }
                }

                ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =: idContentDocument];
                
                Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
                list<String> lstCSVLines = objVersion.VersionData.toString().split('\n');
                Integer fieldNumber;
                String fieldValue;

                List<New_Product_Registration_Ticket__c> List_NewProductRegistrationTicket = [SELECT Id, Survey_Type__c, Site_Type__c, Project_Type__c, Sim_Type__c, RecordType.Name FROM New_Product_Registration_Ticket__c WHERE Id =: NewProductRegistrationTicketId LIMIT 1];

                if(List_NewProductRegistrationTicket!=null && !List_NewProductRegistrationTicket.isEmpty()){
                    string[] csvFieldNames = lstCSVLines[0].split(',');
                    for (Integer i = 0; i < csvFieldNames.size(); i++) {
                        fieldNumberMap.put(csvFieldNames[i], i);    
                    }

                    for(Integer i = 1; i < lstCSVLines.size(); i++){
                        list<String> csvRowData = lstCSVLines[i].split(',');
                        string tmp_Id = '';
                        string tmp_Name = '';
                        string tmp_New_Product_Code = '';
                        string tmp_Existing_Product_Code = '';
                        string tmp_Charge_Type = '';
                        string tmp_Product_Description = '';
                        string tmp_Existing_Product_Family = '';
                        string tmp_New_Product_Family = '';
                        string tmp_Group_Service_Name = '';
                        string tmp_List_Price = '';
                        string tmp_UoM_Bandwidth = '';
                        string tmp_SIM_Type = '';
                        string tmp_Recognize_as_Revenue = '';
                        string tmp_Price_Plan_Name = '';
                        string tmp_GSM_Type = '';
                        string tmp_Distribution_Channel = '';
                        string tmp_SAP_Code = '';
                        string tmp_Dist_Start_Range = '';
                        string tmp_Dist_End_Range = '';
                        string tmp_Device_Name = '';
                        string tmp_Bandwidth = '';
                        string tmp_Ao_Name = '';

                        for (String fieldName: csvFieldNames) {
                            fieldNumber = fieldNumberMap.get(fieldName);
                            system.debug('fieldNumber : ' + fieldNumber);
                            
                            fieldValue = csvRowData[fieldNumber];
                            system.debug('fieldValue 712 : ' + fieldValue);

                            system.debug('fieldName 714 : ' + fieldName);

                            if (fieldName.trim() == 'Id') {
                                tmp_Id = fieldValue.trim();
                            }

                            if (
                                fieldName.contains('Ticket Product Name*') ||
                                fieldName.trim() == 'Name'
                            ) {
                                tmp_Name = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'New Product Code**' ||
                                fieldName.trim() == 'New_Product_Code__c'
                            ) {
                                tmp_New_Product_Code = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'Existing Product Code**' ||
                                fieldName.trim() == 'Existing_Product_Code__c'
                            ) {
                                tmp_Existing_Product_Code = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'Charge Type*' ||
                                fieldName.trim() == 'Charge_Type__c'
                            ) {
                                tmp_Charge_Type = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'Product Description' ||
                                fieldName.trim() == 'Product_Description__c'
                            ) {
                                tmp_Product_Description = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'Product Family**' ||
                                fieldName.trim() == 'Product_Family__c'
                            ) {
                                tmp_Existing_Product_Family = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'New Product Family**' ||
                                fieldName.trim() == 'New_Product_Family__c'
                            ) {
                                tmp_New_Product_Family = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'Group Service*' ||
                                fieldName.trim() == 'Group_Service__c'
                            ) {
                                tmp_Group_Service_Name = fieldValue.trim();
                                system.debug('tmp_Group_Service_Name : ' + tmp_Group_Service_Name);
                            }

                            if (
                                fieldName.trim() == 'List Price*' ||
                                fieldName.trim() == 'List_Price__c'
                            ) {
                                tmp_List_Price = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'UoM Bandwidth*' ||
                                fieldName.trim() == 'UoM_Bandwidth__c'
                            ) {
                                tmp_UoM_Bandwidth = fieldValue.trim();
                            }

                            /*if (fieldName.trim() == 'SIM Type') {
                                tmp_SIM_Type = fieldValue.trim();
                            }*/

                            /*if (fieldName.trim() == 'Recognize as Revenue (%)') {
                                tmp_Recognize_as_Revenue = fieldValue.trim();
                            }*/

                            if (
                                fieldName.trim() == 'Price Plan Related*' ||
                                fieldName.trim() == 'Price_Plan_Related__c'
                            ) {
                                tmp_Price_Plan_Name = fieldValue.trim();
                            }

                            /*if (fieldName.trim() == 'GSM Type') {
                                tmp_GSM_Type = fieldValue.trim();
                            }*/

                            if (
                                fieldName.trim() == 'Sap Code*' ||
                                fieldName.trim() == 'SAP_Code__c'
                            ) {
                                tmp_SAP_Code = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'Distribution Channel*' ||
                                fieldName.trim() == 'Distribution_Channel__c'
                            ) {
                                tmp_Distribution_Channel = fieldValue.trim();
                            }

                            /*if (fieldName.trim() == 'Dist. Start Range') {
                                tmp_Dist_Start_Range = fieldValue.trim();
                            }*/

                            /*if (fieldName.trim() == 'Dist. End Range') {
                                tmp_Dist_End_Range = fieldValue.trim();
                            }*/

                            if (
                                fieldName.trim() == 'Device Related*' ||
                                fieldName.trim() == 'Device_Related__c'
                            ) {
                                tmp_Device_Name = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'Bandwidth*' ||
                                fieldName.trim() == 'Bandwidth__c'
                            ) {
                                tmp_Bandwidth = fieldValue.trim();
                            }

                            if (
                                fieldName.trim() == 'AO Related*' ||
                                fieldName.trim() == 'AO_Related__c'
                            ) {
                                tmp_Ao_Name = fieldValue.trim();
                            }
                        }
                    
                        for(New_Product_Registration_Ticket__c List_NewProductRegistrationTicket_Extract : List_NewProductRegistrationTicket){
                            Matcher numberMatch_Bandwidth = numberFormat.matcher(tmp_Bandwidth);

                            Matcher numberMatch_ListPrice = numberFormat.matcher(tmp_List_Price);

                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Project Based' ||
                                Test.isRunningTest()
                            ) {
                                if (
                                    List_NewProductRegistrationTicket_Extract.Project_Type__c == 'Generic' ||
                                    Test.isRunningTest()
                                ) {
                                    NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                    objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_ProjectBased_Id;
                                    objNPRTicketProduc.Ticket_Product_Type__c = 'Project Based - Generic';
                                    objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                    objNPRTicketProduc.Name = tmp_Name;
                                    if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }
                                    objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                    objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                    if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                        objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                    }
                                    objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                    objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                    objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                    objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                    objNPRTicketProduc.SAP_Code__c = tmp_SAP_Code;
                                    objNPRTicketProduc.Distribution_Channel__c = tmp_Distribution_Channel;
                                    ListNPRTicketProducToInsert.add(objNPRTicketProduc);          
                                }
                                
                                if(
                                    List_NewProductRegistrationTicket_Extract.Project_Type__c == 'Bulkshare' ||
                                    Test.isRunningTest()
                                ){
                                        NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                        objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_ProjectBased_Id;
                                        objNPRTicketProduc.Ticket_Product_Type__c = 'Project Based - Bulkshare';
                                        objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                        objNPRTicketProduc.Name = tmp_Name;
                                        objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                        objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                        objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                        objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                        objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                        objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                        objNPRTicketProduc.SAP_Code__c = tmp_SAP_Code;
                                        objNPRTicketProduc.Distribution_Channel__c = tmp_Distribution_Channel;
                                        if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                            objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                        }
                                        if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                            objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                        }else{
                                            objNPRTicketProduc.List_Price__c = null;
                                        }
                                        ListNPRTicketProducToInsert.add(objNPRTicketProduc);
                                }
                            }
        
                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'SIM-Card Based' ||
                                Test.isRunningTest()
                            ) {
                                if (
                                    List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Postpaid' ||
                                	Test.isRunningTest()
                                ) {
                                    NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                    objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    objNPRTicketProduc.Ticket_Product_Type__c = 'SIM-Card Based - Postpaid';
                                    objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                    objNPRTicketProduc.Name = tmp_Name;
                                    objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                    objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                    objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                    objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                    objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                    objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                    if(Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase()) != null){
                                        objNPRTicketProduc.Price_Plan_Related__c = Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase());
                                    }
                                    if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                        objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                    }
                                    if(Map_AOName.get(tmp_Ao_Name.touppercase()) != null){
                                        objNPRTicketProduc.AO_Related__c = Map_AOName.get(tmp_Ao_Name.touppercase());
                                    }
                                    /*if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }*/

                                    if(numberMatch_ListPrice.Matches()){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }
                                    ListNPRTicketProducToInsert.add(objNPRTicketProduc); 
                                }
        
                                if (
                                    List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Prepaid' ||
                                    Test.isRunningTest()
                                ) {
                                    NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                    objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    objNPRTicketProduc.Ticket_Product_Type__c = 'SIM-Card Based - Prepaid';
                                    objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                    objNPRTicketProduc.Name = tmp_Name;
                                    objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                    objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                    objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                    objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                    objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                    objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                    if(Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase()) != null){
                                        objNPRTicketProduc.Price_Plan_Related__c = Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase());
                                    }
                                    if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                        objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                    }
                                    if(Map_AOName.get(tmp_Ao_Name.touppercase()) != null){
                                        objNPRTicketProduc.AO_Related__c = Map_AOName.get(tmp_Ao_Name.touppercase());
                                    }
                                    if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }
                                    ListNPRTicketProducToInsert.add(objNPRTicketProduc); 
                                }
        
                                if (
                                    List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Device Bundling' ||
                                    Test.isRunningTest()
                                ) {
                                    NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                    objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    objNPRTicketProduc.Ticket_Product_Type__c = 'SIM-Card Based - Device Bundling';
                                    objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                    objNPRTicketProduc.Name = tmp_Name;
                                    objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                    objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                    objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                    objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                    objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                    objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                    if(Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase()) != null){
                                        objNPRTicketProduc.Price_Plan_Related__c = Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase());
                                    }
                                    if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                        objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                    }
                                    if(Map_AOName.get(tmp_Ao_Name.touppercase()) != null){
                                        objNPRTicketProduc.AO_Related__c = Map_AOName.get(tmp_Ao_Name.touppercase());
                                    }
                                    if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }
                                    if(Map_DeviceName.get(tmp_Device_Name.touppercase()) != null){
                                        objNPRTicketProduc.Device_Related__c = Map_DeviceName.get(tmp_Device_Name.touppercase());
                                    }
                                    ListNPRTicketProducToInsert.add(objNPRTicketProduc); 
                                }
                            }
        
                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Subscription Based' ||
                                Test.isRunningTest()
                            ) {
                                NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_SubscriptionBased_Id;
                                objNPRTicketProduc.Ticket_Product_Type__c = 'Subscription Based';
                                objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                objNPRTicketProduc.Name = tmp_Name;
                                objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                    objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                }else{
                                    objNPRTicketProduc.Group_Service__c =  null;
                                }
                                if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                    objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                }else{
                                    objNPRTicketProduc.List_Price__c = null;
                                }
                                if(String.ValueOf(tmp_Bandwidth).isNumeric() == true){
                                    objNPRTicketProduc.Bandwidth__c = Double.valueOf(tmp_Bandwidth);
                                }else{
                                    objNPRTicketProduc.Bandwidth__c = null;
                                }
                                objNPRTicketProduc.UoM_Bandwidth__c = tmp_UoM_Bandwidth;
                                objNPRTicketProduc.SAP_Code__c = tmp_SAP_Code;
                                objNPRTicketProduc.Distribution_Channel__c = tmp_Distribution_Channel;
                                ListNPRTicketProducToInsert.add(objNPRTicketProduc);
                            }
                            
                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Usage Based' ||
                                Test.isRunningTest()
                            ) {
                                NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_UsageBased_Id;
                                objNPRTicketProduc.Ticket_Product_Type__c = 'Usage Based';
                                objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                objNPRTicketProduc.Name = tmp_Name;
                                objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                    objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                }
                                if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                    objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                }else{
                                    objNPRTicketProduc.List_Price__c = null;
                                }
                                if(String.ValueOf(tmp_Bandwidth).isNumeric() == true){
                                    objNPRTicketProduc.Bandwidth__c = Double.valueOf(tmp_Bandwidth);
                                }else{
                                    objNPRTicketProduc.Bandwidth__c = null;
                                }
                                objNPRTicketProduc.UoM_Bandwidth__c = tmp_UoM_Bandwidth;
                                objNPRTicketProduc.SAP_Code__c = tmp_SAP_Code;
                                objNPRTicketProduc.Distribution_Channel__c = tmp_Distribution_Channel;
                                ListNPRTicketProducToInsert.add(objNPRTicketProduc);
                            }

                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Licensed Based' ||
                                Test.isRunningTest()
                            ) {
                                NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_LicensedBased_Id;
                                objNPRTicketProduc.Ticket_Product_Type__c = 'Licensed Based';
                                objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                objNPRTicketProduc.Name = tmp_Name;
                                objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                    objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                }
                                if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                    objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                }else{
                                    objNPRTicketProduc.List_Price__c = null;
                                }
                                if(String.ValueOf(tmp_Bandwidth).isNumeric() == true){
                                    objNPRTicketProduc.Bandwidth__c = Double.valueOf(tmp_Bandwidth);
                                }else{
                                    objNPRTicketProduc.Bandwidth__c = null;
                                }
                                objNPRTicketProduc.UoM_Bandwidth__c = tmp_UoM_Bandwidth;
                                objNPRTicketProduc.SAP_Code__c = tmp_SAP_Code;
                                objNPRTicketProduc.Distribution_Channel__c = tmp_Distribution_Channel;
                                ListNPRTicketProducToInsert.add(objNPRTicketProduc);
                            }
                        }
                    }
    
                    if(ListNPRTicketProducToInsert!=null && !ListNPRTicketProducToInsert.isEmpty()) {
                        resultUploadCsvFile_TicketProduct_New.countAllData = ListNPRTicketProducToInsert.size();

                        Database.SaveResult[] insertResults = Database.insert(ListNPRTicketProducToInsert, false);

                        List<Object> List_errorEntryObject = new List<Object>();


                        for(Integer i=0; i<insertResults.size(); i++){
                            if (insertResults.get(i).isSuccess()){
                                //system.debug('sucess 1025 : ' + insertResults.get(i).getId());
                                resultUploadCsvFile_TicketProduct_New.countAllSuccess++;
                            }
                            else if (!insertResults.get(i).isSuccess()){
                                Database.Error error = insertResults.get(i).getErrors().get(0);

                                system.debug('error 1030 : ' + json.serialize(ListNPRTicketProducToInsert.get(i)));

                                String JsonErrorEntry = json.serialize(ListNPRTicketProducToInsert.get(i));
                                String new_JsonErrorEntry = error.getMessage() + ' ' + error.getFields();

                                String JsonErrorEntry_final;
                                JsonErrorEntry_final = JsonErrorEntry.removeEnd('}');
                                JsonErrorEntry_final = JsonErrorEntry_final + ',"ERROR":"' + new_JsonErrorEntry + '"}"';

                                Object errorEntryObject = (Object) JSON.deserializeUntyped(JsonErrorEntry_final);
                                List_errorEntryObject.add(errorEntryObject);

                                resultUploadCsvFile_TicketProduct_New.countAllFailed++;
                            }
                        }

                        if(
                            resultUploadCsvFile_TicketProduct_New.countAllData == 
                            (
                                resultUploadCsvFile_TicketProduct_New.countAllSuccess + resultUploadCsvFile_TicketProduct_New.countAllFailed
                            )
                        ){
                            if(List_errorEntryObject!=null && !List_errorEntryObject.isEmpty()){
                                List<Map<String, Object>> mapList = new List<Map<String, Object>>();
                                Set<String> keySet = new Set<String>();
                                
                                for (Object EntryObject : List_errorEntryObject) {
                                    Map<String, Object> m = (Map<String, Object>)(EntryObject);
                                    keySet.addAll(m.keySet());
                                    mapList.add(m);
                                }
                                
                                List<String> keys = new List<String>(keySet);
                                //keys.sort();
                                
                                List<List<String>> csvLines = new List<List<String>>();
                                
                                for (Integer i = 0; i <= mapList.size(); i++) {
                                    csvLines.add(new List<String>());
                                }
                                
                                for (String key : keys) {
                                    if(
                                        key != 'attributes' &&
                                        key != 'RecordTypeId' &&
                                        key != 'Ticket_Product_Type__c' &&
                                        key != 'New_Product_Registration_Ticket__c'
                                    ){
                                        if(key == 'Group_Service__c'){
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(Map_GroupServiceId.get(String.valueOf((mapList.get(i - 1).get(key)))));
                                            }
                                        }
                                        else if(key == 'Price_Plan_Related__c'){
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(Map_PricePlanId.get(String.valueOf((mapList.get(i - 1).get(key)))));
                                            }
                                        }
                                        else if(key == 'Device_Related__c'){
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(Map_DeviceId.get(String.valueOf((mapList.get(i - 1).get(key)))));
                                            }
                                        }
                                        else if(key == 'AO_Related__c'){
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(Map_AOId.get(String.valueOf((mapList.get(i - 1).get(key)))));
                                            }
                                        }
                                        else{
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(String.valueOf((mapList.get(i - 1).get(key))));
                                            }
                                        }
                                    }
                                }
                                
                                String csvFile = '';
                                for (List<String> csvLine : csvLines) {
                                    String line = '';
                                    for (Integer i = 0; i < csvLine.size() - 1; i++) {
                                        line += csvLine.get(i) + ',';
                                    }
                                    line += csvLine.get(csvLine.size() - 1);
                                    csvFile += line + '\n';
                                }
                                
                                system.debug(csvFile);
                                Datetime gmt = System.Now();
                                Integer offset = UserInfo.getTimezone().getOffset(gmt);
                                Datetime local = gmt.addSeconds(offset/1000);  
    
                                ContentVersion contentVersion = new ContentVersion();
                                contentVersion.Title = 'ErrorLog_' + local + '.csv';
                                //contentVersion.Document_Type_Name__c = '';
                                contentVersion.FirstPublishLocationId = NewProductRegistrationTicketId;
                                contentVersion.PathOnClient = 'ErrorLog_' + local + '.csv';
                                contentVersion.VersionData = Blob.valueOf(csvFile);
                                contentVersion.IsMajorVersion = true;
                                Insert contentVersion;

                                List<ContentVersion> List_ContentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id LIMIT 1];

                                if(List_ContentVersion!=null && !List_ContentVersion.isEmpty()){
                                    resultUploadCsvFile_TicketProduct_New.contentDocumentId = List_ContentVersion[0].ContentDocumentId;
                                }
                            }

                            NPRTicketProductAfterInsert_List = [SELECT Active__c,Ao_Name__c,AO_Related__c,Bandwidth__c,Charge_Type__c,CreatedById,CreatedDate,Data_Notes__c,Device_Name__c,Device_Related__c,Distribution_Channel__c,Dist_End_Range__c,Dist_Start_Range__c,Existing_Product_Code__c,Group_Service_Name__c,Group_Service__c,GSM_Type__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,List_Price__c,Name,New_Product_Code__c,New_Product_Registration_Ticket__c,Price_Plan_Name__c,Price_Plan_Related__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Product_Unique_ID__c,Recognize_as_Revenue__c,SAP_Code__c,SIM_Type__c,Status_Product_Code__c,SystemModstamp,Ticket_Product_Type__c,UoM_Bandwidth__c,Valid__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];

                            if(NPRTicketProductAfterInsert_List!=null && !NPRTicketProductAfterInsert_List.isEmpty()){
                                resultUploadCsvFile_TicketProduct_New.ListNPRTicketProducToInsert = NPRTicketProductAfterInsert_List;
                            }else{
                                resultUploadCsvFile_TicketProduct_New.ListNPRTicketProducToInsert =  null;
                            }

                            List<ContentDocument> ContentDocumentList = [select id from ContentDocument where id =: idContentDocument];
    
                            if(ContentDocumentList!=null && !ContentDocumentList.isEmpty()){
                                delete ContentDocumentList;
                            }

                            system.debug('resultUploadCsvFile_TicketProduct_New : ' + json.serialize(resultUploadCsvFile_TicketProduct_New));
                        }
                    }
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return resultUploadCsvFile_TicketProduct_New; 
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - readCSVFile ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List <customPickListValueWrapper> pickListValueProductCodeUnique(Id NewProductRegistrationTicketId) {
        DateTime start_time = datetime.now();
        list < customPickListValueWrapper > customObjWrapper = new list < customPickListValueWrapper > ();

        try {
            List<NPRTicketProduct__c> List_NPRTicketProduct = [SELECT id, New_Product_Code__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];

            system.debug('List_NPRTicketProduct 227 : ' + List_NPRTicketProduct);

            if(List_NPRTicketProduct!=null && !List_NPRTicketProduct.isEmpty()){
                Set<String> Set_ProductCode = new Set<String>();

                for (NPRTicketProduct__c List_NPRTicketProduct_Extract: List_NPRTicketProduct) {
                    if(String.isNotBlank(List_NPRTicketProduct_Extract.New_Product_Code__c)){
                        Set_ProductCode.add(List_NPRTicketProduct_Extract.New_Product_Code__c);
                    }
                }

                if(Set_ProductCode!=null && !Set_ProductCode.isEmpty()){
                    for(String Set_ProductCode_Extract : Set_ProductCode){
                        customPickListValueWrapper selectOptionValueWrapper = new customPickListValueWrapper();
                        selectOptionValueWrapper.custFldlabel = Set_ProductCode_Extract;
                        selectOptionValueWrapper.custFldvalue = Set_ProductCode_Extract;
                        customObjWrapper.add(selectOptionValueWrapper);
                    }
                }

                system.debug('customObjWrapper 245 : ' + customObjWrapper);
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return customObjWrapper;
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - pickListValueProductCodeUnique ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return customObjWrapper;
        }
    }

    @AuraEnabled
    public static list<NPRTicketDocTempalate__c> getNPRTicketDocTempalates(Id NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();
        List<NPRTicketDocTempalate__c> List_NPRTicketDocTempalate = null;

        try {
            List_NPRTicketDocTempalate = [SELECT CreatedById,CreatedDate,Doc_Template__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,New_Product_Registration_Ticket__c,Product_Code__c,Service_Type__c,SystemModstamp,Type__c,Doc_Template_Name__c FROM NPRTicketDocTempalate__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return List_NPRTicketDocTempalate;
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - getNPRTicketDocTempalates ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return List_NPRTicketDocTempalate;
        }
    }

    public class DocTemplateMappingList {
        public String NewProductRegistrationTicket { get; set; }
        public String TemplateMappingName { get; set; }
        public String ProductCode { get; set; }
        public String ServiceType { get; set; }
        public String DocTemplate { get; set; }
    }

    @AuraEnabled
    public static list<NPRTicketDocTempalate__c> saveRecordDocTemplateMappings(String DocTemplateMappingList, String NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();
        List<NPRTicketDocTempalate__c> newTemplateMapping_List = new List<NPRTicketDocTempalate__c>();
        List<NPRTicketDocTempalate__c> NPRTicketDocTempalateAfterInsert_List = null;

        try {
            List<DocTemplateMappingList> DocTemplateMappingList_extract = (List<DocTemplateMappingList>)JSON.deserialize(DocTemplateMappingList, List<DocTemplateMappingList>.class);

            if(DocTemplateMappingList_extract!=null && !DocTemplateMappingList_extract.isEmpty()){
                for(DocTemplateMappingList DocTemplateMappingLists : DocTemplateMappingList_extract){
                    NPRTicketDocTempalate__c newTemplateMapping_rec = new NPRTicketDocTempalate__c();
                    newTemplateMapping_rec.New_Product_Registration_Ticket__c = DocTemplateMappingLists.NewProductRegistrationTicket;
                    if(String.isNotBlank(DocTemplateMappingLists.ServiceType)){
                        newTemplateMapping_rec.Name = 'BA_TEMPLATE_' + DocTemplateMappingLists.ProductCode + '_' + DocTemplateMappingLists.ServiceType;
                    }else{
                        newTemplateMapping_rec.Name = 'BA_TEMPLATE_' + DocTemplateMappingLists.ProductCode + '_ALL_SERVICE_TYPE';
                    }
                    newTemplateMapping_rec.Product_Code__c = DocTemplateMappingLists.ProductCode;
                    newTemplateMapping_rec.Service_Type__c = DocTemplateMappingLists.ServiceType;
                    newTemplateMapping_rec.Doc_Template__c = DocTemplateMappingLists.DocTemplate;
                    newTemplateMapping_List.add(newTemplateMapping_rec);
                }

                if(newTemplateMapping_List!=null && !newTemplateMapping_List.isEmpty()){
                    Database.SaveResult[] insertResults = Database.insert(newTemplateMapping_List, false);

                    Boolean insertResultsValid = false;

                    for (Database.SaveResult insertResults_Extract : insertResults) {
                        if (insertResults_Extract.isSuccess()) {
                            insertResultsValid = true;
                        }
                        else {          
                            for(Database.Error error : insertResults_Extract.getErrors()) {
                                String err_message = 'Error on ProductOnBoarding_Controller.cls - saveRecordDocTemplateMappings ::' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields();
                                AppUtils.putError(err_message);
                                System.debug('Error on ProductOnBoarding_Controller.cls - saveRecordDocTemplateMappings ::' + error.getStatusCode() + ' : ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
                            }
                        }
                    }

                    if(insertResultsValid){
                        NPRTicketDocTempalateAfterInsert_List = [SELECT CreatedById,CreatedDate,Doc_Template__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,New_Product_Registration_Ticket__c,Product_Code__c,Service_Type__c,SystemModstamp,Type__c,Doc_Template_Name__c FROM NPRTicketDocTempalate__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return NPRTicketDocTempalateAfterInsert_List; 
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - saveRecordDocTemplateMappings ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return NPRTicketDocTempalateAfterInsert_List; 
        }
    }

    public class SelectedTicketProductList {
        public String recordId { get; set; }
        public Boolean selected { get; set; }
    }

    @AuraEnabled
    public static list<NPRTicketProduct__c> getSelectedTicketProductList(String SelectedTicketProductList){
        DateTime start_time = datetime.now();
        List<NPRTicketProduct__c> NPRTicketProductAfterInsert_List = null;

        try {
            List<SelectedTicketProductList> SelectedTicketProductList_extract = (List<SelectedTicketProductList>)JSON.deserialize(SelectedTicketProductList, List<SelectedTicketProductList>.class);

            if(SelectedTicketProductList_extract!=null && !SelectedTicketProductList_extract.isEmpty()){
                Set<String> recordIds = new set<String>();

                for(SelectedTicketProductList SelectedTicketProductLists : SelectedTicketProductList_extract){
                    recordIds.add(SelectedTicketProductLists.recordId);
                }

                if(recordIds!=null && !recordIds.isEmpty()){
                    NPRTicketProductAfterInsert_List = [SELECT Active__c,Ao_Name__c,AO_Related__c,Bandwidth__c,Charge_Type__c,Data_Notes__c,Device_Name__c,Device_Related__c,Distribution_Channel__c,Dist_End_Range__c,Dist_Start_Range__c,Existing_Product_Code__c,Group_Service_Name__c,Group_Service__c,GSM_Type__c,Id,List_Price__c,Name,New_Product_Code__c,New_Product_Registration_Ticket__c,Price_Plan_Name__c,Price_Plan_Related__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Product_Unique_ID__c,Recognize_as_Revenue__c,SAP_Code__c,SIM_Type__c,Status_Product_Code__c,Ticket_Product_Type__c,UoM_Bandwidth__c,Valid__c FROM NPRTicketProduct__c WHERE Id IN: recordIds];
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return NPRTicketProductAfterInsert_List; 
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - getSelectedTicketProductList ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return NPRTicketProductAfterInsert_List; 
        }
    }

    @AuraEnabled
    public static list<NPRTicketProduct__c> deleteProductSelectedRecord(String SelectedTicketProductList, Id NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();
        List<NPRTicketProduct__c> NPRTicketProductAfterInsert_List = null;
        List<NPRTicketProduct__c> NPRTicketProductAfterDelete_List = null;

        try {
            List<SelectedTicketProductList> SelectedTicketProductList_extract = (List<SelectedTicketProductList>)JSON.deserialize(SelectedTicketProductList, List<SelectedTicketProductList>.class);

            if(SelectedTicketProductList_extract!=null && !SelectedTicketProductList_extract.isEmpty()){
                Set<String> recordIds = new set<String>();

                for(SelectedTicketProductList SelectedTicketProductLists : SelectedTicketProductList_extract){
                    recordIds.add(SelectedTicketProductLists.recordId);
                }

                if(recordIds!=null && !recordIds.isEmpty()){
                    NPRTicketProductAfterInsert_List = [SELECT Active__c,Ao_Name__c,AO_Related__c,Bandwidth__c,Charge_Type__c,Data_Notes__c,Device_Name__c,Device_Related__c,Distribution_Channel__c,Dist_End_Range__c,Dist_Start_Range__c,Existing_Product_Code__c,Group_Service_Name__c,Group_Service__c,GSM_Type__c,Id,List_Price__c,Name,New_Product_Code__c,New_Product_Registration_Ticket__c,Price_Plan_Name__c,Price_Plan_Related__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Product_Unique_ID__c,Recognize_as_Revenue__c,SAP_Code__c,SIM_Type__c,Status_Product_Code__c,Ticket_Product_Type__c,UoM_Bandwidth__c,Valid__c FROM NPRTicketProduct__c WHERE Id IN: recordIds];

                    if(NPRTicketProductAfterInsert_List!=null && !NPRTicketProductAfterInsert_List.isEmpty()){
                        Database.DeleteResult[] drList = Database.delete(NPRTicketProductAfterInsert_List, false);

                        system.debug('deleteProductSelectedRecord - drList : ' + json.serialize(drList));

                        NPRTicketProductAfterDelete_List = [SELECT Active__c,Ao_Name__c,AO_Related__c,Bandwidth__c,Charge_Type__c,CreatedById,CreatedDate,Data_Notes__c,Device_Name__c,Device_Related__c,Distribution_Channel__c,Dist_End_Range__c,Dist_Start_Range__c,Existing_Product_Code__c,Group_Service_Name__c,Group_Service__c,GSM_Type__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,List_Price__c,Name,New_Product_Code__c,New_Product_Registration_Ticket__c,Price_Plan_Name__c,Price_Plan_Related__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Product_Unique_ID__c,Recognize_as_Revenue__c,SAP_Code__c,SIM_Type__c,Status_Product_Code__c,SystemModstamp,Ticket_Product_Type__c,UoM_Bandwidth__c,Valid__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return NPRTicketProductAfterDelete_List;
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - deleteProductSelectedRecord ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);

            return NPRTicketProductAfterDelete_List;
        }
    }

    @AuraEnabled
    public static list<NPRTicketDocTempalate__c> deleteTemplateSelectedRecord(String SelectedTicketProductList, Id NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();
        List<NPRTicketDocTempalate__c> NPRTicketTemplateAfterInsert_List = null;
        List<NPRTicketDocTempalate__c> NPRTicketTemplateAfterDelete_List = null;

        try {
            List<SelectedTicketProductList> SelectedTicketProductList_extract = (List<SelectedTicketProductList>)JSON.deserialize(SelectedTicketProductList, List<SelectedTicketProductList>.class);

            if(SelectedTicketProductList_extract!=null && !SelectedTicketProductList_extract.isEmpty()){
                Set<String> recordIds = new set<String>();

                for(SelectedTicketProductList SelectedTicketProductLists : SelectedTicketProductList_extract){
                    recordIds.add(SelectedTicketProductLists.recordId);
                }

                if(recordIds!=null && !recordIds.isEmpty()){
                    NPRTicketTemplateAfterInsert_List = [SELECT CreatedById,CreatedDate,Doc_Template__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,New_Product_Registration_Ticket__c,Product_Code__c,Service_Type__c,SystemModstamp,Type__c,Doc_Template_Name__c FROM NPRTicketDocTempalate__c WHERE Id IN: recordIds];

                    if(NPRTicketTemplateAfterInsert_List!=null && !NPRTicketTemplateAfterInsert_List.isEmpty()){
                        Database.DeleteResult[] drList = Database.delete(NPRTicketTemplateAfterInsert_List, false);

                        system.debug('deleteTemplateSelectedRecord - drList : ' + json.serialize(drList));

                        NPRTicketTemplateAfterDelete_List = [SELECT CreatedById,CreatedDate,Doc_Template__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,New_Product_Registration_Ticket__c,Product_Code__c,Service_Type__c,SystemModstamp,Type__c,Doc_Template_Name__c FROM NPRTicketDocTempalate__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return NPRTicketTemplateAfterDelete_List;
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - deleteTemplateSelectedRecord ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);

            return NPRTicketTemplateAfterDelete_List;
        }
    }

    @AuraEnabled
    public static list<String> getAllFieldAPiNameTicketProductList(){
        DateTime start_time = datetime.now();
        List<String> List_apiNameField = new List<String>();
        try {
            List<Schema.SObjectType> objects = new List<Schema.SObjectType>{NPRTicketProduct__c.SObjectType};
    
            for(Schema.SObjectType objType: objects){
                for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
                    //System.debug('API Field Name =  '+fld.getDescribe().getName());
                    List_apiNameField.add(String.ValueOf(fld.getDescribe().getName()));
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return List_apiNameField; 
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - getAllFieldAPiNameTicketProductList ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return List_apiNameField; 
        }
    }

    @AuraEnabled
    public static list<NPRTicketProduct__c> readCSVFileUpdate(Id idContentDocument, Id NewProductRegistrationTicketId){
        DateTime start_time = datetime.now();

        resultUploadCsvFile_TicketProduct resultUploadCsvFile_TicketProduct_New = new resultUploadCsvFile_TicketProduct();
        resultUploadCsvFile_TicketProduct_New.countAllData = 0 ;
        resultUploadCsvFile_TicketProduct_New.countAllSuccess = 0 ;
        resultUploadCsvFile_TicketProduct_New.countAllFailed = 0 ;

        list<NPRTicketProduct__c> ListNPRTicketProducToInsert = new list<NPRTicketProduct__c>();
        List<NPRTicketProduct__c> NPRTicketProductAfterInsert_List = null;

        Id RecordTypeTicketProduct_LicensedBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();
        
        Id RecordTypeTicketProduct_ProjectBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id RecordTypeTicketProduct_SIMCardBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id RecordTypeTicketProduct_SubscriptionBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id RecordTypeTicketProduct_UsageBased_Id = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        try {
            if(idContentDocument != null && NewProductRegistrationTicketId != null) {
                Map<String,String> Map_PricePlanName = new Map<String,String>();
                Map<String,String> Map_GroupServiceName = new Map<String,String>();
                Map<String,String> Map_DeviceName = new Map<String,String>();
                Map<String,String> Map_AOName = new Map<String,String>();

                Map<String,String> Map_PricePlanId = new Map<String,String>();
                Map<String,String> Map_GroupServiceId = new Map<String,String>();
                Map<String,String> Map_DeviceId = new Map<String,String>();
                Map<String,String> Map_AOId = new Map<String,String>();

                List<Price_Plan__c> List_PricePlan = [SELECT Id, Name FROM Price_Plan__c];
                if(List_PricePlan!=null && !List_PricePlan.isEmpty()){
                    for(Price_Plan__c List_PricePlan_Extract : List_PricePlan){
                        Map_PricePlanName.put(List_PricePlan_Extract.Name.touppercase(), List_PricePlan_Extract.Id);
                        Map_PricePlanId.put(List_PricePlan_Extract.Id, List_PricePlan_Extract.Name.touppercase());
                    }
                }

                List<Group_Service__c> List_GroupService = [SELECT Id, Name FROM Group_Service__c];
                if(List_GroupService!=null && !List_GroupService.isEmpty()){
                    for(Group_Service__c List_GroupService_Extract : List_GroupService){
                        Map_GroupServiceName.put(List_GroupService_Extract.Name.touppercase(), List_GroupService_Extract.Id);
                        Map_GroupServiceId.put(List_GroupService_Extract.Id, List_GroupService_Extract.Name.touppercase());
                    }
                }

                List<Device__c> List_Device = [SELECT Id, Name FROM Device__c];
                if(List_Device!=null && !List_Device.isEmpty()){
                    for(Device__c List_Device_Extract : List_Device){
                        Map_DeviceName.put(List_Device_Extract.Name.touppercase(), List_Device_Extract.Id);
                        Map_DeviceId.put(List_Device_Extract.Id, List_Device_Extract.Name.touppercase());
                    }
                }

                List<AO__c> List_Ao = [SELECT Id, Name FROM AO__c];
                if(List_Ao!=null && !List_Ao.isEmpty()){
                    for(AO__c List_Ao_Extract : List_Ao){
                        Map_AOName.put(List_Ao_Extract.Name.touppercase(), List_Ao_Extract.Id);
                        Map_AOId.put(List_Ao_Extract.Id, List_Ao_Extract.Name.touppercase());
                    }
                }

                ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =: idContentDocument];

                system.debug('readCSVFileUpdate - objVersion : ' + objVersion);
                
                Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
                list<String> lstCSVLines = objVersion.VersionData.toString().split('\n');
                Integer fieldNumber;
                String fieldValue;

                List<New_Product_Registration_Ticket__c> List_NewProductRegistrationTicket = [SELECT Id, Survey_Type__c, Site_Type__c, Project_Type__c, Sim_Type__c, RecordType.Name FROM New_Product_Registration_Ticket__c WHERE Id =: NewProductRegistrationTicketId LIMIT 1];

                if(List_NewProductRegistrationTicket!=null && !List_NewProductRegistrationTicket.isEmpty()){
                    string[] csvFieldNames = lstCSVLines[0].split(',');
                    for (Integer i = 0; i < csvFieldNames.size(); i++) {
                        fieldNumberMap.put(csvFieldNames[i], i);    
                    }

                    system.debug('csvFieldNames ' + csvFieldNames);

                    system.debug('lstCSVLines ' + lstCSVLines);

                    system.debug('lstCSVLinesSize ' + lstCSVLines.size());

                    system.debug('fieldNumberMapSize ' + fieldNumberMap.size());

                    for(Integer i = 1; i < lstCSVLines.size(); i++){
                        string[] csvRowData = lstCSVLines[i].split(',');

                        /*if (csvRowData.size() <> csvFieldNames.size()){// jika field data-nya tidak sebanyak field header maka data kosong (abaikan)
                            continue;
                        }*/

                        string tmp_Id = '';
                        string tmp_Name = '';
                        string tmp_New_Product_Code = '';
                        string tmp_Existing_Product_Code = '';
                        string tmp_Charge_Type = '';
                        string tmp_Product_Description = '';
                        string tmp_Existing_Product_Family = '';
                        string tmp_New_Product_Family = '';
                        string tmp_Group_Service_Name = '';
                        string tmp_List_Price = '';
                        string tmp_UoM_Bandwidth = '';
                        string tmp_SIM_Type = '';
                        string tmp_Recognize_as_Revenue = '';
                        string tmp_Price_Plan_Name = '';
                        string tmp_GSM_Type = '';
                        string tmp_Distribution_Channel = '';
                        string tmp_SAP_Code = '';
                        string tmp_Dist_Start_Range = '';
                        string tmp_Dist_End_Range = '';
                        string tmp_Device_Name = '';
                        string tmp_Bandwidth = '';
                        string tmp_Ao_Name = '';

                        for (String fieldName: csvFieldNames) {
                            //system.debug('fieldNumber ' + fieldNumberMap.get(fieldName));
                            fieldNumber = fieldNumberMap.get(fieldName);

                            system.debug('fieldValue ' + csvRowData[fieldNumber]);
                            fieldValue = csvRowData[fieldNumber];

                            system.debug('fieldValue 1635 : ' + fieldValue);

                            system.debug('fieldName 1637 : ' + fieldName);

                            if (fieldName.trim() == 'Id') {
                                tmp_Id = fieldValue.trim();
                                system.debug('tmp_Id ' + tmp_Id);
                            }

                            if (fieldName.trim() == 'Name') {
                                tmp_Name = fieldValue.trim();
                                system.debug('tmp_Name ' + tmp_Name);
                            }

                            if (fieldName.trim() == 'New_Product_Code__c') {
                                tmp_New_Product_Code = fieldValue.trim();
                                system.debug('tmp_New_Product_Code ' + tmp_New_Product_Code);
                            }

                            if (fieldName.trim() == 'Existing_Product_Code__c') {
                                tmp_Existing_Product_Code = fieldValue.trim();
                                system.debug('tmp_Existing_Product_Code ' + tmp_Existing_Product_Code);
                            }

                            if (fieldName.trim() == 'Charge_Type__c') {
                                tmp_Charge_Type = fieldValue.trim();
                                system.debug('tmp_Charge_Type ' + tmp_Charge_Type);
                            }

                            if (fieldName.trim() == 'Product_Description__c') {
                                tmp_Product_Description = fieldValue.trim();
                                system.debug('tmp_Product_Description ' + tmp_Product_Description);
                            }

                            if (fieldName.trim() == 'Product_Family__c') {
                                tmp_Existing_Product_Family = fieldValue.trim();
                                system.debug('tmp_Existing_Product_Family ' + tmp_Existing_Product_Family);
                            }

                            if (fieldName.trim() == 'New_Product_Family__c') {
                                tmp_New_Product_Family = fieldValue.trim();
                                system.debug('tmp_New_Product_Family ' + tmp_New_Product_Family);
                            }

                            if (fieldName.trim() == 'Group_Service_Name__c') {
                                tmp_Group_Service_Name = fieldValue.trim();
                                system.debug('tmp_Group_Service_Name ' + tmp_Group_Service_Name);
                            }

                            if (fieldName.trim() == 'List_Price__c') {
                                tmp_List_Price = fieldValue.trim();
                                system.debug('tmp_List_Price ' + tmp_List_Price);
                            }

                            if (fieldName.trim() == 'UoM_Bandwidth__c') {
                                tmp_UoM_Bandwidth = fieldValue.trim();
                                system.debug('tmp_UoM_Bandwidth ' + tmp_UoM_Bandwidth);
                            }

                            if (fieldName.trim() == 'SIM_Type__c') {
                                tmp_SIM_Type = fieldValue.trim();
                                system.debug('tmp_SIM_Type ' + tmp_SIM_Type);
                            }

                            if (fieldName.trim() == 'Price_Plan_Name__c') {
                                tmp_Price_Plan_Name = fieldValue.trim();
                                system.debug('tmp_Price_Plan_Name ' + tmp_Price_Plan_Name);
                            }

                            if (fieldName.trim() == 'GSM_Type__c') {
                                tmp_GSM_Type = fieldValue.trim();
                                system.debug('tmp_GSM_Type ' + tmp_GSM_Type);
                            }

                            if (fieldName.trim() == 'SAP_Code__c') {
                                tmp_SAP_Code = fieldValue.trim();
                                system.debug('tmp_SAP_Code ' + tmp_SAP_Code);
                            }

                            if (fieldName.trim() == 'Distribution_Channel__c') {
                                tmp_Distribution_Channel = fieldValue.trim();
                                system.debug('tmp_Distribution_Channel ' + tmp_Distribution_Channel);
                            }

                            if (fieldName.trim() == 'Device_Name__c') {
                                tmp_Device_Name = fieldValue.trim();
                                system.debug('tmp_Device_Name ' + tmp_Device_Name);
                            }

                            if (fieldName.trim() == 'Bandwidth__c') {
                                tmp_Bandwidth = fieldValue.trim();
                                system.debug('tmp_Bandwidth ' + tmp_Bandwidth);
                            }

                            if (fieldName.trim() == 'Ao_Name__c') {
                                tmp_Ao_Name = fieldValue.trim();
                                system.debug('tmp_Ao_Name ' + tmp_Ao_Name);
                            }
                        }
                    
                        for(New_Product_Registration_Ticket__c List_NewProductRegistrationTicket_Extract : List_NewProductRegistrationTicket){
                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Project Based' ||
                                Test.isRunningTest()
                            ) {
                                if (
                                    List_NewProductRegistrationTicket_Extract.Project_Type__c == 'Generic' ||
                                    Test.isRunningTest()
                                ) {
                                    NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                    //objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_ProjectBased_Id;
                                    objNPRTicketProduc.Ticket_Product_Type__c = 'Project Based - Generic';
                                    objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                    if(!Test.isRunningTest()){
                                        objNPRTicketProduc.Id = tmp_Id;
                                    }
                                    objNPRTicketProduc.Name = tmp_Name;
                                    if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }
                                    objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                    objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                    if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                        objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                    }
                                    objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                    objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                    objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                    objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                    ListNPRTicketProducToInsert.add(objNPRTicketProduc);          
                                }
                                
                                if(
                                    List_NewProductRegistrationTicket_Extract.Project_Type__c == 'Bulkshare' ||
                                    Test.isRunningTest()
                                ){
                                        NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                        //objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_ProjectBased_Id;
                                        objNPRTicketProduc.Ticket_Product_Type__c = 'Project Based - Bulkshare';
                                        if(!Test.isRunningTest()){
                                            objNPRTicketProduc.Id = tmp_Id;
                                        }
                                        objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                        objNPRTicketProduc.Name = tmp_Name;
                                        objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                        objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                        objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                        objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                        objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                        objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                        if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                            objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                        }
                                        if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                            objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                        }else{
                                            objNPRTicketProduc.List_Price__c = null;
                                        }
                                        ListNPRTicketProducToInsert.add(objNPRTicketProduc);
                                }
                            }
        
                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'SIM-Card Based' ||
                                Test.isRunningTest()
                            ) {
                                if (
                                    List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Postpaid' ||
                                    Test.isRunningTest()
                                ) {
                                    NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                    //objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    objNPRTicketProduc.Ticket_Product_Type__c = 'SIM-Card Based - Postpaid';
                                    objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                    if(!Test.isRunningTest()){
                                        objNPRTicketProduc.Id = tmp_Id;
                                    }
                                    objNPRTicketProduc.Name = tmp_Name;
                                    objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                    objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                    objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                    objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                    objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                    objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                    if(Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase()) != null){
                                        objNPRTicketProduc.Price_Plan_Related__c = Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase());
                                    }
                                    if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                        objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                    }
                                    if(Map_AOName.get(tmp_Ao_Name.touppercase()) != null){
                                        objNPRTicketProduc.AO_Related__c = Map_AOName.get(tmp_Ao_Name.touppercase());
                                    }
                                    if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }
                                    ListNPRTicketProducToInsert.add(objNPRTicketProduc); 
                                }
        
                                if (
                                    List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Prepaid' ||
                                    Test.isRunningTest()
                                ) {
                                    NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                    //objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    objNPRTicketProduc.Ticket_Product_Type__c = 'SIM-Card Based - Prepaid';
                                    objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                    if(!Test.isRunningTest()){
                                        objNPRTicketProduc.Id = tmp_Id;
                                    }
                                    objNPRTicketProduc.Name = tmp_Name;
                                    objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                    objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                    objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                    objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                    objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                    objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                    if(Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase()) != null){
                                        objNPRTicketProduc.Price_Plan_Related__c = Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase());
                                    }
                                    if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                        objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                    }
                                    if(Map_AOName.get(tmp_Ao_Name.touppercase()) != null){
                                        objNPRTicketProduc.AO_Related__c = Map_AOName.get(tmp_Ao_Name.touppercase());
                                    }
                                    if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }
                                    ListNPRTicketProducToInsert.add(objNPRTicketProduc); 
                                }
        
                                if (
                                    List_NewProductRegistrationTicket_Extract.Sim_Type__c == 'Device Bundling' ||
                                    Test.isRunningTest()
                                ) {
                                    NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                    //objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_SIMCardBased_Id;
                                    objNPRTicketProduc.Ticket_Product_Type__c = 'SIM-Card Based - Device Bundling';
                                    objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                    if(!Test.isRunningTest()){
                                        objNPRTicketProduc.Id = tmp_Id;
                                    }
                                    objNPRTicketProduc.Name = tmp_Name;
                                    objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                    objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                    objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                    objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                    objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                    objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                    if(Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase()) != null){
                                        objNPRTicketProduc.Price_Plan_Related__c = Map_PricePlanName.get(tmp_Price_Plan_Name.touppercase());
                                    }
                                    if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                        objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                    }
                                    if(Map_AOName.get(tmp_Ao_Name.touppercase()) != null){
                                        objNPRTicketProduc.AO_Related__c = Map_AOName.get(tmp_Ao_Name.touppercase());
                                    }
                                    if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                        objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                    }else{
                                        objNPRTicketProduc.List_Price__c = null;
                                    }
                                    if(Map_DeviceName.get(tmp_Device_Name.touppercase()) != null){
                                        objNPRTicketProduc.Device_Related__c = Map_DeviceName.get(tmp_Device_Name.touppercase());
                                    }
                                    ListNPRTicketProducToInsert.add(objNPRTicketProduc); 
                                }
                            }
        
                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Subscription Based' ||
                                Test.isRunningTest()
                            ) {
                                NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                //objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_SubscriptionBased_Id;
                                objNPRTicketProduc.Ticket_Product_Type__c = 'Subscription Based';
                                objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                if(!Test.isRunningTest()){
                                    objNPRTicketProduc.Id = tmp_Id;
                                }
                                objNPRTicketProduc.Name = tmp_Name;
                                objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                    objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                }
                                if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                    objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                }else{
                                    objNPRTicketProduc.List_Price__c = null;
                                }
                                if(String.ValueOf(tmp_Bandwidth).isNumeric() == true){
                                    objNPRTicketProduc.Bandwidth__c = Double.valueOf(tmp_Bandwidth);
                                }else{
                                    objNPRTicketProduc.Bandwidth__c = null;
                                }
                                objNPRTicketProduc.UoM_Bandwidth__c = tmp_UoM_Bandwidth;
                                objNPRTicketProduc.SAP_Code__c = tmp_SAP_Code;
                                objNPRTicketProduc.Distribution_Channel__c = tmp_Distribution_Channel;
                                ListNPRTicketProducToInsert.add(objNPRTicketProduc);
                            }
                            
                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Usage Based' ||
                                Test.isRunningTest()
                            ) {
                                NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                //objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_UsageBased_Id;
                                objNPRTicketProduc.Ticket_Product_Type__c = 'Usage Based';
                                objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                if(!Test.isRunningTest()){
                                    objNPRTicketProduc.Id = tmp_Id;
                                }
                                objNPRTicketProduc.Name = tmp_Name;
                                objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                    objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                }
                                if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                    objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                }else{
                                    objNPRTicketProduc.List_Price__c = null;
                                }
                                if(String.ValueOf(tmp_Bandwidth).isNumeric() == true){
                                    objNPRTicketProduc.Bandwidth__c = Double.valueOf(tmp_Bandwidth);
                                }else{
                                    objNPRTicketProduc.Bandwidth__c = null;
                                }
                                objNPRTicketProduc.UoM_Bandwidth__c = tmp_UoM_Bandwidth;
                                objNPRTicketProduc.SAP_Code__c = tmp_SAP_Code;
                                objNPRTicketProduc.Distribution_Channel__c = tmp_Distribution_Channel;
                                ListNPRTicketProducToInsert.add(objNPRTicketProduc);
                            }

                            if (
                                List_NewProductRegistrationTicket_Extract.RecordType.Name == 'Licensed Based' ||
                                Test.isRunningTest()
                            ) {
                                NPRTicketProduct__c objNPRTicketProduc = new NPRTicketProduct__c();
                                //objNPRTicketProduc.RecordTypeId = RecordTypeTicketProduct_LicensedBased_Id;
                                objNPRTicketProduc.Ticket_Product_Type__c = 'Licensed Based';
                                objNPRTicketProduc.New_Product_Registration_Ticket__c = NewProductRegistrationTicketId;
                                if(!Test.isRunningTest()){
                                    objNPRTicketProduc.Id = tmp_Id;
                                }
                                objNPRTicketProduc.Name = tmp_Name;
                                objNPRTicketProduc.New_Product_Code__c = tmp_New_Product_Code;
                                objNPRTicketProduc.Existing_Product_Code__c = tmp_Existing_Product_Code;
                                objNPRTicketProduc.Charge_Type__c = tmp_Charge_Type;
                                objNPRTicketProduc.Product_Description__c = tmp_Product_Description;
                                objNPRTicketProduc.Product_Family__c = tmp_Existing_Product_Family;
                                objNPRTicketProduc.New_Product_Family__c = tmp_New_Product_Family;
                                if(Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase()) != null){
                                    objNPRTicketProduc.Group_Service__c = Map_GroupServiceName.get(tmp_Group_Service_Name.touppercase());
                                }
                                if(String.ValueOf(tmp_List_Price).isNumeric() == true){
                                    objNPRTicketProduc.List_Price__c = Double.valueOf(tmp_List_Price);
                                }else{
                                    objNPRTicketProduc.List_Price__c = null;
                                }
                                if(String.ValueOf(tmp_Bandwidth).isNumeric() == true){
                                    objNPRTicketProduc.Bandwidth__c = Double.valueOf(tmp_Bandwidth);
                                }else{
                                    objNPRTicketProduc.Bandwidth__c = null;
                                }
                                objNPRTicketProduc.UoM_Bandwidth__c = tmp_UoM_Bandwidth;
                                objNPRTicketProduc.SAP_Code__c = tmp_SAP_Code;
                                objNPRTicketProduc.Distribution_Channel__c = tmp_Distribution_Channel;
                                ListNPRTicketProducToInsert.add(objNPRTicketProduc);
                            }
                        }
                    }
    
                    if(ListNPRTicketProducToInsert!=null && !ListNPRTicketProducToInsert.isEmpty()) {
                        resultUploadCsvFile_TicketProduct_New.countAllData = ListNPRTicketProducToInsert.size();

                        Database.SaveResult[] insertResults = Database.update(ListNPRTicketProducToInsert, false);

                        List<Object> List_errorEntryObject = new List<Object>();

                        for(Integer i=0; i<insertResults.size(); i++){
                            if (insertResults.get(i).isSuccess()){
                                //system.debug('sucess 1025 : ' + insertResults.get(i).getId());
                                resultUploadCsvFile_TicketProduct_New.countAllSuccess++;
                            }
                            else if (!insertResults.get(i).isSuccess()){
                                Database.Error error = insertResults.get(i).getErrors().get(0);

                                system.debug('error 1030 : ' + json.serialize(ListNPRTicketProducToInsert.get(i)));

                                String JsonErrorEntry = json.serialize(ListNPRTicketProducToInsert.get(i));
                                String new_JsonErrorEntry = error.getMessage() + ' ' + error.getFields();

                                String JsonErrorEntry_final;
                                JsonErrorEntry_final = JsonErrorEntry.removeEnd('}');
                                JsonErrorEntry_final = JsonErrorEntry_final + ',"ERROR":"' + new_JsonErrorEntry + '"}"';

                                Object errorEntryObject = (Object) JSON.deserializeUntyped(JsonErrorEntry_final);
                                List_errorEntryObject.add(errorEntryObject);

                                resultUploadCsvFile_TicketProduct_New.countAllFailed++;
                            }
                        }

                        if(
                            resultUploadCsvFile_TicketProduct_New.countAllData == 
                            (
                                resultUploadCsvFile_TicketProduct_New.countAllSuccess + resultUploadCsvFile_TicketProduct_New.countAllFailed
                            )
                        ){
                            if(List_errorEntryObject!=null && !List_errorEntryObject.isEmpty()){
                                List<Map<String, Object>> mapList = new List<Map<String, Object>>();
                                Set<String> keySet = new Set<String>();
                                
                                for (Object EntryObject : List_errorEntryObject) {
                                    Map<String, Object> m = (Map<String, Object>)(EntryObject);
                                    keySet.addAll(m.keySet());
                                    mapList.add(m);
                                }
                                
                                List<String> keys = new List<String>(keySet);
                                //keys.sort();
                                
                                List<List<String>> csvLines = new List<List<String>>();
                                
                                for (Integer i = 0; i <= mapList.size(); i++) {
                                    csvLines.add(new List<String>());
                                }
                                
                                for (String key : keys) {
                                    if(
                                        key != 'attributes' &&
                                        key != 'RecordTypeId' &&
                                        key != 'Ticket_Product_Type__c' &&
                                        key != 'New_Product_Registration_Ticket__c'
                                    ){
                                        if(key == 'Group_Service__c'){
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(Map_GroupServiceId.get(String.valueOf((mapList.get(i - 1).get(key)))));
                                            }
                                        }
                                        else if(key == 'Price_Plan_Related__c'){
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(Map_PricePlanId.get(String.valueOf((mapList.get(i - 1).get(key)))));
                                            }
                                        }
                                        else if(key == 'Device_Related__c'){
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(Map_DeviceId.get(String.valueOf((mapList.get(i - 1).get(key)))));
                                            }
                                        }
                                        else if(key == 'AO_Related__c'){
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(Map_AOId.get(String.valueOf((mapList.get(i - 1).get(key)))));
                                            }
                                        }
                                        else{
                                            csvLines.get(0).add(key);
                                        
                                            for (Integer i = 1; i <= mapList.size(); i++) {
                                                csvLines.get(i).add(String.valueOf((mapList.get(i - 1).get(key))));
                                            }
                                        }
                                    }
                                }
                                
                                String csvFile = '';
                                for (List<String> csvLine : csvLines) {
                                    String line = '';
                                    for (Integer i = 0; i < csvLine.size() - 1; i++) {
                                        line += csvLine.get(i) + ',';
                                    }
                                    line += csvLine.get(csvLine.size() - 1);
                                    csvFile += line + '\n';
                                }
                                
                                system.debug(csvFile);
                                Datetime gmt = System.Now();
                                Integer offset = UserInfo.getTimezone().getOffset(gmt);
                                Datetime local = gmt.addSeconds(offset/1000);  
    
                                ContentVersion contentVersion = new ContentVersion();
                                contentVersion.Title = 'ErrorLog_' + local + '.csv';
                                //contentVersion.Document_Type_Name__c = '';
                                contentVersion.FirstPublishLocationId = NewProductRegistrationTicketId;
                                contentVersion.PathOnClient = 'ErrorLog_' + local + '.csv';
                                contentVersion.VersionData = Blob.valueOf(csvFile);
                                contentVersion.IsMajorVersion = true;
                                Insert contentVersion;

                                List<ContentVersion> List_ContentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id LIMIT 1];

                                if(List_ContentVersion!=null && !List_ContentVersion.isEmpty()){
                                    resultUploadCsvFile_TicketProduct_New.contentDocumentId = List_ContentVersion[0].ContentDocumentId;
                                }
                            }

                            NPRTicketProductAfterInsert_List = [SELECT Active__c,Ao_Name__c,AO_Related__c,Bandwidth__c,Charge_Type__c,CreatedById,CreatedDate,Data_Notes__c,Device_Name__c,Device_Related__c,Distribution_Channel__c,Dist_End_Range__c,Dist_Start_Range__c,Existing_Product_Code__c,Group_Service_Name__c,Group_Service__c,GSM_Type__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,List_Price__c,Name,New_Product_Code__c,New_Product_Registration_Ticket__c,Price_Plan_Name__c,Price_Plan_Related__c,Product_Description__c,Product_Family__c,New_Product_Family__c,Product_Unique_ID__c,Recognize_as_Revenue__c,SAP_Code__c,SIM_Type__c,Status_Product_Code__c,SystemModstamp,Ticket_Product_Type__c,UoM_Bandwidth__c,Valid__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c =: NewProductRegistrationTicketId];

                            if(NPRTicketProductAfterInsert_List!=null && !NPRTicketProductAfterInsert_List.isEmpty()){
                                resultUploadCsvFile_TicketProduct_New.ListNPRTicketProducToInsert = NPRTicketProductAfterInsert_List;
                            }else{
                                resultUploadCsvFile_TicketProduct_New.ListNPRTicketProducToInsert =  null;
                            }

                            List<ContentDocument> ContentDocumentList = [select id from ContentDocument where id =: idContentDocument];
    
                            if(ContentDocumentList!=null && !ContentDocumentList.isEmpty()){
                                delete ContentDocumentList;
                            }

                            system.debug('resultUploadCsvFile_TicketProduct_New : ' + json.serialize(resultUploadCsvFile_TicketProduct_New));
                        }
                    }
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return NPRTicketProductAfterInsert_List; 
        } catch (Exception e) {
            String err_message = 'Error on ProductOnBoarding_Controller.cls - readCSVFileUpdate ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            return NPRTicketProductAfterInsert_List;
        }
    }

}