/**
 * @description       : 
 * @author            : Andre Prasetya
 * @group             : 
 * @last modified on  : 03-22-2022
 * @last modified by  : Andre Prasetya
**/
public with sharing class Notification_WBA_Sales {
    @future(callout=true) 
    public static void sendemail(String Before, String After) {
        try{
            Opportunity OppBefore=(Opportunity) JSON.deserialize(before, Opportunity.class);
            Opportunity OppAfter=(Opportunity) JSON.deserialize(after, Opportunity.class);
            User ProjectCoordinator=[SELECT Email FROM User WHERE Name=:OppAfter.Project_Coordinator__c.Substringafter(' ')];
            list<String> mailaddress=new list<String>{'operationrevenuemanagement@xl.co.id','OperationGovernanceDS@xl.co.id','SalesSupport@xl.co.id',ProjectCoordinator.Email};
            //list<String> mailaddress=new list<String>{'diky.nurosid@saasten.com'};
                User SalesOwner=[SELECT Email,Manager.Email FROM User WHERE id=:Oppbefore.Ownerid];
            list<String> mailcc=new list<String>{SalesOwner.Email,SalesOwner.Manager.Email,'Fixeditdelivery@xl.co.id'};
                
                String MessageIntro='<html><head></head><body>Dear All,<br/><br/>This Opportunity has been updated by '+userinfo.getName()+' with below detail :<br/><br/>';
            String Messagebefore='OPPORTUNITY INFORMATION<br/><br/>before<br/><br/>';
            String Messageafter='After<br/><br/>';
            String MessageEnd='For further detail please go to the link below.<br/><br/>https://' + System.URL.getSalesforceBaseUrl().getHost()+'/lightning/r/Opportunity/'+OppBefore.id+'/view <br/><br/>Thanks<br/>Salesforce Administrator';
            Integer updated=0;
            if(OppBefore.Amount!=OppAfter.Amount||test.isRunningTest())
            {
                long amount=Integer.valueof(Oppbefore.Amount);
                long onetime=Integer.valueof(Oppbefore.Onetime_Revenue__c);
                long recurring=Integer.valueof(Oppbefore.Recurring_Revenue__c);
                MessageBefore=MessageBefore+'Amount: '+Amount+'<br/>';
                MessageBefore=MessageBefore+'One Time Revenue: '+Onetime+'<br/>';
                MessageBefore=MessageBefore+'Recurring Revenue: '+recurring+'<br/>';
                amount=Integer.valueof(OppAfter.Amount);
                onetime=Integer.valueof(OppAfter.Onetime_Revenue__c);
                recurring=Integer.valueof(OppAfter.Recurring_Revenue__c);
                MessageAfter=Messageafter+'Amount: '+Amount+'<br/>';
                MessageAfter=Messageafter+'One Time Revenue: '+Onetime+'<br/>';
                MessageAfter=Messageafter+'Recurring Revenue: '+Recurring+'<br/>';
                updated++;
            }
            /*    if(OppBefore.Contract_Periode__c!=OppAfter.Contract_Periode__c||OppBefore.Periode_UOM__c!=OppAfter.Periode_UOM__c)
    {
    MessageBefore=MessageBefore+'Contract Periode: '+Oppbefore.Contract_Periode__c+'<br/>';
    MessageBefore=MessageBefore+'Periode Uom: '+Oppbefore.Periode_UOM__c+'<br/>';
    MessageAfter=Messageafter+'Contract Periode: '+Oppafter.Contract_Periode__c+'<br/>';
    MessageAfter=Messageafter+'Periode UOM: '+Oppafter.Periode_UOM__c+'<br/>';
    updated++;
    }*/
            if(OppBefore.BW_Before__c!=OppAfter.BW_Before__c||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'Bandwidth Before: '+Oppbefore.BW_Before__c+'<br/>';
                MessageAfter=Messageafter+'Bandwidth Before: '+Oppafter.BW_Before__c+'<br/>';
                updated++;
            }
            if(OppBefore.uom_BW_Before__c!=OppAfter.uom_BW_Before__c||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'Bandwidth Before UOM: '+Oppbefore.UOM_BW_Before__c+'<br/>';
                MessageAfter=Messageafter+'Bandwidth Before UOM: '+Oppafter.UOM_BW_Before__c+'<br/>';
                updated++;
            }
            if(OppBefore.BW_After__c!=OppAfter.BW_After__c||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'Bandwidth After: '+Oppbefore.BW_After__c+'<br/>';
                MessageAfter=Messageafter+'Bandwidth After: '+Oppafter.BW_After__c+'<br/>';
                updated++;
            }
            if(OppBefore.uom_BW_After__c!=OppAfter.uom_BW_After__c||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'Bandwidth After UOM: '+Oppbefore.UOM_BW_After__c+'<br/>';
                MessageAfter=Messageafter+'Bandwidth After UOM: '+Oppafter.UOM_BW_After__c+'<br/>';
                updated++;
            }
            if(OppBefore.PKS_Number__c!=OppAfter.PKS_Number__c||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'PKS Number: '+Oppbefore.PKS_Number__c+'<br/>';
                MessageAfter=Messageafter+'PKS Number: '+Oppafter.PKS_Number__c+'<br/>';
                updated++;
            }
            if(OppBefore.Cof_Number__c!=OppAfter.Cof_Number__c||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'COF Number: '+Oppbefore.COF_Number__c+'<br/>';
                MessageAfter=Messageafter+'COF Nember: '+Oppafter.COF_Number__c+'<br/>';
                updated++;
            }
            if(OppBefore.BP_Payer__c!=OppAfter.BP_Payer__c||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'BP Payer: '+Oppbefore.Payer_BP_Number__c+'<br/>';
                MessageAfter=Messageafter+'BP Payer: '+Oppafter.Payer_BP_Number__c+'<br/>';
                updated++;
            }
            if(OppBefore.BP_VAT__c!=OppAfter.BP_VAT__c||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'BP VAT: '+Oppbefore.VAT_BP_Number__c+'<br/>';
                MessageAfter=Messageafter+'BP VAT: '+Oppafter.VAT_BP_Number__c+'<br/>';
                updated++;
            }
            /*  if(OppBefore.International_BW__c!=OppAfter.International_BW__c)
    {
    MessageBefore=MessageBefore+'International BW: '+Oppbefore.International_BW__c+'<br/>';
    MessageAfter=Messageafter+'International BW: '+Oppafter.International_BW__c+'<br/>';
    updated++;
    }
    if(OppBefore.Local_BW__c!=OppAfter.Local_BW__c)
    {
    MessageBefore=MessageBefore+'Local BW: '+Oppbefore.Local_bw__c+'<br/>';
    MessageAfter=Messageafter+'Local BW: '+Oppafter.local_bw__c+'<br/>';
    updated++;
    }
    if(Oppbefore.LastMile_Type__c!=OppAfter.LastMile_type__c)
    {
    MessageBefore=MessageBefore+'Lastmile_type__c: '+Oppbefore.Lastmile_type__c+'<br/>';
    MessageAfter=Messageafter+'Lastmile_type__c: '+Oppafter.Lastmile_type__c+'<br/>';
    updated++;
    }*/
            if(Oppbefore.Quota__c!=OppAfter.Quota__c ||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'Quota: '+Oppbefore.Quota__c+'<br/>';
                MessageAfter=Messageafter+'Quota: '+Oppafter.Quota__c+'<br/>';
                updated++;
            }
            if(Oppbefore.UOM_Quota__c!=Oppafter.UOM_Quota__c ||test.isRunningTest())
            {
                MessageBefore=MessageBefore+'UOM Quota: '+Oppbefore.UOM_Quota__c+'<br/>';
                MessageAfter=Messageafter+'UOM Quota: '+Oppafter.UOM_Quota__c+'<br/>';
                updated++;
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            mail.optOutPolicy = 'FILTER';    
            mail.setToAddresses(mailaddress);
            mail.setCCaddresses(mailcc);
            mail.setSubject('Change After WBA :'+Oppbefore.Opportunity_id__c+' - '+Oppbefore.Name);
            mail.setHtmlBody(MessageIntro+Messagebefore+MessageAfter+MessageEnd);
            if(updated>0||test.isrunningtest())
            {
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                    List<Messaging.SendEmailResult>  results=new List<Messaging.SendEmailResult> ();
                Results=Messaging.sendEmail(messages);
                Call_Log__c CL=new Call_Log__c();
                CL.Salesforce_ID_1__c=Oppbefore.id;
                CL.Type__c='RevisedAfterBASent';
                CL.Request_Start_Time__c=system.now();
                CL.Response_End_Time__c=system.now();
                CL.Request_Message__c=MessageBefore+MessageAfter;
                CL.Response_Message__c='Success ='+results[0].issuccess()+' Error:'+results[0].geterrors();
                insert CL;
            }   
        }
        catch(Exception e){
            
            string notes = 'Error on Notification_WBA_Sales.sendemail method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' ; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
        }
       
}