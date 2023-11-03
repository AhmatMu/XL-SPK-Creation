public class TA_AT_VendorAftUpd_CallToUpdateVendor implements TriggerAction.AfterUpdate{
    public void AfterUpdate(List<Vendor__c> newList, List<Vendor__c> oldList){
        System.debug('----TA_AT_VendorAftUpd_CallToUpdateVendor----');

        Map<Id, Vendor__c> oldMap = new Map<Id, Vendor__c>(oldList);
        
        String errorMsg;
        Id vendorId;
        Object newVendor;

        try {
            for (Vendor__c vendorRec : newList) {
                if (
                    (oldMap.get(vendorRec.Id).Type__c != vendorRec.Type__c) || 
                    (
                        vendorRec.VendorId__c != null || vendorRec.Name != null || vendorRec.listemail__c != null || vendorRec.PIC__c != null || vendorRec.Address__c != null || vendorRec.is_Active__c != null || vendorRec.SPK_to_PMIS__c != null  
                    )
                ) {
                    vendorId    = vendorRec.Id;
                    newVendor   = vendorRec;
                }
            }

            if (vendorId != null) {
                REST_Vendor_Callout.requestVendorCreationToEasyOpsByVendorId(vendorId, JSON.serialize(newVendor), JSON.serialize(oldMap.get(String.valueOf(vendorId))), null, null, null, null);
            }
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_VendorAftUpd_CallToUpdateVendor After Update :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}