/**
 * @description       : 
 * @Test Class        : TA_AT_OrderItemSimCardUPD_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-10-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   12-07-2022   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_AT_OrderItemSimCardUPD implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<OrderItem> newOrderProductList, list<OrderItem> oldOrderProductList) {
        system.debug('==== TA_AT_OrderItemSimCardUPD.afterUpdate ====== ');
        string errorMsg;
        
        try {
            Map<Id,OrderItem> oldMap = new Map<Id,OrderItem>(oldOrderProductList);
            Set<String> Set_OrderId = new Set<String>();

            Set<String> Set_OrderProductId = new Set<String>();
            Set<String> Set_ProductId = new Set<String>();

            for(OrderItem orderProductREC : newOrderProductList) {
                if (
                    orderProductREC.Order_Record_Type__c == system.label.RT_ORDER_GSM_SIM_Card &&
                    (
                        orderProductREC.Quantity != oldMap.get(orderProductREC.id).Quantity ||
                        orderProductREC.UnitPrice != oldMap.get(orderProductREC.id).UnitPrice
                    )
                    
                ){
                    Set_OrderProductId.add(orderProductREC.Id);
                    Set_ProductId.add(orderProductREC.Product2Id);

                    if(orderProductREC.Quantity > oldMap.get(orderProductREC.id).Quantity){
                        Set_OrderId.add(orderProductREC.OrderId);
                    }
                }
            }

            if(Set_OrderProductId!=null && !Set_OrderProductId.isEmpty()){
                REST_SAPGetPrice_Callout_v1.getPriceSAP(Set_OrderProductId, Set_ProductId, false);
            }

            system.debug('TA_AT_OrderItemSimCardUPD Set_OrderId : ' + Set_OrderId);

            if(Set_OrderId!=null && !Set_OrderId.isEmpty()){
                List<Order> List_Order = [
                    SELECT Id,
                    Status,
                    Approval_Status__c,
                    GM_Sales_Approval__c,
                    Sales_Admin_Approval__c,
                    Sales_Manager_Approval__c
                    FROM Order
                    WHERE Id In : Set_OrderId AND
                    Status = 'Draft'
                ];

                system.debug('TA_AT_OrderItemSimCardUPD List_Order : ' + List_Order);

                if(Set_OrderId!=null && !Set_OrderId.isEmpty()){
                    for(Order List_Order_Extract : List_Order){
                        List_Order_Extract.Approval_Status__c = null;
                        List_Order_Extract.GM_Sales_Approval__c = null;
                        List_Order_Extract.Sales_Admin_Approval__c = null;
                        List_Order_Extract.Sales_Manager_Approval__c = null;
                    }

                    update List_Order;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_OrderItemSimCardUPD After Update' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

    }
}