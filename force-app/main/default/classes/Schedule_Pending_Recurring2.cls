global class Schedule_Pending_Recurring2  implements Schedulable{
    global void execute(SchedulableContext sc){
        list<Pending_Recurring__c> listPR=[SELECT Account_Manager__c,AM_Sales__c,PIC__c,AM_Manager__c FROM Pending_Recurring__c 
                                            WHERE Status__c='Send To Sales'
                                                AND (
                                                    VR_Close_Reasons_Validation_IS_ERROR__c = false AND
                                                    VR_ORM_Update_IS_ERROR__c = false AND
                                                    VR_Sales_Update_IS_ERROR__c = false AND
                                                    VR_VOIP_Validation_IS_ERROR__c = false
                                                )
                                            ] ;

        list<UserRole> Role1=[SELECT ID,NAME FROM UserRole WHERE ParentRoleID=:system.label.Group_Head_Key_Account_Management_ID];
        list<UserRole> Role2=[SELECT ID,Name FROM UserRole WHERE ParentRoleID=:system.label.Group_Head_SME_ID];
        list<User> listU=[SELECT name,Email,UserRole.Name FROM User 
                                WHERE UserRole.Name IN ('CEO Enterprise and SME',
                                        'Group Head - Key Account Management',
                                        'Group Head - SME','Group Head - Operations',
                                        'Planning & Performance Management',
                                        'Head - Operations Management') 
                                        and profile.name <> 'System Administrator'
                                                ];

        String[] UserRole1=new String[]{};
        String[] UserRole2=new String[]{};

        SYSTEM.DEBUG ('============= listPR : ' + listPR);
        SYSTEM.DEBUG ('============= listPR.size() : ' + listPR.size());
        SYSTEM.DEBUG ('============= Role1 : ' + Role1);
        SYSTEM.DEBUG ('============= Role2 : ' + Role2);
        SYSTEM.DEBUG ('============= listU : ' + listU);
        SYSTEM.DEBUG ('============= listU.size() : ' + listU.size());    

        Decimal Total=0;
        String OutputTotal='';
        String PIC='';
        String oweaID='';

        String errorMessage = '';
        Messaging.SingleEmailMessage tmpMessage = new Messaging.SingleEmailMessage();
        Messaging.SendEmailResult[] tmpResults = new List<Messaging.SendEmailResult>();
                
        String sendEmailRecipient = system.label.PENDING_RECURRING_SEND_EMAIL_RECIPIENT;
        /* 
            REAL    : real email Recipient
            TEST    : test email Recipient
         */

        String isSENDEmail = system.label.PENDING_RECURRING_IS_SEND_EMAIL;
        /* 
            YES : send email, and put log
            NO  : no send email, just put log
         */

        SYSTEM.DEBUG ('============= sendEmailRecipient : ' + sendEmailRecipient);
        SYSTEM.DEBUG ('============= isSENDEmail        : ' + isSENDEmail);


        try {
            for(Pending_Recurring__c PR:listPR)
            {
                List<User> userAMManagerList =[SELECT id,Userrole.Name,Name FROM User WHERE Name=:PR.AM_Manager__c];

                SYSTEM.DEBUG ('============= userAMManagerList : ' + userAMManagerList);

                if (userAMManagerList.size() > 0 ) {
                    user  tesU = userAMManagerList[0];
                    
                    if (tesU.Userrole.Name <> null) {
                        if(tesU.Userrole.Name.Contains('Group Head'))
                        {
                            PR.PIC__c=PR.AM_Sales__c;
                        }
                        else {
                            PR.PIC__c=PR.AM_Manager__c;
                            PR.Account_Manager__c=PR.AM_Sales__c;
                        }

                        // TODO : HANDLING ROLE NAME is NULL
                        // NO-ACTION
                        

                    }
                }
            }
            update listPR;
            String userrole='';
            
            for(UserRole UR:Role1)
            {
                userrole=UR.Name.replace('Head - ','');
                UserRole1.add(userrole);
            } 
            
            for(UserRole UR:Role2)
            {
                userrole=UR.Name.replace('Head - ','');
                UserRole2.add(userrole);
            } 
            
            List<AggregateResult> listAGPR=[SELECT MAX(Segment__c) Segment,PIC__c,SUM(Total_Revenue__c) Total_Outstanding_Revenue,MIN(Pending_From__c) Earliest_Pending_From,MAX(Aging__c) Largest_Aging FROM Pending_Recurring__c 
                                                        WHERE Status__c='Send To Sales' AND Segment__c IN :UserRole1 
                                                            and ( AM_Manager__c <> 'System Administrator'  or  AM_Manager_User_Status__c <> false )
                                                        GROUP BY PIC__c];

            List<AggregateResult> listAGPR2=[SELECT MAX(Segment__c) Segment,PIC__c,SUM(Total_Revenue__c) Total_Outstanding_Revenue,MIN(Pending_From__c) Earliest_Pending_From,MAX(Aging__c) Largest_Aging FROM Pending_Recurring__c 
                                                        WHERE Status__c='Send To Sales' AND Segment__c IN :UserRole2 
                                                            and ( AM_Manager__c <> 'System Administrator'  or  AM_Manager_User_Status__c <> false )
                                                        GROUP BY PIC__c];

            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :system.label.Pending_Recurring_Sender ];

            oweaID = owea.get(0).Id;
            
            SYSTEM.DEBUG ('============= listAGPR : ' + listAGPR);
            SYSTEM.DEBUG ('============= listAGPR.size() : ' + listAGPR.size());
            SYSTEM.DEBUG ('============= listAGPR2 : ' + listAGPR2);
            SYSTEM.DEBUG ('============= listAGPR2.size() : ' + listAGPR2.size());
            SYSTEM.DEBUG ('============= owea : ' + owea);

            datetime Now3=system.now().adddays(-3);
            String tanggaljumat=Now3.format('dd MMM yyyy');

            if(listAGPR.size()>0)
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            
                message.optOutPolicy = 'FILTER';

                message.setOrgWideEmailAddressId(oweaID);
                message.subject = 'Pending Recurring Enterprise  '+tanggaljumat;
                String Segment='';
                String messageBody = '<html><head><style> table#customers{font-family: "Trebuchet MS", Arial_Unicode_MS, sans-serif;border-collapse:collapse;width: auto;border: 3px solid black;padding: 3px;font-size: 12px;}td#customers101{border: 3px solid black;padding: 3px;font-size: 8px;}</style></head>';
                MessageBody=Messagebody+'<body>Dear GH Key Account Management,<br><br>Berikut ini nilai penagihan layanan yang masih tertunda (pending recurring) dan membutuhkan kelengkapan dokumen :<br/><br/>';
                messagebody=messagebody+'<table border="1" cellpadding="5" id="customers"><tr style="background-color:#0000FF;color:#FFFFFF" align="center"><td id="customers" width="200">  Segment  </td><td width="200">  PIC  </td><td width="150">  Longest Pending From  </td><td width="150">  Longest Aging(Days)  </td><td width="200">  Total Pending Revenue  </td></tr>';
                String outputCurrency ='';
                Decimal Currency1=0;
                String dateOutput = '';
                datetime dt=system.now();
                string bgcolor='';
                Integer counttr=0;
                for(AggregateResult AG:listAGPR)
                {
                    Counttr=counttr+1;
                    if(math.mod(counttr,2)==1)
                    bgcolor='#ADD8E6';
                    else
                    bgcolor='#FFFFFF';
                    PIC=(String) AG.get('PIC__c');
                
                    Segment=(String)AG.get('Segment');
                    Currency1=(Decimal) AG.get('Total_OutStanding_Revenue');
                    if(!test.isRunningTest())
                    {
                    Total=Total+Currency1;
                    outputcurrency= Currency1.setScale(2).format();
                    }
                    else {
                        total=0;
                        outputcurrency='0';
                    }
                    dt=(datetime) AG.get('Earliest_Pending_From');
                    dateoutput=dt.format('dd MMM yyyy');
                    messagebody=messagebody+'<tr style="background-color:'+bgcolor+';"><td align="left">  '+Segment+'  </td><td align="left">  '+PIC+'  </td><td>'+dateOutput+'</td><td>'+Integer.valueof(AG.get('Largest_Aging'))+'</td><td align="right">  '+outputCurrency+'  </td></tr>';
                }
                OutputTotal=total.setScale(2).format();
                messagebody=messagebody+'<tr align="right"><td></td><td></td><td></td><td>  Grand Total  </td><td align="right">  '+OutputTotal+'  </td></tr>';
                messagebody=messagebody+'</table><br>Best Regards,<br>Operation Revenue Management</body>  </html>';
                message.setHtmlBody(messageBody); 
                list<String> emailreceiver=new String[] {};
                //list<String> emailreceivercc=new String[] {'GinaF@xl.co.id'};
                list<String> emailreceivercc=new String[] {};
                
                //if ( system.label.PENDING_RECURRING_IS_TEST == 'NO' ) 
                if ( sendEmailRecipient == 'REAL' ) 
                {
                    
                    List<String> tmpCCAddressList = system.label.Pending_Recurring_Recipient_CC.split(';');
                    for (String tmpCCAddress :tmpCCAddressList) {
                        emailreceivercc.add (tmpCCAddress);
                    }
                    
                    for(user u:listU)
                    {
                        if(U.userrole.name=='Group Head - Key Account Management')
                        {
                            emailreceiver.add(u.email);
                        }
                        else if(U.userrole.name!='Group Head - SME')
                        {
                            emailreceivercc.add(u.email);
                        }
                    }
                } 
                
                //else if ( system.label.PENDING_RECURRING_IS_TEST == 'YES' ) 
                else if ( sendEmailRecipient == 'TEST' )
                {
                    List<String> tmpToAddressList = system.label.Pending_Recurring_Test_ToAddress.split(';');
                    for (String tmpToAddress :tmpToAddressList) {
                        emailreceiver.add (tmpToAddress);
                    }

                    List<String> tmpCCAddressList = system.label.Pending_Recurring_Test_CCAddress.split(';');
                    for (String tmpCCAddress :tmpCCAddressList) {
                        emailreceivercc.add (tmpCCAddress);
                    }
                }

                SYSTEM.DEBUG ('============= emailreceiver : ' + emailreceiver);
                SYSTEM.DEBUG ('============= emailreceivercc : ' + emailreceivercc);

                message.toaddresses=emailreceiver;
                message.setCCAddresses(emailreceivercc);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};

                Messaging.SendEmailResult[] results = null ;

                if (isSENDEmail == 'YES') {
                    //-- send email if normal or test mode 1 
                    results = Messaging.sendEmail(messages);
                }

                tmpMessage = message;
                tmpResults = results;

                SYSTEM.DEBUG ('============= tmpMessage : ' + tmpMessage);
                SYSTEM.DEBUG ('============= tmpResults : ' + tmpResults);
            }

            if(listAGPR2.size()>0)
            {
                Messaging.SingleEmailMessage message2 = new Messaging.SingleEmailMessage();
                
                message2.optOutPolicy = 'FILTER';
                
                message2.setOrgWideEmailAddressId(oweaID);
                message2.subject = 'Pending Recurring SME  '+tanggaljumat;
                String Segment2='';
                string bgcolor='';
                Integer counttr=0;
                String messageBody2 = '<html><head><style> table#customers{font-family: "Trebuchet MS", Arial_Unicode_MS, sans-serif;border-collapse:collapse;width: auto;border: 3px solid black;padding: 3px;font-size: 12px;}td#customers101{border: 3px solid black;padding: 3px;font-size: 8px;}</style></head>';
                MessageBody2=Messagebody2+'<body>Dear GH SME,<br><br>Berikut ini nilai penagihan layanan yang masih tertunda (pending recurring) dan membutuhkan kelengkapan dokumen :<br /><br />';
                messagebody2=messagebody2+'<table border="1" cellpadding="5" id="customers"><tr style="background-color:#0000FF;color:#FFFFFF"><td id="customers" width="200">  Segment  </td><td width="200">  PIC  </td><td width="150">  Longest Pending From  </td><td width="150">  Longest Aging(Days)  </td><td width="200">  Total Pending Revenue  </td></tr>';
                String outputCurrency ='';
                String dateOutput = '';
                Decimal Currency1=0;
                datetime dt=system.now();
                Total=0;
                for(AggregateResult AG:listAGPR2)
                {
                    Segment2=(String)AG.get('Segment');
                    if(math.mod(counttr,2)==1)
                    bgcolor='#ADD8E6';
                    else
                    bgcolor='#FFFFFF';
                    PIC=(String) AG.get('PIC__c');
                
                    Total=Total+Currency1;
                    Currency1=(Decimal) AG.get('Total_OutStanding_Revenue');
                    if(!test.isRunningTest())
                    {
                    Total=Total+Currency1;
                    outputcurrency= Currency1.setScale(2).format();
                    }
                    else {
                        Total=0;
                        Outputcurrency='0';
                    }
                    dt=(datetime) AG.get('Earliest_Pending_From');
                    dateoutput=dt.format('dd MMM yyyy');
                    messagebody2=messagebody2+'<tr style="background-color:'+bgcolor+';"><td align="left">  '+Segment2+'  </td><td align="left">  '+PIC+'  </td><td>  '+dateOutput+'  </td><td>  '+Integer.valueof(AG.get('Largest_Aging'))+'  </td><td align="right">  '+outputCurrency+'  </td></tr>';
                }
                OutputTotal=total.setScale(2).format();
                messagebody2=messagebody2+'<tr align="right"><td></td><td></td><td></td><td>  Grand Total  </td><td align="right">  '+OutputTotal+'  </td></tr>';
                messagebody2=messagebody2+'</table><br>Best Regards,<br>Operation Revenue Management</body>  </html>';
                message2.setHtmlBody(messageBody2); 
                list<String> emailreceiver2=new String[] {};
                //list<String> emailreceivercc2=new String[] {'GinaF@xl.co.id'};
                list<String> emailreceivercc2=new String[] {} ;            
                
                //if ( system.label.PENDING_RECURRING_IS_TEST == 'NO' ) 
                if ( sendEmailRecipient == 'REAL' ) 
                {
                    List<String> tmpCCAddressList = system.label.Pending_Recurring_Recipient_CC.split(';');
                    for (String tmpCCAddress :tmpCCAddressList) {
                        emailreceivercc2.add (tmpCCAddress);
                    }
                    
                    for(user u:listU)
                    {
                        if(U.userrole.name=='Group Head - SME')
                        {
                            emailreceiver2.add(u.email);
                        }
                        else if(U.userrole.name!='Group Head - Key Account Management')
                        {
                            emailreceivercc2.add(u.email);
                        } 
                    }
                }


                //else if ( system.label.PENDING_RECURRING_IS_TEST == 'YES' ) 
                else if ( sendEmailRecipient == 'TEST' ) 
                {
                    List<String> tmpToAddressList = system.label.Pending_Recurring_Test_ToAddress.split(';');
                    for (String tmpToAddress :tmpToAddressList) {
                        emailreceiver2.add (tmpToAddress);
                    }

                    List<String> tmpCCAddressList = system.label.Pending_Recurring_Test_CCAddress.split(';');
                    for (String tmpCCAddress :tmpCCAddressList) {
                        emailreceivercc2.add (tmpCCAddress);
                    }
                }

                SYSTEM.DEBUG ('============= emailreceiver2 : ' + emailreceiver2);
                SYSTEM.DEBUG ('============= emailreceivercc2 : ' + emailreceivercc2);


                message2.toaddresses=emailreceiver2;
                message2.setCCAddresses(emailreceivercc2);
                Messaging.SingleEmailMessage[] messages2 =   new List<Messaging.SingleEmailMessage> {message2};
                Messaging.SendEmailResult[] results2 = null ;

                if ( isSendEmail == 'YES' ) {
                    //-- send email if normal or test mode 1 
                    results2 = Messaging.sendEmail(messages2);
                }

                tmpMessage = message2;
                tmpResults = results2;

                SYSTEM.DEBUG ('============= tmpMessage : ' + tmpMessage);
                SYSTEM.DEBUG ('============= tmpResults : ' + tmpResults);
            }

        }
        catch (Exception e){

            errorMessage = 'Error on Schedule_Pending_Recurring2 .:: ' +
                                ' '+ e.getmessage() + ' - ' +e.getStacktraceString() +' ' +'::' + e.getLineNumber() ;
            
            SYSTEM.DEBUG ('============= errorMessage : ' + errorMessage);
            apputils.puterror(errorMessage);

        } 

        // save to LOG
        Send_Email__c  sendEmailObj  = new Send_Email__c();
        sendEmailObj.optOutPolicy__c = tmpMessage.optOutPolicy;
        sendEmailObj.OrgWide_Email_Address_Id__c = oweaID; 
        sendEmailObj.subject__c = (tmpMessage.subject == null || tmpMessage.subject == '') ? '-- this email not to send --' : tmpMessage.subject ; 
        sendEmailObj.Message_Body__c = tmpMessage.getHtmlBody() == null ? '' : tmpMessage.getHtmlBody() ;
        sendEmailObj.to_addresses__c = tmpMessage.getToaddresses() == null ? '' : string.join(tmpMessage.getToaddresses(),',')  ;
        sendEmailObj.CC_Addresses__c = tmpMessage.getCCAddresses() == null ? '' : string.join(tmpMessage.getCCAddresses(),',')  ; 
        sendEmailObj.status__c = 'Sent' ; 
        sendEmailObj.error_message__c = errorMessage;

        if (tmpResults<> null)
            sendEmailObj.Results__c =  string.join(tmpResults,',')  ; 

        insert sendEmailObj;
    }

}