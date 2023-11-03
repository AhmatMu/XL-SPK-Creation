/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-07-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-07-2022   Novando Utoyo Agmawan   Initial Version
**/

public class NewProductOnboardingService_Batch implements Database.Batchable<SObject>, Database.Stateful {
    private String stringVariable;
    
    public NewProductOnboardingService_Batch(String passedString) {
        stringVariable = passedString;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String ticketProductList = 
        'SELECT id, ' +  
        'Name ' +
        'FROM NPRTicketProduct__c ' +  
        'WHERE New_Product_Registration_Ticket__c =: stringVariable'
        ;
        return Database.getQueryLocator(ticketProductList);
    }
    
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (SObject s : scope) {
            system.debug(s);
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('stringVariable: '+ stringVariable);
    }

}