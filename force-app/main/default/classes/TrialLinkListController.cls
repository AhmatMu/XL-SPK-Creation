/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 02-21-2022
 * @last modified by  : Diky Nurosid
**/
global with sharing class TrialLinkListController{
    
  //  global List<Trial_Monitoring_Ticket__c> LinkConversionTicketList{get;set;}
    global String LinkID{get;set;}
    global String RoleId{get;set;}
    global String OwnerId{get;set;}
    global List<Trial_Monitoring_Ticket__c> posToDisplayList;
    global List<Opportunity> tableOpportunityList;
    global  TrialLinkListController(){
    }
    
    global List<Trial_Monitoring_Ticket__c> LinkConversionTicket{
        get{
            posToDisplayList = new List<Trial_Monitoring_Ticket__c>();
          
          List<Trial_Monitoring_Ticket__c> trialMonitoringTicketList = [SELECT Id,link__r.Company_Name__c ,Link_Conversion_Ticket_Status__c,link__r.Link_ID__c,link__r.Trial_Service_Type__c,link__r.Trial_Start_Date__c,link__r.Trial_End_Date__c FROM Trial_Monitoring_Ticket__c WHERE  Owner.UserRoleId =: RoleId AND Link_Conversion_Ticket_Stage__c = 'On Going Trial'];
          for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec:trialMonitoringTicketList){
                   posToDisplayList.add(trialMonitoringTicketRec);
           }
            return posToDisplayList;
        }
        set;
    }
//Tabel pada email oppty yang belum completed when end trial > today
    global List<Opportunity> opportunityNotComplete{
        get{tableOpportunityList = new List<Opportunity>();List<Opportunity> OpportunityList = [select id, name, PR_Rel__r.Name,PR_Rel__c, trial_monitoring_ticket_rel__r.Trial_End_Date__c,trial_monitoring_ticket_rel__c,StageName, Link_Related__r.name, Link_Related__r.Link_id__c, trial_monitoring_ticket_rel__r.name, opportunity_ID__c FROM Opportunity WHERE isTrialtoProduction__c = true and PR_Rel__c != null and PR_Rel__r.status__c != 'completed' AND StageName != 'Closed Lost' AND trial_monitoring_ticket_rel__r.Trial_End_Date__c < today AND OwnerId =:OwnerId];for(Opportunity OpportunityRec:OpportunityList){tableOpportunityList.add(OpportunityRec);}return tableOpportunityList;}
        set;
    }
    global String NewLine {
        get { return '\r\n'; }
        set;
    }
    
}