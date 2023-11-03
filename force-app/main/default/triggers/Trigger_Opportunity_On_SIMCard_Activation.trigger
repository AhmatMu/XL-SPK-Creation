trigger Trigger_Opportunity_On_SIMCard_Activation on Opportunity (after update) {

    system.debug('============= on Trigger_Opportunity_On_SIMCard_Activation1');
    
    if (label.Is_Trigger_Opportunity_On_SIMCard_Activation_ON == 'YES') {
    
    if (trigger.isAfter){
        if (trigger.isUpdate) {
             for(Opportunity newOpp:system.trigger.new) {
                 Opportunity oldOpp = Trigger.oldMap.get(newOpp.id);
                 
                 /*
                 if (oldOpp.Activation_Quantity__c  <> newOpp.Activation_Quantity__c) {
                     
                     // get product 
                    string pricebook2id = newOpp.Product__c ;  //'01s5D0000005FuIQAU' ;
                    double quantity= newOpp.Activation_Quantity__c ;
                    
                     
                    OpportunityLineItem[] lines = null;
                    PricebookEntry entry = [SELECT Id, UnitPrice 
                        FROM PricebookEntry
                        WHERE pricebook2id='01s5D0000005FuIQAU'
                            AND product2.parent_product__C = :pricebook2id  //'01t5D000001XRhXQAW'
                            and (Start_From__c < :quantity)
                            and (Up_To__c >= :quantity)];
                    
                        
                    // delete lineitems
                    lines = [select id from OpportunityLineItem where OpportunityId=:newOpp.id];
                    delete lines;
                    
                    // add product automatically
                    lines = new OpportunityLineItem[0];
                    lines.add(new OpportunityLineItem(PricebookEntryId=entry.Id, 
                            OpportunityId=newOpp.Id, UnitPrice=entry.UnitPrice, Quantity= quantity));
                    
                    insert lines;
                     
                     
                 }*/
                 
                if (oldOpp.stageName  <> newOpp.stageName && newOpp.stageName == 'Submit Order' && 
                        //newOpp.recordtypeid=='0125D0000000UfC' ) { //TODO: ganti sama contain
                        //newOpp.recordType.Name.contains('GSM') && newOpp.recordType.Name.contains('Activation') ) {
                        newOpp.recordtypeid==label.simcardactivationrecordtypeid  && 
                        (newOpp.SA_ID__c == '' || newOpp.SA_ID__c == null) ){
                    
                    system.debug('============= masuk');
                    //GSM_Callout_Sales_Activation.SalesActivation (newOpp.Opportunity_ID__c);
                    REST_SIMCardActivations.CreateSalesActivation(newOpp.Opportunity_ID__c); 
                
                } else {system.debug('============= TIDAK masuk');}
            
            }
    
        }
    }
    
    } // end of trigger activation

}