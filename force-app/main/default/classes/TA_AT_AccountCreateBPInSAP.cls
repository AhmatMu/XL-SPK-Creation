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
public with sharing class TA_AT_AccountCreateBPInSAP implements TriggerAction.AfterInsert {
    public void afterInsert (list<Account> newAccountList) {
    
    
        system.debug('==== TA_AT_AccountCreateBPInSAP.afterInsert ====== ');
        string errorMsg;
        try {
            
            for(Account accountREC : newAccountList) {
                if ( accountREC.Account_Type__c == 'BP' ) {
                    
                    //-- call api to SAP to CREATE BP
                    if (test.isrunningtest() ) {  //TODO : remove condition for isrunningtest!! 
                        HitsapComDocumentSapSoap.InsertAccount2(String.valueof(accountREC.id)); 
                    }
                } 
            }
        }

        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_AccountCreateBPInSAP After Insert' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

    }
}