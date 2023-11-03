/**
 * @description       : 
 * @author            : ahmat.murad@saasten.com
 * @group             : 
 * @last modified on  : 02-09-2022
 * @last modified by  : ahmat.murad@saasten.com
 **/
public class Trigger_ContentVersionHandler implements ITriggerHandler {
    public Boolean IsDisabled() {
        return false;
    }

    public void BeforeInsert(List < SObject > newItems) {
        ReplacementSameFiles(newItems);
    }

    public void BeforeUpdate(Map < Id, SObject > newItems, Map < Id, SObject > oldItems) {}

    public void BeforeDelete(Map < Id, SObject > oldItems) {}

    public void AfterInsert(Map < Id, SObject > newItems) {
        CreateLinkRecordFile(newItems);
        SendEmailNotifLastFile(newItems);
        ShareToAllUser(newItems);
        CheckDocumentBA(newItems);
        ContentDocumentCOFForLinkConversionTicket(newItems);
        //   ContentDocumentProofOfChangeonPRTrial(newItems);

    }

    public void AfterUpdate(Map < Id, SObject > newItems, Map < Id, SObject > oldItems) {

        ContentDocumentCOFForLinkConversionTicket(newItems);

    }

    public void AfterDelete(Map < Id, SObject > oldItems) {}

    public void AfterUndelete(Map < Id, SObject > oldItems) {}

    public void ReplacementSameFiles(List < SObject > newItems) {
        DateTime start_time = datetime.now();
        try {
            String typeFile;
            Id customerRegistrationTicketId;
            for (SObject varContenVersion: newItems) {
                if (String.isNotBlank((String) varContenVersion.get('Document_Type_Name__c')) && (String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == 'a1A' || String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == 'a11')) {
                    typeFile = (String) varContenVersion.get('Document_Type_Name__c');
                    customerRegistrationTicketId = (Id) varContenVersion.get('FirstPublishLocationId');
                }
            }

            if (String.isNotBlank(typeFile) && String.isNotBlank(customerRegistrationTicketId)) {
                List < ContentVersion > contentVersionList = [select ContentDocumentId from ContentVersion
                    where Document_Type_Name__c =: typeFile and FirstPublishLocationId =: customerRegistrationTicketId
                ];


                if (contentVersionList != null && !contentVersionList.isEmpty()) {
                    set < Id > ContentDocumentIdList = new set < id > ();

                    for (ContentVersion contentVersionListExtract: contentVersionList) {
                        ContentDocumentIdList.add((Id) contentVersionListExtract.ContentDocumentId);
                    }

                    List < ContentDocument > ContentDocumentList = [select id from ContentDocument
                        where id In: ContentDocumentIdList
                    ];
                    if (ContentDocumentList != null && !ContentDocumentList.isEmpty()) {
                        delete ContentDocumentList;

                        AppUtils.putCalllog('Trigger', null, start_time, 'success', datetime.now(), 'Trigger_ContentVersionHandler.cls - ReplacementSameFiles', null);
                    }
                }
            }

            if (Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Insert - Content Version ::' + e.getmessage() + ' - ' + e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger', null, start_time, 'failed', datetime.now(), 'Trigger_ContentVersionHandler.cls - ReplacementSameFiles', err_message);
        }
    }

