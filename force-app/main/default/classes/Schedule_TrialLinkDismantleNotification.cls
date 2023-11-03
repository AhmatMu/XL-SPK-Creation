/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Diky Nurosid
**/
global class Schedule_TrialLinkDismantleNotification implements Schedulable{

global void execute(SchedulableContext sc) {
    //Notification if h-1 move to implementation sendEmail to Project coordinator
    TrialMonitoringTicketServices trialLinkServicesObject = new TrialMonitoringTicketServices();
    List<Trial_Monitoring_Ticket__c> TMTListMoveImplementation = [SELECT Id ,OwnerId, Trial_Reminder_Date_Project_Coordinator__c, PR_Rel__r.Project_Coordinator_Email__c, Trial_Reminder_Date_Move_Implementation__c  FROM Trial_Monitoring_Ticket__c WHERE Link_Conversion_Ticket_Stage__c = 'On Going Trial' AND Link_Conversion_Ticket_Status__c = 'Waiting Customer Confirmation' AND Trial_Reminder_Date_Move_Implementation__c = TODAY];
    if(TMTListMoveImplementation.size() != null || TMTListMoveImplementation.size()> 0){
                trialLinkServicesObject.moveTicketStageToImplementation(TMTListMoveImplementation);            
    }
}
}