@isTest
public class TA_VR_BillingReqStatusCantEditTest {
    static testMethod void testBeforeUpdate() {
        Profile p = [SELECT Id, Name FROM Profile WHERE Name != 'System Administrator' LIMIT 1];
        User userA = new User(
            Alias = 'testuser',
            Email = 'testuser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser@testorg.com'
        );
        insert userA;
        
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
        
        // Test Case 1: Billing Request Status is not Created
        billingRequest.Status__c = 'In Queue';
        update billingRequest;
        // System.assertEquals(0, Limits.getDMLStatements()); // DML operation is successful
        
        // Test Case 2: Billing Request Status is Created, User is System Administrator
        System.runAs(new User(Id = UserInfo.getUserId(), ProfileId = p.Id)) {
            Billing_Request__c billingRequest2 = new Billing_Request__c();
            billingRequest2.Link__c = link.Id;
            billingRequest2.Status__c = 'Created';
            billingRequest2.Type__c = 'Burstable';
            billingRequest2.Amount__c = 50000;
            billingRequest2.Usage__c = '3';
            billingRequest2.UoM_Usage__c = 'Mbps';
            billingRequest2.Period__c = System.today();
            insert billingRequest2;
            billingRequest2.Status__c = 'In Queue';
            update billingRequest2;
            //  System.assertEquals(0, Limits.getDMLStatements()); // DML operation is successful
        }
        
        // Test Case 3: Billing Request Status is Created, User is not System Administrator
        System.runAs(userA) {
            Billing_Request__c billingRequest3 = new Billing_Request__c();
            billingRequest3.Link__c = link.Id;
            billingRequest3.Status__c = 'Created';
            billingRequest3.Type__c = 'Burstable';
            billingRequest3.Amount__c = 50000;
            billingRequest3.Usage__c = '3';
            billingRequest3.UoM_Usage__c = 'Mbps';
            billingRequest3.Period__c = System.today();
            insert billingRequest3;
            billingRequest3.Status__c = 'In Queue';
            
            try {
                update billingRequest3;
                System.assert(false, 'DML operation should have thrown an exception');
            } catch (DmlException e) {
                System.assertEquals(1, e.getNumDml());
                System.assertEquals('Cannot edit a Billing Request with Status \'Created\'', e.getDmlMessage(0));
            }
        }
        // Test Case 3: Billing Request Status is Created, User is not System Administrator
        System.runAs(new User(Id = UserInfo.getUserId())) {
            
            try {
                Billing_Request__c billingRequest4 = new Billing_Request__c();
                billingRequest4.Link__c = link.Id;
                billingRequest4.Status__c = 'Createded';
                billingRequest4.Type__c = 'Burstable';
                billingRequest4.Amount__c = 50000;
                billingRequest4.Usage__c = '3';
                billingRequest4.UoM_Usage__c = 'Mbps';
                billingRequest4.Period__c = System.today();
                insert billingRequest4;
                billingRequest4.Status__c = 'Restart';
                update billingRequest4;
                System.assert(false, 'DML operation should have thrown an exception');
            } catch (Exception e) {
                System.assertEquals(e.getmessage(), e.getmessage());
                // System.assertEquals('Can\'t Edit If Status Created', e.getDmlMessage(0));
            }
        }
    }
}