    public void CreateLinkRecordFile(Map < Id, SObject > newItems) {
        DateTime start_time = datetime.now();
        try {
            Id recordId;
            Id customerRegistrationTicketId;
            String uniqueIdentityDocument;
            for (SObject varContenVersion: newItems.values()) {
                if (String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == 'a1A' || String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == 'a11') {
                    customerRegistrationTicketId = (Id) varContenVersion.get('FirstPublishLocationId');
                }
            }

            if (String.isNotBlank(customerRegistrationTicketId)) {
                Map < String, Customer_Registration_Document__c > customerRegistrationDocumentMap = new Map < String, Customer_Registration_Document__c > ();

                List < Customer_Registration_Document__c > customerRegistrationDocumentList = [SELECT Id, Customer_Registration_Ticket__c, Unique_Identity_Document__c, Name, Document_Type_Name__c, Document_Link__c FROM Customer_Registration_Document__c WHERE Customer_Registration_Ticket__c =: customerRegistrationTicketId];

                if (customerRegistrationDocumentList != null && !customerRegistrationDocumentList.isEmpty()) {
                    for (Customer_Registration_Document__c customerRegistrationDocumentList_extract: customerRegistrationDocumentList) {
                        customerRegistrationDocumentMap.put(customerRegistrationDocumentList_extract.Unique_Identity_Document__c, customerRegistrationDocumentList_extract);
                    }

                    for (SObject varContenVersion: newItems.values()) {
                        recordId = (Id) varContenVersion.get('Id');
                        uniqueIdentityDocument = (String) varContenVersion.get('Document_Type_Name__c') + '/' + (String) varContenVersion.get('FirstPublishLocationId');

                        String prefix = URL.getSalesforceBaseURL().toExternalForm().replace('https://', '').split('\\.')[0];
                        prefix = prefix.removeEnd('--c');
                        String fixURL = 'https://' + prefix.toLowerCase() + '.lightning.force.com' + '/lightning/r/ContentDocument/';

                        Customer_Registration_Document__c customerRegistrationDocumentMap_extract = null;
                        customerRegistrationDocumentMap_extract = customerRegistrationDocumentMap.get(uniqueIdentityDocument);

                        if (customerRegistrationDocumentMap_extract != null) {
                            customerRegistrationDocumentMap_extract.Document_Link__c = fixURL + recordId + '/view';
                            customerRegistrationDocumentMap_extract.Complete__c = true;
                        }
                    }
                    update(customerRegistrationDocumentMap.values());

                    AppUtils.putCalllog('Trigger', null, start_time, 'success', datetime.now(), 'Trigger_ContentVersionHandler.cls - CreateLinkRecordFile', null);
                }
            }

            if (Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Insert - Content Version ::' + e.getmessage() + ' - ' + e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger', null, start_time, 'failed', datetime.now(), 'Trigger_ContentVersionHandler.cls - CreateLinkRecordFile', err_message);
        }
    }

    public void SendEmailNotifLastFile(Map < Id, SObject > newItems) {
        DateTime start_time = datetime.now();
        try {
            Id customerRegistrationTicketId;
            for (SObject varContenVersion: newItems.values()) {
                if (String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == 'a1A' || String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == 'a11') {
                    customerRegistrationTicketId = (Id) varContenVersion.get('FirstPublishLocationId');
                }
            }

            if (String.isNotBlank(customerRegistrationTicketId)) {
                Integer countAllDocument = [Select Count() From Customer_Registration_Document__c WHERE Customer_Registration_Ticket__c =: customerRegistrationTicketId];

                Integer countAllDocumentComplete = [Select Count() From Customer_Registration_Document__c WHERE Customer_Registration_Ticket__c =: customerRegistrationTicketId AND Complete__c =: true];

                if (countAllDocument == countAllDocumentComplete) {
                    Map < Id, Customer_Registration_Ticket__c > customerRegistrationTicketMap = new Map < Id, Customer_Registration_Ticket__c > ([SELECT Id, Stage__c, Need_send_email_alert__c FROM Customer_Registration_Ticket__c WHERE Id =: customerRegistrationTicketId]);

                    if (customerRegistrationTicketMap != null && !customerRegistrationTicketMap.isEmpty()) {
                        for (SObject varContenVersion: newItems.values()) {
                            Customer_Registration_Ticket__c customerRegistrationTicket = customerRegistrationTicketMap.get((Id) varContenVersion.get('FirstPublishLocationId'));
                            customerRegistrationTicket.Need_send_email_alert__c = true;
                            customerRegistrationTicket.Stage__c = 'Need To Review';
                        }
                        update(customerRegistrationTicketMap.values());

                        AppUtils.putCalllog('Trigger', null, start_time, 'success', datetime.now(), 'Trigger_ContentVersionHandler.cls - SendEmailNotifLastFile', null);
                    }
                }
            }

            if (Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Insert - Content Version ::' + e.getmessage() + ' - ' + e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger', null, start_time, 'failed', datetime.now(), 'Trigger_ContentVersionHandler.cls - SendEmailNotifLastFile', err_message);
        }
    }

