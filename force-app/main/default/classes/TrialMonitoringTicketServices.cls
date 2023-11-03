/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 05-25-2022
 * @last modified by  : Andre Prasetya
**/
public with sharing class TrialMonitoringTicketServices {
    public string relatedSFIDs;

    public static void createTrialMonitoringTicketRecords(Id recordId) {
        Set<string> linkIDs = new Set <string>();
        string relatedSFIDs;
        Id RecordType;
        Id srprID;
     //  TrialLinkConversionGENERALSetting__c TmtSetting = TrialLinkConversionGENERALSetting__c.getorgdefaults();
      
        try{
            String month='';
            String year='';
            SYSTEM.debug('=== TrialMonitoringTicketServices.createTrialMonitoringTicketRecords ===');

            List <Link__c> trialLinkList = [SELECT Id, OwnerID, Owner.email, Name, CreatedById, LastModifiedById, Company_Name__c, CID__c, Address__c, Capacity_Bandwidth__c, Trial_Capacity_Bandwith__c, Trial_UOM_Bandwith__c, UoM__c, CID_RelD__c,Link_ID__c,Last_PR_Rel__c,Last_PR_Rel__r.Opportunity__r.OwnerID, Site_A_Name__c, Free_Link__c, Partner__c, Contract_Category__c, Trial_Start_Date__c, Trial_End_Date__c, previous_bandwith__c, Trial_Service_Type__c, Is_Trial__c, Trial_Reminder_Date__c FROM Link__c WHERE Id =:recordID AND is_Trial__c = true];
           
            system.debug(' == linkTrialObj: ' + trialLinkList);

            list<Trial_Monitoring_Ticket__c> trialMonitoringTicketList = new List<Trial_Monitoring_Ticket__c>();
            if(trialLinkList.size() != null || trialLinkList.size()> 0){
                for(Link__c trialLinkRec : trialLinkList){
                    relatedSFIDs = trialLinkRec.id;
                    if(trialLinkRec.Trial_Service_Type__c == 'Newlink'){
                        Id RecordTypeNewlinkId = Schema.SObjectType.Trial_Monitoring_Ticket__c.getRecordTypeInfosByName().get('New Link Trial-to-Production').getRecordTypeId();
                        RecordType = RecordTypeNewlinkId;
                        system.debug('== RecordTypeNewlinkId + ' + RecordTypeNewlinkId);
                    }if(trialLinkRec.Trial_Service_Type__c == 'Upgrade'){
                        Id RecordTypeUpgradeId = Schema.SObjectType.Trial_Monitoring_Ticket__c.getRecordTypeInfosByName().get('Upgrade Link Trial-to-Production').getRecordTypeId();
                        RecordType = RecordTypeUpgradeId;
                        system.debug('== RecordTypeUpgradeId + ' + RecordTypeUpgradeId);
                    }if(trialLinkRec.Trial_Service_Type__c == 'Downgrade'){
                        Id RecordTypeDowngradeId = Schema.SObjectType.Trial_Monitoring_Ticket__c.getRecordTypeInfosByName().get('Downgrade Link Trial-to-Production').getRecordTypeId();
                        RecordType = RecordTypeDowngradeId;
                        system.debug('== RecordTypeDowngradeId + ' + RecordTypeDowngradeId);
                    }
                    linkIDs.add(trialLinkRec.Id);
                }
                
                List<Trial_Monitoring_Ticket__c> linkTicketList = [ SELECT Name,Unique_id__c,Link__c,Trial_Service_Type__c FROM Trial_Monitoring_Ticket__c WHERE Link__c in :linkIDs AND Link_Conversion_Ticket_Stage__c <> 'Complete'];
                
                // custom setting trialLinkGeneralSetting
                TrialLinkConversionGENERALSetting__c  trialLinkGeneralSetting = TrialLinkConversionGENERALSetting__c.getOrgDefaults();
                double reminderToImplementation = trialLinkGeneralSetting.Days_before_end_date_to_implementation__c * -1;
                double reminderToProjectCoordinator = trialLinkGeneralSetting.Days_Before_remind_Project_Coordinator__c * -1;

                integer numberofreminderToImplementation = integer.valueOf(reminderToImplementation);
                integer numberofreminderToProjectCoordinator = integer.valueOf(reminderToProjectCoordinator);
                System.debug('=== reminderToImplementation : ' + reminderToImplementation);
                system.debug('reminderToProjectCoordinator :'+ reminderToProjectCoordinator);
                 Map<String, String> linkTicketMap = new Map<String, String>();
                
                for (Trial_Monitoring_Ticket__c obj : linkTicketList) {
                    linkTicketMap.put(obj.Unique_id__c,'available');
                }
                SYSTEM.DEBUG ('======== LinkTicketMap : ' + LinkTicketMap );
                
                for(Link__c trialLinkRec : trialLinkList){
                    Date startDate = trialLinkRec.Trial_Start_Date__c;
                    System.debug(startDate.format());
                    String trialCapacity = trialLinkRec.Trial_Capacity_Bandwith__c+trialLinkRec.Trial_UOM_Bandwith__c;
                    
                    String uniqueName = 'TMT-'+trialLinkRec.Trial_Service_Type__c+'-'+trialLinkRec.Link_ID__c+'-'+trialCapacity+'-'+startDate.format();
                    String availUniqueName = (String) linkTicketMap.get(uniqueName);
                    //String availType = (String) linkTicketMap.get(trialLinkRec.Trial_Service_Type__c);
                     SYSTEM.DEBUG ('======== LinkTicketMapString : ' + availUniqueName);
                    
                     if(system.today().month()<10) {
                         month='0'+String.valueof(system.today().month());
                     }
                     else{
                         month=String.valueof(system.today().month());
                     }
                     year=String.valueof(system.today().year()).right(2);
                 
                    if (availUniqueName == null) {
                    //    String todaymonthyear=year+month;
                     //   String TMTNumber=String.valueof(TmtSetting.Ticket_Number__c).leftPad(7, '0');
                       // TMTNumber = TMTNumber.left(TMTNumber.length()-2);
                    //    TMTNumber=TMTNumber.replace('.0','');
                        Trial_Monitoring_Ticket__c trialMonitoringTicketRec=new Trial_Monitoring_Ticket__c();
                        String recordName = 'TMT-'+trialLinkRec.Trial_Service_Type__c+'-'+trialLinkRec.Link_ID__c+'-'+trialLinkRec.Trial_Capacity_Bandwith__c+'-'+trialLinkRec.Trial_UOM_Bandwith__c+'-'+startDate.format();
                      //  trialMonitoringTicketRec.Name ='TMT-'+todaymonthyear+'-'+TMTNumber;
                        trialMonitoringTicketRec.Link_Conversion_Ticket_Stage__c ='On Going Trial';
                        trialMonitoringTicketRec.Link_Conversion_Ticket_Status__c ='Waiting Customer Confirmation';
                        trialMonitoringTicketRec.RecordTypeId = RecordType;
                        trialMonitoringTicketRec.Link__c = trialLinkRec.id;
                        trialMonitoringTicketRec.PR_Rel__c = trialLinkRec.Last_PR_Rel__c;
                        trialMonitoringTicketRec.Unique_id__c =recordName;
                        trialMonitoringTicketRec.OwnerID = trialLinkRec.Last_PR_Rel__r.Opportunity__r.OwnerID;
                        trialMonitoringTicketRec.Trial_Start_Date__c= trialLinkRec.Trial_Start_Date__c;
                        trialMonitoringTicketRec.Trial_End_Date__c = trialLinkRec.Trial_End_Date__c;
                        if (trialLinkRec.Trial_Capacity_Bandwith__c != null){
                        	trialMonitoringTicketRec.Trial_Capacity_Bandwith__c = trialLinkRec.Trial_Capacity_Bandwith__c;                          
                        }
                        if(trialLinkRec.Trial_UOM_Bandwith__c != null){
			            	trialMonitoringTicketRec.Trial_UOM_Bandwith__c = trialLinkRec.Trial_UOM_Bandwith__c;                
                        }
                        trialMonitoringTicketRec.Trial_Reminder_Date__c = trialLinkRec.Trial_Reminder_Date__c;
                        trialMonitoringTicketRec.Trial_Service_Type__c = trialLinkRec.Trial_Service_Type__c;
                        trialMonitoringTicketRec.Trial_Reminder_Date_Move_Implementation__c = trialLinkRec.Trial_End_Date__c.addDays(numberofreminderToImplementation);
                        trialMonitoringTicketRec.Trial_Reminder_Date_Project_Coordinator__c = trialLinkRec.Trial_End_Date__c.addDays(numberofreminderToProjectCoordinator);

                        SYSTEM.DEBUG ('======== trialLinkRec.Trial_Reminder_Date__c : ' + trialLinkRec.Trial_Reminder_Date__c );
                        SYSTEM.DEBUG ('======== trialMonitoringTicketRec : ' + trialMonitoringTicketRec );
                        SYSTEM.DEBUG ('======== trialLinkRec.Trial_Service_Type__c : ' + trialLinkRec.Trial_Service_Type__c );
                    
                       trialMonitoringTicketList.add(trialMonitoringTicketRec);
                      // TmtSetting.Ticket_Number__c=TmtSetting.Ticket_Number__c+1;
                    }
                }
                SYSTEM.DEBUG ('======== trialMonitoringTicketList : ' + trialMonitoringTicketList );
                insert trialMonitoringTicketList;
                updateFieldInLink(trialMonitoringTicketList);
               // update TmtSetting; 
                
            }
        }catch(Exception e){
            
            string notes = 'Error on TrialMonitoringTicketServices.createTrialMonitoringTicketServices method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }

//Send Email N Days to End Date
//Lihat Class Schedule_TrialLinkNotification Class
    public void sendTrialEmailNotificationSegments(Id UserRoleId){
        // '=== trialmonitroingticketservices.sendTrialEmailNotificationSegments ==='
        Integer totalpendingsegment = 0;
        List<string> List_toAddress = new list<String>();
        Messaging.SingleEmailMessage message;
        String additionalBcc = '';
        String additionalCc='';
        String additionalTo='';
        String emailTemplateName='';
        String senderEmailAddress='';
        try {
            List<String> additionalBccList= new List<String>();
            List<String> additionalCcList = new List<String>();
            TrialLinkConversionEmailSetting__c trialEmailSetting = TrialLinkConversionEmailSetting__c.getValues('Email Notification Segments');

            if(trialEmailSetting.AdditionalBccEmailAddress__c !=null){
                additionalBcc = trialEmailSetting.AdditionalBccEmailAddress__c;
                List<String> additionalBccListTmp = AppUtils.additionalSettingEmail(additionalBcc);
                if (additionalBccListTmp != null) {
                    additionalBccList = additionalBccListTmp;
                }
            }
            if(trialEmailSetting.AdditionalCCEmailAddress__c !=null){
                additionalCc = trialEmailSetting.AdditionalCCEmailAddress__c;
                List<String> additionalCcListTmp = AppUtils.additionalSettingEmail(additionalCc);
                if (additionalCcListTmp != null) {
                    additionalCcList = additionalCcListTmp;
                }
            }
            if(trialEmailSetting.AdditionalToEmailAddress__c !=null){
                additionalTo = trialEmailSetting.AdditionalToEmailAddress__c;
                List<String> additionalToListTmp = AppUtils.additionalSettingEmail(additionalTo);
                if (additionalToListTmp != null) {
                    List_toAddress = additionalToListTmp;
                }
            }
            if(trialEmailSetting.EmailTemplateName__c !=null){
                emailTemplateName = trialEmailSetting.EmailTemplateName__c;
            }
            if(trialEmailSetting.SenderEmailAddress__c !=null){
                senderEmailAddress = trialEmailSetting.SenderEmailAddress__c;
            }
            Set<String> userRoleSet = new Set<String>();
            list<String> SegmentList = new list<String>();
            list<String> OwnerIdList = new list<String>();
            Set<id> OwnerIdSet = new Set<Id>();

            //update 23 mei                
            List<String> emailBccList= new List<String>();
            List<String> emailCcList = new List<String>();
            List<String> emailToList = new List<String>();

            emailToList.addAll(List_toAddress);
            emailCcList.addAll(additionalCcList);
            emailBccList.addAll(additionalBccList);

            List<Trial_Monitoring_Ticket__c> trialMonitoringTicketList = [select OwnerId, Owner.email, Owner.UserRoleId, Segment__c FROM Trial_Monitoring_Ticket__c WHERE Link_Conversion_Ticket_Stage__c = 'On Going Trial' AND Owner.UserRoleId =: UserRoleId];
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate WHERE name =:emailTemplateName];
            system.debug(' == trialMonitoringTicketList: ' + trialMonitoringTicketList);
            if(trialMonitoringTicketList!=null && !trialMonitoringTicketList.isEmpty()){
                for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec : trialMonitoringTicketList){
                    system.debug(' == trialMonitoringTicketRec: ' + trialMonitoringTicketRec);
                    userRoleSet.add(trialMonitoringTicketRec.Segment__c);
                   // OwnerIdSet.add(trialMonitoringTicketRec.OwnerId);
                }
            }
            if(userRoleSet!=null && !userRoleSet.isEmpty()){
                SegmentList.addAll(userRoleSet);
            }
            message = new Messaging.SingleEmailMessage();
            system.debug('CCLIST-->' +emailCcList);
            message.setCcAddresses(emailCcList);
            system.debug('BCCLIST-->' +emailBccList);
            if(emailBccList.size()>0){
                message.setBccAddresses(emailBccList);
                }else{
                message.setBccSender(false); 
                }
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='fixeditdelivery@xl.co.id'];

            for(Integer i=0;i<SegmentList.size();i++)
            {
                totalpendingsegment =0;              
                message.setOrgWideEmailAddressId(owea.get(0).Id);
                
                emailToList = new List<string>();

                for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec : trialMonitoringTicketList){
                    if(trialMonitoringTicketRec.Segment__c == SegmentList[i]){
                        message.setTargetObjectId(trialMonitoringTicketRec.OwnerId);
                        message.setUseSignature(false); 
                        message.setSaveAsActivity(false);
                        message.setTemplateID(emailTemplate.Id); 
                        message.setWhatId(trialMonitoringTicketRec.OwnerId); //This is important for the merge fields in template to work
                            list<User> userList = [SELECT id, email, UserRole.Name FROM User WHERE UserRole.Name=:trialMonitoringTicketRec.Segment__c AND Id =: trialMonitoringTicketRec.OwnerId]; 
                            
                            if(userList!=null && !userList.isEmpty()){
                                for(User userListRec : userList)
                                {
                                    if(userListRec.email != null){
                                        emailToList.add(userListRec.email); 
                                    }   
                                }
                            }
                            totalpendingsegment = totalpendingsegment + 1;
                    }
                }
            }
            
            System.debug('jumlah segmen ----> ' + SegmentList.size());
            System.debug('Segment ----> ' + SegmentList);
            System.debug('emailNYA ----> ' + emailToList);
          //  System.debug('total pending ----> ' + totalpendingsegment);
            message.setToAddresses(emailToList);
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            if(totalpendingsegment>0) 
                {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
            
        } catch(Exception e) {
            string notes = 'Error on TrialMonitoringTicketServices.sendTrialEmailNotification method.'; string messagess =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  messagess + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

   // Send Email to project Coordinator Dismantle Link
   // Lihat moveTicketStageToImplementation method
   public void sendEmailDismantleLinkNotification(List<Trial_Monitoring_Ticket__c> trialMonitoringTicketList){
    try {
        
        for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec : trialMonitoringTicketList){
            String emailProjectCoordinator = trialMonitoringTicketRec.PR_Rel__r.Project_Coordinator_Email__c;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(trialMonitoringTicketRec.OwnerId); 
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='fixeditdelivery@xl.co.id'];
            message.setOrgWideEmailAddressId(owea.get(0).Id);
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(false); 
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate WHERE name = 'Oppty Trial - Send Email to Dismantle Link'];
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(trialMonitoringTicketRec.Id); //This is important for the merge fields in template to work
            if(test.isRunningTest())
                  {
                    message.toAddresses = new String[] {'dikynurosid@gmail.com'};
                  }
                  else{
                    message.toAddresses = new String[] {emailProjectCoordinator};
                  }
         
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
            //moveTicketStageToImplementation(trialMonitoringTicketRec.Id);
            System.debug('The email was sent successfully to --> ' + emailProjectCoordinator);
            } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
        
    } catch(Exception e) {
        string notes = 'Error on TrialMonitoringTicketServices.sendEmailDismantleLinkNotification method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber(); string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
    }
    
}
//is expired
public void sendEmailWhenTrialisExpired(Id OwnerId,String Email){
    try {
        String additionalBcc = '';
        String additionalCc='';
        String additionalTo='';
        String emailTemplateName='';
        String senderEmailAddress='';

        List<String> additionalBccList= new List<String>();
        List<String> additionalCcList = new List<String>();
        List<String> additionalToList = new List<String>();
        TrialLinkConversionEmailSetting__c trialEmailSetting = TrialLinkConversionEmailSetting__c.getValues('Email Notification If Trial Is Expired');
            if(trialEmailSetting.AdditionalBccEmailAddress__c !=null){
                additionalBcc = trialEmailSetting.AdditionalBccEmailAddress__c;
                List<String> additionalBccListTmp = AppUtils.additionalSettingEmail(additionalBcc);
                if (additionalBccListTmp != null) {
                    additionalBccList = additionalBccListTmp;
                }
            }
            if(trialEmailSetting.AdditionalCCEmailAddress__c !=null){
                additionalCc = trialEmailSetting.AdditionalCCEmailAddress__c;
                List<String> additionalCcListTmp = AppUtils.additionalSettingEmail(additionalCc);
                if (additionalCcListTmp != null) {
                    additionalCcList = additionalCcListTmp;
                }
            }
            if(trialEmailSetting.AdditionalToEmailAddress__c !=null){
                additionalTo = trialEmailSetting.AdditionalToEmailAddress__c;
                List<String> additionalToListTmp = AppUtils.additionalSettingEmail(additionalTo);
                if (additionalToListTmp != null) {
                    additionalToList = additionalToListTmp;
                }
            }
            if(trialEmailSetting.EmailTemplateName__c !=null){
                emailTemplateName = trialEmailSetting.EmailTemplateName__c;
            }
            if(trialEmailSetting.SenderEmailAddress__c !=null){
                senderEmailAddress = trialEmailSetting.SenderEmailAddress__c;
            }
            additionalToList.add(email);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(OwnerId); 
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:senderEmailAddress];
            if(test.isRunningTest()){
                message.setOrgWideEmailAddressId('0D27F0000008R2pSAE');
            }
            else{
                
                message.setOrgWideEmailAddressId(owea.get(0).Id);
            }
         
            //message.setOrgWideEmailAddressId(owea.get(0).Id);
            message.setUseSignature(false); 
            message.setCcAddresses(additionalCcList);
            if(additionalBccList.size()>0){
                message.setBccAddresses(additionalBccList);
                }else{
                    message.setBccSender(false); 
                }
            message.setSaveAsActivity(false);
           // message.CcAddresses = new String[] {'diky.nurosid@saasten.com'};
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate WHERE name =: emailTemplateName];
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(OwnerId); //This is important for the merge fields in template to work
            message.setToAddresses(additionalToList);// = new String[] {Email};
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
            //moveTicketStageToImplementation(trialMonitoringTicketRec.Id);
            System.debug('The email was sent successfully to --> ');
            } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
       
        
    } catch(Exception e) {
        string notes = 'Error on TrialMonitoringTicketServices.sendEmailDismantleLinkNotification method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber(); string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
    }   
}
    
