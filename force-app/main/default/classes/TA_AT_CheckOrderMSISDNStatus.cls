public with sharing class TA_AT_CheckOrderMSISDNStatus implements TriggerAction.afterUpdate{

    public void afterUpdate(list<Order_MSISDN__c> newOrderMSISDNList, list<Order_MSISDN__c> oldOrderMSISDNList) {
        //id orderId;
        
		Set<string> Set_orderId = new Set<string>();
        for(Order_MSISDN__c orderRec:newOrderMSISDNList){
            Set_orderId.add(orderRec.Order__c);
        }
        system.debug('Set_orderId : '+Set_orderId); 
        
        for(String orderidrec : Set_orderId){
            OrderMSISDN.CheckOrderMSISDNStatus(orderidrec);
        }

    }
}