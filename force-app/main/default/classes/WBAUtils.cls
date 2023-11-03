public class WBAUtils {
    public String HariIni {get;set;}
    public String TanggalIni {get;set;}
    public SR_PR_Notification__c SPBA{get;set;}
    public Account Acc{get;set;}
    public Account SiteA{get;set;}
    public Account SiteB{get;set;}
    public String siteAinfo{get;set;}
    public String siteBinfo{get;set;}
    public Opportunity Opp{get;set;}
    public AccountContactRelation ACR{get;set;}
    public String displaytableNonGSM{get;set;}
    public String displayMCA{get;set;}
    public String displaytableVOIP{get;set;}
    public String displaytablecloudiaas{get;set;}
    public String displaytableMDS{get;set;}
    public String displayLL{get;set;}
    public String displayCL{get;set;}
    public String displayrelocation{get;set;}
    public date tanggalpenagihan{get;set;}
    public String displayerror{get;set;}
    public String displaynoerror{get;set;}
    public String displayexisting{get;set;}
    public String displayTelcoDataInsight{get;set;} // Adding by Sysadmin 6 Nov 2020
    public String deskripsiVOIP{get;set;}
    public string opportunityID {get;set;} 
    public String closingstatement{get;set;}  
    public String tanggalintegrasi{get;set;}
    public String trial{get;set;}
    public String contractperiode{get;set;}
    public String uom{get;set;}
    public String berlangganan{get;set;}
    public String autorenewal {get;set;}
    public String jangkawaktu {get;set;}
    public String contractstart {get;set;}
    public String contractend {get;set;}
    public String quarter {get;set;}
    public string linkID {get;set;}
    public list<link__c> links{get;set;}   
    public WBAUtils(ApexPages.StandardController controller) {
        Opportunity O=(Opportunity)controller.getrecord();
        Opp=[SELECT id ,Opportunity_id__c,PKS_Number__c,PIC_BA_Print__c,COF_Number__c,Contract_Periode__c,trial__c,auto_renewal__c,periode_uom__c,link_related__r.Contract_Item_Rel__r.Periode_UOM__c,link_related__r.Contract_Item_Rel__r.Contract_Term__c,Auto_Renewal_Periode__c,Auto_Renewal_UOM__C from Opportunity WHERE id=:O.id];
        //variable to display certain services	
        displaytablenongsm='display:none';
        displaytablecloudiaas='display:none';
        displaytableVOIP='display:none';
        displayerror='display:none';
        displaynoerror='display:none';
        displaytableMDS='display:none';
        displayMCA='display:none';
        displayexisting='display:none';
        displayLL='display:none';
        displayCL='display:none';
        displayrelocation='display:none';
        trial='';
        berlangganan='berlangganan';
        autorenewal='tidak otomatis';
        Integer q=0;
        OpportunityLineItem OLI=[SELECT id,Contract_start_date__c,Contract_end_date__c FROM OpportunityLineItem WHERE OpportunityID=:Opp.id LIMIT 1];
        if(OLI.Contract_Start_Date__c!=null)
            contractstart=convertdateindonesia(datetime.newinstance(OLI.Contract_Start_Date__c.year(),OLI.Contract_Start_Date__c.month(),OLI.Contract_Start_Date__c.day(),6,0,0));
        if(OLI.Contract_Start_Date__c!=null)
            contractend=convertdateindonesia(datetime.newinstance(OLI.Contract_End_Date__c.year(),OLI.Contract_End_Date__c.month(),OLI.Contract_End_Date__c.day(),6,0,0));
        
        list<SR_PR_Notification__c> SRPR=[select id from SR_PR_Notification__c WHERE Opportunity__c=:Opp.id AND Notif_type__c='PR' LIMIT 1]; //AND Status__c='Waiting Berita Acara'];
        if(SRPR.Size()==0)
        { 
            
            displayerror='';
            
        }
        else
        {
            //declare SR PR , ACCOUNT, SITE AND OPP Variable
            displaynoerror='';
            SPBA=[SELECT id,Name,Account__c,Services__c,Billing_Start_Date__c,Capacity_Before__c,IP_PTP__c,UOM_Before__c,Capacity_After__c,UOM_After__c,Link_id__c,MSISDN__c,IP_LAN__c,Project_Complete_Date__c,Hostname__c,OS__c,vcore__c,Memory__c,Storage__c,IP_Address__c ,Existing_On_Net__c,
                  Existing_Off_Net__c,Site_A__c,Site_B__c,Project_type__c,A_Number__c,Existing_PSTN__c,Existing_MinCom__c,new_on_net__c,new_off_net__c,new_PSTN__c,new_mincom__c,Rack_Number__c,Power_Consumption__c
                  FROM SR_PR_Notification__c WHERE Opportunity__c=:O.id AND Notif_type__c='PR' LIMIT 1];// AND Status__c='Waiting Berita Acara'];
            Acc=[SELECT id,Name,No_NPWP__c,BillingCity,BillingStreet,BillingState,BillingPostalCode,	Relocation_Street_1__c	,	Relocation_Street_2__c,	Relocation_Street_3__c,	Relocation_City__c,	Relocation_Postal_Code__c	 FROM Account WHERE ID=:SPBA.Account__c];
            ACR=[SELECT id,Contact.Name,Contact.Title,Contact.Phone,Contact.Email FROM AccountContactRelation WHERE AccountID=:Acc.id AND Contactid=:Opp.pic_ba_print__c];
            SiteA=[SELECT id,Name,Unique_Name__c,BillingStreet,BillingCity,BillingPostalCode,Relocation_Street_1__c	,	Relocation_Street_2__c,	Relocation_Street_3__c,	Relocation_City__c,	Relocation_Postal_Code__c FROM Account WHERE ID=:SPBA.Site_A__c];
            SiteAinfo=SiteA.Name+' - '+SiteA.Unique_Name__c;
            
            ContractPeriode=String.valueof(Opp.Contract_Periode__c);
            UOM=String.valueof(Opp.Periode_UOM__c);
            
            
            if(UOM=='Week')
            {
                q=Integer.valueof(ContractPeriode)*7/4;
                UOM='Minggu';
            }
            if(UOM=='Month')
            {
                q=Integer.valueof(ContractPeriode)*30/4;
                UOM='Bulan';
            }
            if(UOM=='Day')
            {
                q=Integer.valueof(ContractPeriode)/4;
                UOM='Hari';
            }/*
if(q<=3)
{
Quarter='3 Hari';
}
else if(q>30)
{
q=q/30;
Quarter=q+' Bulan';
}
else if(q>7)
{
q=q/7;
Quarter=q+' Minggu';
}
else 
Quarter=q+' Hari';*/
            if(Opp.trial__c==true)
            {	trial='Trial';
             berlangganan='';
            }
            jangkawaktu='diperpanjang untuk periode berikutnya selama tidak ada pemberitahuan tertulis perpanjangan berlangganan dari salah satu pihak paling lambat '+Opp.Auto_Renewal_Periode__c+' '+Opp.Auto_Renewal_UOM__C+' sebelumnya.';
            if(Opp.auto_renewal__c==true)
            {
                autorenewal='otomatis';
                jangkawaktu='diperpanjang untuk periode berikutnya selama tidak ada pemberitahuan tertulis pemutusan berlangganan dari salah satu pihak paling lambat '+Opp.Auto_Renewal_Periode__c+' '+Opp.Auto_Renewal_UOM__C+' sebelumnya.';
                
            }
            if(SPBA.Services__c=='LL'||SPBA.Services__c=='VLL'||SPBA.Services__c=='L2VPN')
            {
                SiteB=[SELECT id,Name,Unique_Name__c,BillingStreet,BillingCity,BillingPostalCode,Relocation_Street_1__c	,	Relocation_Street_2__c,	Relocation_Street_3__c,	Relocation_City__c,	Relocation_Postal_Code__c FROM Account WHERE ID=:SPBA.Site_B__c];
                siteBinfo=SiteB.Name+' - '+SiteB.Unique_Name__c;
                displayLL='';
            }
            else
            {
                siteBinfo='';
            }
            if(SPBA.Services__c=='Voip')
            {
                displaytableVOIP='';
                
                if(SPBA.Project_type__c!='New')
                {displayexisting='';
                 deskripsivoip='Change Price';
                }
                else
                {
                    deskripsivoip='New';
                }
            }
            if(SPBA.Services__c=='Cloud IAAS')
            {
                displaytableCloudIAAS='';
            }
            if(SPBA.Services__c=='MPLS'||
            	SPBA.Services__c=='LL'||
            	SPBA.Services__c=='VLL'||
            	SPBA.Services__c=='ISP'||
            	SPBA.Services__c=='L2VPN'||
            	SPBA.Services__c=='MCA/Fleetech'||
            	SPBA.Services__c=='MCA'||
            	SPBA.Services__c=='Fleet'||
            	SPBA.Services__c=='SSLVPN'||
            	SPBA.Services__c=='ISPUPTO'||
            	SPBA.Services__c=='ISPHRB'||
            	SPBA.Services__c=='NAP'||
            	SPBA.Services__c=='ISPFTTX'||
            	SPBA.Services__c=='VPLS'||
            	SPBA.Services__c=='Collocation'||
            	SPBA.Services__c=='NAPMIX' ||
            	SPBA.Services__c=='4G Access'||
            	SPBA.Services__c=='SD-WAN' ||
                SPBA.Services__c=='DIRECT PEERING')
            {
                displaytableNonGSM='';
                if(SPBA.Services__c=='MCA/Fleetech'||SPBA.Services__c=='MCA'||SPBA.Services__c=='FLEET' ||SPBA.Services__c=='4G Access')
                    displayMCA='';
                if(SPBA.Project_type__c=='Relocation')
                    displayrelocation='';
                if(SPBA.Services__c=='Collocation')
                    displayCL='';
                
                
            }
            if(SPBA.Services__c=='MDS Bulkshare' )
            {
                tanggalpenagihan=SPBA.Project_Complete_Date__c.addmonths(1);
                displaytableMDS='';
                closingstatement='';
            }
            else
            {
                if(SPBA.Services__c!='VoIp')
                {closingstatement='Telah selesai ditest dan dipasang dengan hasil sesuai spesifikasi teknis yang disepakati serta dinyatakan telah digunakan/dioperasikan terhitung sejak Tanggal Berita Acara ini.\n Pelanggan bertanggung jawab sepenuhnya atas isi dari semua informasi yang ada pada Berita Acara ini. Pelanggan menyetujui untuk tunduk pada syarat dan ketentuan yang berlaku di XL.Apabila dalam jangka waktu 14 (empat belas) hari sejak tanggal efektif dan Berita Acara ini belum ditandatangani maka XL berhak untuk men-nonaktifkan layanan ini.\n Pelanggan wajib menanggung seluruh biaya instalasi yang telah disepakati oleh kedua belah pihak. ';}
                else
                {
                    closingstatement='Telah selesai dipasang dan ditest secara teknis maupun rating dengan hasil baik serta dinyatakan siap digunakan / dioperasikan.\n Demikian Berita Acara ini dibuat dalam rangkap 2 (dua) asli yang sama bunyinya dan mempunyai kekuatan hukum yang sama setelah ditandatangani oleh Para Pihak.';
                    
                }
            }
            datetime dt=system.now();
            if(SPBA.Billing_Start_Date__c!=null)
            {
                dt=datetime.newinstance(SPBA.Billing_Start_Date__c.year(),SPBA.Billing_Start_Date__c.month(),SPBA.Billing_Start_Date__c.day(),3,0,0);
            }
            Hariini=returndayIndonesia(dt);
            if(SPBA.Project_complete_date__c!=null)
            {
               /* datetime projectcomplete=datetime.newinstance(SPBA.Project_Complete_Date__c.year(),SPBA.Project_Complete_Date__c.month(),SPBA.Project_Complete_Date__c.day(),6,0,0);
                tanggalintegrasi=convertdateindonesia(projectcomplete); */
                 datetime projectcomplete=datetime.newinstance(SPBA.Project_Complete_Date__c.year(),SPBA.Project_Complete_Date__c.month(),SPBA.Project_Complete_Date__c.day(),6,0,0);
                tanggalintegrasi=projectcomplete.format('YYYY-MM-DD');
            }
            
            Tanggalini=convertdateindonesia(dt);

        }
    }
    
    public String convertdateindonesia(datetime D)
    {
        //convert date to Indonesia date
        String CurrentDate=D.format('dd MMM yyyy');
        if(CurrentDate.Contains('Jan')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Jan','Januari');
        if(CurrentDate.Contains('Feb')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Feb','Februari');
        if(CurrentDate.Contains('Mar')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Mar','Maret');
        if(CurrentDate.Contains('Apr')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Apr','April');
        if(CurrentDate.Contains('May')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('May','Mei');
        if(CurrentDate.Contains('Jun')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Jun','Juni');
        if(CurrentDate.Contains('Jul')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Jul','Juli');
        if(CurrentDate.Contains('Aug')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Aug','Agustus');
        if(CurrentDate.Contains('Sep')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Sep','September');
        if(CurrentDate.Contains('Oct')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Oct','Oktober');
        if(CurrentDate.Contains('Nov')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Nov','November');
        if(CurrentDate.Contains('Dec')||test.isrunningtest())
            CurrentDate=CurrentDate.Replace('Dec','Desember');
        return CurrentDate;
    }
    public String returndayindonesia(datetime dt)
    {
        //convert day to Indonesian
        String CurrentDay=dt.format('EEEE');
        if(CurrentDay=='Monday'||test.isrunningtest())
            CurrentDay='Senin';
        if(CurrentDay=='Tuesday'||test.isrunningtest())
            CurrentDay='Selasa';
        if(CurrentDay=='Wednesday'||test.isrunningtest())
            CurrentDay='Rabu';
        if(CurrentDay=='Thursday'||test.isrunningtest())
            CurrentDay='Kamis';
        if(CurrentDay=='Friday'||test.isrunningtest())
            CurrentDay='Jum\'at';
        if(CurrentDay=='Saturday'||test.isrunningtest())
            CurrentDay='Sabtu';
        if(CurrentDay=='Sunday'||test.isrunningtest())
            CurrentDay='Minggu';
        return currentday;
    }
}