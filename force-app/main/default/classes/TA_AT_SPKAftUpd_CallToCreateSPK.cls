public class TA_AT_SPKAftUpd_CallToCreateSPK implements TriggerAction.AfterUpdate{
    public void AfterUpdate(List<SPK__c> newList, List<SPK__c> oldList){
        System.debug('----TA_AT_SPKAftUpd_CallToCreateSPK----');

        Map<Id, SPK__c> oldMap = new Map<Id, SPK__c>(oldList);

        String errorMsg;
        Set<Id> spkIds = new Set<Id>();

        try {
            for (SPK__c spkRec : newList) {
                if (
                    (oldMap.get(spkRec.Id).status__c != spkRec.status__c) && spkRec.Status__c == 'Released'
                ) {
                    spkIds.add(spkRec.Id);
                }
            }

            if (!spkIds.isEmpty()) {
                // REST_SPK_Callout.requestSPKCreationToEasyopsBySPKId(spkIds);
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_SPKAftUpd_CallToCreateSPK After Update :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}