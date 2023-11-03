global class SOAPUpdatePR
{
    webservice static String updatePR(String OpportunityID, String SR, String PR, String PRStatus, String SRStatus, String SRNotes, String PRNotes, String BAStartDate, String CID)
    {
        DateTime start_time;
        try
        {
            start_time = system.now();
            
            OpportunityID = OpportunityID.left(4) + '-' + OpportunityID.right(6);
            Opportunity O = [SELECT id,Amount, Opportunity_ID__c , name, PR__c, Recurring_Revenue__c, Link_Related__c, Service_Type__c, StageName, PR_Status__c, SR_Status__c, PR_Notes__c, SR_Notes__c, Contract_Periode__c, Periode_UOM__c,Note__c from Opportunity WHERE Opportunity_ID__c = :OpportunityID LIMIT 1];
            //O.PR__c=PR;
            if(O.StageName=='Closed Won'||O.StageName=='Closed Lost'||O.StageName=='Closed Not Delivered')
            	return 'Opportunity Already Closed';
            O.SR_Status__c = SRStatus;
            O.PR_Status__c = PRStatus;
            O.SR_Notes__c = SRNotes;
            O.PR_Notes__c = PRNotes;
            if(PRStatus != null && PRStatus != '' && PRStatus == 'WBA')
            {
                list<OpportunityLineItem> OLI = [SELECT Contract_Start_Date__c, Contract_End_Date__c, Revenue_Type__c FROM OpportunityLineItem WHERE OpportunityID = :O.id];
                Date D = date.newinstance(Integer.valueof(BAStartDate.left(4)), Integer.valueof(BAStartDate.substring(4, 6)), Integer.valueof(BAStartDate.right(2)));
                Integer I = Integer.valueof(O.Contract_Periode__c);
                for(OpportunityLineItem LI : OLI)
                {

                    LI.Contract_Start_Date__c = D;
                    if(LI.Revenue_Type__c == 'Recurring' || LI.Revenue_Type__c == 'One Time')
                    {
                        if(O.periode_uom__c == 'Month')
                            LI.Contract_End_Date__c = D.Addmonths(I);
                        if(O.periode_uom__c == 'Year')
                            LI.Contract_End_Date__c = D.AddYears(I);
                    }
                    if(O.Recurring_Revenue__c == 0)
                        LI.Contract_End_DATE__C = D.addmonths(1);
                    if(LI.Contract_End_Date__c!=null)
                    LI.Contract_End_Date__c=LI.Contract_End_Date__c.Adddays(-1);
                }

                update OLI;
            }
            system.debug('====== O.Service_Type__c : ' + O.Service_Type__c);
            system.debug('====== PRStatus :' + PRStatus );
            
            
            if(PRStatus == 'CNCL' || PRStatus == 'CANCL')
                O.StageName = 'Closed Loss';
            else if(PRStatus.startswith('WBA'))
            {
                O.StageName = 'Waiting for BA';
                if(O.Service_Type__c == 'NewLink')
                {
                    O.CID__c = CID;
                    List<Link__c> linkList = [SELECT id FROM Link__c WHERE Name = :CID];
                    if (linkList.size() >0) {
                        //-- Link is exist on the Link Table/Object
                        O.Link_Related__c = linkList[0].id;
                    }
                    else {
                        //-- the link is not exist, then send email to System Administrator
                        Send_Email__c se = new Send_Email__c ();
                        List<user> users = [ select id, name, profile.name, email from user where name = 'System Administrator' ];
                        string userID;
                        if ( users.size() >0 )  {
                            userID=users[0].id;

                            se.user_receiver__c = userID;
                            se.subject__c = 'The CID ' + CID + ' is not exist on the Salesforce.' ;
                            se.Message_Body__c = 'Dear System Administrator ' +  '<br>' + '<br>'+ '<br>' 
                                + 'The CID "' + CID + '" is not exist on the Salesforce to relate on Opportunity. ' 
                                + 'This email is triggered on stage movement to WBA (by update PR from SAP).' + '<br>'
                                + '<br>'+ '<br>' + '<br>'+ '<br>'
                                + '<i>'
                                + 'Notes :  ' + '<br>'
                                + 'Opportunity ID   :  ' + O.Opportunity_ID__c + '<br>'
                                + 'Opportunity Name :  ' + O.name 
                                + '</i>';
    
                            se.status__c = 'New';
                            insert se; 
                        }

                    }

                }
            }
            else if(PRStatus.contains('COM'))
                {
                    if(O.Amount==0)
                    O.StageName='Closed Won';
                    else
                    {
                    O.StageName = 'Waiting for Contract';
             //       O.Note__c='Send Email To Contract Manager';
                    }
                }
            
            if(O.StageName != 'Implementation' && O.StageName != 'Waiting for BA' && !O.StageName.Contains('Closed'))
            {
                if(SRStatus.Contains('CNCL')||SRStatus == 'CNCL' || SRStatus == 'CANCL' || SRStatus.Contains('R07') || SRStatus.Contains('R08') || SRStatus.Contains('R09') || SRSTATUS.Contains('R10'))
                    O.StageName = 'Prospecting';
                else
                {
                    if(O.StageName == 'Survey')
                        O.StageName = 'Negotiation';
                }
            }
            update O;
            Call_Log__c CL = new Call_Log__c();
            CL.endpoint__c = 'SOAPUpdatePR';
            CL.Request_Message__c = 'Opportunity No:'+OpportunityID +'  SRStatus:'+ SRSTATUS +' PRStatus:'+ PRStatus+'  BAStartDate:'+BAStartDate;
            CL.response_message__c = 'success';
            CL.Request_Start_Time__c = start_time;
             CL.Status__c='Success'; 
            CL.response_end_time__c = system.now();
            CL.Type__c = 'Callin';
            insert CL;
            return 'success';
        }
        catch(exception e)
        {
            Call_Log__c CL2 = new Call_Log__c();
            CL2.endpoint__c = 'SOAPUpdatePR';
            CL2.Request_Message__c = OpportunityID + SRSTATUS + PRStatus;
            CL2.response_message__c = e.getmessage() + 'Stack Trace' + e.getstacktracestring();
            CL2.Request_Start_Time__c = start_time;
            CL2.response_end_time__c = system.now();
            CL2.Status__c='Failed';
            CL2.Type__c = 'Callin';
            insert CL2;
            return e.getmessage() + 'Stack Trace' + e.getstacktracestring();
        }
    }

}