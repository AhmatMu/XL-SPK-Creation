/* ====================================================================================================
 * Class Name		        : ProfitabilityHistory_Schedule_Month
 * Test Class		        : ProfitabilityHistory_Schedule_Test
 * Created By		        : Novando Utoyo Agmawan
 * Created Date		        : 06/2021
 * Created Description		: - 
 * 					          - 
 * Updated By               :
 * Updated Date	            :
 * Updated Description		: - 
 * 					          - 
 * ====================================================================================================
 */

global class ProfitabilityHistory_Schedule_Month implements Schedulable{

    global void execute(SchedulableContext sc)
    {
        Datetime scheduleRunDateTimes = system.now();

        ProfitabilityHistoryActual_Week_Batch ProfitabilityHistoryActual_Week_Batch_Class = new ProfitabilityHistoryActual_Week_Batch('Month',scheduleRunDateTimes);
        Database.executebatch(ProfitabilityHistoryActual_Week_Batch_Class);
    }
}