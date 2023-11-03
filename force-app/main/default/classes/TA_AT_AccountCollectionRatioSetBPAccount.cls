/*-----------------------------------------------------------------------------------------------------------//
* Class Name	: TA_AT_AccountCollectionRatioSetBPAccount
* Author		: ahmat zulkifli murad <ahmat.murad@saasten.com>
* Date			: 10 / 09 / 2022
* Description	: Description of the class
*
* Changes (version)
* -------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	-----------------------------------
* @version		1.0		2022-09-10		ahmat zulkifli murad	Created
* 
*-----------------------------------------------------------------------------------------------------------*/
/*
menggunakan metode Trigger Action guna melihat detail automation per event action pada object check url di bawah
untuk penggunaan bisa mengikuti metode di bawah
https://github.com/mitchspano/apex-trigger-actions-framework
*/
public with sharing class TA_AT_AccountCollectionRatioSetBPAccount implements TriggerAction.BeforeInsert {
    public void beforeInsert(list<Account_Collection_Ratio__c> newAccountCollectionRatioList){

        system.debug('==== TA_AccountCollectionRatio_SetBPAccount.beforeInsert ====== ');
        string errorMsg;
        
        try{
            set < String > accountBPInvoiceSet = new Set < String > ();

            for(Account_Collection_Ratio__c accountCollectoinRatioRec : newAccountCollectionRatioList){
                accountBPInvoiceSet.add(accountCollectoinRatioRec.BP_Invoice_LA_Number__c);
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
                if(accountCollectoinRatioRec.BP_Invoice__c == null){
                    accountBPNumber = accountCollectoinRatioRec.BP_Invoice_LA_Number__c;
                    accountObj = accountBPInvoiceMap.get(accountBPNumber);

                    system.debug(' == accountObj : ' + accountObj);
                    system.debug(' == accountObj.id : ' + accountObj.id);
                    system.debug(' == accountObj.ParentId : ' + accountObj.ParentId);
                    system.debug(' == accountObj.parent.OwnerId : ' + accountObj.parent.OwnerId);
                    system.debug(' == accountObj.Sales_Person__c : ' + accountObj.parent.OwnerId);

                    if(accountObj <> null){
                        if(accountObj.Organization_Type__c == 'Head Office'){
                            if(accountObj.id != null){
                                accountCollectoinRatioRec.BP_Invoice__c = accountObj.id;
                                accountCollectoinRatioRec.BP_HO__c = accountObj.id;
                            }
                            if(accountObj.OwnerId != null){
                                accountCollectoinRatioRec.ownerid = accountObj.OwnerId;
                            }
                            if(accountObj.OwnerId != null){
                                accountCollectoinRatioRec.Sales_Person__c = accountObj.OwnerId;
                            }
                            if(accountObj.Owner.Employee_ID__c != null){
                                accountCollectoinRatioRec.sales_employee_id__c = accountObj.Owner.Employee_ID__c;
                            }
                            
                        }else{

                            if(accountObj.id != null){
                                accountCollectoinRatioRec.BP_Invoice__c = accountObj.id;
                            }
                            if(accountObj.ParentId != null){
                                accountCollectoinRatioRec.BP_HO__c = accountObj.ParentId;
                            }
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
          errorMsg = errorMsg +  '. Error on TA_AT_AccountCollectionRatioSetBPAccount Before Insert' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}