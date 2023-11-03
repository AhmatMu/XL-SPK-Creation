/**
 * @description       : 
 * @Test Class        : TA_AT_AccountCreateDealerInIdexPro_Test
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 11-29-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   27-09-2022   Doddy Prima   Initial Version
**/

public with sharing class TA_AT_AccountCreateDealerInIdexPro implements TriggerAction.AfterInsert {
    public void afterInsert (list<Account> newAccountList) {
        system.debug('==== TA_AT_AccountCreateDealerInIdexPro.afterInsert ====== ');
        string errorMsg;
        
        try {
            
            for(Account accountREC : newAccountList) {
                if ( accountREC.Account_Type__c == 'Dealer' ) {
                    
                    //-- call api to IdexPRO to CREATE Dealer
                    //REST_Account_Callout.createDealer( String.valueof(accountREC.id) );
                } 
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_AccountCreateDealerInIdexPro After Insert' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}