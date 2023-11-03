@isTest
private class AddPendingRecurringtoSRVActionTEST {

    static testMethod void schenario1(){
        Id recordtypeAccid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

        Account accObj = new Account (
            name = 'PT. ABC',
            term_of_payment__c = '',
            organization_type__c = 'Head Office',
            recordtypeid = recordtypeAccid //,
            //assign_to__c = usr.id
        );
        insert accObj;
        
        Link__c linkObj = new Link__c(
            ID__c = '21651',       // ID
            CID__c = '12-00090',     // CID *
            BU__c = 'ENTERPRISE',    // BU
            //CID_RelD__c = 'undefined',       // CID RelD
            Name = '12-00090',       // CID/Link ID
            Company_Name__c = 'PT Smart Telecom',         // Company Name
            Link_ID__c = '020C1341L2',       // Link ID
            Contract_Item__c = '3002203-3',  // Contract Item
            Status_Link__c = 'IN_SERVICE',   // Status Link
            Routepath__c = '749836 PLTU Tumbang Kajuei, Rungan, Gunung Mas, Kalimantan Tengah - PT Starcom Solusindo  - C459 TUMBANG JUTUH - C481 TARAKAS - 3460 GUHUNG - 3503 AYANI - 241PX344 CYBER1&2 JAW-JK-KYB-1827',  // Routepath
            Service_Type__c = 'L2VPN',       // Service Type
            BP_Site_A__c = '749836', // BP Site A
            BP_Site_B__c = '749501', // BP Site B
            Site_A_Name__c = accObj.id,    // Site A Name
            //Site_B_Name__c = 'undefined',    // Site B Name
            Capacity_Bandwidth__c = '4',     // Capacity Bandwidth
            //Contract_Item_Rel__c = 'undefined',           // Contract Item Rel
            UoM__c = 'Mbps',         // UoM
            Free_Link__c = false,    // Free Link
            Partner__c = false      // Partner
        );
        insert linkObj;

        Id RecordTypeId = Schema.SObjectType.Pending_Recurring__c.getRecordTypeInfosByName().get('With Link').getRecordTypeId();

        Pending_Recurring__c pendRecObj = new Pending_Recurring__c(
            RecordTypeId = RecordTypeId,                        // Record Type
            Name = 'PT Smart Telecom',                           // Pending Recurring Name
            Link_ID__c = '020C1341L2;',                          // Link ID
            Search_Link__c = linkObj.id,                        // CID
            //Service_Type_Non_Link__c = 'M2M',                  // Service Type
            Monthly_Price_ORM__c = 12741000,                 // Monthly_Price
            Pending_From__c = Date.newInstance(2021,06,12),        // Pending Start
            Pending_To__c = Date.newInstance(2021,06,30) ,          // Pending Until
            Pending_Type__c = 'BA',                              // Pending Type
            Remark__c = 'No BAE',                                // Remark
            Outstanding_Revenue_Calculated__c = 8069300.00,      // Outstanding Revenue
            Status__c = 'Draft',                         // Status
            Aging_Since__c = Date.newInstance(2021,05,12) ,         // Aging Since
            Send_to_Sales_Date__c =  Date.newInstance(2021,05,12),  // Send to Sales Date
            AM_Email__c = 'meilianaf@xl.co.id'                  // AM Email
        );
    

        test.starttest();
            insert pendRecObj;
            
            /*old way
            
            pendRecObj.Status__c = 'Send To Sales';
            update pendRecObj;

            pendRecObj.Mark_as_Revenue_Pending_Recurring__c = false;
            update pendRecObj;
            */


            List<Pending_Recurring__c> pendingRecurringList = new List<Pending_Recurring__c>();
            pendingRecurringList.add(pendRecObj);
            SalesRevenueController.addForecastPendingRecurringData( pendingRecurringList  );

            pendRecObj.Status__c = 'Send To Sales';
            pendRecObj.Mark_as_Revenue_Pending_Recurring__c =true;

            update pendRecObj;
            pendingRecurringList = new List<Pending_Recurring__c>();
            pendingRecurringList.add(pendRecObj);
            SalesRevenueController.addForecastPendingRecurringData( pendingRecurringList  );

            /*
            pendRecObj.Status__c = 'Submit to ORM';
            update pendRecObj;
            pendingRecurringList = new List<Pending_Recurring__c>();
            pendingRecurringList.add(pendRecObj);
            SalesRevenueController.addForecastPendingRecurringData( pendingRecurringList  );

            pendRecObj.Status__c = 'Sent to Finance';
            update pendRecObj;
            pendingRecurringList = new List<Pending_Recurring__c>();
            pendingRecurringList.add(pendRecObj);
            SalesRevenueController.addForecastPendingRecurringData( pendingRecurringList  );
            */


            //SalesRevenueController.deletedForecatPendingRecurringData( pendingRecurringList  );


            AddPendingRecurringtoSalesRevenueAction.AddPendingRecurringtoSalesRevenueAction(pendingRecurringList) ;


            pendRecObj.Mark_as_Revenue_Pending_Recurring__c =false;
            update pendRecObj;
            pendingRecurringList = new List<Pending_Recurring__c>();
            pendingRecurringList.add(pendRecObj);
            SalesRevenueController.addForecastPendingRecurringData( pendingRecurringList  );
            AddPendingRecurringtoSalesRevenueAction.AddPendingRecurringtoSalesRevenueAction(pendingRecurringList) ;

        Test.stopTest();
        
    }
}