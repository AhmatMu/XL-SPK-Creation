public class TA_AT_VendorAftIns_CallToCreateVendor implements TriggerAction.AfterInsert{
    public void AfterInsert(List<Vendor__c> newVendorList){
        System.debug('----TA_AT_VendorAftIns_CallToCreateVendor----');

        String errorMsg;
        Id vendorId;

        try {
            for (Vendor__c vendorRec : newVendorList) {
                if (
                    vendorRec.Name != null || vendorRec.VendorId__c != null || vendorRec.listemail__c != null 
                ) {
                    vendorId = vendorRec.Id;
                }
            }

            if (vendorId != null) {
                REST_Vendor_Callout.requestVendorCreationToEasyOpsByVendorId(vendorId, null, null, null, null, null, null);
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_VendorAftIns_CallToCreateVendor After Insert :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}