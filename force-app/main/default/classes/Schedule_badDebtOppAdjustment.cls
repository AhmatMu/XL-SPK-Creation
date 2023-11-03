global with sharing class Schedule_badDebtOppAdjustment implements Schedulable {
    public static string errorMsg ='';

    global void execute (SchedulableContext sc){

        // call OpportunityService.badDebtOppAdjustment()
        OpportunityService.badDebtOppAdjustment();
        
    }
}