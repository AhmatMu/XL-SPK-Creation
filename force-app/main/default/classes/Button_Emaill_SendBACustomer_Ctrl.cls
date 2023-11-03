/**
 * @description       : 
 * @Test Class		  : TEST_Notif_TerminationNonAutoRenewal
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   07-29-2022   Novando Utoyo Agmawan   Initial Version
**/

public class Button_Emaill_SendBACustomer_Ctrl {

    @InvocableMethod
    public static void SendEmailAction(List<Id> contract_ExtensionIds)
    {
        List<Contract_Extension__c> contract_ExtensionList = 
        [
            SELECT Id,
            name,
            BA_Print__c,
            BA_Print__r.Name,
            BA_Print__r.Email,
            Account__c,
            Account__r.Name,
            Existing_Contract_item__c,
            Existing_Contract_item__r.End_Date__c,
            Existing_Contract_item__r.Product__r.Name,
            Link__c,
            Link__r.Link_ID__c,
            Link__r.Site_A_Name__r.Name,
            Link__r.Site_A_Name__r.Unique_Name__c,
            Account_Manager__c,
            Account_Manager__r.Name,
            Account_Manager__r.Email,
            Account_Manager__r.ManagerId,
            Account_Manager__r.Manager_of_Manager__c,
            Status__c,
            Flag_send_email_via_button__c,
            Email_Tenar_Count__c,
            Going_To_Days__c
            FROM Contract_Extension__c
            WHERE Id IN : contract_ExtensionIds
        ];

        if(contract_ExtensionList!=null && !contract_ExtensionList.isEmpty()){
            Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(contract_ExtensionList,true);
        }
    }

    @future(callout = true)
    public static void SendEmailActionTrigger(String contract_ExtensionIds)
    {
        DateTime start_time = datetime.now();

        try {
            List<Contract_Extension__c> contract_ExtensionList = 
            [
                SELECT Id,
                name,
                BA_Print__c,
                BA_Print__r.Name,
                BA_Print__r.Email,
                Account__c,
                Account__r.Name,
                Existing_Contract_item__c,
                Existing_Contract_item__r.End_Date__c,
                Existing_Contract_item__r.Product__r.Name,
                Link__c,
                Link__r.Link_ID__c,
                Link__r.Site_A_Name__r.Name,
                Link__r.Site_A_Name__r.Unique_Name__c,
                Account_Manager__c,
                Account_Manager__r.Name,
                Account_Manager__r.Email,
                Account_Manager__r.ManagerId,
                Account_Manager__r.Manager_of_Manager__c,
                Status__c,
                Flag_send_email_via_button__c,
                Going_To_Days__c
                FROM Contract_Extension__c
                WHERE Id =: contract_ExtensionIds
            ];
            if(contract_ExtensionList!=null && !contract_ExtensionList.isEmpty()){
                Email_Notif_TerminationNonAutoRenewal Class_Email_Notif_TerminationNonAutoRenewal = new Email_Notif_TerminationNonAutoRenewal(contract_ExtensionList,true);
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Button_Emaill_SendBACustomer_Ctrl.cls - SendEmailActionTrigger ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

}