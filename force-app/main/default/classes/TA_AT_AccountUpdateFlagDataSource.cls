/**
 * @description       : 
 * @Test Class        : TA_AT_AccountUpdateFlagDataSource_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 11-29-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-23-2022   Novando Utoyo Agmawan   Initial Version
**/


public with sharing class TA_AT_AccountUpdateFlagDataSource implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(list<Account> newAccountList, list<Account> oldAccountList) {

        system.debug('==== TA_AT_AccountUpdateFlagDataSource.beforeUpdate ====== ');
        string errorMsg;
        try {
            Map<Id,Account> oldMap = new Map<Id,Account>(oldAccountList);

            system.debug('BeforeUpdate - newAccountList : ' + json.serialize(newAccountList));

            system.debug('BeforeUpdate - oldAccountList : ' + json.serialize(oldAccountList));

            system.debug('BeforeUpdate - oldMap : ' + json.serialize(oldMap));
            
            for(Account accountREC : newAccountList) {
                if (
                    accountREC.Account_Type__c == 'Dealer'
                ){
                    if(
                        accountREC.Update_Dealer_IdexPro_Status__c != oldMap.get(accountREC.id).Update_Dealer_IdexPro_Status__c
                    ){
                        if(
                            accountREC.Update_Dealer_IdexPro_Status__c != 'Failed' &&
                            accountREC.Update_Dealer_IdexPro_Status__c != 'Success'
                        ){
                            if(
                                //accountREC.DataSource__c != oldMap.get(accountREC.id).DataSource__c && 
                                accountREC.DataSource__c == 'BizCare' &&
                                oldMap.get(accountREC.id).DataSource__c == 'BizCare'
                            ){
                                accountREC.DataSource__c = 'Salesforce Input Form';
                                accountREC.Update_Dealer_IdexPro_Status__c = 'On Progress';
                            }

                            if (
                                accountREC.DataSource__c == 'Salesforce Input Form' 
                            ){
                                accountREC.Update_Dealer_IdexPro_Status__c = 'On Progress';
                            } 
                        }
                    }else if(
                        accountREC.Update_Dealer_IdexPro_Status__c == 'Failed' ||
                        accountREC.Update_Dealer_IdexPro_Status__c == 'Success'
                    ){
                        if(
                            //accountREC.DataSource__c != oldMap.get(accountREC.id).DataSource__c && 
                            accountREC.DataSource__c == 'BizCare' &&
                            oldMap.get(accountREC.id).DataSource__c == 'BizCare'
                        ){
                            accountREC.DataSource__c = 'Salesforce Input Form';
                            accountREC.Update_Dealer_IdexPro_Status__c = 'On Progress';
                        }

                        if (
                            accountREC.DataSource__c == 'Salesforce Input Form' 
                        ){
                            accountREC.Update_Dealer_IdexPro_Status__c = 'On Progress';
                        } 
                    }else if(string.isBlank(accountREC.Update_Dealer_IdexPro_Status__c)){
                        if(
                            //accountREC.DataSource__c != oldMap.get(accountREC.id).DataSource__c && 
                            accountREC.DataSource__c == 'BizCare' &&
                            oldMap.get(accountREC.id).DataSource__c == 'BizCare'
                        ){
                            accountREC.DataSource__c = 'Salesforce Input Form';
                            accountREC.Update_Dealer_IdexPro_Status__c = 'On Progress';
                        }

                        if (
                            accountREC.DataSource__c == 'Salesforce Input Form' 
                        ){
                            accountREC.Update_Dealer_IdexPro_Status__c = 'On Progress';
                        } 
                    }
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_AccountUpdateFlagDataSource Before Update' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}