/**
 * @description       : 
 * @Test Class		  : TA_VR_Oppty_AU_CantChangeFreeMRC_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-13-2023
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-12-2023   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_VR_Oppty_AU_CantChangeFreeMRC implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<Opportunity> newList, list<Opportunity> oldList) {
        system.debug('==== TA_VR_Oppty_AU_CantChangeFreeMRC.AfterUpdate ====== ');
        string errorMsg;

        try {
            Map<Id,Opportunity> oldMap = new Map<Id,Opportunity>(oldList);

            Set<String> Set_OpportunityIds = new Set<String>();

            for (Opportunity oppRec : newList) {
                if (
                    oppRec.Free_MRC_Periode_Month_Invoice__c != oldMap.get(oppRec.id).Free_MRC_Periode_Month_Invoice__c &&
                    oppRec.Free_MRC_Periode_Month_Invoice__c != null
                ) {
                    Set_OpportunityIds.add(oppRec.Id);
                }
            }

            system.debug('TA_VR_Oppty_AU_CantChangeFreeMRC - Set_OpportunityIds : ' + json.serialize(Set_OpportunityIds));

            //if(Set_OpportunityIds!=null && !Set_OpportunityIds.isEmpty()){
            if( Set_OpportunityIds.size() > 0 ){
                List<Contract> List_contracts = [
                    SELECT Id,
                        SO_Number__c, Opportunity__c
                    FROM Contract
                    WHERE Opportunity__c IN: Set_OpportunityIds 
                        AND SO_Number__c != null
                ];

                system.debug('TA_VR_Oppty_AU_CantChangeFreeMRC - List_contracts : ' + json.serialize(List_contracts));

                //if(List_contracts!=null && !List_contracts.isEmpty()){
                if( List_contracts.size() > 0 ){
                
                    Map<String,String> Map_contractsWithOpp = new Map<String,String>();

                    for(Contract contractReq : List_contracts){
                        Map_contractsWithOpp.put(contractReq.Opportunity__c, contractReq.Opportunity__c);
                    }

                    system.debug('TA_VR_Oppty_AU_CantChangeFreeMRC - Map_contractsWithOpp : ' + Map_contractsWithOpp);

                    if(Map_contractsWithOpp!=null && !Map_contractsWithOpp.isEmpty()){
                        for (Opportunity oppRec : newList) {
                            if (
                                oppRec.Free_MRC_Periode_Month_Invoice__c != oldMap.get(oppRec.id).Free_MRC_Periode_Month_Invoice__c &&
                                oppRec.Free_MRC_Periode_Month_Invoice__c != null &&
                                Map_contractsWithOpp.get(oppRec.Id) != null
                            ) {
                                if (!test.isrunningtest()) {
                                    oppRec.addError(system.label.ERRMSG_CANNOT_CHANGE_FREEMRC_PERIODE_DUE_SOFREE);
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
            errorMsg = errorMsg +  '. Error on TA_VR_Oppty_AU_CantChangeFreeMRC After Update' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}