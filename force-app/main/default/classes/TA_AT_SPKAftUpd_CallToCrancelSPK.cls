public class TA_AT_SPKAftUpd_CallToCrancelSPK implements TriggerAction.AfterUpdate{
    public void AfterUpdate(List<SPK__c> newList, List<SPK__c> oldList) {
        System.debug('----TA_AT_SPKAftUpd_CallToCrancelSPK----');

        Map<Id, SPK__c> oldMap = new Map<Id, SPK__c>(oldList);

        String errorMsg;
        Set<Id> spkIds = new Set<Id>();

        try {
            for (SPK__c spkRec : newList) {
                if (
                    (oldMap.get(spkRec.Id).status__c != spkRec.status__c) && spkRec.status__c == 'Canceled'
                ) {
                    spkIds.add(spkRec.Id);
                }
            }

            if (!spkIds.isEmpty()) {
                // REST_SPK_Callout.requestSPKCancelationBySPKId(spkIds);
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_SPKAftUpd_CallToCrancelSPK After Update :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}