trigger AccountCollectionRatioTrigger on Account_Collection_Ratio__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
	new MetadataTriggerHandler().run();
}