public class TA_AT_VendorSPKTypeAftUpd_UpdateVendor implements TriggerAction.AfterUpdate {
    public void AfterUpdate(List<Vendor_SPK_Type__c> newList, List<Vendor_SPK_Type__c> oldList) {
        System.debug('----TA_AT_VendorSPKTypeAftUpd_UpdateVendor----');

        Map<Id, Vendor_SPK_Type__c> oldMap = new Map<Id, Vendor_SPK_Type__c>(oldList);

        String errorMsg;
        Id vendorSPKTypeId;
        String oldVendorSPKType;
        Object newVendorSPKType;
        
        try {
            for (Vendor_SPK_Type__c vendorSPKTypeRec : newList) {
                if (
                    (oldMap.get(vendorSPKTypeRec.Id).SPK_Type__c != vendorSPKTypeRec.SPK_Type__c) || (oldMap.get(vendorSPKTypeRec.Id).Need_PO__c != vendorSPKTypeRec.Need_PO__c) || (oldMap.get(vendorSPKTypeRec.Id).Vendor__c != vendorSPKTypeRec.Vendor__c)
                ) {
                    vendorSPKTypeId     = vendorSPKTypeRec.Vendor__c;
                    oldVendorSPKType    = vendorSPKTypeRec.Id;
                    newVendorSPKType    = vendorSPKTypeRec;
                }
            }

            if (vendorSPKTypeId != null) {
                REST_Vendor_Callout.requestVendorCreationToEasyOpsByVendorId(vendorSPKTypeId, null, null, null, null, JSON.serialize(newVendorSPKType), JSON.serialize(oldMap.get(oldVendorSPKType)));
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_VendorSPKTypeAftUpd_UpdateVendor After Update :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}