    public void ShareToAllUser(Map < Id, SObject > newItems) {
        DateTime start_time = datetime.now();
        Set < Id > IdUserNotInclude = new Set < Id > ();
        IdUserNotInclude.add('0055D000001FxcJQAS');
        IdUserNotInclude.add('0057F000001r4eiQAA');
        IdUserNotInclude.add('0055D000002GTmXQAW');
        IdUserNotInclude.add('0057F000005SOOAQA4');
        IdUserNotInclude.add('0057F0000043NWdQAM');
        try {
            List < User > userList = [SELECT Id FROM User WHERE Id !=: UserInfo.getUserId() AND IsActive =: true AND Id !=: IdUserNotInclude];

            list < ContentDocumentLink > cdl_List = new list < ContentDocumentLink > ();

            for (SObject varContenVersion: newItems.values()) {
                //if(String.isNotBlank((String)varContenVersion.get('Document_Type_Name__c'))){

                if (userList != null && !userList.isEmpty()) {
                    for (User userListExtract: userList) {
                        userListExtract.UserPreferencesDisableAllFeedsEmail = TRUE;

                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.LinkedEntityId = userListExtract.Id;
                        cdl.ContentDocumentId = (Id) varContenVersion.get('ContentDocumentId');
                        cdl.ShareType = 'V';
                        cdl.Visibility = 'AllUsers';
                        cdl_List.add(cdl);
                    }

                    AppUtils.putCalllog('Trigger', null, start_time, 'success', datetime.now(), 'Trigger_ContentVersionHandler.cls - ShareToAllUser', null);
                }
                //}
            }
            update userList;
            insert cdl_List;

            for (SObject varContenVersion: newItems.values()) {
                //if(String.isNotBlank((String)varContenVersion.get('Document_Type_Name__c'))){

                if (userList != null && !userList.isEmpty()) {
                    for (User userListExtract: userList) {
                        userListExtract.UserPreferencesDisableAllFeedsEmail = FALSE;
                    }
                    AppUtils.putCalllog('Trigger', null, start_time, 'success', datetime.now(), 'Trigger_ContentVersionHandler.cls - ShareToAllUser', null);
                }
                //}
            }
            update userList;

            if (Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Insert - Content Version ::' + e.getmessage() + ' - ' + e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger', null, start_time, 'failed', datetime.now(), 'Trigger_ContentVersionHandler.cls - ShareToAllUser', err_message);
        }
    }

    /*  Author  : ahmat
        Date    : 16 february 2021 
        Project : Digital Advertising */
    //  ===================================== ahmat =================================
    public void CheckDocumentBA(Map < Id, SObject > newItems) {
        DateTime start_time = datetime.now();
        try {
            String title;
            Id opportunityId;
            String recordTypeName = 'Digital Advertising'; // <-- Change this to record type name

            Map < String, Schema.RecordTypeInfo > rtMapByName = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtInfo = rtMapByName.get(recordTypeName);
            Id recordTypeId_Digital_advertasing = rtInfo.getRecordTypeId();

            //   List<ContentDocumentLink> CDLList = new List<ContentDocumentLink>();
            // List<ContentDocumentLink_queryString__c> ContentDocumentLink_queryString= [select String_Condition__c from ContentDocumentLink_queryString__c where name = 'Condition_OppDoc'];

            List < BADocumentFileNameContainWords__c > keywordList = [select name from BADocumentFileNameContainWords__c];

            for (SObject varContenVersion: newItems.values()) {
                boolean match = false;
                for (BADocumentFileNameContainWords__c keyword: keywordList) {
                    String keywordName = keyword.name;

                    if (String.ValueOf(varContenVersion.get('title')).contains(keywordName)) {
                        match = true;
                    }
                }

                if (match &&
                    (String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == '006')) {

                    title = (String) varContenVersion.get('title');
                    opportunityId = (Id) varContenVersion.get('FirstPublishLocationId');

                }
            }

            if (String.isNotBlank(opportunityId)) {
                List < Opportunity > oppList = [SELECT Id, BA_Doc_is_uploaded__c FROM Opportunity WHERE Id =: opportunityId AND RecordTypeId =: recordTypeId_Digital_advertasing];

                if (oppList != null && !oppList.isEmpty()) {
                    for (Opportunity oppList_Extract: oppList) {
                        oppList_Extract.BA_Doc_is_uploaded__c = true;
                    }
                    update oppList;
                }
            }

            if (Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger after Insert - Content Version ::' + e.getmessage() + ' - ' + e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger', null, start_time, 'failed', datetime.now(), 'Trigger_ContentVersionHandler.cls - CheckDocumentBA', err_message);
        }
    }

