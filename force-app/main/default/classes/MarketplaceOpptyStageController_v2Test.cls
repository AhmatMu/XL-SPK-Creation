/**
 * @description       : 
 * @author            : Andre Prasetya
 * @group             : 
 * @last modified on  : 03-10-2022
 * @last modified by  : Andre Prasetya
**/
@isTest
public class MarketplaceOpptyStageController_v2Test {

    static testMethod void Test_MarketplaceOpportunityStageController_invokeApexCallout() {
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];

         insert new Transaction__c(transactionID__c = 1);
        
         ID accountHORT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId(); 
        ID oppRecordtypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Licensed').getRecordTypeId(); 
        Account acc = new Account(
            Name = 'PT Khazanah Media Network Nusantara TEST',                // Account Name
            RecordTypeId = accountHORT,                                    // Account Record Type
            BP_Number__c = '763278',                                       // BP Number
            Organization_Type__c = 'Head Office',                          // Organization Type
            Type = 'Customer',                                             // Type
            Unique_Name__c = 'Kapuas',                                     // Unique Name
            Customer_Type__c = 'NONGSM',                                   // Customer Type
            Industry = 'Telecommunications',                               // Industry
            Payer_For_GSM_Invoice__c = false,                              // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',            // Term of Payment
            Customer_VAT_Name__c = 'PT Khazanah Media Network Nusantara',  // Customer VAT Name
            Is_New_Customer__c = false,                                    // Is New Customer
            Kwitansi__c = false,                                           // Kwitansi
            Faktur_Pajak__c = false,                                       // Faktur Pajak
            summary_invoice__c = false,                                    // Summary Invoice
            Summary_Billing__c = false,                                    // Summary Billing
            Approval_Status__c = 'Approved',                               // Approval Status
            Using_HO_Billing_Address__c = false,                           // Using HO Billing Address
            No_NPWP__c = '723434791711000',                                // No NPWP
            Relocation_Street_1__c = 'reloc ke suatu tempat',
            ShippingStreet = 'dsdsdsds'
        );
        insert acc;
        
        //-- create Group Service
        Group_Service__c groupService1REC = new Group_Service__c(
            Name = 'FIXED',                  // Group Service Name
            Unique_ID__c = 'FIXED',            // Unique ID
            Type__c = 'BAU',                   // Type
            Search_Term__c = 'Group Service'  // Search Term
        );
        
			Pricebook2 pb22 = new Pricebook2(
            Name='Internet_Dedicated_Karawang',
            Service_group__c='Non-GSM',
            Product_Category__c='Subscription Based',
            SiteType__c='One Site',
            SurveyType__c='Standard',
            IsActive=true
        );
        insert pb22;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebookREC = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebookREC;
        
        Product2 pro2 = new Product2(
            Name = 'L2VPN 500 Mbps TEST',             // Product Name
            Group_Service__c = groupService1REC.id,  // Group Service
            Bandwidth__c = 500,                  // Bandwidth
            Family = 'Non-GSM',                       // Product Family
            UoM_Bandwidth__c = 'Mbps',             // UoM Bandwidth
            IsActive = false,                      // Active
            SAP_Code__c = 'L2VPN-02',              // SAP Code
            Product_Code2__c = 'L2VPN',            // Product Code
            Revenue_Type__c = 'Recurring',         // Charge Type
            Description = 'L2VPN 500 Mbps'        // Product Description
        );
        insert pro2;
        
        PricebookEntry pbEntrySTDREC = new PricebookEntry(
            Product2Id = pro2.id,  // Product
            IsActive = true,                   // Active
            Pricebook2Id = standardPricebookREC.id,  // Price Book
            UnitPrice = 52.500,                // List Price
            UseStandardPrice = false          // Use Standard Price
        );
        insert pbEntrySTDREC;
        
        PricebookEntry pbEntry = new PricebookEntry(
            Product2Id = pro2.id,  // Product
            IsActive = true,                   // Active
            Pricebook2Id = pb22.id,  // Price Book
            UnitPrice = 52.500,                // List Price
            UseStandardPrice = false          // Use Standard Price
        );
        insert pbEntry;    

        Contact cont = new Contact();
        cont.lastName ='wanka';
        cont.accountid = acc.id;
        insert cont;
        
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = oppRecordtypeID;
        opp.name = 'TEst';
        opp.StageName ='Prospecting';
        opp.CloseDate = date.today();
        opp.accountid = acc.id;

        opp.CloseDate=system.today().adddays(10);
        opp.Periode_UOM__c='Month';
        opp.BP_payer__C = acc.id;
        opp.BP_vat__C = acc.id;   
        
        opp.Service_Type__c='Licensed';
        opp.LastMile_Type__c='Radio';
        opp.Expected_RFS_Date__c=system.today().addmonths(3);
        opp.Contract_Periode__c=12;
        opp.Periode_Uom__c='Month';
        opp.StageName='survey';
        opp.SR__c='22222';
        opp.Project_Coordinator__c='90006544 Nancy Citraningrum';
        opp.PKS_Number__c='222';
        insert opp;
        
        OpportunityLineItem OLI2=new OpportunityLineItem();
        OLI2.Product2id=pro2.id;
        OLI2.PricebookEntryId = pbEntry.id;
        OLI2.OpportunityID=opp.id;
        OLI2.revenue_type__c='Recurring';
        OLI2.UnitPrice=50000000;
        OLI2.Quantity=1;
        OLI2.Contract_Start_Date__c= date.today();
        OLI2.Contract_End_Date__c= date.today();
        OLI2.Billing_Type__c='Monthly';
        insert OLI2;
        list<Opportunity> listopp=new list<Opportunity>();
       
        Test.startTest(); 
        opp.stagename ='implemetation';
           Update opp;
           listopp.add(opp);
           MarketplaceOpportunityStageController_v2.invokeApexCallout(listOpp); 
        Test.stopTest();
    }
}