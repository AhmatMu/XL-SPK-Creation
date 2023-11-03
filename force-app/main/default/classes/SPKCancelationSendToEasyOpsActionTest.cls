@isTest
public with sharing class SPKCancelationSendToEasyOpsActionTest {
    @TestSetup
    static void makeData(){
        insert new Transaction__c(
            transactionID__c = 125,
            Temporary_LA_or_IDCom__c = 2499
        );

        // create user
        User userReq = new User();
        userReq.FirstName           = 'user';
        userReq.LastName            = 'test';
        userReq.Email               = 'user****@gmail.com';
        userReq.Username            = 'user****@gmail.com';
        userReq.Alias               = 'userT';
        userReq.TimeZoneSidKey      = string.valueOf(UserInfo.getTimeZone());
        userReq.LocaleSidKey        = UserInfo.getLocale();
        userReq.EmailEncodingKey    = 'ISO-8859-1';
        userReq.LanguageLocaleKey   = UserInfo.getLanguage();
        userReq.ProfileId           = UserInfo.getProfileId();
        insert userReq;

        // create account
        TriggerBase.bypass('Account');

        Account accReq = new Account();
        // invoicing information
        accReq.Name                 = 'PT Solusi Jasa Teknologi';
        accReq.BP_Number__c         = '763451';
        accReq.Organization_Type__c = 'Head Office';
        accReq.Type                 = 'Customer';
        accReq.term_of_payment__c   = 'Z030 Within 30 Days Due Net';
        accReq.Customer_VAT_Name__c = 'PT Solusi Jasa Teknologi';
        accReq.RecordTypeId         = '0127F000000WXQMQA4'; //BP
        accReq.Phone                = '0251.7559955';
        accReq.Customer_Type__c     = 'NONGSM';
        // approval information
        accReq.Approval_Status__c   = 'Approved';
        // address information
        accReq.Billing_Address_Province__c  = 'Jawa Barat';
        accReq.Shipping_Address_Province__c = 'Jawa Barat';
        accReq.Billing_Address_City__c      = 'Kota Bogor';
        accReq.Shipping_Address_City__c     = 'Kota Bogor';
        // documents
        accReq.No_NPWP__c           = '946965548404000';
        accReq.NPWP_Expired_Date__c = Date.newInstance(2024, 2, 29);
        insert accReq;

        // create contact
        Contact conReq = new Contact();
        conReq.LastName     = 'Test';
        conReq.AccountId    = accReq.Id;
        conReq.Title        = 'Operation Management';
        conReq.Email        = 'test***@gmail.com';
        conReq.OwnerId      = userReq.Id;
        insert conReq;

        // ========== create circuit ==========
        TriggerBase.bypass('Circuit__c');

        Circuit__c cirReq = new Circuit__c();
        cirReq.Name         = '03-00054';
        cirReq.datacode__c  = 'circuitimport_201801';
        cirReq.OwnerId      = userReq.Id;
        insert cirReq;

        // ========== create link ==========
        TriggerBase.bypass('Link__c');

        Link__c linkReq = new Link__c();
        // information
        linkReq.Company_Name__c = 'PT Solusi Jasa Teknologi';
        linkReq.Name            = '03-00054';
        linkReq.Link_Id__c      = '006C9540L80';
        linkReq.Status_Link__c  = 'UNDER_PROJECT';
        linkReq.Service_Type__c = 'ISP';
        linkReq.UoM__c          = 'Mbps';
        linkReq.Routepath__c    = '764068 PT. SOLUSI JASA TEKNOLOGI JAW-JT-ENT-764068';
        // site information
        linkReq.Site_A_Name__c  = accReq.Id;
        linkReq.BP_Site_A__c    = '764068';
        // other information
        linkReq.CID__c      = '03-00054';
        linkReq.ID__c       = 'b9375814-da62-4e9d-a3dc-eaee1cdceee3';
        linkReq.BU__c       = 'ENTERPRISE';
        linkReq.OwnerId     = userReq.Id;
        
        insert linkReq;


        // ========== create opportunity ==========
        TriggerBase.bypass('Opportunity'); // bypass opportunity

        Opportunity oppReq = new Opportunity();
        // categorization
        oppReq.Service_Type__c          = 'Newlink';
        oppReq.Auto_Renewal__c          = true;
        oppReq.PIC_BA_Print__c          = conReq.Id;
        oppReq.OwnerId                  = userReq.Id;
        oppReq.Auto_Renewal_Periode__c  = 3;
        oppReq.Auto_Renewal_UOM__c      = 'Bulan';
        // opportunity information
        oppReq.Name                             = '[TEST 20231013] SPK Creation ISP Sojatek Wonogiri';
        // oppReq.AccountId                        = accReq.Id;
        oppReq.Description                      = 'BP Number: 764068';
        oppReq.BP_Payer__c                      = accReq.Id;
        oppReq.BP_VAT__c                        = accReq.Id;
        oppReq.Contract_Periode__c              = 12;
        oppReq.Periode_UOM__c                   = 'Month';
        oppReq.COF_Number__c                    = '123/SIT-TEST/123';
        // oppReq.Solution_PIC__c                  = conReq.Id;
        oppReq.CloseDate                        = Date.newInstance(2023, 10, 31);
        oppReq.Target_Closed_Date_Message__c    = 'You can only update Target Close Date 2 times.';
        oppReq.Actual_Closed_Date__c            = Date.newInstance(2023, 10, 31);
        oppReq.PO_Date__c                       = Date.newInstance(2023, 10, 13);
        oppReq.Expected_RFS_Date__c             = Date.newInstance(2023, 10, 13);
        oppReq.StageName                        = 'Implementation';
        oppReq.Probability                      = 50;
        // approval information
        oppReq.Remark__c    = 'Approved';
        // site information
        oppReq.Account_Site_A__c    = accReq.Id;
        oppReq.Link_Related__c      = linkReq.Id;
        // survey
        oppReq.SR__c = '2310-003628';
        // quotation final approval
        oppReq.Quotation_Final_Approval__c = 'Approved';
        // implementation
        oppReq.PR__c = '2310-002939';
        // technical details
        oppReq.BW_before__c             = '0';
        oppReq.BW_after__c              = '10';
        oppReq.Lastmile_Type__c         = 'Radio';
        oppReq.Uom_BW_Before__c         = 'Mbps';
        oppReq.Uom_BW_After__c          = 'Mbps';
        oppReq.Project_Coordinator__c   = '90006544 Nancy Citraningrum';
        // system information
        oppReq.Sales_Manager_Owner__c           = userReq.Id;
        oppReq.GM_Sales_of_Owner__c             = userReq.Id;
        oppReq.Sales_Manager_for_Approval__c    = userReq.Id;
        oppReq.Group_Head_for_Approval__c       = userReq.Id;

        insert oppReq;


        // ========== create srpr ==========
        TriggerBase.bypass('SR_PR_Notification__c'); // bypass sr pr notification

        // === create sr ===
        SR_PR_Notification__c srReq = new SR_PR_Notification__c();
        // information
        srReq.Name              = 'SR-2310-003628';
        srReq.Notif_Type__c     = 'SR';
        srReq.Project_Type__c   = 'New';
        srReq.Project_Name__c   = 'ISP - PT. SOLUSI JASA TEKNOLOGI,SOJATEK_15479714_PT. Semestanustra Distrindo Wonogiri';
        srReq.OwnerId           = userReq.Id;
        srReq.Opportunity__c    = oppReq.Id;
        srReq.Services__c       = 'MPLS';
        srReq.Status__c         = 'Close(Complete)';
        srReq.substatus__c      = 'Profitability Cost Complete';
        srReq.services__c       = 'L2VPN';
        // site information
        srReq.Site_A__c                     = accReq.Id;
        srReq.PIC_Site__c                   = conReq.Id;
        srReq.Link_Id__c                    = '020C9540L1';
        srReq.Project_Coordinator_Text__c   = '90006544 Nancy Citraningrum';
        // Technical Info
        srReq.Survey_Type__c            = 'P2P';
        srReq.Survey_LastMile_Type__c   = 'Lastmile by XL' + '\'' + 's MW';
        srReq.Type_of_Lastmile__c       = 'iPASOLINK';
        // Bandwith Information
        srReq.Capacity_Before__c    = '0';
        srReq.Capacity_After__c     = '10';
        srReq.UOM_before__c         = 'Mbps';
        srReq.UOM_After__c          = 'Mbps';
        // Dates
        srReq.Notif_Date__c             = Date.newInstance(2023, 10, 13);
        srReq.Survey_Date__c            = Date.newInstance(2023, 10, 13);
        srReq.Normal_RFS__c             = Date.newInstance(2023, 10, 19);
        srReq.Assign_Date__c            = Date.newInstance(2023, 10, 13);
        srReq.Survey_Complete_Date__c   = Date.newInstance(2023, 10, 13);
        srReq.Vendor_Assigned_Date__c   = Date.newInstance(2023, 10, 13);

        insert srReq;

        // === create pr ===
        SR_PR_Notification__c prReq = new SR_PR_Notification__c();
        // information
        prReq.Name                = 'PR-2310-002939';
        prReq.Notif_Type__c       = 'PR';
        prReq.Project_Type__c     = 'New';
        prReq.Project_Name__c     = 'ISP - PT. SOLUSI JASA TEKNOLOGI,SOJATEK_15479714_PT. Semestanustra Distrindo Wonogiri';
        prReq.OwnerId             = userReq.Id;
        prReq.Opportunity__c      = oppReq.Id;
        prReq.Services__c         = 'ISP';
        prReq.Status__c           = 'In Progress';
        prReq.substatus__c        = 'SPK Partner Administration';
        // site information
        prReq.Site_A__c           = accReq.Id;
        prReq.PIC_Site__c         = conReq.Id;
        
        insert prReq;   

        // create vendor
        Vendor__c vendorReq = new Vendor__c();
        vendorReq.Name              = 'PT SRC Indonesia';
        vendorReq.VendorId__c       = '887766';
        vendorReq.PIC__c            = 'src 1';
        vendorReq.Type__c           = 'Vendor';
        vendorReq.Phone__c          = '08764678634';
        vendorReq.SPK_to_PMIS__c    = false;
        vendorReq.is_Active__c      = true;
        vendorReq.OwnerId           = userReq.Id;
        vendorReq.listemail__c      = 'src1@gmail.com;src2@gmail.com;src3@gmail.com;';
        vendorReq.address__c        = 'Jl. ketapang';
        insert vendorReq;

        // create object lease
        Object_Lease__c objectLeaseReq = new Object_Lease__c();
        objectLeaseReq.name                 = 'Office Lease';
        objectLeaseReq.Object_Lease_Type__c = 'COGS';
        objectLeaseReq.is_Active__c         = true;
        insert objectLeaseReq;

        // create vendor object lease
        Vendor_Object_Lease__c volReq = new Vendor_Object_Lease__c();
        volReq.Object_Lease__c  = objectLeaseReq.Id;
        volReq.Vendor__c        = vendorReq.Id;
        volReq.Garansi_SLA__c   = 10;
        insert volReq;

        // create vendor spk type
        Vendor_SPK_Type__c spktRec = new Vendor_SPK_Type__c();
        spktRec.Vendor__c   = vendorReq.Id;
        spktRec.SPK_Type__c = 'Installation';
        spktRec.Need_PO__c  = true;
        insert spktRec;    
    }

    static testmethod void spkTriggerCancelation() {
        Account accRec              = [SELECT Id FROM Account WHERE Name = 'PT Solusi Jasa Teknologi'];
        User userRec                = [SELECT Id FROM User WHERE Username = 'user****@gmail.com'];
        Opportunity oppRec          = [SELECT Id FROM Opportunity WHERE Name = '[TEST 20231013] SPK Creation ISP Sojatek Wonogiri'];
        Vendor__c vendorRec         = [SELECT Id FROM Vendor__c WHERE VendorId__c = '887766'];
        SR_PR_Notification__c srRec = [SELECT Id FROM SR_PR_Notification__c WHERE Name = 'SR-2310-003628'];
        SR_PR_Notification__c prRec = [SELECT Id FROM SR_PR_Notification__c WHERE Name = 'PR-2310-002939'];
        Object_Lease__c objLeaseRec = [SELECT Id FROM Object_Lease__c WHERE Name = 'Office Lease'];

        // create spk
        List<SPK__c> spkRecords = new List<SPK__c>();
        SPK__c spkReq = new SPK__c();
        spkReq.Name                         = 'test spk';
        spkReq.SPK_Type__c                  = 'Installation';
        spkReq.SPK_Description__c           = '';
        spkReq.Account__c                   = accRec.Id;
        spkReq.Opportunity__c               = oppRec.Id;
        spkReq.Need_PO__c                   = true;
        spkReq.PIC_Name__c                  = 'Sojatek CRB';
        spkReq.PIC_Contact__c               = '0819876543';
        spkReq.Cancel_Reason__c             = 'Change Partner';
        spkReq.OwnerId                      = userRec.Id;
        spkReq.status__c                    = 'Sent to Partner';
        spkReq.SR_Rel__c                    = srRec.Id;
        spkReq.PR_Rel__c                    = prRec.Id;
        spkReq.Project_Coordinator_Email__c = 'usamah.ridha@saasten.com.invalid';
        // site information
        spkReq.Site__c                  = 'A';
        spkReq.Site_Assignment__c       = accRec.Id;
        spkReq.Other_Site_Assignment__c = null;
        // vendor information
        spkReq.Partner_Name__c  = vendorRec.Id;
        spkReq.Partner_Email__c = 'src1@gmail.com;src2@gmail.com;src3@gmail.com;';
        // object lease information
        spkReq.Object_Lease_Name__c         = objLeaseRec.Id;
        spkReq.Object_Lease_Description__c  = 'Office Lease COGS';
        // dates
        spkReq.Working_Start_Date__c    = Date.newInstance(2023, 10, 16);
        spkReq.Working_End_Date__c      = Date.newInstance(2023, 10, 23);
        spkReq.SPK_Date__c              = null;

        spkRecords.add(spkReq);

        SPKCancelationSendToEasyOpsAction.SPKRequest request = new SPKCancelationSendToEasyOpsAction.SPKRequest();
        request.spkListCancelation = spkRecords;

        Test.startTest();
        SPKCancelationSendToEasyOpsAction.SPKCancelationSendToEasyOpsAction(new List<SPKCancelationSendToEasyOpsAction.SPKRequest>{request});
        Test.stopTest();
    }
}