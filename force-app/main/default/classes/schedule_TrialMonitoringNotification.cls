/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 03-01-2022
 * @last modified by  : ahmat.murad@saasten.com
 **/
global class schedule_TrialMonitoringNotification implements Schedulable {

     global void execute(SchedulableContext sc) {
 
         TrialMonitoringTicketServices trialLinkServicesObject = new TrialMonitoringTicketServices();
         system.debug(' == in schedule_TrialMonitoringNotification.trialLinkServicesObject =='+ trialLinkServicesObject);
         //Query BY Reminder Date
         List < Trial_Monitoring_Ticket__c > LinkConversionTicketList = [SELECT Id, Name, Trial_End_Date__c, Trial_Reminder_Date__c FROM Trial_Monitoring_Ticket__c WHERE Link_Conversion_Ticket_Stage__c != 'completed'
             AND PR_Rel__r.Trial__c = true AND Trial_Reminder_Date__c >= TODAY AND Trial_End_Date__c >= TODAY
         ];
         system.debug(' === LinkConversionTicketList :' + LinkConversionTicketList);

         List < Trial_Monitoring_Ticket__c > TrialMonitoringTicketList = [SELECT Id, OwnerId, PR_Rel__r.Opportunity__r.AccountId, Name, PR_Rel__r.Opportunity__r.PIC_BA_Print__r.email, Trial_End_Date__c, Trial_Reminder_Date__c FROM Trial_Monitoring_Ticket__c WHERE Link_Conversion_Ticket_Stage__c != 'completed'
             AND PR_Rel__r.Trial__c = true AND Trial_Reminder_Date__c = TODAY
         ];
         system.debug('== TrialMonitoringTicketList :' + TrialMonitoringTicketList);

         
         if (LinkConversionTicketList.size() != null || LinkConversionTicketList.size() > 0) {
             List < AggregateResult > UserRoleResult = [select Owner.UserRoleId roleID, Owner.UserRole.Name RoleName FROM Trial_Monitoring_Ticket__c GROUP BY Owner.UserRoleId, Owner.UserRole.Name];
             for (AggregateResult linkRec: UserRoleResult) {
                 id trialMonitoringTicketRoleId = (id) linkRec.get('roleID');
                 trialLinkServicesObject.sendTrialEmailNotificationSegments(trialMonitoringTicketRoleId);
             }
         }
         if (TrialMonitoringTicketList.size() != null || TrialMonitoringTicketList.size() > 0) {
             trialLinkServicesObject.sendEmailNotificationToCustomer(TrialMonitoringTicketList);
         }
 
     }
 
 }