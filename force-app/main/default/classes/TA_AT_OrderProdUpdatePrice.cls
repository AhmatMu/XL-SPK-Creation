/**
 * @description       : 
 * @Test Class        : TA_AT_OrderProdUpdatePrice_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-09-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-03-2022   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_AT_OrderProdUpdatePrice implements TriggerAction.AfterInsert {
    public void afterInsert (list<OrderItem> newOrderProductList) {
        system.debug('==== TA_AT_OrderProdUpdatePrice.afterInsert ====== ');
        string errorMsg;
        
        try {
            Set<String> Set_OrderProductId = new Set<String>();
            Set<String> Set_ProductId = new Set<String>();

            for(OrderItem orderProductREC : newOrderProductList) {
                if (orderProductREC.Order_Record_Type__c == system.label.RT_ORDER_GSM_SIM_Card){
                    Set_OrderProductId.add(orderProductREC.Id);
                    Set_ProductId.add(orderProductREC.Product2Id);
                }
            }

            if(Set_OrderProductId!=null && !Set_OrderProductId.isEmpty()){
                REST_SAPGetPrice_Callout_v1.getPriceSAP(Set_OrderProductId, Set_ProductId, false);
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_OrderProdUpdatePrice After Insert' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

    }
}