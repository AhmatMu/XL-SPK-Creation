/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 21-03-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   09-03-2022   Doddy Prima   Initial Version
**/
global with sharing class Schedule_Send_BA_Immediately implements Schedulable{
    public ID opportunityID = null;    

    //-- constructor method
    public Schedule_Send_BA_Immediately (ID opportunityID) {
        this.opportunityID = opportunityID;
    }

    global void execute(SchedulableContext sc) {        
        if (opportunityID <> null && !test.isrunningtest()) {
            //-- send email for BA
            SendWBAUtils.futuresendemail(opportunityID);    
        }
    }
}