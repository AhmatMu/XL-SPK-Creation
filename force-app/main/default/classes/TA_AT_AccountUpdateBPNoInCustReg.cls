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
public with sharing class TA_AT_AccountUpdateBPNoInCustReg implements TriggerAction.AfterUpdate {
    public void afterUpdate (list<Account> newAccountList, list<Account> oldAccountList) {

        system.debug('==== TA_AT_AccountUpdateBPNoInCustReg.afterUpdate ====== ');
        string errorMsg;
        try {
            
            Map<Id, Account> oldMap = new Map<Id, Account>(oldAccountList);
            for(Account newAccountREC : newAccountList) {
                //-- get OlD Account Record
                Account oldAccountREC = oldMap.get( newAccountREC.id );
                    
                //-- This is for handling after Call API to SAP for BP Creation in Customer Registration "Complete" status
                //-- This event is after Update/isChange the BP_Number field (from api bp creation response)
                //-- All actions only for Account that create from "Customer Registration"
                if ( oldAccountREC.Bp_Number__c != newAccountREC.Bp_Number__c 
                    && ( newAccountREC.Bp_Number__c != '' || newAccountREC.BP_Number__c != null ) 
                    && ( newAccountREC.Field_Source__c == 'Bizstore Customer Registration' 
                            || newAccountREC.Field_Source__c == 'Bizcare Customer Registration'
                       ) 
                    && newAccountREC.Bizstore_Complete__c == false ) 
                
                {
                    List<Customer_Registration_Ticket__c> customerRegistrationTicket = [
                        SELECT Id, 
                            Bizstore_Complete__c, 
                            Account__c, 
                            BP_Number__c
                        FROM CUSTOMER_REGISTRATION_TICKET__C 
                        WHERE Company_Type__c =: 'new' 
                            AND Bizstore_Complete__c =: false 
                            AND Account__c =: newAccountREC.Id 
                            AND Stage__c =: 'Complete'
                    ];
                    
                    if(customerRegistrationTicket != null && !customerRegistrationTicket.isEmpty()) {
                        customerRegistrationTicket[0].BP_Number__c = newAccountREC.BP_Number__c;
                        customerRegistrationTicket[0].Bizstore_Complete__c = True;
                    }


                    update customerRegistrationTicket;
                }
            }
        }

        catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_AccountUpdateBPNoInCustReg After Update' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}