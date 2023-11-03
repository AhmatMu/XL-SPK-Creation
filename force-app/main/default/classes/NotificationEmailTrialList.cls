/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-23-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class NotificationEmailTrialList{
    
    global List<Trial_Monitoring_Ticket__c> LinkConversionTicketList{get;set;}
    global String LinkID{get;set;}
    global String OwnerId{get;set;}
    global List<Trial_Monitoring_Ticket__c> posToDisplayList;
    global  NotificationEmailTrialList(){
    }
    
    global List<Trial_Monitoring_Ticket__c> LinkConversionTicket{
        get{
            posToDisplayList = new List<Trial_Monitoring_Ticket__c>();
            List<Trial_Monitoring_Ticket__c> LinkConversionTicketList = [SELECT Id,Link_Conversion_Ticket_Stage__c,link__r.Company_Name__c ,link__r.Link_ID__c,link__r.Trial_Service_Type__c,link__r.Trial_Start_Date__c,link__r.Trial_End_Date__c FROM Trial_Monitoring_Ticket__c WHERE OwnerID =: OwnerId];
             for(Trial_Monitoring_Ticket__c LinkConversionTicketRec:LinkConversionTicketList){
                 if(LinkConversionTicketRec.Link_Conversion_Ticket_Stage__c == 'Ready to Confirm'){
                    posToDisplayList.add(LinkConversionTicketRec);
                 }
            }
            return posToDisplayList;
        }
        set;
    }
    
    global String NewLine {
        get { return '\r\n'; }
        set;
    }
    
}