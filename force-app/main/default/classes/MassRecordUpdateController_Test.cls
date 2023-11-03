@isTest
public class MassRecordUpdateController_Test {
    
    /* 
        FORMAT Date
        Date dateValue = Date.newInstance(arg0, arg1, arg2);
        Datetime dateTimeValue = Datetime.newInstance(Year, Month, Day, Hours, Minutes, Seconds); 
    */

    /* 
        FilterRecord JSON Value
        {
            "index":1,
            "filterUpdateField":"SR/PR Notification Name",
            "textField":"pr-22",
            "textFieldVisible":true,
            "numberField":null,
            "numberFieldVisible":false,
            "picklistField":null,
            "picklistFieldVisible":false,
            "startDateField":null,
            "endDateField":null,
            "dateFieldVisible":false,
            "dateTimeField":null,
            "dateTimeFieldVisible":false,
            "checkboxField":null,
            "checkboxFieldVisible":false
        } 
    */

    @TestSetup
    static void setUpRecord(){
        
        Id recRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID Com').getRecordTypeId();
        Id recRecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General').getRecordTypeId();
        Id recRecordTypeIdSRPR = Schema.SObjectType.SR_PR_Notification__c.getRecordTypeInfosByName().get('PR Non GSM').getRecordTypeId();

        System.debug('recRecordTypeIdAcc: ' + recRecordTypeIdAcc);
        System.debug('recRecordTypeIdOpp: ' + recRecordTypeIdOpp);
        System.debug('recRecordTypeIdSRPR: ' + recRecordTypeIdSRPR);

      
        /* List<String> filterRecordList = new List<String>();
        
        for (type variable : List_or_set) {

        }
        
        String filterRecord = '[{"index":1,"filterUpdateField":"SR/PR Notification Name","textField":"pr-22","textFieldVisible":true,"numberField":null,"numberFieldVisible":false,"picklistField":null,"picklistFieldVisible":false,"startDateField":null,"endDateField":null,"dateFieldVisible":false,"dateTimeField":null,"dateTimeFieldVisible":false,"checkboxField":null,"checkboxFieldVisible":false}]';

        filterRecordList.add(filterRecord); */

        
        // create Account
        Account recAcc = new Account(
            Kwitansi__c = false,                                                            // Kwitansi
            Faktur_Pajak__c = false,                                                        // Faktur Pajak
            Summary_Billing__c = false,                                                     // Summary Billing
            summary_invoice__c = false,                                                     // summary invoice
            // CurrencyIsoCode = 'IDR - Indonesian Rupiah',                                    // Account Currency
            Name = 'PT VIAMO SERVICES INDONESIA',                                           // Account Name
            RecordTypeId = recRecordTypeIdAcc,                                                     // Account Record Type !!!!!!!!!!
            BP_Number__c = '756991',                                                        // BP Number
            Organization_Type__c = 'Holding',                                           // Organization Type 
            Type = 'Customer',                                                              // Type
            Unique_Name__c = 'Senayan',                                                     // Unique Name
            Keyword__c = 'Viamo INC',                                                       // Keyword
            Customer_Type__c = 'NONGSM',                                                    // Customer Type
            Payer_For_GSM_Invoice__c = false,                                               // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',                             // Term of Payment
            Customer_VAT_Name__c = 'PT Viamo Services Indonesia',                           // Customer VAT Name
            Is_New_Customer__c = false,                                                     // Is New Customer
            Approval_Status__c = 'Approved',                                                // Approval Status
            Using_HO_Billing_Address__c = false,                                            // Using HO Billing Address
            No_NPWP__c = '936088269012000',                                                 // No NPWP
            Bad_Debt_Status__c = 'False',                                                   // Bad Debt Status
            Bad_Debt_Last_Checking_Date__c = Date.newInstance(2023, 01, 26) // valueOf('1-26-2023 3:02 PM:00') // Bad Debt Last Checking Date ========
            );

            insert recAcc;


        // create Contact
        Contact recCon = new Contact(
            AccountId = recAcc.Id,                    // Account Name
            Salutation = 'Mr.',
            FirstName = 'Mark',
            LastName = 'Boots',
            Title = 'Chief Technology Officer',           // Title
            Department = 'IT',                            // Department
            Email = 'mark.boots@viamo.io.invalid',        // Email
            MobilePhone = '+1(301)8023882'               // Mobile
            // CurrencyIsoCode = 'IDR - Indonesian Rupiah'   // Contact Currency
            );

            insert recCon;


        // create Opportunity
        Opportunity recOppty = new Opportunity(
            Service_Type__c = 'Newlink',                                // Service Type
            RecordTypeId = recRecordTypeIdOpp,                                 // Opportunity Record Type !!!!!!!!!!!!!
            Auto_Renewal__c = false,                                    // Auto Renewal
            BA_Sent_Date__c = Date.newInstance(2021, 11, 25),           // Date.valueOf('11-25-2021') // BA Sent Date =================
            trial__c = false,                                           // trial
            Contract_Ticket__c = null,                           // Contract Ticket
            PIC_BA_Print__c = null,                              // PIC BA Print
            Auto_Renewal_Periode__c = 7,                                // Auto Renewal Periode
            Auto_Renewal_UOM__c = 'Hari',                               // Auto Renewal UOM
            Profitability__c = null,                             // Profitability
            AccountId = recAcc.Id,                                      // Account Name =======================
            IsLocked__c = false,                                        // IsLocked
            // CurrencyIsoCode = 'IDR - Indonesian Rupiah',                // Opportunity Currency
            Name = 'ISP 100Mbps + Local loop ke 4 Cabang',              // Opportunity Name
            CloseDate = Date.newInstance(2021, 09, 20),                 // Date.valueOf('9-20-2021') // Target Closed Date ====================
            //AccountId = null,                                  // Account Name (Formula) ?????????????????
            Actual_Closed_Date__c = Date.newInstance(2021, 09, 20),     // Date.valueOf('9-20-2021') // Closed Date  =======================
            PO_Date__c = Date.newInstance(2021, 10, 22),                // Date.valueOf('10-22-2021') // PO Date  =======================
            Expected_RFS_Date__c = Date.newInstance(2021, 10, 07),      // Date.valueOf('10-7-2021') // Expected RFS Date  =======================
            BP_Payer__c = null,                                  // BP Payer
            StageName = 'Survey',                                       // Stage
            BP_VAT__c = null,                                    // BP VAT
            Probability = 25,                                           // Probability (%)
            Contract_Periode__c = 1,                                    // Contract Periode
            Amount = 0.00,                                              // Amount
            Periode_UOM__c = 'Month',                                   // Periode UOM
            PKS_Number__c = '95/XL/II/2021',                            // PKS Number
            COF_Number__c = '95/XL/II/2021',                            // COF Number
            Remark__c = 'Approved',                                     // Remark
            Approval_Status__c = 'Approved',                            // Solution Approval Status
            Account_Site_A__c = null,                            // Account Site A (BP Site)
            Doc_Template__c = null,                              // Doc Template
            Link_Related__c = null,                              // CID (Related)
            SR__c = '2110-003216',                                      // SR
            Quotation_Final_Approval__c = 'Approved',                   // Quotation Final Approval Status
            PR__c = '2111-002551',                                      // PR
            PR_Rel__c = null,                                    // PR Rel
            PR_Status__c = 'COM',                                       // PR Status
            LeadSource = 'AM',                                          // Lead Source
            BW_before__c = '0',                                         // Capacity before
            Uom_BW_Before__c = 'Mbps',                                  // Uom BW Before
            BW_after__c = '100',                                        // Capacity after
            Uom_BW_After__c = 'Mbps',                                   // Uom BW After
            Project_Coordinator__c = '90006544 Nancy Citraningrum',     // Project Coordinator
            Sales_Manager_Owner__c = null,                       // Sales Manager Owner
            Mark_as_Add_Link_Sales_Revenue__c = false,                  // Mark as Add Link (Sales Revenue)
            Mark_as_Sales_Revenue__c = false                            // Mark as Sales Revenue
            );

            insert recOppty;
        
        
        // create Circuit__c
        Circuit__c recCircuit = new Circuit__c(
            Name = '03-02344',   // CID
            Services__c = 'ISP'  // Services
            );

            insert recCircuit; 


        // create SR_PR_Notification__c
        SR_PR_Notification__c recSRPR = new SR_PR_Notification__c(
            Name = 'PR-2111-002551',                                                      // SR/PR Notification Name
            Notif_Type__c = 'PR',                                                         // Notif Type
            Opportunity__c = recOppty.Id,                                               // Opportunity
            Project_Type__c = 'New',                                                      // Project Type
            Services__c = 'ISP',                                                          // Services
            Project_Name__c = 'ISP - PT Viamo Services Indonesia,VIAMO – Bintaro DC XL',  // Project Name
            Status__c = 'In Progress',                                                    // Status
            Account__c = recAcc.Id,                                                     // Account
            Proof_of_Change_PR_Trial_Is_Upload__c = false,                                // Proof of Change PR Trial Is Upload
            CID__c = '03-02344',                                                          // CID
            Site_A__c = recAcc.Id,                                                      // Site A
            PIC_Site__c = recCon.Id,                                                    // PIC Site
            Circuit__c = recCircuit.Id,                                                     // Circuit
            Head_Sales_Email__c = 'harfeliar@xl.co.id.invalid',                           // Head Sales Email
            Project_Coordinator_Email__c = 'kahfi.frimanda@gmail.com',                    // Project Coordinator Email
            Sales_Email__c = 'radhitya.indrapratikto@saasten.com',                        // Sales Email
            ECRF_Request__c = false,                                                      // ECRF Request
            Capacity_Before__c = '128',                                                   // Capacity Before
            UOM_before__c = 'Mbps',                                                       // UOM before
            Capacity_After__c = '128',                                                    // Capacity After
            UOM_After__c = 'Mbps',                                                        // UOM After
            WBA_Required_File__c = false,                                                 // Customer Confirmation File Upload
            Notif_Date__c = Date.newInstance(2021, 11, 25),                         //Date.valueOf('11-25-2021') // Notif Date ===========
            Normal_RFS__c = Date.newInstance(2021, 12, 25),                         //Date.valueOf('12-25-2021') // Normal RFS ===========
            Exp_RFS_Date__c = Date.newInstance(2021, 10, 07),                       //Date.valueOf('10-7-2021') // Exp RFS Date ==========
            Trial__c = false,                                                             // Trial
            End_Date_Trial__c = Date.newInstance(2021, 12, 01),                     //Date.valueOf('12-1-2021') // End Date Trial ========
            Start_Date_Trial__c = Date.newInstance(2021, 11, 26),                   //Date.valueOf('11-26-2021') // Start Date Trial =====
            RecordTypeId = recRecordTypeIdSRPR                                                    // Record Type !!!!!!!!!!!!!!!!
            );
            
            insert recSRPR;
        
    }

