trigger VendorObjectLeaseTrigger on Vendor_Object_Lease__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
	new MetadataTriggerHandler().run();
}