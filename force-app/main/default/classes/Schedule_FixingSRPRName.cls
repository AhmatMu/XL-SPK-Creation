/**
 * @description       : 
 * @Test Class		  : Schedule_FixingSRPRName_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-26-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-14-2023   Novando Utoyo Agmawan   Initial Version
**/

global with sharing class Schedule_FixingSRPRName implements Schedulable {
    global void execute (SchedulableContext sc) {
        SRPRService SRPRService_class = new SRPRService();
        SRPRService_class.FixSRPRDuplicateName();
    }
}