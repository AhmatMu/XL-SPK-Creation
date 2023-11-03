/* ====================================================================================================
* Class Name		        : Upsert_Profitability_GSM_Actual_Schedule
* Test Class		        : Upsert_Profitability_GSM_Actual_Test
* Created By		        : Novando Utoyo Agmawan
* Created Date		        : 08/2021
* Created Description		: - 
* 					          - 
* Updated By               :
* Updated Date	            :
* Updated Description		: - 
* 					          - 
* ====================================================================================================
*/

global class Upsert_Profitability_GSM_Actual_Schedule implements Schedulable{
    
    global void execute(SchedulableContext sc)
    {
        Date scheduleRunDateTimes = system.Today();

        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtInfo_Gsm =  rtMapByName.get('GSM');
        Id recordTypeId_Gsm = rtInfo_Gsm.getRecordTypeId();

        List<Profitability__c> Profitability_GsmActual_List = [
            SELECT Id
            FROM Profitability__c
            WHERE Status__c =: 'Actual' AND
            recordTypeId =: recordTypeId_Gsm
        ];

        Boolean deleteComplete = false;

        if(Profitability_GsmActual_List!=null && !Profitability_GsmActual_List.isEmpty()){
            Database.DeleteResult[] deleteResult_Profitability_GsmActual_List = Database.delete(Profitability_GsmActual_List, true);

            for (Database.DeleteResult result: deleteResult_Profitability_GsmActual_List){
                if (result.isSuccess())
                {
                    deleteComplete = true;
                }
            }

            if(deleteComplete){
                Upsert_Profitability_GSM_Actual_Batch Upsert_Profitability_GSM_Actual_Batch_Class = new Upsert_Profitability_GSM_Actual_Batch(scheduleRunDateTimes);
                Database.executebatch(Upsert_Profitability_GSM_Actual_Batch_Class);
            }
        }else{
            Upsert_Profitability_GSM_Actual_Batch Upsert_Profitability_GSM_Actual_Batch_Class = new Upsert_Profitability_GSM_Actual_Batch(scheduleRunDateTimes);
            Database.executebatch(Upsert_Profitability_GSM_Actual_Batch_Class);
        }
    }
}