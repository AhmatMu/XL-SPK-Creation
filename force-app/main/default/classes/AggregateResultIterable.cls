/* ====================================================================================================
 * Class Name		        : AggregateResultIterable
 * Test Class		        : ProfitabilityHistoryActual_Week_Test
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

global class AggregateResultIterable implements Iterable<AggregateResult> {
    private String query;
    
    global AggregateResultIterable(String soql){
        query = soql;
    }
    
    global Iterator<AggregateResult> Iterator(){
        return new AggregateResultIterator(query);
    }
}