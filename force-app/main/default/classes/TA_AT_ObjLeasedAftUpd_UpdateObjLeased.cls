/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 10-31-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
public class TA_AT_ObjLeasedAftUpd_UpdateObjLeased implements TriggerACtion.AfterUpdate{
    public void AfterUpdate(List<Object_Lease__c> newList, List<Object_Lease__c> oldList){
        System.debug('----TA_AT_ObjLeasedAftUpd_UpdateObjLeased----');

        Map<Id, Object_Lease__c> oldMap = new Map<Id, Object_Lease__c>(oldList);

        String errorMsg;
        String objLeaseGUID;
        String oldObjectLeaseRec;
        Object newObjectLeaseRec;

        try {
            for (Object_Lease__c objLeaseRec : newList) {
                System.debug('objLeaseRec: ' + objLeaseRec);
                if (
                    objLeaseRec.Object_Lease_Id__c != null && 
                    (
                        (oldMap.get(objLeaseRec.Id).Name != objLeaseRec.Name) ||
                        (oldMap.get(objLeaseRec.Id).Object_Lease_Type__c != objLeaseRec.Object_Lease_Type__c) ||
                        (oldMap.get(objLeaseRec.Id).is_Active__c != objLeaseRec.is_Active__c)
                    )
                ) {
                    objLeaseGUID        = objLeaseRec.Object_Lease_Id__c;
                    oldObjectLeaseRec   = objLeaseRec.Id;
                    newObjectLeaseRec   = objLeaseRec;
                }
            }

            // === call api to easyops
            if (objLeaseGUID != null) {
                REST_ObjectLease_Callout.requestObjectLeaseUpdatedToEasyOpsByGUID(objLeaseGUID, JSON.serialize(newObjectLeaseRec), JSON.serialize(oldMap.get(oldObjectLeaseRec)));
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_ObjLeasedAftUpd_UpdateObjLeased After Update :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}