trigger Trigger_EDA on EDA__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    List<Trigger_Controller__c> TriggerController = [select Is_Active__c from Trigger_Controller__c where name = 'Trigger_EDA'];
    
    if(TriggerController!=null && !TriggerController.isEmpty()){
        if(TriggerController[0].Is_Active__c){
            TriggerDispatcher.Run(new Trigger_EDAHandler());
        }
    }
}