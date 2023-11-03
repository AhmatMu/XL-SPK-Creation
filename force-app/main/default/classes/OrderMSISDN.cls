public with sharing class OrderMSISDN {
	
	public static void CheckOrderMSISDNStatus(String OrderId){
		System.debug ('==== Starting Class:OrderMSISDN method:CheckOrderMSISDNStatus ====');
        System.debug ('==== OrderID : ' + OrderID);

		Order orderObj = [select id, recordtypeid, status, sub_status__c from order where id =:orderID];
        string RTID15String = string.valueof(orderObj.recordtypeid).left(15);
        List<Order_MSISDN__c> orderNotSuccessList = null;
        
        System.debug ('==== RTID15String : ' + RTID15String);                      

		//-- for this session Auto Complete process only for PREPAID TAGGING
        if ( RTID15String == system.label.RT_ORDER_PREPAID_EXISTING 
            || RTID15String == system.label.RT_ORDER_PREPAID_NEW  
            || RTID15String == system.label.RT_ORDER_PREPAID_UNTAGGING_EXISTING  
           ) {
                /* old way
                orderNotSuccessList = [SELECT id, status__c 
                    from Order_MSISDN__c 
                WHERE Order__c =:orderID 
                    AND status__c != 'Success'                    
                ];
                */


                List<AggregateResult> orderMSISDNARList = [SELECT 
                    status__c, count(id) qty
                FROM Order_MSISDN__c 
                WHERE Order__c =:orderID 
                GROUP BY status__c
                ];

                integer successQty = 0;
                integer failedQty = 0;
                integer otherQty = 0;

                for (AggregateResult orderMSISDNARObj : orderMSISDNARList) {
                    string status = (string) orderMSISDNARObj.get('status__c');
                    integer qty = (integer) orderMSISDNARObj.get('qty');

                    if (status == 'Success') {
                        successQty = successQty + qty;
                    }
                    else if (status == 'Failed') {
                        failedQty = failedQty + qty;
                    }
                    else {
                        otherQty = otherQty + qty;
                    }
                }
				System.debug ('==== otherQty : ' + otherQty); 
                if ( otherQty == 0) {
                    orderObj.status = 'Complete';                       
                    update orderObj;
                }





            }
        /* old way
        if (orderNotSuccessFailedList <> null) {
            System.debug ('==== orderNotSuccessFailedList.size() : ' + orderNotSuccessFailedList.size());
            if (orderNotSuccessList.size()== 0){
                orderObj.status = 'Complete';                       
                update orderObj;
            }
            else {
                orderObj.sub_status__c = 'Something Failed';  // <-- the changes will be trigger to send an email notification  
           		update orderObj; 
            }
        }
        */
        
	}
	
	
}