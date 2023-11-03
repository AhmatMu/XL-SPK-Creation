trigger SalesTargetTrigger on Sales_Target__c (before insert, before update, before delete, after insert, after update, after delete, after undelete)  { 

    List<Trigger_Controller__c> triggerControllerList = [select name, Is_Active__c 
                                                        from Trigger_Controller__c 
                                                        where name like 'SalesTargetTrigger%' ];
    Map<string, boolean> isActiveTriggerMap = new Map<string, boolean> ();
    for (Trigger_Controller__c  triggerCntr : triggerControllerList) {
        isActiveTriggerMap.put (triggerCntr.name, triggerCntr.Is_Active__c);
    }


    if( triggerControllerList.size() > 0 ){
        if ( isActiveTriggerMap.get ('SalesTargetTrigger') <> null ) {
            if ( isActiveTriggerMap.get ('SalesTargetTrigger') ) {

                SalesTargetTriggerHandler handler = new SalesTargetTriggerHandler(Trigger.isExecuting, Trigger.size);
        
                if(Trigger.isInsert && Trigger.isBefore && isActiveTriggerMap.get ('SalesTargetTrigger.beforeInsert') ) {
                    handler.OnBeforeInsert(Trigger.new);
                //     SalesTargetTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
                }
                else if(Trigger.isInsert && Trigger.isAfter && isActiveTriggerMap.get ('SalesTargetTrigger.afterInsert') ) {
                    handler.OnAfterInsert(Trigger.new);
                    //SalesTargetTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
                }
                
                else if(Trigger.isUpdate && Trigger.isBefore && isActiveTriggerMap.get ('SalesTargetTrigger.beforeUpdate') ) {
                    handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                }
                else if(Trigger.isUpdate && Trigger.isAfter && isActiveTriggerMap.get ('SalesTargetTrigger.afterUpdate') ) {
                    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                    //SalesTargetTriggerHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
                }
                
                else if(Trigger.isDelete && Trigger.isBefore && isActiveTriggerMap.get ('SalesTargetTrigger.beforeDelete') ) {
                    handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
                }
                else if(Trigger.isDelete && Trigger.isAfter && isActiveTriggerMap.get ('SalesTargetTrigger.afterDelete') ) {
                    handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
                    //SalesTargetTriggerHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
                }
                
                else if(Trigger.isUnDelete && isActiveTriggerMap.get ('SalesTargetTrigger.undelete') ) {
                    handler.OnUndelete(Trigger.new);
                }


            }
 
        }
    }



}