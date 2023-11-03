@isTest

//Test Class For File_BAP_Attachment_Public_URL And Schedule_BAP_Approval
private class Test_Schedule_BAP_Approval {
    
    static testmethod void Test01() {
        BAPGeneralSetting__c  BAPSetting = new BAPGeneralSetting__c (
            Name = 'test',
            AutoApprovedCHIEFafterxdays__c = 5,
            AutoApprovedCHIEFDayType__c = 'BUSINESS_DAY',
            AutoApprovedGHafterxdays__c = 5,
            AutoApprovedGHDayType__c = 'BUSINESS_DAY',
            isAutoApprovedforCHIEF__c = TRUE,
            isAutoApprovedforGH__c = TRUE
        );
        insert BAPSetting;
        
        insert new Transaction__c(transactionID__c = 1);
      
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='BP'];
        Account A = new Account(
	  	Name = 'PT Bank Permata Tbk',                      // Account Name
	  	BP_Number__c = '757677',                             // BP Number
	  	Organization_Type__c = 'Head Office',                // Organization Type
	  	Type = 'Customer',                                   // Type
	  	RecordTypeId = RT.id,                          // Account Record Type
	  	Unique_Name__c = 'Kantor Kemenag Lombok',            // Unique Name
	  	Keyword__c = 'BP',                                   // Keyword
	  	term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
	  	Customer_VAT_Name__c = 'PT Bank Permata Tbk',        // Customer VAT Name
	  	Customer_Type__c = 'NONGSM',                         // Customer Type
	  	Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
	  	Summary_Billing__c = false,                          // Summary Billing
	  	Approval_Status__c = 'Approved',                     // Approval Status
	  	Using_HO_Billing_Address__c = false,                 // Using HO Billing Address
	  	No_NPWP__c = '000009090909090'                      // No NPWP
		);
		insert A;
        
      	//User sUser = [SELECT id FROM User WHERE Email = 'yogis@xl.co.id'];
      	//User sMgr = [SELECT id FROM User WHERE Name = 'Rudy Sumadi'];
      	//
      	//
      	User mgr3 = new User();
        mgr3.Email = 'sarah@gmail.com';
        mgr3.Username = 'sarah@xlsaasten.com'; 
        mgr3.LastName = 'sarah'; 
        mgr3.Alias = 'mgr3'; 
        mgr3.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr3.LocaleSidKey = 'in_ID'; 
        mgr3.EmailEncodingKey = 'ISO-8859-1'; 
        mgr3.ProfileId = '00e7F000000trIRQAY'; 
        mgr3.LanguageLocaleKey = 'en_US';
        insert mgr3;
        
        
        User mgr2 = new User();
        mgr2.Email = 'muiqbal21113@gmail.com';
        mgr2.ManagerId = mgr3.id;
        mgr2.Username = 'mgr2@xlsaasten.com'; 
        mgr2.LastName = 'mgr2'; 
        mgr2.Alias = 'mgr2'; 
        mgr2.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr2.LocaleSidKey = 'in_ID'; 
        mgr2.EmailEncodingKey = 'ISO-8859-1'; 
        mgr2.ProfileId = '00e7F000000trIRQAY'; 
        mgr2.LanguageLocaleKey = 'en_US';
        insert mgr2;
        
        User mgr1 = new User();
        mgr1.Email = 'muhammad.iqbal@saasten.com';
        mgr1.ManagerId = mgr2.id;
        mgr1.Username = 'mgr1@xlsaasten.com'; 
        mgr1.LastName = 'mgr1'; 
        mgr1.Alias = 'mgr1'; 
        mgr1.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr1.LocaleSidKey = 'in_ID'; 
        mgr1.EmailEncodingKey = 'ISO-8859-1'; 
        mgr1.ProfileId = '00e7F000000trIRQAY'; 
        mgr1.LanguageLocaleKey = 'en_US';
        insert mgr1;
        
        User sales = new User();
        sales.Email = 'muiqbal2111@gmail.com';
        sales.ManagerId = mgr1.id;
        sales.Username = 'sales@xlsaasten.com'; 
        sales.LastName = 'Sales'; 
        sales.Alias = 'sls'; 
        sales.TimeZoneSidKey = 'Asia/Bangkok'; 
        sales.LocaleSidKey = 'in_ID'; 
        sales.EmailEncodingKey = 'ISO-8859-1'; 
        sales.ProfileId = '00e7F000000trIRQAY'; 
        sales.LanguageLocaleKey = 'en_US';
         
        insert sales;
        
        Link__c L=new Link__c();
        L.Name='9393';
        L.Service_type__c='MPLS';
        L.site_A_Name__c=A.id;
        L.Free_Link__c=true;
        insert L;
        
        BAP__c BAP=new BAP__c();
        BAP.OwnerId = sales.id;
        BAP.Customer__c=A.id;
        //BAP.isbackdate__c=true;
        //BAP.ispenalty__c=true;
        //BAP.IsCostPartner__c=true;
        BAP.Backdate_Approval_Status__c=null;
        BAP.Penalty_Approval_Status__c=null;
        BAP.request_date__c=system.today().adddays(-10);
        BAP.Link__c=L.id;
        BAP.Note__c='test Note';
		BAP.PIC_email__c = 'testEmail@tes.com';
		BAP.PIC_Name__c = 'Test Name'; 
		BAP.PIC_Phone__c='089786979889'; 
		BAP.PIC_Position__c='POsisition'; 
		BAP.Reason__c='Kontrak berakhir atau tidak diperpanjang';
		BAP.Sales_Group_Head__c = mgr2.id;
        insert BAP;
        system.debug ('======== BAP.request_date__c 1 : ' + BAP.request_date__c);
        
