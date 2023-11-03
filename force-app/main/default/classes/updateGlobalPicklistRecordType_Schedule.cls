/**
 * @description       : 
 * @Test Class		  : ProductOnboarding_Schedule_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-08-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   03-04-2022   Novando Utoyo Agmawan   Initial Version
**/

global class updateGlobalPicklistRecordType_Schedule implements Schedulable{
    Public string actionType;
    Public string soapEnvelop;

    global updateGlobalPicklistRecordType_Schedule(
        String aactionType,
        String asoapEnvelop
    ){
        actionType = aactionType;
        soapEnvelop = asoapEnvelop;
    }
    
    global void execute(SchedulableContext sc){
        testScheduleClassMethod(
            actionType,
            soapEnvelop
        );
    }

    global void testScheduleClassMethod(
        String aactionType,
        String asoapEnvelop
    ){
        NewProductRegistrationTicketService.updateGlobalPicklistRecordType(
            aactionType,
            asoapEnvelop   
        );
    }
}