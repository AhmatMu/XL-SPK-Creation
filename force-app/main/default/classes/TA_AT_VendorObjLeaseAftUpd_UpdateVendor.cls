public class TA_AT_VendorObjLeaseAftUpd_UpdateVendor implements TriggerAction.AfterUpdate{
    public void AfterUpdate(List<Vendor_Object_Lease__c> newList, List<Vendor_Object_Lease__c> oldList) {
        System.debug('----TA_AT_VendorObjLeaseAftUpd_UpdateVendor----');

        Map<Id, Vendor_Object_Lease__c> oldMap = new Map<Id, Vendor_Object_Lease__c>(oldList);

        String errorMsg;
        Id vendorObjLeaseId;
        String oldVendorObjectLease;
        Object newVendorObjectLease;

        try {
            for (Vendor_Object_Lease__c vendorObjLeaseRec : newList) {
                if (
                    oldMap.get(vendorObjLeaseRec.Id).Garansi_SLA__c != vendorObjLeaseRec.Garansi_SLA__c || oldMap.get(vendorObjLeaseRec.Id).is_Active__c != vendorObjLeaseRec.is_Active__c
                ) {
                    vendorObjLeaseId        = vendorObjLeaseRec.Vendor__c;
                    oldVendorObjectLease    = vendorObjLeaseRec.Id;
                    newVendorObjectLease    = vendorObjLeaseRec;
                }
            }

            if (vendorObjLeaseId != null) {
                REST_Vendor_Callout.requestVendorCreationToEasyOpsByVendorId(vendorObjLeaseId, null, null, JSON.serialize(newVendorObjectLease), JSON.serialize(oldMap.get(oldVendorObjectLease)), null, null);
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_VendorObjLeaseAftUpd_UpdateVendor After Update - Async :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}