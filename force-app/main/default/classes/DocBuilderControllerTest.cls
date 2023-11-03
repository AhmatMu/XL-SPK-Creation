/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-09-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class DocBuilderControllerTest {
    @isTest static void schenario1(){
        
        //TEST CONSTRUCT
        Test.startTest();
        Pdf_Template__c Pdfobj = new Pdf_Template__c(
            Name = 'MPLS DOCUMENT TEMPLATE1',                                 // Pdf Template Name
            Main_Object__c = 'Opportunity',                                         // Main Object
            Size_Document__c = 'A4',                                        // Size Document
            Default_Document_Name__c = '%%Opportunity::PR_Rel__r.Name%',                          // Default Document Name
            Margin_Top__c = 4.00,                                       // Margin Top
            Margin_Bottom__c = 4.00,                                    // Margin Bottom
            Margin_Right__c = 1.70,                                     // Margin Right
            Margin_Left__c = 1.70, 
            Unit_Document__c = 'cm',                             // Unit Document
            Type_Document__c = 'potrait',                                     // Type Document
            Content_Footer_Margin__c = 50.00,
            Content_Header_Margin__c = 50.00, // Content Footer Margin
            Tex_Area_1__c = 'BERITA ACARA Selanjutnya disebut <table border="1" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td colspan="1" rowspan="1">Name</td><td colspan="1" rowspan="1">Qty</td><td colspan="1" rowspan="1">Price</td></tr><tr><td colspan="1" rowspan="1">%%OpportunityLineItem::Name%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::Quantity%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::UnitPrice%%</td></tr></tbody></table>, %%Opportunity::PR_Rel__r.Billing_Start_Date_IND__c%%\n\nBank Maybank Indonesia Tbk PT. XL Axiata TBK  %%StaticResource::signaturesigit%% Sigit Suhardono\n\n \n\n\n\t\t\tDiisi Oleh XL\n\n\t\t\tQuotation Number: %%Opportunity::PR_Rel__r.Opportunity_ID__c%%PR Notification: %%Opportunity::PR_Rel__r.Name%%Project ID: EWO Survey Number: SME: No\n\t\t\t',  // Tex Area 1
            Header__c = ' \n\t\t\t\t\t\tXL AXIATA\n\t\t\t \n\n\n \n',  // Header
            Footer__c = ' \t\t\tXL AXIATA \n\n'  // Footer
        );
        insert Pdfobj;
        Transaction__c TCObj = new Transaction__c(
            TransactionID__c = 1
        );
        insert TCObj;
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account AccObj = new Account(
            Name = 'CODENUSA1', // Account Name
            Organization_Type__c = 'Head Office', //
            RecordTypeId = RecordTypeAccId,              // Account Record Type
            Record_Type_Custom__c = 'BP',            // Record Type Custom
            Bizstore_Complete__c = false,            // Bizstore Complete
            Payer_For_GSM_Invoice__c = false,        // Payer For GSM Invoice
            Summary_Billing__c = false,              // Summary Billing
            Using_HO_Billing_Address__c = false     // Using HO Billing Address
        );
        insert AccObj;
        
        Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM VoIP').getRecordTypeId();
        
        Opportunity OppObj = new Opportunity(
            Service_Type__c = 'Newlink',                      // Service Type
            RecordTypeId = RecordTypeOppId,                         // Opportunity Record Type
            Project_Group__c = 'Test Fleetech Group',           // Project Group
            Auto_Renewal__c = false,                            // Auto Renewal
            trial__c = false,                                   // trial
            Name = 'Opportunity - 2',                           // Opportunity Name
            AccountId = AccObj.id,                            // Account Name
            CloseDate = Date.newInstance(2021,06, 30),              // Target Close Date
            Actual_Closed_Date__c = Date.newInstance(2021,06, 30),  // Closed Date
            Expected_RFS_Date__c = Date.newInstance(2021,06, 30),   // Expected RFS Date
            Contract_Periode__c = 12,                         // Contract Periode
            StageName = 'Prospecting',                          // Stage
            Periode_UOM__c = 'Month',                           // Periode UOM
            Probability = 0,                                    // Probability (%)
            Amount = 11.000,                                    // Amount
            Remark__c = 'Please Request Approval to Manager',   // Remark
            LeadSource = 'Other',                               // Lead Source
            BW_before__c = '0',                                 // Capacity before
            Uom_BW_Before__c = 'Mbps',                          // Uom BW Before
            BW_after__c = '0',                                  // Capacity after
            Uom_BW_After__c = 'Mbps'                           // Uom BW After
        );
        insert OppObj;
        Pricebook2 pb22 = new Pricebook2(Name='testNonDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCDXXX', isActive=true,Revenue_Type__c='One Time');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=25, OpportunityId=OppObj.Id,UnitPrice=1,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        DocBuilderController DocBuilderObj = new DocBuilderController(Pdfobj.Id,OppObj.Id);
        DocBuilderObj.replacementByType('document-content');
        DocBuilderObj.replacementByType('document-name');
        DocBuilderObj.getStringDocContent();
        DocBuilderObj.getStringDocName();
        DocBuilderObj.getStringDocFooter();
        DocBuilderObj.getStringDocHeader();
        DocBuilderObj.getStringDocImageFooter();
        DocBuilderObj.getStringTemplateContent();
        DocBuilderObj.getStringStyleSize();
        DocBuilderObj.getStringStyleMarginHF();
        DocBuilderObj.getStringStyleMarginContent();
        DocBuilderObj.getStringDocImageFooter();
        DocBuilderObj.getStringDocImageHeader();
        DocBuilderObj.generatePdfBlob();
        DocBuilderObj.attachPdfFileToRecord();
        DocBuilderObj.getStringStyleMarginContentH();
        DocBuilderObj.getStringStyleMarginContentF();
        DocBuilderObj.getBlobDocContent();
        Test.stopTest();
    }
    
    @isTest static void schenario2(){
        
        //TEST CONSTRUCT
        Test.startTest();
        Pdf_Template__c Pdfobj = new Pdf_Template__c(
            Name = 'MPLS DOCUMENT TEMPLATE1',                                 // Pdf Template Name
            Main_Object__c = 'Opportunity',                                         // Main Object
            Size_Document__c = 'A4',                                        // Size Document
            //Default_Document_Name__c = '%%Opportunity::PR_Rel__r.Name%', // Default Document Name
            Margin_Top__c = 4.00,                                       // Margin Top
            Margin_Bottom__c = 4.00,                                    // Margin Bottom
            Margin_Right__c = 1.70,                                     // Margin Right
            Margin_Left__c = 1.70, 
            Unit_Document__c = 'cm',                             // Unit Document
            Type_Document__c = 'potrait',                                     // Type Document
            Content_Footer_Margin__c = 50.00,
            Content_Header_Margin__c = 50.00, // Content Footer Margin
            //Tex_Area_1__c = 'BERITA ACARA Selanjutnya disebut <table border="1" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td colspan="1" rowspan="1">Name</td><td colspan="1" rowspan="1">Qty</td><td colspan="1" rowspan="1">Price</td></tr><tr><td colspan="1" rowspan="1">%%OpportunityLineItem::Name%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::Quantity%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::UnitPrice%%</td></tr></tbody></table>, %%Opportunity::PR_Rel__r.Billing_Start_Date_IND__c%%\n\nBank Maybank Indonesia Tbk PT. XL Axiata TBK  %%StaticResource::signaturesigit%% Sigit Suhardono\n\n \n\n\n\t\t\tDiisi Oleh XL\n\n\t\t\tQuotation Number: %%Opportunity::PR_Rel__r.Opportunity_ID__c%%PR Notification: %%Opportunity::PR_Rel__r.Name%%Project ID: EWO Survey Number: SME: No\n\t\t\t',  // Tex Area 1
            Header__c = ' \n\t\t\t\t\t\tXL AXIATA\n\t\t\t \n\n\n \n',  // Header
            Footer__c = ' \t\t\tXL AXIATA \n\n'  // Footer
        );
        insert Pdfobj;
        Transaction__c TCObj = new Transaction__c(
            TransactionID__c = 1
        );
        insert TCObj;
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account AccObj = new Account(
            Name = 'CODENUSA2', // Account Name
            Organization_Type__c = 'Head Office', //
            RecordTypeId = RecordTypeAccId,              // Account Record Type
            Record_Type_Custom__c = 'BP',            // Record Type Custom
            Bizstore_Complete__c = false,            // Bizstore Complete
            Payer_For_GSM_Invoice__c = false,        // Payer For GSM Invoice
            Summary_Billing__c = false,              // Summary Billing
            Using_HO_Billing_Address__c = false     // Using HO Billing Address
        );
        insert AccObj;
        
        Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM VoIP').getRecordTypeId();
        
        Opportunity OppObj = new Opportunity(
            Service_Type__c = 'Newlink',                      // Service Type
            RecordTypeId = RecordTypeOppId,                         // Opportunity Record Type
            Project_Group__c = 'Test Fleetech Group',           // Project Group
            Auto_Renewal__c = false,                            // Auto Renewal
            trial__c = false,                                   // trial
            Name = 'Opportunity - 3',                           // Opportunity Name
            AccountId = AccObj.id,                            // Account Name
            CloseDate = Date.newInstance(2021,06, 30),              // Target Close Date
            Actual_Closed_Date__c = Date.newInstance(2021,06, 30),  // Closed Date
            Expected_RFS_Date__c = Date.newInstance(2021,06, 30),   // Expected RFS Date
            Contract_Periode__c = 12,                         // Contract Periode
            StageName = 'Prospecting',                          // Stage
            Periode_UOM__c = 'Month',                           // Periode UOM
            Probability = 0,                                    // Probability (%)
            Amount = 11.000,                                    // Amount
            Remark__c = 'Please Request Approval to Manager',   // Remark
            LeadSource = 'Other',                               // Lead Source
            BW_before__c = '0',                                 // Capacity before
            Uom_BW_Before__c = 'Mbps',                          // Uom BW Before
            BW_after__c = '0',                                  // Capacity after
            Uom_BW_After__c = 'Mbps'                           // Uom BW After
        );
        insert OppObj;
        Pricebook2 pb22 = new Pricebook2(Name='testNonDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCDXXX', isActive=true,Revenue_Type__c='One Time');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=25, OpportunityId=OppObj.Id,UnitPrice=1,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        DocBuilderController DocBuilderObj = new DocBuilderController(Pdfobj.Id,OppObj.Id);
        DocBuilderObj.replacementByType('document-content');
        DocBuilderObj.replacementByType('document-name');
        DocBuilderObj.getStringDocContent();
        DocBuilderObj.getStringDocName();
        DocBuilderObj.getStringDocFooter();
        DocBuilderObj.getStringDocHeader();
        DocBuilderObj.getStringDocImageFooter();
        DocBuilderObj.getStringTemplateContent();
        DocBuilderObj.getStringStyleSize();
        DocBuilderObj.getStringStyleMarginHF();
        DocBuilderObj.getStringStyleMarginContent();
        DocBuilderObj.getStringDocImageFooter();
        DocBuilderObj.getStringDocImageHeader();
        DocBuilderObj.generatePdfBlob();
        DocBuilderObj.attachPdfFileToRecord();
        DocBuilderObj.getStringStyleMarginContentH();
        DocBuilderObj.getStringStyleMarginContentF();
        DocBuilderObj.getBlobDocContent();
        Test.stopTest();
    }
}