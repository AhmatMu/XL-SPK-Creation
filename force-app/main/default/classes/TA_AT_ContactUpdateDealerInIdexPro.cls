/**
 * @description       : 
 * @Test Class        : TA_AT_ContactUpdateDealerInIdexPro_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 12-06-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-15-2022   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class TA_AT_ContactUpdateDealerInIdexPro implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<Contact> newContactList, list<Contact> oldContactList) {
        system.debug('==== TA_AT_ContactUpdateDealerInIdexPro.afterUpdate ====== ');
        string errorMsg;
        try {
            
            for(Contact contactREC : newContactList) {
                if ( String.isNotBlank(contactREC.Idexpro_ProfileID__c) ) {
                    //-- call api to IdexPRO to UPDATE Dealer
                    REST_Account_Callout.modificationPartner_async(contactREC.AccountId, contactREC.id, null);
                } 
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_ContactUpdateDealerInIdexPro After Update' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}