        BAP.request_date__c=system.today().adddays(-10);
        BAP.isbackdate__c=true;
        BAP.ispenalty__c=true;
        BAP.IsCostPartner__c=true;
        BAP.Request_Status__c = 'Iom Approval';
        update BAP;
        
        system.debug ('======== BAP ID TTT ADALAH : ' + BAP.id);
        system.debug ('======== BAP.request_date__c 2 : ' + BAP.request_date__c);
        
        
        /*
        BAP__c BAP = new BAP__c(
		  BAP_ID__c = '9287',                                                                                     // BAP ID
		  Name = 'BAP 02-04332 PT Bank Permata Tbk  Kantor Kemenag Lombok',                                         // BAP Name
		  Request_Status__c = 'BAP Iom Approval',                                                                           // Request Status
		  Type_of_Request__c = 'Pemutusan',                                                                         // Type of Request
		  Links_Info__c = '1. 007C1049L6',                                                                          // Links Info
		  Customer__c = A.id,                                                                                // Customer
		  Sirkit__c = 'PT Bank Permata Tbk  Kantor Kemenag Lombok',                                                 // Sirkit
		  Address2__c = 'Jl. Jend Sudirman Kav 29-31 ganti alamat deh kitaaaaaa aaaaaaa123 Jakarta Selatan 12160',  // Address
		  PIC_Name__c = 'Abdul',                                                                                    // PIC Name
		  PIC_Phone__c = '021-09389884',                                                                            // PIC Phone
		  PIC_email__c = 'kahfif@xl.co.id',                                                                         // PIC email
		  PIC_Position__c = 'Duta Besar',                                                                           // PIC Position
		  Request_Date__c = Date.valueOf('8-26-2020'),                                                              // Submit Date
		  Terminate_Date__c = Date.valueOf('9-30-2020'),                                                            // Terminate Date
		  Reason__c = 'Kontrak berakhir atau tidak diperpanjang',                                                   // Reason
		  Note__c = 'testing 123',                                                                                  // Note
		  BAP_No__c = 'BAP-26082020-9286',                                                                          // BAP No
		  Approval_Flag__c = 'Tidak',                                                                               // Approval Flag
		  Pernah_Disubmit__c = false,                                                                               // Pernah Disubmit
		  Contract_End_Date__c = Date.valueOf('3-31-2020'),                                                         // Contract End Date
		  Pinalty_Flag__c = false,                                                                                  // Pinalty Flag
		  Contract_Start_Date__c = Date.valueOf('4-1-2019'),                                                        // Contract Start Date
		  Pinalty__c = 0,                                                                                         // Pinalty
		  Mirroring_Status__c = 'Success',                                                                          // Mirroring Status
		  Lebih_Tagih__c = 0,                                                                                     // Lebih Tagih
		  Cost_Flag__c = false,                                                                                     // Cost Flag
		  Cost__c = 0,                                                                                            // Cost
		  IsBackDate__c = false,                                                                                    // IsBackDate / IsEarly
		  IsPenalty__c = false,                                                                                     // IsPenalty
		  Sales_Group_Head__c = sMgr.id,                                                                        // Sales Group Head
		  IsCostPartner__c = false,                                                                                 // Cost Partner > 100jt
		  Stamp_Stage_Submit__c = Datetime.valueOf('8-26-2020 1:41 PM:00'),                                         // Stamp Stage Submit
		  Stamp_Stage_Sent_to_Customer__c = Datetime.valueOf('8-26-2020 1:42 PM:00'),                               // Stamp Stage Sent to Customer
		  Stamp_Stage_Operation_Review__c = Datetime.valueOf('8-26-2020 1:41 PM:00')                               // Stamp Stage Operation Review
		);
		insert BAP;
		*/
		/*BAP__c qBAP = [SELECT id, OwnerId,isbackdate__c,ispenalty__c,IsCostPartner__c, Penalty_Approval_Status__c,Backdate_Approval_Status__c,GH_Approval_Date__c,IoM_Approval_Status__c,Request_Status__c,Approval_Remark__c 
        				FROM BAP__c where BAP_id__c = '9287'];
        */
        
       Test.StartTest(); 
        
        /* TUTUP DULU */
        Approval.ProcessSubmitRequest req1 = 
        new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(BAP.id);

        req1.setSubmitterId(userinfo.getuserid()); 
   
        req1.setProcessDefinitionNameOrId('04a5D0000004TZz');
        req1.setSkipEntryCriteria(true);
    	/**/
        
        
        //Approval.ProcessResult result = Approval.process(req1);
        
        system.debug ('======== BAP.request_date__c 3 : ' + BAP.request_date__c);
        
        
        /*Schedule_BAP_Approval SBA=new Schedule_BAP_Approval();
        
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
		String CRON_EXP = '0 1 * * * ?';
        
        system.schedule('Test check', CRON_EXP, SBA);
		*/
        
        Schedule_BAP_Approval SBA=new Schedule_BAP_Approval();
        SBA.execute(null);
        Test.stopTest();
        
        
        
