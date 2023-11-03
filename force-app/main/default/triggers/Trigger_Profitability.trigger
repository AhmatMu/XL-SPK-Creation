/* ====================================================================================================
 * Class Name		        : Trigger_Profitability
 * Test Class		        : Trigger_ProfitabilityHandler_Test
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

trigger Trigger_Profitability on Profitability__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    List<Trigger_Controller__c> TriggerController = [select Is_Active__c from Trigger_Controller__c where name = 'Trigger_Profitability'];

    if(TriggerController!=null && !TriggerController.isEmpty()){
        if(TriggerController[0].Is_Active__c){
            TriggerDispatcher.Run(new Trigger_ProfitabilityHandler());
        }
    }
}