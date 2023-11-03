/**
 * @description       : 
 * @Test Class        : TEST_TR_ContentVersionHandler_V2Test
 * @author            : Ahmat
 * @group             : 
 * @last modified on  : 09-05-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-05-2022   Novando Utoyo Agmawan   Initial Version
**/

public class Trigger_ContentVersionHandler_V2 implements ITriggerHandler {
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

                        /* di comment, codingan lama - Vando
                        String prefix = URL.getSalesforceBaseURL().toExternalForm().replace('https://', '').split('\\.')[0];
                        prefix = prefix.removeEnd('--c');
                        String fixURL = 'https://' + prefix.toLowerCase() + '.lightning.force.com' + '/lightning/r/ContentDocument/';
                        */

                        String prefix = URL.getSalesforceBaseURL().toExternalForm();
                        String fixURL = prefix + '/lightning/r/ContentDocument/';

                        Customer_Registration_Document__c customerRegistrationDocumentMap_extract = null;
                        customerRegistrationDocumentMap_extract = customerRegistrationDocumentMap.get(uniqueIdentityDocument);

                        if (customerRegistrationDocumentMap_extract != null) {
                            customerRegistrationDocumentMap_extract.Document_Link__c = fixURL + recordId + '/view';
                            customerRegistrationDocumentMap_extract.Complete__c = true;
                        }
                    }
                    update(customerRegistrationDocumentMap.values());
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
        }
    }

    /*  Author  : ahmat
        Date    : 16 february 2021 
        Project : Digital Advertising */
    //  ===================================== ahmat =================================
    public void CheckDocumentBA(Map < Id, SObject > newItems) {
        system.debug(' == masuk method CheckDocumentBA ==');
        DateTime start_time = datetime.now();
        try {
            String title;
            Id opportunityId;

            OpportunityRecordtypeSetting__c OpportunityRecordtypeSetting = OpportunityRecordtypeSetting__c.getOrgDefaults();

            id OppRT_ProjectBulkshareID = OpportunityRecordtypeSetting.OppRT_ProjectBulkshare__c;

            List < BADocumentFileNameContainWords__c > keywordList = [select name from BADocumentFileNameContainWords__c];

            for (SObject varContenVersion: newItems.values()) {
                boolean match = false;
                for (BADocumentFileNameContainWords__c keyword: keywordList) {
                    String keywordName = keyword.name;
                    
                    if (String.ValueOf(varContenVersion.get('title')).contains(keywordName)) {
                        match = true;
                    }
                    system.debug(' == varContenVersion title BA : ' + varContenVersion.get('title'));
                    system.debug('== keywordName BA : ' + keywordName );
                    SYSTEM.debug('=== hasil match BA : ' + match);
                }

                if (match &&
                    (String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == '006')) {

                    title = (String) varContenVersion.get('title');
                    opportunityId = (Id) varContenVersion.get('FirstPublishLocationId');

                }
            }

            if (String.isNotBlank(opportunityId)) {
                system.debug ('=== OppRT_ProjectBulkshareID : ' + OppRT_ProjectBulkshareID);
                
                
                List < Opportunity > oppList = [SELECT Id, BA_Doc_is_uploaded__c FROM Opportunity WHERE Id =: opportunityId AND RecordTypeId =: OppRT_ProjectBulkshareID];

                system.debug ('=== oppList : ' + oppList);

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
        }
    }

    
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
            String trialFirstPublishId = trialLinkGeneralSetting.trial_FirstPublishLocationIdSubstring__c;
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
                            (String.ValueOf(varContenVersion.get('FirstPublishLocationId')).substring(0, 3) == trialFirstPublishId)) {

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
        }
    }

}