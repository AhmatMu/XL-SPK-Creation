/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 09-06-2022
 * @last modified by  : Diky Nurosid
**/
trigger VendorRegistrationTicketTrigger on Vendor_Registration_Ticket__c (
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  new MetadataTriggerHandler().run();
}