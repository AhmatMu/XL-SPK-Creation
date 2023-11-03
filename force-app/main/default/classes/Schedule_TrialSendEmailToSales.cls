/**
 * @description       : 
 * @author            : Andre Prasetya
 * @group             : 
 * @last modified on  : 02-16-2022
 * @last modified by  : Diky Nurosid
**/

global class Schedule_TrialSendEmailToSales implements Schedulable{
    global void execute(SchedulableContext sc) {
    TrialLinkConversionGENERALSetting__c  trialLinkGeneralSetting = TrialLinkConversionGENERALSetting__c.getOrgDefaults();
        
        double reminderTosales = trialLinkGeneralSetting.Days_need_confirmation_to_Sales__c;

        integer numberOfReminderToSales = integer.valueOf(reminderTosales);
        TrialMonitoringTicketServices trialobj = new TrialMonitoringTicketServices();
        String queryString = 'SELECT id, name, PR_Rel__r.Project_Coordinator_Email__c, owner.email FROM Trial_Monitoring_Ticket__c WHERE Link_Conversion_Ticket_Stage__c=\'On Going Trial\'AND Link_Conversion_Ticket_Status__c = \'Waiting Customer Confirmation\' AND Trial_End_Date__c = NEXT_N_DAYS:'+numberOfReminderToSales;
        List<Trial_Monitoring_Ticket__c> TrialMonitoringTicketList = Database.query(queryString);
      
    trialobj.sendEmailConfirmationToSales(TrialMonitoringTicketList);
    }
}