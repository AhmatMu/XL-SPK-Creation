public class TA_AT_ObjLeaseAftIns_CreateObjLeased implements TriggerAction.AfterInsert {
    public void AfterInsert(List<Object_Lease__c> newList){
        System.debug('----TA_AT_ObjLeaseAftIns_CreateObjLeased----');

        String errorMsg;
        Id objLeaseId;

        try {
            for (Object_Lease__c objLeaseRec : newList) {
                if (
                    objLeaseRec.Name != null ||
                    objLeaseRec.Object_Lease_Type__c != null
                ) {
                    objLeaseId = objLeaseRec.Id;
                }
            }

            if (objLeaseId != null) {
                REST_ObjectLease_Callout.requestObjectLeaseCreationToEasyOpsByObjectLeaseId(objLeaseId);
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_ObjLeaseAftIns_CreateObjLeased After Insert :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}