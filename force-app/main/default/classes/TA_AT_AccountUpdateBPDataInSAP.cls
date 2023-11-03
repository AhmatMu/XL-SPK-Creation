/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 27-09-2022
 * @last modified by  : Doddy Prima 
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   27-09-2022   Doddy Prima   Initial Version
**/
public with sharing class TA_AT_AccountUpdateBPDataInSAP implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<Account> newAccountList, list<Account> oldAccountList) {

        system.debug('==== TA_AT_AccountUpdateBPDataInSAP.afterInsert ====== ');
        string errorMsg;
        try {
            
            for(Account accountREC : newAccountList) {

            }
        }

        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_AccountUpdateBPDataInSAP After Update' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
              apputils.puterror(errorMsg);
              SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}