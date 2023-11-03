/**
 * this test class for : AddDeleteNewLinkOppToSalesRevenueAction
 */
@isTest
private class AddDeleteNewLinkOppToSRVActionTEST {


    static testMethod void methodName(){
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account accObj = new Account(
            Name = 'PT Teknologi Perdana Indonesia',                // Account Name
            RecordTypeId = RecordTypeAccId,                               // Account Record Type
            BP_Number__c = '752858',                                  // BP Number
            Organization_Type__c = 'Head Office',                     // Organization Type
            Type = 'Customer',                                        // Type
            Unique_Name__c = 'Jakarta Wisma NH',                      // Unique Name
            Keyword__c = 'TEKPEI',                                    // Keyword
            Customer_Type__c = 'NONGSM',                              // Customer Type
            Payer_For_GSM_Invoice__c = false,                         // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',       // Term of Payment
            Company_Group__c = 'TEKNOLOGI PERDANA',                   // Company_Group
            Customer_VAT_Name__c = 'PT Teknologi Perdana Indonesia',  // Customer VAT Name
            Summary_Billing__c = false,                               // Summary Billing
            Using_HO_Billing_Address__c = false                      // Using HO Billing Address
        );
        insert accObj;

        //Create Product
        Product2 productObj = new Product2(Name = 'Mincom VoIP - Rp 15,000,000', Family = 'NGSM', productcode = 'VOIP', Revenue_Type__c = 'Recurring');
        Insert productObj;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );

        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Pricebook2 voipPricebook = new Pricebook2( name = 'VoIP',
            IsActive = true
        );
        insert voipPricebook;

        PricebookEntry voipPbe = new PricebookEntry(
            Pricebook2Id = voipPricebook.Id,
            Product2Id = productObj.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert voipPbe;

        Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM VoIP').getRecordTypeId();
        Opportunity oppObj = new Opportunity(
            Service_Type__c = 'Newlink',                       // Service Type
            RecordTypeId = RecordTypeOppId,                          // Opportunity Record Type
            Project_Group__c = 'VOIP Maxima',                    // Project Group
            Auto_Renewal__c = false,                             // Auto Renewal
            trial__c = false,                                    // trial
            Name = 'VOIP Maxima',                                // Opportunity Name
            AccountId = accObj.id,                             // Account Name
            //Solution_PIC__c = 'undefined',                       // Solution PIC
            CloseDate =  Date.newInstance(2021,06, 30) ,              // Target Closed Date
            Actual_Closed_Date__c =  Date.newInstance(2021,06,30) ,  // Closed Date
            Contract_Periode__c = 12,                          // Contract Periode
            StageName = 'Prospecting',                           // Stage
            Probability = 0,                                     // Probability (%)
            Amount = 15000,                                     // Amount
            Remark__c = 'Approved',                              // Remark
            LeadSource = 'Other',                                // Lead Source
            BW_before__c = '0',                                  // Capacity before
            Uom_BW_Before__c = 'Kbps',                           // Uom BW Before
            BW_after__c = '0',                                   // Capacity after
            Uom_BW_After__c = 'Kbps',                            // Uom BW After
            Pricebook2id = voipPricebook.id
        );

        insert oppObj;
        OpportunitylineItem oliObj = new OpportunitylineItem();
        oliObj.unitprice = 10000;
        oliObj.quantity = 2;
        oliObj.billing_type__c = 'Monthly';
        oliObj.Revenue_Type__c = 'Recurring';
        oliObj.opportunityID = oppObj.id;
        oliObj.PricebookEntryId  = voipPbe.id;
        insert oliObj;


        


        Test.startTest();
        //System.runAs(contextuser){
            oppObj.Mark_as_Add_Link_Sales_Revenue__c = true;
            oppObj.stageName = 'Closed Won';
            oppObj.probability = 100;
            update oppObj;

            List<Opportunity> opptyList = new List<Opportunity>();
            opptyList.add(oppObj);
            AddDeleteNewLinkOppToSalesRevenueAction.addDeleteNewLinkOppToSalesRevenueAction(opptyList);


            oppObj.Mark_as_Add_Link_Sales_Revenue__c = false;
            update oppObj;

            opptyList = new List<Opportunity>();
            opptyList.add(oppObj);
            AddDeleteNewLinkOppToSalesRevenueAction.addDeleteNewLinkOppToSalesRevenueAction(opptyList);

        //}
        Test.stopTest();
        
    } 
}