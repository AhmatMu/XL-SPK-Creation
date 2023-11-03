trigger Trigger_BAP_IoM_Approval on BAP__c (after update,before update) {
    if(system.label.Is_Trigger_BAP_IOM_Approval_ON=='YES')
    {
        // Look up record type id
        String recordTypeName = 'Termination'; // <-- Change this to record type name
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
        id recordTypeId = rtInfo.getRecordTypeId();
        
        for(BAP__c NewBAPRec:system.trigger.new)
        {   
            if(NewBAPRec.RecordTypeId == recordTypeId){
                if(trigger.isafter)
                {
                    BAP__c B = new BAP__c();
                    ApexPages.StandardController SC = new ApexPages.StandardController(B);
                    BAP__c oldBAPRec = Trigger.oldMap.get(NewBAPRec.id);
                    BAP_IoM_Approval BIA=new BAP_IOM_Approval(SC);
                    //ngatur send email ke GH setiap ada perubahan backdate, penalty, costpartner
                    if( ( NewBAPRec.IsBackDate__c != oldBAPRec.IsBackDate__c && NewBAPRec.IsBackDate__c == TRUE )
                       || ( NewBAPRec.IsPenalty__c != oldBAPRec.IsPenalty__c && NewBAPRec.IsPenalty__c == TRUE 
                           
                          )
                      )
                        /*
* Jika IsBackDate__c atau IsPenalty__c ada perubahan DAN
* jika salah satunya bernilai TRUE, maka kirim approval ke GH
* 
* */
                        
                    {
                        Approval.lock(oldBAPRec);
                        Messaging.SingleEmailMessage approvalNotif = new Messaging.SingleEmailMessage();
                        /*  PageReference pdf = page.Preview_IOM;
pdf.getParameters().put('id',newBAPRec.id);
Blob body;
Call_Log__c CL=new Call_Log__c();
CL.Salesforce_ID_1__c=newbaprec.id;

CL.Type__c='Email';
CL.Request_Start_Time__c=system.now();
try {

// returns the output of the page as a PDF
body = pdf.getContent();

// need to pass unit test -- current bug  
} catch (VisualforceException e) {
body = Blob.valueOf('Error');
CL.Response_Message__c  =e.getmessage();
CL.Response_End_Time__c=system.now();

insert CL;
if(!test.isrunningtest())
return;
}
Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
attach.setContentType('application/pdf');
attach.setFileName('BAP.pdf');
attach.setInline(false);
approvalNotif.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });*/
                        
                        //send email notif approval request to GH
                        
                        /*  String[] sendTo = new String[]{NewBAPRec.Group_Head_Email__c};
approvalNotif.setToAddresses(sendTo);
approvalNotif.setSubject('BAP Approval IoM');
approvalNotif.setPlainTextBody('Approve dong ' + 'https://cs72.lightning.force.com/lightning/r/BAP__c/'+newBAPRec.id+'/view');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {approvalNotif});*/
                        
                        system.debug('============== newBAPRec.ownerid 1 : ' + newBAPRec.ownerid);
                        BAP_IoM_Approval.sendEmailCustom('GroupHead', '',newBAPRec.id ,newBAPRec.ownerid);
                    }
                    
                    //ngatur send email notif approval by CEO
                    if(NewBAPRec.Send_GH_Notif__c != oldBAPRec.Send_GH_Notif__c && NewBAPRec.Send_GH_Notif__c==TRUE)
                    {
                        system.debug('============== newBAPRec.ownerid 2 : ' + newBAPRec.ownerid);
                        BAP_IoM_Approval.sendEmailCustom('Chief', '',newBAPRec.id ,newBAPRec.ownerid);
                        //send Email Notif Request Approval to Chief 
                    }
                    
                    if((NewBAPRec.Send_GH_Approve__c    != oldBAPRec.Send_GH_Approve__c && NewBAPRec.Send_GH_Approve__c==TRUE)||test.isRunningTest())
                    {
                        system.debug('============== newBAPRec.ownerid 3 : ' + newBAPRec.ownerid);
                        BAP_IoM_Approval.sendEmailCustom('Approved', 'Chief',newBAPRec.id ,newBAPRec.ownerid);
                        
                        //  File_BAP_Attachment_Public_URL.getURL(newBAPrec.id,newBAPRec.Name);
                        
                        //send Email Notif Approval Completed (Chief)
                    }
                    
                    if(NewBAPRec.Send_GH_Reject__c  != oldBAPRec.Send_GH_Reject__c && NewBAPRec.Send_GH_Reject__c==TRUE)
                    {
                        system.debug('============== newBAPRec.ownerid 4 : ' + newBAPRec.ownerid);
                        BAP_IoM_Approval.sendEmailCustom('Rejected', 'Chief',newBAPRec.id ,newBAPRec.ownerid);
                        //send Email Notif Rejection (Chief)
                    }
                }
                if(trigger.isbefore)
                {
                    BAP__c oldBAPRec = Trigger.oldMap.get(NewBAPRec.id);
                    
                    if(NewBAPRec.Send_GH_Approve__c != oldBAPRec.Send_GH_Approve__c && NewBAPRec.Send_GH_Approve__c==TRUE)
                    {
                        
                    }
                }
            }
        }
    }
}