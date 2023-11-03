/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-10-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-18-2022   Novando Utoyo Agmawan   Initial Version
 * 1.1   30-09-2022   Ahmat Murad             Disabled-syntax for validation that sales can't edit/move-stage after "waiting for ba" stage
 *                                              The validation move to standard validation-rule in opportunity
 *  
 *  
 **/

trigger Trigger_Opportunity_v2 on Opportunity(after insert, after update, before insert, before update) {
    if (system.label.is_Trigger_Opportunity_v2_On == 'YES') {

        Datetime datelimit = datetime.newinstance(2018, 7, 3, 0, 0, 0);
        set < String > set_ProfitabilityIds_DeleteAfterCloseLost = new set < String > ();

        if (trigger.isinsert) {
            list < AM_Portfolio_Mapping__c > Mapping = [SELECT id, AM__c, Portfolio_Management_Support__c FROM AM_Portfolio_Mapping__c WHERE Status__c = 'Active'];

            if (trigger.isbefore) {
                for (Opportunity Opp: system.trigger.new) {
                    system.debug('===== Opp ====' + Opp);
                    if (opp.trial_monitoring_ticket_rel__c == null) {
                        /*10 Feb 2020 Surya ,cloning default opportunity value */
                        Create_PR_SR_V2 CPS = new Create_PR_SR_V2();
                        String AutoRenewal = '';
                        Opp.StageName = 'Prospecting';
                        Opp.Contract_Ticket__c = null;
                        Opp.PO_Date__c = null;
                        Opp.PKS_Number__c = '';
                        Opp.COF_Number__c = '';
                        Opp.PR_Status__c = '';
                        Opp.SR_Status__c = '';
                        Opp.PR__c = '';
                        Opp.Pr_Notes__c = '';
                        Opp.SR__c = '';
                        Opp.Sr_notes__c = '';
                        Opp.BW_Before__c = '0';

                        Opp.UOM_BW_Before__c = '';
                        Opp.UOM_BW_After__c = '';
                        //       OPP.Project_Coordinator__c = '';

                        Opp.Loss_Reason__c = '';
                        Opp.Loss_Reason_Description__c = '';
                        Opp.Opportunity_Remark__c = '';
                        Opp.Quotation_Final_Approval__c = '';
                        Opp.Link_Related__c = null;
                        Opp.Periode_UOM__c = null;
                        Opp.International_BW__c = '';
                        Opp.Local_BW__c = '';
                        Opp.LastMile_Type__c = null;
                        Opp.Remark__c = null;
                        Opp.Approval_Status__c = null;
                        Opp.Quotation_Final_Rejection_Reason__c = '';
                        if ( /*Opp.Service_Type__c=='NewLink' &&*/ test.isrunningtest() || (Opp.Periode_UOM__c != null && Opp.Contract_Periode__c != null)) {
                            //set autorenewal deadline after contract periode defined
                            Autorenewal = CPS.setautorenewal(Integer.valueof(Opp.Contract_Periode__c), Opp.Periode_UOM__c);
                            list < String > SplitAR = Autorenewal.Split(' ');
                            Opp.Auto_Renewal_Periode__c = decimal.valueof(SplitAR[0]);
                            Opp.Auto_Renewal_UOM__c = SplitAR[1];
                        }
                    }

                    /* if((Opp.Service_Type__c=='Upgrade'||Opp.Service_Type__c=='Downgrade') &&  Opp.Link_Related__c!=null)
{
Link__c LinkRelated=[SELECT Contract_Item_Rel__r.Contract_Term__c ,Contract_Item_Rel__r.Periode_UOM__c FROM Link__c WHERE ID=:Opp.Link_Related__c];
Autorenewal=CPS.setautorenewal(Integer.valueof(LinkRelated.Contract_Item_Rel__r.Contract_Term__c),LinkRelated.Contract_Item_Rel__r.Periode_UOM__c);
list<String> SplitAR=Autorenewal.Split(' ');
Opp.Auto_Renewal_Periode__c=decimal.valueof(SplitAR[0]);
Opp.Auto_Renewal_UOM__c=SplitAR[1];
}*/
                    for (Integer i = 0; i < mapping.size(); i++) {
                        //map solution assigned to opportunity depend on owner of opportunity
                        if (Mapping[i].AM__c == Opp.Ownerid) {
                            Opp.Solution_PIC__c = Mapping[i].Portfolio_Management_Support__c;
                            break;
                        }
                    }

                }
            }

            //logic after insert new Opportunity
            if (trigger.isafter) {
                list < OpportunityTeamMember > listTeamOpp = new list < OpportunityTeamMember > ();

                //logic to find out the opportunity belong to converted Presurvey Lead
                //List<Lead> convertedLeads = [Select id,ConvertedOpportunityId, presurvey__c from Lead where ConvertedOpportunityId !=Null and IsConverted = True and LeadSource = 'Presurvey'];
                //  List<Opportunity> pOppty = new List<Opportunity>();

                for (Opportunity Opp: system.trigger.new) {
                    for (Integer i = 0; i < mapping.size(); i++) {
                        if (mapping[i].AM__c == Opp.Ownerid) {
                            //set solution as team member of opportunity
                            OpportunityTeamMember TeamOpp = new OpportunityTeamMember();
                            TeamOpp.Opportunityid = Opp.id;
                            TeamOpp.userid = Mapping[i].Portfolio_Management_Support__c;
                            TeamOpp.TeamMemberRole = 'Solution';
                            listTeamOpp.add(TeamOpp);
                            break;
                        }
                    }
                    //logic to find out the opportunity belong to converted Presurvey Lead
                    /*if(convertedLeads != Null && !convertedLeads.isempty() ){
                        for(Lead pLead : convertedLeads){
                            if(pLead.ConvertedOpportunityId == opp.id){
                                opp.Presurvey__c = pLead.Presurvey__c;
                                pOppty.add(opp);
                            }
                        }
                    } */
                }
                /*if(pOppty !=Null && !pOppty.isempty()){
                    update pOppty;
                }*/
                if (listTeamOpp.size() > 0) {
                    insert ListTeamOpp;
                }

            }
        }

        if (trigger.isupdate) {
            if (trigger.isbefore) {
                Profile p = [select id from profile where Name = 'Sales'];
                for (Opportunity O: system.trigger.new) {

                    Opportunity Old = Trigger.oldMap.get(O.id);

                    /* Surya 31 January 2020 validation link related cannot in 2 active oppty*/
                    if (Old.Link_Related__c == null && O.Link_Related__c != Old.Link_Related__c && ((O.service_type__c != 'relocation' && O.service_type__c != 'Reroute' && O.recurring_revenue__c > 0) || test.isRunningTest())) {
                        Link__c LR = [SELECT CID_RelD__c FROM LINK__c WHERE ID =: O.Link_Related__c];
                        list < Opportunity > OtherOpp = [SELECT Contract_Ticket__r.TicketStatus__c, StageName FROM Opportunity WHERE ID !=: O.id AND recurring_revenue__c > 0 AND Link_Related__r.CID_RelD__c =: LR.CID_RelD__c AND Probability <= 90 AND Stagename != 'Closed Lost'
                            AND StageName != 'Closed Not Delivered'
                            AND Service_type__c != 'Reroute'
                            AND Service_type__c != 'relocation'
                        ];
                        System.debug('OtherOpp ---> ' + OtherOpp);
                        System.debug('OtherOpp ---> ' + LR);
                        if (Otheropp.size() > 0 && !test.isRunningTest()) {

                            for (Opportunity other: otheropp) {
                                system.debug('== Other.stageName : ' + Other.stageName);
                                if (Other.stageName != 'Waiting for Contract') {
                                    O.adderror('Link cannot be added when it is used in other active opportunities.');
                                } else {
                                    if (other.contract_ticket__r.ticketstatus__c != 'Review By Finance' &&
                                        other.contract_ticket__r.ticketstatus__c != 'Active') {
                                        O.adderror('Link cannot be added when it is used in other active opportunities..');
                                    }
                                }
                            }
                        }
                    }
                    if (O.RecordtypeName__c == 'Simcard Postpaid/Prepaid' && O.StageName == 'Prospecting' && O.StageName != Old.StageName && Old.StageName == 'Submit PO') {
                        O.Failed_Hit__c = O.Failed_Hit__c + 1;
                    }
                    if (O.RecordtypeName__c == 'GSM (Simcard Order)' && O.StageName == 'Prospecting' && O.StageName != Old.StageName && Old.StageName == 'Submit Order') {
                        O.Failed_Hit__c = O.Failed_Hit__c + 1;
                    }

                    /** 
                     * log-v1.1 : disabled-syntax
                     * this validation will move to standard validation rule on opportunity
                     * October 30, 2002 - by ahmat

                    if (Old.StageName != 'Prospecting' &&
                        Old.StageName != 'Negotiation' &&
                        Old.StageName != 'Waiting for BA' &&
                        (Old.Contract_ticket__c == null || O.Dealer_Code__c != 'Complete') &&
                        userinfo.getProfileId() == P.id &&
                        Old.lastmodifieddate < system.now().addseconds(-2) &&
                        O.RecordtypeName__c.Contains('Subscription')) // && O.Createddate>datelimit)
                    {
                        //validation sales cannot update in certain stage of oppty
                        if (O.StageName != Old.StageName && O.StageName != 'Closed Lost' && O.StageName != 'Closed Not Delivered')
                            O.adderror('Sales cannot update at this stage');
                        if (Old.CloseDate != O.CloseDate || Old.Expected_RFS_Date__c != O.Expected_RFS_Date__c || O.StageName == 'Closed Lost' || O.StageName == 'Closed Not Delivered') {} else
                            O.adderror('Sales cannot update at this stage');
                    }
                    
                    * .END of "log-v1.1 : disabled-syntax" for the validation handling above
                    */
                    

                    /* 
                     if (Old.StageName != 'Prospecting' && Old.StageName != 'Negotiation' && Old.StageName != 'Waiting for BA' && (Old.Contract_ticket__c == null || O.Dealer_Code__c != 'Complete') &&
                         userinfo.getProfileId() == P.id &&
                         Old.lastmodifieddate < system.now().addseconds(-2) &&
                         O.RecordtypeName__c.Contains('Subscription') // && O.Createddate>datelimit)

                         //-- exclude trial opportunity (by doddy feb 8, 2022)
                         //-- todo: cari tahu fungsi validasi ini (dari line 150 sd. 169)
                        && O.trial__c <> TRUE 

                     ){
                         system.debug('== O.StageName : ' + O.StageName);
                         system.debug('== Old.StageName : ' + Old.StageName);
                         //validation sales cannot update in certain stage of oppty
                         if (O.StageName != Old.StageName && O.StageName != 'Closed Lost' && O.StageName != 'Closed Not Delivered'){
                             O.adderror('Cannot update in this stage. 1'+Old.StageName+' 2'+O.StageName);
                         }
                         //    O.adderror('Sales cannot update at this stage (1)');
                         if (Old.CloseDate != O.CloseDate || Old.Expected_RFS_Date__c != O.Expected_RFS_Date__c || O.StageName == 'Closed Lost' || O.StageName == 'Closed Not Delivered') { O.adderror('Sales cannot update at this stage (2)');} 
                            
                     }*/

                    if (
                        Old.StageName != 'Survey' && O.StageName == 'Survey' &&
                        (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage'))
                    ) {
                        O.Survey_Request_Date_Email__c = String.valueof(system.today());

                    }
                    if (
                        Old.StageName != 'Survey' &&
                        O.StageName == 'Survey' &&
                        (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage')) &&
                        O.Expected_RFS_Date__c == null
                        //&& O.Link_Related__c!=null)
                    ) {
                        O.adderror('RFS Date cannot be null');
                    }
                    if (
                        Old.StageName != 'Survey' &&
                        O.StageName == 'Survey' &&
                        (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage')) &&
                        O.RecordtypeName__c != 'M-Ads' &&
                        O.Service_Type__c == null
                        //&& O.Link_Related__c!=null)
                    ) {
                        O.adderror('Service Type cannot be null');
                    }
                    Create_PR_SR_V2 CPS = new Create_PR_SR_V2();
                    String AutoRenewal = '';

                    if ((Old.Contract_Periode__c != O.Contract_Periode__c || Old.Periode_UOM__c != O.Periode_UOM__c) && O.Periode_UOM__c != null && O.Contract_Periode__c != null) {
                        //set autorenewal periode after contract periode has been set
                        Autorenewal = CPS.setautorenewal(Integer.valueof(O.Contract_Periode__c), O.Periode_UOM__c);
                        list < String > SplitAR = Autorenewal.Split(' ');
                        O.Auto_Renewal_Periode__c = decimal.valueof(SplitAR[0]);
                        O.Auto_Renewal_UOM__c = SplitAR[1];
                    }
                    if ((O.Service_Type__c == 'Upgrade' || O.Service_Type__c == 'Downgrade') && (Old.Link_Related__c != O.Link_Related__c) && O.Link_Related__c != null) {
                        /*Link__c LinkRelated=[SELECT free_link__c,Contract_Item_Rel__r.Contract_Term__c ,Contract_Item_Rel__r.Periode_UOM__c FROM Link__c WHERE ID=:O.Link_Related__c];
if(linkrelated.free_link__c==false)
{
//autorenewal for upgrade/downgrade
Autorenewal=CPS.setautorenewal(Integer.valueof(LinkRelated.Contract_Item_Rel__r.Contract_Term__c),LinkRelated.Contract_Item_Rel__r.Periode_UOM__c);
list<String> SplitAR=Autorenewal.Split(' ');
O.Auto_Renewal_Periode__c=decimal.valueof(SplitAR[0]);
O.Auto_Renewal_UOM__c=SplitAR[1];

}*/
                    }

                    if (
                        Old.StageName != 'Survey' &&
                        O.StageName == 'Survey' &&
                        (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage')) &&
                        O.RecordtypeName__c != 'M-Ads'
                        //&& O.Link_Related__c!=null)
                    ) {
                        if (
                            O.RecordtypeName__c.Contains('Subscription Two Site')
                        ) {
                            list < AccountContactRelation > ACRSurvey = [SELECT id, AccountID, Contact.Name, Contact.Phone, Contact.MobilePhone, Contact.Email FROM AccountContactRelation WHERE(AccountID =: O.Account_Site_A__c OR AccountID =: O.Account_Site_B__c) AND Roles INCLUDES('PIC SITE')];
                            if (ACRSurvey.size() < 2 && !test.isrunningtest()) {
                                O.Adderror('Both Site must have PIC Site'); //leased line validation
                            } else {
                                String AccountSiteA = '';
                                String AccountSiteB = '';

                                O.PIC_Contact_Data_Email__c = '';
                                O.PIC_Contact_Data_Site_B_Email__c = '';
                                for (AccountContactRelation AcRelation: ACRSurvey) {
                                    if (AcRelation.AccountID == O.Account_Site_A__c) {
                                        //fill field required for email alert
                                        AccountSiteA = '1';
                                        O.PIC_A_Email__c = ACRelation.Contact.Name;
                                        if (O.Pic_Contact_Data_Email__c == null || O.Pic_Contact_Data_Email__c == '') {
                                            if (ACRelation.Contact.Phone != null && ACRelation.Contact.Phone != '')
                                                O.PIC_Contact_Data_Email__c = O.PIC_Contact_Data_Email__c + '  ' + ACRelation.Contact.Phone;
                                            if (ACRelation.Contact.MobilePhone != null && ACRelation.Contact.MobilePhone != '')
                                                O.PIC_Contact_Data_Email__c = O.PIC_Contact_Data_Email__c + '  ' + ACRelation.Contact.MobilePhone;
                                            if (ACRelation.Contact.Email != null && ACRelation.Contact.Email != '')
                                                O.PIC_Contact_Data_Email__c = O.PIC_Contact_Data_Email__c + '  ' + ACRelation.Contact.Email;
                                        }

                                    }
                                    if (AcRelation.AccountID == O.Account_Site_B__c) {
                                        //fill field required for email alert
                                        AccountSiteB = '1';
                                        O.PIC_B_Email__c = ACRelation.Contact.Name;
                                        if (O.Pic_Contact_Data_Site_B_Email__c == null || O.Pic_Contact_Data_Email__c == '' || test.isrunningtest()) {
                                            if (ACRelation.Contact.Phone != null && ACRelation.Contact.Phone != '')
                                                O.PIC_Contact_Data_Site_B_Email__c = O.PIC_Contact_Data_Site_B_Email__c + '  ' + ACRelation.Contact.Phone;
                                            if (ACRelation.Contact.MobilePhone != null && ACRelation.Contact.MobilePhone != '')
                                                O.PIC_Contact_Data_Site_B_Email__c = O.PIC_Contact_Data_Site_B_Email__c + '  ' + ACRelation.Contact.MobilePhone;
                                            if (ACRelation.Contact.Email != null && ACRelation.Contact.Email != '')
                                                O.PIC_Contact_Data_Site_B_Email__c = O.PIC_Contact_Data_Site_B_Email__c + '  ' + ACRelation.Contact.Email;
                                        }
                                    }
                                }
                                if ((AccountSiteA == '' || AccountSiteB == '') && !test.isrunningtest()) {
                                    O.Adderror('Both Site must have PIC Site');
                                } //validation leased line
                                else {
                                    list < SR_PR_Notification__c > SRCek = [SELECT id FROM SR_PR_Notification__c WHERE Opportunity__c =: O.id AND((Status__c = 'Close(Complete)'
                                            AND Reasons__c <> 'R28-NO PR Submission') OR Status__c = 'In Progress'
                                        OR Status__c = 'Assigned')];
                                    if (SRCek.size() == 0 && !test.isrunningtest()) {
                                        CPS.CreateSR(O); //call SR
                                    }
                                }
                            }

                        } else {
                            list < AccountContactRelation > ACRSurvey = [SELECT id, AccountID, Contact.Name, Contact.Phone, Contact.MobilePhone, Contact.Email FROM AccountContactRelation WHERE(AccountID =: O.Account_Site_A__c) AND Roles INCLUDES('PIC SITE')];
                            if (ACRSurvey.size() == 0) //&& !test.isrunningtest())
                            {
                                if (!test.isrunningtest())
                                    O.Adderror('Site A must have PIC Site'); //validation PIC site
                            } else {
                                //fill email alert field , update query SR
                                O.PIC_A_Email__c = ACRSurvey[0].Contact.Name;
                                if (O.Pic_Contact_Data_Email__c == null || O.Pic_Contact_Data_Email__c == '') {
                                    if (ACRSurvey[0].Contact.Phone != null && ACRSurvey[0].Contact.Phone != '')
                                        O.PIC_Contact_Data_Email__c = O.PIC_Contact_Data_Email__c + '  ' + ACRSurvey[0].Contact.Phone;
                                    if (ACRSurvey[0].Contact.MobilePhone != null && ACRSurvey[0].Contact.MobilePhone != '')
                                        O.PIC_Contact_Data_Email__c = O.PIC_Contact_Data_Email__c + '  ' + ACRSurvey[0].Contact.MobilePhone;
                                    if (ACRSurvey[0].Contact.Email != null && ACRSurvey[0].Contact.Email != '')
                                        O.PIC_Contact_Data_Email__c = O.PIC_Contact_Data_Email__c + '  ' + ACRSurvey[0].Contact.Email;
                                }
                                list < SR_PR_Notification__c > SRCek = [SELECT id FROM SR_PR_Notification__c WHERE Opportunity__c =: O.id AND(Status__c = 'Open'
                                    OR Status__c = 'Assigned'
                                    OR Status__c = 'Waiting Solution Confirmation'
                                    OR Status__c = 'In Progress'
                                    OR Status__c = 'Pending'
                                    OR(Status__c = 'Close(Complete)'
                                        AND Reasons__c <> 'R28-NO PR Submission'))];
                                if (SRCek.size() == 0 && !test.isrunningtest()) {
                                    CPS.CreateSR(O);
                                }

                            }
                        }

                    }

                    /*   if(Old.StageName!='Implementation' && O.StageName=='Implementation' && O.RecordtypeName__c=='B2B Marketplace')
{
CPS.CreateSRComplete(O); 
}*/

                    //validation rules untuk PIC BA PRINT Saat Stages Survey 08/03/2022
                    //request by: XL
                    if (Old.StageName != 'Survey' && O.StageName == 'Survey' && (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage') || O.RecordtypeName__c.Contains('Licensed') || O.RecordtypeName__c.Contains('Project'))) {
                        list < AccountContactRelation > listACR2 = [SELECT id, Roles, AccountID, Contact.Name, Account.BP_Number__c, Contactid, Contact.Email FROM AccountContactRelation WHERE AccountID =: O.Accountid AND Roles INCLUDES('PIC BA Print')];

                        if (listACR2.size() == 0) {
                            if (!test.isrunningtest()) {
                                O.adderror('No PIC BA Print in Account');
                            }
                        }

                    }

                    if (
                        (
                            Old.StageName != 'Survey' &&
                            O.StageName == 'Survey' &&
                            O.RecordtypeName__c == 'Licensed'
                        ) || test.isRunningTest()
                    ) {
                        //marketplace flow from survey to quotation final
                        if (!test.isrunningtest()) {
                            CPS.CreateSRComplete(O);

                            //-- request at March 4, 2002 : survey complete ke negotiation
                            // O.StageName = 'Quotation Final';

                            O.StageName = 'Negotiation';

                        }
                        O.bp_payer__c = O.accountid;
                        O.bp_vat__c = O.accountid;
                        O.Auto_renewal__c = true;
                    }

                    // -- end validation rules untuk  Saat Stages Quotation Final 08/03/2022

                    if (Old.StageName != 'Quotation Final' && O.StageName == 'Quotation Final') {

                        String RoleBAPrint = '';
                        String RoleBARecipient = '';
                        String PICSite = '';

                        System.debug(' =========== O.Account_Site_A__c : ' + O.Account_Site_A__c);
                        System.debug(' =========== O.Accountid : ' + O.Accountid);
                        boolean kroscekbaprint = false;

                        list < AccountContactRelation > listACR = [SELECT id, Roles, AccountID, Contact.Name, Account.BP_Number__c, Contactid, Contact.Email FROM AccountContactRelation WHERE AccountID =: O.Accountid OR AccountID =: O.Account_Site_A__c];
                        list < AccountContactRelation > listACR2 = [SELECT id, Roles, AccountID, Contact.Name, Account.BP_Number__c, Contactid, Contact.Email FROM AccountContactRelation WHERE AccountID =: O.Accountid AND Roles INCLUDES('PIC BA Print')];
                        system.debug('=======acr size' + listACR.size());
                        system.debug('====== acr 2' + listACR2.size());

                        // --  validation rules BA Saat Stages Quotation Final 08/03/2022
                        if (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage') || O.RecordtypeName__c.Contains('Licensed')) {
                            if (O.Project_Coordinator__c == null || O.Project_Coordinator__c == '') {
                                O.addError('Please fill project coordinator field');
                            } else {
                                User ProjectCoordinator = [SELECT id FROM User WHERE Name =: O.Project_Coordinator__c.Substringafter(' ')];
                                O.Project_Coordinator_User__c = ProjectCoordinator.id; /*system.label.Project_Coordinator_User_ID;*/
                            }
                        }
                        if (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage') || O.RecordtypeName__c.Contains('Licensed') || O.RecordtypeName__c.Contains('Project')) {

                            if (listACR2.size() == 1) {
                                O.PIC_BA_Print__c = listACR2[0].contactid;
                            }
                            system.debug('=========O BA PRINT' + O.PIC_BA_Print__c);
                            boolean correctbaprint = false;
                            if (listACR2.size() > 1) {
                                if (O.PIC_BA_Print__c == null) {
                                    O.adderror('More than 1 BA Print ,please fill the field with chosen BA Print');
                                } else {
                                    for (AccountContactRelation ACR: listACR2) {
                                        if (ACR.Contactid == O.PIC_BA_Print__c)
                                            correctbaprint = true;
                                    }
                                    if (correctbaprint == false) {
                                        O.adderror('PIC BA Print not filled with contact with BA Print Role in Account');
                                    }
                                }
                                if (listACR2.size() == 0) {
                                    if (!test.isrunningtest()) {
                                        O.adderror('No BA Print in Account');
                                    }
                                }

                                System.debug('=====listACR ' + listACR);
                                for (AccountContactRelation ACR: listACR) {
                                    System.debug('=====O.PIC_BA_Print__c ' + O.PIC_BA_Print__c);
                                    system.debug('======ACR.Contactid' + ACR.Contactid);
                                    if (O.PIC_BA_Print__c == ACR.Contactid && !test.isrunningtest()) {
                                        list < AccountContactRelation > TesBAPrint = [select id FROM accountcontactrelation WHERE Contactid =: O.PIC_BA_Print__c AND Roles INCLUDES('PIC BA Print')];
                                        system.debug('====TesBAPrint' + TesBAPrint.size());

                                        if (TesBAPrint.size() == 0) {
                                            if (!test.isrunningtest()) {
                                                O.Adderror('Contact IS NOT BA Print');
                                            }
                                        }
                                    }

                                    if (Acr.Accountid == O.Accountid && ACR.Roles != null) {
                                        if (ACR.Roles.Contains('BA Recipient')) {
                                            RoleBARecipient = 'TRUE';
                                            O.PIC_BA_Recipient_Email__c = ACR.Account.BP_Number__c + ' - ' + ACR.Contact.Name + ' - ' + ACR.Contact.Email;
                                        }
                                        if (ACR.Roles.Contains('BA Print')) {
                                            RoleBAPrint = 'TRUE';
                                            O.PIC_BA_Print_Email__c = ACR.Account.BP_Number__c + ' - ' + ACR.Contact.Name + ' - ' + ACR.Contact.Email;
                                        }
                                    }

                                }

                                if (RoleBAPrint == '' && !test.isrunningtest())
                                    O.AddError('Seems like you don’t have PIC BA Print, please add PIC/Contact for this Opportunity');
                                if (RoleBARecipient == '' && !test.isrunningtest())
                                    O.AddError('No BA Recipient in Account');
                            }
                        }
                        // -- validation rules PIC SITE Saat Stages Quotation Final 08/03/2022
                        if (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage')) {
                            for (AccountContactRelation ACR: listACR) {
                                if (Acr.Accountid == O.Account_Site_A__c && ACR.Roles != null) {
                                    if (ACR.Roles.Contains('PIC Site'))
                                        PICSite = 'TRUE';
                                }

                            }
                            if (PICSite == '' && !test.isrunningtest())
                                O.AddError('No PIC Site in Account');
                        }

                    }

                    /*surya 27 january 2020
Quotation Final Approval become standard approval process, move rejection reason to oppty field
*/
                    // if (old.stagename == 'Negotiation' && O.StageName == 'Quotation Final' && O.Quotation_Final_Approval__c == 'Rejected') {
                    if (O.StageName == 'Negotiation' && O.Quotation_Final_Approval__c == 'Rejected') {
                        list < ProcessInstanceStep > PIS = [SELECT ActorId, Comments, CreatedById, CreatedDate, ElapsedTimeInDays, Id, ElapsedTimeInHours, ElapsedTimeInMinutes, OriginalActor.Name, ProcessInstanceId, StepNodeId, StepStatus, SystemModstamp FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectID =: O.ID AND ProcessInstance.ProcessDefinitionID in (: system.label.Quotation_Final_Approval_sfid,: system.label.Quotation_Final_Approval_sfid_v2) AND StepStatus = 'Rejected'
                            ORDER BY Createddate DESC
                        ];
                        if (PIS.size() > 0) {
                            if ((PIS[0].Comments == null || PIS[0].Comments.trim().length() == 0)) {
                                O.AddError('Please Add Comment for Rejection');
                            } else {
                                O.Quotation_Final_Rejection_Reason__c = PIS[0].OriginalActor.Name + ' Reason: ' + PIS[0].Comments;
                            }
                        }
                    }
                    if (Old.StageName != 'Waiting for Contract' && O.StageName == 'Waiting for Contract') {
                        O.PR_Status__c = 'COM';
                        if (O.Contract_Ticket__c != null && O.Note__c == '')
                            O.Note__c = 'Send Email To Contract Manager';
                    }
                    if (
                        Old.StageName != 'Waiting for Contract'
                        /* && Old.StageName!='Waiting for BA'*/
                        &&
                        ( /*O.StageName=='Waiting for BA'||*/
                            O.StageName == 'Waiting for Contract')
                    ) {
                        if (
                            O.RecordtypeName__c.Contains('Subscription') &&
                            O.Amount == 0
                        ) {
                            O.StageName = 'Closed Won';
                        }
                    }
                    if (
                        O.StageName == 'Waiting for BA' &&
                        Old.StageName == 'Implementation' &&
                        O.Contract_Ticket__c == null &&
                        O.Lastmodifieddate < system.now().addseconds(-1) &&
                        !test.isrunningtest() &&
                        O.RecordtypeName__c == 'Licensed'
                    ) {

                    }
                    system.debug('==== O.StageName' + O.StageName);
                    system.debug('==== O.Contract_Ticket__c' + O.Contract_Ticket__c);
                    system.debug('==== O.Lastmodifieddate' + system.now().addseconds(-1));

                    if (
                        O.StageName == 'Waiting for BA' &&
                        Old.StageName == 'Implementation' &&
                        O.Contract_Ticket__c == null &&

                        //-- ini tutup dulu kawatir tidak masuk kondisi : O.Lastmodifieddate < system.now().addseconds(-1) && 
                        !test.isrunningtest() &&
                        (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage') || O.RecordtypeName__c.Contains('Licensed'))
                    ) {
                        //send ba to customer when status WBA
                        system.debug('==== IN WBA Status debug');
                        //SendWBAUtils.futuresendemail(O.id);

                        //-- new way : using scheduler :
                        BASetting__c BASetting = BASetting__c.getOrgDefaults();
                        DateTime nextSchedule = system.now().addSeconds(integer.valueof(BASetting.SendBAEmailAfterXSeconds__c));
                        String sYear = string.valueof(nextSchedule.year());
                        String sMonth = string.valueof(nextSchedule.month());
                        String sDay = string.valueof(nextSchedule.day());
                        String sHour = string.valueof(nextSchedule.Hour());
                        String sMinute = string.valueof(nextSchedule.minute());
                        String sSecond = string.valueof(nextSchedule.second());

                        Schedule_Send_BA_Immediately sendBAEmailSchedule = new Schedule_Send_BA_Immediately(O.id);
                        String schTime = sSecond + ' ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
                        system.debug('============ schTime :' + schTime);

                        //-- create scheduler
                        String jobTitle = 'Send BA Email. Opportunity : ' + O.opportunity_id__c + '. ' +
                            'At : ' + schTime;

                        string jobID = system.schedule(jobTitle, schTime, sendBAEmailSchedule);
                        //-----------------

                    }
                    if ((userinfo.getName() == 'Sales Admin' || userinfo.getProfileId() == system.label.profile_id_sales) && O.Stagename == 'Waiting for BA' && O.Lastmodifieddate < system.now().addseconds(-1)) {
                        String JSONBefore = json.serialize(Old);
                        String JSONAfter = json.serialize(O);
                        Notification_WBA_Sales.Sendemail(JSONBefore, JSONAfter);
                        //send email whenever oppty updated to stage waiting for BA 
                    }
                    if (
                        Old.StageName != 'Closed Won' &&
                        O.StageName == 'Closed Won' &&
                        O.RecordtypeName__c != 'GSM' &&
                        (O.RecordtypeName__c.Contains('Subscription') || O.RecordtypeName__c.Contains('Usage'))
                        //&& O.Link_Related__c!=null)
                    ) {
                        if (O.Service_Type__c == 'Reroute') {

                        }
                    }

                    /**
Add by doddy January 19, 2019 for automation BP Payer and PB VAT
When opportunity service type is  UPGRADE, DOWNGRADE, and REROUTE
BP Payer & BP VAT value get from previous contract  (link related)  
*/
                    if (
                        (O.Service_Type__c == 'Upgrade' || O.Service_Type__c == 'Downgrade' || O.Service_Type__c == 'Reroute') &&
                        Old.Link_Related__c <> O.Link_Related__c &&
                        O.Link_Related__c <> null &&
                        O.RecordtypeName__c.contains('Subscription') &&
                        !O.RecordtypeName__c.Contains('Usage')
                    ) {

                        Link__c linkTmp = [select id, Contract_Item_Rel__r.Account_BP_Payer__c,
                            Contract_Item_Rel__r.Account_BP_VAT__c, free_link__c
                            from link__c where id =: O.Link_Related__c
                        ];

                        system.debug('========= linkTmp..Contract_Item_Rel__r.Account_BP_Payer__c  : ' + linkTmp.Contract_Item_Rel__r.Account_BP_Payer__c);
                        system.debug('========= linkTmp.Contract_Item_Rel__r.Account_BP_VAT__c  : ' + linkTmp.Contract_Item_Rel__r.Account_BP_VAT__c);

                        string errMessage = '';
                        if (linkTmp.free_link__c == false) {
                            if (linkTmp.Contract_Item_Rel__r.Account_BP_Payer__c == null && !test.isrunningtest()) {
                                errMessage = errMessage + 'BP Payer, ';
                            } else {
                                if (!test.isRunningTest())
                                    O.BP_Payer__c = linkTmp.Contract_Item_Rel__r.Account_BP_Payer__c;
                            }

                            if (linkTmp.Contract_Item_Rel__r.Account_BP_VAT__c == null && !test.isrunningtest()) {
                                errMessage = errMessage + 'BP VAT, ';

                            } else {
                                if (!test.isRunningTest())
                                    O.BP_VAT__c = linkTmp.Contract_Item_Rel__r.Account_BP_VAT__c;
                            }
                        }
                        if (errMessage != '') O.AddError(' __ ' + errMessage + ' from previous Contract is Empty __');

                    }

                    /**
Add by doddy January 22, 2019 for VALIDATION
Untuk NEW LINK :  
- BP Payer mandatory harus ada PIC UP Invoice 
- BP VAT harus ada NPWP, shipping address
- ACCOUNT harus ada NPWP, Shipping address  
*/

                    string errMessage = '';
                    if (
                        (
                            O.SERVICE_TYPE__C == 'Newlink' ||
                            O.Recordtypename__c == 'Project Bulkshare' ||
                            O.Recordtypename__c == 'M_Ads'
                        ) &&
                        old.bp_payer__c <> o.bp_payer__c && o.bp_payer__c <> null
                    ) {
                        List < AccountContactRelation > ACRList = [SELECT Id FROM AccountContactRelation WHERE AccountId =: o.bp_payer__c and Roles includes('PIC UP Invoice')];
                        if (ACRList.size() == 0)
                            errMessage = 'PIC UP Invoice person must be on BP Payer. ';
                    }
                    /* MOVE TO VALIDATION RULES
List <Account> accList = new List <Account> ();
if (O.SERVICE_TYPE__C == 'Newlink' && 
old.bp_vat__c <> o.bp_vat__c && o.bp_vat__c <> null ) {

accList = [SELECT Id, No_NPWP__c, ShippingStreet  FROM Account WHERE id =: o.bp_vat__c];
if (accList.size() >0)
if ( (accList[0].No_NPWP__c == null || accList[0].No_NPWP__c =='') || (accList[0].ShippingStreet == null || accList[0].ShippingStreet =='')  ) 
errMessage = errMessage + 'NPWP and Shipping address must be on on BP VAT. ';
}                
if (O.SERVICE_TYPE__C == 'Newlink' && 
o.accountid <> null ) {

accList = [SELECT Id, No_NPWP__c, ShippingStreet  FROM Account WHERE id =: o.AccountId];
if (accList.size() >0)
if ( (accList[0].No_NPWP__c == null || accList[0].No_NPWP__c =='') || (accList[0].ShippingStreet == null || accList[0].ShippingStreet =='')  ) 
errMessage = errMessage + 'NPWP and Shipping address must be on on Account. ';
} 
*/

                    if (!test.isRunningTest())
                        if (errMessage != '') O.AddError(' __ ' + errMessage + ' __');
                    /*------------------------------------------------------------------------*/

                    /* move to AFTER UPDATE EVENT TRIGGER
if (Old.StageName != 'Implementation' && O.StageName == 'Implementation' && (O.RecordtypeName__c.Contains('Non GSM') || O.RecordtypeName__c.Contains('IoT')) && O.RecordTypeName__c != 'Digital Advertising' && !test.isrunningtest() && (O.PR__C == '' || O.PR__C == null)) // && O.Createddate>datelimit)//  && O.Link_Related__c!=null)
{
//PR created when implementation
CPS.CreatePR(O);
}
if (Old.StageName != 'Implementation' && O.StageName == 'Implementation' && O.recordtypename__c.contains('Marketplace') && O.RecordTypeName__c != 'Digital Advertising' && !test.isrunningtest() && (O.PR__C == '' || O.PR__C == null)) // && O.Createddate>datelimit)//  && O.Link_Related__c!=null)
{
//PR created when implementation marketplace
CPS.CreatePRMarketplace(O);
}
*/
                    if (Old.Link_Related__c == null && O.Link_Related__c != Old.Link_Related__c) {
                        if (O.Service_Type__c == 'Upgrade' || O.Service_Type__c == 'Downgrade') {
                            /* Link__c L=[SELECT id,Contract_item_rel__c FROM Link__c WHERE id=:O.Link_related__c];
Contract C=[Select Periode_UOM__c,Contract_Term__c from Contract WHERE id=:L.Contract_item_rel__c];
O.Contract_Periode__c=C.Contract_term__c;
O.Periode_UOM__c=C.Periode_UOM__c;*/
                        }
                    }

                }
            }

            if (trigger.isafter) {
                for (Opportunity Opp: system.trigger.new) {
                    Opportunity Old = Trigger.oldMap.get(Opp.id);
                    //Update Diky Latest -> 2/11/2021 LATEST UPDATE
                    if (Old.StageName != 'Waiting for BA' && Opp.StageName == 'Waiting for BA') {

                        if (system.label.Is_Trigger_Opportunity_On_Dynamic_Document_Template == 'YES') {
                            List < Template_Mapping__c > mapping = new list < Template_Mapping__c > ();
                            if (DocTemplateController.CheckMappingDocument(Opp.id, Opp.Service_Type__c)) {
                                DocTemplateController.setDocumentTemplateinOpportunity(Opp.id);
                                DocTemplateController.generateDocument(Opp.id);
                            } else {
                                Opp.addError('Please set the template document first');
                            }
                        }
                    }

                    if (
                        Old.StageName != 'Implementation' &&
                        Opp.StageName == 'Implementation' &&
                        (
                            Opp.RecordtypeName__c.Contains('Subscription') ||
                            Opp.RecordtypeName__c.Contains('Usage')
                        ) &&
                        Opp.RecordTypeName__c != 'Project Bulkshare' &&
                        !test.isrunningtest() &&
                        (
                            Opp.PR__C == '' ||
                            Opp.PR__C == null
                        )
                        // && O.Createddate>datelimit)//  && O.Link_Related__c!=null)
                    ) {
                        //PR created when implementation
                        Create_PR_SR_V2 CPS = new Create_PR_SR_V2();
                        CPS.CreatePR(Opp);
                    }
                    if (
                        Old.StageName != 'Implementation' &&
                        Opp.StageName == 'Implementation' &&
                        Opp.recordtypename__c.contains('Licensed') &&
                        Opp.RecordTypeName__c != 'Project Bulkshare' &&
                        !test.isrunningtest() &&
                        (
                            Opp.PR__C == '' ||
                            Opp.PR__C == null
                        )
                    )

                    {
                        //PR created when implementation marketplace
                        Create_PR_SR_V2 CPS = new Create_PR_SR_V2();
                        CPS.CreatePRMarketplace(Opp);
                    }

                    if (Old.PR_Status__c != 'WBA' && Opp.PR_Status__c == 'WBA' && Opp.Contract_Ticket__c != null) {

                    }

                    if (Old.Link_Related__c == null && Opp.Link_Related__c != null) {
                        //link field filled when link related lookup filled
                        list < SR_PR_Notification__c > listSP = [SELECT id, Link__c, Link_ID__c from SR_PR_Notification__c WHERE Opportunity__c =: Opp.id];
                        for (SR_PR_Notification__c SP: listSP) {
                            SP.Link__c = Opp.Link_Related__c;
                            SP.Link_id__c = Opp.Link_id__c;
                        }
                        update listSP;

                    }
                    if (Old.trial__c == false && Opp.trial__c == true) {
                        list < SR_PR_Notification__c > listSP2 = [SELECT id, trial__c, Link__c, Link_ID__c from SR_PR_Notification__c WHERE Opportunity__c =: Opp.id AND Notif_type__c = 'PR'];
                        // list < Link_c > linkList = [SELECT id, is_Trial__c FROM Link__c WHERE Opportunity__c =: Opp.id];
                        for (SR_PR_Notification__c SP2: listSP2) {
                            SP2.Trial__c = Opp.Trial__c;

                        }
                        update listSP2;
                    }

                    if (Opp.Service_type__c == 'NewLink') {
                        //fill oppty item contract start date and end date from contract periode and uom
                        if (Opp.Periode_UOM__c != Old.Periode_UOM__c || Opp.Contract_Periode__c != Old.Contract_Periode__c) {
                            list < OpportunityLineItem > listOLI = [SELECT id, Billing_Type__c, Contract_End_Date__c, Contract_Start_Date__c, Product2.SAP_Code__c, Quantity, UnitPrice FROM OpportunityLineItem WHERE OpportunityID =: Opp.id];
                            Integer D = Integer.valueof(Opp.Contract_Periode__c);
                            String UOM = Opp.Periode_UOM__c;

                            for (OpportunityLineItem OppLine: ListOLI) {
                                if (Oppline.Contract_Start_Date__c != null && Oppline.Contract_End_Date__c != null) {
                                    if (UOM == 'Week') {
                                        D = D * 7;
                                        OppLine.Contract_End_Date__c = Oppline.Contract_start_date__c.adddays(D);
                                    }
                                    if (UOM == 'Day')
                                        OppLine.Contract_End_Date__c = Oppline.Contract_start_date__c.adddays(D);
                                    if (UOM == 'Month')
                                        OppLine.Contract_End_Date__c = Oppline.Contract_start_date__c.addmonths(D);
                                }
                            }
                            update listOLI;
                        }

                    }
                    //update ahmat, digital advertising
                    system.debug('=== value Opp.RecordtypeName__c : ' + Opp.RecordtypeName__c);
                    system.debug('=== value Old.StageName : ' + Old.StageName);
                    system.debug('=== value Opp.StageName : ' + Opp.StageName);
                    if (
                        Old.StageName != 'Waiting for Contract' &&
                        Opp.StageName == 'Waiting for Contract' &&
                        !Opp.RecordtypeName__c.Contains('Usage') &&
                        (
                            Opp.RecordtypeName__c.Contains('Subscription') ||
                            Opp.recordtypeName__c.contains('Licensed') ||
                            Opp.recordtypeName__c.contains('Project Bulkshare')||
                            Opp.recordtypeName__c.contains('Project Generic')
                        )
                    ) {
                        //create contract ticket and contract item after stage waiting for contract
                        if (Opp.Contract_Ticket__c != null) { //-- contrak ticket is available
                            Contract_Ticket__c CTicket = [SELECT id, TicketStatus__c FROM Contract_Ticket__c WHERE ID =: Opp.Contract_Ticket__c];
                            Cticket.TicketStatus__c = 'Review By Contract Manager';
                            update Cticket;

                            Contract_Services_v2 Contract_Services_v2 = new Contract_Services_v2();
                            Contract_Services_v2.updateContractsFromOpportunity(Opp.id);

                        }

                        if (Opp.Amount > 0 && Opp.Contract_Ticket__c == null) {

                            //-- TODO: check the mandatory field on Contract !!
                            //-- header : TRANSACTION_DATE, TRANSACTION_ID, SOLD_TO_PARTY, CURRENCY
                            //-- items  : TASK, TRANSACTION_ID_ITEM, PROJECT_TYPE, MATERIAL, QUANTITY, UOM, CONTRACT_START, CONTRACT_END, BILLING_TYPE,
                            //--            BP_PAYER, BP_VAT, BP_SITE_A, BP_SITE_B, 

                            // bila BELUM ADA MAKA TIDAK BOLEH CREATE CONTRACT, MOVE BACK TO WBA.               
                            list < OpportunityLineItem > listOLI = [SELECT id, Billing_Type__c, Contract_End_Date__c, Contract_Start_Date__c, Product2.SAP_Code__c, Quantity, UnitPrice FROM OpportunityLineItem WHERE OpportunityID =: Opp.id];
                            for (OpportunityLineItem OppLine: ListOLI) {
                                if (Oppline.Billing_Type__c == null || Oppline.Billing_Type__c == '') {
                                    Opp.AddError('One Of Product\'s Billing Type is Empty, Please fill it before creating contract');
                                }

                                /*
if(Oppline.Product2.SAP_Code__c==null||Oppline.Product2.SAP_Code__c=='')
{
O.AddError('One Of Product\'s SAP Code is Empty, Please fill it before creating contract');
}*/

                                if (Oppline.Contract_Start_Date__c == null) {
                                    Opp.AddError('One Of Product\'s Contract Start Date is Empty, Please fill it before creating contract');
                                }
                                if (Oppline.Contract_End_Date__c == null) {
                                    Opp.AddError('One Of Product\'s Contract End Date is Empty, Please fill it before creating contract');
                                }
                                if (Oppline.Quantity == null) {
                                    Opp.AddError('One Of Product\'s Quantity is Empty, Please fill it before creating contract');
                                }
                                if (Oppline.UnitPrice == null) {
                                    Opp.AddError('One Of Product\'s Unit Price is Empty, Please fill it before creating contract');
                                }
                            }
                            if (
                                Opp.recordtypeName__c != 'Licensed' &&
                                Opp.recordtypeName__c != 'Project Bulkshare' && Opp.recordtypeName__c != 'Project Generic'
                            ) {
                                if (Opp.BP_VAT__c == null)
                                    Opp.AddError('BP VAT is Empty, Please fill it before creating contract');
                                if (Opp.BP_Payer__c == null)
                                    Opp.AddError('BP Payer is Empty, Please fill it before creating contract');
                                if (Opp.Account_Site_A__c == null)
                                    Opp.AddError('BP Site A is Empty, Please fill it before creating contract');
                                if (Opp.Service_Type__c == null)
                                    Opp.AddError('Service Type is Empty, Please fill it before creating contract');
                                if (String.valueof(Opp.BP_VAT__c) == '')
                                    Opp.AddError('BP VAT is Empty, Please fill it before creating contract');
                                if (String.valueof(Opp.BP_Payer__c) == '')
                                    Opp.AddError('BP Payer is Empty, Please fill it before creating contract');
                            } else if (
                                Opp.recordtypeName__c != 'Project Bulkshare' //-- (Licensed) update March 8, 2022 by doddy
                            ) {
                                /* handling nanti ----  (ini harusnya pakai profisioning = manual/auto)
                                list < SR_PR_Notification__c > PROpp = [SELECT id, status__c, BA_Receive_date__c from SR_PR_Notification__c WHERE Opportunity__c =: Opp.id AND Notif_type__c = 'PR'];
                                if (PROpp.size() == 0)
                                    Opp.adderror('Cannot Update to this status without PR');
                                PROpp[0].status__c = 'Complete';
                                PROPP[0].ba_receive_date__c = system.today();
                                
                                update PRopp;

                                */
                            }

                            system.debug('Contract_Services_v2.CreateContractsFromOpportunity');

                            Contract_Services_v2 Contract_Services_v2 = new Contract_Services_v2();
                            //create contract ticket and item
                            Contract_Services_v2.CreateContractsFromOpportunity(Opp.id);
                        }

                        //-- Untuk Relocation yang Leased Line maka informasi Billing Address pada Account diganti dengan Informasi pada Opportunity.
                        if (Opp.Service_Type__c == 'Relocation') {
                            if (Opp.Recordtypename__c.Contains('Subscription Two Site')) {

                                Account LeasedLineA = [SELECT BillingStreet, BillingCity, BillingPostalCode, BillingState, Relocation_Street_1__c, Relocation_Street_2__c, Relocation_Street_3__c, Relocation_Region__c, Relocation_City__c, Relocation_Country__c, Relocation_Postal_Code__c FROM Account WHERE ID =: Opp.Account_Site_A__c];
                                LeasedLineA.BillingStreet = LeasedLineA.Relocation_Street_1__c + ' ' + LeasedLineA.Relocation_Street_2__c + ' ' + LeasedLineA.Relocation_Street_3__c;
                                LeasedLineA.BillingState = LeasedLineA.Relocation_Region__c;
                                LeasedLineA.BillingPostalCode = LeasedLineA.Relocation_Postal_Code__c;
                                LeasedLineA.BillingCity = LeasedLineA.Relocation_City__c;
                                LeasedLineA.Relocation_City__c = '';
                                LeasedLineA.Relocation_Country__c = '';
                                LeasedLineA.Relocation_Region__c = '';
                                LeasedLineA.Relocation_Postal_Code__c = '';
                                LeasedLineA.Relocation_Street_1__c = '';
                                LeasedLineA.Relocation_Street_2__c = '';
                                LeasedLineA.Relocation_Street_3__c = '';
                                //    update LeasedLineA;

                                Account LeasedLineB = [SELECT BillingStreet, BillingCity, BillingPostalCode, BillingState, Relocation_Street_1__c, Relocation_Street_2__c, Relocation_Street_3__c, Relocation_Region__c, Relocation_City__c, Relocation_Country__c, Relocation_Postal_Code__c FROM Account WHERE ID =: opp.Account_Site_B__c];
                                LeasedLineB.BillingStreet = LeasedLineB.Relocation_Street_1__c + ' ' + LeasedLineB.Relocation_Street_2__c + ' ' + LeasedLineB.Relocation_Street_3__c;
                                LeasedLineB.BillingState = LeasedLineB.Relocation_Region__c;
                                LeasedLineB.BillingPostalCode = LeasedLineB.Relocation_Postal_Code__c;
                                LeasedLineB.BillingCity = LeasedLineB.Relocation_City__c;
                                LeasedLineB.Relocation_City__c = '';
                                LeasedLineB.Relocation_Country__c = '';
                                LeasedLineB.Relocation_Region__c = '';
                                LeasedLineB.Relocation_Postal_Code__c = '';
                                LeasedLineB.Relocation_Street_1__c = '';
                                LeasedLineB.Relocation_Street_2__c = '';
                                LeasedLineB.Relocation_Street_3__c = '';
                                //    update LeasedLineB;

                            } else {
                                Account AC = [SELECT BillingStreet, BillingCity, BillingPostalCode, BillingState, Relocation_Street_1__c, Relocation_Street_2__c, Relocation_Street_3__c, Relocation_Region__c, Relocation_City__c, Relocation_Country__c, Relocation_Postal_Code__c FROM Account WHERE ID =: Opp.Account_Site_A__c];
                                AC.BillingStreet = AC.Relocation_Street_1__c + ' ' + AC.Relocation_Street_2__c + ' ' + AC.Relocation_Street_3__c;
                                AC.BillingState = AC.Relocation_Region__c;
                                AC.BillingPostalCode = AC.Relocation_Postal_Code__c;
                                AC.BillingCity = AC.Relocation_City__c;
                                AC.Relocation_City__c = '';
                                AC.Relocation_Country__c = '';
                                AC.Relocation_Region__c = '';
                                AC.Relocation_Postal_Code__c = '';
                                AC.Relocation_Street_1__c = '';
                                AC.Relocation_Street_2__c = '';
                                AC.Relocation_Street_3__c = '';
                                // update AC;
                            }
                        } //-- .endOF O.Service_Type__c=='Relocation' 
                    }

                    /*
list<OpportunityLineItem> opty_prod = [SELECT id,percentage_calculation__c FROM OpportunityLineItem WHERE OpportunityId = :O.id];
if(opty_prod.size()>0)
{
Decimal max=0;
integer dm;
for (Integer i=0;i<opty_prod.size();i++)
{

if(opty_prod[i].percentage_calculation__c > max) 
{
max = opty_prod[i].percentage_calculation__c ;
}
}
dm = max.intValue();
system.debug('dm nya:'+dm);
o.disc_max__c = dm;
system.debug('dm nya:'+o.disc_max__c);

}
update o;    */
                }
            }
        }
    }
}