global with sharing class Schedule_Notif_Contract_Extension implements Schedulable {
  
    global void execute (SchedulableContext sc) {
        Batch_Notif_NEW_Contract_Extension bacthEmail = new Batch_Notif_NEW_Contract_Extension();
        ID batchprocessid = database.executeBatch(bacthEmail,20);
    }

}