    @isTest
    static void getSobjectHeaderColumn_Test(){
        MassRecordUpdateController.getSobjectHeaderColumn('SR_PR_Notification__c');
    }

    @isTest
    static void getSobjectItemsHeaderColumn_Test() {
        MassRecordUpdateController.getSobjectItemsHeaderColumn('SR_PR_Notification__c');
    }

    @isTest
    static void getSobjectListFieldsType_Test(){
        MassRecordUpdateController.getSobjectListFieldsType('Id', 'SR_PR_Notification__c');
    }

    @isTest
    static void getSobjectListFieldsName_Test(){
        MassRecordUpdateController.getSobjectListFieldsName('Record ID', 'SR_PR_Notification__c');
    }

    @isTest
    static void getSobjectListFieldsLable_Test(){
        MassRecordUpdateController.getSobjectListFieldsLable('SR_PR_Notification__c');
    }

    @isTest
    static void getSobjectRecordItemListFieldsLable_Test(){
        MassRecordUpdateController.getSobjectRecordItemListFieldsLable('SR_PR_Notification__c');
    }

    @isTest
    static void getSobjectRecordList_Test(){
        String filterRecord = '[{"index":1,"filterUpdateField":"SR/PR Notification Name","textField":"pr-22","textFieldVisible":true,"numberField":null,"numberFieldVisible":false,"picklistField":null,"picklistFieldVisible":false,"startDateField":null,"endDateField":null,"dateFieldVisible":false,"dateTimeField":null,"dateTimeFieldVisible":false,"checkboxField":null,"checkboxFieldVisible":false}]';

        // MassRecordUpdateController.getSobjectRecordList(SobjectApiName, FilterRecord, pageSize, pageNumber, operatorCondition, fieldType);
        MassRecordUpdateController.getSobjectRecordList('SR_PR_Notification__c', filterRecord, 1, 1, 'AND', 'String');
        System.debug('getSobjectRecordList: ' + MassRecordUpdateController.getSobjectRecordList('SR_PR_Notification__c', filterRecord, 1, 1, 'AND', 'String'));
    }

