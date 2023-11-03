trigger Trigger_Opportunity_On_SIMCard_ORDER on Opportunity (before update) {

  if (label.Is_Trigger_Opportunity_On_SIMCard_ORDER_ON == 'YES') {
   if(trigger.isupdate){
   
        if(trigger.isbefore) {
            for(Opportunity newOpp:system.trigger.new) {
                Opportunity oldOpp=Trigger.oldMap.get(newOpp.id);
                if (newOpp.recordtypeid==system.label.simcardorderid) {                                                     //-- recordType :GSM (Simcard Order)
                    if (oldOpp.stageName <> 'Order Fulfillment' && newOpp.stageName == 'Order Fulfillment' 
                        //&&   (newOpp.SO_ID__c == '' || newOpp.SO_ID__c == null) 
                            // && Approval_Status__c = 'Approved' 
                        ) {
                        // call API to SIM Card Order
                        REST_SIMCardOrder.addSimCardOrder(newOpp.id);
                    }
                }
            }
   
        }
    }
    
    }


}