//update 11 jan
   // Send Email to sales cc ORM, project coord h-3
   public void sendEmailConfirmationToSales(List<Trial_Monitoring_Ticket__c> trialMonitoringTicketList){
    try {
        String additionalBcc = '';
        String additionalCc='';
        String additionalTo='';
        String emailTemplateName='';
        String senderEmailAddress='';

        List<String> additionalBccList= new List<String>();
        List<String> additionalCcList = new List<String>();
        List<String> additionalToList = new List<String>();
        TrialLinkConversionEmailSetting__c trialEmailSetting = TrialLinkConversionEmailSetting__c.getValues('Email Confirmation to Sales');
       if(trialEmailSetting.AdditionalBccEmailAddress__c !=null){
        additionalBcc = trialEmailSetting.AdditionalBccEmailAddress__c;
        List<String> additionalBccListTmp = AppUtils.additionalSettingEmail(additionalBcc);
        if (additionalBccListTmp != null) {
            additionalBccList = additionalBccListTmp;
        }
       }
       if(trialEmailSetting.AdditionalCCEmailAddress__c !=null){
        additionalCc = trialEmailSetting.AdditionalCCEmailAddress__c;
        List<String> additionalCcListTmp = AppUtils.additionalSettingEmail(additionalCc);
        if (additionalCcListTmp != null) {
            additionalCcList = additionalCcListTmp;
        }
       }
       if(trialEmailSetting.AdditionalToEmailAddress__c !=null){
        additionalTo = trialEmailSetting.AdditionalToEmailAddress__c;
        List<String> additionalToListTmp = AppUtils.additionalSettingEmail(additionalTo);
        if (additionalToListTmp != null) {
            additionalToList = additionalToListTmp;
        }
       }
       if(trialEmailSetting.EmailTemplateName__c !=null){
        emailTemplateName = trialEmailSetting.EmailTemplateName__c;
       }
       if(trialEmailSetting.SenderEmailAddress__c !=null){
        senderEmailAddress = trialEmailSetting.SenderEmailAddress__c;
       }
        List<User> emailORMList = [SELECT Email FROM User WHERE AM_Role_Name__c = 'ORM'];
        List<String> ccEmailList = new List<String>();
        if(emailORMList.size()>0){
            for(User userRec: emailORMList){
                additionalCcList.add(userRec.Email);
            }
         //   additionalCcList.add('dikynurosid@gmail.com');
        }
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:senderEmailAddress];
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate WHERE name =: emailTemplateName];
        
        for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec : trialMonitoringTicketList){

            List<String> emailBccList= new List<String>();
            List<String> emailCcList = new List<String>();
            List<String> emailToList = new List<String>();

            emailToList.addAll(additionalToList);
            emailCcList.addAll(additionalCcList);
            emailBccList.addAll(additionalBccList);

            String emailProjectCoordinator = trialMonitoringTicketRec.PR_Rel__r.Project_Coordinator_Email__c;
           if(emailProjectCoordinator!=null){
            emailToList.add(emailProjectCoordinator);
            }
            //emailCcList.add(emailProjectCoordinator);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(trialMonitoringTicketRec.OwnerId); 
            String emailSales = trialMonitoringTicketRec.owner.email;
            emailToList.add(emailSales);
           system.debug('ccAdresses-->'+emailCcList);
           system.debug('toAdresses-->'+emailToList);
            
           // message.setOrgWideEmailAddressId(owea.get(0).Id);
            if(test.isRunningTest()){
                message.setOrgWideEmailAddressId('0D27F0000008R2pSAE');
            }
            else{
                
                message.setOrgWideEmailAddressId(owea.get(0).Id);
            }
         
            message.setCcAddresses(emailCcList);
            message.setUseSignature(false);
            if(emailBccList.size()>0){
                message.setBccAddresses(emailBccList);
                }else{
                    message.setBccSender(false); 
                }
            message.setSaveAsActivity(false); 
           
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(trialMonitoringTicketRec.Id); //This is important for the merge fields in template to work
            message.setToAddresses(emailToList);
            messages.add(message);
            //message.CcAddresses = new String [] {};
           // Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
           // Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        }
        //update 24 mei
        if(!test.isrunningtest()){
            List<Messaging.SendEmailResult> results = new List<Messaging.SendEmailResult> ();  List<Call_Log__c> callLogList = new List<Call_Log__c>();            
            results = Messaging.sendEmail(messages);   for(Messaging.SendEmailResult emailResultRec : results){ Call_Log__c CL=new Call_Log__c(); CL.Type__c='Email';   CL.Request_Start_Time__c=system.now(); CL.Response_End_Time__c=system.now(); CL.Response_Message__c='Success ='+emailResultRec.issuccess()+' Error:'+emailResultRec.geterrors(); callLogList.add(CL);           } insert callLogList;          
        }

        //Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        /*
        if (results[0].success) 
        {
        //moveTicketStageToImplementation(trialMonitoringTicketRec.Id);
        System.debug('The email was sent successfully to --> ' + additionalToList);
        } else {
        System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }*/
        
    } catch(Exception e) {
        string notes = 'Error on TrialMonitoringTicketServices.SendEmailConfirmationToSales method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber(); string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
    } 
}
//update by andre
//schedule_TrialMonitoringNotification
public void sendEmailNotificationToCustomer(List<Trial_Monitoring_Ticket__c> trialMonitoringTicketList){
    try {
        String additionalBcc = '';
        String additionalCc='';
        String additionalTo='';
        String emailTemplateName='';
        String senderEmailAddress='';

        List<String> additionalBccList= new List<String>();
        List<String> additionalCcList = new List<String>();
        List<String> additionalToList = new List<String>();
        TrialLinkConversionEmailSetting__c trialEmailSetting = TrialLinkConversionEmailSetting__c.getValues('Email Notification to Customer');
       if(trialEmailSetting.AdditionalBccEmailAddress__c !=null){
        additionalBcc = trialEmailSetting.AdditionalBccEmailAddress__c;
        List<String> additionalBccListTmp = AppUtils.additionalSettingEmail(additionalBcc);
        if (additionalBccListTmp != null) {
            additionalBccList = additionalBccListTmp;
        }
       }
       if(trialEmailSetting.AdditionalCCEmailAddress__c !=null){
        additionalCc = trialEmailSetting.AdditionalCCEmailAddress__c;
        List<String> additionalCcListTmp = AppUtils.additionalSettingEmail(additionalCc);
        if (additionalCcListTmp != null) {
            additionalCcList = additionalCcListTmp;
        }
       }
       if(trialEmailSetting.AdditionalToEmailAddress__c !=null){
        additionalTo = trialEmailSetting.AdditionalToEmailAddress__c;
        List<String> additionalToListTmp = AppUtils.additionalSettingEmail(additionalTo);
        if (additionalToListTmp != null) {
            additionalToList = additionalToListTmp;
        }
       }
       if(trialEmailSetting.EmailTemplateName__c !=null){
        emailTemplateName = trialEmailSetting.EmailTemplateName__c;
       }
       if(trialEmailSetting.SenderEmailAddress__c !=null){
        senderEmailAddress = trialEmailSetting.SenderEmailAddress__c;
       }

       Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
       OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:senderEmailAddress];
       EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate WHERE name =: emailTemplateName];

       Map<String, String> accountIdMap = new Map<String, String>();
       Map<String, String> OwnerIdMap = new Map<String, Id>();
                
       for (Trial_Monitoring_Ticket__c TMTOwner : TrialMonitoringTicketList) {
        OwnerIdMap.put('OwnerID',TMTOwner.id);
        accountIdMap.put('AccountID',TMTOwner.PR_Rel__r.Opportunity__r.AccountId);
       }
       Id OwnerId = (Id) OwnerIdMap.get('OwnerID');
       Id AccountId = (Id) OwnerIdMap.get('AccountID');
       List<User> emaiSalesAccountList = [SELECT Id, Email, Manager.Email FROM User WHERE Id =: OwnerId LIMIT 1]; 
     //  String AccountId = trialMonitoringTicketRec.PR_Rel__r.Opportunity__r.AccountId;
           
       List<AccountContactRelation> emailCustomerList = [SELECT ContactId, Contact_Email__c, AccountId, Roles FROM AccountContactRelation WHERE Roles INCLUDES ('PIC BA Recipient') AND AccountId =:AccountId];

        for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec : trialMonitoringTicketList){

            List<String> emailBccList= new List<String>();
            List<String> emailCcList = new List<String>();
            List<String> emailToList = new List<String>();

            emailToList.addAll(additionalToList);
            emailCcList.addAll(additionalCcList);
            emailBccList.addAll(additionalBccList);

            if(emailCustomerList!=null && !emailCustomerList.isEmpty()){
                for(AccountContactRelation emailCustomerRec : emailCustomerList){
                    if(emailCustomerRec.Contact_Email__c !=null){
                        emailToList.add(emailCustomerRec.Contact_Email__c);
                    }
                   
                }
            }
            String picBAPrint = trialMonitoringTicketRec.PR_Rel__r.Opportunity__r.PIC_BA_Print__r.email;
            if(picBAPrint != null && !emailCustomerList.isEmpty()){
                emailToList.add(picBAPrint);
            }
           
            if(emaiSalesAccountList.size()>0){
                String emailSales = emaiSalesAccountList[0].email;
                String emailManager = emaiSalesAccountList[0].Manager.email;
                if(emailSales != null && emailManager != null){
                    emailCcList.add(emailSales);
                    emailCcList.add(emailManager);
                }
                
            }
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(trialMonitoringTicketRec.OwnerId); 
            system.debug('ccAdresses-->'+emailCcList);
            system.debug('toAdresses-->'+emailToList);
           
            if(test.isRunningTest()){
                message.setOrgWideEmailAddressId('0D27F0000008R2pSAE');
            }
            else{
                
                message.setOrgWideEmailAddressId(owea.get(0).Id);
            }
         
            message.setCcAddresses(emailCcList);
            message.setUseSignature(false);
            if(emailBccList.size()>0){
                message.setBccAddresses(emailBccList);
                system.debug('BccAdresses-->'+emailBccList);
                }else{
                    message.setBccSender(false); 
                }
            message.setSaveAsActivity(false); 
           message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(trialMonitoringTicketRec.Id); //This is important for the merge fields in template to work
            message.setToAddresses(emailToList);
           // message.CcAddresses = new String [] {};
            messages.add(message);
            
            /*
            if (results[0].success) 
            {
            //moveTicketStageToImplementation(trialMonitoringTicketRec.Id);
            System.debug('The email was sent successfully to --> ' + emailToList);
            } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }*/
        }

        if(!test.isrunningtest()){
            List<Messaging.SendEmailResult> results = new List<Messaging.SendEmailResult> ();           
            List<Call_Log__c> callLogList = new List<Call_Log__c>();
            
            results = Messaging.sendEmail(messages);
            for(Messaging.SendEmailResult emailResultRec : results){ Call_Log__c CL=new Call_Log__c();
                //CL.Salesforce_ID_1__c=trialMonitoringTicketRec.Id;
                //CL.Salesforce_id_2__c=trialMonitoringTicketRec.Ownerid;
                CL.Type__c='Email';               CL.Request_Start_Time__c=system.now(); CL.Response_End_Time__c=system.now();               CL.Response_Message__c='Success ='+emailResultRec.issuccess()+' Error:'+emailResultRec.geterrors(); 
                callLogList.add(CL);                 }             insert callLogList;          }

        
        
    } catch(Exception e) {
        string notes = 'Error on TrialMonitoringTicketServices.SendEmailConfirmationToSales method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber(); string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
    }   



}


