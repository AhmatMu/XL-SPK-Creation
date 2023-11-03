trigger Trigger_ContentVersion on ContentVersion (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    List<Trigger_Controller__c> TriggerController = [select Is_Active__c from Trigger_Controller__c where name = 'Trigger_ContentVersion'];

    if(TriggerController!=null && !TriggerController.isEmpty()){
        if(TriggerController[0].Is_Active__c){
            TriggerDispatcher.Run(new Trigger_ContentVersionHandler());
        }
    }
}