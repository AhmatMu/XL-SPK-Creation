/**
 * @description       : 
 * @Test Class        : REST_SIMCardOrder_v2_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-27-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-09-2023   Novando Utoyo Agmawan   Initial Version
**/

global class REST_SIMCardOrder_v2_Schdler implements Schedulable {
    Public String orderId;

    global REST_SIMCardOrder_v2_Schdler(Id aOrderId) {
        if ( orderId == null ) {
            orderId = aOrderId;
        }
    }
    
    global void execute(SchedulableContext sc){
        testScheduleClassMethod(orderId);
    }

    global void testScheduleClassMethod(Id orderId){
        if(!Test.isRunningTest()){
            REST_SIMCardOrder_v3.addSimCardOrder(orderId);
        }
    }
    
}