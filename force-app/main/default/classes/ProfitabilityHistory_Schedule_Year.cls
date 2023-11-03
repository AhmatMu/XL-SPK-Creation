/* ====================================================================================================
 * Class Name		        : ProfitabilityHistory_Schedule_Year
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

global class ProfitabilityHistory_Schedule_Year implements Schedulable{

    global void execute(SchedulableContext sc)
    {
        Datetime scheduleRunDateTimes = system.now();
        if(test.isrunningtest()){
            scheduleRunDateTimes = datetime.newInstanceGmt(2021, 12, 30);
        }
        Date dateValue = scheduleRunDateTimes.date();

        Integer monthValue = dateValue.month();

        if(monthValue == 12){
            ProfitabilityHistoryActual_Week_Batch ProfitabilityHistoryActual_Week_Batch_Class = new ProfitabilityHistoryActual_Week_Batch('Year',scheduleRunDateTimes);
            Database.executebatch(ProfitabilityHistoryActual_Week_Batch_Class);
        }
    }

}