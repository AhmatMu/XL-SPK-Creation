/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 28-09-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   27-09-2022   Doddy Prima   Initial Version
**/
public with sharing class TA_AT_AccountUpdateTempLAInEasyOps implements TriggerAction.AfterInsert {
    public void afterInsert (list<Account> newAccountList) {
    
    
        system.debug('==== TA_AT_AccountUpdateTempLAInEasyOps.afterInsert ====== ');
        string errorMsg;
        try {
            
            for(Account accountREC : newAccountList) {
                if ( accountREC.Account_Type__c == 'LA' 
                        || accountREC.Account_Type__c == 'ID Com' //TODO : make sure, confirmation to xl: update to easyops onl LA or ID COM too ?
                    ) {
                    
                    //-- call api to EasyOps to update temporary LA if any account created with RT is LA / ID Com ??
                    updateTemporaryLa.updateTemporaryLa( String.valueof(accountREC.id) );
                } 
            }
        }

        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_AccountUpdateTempLAInEasyOps After Insert' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

    }
}