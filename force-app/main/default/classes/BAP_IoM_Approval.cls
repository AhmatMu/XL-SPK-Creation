/* ====================================================================================================
 * Class Name		        : BAP_IoM_Approval
 * Test Class		        : test_BAP_IOM_Approval
 * Created By		        : 
 * Created Date		        : 
 * Created Description		: - 
 * 					          - 
 * Updated By               :
 * Updated Date	            :
 * Updated Description		: - 
 * 					          - 
 * ====================================================================================================
 */

public class BAP_IoM_Approval {
    
    ApexPages.StandardController con;
    public Boolean isBackDateToggle {get;set;}
    public Boolean isPenaltyToggle {get;set;}
    public Boolean vfVisibility {get;set;}
    public Boolean checkboxBackdateVisibility {get;set;}
    public Boolean checkboxPenaltyVisibility {get;set;}
    public Boolean submitVisibility {get;set;}
    public Boolean isBackdateFlag {get;set;}
    public Boolean isPenaltyFlag {get;set;}
    public Boolean isCostPartnerFlag {get;set;}
    public String bapid{get;set;}
    public BAP__c bap;
    
    public BAP_IoM_Approval(ApexPages.StandardController controller) {     
        bap = (BAP__c) controller.getRecord();
        bapid=bap.id;
        if(bapid!=null && bapid!='')
        {
            bap=[select id,    Sales_Group_Head__r.Manager.Email,vfVisibility__c, isbackdate__c,ispenalty__c,ownerid,iscostpartner__c, pernah_disubmit__c, request_status__c FROM BAP__c WHERE id=:bapid];
            con = Controller;
            
            //untuk set visibility vf page di BAP 
            Id currentUserID = userinfo.getProfileId();
            List<Profile> currentUserProfileRecord = [SELECT Id, Name FROM Profile WHERE Id=:currentUserID LIMIT 1];
            String currentUserProfileName = currentUserProfileRecord[0].Name;
            system.debug('=== bap.request_status__c :'+bap.request_status__c);
            system.debug('=== currentUserProfileName :'+currentUserProfileName);
            if ((currentUserProfileName=='System Administrator'||currentUserProfileName=='Sales Group Head'||currentUserProfileName=='CEO') && bap.request_status__c =='IOM Approval' )
            {
                vfVisibility = TRUE;
            }
            
            //untuk set visibility checkbox
            isBackdateFlag = bap.IsBackDate__c;
            isPenaltyFlag = bap.IsPenalty__c;
            isCostPartnerFlag = bap.IsCostPartner__c;
            submitVisibility = FALSE;
            
            if (bap.pernah_disubmit__c == FALSE) {
                if(isBackdateFlag==TRUE&&isPenaltyFlag==TRUE)
                {
                    checkboxBackdateVisibility = TRUE;
                    checkboxPenaltyVisibility = TRUE;
                    submitVisibility = TRUE;
                }
                else if(isBackdateFlag==TRUE&&isPenaltyFlag==FALSE)
                {
                    checkboxBackdateVisibility = TRUE;
                    checkboxPenaltyVisibility = FALSE;
                    submitVisibility = TRUE;
                }
                else if(isBackdateFlag==FALSE&&isPenaltyFlag==TRUE)
                {
                    checkboxBackdateVisibility = FALSE;
                    checkboxPenaltyVisibility = TRUE;
                    submitVisibility = TRUE;
                }
            } 
            else {
                checkboxBackdateVisibility = FALSE;
                checkboxPenaltyVisibility = FALSE;
                submitVisibility = FALSE;
            }
            
            
        }
    }
    @future(callout=true)   
    public static void sendEmailCustom(String Notif,String ToChiefGroup,String BAPid,String UserID)
    {
        system.debug('masuk di sendEmailCustom');
        Messaging.SingleEmailMessage Notification = new Messaging.SingleEmailMessage();
        User SalesName=[SELECT id,  Name,Manager.UserRole.Name, Manager.Manager.UserRole.Name, Manager.Manager.Email,Manager.Email,Email, 
                        LastName,Manager.lastName,Manager.Manager.lastName , Group_Head_Role_Name__c ,Sales_Group_Head__r.email FROM User WHERE ID=:userid ];
        system.debug('SalesName ==');
        BAP__c bap=[SELECT id,Name, Customer__r.Name,lebih_tagih__c, Sales_Group_Head__r.Manager.Email,Pinalty__c,Cost__c,
                    IOM_File_Link__c,Links_Info__c,Backdate_Approval_Status__c,Penalty_Approval_Status__c,ownerid,  
                    BAP_ID__c,BAP_No__c,Type_of_Request__c,Link__r.Link_id__c,Link__r.Service_Type__c,Sirkit__c,
                    termination_category__c,Approval_Remark__c,iscostpartner__c, CID__c,Terminate_Date__c,
                    Contract_Start_Date__c,Contract_End_Date__c,  Reason__c,Note__c,Pinalty_Currency_Format__c, 
                    IsBackDate__c, IsPenalty__c,Periode_Kontrak__c,
                    Terminate_Date_dd_MMM_yyyy__c ,Cost_Currency_Format_IND__c,Lebih_Tagih_Currency_Format_IND__c,Penalty_Currency_Format_IND__c
                    FROM BAP__c WHERE id=:bapid];
        system.debug('bap ===');
        User chiefenterprise=[SELECT id,Name,Email FROM User WHERE Profile.Name='CEO'];
        system.debug('chiefenterprise ===');
        //NOVI 2 FEB 2021
        //GH OPS
        User gh_ops= [SELECT id, name,Sales_Group_Head__r.email FROM User WHERE ID=:userid] ;
        //User gh_ops=[SELECT id,Name,Email,Profile.Name, userrole.name FROM User WHERE userrole.name='Group Head - Key Account Management'];
        
        //Head Technical & Contact
        User head_cts=[SELECT id,Name,Email,Profile.Name, userrole.name FROM User WHERE userrole.name='Head - Technical & Contact Center'];
        //Head Operations Management
        User head_om=[SELECT id,Name,Email,Profile.Name, userrole.name FROM User WHERE userrole.name='Head - Bid Mgmt & Business Intelligence'];
        
        date contractstart=BAP.Contract_Start_Date__c;
        date contractend=BAP.Contract_End_Date__c;
        datetime terminatedatetime=datetime.newinstance(BAP.terminate_date__c.year(),BAP.terminate_date__c.Month(),BAP.terminate_date__c.day(),7,0,0);
        String Terminate=terminatedatetime.format('dd MMM yyyy');
        Integer jangkawaktu=0;
        if(ContractStart!=null && ContractEnd!=null)
        {
            jangkawaktu=(contractstart.daysBetween(contractend)/365)*12;
        }
        
        system.debug ('============ jangkawaktu : '+ jangkawaktu);        
        
        
        String BodyEmail='<html><head></head><body>';
        list<String> mailto=new list<String>();
        list<String> mailcc=new list<String>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
        notification.setOrgWideEmailAddressId(owea.get(0).Id);
        system.debug ('============ owea : '+ owea);        
        
        
        
        if(notif=='GroupHead')
        {
            //Notification.setSubject('Need Approval: '+BAP.Name+' '+BAP.Customer__r.Name);
            Notification.setSubject('Need Approval '+ BAP.Name +' '+BAP.Link__r.Link_id__c);    
            BodyEmail=BodyEmail+'Dear '+ SalesName.Group_Head_Role_Name__c + ',<br/><br/> '
                + 'Mohon persetujuan untuk proses Berita Acara Pemutusan layanan sebagai berikut : <br/><br/>';
                    
                    /*mailto.add(SalesName.Manager.Manager.Email);
                    mailcc.add(SalesName.Manager.Email);
                    mailcc.add(SalesName.Email); */
                                        
                    //mailcc.add('operationcostmanagement@xl.co.id');
                    //mailcc.add('OperationRevenueManagement@xl.co.id');
                    
                    //(NOVI 2 FEB 2021) Sender : BAP Creator <Sales> CC: Requester/Creator, Head Requester, GH Ops, Head CTS, Head OM, ORM, OCM
                    //mailto.add(SalesName.Manager.Manager.Email);
            
                    mailto.add(gh_ops.Sales_Group_Head__r.email);
                    mailcc.add(SalesName.email);
                    mailcc.add(head_cts.Email);
                    mailcc.add(head_om.Email);
                    mailcc.add(system.label.OCM_Email);
                    mailcc.add(system.label.ORM_Email);
            
            
        }
        
       // --- send email custom to all (sales,sales manager,group head, orm, ocm, chief) 
       // ketika approval proses chief dan send gh notif = true -- 
       // method terpanggil ketika send gh is change
              
        if(notif=='Chief')
        {
            //ini untuk kirimnotif ke sales, manager dan GH bahwa BAP sedang dimintakan Approval

            Notification.setSubject('Need Approval '+ BAP.Name +' '+BAP.Link__r.Link_id__c); 
            BodyEmail=BodyEmail+'Dear Chief Enterprise - ME,<br/><br/> Mohon persetujuan untuk proses Berita Acara Pemutusan layanan sebagai berikut : <br/><br/>';
            //mailto.add(chiefenterprise.email);  -- ganti ke managernya CHIEF
            mailto.add(bap.Sales_Group_Head__r.Manager.Email);
            mailcc.add(SalesName.Manager.Email);
            mailcc.add(SalesName.Email);
            //mailcc.add('operationcostmanagement@xl.co.id');
            //mailcc.add('OperationRevenueManagement@xl.co.id');
            
            // (NOVI 2 FEB 2021) Sender : creator. CC: creator,head requester, GH Sales,GH Ops,Head CTS,Head OM,ORM,OCM
            mailto.add(SalesName.Manager.Manager.Email);
            
            mailcc.add(SalesName.email);
            mailcc.add(SalesName.Manager.Email);
            mailcc.add(gh_ops.Sales_Group_Head__r.email);
            mailcc.add(head_cts.Email);
            mailcc.add(head_om.Email);
            mailcc.add(system.label.OCM_Email);
            mailcc.add(system.label.ORM_Email);
            
            system.debug('============ recipient GH' +gh_ops);
            system.debug('============ recipient Head' +head_cts);
            system.debug('============ recipient head om' + head_om);
            system.debug('============ recipient sales manager' + SalesName.Manager.Email);
            system.debug('============ recipient sales' + SalesName.email);
            
            
        }
        
        if(notif=='Rejected')
        {
            //Notification.setSubject('Rejected '+BAP.Name+' '+BAP.Customer__r.Name);
            Notification.setSubject('Rejected '+ BAP.Name +' '+BAP.Link__r.Link_id__c);
            BodyEmail=BodyEmail+'Dear '+SalesName.Name+',<br/><br/>Proses Berita Acara Pemutusan layanan sebagai berikut ditolak oleh '+Userinfo.getName()+' :<br/><br/>';
            mailto.add(SalesName.Email);
            mailto.add(SalesName.Manager.Email);
            //mailcc.add('operationcostmanagement@xl.co.id');
            //mailcc.add('OperationRevenueManagement@xl.co.id');
            
        }
        
        
        if(notif=='Approved')
        {
            
            //Notification.setSubject('Approved '+BAP.Name+' '+BAP.Customer__r.Name);
            Notification.setSubject('Approved '+ BAP.Name +' '+BAP.Link__r.Link_id__c);
            BodyEmail=BodyEmail+'Dear '+SalesName.Name+',<br/><br/>Proses Berita Acara Pemutusan layanan sebagai berikut telah disetujui :<br/><br/>';
            mailto.add(SalesName.Email);
            mailto.add(SalesName.Manager.Email);
            //mailcc.add('operationcostmanagement@xl.co.id');
            //mailcc.add('OperationRevenueManagement@xl.co.id');
            system.debug('============ notif iom '+ SalesName.Email);
            system.debug('============ notif iom '+ SalesName.Manager.Email);
            
            if(tochiefgroup=='chief')
            {
                //mailcc.add(system.label.email_chief);
            }
            if(tochiefgroup=='group')
            {
                mailcc.add(SalesName.Manager.Manager.Email);
            }
        }
        
        BodyEmail=BodyEmail+'<table>';
        BodyEmail=BodyEmail+'<col width="200px" /><col width="10px" /><col width="400px" />';
        BodyEmail=BodyEmail+'<tr><td width="150">Nama Customer </td><td width="10">:</td><td width="250">'+BAP.Customer__r.Name+'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Layanan </td><td>:</td><td>'+BAP.Link__r.Service_type__c+'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Site Name </td><td>:</td><td>'+BAP.Sirkit__c+'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>LID </td><td>:</td><td>'+BAP.Links_Info__c+'</td></tr>';
        BodyEmail=BodyEmail+'<tr><td>Tanggal Terminasi </td><td>:</td><td>'+BAP.Terminate_Date_dd_MMM_yyyy__c +'</td></tr>';
        BodyEmail=BodyEmail+'<tr> <td>Periode Kontrak </td><td>:</td><td>'+bap.Periode_Kontrak__c+' Bulan</td></tr>'; 
        BodyEmail=BodyEmail+'<tr> <td>Reason </td><td>:</td><td>'+BAP.Reason__c+'</td></tr>';
        //add field notes based on meeting support request dari mas kahfi
        BodyEmail=BodyEmail+'<tr> <td>Note </td><td>:</td><td>'+BAP.Note__c+'</td></tr>';
        BodyEmail=BodyEmail+'<tr> <td align="top">Kategori Terminasi </td><td>:</td><td>'+BAP.Termination_Category__c+'  </td></tr></table>';
        
        List<String> args = new String[]{'0','number','#.###.0'};
        String costF;
        String lebihTagihF;
    	String pinaltyF;
        
        if (BAP.Cost__c != null) {
            //costF = String.format(BAP.Cost__c.format(), args);
            costF = BAP.Cost_Currency_Format_IND__c;
        } else {costF = '0';}
        
        if (BAP.Lebih_Tagih__c != null && BAP.Lebih_Tagih__c != 0) {
            //lebihTagihF = String.format(BAP.Lebih_Tagih__c.format(), args);
             lebihTagihF = BAP.Lebih_Tagih_Currency_Format_IND__c;
        } else {lebihTagihF = '0';}

        if (BAP.Pinalty__c != null) {
        	//pinaltyF = String.format(BAP.Pinalty__c.format(), args);
        	pinaltyF = BAP.Penalty_Currency_Format_IND__c;
        } else {pinaltyF = '0';}
        
                
        BodyEmail=BodyEmail+'<br/>Dengan    <br/>• Penagihan Penalty ke pelanggan sebesar Rp '+pinaltyF
            +'<br/> • Pengembalian lebih tagih ke pelanggan sebesar Rp ' + lebihTagihF
            +'<br/> • Pembayaran biaya ke partner sebesar Rp ' + costF +'<br/><br/>';
        
        if((BAP.IsBackDate__c== TRUE || BAP.IsPenalty__c == true || BAP.IsCostPartner__c == true) && BAP.approval_remark__c == 'Request for CEO Approval')
        {
            if(BAP.approval_remark__c=='Request for CEO Approval'){
            	BodyEmail=BodyEmail+'Persetujuan ini dibutuhkan karena :<br/>';
            }
            if(BAP.IsBackDate__c==true && BAP.IsPenalty__c == true && BAP.IsCostPartner__c== false && BAP.Backdate_Approval_Status__c == 'APPROVED' && BAP.Penalty_Approval_Status__c == 'NOT APPROVED') {
                BodyEmail=BodyEmail+' • Group Head tidak menyetujui penagihan penalty ke pelanggan  <br/>';
            }
            
            
            if( BAP.IsBackDate__c==true && BAP.IsPenalty__c == False && BAP.IsCostPartner__c==true  && BAP.Backdate_Approval_Status__c == 'APPROVED' || BAP.Penalty_Approval_Status__c == 'NO NEED APPROVAL') {
                BodyEmail=BodyEmail+' • Pembayaran biaya ke partner sebesar Rp '+costF+' <br/>' ;
            }
            
           if(BAP.IsBackDate__c==true && BAP.IsPenalty__c == true && BAP.IsCostPartner__c==true && BAP.Backdate_Approval_Status__c == 'APPROVED' && BAP.Penalty_Approval_Status__c == 'NOT APPROVED' ) {
                BodyEmail=BodyEmail+' • Group Head tidak menyetujui penagihan penalty ke pelanggan  <br/>' ;
                BodyEmail=BodyEmail+' • Pembayaran biaya ke partner sebesar Rp '+costF+'  <br/><br/>' ;
            }
			if(BAP.IsBackDate__c==false && BAP.IsPenalty__c == true && BAP.IsCostPartner__c==false && BAP.Backdate_Approval_Status__c == 'NO NEED APPROVAL' && BAP.Penalty_Approval_Status__c == 'NOT APPROVED' ) {
                BodyEmail=BodyEmail+' • Group Head tidak menyetujui penagihan penalty ke pelanggan  <br/>' ;
                //BodyEmail=BodyEmail+' • Pembayaran biaya ke partner sebesar Rp '+costF+'  <br/><br/>' ;
            }
             if(BAP.IsBackDate__c==false && BAP.IsPenalty__c == true && BAP.IsCostPartner__c==true && BAP.Backdate_Approval_Status__c == 'NO NEED APPROVAL' && BAP.Penalty_Approval_Status__c == 'APPROVED' ) {
                BodyEmail=BodyEmail+' • Pembayaran biaya ke partner sebesar Rp '+costF+'  <br/><br/>' ;
            }
              if(BAP.IsBackDate__c==false && BAP.IsPenalty__c == true && BAP.IsCostPartner__c==true && BAP.Backdate_Approval_Status__c == 'NO NEED APPROVAL' && BAP.Penalty_Approval_Status__c == 'NOT APPROVED' ) {
                BodyEmail=BodyEmail+' • Group Head tidak menyetujui penagihan penalty ke pelanggan  <br/>' ;
                BodyEmail=BodyEmail+' • Pembayaran biaya ke partner sebesar Rp '+costF+'  <br/><br/>' ;
            }
                            
            
        }
        
        BodyEmail = BodyEmail +'<br/><br/>';
        
        if(notif=='Rejected'||Notif=='Approved'||notif=='Grouphead') {
            BodyEmail=BodyEmail+'Untuk informasi detail BAP silakan klik ' 
                + '<a href='+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+BAP.id +' >link</a> ini.' 
                + '</body></html>' ;
        } 
       
        else{
             BodyEmail=BodyEmail+'Untuk informasi detail BAP silakan klik ' 
                + '<a href='+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+BAP.id +' >link</a> ini.' 
                + '</body></html>' ;
             
            // query ProcessInstanceworkitem tdk ada
           /* if(!test.isrunningtest())
            {
                ProcessInstanceworkitem PIS=[SELECT id FROM ProcessInstanceworkitem WHERE ActorID=:chiefenterprise.id AND Createddate=TODAY ORDER BY Createddate DESC LIMIT 1];
                //BodyEmail=BodyEmail+'Untuk informasi lebih lanjut silakan klik 
                //https://ap5.lightning.force.com/lightning/r/ProcessInstanceWorkItem/'+PIS.id+'/view.</body></html>';
                BodyEmail=BodyEmail+'Untuk informasi approval lebih lanjut silakan klik ' 
                + '<a href='+ URL.getSalesforceBaseUrl().toExternalForm()+'/' + PIS.id +' >Link</a> ini.' 
                + '</body></html>' ;
            } */
        } 
        PageReference pdf = page.Preview_IOM;
        pdf.getParameters().put('id',BAPid);
        Blob body;
        Call_Log__c CL=new Call_Log__c();
        CL.Salesforce_ID_1__c=BAPid;
        
        CL.Type__c='Email';
        CL.Request_Start_Time__c=system.now();
        try {
            
            // returns the output of the page as a PDF
            body = pdf.getContent();
            if(notif=='Approved')
            {
                /*ContentVersion v = new ContentVersion();
v.versionData = body;
v.title = BAP.Name+'.pdf';
v.pathOnClient ='/';
insert v;
ContentVersion V2=[SELECT ContentDocumentID FROM Contentversion WHERE ID=:v.id];
ContentDocumentLink CDL=new ContentDocumentLink();
CDL.contentdocumentid=V2.ContentDocumentID;
CDL.linkedentityid=BAP.id;
insert CDL;
ContentDistribution cd = new ContentDistribution();
cd.Name = BAP.Name;
cd.ContentVersionId = v.id;
cd.PreferencesAllowViewInBrowser= true;
cd.PreferencesLinkLatestVersion=true;
cd.PreferencesNotifyOnVisit=false;
cd.PreferencesPasswordRequired=false;
cd.PreferencesAllowOriginalDownload= true;
insert cd;
ContentDistribution CD2=[SELECT id,DistributionPublicUrl FROM ContentDistribution WHERE ID=:CD.id];
BAP.iom_file_link__c=CD2.DistributionPublicUrl;
update BAP;*/
            }
            
            // need to pass unit test -- current bug  
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error');
            CL.Response_Message__c  =e.getmessage();
            CL.Response_End_Time__c=system.now();
            
            insert CL;
            if(!test.isrunningtest())
                return;
        }
        if(notif=='Approved')
        {
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName(BAP.Name+'.pdf');
            attach.setInline(false);
            attach.Body = body;
            notification.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
        }

        // create a set from the list
        set<string> amailtoSet = new set<string>(mailto);
        set<string> amailccSet = new set<string>(mailcc);

        // remove blanks and nulls
        amailtoSet.remove('');
        amailtoSet.remove(null);

        amailccSet.remove('');
        amailccSet.remove(null);

        // convert back to list
        list<string> mailtoList = new list<string>(amailtoSet);
        list<string> mailccList = new list<string>(amailccSet);

        notification.sethtmlbody(BodyEmail);
        notification.setToAddresses(mailtoList);
        notification.setCcAddresses(mailccList);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {Notification});
    }
    /*
public void sendemailBAPtoCustomer(String BAPid)
{
//BAP=[SELECT Group_Head_Email__c FROM BAP__c WHERE id=:BAPid];
Messaging.SingleEmailMessage approvalNotif = new Messaging.SingleEmailMessage();
PageReference pdf = page.Preview_IOM;
pdf.getParameters().put('id',BAPid);
Blob body;
Call_Log__c CL=new Call_Log__c();
CL.Salesforce_ID_1__c=BAPid;

CL.Type__c='Email';
CL.Request_Start_Time__c=system.now();
try {

// returns the output of the page as a PDF
body = pdf.getContent();

// need to pass unit test -- current bug  
} catch (VisualforceException e) {
body = Blob.valueOf('Error');
CL.Response_Message__c  =e.getmessage();
CL.Response_End_Time__c=system.now();

insert CL;
if(!test.isrunningtest())
return;
}
Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
attach.setContentType('application/pdf');
attach.setFileName('BAP.pdf');
attach.setInline(false);
approvalNotif.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });


String[] sendTo = new String[]{BAP.Group_Head_Email__c};
approvalNotif.setToAddresses(sendTo);
approvalNotif.setSubject('BAP Approval IoM');
approvalNotif.setPlainTextBody('Approve dong ' + 'https://cs72.lightning.force.com/lightning/r/BAP__c/'+BAPid+'/view');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {approvalNotif});
}
*/
    //ngatur logic approval dari hasil pencetan di visualforce
    public PageReference pencetSubmit(){
        //String currentUrl = ApexPages.currentPage().geturl();
        
        //PageReference tempPage = new PageReference(currentUrl);      
        PageReference tempPage = new PageReference('/' + bapid);
        
        tempPage.setRedirect(true);     
        if(isBackdateFlag==TRUE&&isPenaltyFlag==TRUE)
        {           
            if (isBackDateToggle==TRUE && isPenaltyToggle==TRUE&&isCostPartnerFlag==FALSE)
            {
                bap.Backdate_Approval_Status__c = 'APPROVED';
                bap.Penalty_Approval_Status__c = 'APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                bap.IoM_Approval_Status__c = 'Approved';
                bap.Request_Status__c = 'BA Sent to Customer';
                Approval.unlock(bap.Id);
                
                //kirim email Notif Approval Completed (GH)
                sendEmailCustom('Approved', 'Group', BAP.id, bap.ownerid);
                //if(!test.isRunningTest())
                //update bap;
                
            }
            else if (isBackDateToggle==TRUE && isPenaltyToggle==TRUE&&isCostPartnerFlag==TRUE)
            {
                bap.Backdate_Approval_Status__c = 'APPROVED';
                bap.Penalty_Approval_Status__c = 'APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                Approval.unlock(bap.Id);
                bap.Approval_Remark__c = 'Request for CEO Approval';
                //if(!test.isRunningTest())
                //update bap;
                
            }
            else if (isBackDateToggle==TRUE && isPenaltyToggle==FALSE)
            {
                bap.Backdate_Approval_Status__c = 'APPROVED';
                bap.Penalty_Approval_Status__c = 'NOT APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                Approval.unlock(bap.Id);
                bap.Approval_Remark__c = 'Request for CEO Approval';
                //if(!test.isRunningTest())
                //update bap;
                
            }       
            else if (isBackDateToggle==FALSE && isPenaltyToggle==TRUE&&isCostPartnerFlag==FALSE)
            {
                bap.Backdate_Approval_Status__c = 'NOT APPROVED';
                bap.Penalty_Approval_Status__c = 'APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                bap.Request_Status__c = 'Draft';
                Approval.unlock(bap.Id);
                //kirim email Notif Rejection (GH)
                sendEmailCustom('Rejected', 'Group', BAP.id, bap.ownerid);
                //if(!test.isRunningTest())
                //update bap;
            }
            else if (isBackDateToggle==FALSE&&isPenaltyToggle==TRUE&&isCostPartnerFlag==TRUE)
            {
                bap.Backdate_Approval_Status__c = 'NOT APPROVED';
                bap.Penalty_Approval_Status__c = 'APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                bap.Request_Status__c = 'Draft';
                Approval.unlock(bap.Id);
                //kirim email Notif Rejection (GH)
                sendEmailCustom('Rejected', 'Group', BAP.id, bap.ownerid);
                //if(!test.isRunningTest())
                //update bap;
            }
            else if (isBackDateToggle==FALSE && isPenaltyToggle==FALSE)
            {
                bap.Backdate_Approval_Status__c = 'NOT APPROVED';
                bap.Penalty_Approval_Status__c = 'NOT APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                bap.Request_Status__c = 'Draft';
                Approval.unlock(bap.Id);
                sendEmailCustom('Rejected', 'Group', BAP.id, bap.ownerid);
                //if(!test.isRunningTest())
                //update bap;
            }       
        }
        else if(isBackdateFlag==TRUE&&isPenaltyFlag==FALSE)
        {
            if(isBackDateToggle==TRUE&&bap.IsCostPartner__c==FALSE)
            {
                bap.Backdate_Approval_Status__c = 'APPROVED';
                bap.Penalty_Approval_Status__c = 'NO NEED APPROVAL';
                bap.GH_Approval_Date__c = Datetime.Now();
                bap.IoM_Approval_Status__c = 'Approved';
                bap.Request_Status__c = 'BA Sent to Customer';
                Approval.unlock(bap.Id);
                //kirim email Notif Approval Completed (GH)
                sendEmailCustom('Approved', 'Group', BAP.id, bap.ownerid);
                //if(!test.isRunningTest())
                //update bap;
                
            }
            else if(isBackDateToggle==TRUE&&bap.IsCostPartner__c==TRUE)
            {
                bap.Backdate_Approval_Status__c = 'APPROVED';
                bap.Penalty_Approval_Status__c = 'NO NEED APPROVAL';
                bap.GH_Approval_Date__c = Datetime.Now();
                Approval.unlock(bap.Id);
                bap.Approval_Remark__c = 'Request for CEO Approval';
                //if(!test.isRunningTest())
                //update bap;
                
            }
            else
            {
                bap.Backdate_Approval_Status__c = 'NOT APPROVED';
                bap.Penalty_Approval_Status__c = 'NO NEED APPROVAL';
                bap.GH_Approval_Date__c = Datetime.Now();
                bap.Request_Status__c = 'Draft';
                Approval.unlock(bap.Id);
                //kirim email Notif Rejection (GH)
                sendEmailCustom('Rejected', 'Group', BAP.id, bap.ownerid);
                //if(!test.isRunningTest())
                //update bap;
                
            }
        }
        else if(isBackdateFlag==FALSE&&isPenaltyFlag==TRUE)
        {
            if(isPenaltyToggle==TRUE&&bap.IsCostPartner__c==FALSE)
            {
                bap.Backdate_Approval_Status__c = 'NO NEED APPROVAL';
                bap.Penalty_Approval_Status__c = 'APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                bap.IoM_Approval_Status__c = 'Approved';
                bap.Request_Status__c = 'BA Sent to Customer';
                Approval.unlock(bap.Id);
                //kirim email Notif Approval Completed (GH)
                sendEmailCustom('Approved', 'Group', BAP.id, bap.ownerid);
                //kirim email BAP ke 
                //if(!test.isRunningTest())
                //update bap;
                
            }
            else if(isPenaltyToggle==TRUE&&bap.IsCostPartner__c==TRUE)
            {
                bap.Backdate_Approval_Status__c = 'NO NEED APPROVAL';
                bap.Penalty_Approval_Status__c = 'APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                Approval.unlock(bap.Id);
                bap.Approval_Remark__c = 'Request for CEO Approval';
                //if(!test.isRunningTest())
                //update bap;
                
            }
            else if (isPenaltyToggle==FALSE)
            {
                bap.Backdate_Approval_Status__c = 'NO NEED APPROVAL';
                bap.Penalty_Approval_Status__c = 'NOT APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                Approval.unlock(bap.Id);
                bap.Approval_Remark__c = 'Request for CEO Approval';
                //if(!test.isRunningTest())
                //update bap;
                
            } 
            /*else
            {
                bap.Backdate_Approval_Status__c = 'NO NEED APPROVAL';
                bap.Penalty_Approval_Status__c = 'NOT APPROVED';
                bap.GH_Approval_Date__c = Datetime.Now();
                bap.Request_Status__c = 'Draft';
                Approval.unlock(bap.Id);
                //kirim email Notif Rejection (GH)
                sendEmailCustom('Rejected', 'Group', BAP.id, bap.ownerid);
                //if(!test.isRunningTest())
                //update bap;
                
            }*/
        }
        
        
        checkboxBackdateVisibility = FALSE;
        checkboxPenaltyVisibility = FALSE;
        submitVisibility = FALSE;
        
        bap.pernah_disubmit__c = TRUE;
        update bap;
        
        
        return tempPage;
    }
    
}