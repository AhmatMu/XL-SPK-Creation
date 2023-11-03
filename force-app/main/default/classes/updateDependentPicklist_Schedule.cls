/**
 * @description       : 
 * @Test Class		  : ProductOnboarding_Schedule_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-08-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-04-2022   Novando Utoyo Agmawan   Initial Version
**/

global class updateDependentPicklist_Schedule implements Schedulable{
    Public String DependentPicklistValues_Map;
    Public Set<String> tikectIds;

    global updateDependentPicklist_Schedule(
        String aDependentPicklistValues_Map,
        Set<String> atikectIds
    ){
        DependentPicklistValues_Map = aDependentPicklistValues_Map;
        tikectIds = atikectIds;
    }
    
    global void execute(SchedulableContext sc){
        testScheduleClassMethod(
            DependentPicklistValues_Map,
            tikectIds
        );
    }

    global void testScheduleClassMethod(
        String aDependentPicklistValues_Map,
        Set<String> atikectIds
    ){
        NewProductRegistrationTicketService.updateDependentPicklist(
            aDependentPicklistValues_Map,
            atikectIds   
        );
    }
}