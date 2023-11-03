@isTest(seealldata=true)
private class Test_Trigger_AccountContactRelationship {
    static testMethod void myUnitTest1() {
        Test.startTest();
        
        RecordType rt=[SELECT id FROM RecordType WHERE Name='BP' LIMIT 1];


        Account accountObj = new Account(
            Name = 'PT Sumber Solusindo Hitech',                // Account Name
            RecordTypeId = rt.id,                           // Account Record Type
            BP_Number__c = '715853',                              // BP Number
            Organization_Type__c = 'Head Office',                 // Organization Type
            Type = 'Customer',                                    // Type
            Unique_Name__c = 'Jakarta Moh Mansyur',               // Unique Name
            Keyword__c = 'SUMBERSOLUSINDO',                       // Keyword
            Customer_Type__c = 'NONGSM',                          // Customer Type
            Payer_For_GSM_Invoice__c = false,                     // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',   // Term of Payment
            Company_Group__c = 'PT Sumber Solusindo Hitech',      // Company_Group
            Customer_VAT_Name__c = 'PT Sumber Solusindo Hitech',  // Customer VAT Name
            Summary_Billing__c = false,                           // Summary Billing
            Using_HO_Billing_Address__c = false,                  // Using HO Billing Address
            No_NPWP__c = '015966120029000',                       // No NPWP
            No_SIUP__c = '77/24.1PM.1/31.71/-1.824.27/e/2017',    // No SIUP
            No_TDP__c = '09.05.1.46.57372',                       // No TDP
            No_Akta__c = '09.05.1.46.57372'                      // No Akta
            );
        insert accountObj;

        Contact contactObj = new Contact(
            lastName = 'bro',
            AccountId = accountObj.id,               // Account Name
            ReportsToId = null,                      // Reports To
            Title = 'Head SDP & OM CPE',             // Title
            Department = null,                       // Department
            Email = 'hentry@janganpernahnyerah.co.id',  // Email
            Fax = null,                              // Fax
            Phone = '0210212100',                // Phone
            MobilePhone = '081789721239',            // Mobile
            datacode__c = null,                      // datacode
            PIC_ID__c = null                        // PIC ID
            );
        insert contactObj;

        AccountContactRelation acrObj = [select id, Roles from AccountContactRelation where ContactId =:contactObj.id ];
        acrObj.Roles = 'PIC Recipient Invoice#0018#2;PIC BA Print#0017#0;PIC Print Invoice#0020#1';
        update acrObj;

        /*
        AccountContactRelation acrObj = new AccountContactRelation (
            AccountId  = accountObj.id,
            //IsActive = true,
            ContactId = contactObj.id,
            Roles = 'PIC Recipient Invoice#0018#2;PIC BA Print#0017#0;PIC Print Invoice#0020#1'

        );
        insert acrObj;
        */

        Test.stopTest();
    }
}