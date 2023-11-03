/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 01-10-2023
 * @last modified by  : Diky Nurosid
**/
@isTest
public class SoqlHelperTest {
    @testSetup
    public static void setup() {
        Transaction__c TCObj = new Transaction__c(
            TransactionID__c = 1
        );
        insert TCObj;
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account AccObj = new Account(
            Name = 'CODENUSA2', // Account Name
            Organization_Type__c = 'Head Office', //
            RecordTypeId = RecordTypeAccId,              // Account Record Type
            Record_Type_Custom__c = 'BP',            // Record Type Custom
            Bizstore_Complete__c = false,            // Bizstore Completex
            Payer_For_GSM_Invoice__c = false,        // Payer For GSM Invoice
            Summary_Billing__c = false,              // Summary Billing
            Using_HO_Billing_Address__c = false     // Using HO Billing Address
        );
        insert AccObj;
    }

    @isTest
    public static void testSoqlHelper() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name ='CODENUSA2'];
        Set<Id> recordIds = new Set<Id>();
        recordIds.add(acc.Id);
        SoqlHelper.getRecordListWithAllFieldsByIds(recordIds, 'Account');
    }
}