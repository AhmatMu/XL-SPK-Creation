/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 09-11-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-11-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class TEST_CallCSRegComplete_Schdler {
    
    static testmethod void CRUD1(){
        Id newRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('New').getRecordTypeId();

        Customer_Registration_Ticket__c customerRegistrationTicket = new Customer_Registration_Ticket__c();
        customerRegistrationTicket.RecordTypeId = newRecordTypeId;
        customerRegistrationTicket.Company_Type__c = 'new';
        customerRegistrationTicket.Company_Name__c = 'Test Admin Novando';
        customerRegistrationTicket.Stage__c = 'New';
        customerRegistrationTicket.BP_Number__c = '111';
        customerRegistrationTicket.Personal_Last_Name__c = 'Test Admin Novando';
        insert customerRegistrationTicket;

        Test.StartTest();
        CallCSRegComplete_Schdler CallCSRegComplete = new CallCSRegComplete_Schdler(customerRegistrationTicket.Id,'marketplace'); 
        String nextFireTime = '0 0 23 * * ?'; 
        System.schedule('CallCSRegComplete_Schdler ' + String.valueOf(system.now()), nextFireTime, CallCSRegComplete);
        Test.stopTest(); 
    }
    
}