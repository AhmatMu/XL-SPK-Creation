/**
 * @description       : 
 * @Test Class		    : TA_AT_CALL_Schdle_FixingSRPRName_Test
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 04-28-2023
 * @last modified by  : Novando Utoyo Agmawan
**/

trigger SRPRTrigger on SR_PR_Notification__c (
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