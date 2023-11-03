/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 09-19-2023
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   16-02-2023   Doddy Prima   Initial Version
**/
global class Batch_MassRecordUpdateItem implements Database.Batchable<sObject>, Database.stateful{
    
    public List <sObject> sObjectRecordItemList = new List<sObject>();
    
    public list<string> succesRecordIdList = new list<string>();
    public list<string> failedRecordIdList = new list<string>();
    public list<string> resultRecordIdList = new list<string>();
    
    public map<string, string> updateStatusMap = new map<string, string>();

    public string fieldApiName = '';
    public string massUpdateRecordId = '';
    public string valueToUpdate = '';

    global void Batch_MassRecordUpdateItem (List<sObject> sobjectRecordList, string fieldApiName, string massUpdateRecordId, string valueToUpdate) {

        System.debug('sobjectRecordList: ' + sobjectRecordList);
        System.debug('fieldApiName: ' + fieldApiName);
        System.debug('massUpdateRecordId: ' + massUpdateRecordId);

        this.sObjectRecordItemList = sobjectRecordList;
        this.fieldApiName = fieldApiName;
        this.massUpdateRecordId = massUpdateRecordId;
        this.valueToUpdate = valueToUpdate;
    }

    global List<sObject> start(Database.BatchableContext context){
        return sObjectRecordItemList;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> sObjectRecordItemUpdateList){
        System.debug('sObjectRecordItemList: ' + sObjectRecordItemList);
        System.debug('fieldApiName: ' + fieldApiName);
        System.debug('massUpdateRecordId: ' + massUpdateRecordId);
        System.debug('sObjectRecordItemUpdateList.size.19: ' + sObjectRecordItemUpdateList.size());

        Database.SaveResult[] databaseUpdateSobejectRecordList = Database.update(sObjectRecordItemList, false);
        string errorMessage = '';
        string MessageResponse = '';

        for (Database.SaveResult databaseUpdateSobejectRecordListResults : databaseUpdateSobejectRecordList) {
                
                resultRecordIdList.add(databaseUpdateSobejectRecordListResults.getId());
                string resultRecordIdListValue = string.join(resultRecordIdList, ', ');
                system.debug('resultRecordIdListValue: '+ resultRecordIdListValue);

            if (databaseUpdateSobejectRecordListResults.isSuccess()) {
                
                updateStatusMap.put(databaseUpdateSobejectRecordListResults.getId(), 'Success: Set \'' + fieldApiName + '\' to ' + valuetoUpdate + ' on ' + system.now());
                // Operation was successful, so get the ID of the record that was processed
                succesRecordIdList.add( '\'' + databaseUpdateSobejectRecordListResults.getId() + '\'');
                
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : databaseUpdateSobejectRecordListResults.getErrors()) {   
                    updateStatusMap.put(databaseUpdateSobejectRecordListResults.getId(), 'Error: ' + err.getMessage() );
                                    
                    System.debug('The following error has occurred : ' + err.getStatusCode() + ' >> ' + err.getMessage() + err);
                    errorMessage = ('Error on : ' + fieldApiName + '| Message: ' + err.getMessage());
                    failedRecordIdList.add('\'' + databaseUpdateSobejectRecordListResults.getId() + '\'');   
                }
            }
        }

        System.debug('resultRecordIdList.61: ' + resultRecordIdList);
        System.debug('massUpdateRecordId.62: ' + massUpdateRecordId);
    }
    
    global void finish(Database.BatchableContext BC){

        System.debug('IN resultRecordIdList: ' + this.resultRecordIdList );
        System.debug('IN massUpdateRecordId: ' + this.massUpdateRecordId );

        list<mass_record_update_item__c> sobjectRecoirdItemList = [select id, Selected_Sobject_Record_ID__c, Update_Status__c from mass_record_update_item__c where Mass_Record_Update__c =:massUpdateRecordId and Selected_Sobject_Record_ID__c in :resultRecordIdList];
        System.debug('sobjectRecoirdItemList: ' + sobjectRecoirdItemList.size() + ' > ' + sobjectRecoirdItemList);

        if(sobjectRecoirdItemList.size() > 0 ){
            list<mass_record_update_item__c> newMasRecordItemUpdateList = new list<mass_record_update_item__c>();    
            for(mass_record_update_item__c sobjectRecoirdItemListRec :sobjectRecoirdItemList){
                if(updateStatusMap.get(sobjectRecoirdItemListRec.Selected_Sobject_Record_ID__c) != null){
                    String status = updateStatusMap.get(sobjectRecoirdItemListRec.Selected_Sobject_Record_ID__c);

                    sobjectRecoirdItemListRec.Update_Status__c = status.left(131072);
                    newMasRecordItemUpdateList.add(sobjectRecoirdItemListRec);   
                }
            }
            update newMasRecordItemUpdateList;

            // get MRU record
            Mass_Record_Update__c getMassUpdateRecord = [select Id, ownerid, owner.email, owner.Lastname, owner.firstname from Mass_Record_Update__c where id =: massUpdateRecordId];
            
            // apex job
            AsyncApexJob aJob = [Select Id, Status, ExtendedStatus, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =: BC.getJobId()];

            // send email
            MRU_Email_Setting__c EmailSetting = MRU_Email_Setting__c.getValues('MRU_Batch_Email');

            List<String> setCCAddress = new List<String>();
            List<String> setBCCAddress = new List<String>();

            if (EmailSetting.CC_Address__c != null) {
                setCCAddress = EmailSetting.CC_Address__c.split(',');
            } else if (EmailSetting.BCC_Address__c != null) {
                setBCCAddress = EmailSetting.BCC_Address__c.split(',');
            }

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            list<EmailTemplate> emailTemplateRecordList = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body FROM EmailTemplate WHERE DeveloperName =: EmailSetting.Email_Template_Name__c];
            for(EmailTemplate EmailTemplateRec: emailTemplateRecordList){
                mail.setSubject('Batch Batch_MassRecordUpdateItem ' + aJob.Status);
                mail.setHtmlBody(EmailTemplateRec.Body.replace('*!Batch*', string.valueOf(aJob.TotalJobItems)).replace('*!jobItemProcecss*', string.valueOf(ajob.JobItemsProcessed)).replace('*!failures*', string.valueOf(ajob.NumberOfErrors)).replace('/n', '<br>').replace('*!relatedTo.Owner.Name*', getMassUpdateRecord.owner.firstname + ' ' + getMassUpdateRecord.owner.Lastname ).replace('*!RecordId*', getMassUpdateRecord.id));
            }
            mail.setWhatId(getMassUpdateRecord.id);
            mail.setTargetObjectId(getMassUpdateRecord.Ownerid);
            mail.toAddresses = new String[] { getMassUpdateRecord.owner.email};
            mail.setCcAddresses(setCCAddress);
            mail.setBccAddresses(setBCCAddress);
            mail.setSaveAsActivity(false);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}