//updateFieldInLink
private static void updateFieldInLink(List<Trial_Monitoring_Ticket__c> trialMonitoringTicketList){
    string relatedSFIDs;
    list<Link__c> linkList = new List<Link__c>();
    
    try{
    for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec : trialMonitoringTicketList){

        Id linkConversionTicketId = trialMonitoringTicketRec.id;

        Link__c LinkRec=new Link__c();
        LinkRec.id = trialMonitoringTicketRec.link__c;
        LinkRec.Trial_Monitoring_Ticket_Rel__c = linkConversionTicketId;
        
        linkList.add(LinkRec);
        system.debug('==  ID LINK CONVERSION TICKET :' + linkConversionTicketId);
        
        }
        update linkList;
        system.debug('== LINK LIST UPDATE :' + linkList);
    }catch(Exception e){
        string notes = 'Error on TrialMonitoringTicketServices.updateFieldInLink method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();        string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
    }
}

//Create Opportunity Ketika LinkConvertionTicket Production
public static void createOpportunityForTrialToProduction(Id OpportunityID, Id lctID){
    string relatedSFIDs;
    try {
        relatedSFIDs = lctID;
        Opportunity oppObj = [SELECT Id, Pricebook2Id, AccountId,Name, Amount, Probability, CloseDate, SR__c, Account_Site_A__c, Account_Site_B__c, CID__c, Service_Type__c, Product_Count__c, Onetime_revenue__c, Recurring_Revenue__c, Account_Site_A_Location__c, Account_Site_B_Location__c, Site_Distance__c, Link_Related__c, Opportunity_ID__c, Expected_RFS_Date__c, Remark__c, Max_Discount__c, Using_Agreement_Pricing__c, BP_Payer__c, BP_VAT__c, BW_after__c, BW_before__c, COF_Number__c, Contract_Periode__c, PKS_Number__c, PR_Status__c, Periode_UOM__c, Project_Coordinator__c, Invoicing_Estimate_Date__c, Link_ID__c, Actual_Closed_Date__c, Auto_Renewal__c, trial__c, Contract_Ticket__c, PO_Date__c, PIC_BA_Print__c, Owner_Status__c, Contract_Ticket_Status__c, Auto_Renewal_Periode__c, Auto_Renewal_UOM__c, NPWP__c, Customer_VAT_Name__c, Tax_Address__c, Mark_as_Sales_Revenue__c, Mark_as_Add_Link_Sales_Revenue__c, Owner_is_Valid__c, Target_Close_Date_Quarter__c, Target_Close_Date_Year__c, Actual_Closed_Date_Year__c, Project_Coordinator_EmployeeID__c, Actual_Closed_Date_Quarter__c, Auto_Renewal_Formula__c, BA_Title_Formula__c, isTrialtoProduction__c FROM Opportunity WHERE Id =:OpportunityID];
        Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General').getRecordTypeId();
        List<OpportunityLineItem> oliItemList = new List<OpportunityLineItem>();
        Opportunity oppNewClone = new Opportunity();
        oppNewClone = oppObj;
        oppNewClone.id = null;
        oppNewClone.recordTypeId = RecordTypeOppId;
        oppNewClone.StageName = 'Prospecting';
        oppNewClone.Probability = 0;
        oppNewClone.trial__c = false;           
        oppNewClone.isTrialtoProduction__c = true;
        oppNewClone.Trial_Monitoring_Ticket_Rel__c = lctID;
        oppNewClone.Contract_Periode__c = null;
        oppNewClone.Periode_UOM__c = '';
        //update Andre 15/02/2022
        string OppNameClone = '[Production] ' +  oppObj.name;
        oppNewClone.name = OppNameClone;
        system.debug('oppNameClone =' + oppNameClone);
        //   oppNewClone.Link_Related__c = oppObj.Link_Related__c;
        system.debug('CLONE OPP-->'+oppObj);
        Database.SaveResult insertResults = Database.insert(oppObj);

        if (insertResults.isSuccess()) {
            
            String newOppId = insertResults.getId();
            system.debug('id OPP BARU---> ' + newOppId);
            
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();

            List<OpportunityLineItem> ProductList =[SELECT Actual_injection_Is_Null__c, AM_Employee_ID__c, AM_SFID__c, AO__c, AO_Priceplan__c, Bandwidth__c, Billing_Type__c, Bottom_Price__c, Capacity__c, Contract_Period__c, 
            Contract_Start_Date__c, Customer_SFID__c, Description, Distance_Km__c, FLAG__c, GH_SFID__c, Group_Service_Name__c, Group_Service_SFID__c, Group_Service_Type__c, Id, Injection_Item__c, is_Forecast_Revenue__c, ListPrice, Mark_as_Revenue_OppProduct__c, Mark_as_Revenue_Pipeline_OLD__c, Mark_as_Sales_Revenue__c, Name, NO__c, Note_From_Solution__c, Notes_From_Sales__c, Opportunity_ID__c, Opportunity_Product_ID__c, Opportunity_SFID__c, OpportunityId, Owner_is_Active__c, Owner_SFID__c, Percentage_Calculation__c, Period_UOM__c, Plan_QTY__c, Previous_Quantity__c, PricebookEntryId, Priceplan__c, Product_Name__c, Product2Id, ProductCode, QTY_Actual__c, QTY_Pipeline__c, QTY_Plan__c, Quantity, Quota__c, Recognize_as_Revenue__c, Recommended_Price__c, Request_QTY__c, Revenue_Type__c, Sales_Price_is_Valid__c, Sales_Revenue_Rel__c, ServiceDate, SM_SFID__c, SortOrder, Temp_Sales_Price__c, Total_Price_Actual__c, Total_price_Pipeline__c, Total_Price_Plan__c, Total_price_Request__c, TotalPrice, UnitPrice, UoM_Bandwidth__c, UoM_Quota__c FROM OpportunityLineItem WHERE OpportunityId =:OpportunityID];
                
            for(Opportunitylineitem productRec:ProductList){
                    Id productID =productRec.product2id;
                    system.debug('OLI OLD---> ' + productRec.product2id);
                    //List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE Product2Id=:productID LIMIT 1];
                    Opportunitylineitem NewItemClone = New Opportunitylineitem();//productRec.clone(false, true); //;// 
                    NewItemClone = productRec;
                    NewItemClone.id = null;
                    NewItemClone.opportunityId = newOppId;
                    NewItemClone.totalprice = null;
                    NewItemClone.unitPrice = productRec.ListPrice;
                    NewItemClone.Contract_Start_Date__c = null;
                    NewItemClone.Contract_End_Date__c = null;
                    oliItemList.add(NewItemClone);   
                        system.debug('OLI DATA---> ' + NewItemClone.unitPrice);
                }
            system.debug('OLI DATA---> ' + oliItemList);
            system.debug('OLI DATA unitPrice ---> ' + oliItemList[0].unitPrice);
            
            insert(oliItemList);
            Trial_Monitoring_Ticket__c lctObj = new Trial_Monitoring_Ticket__c();
            lctObj.id = lctID;
            lctObj.Opportunity_Creation_Rel__c = newOppId;
            update lctObj;
            sendEmailOpportunityProductionCreation(newOppId);
            shareTicketDocsToOpportunity(newOppId,lctID);
        
        }

    } catch (Exception e) {
        string notes = 'Error on TrialMonitoringTicketServices.createOpportunityForTrialToProduction method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();             string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
    }
}

