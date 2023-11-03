/**
 * @description       : 
 * @Test Class        : TA_AT_OrderItemSimCardUPD_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 12-26-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-03-2022   Novando Utoyo Agmawan   Initial Version
**/

trigger OrderProductTrigger on OrderItem (
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