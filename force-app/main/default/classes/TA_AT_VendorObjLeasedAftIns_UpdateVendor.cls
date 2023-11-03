public class TA_AT_VendorObjLeasedAftIns_UpdateVendor implements TriggerAction.AfterInsert {
    public void AfterInsert(List<Vendor_Object_Lease__c> newList) {
        System.debug('----TA_AT_VendorObjLeasedAftIns_UpdateVendor----');

        String errorMsg;
        Id vendorObjectLeaseId;

        try {
            for (Vendor_Object_Lease__c vendorObjLeaseRec : newList) {
                if (
                    vendorObjLeaseRec.Name != null || vendorObjLeaseRec.Object_Lease__c != null || vendorObjLeaseRec.Vendor__c != null
                ) {
                    vendorObjectLeaseId = vendorObjLeaseRec.Vendor__c;
                }
            }

            if (vendorObjectLeaseId != null) {
                REST_Vendor_Callout.requestVendorCreationToEasyOpsByVendorId(vendorObjectLeaseId, null, null, null, null, null, null);
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_VendorObjLeasedAftIns_UpdateVendor After Insert :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}