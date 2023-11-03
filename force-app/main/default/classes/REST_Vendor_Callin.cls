/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 12-20-2022
 * @last modified by  : Diky Nurosid
**/
@RestResource(urlMapping='/v1/vendor/*')
global with sharing class REST_Vendor_Callin {
    @HttpPost
    global static Vendor__c doCreate(Vendor__c newVendor) {
        insert newVendor;
        return newVendor;
    }

    @HttpPatch
    global static Vendor__c doUpdate(String vendorId,Vendor__c updateVendor) {
       // Vendor__c vendorObj = (Vendor__c) JSON.deserialize(RestContext.request.requestBody.toString(), Vendor__c.class);
        update [SELECT Id, Name FROM Vendor__c WHERE Id = :vendorId];
        return updateVendor;
    }

    @HttpDelete
    global static void doDelete() {
        String vendorId = RestContext.request.params.get('vendorId');
        delete [SELECT Id FROM Vendor__c WHERE Id = :vendorId];
    }
}