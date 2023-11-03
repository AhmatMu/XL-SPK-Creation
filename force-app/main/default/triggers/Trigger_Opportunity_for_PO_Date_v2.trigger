/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-27-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-18-2022   Novando Utoyo Agmawan   Initial Version
**/

trigger Trigger_Opportunity_for_PO_Date_v2 on Opportunity (before update) {
    if (label.Is_Trigger_Opportunity_for_PO_Date_v2_ON == 'YES') {
    
        if (trigger.isBefore){
              if (trigger.isUpdate) {
                  for(Opportunity newOpp : system.trigger.new) {
                      Opportunity oldOpp=Trigger.oldMap.get(newOpp.id);
                      
                      //-- for GSM
                      /*if ( newOpp.RecordtypeName__c == 'GSM' ) {
                        if (newOpp.StageName <> oldOpp.StageName && 
                                ( newOpp.StageName == 'Quotation Final' || newOpp.StageName == 'Closed Won'  ) ) {
                            if (oldOpp.PO_Date__c == null) {
                                newOpp.PO_Date__c = Date.today();
                            }
                        }   
                      } */
                      
                      //-- for GSM (Activation)
                      if ( newOpp.RecordtypeName__c == 'Simcard Postpaid/Prepaid' ) {
                          if (newOpp.StageName <> oldOpp.StageName &&  
                                ( newOpp.StageName == 'Quotation Final' || newOpp.StageName == 'Implementation') ) {
                            if (oldOpp.PO_Date__c == null) {newOpp.PO_Date__c = Date.today();
                            }
                        } 
                      }

                      //-- for GSM (Simcard Order)
                      if ( newOpp.RecordtypeName__c == 'GSM (Simcard Order)' ) {
                        if (newOpp.StageName <> oldOpp.StageName && 
                                ( newOpp.StageName == 'Submit Order' || newOpp.StageName == 'Closed Won'  ) ) {
                            if (oldOpp.PO_Date__c == null) {newOpp.PO_Date__c = Date.today();
                            }
                        } 
                      }

                      //-- for Bulkshare (Digital Advertising)
                      //if ( newOpp.RecordtypeName__c == 'Project Bulkshare' ) {
                      if ( newOpp.RecordtypeName__c.contains('Project')) {
                        if (newOpp.StageName <> oldOpp.StageName && 
                                ( newOpp.StageName == 'Quotation Final') ) {
                            if (oldOpp.PO_Date__c == null) {
                                newOpp.PO_Date__c = Date.today();
                            }
                        } 
                      }
                      
                      
                       //-- for DEVICE BUNDLING
                          if ( newOpp.RecordtypeName__c.contains('Device Bundling')) {
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
                      if( 
                          newOpp.RecordtypeName__c.contains('Subscription') ||
                          newOpp.RecordtypeName__c.contains('Subscription Two Site') ||
                          newOpp.RecordtypeName__c.contains('Usage')|| 
                          newOpp.RecordtypeName__c == 'M-Ads'
                       ){
                        if (newOpp.StageName <> oldOpp.StageName && newOpp.StageName == 'Quotation Final' ) {newOpp.PO_Date__c = Date.today();
                        } 
                      }                     
                  }
              }
        }
    }
}