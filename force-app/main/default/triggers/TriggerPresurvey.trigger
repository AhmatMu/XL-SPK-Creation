/* ====================================================================================================
 * Class Name		        : TriggerPresurvey
 * Test Class		        : TestTriggerPresurvey
 * Created By		        : Kahfi Frimanda
 * Created Date		        : 03/2022
 * Created Description		: - 
 * 					          - 
 * Updated By               :
 * Updated Date	            :
 * Updated Description		: - 
 * 					          - 
 * ====================================================================================================
 */
trigger TriggerPresurvey on Presurvey__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    List<Trigger_Controller__c> TriggerController = [select Is_Active__c from Trigger_Controller__c where name = 'Trigger_Presurvey'];
    
    if(TriggerController!=null && !TriggerController.isEmpty()){
        if(TriggerController[0].Is_Active__c){
            TriggerDispatcher.Run(new PresurveyTriggerHandler());
        }
    }   
}