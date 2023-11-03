/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 22-09-2021
 * @last modified by  : Doddy Prima
**/
trigger SalesRevenueTrigger on Sales_Revenue__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {


    SYSTEM.DEBUG ('=== Trigger.isBefore : ' + Trigger.isBefore);
    SYSTEM.DEBUG ('=== Trigger.isAfter : ' + Trigger.isAfter);
    SYSTEM.DEBUG ('=== ');

    SYSTEM.DEBUG ('=== Trigger.isInsert : ' + Trigger.isInsert);
    SYSTEM.DEBUG ('=== Trigger.isUpdate : ' + Trigger.isUpdate);
    SYSTEM.DEBUG ('=== Trigger.isDelete : ' + Trigger.isDelete);
    SYSTEM.DEBUG ('=== Trigger.isUndelete : ' + Trigger.isUndelete);


    //Trigger_Controller__c tcRec = Trigger_Controller__c.getValues('SalesRevenueTrigger.beforeInsert');
    //SYSTEM.DEBUG ('=== tcRec.Is_Active__c : ' + tcRec.Is_Active__c);


    /* OLD WAY
    List<Trigger_Controller__c> triggerControllerList = [select name, Is_Active__c 
                                                        from Trigger_Controller__c 
                                                        where name like 'SalesRevenueTrigger%' ];
                                                        */

    List<Trigger_Controller__c> triggerControllerList = Trigger_Controller__c.getall().values();

    Map<string, boolean> isActiveTriggerMap = new Map<string, boolean> (); 
    for (Trigger_Controller__c  triggerCntr : triggerControllerList) {
        isActiveTriggerMap.put (triggerCntr.name, triggerCntr.Is_Active__c);
    }      

    system.debug ('== isActiveTriggerMap : ' + isActiveTriggerMap);
    system.debug ('== beforeInsert : ' + isActiveTriggerMap.get ('SalesRevenueTrigger.beforeInsert') );
                                             

    if( triggerControllerList.size() > 0 ){
        if ( isActiveTriggerMap.get ('SalesRevenueTrigger') <> null ) {
            if ( isActiveTriggerMap.get ('SalesRevenueTrigger') ) {
                SalesRevenueTriggerHandler handler = new SalesRevenueTriggerHandler(Trigger.isExecuting, Trigger.size);
                
                if(Trigger.isInsert && Trigger.isBefore && isActiveTriggerMap.get ('SalesRevenueTrigger.beforeInsert') ) {
                    handler.OnBeforeInsert(Trigger.new);  
                }
                else if(Trigger.isInsert && Trigger.isAfter && isActiveTriggerMap.get ('SalesRevenueTrigger.afterInsert')){
                    handler.OnAfterInsert(Trigger.new);
                // SalesRevenueTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
                }
                
                else if(Trigger.isUpdate && Trigger.isBefore  && isActiveTriggerMap.get ('SalesRevenueTrigger.beforeUpdate')){
                    handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                }
                else if(Trigger.isUpdate && Trigger.isAfter  && isActiveTriggerMap.get ('SalesRevenueTrigger.afterUpdate') ){
                    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                    //SalesAchievementTriggerHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
                }   
                
                else if(Trigger.isDelete && Trigger.isBefore  && isActiveTriggerMap.get ('SalesRevenueTrigger.beforeDelete')){
                    handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
                }
                else if(Trigger.isDelete && Trigger.isAfter  && isActiveTriggerMap.get ('SalesRevenueTrigger.afterDelete')){
                    handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
                    //SalesAchievementTriggerHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
                }
                
                else if(Trigger.isUnDelete  && isActiveTriggerMap.get ('SalesRevenueTrigger.undelete')){
                    handler.OnUndelete(Trigger.new);
                }
            }
        }
    }
}