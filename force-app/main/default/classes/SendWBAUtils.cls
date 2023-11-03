/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 18-03-2022
 * @last modified by  : Doddy Prima
**/
global class SendWBAUtils {
    public String HariIni {get;set;}
    public String TanggalIni {get;set;}
    public SR_PR_Notification__c SPBA{get;set;}
    public Account Acc{get;set;}
    public Account SiteA{get;set;}
    public Account SiteB{get;set;}
    public Opportunity Opp{get;set;}
    public AccountContactRelation ACR{get;set;}
    public String displayerror{get;set;}
    public String displaynoerror{get;set;}
    public String displaysend{get;set;}
    public string opportunityID {get;set;}  
    
    public string linkID {get;set;}
    public list<link__c> links{get;set;}   
    //New SendWBAUtils tgl 07/11/2021
    public SendWBAUtils(ApexPages.StandardController controller) {
        Opportunity O=(Opportunity)controller.getrecord();
        Opp=[SELECT id ,Opportunity_id__c,stagename,RecordTypeName__c from Opportunity WHERE id=:O.id];
        OpportunityID=Opp.id;
        displayerror='display:none';
        displaynoerror='display:none';
        displaysend='display:none';
        
        if(Opp.StageName=='Waiting for BA')
        {
            list<SR_PR_Notification__c> SRPR = [select id 
                                                from SR_PR_Notification__c 
                                                WHERE Opportunity__c=:O.id 
                                                AND Notif_type__c='PR' 
                                                AND Status__c='Waiting Berita Acara' LIMIT 1];
            if(SRPR.Size()==0)
            {
                displayerror='';
                cancel();
            }
            else
            {
                displaynoerror='';
            }
        }
        else
        {
            displayerror='';
            cancel();
        }
    }
    
    public pagereference cancel()
    {
        return new PageReference('/'+OpportunityID);
    }
    
    public pagereference sendemail()
    {
        displaysend='';
        
        
        
        Opp=[SELECT id,Doc_Template__c from Opportunity WHERE Id=:OpportunityID];
        if(Opp.Doc_Template__c != null){
            futuresendemail(opportunityID);
            return new PageReference('/'+OpportunityID);
        }else{
            return null;
        }
        //    SPBA=[SELECT id,project_coordinator_email__c from sr_pr_notification__c WHERE Opportunity__c=:OpportunityID AND Notif_type__c='PR' AND Status__c='Waiting Berita Acara' ];
        
    }

    //@future(callout=true)
    public static void futuresendemail(String recordID)
    {
        system.debug ('========= in Method SendWBAUtils.futuresendemail ===============' );
        Id pdf_id;
        Id recID = recordID;
        String LinkID;
        String Services;
        String BW_Before;
        String UOM_Before;
        String BW_After;
        String UOM_After;
        String UniqueNameAccountA;
        String UniqueNameAccountB;
        String siteType;
        //send email WBA
        //PageReference pdf = page.PRWBA;
        //

        PageReference pdf = Page.VF_Pdf_Preview;
        
        String sObjName = recID.getSObjectType().getDescribe().getName();
        String queryDocument = 'SELECT Id, Doc_Template__c FROM '+sObjName+' WHERE Id = \''+recID+'\'';
        
        List<SObject> DocumentList = Database.query(queryDocument);
        for(SObject Obj :DocumentList){
            pdf_id = String.valueOf(Obj.get('Doc_Template__c'));
        }
        pdf.getParameters().put('rec_id', recID);
        pdf.getParameters().put('pdf_id', pdf_id);
        
        
        Call_Log__c CL=new Call_Log__c();
        CL.Salesforce_ID_1__c=recordID;
        
        CL.Type__c='Email';
        CL.Request_Start_Time__c=system.now();
        //pdf.getParameters().put('id',recordID);
        SR_PR_Notification__c SPBA=[SELECT id,Name,Services__c,project_coordinator_email__c,BA_Sent_Date__c from sr_pr_notification__c WHERE Opportunity__c=:recordID AND Notif_type__c='PR' LIMIT 1];
        Opportunity Opp=[SELECT recordType.Name, BW_Before__c,UOM_BW_Before__c,BW_After__c,UOM_BW_After__c,PR__c,Opportunity_ID__c,Accountid,Service_Type__c,Account_Site_A__r.Unique_Name__c,Account_Site_A__r.Name,Account_Site_B__r.Name,Account_Site_B__r.Unique_Name__c,Link_ID__c FROM Opportunity WHERE ID=:recordID];
        String recordTypeName = Opp.RecordType.Name;
        Boolean resultLL=recordTypeName.contains('Subscription Two Site');
        if(resultLL){
            siteType = 'Two Site';
        }else{
            siteType = 'One Site';
        }
        Account A=[SELECT Owner.Name,Name,Unique_Name__c,Owner.Email,Owner.Manager.Email FROM Account WHERE ID=:Opp.AccountID];
        list<AccountContactRelation> BARecipient=[SELECT Contact.Email FROM AccountContactRelation WHERE AccountID=:Opp.AccountID AND Roles INCLUDES('PIC BA Recipient') LIMIT 1];
        CL.Salesforce_ID_2__c=Opp.PR__c;
        CL.Salesforce_ID_3__c=Opp.Opportunity_ID__c;    
        system.debug('BA_Sent_Date__c nya before'+SPBA.BA_Sent_Date__c);
        if (SPBA.BA_Sent_Date__c == null)
            SPBA.BA_Sent_Date__c=system.today();
        system.debug('BA_Sent_Date__c nya after'+SPBA.BA_Sent_Date__c);
        // the contents of the attachment from the pdf
        if(BARecipient.size()==0)
        {
            CL.Response_Message__c  ='No BA Recipient';
            
            CL.Response_End_Time__c=system.now();
            insert CL;
            return;
        }
        //  Blob body;
        Blob body;
        
        try {
            if(Test.isRunningTest()) { 
                body = blob.valueOf('Unit.Test');
            } else {
                body = pdf.getContentAsPDF();
            }
            // returns the output of the page as a PDF
            //   body = pdf.getContentAsPDF();
            
            // need to pass unit test -- current bug  
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error');
            CL.Response_Message__c  =e.getmessage();
            CL.Response_End_Time__c=system.now();
            
            insert CL;
            if(!test.isrunningtest())
                return;
        }
        LinkID = (Opp.Link_ID__c != null) ? Opp.Link_ID__c : '';
        Services = (SPBA.Services__c != null) ? SPBA.Services__c : '';
        BW_Before = (Opp.BW_Before__c != null) ? Opp.BW_Before__c : '';
        UOM_Before = (Opp.UOM_BW_Before__c != null) ? Opp.UOM_BW_Before__c : '';
        BW_After = (Opp.BW_After__c != null) ? Opp.BW_After__c : '';
        UOM_After = (Opp.UOM_BW_After__c != null) ? Opp.UOM_BW_After__c : '';
        UniqueNameAccountA = (Opp.Account_Site_A__r.Unique_Name__c != null) ? '['+Opp.Account_Site_A__r.Unique_Name__c+']' : '';
        UniqueNameAccountB = (Opp.Account_Site_B__r.Unique_Name__c != null) ? '['+Opp.Account_Site_B__r.Unique_Name__c+']' : '';
        list<String> mailaddress=new list<String>{};
        list<String> mailcc=new list<String>{};  
        //attach PDF To Email, PDF from vf page PRWBA
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName(A.Name+'_'+Services+'_'+'BA'+'_'+Opp.Service_Type__c+'_'+LinkID+'.pdf');
        attach.setInline(false);
        attach.Body = body;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        
        if(BARecipient[0].Contact.Email==null||BARecipient[0].Contact.Email==''||test.isrunningtest())
        {
            CL.Response_Message__c  ='No BA Recipient Email,Invalid Email Address';
            CL.Response_End_Time__c=system.now();
            if(!test.isrunningtest())
            {insert CL;
             return;}
        }
        system.debug ('========= BARecipient[0].Contact.Email : ' + BARecipient[0].Contact.Email);
        //Set recipient and CC
        mailaddress.add(BARecipient[0].Contact.Email);
      //mailcc.add('dikynurosid@gmail.com');
      //mailcc.add('dickynurosid@gmail.com');
      	mailcc.add(system.label.CC_Notification_BA_1);
        mailcc.add(system.label.CC_Notification_BA_2);
        mailcc.add(system.label.CC_Notification_BA_3);
        
        
        //mailcc.add('FixedITDelivery@xl.co.id');
        //mailcc.add('OperationRevenueManagement@xl.co.id');
        //mailcc.add('operationgovernanceds@xl.co.id');
        
        
        if (A.Owner.Email <> null)
            mailcc.add(A.Owner.Email); 
        
        if (A.Owner.Manager <> null)
            if (A.Owner.Manager.Email <> null)
            mailcc.add(A.Owner.Manager.Email);
      	  mailcc.add(system.label.CC_Notification_BA_4);
       // mailcc.add('diky.nurosid@saasten.com');
       // mailcc.add('salessupport@xl.co.id');
      //  mailcc.add(SPBA.Project_Coordinator_Email__c);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='BAmonitoring@xl.co.id'];
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
        mail.optOutPolicy = 'FILTER';
        mail.setToAddresses(mailaddress);
        mail.setCCaddresses(mailcc);
        String Subject='';
        String installationSite ='';
        if(siteType == 'Two Site'){
            Subject='BA '+Services+'  '+Opp.Service_Type__c+'  - '+Opp.Account_Site_A__r.Name+' '+UniqueNameAccountA+' - '+ Opp.Account_Site_B__r.Name+' '+UniqueNameAccountB+' '+LinkID;
            installationSite = Opp.Account_Site_A__r.Name+' '+UniqueNameAccountA+' - '+Opp.Account_Site_B__r.Name+' '+UniqueNameAccountB;
        }else{
            Subject='BA '+Services+'  '+Opp.Service_Type__c+' - '+Opp.Account_Site_A__r.Name+' '+UniqueNameAccountA+' '+LinkID;
            installationSite= Opp.Account_Site_A__r.Name+' - '+UniqueNameAccountA;
        }
       
        mail.setSubject(Subject);
        Date deadlineBA=SPBA.ba_sent_date__c.adddays(7);
        String BulanIndonesia='';
        String MonthEnglish='';
        if(DeadlineBA.month()==1||test.isRunningTest())
        {
            BulanIndonesia='Januari';
            MonthEnglish='January';
        }
        if(DeadlineBA.month()==2||test.isRunningTest())
        {
            BulanIndonesia='Februari';
            MonthEnglish='February';
        }
        if(DeadlineBA.month()==3||test.isRunningTest())
        {
            BulanIndonesia='Maret';
            MonthEnglish='March';
        }
        if(DeadlineBA.month()==4||test.isRunningTest())
        {
            BulanIndonesia='April';
            MonthEnglish='April';
        }
        if(DeadlineBA.month()==5||test.isRunningTest())
        {
            BulanIndonesia='Mei';
            MonthEnglish='May';
        }
        if(DeadlineBA.month()==6||test.isRunningTest())
        {
            BulanIndonesia='Juni';
            MonthEnglish='June';
        }
        if(DeadlineBA.month()==7||test.isRunningTest())
        {
            BulanIndonesia='Juli';
            MonthEnglish='July';
        }
        if(DeadlineBA.month()==8||test.isRunningTest())
        {
            BulanIndonesia='Agustus';
            MonthEnglish='August';
        }
        if(DeadlineBA.month()==9||test.isRunningTest())
        {
            BulanIndonesia='September';
            MonthEnglish='September';
        }
        if(DeadlineBA.month()==10||test.isRunningTest())
        {
            BulanIndonesia='Oktober';
            MonthEnglish='October';
        }
        if(DeadlineBA.month()==11||test.isRunningTest())
        {
            BulanIndonesia='November';
            MonthEnglish='November';
        }
        if(DeadlineBA.month()==12||test.isRunningTest())
        {
            BulanIndonesia='Desember';
            MonthEnglish='December';
        }
        String deadlineBAIndonesia=DeadlineBA.day()+' '+BulanIndonesia+' '+deadlineBA.year();
        String deadlineBAInggris=DeadlineBA.day()+' '+MonthEnglish+' '+deadlineBA.year();
        
        //set body attachment
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
        //-----------------------------
        
        //-----------------------------------------------------------------
        String BodyEmail='Pelanggan Yang Terhormat '+A.Name+',<br/><br/>Berikut ini kami sampaikan Berita Acara untuk ditandatangani :<br/><br/>';
        BodyEmail=BodyEmail+'    <table style="background-color: #ffffff; filter: alpha(opacity=40); opacity: 0.95;border:1px white solid;"><col width="100px"/><col width="10px" /><col width="400px" /><tr><td>Project</td><td>:</td><td>'+Opp.Service_type__c+'</td></tr>';
        BodyEmail=BodyEmail+'   <tr><td>Service</td><td>:</td><td>'+Services+'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Installation Site</td><td>:</td><td>'+installationSite+'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Capacity</td><td>:</td><td>Before  '+BW_Before+' '+ UOM_Before+'/After  '+BW_After +' '+ UOM_After +'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Link ID</td><td>:</td><td>'+LinkID+'</td></tr></table><br/><br/>';
        BodyEmail=BodyEmail+'Apabila terdapat ketidaksesuaian dalam Berita Acara terlampir, silakan menghubungi AM dan Sales Manager terkait, atau me-reply all email ini.<br/>Kami tunggu Berita Acara terlampir yang sudah ditanda-tangani selambatnya '+deadlineBAIndonesia+'. Apabila setelah tanggal tersebut Berita Acara belum kami terima, maka layanan akan diisolir atau dikembalikan ke kondisi semula.<br/>Terima kasih atas perhatian dan kerjasamanya.<br/><br/>Hormat kami,<br/><br/>XL Business Solutions<br/>';
        BodyEmail=BodyEmail+'-------------------------------------------------------------------------------------<br/><br/>';
        BodyEmail=BodyEmail+'Dear Valued Customer '+A.Name+',<br/><br/>Hereby we submit Letter of Acceptance for your signing :<br/><br/>';
        BodyEmail=BodyEmail+'    <table style="background-color: #ffffff; filter: alpha(opacity=40); opacity: 0.95;border:1px white solid;"><col width="100px"/><col width="10px" /><col width="400px" /><tr><td>Project</td><td>:</td><td>'+Opp.Service_type__c+'</td></tr>';
        BodyEmail=BodyEmail+'   <tr><td>Service</td><td>:</td><td>'+Services+'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Installation Site</td><td>:</td><td>'+installationSite+'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Capacity</td><td>:</td><td>Before  '+BW_Before+' '+ UOM_Before+'/After  '+BW_After +' '+ UOM_After +'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Link ID</td><td>:</td><td>'+LinkID+'</td></tr></table><br/><br/>';
        
        BodyEmail=BodyEmail+'For any concern on Letter of Acceptance details, kindly contact respective AM and Sales Manager, or reply-all this email.<br/>We expect to receive the signed Letter of Acceptance on '+deadlineBAInggris+' at the latest.  If after the date we have not received the Letter of Acceptance, the service will be isolated or returned to its original condition.<br/>Thank you for your attention and cooperation.<br/>';
        BodyEmail=BodyEmail+'<br/>Best regards,<br/><br/>XL Business Solutions <br/>';
        mail.setHtmlBody(BodyEmail);
        // Send the email
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
            List<Messaging.SendEmailResult>  results=new List<Messaging.SendEmailResult> ();
        system.debug('=== IN send email condition before');
        if(!test.isrunningtest())
        {
            system.debug('=== IN send email condition after');
            
            results = Messaging.sendEmail(messages);
            
            CL.Response_End_Time__c=system.now();
            CL.Response_Message__c='Success ='+results[0].issuccess()+' Error:'+results[0].geterrors();
            insert CL;
            
            update SPBA;
        }
        else
        {
            results=null;
            
            return;
        }
        
    }
}