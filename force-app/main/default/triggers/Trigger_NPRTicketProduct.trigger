/**
 * @description       : 
 * @Test Class		  : Trigger_NPRTicketProductHandler_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 12-19-2021
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   12-19-2021   Novando Utoyo Agmawan   Initial Version
**/

trigger Trigger_NPRTicketProduct on NPRTicketProduct__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    List<Trigger_Controller__c> TriggerController = [select Is_Active__c from Trigger_Controller__c where name = 'Trigger_NPRTicketProduct'];

    if(TriggerController!=null && !TriggerController.isEmpty()){
        if(TriggerController[0].Is_Active__c){
            TriggerDispatcher.Run(new Trigger_NPRTicketProductHandler());
        }
    }
}