/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_Schedule_Pending_Recurring {

    static testMethod void myUnitTest() {
    	insert new Transaction__c(transactionID__c = 1);
        // TO DO: implement unit test
         User Sales=[SELECT id FROM User WHERE Profile.Name='Sales' AND UserRole.Name='Banking & Financial Service' AND IsActive=true LIMIT 1];
        
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='BP'];
        Account A = new Account(
	  	Name = 'PT Bank Permata Tbk',                      // Account Name
	  	BP_Number__c = '757677',                             // BP Number
	  	Organization_Type__c = 'Head Office',                // Organization Type
	  	Type = 'Customer',                                   // Type
	  	RecordTypeId = RT.id,                          // Account Record Type
	  	Unique_Name__c = 'Kantor Kemenag Lombok',            // Unique Name
	  	Keyword__c = 'BP',                                   // Keyword
	  	term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
	  	Customer_VAT_Name__c = 'PT Bank Permata Tbk',        // Customer VAT Name
	  	Customer_Type__c = 'NONGSM',                         // Customer Type
	  	Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
	  	Summary_Billing__c = false,                          // Summary Billing
	  	Approval_Status__c = 'Approved',                     // Approval Status
	  	Using_HO_Billing_Address__c = false,                 // Using HO Billing Address
          No_NPWP__c = '000009090909090',                      // No NPWP
          Ownerid=Sales.id
		);
		insert A;
        
        /*
        Account A=new Account();
        A.Name='Tes Akun XL';
        A.Ownerid=Sales.id;
        insert A;
        */
        
        Link__c L=new Link__c();
        L.Link_ID__c='937DHS'; 
        L.Service_Type__c='MPLS';
        L.Site_A_Name__c=A.id;
        insert L;
       	
       	
        Pending_Recurring__c PR=new Pending_Recurring__c(); 
        PR.Search_Link__c=L.id;
        PR.Status__c='Send to Sales';
        PR.Pending_from__c=system.today().adddays(-30);
        
        insert PR;
        User Sales2=[SELECT id FROM User WHERE Profile.Name='Sales' AND UserRole.Name='Banking & Financial Service' /*and Events'*/ AND IsActive=true LIMIT 1];
        
        //RecordType RT=[SELECT id FROM Recordtype WHERE Name='BP'];
        Account A2 = new Account(
	  	Name = 'PT Bank Permata Tbk',                      // Account Name
	  	BP_Number__c = '757677',                             // BP Number
	  	Organization_Type__c = 'Head Office',                // Organization Type
	  	Type = 'Customer',                                   // Type
	  	RecordTypeId = RT.id,                          // Account Record Type
	  	Unique_Name__c = 'Kantor Kemenag Lombok',            // Unique Name
	  	Keyword__c = 'BP',                                   // Keyword
	  	term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
	  	Customer_VAT_Name__c = 'PT Bank Permata Tbk',        // Customer VAT Name
	  	Customer_Type__c = 'NONGSM',                         // Customer Type
	  	Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
	  	Summary_Billing__c = false,                          // Summary Billing
	  	Approval_Status__c = 'Approved',                     // Approval Status
	  	Using_HO_Billing_Address__c = false,                 // Using HO Billing Address
          No_NPWP__c = '000009090909090',                      // No NPWP
          Ownerid=Sales2.id
		);
        insert A2;
        
        /*
        Account A2=new Account();
        A2.Name='Tes Akun XL 2';
        A2.Ownerid=Sales2.id;
        insert A2;
        */
        
        Link__c L2=new Link__c();
        L2.Link_ID__c='937DHS2'; 
        L2.Service_Type__c='MPLS';
        L2.Site_A_Name__c=A2.id;
        insert L2;
       
        Pending_Recurring__c PR2=new Pending_Recurring__c();
        PR2.Search_Link__c=L2.id;
        PR2.Status__c='Send to Sales';
        PR2.Pending_from__c=system.today().adddays(-30);
        
        insert PR2;
     
		Schedule_Pending_Recurring schepr=new Schedule_Pending_Recurring();
		schepr.execute(null);
        Schedule_Pending_Recurring2 schepr2=new Schedule_Pending_Recurring2();
		schepr2.execute(null);
    }
}