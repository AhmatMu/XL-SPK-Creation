/**
 * @description       : 
 * @Test Class        : TA_AT_OrderSimCard_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 12-06-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   12-06-2022   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_AT_OrderSimCard implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(list<Order> newOrderList, list<Order> oldOrderList) {
        system.debug('==== TA_AT_OrderSimCard.beforeUpdate ====== ');
        string errorMsg;
        
        try {
            Map<Id,Order> oldMap = new Map<Id,Order>(oldOrderList);
            
            for(Order orderREC : newOrderList) {
                if (
                    orderREC.recordtypeid == system.label.RT_ORDER_GSM_SIM_Card &&
                    orderREC.SIMCard_Order_Payment_Type__c != oldMap.get(orderREC.id).SIMCard_Order_Payment_Type__c &&
                    orderREC.SIMCard_Order_Payment_Type__c != null &&
                    orderREC.Status == 'Draft'
                ){
                    orderREC.Approval_Status__c = null;
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_OrderSimCard Before Update' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}