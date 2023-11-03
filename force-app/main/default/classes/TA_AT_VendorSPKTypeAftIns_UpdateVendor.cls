public class TA_AT_VendorSPKTypeAftIns_UpdateVendor implements TriggerAction.AfterInsert {
    public void AfterInsert(List<Vendor_SPK_Type__c> newList) {
        System.debug('----TA_AT_VendorSPKTypeAftIns_UpdateVendor----');

        String errorMsg;
        Id vendorSPKTypeId;

        try {
            for (Vendor_SPK_Type__c vendorSPKTypeRec : newList) {
                if (
                    vendorSPKTypeRec.Vendor__c != null || vendorSPKTypeRec.SPK_Type__c != null
                ) {
                    vendorSPKTypeId = vendorSPKTypeRec.Vendor__c;
                }
            }

            if (vendorSPKTypeId != null) {
                REST_Vendor_Callout.requestVendorCreationToEasyOpsByVendorId(vendorSPKTypeId, null, null, null, null, null, null);
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_VendorSPKTypeAftIns_UpdateVendor After Insert :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}