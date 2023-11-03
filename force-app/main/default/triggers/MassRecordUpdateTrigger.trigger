trigger MassRecordUpdateTrigger on Mass_Record_Update__c (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    new MetadataTriggerHandler().run();
}