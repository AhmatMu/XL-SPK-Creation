/**
 * @description       : 
 * @Test Class		  : ProductOnboarding_Schedule_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-08-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-06-2022   Novando Utoyo Agmawan   Initial Version
**/

global class updatePicklistRecordType_Schedule implements Schedulable{
    Public set<String> newPicklistValues;
    Public String objectApiName;
    Public String fieldApiName;
    Public String siteType;

    global updatePicklistRecordType_Schedule(
        set<String> anewPicklistValues,
        String aobjectApiName,
        String afieldApiName,
        String asiteType
    ){
        newPicklistValues = anewPicklistValues;
        objectApiName = aobjectApiName;
        fieldApiName = afieldApiName;
        siteType = asiteType;
    }
    
    global void execute(SchedulableContext sc){
        testScheduleClassMethod(
            newPicklistValues,
            objectApiName,
            fieldApiName,
            siteType
        );
    }

    global void testScheduleClassMethod(
        set<String> anewPicklistValues,
        String aobjectApiName,
        String afieldApiName,
        String asiteType
    ){
        NewProductRegistrationTicketService.updateRecordType(
            anewPicklistValues,
            aobjectApiName,
            afieldApiName,
            asiteType   
        );
    }
}