/**
 * @description       : 
 * @Test Class        : TEST_CallCSRegComplete_Schdler
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-09-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-18-2022   Novando Utoyo Agmawan   Initial Version
**/

global class CallCSRegComplete_Schdler implements Schedulable {
    Public Id custRegTicketID;
    Public String source;

    global CallCSRegComplete_Schdler(Id aCustRegTicketID, String asource) {
        if ( custRegTicketID == null ) {
            custRegTicketID = aCustRegTicketID;
        }

        source = asource;
    }
    
    global void execute(SchedulableContext sc){
        testScheduleClassMethod(custRegTicketID,source);
    }

    global void testScheduleClassMethod(Id argPass, String source){
        if(source == 'marketplace'){
            system.debug('CallCSRegComplete_Schdler - source : ' + source);
            
            //REST_Customer_Registration_CallOut_v1.sendApprovalInfo(argPass);

            REST_Customer_Registration_CallOut_v2.sendApprovalInfo(argPass);
        }

        if(source == 'bizcare'){
            system.debug('CallCSRegComplete_Schdler - source : ' + source);

            REST_BizCare_BizOn_CallOut_v1.UpdateTicketRegistration(argPass);
        }
    }
    
}