/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 27-07-2023
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   27-07-2023   Doddy Prima   Initial Version
**/
public with sharing class Schedule_GetTowerCandidate implements Schedulable {
    public ID presurveyID;

    public void execute(SchedulableContext sc){
        /*
        Integer callNumber;
        List<Presurvey__c> presurveyList = [
            SELECT id, Get_Tower_Call_Number__c
            FROM Presurvey__c
            WHERE id = :presurveyID
        ];
        
        if ( presurveyList.size() > 0 ) {
            callNumber = Integer.valueof(presurveyList[0].Get_Tower_Call_Number__c);

            Integer API_CALL_MAX_for_GET_TOWER = 3; //TODO : change this statement to get value from custom setting

            if (callNumber <= API_CALL_MAX_for_GET_TOWER) {
                        // call api to get tower candidates
                        REST_Presurvey_Callout.getTowerCandidates( presurveyId ); 
                }

        }
        */

        // call api to get tower candidates
        REST_Presurvey_Callout.getTowerCandidates( presurveyId );

    }        
}