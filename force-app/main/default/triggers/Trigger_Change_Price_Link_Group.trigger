trigger Trigger_Change_Price_Link_Group on Change_Price_Link_Group__c (after update) {

    //-- on UPDATE
    if(trigger.isUpdate)
    {   
        //-- IF BEFORE Update
        if(trigger.isAfter) {
            for( Change_Price_Link_Group__c PricingNew :system.trigger.new ) {
                //-- get old value      
                Change_Price_Link_Group__c  PricingOld =Trigger.oldMap.get(PricingNew .id);
                
                if ( PricingOld.Selling_price__c <> PricingNew.Selling_price__c ) {
                    //-- update Change Price 
                    string changePriceID = PricingOld.Change_Price__c ;
                    list <Change_Price_Link__c > CPLList = [select id, selling_price__c from Change_Price_Link__c 
                    											where Change_Price__c =:changePriceID
                    												and Bandwidth__c =:PricingNew.Bandwidth__c		
                    												and UoM__c =: PricingNew.UoM__c
                    											];
                    if ( CPLList.size() >0  ) {
                        for ( Change_Price_Link__c  CPL : CPLList) {
                            CPL.selling_price__c = PricingNew.Selling_price__c;
                        }
                        update CPLList;
                    
                    }
                }
            
            }
        
        
        }
    }        
}