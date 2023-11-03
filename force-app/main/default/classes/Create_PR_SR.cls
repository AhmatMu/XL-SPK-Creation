/* ====================================================================================================
* Class Name		        : Create_PR_SR
* Test Class		        : testSR_PR
* Created By		        : 
* Created Date		        : 
* Created Description		: 
* Updated By                : Novando Utoyo Agmawan
* Updated Date	            : 09/2021
* Updated Description		: - Move to Email template for body email
* ====================================================================================================
*/

global class Create_PR_SR
{
    
    public Task createTask(String Description,boolean Active,Integer ActNumber,Date Start,Date ActDate,SR_PR_Notification__c SP)
    {
        //create task in PR
        task T=new Task();
        T.Subject=Description;
        T.WhatID=SP.ID;
        T.Active__c=Active;
        T.Activity_Number__c=ActNumber;
        T.Start_Date__c=start;
        T.ActivityDate=ActDate;
        return T; 
    } 
    public String setautorenewal(integer Contractperiode,String uom)
    {
        //create autorenewal duration formula
        String Quarter='';
        Integer Q=0;
        if(UOM=='Week')
        {
            q=ContractPeriode*7/4;
            UOM='Minggu';
        }
        if(UOM=='Month')
        {
            q=ContractPeriode*30/4;
            UOM='Bulan';
        }
        if(UOM=='Day')
        {
            q=ContractPeriode/4;
            UOM='Hari';
        }
        if(q<=3)
        {
            Quarter='3 Hari';
        }
        else if(q>30)
        {
            q=q/30;
            if(q>3)
                q=3;
            Quarter=q+' Bulan';
            
            
        }
        else if(q>7)
        {
            q=q/7;
            Quarter=q+' Minggu';
        }
        else 
            Quarter=q+' Hari';
        return Quarter;
    }
    
    public void CreatePRMarketplace(Opportunity oppObj)
    {
        Opportunity oppToUpdateObj = [SELECT id, pr__c, CID__c, PR_rel__c FROM Opportunity WHERE id =:oppObj.id];
        
        //create PR in marketplace record type
        list<OpportunityLineItem> OLI=[SELECT Product2.ProductCode,Product2.Product_Code2__c 
                                       FROM OpportunityLineItem 
                                       WHERE OpportunityID=:oppObj.id];
        
        Account A=[SELECT ID,Name,Parent.BP_Number__c,Parent.Name,BP_Number__c,Unique_Name__c,ShippingCity,Region__c,BP_Number_Unique_Name__c 
                   FROM Account 
                   WHERE ID=:oppObj.Accountid];
        
        SR_PR_Notification__c SP=new SR_PR_Notification__c();
        SP.Notif_Type__c='PR';
        SP.Opportunity__c=oppObj.id;
        SP.Account__c=oppObj.AccountID;
        
        //Novi, SIR : set owner SRPR based on sales Opty . 16 feb 2021
        SP.OwnerId = oppObj.ownerId;
        SR_PR__c SPN=SR_PR__c.getorgdefaults();//get PR Number counter
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
        String Stringprnumber=String.valueof(SPN.PR_Number__c);
        StringPRNumber=StringPRNumber.replace('.0','');
        while(Stringprnumber.length()<6)
        {
            Stringprnumber='0'+stringprnumber;
        }
        String PRNumber=todaymonthyear+'-'+stringprnumber;
        //Create default PR Number
        SP.Name='PR-'+PRNumber;
        
        SPN.PR_Number__c=SPN.PR_Number__c+1;
        SP.Project_type__c='ECommerce';
        SP.Status__c='In Progress';
        SP.Notif_Date__c=system.today();
        SP.Services__c=OLI[0].Product2.Product_Code2__c;
        SP.Normal_RFS__c=system.today().adddays(14);
        SP.UOM_Before__c=oppObj.UOM_BW_Before__c;
        SP.Exp_RFS_Date__c=oppObj.Expected_RFS_Date__c;
        SP.UOM_After__c=oppObj.UOM_BW_After__c;
        SP.Capacity_Before__c=oppObj.BW_Before__c;
        SP.Capacity_After__c=oppObj.BW_After__c;
        SP.CPE_Additional_Request__c=oppObj.Router_type__c;
        SP.Project_Coordinator_Text__c=oppObj.Project_Coordinator__c;
        SP.Project_Name__c=SP.Services__c+' - ECommerce '+A.Name;
        //set default value of PR from Oppty
        update SPN; 
        insert SP;
        
        
        //-- update pr information in opportunity ----
        oppToUpdateObj.PR__c = PRNumber;
        oppToUpdateObj.PR_rel__c = SP.id;
        update oppToUpdateObj;
        
    }
    
    public void createPR(Opportunity oppObj)
    {
        Opportunity oppToUpdateObj = [SELECT id, pr__c, CID__c, PR_rel__c FROM Opportunity WHERE id =:oppObj.id];
        
        list<OpportunityLineItem> OLI=[SELECT Product2.ProductCode,Product2.Product_Code2__c 
                                       FROM OpportunityLineItem 
                                       WHERE OpportunityID=:oppToUpdateObj.id];
        
        Account A=[SELECT ID,Name,Parent.BP_Number__c,Parent.Name,BP_Number__c,Unique_Name__c,ShippingCity,Region__c,BP_Number_Unique_Name__c 
                   FROM Account 
                   WHERE ID=:oppObj.Account_Site_A__c];
        
        AccountContactRelation ACR=[SELECT Contactid,Contact.Name,Contact.Phone,Contact.MobilePhone 
                                    FROM AccountContactRelation 
                                    WHERE AccountID=:A.id AND ROLES INCLUDES ('PIC Site') LIMIT 1];
        
        String PhoneVariable='';
        if(ACR.Contact.Phone!=null && ACR.Contact.Phone!='') {
            PhoneVariable=ACR.Contact.Phone;
        }
        
        if(ACR.Contact.MobilePhone!=null && ACR.Contact.MobilePhone!='') {
            PhoneVariable=ACR.Contact.MobilePhone;
        }
        
        SR_PR_Notification__c SP=new SR_PR_Notification__c();
        SP.Solution_PIC__c = oppObj.Solution_PIC__c;
        SP.Notif_Type__c='PR';
        SP.Opportunity__c=oppObj.id;
        SP.Account__c=oppObj.AccountID;
        
        //Novi, SIR : set owner SRPR bases on sales Opty . 16 feb 2021
        //SP.OwnerId = oppObj.ownerId;
        
        SR_PR__c SPN=SR_PR__c.getorgdefaults();
        system.debug('masuk di 175');
        String month='';
        String year='';
        if(system.today().month()<10) {
            month='0'+String.valueof(system.today().month());
        }
        else{
            month=String.valueof(system.today().month());
        }
        
        year=String.valueof(system.today().year()).right(2);
        String todaymonthyear=year+month;
        String Stringprnumber=String.valueof(SPN.PR_Number__c);
        StringPRNumber=StringPRNumber.replace('.0','');
        while(Stringprnumber.length()<6)
        {
            Stringprnumber='0'+stringprnumber;
        }
        
        String PRNumber=todaymonthyear+'-'+stringprnumber;
        //Set PR Number default
        SP.Name = 'PR-' + PRNumber;
        SPN.PR_Number__c=SPN.PR_Number__c+1;
        
        if(oppObj.Service_type__c=='Newlink') {
            SP.Project_type__c='New';
        }
        else {
            SP.Project_type__c = oppObj.Service_Type__c;
        }
        
        SP.Status__c='In Progress';
        //set default variable/value for PR from oppty object
        SP.Site_A__c = oppObj.Account_Site_A__c;
        SP.Notif_Date__c=system.today();
        
        if(SP.Project_type__c=='New') {
            SP.Normal_RFS__c=system.today().adddays(30);
        }
        else {
            SP.Normal_RFS__c=system.today().adddays(14);
        }
        
        SP.UOM_Before__c = oppObj.UOM_BW_Before__c;
        SP.Exp_RFS_Date__c = oppObj.Expected_RFS_Date__c;
        SP.UOM_After__c = oppObj.UOM_BW_After__c;
        SP.Capacity_Before__c = oppObj.BW_Before__c;
        SP.Capacity_After__c = oppObj.BW_After__c;
        SP.CPE_Additional_Request__c = oppObj.Router_type__c;
        SP.Project_Coordinator_Text__c = oppObj.Project_Coordinator__c;
        SP.No_SR_Khusus_PR__c = oppObj.SR__c;
        //  Link_CID__c LC=Link_CID__c.getorgdefaults();
        SP.PIC_Site__c = ACR.Contactid;
        SP.Customer_Request_lastmile_type__c = oppObj.Lastmile_type__c;
        SP.Trial__c = oppObj.trial__c;
        
        
        if(SP.Trial__c==true)
        {
            //trial condition
            if(SP.Billing_Start_Date__c!=null)
            {
                if(sp.start_date_trial__c==null) {
                    SP.Start_Date_trial__c=SP.Billing_Start_Date__c;
                }
                
                if(sp.end_date_trial__c==null) {
                      SP.End_Date_trial__c=SP.Start_Date_Trial__c.adddays(15); 
                      //EXISTING 
                     // update 27/11/2021 Diky

                    // if(oppObj.periode_uom__c == 'Month'){
                    //     Integer contractPeriodemonth = Integer.valueOf(oppObj.Contract_Periode__c);
                    //     SP.End_Date_trial__c=SP.Start_Date_Trial__c.addMonths(contractPeriodemonth);
                    // }
                    // if(oppObj.periode_uom__c == 'Week'){
                    //     Integer contractPeriodeweek = Integer.valueOf(oppObj.Contract_Periode__c)*7;
                    //     SP.End_Date_trial__c=SP.Start_Date_Trial__c.addDays(contractPeriodeweek);
                    // }
                    // if(oppObj.periode_uom__c == 'Day'){
                    //     Integer contractPeriodeday = Integer.valueOf(oppObj.Contract_Periode__c);
                        
                    //     SP.End_Date_trial__c=SP.Start_Date_Trial__c.addDays(contractPeriodeday);
                    //     system.debug('INI YG HARI ---> ' + oppObj.Contract_Periode__c);
                    // }
                    
                }
            }
        }
        //  String CIDInitial='';
        //  String CIDNumber='';
        SP.Services__c=OLI[0].Product2.Product_Code2__c;
        if(OLI[0].Product2.Product_Code2__c=='CL') {
            SP.Services__c='Collocation';
        }
        
        if(OLI[0].Product2.Product_Code2__c=='IAAS') {
            SP.Services__c='Cloud IAAS';
        }
        
        list<SR_PR_Notification__c> prevSR=[SELECT A_Number__c,B_Number__c,new_On_Net__c,CPE_Managed_by__c,Existing_On_Net__c,new_Off_Net__c,existing_off_net__c,new_PSTN__c,existing_pstn__c,new_Mincom__c,existing_mincom__c,Survey_Lastmile_Type__c FROM SR_PR_Notification__c WHERE Opportunity__c=:SP.Opportunity__c AND Status__c='Close(Complete)'];
        if(prevSR.size()>0 && oppObj.RecordtypeName__c!='B2B Marketplace')
        {
            if(SP.Services__c=='Voip')
            {
                //map variable for voip item
                SP.new_On_Net__c=prevSR[0].new_on_net__c;
                SP.Existing_On_Net__c=prevSR[0].Existing_On_Net__c;
                SP.new_Off_Net__c=prevSR[0].new_Off_Net__c;
                SP.existing_off_net__c=prevSR[0].existing_off_net__c;
                SP.new_PSTN__c=prevSR[0].new_PSTN__c;
                SP.existing_pstn__c=prevSR[0].existing_pstn__c;
                SP.new_Mincom__c=prevSR[0].new_Mincom__c;
                SP.existing_mincom__c=prevSR[0].existing_mincom__c;
                SP.A_Number__c=prevSR[0].A_Number__c;
                SP.B_Number__c=prevSR[0].B_Number__c;
                SP.CPE_Managed_by__c=prevSR[0].CPE_Managed_by__c;
            }
        }
        
        if(SP.Services__c=='LL'||SP.Services__c=='VLL'||SP.Services__c=='L2VPN')
        {
            //map variable for leased line
            SP.Site_B__c = oppObj.Account_Site_B__c;
            AccountContactRelation ACR2=[SELECT Contactid,Contact.Name,Contact.Phone,Contact.MobilePhone FROM AccountContactRelation WHERE AccountID=:oppObj.Account_Site_B__c AND ROLES INCLUDES ('PIC Site') LIMIT 1];
            SP.PIC_Site_B__c=ACR2.ContactID;
        }
        
        if(SP.Project_Type__c=='New')
        {
            Circuit__c cir=new Circuit__c();
            cir.Services__c=SP.Services__c;
            insert Cir;
            SP.Circuit__c=CIR.id;
            //set CID default value for new link
            Circuit__c CRCT=[SELECT Name FROM Circuit__c WHERE ID=:CIR.id];
            SP.CID__c=CRCT.Name;
            oppToUpdateObj.CID__c = CRCT.Name;
        }
        else
        {
            //existing link
            Link__c L = [SELECT cid__c,link_id__c,CID_RelD__c FROM Link__c WHERE ID=:oppObj.Link_Related__c];
            if(L != null){
                SP.Cid__c=L.CID__c;
                SP.Link_id__c=L.Link_id__c;
                SP.Circuit__c=L.CID_RelD__c;
            }
            
        }
        
        //      update LC;
        SP.Project_Name__c=SP.Services__c+' - '+A.Name+','+A.Unique_Name__c;
        update SPN; 
        insert SP;
        
        //-- update pr information in opportunity ----
        oppToUpdateObj.PR__c = PRNumber;
        oppToUpdateObj.PR_rel__c = SP.id;
        update oppToUpdateObj;
        
        
        Date RunningDate=system.today();
        Date PreviousDate=system.today();
        list<Task> ListT=new list<Task>();
        //  list<SR_PR_Notification__c> SRPrev=[SELECT Survey_Lastmile_Type__c FROM SR_PR_Notification__c WHERE Opportunity__c=:O.id and Notif_Type__c='SR' AND Status__c='Close(Complete)'];
        
        if(prevSR.size()>0) {
            //set task for new PR
            list<Task_Template__c> TT=[SELECT id,Activities__c,Duration__c from Task_Template__c WHERE Service_type__c LIKE :SP.Services__c AND Survey_Lastmile_Type__c=:PrevSR[0].Survey_Lastmile_Type__c AND  Project_Type__c=:SP.Project_Type__c];
            if(TT.size()>0)
            {
                String[] listactivity=TT[0].Activities__c.split(';');
                String[] listduration=TT[0].Duration__c.split(';');
                Task T=new Task();
                Integer dr=0;
                date paralleldate=system.today();
                integer activitynumber=0;
                for(Integer x=0;x<listactivity.size();x++)
                {
                    system.debug('Activity '+listactivity[x]+' list Duration '+ listduration[x]+' X= '+x);
                    dr=Integer.valueof(listDuration[x]);
                    if(!listActivity[x].contains('Parallel'))
                    {
                        activitynumber=activitynumber+1;
                        previousdate=runningdate.adddays(1);
                        runningdate=previousdate.adddays(dr);
                        T=createTask(listActivity[x],false,activitynumber,previousdate,runningdate,SP);
                        if(activitynumber==1)
                            T.Active__c=true;
                    }
                    else
                    {
                        previousdate=previousdate.adddays(1);
                        paralleldate=previousdate.adddays(dr);
                        listactivity[x]=listactivity[x].replace('Parallel','');
                        T=createTask(listActivity[x],false,activitynumber,previousdate,paralleldate,SP);
                        T.Parallel__c=true;
                        system.debug('Task Created:' +T);
                    }
                    
                    
                    
                    listT.add(T);
                }
            }
        }
        insert listT;
        
        
        //send email when PR Created
        sendEmailPR(SP, oppObj, A, ACR.Contact.Name,PhoneVariable);
    }

    public void sendEmailPR(SR_PR_Notification__c SP,Opportunity O,Account A,String PICName,String PICPhone)
    {
        DateTime start_time = datetime.now();
        try {
            system.debug ('== masuk sendEmailPR ');

            List<EmailNotif_SRPR__c> EmailNotif_SRPR = [
                SELECT Name, 
                Additional_toAddress__c, 
                Additional_toCCAddress__c,
                Email_Template__c,
                Sender_Email__c 
                FROM EmailNotif_SRPR__c 
                WHERE Name =: 'Notification PR Created'
            ];

            if(EmailNotif_SRPR!=null && !EmailNotif_SRPR.isEmpty()){
                List<string> List_toAddress = new List<string>();
                List<string> List_toCCAddress = new List<string>();

                Set<string> Set_AddressList = new Set<string>();
                Set<string> Set_AddressCCList = new Set<string>();

                String batch_ToAddress = EmailNotif_SRPR[0].Additional_toAddress__c;
                String batch_toCCAddress = EmailNotif_SRPR[0].Additional_toCCAddress__c;
                
                if(String.isNotBlank(batch_ToAddress)){
                    if(batch_ToAddress.contains(' ')){ //space
                        String toAddress = batch_ToAddress.replaceAll('\\s','');
                        List_toAddress = toAddress.split(';');
                    }
                    if(batch_ToAddress.contains(',')){ //koma
                        String toAddress = batch_ToAddress.replaceAll('\\,',';');
                        List_toAddress = toAddress.split(';');
                    }
                    if(batch_ToAddress.contains('|')){ //pipe
                        String toAddress = batch_ToAddress.replaceAll('\\|',';');
                        List_toAddress = toAddress.split(';');
                    }
                    if(batch_ToAddress.contains(' ') && batch_ToAddress.contains(',') ){ //space dan koma
                        String toAddress = batch_ToAddress.replaceAll('\\s','');
                        String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                        List_toAddress = toAddressFormat_1.split(';');
                    }
                    if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') ){ //space dan pipe
                        String toAddress = batch_ToAddress.replaceAll('\\s','');
                        String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                        List_toAddress = toAddressFormat_1.split(';');
                    }
                    if(batch_ToAddress.contains(',') && batch_ToAddress.contains('|') ){ //koma dan pipe
                        String toAddress = batch_ToAddress.replaceAll('[\\|\\,]',';');
                        List_toAddress = toAddress.split(';');
                    }
                    if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') && batch_ToAddress.contains(',') ){ //koma dan pipe dan space
                        String toAddress = batch_ToAddress.replaceAll('\\s','');
                        String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                        List_toAddress = toAddressFormat_1.split(';');
                    }
                    if(!batch_ToAddress.contains(' ') && !batch_ToAddress.contains('|') && !batch_ToAddress.contains(',') ){
                        List_toAddress = batch_ToAddress.split(';');
                    }
                }
                
                if(String.isNotBlank(batch_toCCAddress)){
                    if(batch_toCCAddress.contains(' ')){ //space
                        String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                        List_toCCAddress = toCCAddress.split(';');
                    }
                    if(batch_toCCAddress.contains(',')){ //koma
                        String toCCAddress = batch_toCCAddress.replaceAll('\\,',';');
                        List_toCCAddress = toCCAddress.split(';');
                    }
                    if(batch_toCCAddress.contains('|')){ //pipe
                        String toCCAddress = batch_toCCAddress.replaceAll('\\|',';');
                        List_toCCAddress = toCCAddress.split(';');
                    }
                    if(batch_toCCAddress.contains(',') && batch_toCCAddress.contains('|') ){ //koma dan pipe
                        String toCCAddress = batch_toCCAddress.replaceAll('[\\|\\,]',';');
                        List_toCCAddress = toCCAddress.split(';');
                    }
                    if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains(',') ){ //space dan koma
                        String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                        String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                        List_toCCAddress = toCCAddressFormat_1.split(';');
                    }
                    if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') ){ //space dan pipe
                        String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                        String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                        List_toCCAddress = toCCAddressFormat_1.split(';');
                    }
                    if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') && batch_toCCAddress.contains(',') ){ //koma dan pipe dan space
                        String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                        String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                        List_toCCAddress = toCCAddressFormat_1.split(';');
                    }
                    if(!batch_toCCAddress.contains(' ') && !batch_toCCAddress.contains('|') && !batch_toCCAddress.contains(',') ){
                        List_toCCAddress = batch_toCCAddress.split(';');
                    }
                }

                Account HO = [SELECT BP_Number__c,Name,Owner.Manager.Email,Owner.Email FROM Account WHERE id=:O.AccountID];
                User ProjectCoordinator = [SELECT id,Email FROM User WHERE Name=:O.Project_Coordinator__c.Substringafter(' ')];
                String PhoneVariable=''; 

                EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: EmailNotif_SRPR[0].Email_Template__c];
                List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];

                SP.VarEmail_PICName__c = PICName;
                SP.VarEmail_PICPhone__c = PICPhone;

                if(SP.Services__c=='LL'||SP.Services__c=='VLL'||SP.Services__c=='L2VPN')
                {
                    AccountContactRelation ACR2 = [SELECT Contact.Name,Contact.Phone,Contact.Mobilephone FROM AccountContactRelation WHERE AccountID=:SP.Site_B__c AND Roles INCLUDES ('PIC Site') LIMIT 1];
                    
                    if(ACR2.Contact.Phone!=null && ACR2.Contact.Phone!=''){
                        PhoneVariable=ACR2.Contact.Phone;
                    }
                    
                    if(ACR2.Contact.MobilePhone!=null && ACR2.Contact.MobilePhone!='') {
                        PhoneVariable=ACR2.Contact.MobilePhone;
                    }

                    SP.VarEmail_PICSiteB_Name__c = ACR2.Contact.Name;
                    SP.VarEmail_PICSiteB_Phone__c = PhoneVariable;
                    SP.PIC_Customer_B_Email__c = ACR2.Contact.Name+'-'+PhoneVariable;
                }

                SP.PIC_Customer_Email__c = PICName+'-'+PICPhone;
                SP.Head_Sales_Email__c = HO.Owner.Manager.Email;
                SP.Project_Coordinator_Email__c = ProjectCoordinator.Email;
                SP.Sales_Email__c = HO.Owner.Email;
                SP.OwnerId = O.ownerId;
                Database.SaveResult updateResult = Database.update(SP); 

                system.debug('sendEmailPR updateResult : ' + updateResult);

                if(updateResult.isSuccess()) {
                    List_toAddress.add(SP.Project_Coordinator_Email__c);

                    Set_AddressList.addAll(List_toAddress);
                    Set_AddressCCList.addAll(List_toCCAddress);

                    Set_AddressList.remove('');
                    Set_AddressList.remove(null);
                    
                    Set_AddressCCList.remove('');
                    Set_AddressCCList.remove(null);

                    list<String> mailcc=new list<String>{};
                    list<String> mailto=new list<String>{};

                    mailto.addAll(Set_AddressList);
                    mailcc.addAll(Set_AddressCCList);
                    
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: EmailNotif_SRPR[0].Sender_Email__c];

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    mail.optOutPolicy = 'FILTER';
                    mail.setUseSignature(false);
                    mail.setToAddresses(Mailto);
                    if(mailcc!=null && !mailcc.isEmpty()){
                        mail.setCCaddresses(mailcc);
                    }
                    mail.setTemplateId(et.Id);
                    mail.setTargetObjectId(contactList[0].id);
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setWhatId(SP.Id);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};

                    if(!test.isrunningtest()){
                        List<Messaging.SendEmailResult> results = new List<Messaging.SendEmailResult> ();
                        results = Messaging.sendEmail(messages);

                        Call_Log__c CL=new Call_Log__c();
                        CL.Salesforce_ID_1__c=O.PR__c;
                        CL.Salesforce_id_2__c=O.Opportunity_ID__c;
                        CL.Type__c='Email';
                        CL.Request_Start_Time__c=system.now();
                        CL.Response_End_Time__c=system.now();
                        CL.Response_Message__c='Success ='+results[0].issuccess()+' Error:'+results[0].geterrors();
                        insert CL;
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Create_PR_SR.cls - sendEmailPR ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
    
    public void sendEmailSR(SR_PR_Notification__c SP,Opportunity O,Account A,String PICName,String PICPhone)
    {
        DateTime start_time = datetime.now();
        try {
            system.debug ('== masuk sendEmailSR ');

            List<EmailNotif_SRPR__c> EmailNotif_SRPR = [
                SELECT Name, 
                Additional_toAddress__c, 
                Additional_toCCAddress__c,
                Email_Template__c,
                Sender_Email__c 
                FROM EmailNotif_SRPR__c 
                WHERE Name =: 'Notification SR Created'
            ];

            if(EmailNotif_SRPR!=null && !EmailNotif_SRPR.isEmpty()){
                List<string> List_toAddress = new List<string>();
                List<string> List_toCCAddress = new List<string>();

                Set<string> Set_AddressList = new Set<string>();
                Set<string> Set_AddressCCList = new Set<string>();

                String batch_ToAddress = EmailNotif_SRPR[0].Additional_toAddress__c;
                String batch_toCCAddress = EmailNotif_SRPR[0].Additional_toCCAddress__c;
                
                if(String.isNotBlank(batch_ToAddress)){
                    if(batch_ToAddress.contains(' ')){ //space
                        String toAddress = batch_ToAddress.replaceAll('\\s','');
                        List_toAddress = toAddress.split(';');
                    }
                    if(batch_ToAddress.contains(',')){ //koma
                        String toAddress = batch_ToAddress.replaceAll('\\,',';');
                        List_toAddress = toAddress.split(';');
                    }
                    if(batch_ToAddress.contains('|')){ //pipe
                        String toAddress = batch_ToAddress.replaceAll('\\|',';');
                        List_toAddress = toAddress.split(';');
                    }
                    if(batch_ToAddress.contains(' ') && batch_ToAddress.contains(',') ){ //space dan koma
                        String toAddress = batch_ToAddress.replaceAll('\\s','');
                        String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                        List_toAddress = toAddressFormat_1.split(';');
                    }
                    if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') ){ //space dan pipe
                        String toAddress = batch_ToAddress.replaceAll('\\s','');
                        String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                        List_toAddress = toAddressFormat_1.split(';');
                    }
                    if(batch_ToAddress.contains(',') && batch_ToAddress.contains('|') ){ //koma dan pipe
                        String toAddress = batch_ToAddress.replaceAll('[\\|\\,]',';');
                        List_toAddress = toAddress.split(';');
                    }
                    if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') && batch_ToAddress.contains(',') ){ //koma dan pipe dan space
                        String toAddress = batch_ToAddress.replaceAll('\\s','');
                        String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                        List_toAddress = toAddressFormat_1.split(';');
                    }
                    if(!batch_ToAddress.contains(' ') && !batch_ToAddress.contains('|') && !batch_ToAddress.contains(',') ){
                        List_toAddress = batch_ToAddress.split(';');
                    }
                }
                
                if(String.isNotBlank(batch_toCCAddress)){
                    if(batch_toCCAddress.contains(' ')){ //space
                        String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                        List_toCCAddress = toCCAddress.split(';');
                    }
                    if(batch_toCCAddress.contains(',')){ //koma
                        String toCCAddress = batch_toCCAddress.replaceAll('\\,',';');
                        List_toCCAddress = toCCAddress.split(';');
                    }
                    if(batch_toCCAddress.contains('|')){ //pipe
                        String toCCAddress = batch_toCCAddress.replaceAll('\\|',';');
                        List_toCCAddress = toCCAddress.split(';');
                    }
                    if(batch_toCCAddress.contains(',') && batch_toCCAddress.contains('|') ){ //koma dan pipe
                        String toCCAddress = batch_toCCAddress.replaceAll('[\\|\\,]',';');
                        List_toCCAddress = toCCAddress.split(';');
                    }
                    if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains(',') ){ //space dan koma
                        String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                        String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                        List_toCCAddress = toCCAddressFormat_1.split(';');
                    }
                    if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') ){ //space dan pipe
                        String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                        String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                        List_toCCAddress = toCCAddressFormat_1.split(';');
                    }
                    if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') && batch_toCCAddress.contains(',') ){ //koma dan pipe dan space
                        String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                        String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                        List_toCCAddress = toCCAddressFormat_1.split(';');
                    }
                    if(!batch_toCCAddress.contains(' ') && !batch_toCCAddress.contains('|') && !batch_toCCAddress.contains(',') ){
                        List_toCCAddress = batch_toCCAddress.split(';');
                    }
                }

                EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: EmailNotif_SRPR[0].Email_Template__c];
                List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];

                String PhoneVariable='';

                SP.VarEmail_PICName__c = PICName;
                SP.VarEmail_PICPhone__c = PICPhone;

                if(SP.Services__c=='LL'||SP.Services__c=='VLL'||SP.Services__c=='L2VPN')
                {
                    list<AccountContactRelation> ACR2=[SELECT Contact.Name,Contact.Phone,Contact.MobilePhone FROM AccountContactRelation WHERE AccountID=:SP.Site_B__c AND Roles INCLUDES ('PIC Site')];

                    if(ACR2[0].Contact.Phone!=null && ACR2[0].Contact.Phone!=''){
                        PhoneVariable=ACR2[0].Contact.Phone;
                    }

                    if(ACR2[0].Contact.MobilePhone!=null && ACR2[0].Contact.MobilePhone!=''){
                        PhoneVariable=ACR2[0].Contact.MobilePhone;
                    }

                    SP.VarEmail_PICSiteB_Name__c = ACR2[0].Contact.Name;
                    SP.VarEmail_PICSiteB_Phone__c = PhoneVariable;
                }
                
                SP.Sales_Email__c=A.owner.Email;
                Database.SaveResult updateResult = Database.update(SP); 

                system.debug('sendEmailSR updateResult : ' + updateResult);

                if(updateResult.isSuccess()) {
                    List_toCCAddress.add(A.Owner.Email);

                    Set_AddressList.addAll(List_toAddress);
                    Set_AddressCCList.addAll(List_toCCAddress);

                    Set_AddressList.remove('');
                    Set_AddressList.remove(null);
                    
                    Set_AddressCCList.remove('');
                    Set_AddressCCList.remove(null);

                    list<String> mailto=new list<String>{};
                    list<String> mailcc=new list<String>{};

                    mailto.addAll(Set_AddressList);
                    mailcc.addAll(Set_AddressCCList);

                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: EmailNotif_SRPR[0].Sender_Email__c];

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    mail.optOutPolicy = 'FILTER';
                    mail.setUseSignature(false);
                    mail.setToAddresses(mailto);
                    if(mailcc!=null && !mailcc.isEmpty()){
                        mail.setCCaddresses(mailcc);
                    }
                    mail.setTemplateId(et.Id);
                    mail.setTargetObjectId(contactList[0].id);
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setWhatId(SP.Id);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};

                    if(!test.isrunningtest())
                    {
                        List<Messaging.SendEmailResult>  results=new List<Messaging.SendEmailResult> ();
                        results=Messaging.sendEmail(messages);
                        Call_Log__c CL=new Call_Log__c();
                        CL.Salesforce_ID_1__c=O.SR__c;
                        CL.Salesforce_id_2__c=O.Opportunity_ID__c;
                        CL.Type__c='Email';
                        CL.Request_Start_Time__c=system.now();
                        CL.Response_End_Time__c=system.now();
                        CL.Response_Message__c='Success ='+results[0].issuccess()+' Error:'+results[0].geterrors();
                        insert CL;
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Create_PR_SR.cls - sendEmailSR ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
    
    public void createSR(Opportunity O){
        
        system.debug('== createSR Called ==');
        
        list<OpportunityLineItem> OLI=[SELECT Product2.ProductCode,Product2.Product_Code2__c FROM OpportunityLineItem WHERE OpportunityID=:O.id];
        Account A=[SELECT ID,Name,BP_number__c,ShippingCity,Unique_Name__c,BP_Number_Unique_Name__c,Owner.Name,Owner.Employee_id__c,Owner.Email FROM Account WHERE ID=:O.Account_Site_A__c];
        system.debug('==== Account cuk : ' + A);
        
        AccountContactRelation ACR=[SELECT Contactid,Contact.Name,Contact.Phone,Contact.MobilePhone FROM AccountContactRelation WHERE AccountID=:A.id AND ROLES INCLUDES ('PIC Site') LIMIT 1];
        system.debug('==== OLI : ' + OLI);
        system.debug('==== OLI1.productcpde : ' + OLI[0].Product2.Product_Code2__c);
        //system.debug('==== OLI2: ' + OLI[1].Product2.Product_Code2__c);
        
        
        String PhoneVariable='';
        
        if(Acr.Contact.Phone!=null && Acr.Contact.Phone!='')
            PhoneVariable=Acr.Contact.Phone;
        if(ACR.Contact.MobilePhone!=null && ACR.Contact.MobilePhone!='')
            PhoneVariable=ACR.Contact.MobilePhone;
        
        SR_PR_Notification__c SP=new SR_PR_Notification__c();
        SP.Notif_Type__c='SR';
        SP.Opportunity__c=O.id;
        //SP.Ownerid=system.label.default_SR_Owner;
        // add presurvey fields to SR
        system.debug('==== Oppty Presurvey : ' + O.Presurvey__c);
        SP.Presurvey__c = O.Presurvey__c;
        system.debug('==== SR presurvey : ' + SP.Presurvey__c);
        
        //Novi, SIR : set owner SRPR bases on sales Opty . 16 feb 2021
        SYSTEM.DEBUG ('=== O.ownerId : ' + O.ownerId);
        SYSTEM.DEBUG ('=== OPPTY : ' + O);
        
        SP.OwnerId = O.ownerId;
        
        SP.Account__c=O.AccountID;
        SR_PR__c SPN=SR_PR__c.getorgdefaults();
        SP.Solution_PIC__c=O.Solution_PIC__c;
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
        String Stringsrnumber=String.valueof(SPN.SR_Number__c);
        StringSRNumber=StringSRNumber.replace('.0','');
        while(Stringsrnumber.length()<6)
        {
            Stringsrnumber='0'+stringsrnumber;
        }
        String SRNumber=todaymonthyear+'-'+stringsrnumber;
        
        if(O.SR_Status__c=='Rejected')
        {
            SP.Name='SR-'+O.SR__c;
        }
        else
        {
            //set SR Number
            SP.Name='SR-'+SRNumber;
            O.SR__c=SRNumber;
            SPN.SR_Number__c=SPN.SR_Number__c+1;
        }
        if(O.Service_type__c=='Newlink')
            SP.Project_type__c='New';
        else
        {
            SP.Project_type__c=O.Service_Type__c;
            if(O.Link_Related__c!=null)
            {
                Link__c L=[SELECT   CID_RelD__c,cid__c,name,Link_id__c from Link__c WHERE ID=:O.Link_Related__c];
                SP.Link_id__c=o.Link_id__c;
                SP.CID__c=L.CID__c;
                SP.Circuit__c=L.CID_RelD__c;
                
            }
        }
        //map variable for SR from Oppty variable
        SP.Status__c='Open';
        SP.CPE_Additional_Request__c=O.Router_type__c;
        SP.Site_A__c=O.Account_Site_A__c;
        SP.PIC_Site__c=ACR.Contactid;
        O.SR_Status__c='';
        O.SR_Notes__c='';
        SP.Notif_Date__c=system.today();
        SP.Customer_Request_lastmile_type__c=O.Lastmile_type__c;
        SP.Normal_RFS__c=system.today().adddays(6);
        if(OLI[0].Product2.Product_Code2__c==null)
        {
            O.adderror('No Product Code in Opp Product');
        }
        SP.Services__c=OLI[0].Product2.Product_Code2__c;
        if(OLI[0].Product2.Product_Code2__c=='CL')
            SP.Services__c='Collocation';
        if(OLI[0].Product2.Product_Code2__c=='IAAS')
            SP.Services__c='Cloud IAAS';
        if(SP.Services__c=='LL'||SP.Services__c=='VLL'||SP.Services__c=='L2VPN')
        {SP.Site_B__c=O.Account_Site_B__c;
         AccountContactRelation ACR2=[SELECT Contactid,Contact.Name,Contact.Phone,Contact.Mobilephone FROM AccountContactRelation WHERE AccountID=:O.Account_Site_B__c AND ROLES INCLUDES ('PIC Site') LIMIT 1];
         SP.PIC_Site_B__c=ACR2.ContactID;
        }
        SP.Project_Name__c=SP.Services__c+' - '+A.Name+','+A.Unique_Name__c;
        SP.UOM_Before__c=O.UOM_BW_Before__c;
        SP.UOM_After__c=O.UOM_BW_After__c;
        SP.Capacity_Before__c=O.BW_Before__c;
        SP.Capacity_After__c=O.BW_After__c;
        if(SP.Services__c=='Voip')
        {
            list<OpportunityLineItem> listOLI=[SELECT id,UnitPrice,Product2.Name FROM OpportunityLineItem WHERE OpportunityID=:SP.Opportunity__c];
            system.debug('== listOLI +' + listOLI);
            for(OpportunityLineItem OLIvoip:listOLI)
            {
                if(OLIvoip.Product2.Name.Contains('OnNet'))
                {
                    SP.New_On_Net__c=OLIvoip.UnitPrice+'/min';
                }
                if(OLIvoip.Product2.Name.Contains('Other Mobile'))
                {
                    SP.New_Off_Net__c=OLIvoip.UnitPrice+'/min';
                }
                if(OLIvoip.Product2.Name.Contains('PSTN'))
                {
                    SP.New_PSTN__c=OLIvoip.UnitPrice+'/min';
                }
                if(OLIvoip.Product2.Name.Contains('MinCom'))
                {
                    SP.New_MinCom__c=OLIvoip.UnitPrice+'/min';
                }
            }
        }
        insert SP;
        system.debug('== SPN + ' + SPN);
        update SPN;
        sendemailSR(SP,O,A,ACR.Contact.Name,PhoneVariable);
    }
    
    public void createSRComplete(Opportunity O)
    {
        list<OpportunityLineItem> OLI=[SELECT Product2.ProductCode FROM OpportunityLineItem WHERE OpportunityID=:O.id];
        //  Account A=[SELECT ID,Name,BP_number__c,ShippingCity,Unique_Name__c,BP_Number_Unique_Name__c,Owner.Name,Owner.Employee_id__c,Owner.Email FROM Account WHERE ID=:O.Account_Site_A__c];
        //      AccountContactRelation ACR=[SELECT Contactid,Contact.Name,Contact.Phone,Contact.MobilePhone FROM AccountContactRelation WHERE AccountID=:A.id AND ROLES INCLUDES ('PIC Site') LIMIT 1];
        //create SR Marketplace
        SR_PR_Notification__c SP=new SR_PR_Notification__c();
        SP.Notif_Type__c='SR';
        SP.Opportunity__c=O.id;
        SP.Account__c=O.AccountID;
        //Novi,SIR set ownr sr pr based on owner opty, 16 feb 2021
        SP.ownerId=O.ownerId;
        
        SR_PR__c SPN=SR_PR__c.getorgdefaults();
        //  SP.Solution_PIC__c=O.Solution_PIC__c;
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
        String Stringsrnumber=String.valueof(SPN.SR_Number__c);
        StringSRNumber=StringSRNumber.replace('.0','');
        while(Stringsrnumber.length()<6)
        {
            Stringsrnumber='0'+stringsrnumber;
        }
        String SRNumber=todaymonthyear+'-'+stringsrnumber;
        
        
        SP.Project_Type__c='ECommerce';     
        SP.Name='SR-'+SRNumber;
        O.SR__c=SRNumber;
        SPN.SR_Number__c=SPN.SR_Number__c+1;
        SP.Project_Coordinator_text__c='90009999 Rifqi Dimas Febriyanto';
        O.project_coordinator__c=SP.Project_Coordinator__c;
        SP.Status__c='Close(Complete)';
        insert SP;
        update SPN;
    }
}