@istest
private class AddDeleteOpportunityToSRVActionTEST {
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

    static testMethod void schenario1(){
        
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
            Pricebook2id = voipPricebook.id,
            Mark_as_Sales_Revenue__c = false
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
                                                Product_Name__c, Mark_as_Sales_Revenue__c 
                                            from OpportunitylineItem 
                                            where id = :oliObj.id
                                                
            ];

            

            // marked
            oppObj.Mark_as_Sales_Revenue__c = true;
            update oppObj;


            List<Opportunity> opptyList = new  List<Opportunity> ();
            opptyList.add ( oppObj );
            AddDeleteOpportunityToSalesRevenueAction.addDeleteOpportunityToSalesRevenueAction(opptyList);

        Test.stopTest();
        
    }
}