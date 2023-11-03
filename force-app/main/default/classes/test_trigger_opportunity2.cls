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
@isTest(seealldata = true)
private class test_trigger_opportunity2 {

    static testMethod void myUnitTestLeasedLine() {
        // TO DO: implement unit test



        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
            LIMIT 1
        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
            AND Revenue_Type__c = 'One Time'
            LIMIT 1
        ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE SAP_Code__c = 'LL-02'
            AND Revenue_Type__c = 'Recurring'
            LIMIT 1
        ];
        Account HQ = [SELECT id, OwnerID from Account where Organization_Type__c = 'Head Office'
            AND BP_Number__c = '706531'
            LIMIT 1
        ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
            AND BP_Number__C = '712822'
            AND ParentID =: HQ.id LIMIT 1
        ];
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        User U = [SELECT id FROM User WHERE ID =: HQ.ownerid];

        Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();


        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Leased_Line'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign;PIC BA Print';
        insert CR;
        test.starttest();
        Opportunity O = new Opportunity();
        String OpportunityID = '';
        system.runas(U) {

            O.Accountid = HQ.id;
            O.Account_Site_A__c = HQ.id;
            O.Account_Site_B__c = A.id;
            O.StageName = 'Prospecting';
            O.Name = 'Tes';
            O.Link_Related__c = L.id;
            O.CloseDate = system.today().adddays(10);
            O.Pricebook2id = PB.id;
            O.Periode_UOM__c = 'Month';

            O.BP_Payer__c = A.id;
            O.BP_Vat__c = A.id;
            insert O;

            Profitability__c ProfitabilityForecats = new Profitability__c();
            ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
            ProfitabilityForecats.Name = 'Testing';
            ProfitabilityForecats.Account__c = O.AccountId;
            ProfitabilityForecats.Opportunity__c = O.Id;
            ProfitabilityForecats.Status__c = 'Forecast';
            ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
            ProfitabilityForecats.Deal_Price__c = 10000;
            ProfitabilityForecats.One_Time_Revenue__c = 10000;
            Insert ProfitabilityForecats;

            O.Profitability__c = ProfitabilityForecats.id;
            update O;

            /*  OpportunityLineItem OLI=new OpportunityLineItem();
              OLI.Product2id=Ptime.id;
              OLI.OpportunityID=O.id;
              OLI.revenue_type__c='One Time';
              OLI.UnitPrice=10000000;
              OLI.Quantity=1;
              insert OLI;*/
            OpportunityLineItem OLI2 = new OpportunityLineItem();
            OLI2.Product2id = Precurring.id;
            OLI2.OpportunityID = O.id;
            OLI2.revenue_type__c = 'Recurring';
            OLI2.UnitPrice = 50000000;
            OLI2.Quantity = 1;
            OLI2.Billing_Type__c = 'Monthly';
            OLI2.Contract_Start_Date__c = system.today().adddays(-3);
            OLI2.Contract_End_Date__c = system.today().adddays(3);
            insert OLI2;
            O.Service_Type__c = 'Relocation';
            O.LastMile_Type__c = 'Radio';
            O.Expected_RFS_Date__c = system.today().addmonths(3);
            O.Contract_Periode__c = 12;
            O.Periode_Uom__c = 'Day';
            O.StageName = 'survey';
            O.SR__c = '22222';
            O.COF_Number__c = '4';
            o.Project_Coordinator__c = '90006544 Nancy Citraningrum';
            update O;
            O.Site_B_Relocation_Street__c = 'Baker Street';
            O.Site_A_Relocation_Street__c = 'Elm Street';
            /* tutup dulu by doddy
            O.StageName = 'Closed Lost';
            O.Loss_Reason__c = 'Lost to Competitor';
            O.Loss_Reason_Description__c = 'test';
            update O;
*/

            //     HitsapComDocumentSapSoap.UpdateOpportunitySurvey(O.id);
            //     HitsapComDocumentSapSoap.UpdateOpportunityImplementation(O.id);
        }

