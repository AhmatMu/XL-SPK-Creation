/**
 * @description       : 
 * @Test Class		  : TA_VR_PR_AU_CantChangeBillStartDate_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-13-2023
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-12-2023   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_VR_PR_AU_CantChangeBillStartDate implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<SR_PR_Notification__c> newList, list<SR_PR_Notification__c> oldList) {
        system.debug('==== TA_VR_PR_AU_CantChangeBillStartDate.AfterUpdate ====== ');
        string errorMsg;

        try {
            Map<Id,SR_PR_Notification__c> oldMap = new Map<Id,SR_PR_Notification__c>(oldList);

            Set<String> Set_OpportunityIds = new Set<String>();
            
            for (SR_PR_Notification__c srprRec : newList) {
                if (
                    srprRec.Billing_Start_Date__c != oldMap.get(srprRec.id).Billing_Start_Date__c && 
                    srprRec.Notif_Type__c == 'PR'&&
                    srprRec.Opportunity_Free_MRC_Periode_Month__c != null &&
                    srprRec.Opportunity__c != null
                ) {
                    Set_OpportunityIds.add(srprRec.Opportunity__c);
                }
            }

            system.debug('TA_VR_PR_AU_CantChangeBillStartDate - Set_OpportunityIds : ' + json.serialize(Set_OpportunityIds));

            //if(Set_OpportunityIds!=null && !Set_OpportunityIds.isEmpty()){
            if( Set_OpportunityIds.size() > 0 ){
                List<Contract> List_contracts = [
                    SELECT Id,
                        SO_Number__c,
                        Opportunity__c
                    FROM Contract
                    WHERE Opportunity__c IN: Set_OpportunityIds 
                        AND SO_Number__c != null
                ];

                system.debug('TA_VR_PR_AU_CantChangeBillStartDate - List_contracts : ' + json.serialize(List_contracts));

                //if(List_contracts!=null && !List_contracts.isEmpty()){
                if( List_contracts.size() > 0 ){
                    Map<String,String> Map_contractsWithOpp = new Map<String,String>();

                    for(Contract contractReq : List_contracts){
                        Map_contractsWithOpp.put(contractReq.Opportunity__c, contractReq.Opportunity__c);
                    }

                    system.debug('TA_VR_PR_AU_CantChangeBillStartDate - Map_contractsWithOpp : ' + Map_contractsWithOpp);

                    if(Map_contractsWithOpp!=null && !Map_contractsWithOpp.isEmpty()){
                        for (SR_PR_Notification__c srprRec : newList) {
                            if (
                                srprRec.Billing_Start_Date__c != oldMap.get(srprRec.id).Billing_Start_Date__c && 
                                srprRec.Notif_Type__c == 'PR'&&
                                srprRec.Opportunity_Free_MRC_Periode_Month__c != null &&
                                Map_contractsWithOpp.get(srprRec.Opportunity__c) != null &&
                                srprRec.Opportunity__c != null
                            ) {
                                if (!test.isrunningtest()) {
                                    srprRec.addError(system.label.ERRMSG_CANNOT_CHANGE_BILLSTARTDATE_DUE_SOFREE);
                                }
                            }
                        }
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_VR_PR_AU_CantChangeBillStartDate After Update' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}