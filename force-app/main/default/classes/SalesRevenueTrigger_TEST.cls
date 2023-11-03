@isTest(seealldata=false)
public class SalesRevenueTrigger_TEST {
	@testSetup static void setup() {
        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.undelete', Is_Active__c=true));
        insert lstTriggerController;

        Sales_Performance_Monthly_AMGS__c sprM_AMGSObj = new Sales_Performance_Monthly_AMGS__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprM_AMGSObj;
        
        Sales_Performance_Monthly_AM__c sprM_AMObj = new Sales_Performance_Monthly_AM__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprM_AMObj;

        Sales_Performance_Monthly__c sprMObj = new Sales_Performance_Monthly__c (name ='{DEFAULT}', year__c ='2021', month__c = '1');
        insert sprMObj;
        

        Sales_Performance_General__c sprGSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AMGS_DEFAULT_SFID', format__c='string', value__c =sprM_AMGSObj.id);
        insert sprGSettingObj;

        sprGSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_AM_DEFAULT_SFID', format__c='string', value__c =sprM_AMObj.id);
        insert sprGSettingObj;

        sprGSettingObj = new Sales_Performance_General__c (name ='SPR_MONTHLY_DEFAULT_SFID', format__c='string', value__c =sprMObj.id);
        insert sprGSettingObj;




        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='testsrvcontroller@xl.co.id',
                    employee_id__c ='12345',
                    phone ='021-90' , mobilephone='0812', firstName = 'bob'
                    );
        insert usr ;


    }

    static testMethod void addopportunityProductData () {
        string SPR_MONTHLY_AMGS_DEFAULT_SFID;
        string SPR_MONTHLY_AM_DEFAULT_SFID;
        string SPR_MONTHLY_DEFAULT_SFID;

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        Map<String, String> generalSettingMap = new Map<String, String>();
        for (Sales_Performance_General__c  setting : listSPGeneralSetting) {
            generalSettingMap.put(setting.name, setting.value__c);

            switch on setting.name {
                when 'SPR_MONTHLY_AMGS_DEFAULT_SFID' {
                    SPR_MONTHLY_AMGS_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_AM_DEFAULT_SFID' {
                    SPR_MONTHLY_AM_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_DEFAULT_SFID' {
                    SPR_MONTHLY_DEFAULT_SFID = setting.value__c;
                }
            }
        }

        system.debug ('== test SPR_MONTHLY_AMGS_DEFAULT_SFID : ' + SPR_MONTHLY_AMGS_DEFAULT_SFID);
        system.debug ('== test SPR_MONTHLY_AM_DEFAULT_SFID : ' + SPR_MONTHLY_AM_DEFAULT_SFID);
        system.debug ('== test SPR_MONTHLY_DEFAULT_SFID : ' + SPR_MONTHLY_DEFAULT_SFID);



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
        

        test.starttest();
            insert oliObj;

            OpportunitylineItem oliObjTEMP = [select unitprice, quantity, billing_type__c, Revenue_Type__c, opportunityID,
                                                PricebookEntryId, Actual_Close_Date__c, AM_SFID__C, AM_Employee_ID__c,
                                                customer_SFID__c, Group_Service_Name__c, SM_SFID__c, GH_SFID__c,
                                                TotalPrice, id, Opportunity_SFID__c, Opportunity_ID__c,
                                                Product_Name__c 
                                            from OpportunitylineItem 
                                            where id = :oliObj.id
                                                
            ];

            
            /*
            oppObj.Mark_as_Sales_Revenue__c = true;
            update oppObj;
            AddOppProductsToSalesRevenueAction.addOpportunityProductData (oliList);


            oppObj.Mark_as_Sales_Revenue__c = false;
            update oppObj;
            AddOppProductsToSalesRevenueAction.addOpportunityProductData (oliList);
            */


            List<OpportunityLineItem> oliTobeAddList = new List<OpportunityLineItem>();
            oliTobeAddList.add(oliObjTEMP);
            SalesRevenueController.addOpportunityProductData( oliTobeAddList  );

            Set<ID> oliTobeDeleteIDs = new Set<ID>();
            oliTobeDeleteIDs.add (oliObj.id);
            SalesRevenueController.deleteOportunityProductData(oliTobeDeleteIDs);

        test.stoptest();


        


        //SalesRevenueController.deleteOportunityProductData
    }

    static testMethod void addForecastPendingRecurringData () {
        User usr = [select id from user where lastname = 'Testing'];
        

        System.runAs(usr) {
            Id recordtypeAccid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

            Account accObj = new Account (
                name = 'PT. ABC',
                term_of_payment__c = '',
                organization_type__c = 'Head Office',
                recordtypeid = recordtypeAccid,
                assign_to__c = usr.id
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


                SalesRevenueController.deletedForecatPendingRecurringData( pendingRecurringList  );


            test.stoptest();
          
        }

        //SalesRevenueController.deletedForecatPendingRecurringData
    }

    /* TUTUP DULU
    static testMethod void addForecastPendingRecurringDataSubmitToORM () {
        system.debug ('== test addForecastPendingRecurringDataSubmitToORM ');
        User usr = [select id from user where lastname = 'Testing'];
        

        System.runAs(usr) {
            Id recordtypeAccid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

            Account accObj = new Account (
                name = 'PT. ABC',
                term_of_payment__c = '',
                organization_type__c = 'Head Office',
                recordtypeid = recordtypeAccid,
                assign_to__c = usr.id
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
        
            insert pendRecObj;

            test.starttest();
                pendRecObj.Mark_as_Revenue_Pending_Recurring__c = true;
                pendRecObj.Status__c = 'Submit To ORM';
                update pendRecObj;

                List<Pending_Recurring__c> pendingRecurringList = new List<Pending_Recurring__c>();
                pendingRecurringList.add(pendRecObj);
                SalesRevenueController.addForecastPendingRecurringData( pendingRecurringList  );
                
            test.stoptest();
          
        }
    }
    static testMethod void addForecastPendingRecurringDataSentToFinance () {
        User usr = [select id from user where lastname = 'Testing'];
        

        System.runAs(usr) {
            Id recordtypeAccid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();

            Account accObj = new Account (
                name = 'PT. ABC',
                term_of_payment__c = '',
                organization_type__c = 'Head Office',
                recordtypeid = recordtypeAccid,
                assign_to__c = usr.id
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
        

            insert pendRecObj;
            
            test.starttest();
                pendRecObj.Mark_as_Revenue_Pending_Recurring__c = true;
                pendRecObj.Status__c = 'Sent To Finance';
                update pendRecObj;
                
            test.stoptest();
          
        }
    }
    */


    static testMethod void addForecastwaivingData () {
        
        Id recordtypeAccid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        User usr = [select id from user where lastname = 'Testing'];
        

        System.runAs(usr) {
            Account accObj = new Account (
                name = 'PT. ABC',
                term_of_payment__c = '',
                organization_type__c = 'Head Office',
                recordtypeid = recordtypeAccid,
                assign_to__c = usr.id
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
                Service__c = 'MPLS'
            );
        

            test.starttest();
                insert edaObj;

                /* old way
                edaObj.EDA_Status__c = 'Completed';
                update edaObj;


                edaObj.EDA_Status__c = 'Draft';
                update edaObj;
                */

                List<EDA__c> edaList = new List<EDA__c>();
                edaObj.EDA_Status__c = 'Completed';
                update edaObj;
                edaList.add (edaObj);
                SalesRevenueController.addForecastwaivingData( edaList ) ;


                edaList = new List<EDA__c>();
                edaObj.EDA_Status__c = 'Draft';
                update edaObj;
                edaList.add (edaObj);
                SalesRevenueController.addForecastwaivingData( edaList ) ;


                SalesRevenueController.deletedForecastWaivingData( edaList ) ;


            test.stoptest();
        }

        //deletedForecastWaivingData

    }

    static testMethod void addNewLinkData () {
        //addNewLinkData
        // create newlink opportunity
        User usr = [select id from user where lastname = 'Testing'];
        

        System.runAs(usr) {

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
                Using_HO_Billing_Address__c = false,                       // Using HO Billing Address
                assign_to__c = usr.id
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
            oliObj.Revenue_Type__c = 'Recurring';
            insert oliObj;

            test.starttest();
                /* old way
                oppObj.stageName = 'Closed Won';
                oppObj.Probability = 100;

                system.debug ('== oppObj : ' + oppObj);
                update oppObj;
                */

                List <Opportunity> newLinkOppportunityTobeAddList = new List <Opportunity>();
                oppObj.stageName = 'Closed Won';
                oppObj.Probability = 100;
                update oppObj;
                newLinkOppportunityTobeAddList.add (oppObj);
                SalesRevenueController.addNewLinkData ( newLinkOppportunityTobeAddList ) ;

                Set<ID> opptyTobeDeleteIDs = new Set<ID> ();
                opptyTobeDeleteIDs.add(oppObj.id);
                SalesRevenueController.deleteNewLinkData ( opptyTobeDeleteIDs );



            test.stoptest();
        }
        
        //deleteNewLinkData

    }

    static testMethod void addTerminationBAPData () {
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        
        Account accObj = new Account(
            Name = 'PT Bank HSBC Indonesia',                                              // Account Name
            RecordTypeId = RecordTypeAccId,                                                     // Account Record Type
            BP_Number__c = '700816',                                                        // BP Number
            //Assign_To__c = 'undefined',                                                     // Assign To
            Organization_Type__c = 'Head Office',                                           // Organization Type
            Type = 'Customer',                                                              // Type
            Unique_Name__c = 'Jakarta Menara Mulia',                                        // Unique Name
            Customer_Type__c = 'NONGSM',                                                    // Customer Type
            Payer_For_GSM_Invoice__c = false,                                               // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',                             // Term of Payment
            Company_Group__c = 'THE HONGKONG SHANGHAI BANKING CORPORATION LIMITED (HSBC)',  // Company_Group
            Customer_VAT_Name__c = 'PT. BANK HSBC INDONESIA',                               // Customer VAT Name
            Summary_Billing__c = false,                                                     // Summary Billing
            Using_HO_Billing_Address__c = false,                                            // Using HO Billing Address
            Relocation_Street_1__c = 'MMU Lt 23 (ruang server) Jakarta',                    // Relocation Street 1
            No_NPWP__c = '013862420091000'                                                 // No NPWP
            );
        insert accObj;

        Link__c linkObj = new Link__c(
            ID__c = '11807',                                       // ID
            CID__c = '12-00106',                                     // CID *
            BU__c = 'ENTERPRISE',                                    // BU
            //CID_RelD__c = 'undefined',                               // CID RelD
            Name = '12-00106',                                       // CID/Link ID
            Company_Name__c = 'PT Bank HSBC Indonesia',              // Company Name
            Link_ID__c = '020C247L44',                               // Link ID
            Contract_Item__c = '3001063-27',                         // Contract Item
            Status_Link__c = 'IN_SERVICE',                           // Status Link
            Routepath__c = '723115 PT Bank HSBC Indonesia ATM Ciputra World Surabaya Surabaya - 1541 GUNDIH JAW-JI-SBY-2408 - SNB Surabaya Network Building - RAWAPENING HUT GRAHA XL - PC027 WTC JAW-JK-KYB-2711 - 722776 HSBC WTC 1 Lt.5 Jl. Jend.Sudirman Kav.29-31, Karet Jakarta Selatan 12920',  // Routepath
            Service_Type__c = 'L2VPN',                               // Service Type
            BP_Site_A__c = '723115',                                 // BP Site A
            BP_Site_B__c = '722776',                                 // BP Site B
            Site_A_Name__c = accObj.id,                            // Site A Name
            //Site_B_Name__c = 'undefined',                            // Site B Name
            Capacity_Bandwidth__c = '64',                            // Capacity Bandwidth
            UoM__c = 'Kbps',                                         // UoM
            Free_Link__c = true,                                    // Free Link
            Partner__c = false                                      // Partner
 
            );
        insert linkObj; 


        //addTerminationBAPData
        Id RecordTypeId = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('Termination').getRecordTypeId();
        BAP__c bapObj = new BAP__c(
            BAP_No__c = 'BAP-11052021-15452',                                         // BAP No
            BAP_ID__c = '15453',                                                        // BAP ID
            Request_Status__c = 'Draft',                                  // Request Status
            Name = 'BAP 12-00106 PT Bank HSBC Indonesia  ATM Ciputra World Surabaya',   // BAP Name
            Links_Info__c = '1. 020C247L44',                                            // Links Info
            Type_of_Request__c = 'Pemutusan',                                           // Type of Request
            Customer__c = accObj.id,                                                  // Customer
            Approval_Flag__c = 'Tidak',                                                 // Approval Flag
            Pernah_Disubmit__c = false,                                                 // Pernah Disubmit
            Sirkit__c = 'PT Bank HSBC Indonesia  ATM Ciputra World Surabaya',           // Sirkit
            PIC_Name__c = 'Yuniarto Nugroho',                                           // PIC Name
            RecordTypeId = RecordTypeId,                                                 // Record Type
            PIC_Phone__c = '0818938333',                                                // PIC Phone
            PIC_email__c = 'yuniartonugroho@hsbc.co.id',                                // PIC email
            PIC_Position__c = 'IT Infrastructure',                                      // PIC Position
            Request_Date__c = Date.newinstance (2021,05,11),                               // Submit Date
            Terminate_Date__c = Date.newinstance (2021,06,11),                             // Terminate Date
            Reason__c = 'Kontrak berakhir atau tidak diperpanjang',                     // Reason
            Note__c = 'Kontrak Berakhir dan tidak diperpanjang',                        // Note
            Pinalty_Flag__c = false,                                                    // Pinalty Flag
            Pinalty__c = 0,                                                           // Pinalty
            //Mirroring_Status__c = 'Success',                                            // Mirroring Status
            Lebih_Tagih__c = 0,                                                       // Lebih Tagih
            Cost_Flag__c = false,                                                       // Cost Flag
            Cost__c = 0,                                                              // Cost
            IsBackDate__c = false,                                                      // IsBackDate / IsEarly
            IsPenalty__c = false,                                                       // IsPenalty
            //Sales_Group_Head__c = 'undefined',                                          // Sales Group Head
            IsCostPartner__c = false ,                                                  // Cost Partner > 100jt
            //Stamp_Stage_Submit__c = Datetime.valueOf('11-05-2021 17:28:00'),            // Stamp Stage Submit
            //Stamp_Stage_Sent_to_Customer__c = Datetime.valueOf('14-05-2021 06:05:00'),  // Stamp Stage Sent to Customer
            //Stamp_Stage_Operation_Review__c = Datetime.valueOf('11-05-2021 17:28:00')  // Stamp Stage Operation Review
            link__c = linkObj.id,
            Address2__c = 'jl. cempaka VI'


            );
        
        test.starttest();
            insert bapObj;
            /* old way
            bapObj.Request_Status__c = 'Submit';
            update bapObj;

            bapObj.Request_Status__c = 'Draft';
            update bapObj;
            */

            List <BAP__c> bapTobeAddList = new List <BAP__c>();
            bapObj.Request_Status__c = 'Submit';
            update bapObj;
            bapTobeAddList.add (bapObj);
            SalesRevenueController.addTerminationBAPData ( bapTobeAddList ) ;

            /*
            bapTobeAddList = new List <BAP__c>();
            bapObj.Request_Status__c = 'Draft';
            update bapObj;
            bapTobeAddList.add (bapObj);
            SalesRevenueController.addTerminationBAPData ( bapTobeAddList ) ;*/

            Set<ID> bapTobeDeleteIDs = new Set<ID>();
            bapTobeDeleteIDs.add (bapObj.id);
            SalesRevenueController.deleteTerminationBAPData ( bapTobeDeleteIDs );

    
        test.stoptest();

        //deleteTerminationBAPData

    }


    static testMethod void setNewCustomer () {
        test.starttest();
            SalesRevenueController.setNewCustomer(Date.newInstance(2021, 01, 01));
        test.stoptest();
    }
 
}