        O.StageName = 'Waiting for Contract';
        update O;

        O.StageName = 'Quotation Final';
        update O;
        test.stoptest();
    }
    
    static testMethod void myUnitTestNonGSM() {
        // TO DO: implement unit test



        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
            LIMIT 1
        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Leased%'
            AND Revenue_Type__c = 'One Time'
            LIMIT 1
        ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE name = 'MPLS - 1 Mbps'
            AND Revenue_Type__c = 'Recurring'
            LIMIT 1
        ];
        Account HQ = [SELECT id, OwnerID from Account where Organization_Type__c = 'Head Office'
            AND BP_Number__c = '706531'
            LIMIT 1
        ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
            AND BP_Number__C = '712822'
            AND ParentID =: HQ.id LIMIT 1
        ];
        Link__C L = [SELECT id FROM Link__c where Name = '02-04034'];
        User U = [SELECT id FROM User WHERE ID =: HQ.ownerid];

        Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();


        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        test.starttest();
        Opportunity O = new Opportunity();
        String OpportunityID = '';
        system.runas(U) {

            O.Accountid = HQ.id;
            O.Account_Site_A__c = HQ.id;
            O.Account_Site_B__c = A.id;
            O.StageName = 'Prospecting';
            O.Name = 'Tes';
            O.Link_Related__c = L.id;
            O.CloseDate = system.today().adddays(10);
            O.Pricebook2id = PB.id;
            O.Periode_UOM__c = 'Month';

            O.BP_Payer__c = A.id;
            O.BP_Vat__c = A.id;
            insert O;

            Profitability__c ProfitabilityForecats = new Profitability__c();
            ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
            ProfitabilityForecats.Name = 'Testing';
            ProfitabilityForecats.Account__c = O.AccountId;
            ProfitabilityForecats.Opportunity__c = O.Id;
            ProfitabilityForecats.Status__c = 'Forecast';
            ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
            ProfitabilityForecats.Deal_Price__c = 10000;
            ProfitabilityForecats.One_Time_Revenue__c = 10000;
            Insert ProfitabilityForecats;

            O.Profitability__c = ProfitabilityForecats.id;
            update O;

            /*  OpportunityLineItem OLI=new OpportunityLineItem();
              OLI.Product2id=Ptime.id;
              OLI.OpportunityID=O.id;
              OLI.revenue_type__c='One Time';
              OLI.UnitPrice=10000000;
              OLI.Quantity=1;
              insert OLI;*/
            OpportunityLineItem OLI2 = new OpportunityLineItem();
            OLI2.Product2id = Precurring.id;
            OLI2.OpportunityID = O.id;
            OLI2.revenue_type__c = 'Recurring';
            OLI2.UnitPrice = 50000000;
            OLI2.Quantity = 1;
            OLI2.Billing_Type__c = 'Monthly';
            OLI2.Contract_Start_Date__c = system.today().adddays(-3);
            OLI2.Contract_End_Date__c = system.today().adddays(3);
            insert OLI2;
            O.Service_Type__c = 'Relocation';
            O.LastMile_Type__c = 'Radio';
            O.Expected_RFS_Date__c = system.today().addmonths(3);
            O.Contract_Periode__c = 12;
            O.Periode_Uom__c = 'Day';
            O.StageName = 'survey';
            O.SR__c = '22222';
            O.COF_Number__c = '4';
            o.Project_Coordinator__c = '90006544 Nancy Citraningrum';
            update O;
            O.Site_B_Relocation_Street__c = 'Baker Street';
            O.Site_A_Relocation_Street__c = 'Elm Street';
            O.StageName = 'Waiting for Contract';
            update O;

            O.StageName = 'Quotation Final';
            update O;

            /* Tutup dulu by doddy
            O.StageName = 'Closed Lost';
            O.Loss_Reason__c = 'Lost to Competitor';
            O.Loss_Reason_Description__c = 'test';
            update O;
			*/

            //     HitsapComDocumentSapSoap.UpdateOpportunitySurvey(O.id);
            //     HitsapComDocumentSapSoap.UpdateOpportunityImplementation(O.id);
        }
        test.stoptest();
    }

    static testMethod void myUnitTestRelocation() {
        // TO DO: implement unit test



        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
            LIMIT 1
        ];


        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%MPLS%'
            AND Revenue_Type__c = 'One Time'
            LIMIT 1
        ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE Name = 'MPLS - 1 Mbps'
            AND Revenue_Type__c = 'Recurring'
            LIMIT 1
        ];
        Account A = [SELECT id, ownerid FROM Account where Organization_Type__c = 'Head Office'
            AND BP_Number__c = '706531'
            LIMIT 1
        ];
        User U = [SELECT id FROM User WHERE ID =: A.ownerid];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        test.starttest();

        Opportunity O = new Opportunity();
        String OpportunityID = '';
        system.runas(U) {

            O.Accountid = A.id;
            O.Account_Site_A__c = A.id;
            //O.RecordTypeid=rt.id;
            O.StageName = 'Prospecting';
            O.Name = 'Tes';
            O.CloseDate = system.today().adddays(10);
            O.Pricebook2id = PB.id;
            O.Periode_UOM__c = 'Month';
            O.BP_Payer__c = A.id;
            O.BP_VAT__c = A.id;
            O.BW_After__c = '5';
            insert O;

            OpportunityLineItem OLI = new OpportunityLineItem();
            OLI.Product2id = Ptime.id;
            OLI.OpportunityID = O.id;
            OLI.revenue_type__c = 'One Time';
            OLI.UnitPrice = 10000000;
            OLI.Quantity = 1;
            //  insert OLI;
            OpportunityLineItem OLI2 = new OpportunityLineItem();
            OLI2.Product2id = Precurring.id;
            OLI2.OpportunityID = O.id;
            OLI2.revenue_type__c = 'Recurring';
            OLI2.UnitPrice = 50000000;
            OLI2.Quantity = 1;
            OLI2.Billing_Type__c = 'Monthly';
            OLI2.Contract_Start_Date__c = system.today().adddays(-3);
            OLI2.Contract_End_Date__c = system.today().adddays(3);
            insert OLI2;
        }
        O.Service_Type__c = 'Relocation';
        O.LastMile_Type__c = 'Radio';
        O.Expected_RFS_Date__c = system.today().addmonths(3);
        O.Contract_Periode__c = 12;
        O.Periode_Uom__c = 'Month';
        O.SR__c = '22222';
        O.Site_A_Relocation_Street__c = 'Elm Street';
        o.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        O.StageName = 'Waiting For Contract';
        O.PKS_Number__c = '222';
        update O;
        
        O.StageName = 'Closed Lost';
            O.Loss_Reason__c = 'Lost to Competitor';
            O.Loss_Reason_Description__c = 'test';
            update O;


    }
    
    static testMethod void testsoapupdatePR() {
        Opportunity OP = [SELECT opportunity_ID__c FROM Opportunity WHERE StageName = 'Implementation'
            AND Service_Type__c = 'NewLink'
            LIMIT 1
        ];
        test.starttest();
        SOAPUpdatePR.updatePR(Op.Opportunity_ID__c, '1', '2', '', 'COM', '', '', '20180522', '012');
        SOAPUpdatePR.updatePR(Op.Opportunity_ID__c, '1', '2', 'COM', '', '', '', '20180522', '012');
        SOAPUpdatePR.updatePR(Op.Opportunity_ID__c, '1', '2', 'WBA', '', '', '', '20180501', '012');
        Opportunity OP2 = [SELECT opportunity_ID__c FROM Opportunity WHERE StageName = 'Survey'
            LIMIT 1
        ];
        SOAPUpdatePR.updatePR(Op2.Opportunity_ID__c, '1', '2', '', 'CANCL', '', '', '20180522', '012');
		test.stoptest();
    }
    
    static testMethod void myUnitTestRelocation2() {
        // TO DO: implement unit test



        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
            LIMIT 1
        ];


        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%MPLS%'
            AND Revenue_Type__c = 'One Time'
            LIMIT 1
        ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE Name = 'MPLS - 1 Mbps'
            AND Revenue_Type__c = 'Recurring'
            LIMIT 1
        ];
        Account A = [SELECT id, OwnerID from Account where Organization_Type__c = 'Head Office'
            AND BP_Number__c = '706531'
            LIMIT 1
        ];
        User U = [SELECT id FROM User WHERE ID =: A.ownerid];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        test.starttest();

        Opportunity O = new Opportunity();
        OpportunityLineItem OLI = new OpportunityLineItem();
        OpportunityLineItem OLI2 = new OpportunityLineItem();
        String OpportunityID = '';
        system.runas(U) {

            O.Accountid = A.id;
            O.Account_Site_A__c = A.id;
            //O.RecordTypeid=rt.id;
            O.StageName = 'Prospecting';
            O.Name = 'Tes';
            O.CloseDate = system.today().adddays(10);
            O.Pricebook2id = PB.id;
            O.Periode_UOM__c = 'Month';
            O.BP_Payer__c = A.id;
            O.BP_Vat__c = A.id;
            O.BW_After__c = '5';
            insert O;


            /*  OLI.Product2id=Ptime.id;
              OLI.OpportunityID=O.id;
              OLI.revenue_type__c='One Time';
              OLI.UnitPrice=10000000;
              OLI.Quantity=1;
              insert OLI;
            */
            OLI2.Product2id = Precurring.id;
            OLI2.OpportunityID = O.id;
            OLI2.revenue_type__c = 'Recurring';
            OLI2.UnitPrice = 50000000;
            OLI2.Quantity = 1;
            OLI2.Billing_Type__c = 'Monthly';
            OLI2.Contract_Start_Date__c = system.today().adddays(-3);
            OLI2.Contract_End_Date__c = system.today().adddays(3);
            insert OLI2;
        }

        O.Service_Type__c = 'Relocation';
        O.LastMile_Type__c = 'Radio';
        O.Expected_RFS_Date__c = system.today().addmonths(3);
        O.Contract_Periode__c = 12;
        O.Periode_Uom__c = 'Week';
        O.SR__c = '22222';
        O.Site_A_Relocation_Street__c = 'Elm Street';
        o.Project_Coordinator__c = '90006544 Nancy Citraningrum';
        O.StageName = 'Waiting For Contract';
        O.PKS_Number__c = '222';
        update O;
    }
    
    static testMethod void testContractServices() {
        // TO DO: implement unit test

        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
            LIMIT 1
        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%MPLS%'
            AND Revenue_Type__c = 'One Time'
            LIMIT 1
        ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE Name = 'MPLS - 1 Mbps'
            AND Revenue_Type__c = 'Recurring'
            LIMIT 1
        ];
        Account A = [SELECT id, Ownerid from Account where Organization_Type__c = 'Head Office'
            AND BP_Number__c = '706531'
            LIMIT 1
        ];
        User U = [SELECT id FROM User WHERE ID =: A.ownerid];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        test.starttest();

        Opportunity O = new Opportunity();
        Contract ci = new Contract();
        String OpportunityID = '';


        Link__c L = new Link__c();

        system.runas(U) {

            O.Accountid = A.id;
            O.Account_Site_A__c = A.id;
            //O.RecordTypeid=rt.id;
            O.StageName = 'Prospecting';
            O.Name = 'Tes';
            O.CloseDate = system.today().adddays(10);
            O.Pricebook2id = PB.id;
            O.Periode_UOM__c = 'Month';
            O.service_type__c = 'Upgrade';
            insert O;

            ci.name = 'CI TEST';
            //         ci.Contract_Ticket__c = tmpContract.id;
            ci.Accountid = A.id;
            ci.Opportunity__c = O.id;

            insert Ci;


            L.Name = '0877722';
            L.contract_item_rel__c = ci.id;
            insert L;

            OpportunityLineItem OLI = new OpportunityLineItem();
            OLI.Product2id = Ptime.id;
            OLI.OpportunityID = O.id;
            OLI.revenue_type__c = 'One Time';
            OLI.UnitPrice = 10000000;
            OLI.Quantity = 1;
            OLI.Billing_Type__c = 'Monthly';
            insert OLI;

            O.link_related__c = L.id;
            update O;
            //delete OLI;
        }

        Contract_Services CS = new Contract_Services();
        //   CS.CreateContractsFromOpportunity(String.valueof(O.id));
    }

    static testMethod void newLinkValidationTest() {
        // TO DO: implement unit test

        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
            LIMIT 1
        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%MPLS%'
            AND Revenue_Type__c = 'One Time'
            LIMIT 1
        ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE Name = 'MPLS - 1 Mbps'
            AND Revenue_Type__c = 'Recurring'
            LIMIT 1
        ];
        Account A = [SELECT id, Ownerid from Account where Organization_Type__c = 'Head Office'
            LIMIT 1
        ];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        User U = [SELECT id FROM User WHERE ID =: A.ownerid];
        Account tmpAcc = new Account();
        tmpAcc.name = 'temp';
        tmpAcc.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        insert tmpAcc;

        test.starttest();

        Opportunity O = new Opportunity();
        String OpportunityID = '';
        system.runas(U) {

            O.service_type__c = 'Newlink';
            O.Accountid = A.id;
            O.Account_Site_A__c = tmpAcc.id;
            //O.RecordTypeid=rt.id;
            O.StageName = 'Prospecting';
            O.Name = 'Tes';
            O.CloseDate = system.today().adddays(10);
            O.Pricebook2id = PB.id;
            O.Periode_UOM__c = 'Month';
            insert O;
            
            OpportunityLineItem OLI = new OpportunityLineItem();
            OLI.Product2id = Ptime.id;
            OLI.OpportunityID = O.id;
            OLI.revenue_type__c = 'One Time';
            OLI.UnitPrice = 10000000;
            OLI.Quantity = 1;
            OLI.Billing_Type__c = 'Monthly';
            insert OLI;
            
            O.BP_payer__C = tmpAcc.id;
            O.BP_vat__C = tmpAcc.id;
            update O;

            Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();

            Profitability__c ProfitabilityForecats = new Profitability__c();
            ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
            ProfitabilityForecats.Name = 'Testing';
            ProfitabilityForecats.Account__c = O.AccountId;
            ProfitabilityForecats.Opportunity__c = O.Id;
            ProfitabilityForecats.Status__c = 'Forecast';
            ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
            ProfitabilityForecats.Deal_Price__c = 10000;
            ProfitabilityForecats.One_Time_Revenue__c = 10000;
            Insert ProfitabilityForecats;

            O.Profitability__c = ProfitabilityForecats.id;
			O.StageName = 'Closed Lost';
            O.Loss_Reason__c = 'Lost to Competitor';
            O.Loss_Reason_Description__c = 'test';
            update O;

        }
        test.stoptest();
    }
    
    static testMethod void newLinkwithStartDateTest() {
        // TO DO: implement unit test

        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Non GSM'
            LIMIT 1
        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%MPLS%'
            AND Revenue_Type__c = 'One Time'
            LIMIT 1
        ];
        Product2 PRecurring = [SELECT id FROM Product2 WHERE Name = 'MPLS - 1 Mbps'
            AND Revenue_Type__c = 'Recurring'
            LIMIT 1
        ];
        Account A = [SELECT id, Ownerid from Account where Organization_Type__c = 'Head Office'
            LIMIT 1
        ];
        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'MPLS'];
        User U = [SELECT id FROM User WHERE ID =: A.ownerid];
        Account tmpAcc = new Account();
        tmpAcc.name = 'temp';
        tmpAcc.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        insert tmpAcc;

        test.starttest();

        Opportunity O = new Opportunity();
        String OpportunityID = '';
        system.runas(U) {

            O.service_type__c = 'Newlink';
            O.Accountid = A.id;
            O.Account_Site_A__c = tmpAcc.id;
            //O.RecordTypeid=rt.id;
            O.StageName = 'Prospecting';
            O.Name = 'Tes';
            O.CloseDate = system.today().adddays(10);
            O.Pricebook2id = PB.id;
            O.Periode_UOM__c = 'Month';
            O.Contract_Periode__c = 12;
            insert O;
            
            OpportunityLineItem OLI2 = new OpportunityLineItem();
            OLI2.Product2id = Precurring.id;
            OLI2.OpportunityID = O.id;
            OLI2.revenue_type__c = 'Recurring';
            OLI2.UnitPrice = 50000000;
            OLI2.Quantity = 1;
            OLI2.Billing_Type__c = 'Monthly';
            OLI2.Contract_Start_Date__c = system.today().adddays(-3);
            OLI2.Contract_End_Date__c = system.today().adddays(3);
            insert OLI2;

            O.note__c = 'test';
            

            update O;

        }
        test.stoptest();
    }
    
    /*
    static testMethod void myUnitTestMarketPlace() {
        // TO DO: implement unit test



        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'B2B Marketplace'
            LIMIT 1
        ];
        Product2 Ptime = [SELECT id FROM Product2 WHERE Name LIKE '%Acronis%'
            LIMIT 1
        ];
        Account HQ = [SELECT id, OwnerID from Account where Organization_Type__c = 'Head Office'
            AND BP_Number__c = '706531'
            LIMIT 1
        ];
        Account A = [SELECT id from Account where Name = 'PT BESS Finance'
            AND BP_Number__C = '712822'
            AND ParentID =: HQ.id LIMIT 1
        ];
        User U = [SELECT id FROM User WHERE ID =: HQ.ownerid];

        Id recordTypeId_ProfitabilityNonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();


        Pricebook2 PB = [SELECT id from PriceBook2 WHERE Name = 'Marketplace'];
        Test.setMock(WebServiceMock.class, new SRPRTestWebServiceMock());
        AccountContactRelation CR = new AccountContactRelation();
        Contact C = new Contact();
        C.LastName = 'Wiryo';
        C.Accountid = HQ.id;
        C.Firstname = 'Yohn';
        C.MobilePhone = '0288282';
        C.Email = 'Fail@fail.com';
        insert C;
        CR.AccountID = A.id;
        CR.Contactid = C.id;
        CR.Roles = 'PIC Site;PIC BA Sign';
        insert CR;
        test.starttest();
        Opportunity O = new Opportunity();
        String OpportunityID = '';
        system.runas(U) {

            O.Accountid = HQ.id;
            O.Account_Site_A__c = HQ.id;
            O.Account_Site_B__c = A.id;
            O.StageName = 'Prospecting';
            O.Name = 'Tes';
            O.service__c = 'E-Commerce';
            
            O.CloseDate = system.today().adddays(10);
            O.Pricebook2id = PB.id;
            O.Periode_UOM__c = 'Month';

            O.BP_Payer__c = A.id;
            O.BP_Vat__c = A.id;
            insert O;

            Profitability__c ProfitabilityForecats = new Profitability__c();
            ProfitabilityForecats.recordTypeId = recordTypeId_ProfitabilityNonGsm;
            ProfitabilityForecats.Name = 'Testing';
            ProfitabilityForecats.Account__c = O.AccountId;
            ProfitabilityForecats.Opportunity__c = O.Id;
            ProfitabilityForecats.Status__c = 'Forecast';
            ProfitabilityForecats.Stage__c = 'Fill Forecast Cost';
            ProfitabilityForecats.Deal_Price__c = 10000;
            ProfitabilityForecats.One_Time_Revenue__c = 10000;
            Insert ProfitabilityForecats;

            O.Profitability__c = ProfitabilityForecats.id;
            update O;

            /*  OpportunityLineItem OLI=new OpportunityLineItem();
              OLI.Product2id=Ptime.id;
              OLI.OpportunityID=O.id;
              OLI.revenue_type__c='One Time';
              OLI.UnitPrice=10000000;
              OLI.Quantity=1;
              insert OLI;*/
    /*
            OpportunityLineItem OLI2 = new OpportunityLineItem();
            OLI2.Product2id = Ptime.id;
            OLI2.OpportunityID = O.id;
            OLI2.revenue_type__c = 'Recurring';
            OLI2.UnitPrice = 50000000;
            OLI2.Quantity = 1;
            OLI2.Billing_Type__c = 'Monthly';
            OLI2.Contract_Start_Date__c = system.today().adddays(-3);
            OLI2.Contract_End_Date__c = system.today().adddays(3);
            insert OLI2;
            

            O.Expected_RFS_Date__c = system.today().addmonths(3);
            O.Contract_Periode__c = 12;
            O.Periode_Uom__c = 'Day';
            O.StageName = 'survey';
            O.SR__c = '22222';
            O.COF_Number__c = '4';
            o.Project_Coordinator__c = '90006544 Nancy Citraningrum';
            update O;
            O.Site_B_Relocation_Street__c = 'Baker Street';
            O.Site_A_Relocation_Street__c = 'Elm Street';
            
            O.StageName = 'Implementation';
            update O;
            
            SR_PR_Notification__c PRtes=new SR_PR_Notification__c();
            PRTes.notif_type__c='PR';
            PRTes.account__c=O.Accountid;
            PRTes.Opportunity__c=O.id;
            PRTes.site_a__c=O.Account_site_a__c;
            PRTes.services__c='Voip';
            PRTes.BA_Sent_Date__c=system.today();
            PRTes.Status__c='Waiting for BA';
            PRTes.Project_Complete_Date__c=system.today();
            SR_PR__c SPN=SR_PR__c.getorgdefaults();
                String month='';
            String year='';
            if(system.today().month()<10)
            {
            month='0'+String.valueof(system.today().month());
            }
            else
                {
                    month=String.valueof(system.today().month());
            }	
    
            year=String.valueof(system.today().year()).right(2);
            String todaymonthyear=year+month;
            String PRNumber=todaymonthyear+'-'+String.valueof(SPN.PR_Number__c);
            PRNumber=PRNumber.replace('.0','');
            PRTes.Name='PR-'+PRNumber;
            if(O.Service_type__c=='NewLink')
            	PRTes.Project_type__c='New';
            	else
            	PRTes.Project_type__c=O.Service_Type__c;
           
            PRTes.Status__c='In Progress';
            PRTes.Notif_Date__c=system.today();
            PRTes.Normal_RFS__c=system.today().adddays(6);
            PRTes.UOM_Before__c=O.UOM_BW_Before__c;
            PRTes.Exp_RFS_Date__c=O.Expected_RFS_Date__c;
            PRTes.UOM_After__c=O.UOM_BW_After__c;
            PRTes.Capacity_Before__c=O.BW_Before__c;
            PRTes.Capacity_After__c=O.BW_After__c;
            PRTes.Project_Coordinator_Text__c=O.Project_Coordinator__c;
            insert PRTes;
        }

        O.RecordTypeid = rt.id;
        update O;

        O.Service_Type__c = 'E-Commerce';
        update O;

        O.StageName = 'Waiting for Contract';
        update O;
        
        O.trial__c = true;
        update O;

        O.StageName = 'Closed Lost';
        O.Loss_Reason__c = 'Lost to Competitor';
        O.Loss_Reason_Description__c = 'test';
        update O;

        test.stoptest();
    }
*/
    
    
    
}