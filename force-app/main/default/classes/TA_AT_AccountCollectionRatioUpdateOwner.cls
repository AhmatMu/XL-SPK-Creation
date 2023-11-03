/*-----------------------------------------------------------------------------------------------------------//
* Class Name	: TA_AT_AccountCollectionRatioUpdateOwner
* Author		: ahmat zulkifli murad <ahmat.murad@saasten.com>
* Date			: 10 / 09 / 2022
* Description	: Description of the class
*
* Changes (version)
* -------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	-----------------------------------
* @version		1.0		2022-09-21		ahmat zulkifli murad	Created
* 
*-----------------------------------------------------------------------------------------------------------*/

global with sharing class TA_AT_AccountCollectionRatioUpdateOwner implements TriggerAction.BeforeUpdate {

    public void beforeUpdate(list<Account_Collection_Ratio__c> newAccountCollectionRatioList, list<Account_Collection_Ratio__c> oldAccountCollectionRatioList){
        system.debug('==== TA_AT_AccountCollectionRatioUpdateOwner.beforeUpdate ====== ');
        string errorMsg;
        
        try{

            id accCollRatioId;

            set < String > accountBPInvoiceSet = new Set < String > ();
            map<id, Account_Collection_Ratio__c> AccCollRatioNewMap = new map<id, Account_Collection_Ratio__c>(newAccountCollectionRatioList);

            for(Account_Collection_Ratio__c accountCollectoinRatioRec : newAccountCollectionRatioList){
                accountBPInvoiceSet.add(accountCollectoinRatioRec.BP_Invoice_LA_Number__c);
                accCollRatioId = accountCollectoinRatioRec.id;
                system.debug(' == accountBPInvoiceSet : ' + accountBPInvoiceSet);
            }
            
            list<Account> accountBPInvoiceList = new List<account>();
            system.debug(' == accountBPInvoiceSet : ' +  accountBPInvoiceSet);
            if(accountBPInvoiceSet != null){
                accountBPInvoiceList = [select id, Organization_Type__c, OwnerId, Owner.Employee_ID__c, parentid, parent.ownerid, parent.owner.Employee_ID__c, BP_Number__c, BP_LA_Number__c from account where BP_LA_Number__c in:accountBPInvoiceSet];
                system.debug(' == accountBPInvoiceList : ' + accountBPInvoiceList);
            }

            Map<String, Account> accountBPInvoiceMap = new Map<String, Account>();
            for(Account accountbpInvoiceRec :accountBPInvoiceList){
                accountBPInvoiceMap.put(accountbpInvoiceRec.BP_LA_Number__c, accountbpInvoiceRec);
                system.debug( ' == accountBPInvoiceMap : ' + accountBPInvoiceMap);
            }

            for(account_collection_Ratio__c accountCollectoinRatioRec : newAccountCollectionRatioList){
                account accountObj = new account();
                string accountBPNumber = '';

                system.debug(' == accountCollectoinRatioRec.BP_Invoice__c :  ' + accountCollectoinRatioRec.BP_Invoice__c);
                if(accountCollectoinRatioRec.BP_Invoice__c != null){
                    accountBPNumber = accountCollectoinRatioRec.BP_Invoice_LA_Number__c;
                    accountObj = accountBPInvoiceMap.get(accountBPNumber);

                    //system.debug(' == accountObj.id : ' + accountObj.id);
                    system.debug(' == AccCollRatioNewMap.get(accCollRatioId).ownerid) : ' + AccCollRatioNewMap.get(accCollRatioId).ownerid);
                    system.debug(' == accountObj.parent.OwnerId : ' + accountObj.parent.OwnerId);
                    system.debug(' == accountObj.OwnerId : ' + accountObj.OwnerId);
                    system.debug(' == accountObj.OwnerId != AccCollRatioNewMap.get(accCollRatioId).ownerid : ' + AccCollRatioNewMap.get(accCollRatioId).ownerid);

                    if(accountObj <> null){
                        if(accountObj.Organization_Type__c == 'Head Office' && accountObj.OwnerId != AccCollRatioNewMap.get(accCollRatioId).ownerid){
                           
                            if(accountObj.OwnerId != null){
                                accountCollectoinRatioRec.ownerid = accountObj.OwnerId;
                            }
                            if(accountObj.OwnerId != null){
                                accountCollectoinRatioRec.Sales_Person__c = accountObj.OwnerId;
                            }
                            if(accountObj.Owner.Employee_ID__c != null){
                                accountCollectoinRatioRec.sales_employee_id__c = accountObj.Owner.Employee_ID__c;
                            }
                            
                        }else if(accountObj.OwnerId != AccCollRatioNewMap.get(accCollRatioId).ownerid){

                            if(accountObj.parent.OwnerId != null){
                                accountCollectoinRatioRec.ownerid = accountObj.parent.OwnerId;
                            }
                            if(accountObj.parent.OwnerId != null){
                                accountCollectoinRatioRec.Sales_Person__c = accountObj.parent.OwnerId;
                            }
                            if(accountObj.parent.Owner.Employee_ID__c != null){
                                accountCollectoinRatioRec.sales_employee_id__c = accountObj.parent.Owner.Employee_ID__c;
                            }
                        }
                    }
                }
            }
           
        }catch(Exception e){
          errorMsg = errorMsg +  '. Error on TA_AT_AccountCollectionRatioUpdateOwner Before beforeUpdate' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}