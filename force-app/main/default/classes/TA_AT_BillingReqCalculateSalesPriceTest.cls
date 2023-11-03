@isTest
public class TA_AT_BillingReqCalculateSalesPriceTest {
    static testMethod void testCreateContract() {
        Circuit__c circuit = new Circuit__c(
            Name = '02-00082',   // CID
            Services__c = 'MPLS'  // Services
        );
        insert circuit;
        Link__c link = new Link__c(
            Company_Name__c = 'PT Solusi Jasa Teknologi Palimanan',// Company Name
            Capacity_Bandwidth__c = '10',                            // Capacity Bandwidth
            Name = '02-00082',                                       // CID/Link ID
            UoM__c = 'Mbps',                                         // UoM
            Link_ID__c = '02-00082',                                 // Link ID
            Partner__c = false,                                      // Partner
            Status_Link__c = 'IN_SERVICE',                           // Status Link
            Service_Type__c = 'MPLS',                                // Service Type
            // Last_PR_Rel__c = 'undefined',                            // Last PR Rel
            // Site_A_Name__c = 'undefined',                            // Site A Name
            BP_Site_A__c = '764086',                                 // BP Site A
            Lastmile_Type_A__c = 'iPASOLINK',                        // Lastmile Type A
            Free_Link__c = false,                                    // Free Link
            Is_Trial__c = false,                                     // Is Trial
            Aging_Trial_Reminder_Date__c = '0',                      // Aging Trial Reminder Date
            CID__c = '02-00082',                                     // CID *
            CID_RelD__c = circuit.Id                              // CID RelD
        );
        insert link;
        // Create Billing_Request__c records
        
        Billing_Request__c billingRequest = new Billing_Request__c();
        billingRequest.Link__c = link.Id;
        billingRequest.Status__c = 'Requested';
        billingRequest.Type__c = 'Burstable';
        billingRequest.Amount__c = 50000;
        billingRequest.Usage__c = '3';
        billingRequest.UoM_Usage__c = 'Mbps';
        billingRequest.Period__c = System.today();
        insert billingRequest;
      
    }
    
}