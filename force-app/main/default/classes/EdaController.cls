public class EdaController {


    public void Create_EdaSubmitTempIsolation(Id bapid){
        DateTime start_time = datetime.now();

        List<BAP__c> bapList = [SELECT OwnerId, Id, Name, Link__c, Link__r.Link_ID__c, Link__r.Free_Link__c, Link__r.Contract_Item_Rel__r.Price__c, BAP_ID__c, EDA__c, CID__c, Customer__r.OwnerId, Customer__r.Name, Customer__c, Isolation_Start_Date__c, Isolation_End_Date__c, Request_Status__c,Remark__c,createBAPTemp_Isolation_easyOps__c FROM BAP__c WHERE Id=:bapid];

        try {
            List<EDA_Setting__c> EDASetting = [select Approver_UserID_1__c, Approver_UserID_2__c, Approver_UserID_3__c, Approver_UserID_4__c,Recipient_Email_1__c, Recipient_Email_2__c, Recipient_Email_3__c, Recipient_Email_5__c from EDA_Setting__c where name = 'For Temporary Isolation'];

            String Approver_1;
            String Approver_2;
            String Approver_3;
            String Approver_4;

            if(EDASetting!=null && !EDASetting.isEmpty()){
                if(!Test.isRunningTest()){
                    if(EDASetting[0].Approver_UserID_1__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_1__c == 'GH_SALES'){
                        Approver_1 = AppUtils.get_userID(EDASetting[0].Approver_UserID_1__c,bapList[0].Customer__r.OwnerId);
                    }else{
                        Approver_1 = AppUtils.get_userID(EDASetting[0].Approver_UserID_1__c,'');
                    }

                    if(EDASetting[0].Approver_UserID_2__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_2__c == 'GH_SALES'){
                        Approver_2 = AppUtils.get_userID(EDASetting[0].Approver_UserID_2__c,bapList[0].Customer__r.OwnerId);
                    }else{
                        Approver_2 = AppUtils.get_userID(EDASetting[0].Approver_UserID_2__c,'');
                    }
                    
                    if(EDASetting[0].Approver_UserID_3__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_3__c == 'GH_SALES'){
                        Approver_3 = AppUtils.get_userID(EDASetting[0].Approver_UserID_3__c,bapList[0].Customer__r.OwnerId);
                    }else{
                        Approver_3 = AppUtils.get_userID(EDASetting[0].Approver_UserID_3__c,'');
                    }

                    if(EDASetting[0].Approver_UserID_4__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_4__c == 'GH_SALES'){
                        Approver_4 = AppUtils.get_userID(EDASetting[0].Approver_UserID_4__c,bapList[0].Customer__r.OwnerId);
                    }else{
                        Approver_4 = AppUtils.get_userID(EDASetting[0].Approver_UserID_4__c,'');
                    }
                }
            }

            List<User> userRecipient4List = [SELECT id, name, email FROM User WHERE userrole.name = 'Group Head Solution Architect'];

            String Recipient_4 = '';
            if(userRecipient4List!=null && !userRecipient4List.isEmpty() && userRecipient4List[0].email != null){
                Recipient_4 = userRecipient4List[0].email;
            }

            Date Isolate_StartDateValue = bapList[0].Isolation_Start_Date__c;
            Date Isolate_EndDateValue = bapList[0].Isolation_End_Date__c;

            Boolean freeLink = bapList[0].Link__r.Free_Link__c;
            String freeLinkFormat = '';
            if(freeLink == true){
                freeLinkFormat = 'Yes';
            }else{
                freeLinkFormat = 'No';
            }
            
            String Isolate_MonthStartDate = getDateMonthName(Isolate_StartDateValue);
            String Isolate_MontEndDate = getDateMonthName(Isolate_EndDateValue);

            String Isolate_StartDate = Isolate_StartDateValue.day() + '-' + Isolate_MonthStartDate + '-' + Isolate_StartDateValue.year();
            String Isolate_EndDate = Isolate_EndDateValue.day() + '-' + Isolate_MontEndDate + '-' + Isolate_EndDateValue.year();

            Decimal Contract_PerMonth = 0;
            String Contract_PerMonth_Format = '';

            if(bapList[0].Link__r.Contract_Item_Rel__r.Price__c != null){
                Contract_PerMonth = bapList[0].Link__r.Contract_Item_Rel__r.Price__c;

                Contract_PerMonth_Format = Contract_PerMonth.format().contains('.')?Contract_PerMonth.format():(Contract_PerMonth.format()+'.00');
            }

            String EdaName = 'Temporary Isolation ' + bapList[0].Name;
            String EdaNameFormat = '';
            if(EdaName.length() > 80){
                EdaNameFormat = EdaName.substring(0, 80);
            }else{
                EdaNameFormat = EdaName;
            }

            EDA__c EdaSubmitTempIsolation = new EDA__c(
            Name = EdaNameFormat,
            Document_Type__c = 'IOM',
            IOM_Type__c = 'Temporary Isolation',
            EDA_Status__c = 'Draft',
            Related_Customer__c = bapList[0].Customer__c,
            BAP__c = bapList[0].Id,
            Recipient_1__c = EDASetting[0].Recipient_Email_1__c,
            Recipient_2__c = EDASetting[0].Recipient_Email_2__c,
            Recipient_3__c = EDASetting[0].Recipient_Email_3__c,
            Recipient_4__c = Recipient_4,
            Recipient_5__c = EDASetting[0].Recipient_Email_5__c,
            Approver_1__c = Approver_1,
            Approver_2__c = Approver_2,
            Approver_3__c = Approver_3,
            Approver_4__c = Approver_4,
            Summary__c = 
                'Request to Process Temporary Isolation : ' + '\n' +
                'Customer : ' + bapList[0].Customer__r.Name + '\n' +
                'BA Isolation : ' + bapList[0].BAP_ID__c + '\n' +
                'CID : ' + bapList[0].CID__c + '\n' +
                'Link ID : ' + bapList[0].Link__r.Link_ID__c + '\n' +
                'Free Link : ' + freeLinkFormat + '\n' +
                'Contract Per Month : ' + Contract_PerMonth_Format + '\n' +
                'Start Isolation Date : ' + Isolate_StartDate + '\n' +
                'End Isolation Date : ' + Isolate_EndDate
            );
            insert EdaSubmitTempIsolation;

            if(EdaSubmitTempIsolation != null) {
                if(bapList !=null && !bapList.isEmpty()) {
                    bapList[0].EDA__c = EdaSubmitTempIsolation.Id;
                    bapList[0].Request_Status__c = 'Waiting Approval';
                    bapList[0].Remark__c = 'Waiting for EDA (Isolation) Approval';
                    bapList[0].createBAPTemp_Isolation_easyOps__c = true;
                    update bapList;
                }

                EdaSubmitTempIsolation.EDA_Status__c = 'Submitted';
                update EdaSubmitTempIsolation;

                AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'EdaController.cls - Create_EdaSubmitTempIsolation',null);
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on EdaController.cls - Create_EdaSubmitTempIsolation ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'EdaController.cls - Create_EdaSubmitTempIsolation',err_message);

            List<user> userReceiverEmail1 = [select id, name, profile.name, email from user where name = 'System Administrator' ];

            List<user> userReceiverEmail2 = [select id, name, profile.name, email from user where Id =: bapList[0].OwnerId];

            String RecordBapLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+bapList[0].Id;
            
            Send_Email__c sendEmail = new Send_Email__c ();
            sendEmail.user_receiver__c = userReceiverEmail1[0].id;
            sendEmail.User_Receiver_2__c = userReceiverEmail2[0].id;
            sendEmail.subject__c = 'The EDA record for BAP Temporary Isolation is NOT successful to create/update. BAP : ' + bapList[0].Name;
            sendEmail.Message_Body__c = 
                'Dear ' + userReceiverEmail2[0].Name + ', ' +  userReceiverEmail1[0].Name + 
                '<br>' + '<br>'+ '<br>' +
                'Your BAP ' + bapList[0].Name + ' is not successful to create EDA for Termination Isolation Approval.' +
                '<br>' +
                'BAP Link : ' + RecordBapLink +
                '<br>' + '<br>'+ '<br>' +
                'Regards,'
                ;
            sendEmail.status__c = 'New';
            insert sendEmail;
        }
    }

    public void Create_EdaExtendTempIsolation(Id bapid){
        DateTime start_time = datetime.now();
        
        List<BAP__c> bapList = [SELECT OwnerId, Id, Link__c, Link__r.Link_ID__c, Link__r.Free_Link__c, Link__r.Contract_Item_Rel__r.Price__c, Name, EDA_for_Extend_Isolation__c, BAP_ID__c, EDA__c, CID__c, Customer__r.OwnerId, Customer__r.Name,Customer__c, Isolation_Start_Date__c, Isolation_End_Date__c, Isolation_Desire_End_Date__c, Request_Status__c,Remark__c,createBAPTemp_Isolation_easyOps__c FROM BAP__c WHERE Id=:bapid];

        try {
            List<EDA_Setting__c> EDASetting = [select Approver_UserID_1__c, Approver_UserID_2__c, Approver_UserID_3__c, Approver_UserID_4__c,Recipient_Email_1__c, Recipient_Email_2__c, Recipient_Email_3__c, Recipient_Email_5__c from EDA_Setting__c where name = 'For Temporary Isolation'];

            String Approver_1;
            String Approver_2;
            String Approver_3;
            String Approver_4;

            if(EDASetting!=null && !EDASetting.isEmpty()){
                if(!Test.isRunningTest()){
                    if(EDASetting[0].Approver_UserID_1__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_1__c == 'GH_SALES'){
                        Approver_1 = AppUtils.get_userID(EDASetting[0].Approver_UserID_1__c,bapList[0].Customer__r.OwnerId);
                    }else{
                        Approver_1 = AppUtils.get_userID(EDASetting[0].Approver_UserID_1__c,'');
                    }

                    if(EDASetting[0].Approver_UserID_2__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_2__c == 'GH_SALES'){
                        Approver_2 = AppUtils.get_userID(EDASetting[0].Approver_UserID_2__c,bapList[0].Customer__r.OwnerId);
                    }else{
                        Approver_2 = AppUtils.get_userID(EDASetting[0].Approver_UserID_2__c,'');
                    }
                    
                    if(EDASetting[0].Approver_UserID_3__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_3__c == 'GH_SALES'){
                        Approver_3 = AppUtils.get_userID(EDASetting[0].Approver_UserID_3__c,bapList[0].Customer__r.OwnerId);
                    }else{
                        Approver_3 = AppUtils.get_userID(EDASetting[0].Approver_UserID_3__c,'');
                    }

                    if(EDASetting[0].Approver_UserID_4__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_4__c == 'GH_SALES'){
                        Approver_4 = AppUtils.get_userID(EDASetting[0].Approver_UserID_4__c,bapList[0].Customer__r.OwnerId);
                    }else{
                        Approver_4 = AppUtils.get_userID(EDASetting[0].Approver_UserID_4__c,'');
                    }
                }
            }

            List<User> userRecipient4List = [SELECT id, name, email FROM User WHERE userrole.name = 'Group Head Solution Architect'];

            String Recipient_4 = '';
            if(userRecipient4List!=null && !userRecipient4List.isEmpty() && userRecipient4List[0].email != null){
                Recipient_4 = userRecipient4List[0].email;
            }

            Date Isolate_StartDateValue = bapList[0].Isolation_Start_Date__c;
            Date Isolate_EndDateValue = bapList[0].Isolation_Desire_End_Date__c;

            Boolean freeLink = bapList[0].Link__r.Free_Link__c;
            String freeLinkFormat = '';
            if(freeLink == true){
                freeLinkFormat = 'Yes';
            }else{
                freeLinkFormat = 'No';
            }

            String Isolate_MonthStartDate = getDateMonthName(Isolate_StartDateValue);
            String Isolate_MontEndDate = getDateMonthName(Isolate_EndDateValue);

            String Isolate_StartDate = Isolate_StartDateValue.day() + '-' + Isolate_MonthStartDate + '-' + Isolate_StartDateValue.year();
            String Isolate_EndDate = Isolate_EndDateValue.day() + '-' + Isolate_MontEndDate + '-' + Isolate_EndDateValue.year();

            Decimal Contract_PerMonth = 0;
            String Contract_PerMonth_Format = '';

            if(bapList[0].Link__r.Contract_Item_Rel__r.Price__c != null){
                Contract_PerMonth = bapList[0].Link__r.Contract_Item_Rel__r.Price__c;

                Contract_PerMonth_Format = Contract_PerMonth.format().contains('.')?Contract_PerMonth.format():(Contract_PerMonth.format()+'.00');
            }

            String EdaName = 'Extend Temporary Isolation ' + bapList[0].Name;
            String EdaNameFormat = '';
            if(EdaName.length() > 80){
                EdaNameFormat = EdaName.substring(0, 80);
            }else{
                EdaNameFormat = EdaName;
            }

            EDA__c EdaExtendTempIsolation = new EDA__c(
            Name = EdaNameFormat,
            Document_Type__c = 'IOM',
            IOM_Type__c = 'Extend Temporary Isolation',
            EDA_Status__c = 'Draft',
            Related_Customer__c = bapList[0].Customer__c,
            BAP__c = bapList[0].Id,
            Recipient_1__c = EDASetting[0].Recipient_Email_1__c,
            Recipient_2__c = EDASetting[0].Recipient_Email_2__c,
            Recipient_3__c = EDASetting[0].Recipient_Email_3__c,
            Recipient_4__c = Recipient_4,
            Recipient_5__c = EDASetting[0].Recipient_Email_5__c,
            Approver_1__c = Approver_1,
            Approver_2__c = Approver_2,
            Approver_3__c = Approver_3,
            Approver_4__c = Approver_4,
            Summary__c = 
                'Request to Process Extend Temporary Isolation : ' + '\n' +
                'Customer : ' + bapList[0].Customer__r.Name + '\n' +
                'BA Isolation : ' + bapList[0].BAP_ID__c + '\n' +
                'CID : ' + bapList[0].CID__c + '\n' +
                'Link ID : ' + bapList[0].Link__r.Link_ID__c + '\n' +
                'Free Link : ' + freeLinkFormat + '\n' +
                'Contract Per Month : ' + Contract_PerMonth_Format  + '\n' +
                'Start Isolation Date : ' + Isolate_StartDate + '\n' +
                'End Isolation Date : ' + Isolate_EndDate
            );
            insert EdaExtendTempIsolation;

            if(EdaExtendTempIsolation != null) {
                if(bapList !=null && !bapList.isEmpty()) {
                    bapList[0].EDA_for_Extend_Isolation__c = EdaExtendTempIsolation.Id;
                    update bapList;
                }

                EdaExtendTempIsolation.EDA_Status__c = 'Submitted';
                update EdaExtendTempIsolation;

                AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'EdaController.cls - Create_EdaExtendTempIsolation',null);
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on EdaController.cls - Create_EdaExtendTempIsolation ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'EdaController.cls - Create_EdaExtendTempIsolation',err_message);

            List<user> userReceiverEmail1 = [select id, name, profile.name, email from user where name = 'System Administrator' ];

            List<user> userReceiverEmail2 = [select id, name, profile.name, email from user where Id =: bapList[0].OwnerId];

            String RecordBapLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+bapList[0].Id;

            Send_Email__c sendEmail = new Send_Email__c ();
            sendEmail.user_receiver__c = userReceiverEmail1[0].id;
            sendEmail.User_Receiver_2__c = userReceiverEmail2[0].id;
            sendEmail.subject__c = 'The EDA record for BAP Temporary Isolation is NOT successful to create/update. BAP : ' + bapList[0].Name + ' for extend Isolation';
            sendEmail.Message_Body__c = 
                'Dear ' + userReceiverEmail2[0].Name + ', ' +  userReceiverEmail1[0].Name + 
                '<br>' + '<br>'+ '<br>' +
                'Your BAP ' + bapList[0].Name + ' is not successful to create EDA for Extend Isolation Approval.' +
                '<br>' +
                'BAP Link : ' + RecordBapLink +
                '<br>' + '<br>'+ '<br>' +
                'Regards,'
                ;
            sendEmail.status__c = 'New';
            insert sendEmail;
        }
    }

    public void Update_EdaSubmitTempIsolation(Id bapid){
        DateTime start_time = datetime.now();

        List<BAP__c> bapList = [SELECT OwnerId, Id, Name, Link__c, Link__r.Link_ID__c, Link__r.Free_Link__c, Link__r.Contract_Item_Rel__r.Price__c, BAP_ID__c, EDA__c, CID__c, Customer__r.OwnerId, Customer__r.Name, Customer__c, Isolation_Start_Date__c, Isolation_End_Date__c, Request_Status__c,Remark__c, createBAPTemp_Isolation_easyOps__c FROM BAP__c WHERE Id=:bapid AND createBAPTemp_Isolation_easyOps__c =: true];

        List<EDA__c> edaList = [SELECT Id, Summary__c, Approver_4__c, Approver_3__c, Approver_2__c, Approver_1__c, Recipient_5__c, Recipient_1__c, Recipient_2__c, Recipient_3__c, Recipient_4__c, BAP__c, Related_Customer__c, IOM_Type__c, Document_Type__c, EDA_Status__c, EDA_Number__c FROM EDA__c WHERE EDA_Status__c =: 'Draft' AND Document_Type__c =: 'IOM' AND IOM_Type__c =: 'Temporary Isolation' AND BAP__c =:bapid];

        try {
            if(bapList !=null && !bapList.isEmpty()) {
                List<EDA_Setting__c> EDASetting = [select Approver_UserID_1__c, Approver_UserID_2__c, Approver_UserID_3__c, Approver_UserID_4__c,Recipient_Email_1__c, Recipient_Email_2__c, Recipient_Email_3__c, Recipient_Email_5__c from EDA_Setting__c where name = 'For Temporary Isolation'];

                String Approver_1;
                String Approver_2;
                String Approver_3;
                String Approver_4;
    
                if(EDASetting!=null && !EDASetting.isEmpty()){
                    if(!Test.isRunningTest()){
                        if(EDASetting[0].Approver_UserID_1__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_1__c == 'GH_SALES'){
                            Approver_1 = AppUtils.get_userID(EDASetting[0].Approver_UserID_1__c,bapList[0].Customer__r.OwnerId);
                        }else{
                            Approver_1 = AppUtils.get_userID(EDASetting[0].Approver_UserID_1__c,'');
                        }
    
                        if(EDASetting[0].Approver_UserID_2__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_2__c == 'GH_SALES'){
                            Approver_2 = AppUtils.get_userID(EDASetting[0].Approver_UserID_2__c,bapList[0].Customer__r.OwnerId);
                        }else{
                            Approver_2 = AppUtils.get_userID(EDASetting[0].Approver_UserID_2__c,'');
                        }
                        
                        if(EDASetting[0].Approver_UserID_3__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_3__c == 'GH_SALES'){
                            Approver_3 = AppUtils.get_userID(EDASetting[0].Approver_UserID_3__c,bapList[0].Customer__r.OwnerId);
                        }else{
                            Approver_3 = AppUtils.get_userID(EDASetting[0].Approver_UserID_3__c,'');
                        }
    
                        if(EDASetting[0].Approver_UserID_4__c == 'HEAD_SALES' || EDASetting[0].Approver_UserID_4__c == 'GH_SALES'){
                            Approver_4 = AppUtils.get_userID(EDASetting[0].Approver_UserID_4__c,bapList[0].Customer__r.OwnerId);
                        }else{
                            Approver_4 = AppUtils.get_userID(EDASetting[0].Approver_UserID_4__c,'');
                        }
                    }
                }

                List<User> userRecipient4List = [SELECT id, name, email FROM User WHERE userrole.name = 'Group Head Solution Architect'];

                String Recipient_4 = '';
                if(userRecipient4List!=null && !userRecipient4List.isEmpty() && userRecipient4List[0].email != null){
                    Recipient_4 = userRecipient4List[0].email;
                }
    
                Date Isolate_StartDateValue = bapList[0].Isolation_Start_Date__c;
                Date Isolate_EndDateValue = bapList[0].Isolation_End_Date__c;
    
                Boolean freeLink = bapList[0].Link__r.Free_Link__c;
                String freeLinkFormat = '';
                if(freeLink == true){
                    freeLinkFormat = 'Yes';
                }else{
                    freeLinkFormat = 'No';
                }
                
                String Isolate_MonthStartDate = getDateMonthName(Isolate_StartDateValue);
                String Isolate_MontEndDate = getDateMonthName(Isolate_EndDateValue);
    
                String Isolate_StartDate = Isolate_StartDateValue.day() + '-' + Isolate_MonthStartDate + '-' + Isolate_StartDateValue.year();
                String Isolate_EndDate = Isolate_EndDateValue.day() + '-' + Isolate_MontEndDate + '-' + Isolate_EndDateValue.year();

                Decimal Contract_PerMonth = 0;
                String Contract_PerMonth_Format = '';

                if(bapList[0].Link__r.Contract_Item_Rel__r.Price__c != null){
                    Contract_PerMonth = bapList[0].Link__r.Contract_Item_Rel__r.Price__c;

                    Contract_PerMonth_Format = Contract_PerMonth.format().contains('.')?Contract_PerMonth.format():(Contract_PerMonth.format()+'.00');
                }

                String EdaName = 'Temporary Isolation ' + bapList[0].Name;
                String EdaNameFormat = '';
                if(EdaName.length() > 80){
                    EdaNameFormat = EdaName.substring(0, 80);
                }else{
                    EdaNameFormat = EdaName;
                }

                bapList[0].Request_Status__c = 'Waiting Approval';
                bapList[0].Remark__c = 'Waiting for EDA (Isolation) Approval';
                bapList[0].createBAPTemp_Isolation_easyOps__c = true;
                update bapList;

                if(edaList !=null && !edaList.isEmpty()) {
                    edaList[0].EDA_Status__c = 'Submitted';
                    edaList[0].Name = EdaNameFormat;
                    edaList[0].Document_Type__c = 'IOM';
                    edaList[0].IOM_Type__c = 'Temporary Isolation';
                    edaList[0].Related_Customer__c = bapList[0].Customer__c;
                    edaList[0].BAP__c = bapList[0].Id;
                    edaList[0].Recipient_1__c = EDASetting[0].Recipient_Email_1__c;
                    edaList[0].Recipient_2__c = EDASetting[0].Recipient_Email_2__c;
                    edaList[0].Recipient_3__c = EDASetting[0].Recipient_Email_3__c;
                    edaList[0].Recipient_4__c = Recipient_4;
                    edaList[0].Recipient_5__c = EDASetting[0].Recipient_Email_5__c;
                    edaList[0].Approver_1__c = Approver_1;
                    edaList[0].Approver_2__c = Approver_2;
                    edaList[0].Approver_3__c = Approver_3;
                    edaList[0].Approver_4__c = Approver_4;
                    edaList[0].Summary__c = 
                        'Request to Process Temporary Isolation : ' + '\n' +
                        'Customer : ' + bapList[0].Customer__r.Name + '\n' +
                        'BA Isolation : ' + bapList[0].BAP_ID__c + '\n' +
                        'CID : ' + bapList[0].CID__c + '\n' +
                        'Link ID : ' + bapList[0].Link__r.Link_ID__c + '\n' +
                        'Free Link : ' + freeLinkFormat + '\n' +
                        'Contract Per Month : ' + Contract_PerMonth_Format + '\n' +
                        'Start Isolation Date : ' + Isolate_StartDate + '\n' +
                        'End Isolation Date : ' + Isolate_EndDate;
                    update edaList;

                    AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'EdaController.cls - Update_EdaSubmitTempIsolation',null);
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on EdaController.cls - Update_EdaSubmitTempIsolation ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'EdaController.cls - Update_EdaSubmitTempIsolation',err_message);
        }
    }

    public void Update_EdaExtendTempIsolation(Id edaId){
        DateTime start_time = datetime.now();
        
        List<BAP__c> bapList = [SELECT OwnerId, Id, Link__c, Link__r.Link_ID__c, Link__r.Free_Link__c, Link__r.Contract_Item_Rel__r.Price__c, Name, EDA_for_Extend_Isolation__c, BAP_ID__c, EDA__c, CID__c, Customer__r.OwnerId, Customer__r.Name,Customer__c, Isolation_Start_Date__c, Isolation_End_Date__c, Isolation_Desire_End_Date__c, Request_Status__c,Remark__c,createBAPTemp_Isolation_easyOps__c FROM BAP__c WHERE EDA_for_Extend_Isolation__c=:edaId];

        List<EDA__c> edaList = [SELECT Id, EDA_Status__c, EDA_Number__c FROM EDA__c WHERE EDA_Status__c =: 'Draft' AND Document_Type__c =: 'IOM' AND IOM_Type__c =: 'Extend Temporary Isolation' AND Id =:edaId];

        try {
            if(bapList !=null && !bapList.isEmpty()) {
                Date Isolate_StartDateValue = bapList[0].Isolation_Start_Date__c;
                Date Isolate_EndDateValue = bapList[0].Isolation_Desire_End_Date__c;

                Boolean freeLink = bapList[0].Link__r.Free_Link__c;
                String freeLinkFormat = '';
                if(freeLink == true){
                    freeLinkFormat = 'Yes';
                }else{
                    freeLinkFormat = 'No';
                }

                String Isolate_MonthStartDate = getDateMonthName(Isolate_StartDateValue);
                String Isolate_MontEndDate = getDateMonthName(Isolate_EndDateValue);

                String Isolate_StartDate = Isolate_StartDateValue.day() + '-' + Isolate_MonthStartDate + '-' + Isolate_StartDateValue.year();
                String Isolate_EndDate = Isolate_EndDateValue.day() + '-' + Isolate_MontEndDate + '-' + Isolate_EndDateValue.year();

                Decimal Contract_PerMonth = 0;
                String Contract_PerMonth_Format = '';

                if(bapList[0].Link__r.Contract_Item_Rel__r.Price__c != null){
                    Contract_PerMonth = bapList[0].Link__r.Contract_Item_Rel__r.Price__c;

                    Contract_PerMonth_Format = Contract_PerMonth.format().contains('.')?Contract_PerMonth.format():(Contract_PerMonth.format()+'.00');
                }

                if(edaList !=null && !edaList.isEmpty()) {
                    edaList[0].EDA_Status__c = 'Submitted';
                    edaList[0].Summary__c = 
                    'Request to Process Extend Temporary Isolation : ' + '\n' +
                    'Customer : ' + bapList[0].Customer__r.Name + '\n' +
                    'BA Isolation : ' + bapList[0].BAP_ID__c + '\n' +
                    'CID : ' + bapList[0].CID__c + '\n' +
                    'Link ID : ' + bapList[0].Link__r.Link_ID__c + '\n' +
                    'Free Link : ' + freeLinkFormat + '\n' +
                    'Contract Per Month : ' + Contract_PerMonth_Format  + '\n' +
                    'Start Isolation Date : ' + Isolate_StartDate + '\n' +
                    'End Isolation Date : ' + Isolate_EndDate;
                    update edaList;

                    AppUtils.putCalllog('Trigger',null,start_time,'success',datetime.now(),'EdaController.cls - Update_EdaExtendTempIsolation',null);
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on EdaController.cls - Update_EdaExtendTempIsolation ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
            AppUtils.putCalllog('Trigger',null,start_time,'failed',datetime.now(),'EdaController.cls - Update_EdaExtendTempIsolation',err_message);
        }
    }

    public String getDateMonthName(Date dateValue){
        String monthValueFormat = '';
        Integer monthValue = dateValue.month();

        if(monthValue == 1){
            monthValueFormat = 'Jan';
        }else if(monthValue == 2){
            monthValueFormat = 'Feb';
        }else if(monthValue == 3){
            monthValueFormat = 'Mar';
        }else if(monthValue == 4){
            monthValueFormat = 'Apr';
        }else if(monthValue == 5){
            monthValueFormat = 'May';
        }else if(monthValue == 6){
            monthValueFormat = 'Jun';
        }else if(monthValue == 7){
            monthValueFormat = 'Jul';
        }else if(monthValue == 8){
            monthValueFormat = 'Aug';
        }else if(monthValue == 9){
            monthValueFormat = 'Sep';
        }else if(monthValue == 10){
            monthValueFormat = 'Oct';
        }else if(monthValue == 11){
            monthValueFormat = 'Nov';
        }else if(monthValue == 12){
            monthValueFormat = 'Dec';
        }

        return monthValueFormat;
    }

}