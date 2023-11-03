trigger CollectionRateQuarterlyTrigger on Collection_Rate_Quarterly__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    /*List<Trigger_Controller__c> triggerControllerList = [select name, Is_Active__c 
                                                        from Trigger_Controller__c 
                                                        where name like 'CollectionRateQuarterlyTrigger%' ];*/
    /*
    List<Trigger_Controller__c> triggerControllerList = Trigger_Controller__c.getall().values();

    Map<string, boolean> isActiveTriggerMap = new Map<string, boolean> ();
    for (Trigger_Controller__c  triggerCntr : triggerControllerList) {
        isActiveTriggerMap.put (triggerCntr.name, triggerCntr.Is_Active__c);
    }      

    system.debug ('== isActiveTriggerMap : ' + isActiveTriggerMap);
    system.debug ('== beforeInsert : ' + isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger.beforeInsert') );
    */                                        

    //if( triggerControllerList.size() > 0 ){
    //    if ( isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger') <> null ) {
    //        if ( isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger') ) {
        CollectionRateQuarterlyTriggerHandler handler = new CollectionRateQuarterlyTriggerHandler(Trigger.isExecuting, Trigger.size);
                
        if(Trigger.isInsert && Trigger.isBefore ){ //&& isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger.beforeInsert') ) {
            handler.OnBeforeInsert(Trigger.new);  
        }
        else if(Trigger.isInsert && Trigger.isAfter ){ //&& isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger.afterInsert')){
            handler.OnAfterInsert(Trigger.new);
        // CollectionRateQuarterlyTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
        }
        
        else if(Trigger.isUpdate && Trigger.isBefore  ){ //&& isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger.beforeUpdate')){
            handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
        else if(Trigger.isUpdate && Trigger.isAfter  ){ //&& isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger.afterUpdate') ){
            handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            //CollectionRateQuarterlyTriggerHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
        }   
        
        else if(Trigger.isDelete && Trigger.isBefore  ){ //&& isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger.beforeDelete')){
            handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        }
        else if(Trigger.isDelete && Trigger.isAfter  ){ //&& isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger.afterDelete')){
            handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
            //CollectionRateQuarterlyTriggerHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
        }
        
        else if(Trigger.isUnDelete  ){ //&& isActiveTriggerMap.get ('CollectionRateQuarterlyTrigger.undelete')){
            handler.OnUndelete(Trigger.new);
        }
    //}
//}
//}

}