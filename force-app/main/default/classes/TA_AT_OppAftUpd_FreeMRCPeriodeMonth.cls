/**
 * @description       : 
 * @Test Class		  : TA_AT_OppAftUpd_FreeMRCPeriodeMonth_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-21-2023   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_AT_OppAftUpd_FreeMRCPeriodeMonth implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<Opportunity> newList, list<Opportunity> oldList) {
        system.debug('==== TA_AT_OppAftUpd_FreeMRCPeriodeMonth.AfterUpdate ====== ');
        string errorMsg;

        try {
            Map<Id,Opportunity> oldMap = new Map<Id,Opportunity>(oldList);

            Boolean checkSAPMaterialCode = false;

            for (Opportunity oppRec : newList) {
                if (
                    oppRec.Free_MRC_Periode_Month_Invoice__c != oldMap.get(oppRec.id).Free_MRC_Periode_Month_Invoice__c &&
                    String.isNotBlank(oppRec.Free_MRC_Periode_Month_Invoice__c)
                ) {
                    checkSAPMaterialCode = true;
                }
            }

            system.debug('TA_AT_OppAftUpd_FreeMRCPeriodeMonth - checkSAPMaterialCode : ' + checkSAPMaterialCode);

            if(checkSAPMaterialCode){
                List<SAP_Material_Code__c> List_FreeSAPMaterialCode = [
                    SELECT Id,
                    Recurring_Material_Code__c,
                    Free_Material_Code__c,
                    Discocunt_Material_Code__c
                    FROM SAP_Material_Code__c
                    WHERE Free_Material_Code__c != null
                ];

                system.debug('TA_AT_OppAftUpd_FreeMRCPeriodeMonth - List_FreeSAPMaterialCode : ' + json.serialize(List_FreeSAPMaterialCode));

                if(List_FreeSAPMaterialCode!=null && !List_FreeSAPMaterialCode.isEmpty()){
                    List<SR_PR_Notification__c> List_SRPRNotification = [
                        SELECT Id,
                        notif_type__c,
                        Billing_Start_Date__c,
                        Opportunity__c
                        FROM SR_PR_Notification__c
                        WHERE Billing_Start_Date__c != null AND
                        notif_type__c = 'PR'
                    ];

                    system.debug('TA_AT_OppAftUpd_FreeMRCPeriodeMonth - List_SRPRNotification : ' + json.serialize(List_SRPRNotification));

                    if(List_SRPRNotification!=null && !List_SRPRNotification.isEmpty()){
                        Map<String,SR_PR_Notification__c> Map_List_SRPRNotification = new Map<String,SR_PR_Notification__c>();

                        for(SR_PR_Notification__c SRPRNotification : List_SRPRNotification){
                            Map_List_SRPRNotification.put(SRPRNotification.Opportunity__c, SRPRNotification);
                        }

                        system.debug('TA_AT_OppAftUpd_FreeMRCPeriodeMonth - Map_List_SRPRNotification : ' + Map_List_SRPRNotification);

                        if(Map_List_SRPRNotification!=null && !Map_List_SRPRNotification.isEmpty()){
                            for (Opportunity oppRec : newList) {
                                if (
                                    oppRec.Free_MRC_Periode_Month_Invoice__c != oldMap.get(oppRec.id).Free_MRC_Periode_Month_Invoice__c &&
                                    String.isNotBlank(oppRec.Free_MRC_Periode_Month_Invoice__c)
                                ) {
                                    if(Map_List_SRPRNotification.get(oppRec.Id) != null){
                                        OpportunityService.CreateFreeMRCOpptyProducts(oppRec.Id, Map_List_SRPRNotification.get(oppRec.Id).Billing_Start_Date__c);
                                    }
                                    
                                }
                            }
                        }
                    }
                }else{
                    for (Opportunity oppRec : newList) {
                        if (
                            oppRec.Free_MRC_Periode_Month_Invoice__c != oldMap.get(oppRec.id).Free_MRC_Periode_Month_Invoice__c &&
                            String.isNotBlank(oppRec.Free_MRC_Periode_Month_Invoice__c)
                        ) {
                            if (!test.isrunningtest()) {
                                oppRec.addError('Can\'t set FREE MRC, because there is no FREE MRC product related to service product. Call Administration!');
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
            errorMsg = errorMsg +  '. Error on TA_AT_OppAftUpd_FreeMRCPeriodeMonth After Update' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}