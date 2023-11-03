/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-21-2022
 * @last modified by  : Diky Nurosid
**/
global class Schedule_TrialLinkNotification implements Schedulable{

	global void execute(SchedulableContext sc) {
          TrialMonitoringTicketServices trialLinkServicesObject = new TrialMonitoringTicketServices();
          //Query BY Reminder Date
          List <Trial_Monitoring_Ticket__c> LinkConversionTicketList = [SELECT Id, Name, Trial_End_Date__c, Trial_Reminder_Date__c FROM Trial_Monitoring_Ticket__c WHERE Link_Conversion_Ticket_Stage__c !='completed' AND PR_Rel__r.Trial__c = true AND Trial_Reminder_Date__c >= TODAY];
          if(LinkConversionTicketList.size() != null || LinkConversionTicketList.size()> 0){
               List<AggregateResult> UserRoleResult = [select Owner.UserRoleId roleID, Owner.UserRole.Name RoleName FROM Trial_Monitoring_Ticket__c GROUP BY Owner.UserRoleId, Owner.UserRole.Name];
               for(AggregateResult linkRec : UserRoleResult){
                    id linkConversionTicketRoleId = (id) linkRec.get('roleID');
                    trialLinkServicesObject.sendTrialEmailNotificationSegments(linkConversionTicketRoleId);
               }
          }
          
         
         
     }
     
}