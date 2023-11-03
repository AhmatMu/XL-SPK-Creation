@istest
private class AddEdaWaivingtoSalesRevenueActionTEST {
    
    static testMethod void schenario1(){

        Id recordtypeAccid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        Account accObj = new Account (
            name = 'PT. ABC',
            term_of_payment__c = '',
            organization_type__c = 'Head Office',
            recordtypeid = recordtypeAccid
            //assign_to__c = usr.id
        );
        insert accObj;

        EDA__c edaObj = new EDA__c(
            Name = 'Hold Isolir - Collocation (XC) Tata - 022C2244L2',          // EDA Name
            Document_Type__c = 'IOM',                                             // Document Type
            IOM_Type__c = 'Waiving',               // IOM Type
            Total_Value__c = 4.642,                                               // Total Value
            //Cause_of_Isolation__c = 'Waiting BA Signed by Customer',              // Cause of Isolation
            Remark__c = 'Completed',                                              // Remark
            EDA_Status__c = 'Draft',                                          // EDA Status
            Related_Customer__c = accObj.id,                                    // Related Customer
            Summary__c = 'Dear Collection team,Mohon untuk hold suspend layanan cross connect - collo dari Tata Comm. dengan LID 022C2244L2, s.d. 28 Mei 2021. Dikarenakan PIC Tata - Pak Gopal, belum mau menandatangani BAE cross connect - collo XL, karena beliau belum mendapat BA perpanjangan untuk layanan collocation-nya dari PDG.Atas perhatiannya, terima kasih banyak.BR,Ashari',  // Summary
            //Hold_Isolation_Until__c = Date.valueOf('28-05-2021'),                 // Hold Isolation Until
            Submission_Date__c =  Date.newInstance(2021,05,3) ,                      // Submission Date
            EDA_Completion_Date__c = Date.newInstance(2021,05,04) ,                  // EDA Completion Date
            Recipient_1__c = 'ariyani@xl.co.id',                                  // Recipient 1
            //Approver_1__c = 'undefined',                                          // Approver 1
            Recipient_2__c = 'corporatecollection@xl.co.id',                      // Recipient 2
            //Approver_2__c = 'undefined',                                          // Approver 2
            Recipient_3__c = 'incem@xl.co.id',                                    // Recipient 3
            //Approver_3__c = 'undefined',                                          // Approver 3
            Recipient_4__c = 'rvivien@xl.co.id',                                  // Recipient 4
            Rejected__c = false,                                                  // Rejected
            Service_Group__c = 'NGSM',
            Service__c = 'MPLS',
            Mark_as_Revenue_EDA_Waiving__c = true
        );
    

        test.starttest();
            insert edaObj;


            List<EDA__c> EDAList = new List<EDA__c> ();
            EDAList.add (edaObj);
            AddEdaWaivingtoSalesRevenueAction.AddEdaWaivingtoSalesRevenueAction(EDAList );

            EDAList = new List<EDA__c> ();
            edaObj.EDA_Status__c = 'Draft';
            edaObj.Mark_as_Revenue_EDA_Waiving__c = false;
            EDAList.add (edaObj);
            AddEdaWaivingtoSalesRevenueAction.AddEdaWaivingtoSalesRevenueAction(EDAList );


        //System.runAs(contextuser){
            
        //}
        Test.stopTest();
        
    }
}