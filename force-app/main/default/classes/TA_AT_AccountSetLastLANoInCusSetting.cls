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
public with sharing class TA_AT_AccountSetLastLANoInCusSetting implements TriggerAction.BeforeInsert {

    public void beforeInsert (list<Account> newAccountList) {
    
    
        system.debug('==== TA_AT_AccountSetLastLANoInCusSetting.beforeInsert ====== ');
        string errorMsg;
        try {

            Transaction__c transactionSettREC = Transaction__c.getOrgDefaults();
            for(Account accountREC : newAccountList) {
                if (accountREC.Account_Type__c != 'BP' 
                        && accountREC.Account_type__c != null 
                        && accountREC.Account_type__c != '') { 
                    
                    accountREC.Temporary_LA_or_IDCom__c = String.valueof(transactionSettREC.Temporary_LA_or_IDCom__c);  //'01234567';
                    transactionSettREC.Temporary_LA_or_IDCom__c = transactionSettREC.Temporary_LA_or_IDCom__c + 1;
                    update transactionSettREC;
                    
                }
            }
        }

        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_AccountSetLastLANoInCusSetting Before Insert' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
              apputils.puterror(errorMsg);
              SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

    }

}