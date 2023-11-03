global with sharing class Schedule_Notif_TerminationNonAutoRenewal implements Schedulable {
  
    global void execute (SchedulableContext sc) {
        Batch_Notif_TerminationNonAutoRenewal bacthEmail = new Batch_Notif_TerminationNonAutoRenewal();
        ID batchprocessid = database.executeBatch(bacthEmail,50);
    }

}