/**
 * @description       : 
 * @author            : Ahmad Aulia Fahmi
 * @group             : 
 * @last modified on  : 07-27-2023
 * @last modified by  : Ahmat Zulkifli Murad
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   06-06-2023   Ahmad Aulia Fahmi       Initial Version
 * 1.1   21-06-2023   Ahmad Aulia Fahmi       Update Template CSV
 * 1.2   22-06-2023   Ahmad Aulia Fahmi       Enhancement From Updated Field Object Candidate Tower
**/

public with sharing class Schedule_PresurveyCapacity implements Schedulable{
    
    public void execute(SchedulableContext sc){
        
        PresurveyService.sendEmailForCapacityAsessment(null); // using parameter Date, fill null in the schedlue, fill datetime.newinstances(int year, int month, int date); if want execute in anonymous
    }
}