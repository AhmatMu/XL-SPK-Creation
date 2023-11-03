/**
 * @description       : 
 * @Test Class		  : test_contractextension
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-10-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   08-23-2022   -                       Initial Version
**/

trigger Trigger_ContractExtension on Contract_Extension__c (after insert, after update, before insert, before update) {
    //preparation to send email
    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
    list<AM_Portfolio_Mapping__c> Mapping=[SELECT id,AM__c,Portfolio_Management_Support__c FROM AM_Portfolio_Mapping__c WHERE Status__c='Active'];
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
    for(Contract_Extension__c ContractExtension:system.trigger.new)
    {
        
        if(trigger.isbefore)
        {
            
            if(trigger.isinsert)
            {
                integer BAPrintExist2=0;
                //validation check BA Print & Recipient exist
                integer BARecipientExist2=0;
                String ContactBAPrint='';
                list<AccountContactRelation> ACR2=[SELECT id,Contactid,Roles FROM AccountContactRelation WHERE Accountid=:ContractExtension.Account__c];
                for(AccountContactRelation A:ACR2)
                {
                    if(A.Roles!=null)
                    {
                        if(A.Roles.Contains('BA Print'))
                        {BAPrintExist2=BAPrintExist2+1;
                         ContactBAPrint=A.Contactid; 
                        }
                        if(A.Roles.contains('BA Recipient'))
                            BARecipientExist2=1;
                    }
                }
                //set AM ,Owner and Solution assigned to Contract extension
                Contract C=[SELECT id,Account.Ownerid FROM Contract WHERE ID=:ContractExtension.Existing_Contract_Item__c];
                ContractExtension.Account_Manager__c=C.Account.Ownerid;
                ContractExtension.Ownerid=C.Account.Ownerid;
                //list<AM_Portfolio_Mapping__c> listAM=[SELECT id,Portfolio_Management_Support__c FROM AM_Portfolio_Mapping__c where AM__c=:ContractExtension.Account_Manager__c AND Status__c='Active'];
                for(Integer i=0;i<mapping.size();i++)
                { 
                    if(mapping[i].AM__c==ContractExtension.Account_Manager__c)
                        ContractExtension.Solution_PIC__c=mapping[i].Portfolio_Management_Support__c;
                }
                if(BAprintExist2>0 && BARecipientExist2==1)
                {
                    
                    if(BAPrintExist2==1)
                    {
                        ContractExtension.BA_Print__c=ContactBAPrint;
                        ContractExtension.Status__c='Submit';
                    }
                }
                else
                {
                    ContractExtension.Status__c='Fill BA Recipient and BA Print';
                }
            }
            if(trigger.isupdate)
            {
                Contract_Extension__c CEOld=trigger.oldmap.get(ContractExtension.id);
                if(CEOld.Status__c=='Fill BA Recipient and BA Print' && CEOld.Status__c!=ContractExtension.Status__c )
                {
                    integer BAPrintExist=0;
                    integer BARecipientExist=0;
                    set<String> BAPrintID=new Set<String>{};
                        list<AccountContactRelation> ACR=[SELECT id,Contactid,Roles FROM AccountContactRelation WHERE Accountid=:ContractExtension.Account__c];
                    for(AccountContactRelation A:ACR)
                    {
                        if(A.Roles!=null)
                        {
                            if(A.Roles.Contains('BA Print'))
                            {BAPrintExist=1;
                             BAPrintID.add(A.Contactid);
                            }
                            if(A.Roles.contains('BA Recipient'))
                                BARecipientExist=1;
                        }
                    }
                    //validation if moved stage from 'Fill BA Print & Recipient'
                    
                    
                    if( BAPrintExist==0 &&
                       	ContractExtension.Status__c!='Completed' && 
                       	ContractExtension.Complete_Status__c !='Canceled')
                    	{
                        	system.debug('==== BAprint NotFilled');
                    
                            ContractExtension.adderror('BA Print Not Filled');
                    	}		
                    if(BARecipientExist==0 &&
                       	ContractExtension.Status__c!='Completed' && 
                       	ContractExtension.Complete_Status__c !='Canceled')
                        {
                        	ContractExtension.adderror('BA Recipient Not Filled');    
                        }
                        
                    if(ContractExtension.BA_Print__c==null&&ContractExtension.Status__c!='Completed'&&ContractExtension.Complete_Status__c !='Canceled')
                    {
                        ContractExtension.adderror('Please Fill Field PIC Customer with User Before next step');
                    }
                    else
                    {
                        if(!BAPrintID.contains(ContractExtension.BA_Print__c) &&
                            ContractExtension.Status__c!='Completed' && 
                            ContractExtension.Complete_Status__c !='Canceled'&& 
                           !test.isrunningtest())
                        {
                            ContractExtension.adderror('PIC Customer not BA Print');
                        }
                    }
                }
                if(CEOld.Status__c=='Completed' && 
                   CEOld.Status__c!=ContractExtension.Status__c &&
                   ContractExtension.Complete_Status__c !='Canceled' &&
                   userinfo.getprofileid() != system.label.Profile_ID_System_Administrator)
                {
                    ContractExtension.adderror('Completed Extension Cannot be Changed');
                }
                if((ContractExtension.Status__c=='Waiting for BA'||
                    ContractExtension.Status__c=='Waiting for Contract'||
                    ContractExtension.Status__c=='Change Price'||
                    (	ContractExtension.Status__c=='Completed' &&
                  		ContractExtension.Complete_Status__c !='Canceled') &&
                    CEOld.Status__c!=ContractExtension.Status__c 
                   ))
                {
                    
                    //cannot moved to above status if not approved by solution
                    if(ContractExtension.Approved_by_Solution__c==false)
                        ContractExtension.adderror('Stage are not allowed when current status are fill BA Print & Recipient');
                    
                }
                if(ContractExtension.Status__c=='Waiting for Contract')
                {
                    ContractExtension.Remark__c='Customer Confirmed to Extend Contract';
                    if(ContractExtension.Extension_Monthly_Price__c==null)
                    {
                        ContractExtension.Extension_Monthly_Price__c=ContractExtension.Previous_Monthly_Price__c;
                    }
                }
                if(CEOld.Status__c!='Waiting for BA' && ContractExtension.Status__c=='Waiting for BA')
                {
                    //dicomment karena harus menunggu tanggal scheduler notif terlebih dahulu (90,14,etc)
                    //when status is 'Waiting for BA', send PDF to customer
                    /*Datetime nextSchedule = system.now().addSeconds(60);
                    
                    String hour = String.valueOf( nextSchedule.hour());
                    String min = String.valueOf( nextSchedule.minute()); 
                    String ss = String.valueOf( nextSchedule.second());
                    String sDay = string.valueof( nextSchedule.day() ); 
                    String sYear = string.valueof( nextSchedule.year() );
                    String sMonth = string.valueof( nextSchedule.month() );
                    
                    String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
                    
                    if(!Test.isRunningTest()){
                        Call_ContractExtensionSendPDF_Schdler Call_ContractExtensionSendPDF = new Call_ContractExtensionSendPDF_Schdler(Contractextension.id); 
                        System.schedule('Call_ContractExtensionSendPDF_Schdler ' + Contractextension.id  + String.valueOf(system.now()), nextFireTime, Call_ContractExtensionSendPDF);
                    }*/
                    //ContractExtensionSendPDF.sendpdf(Contractextension.id);
                }
            }
        }
        if(trigger.isafter)
        {
            if(trigger.isinsert)
            {
                //  link__c L=[SELECT Link_id__c from Link__c where ID=:ContractExtension.Link__c];
                //  ContractExtensionSendPDF.IntegrationLinkPartner(ContractExtension.Link__c,L.Link_id__c);
                
                
            }
            if(trigger.isupdate)
            {
                Contract_Extension__c CEOld=trigger.oldmap.get(ContractExtension.id);
                Contract_Services CS=new Contract_Services();
                if((CEOld.Status__c!='Waiting Solution Approval' && ContractExtension.Status__c=='Waiting Solution Approval')||test.isrunningtest())
                {
                    //send email to Solution to notify about approval
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setUseSignature(false);
                    Contract_Extension__c BAX=[Select Link__r.Capacity_Bandwidth__c,Link__r.UOM__C,Link__r.Address__c,Account__r.Name,Link__r.Link_id__c,Solution_PIC__r.Email,Account_Manager__r.Manager.Email,Account_Manager__r.Email FROM Contract_Extension__c WHERE ID=:contractextension.id];
                    mail.setccAddresses(new String[]{'kahfif@xl.co.id','IDEWAP@xl.co.id',BAX.Account_Manager__r.Manager.Email,BAX.Account_Manager__r.Email,'operationrevenuemanagement@xl.co.id'});
                    mail.setToaddresses(new String[]{BAX.Solution_PIC__r.Email});
                    //mail.setToaddresses(new String[]{'Novando.Agmawan@saasten.com'});
                    
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    String URLEx=URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Contract_Extension__c/'+ContractExtension.id+'/view';
                    mail.optOutPolicy = 'FILTER';
                    mail.setSubject('[BA EXT] '+ BAX.Link__r.Link_id__c +' '+BAX.Account__r.Name);
                    String EmailBody='<html><head></head><body>Dear Solution,<br><br>Mohon untuk direview dan dianalisa skema partnership yang telah berjalan untuk link berikut karena link tersebut akan ditawarkan untuk perpanjangan ke customer:<br><br>';
                    EmailBody=EmailBody+'<table><tr><td>Link ID    </td> <td>  : </td><td>    '+BAX.Link__r.Link_id__c+' </td></tr>';
                    EmailBody=EmailBody+'<tr><td>BandWidth    </td> <td> : </td> <td>    '+BAX.Link__r.Capacity_Bandwidth__c +' '+BAX.Link__r.UOM__c+' </td></tr>';
                    EmailBody=EmailBody+'<tr><td>Customer Name </td> <td>: </td> <td>    '+BAX.Account__r.Name+'</td></tr>';
                    EmailBody=EmailBody+'<tr><td>Address      </td> <td> : </td> <td>    '+BAX.Link__r.Address__c+'</td></tr>';
                    EmailBody=EmailBody+'<tr><td>Monthly Fee  </td> <td> :  </td> <td>   '+ContractExtension.Previous_Monthly_Price__c+'</td></tr>';
                    EmailBody=EmailBody+'<tr><td>End of Contract  </td> <td>:  </td> <td>   '+ContractExtension.Contract_End_Date_string__c+'</td></tr>';
                    EmailBody=EmailBody+'<tr><td>Extension Period  </td> <td>:  </td> <td>   '+ContractExtension.Extension_Start_Date_string__c + ' - ' + ContractExtension.Extension_End_Date_string__c+'</td></tr></table>';
                    EmailBody=EmailBody+'Mohon lengkapi proposal extension untuk link di atas untuk BA Extension '+ContractExtension.Name+' berikut :<br><br>'+URLex;
                    EmailBody=EmailBody+'<br><br>Notes: Mohon untuk segera submit approval maksimum 14 hari setelah BA Extension diterima.<br><br>Regards<br></body></html>';
                    mail.setHtmlBody(EmailBody);
                    messages.add(Mail);
                }
                if(CEOld.Status__c!='Change Price' && ContractExtension.Status__c=='Change Price')
                {
                    //create change price from BA extension
                    CS.CreateChangePriceFromBAExtension(ContractExtension.id);
                }
                if(CEOld.Status__c!='Waiting For Contract' && ContractExtension.Status__c=='Waiting For Contract')
                {
                    //NEW UPDATE --> CHECK LINK STATUS BY VANDO dan NOVI
                    if(ContractExtension.Existing_Contract_item__c != null){
                        List<Link__c> linkList = [SELECT Id, Contract_Item_Rel__c, Status_Link__c FROM Link__c WHERE Contract_Item_Rel__c =: ContractExtension.Existing_Contract_item__c];
                        
                        if(linkList!=null && !linkList.isEmpty()){
                            if(linkList[0].Status_Link__c.contains ('IN_SERVICE')){
                                //create Contract from BA Extension -- EXISTING
                                if(ContractExtension.Contract_Ticket_Created__c==null)
                                {
                                    CS.CreateContractsFromBAExtension(ContractExtension.id);
                                }
                                else
                                {
                                    Contract_Ticket__c CT2=new Contract_Ticket__c();
                                    CT2.ID=ContractExtension.Contract_Ticket_Created__c;
                                    CT2.TicketStatus__c='Review by Contract Manager';
                                    Update CT2;
                                }
                                // END EXISTING
                            }
                        }
                    }
                    //END -- NEW UPDATE
                }
                //NEW -->> SET BAP TO CANCEL (NOVANDO - MARET 2021)
                if(CEOld.Status__c!='Waiting For Contract' && ContractExtension.Status__c=='Waiting For Contract' ||
                   CEOld.Status__c!='Completed' && ContractExtension.Status__c=='Completed' && ContractExtension.Complete_Status__c=='Done')
                {   
                    Id recordTypeId_bapEndofContract = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('End of Contract').getRecordTypeId();
                    
                    List<BAP__c> bapList = 
                        [
                            SELECT Id, 
                            BA_Extend_REL__c,
                            Request_Status__c, 
                            Complete_Status__c 
                            FROM BAP__c 
                            WHERE RecordTypeId =: recordTypeId_bapEndofContract AND 
                            BA_Extend_REL__c =: ContractExtension.id AND
                            Complete_Status__c != 'Canceled' AND
                            Request_Status__c != 'Complete'
                        ];
                    
                    if(bapList!=null && !bapList.isEmpty()){
                        for(BAP__c bapList_Extract : bapList){
                            bapList_Extract.Complete_Status__c = 'Canceled';
                            bapList_Extract.Request_Status__c = 'Complete';
                        }
                        update bapList;
                    }
                }
            }
        }
    }
    system.debug (' == messages : ' + messages); 
    system.debug (' == messages.size() : ' + messages.size()); 
    if(messages.size()>0)
        Messaging.sendEmail(messages);
}