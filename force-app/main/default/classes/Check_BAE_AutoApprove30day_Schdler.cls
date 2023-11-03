/**
 * @description       : 
 * @Test Class        : Check_BAE_AutoApprove30day_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-25-2023   Novando Utoyo Agmawan   Initial Version
**/

global class Check_BAE_AutoApprove30day_Schdler implements Schedulable {
    global void execute (SchedulableContext sc) {
        Check_BAE_AutoApprove30day_Batch class_Check_BAE_AutoApprove30day_Batch = new Check_BAE_AutoApprove30day_Batch();
        ID batchprocessid = database.executeBatch(class_Check_BAE_AutoApprove30day_Batch,10);
    }
}