public static void sendEmailOpportunityProductionCreation(Id newOppId){
    string relatedSFIDs = '';
    try {
        List<Trial_Monitoring_Ticket__c> trialMonitoringTicketList = [select Id, OwnerId, Owner.email, Opportunity_Creation_Rel__c,PR_Rel__r.Project_Coordinator_Email__c FROM Trial_Monitoring_Ticket__c WHERE Opportunity_Creation_Rel__c =:newOppId];
        for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec : trialMonitoringTicketList){
            String emailProjectCoordinator = trialMonitoringTicketRec.PR_Rel__r.Project_Coordinator_Email__c;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(trialMonitoringTicketRec.OwnerId); 
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='fixeditdelivery@xl.co.id'];     

            message.setOrgWideEmailAddressId(owea.get(0).Id);
            message.setUseSignature(false); 
            message.setBccSender(false);
            message.CcAddresses = new String[] {emailProjectCoordinator};
            message.setSaveAsActivity(false); 
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate WHERE name = 'Oppty Trial - Email when Opportunity created Prod'];
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(trialMonitoringTicketRec.Id); //This is important for the merge fields in template to work
            message.toAddresses = new String[] {trialMonitoringTicketRec.Owner.email};
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            //update 24 mei
            if(!test.isrunningtest()){
                Call_Log__c CL=new Call_Log__c(); CL.Salesforce_ID_1__c=trialMonitoringTicketRec.Id; CL.Salesforce_id_2__c=trialMonitoringTicketRec.Ownerid;                 CL.Type__c='Email';  CL.Request_Start_Time__c=system.now();  CL.Response_End_Time__c=system.now(); CL.Response_Message__c='Success ='+results[0].issuccess()+' Error:'+results[0].geterrors(); insert CL;            }
        }
        
    } catch(Exception e) {
        string notes = 'Error on TrialMonitoringTicketServices.sendEmailOpportunityProductionCreation method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber(); string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
    }
}
//moveTicketStageToImplementation
public void moveTicketStageToImplementation (list<Trial_Monitoring_Ticket__c> trialMonitoringTicketList){ 
    string relatedSFIDs;
    try{
        list<Trial_Monitoring_Ticket__c> TrialMonitoringTicketnewList = new list<Trial_Monitoring_Ticket__c>();
        for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec: trialMonitoringTicketList){            
            relatedSFIDs = trialMonitoringTicketRec.id;
            Trial_Monitoring_Ticket__c trialMonitoringTicket = new Trial_Monitoring_Ticket__c();
            trialMonitoringTicket.id = trialMonitoringTicketRec.id;
            trialMonitoringTicket.Link_Conversion_Ticket_Status__c = 'No Production';
            trialMonitoringTicket.Is_Confirmed__c = true;                
            trialMonitoringTicket.Link_Conversion_Ticket_Stage__c = 'Implementation';
            TrialMonitoringTicketnewList.add(trialMonitoringTicket);
        }
        update TrialMonitoringTicketnewList;
        sendEmailDismantleLinkNotification(trialMonitoringTicketList);
        system.debug('== UPDATE :' + TrialMonitoringTicketnewList);            
    }
    catch(Exception e){
        string notes = 'Error on TrialMonitoringTicketServices.moveTicketStageToImplementation method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
        
        string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
    }
}
//shareTicketDocsToOpportunity
public static void shareTicketDocsToOpportunity(Id opportunityId,Id tmtId){
    system.debug('=== shareTicketDocsToOpportunity ===');
    //versi 2
    List<ContentDocumentLink> contentDocumentLinkList = [   
        SELECT ContentDocumentId 
        FROM ContentDocumentLink 
        WHERE LinkedEntityId = : tmtId
    ];
    
    List<ContentDocumentLink> contentList = new List<ContentDocumentLink>();
    for(ContentDocumentLink contentDocumentLinkREC : contentDocumentLinkList){
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentLinkREC.ContentDocumentId;
        cdl.LinkedEntityId = opportunityId;
        cdl.ShareType = 'V';
        contentList.add(cdl);   
    }   
    insert contentList;
    system.debug('== contentList :' + contentList);
}

    
}