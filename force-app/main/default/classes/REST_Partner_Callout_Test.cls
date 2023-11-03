@isTest
public with sharing class REST_Partner_Callout_Test {
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
        Account accReq = new Account();
        accReq.Name                         = 'acc test';
        accReq.term_of_payment__c           = 'Z030 Within 30 Days Due Net';
        accReq.Billing_Address_Province__c  = 'Bali';
        accReq.Billing_Address_City__c      = 'Kabupaten Buleleng';
        accReq.Shipping_Address_Province__c = 'Bali';
        accReq.Shipping_Address_City__c     = 'Kabupaten Buleleng';
        accReq.Organization_Type__c         = 'Head Office';
        accReq.Customer_Type__c             = 'NONGSM';
        accReq.OwnerId                      = userReq.Id;
        insert accReq;
    }

    static testmethod void partner_test(){
        Account accReq = [SELECT Id FROM Account WHERE Name = 'acc test'];
        User userReq = [SELECT Id FROM user WHERE Username = 'user****@gmail.com'];

        // TODO:: continue create test class
        SingleRequestMock getAccessToken = new SingleRequestMock(
            200,
            'success',
            '{"token":"2345678908765435467890"}',
            null
        );

        SingleRequestMock reqPartnerCreation = new SingleRequestMock(
            200,
            'success',
            '{"success":false,"status":200,"message":null,"data":{"guid":"d79c2743-207a-4fb0-98a2-e9e8a7cf8cc3","partner_id":"12345"}}',
            null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_EasyOps_GetToken_Endpoint, getAccessToken);
        endpoint2TestResp.put(label.REST_EasyOps_PartnerCreation_Endpoint, reqPartnerCreation);

        System.debug('=== endpoint2TestResp : ' + endpoint2TestResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        System.debug('=== multiCalloutMock : ' + multiCalloutMock);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Easy_Ops_API_Setting__c getToken = new Easy_Ops_API_Setting__c();
        getToken.name           = 'getToken2';
        getToken.uri__c         = 'https://easy-ops.xl.co.id/dev/api';
        getToken.url__c         = '/auth/token';
        getToken.Username__c    = 'apidemo';
        getToken.Password__c    = 'Password*1';
        insert getToken;

        Easy_Ops_API_Setting__c sync_partner = new Easy_Ops_API_Setting__c();
        sync_partner.name          = 'SyncPatner';
        sync_partner.uri__c        = 'https://easy-ops.xl.co.id/dev/api';
        sync_partner.url__c        = '/sync_partner';
        sync_partner.Username__c   = '';
        sync_partner.Password__c   = '';
        insert sync_partner;

        
        // create contact
        Contact conReq = new Contact();
        conReq.LastName     = 'Test';
        conReq.AccountId    = accReq.Id;
        conReq.Title        = 'Operation Management';
        conReq.Email        = 'test***@gmail.com';
        conReq.OwnerId      = userReq.Id;
        insert conReq;

        // create opportunity
        Opportunity oppReq = new Opportunity();
        oppReq.Name                     = 'oppty test';
        oppReq.AccountId                = accReq.Id;
        oppReq.StageName                = 'Implementation';
        oppReq.CloseDate                = Date.newInstance(2022, 11, 12);
        oppReq.OwnerId                  = userReq.Id;
        oppReq.Project_Coordinator__c   = '90007048 Rifqi Dimas Febriyanto';
        insert oppReq;

        // create link
        Link__c linkReq = new Link__c();
        linkReq.Name            = '02-00084';
        linkReq.Site_A_Name__c  = accReq.Id;
        linkReq.UoM__c          = 'Mbps';
        insert linkReq;

        // create sr pr notification
        SR_PR_Notification__c createSRReq = new SR_PR_Notification__c();
        createSRReq.Name                        = 'SR-2309-000001';
        createSRReq.OwnerId                     = userReq.Id;
        createSRReq.Notif_Type__c               = 'SR';
        createSRReq.Opportunity__c              = oppReq.Id;
        createSRReq.Project_Type__c             = 'Licensed';
        createSRReq.Services__c                 = 'MPLS';
        createSRReq.Project_Name__c             = 'MPLS - PT Test';
        createSRReq.Status__c                   = 'Close(Complete)';
        createSRReq.substatus__c                = 'Waiting profitability by Sol-Ar';
        createSRReq.Site_A__c                   = accReq.Id;
        createSRReq.PIC_Site__c                 = conReq.Id;
        createSRReq.Survey_Type__c              = 'P2P';
        createSRReq.Capacity_Before__c          = '0';
        createSRReq.UoM_before__c               = 'Mbps';
        createSRReq.Capacity_After__c           = '100';
        createSRReq.UoM_After__c                = 'Mbps';
        createSRReq.Notif_Date__c               = Date.newInstance(2022, 6, 27);
        createSRReq.Assign_Date__c              = Date.newInstance(2022, 6, 28);
        createSRReq.Survey_Date__c              = Date.newInstance(2022, 6, 27);
        createSRReq.Survey_Complete_Date__c     = Date.newInstance(2022, 6, 29);
        createSRReq.Solution_Request_Date__c    = Date.newInstance(2022, 6, 28);
        createSRReq.Solution_Complete_Date__c   = Date.newInstance(2022, 6, 27);
        createSRReq.Normal_RFS__c               = Date.newInstance(2022, 7, 3);
        createSRReq.Result_Date__c              = Date.newInstance(2022, 6, 27);
        insert createSRReq;

        SR_PR_Notification__c createPRReq = new SR_PR_Notification__c();
        createPRReq.Name                        = 'PR-2309-000001';
        createPRReq.OwnerId                     = userReq.Id;
        createPRReq.Notif_Type__c               = 'PR';
        createPRReq.Opportunity__c              = oppReq.Id;
        createPRReq.Project_Type__c             = 'Downgrade';
        createPRReq.Services__c                 = 'L2VPN';
        createPRReq.Project_Name__c             = 'L2VPN - PT Test';
        createPRReq.Status__c                   = 'In Progress';
        createPRReq.substatus__c                = 'Prepare & Delivery Material';
        createPRReq.Reasons__c                  = 'R10 Customer - Permit';
        createPRReq.Site_A__c                   = accReq.Id;
        createPRReq.PIC_Site__c                 = conReq.Id;
        createPRReq.Link_Id__c                  = linkReq.Id;
        createPRReq.Capacity_Before__c          = '0';
        createPRReq.UoM_before__c               = 'Mbps';
        createPRReq.Capacity_After__c           = '100';
        createPRReq.UoM_After__c                = 'Mbps';
        createPRReq.Notif_Date__c               = Date.newInstance(2022, 6, 29);
        createPRReq.Normal_RFS__c               = Date.newInstance(2022, 7, 13);
        createPRReq.Exp_RFS_Date__c             = Date.newInstance(2022, 7, 13);
        createPRReq.WFI_Date__c                 = Date.newInstance(2022, 9, 20);
        createPRReq.Billing_Start_Date__c       = Date.newInstance(2022, 7, 13);
        insert createPRReq;

        // create srpr vendor
        SRPR_Vendor__c srprVendorReq = new SRPR_Vendor__c();
        // srprVendorReq.Name                  = 'SRPR-Vendor-220923-000001';
        srprVendorReq.OwnerId               = userReq.Id;
        srprVendorReq.Last_SR__c            = createSRReq.Id;
        srprVendorReq.Last_PR_Rel__c        = createPRReq.Id;
        srprVendorReq.Opportunity_Rel__c    = oppReq.Id;
        insert srprVendorReq;

        // create spk
        SPK__c spkReq = new SPK__c();
        spkReq.Name                         = 'test spk';
        // spkReq.Status__c                    = null;
        // spkReq.PR_Rel__c                    = createPRReq.Id;
        // spkReq.OwnerId                      = userReq.Id;
        // spkReq.Partner__c                   = null;
        // // spkReq.Object_Lease__c              = null;
        // // spkReq.SPK_Type__c                  = 'Installation';
        // spkReq.Working_Start_Date__c        = Date.newInstance(2023, 9, 17);
        // spkReq.Working_End_Date__c          = Date.newInstance(2023, 9, 20);
        // spkReq.SPK_Date__c                  = Date.newInstance(2023, 9, 21);
        // spkReq.SPK_Description__c           = 'relokasi ATM';
        // spkReq.Link__c                      = linkReq.Id;
        // spkReq.Account__c                   = accReq.Id;
        // // spkReq.Site_A__c                    = accReq.Id;
        // // spkReq.Site_B__c                    = null;
        // spkReq.SR__c                        = oppReq.Id;
        // spkReq.PIC_Site__c                  = conReq.Id;
        // spkReq.PIC_Site_B__c                = null;
        // spkReq.Project_Coordinator_Email__c = 'test***@gmail.com';
        // spkReq.Capacity_Before__c           = '64';
        // spkReq.Capacity_After__c            = '128';
        // spkReq.PQ_Number__c                 = '-';
        // spkReq.PIC_Email__c                 = 'test****@gmail.com';
        // spkReq.Need_PO__c                   = false;
        // spkReq.Notes__c                     = '-';
        insert spkReq;

        Vendor__c vendorReq = new Vendor__c();
        vendorReq.Name  = 'Test vendor';
        insert vendorReq;

        Test.startTest();

        REST_Partner_Callout.getAccessToken();
        REST_Partner_Callout.requestVendorCreationToEasyOpsByVendorId(vendorReq.Id);

        Test.stopTest();
    }
}