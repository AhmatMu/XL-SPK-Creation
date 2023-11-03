public class TA_AT_SRPR_DeleteSPKItem implements TriggerAction.BeforeDelete {
    public void BeforeDelete(List<SR_PR_Notification__c> oldList) {
        System.debug('----TA_AT_SRPR_DeleteSPKItem----');

        String errorMsg; // new for try catch

        try {
            list<SPK__c> oldSPKList = [
            SELECT id 
            FROM SPK__c 
            WHERE PR_Rel__c in:oldList
            ];

            delete oldSPKList; 
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_SRPR_DeleteSPKItem Before Delete' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}