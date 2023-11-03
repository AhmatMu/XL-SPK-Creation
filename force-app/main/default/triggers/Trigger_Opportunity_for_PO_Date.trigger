trigger Trigger_Opportunity_for_PO_Date on Opportunity (before update) {
    /*
        Created By      : ahmat murad
        Created Date    : 05 Oct 2021
        Function        : To fulfill PO Date field.
        Criteria        : - Non GSM : when stage move to "Quotation Final" 
                          - GSM : when stage move to "Quotation Final" or "Closed Won"
                          - adding for digital advertising
        
    
    */
    
    if (label.Is_Trigger_Opportunity_for_PO_Date_ON == 'YES') {
    
        if (trigger.isBefore){
              if (trigger.isUpdate) {
                  for(Opportunity newOpp : system.trigger.new) {
                      Opportunity oldOpp=Trigger.oldMap.get(newOpp.id);
                      
                      //-- for GSM
                      if ( newOpp.RecordtypeName__c == 'GSM' ) {
                        if (newOpp.StageName <> oldOpp.StageName && 
                                ( newOpp.StageName == 'Quotation Final' || newOpp.StageName == 'Closed Won'  ) ) {
                            if (oldOpp.PO_Date__c == null) {
                                newOpp.PO_Date__c = Date.today();
                            }
                        }   
                      }
                      
                      //-- for GSM (Activation)
                      if ( newOpp.RecordtypeName__c == 'GSM (Activation)' ) {
                        if (newOpp.StageName <> oldOpp.StageName &&  
                                ( newOpp.StageName == 'Submit PO' || newOpp.StageName == 'Closed Won'  ) ) {
                            if (oldOpp.PO_Date__c == null) {
                                newOpp.PO_Date__c = Date.today();
                            }
                        } 
                      }

                      //-- for GSM (Simcard Order)
                      if ( newOpp.RecordtypeName__c == 'GSM (Simcard Order)' ) {
                        if (newOpp.StageName <> oldOpp.StageName && 
                                ( newOpp.StageName == 'Submit Order' || newOpp.StageName == 'Closed Won'  ) ) {
                            if (oldOpp.PO_Date__c == null) {
                                newOpp.PO_Date__c = Date.today();
                            }
                        } 
                      }

                      //-- for Bulkshare (Digital Advertising)
                      if ( newOpp.RecordtypeName__c == 'Digital Advertising' ) {
                        if (newOpp.StageName <> oldOpp.StageName && 
                                ( newOpp.StageName == 'Quotation Final') ) {
                            if (oldOpp.PO_Date__c == null) {
                                newOpp.PO_Date__c = Date.today();
                            }
                        } 
                      }
 
                    
                    system.debug ('=== newOpp.RecordtypeName__c : ' + newOpp.RecordtypeName__c);
                    system.debug ('=== oldOpp.StageName : ' + oldOpp.StageName);
                    system.debug ('=== newOpp.StageName : ' + newOpp.StageName);
                    
                       //-- for Non GSM 
                      if ( newOpp.RecordtypeName__c == 'IoT'
                            || newOpp.RecordtypeName__c == 'IoT (existing link)'
                            || newOpp.RecordtypeName__c == 'M-Ads'
                            || newOpp.RecordtypeName__c == 'Non GSM'
                            || newOpp.RecordtypeName__c == 'Non GSM (existing link)'
                            || newOpp.RecordtypeName__c == 'Non GSM Leased Line'
                            || newOpp.RecordtypeName__c == 'Non GSM Leased Line (existing link)'
                            || newOpp.RecordtypeName__c == 'Non GSM VoIP'
                            || newOpp.RecordtypeName__c == 'Non GSM VoIP (existing link)'
                       ) {
                        if (newOpp.StageName <> oldOpp.StageName && newOpp.StageName == 'Quotation Final' ) {
                            newOpp.PO_Date__c = Date.today();
                        } 
                      }                     
                  }
              }
        }
    }
}