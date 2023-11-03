@isTest(seeAllData=false)
private with sharing class Test_SendWBAUtils {
    // DIGANTI JADI CREATE DATA
    static testMethod void doScenario1Test() {
        
        Pdf_Template__c Pdfobj = new Pdf_Template__c(
            Name = 'BA VOIP',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        // Pdf Template Name
            Main_Object__c = 'Opportunity',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            // Main Object
            Size_Document__c = 'A4',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Size Document
            Default_Document_Name__c = ' %%Opportunity::Name%%',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                // Default Document Name
            Margin_Top__c = 4.00,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    // Margin Top
            Margin_Bottom__c = 4.00,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 // Margin Bottom
            Margin_Right__c = 1.70,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  // Margin Right
            Margin_Left__c = 1.70,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Margin Left
            Unit_Document__c = 'cm',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Unit Document
            Type_Document__c = 'potrait',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              // Type Document
            Content_Footer_Margin__c = 50.00,
            Content_Header_Margin__c = 50.00, // Content Footer Margin
            Tex_Area_1__c = 'BERITA ACARA Selanjutnya disebut <table border="1" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td colspan="1" rowspan="1">Name</td><td colspan="1" rowspan="1">Qty</td><td colspan="1" rowspan="1">Price</td></tr><tr><td colspan="1" rowspan="1">%%OpportunityLineItem::Name%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::Quantity%%</td><td colspan="1" rowspan="1">%%OpportunityLineItem::UnitPrice%%</td></tr></tbody></table>, %%Opportunity::PR_Rel__r.Billing_Start_Date_IND__c%%\n\nBank Maybank Indonesia Tbk PT. XL Axiata TBK  %%StaticResource::signaturesigit%% Sigit Suhardono\n\n \n\n\n\t\t\tDiisi Oleh XL\n\n\t\t\tQuotation Number: %%Opportunity::PR_Rel__r.Opportunity_ID__c%%PR Notification: %%Opportunity::PR_Rel__r.Name%%Project ID: EWO Survey Number: SME: No\n\t\t\t',  // Tex Area 1
            Header__c = ' \n\t\t\t\t\t\tXL AXIATA\n\t\t\t \n\n\n \n',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  // Header
            Footer__c = ' \t\t\tXL AXIATA \n\n'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       // Footer
        );
        insert Pdfobj;
        
        Template_Mapping__c Tmc = new Template_Mapping__c(
            Name = 'BA TEMPLATE VOIP',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           // Main Object
            Type__c = 'BA',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Size Document
            Product_Code__c = 'VOIP',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                // Default Document Name
            Template__c = Pdfobj.Id
        );
        insert Tmc;
        
        Transaction__c TCObj = new Transaction__c(
            TransactionID__c = 1
        );
        insert TCObj;
        
        Id RecordTypeAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account AccObj = new Account(
            Name = 'PT Hino Nusa Indonesia',                // Account Name
            RecordTypeId = RecordTypeAccId,                          // Account Record Type
            BP_Number__c = '762832',                             // BP Number
            Organization_Type__c = 'Head Office',                // Organization Type
            Type = 'Customer',                                   // Type
            Unique_Name__c = 'Jakarta',                          // Unique Name
            Keyword__c = 'Hino',                                 // Keyword
            Customer_Type__c = 'NONGSM',                         // Customer Type
            Industry = 'Other',                                  // Industry
            Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
            Is_New_Customer__c = false,                          // Is New Customer
            Kwitansi__c = false,                                 // Kwitansi
            Faktur_Pajak__c = false,                             // Faktur Pajak
            Summary_Billing__c = false,                          // Summary Billing
            summary_invoice__c = false,                          // summary invoice
            Approval_Status__c = 'Approved',                     // Approval Status
            Using_HO_Billing_Address__c = false
         
        );
        insert AccObj;
        
        Contact ContactObj = new Contact(
            AccountId = AccObj.id,                                 // Account Name
            FirstName = 'Diky',
            LastName='Nurosid',
            Email = 'dikky_sulaiman@hinofinance.co.id.invalid.invalid',  // Email
            MobilePhone = '0212128600'                                // Mobile
        );
        insert ContactObj;
        
        Account accRecord2=new account(
            Name = 'CODENUSA3',                // Account Name
            RecordTypeId = RecordTypeAccId,                          // Account Record Type
            BP_Number__c = '762832',                             // BP Number
            Organization_Type__c = 'Head Office',                // Organization Type
            Type = 'Customer',                                   // Type
            Unique_Name__c = 'Jakarta',                          // Unique Name
            Keyword__c = 'Hino',                                 // Keyword
            Customer_Type__c = 'NONGSM',                         // Customer Type
            Industry = 'Other',                                  // Industry
            Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
            term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
            Is_New_Customer__c = false,                          // Is New Customer
            Kwitansi__c = false,                                 // Kwitansi
            Faktur_Pajak__c = false,                             // Faktur Pajak
            Summary_Billing__c = false,                          // Summary Billing
            summary_invoice__c = false,                          // summary invoice
            Approval_Status__c = 'Approved',                     // Approval Status
            Using_HO_Billing_Address__c = false
        );
        
        insert accRecord2;
        
        AccountContactRelation acr = new AccountContactRelation(); 
        acr.Accountid = accRecord2.id;
        acr.Contactid = ContactObj.id;
        acr.roles = 'PIC BA Print;PIC BA Recipient';
        
        insert acr;
        
        Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM VoIP (existing link)').getRecordTypeId();
        
        Opportunity OppObj = new Opportunity(
            Service_Type__c = 'ChangePrice VoIP',                      // Service Type
            RecordTypeId = RecordTypeOppId,                         // Opportunity Record Type
            Project_Group__c = 'Test Fleetech Group',           // Project Group
            Auto_Renewal__c = false,                            // Auto Renewal
            trial__c = false,                                   // trial
            Name = 'Opportunity - 2',                           // Opportunity Name
            AccountId = accRecord2.id,                            // Account Name
            CloseDate = Date.newInstance(2021,06, 30),              // Target Close Date
            Actual_Closed_Date__c = Date.newInstance(2021,06, 30),  // Closed Date
            Expected_RFS_Date__c = Date.newInstance(2021,06, 30),   // Expected RFS Date
            Contract_Periode__c = 12,                         // Contract Periode
            StageName = 'Implementation',                          // Stage
            Periode_UOM__c = 'Month',                           // Periode UOM
            Probability = 0,                                    // Probability (%)
            Amount = 11.000,                                    // Amount
            Remark__c = 'Please Request Approval to Manager',   // Remark
            LeadSource = 'Other',                               // Lead Source
            BW_before__c = '0',                                 // Capacity before
            Uom_BW_Before__c = 'Mbps',                          // Uom BW Before
            BW_after__c = '0',                                  // Capacity after
            Uom_BW_After__c = 'Mbps',
            PIC_BA_Print__c = ContactObj.id,
            Doc_Template__c = Pdfobj.id
        );
        insert OppObj;
        Pricebook2 pb22 = new Pricebook2(Name='testNonDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='Instalasi 2 MPLS', isActive=true,Family='Non-GSM',Product_Code2__c='MPLS',Revenue_Type__c='One Time');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=25, OpportunityId=OppObj.Id,UnitPrice=1,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        SR_PR_Notification__c PRtes=new SR_PR_Notification__c();
        PRTes.notif_type__c='PR';
        PRTes.account__c=OppObj.Accountid;
        PRTes.Opportunity__c=OppObj.id;
        PRTes.site_a__c=OppObj.Account_site_a__c;
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
        if(OppObj.Service_type__c=='NewLink')
            PRTes.Project_type__c='New';
        else
            PRTes.Project_type__c=OppObj.Service_Type__c;
        PRTes.Status__c='In Progress';
        
        PRTes.Notif_Date__c=system.today();
        PRTes.Normal_RFS__c=system.today().adddays(6);
        PRTes.UOM_Before__c=OppObj.UOM_BW_Before__c;
        PRTes.Exp_RFS_Date__c=OppObj.Expected_RFS_Date__c;
        PRTes.UOM_After__c=OppObj.UOM_BW_After__c;
        PRTes.Capacity_Before__c=OppObj.BW_Before__c;
        PRTes.Capacity_After__c=OppObj.BW_After__c;
        PRTes.Project_Coordinator_Text__c=OppObj.Project_Coordinator__c;
        insert PRTes;
        test.starttest();
        apexpages.standardcontroller sc=new apexpages.standardcontroller(OppObj);
        
        SendWBAUtils swu=new SendWBAUtils(SC);
        
        swu.sendemail();
        swu.cancel();
        test.stoptest();
        
        /*
Opportunity O=[SELECT id,name,service_type__c,router_type__c,accountid,solution_pic__c,SR_Status__c,Account_Site_A__c,UOM_BW_Before__c,UOM_BW_After__c,BW_Before__c,BW_After__c,Account_Site_A_Full_Address__c,SR__c,Project_Coordinator__c,Expected_RFS_Date__c,Lastmile_type__c,trial__c,auto_renewal__c FROM Opportunity WHERE StageName='Implementation' AND Amount>0 AND PIC_BA_Print__c!=null ORDER BY CREATEDDATE DESC LIMIT 1];

test.starttest();
O.Trial__c=true;
O.Auto_Renewal__c=true;
update O;
list<SR_PR_Notification__c> listSRPR=[SELECT id FROM SR_PR_Notification__c WHERE Opportunity__c=:O.id AND Notif_type__c='PR' ];

SR_PR_Notification__c PRtes=new SR_PR_Notification__c();
if(listSRPR.size()>0)
{
delete listSRPR;
}
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


apexpages.standardcontroller sc=new apexpages.standardcontroller(O);

sendwbautils swu=new sendwbautils(SC);
wbautils wu=new wbautils(SC);
PageReference sendwba = Page.sendwba;
sendwba.getParameters().put('Id', String.valueOf(O.id));
Test.setCurrentPage(sendwba);  
swu.sendemail();
swu.cancel();
test.stoptest();
*/
        
    }
    
}