        system.debug ('======== BAP.request_date__c 4 : ' + BAP.request_date__c);


    }

	static testmethod void Test02() {
        insert new Transaction__c(transactionID__c = 1);
        
        BAPGeneralSetting__c  BAPSetting = new BAPGeneralSetting__c (
            Name = 'test',
            AutoApprovedCHIEFafterxdays__c = 5,
            AutoApprovedCHIEFDayType__c = 'BUSINESS_DAY',
            AutoApprovedGHafterxdays__c = 5,
            AutoApprovedGHDayType__c = 'BUSINESS_DAY',
            isAutoApprovedforCHIEF__c = TRUE,
            isAutoApprovedforGH__c = TRUE
        );
        insert BAPSetting;
        
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='BP'];
        Account A = new Account(
	  	Name = 'PT Bank Permata Tbk',                      // Account Name
	  	BP_Number__c = '757677',                             // BP Number
	  	Organization_Type__c = 'Head Office',                // Organization Type
	  	Type = 'Customer',                                   // Type
	  	RecordTypeId = RT.id,                          // Account Record Type
	  	Unique_Name__c = 'Kantor Kemenag Lombok',            // Unique Name
	  	Keyword__c = 'BP',                                   // Keyword
	  	term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
	  	Customer_VAT_Name__c = 'PT Bank Permata Tbk',        // Customer VAT Name
	  	Customer_Type__c = 'NONGSM',                         // Customer Type
	  	Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
	  	Summary_Billing__c = false,                          // Summary Billing
	  	Approval_Status__c = 'Approved',                     // Approval Status
	  	Using_HO_Billing_Address__c = false,                 // Using HO Billing Address
	  	No_NPWP__c = '000009090909090'                      // No NPWP
		);
		insert A;
        
      	//User sUser = [SELECT id FROM User WHERE Email = 'yogis@xl.co.id'];
      	//User sMgr = [SELECT id FROM User WHERE Name = 'Rudy Sumadi'];
      	//
      	//
      	User mgr3 = new User();
        mgr3.Email = 'sarah@gmail.com';
        mgr3.Username = 'sarah@xlsaasten.com'; 
        mgr3.LastName = 'sarah'; 
        mgr3.Alias = 'mgr3'; 
        mgr3.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr3.LocaleSidKey = 'in_ID'; 
        mgr3.EmailEncodingKey = 'ISO-8859-1'; 
        mgr3.ProfileId = '00e7F000000trIRQAY'; 
        mgr3.LanguageLocaleKey = 'en_US';
        insert mgr3;
        
        
        User mgr2 = new User();
        mgr2.Email = 'muiqbal2111@gmail.com';
        mgr2.ManagerId = mgr3.id;
        mgr2.Username = 'mgr2@xlsaasten.com'; 
        mgr2.LastName = 'mgr2'; 
        mgr2.Alias = 'mgr2'; 
        mgr2.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr2.LocaleSidKey = 'in_ID'; 
        mgr2.EmailEncodingKey = 'ISO-8859-1'; 
        mgr2.ProfileId = '00e7F000000trIRQAY'; 
        mgr2.LanguageLocaleKey = 'en_US';
        insert mgr2;
        
        User mgr1 = new User();
        mgr1.Email = 'muhammad.iqbal@saasten.com';
        mgr1.ManagerId = mgr2.id;
        mgr1.Username = 'mgr1@xlsaasten.com'; 
        mgr1.LastName = 'mgr1'; 
        mgr1.Alias = 'mgr1'; 
        mgr1.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr1.LocaleSidKey = 'in_ID'; 
        mgr1.EmailEncodingKey = 'ISO-8859-1'; 
        mgr1.ProfileId = '00e7F000000trIRQAY'; 
        mgr1.LanguageLocaleKey = 'en_US';
        insert mgr1;
        
        User sales = new User();
        sales.Email = 'muiqbal2111@gmail.com';
        sales.ManagerId = mgr1.id;
        sales.Username = 'sales@xlsaasten.com'; 
        sales.LastName = 'Sales'; 
        sales.Alias = 'sls'; 
        sales.TimeZoneSidKey = 'Asia/Bangkok'; 
        sales.LocaleSidKey = 'in_ID'; 
        sales.EmailEncodingKey = 'ISO-8859-1'; 
        sales.ProfileId = '00e7F000000trIRQAY'; 
        sales.LanguageLocaleKey = 'en_US';
         
        insert sales;
        
        Link__c L=new Link__c();
        L.Name='9393';
        L.Service_type__c='MPLS';
        L.site_A_Name__c=A.id;
        L.Free_Link__c=true;
        insert L;
        
        BAP__c BAP=new BAP__c();
        BAP.OwnerId = sales.id;
        BAP.Customer__c=A.id;
        BAP.isbackdate__c=true;
        BAP.ispenalty__c=true;
        BAP.IsCostPartner__c=true;
        BAP.Backdate_Approval_Status__c=null;
        BAP.Penalty_Approval_Status__c=null;
        BAP.request_date__c=system.today().adddays(-10);
        BAP.Link__c=L.id;
        BAP.Note__c='test Note';
		BAP.PIC_email__c = 'testEmail@tes.com';
		BAP.PIC_Name__c = 'Test Name'; 
		BAP.PIC_Phone__c='089786979889'; 
		BAP.PIC_Position__c='POsisition'; 
		BAP.Reason__c='Kontrak berakhir atau tidak diperpanjang';
		BAP.Sales_Group_Head__c = mgr3.id;
        insert BAP;
        system.debug ('======== BAP.request_date__c 1 : ' + BAP.request_date__c);
        
        BAP.request_date__c=system.today().adddays(-10);
        BAP.IsBackdate__c=true;
        BAP.IsPenalty__c =true;
        BAP.IsCostPartner__c = false;
        BAP.Request_Status__c = 'Iom Approval';
        update BAP;
        
        
        system.debug ('======== BAP ID ADALAH : ' + BAP.id);
        system.debug ('======== BAP.request_date__c 2 : ' + BAP.request_date__c);
        
        
        
       Test.StartTest(); 
        
        /* TUTUP DULU */
        Approval.ProcessSubmitRequest req1 = 
        new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(BAP.id);

        req1.setSubmitterId(userinfo.getuserid()); 
   
        req1.setProcessDefinitionNameOrId('04a5D0000004TZz');
        req1.setSkipEntryCriteria(true);
    	/**/
        
        
        //Approval.ProcessResult result = Approval.process(req1);
        
        system.debug ('======== BAP.request_date__c 3 : ' + BAP.request_date__c);
        Schedule_BAP_Approval SBA=new Schedule_BAP_Approval();
        SBA.execute(null);
        Test.stopTest();
        system.debug ('======== BAP.request_date__c 4 : ' + BAP.request_date__c);


    }
    
    static testmethod void Test03() {
        insert new Transaction__c(transactionID__c = 1);
        
        BAPGeneralSetting__c  BAPSetting = new BAPGeneralSetting__c (
            Name = 'test',
            AutoApprovedCHIEFafterxdays__c = 5,
            AutoApprovedCHIEFDayType__c = 'BUSINESS_DAY',
            AutoApprovedGHafterxdays__c = 5,
            AutoApprovedGHDayType__c = 'BUSINESS_DAY',
            isAutoApprovedforCHIEF__c = TRUE,
            isAutoApprovedforGH__c = TRUE
        );
        insert BAPSetting;
        
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='BP'];
        Account A = new Account(
	  	Name = 'PT Bank Permata Tbk',                      // Account Name
	  	BP_Number__c = '757677',                             // BP Number
	  	Organization_Type__c = 'Head Office',                // Organization Type
	  	Type = 'Customer',                                   // Type
	  	RecordTypeId = RT.id,                          // Account Record Type
	  	Unique_Name__c = 'Kantor Kemenag Lombok',            // Unique Name
	  	Keyword__c = 'BP',                                   // Keyword
	  	term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
	  	Customer_VAT_Name__c = 'PT Bank Permata Tbk',        // Customer VAT Name
	  	Customer_Type__c = 'NONGSM',                         // Customer Type
	  	Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
	  	Summary_Billing__c = false,                          // Summary Billing
	  	Approval_Status__c = 'Approved',                     // Approval Status
	  	Using_HO_Billing_Address__c = false,                 // Using HO Billing Address
	  	No_NPWP__c = '000009090909090'                      // No NPWP
		);
		insert A;
        
      	//User sUser = [SELECT id FROM User WHERE Email = 'yogis@xl.co.id'];
      	//User sMgr = [SELECT id FROM User WHERE Name = 'Rudy Sumadi'];
      	//
      	//
      	User mgr3 = new User();
        mgr3.Email = 'sarah@gmail.com';
        mgr3.Username = 'sarah@xlsaasten.com'; 
        mgr3.LastName = 'sarah'; 
        mgr3.Alias = 'mgr3'; 
        mgr3.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr3.LocaleSidKey = 'in_ID'; 
        mgr3.EmailEncodingKey = 'ISO-8859-1'; 
        mgr3.ProfileId = '00e7F000000trIRQAY'; 
        mgr3.LanguageLocaleKey = 'en_US';
        insert mgr3;
        
        
        User mgr2 = new User();
        mgr2.Email = 'muiqbal2111@gmail.com';
        mgr2.ManagerId = mgr3.id;
        mgr2.Username = 'mgr2@xlsaasten.com'; 
        mgr2.LastName = 'mgr2'; 
        mgr2.Alias = 'mgr2'; 
        mgr2.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr2.LocaleSidKey = 'in_ID'; 
        mgr2.EmailEncodingKey = 'ISO-8859-1'; 
        mgr2.ProfileId = '00e7F000000trIRQAY'; 
        mgr2.LanguageLocaleKey = 'en_US';
        insert mgr2;
        
        User mgr1 = new User();
        mgr1.Email = 'muhammad.iqbal@saasten.com';
        mgr1.ManagerId = mgr2.id;
        mgr1.Username = 'mgr1@xlsaasten.com'; 
        mgr1.LastName = 'mgr1'; 
        mgr1.Alias = 'mgr1'; 
        mgr1.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr1.LocaleSidKey = 'in_ID'; 
        mgr1.EmailEncodingKey = 'ISO-8859-1'; 
        mgr1.ProfileId = '00e7F000000trIRQAY'; 
        mgr1.LanguageLocaleKey = 'en_US';
        insert mgr1;
        
        User sales = new User();
        sales.Email = 'muiqbal2111@gmail.com';
        sales.ManagerId = mgr1.id;
        sales.Username = 'sales@xlsaasten.com'; 
        sales.LastName = 'Sales'; 
        sales.Alias = 'sls'; 
        sales.TimeZoneSidKey = 'Asia/Bangkok'; 
        sales.LocaleSidKey = 'in_ID'; 
        sales.EmailEncodingKey = 'ISO-8859-1'; 
        sales.ProfileId = '00e7F000000trIRQAY'; 
        sales.LanguageLocaleKey = 'en_US';
         
        insert sales;
        
        Link__c L=new Link__c();
        L.Name='9393';
        L.Service_type__c='MPLS';
        L.site_A_Name__c=A.id;
        L.Free_Link__c=true;
        insert L;
        
        BAP__c BAP=new BAP__c();
        BAP.OwnerId = sales.id;
        BAP.Customer__c=A.id;
        BAP.isbackdate__c=true;
        BAP.ispenalty__c=true;
        BAP.IsCostPartner__c=true;
        BAP.Backdate_Approval_Status__c=null;
        BAP.Penalty_Approval_Status__c=null;
        BAP.request_date__c=system.today().adddays(-10);
        BAP.Link__c=L.id;
        BAP.Note__c='test Note';
		BAP.PIC_email__c = 'testEmail@tes.com';
		BAP.PIC_Name__c = 'Test Name'; 
		BAP.PIC_Phone__c='089786979889'; 
		BAP.PIC_Position__c='POsisition'; 
		BAP.Reason__c='Kontrak berakhir atau tidak diperpanjang';
		BAP.Sales_Group_Head__c = mgr3.id;
        insert BAP;
        system.debug ('======== BAP.request_date__c 1 : ' + BAP.request_date__c);
        
        BAP.request_date__c=system.today().adddays(-10);
        BAP.IsBackdate__c=true;
        BAP.IsPenalty__c =false;
        BAP.IsCostPartner__c = false;
        BAP.Request_Status__c = 'Iom Approval';
        update BAP;
        
        
        system.debug ('======== BAP ID ADALAH : ' + BAP.id);
        system.debug ('======== BAP.request_date__c 2 : ' + BAP.request_date__c);
        
        
        
       Test.StartTest(); 
        
        /* TUTUP DULU */
        Approval.ProcessSubmitRequest req1 = 
        new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(BAP.id);

        req1.setSubmitterId(userinfo.getuserid()); 
   
        req1.setProcessDefinitionNameOrId('04a5D0000004TZz');
        req1.setSkipEntryCriteria(true);
    	/**/
        
        
        //Approval.ProcessResult result = Approval.process(req1);
        
        system.debug ('======== BAP.request_date__c 3 : ' + BAP.request_date__c);
        Schedule_BAP_Approval SBA=new Schedule_BAP_Approval();
        SBA.execute(null);
        Test.stopTest();
        system.debug ('======== BAP.request_date__c 4 : ' + BAP.request_date__c);


    }
    
    static testmethod void Test04() {
        insert new Transaction__c(transactionID__c = 1);
        
        BAPGeneralSetting__c  BAPSetting = new BAPGeneralSetting__c (
            Name = 'test',
            AutoApprovedCHIEFafterxdays__c = 5,
            AutoApprovedCHIEFDayType__c = 'BUSINESS_DAY',
            AutoApprovedGHafterxdays__c = 5,
            AutoApprovedGHDayType__c = 'BUSINESS_DAY',
            isAutoApprovedforCHIEF__c = TRUE,
            isAutoApprovedforGH__c = TRUE
        );
        insert BAPSetting;
        
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='BP'];
        Account A = new Account(
	  	Name = 'PT Bank Permata Tbk',                      // Account Name
	  	BP_Number__c = '757677',                             // BP Number
	  	Organization_Type__c = 'Head Office',                // Organization Type
	  	Type = 'Customer',                                   // Type
	  	RecordTypeId = RT.id,                          // Account Record Type
	  	Unique_Name__c = 'Kantor Kemenag Lombok',            // Unique Name
	  	Keyword__c = 'BP',                                   // Keyword
	  	term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
	  	Customer_VAT_Name__c = 'PT Bank Permata Tbk',        // Customer VAT Name
	  	Customer_Type__c = 'NONGSM',                         // Customer Type
	  	Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
	  	Summary_Billing__c = false,                          // Summary Billing
	  	Approval_Status__c = 'Approved',                     // Approval Status
	  	Using_HO_Billing_Address__c = false,                 // Using HO Billing Address
	  	No_NPWP__c = '000009090909090'                      // No NPWP
		);
		insert A;
        
      	//User sUser = [SELECT id FROM User WHERE Email = 'yogis@xl.co.id'];
      	//User sMgr = [SELECT id FROM User WHERE Name = 'Rudy Sumadi'];
      	//
      	//
      	User mgr3 = new User();
        mgr3.Email = 'sarah@gmail.com';
        mgr3.Username = 'sarah@xlsaasten.com'; 
        mgr3.LastName = 'sarah'; 
        mgr3.Alias = 'mgr3'; 
        mgr3.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr3.LocaleSidKey = 'in_ID'; 
        mgr3.EmailEncodingKey = 'ISO-8859-1'; 
        mgr3.ProfileId = '00e7F000000trIRQAY'; 
        mgr3.LanguageLocaleKey = 'en_US';
        insert mgr3;
        
        
        User mgr2 = new User();
        mgr2.Email = 'muiqbal2111@gmail.com';
        mgr2.ManagerId = mgr3.id;
        mgr2.Username = 'mgr2@xlsaasten.com'; 
        mgr2.LastName = 'mgr2'; 
        mgr2.Alias = 'mgr2'; 
        mgr2.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr2.LocaleSidKey = 'in_ID'; 
        mgr2.EmailEncodingKey = 'ISO-8859-1'; 
        mgr2.ProfileId = '00e7F000000trIRQAY'; 
        mgr2.LanguageLocaleKey = 'en_US';
        insert mgr2;
        
        User mgr1 = new User();
        mgr1.Email = 'muhammad.iqbal@saasten.com';
        mgr1.ManagerId = mgr2.id;
        mgr1.Username = 'mgr1@xlsaasten.com'; 
        mgr1.LastName = 'mgr1'; 
        mgr1.Alias = 'mgr1'; 
        mgr1.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr1.LocaleSidKey = 'in_ID'; 
        mgr1.EmailEncodingKey = 'ISO-8859-1'; 
        mgr1.ProfileId = '00e7F000000trIRQAY'; 
        mgr1.LanguageLocaleKey = 'en_US';
        insert mgr1;
        
        User sales = new User();
        sales.Email = 'muiqbal2111@gmail.com';
        sales.ManagerId = mgr1.id;
        sales.Username = 'sales@xlsaasten.com'; 
        sales.LastName = 'Sales'; 
        sales.Alias = 'sls'; 
        sales.TimeZoneSidKey = 'Asia/Bangkok'; 
        sales.LocaleSidKey = 'in_ID'; 
        sales.EmailEncodingKey = 'ISO-8859-1'; 
        sales.ProfileId = '00e7F000000trIRQAY'; 
        sales.LanguageLocaleKey = 'en_US';
         
        insert sales;
        
        Link__c L=new Link__c();
        L.Name='9393';
        L.Service_type__c='MPLS';
        L.site_A_Name__c=A.id;
        L.Free_Link__c=true;
        insert L;
        
        BAP__c BAP=new BAP__c();
        BAP.OwnerId = sales.id;
        BAP.Customer__c=A.id;
        BAP.isbackdate__c=true;
        BAP.ispenalty__c=true;
        BAP.IsCostPartner__c=true;
        BAP.Backdate_Approval_Status__c=null;
        BAP.Penalty_Approval_Status__c=null;
        BAP.request_date__c=system.today().adddays(-10);
        BAP.Link__c=L.id;
        BAP.Note__c='test Note';
		BAP.PIC_email__c = 'testEmail@tes.com';
		BAP.PIC_Name__c = 'Test Name'; 
		BAP.PIC_Phone__c='089786979889'; 
		BAP.PIC_Position__c='POsisition'; 
		BAP.Reason__c='Kontrak berakhir atau tidak diperpanjang';
		BAP.Sales_Group_Head__c = mgr3.id;
        insert BAP;
        system.debug ('======== BAP.request_date__c 1 : ' + BAP.request_date__c);
        
        BAP.request_date__c=system.today().adddays(-10);
        BAP.IsBackdate__c=true;
        BAP.IsPenalty__c =false;
        BAP.IsCostPartner__c = true;
        
        update BAP;
        
        
        system.debug ('======== BAP ID ADALAH : ' + BAP.id);
        system.debug ('======== BAP.request_date__c 2 : ' + BAP.request_date__c);
        
        
        
       Test.StartTest(); 
        
        /* TUTUP DULU */
        Approval.ProcessSubmitRequest req1 = 
        new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(BAP.id);

        req1.setSubmitterId(userinfo.getuserid()); 
   
        req1.setProcessDefinitionNameOrId('04a5D0000004TZz');
        req1.setSkipEntryCriteria(true);
    	/**/
        
        
        //Approval.ProcessResult result = Approval.process(req1);
        
        system.debug ('======== BAP.request_date__c 3 : ' + BAP.request_date__c);
        Schedule_BAP_Approval SBA=new Schedule_BAP_Approval();
        SBA.execute(null);
        Test.stopTest();
        system.debug ('======== BAP.request_date__c 4 : ' + BAP.request_date__c);


    }
    
    static testmethod void Test05() {
        insert new Transaction__c(transactionID__c = 1);
        
        BAPGeneralSetting__c  BAPSetting = new BAPGeneralSetting__c (
            Name = 'test',
            AutoApprovedCHIEFafterxdays__c = 5,
            AutoApprovedCHIEFDayType__c = 'BUSINESS_DAY',
            AutoApprovedGHafterxdays__c = 5,
            AutoApprovedGHDayType__c = 'BUSINESS_DAY',
            isAutoApprovedforCHIEF__c = TRUE,
            isAutoApprovedforGH__c = TRUE
        );
        insert BAPSetting;
        
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='BP'];
        Account A = new Account(
	  	Name = 'PT Bank Permata Tbk',                      // Account Name
	  	BP_Number__c = '757677',                             // BP Number
	  	Organization_Type__c = 'Head Office',                // Organization Type
	  	Type = 'Customer',                                   // Type
	  	RecordTypeId = RT.id,                          // Account Record Type
	  	Unique_Name__c = 'Kantor Kemenag Lombok',            // Unique Name
	  	Keyword__c = 'BP',                                   // Keyword
	  	term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
	  	Customer_VAT_Name__c = 'PT Bank Permata Tbk',        // Customer VAT Name
	  	Customer_Type__c = 'NONGSM',                         // Customer Type
	  	Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
	  	Summary_Billing__c = false,                          // Summary Billing
	  	Approval_Status__c = 'Approved',                     // Approval Status
	  	Using_HO_Billing_Address__c = false,                 // Using HO Billing Address
	  	No_NPWP__c = '000009090909090'                      // No NPWP
		);
		insert A;
        
      	//User sUser = [SELECT id FROM User WHERE Email = 'yogis@xl.co.id'];
      	//User sMgr = [SELECT id FROM User WHERE Name = 'Rudy Sumadi'];
      	//
      	//
      	User mgr3 = new User();
        mgr3.Email = 'sarah@gmail.com';
        mgr3.Username = 'sarah@xlsaasten.com'; 
        mgr3.LastName = 'sarah'; 
        mgr3.Alias = 'mgr3'; 
        mgr3.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr3.LocaleSidKey = 'in_ID'; 
        mgr3.EmailEncodingKey = 'ISO-8859-1'; 
        mgr3.ProfileId = '00e7F000000trIRQAY'; 
        mgr3.LanguageLocaleKey = 'en_US';
        insert mgr3;
        
        
        User mgr2 = new User();
        mgr2.Email = 'muiqbal2111@gmail.com';
        mgr2.ManagerId = mgr3.id;
        mgr2.Username = 'mgr2@xlsaasten.com'; 
        mgr2.LastName = 'mgr2'; 
        mgr2.Alias = 'mgr2'; 
        mgr2.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr2.LocaleSidKey = 'in_ID'; 
        mgr2.EmailEncodingKey = 'ISO-8859-1'; 
        mgr2.ProfileId = '00e7F000000trIRQAY'; 
        mgr2.LanguageLocaleKey = 'en_US';
        insert mgr2;
        
        User mgr1 = new User();
        mgr1.Email = 'muhammad.iqbal@saasten.com';
        mgr1.ManagerId = mgr2.id;
        mgr1.Username = 'mgr1@xlsaasten.com'; 
        mgr1.LastName = 'mgr1'; 
        mgr1.Alias = 'mgr1'; 
        mgr1.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr1.LocaleSidKey = 'in_ID'; 
        mgr1.EmailEncodingKey = 'ISO-8859-1'; 
        mgr1.ProfileId = '00e7F000000trIRQAY'; 
        mgr1.LanguageLocaleKey = 'en_US';
        insert mgr1;
        
        User sales = new User();
        sales.Email = 'muiqbal2111@gmail.com';
        sales.ManagerId = mgr1.id;
        sales.Username = 'sales@xlsaasten.com'; 
        sales.LastName = 'Sales'; 
        sales.Alias = 'sls'; 
        sales.TimeZoneSidKey = 'Asia/Bangkok'; 
        sales.LocaleSidKey = 'in_ID'; 
        sales.EmailEncodingKey = 'ISO-8859-1'; 
        sales.ProfileId = '00e7F000000trIRQAY'; 
        sales.LanguageLocaleKey = 'en_US';
         
        insert sales;
        
        Link__c L=new Link__c();
        L.Name='9393';
        L.Service_type__c='MPLS';
        L.site_A_Name__c=A.id;
        L.Free_Link__c=true;
        insert L;
        
        BAP__c BAP=new BAP__c();
        BAP.OwnerId = sales.id;
        BAP.Customer__c=A.id;
        BAP.isbackdate__c=true;
        BAP.ispenalty__c=true;
        BAP.IsCostPartner__c=true;
        BAP.Backdate_Approval_Status__c=null;
        BAP.Penalty_Approval_Status__c=null;
        BAP.request_date__c=system.today().adddays(-10);
        BAP.Link__c=L.id;
        BAP.Note__c='test Note';
		BAP.PIC_email__c = 'testEmail@tes.com';
		BAP.PIC_Name__c = 'Test Name'; 
		BAP.PIC_Phone__c='089786979889'; 
		BAP.PIC_Position__c='POsisition'; 
		BAP.Reason__c='Kontrak berakhir atau tidak diperpanjang';
		BAP.Sales_Group_Head__c = mgr3.id;
        insert BAP;
        system.debug ('======== BAP.request_date__c 1 : ' + BAP.request_date__c);
        
        BAP.request_date__c=system.today().adddays(-10);
        BAP.IsBackdate__c=false;
        BAP.IsPenalty__c =true;
        BAP.IsCostPartner__c = false;
        BAP.Request_Status__c = 'Iom Approval';
        update BAP;
        
        
        system.debug ('======== BAP ID ADALAH : ' + BAP.id);
        system.debug ('======== BAP.request_date__c 2 : ' + BAP.request_date__c);
        
        
        
       Test.StartTest(); 
        
        /* TUTUP DULU */
        Approval.ProcessSubmitRequest req1 = 
        new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(BAP.id);

        req1.setSubmitterId(userinfo.getuserid()); 
   
        req1.setProcessDefinitionNameOrId('04a5D0000004TZz');
        req1.setSkipEntryCriteria(true);
    	/**/
        
        
        //Approval.ProcessResult result = Approval.process(req1);
        
        system.debug ('======== BAP.request_date__c 3 : ' + BAP.request_date__c);
        Schedule_BAP_Approval SBA=new Schedule_BAP_Approval();
        SBA.execute(null);
        Test.stopTest();
        system.debug ('======== BAP.request_date__c 4 : ' + BAP.request_date__c);


    }
    static testmethod void Test06() {
        insert new Transaction__c(transactionID__c = 1);
        
        BAPGeneralSetting__c  BAPSetting = new BAPGeneralSetting__c (
            Name = 'test',
            AutoApprovedCHIEFafterxdays__c = 5,
            AutoApprovedCHIEFDayType__c = 'BUSINESS_DAY',
            AutoApprovedGHafterxdays__c = 5,
            AutoApprovedGHDayType__c = 'BUSINESS_DAY',
            isAutoApprovedforCHIEF__c = TRUE,
            isAutoApprovedforGH__c = TRUE
        );
        insert BAPSetting;
        
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='BP'];
        Account A = new Account(
	  	Name = 'PT Bank Permata Tbk',                      // Account Name
	  	BP_Number__c = '757677',                             // BP Number
	  	Organization_Type__c = 'Head Office',                // Organization Type
	  	Type = 'Customer',                                   // Type
	  	RecordTypeId = RT.id,                          // Account Record Type
	  	Unique_Name__c = 'Kantor Kemenag Lombok',            // Unique Name
	  	Keyword__c = 'BP',                                   // Keyword
	  	term_of_payment__c = 'Z030 Within 30 Days Due Net',  // Term of Payment
	  	Customer_VAT_Name__c = 'PT Bank Permata Tbk',        // Customer VAT Name
	  	Customer_Type__c = 'NONGSM',                         // Customer Type
	  	Payer_For_GSM_Invoice__c = false,                    // Payer For GSM Invoice
	  	Summary_Billing__c = false,                          // Summary Billing
	  	Approval_Status__c = 'Approved',                     // Approval Status
	  	Using_HO_Billing_Address__c = false,                 // Using HO Billing Address
	  	No_NPWP__c = '000009090909090'                      // No NPWP
		);
		insert A;
        
      	//User sUser = [SELECT id FROM User WHERE Email = 'yogis@xl.co.id'];
      	//User sMgr = [SELECT id FROM User WHERE Name = 'Rudy Sumadi'];
      	//
      	//
      	User mgr3 = new User();
        mgr3.Email = 'sarah@gmail.com';
        mgr3.Username = 'sarah@xlsaasten.com'; 
        mgr3.LastName = 'sarah'; 
        mgr3.Alias = 'mgr3'; 
        mgr3.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr3.LocaleSidKey = 'in_ID'; 
        mgr3.EmailEncodingKey = 'ISO-8859-1'; 
        mgr3.ProfileId = '00e7F000000trIRQAY'; 
        mgr3.LanguageLocaleKey = 'en_US';
        insert mgr3;
        
        
        User mgr2 = new User();
        mgr2.Email = 'muiqbal2111@gmail.com';
        mgr2.ManagerId = mgr3.id;
        mgr2.Username = 'mgr2@xlsaasten.com'; 
        mgr2.LastName = 'mgr2'; 
        mgr2.Alias = 'mgr2'; 
        mgr2.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr2.LocaleSidKey = 'in_ID'; 
        mgr2.EmailEncodingKey = 'ISO-8859-1'; 
        mgr2.ProfileId = '00e7F000000trIRQAY'; 
        mgr2.LanguageLocaleKey = 'en_US';
        insert mgr2;
        
        User mgr1 = new User();
        mgr1.Email = 'muhammad.iqbal@saasten.com';
        mgr1.ManagerId = mgr2.id;
        mgr1.Username = 'mgr1@xlsaasten.com'; 
        mgr1.LastName = 'mgr1'; 
        mgr1.Alias = 'mgr1'; 
        mgr1.TimeZoneSidKey = 'Asia/Bangkok'; 
        mgr1.LocaleSidKey = 'in_ID'; 
        mgr1.EmailEncodingKey = 'ISO-8859-1'; 
        mgr1.ProfileId = '00e7F000000trIRQAY'; 
        mgr1.LanguageLocaleKey = 'en_US';
        insert mgr1;
        
        User sales = new User();
        sales.Email = 'muiqbal2111@gmail.com';
        sales.ManagerId = mgr1.id;
        sales.Username = 'sales@xlsaasten.com'; 
        sales.LastName = 'Sales'; 
        sales.Alias = 'sls'; 
        sales.TimeZoneSidKey = 'Asia/Bangkok'; 
        sales.LocaleSidKey = 'in_ID'; 
        sales.EmailEncodingKey = 'ISO-8859-1'; 
        sales.ProfileId = '00e7F000000trIRQAY'; 
        sales.LanguageLocaleKey = 'en_US';
         
        insert sales;
        
        Link__c L=new Link__c();
        L.Name='9393';
        L.Service_type__c='MPLS';
        L.site_A_Name__c=A.id;
        L.Free_Link__c=true;
        insert L;
        
        BAP__c BAP=new BAP__c();
        BAP.OwnerId = sales.id;
        BAP.Customer__c=A.id;
        BAP.isbackdate__c=true;
        BAP.ispenalty__c=true;
        BAP.IsCostPartner__c=true;
        BAP.Backdate_Approval_Status__c=null;
        BAP.Penalty_Approval_Status__c=null;
        BAP.request_date__c=system.today().adddays(-10);
        BAP.Link__c=L.id;
        BAP.Note__c='test Note';
		BAP.PIC_email__c = 'testEmail@tes.com';
		BAP.PIC_Name__c = 'Test Name'; 
		BAP.PIC_Phone__c='089786979889'; 
		BAP.PIC_Position__c='POsisition'; 
		BAP.Reason__c='Kontrak berakhir atau tidak diperpanjang';
		BAP.Sales_Group_Head__c = mgr3.id;
        insert BAP;
        system.debug ('======== BAP.request_date__c 1 : ' + BAP.request_date__c);
        
        BAP.request_date__c=system.today().adddays(-10);
        BAP.IsBackdate__c=false;
        BAP.IsPenalty__c =true;
        BAP.IsCostPartner__c = true;
        
        update BAP;
        
        
        system.debug ('======== BAP ID ADALAH : ' + BAP.id);
        system.debug ('======== BAP.request_date__c 2 : ' + BAP.request_date__c);
        
        
        
       Test.StartTest(); 
        
        /* TUTUP DULU */
        Approval.ProcessSubmitRequest req1 = 
        new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(BAP.id);

        req1.setSubmitterId(userinfo.getuserid()); 
   
        req1.setProcessDefinitionNameOrId('04a5D0000004TZz');
        req1.setSkipEntryCriteria(true);
    	/**/
        
        
        //Approval.ProcessResult result = Approval.process(req1);
        
        system.debug ('======== BAP.request_date__c 3 : ' + BAP.request_date__c);
        Schedule_BAP_Approval SBA=new Schedule_BAP_Approval();
        SBA.execute(null);
        Test.stopTest();
        system.debug ('======== BAP.request_date__c 4 : ' + BAP.request_date__c);


    }
       
}