    @isTest
    static void putSelectedRowtoMassRecordUpdateItems_Test(){
        // MassRecordUpdateController.putSelectedRowtoMassRecordUpdateItems(selectedRecordRowId, massUpdateRecordId, 'SR_PR_Notification__c', 1, 1, selectedAllRecordItem, recordItemIdList);
    }

    @isTest
    static void getSelectedMassRecordUpdateItems_Test(){
        // MassRecordUpdateController.getSelectedMassRecordUpdateItems(massUpdateRecordId, 'SR_PR_Notification__c', 1, 1, searchKeyUpdateRecordItem, selectedRecordUpdateItemViewDefault);
    }

    @isTest
    static void removeRecordUpdateItem_Test(){
        // MassRecordUpdateController.removeRecordUpdateItem(massRecordUpdateId, selectedRowRemoveItems, selectedRemoveItems, selectedAllRecordRemoveItems, 'SR_PR_Notification__c');
    }

    @isTest
    static void updateSobjectRecordItems_Test(){
        // MassRecordUpdateController.updateSobjectRecordItems(SobjectrecordIds, 'SR_PR_Notification__c', massUpdateRecordId, fieldDataType, fieldApiName, valuetoUpdate, selectedAllRecordItem, fieldLabel);
    }

    @isTest
    static void SaveSearchItemListView_Test(){
        // MassRecordUpdateController.SaveSearchItemListView(searchItemColumnView, SobjectrecordIds);
    }

    @isTest
    static void SaveRecordItemListView_Test(){
        // MassRecordUpdateController.SaveRecordItemListView(selectedItemColumnView, SobjectrecordIds);
    }

    @isTest
    static void getSobjectPicklistValues_Test(){
        MassRecordUpdateController.getSobjectPicklistValues('SR_PR_Notification__c', 'Status__c');
    }
    
}