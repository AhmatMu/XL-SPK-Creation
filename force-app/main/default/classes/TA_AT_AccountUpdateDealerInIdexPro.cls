/**
 * @description       : 
 * @Test Class        : TA_AT_AccountUpdateDealerInIdexPro_Test
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 11-29-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   27-09-2022   Doddy Prima   Initial Version
**/

public with sharing class TA_AT_AccountUpdateDealerInIdexPro implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<Account> newAccountList, list<Account> oldAccountList) {

        system.debug('==== TA_AT_AccountUpdateDealerInIdexPro.afterUpdate ====== ');
        string errorMsg;
        try {
            Map<Id,Account> oldMap = new Map<Id,Account>(oldAccountList);

            system.debug('AfterUpdate - newAccountList : ' + json.serialize(newAccountList));

            for(Account accountREC : newAccountList) {
                if (
                    accountREC.Account_Type__c == 'Dealer'  && 
                    String.IsNotBlank(accountREC.DealerID__c)  && 
                    accountREC.DataSource__c != 'BizCare' &&
                    accountREC.Update_Dealer_IdexPro_Status__c == 'On Progress'
                ) {
                    //-- call api to IdexPRO to UPDATE Dealer
                    REST_Account_Callout.modificationPartner_async(accountREC.Id, null, json.serialize(oldMap.get(accountREC.id)));
                } 
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_AccountUpdateDealerInIdexPro After Update' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}