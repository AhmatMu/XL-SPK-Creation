global class updatePRInformation {
    
    webservice static void UpdatePRInformationUpdate(String OpportunityID)
    {
       /*     Opportunity O=[SELECT ID,owner.name,Update_PR_Status__c,Opportunity_ID__c,SR__c,PR__c,Project_Coordinator__c,Link_Related__c,Service_Type__c,OwnerID,Contract_Periode__c,Expected_RFS_Date__c,periode_uom__c,Account_Site_A__r.Name,Account_Site_A__r.BP_Number__c,Accountid,Account.Name,Account.BP_Number__c,Segmentation__c,Link_related__r.Name,Link_Related__r.Link_id__c, 
            International_BW__c,Local_BW__c,CID__c,Router_Type__c,BW_before__c,qos__c,as_number__c,PSTN_Domestic__c,power_consumption__C,rack_quantity__c,domain__c,Add_On_Storage__c,OS__c,LastMile_Type__c,Account_Site_B__c,Account_Site_B__r.BP_Number__c,Account_Site_B__r.Name,Quota__c,UOM_Quota__c,UOM_BW_Before__c,UOM_BW_AFter__c,BW_After__c,
            Site_A_Relocation_Street__c,Site_A_Relocation_city__c,Site_A_Relocation_State_Province__c,Site_A_Relocation_Zip_Postal_Code__c,Recurring_Revenue__c,Auto_Renewal__c,trial__c,Account_BA_Sign__r.Name,
            Site_B_Relocation_Street__c,Site_B_Relocation_city__c,Site_B_Relocation_State_Province__c,Site_B_Relocation_Zip_Postal_Code__c,RecordType.Name
            FROM Opportunity WHERE ID=:OpportunityID];
        list<AccountContactRelation> listACR=[SELECT Contactid,Contact.Name,Account.BP_NUMBER__C,Roles From AccountContactRelation WHERE AccountID=:O.AccountID AND Roles INCLUDES('PIC BA Recipient','PIC BA Print','PIC BA Sign')];
        if(O.RecordType.Name.Contains('Leased Line') && O.Account_Site_B__c!=null)
        {
        }
          User U=[SELECT ID,Profile.Name,Name,Employee_ID__c,Manager.Name FROM User WHERE ID=:O.OwnerID];
          list<User> U2=[SELECT ID FROM User WHERE Email=:system.label.system_admin_email];
        OpportunityLineItem OLI=new OpportunityLineItem();
        //Contract_Item__c CIOld=new Contract_Item__c();
          if(!O.RecordType.Name.Contains('VOIP'))
    	{
 		}
        sapComDocumentSapRfcFunctions2.ZEXDSDST00098 Opportnity=new sapComDocumentSapRfcFunctions2.ZEXDSDST00098();
        sapComDocumentSapRfcFunctions2.ZEXDSDST00099 Link=new sapComDocumentSapRfcFunctions2.ZEXDSDST00099();
        Opportnity.Task='U';
         
        String TransactionYear=String.valueof(system.today().year());
        String TransactionMonth=String.valueof(system.today().Month());
        String TransactionDay=String.valueof(system.today().Day());
        if(transactionmonth.length()<2)
        transactionmonth='0'+transactionmonth;
        if(transactionday.length()<2)
        transactionday='0'+transactionday;
        Opportnity.transaction_date=transactionyear+transactionmonth+transactionday;
         Transaction__c settings = Transaction__c.getOrgDefaults();
          Opportnity.Transaction_Id=String.valueof(settings.transactionID__c);//'01234567';
          settings.transactionID__c= settings.transactionID__c+1;
        Opportnity.OPPORTUNITY_ID=O.Opportunity_ID__c.replace('-','');
    if(O.service_type__c=='NewLink')
        {Opportnity.PROJECT_TYPE='0001';
            Link.CID=O.CID__c;
        }
         else
    {
        Link.CID=O.Link_Related__r.Name;
        Link.LinkID=O.Link_related__r.Link_id__c;
    }
        if(O.service_type__c=='Upgrade')
        Opportnity.PROJECT_TYPE='0002';
        if(O.service_type__c=='Downgrade')
        Opportnity.PROJECT_TYPE='0003';
        if(O.service_type__c=='Relocation')
        Opportnity.PROJECT_TYPE='0004';
        if(O.service_type__c=='Reroute')
        Opportnity.PROJECT_TYPE='0005';
        if(O.trial__c==true)
         Opportnity.PROJECT_TYPE='0006';
        Opportnity.TRX_Type='PR';
        Opportnity.SR_NO=O.SR__c;
        Opportnity.SAP_ID=O.PR__c;
          if(O.RecordType.Name.Contains('VOIP'))
        {
        	Link.BANDwidth='0';
        	Link.Quota='0';
        	Link.Product='VOIP-02';
        	Link.UOM_BandWidth='0001';
        	Link.UOM_Quota=null;
        } 
        else
        {
   
      
        if(O.Service_type__c=='Relocation'||O.Service_type__c=='Reroute')
         { Link.Bandwidth=O.BW_Before__C;
              IF(O.UOM_BW_After__c=='KBPS')
             	Link.UOM_BandWidth='0001';
             if(O.UOM_BW_After__c=='E1')
             	Link.UOM_BandWidth='0002';
               if(O.UOM_BW_After__c=='DS3')
               	Link.UOM_BandWidth='0003';
                 if(O.UOM_BW_After__c=='STM1')
                 	Link.UOM_BandWidth='0004';
            IF(O.UOM_BW_After__c=='MBPS')
            	Link.UOM_BandWidth='0006';
            IF(O.UOM_BW_After__c=='GBPS')
            	Link.UOM_BandWidth='0012';
         }
         else
         {
          Link.Bandwidth=O.BW_After__C;
            Link.Bandwidth_Before=O.BW_Before__c;
              IF(O.UOM_BW_After__c=='KBPS')
             	Link.UOM_BandWidth='0001';
             if(O.UOM_BW_After__c=='E1')
             	Link.UOM_BandWidth='0002';
               if(O.UOM_BW_After__c=='DS3')
               	Link.UOM_BandWidth='0003';
                 if(O.UOM_BW_After__c=='STM1')
                 	Link.UOM_BandWidth='0004';
            IF(O.UOM_BW_After__c=='MBPS')
            	Link.UOM_BandWidth='0006';
            IF(O.UOM_BW_After__c=='GBPS')
            	Link.UOM_BandWidth='0012';
         }
       		Link.QUOTA=O.Quota__c;
        	Link.UOM_Quota=O.UOM_Quota__c; 
        	boolean onetimerecurring=false;
        	list<OpportunityLineItem> listOli=[SELECT id,Revenue_Type__c FROM OpportunityLineItem WHERE OpportunityID=:OpportunityID];
        	for(OpportunityLineItem OI:listOLI)
        	{
        		if(OI.revenue_type__c=='recurring')
        			onetimerecurring=true;
        	}
        	if(onetimerecurring==false)
        	OLI=[SELECT id,Name,Product2.Bandwidth__c,Product2.SAP_Code__c,Product2.UOM_Bandwidth__c,Product2.Quota__c,Product2.Uom_Quota__c FROM OpportunityLineItem WHERE OpportunityID=:OpportunityID LIMIT 1];
        	else
        	OLI=[SELECT id,Name,Product2.Bandwidth__c,Product2.SAP_Code__c,Product2.UOM_Bandwidth__c,Product2.Quota__c,Product2.Uom_Quota__c FROM OpportunityLineItem WHERE OpportunityID=:OpportunityID AND Revenue_type__c='Recurring' LIMIT 1];
        	Link.Product=OLI.Product2.SAP_Code__c;
        }
        if(O.Service_Type__c=='Relocation')
        {   
          
        }
        Link.Segment=O.Segmentation__c.replace('&','AND');
        Link.SM_NAME=U.Manager.Name;
        String RFSDay=String.valueof(O.Expected_RFS_Date__c.day());
        String RFSMonth=String.valueof(O.Expected_RFS_Date__c.month());
        if(RFSDay.length()<2)
        RFSDay='0'+RFSDay;
        if(RFSMonth.length()<2)
        RFSMonth='0'+RFSMonth;
        String RFSYear=String.valueof(O.Expected_RFS_Date__c.year());
        Link.EXPECTED_RFS_DAT=RFSYear+RFSMonth+RFSDay;//'20180204';
        Link.CONTRACT_PERIODE=String.valueof(O.Contract_Periode__c);
        if(O.Periode_UOM__c=='Month')
        Link.Periode_UOM='01';
        if(O.Periode_UOM__c=='Year')
        Link.Periode_UOM='02';
    
        Link.INTERNATIONAL_BW=O.International_BW__c;
        Link.Local_BW=O.local_BW__c;
        Link.ROUTER_TYPE=O.Router_Type__c;
        Link.BANDWIDTH_BEFORE=O.BW_before__c;
            if(O.QOS__c=='Platinum')
        Link.QOS='0001';
        else if(O.Qos__C=='Gold')
        Link.QOS='0002';
        else if(O.QOS__c=='Silver')
        Link.QOS='0003';
        else 
        Link.QOS='';
        if(O.LastMile_Type__c=='Radio')
        Link.LAST_MILE='0001';
        else if(O.LastMile_Type__c=='Fiber')
        Link.LAST_MILE='0004';
        else if(O.Lastmile_Type__c=='Partner')
        Link.LAST_MILE='0002';
        else
        Link.LAST_MILE='0005';
        if(O.Recurring_revenue__c!=null)
        Link.reserve2='IDR|'+String.valueof(O.Recurring_revenue__c);
        if(O.Auto_Renewal__c==false)
        Link.reserve1='NON';
        else
        Link.reserve1='';
        Link.AS_Number=O.AS_Number__c;
        Link.PSTN_DOMESTIC=O.PSTN_Domestic__c;
        Link.POWER_CONSUMPTION=O.Power_Consumption__c;
        Link.RACK_QUANTITY=O.Rack_Quantity__c;
        Link.DOMAIN=O.Domain__c;
        Link.Add_On_Storage=O.Add_On_Storage__c;
        Link.OS=O.OS__c;
        list<sapComDocumentSapRfcFunctions2.ZEXDSDST00100> ArrayPartner=new list<sapComDocumentSapRfcFunctions2.ZEXDSDST00100>();
        sapComDocumentSapRfcFunctions2.ZEXDSDST00100 Partner=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
   		 Partner.Partner_ID=U.employee_id__c;
        if(U.Name.length()>=35)
        Partner.Partner_Name=U.Name.substring(0,34);
        else
        Partner.Partner_Name=U.Name;
        Partner.Role='$C';//U.profile.Name;
            sapComDocumentSapRfcFunctions2.ZEXDSDST00100 Partner2=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
        Partner2.Partner_ID=O.Account.BP_Number__c;
        if(O.Account.Name.length()>=35)
        Partner2.Partner_Name=O.Account_BA_Sign__r.Name.substring(0,34);
      // Partner2.Partner_Name=O.Account.Name.substring(0,34);
        else
      Partner2.Partner_Name=O.Account_BA_Sign__r.Name;
    // Partner2.Partner_Name=O.Account.Name;
        Partner2.Role='$G';//U.profile.Name;
            ArrayPartner.add(Partner);
        ArrayPartner.add(Partner2);
            sapComDocumentSapRfcFunctions2.ZEXDSDST00100 Partner3=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
        if(O.Account_Site_A__c!=null)
        {
        Partner3.Partner_ID=O.Account_Site_A__r.BP_Number__c;
        if( O.Account_Site_A__r.Name.length()>=35)
        Partner3.Partner_Name=O.Account_Site_A__r.Name.substring(0,34);
        else
         Partner3.Partner_Name=O.Account_Site_A__r.Name;
        if(O.RecordType.Name.Contains('Leased Line'))
        Partner3.Role='SA';
        else
        Partner3.Role='SP';//U.profile.Name;
        ArrayPartner.add(Partner3);
        }
        if(O.RecordType.Name.Contains('Leased Line') && O.Account_Site_B__c!=null)
        {
            sapComDocumentSapRfcFunctions2.ZEXDSDST00100 Partner7=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
        Partner7.Partner_ID=O.Account_Site_B__R.BP_Number__c;
        if(O.Account_Site_B__r.Name.length()>=35)
        Partner7.Partner_Name=O.Account_Site_B__r.Name.substring(0,34);
        else
        Partner7.Partner_Name=O.Account_Site_B__r.Name;
        Partner7.Role='SB';//U.profile.Name;
        ArrayPartner.add(Partner7);
        }
        sapComDocumentSapRfcFunctions2.ZEXDSDST00100 Partner4=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
        Partner4.Partner_ID=O.Project_Coordinator__c.left(8);
        Partner4.Partner_Name=O.Project_Coordinator__c.substring(8);
        Partner4.Role='$E';//U.profile.Name;
        ArrayPartner.add(Partner4);
        
        
        
        for(AccountContactRelation ACR:listACR)
        {
                sapComDocumentSapRfcFunctions2.ZEXDSDST00100 PartnerX=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
                 sapComDocumentSapRfcFunctions2.ZEXDSDST00100 PartnerY=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
        PartnerX.Partner_ID=ACR.Account.BP_Number__c;
        if(ACR.Contact.Name.length()>=35)
        PartnerX.Partner_Name=ACR.Contact.Name.substring(0,34);
        else
         PartnerX.Partner_Name=ACR.Contact.Name;
         if(ACR.Roles.Contains('Recipient') && (ACR.Roles.Contains('PIC BA Print')||ACR.Roles.Contains('PIC BA Sign')))
        {
        	 PartnerY.Partner_ID=ACR.Account.BP_Number__c;
        	 if(ACR.Contact.Name.length()>=35)
        PartnerY.Partner_Name=ACR.Contact.Name.substring(0,34);
        else
        PartnerY.Partner_Name=ACR.Contact.Name;
        PartnerX.Role='ZH';
        PartnerY.Role='$H';
        ArrayPartner.Add(PartnerY);
        ArrayPartner.Add(PartnerX);
        }
        else
        {
        if(ACR.Roles.Contains('PIC BA Print')||ACR.Roles.Contains('PIC BA Sign'))
        PartnerX.Role='ZH';
        else
        PartnerX.Role='$H';
        ArrayPartner.Add(PartnerX);
        }
        }
       list<AccountContactRelation> ACR2=[SELECT Contactid,Contact.Name,Roles,Account.BP_Number__c,Account.Name FROM AccountContactRelation WHERE AccountID=:O.Account_Site_A__c AND Roles INCLUDES('PIC Site')];
        if(O.RecordType.Name.Contains('Leased Line') && O.Account_Site_B__c!=null)
        {
        ACR2=[SELECT AccountID,Contactid,Contact.Name,Roles,Account.BP_Number__c,Account.Name FROM AccountContactRelation WHERE (AccountID=:O.Account_Site_A__c OR AccountID=:O.Account_Site_B__c) AND Roles INCLUDES('PIC Site')];  
        }
          if(O.RecordType.Name.Contains('Leased Line') && O.Account_Site_B__c!=null)
        {
            for(AccountContactRelation AC:ACR2)
            {
                sapComDocumentSapRfcFunctions2.ZEXDSDST00100 Partner9=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
                Partner9.Partner_ID=AC.Account.BP_Number__c;
                if(AC.Contact.Name.length()>=35)
                Partner9.Partner_Name=AC.Contact.Name.substring(0,34);
                else
                Partner9.Partner_Name=AC.Contact.Name;
                if(AC.Accountid==O.Account_Site_A__c)
                Partner9.Role='PA';
                if(AC.Accountid==O.Account_Site_B__c)
                Partner9.Role='PB';
                ArrayPartner.Add(Partner9);
            }
        }
        else
        {
        if(ACR2.Size()>0)
        {   
        	sapComDocumentSapRfcFunctions2.ZEXDSDST00100 Partner10=new sapComDocumentSapRfcFunctions2.ZEXDSDST00100();
      
        Partner10.Partner_ID=O.Account_Site_A__r.BP_Number__c;//'90002724';
        if(ACR2[0].Contact.Name.length()>=35)
        Partner10.Partner_Name=ACR2[0].Contact.Name.substring(0,34);
        else
        Partner10.Partner_Name=ACR2[0].Contact.Name;
        Partner10.Role='$A';//U.profile.Name;
        ArrayPartner.add(Partner10);
        }
        }
        
        sapComDocumentSapRfcFunctions2.ZEXDSDTT00053 listPartner=new sapComDocumentSapRfcFunctions2.ZEXDSDTT00053();
        listPartner.item=ArrayPartner;
        sapComDocumentSapRfcFunctions2.ZBD_SF_SRPR HitSAP=new sapComDocumentSapRfcFunctions2.ZBD_SF_SRPR();
          HitSAP.inputHttpHeaders_x=new Map<String,String>();
            String username = system.label.SAPUsername;//'xlsapint';
			String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';
Blob headerValue = Blob.valueOf(username + ':' + password);
String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
HitSAP.inputHttpHeaders_x.put('Authorization',authorizationHeader);
HitSAP.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        sapComDocumentSapRfcFunctions2.ZEXDSDTT00054 Result=new sapComDocumentSapRfcFunctions2.ZEXDSDTT00054();
        try{
        	if(!test.isRunningTest())
        Result=HitSAP.ZEXD_SF_SRPR(listPartner,Link,Opportnity);
        list<sapComDocumentSapRfcFunctions2.ZEXDSDST00101> listresponse=new list<sapComDocumentSapRfcFunctions2.ZEXDSDST00101>();
        listresponse=Result.item;
    
        Call_Log__c CL=new Call_Log__c();
        CL.endpoint__c=hitSAP.endpoint_x;
       sapComDocumentSapRfcFunctions2.ZEXDSDTT00052 MessageResultArray=listresponse[0].MESSAGES;
 		list<sapComDocumentSapRfcFunctions2.ZEXDSDST00097> MessageList=MessageResultArray.Item;
 		    
        //CL.response_message__c=String.valueof(listresponse[0]);
        CL.response_message__c=Json.serialize(listresponse[0]);
		CL.Request_Message__c=String.valueof('  Link'+Link+'  ListPartner'+listPartner+'   Opportunity'+Opportnity);
    	
     
        CL.response_end_time__c=system.now();
        CL.Type__c='Callout';
        insert CL;
        update settings;
		
       Send_Email__c se = new Send_Email__c ();
       se.user_receiver__c = O.OwnerId;
       if(U2.size()>0)
       se.User_Receiver_2__c=U2[0].id;
       se.subject__c = 'Request Update PR dengan ID' + O.Opportunity_ID__c + ' Gagal';
       String messageerror='';
       for(sapComDocumentSapRfcFunctions2.ZEXDSDST00097 MSG:Messagelist)
       {
       	if(String.valueof(MSG.Message)!='Success')
       		messageerror=messageerror+'   <br>Message: '+MSG.Message+'<br>';
       }
       if(messageerror=='')
       {
       	  O.Update_PR_Status__c = 'Success at ' + String.valueof(datetime.now());
       }
       else
       {
       se.Message_Body__c = 'Dear ' + O.owner.name  + '<br>' + '<br>'+ '<br>' 
                    + 'Request update PR Failed Because'+ MessageError;
                  se.status__c = 'New';
                  O.Update_PR_Status__c = 'Failed at ' + String.valueof(datetime.now());
                  insert se;
                 
       }    
         update O;    
        }
         catch(exception e)
		{
			 Call_Log__c CL=new Call_Log__c();
        CL.endpoint__c=hitSAP.endpoint_x;
   //    system.debug(msg[0]);
          CL.response_message__c=e.getmessage() +' '+ e.getLineNumber();
         CL.Request_Message__c=String.valueof('  Link'+Link+'  ListPartner'+listPartner+'   Opportunity'+Opportnity);
            // CL.Method__c='SAP';
        CL.response_end_time__c=system.now();
        CL.Type__c='Callout';
     //   O.StageName='Quotation Final';
        Send_Email__c se2 = new Send_Email__c ();
       se2.user_receiver__c = O.OwnerId;
       if(U2.size()>0)
       se2.User_Receiver_2__c=U2[0].id;
       se2.subject__c = 'Request Update PR dengan ID' + O.Opportunity_ID__c + ' Gagal';
      se2.Message_Body__c = 'Dear ' + O.owner.name  + '<br>' + '<br>'+ '<br>' 
                    + 'Request update PR Failed Because'+ e.getmessage()+'  '+e.getstacktracestring();
                  se2.status__c = 'New';
                  O.Update_PR_Status__c = 'Failed at ' + String.valueof(datetime.now());
        update O;
        insert CL;
        insert se2;
         update settings;
		}
        */
    }
}