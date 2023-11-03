/*-----------------------------------------------------------------------------------------------------------//
* Class Name	: OpptyValidateAccountBadDebt_Controller
* Author		: ahmat zulkifli murad <ahmat.murad@saasten.com>
* Date			: 10 / 09 / 2022
* Description	: Description of the class
* test class    : OpptyValidateAccountBadDebt_Cont_Test
*
* Changes (version)
* -------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	-----------------------------------
* @version		1.0		2022-09-10		ahmat zulkifli murad	Created
* 
*-----------------------------------------------------------------------------------------------------------*/
public class OpptyValidateAccountBadDebt_Controller {
    ApexPages.StandardSetController setCon; 
    ApexPages.StandardController con;

   // public list<string> AccountBPNumbers {get;set;}
	public list<id> AccountIds {get;set;}
    public id accountid {get; set;}
	public id OpportunityId {get;set;}
    public string AccountName {get;set;}
    public string AccountBadDebtStatus {get;set;} 
    public List<invoice__c> invoiceNewList {get;set;}
    public dateTime BadDebtLastCheckingDateTime {get;set;}
    public set<string> accountBpNumbers = new set <string>();
    //public string dateformat = BadDebtLastCheckingDateTime.format('dd mmm yyyy HH:mm:ss ');
    public string BadDebtLastCheckingDateTimeFormat {get;set;}
    string errorMsg;
    String responseMsg;
    
    public OpptyValidateAccountBadDebt_Controller (ApexPages.StandardSetController controller) {
        setCon = controller;

    }
    public OpptyValidateAccountBadDebt_Controller (ApexPages.StandardController controller) {
        con = controller;
        //validateOpptyAccountBadDebt();
    }

    public void validateOpptyAccountBadDebt(){

        try{
            OpportunityId  = ApexPages.CurrentPage().getparameters().get('id');
            
            list<opportunity> opportunityList = [SELECT Id, AccountId, Account.name, account.bp_number__c, Account_BP_No__c, account.Bad_Debt_Last_Checking_Date__c,account.BP_LA_Number__c, RecordTypeId, Name, StageName, Amount, Probability, CloseDate FROM Opportunity WHERE Id = :OpportunityId and AccountId != null and account.bp_number__c != null];
            SYSTEM.debug('opportunityList >>'+ opportunityList );

            for(Opportunity opptyRec : opportunityList){
                AccountId = opptyRec.AccountId;
                accountBpNumbers.add(opptyRec.Account_BP_No__c);
                if(opptyRec.account.Bad_Debt_Last_Checking_Date__c != null){
                    BadDebtLastCheckingDateTime = opptyRec.account.Bad_Debt_Last_Checking_Date__c ;
                    string dateformat = BadDebtLastCheckingDateTime.format('dd MMMMMMM yyyy HH:mm:ss ');
                    BadDebtLastCheckingDateTimeFormat = dateformat;
                    system.debug(' == opptyRec.Account_BP_No__c >  '+ opptyRec.Account_BP_No__c);
                   
                }
            }
            
            system.debug(' == accountBpNumbers >  '+  accountBpNumbers);
            list<account> accountList = REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestSync(accountBpNumbers);

            for(account accountRec :accountList){
                AccountBadDebtStatus = accountRec.bad_debt_status__c;
                BadDebtLastCheckingDateTime = accountRec.Bad_Debt_Last_Checking_Date__c;
                accountBpNumbers.add(accountRec.bp_number__c);
                if(accountRec.Bad_Debt_Last_Checking_Date__c != null){
                    string dateformat = BadDebtLastCheckingDateTime.format('dd MMMMMMM yyyy HH:mm:ss ');
                    BadDebtLastCheckingDateTimeFormat = dateformat;
                    
                }
            } 
            
            if(AccountBadDebtStatus == 'True'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Your Account has Bad Debt!'));
            }else if(AccountBadDebtStatus == 'false'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Your Account has NO Bad Debt, Please Continue.'));
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Failed to Get Result, Contact your administrator '));
            }

            SYSTEM.debug('accountids >> ' + AccountIds);

            invoiceNewList= [SELECT Invoice_Number__c, Total_Amount__c, Status__c, Invoice_Date__c FROM Invoice__c where Status__c = 'unpaid' and BillingAccountId__c =:AccountId];
            system.debug(' >> invoiceNewList :' + invoiceNewList);
            
        }catch(exception e){
            errorMsg = errorMsg + '. Error on REST_CheckAccountBadDebt_Callout.checkAccountBadDebt method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' ' + responseMsg + '::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
    }

    public void onLoadOpptyAccountBadDebt(){

        try{
            OpportunityId  = ApexPages.CurrentPage().getparameters().get('id');
            
            list<opportunity> opportunityList = [SELECT Id, AccountId, Account.name, account.bp_number__c, Account_BP_No__c, account.Bad_Debt_Last_Checking_Date__c, account.BP_LA_Number__c, account.Bad_Debt_Status__c, RecordTypeId, Name, StageName, Amount, Probability, CloseDate FROM Opportunity WHERE Id = :OpportunityId and AccountId != null and account.bp_number__c != null];
            SYSTEM.debug('opportunityList >>'+ opportunityList );

            for(Opportunity opptyRec : opportunityList){
                AccountId = opptyRec.AccountId;
                AccountName = opptyRec.Account.name;
                accountBpNumbers.add(opptyRec.account.bp_number__c);
                AccountBadDebtStatus = opptyRec.Account.Bad_Debt_Status__c;
                if(opptyRec.account.Bad_Debt_Last_Checking_Date__c != null){
                    BadDebtLastCheckingDateTime = opptyRec.account.Bad_Debt_Last_Checking_Date__c ;
                    string dateformat = BadDebtLastCheckingDateTime.format('dd MMMMMMM yyyy HH:mm:ss ');
                    BadDebtLastCheckingDateTimeFormat = dateformat;
                }

            }
            
            
            if(AccountBadDebtStatus == 'True'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Your Account has Bad Debt!'));
            }else if(AccountBadDebtStatus == 'false' ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Your Account has NO Bad Debt, Please Continue.'));
            }else if(AccountBadDebtStatus == '' || AccountBadDebtStatus == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Validate Your account first, Check Now'));
            }

            SYSTEM.debug('accountids >> ' + AccountIds);

            invoiceNewList= [SELECT Invoice_Number__c, Total_Amount__c, Status__c, Invoice_Date__c FROM Invoice__c where Status__c = 'unpaid' and BillingAccountId__c =:AccountId];
            system.debug(' >> invoiceNewList :' + invoiceNewList);
            
        }catch(exception e){
            errorMsg = errorMsg + '. Error on REST_CheckAccountBadDebt_Callout.checkAccountBadDebt method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' ' + responseMsg + '::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
    }

    public list<invoice__c>  getInvoice () {
        
        system.debug ('this.invoiceNewList : ' + this.invoiceNewList);
        return this.invoiceNewList;
    }
}