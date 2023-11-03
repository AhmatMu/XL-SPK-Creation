trigger SincSalesPersonSettingTrigger on SInc_Sales_Person_Setting__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    List <Trigger_Controller__c> triggerControllerList = Trigger_Controller__c.getall().values();
  
    Map < string, boolean > isActiveTriggerMap = new Map < string, boolean > ();
    for (Trigger_Controller__c triggerCntr: triggerControllerList) {
      isActiveTriggerMap.put(triggerCntr.name, triggerCntr.Is_Active__c);
    }
  
    system.debug('== isActiveTriggerMap : ' + isActiveTriggerMap);
    system.debug('== beforeInsert : ' + isActiveTriggerMap.get('SincSalesPersonSetting.beforeInsert'));
    system.debug('== after insert : ' +  isActiveTriggerMap.get('SincSalesPersonSetting.afterInsert'));
  
    if (triggerControllerList.size() > 0) {
        system.debug('in line 15');
          SincSalesPersonSettingTriggerHandler handler = new SincSalesPersonSettingTriggerHandler(Trigger.isExecuting, Trigger.size);  
          if (Trigger.isInsert && Trigger.isBefore && isActiveTriggerMap.get('SincSalesPersonSetting.beforeInsert')) {
            handler.OnBeforeInsert(Trigger.new);
          } else if (Trigger.isInsert && Trigger.isAfter && isActiveTriggerMap.get('SincSalesPersonSetting.afterInsert')) {
            handler.OnAfterInsert(Trigger.new);
            // SincSalesPersonSetting.OnAfterInsertAsync(Trigger.newMap.keySet());
          }
        }
      }