/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 09-26-2022
 * @last modified by  : Diky Nurosid
**/
trigger TrialMonitoringTicketTrigger on Trial_Monitoring_Ticket__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new MetadataTriggerHandler().run();
}