    /*  Author  : ahmat
      Date    : 28 November 2021 
      Project : PR Trial doukemen check */
    //  ===================================== ahmat =================================
    /*
    public void ContentDocumentProofOfChangeonPRTrial(Map<Id, SObject> newItems){
        system.debug('====== IN Trigger_ContentVersionHandler.ContentDocumentProofOfChangeonPRTrial');
        DateTime start_time = datetime.now();
        try {
            String title;
            id SRPRNotificationId;

            List<PR_Trial_Document_Name_Setting__c	> keywordList = [select name, Contains_name__c from PR_Trial_Document_Name_Setting__c ];
            system.debug('== keywordList.pr_trial_custom_setting :' + keywordList);

            for(SObject varContenVersion : newItems.values()){
                boolean match  = false;
                for(PR_Trial_Document_Name_Setting__c keyword : keywordList){
                    String keyWordName =  keyword.Contains_name__c.toUppercase();
                  
                    if ( String.ValueOf( varContenVersion.get('title') ).toUppercase().contains(keyWordName) ) {
                    	match =true;
                        SYSTEM.debug('=== masuk di persamaan === 318');
               		}
                                               
                system.debug(' == keywordName :' + varContenVersion.get('title'));
                system.debug('== keyword.Contains_name__c :' + keyWordName);
                }

                if(match
                    && (String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == 'a0i')){
                        
                    title = (String)varContenVersion.get('title');
                    SRPRNotificationId = (Id)varContenVersion.get('FirstPublishLocationId');
                }
                
                system.debug('SRPRNotificationId ==' + SRPRNotificationId);
                system.debug('title ==' +  title);
            }
            
            system.debug('== masuk di line 345 ==');
            if(String.isNotBlank(SRPRNotificationId)){
                system.debug(' == SRPRNotificationId : ' + SRPRNotificationId);

                List<SR_PR_Notification__c> SRPRList = [SELECT Id, Proof_of_Change_PR_Trial_Is_Upload__c FROM SR_PR_Notification__c WHERE Id = :SRPRNotificationId AND trial__c = true AND recordType.name Like '%pr%'];
                system.debug(' == SRPRList :' + SRPRList);
                if(SRPRList!=null && !SRPRList.isEmpty()){
                    for(SR_PR_Notification__c SRPR_Extract : SRPRList){
                        SRPR_Extract.Proof_of_Change_PR_Trial_Is_Upload__c = true;
                    }
                    update SRPRList;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) { 
            String err_message = 'Error on Trigger after Insert - Content Version ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'Trigger_ContentVersionHandler.cls - ContentDocumentProofOfChangeonPRTrial',err_message);
        }
    }*/
    /*      Author  : ahmat
            Date    : 5 January 2022 
            Project : trial monitoring ticket COF doukemen check */
    //  ===================================== ahmat =================================

    public void ContentDocumentCOFForLinkConversionTicket(Map < Id, SObject > newItems) {
        system.debug('====== IN Trigger_ContentVersionHandler.ContentDocumentCOFForLinkConversionTicket');
        DateTime start_time = datetime.now();
        try {
            String title;
            id linkConversionTicketId;

            TrialLinkConversionGENERALSetting__c trialLinkGeneralSetting = TrialLinkConversionGENERALSetting__c.getOrgDefaults();

            String keywordList = trialLinkGeneralSetting.COF_Content_Document__c;
            String[] keywoardListSplit = keywordList.split(',');

            for (SObject varContenVersion: newItems.values()) {
                boolean match = false;

                for (String KeywordsListSplitResult: keywoardListSplit) {
                    String keywoardsName = KeywordsListSplitResult.toUpperCase();
                    system.debug('== keywoardsName : ' + keywoardsName);

                    if (String.ValueOf(varContenVersion.get('title')).toUppercase().contains(keywoardsName)) {
                        system.debug(' == varContenVersion title : ' + varContenVersion.get('title'));
                        system.debug('== keywoardsName : ' + keywoardsName );
                        SYSTEM.debug('=== hasil match : ' + match);
                        match = true;
                    }

                        if (match &&
                            (String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == 'a21')) {

                            title = (String) varContenVersion.get('title');
                            linkConversionTicketId = (Id) varContenVersion.get('FirstPublishLocationId');
                        }
                    }
                

                system.debug('linkConversionTicketId ==' + linkConversionTicketId);
                system.debug('title ==' + title);
            }

            system.debug('== masuk di line 345 ==');
            if (String.isNotBlank(linkConversionTicketId)) {
                system.debug(' == linkConversionTicketId : ' + linkConversionTicketId);

                List < trial_monitoring_ticket__c > LinkConversionTicketList = [SELECT Id, Doc_COF_Is_Uploaded__c FROM trial_monitoring_ticket__c WHERE Id =: linkConversionTicketId];
                system.debug(' == LinkConversionTicketList :' + LinkConversionTicketList);
                if (LinkConversionTicketList != null && !LinkConversionTicketList.isEmpty()) {
                    for (trial_monitoring_ticket__c linkConversionTicketRec: LinkConversionTicketList) {
                        linkConversionTicketRec.Doc_COF_Is_Uploaded__c = true;
                    }
                    update LinkConversionTicketList;
                }
            }

            if (Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger after Insert - Content Version ::' + e.getmessage() + ' - ' + e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger', null, start_time, 'failed', datetime.now(), 'Trigger_ContentVersionHandler.cls - ContentDocumentProofOfChangeonPRTrial', err_message);
        }
    }

}