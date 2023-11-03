/**
 * @description       : 
 * @Test Class		  : SRcompleted_MoreThan60days_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-05-2021
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-30-2021   Novando Utoyo Agmawan   Initial Version
**/

global class SRcompleted_MoreThan60days_Schedule implements Schedulable{
    global void execute (SchedulableContext sc) {
        SRcompleted_MoreThan60days_Batch SRcompleted_MoreThan60days_Batch_Class = new SRcompleted_MoreThan60days_Batch();
        ID batchprocessid = database.executeBatch(SRcompleted_MoreThan60days_Batch_Class,20);
    }
}