/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 01-16-2023
 * @last modified by  : Novando Utoyo Agmawan
**/

trigger Trigger_Order on Order (after insert, after update, before delete, before insert, before update) {
    if (label.Is_Trigger_ORDER_ON == 'YES') {
        string errMessage='';
        Map<ID, User> userMap=new Map<ID,User>([SELECT id,Managerid,Manager.Managerid, email FROM User ]);
        if(trigger.isupdate){
            
            //-- BEFORE UPDATE
            if(trigger.isbefore) {
                for(Order newOrder:system.trigger.new) {
                    Order oldOrder=Trigger.oldMap.get(newOrder.id);
                    
                    if(OldOrder.OwnerID!=NewOrder.OwnerID)
                    {
                        //-- SET "Sales Manager" and "GM Sales" field related to Owner ---
                        //-- TODO: handling SOQL in loop ---
                        User U=userMap.get(NewOrder.ownerid); 
                        if(U.ManagerID!=null){
                            NewOrder.Sales_Manager__c=U.ManagerID;
                        }
                        if(U.Manager.Managerid!=null){
                            NewOrder.GM_Sales__c=U.Manager.ManagerID;
                        } 
                    }
                    if(neworder.status=='Create ID COM' && oldorder.status!='Create ID COM' && newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_NEW  ) {
                        if (neworder.ID_COM_is_Created__c == TRUE) {
                            //-- Move stage to Tagging Process, because no need create ID COM
                            neworder.status ='Tagging Process';
                            neworder.is_need_validation__c = true;
                        }
                    }

                        system.debug('=== newOrder.status'+newOrder.status);
                        if(neworder.status=='Complete' && oldorder.status!='Complete')
                        {
                            /* -- VALIDATION : for PostPaid Activation Order
                             * ALL MSISDN get the activation process result (success/failed), from data upload 
                             * every failed data get the reason note, from data upload
                             * LA have LA Number
                             */
                            errMessage = '';
                            system.debug('=== newOrder.recordtypeid'+newOrder.recordtypeid);
                            if ( newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW 
                                    ||  newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING 
                                    ||  newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING 
                                    ||  newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW 
                                    ) {
                                        
                                List<Order_MSISDN__c> orderMSISDNList = 
                                    [   SELECT id , order__c, name, status__c, PC_Notes__c 
                                        FROM Order_MSISDN__c 
                                        WHERE order__c =:NewOrder.id
                                            AND (
                                                status__c = null
                                                OR  (status__c = 'Failed' AND ( PC_Notes__c = '' OR PC_Notes__c = null))
                                            )
                                        ];  

                                if (orderMSISDNList.size() > 0) {
                                    errMessage = 'Any activation status is still empty or PC Notes is empty for Failed activation. ';
                                }

                                if( ( newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW  || newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW )
                                    && (newOrder.La_Number__c == '' || newOrder.La_Number__c == null) && !test.isrunningtest() ) {
                                    errMessage = errMessage + 'LA Number is still empty. ';
                                }
                                
                                if (errMessage<>'') {
                                    NewOrder.addError ('This Order cannot Complete. ' + errMessage );  
                                } 
                            }
 

                            /* -- VALIDATION : for PrePaid Tagging Order
                             *  ???
                             * 
                             */
                            if ( newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_NEW ||  newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_EXISTING ) {
                                //-- TODO
                            }

                            
                            //-- CREATE ACCOUNT LA / ID COM record WHEN Order is Completed --------------------------------
                            if((newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW 
                                || newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_NEW
                                || newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW
                                
                                ))
                            {
                                Account accRecord = new Account();
                                accRecord.ownerid = neworder.ownerid;  //--todo: set to Account.owner
                                accRecord.Phone=neworder.Phone__c;
                                accRecord.Organization_Type__c = 'Branch';
                                accRecord.parentid =newOrder.Accountid;
                                accRecord.Fax=newOrder.Fax__c;
                                accRecord.No_SIUP__c = newOrder.SIUP_No__c;
                                accRecord.No_NPWP__c=neworder.NPWP_No__c;
                                accRecord.No_TDP__c=neworder.TDP_No__c;
                                accRecord.No_Akta__c=neworder.Akta_Notaris_No__c;
                                accRecord.No_Legal__c=newOrder.Legal_No__c;
                                accRecord.OU__c = newOrder.OU__c;   
                                
                                accRecord.BillingStreet=neworder.Address_street__c;
                                accRecord.BillingCity=neworder.Address_City__c;
                                accRecord.billingpostalcode=neworder.Address_Postal_Code__c;
                                accRecord.billingState=neworder.Address_State_Province__c;
                                accRecord.BillingCountry=neworder.Address_Country__c;
                                
                                accRecord.ShippingStreet=neworder.Address_street__c;
                                accRecord.ShippingCity=neworder.Address_City__c;
                                accRecord.Shippingpostalcode=neworder.Address_Postal_Code__c;
                                accRecord.ShippingState=neworder.Address_State_Province__c;
                                accRecord.ShippingCountry=neworder.Address_Country__c;

                                accRecord.Name=neworder.Corporate_Name__c; //Nama_Account__c;
                                
                                accRecord.Summary_Billing__c = neworder.Summary_Billing__c;
                                accRecord.summary_invoice__c = neworder.Summary_Invoice__c;
                                accRecord.Faktur_Pajak__c = neworder.Faktur_Pajak__c;
                                


                                if( newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW 
                                    || newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW )
                                {
                                    Recordtype RT=[SELECT id FROM Recordtype where Name='LA'];
                                    accRecord.recordtypeid=RT.id;
                                    accRecord.LA_Number__c=neworder.LA_Number__c;
                                }
                                if(newOrder.recordtypeid==system.label.RT_ORDER_Prepaid_NEW)
                                {
                                    Recordtype RT=[SELECT id FROM Recordtype where Name='ID Com'];
                                    accRecord.recordtypeid=RT.id;
                                    accRecord.LA_Number__c= neworder.ID_COM_Number__c;
                                    accRecord.COMNAME__c = neworder.COMNAME__c;
                                    accRecord.COMTYPE__c = neworder.COMTYPE__c;

                                }

                                try {
                                    insert accRecord;
                                    if( newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW
                                        || newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW 
                                        )
                                    {
                                        neworder.LA__c=accRecord.id;
                                    }

                                    if(newOrder.recordtypeid==system.label.RT_ORDER_Prepaid_NEW)
                                    {
                                        neworder.ID_COM__c=accRecord.id;
                                    }

                                    //-- handling duplicate by mobilephone and email

                                    List<contact> contactList = null;
                                    boolean doCreateContact = false;
                                    boolean isAnyPrivateContact = false;

                                    if ( (neworder.Mobile_Phone__c <> null  && neworder.Mobile_Phone__c <>'') && (neworder.PIC_Email__c == null  || neworder.PIC_Email__c == ''  )   )                          
                                    {   
                                        contactList = [ select id, accountid, name, email, mobilephone from contact where mobilephone =:neworder.Mobile_Phone__c ] ;
                                        if (contactList.size() == 0) doCreateContact=true;
                                    }
                                    
                                    if ( (neworder.Mobile_Phone__c == null  || neworder.Mobile_Phone__c =='') && (neworder.PIC_Email__c <> null  && neworder.PIC_Email__c <> ''  )      )                       
                                    {   
                                        contactList = [ select id, accountid, name, email, mobilephone from contact where email =:neworder.PIC_Email__c ] ;
                                        if (contactList.size() == 0) doCreateContact=true;
                                    }

                                    if ( (neworder.Mobile_Phone__c <> null  && neworder.Mobile_Phone__c <>'') && (neworder.PIC_Email__c <> null  && neworder.PIC_Email__c <> ''  )  )                           
                                    {
                                        contactList = [ select id, accountid, name, email, mobilephone from contact where mobilephone =:neworder.Mobile_Phone__c or email =:neworder.PIC_Email__c ] ;
                                        if (contactList.size() == 0) doCreateContact=true;
                                    }

                                    if ( (neworder.Mobile_Phone__c == null  || neworder.Mobile_Phone__c =='') && (neworder.PIC_Email__c == null  || neworder.PIC_Email__c == ''  )   )                          
                                    {
                                        doCreateContact=true;
                                    }

                                    if (doCreateContact) 
                                    {
                                        //-- PUT CONTACT INFORMATION if no DUPLICATE
                                        Contact contactRecord = new Contact();
                                        contactRecord.ownerid = neworder.ownerid;   //--todo: set to Account.owner
                                        contactRecord.Accountid= accRecord.id;
                                        contactRecord.LastName= neworder.PIC_Name__c;
                                        contactRecord.birthdate= neworder.PIC_Date_of_Birth__c;
                                        contactRecord.Mobilephone= neworder.Mobile_Phone__c;
                                        
                                        contactRecord.Email = neworder.PIC_Email__c;
                                        contactRecord.MailingStreet = neworder.PIC_Address_Street__c;
                                        contactRecord.MailingState = neworder.PIC_Address_State_Province__c;
                                        contactRecord.MailingCity = neworder.PIC_Address_City__c;
                                        contactRecord.MailingPostalCode = neworder.PIC_Address_Postal_Code__c;
                                        contactRecord.MailingCountry = neworder.PIC_Address_Country__c;

                                        SYSTEM.DEBUG ('========= contactRecord : ' +  contactRecord);
                                        insert contactRecord;
                                    } 
                                    else 
                                    {
                                        SYSTEM.DEBUG ('========= accRecord : ' +  accRecord);
                                        SYSTEM.DEBUG ('========= contactList : ' +  contactList);
                                        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
                                        for (Contact contactObj : contactList) {
                                            
                                            SYSTEM.DEBUG ('========= contactObj : ' +  contactObj);

                                            if (contactObj.accountid == null) {
                                                //-- IS PRIVATE CONTACT THEN SET THE ACCCOUNT
                                                contactObj.accountid = accRecord.ID;
                                                isAnyPrivateContact = true;
                                            }
                                            else {
                                                //-- CREAT Account Contact Relationship 
                                                AccountContactRelation acrObjr = new AccountContactRelation();
                                                acrObjr.accountID = accRecord.ID;
                                                acrObjr.contactID = contactObj.ID;
                                                SYSTEM.DEBUG ('========= acrObjr : ' +  acrObjr);

                                                acrList.add (acrObjr);
                                            }
                                        }

                                        SYSTEM.DEBUG ('========= acrList : ' +  acrList);
                                        if ( acrList <> null )
                                            insert acrList;
                                        
                                        if (isAnyPrivateContact) update contactList;

                                    }


                                    
                                } catch (Exception e) {
                                    errMessage =  e.getmessage() + ' ' + e.getstacktraceString() ;
                                    appUtils.putError('Error on Trigger_Order before Complete ::' + errMessage + '::' + e.getLineNumber()  );
                                    newOrder.adderror(e.getmessage());

                                }
                            }
                        }
                    /* TUTUP DULU
                    if(OldOrder.Status!=NewOrder.Status && NewOrder.Status=='Submit Order' && NewOrder.SIMCard_Order_Payment_Type__c=='FREE')
                    {
                        NewOrder.Sales_Manager_Approval__c='Pending';
                    }*/
                    
                }
            }
            
            
            //-- AFTER UPDATE
            if(trigger.isAfter) {
                List <Opportunity> opportunityToUpdateList = new List <Opportunity> ();

                for(Order newOrder:system.trigger.new) {
                    Order oldOrder=Trigger.oldMap.get(newOrder.id);
                    if((neworder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING||neworder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW) 
                        && neworder.Pricebook2id!=oldorder.pricebook2id)
                        {
                    /*
                    */
                        }

                    system.debug ('===== neworder.recordtypeid :' +  neworder.recordtypeid );

                    if( neworder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW  
                            || neworder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING
                            || neworder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING
                            || neworder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW
                    
                        )
                    {
                        if(neworder.status=='Activation in Process' && oldorder.status!='Activation in Process')
                        {
                            //List<Order_MSISDN__c > OMlist = [Select name ,ICCID__c,MSISDN__r.Name,New_MSISDN_IP__c,CL__c,PPS__c,Credit_Class__c,PricePlan__c,AO__c,Email__c,Activation_Status__c,PC_Notes__c from Order_MSISDN__c WHERE Order__c=:neworder.id];   
                            //string header = ' Name ,ICCID ,MSISDN,New MSISDN/IP,CL,PPS,CreditClass,PricePlan,AO,Email,StatusAktivasi,PCNotes\n';
                            
                            List<Order_MSISDN__c > OMlist = [ Select name , order__r.account.name ,ICCID__c,MSISDN__r.Name,New_MSISDN_IP__c,
                                                                    CL__c,PPS__c,Credit_Class__c, order__r.service_type__c, 
                                                                    PricePlan__c,AO__c,Email__c,order__r.recordtype.name, order__r.owner.name, 
                                                                    order__r.LA__r.name, order__r.LA__r.LA_Number__c, Order__r.order_id__c, order__r.Min_Commitment__c  ,
                                                                    order__r.opportunity.opportunity_id__c , name__c, status__c, order__r.LA__r.OU__c , order__r.Corporate_Name__c
                                                                from Order_MSISDN__c 
                                                                    WHERE Order__c=:neworder.id ];
                            
                            string header = 'Name, ICCID, MSISDN, New MSISDN/IP, CL, PPS, CreditClass, Service Type, Status, Priceplan, Minkom, AO, Email, LA, Customer Name, Requester, TO, Oppty ID\n';
                            string finalstr = header ;                                                                  
                            
                            for(Order_MSISDN__c orderMSISDN : OMList)
                            {
                                string minkom = orderMSISDN.order__r.Min_Commitment__c == true ? 'Minkom' : 'No Mincom';
                                string iccid = '/' + orderMSISDN.ICCID__c ;
                                string msisdn = '/' + orderMSISDN.MSISDN__r.Name ;
                                string newMsisdn = '/' + orderMSISDN.New_MSISDN_IP__c ;

                                iccid = iccid.replaceall('//', '/');
                                msisdn = msisdn.replaceall('//', '/');
                                newMsisdn = newMsisdn.replaceall('//', '/');

                                string LAName = '';
                                if ( neworder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING
                                        || neworder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING ) {

                                    //-- EXISTING LA
                                    LAName = '<' + orderMSISDN.order__r.LA__r.LA_Number__c + '> / <' + orderMSISDN.order__r.LA__r.OU__c + '>';

                                } else if ( neworder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW  
                                        || neworder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW ) {

                                    //-- NEW LA
                                    LAName = orderMSISDN.order__r.Corporate_Name__c;
                                }

                                
                                string recordString = ''
                                                        + orderMSISDN.name__c + ',' 
                                                        + iccid + ',' 
                                                        + msisdn + ',' 
                                                        + newMsisdn + ',' 
                                                        + orderMSISDN.CL__c +',' 
                                                        + orderMSISDN.PPS__c + ',' 
                                                        + orderMSISDN.Credit_Class__c + ','
                                                        + orderMSISDN.order__r.service_type__c + ','
                                                        + orderMSISDN.status__c + ','
                                                        + orderMSISDN.PricePlan__c + ','
                                                        + minkom + ','
                                                        + orderMSISDN.AO__c + ',' 
                                                        + orderMSISDN.Email__c + ','
                                                        + LAName + ',' 
                                                        + orderMSISDN.order__r.account.name + ','
                                                        + orderMSISDN.order__r.owner.name  + ','
                                                        + orderMSISDN.Order__r.order_id__c  + ','
                                                        + orderMSISDN.order__r.opportunity.opportunity_id__c 
                                                        + '\n';
                                recordstring=recordstring.replaceall('null','');
                                finalstr = finalstr +recordString;

                            }

                            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                            blob csvBlob = Blob.valueOf(finalstr);
                            string csvname= 'ActivationReq_'+neworder.order_id__c+'.csv';
                            csvAttc.setFileName(csvname);
                            csvAttc.setBody(csvBlob);
                            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                            
                            /*
                            String[] toAddresses = new list<string> {'surya.ansana@saasten.com','doddy.kusumadhynata@saasten.com'};
                            String listemailuseraktivasi=system.label.email_user_aktivasi;
                            String[] emailuseraktivasi=listemailuseraktivasi.split(';');
                            for(String emailaktiv:emailuseraktivasi)
                            {
                                toaddresses.add(emailaktiv);
                            }

                            List <User> userList = [SELECT Id, name, email FROM User where userrole.name ='Corporate Collection' 
                                or id =:system.label.Project_Coordinator_Device_ID ];
                                string [] toCC = new List <string>();
                            for (user usr : userList) {
                                if (usr.email <> null)
                                    toCC.add(usr.email);    //-- Project Coordinator & Corporate Collection'
                            }

                            */

                            List <User> userList2 = [SELECT Id, name, manager.email  FROM User 
                                where id =:system.label.Project_Coordinator_Device_ID ];

                            //-- Recipent email TO : Email_to_Activation_Team_TO  -------------------
                            String activationRecipientEmailTO =system.label.Email_to_Activation_Team_TO;
                            String[] activationRecipientEmailTOList = activationRecipientEmailTO.split(';');
                            String[] toAddresses = new list<string> ();                         
                            for(String emailAddress : activationRecipientEmailTOList) {
                                toAddresses.add(emailAddress);
                            }
                            //-----------------------------------------------------------------------


                            /*  Recipent email TO : Email_to_Activation_Team_TO -------------------------------------------
                             * 
                             * Project_Coordinator_Activation_Email 
                             * Email_to_Activation_Team_CC
                             * Sales Email
                             * + manager project coordinator
                             * 
                            */          

                            //-- Project_Coordinator_Activation_Email 
                            String activationRecipientEmailCC1 =system.label.Project_Coordinator_Activation_Email;
                            String[] activationRecipientEmailCC1List = activationRecipientEmailCC1.split(';');
                            String[] ccAddresses = new list<string> ();                         
                            for(String emailAddress : activationRecipientEmailCC1List) {
                                ccAddresses.add(emailAddress);
                            }

                            //-- Email_to_Activation_Team_CC -----
                            String activationRecipientEmailCC2 =system.label.Email_to_Activation_Team_CC;
                            String[] activationRecipientEmailCC2List = activationRecipientEmailCC2.split(';');
                            //String[] ccddresses = new list<string> ();                            
                            for(String emailAddress : activationRecipientEmailCC2List) {
                                ccAddresses.add(emailAddress);
                            }

                            //-- Sales Email ----
                            User usr=userMap.get(NewOrder.ownerid);
                            ccAddresses.add(usr.email);

                            //-- Project Coordinator Manager ----
                            List <User> userPCMList = [SELECT Id, name, manager.email  FROM User 
                                where email =:system.label.Project_Coordinator_Activation_Email ];
                            for (user userPCM : userPCMList) {
                                if (userPCM.manager.email <> null)
                                ccAddresses.add(userPCM.manager.email); 
                            }
                            //---------------------------------------------------------------------------------------------                 


                            system.debug ('=== toAddresses : ' + toAddresses);
                            system.debug ('=== ccAddresses : ' + ccAddresses);

                            Account accountObj=[SELECT Name FROM Account WHERE ID=:NewOrder.Accountid];
                            
                            String acccountLAName = '';
                            boolean doSend = false;

                            system.debug ('===== newOrder.LA__c : ' + newOrder.LA__c);

                            string serviceType = (neworder.Service_type__c == null) ? '' : neworder.Service_type__c ;
                            string orderID = (neworder.Order_ID__c == null) ? '' : neworder.Order_ID__c ;
                            string accountName = (accountObj.Name == null) ? '' : accountObj.Name ;
                            string corporateName = (neworder.Corporate_Name__c == null) ? '' : neworder.Corporate_Name__c ;

                            string APNName = (neworder.APN_Name__c == null) ? '' : neworder.APN_Name__c;
                            string APNID = (neworder.APN_ID__c == null) ? '' : neworder.APN_ID__c;

                            if ( (newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING || newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING) && newOrder.Order_DCP__c == false ) {
                                

                                if (newOrder.LA__c == null ) {
                                    NewOrder.addError ('LA field is empty. Choose LA first!' );  
                                    doSend = false;
                                } 
                                else {
                                    List <Account> accountLAList=[SELECT Name, LA_Number__c, OU__c FROM Account WHERE ID=:newOrder.LA__c];
                                    Account accountLAObj = null;
                                    if (accountLAList.size() > 0 ) {
                                        accountLAObj = accountLAList[0];

                                        string LANumber = (accountLAObj.LA_Number__c == null ) ? '' : accountLAObj.LA_Number__c ;
                                        string OU = (accountLAObj.OU__c == null) ? '' : accountLAObj.OU__c;

                                        SYSTEM.DEBUG ('============= accountLAList : ' + accountLAList);
                                        SYSTEM.DEBUG ('============= accountLAObj : ' + accountLAObj);
                                        SYSTEM.DEBUG ('============= LANumber : ' + LANumber);
                                        SYSTEM.DEBUG ('============= OU : ' + OU);


                                        doSend = true;

                                        //-- Email Body for EXISTING LA GSM Activation
                                        email.setHTMLBody(
                                            '<html> <head></head> '
                                            + '<body>'
                                            + 'Dear Activation Team.' + '<br/> '
                                            + '<br/> '
                                            + 'Mohon bantuannya untuk new Activation (' + serviceType + ') berikut : ' + '<br/> '
                                            + '<br/> '
                                            + 'Order No : ' + orderID + '<br/> '
                                            + 'Account Name : ' + accountName + '<br/> '
                                            + 'LA Name : ' + '&lt;' + LANumber + '&gt;' + ' / ' + '&lt;' +  OU + '&gt;' + '<br/> '
                                            + 'Service Type : ' + serviceType + '<br/> '
                                            + 'Number of MSISDN : ' + OMList.size() + '<br/> '
                                            + 'APN Name : ' + APNName + '<br/> '
                                            + 'APN ID : ' + APNID + '<br/> '

                                            + '<br/> '
                                            + '<br/> '
                                            + 'Kami tunggu untuk updatenya.' + '<br/> '
                                            + 'Terima kasih atas bantuan dan kerjasamanya.' + '<br/> '
                                            + '<br/> '
                                            + '<br/> '
                                            + 'Regards, ' + '<br/>'
                                            + '</body> '
                                            + '</html> ');
                                    }
                                    else {      
                                        NewOrder.addError ('LA field is empty. Choose LA first!' );  
                                        doSend = false;
                                    }
                                }
                            } 
                            else if ( newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW ||newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW ) {
                                doSend = true;
                                //-- Email Body for NEW LA GSM Activation
                                
                                string addressStreet = (neworder.Address_street__c == null) ? '' : neworder.Address_street__c ;
                                string addressStateProvince = (neworder.Address_State_Province__c == null) ? '' : neworder.Address_State_Province__c ;
                                string addressCity = (neworder.Address_City__c == null) ? '' : neworder.Address_City__c ;
                                string addressPostalCode = (neworder.Address_Postal_Code__c == null) ? '' : neworder.Address_Postal_Code__c ;
                                string addressCountry = (neworder.Address_Country__c == null) ? '' : neworder.Address_Country__c ;
                                string phone = (neworder.Phone__c == null) ? '' : neworder.Phone__c ;
                                string Fax = (neworder.Fax__c == null) ? '' : neworder.Fax__c ;
                                string SIUPNo = (neworder.SIUP_No__c == null) ? '' : neworder.SIUP_No__c ;
                                string NPWPNo = (neworder.NPWP_No__c == null) ? '' : neworder.NPWP_No__c ;
                                string TDPNo = (neworder.TDP_No__c == null) ? '' : neworder.TDP_No__c ;
                                string aktaNotarisNo = (neworder.Akta_Notaris_No__c == null) ? '' : neworder.Akta_Notaris_No__c ;

                                string picName = (neworder.PIC_Name__c == null) ? '' : neworder.PIC_Name__c ;
                                string picDateOfBirth = (neworder.PIC_Date_of_Birth__c == null) ? '' : string.valueof (neworder.PIC_Date_of_Birth__c) ;
                                string picAddressStreet = (neworder.PIC_Address_Street__c == null) ? '' : neworder.PIC_Address_Street__c ;
                                string picAddressStateProvince = (neworder.PIC_Address_State_Province__c == null) ? '' : neworder.PIC_Address_State_Province__c ;
                                string picAddressCity = (neworder.PIC_Address_City__c == null) ? '' : neworder.PIC_Address_City__c ;
                                string picAddressPostalCode = (neworder.PIC_Address_Postal_Code__c == null) ? '' : neworder.PIC_Address_Postal_Code__c ;
                                string picAddressCountry = (neworder.PIC_Address_Country__c == null) ? '' : neworder.PIC_Address_Country__c ;
                                string ktpNo = (neworder.KTP_No__c == null) ? '' : neworder.KTP_No__c ;
                                string mobilePhone = (neworder.Mobile_Phone__c == null) ? '' : neworder.Mobile_Phone__c ;
                                string legalNo = (neworder.Legal_No__c == null) ? '' : neworder.Legal_No__c ;


                                email.setHTMLBody(
                                    '<html> <head></head> '
                                    + '<body>'
                                    + 'Dear Activation Team.' + '<br/> '
                                    + '<br/> '
                                    + 'Mohon bantuannya untuk new Activation (' + serviceType + ') berikut : ' + '<br/> '
                                    + '<br/> '
                                    + 'Order No : ' + orderID + '<br/> '
                                    + 'Account Name : ' + accountName + '<br/> '
                                    + 'LA Name : ' + corporateName + '<br/> '                                   
                                    + 'Service Type : ' + serviceType + '<br/> '
                                    + 'Number of MSISDN : ' + OMList.size() + '<br/> '
                                    + 'APN Name : ' + APNName + '<br/> '
                                    + 'APN ID : ' + APNID + '<br/> '

                                    + '<br/> '
                                    + '<b> '
                                    + 'UKM Name : ' + corporateName + '</b> ' + '<br/> '
                                    + 'Alamat : ' + addressStreet  + ' ' 
                                                    + addressStateProvince + ' ' 
                                                    + addressCity + ' ' 
                                                    + addressPostalCode + ' ' 
                                                    + addressCountry
                                                    + '<br/> '
                                    + 'Telp : ' + phone + '<br/> '
                                    + 'Fax : ' + Fax + '<br/> '
                                    + 'SIUP : ' + SIUPNo + '<br/> '
                                    + 'NPWP : ' + NPWPNo + '<br/> '
                                    + 'TDP : ' + TDPNo + '<br/> '
                                    + 'Akta Notaris : ' + aktaNotarisNo + '<br/> '

                                    + '<br/> '
                                    + '<B>PIC </b><br/> '
                                    + 'Nama : ' + picName + '<br/> '
                                    + 'DOB : ' + picDateOfBirth + '<br/> '
                                    + 'Alamat : ' + picAddressStreet  + ' ' 
                                                    + picAddressStateProvince + ' ' 
                                                    + picAddressCity + ' '  
                                                    + picAddressPostalCode + ' ' 
                                                    + picAddressCountry
                                                    + '<br/> '
                                    + 'No. KTP : ' + ktpNo + '<br/> '
                                    + 'HP : ' + mobilePhone + '<br/> '
                                    + 'No. Legal : ' + legalNo + '<br/> '

                                    + '<br/> '
                                    + '<br/> '
                                    + 'Kami tunggu untuk updatenya.' + '<br/> '
                                    + 'Terima kasih atas bantuan dan kerjasamanya.' + '<br/> '
                                    + '<br/> '
                                    + '<br/> '
                                    + 'Regards, ' + '<br/>'
                                    + '</body> '
                                    + '</html> ');
                                    

                            }

                            system.debug ('========== doSend : ' + doSend);
                            if(newOrder.Order_DCP__c == false){
                                if (doSend) {
    
                                    String subject =accountObj.Name+' #'+Neworder.Order_id__c+' New Activation MSISDN ('+OMList.size()+')';
                                    email.setSubject(subject);
                                    email.setToAddresses( toAddresses );
                                    email.setccAddresses (ccAddresses);
                                    
                                    //BrandTemplate et = [SELECT Id,Name FROM BrandTemplate WHERE name='XL' LIMIT 1];
                                    
    
    
                                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                                    if(toAddresses.size()>0)
                                    {
                                        Messaging.SendEmailResult [] sendEmailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                                        SYSTEM.DEBUG (' ======= sendEmailResult : ' + sendEmailResult);
    
                                    }
    
    
                                    //-- add by doddy July 20, 2020
                                    //-- Jika ada 1 order saja (activation) yang sudah sampai "Activation in Process" 
                                    //-- maka Opportunity harusnya pindah ke Implementation
                                    //-- PO_Date
                                    string tmpOpptyID =  neworder.opportunityid;
                                    if ( tmpOpptyID <> null ) {
                                        Opportunity tmpOppty = new Opportunity (id= tmpOpptyID);
                                        tmpOppty.StageName = 'Implementation';
                                        //-- add by Kahfi Des 21, 2021 to handle PO date empty
                                        if(tmpOppty.PO_Date__c == null){
                                          tmpOppty.PO_Date__c = System.today();
                                      }
                                        opportunityToUpdateList.add (tmpOppty);
                                        tmpOppty.StageIsUpdatedFromOrder__c = TRUE;
                                    }
    
                                }
                           } else{
                                //-- add by doddy July 20, 2020
                                //-- Jika ada 1 order saja (activation) yang sudah sampai "Activation in Process" 
                                //-- maka Opportunity harusnya pindah ke Implementation
                                string tmpOpptyID =  neworder.opportunityid;
                                if ( tmpOpptyID <> null ) {
                                    Opportunity tmpOppty = new Opportunity (id= tmpOpptyID);
                                    tmpOppty.StageName = 'Implementation';
                                    //-- add by Kahfi Des 21, 2021 to handle PO date empty
                                    if(tmpOppty.PO_Date__c == null){
                                        tmpOppty.PO_Date__c = System.today();
                                    }
                                    opportunityToUpdateList.add (tmpOppty);
                                    tmpOppty.StageIsUpdatedFromOrder__c = TRUE;
                                }
                               
                           }

                        }
                        

                        if(neworder.status=='Activation in Review' && oldorder.status!='Activation in Review')
                        {
                            //-- to UPDATE MSISDN historical status 
                            OrderController ocObj = new OrderController();
                            ocObj.updateOnActivationOrder(neworder);
                        }

                        //-- AFTER Complete
                        //-- set Opportunity to Closed Won when all order have been Complete (by quantity)
                        if(neworder.status=='Complete' && oldorder.status!='Complete')
                        {

                            //-- to UPDATE MSISDN historical status 
                            OrderController ocObj = new OrderController();
                            ocObj.updateOnActivationOrder(neworder); 


                            //-- do AUTO Closed Won (opportunity) when number of success = number of product 
                            //-- OLD WAY list<AggregateResult> AR_OrderProduct=[SELECT SUM(Quantity) Total FROM OrderItem WHERE Order.Status='Complete' AND Order.OpportunityID=:neworder.opportunityID ];
                            
                            //-- GET Opportunity data
                            List<Opportunity> opportunityList=[SELECT TotalOpportunityQuantity,StageName,CloseDate FROM Opportunity WHERE ID=:newOrder.OpportunityID];
                            if (opportunityList.size() > 0) {
                                decimal oppProductTotalQuantity= opportunityList[0].TotalOpportunityQuantity;
    
                                //-- GET SUCCESS Activation records
                                list<order_msisdn__c> orderMSISDNList = [select id, name 
                                                                            from order_msisdn__c 
                                                                            where Status__c = 'Success' 
                                                                                AND Order__r.Opportunityid =: newOrder.OpportunityID];
                                integer msisdnSuccessTotal = orderMSISDNList.size();
    
                                //-- OLD WAY : if(O.TotalOpportunityQuantity==(Decimal)AR_OrderProduct[0].get('Total') && O.CloseDate>system.today())
                                if (msisdnSuccessTotal == oppProductTotalQuantity ){ 
                                    opportunityList[0].StageName = 'Closed Won';
                                    update opportunityList;
                                }
                            }

                        }
                        
                    }
                    
                    /* PREPAID TAGGING STATUS AFTER UPDATE -----------------------------------
                     * add by doddy 06 May 2020
                     * 
                     */
                     
                     
                     
                    if(neworder.recordtypeid==system.label.RT_ORDER_PREPAID_EXISTING||neworder.recordtypeid==system.label.RT_ORDER_PREPAID_NEW || neworder.recordtypeid==system.label.RT_ORDER_PREPAID_UNTAGGING_EXISTING)
                    {
                        if(neworder.status=='Create ID COM' && oldorder.status!='Create ID COM')
                        {
                            system.debug ('===== masuk trigger untuk createCom, order id :' +  neworder.id );
                            //REST_Community  ResCom = new REST_Community();
                            integer max_sub = integer.valueOf(neworder.max_subscriber__c);
                            integer discount = integer.valueOf(neworder.discount__c);
                            
                            REST_Community_Callout.CreateComm(neworder.id,neworder.ID_COM_Number__c,neworder.COMNAME__c, neworder.COMTYPE__c, max_sub, discount);
                            

                        }
                        
                        if(neworder.status=='Tagging Process' && oldorder.status!='Tagging Process')
                        {
                            system.debug ('===== masuk trigger untuk tagging process, order id :' +  neworder.id );
                            
                            
                            GSM_Tagging_Service  GTS = new GSM_Tagging_Service();
                            GTS.taggingRequestByOrder(neworder.id );

                            //-- to UPDATE MSISDN historical status 
                            OrderController ocObj = new OrderController();
                            ocObj.updateOnTaggingOrder(neworder); 


                            //-- Jika ada 1 order saja (TAGGING) yang sudah sampai "Tagging Process" 
                            //-- maka Opportunity harusnya pindah ke Implementation
                            string tmpOpptyID =  neworder.opportunityid;
                            if ( tmpOpptyID <> null ) {
                                Opportunity tmpOppty = new Opportunity (id= tmpOpptyID);
                                //-- add by Kahfi Des 21, 2021 to handle PO date empty
                                if(tmpOppty.PO_Date__c == null){
                                       tmpOppty.PO_Date__c = System.today();
                                }
                                tmpOppty.StageName = 'Implementation';
                                opportunityToUpdateList.add (tmpOppty);
                                tmpOppty.StageIsUpdatedFromOrder__c = TRUE;
                            }
                        }

                        if(neworder.status=='Untagging Process' && oldorder.status!='Untagging Process')
                        {
                            system.debug ('===== masuk trigger untuk untagging process, order id :' +  neworder.id );
                            
                            
                            GSM_UnTagging_Service  GUTS = new GSM_UnTagging_Service();
                            GUTS.UntaggingRequestByOrder(neworder.id );

                            //-- to UPDATE MSISDN historical status 
                            OrderController ocObj = new OrderController();
                            ocObj.updateOnUnTaggingOrder(neworder); 


                            
                        }

                        //-- AFTER Complete
                        //-- set Opportunity to Closed Won when all order have been Complete (by quantity)
                        if(neworder.status=='Complete' && oldorder.status!='Complete')
                        {
                            system.debug('neworder.RecordType.Name nya :'+neworder.RecordType.Name);
                            //-- to UPDATE MSISDN historical status 
                            if(neworder.recordtypeid==system.label.RT_ORDER_PREPAID_UNTAGGING_EXISTING){
                                OrderController ocObjUnt = new OrderController();
                                ocObjUnt.updateOnUnTaggingOrder(neworder);
                                
                            }
                            
                            else{
                            system.debug('==== MASUK SINI :');
                                OrderController ocObj = new OrderController();
                                ocObj.updateOnTaggingOrder(neworder); 
                            }
                            

                            //-- do AUTO Closed Won (opportunity) when number of success = number of product 
                            //-- OLD WAY list<AggregateResult> AR_OrderProduct=[SELECT SUM(Quantity) Total FROM OrderItem WHERE Order.Status='Complete' AND Order.OpportunityID=:neworder.opportunityID ];
                            
                            //-- GET Opportunity data
                            List<Opportunity> opportunityList=[SELECT TotalOpportunityQuantity,StageName,CloseDate 
                                                                FROM Opportunity
                                                                WHERE ID=:newOrder.OpportunityID];
                            if (opportunityList.size() > 0 ) {
                                decimal oppProductTotalQuantity= opportunityList[0].TotalOpportunityQuantity;
    
                                //-- GET SUCCESS Activation records
                                list<order_msisdn__c> orderMSISDNList = [select id, name 
                                                                            from order_msisdn__c 
                                                                            where Status__c = 'Success' 
                                                                                AND Order__r.Opportunityid =: newOrder.OpportunityID];
                                integer msisdnSuccessTotal = orderMSISDNList.size();
    
                                //-- OLD WAY : if(O.TotalOpportunityQuantity==(Decimal)AR_OrderProduct[0].get('Total') && O.CloseDate>system.today())
                                if (msisdnSuccessTotal == oppProductTotalQuantity ){ 
                                    opportunityList[0].StageName = 'Closed Won';
                                    update opportunityList;
                                }
                            }
                        }




                    }
                    //------------------------------------------------------------------------------------------


                    /* 
                     * SIM CARD ORDER HANDLER -------------
                    */

                    if (newOrder.recordtypeid==system.label.RT_ORDER_GSM_SIM_Card) {
                        
                        system.debug ('===== newOrder.recordtypeid : ' + newOrder.recordtypeid);
                        system.debug ('===== system.label.RT_ORDER_GSM_SIM_Card : ' + system.label.RT_ORDER_GSM_SIM_Card);
                        system.debug ('===== oldOrder.status : ' + oldOrder.status);
                        system.debug ('===== newOrder.status : ' + newOrder.status);
                        system.debug ('===== newOrder.SO_ID__c : ' + newOrder.SO_ID__c);
                        system.debug ('===== newOrder.Approval_Status__c : ' + newOrder.Approval_Status__c);
                        
                        
                        if ( oldOrder.status <> 'Submit Order' && newOrder.status == 'Submit Order' )
                        {
                            system.debug ('===== read available material');
                            //--- call API for read available material
                            REST_Material.readAvailableMaterialOnOrder(newOrder.id);
                        }
                        
                        if ( oldOrder.status <> 'Order Fulfillment' && newOrder.status == 'Order Fulfillment' 
                                &&   (newOrder.SO_ID__c == '' || newOrder.SO_ID__c == null) 
                                //&& newOrder.Approval_Status__c == 'Approved'  
                        ) {
                             system.debug ('===== read available material');
                            //--- call API for read available material
                            REST_Material.readAvailableMaterialOnOrder(newOrder.id);
                            
                            system.debug ('===== ready to call API for SIM Card Order');
                            //--- call API for SIM Card Order ---
                            REST_SIMCardOrder_v2.addSimCardOrder(newOrder.id);
                        }
                        
                        
                        if ( oldOrder.status <> 'Ready for Pickup' && newOrder.status == 'Ready for Pickup' )
                        {
                            system.debug ('===== Ready for Pickup');

                            //-- to UPDATE MSISDN historical status 
                            OrderController ocObj = new OrderController();
                            ocObj.updateOnSIMCardOrder(neworder); 
                            
                        }

                        if ( oldOrder.status <> 'Complete' && newOrder.status == 'Complete' ) {
                            system.debug ('===== Complete');

                            //-- to UPDATE MSISDN historical status 
                            OrderController ocObj = new OrderController();
                            ocObj.updateOnSIMCardOrder(neworder);
                        }
                        
                        
                        
                    }
                    
                }

                //-- add by doddy July 20, 2020
                //-- update opportunities value;
                system.debug('===== opportunityToUpdateList : ' + opportunityToUpdateList);
                if (opportunityToUpdateList.size() >0 ) 
                    update opportunityToUpdateList;


            }           
        }
        
        if(trigger.isInsert){

            //-- BEFORE INSERT ------------------------------
            if(trigger.isbefore) {
                for(Order newOrder:system.trigger.new) {
                        //-- SET "Sales Manager" and "GM Sales" field related to Owner ---
                        //-- TODO: handling SOQL in loop ---
                        User U=userMap.get(NewOrder.ownerid);
                        if(U.ManagerID!=null){
                            NewOrder.Sales_Manager__c=U.ManagerID;
                        }
                        if(U.Manager.Managerid!=null){
                            NewOrder.GM_Sales__c=U.Manager.ManagerID;
                        }
                      	//START validation opportunity hanya bisa create order prepaid/postpaid saja
            			List <Order> orderPostpaidList =[SELECT id, name, opportunityid FROM order 
                                                        		WHERE opportunityid=:newOrder.OpportunityID 
                                            					AND recordtype.name LIKE 'POSTpaid%'];
                    
                      	List <Order> orderPrepaidList =[SELECT id, name,opportunityid FROM order 
                                                        		WHERE opportunityid=:newOrder.OpportunityID 
                                                     			AND recordtype.name LIKE 'Prepaid%'];
                       	system.debug('=== orderPostpaidList : '+orderPostpaidList.size());
                    	system.debug('=== orderPrepaidList : '+orderPrepaidList.size());
            			if ((newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_NEW ||
                             newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_EXISTING) &&
                             newOrder.recordtypeid!=system.label.RT_ORDER_MSISDN_Untagging_Order && orderPostpaidList.size()>0)
                        {  
                            NewOrder.addError ('This Opportunity already have postpaid Order. ' + errMessage );
                        }
                      	if ((newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW ||
                            newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING) && 
                            newOrder.recordtypeid!=system.label.RT_ORDER_MSISDN_Untagging_Order && orderPrepaidList.size()>0)
                        {  
                            NewOrder.addError ('This Opportunity already have prepaid Order. ' + errMessage );
                        }
            
                      	//END validation
                      
                        List <Opportunity> opportunityList=[SELECT Pricebook2id, name FROM Opportunity WHERE ID=:newOrder.OpportunityID];
                        
                        if (newOrder.recordtypeid==system.label.RT_ORDER_GSM_SIM_Card) {
                            newOrder.Pricebook2id =  system.label.PRICEBOOK_GSM_MATERIAL;  // '01s5D0000000odK'; //PB: GSM-Material General 
                        }
                        else if(newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING ||
                                newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW ||
                                newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING ||
                                newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW ||
                                newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_EXISTING ||
                                newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_NEW) {
                            
                            //-- set pricebook automatically, related to opportunity
                            if (opportunityList.size() >0 ) 
                                newOrder.Pricebook2id=opportunityList[0].Pricebook2id;
                            else {
                                if( newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING ||
                                    newOrder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW ||
                                    newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_EXISTING ||
                                    newOrder.recordtypeid==system.label.RT_ORDER_PREPAID_NEW) {

                                        newOrder.Pricebook2id =  system.label.PRICEBOOK_GSM_ACTIVATION; 
                                }
                                else if (newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING ||
                                    newOrder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW ) {

                                        newOrder.Pricebook2id =  system.label.PRICEBOOK_DEVICE_BUNDLING; 
                                }
                            
                            }
                        }
                    
                }
            }
            
            //-- AFTER INSERT ------------------------------
            if(trigger.isafter) 
            {
                for(Order newOrder:system.trigger.new) {
                    if((neworder.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING
                            ||neworder.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW
                            ||neworder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING
                            ||neworder.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW

                            || neworder.recordtypeid==system.label.RT_ORDER_PREPAID_EXISTING
                            || neworder.recordtypeid==system.label.RT_ORDER_PREPAID_NEW
                            
                            ))
                    {

                        //-- AUTOMATION PROCESS TO CREATE ORDER PRODUCT ---------
                        //-- exclude DSS order (JUMP) , requested as of 1 September 2020
                        
                        if (newOrder.data_source__c <> system.label.JUMP_DATA_SOURCE_LABEL) {

                            
                            
                            

                            /*AggregateResult[] AR_OI=[SELECT SUM(Quantity) Total,PricebookEntry.Product2ID Result 
                                                        FROM OrderItem 
                                                        WHERE Order.OpportunityID=:neworder.opportunityid 
                                                            AND 
                                                            AND Order.Status!='Draft' 
                                                            AND 
                                                            GROUP BY Pricebookentry.Product2ID];
                                                            */

                            
                            
                            /* change using OrderService ---
                            AggregateResult[] orderProductARList=[
                                SELECT SUM(Quantity) totalQTY,
                                    PricebookEntry.ID productEntryID 
                                FROM OrderItem 
                                WHERE Order.OpportunityID =: neworder.opportunityid 
                                    AND Order.Status = 'Complete'  
                                GROUP BY PricebookEntry.ID
                            ];

                            Map<string, decimal> orderProdSuccessQuantityMap = new Map<string, decimal>();
                            for (AggregateResult orderProductARRec: orderProductARList) {
                                string productEntryID = (string) orderProductARRec.get('productEntryID');
                                decimal quantity = (decimal) orderProductARRec.get('totalQTY');
                                
                                orderProdSuccessQuantityMap.put (productEntryID, quantity );
                            }
                            system.debug ('=== orderProdSuccessQuantityMap : ' + orderProdSuccessQuantityMap);
                            ----- */

                            OrderService orderServiceOBJ = new orderService(neworder);
                            Map<string, decimal> orderProdUsedQuantityMap = orderServiceOBJ.getRemainingOfOrderProductQuantity();


                            /* old way : just for one product   
                            AggregateResult[] AR_OrderMSISDN= [ SELECT SUM(MSISDN_Success_Numbers__c) Total
                                                                FROM order where OpportunityID=:neworder.opportunityid ] ;
                            */

                            //-- get opportunity Product List ---
                            List<OpportunityLineItem> opptyProductList =[
                                SELECT id, PricebookEntryID , PricebookEntry.Pricebook2id,
                                    Pricebookentry.Product2id, Unitprice, Quantity 
                                FROM OpportunityLineItem 
                                WHERE OpportunityID = :neworder.opportunityid
                            ];
                            
                            list<OrderItem> orderItemTobeCreateList = new list<OrderItem>();
                            
                            for(OpportunityLineItem opptyProdREC : opptyProductList) {
                                Decimal forNewProductQuantity = 0;

                                decimal usedQTY = orderProdUsedQuantityMap.get (opptyProdREC.PricebookEntryID);
                                if (usedQTY == null) {
                                    //-- jika tidak ada dalam map (tidak ada di order product) maka set to 0
                                    usedQTY = 0;
                                }
        
                                //-- forNewProductQuantity : bakal quantity (quantity di opportunity - quantity sukses di order)
                                forNewProductQuantity = opptyProdREC.Quantity - usedQTY;

                                if (forNewProductQuantity > 0 ) {
                                    //-- jika forNewProductQuantity > 0 , maka perlu dibuatkan order product
                                    
                                    OrderItem orderItemREC = new OrderItem();
                                    orderItemREC.OrderID = newOrder.id;
                                    
                                    orderItemREC.PricebookEntryid = opptyProdREC.PricebookEntryID;
                                    orderItemREC.unitprice = opptyProdREC.unitprice;
                                    orderItemREC.quantity = opptyProdREC.Quantity - usedQTY;

                                    orderItemTobeCreateList.add(orderItemREC);

                                    system.debug ('=== orderItemREC : ' + orderItemREC);
                                    system.debug ('=== orderItemTobeCreateList : ' + orderItemTobeCreateList);
                                
                                }
                                
                            } //.endFor of Opportunity Product 
                            
                            system.debug ('=== orderItemTobeCreateList : ' + orderItemTobeCreateList);
                            insert orderItemTobeCreateList;
                        }
                    }
                }
            }
        }
        
    
    }

}