/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 01-26-2023
 * @last modified by  : Diky Nurosid
**/
trigger BillingRequestTrigger on Billing_Request__c (
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