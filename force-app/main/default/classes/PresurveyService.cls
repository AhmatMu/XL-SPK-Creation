/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 08-03-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
public with sharing class PresurveyService {

    public static void sendEmailForCapacityAsessment (Datetime periodDate){
        String dateStr; 
        String dateStrCSV;
        String rowDataForCSV; //setup String rowData
        String errorMsg = '';
        String relatedSFIDs = '';
        String emailSubject;
        
        List<String> csvRowValues = new List<String>(); //setup for row data csv
        List<Tower_Candidate__c> towerCandidateisSentList = new List<Tower_Candidate__c>();
        

        Map<String, String> mappingAllData = new Map<String, String>(); //setup mapping for data csv
        List<Tower_Candidate__c> listCandidateTower = new List<Tower_Candidate__c>();

        Call_Log__c callLogObj = new Call_Log__c();

        set<string> presurveyIds = new set<string>();
        try {
            if (periodDate != null) {
                dateStr = periodDate.format('dd-MMM-YYYY');
                dateStrCSV = periodDate.format('dd/MM/YYYY');

                listCandidateTower = [
                    SELECT Id, CreatedDate, Name, Tower_ID__c, Router_ID__c, IsSent__c, IP_Loopback__c, Routepath__c, Presurvey__r.Bandwidth__c,
                        SR_Router__c, Note_NPD__c, Site_ID__c, Presurvey__r.Id, Presurvey__r.Name, Presurvey__r.Service__c, 
                        Presurvey__r.Interface_Capacity__c, Customer_Site__c  
                    FROM Tower_Candidate__c 
                    WHERE Presurvey__r.Presurvey_Status__c = 'Waiting Capacity Assessment' AND 
                        IsSent__c = false AND 
                        Select_For_Assessment__c = true AND
                        Customer_Site__c != Null AND
                        Tower_ID__c != Null AND
                        Router_ID__c != Null AND
                        IP_Loopback__c != Null AND
                        Routepath__c != Null AND 
                        presurvey__r.Waiting_Capacity_Assessment_Date__c <= :periodDate.date()
                ];
            }else{
                dateTime  dateNow = dateTime.now();
                dateStr = dateNow.format('dd-MMM-YYYY');
                dateStrCSV = dateNow.format('dd/MM/YYYY');
                listCandidateTower = [
                    SELECT Id, CreatedDate, Name, Tower_ID__c, Router_ID__c, IsSent__c, IP_Loopback__c, Routepath__c, Presurvey__r.Bandwidth__c,
                        SR_Router__c, Note_NPD__c, Site_ID__c, Presurvey__r.Id, Presurvey__r.Name, Presurvey__r.Service__c, 
                        Presurvey__r.Interface_Capacity__c, Customer_Site__c  
                    FROM Tower_Candidate__c 
                    WHERE Presurvey__r.Presurvey_Status__c = 'Waiting Capacity Assessment' AND 
                        IsSent__c = false AND 
                        Select_For_Assessment__c = true AND
                        Customer_Site__c != Null AND
                        Tower_ID__c != Null AND
                        Router_ID__c != Null AND
                        IP_Loopback__c != Null AND
                        Routepath__c != Null
                ];
            }
            System.debug('listCandidateTower: ' + json.serialize(listCandidateTower));
            if(listCandidateTower.size() > 0){
                for(Tower_Candidate__c dataCandidateTower: listCandidateTower){
                    rowDataForCSV = dateStrCSV + ',' + dataCandidateTower.Presurvey__r.Name + ',' + dataCandidateTower.Presurvey__r.Service__c + ',' + dataCandidateTower.Presurvey__r.Bandwidth__c + ',' + dataCandidateTower.Presurvey__r.Interface_Capacity__c + ',' + dataCandidateTower.Customer_Site__c + ',' + dataCandidateTower.Site_ID__c + ',' + dataCandidateTower.Tower_ID__c + ',' + dataCandidateTower.Router_ID__c + ',' + dataCandidateTower.IP_Loopback__c + ',' + dataCandidateTower.Routepath__c + ',' + dataCandidateTower.SR_Router__c + ',' + dataCandidateTower.Note_NPD__c; //setup data for csv at string data type
                    mappingAllData.put(dataCandidateTower.Id,rowDataForCSV); //setup mapping using key ID presurvey and data row csv
        
                    // penanda kalau sudah ter kirim
                    dataCandidateTower.isSent__c = true;
                    towerCandidateisSentList.add(dataCandidateTower);
                    presurveyIds.add(dataCandidateTower.presurvey__c);
                }
                update towerCandidateisSentList;
                
                for(String key: mappingAllData.keySet()){
                    if(key == null){
                        System.debug('not insert to csv');
                    }else{
                        csvRowValues.add(mappingAllData.get(key)); //adding value of map using key map to list row csv
                    }
                }
                
                String csvColumnHeader = 'Request Date, Presurvey, Service, Bandwidth, Interface_Capacity, Customer Site, Site ID, Tower ID, Router ID, IP Loopback, Routepath, SR Router, Note NPD, Utilisasi (SOM) \n'; //setup header data
                String csvFile = csvColumnHeader + String.join(csvRowValues,'\n').replace('null', ''); //setup all data include header and body data
                
                Presurvey_Email_Setting__c emailSetting = Presurvey_Email_Setting__c.getValues('email_to_team_capacity_som');
        
                // ============ setup attachment data
                Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
                Blob csvBlob = blob.valueOf(csvFile); //setup data to blob type
                String csvName = emailSetting.csvName__c.replace('%DATE%', dateStr);
                csvAttachment.setFileName(csvName);
                csvAttachment.setBody(csvBlob);
        
                // ============ setup general email        
                List<String> setCcAddresses = new list<String>();
                List<String> setBccAddresses = new list<String>();
                List<String> setToAddresses = new list<String>();
        
                if (emailSetting.ToAddress__c != null) {
                    setToAddresses = emailSetting.ToAddress__c.split(',');
                }
                if (emailSetting.CCAddress__c != null) {
                    setCcAddresses = emailSetting.CCAddress__c.split(',');
                }
                if (emailSetting.BCCAddress__c != null) {
                    setBccAddresses = emailSetting.BCCAddress__c.split(',');
                }
        
                EmailTemplate emailTemp = [Select Id, body From EmailTemplate Where developername =: emailSetting.Email_Template_Name__c];
                emailSubject = emailSetting.Subject__c.replace('%DATE%', dateStr);
        
                // ============ process for sending email
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                orgwideEmailAddress owaRec = [select id, address, displayname from orgwideEmailAddress where address =: emailSetting.Sender__c];
               
                email.setSubject(emailSubject);
                email.setToAddresses(setToAddresses);
                email.setCcAddresses(setCcAddresses);
                email.setBccAddresses(setBccAddresses);
                //email.setSenderDisplayName(emailSetting.Sender__c);
                email.setTemplateId(emailTemp.id);
                email.setPlainTextBody(emailTemp.body);
                email.setTargetObjectId(userInfo.getUserId());
                email.setOrgWideEmailAddressId(owaRec.id); 
                email.setSaveAsActivity(false);
                email.setUseSignature(false);
                email.setTreatTargetObjectAsRecipient(false); // new
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment}); //set file attach
                Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
                
                
                callLogObj.Status__c = 'Success';
                callLogObj.sent_email_if_failed__c = false;
                callLogObj.Request_Message__c = ('Subject: ' + emailSubject + ' ID: ' + presurveyIds).left(131070);
                callLogObj.Response_Message__c = 'is Success = ' + result[0].issuccess();
        
                System.debug('result send email = '+result);
            }
        } catch (Exception e) {
        
            callLogObj.Status__c = 'Failed';
            callLogObj.Request_Message__c = ('Subject: ' + emailSubject + ' ID: ' + presurveyIds).left(131070);
            callLogObj.Response_Message__c = e.getmessage() + ' in line: ' + e.getLineNumber();

            string notes = 'Error on PresurveyServices.sendEmailForCapacityAsessment method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }

        callLogObj.CallerFrom__c = 'Salesforce';
        callLogObj.Type__c = 'Email';
        callLogObj.Request_Start_Time__c = datetime.now();
        callLogObj.Response_End_Time__c = Datetime.now();

        insert callLogObj;
       
    }   
}