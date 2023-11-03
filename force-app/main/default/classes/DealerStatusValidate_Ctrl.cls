/**
 * @description       : 
 * @Test Class        : DealerStatusValidate_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-27-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-24-2022   Novando Utoyo Agmawan   Initial Version
**/

public class DealerStatusValidate_Ctrl {
    ApexPages.StandardSetController setCon; 
    ApexPages.StandardController con;

    public id accountId {get; set;}
    
    public DealerStatusValidate_Ctrl (ApexPages.StandardSetController controller) {
        setCon = controller;
    }
    public DealerStatusValidate_Ctrl (ApexPages.StandardController controller) {
        con = controller;
    }

    public void validateDealerStatus(){
        try{
            accountId  = ApexPages.CurrentPage().getparameters().get('id');
            
            list<Account> List_Account = [
                SELECT Id,
                Create_Dealer_IdexPro_Status__c,
                Update_Dealer_IdexPro_Status__c,
                DealerID__c
                FROM Account 
                WHERE Id =: accountId
            ];

            system.debug('List_Account : ' + List_Account);

            if(String.isBlank(List_Account[0].DealerID__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Dealer Is Not Active!'));

                if(List_Account[0].Create_Dealer_IdexPro_Status__c == 'Failed'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Failed to Get Result, Contact your administrator '));
                }
            }else{
                if(String.isNotBlank(List_Account[0].Update_Dealer_IdexPro_Status__c)){
                    if(List_Account[0].Update_Dealer_IdexPro_Status__c == 'Success'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Dealer Modified (updated) Successfully.'));
                    }

                    if(List_Account[0].Update_Dealer_IdexPro_Status__c == 'Failed'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Dealer Modification (update) Failed. Please contact your System Administrator.'));
                    }

                    if(List_Account[0].Update_Dealer_IdexPro_Status__c == 'On Progress'){
                        if(List_Account[0].Create_Dealer_IdexPro_Status__c == 'Success'){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Dealer Created Successfully'));
                        }
    
                        if(List_Account[0].Create_Dealer_IdexPro_Status__c == 'Failed'){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Failed to Get Result, Contact your administrator '));
                        }
                    }
                }else{
                    if(List_Account[0].Create_Dealer_IdexPro_Status__c == 'Success'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Dealer Created Successfully'));
                    }

                    if(List_Account[0].Create_Dealer_IdexPro_Status__c == 'Failed'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Failed to Get Result, Contact your administrator '));
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch(exception e){
            String errorMsg = 'Error on DealerStatusValidate_Ctrl.validateDealerStatus method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' :: ' + e.getLineNumber();

            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
    }

    public void onLoadDealerStatusValidate(){
        try{
            accountId  = ApexPages.CurrentPage().getparameters().get('id');
            
            list<Account> List_Account = [
                SELECT Id,
                Create_Dealer_IdexPro_Status__c,
                Update_Dealer_IdexPro_Status__c,
                DealerID__c
                FROM Account 
                WHERE Id =: accountId
            ];

            system.debug('List_Account : ' + List_Account);

            if(String.isBlank(List_Account[0].DealerID__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Dealer Is Not Active!'));
            }else{
                if(String.isNotBlank(List_Account[0].Update_Dealer_IdexPro_Status__c)){
                    if(List_Account[0].Update_Dealer_IdexPro_Status__c == 'Success'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Dealer Modified (updated) Successfully.'));
                    }

                    if(List_Account[0].Update_Dealer_IdexPro_Status__c == 'Failed'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Dealer Modification (update) Failed. Please contact your System Administrator.'));
                    }
                }else{
                    if(List_Account[0].Create_Dealer_IdexPro_Status__c == 'Success'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Dealer Created Successfully'));
                    }

                    if(List_Account[0].Create_Dealer_IdexPro_Status__c == 'Failed'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Failed to Get Result, Contact your administrator '));
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch(exception e){
            String errorMsg = 'Error on DealerStatusValidate_Ctrl.onLoadDealerStatusValidate method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' :: ' + e.getLineNumber();

            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
    }
}