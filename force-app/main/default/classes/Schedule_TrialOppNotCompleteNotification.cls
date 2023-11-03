/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 02-17-2022
 * @last modified by  : Diky Nurosid
**/
global class Schedule_TrialOppNotCompleteNotification {
    global void execute(SchedulableContext sc) {
        TrialMonitoringTicketServices trialLinkServicesObject = new TrialMonitoringTicketServices();
        List<AggregateResult> OwnerResults = [SELECT OwnerId Owner, Owner.UserRole.Name RoleName, Owner.Email Email FROM Opportunity WHERE isTrialtoProduction__c = true and PR_Rel__c != null and PR_Rel__r.status__c != 'completed' AND StageName != 'Closed Lost' AND trial_monitoring_ticket_rel__r.Trial_End_Date__c < today GROUP BY OwnerId, Owner.UserRole.Name,Owner.Email];
            if(OwnerResults.size()>0){
                for(AggregateResult OpptyRec : OwnerResults){
                    id OwnerId = (id) OpptyRec.get('Owner');
                    String Email = (String) OpptyRec.get('Email');
                    trialLinkServicesObject.sendEmailWhenTrialisExpired(OwnerId,Email);
               }
            }
    }
}