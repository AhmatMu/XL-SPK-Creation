/**
 * @description       : Trigger Action for create vendor after vendor registration ticket approved
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 09-06-2022
 * @last modified by  : Diky Nurosid
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0  09-06-2022   Diky Nurosid   Initial Version
**/
public with sharing class TA_AT_CreateVendorAfterApprove implements TriggerAction.AfterUpdate {
    public void AfterUpdate(List<Vendor_Registration_Ticket__c> newList, List<Vendor_Registration_Ticket__c> oldList){
        system.debug('----TA_AT_CreateVendorAfterApprove----');

        try {
            List<String> vendorRegIds = new list<String>();
            Set<Id> bpPayerId = new Set<Id>();
            Map<Id,Vendor_Registration_Ticket__c> oldMap = new Map<Id,Vendor_Registration_Ticket__c>(oldList);
            List<Vendor__c> vendorList = new List<Vendor__c>();
            for (Vendor_Registration_Ticket__c vendorRec : newList) {

                if (
                    vendorRec.Status__c != oldMap.get(vendorRec.id).Status__c && vendorRec.Status__c == 'Completed' && vendorRec.Complete_Status__c =='Approved'
                ) {
                 Vendor__c vendor = new Vendor__c();
                 vendor.Name = vendorRec.Vendor_Name__c;
                 vendor.Type__c = vendorRec.Type__c;
                 vendor.phone__c = vendorRec.Vendor_Phone__c;
                 vendor.listemail__c= vendorRec.PIc_List_Email__c;
                 vendor.address__c= vendorRec.Vendor_Address__c;
                 vendorList.add(vendor);
                }
               // vendorRegIds.add(vendorRec.Id);
            }
            insert vendorList;

           
        } catch(Exception e) {
            string notes = 'Error on TA_AT_CreateVendorAfterApprove.AfterUpdate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
}