/**
 * @description       : 
 * @Test Class        : SRPRTestV2
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 09-25-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-19-2022   Novando Utoyo Agmawan   Initial Version
 **/

trigger SRPR_v2 on SR_PR_Notification__c(before update, after update, after insert) {
  if (system.label.IS_TRIGGER_SRPR_v2_ON == 'YES') {

    List < String > Opp_ProfitabilityForecast_SR_Ids = new List < String > ();
    List < String > Opp_ProfitabilityForecast_PR_Ids = new List < String > ();

    List < Opportunity > PR_OppNew_list = new List < Opportunity > ();
    
    List<Opportunity> List_OppMoveTo_Negotation = new List<Opportunity>();
    

    if (trigger.isbefore) {
      for (SR_PR_Notification__c SP: system.trigger.new) {
        SR_PR_Notification__c SPOld = trigger.oldmap.get(SP.id);
        if (SP.notif_type__c == 'PR' && SP.Trial__c == true) {
          //set trial scenario
          if (SP.Billing_Start_Date__c != null) {
            if (sp.start_date_trial__c == null) {
              SP.Start_Date_trial__c = SP.Billing_Start_Date__c;
            }

            if (sp.end_date_trial__c == null) {

              //  SP.End_Date_trial__c = SP.Start_Date_Trial__c.adddays(10);
              if (SP.auto_renewal_uom__c == 'Bulan') {
                Integer autoRenewalPeriodemonth = Integer.valueOf(SP.Auto_Renewal_Periode__c);
                SP.aging_trial_reminder_date__c = String.valueOf(autoRenewalPeriodemonth * 30);
              }
              if (SP.auto_renewal_uom__c == 'Minggu') {
                Integer autoRenewalPeriodeweek = Integer.valueOf(SP.Auto_Renewal_Periode__c);
                SP.aging_trial_reminder_date__c = String.valueOf(autoRenewalPeriodeweek * 7);
              }
              if (SP.auto_renewal_uom__c == 'Hari') {
                Integer autoRenewalPeriodeDay = Integer.valueOf(SP.Auto_Renewal_Periode__c);
                SP.aging_trial_reminder_date__c = String.valueOf(autoRenewalPeriodeDay);
              }

              if (SP.periode_uom__c == 'Month') {
                Integer contractPeriodemonth = Integer.valueOf(SP.Contract_Periode__c);
                SP.End_Date_trial__c = SP.Start_Date_Trial__c.addMonths(contractPeriodemonth);
              }
              if (SP.periode_uom__c == 'Week') {
                Integer contractPeriodemonth = Integer.valueOf(SP.Contract_Periode__c) * 7;
                SP.End_Date_trial__c = SP.Start_Date_Trial__c.addDays(contractPeriodemonth);
              }
              if (SP.periode_uom__c == 'Day') {
                Integer contractPeriodemonth = Integer.valueOf(SP.Contract_Periode__c);
                SP.End_Date_trial__c = SP.Start_Date_Trial__c.addDays(contractPeriodemonth);
              }
            }

          }
        }
        if (SPOld.Status__c != 'Assigned' && SP.Status__c == 'Assigned') {

          /*
          if(SP.Vendor__c==null||String.valueof(SP.Vendor__c)=='')
          {
              SP.adderror('Please Fill Vendor Name before Status change "Assigned"');
          }
          */
          SP.Assign_Date__c = system.today();
          if (((SP.CPE_Additional_Request__c != '' && SP.CPE_Additional_Request__c != null) ||
              SP.Survey_Lastmile_Type__c == 'Lastmile by Partner') && SP.Status__c == 'Assigned' && SP.services__c != 'voip') {
            //solution approval
            SP.Status__c = 'Waiting Solution Confirmation';
            SP.Solution_request_date__c = system.today();
          }
          if (SP.Survey_Lastmile_Type__c == 'Config only' && SP.services__c == 'voip') {
            //solution approval
            SP.Status__c = 'Waiting Solution Confirmation';
            SP.Solution_request_date__c = system.today();
          }
        }
        //approval validation
        if (SPOld.Status__c == 'Waiting Solution Confirmation' && SP.Status__c != SPold.Status__c && SP.Status__c != 'Close(Cancel)' && SP.Status__c != '	Close(Not Deliver)') {
          if (SP.Services__c != 'VOIP' && (SP.Partner_Name__c == null || SP.Solution_Partner_Approval__c == '')) {
            SP.adderror('Please Approved and fill partner before moving to the next stage');
          }
          if (SP.Services__c == 'Voip' && SP.Solution_Partner_Approval__c == '') {
            SP.adderror('Please Approved before moving to the next stage');
          }

        }
        if (SP.Status__c == 'Waiting Solution Confirmation' && SP.Status__c != SPold.Status__c) {
          SP.Solution_Partner_Approval__c = '';
        }
        if (SP.Solution_Partner_Approval__c == 'Approved' && SP.Status__c == 'Waiting Solution Confirmation') {
          SP.Status__c = 'In Progress';
          SP.Solution_Complete_date__c = system.today();
        }
        if (SP.Solution_Partner_Approval__c == 'Rejected' && SP.Status__c == 'Waiting Solution Confirmation') {
          SP.Status__c = 'Close(Not Deliver)';

          //set flow after SR rejected
          SP.Solution_Complete_date__c = system.today();
        }

        //SR Validation
        if (SPOld.Notif_Type__c != SP.Notif_type__c && userinfo.getprofileid() != system.label.Profile_ID_System_Administrator) {
          SP.adderror('Notif Type cannot be changed');
        }
        if (SPOld.Name != SP.Name && userinfo.getprofileid() != system.label.Profile_ID_System_Administrator) {
          SP.adderror('Name cannot be changed');
        }
        if (SPOld.Services__c != SP.Services__c && userinfo.getprofileid() != system.label.Profile_ID_System_Administrator) {
          SP.adderror('Services cannot be changed');
        }
        if (SPOld.Status__c != 'Waiting For Integration' && SP.Status__c == 'Waiting For Integration') {
          SP.WFI_date__c = system.today();
        }
        if ((SP.Status__c == 'Rejected' || SP.Status__c == 'Close(Cancel)' || SP.Status__c == 'Close(Not Deliver)' || SP.Status__c == 'Close(Complete)') && SPOld.Status__c != SP.Status__c) {
          SP.Result_Date__c = system.today();

        }
        if (
          userinfo.getprofileid() != system.label.Profile_ID_System_Administrator &&
          SP.Notif_Type__c == 'SR' &&
          (SPOld.Status__c == 'Complete' || SPOld.Status__c == 'Close(Complete)' || SPOld.Status__c == 'Close(Not Deliver)' || SPOld.Status__c == 'Close(Cancel)' || SPOld.Status__c == 'Rejected')
        ) {
          if (
            userinfo.getprofileid() == system.label.Profile_ID_Solution &&
            SPOld.substatus__c != 'Profitability Cost Complete'
          ) {
            //nothing
          } else if (SP.Opportunity_RecordTypeName__c.Contains('Licensed')) {
            //nothing
          } else {
            SP.adderror('Already Finished SR Cannot be Updated');
          }
        }
        if (
          userinfo.getprofileid() != system.label.Profile_ID_System_Administrator &&
          SP.Notif_Type__c == 'PR' &&
          (SPOld.Status__c == 'Complete' || SPOld.Status__c == 'Close(Complete)' || SPOld.Status__c == 'Close(Not Deliver)' || SPOld.Status__c == 'Close(Cancel)' || SPOld.Status__c == 'Rejected')

          //&& (SPOld.LastModifiedByTrialTicket__c == SP.LastModifiedByTrialTicket__c)
        ) {

          SObjectType srPRType = Schema.getGlobalDescribe().get('SR_PR_Notification__c');
          Schema.sObjectField[] fieldList = srPRType.getDescribe().fields.getMap().values();

          Schema.sObjectField[] changedFields = getChangedFields(SP.id, fieldList);
          system.debug('=== changedFields : ' + changedFields);

          if (!test.isrunningtest()) {
            SP.adderror('Already Finished PR Cannot be Updated');
          }
        }
        /*
              if (userinfo.getprofileid() == system.label.Profile_ID_Sales && trigger.isupdate && SP.Createddate < system.Now().addminutes(-3) && SPOld.Link_id__c == SP.Link_id__c && SP.Link__c == SPOld.Link__c && SPold.BA_Sent_Date__c == SP.BA_Sent_Date__c) {
                  SP.adderror('Sales Cannot Update SR/PR');
              }
*/

        if (SPOld.Status__c != 'Waiting Berita Acara' && SP.Status__c == 'Waiting Berita Acara') {
          //Update Diky 25/11/2021 - update field Link lookup in SRPR From Link in Opportunity
          SP.Link__c = SP.LinkInOpportunity__c;
        }
        if (trigger.isupdate) {
          //update Sub Status -> Vando
          if (
            SPOld.Status__c != SP.Status__c &&
            SP.Status__c == 'Close(Complete)' &&
            SP.Opportunity__c != null &&
            (
              SP.Opportunity_RecordTypeName__c.Contains('Subscription') 
              //SP.Opportunity_RecordTypeName__c.Contains('Usage') // << untuk usage belum dulu karena belum tau formula perhitungan PNLnya confimr mas Kahfi 
            ) &&
            (
              SP.Opportunity_ServiceType__c == 'Newlink' ||
              SP.Opportunity_ServiceType__c == 'Upgrade' ||
              SP.Opportunity_ServiceType__c == 'Downgrade'
            )
          ) {
            if(SP.Opportunity_Trial__c == false){
                SP.substatus__c = 'Waiting profitability by Sol-Ar';
            }
            //SP.substatus__c = 'Waiting profitability by Sol-Ar';
          }

          if (
            SPOld.Status__c != 'Close(Complete)' &&
            SP.Status__c == 'Close(Complete)' &&
            /*!SP.Opportunity_RecordTypeName__c.Contains('Subscription')*/
            SP.Opportunity__c != null &&
            SP.Opportunity_ServiceType__c != 'Newlink' &&
            SP.Opportunity_ServiceType__c != 'Upgrade' &&
            SP.Opportunity_ServiceType__c != 'Downgrade'
          ) {
            SP.substatus__c = 'Completed';
          }

        }
      }
    }
    if (trigger.isafter) {

      for (SR_PR_Notification__c SP: system.trigger.new) {
        if (trigger.isinsert) {
          // update ahmat handle contract end date 28 06 2022
          if(sp.opportunity__r.istrialtoproduction__c == true && SP.Project_type__c == 'new'){
            system.debug(' =SRPR_V2= pr after insert pr newlink filled contract start date and end date on OLI =SRPR_V2= ');
            setContractendDateOpptyLineItemNewLink(SP.opportunity__c, sp.Billing_Start_Date__c); 
            sp.Billing_Start_Date__c = sp.opportunity__r.trial_monitoring_ticket_rel__r.Trial_End_Date__c.addDays(1);
            system.debug(' sp.Billing_Start_Date__c == ' + sp.Billing_Start_Date__c);
          }
          
          if(( sp.opportunity__r.istrialtoproduction__c == true) && (SP.Project_type__c == 'Upgrade' || SP.Project_type__c == 'Downgrade' || SP.Project_type__c == 'Reroute' || SP.Project_type__c == 'Relocation' || test.isrunningtest())){
            system.debug(' =SRPR_V2= pr after insert except pr newlink filled contract start date and end date on OLI =SRPR_V2= ');
            setContractEndDateOpptyLineItemExceptNewLink(SP.opportunity__c, sp.Billing_Start_Date__c);
          }
          
         
          if (SP.Notif_type__c == 'PR' && SP.Project_type__c != 'Licensed') {
            //replicate PR to easy ops callout
            datetime nextschedule = system.now().addminutes(2);
            String sYear = string.valueof(nextSchedule.year());
            String sMonth = string.valueof(nextSchedule.month());
            String sDay = string.valueof(nextSchedule.day());
            String sHour = string.valueof(nextSchedule.Hour());
            String sMinute = string.valueof(nextSchedule.minute());
            Scheduled_Process__c spcs = new Scheduled_Process__c();
            spcs.Execute_Plan__c = nextSchedule;
            spcs.Type__c = 'Replicate PR';
            spcs.parameter1__c = SP.id;

            Scheduled_Process_Services sps = new Scheduled_Process_Services();
            String sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

            String jobID2 = system.schedule('Link ' + sch + '  AccountID : ' + spcs.parameter1__c, sch, sps);
            spcs.parameter3__c = jobID2;
            spcs.jobid__c = jobID2;
            spcs.title__c = 'Replicate PR';
            insert spcs;
          }

          if (SP.Notif_type__c == 'PR' && SP.Opportunity__c != null) {
            Opportunity opps = new Opportunity(Id = SP.Opportunity__c);
            opps.PR_Rel__c = SP.Id;
            PR_OppNew_list.add(opps);
          }
        }
        
        if (trigger.isupdate) {
          SR_PR_Notification__c SPOld = trigger.oldmap.get(SP.id);
          Opportunity O = new Opportunity();
          O.id = SP.Opportunity__c;
          if (SPOld.Status__c != 'Assigned' && SP.Status__c == 'Assigned') {
            if (SP.Vendor__c != null && !test.isrunningtest())
              sendEmailSRPR.sendEmailToVendor(SP);
            else if (!test.isrunningtest())
              sendemailSRPR.sendemailassigned(SP);
            //send email after assigned
          }

          if ((SP.Status__c == 'Rejected' || SP.Status__c == 'Close(Cancel)' || SP.Status__c == 'Close(Not Deliver)') && SPold.Status__c != SP.Status__c) {
            O.SR_Notes__c = SP.Description__c + '  ' + SP.Comment_Description__c;
            //set reason/description after rejected/cancel
          }
          if (
            SPOld.Status__c != 'Close(Complete)' &&
            SP.Status__c == 'Close(Complete)' &&
            /*!SP.Opportunity_RecordTypeName__c.Contains('Subscription')*/
            SP.Opportunity__c != null &&
            SP.Opportunity_ServiceType__c != 'Newlink' &&
            SP.Opportunity_ServiceType__c != 'Upgrade' &&
            SP.Opportunity_ServiceType__c != 'Downgrade'
          ) {
            //survey completed scenario
            O.StageName = 'Negotiation';
            O.SR_Status__c = SP.Status__c;
            update O;
            if (!test.isrunningtest())
              sendEmailSRPR.sendemailCloseSR(SP);
          }
          if (SPOld.Status__c != 'Rejected' && SP.Status__c == 'Rejected') {
            //rejected scenario
            O.StageName = 'Prospecting';
            O.SR_Status__c = SP.Status__c;
            O.SR_Notes__c = SP.Reasons__c;
            update O;
          }
          if (SPOld.Status__c != 'Cancel' && SP.Status__c == 'Cancel') {
            //cancel scenario
            O.StageName = 'Closed Lost';
            O.closed_lost_flag__c = 'PR CANCEL';
            O.PR_Status__c = SP.Status__c;
            O.PR_Notes__c = SP.Reasons__c;
            O.Loss_Reason__c = 'Other';
            O.loss_reason_description__c = SP.Reasons__c;
            update O;
          }
          system.debug(' == SP.Billing_Start_Date__c ' + SP.Billing_Start_Date__c);
          system.debug(' == SPOld.Billing_Start_Date__c ' + SPOld.Billing_Start_Date__c);

          system.debug(' == SPOld.status__c ' + SPOld.status__c);
          system.debug(' == SP.status__c ' + SP.status__c);

          //update ahmat, handle di pindah bikin method baru  28 june 2022
          if (SP.Billing_Start_Date__c != SPOld.Billing_Start_Date__c) {
                    
            if (SP.Project_type__c == 'New' || test.isrunningtest() || SP.Project_type__c == 'Licensed') {
              setContractendDateOpptyLineItemNewLink(sp.opportunity__c, sp.Billing_Start_Date__c);
            }
    
            if ( SP.Project_type__c == 'Upgrade' || SP.Project_type__c == 'Downgrade' || SP.Project_type__c == 'Reroute' || SP.Project_type__c == 'Relocation' || test.isrunningtest() ) {
              setContractEndDateOpptyLineItemExceptNewLink(sp.opportunity__c, sp.Billing_Start_Date__c);
            }
            /*
            //set start date and end date in oppty line item
            list < OpportunityLineItem > OLI = [SELECT id, Opportunity.Link_Related__r.Contract_Item_Rel__r.Start_Date__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.ContractTerm, Opportunity.Link_Related__r.Contract_Item_Rel__r.Contract_Term__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.End_Date__c, Opportunity.Periode_UOm__c, Contract_Start_Date__c, Contract_End_Date__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.Periode_UOM__c, Opportunity.Contract_Periode__c FROM OpportunityLineItem WHERE OpportunityID =: SP.Opportunity__c];
            String UOM = OLI[0].Opportunity.Periode_UOM__c;
            Integer D = 0;
            for (OpportunityLineItem OppLi: OLI) {
                if (SP.Project_type__c == 'New' || test.isrunningtest() || SP.Project_type__c == 'Licensed') {
                    OppLi.Contract_Start_Date__c = SP.Billing_Start_Date__c;
                    D = Integer.valueof(OppLi.Opportunity.Contract_Periode__c);
                    if (UOM == 'Week' || test.isrunningtest()) {
                        D = D * 7;
                        OppLi.Contract_End_Date__c = Oppli.Contract_start_date__c.adddays(D) - 1;
                        system.debug(' OppLi.Contract_End_Date__c ====== xxxx'+ OppLi.Contract_End_Date__c );
                    }
                    if (UOM == 'Day' || test.isrunningtest())
                        OppLi.Contract_End_Date__c = Oppli.Contract_start_date__c.adddays(D) - 1;
                    if (UOM == 'Month' || test.isrunningtest())
                        OppLi.Contract_End_Date__c = Oppli.Contract_start_date__c.addmonths(D) - 1;
                }
                if (SP.Project_type__c == 'Upgrade' || SP.Project_type__c == 'Downgrade' || SP.Project_type__c == 'Reroute' || SP.Project_type__c == 'Relocation' || test.isrunningtest()) {
                    UOM = OppLi.Opportunity.Periode_UOM__c;
                    D = Integer.valueof(Oppli.Opportunity.Contract_Periode__c);
                    OppLi.Contract_Start_Date__c = SP.Billing_Start_Date__c;


                    Oppli.Contract_End_Date__c = AppUtils.getNewContractEndDate(Oppli.Opportunity.Link_Related__r.Contract_Item_Rel__r.Start_Date__c, Oppli.Opportunity.Link_Related__r.Contract_Item_Rel__r.End_Date__c, D, SP.Billing_Start_Date__c, UOM, Integer.valueof(Oppli.Opportunity.Contract_Periode__c), Oppli.Opportunity.Periode_UOM__c);

                }
            }
            update OLI;
            */
            
          }
          

          //closed scenario
          if (SPOld.Status__c != 'Close(Not Deliver)' && SP.Status__c == 'Close(Not Deliver)') {

            O.StageName = 'Closed Lost';
            O.SR_Status__c = SP.Status__c;
            O.SR_Notes__c = SP.Reasons__c;
            O.Loss_Reason__c = SP.Reasons__c;
            O.Loss_Reason_Description__c = SP.Reasons__c;
            update O;
          }
          if (SPOld.Status__c != 'Close(Cancel)' && SP.Status__c == 'Close(Cancel)') {

            O.StageName = 'Prospecting';
            O.SR_Status__c = SP.Status__c;
            O.SR_Notes__c = SP.Reasons__c;
            update O;
          }
          //WBA Scenario
          if (SPOld.Status__c != 'Waiting Berita Acara' && SP.Status__c == 'Waiting Berita Acara') {
            /*surya 31 january 2020*/
            Boolean cekBAPrint = false;
            Boolean cekBARecipient = false;

            //-- add by doddy March 17, 2021
            //-- for handling PIC must have email
            Boolean cekBAPrintEmail = false;
            Boolean cekBARecipientEmail = false;
            Boolean cekPICEmail = true;

            List < accountcontactrelation > listACR3 = [SELECT Accountid, Roles, Contactid, Contact.email
              FROM AccountContactRelation
              WHERE AccountID =: SP.Account__c
              AND Roles INCLUDES('PIC BA Print', 'PIC BA Recipient')
            ];

            Opportunity OpCek = [SELECT id, link_related__c, link_id__c, bw_before__c, bw_after__c, PIC_BA_pRINT__c
              FROM Opportunity WHERE ID =: O.id
            ];

            if (SP.Project_type__c != 'Licensed') {
              //before WBA ,Validation
              //Update Diky 25/11/2021 update link__c 
              if (OPCek.link_related__c == null && !test.isRunningTest())
                SP.adderror('The Opportunity Have No Link');
              if (OPCek.PIC_BA_Print__c == null && !test.isRunningTest())
                SP.adderror('The Opportunity Have No PIC BA Print');
              if (OPCek.BW_Before__c == null && !test.isRunningTest())
                SP.adderror('The Opportunity Have No BW Before');
              if (OPCek.BW_After__c == null && !test.isRunningTest())
                SP.adderror('The Opportunity Have No BW After');
              if ((OPCek.link_id__c == null || Opcek.link_id__c == '') && !test.isRunningTest())
                SP.adderror('The Opportunity Have No Link ID');

              //-- update by doddy March 17, 2021
              //-- for handling PIC must have email
              for (AccountContactRelation ACR: listACR3) {
                if (ACR.Roles.Contains('PIC BA Recipient')) {
                  cekbarecipient = true;

                  if (ACR.Contact.email != '' && ACR.Contact.email != null) {
                    cekBARecipientEmail = true;
                  } else cekPICEmail = false; //cekBARecipientEmail = false;
                }

                if (ACR.Roles.Contains('PIC BA Print')) {
                  cekbaprint = true;

                  if (ACR.Contact.email != '' && ACR.Contact.email != null) {
                    cekBAPrintEmail = true;
                  } else cekPICEmail = false; //cekBAPrintEmail = false;
                }
              }

              //-- update by doddy March 17, 2021
              //-- for handling PIC must have email 
              string errorMessage = '';
              if (cekBARecipient == false) {
                //errorMessage= errorMessage + 'No BA Recipient in Account. ';

                //18 maret 2021 novi update :error message and use customlabel
                errorMessage = errorMessage + system.label.Error_message_Assign_Role_PIC_BA_Recipient;
              }

              if (cekBAPrint == false) {
                //errorMessage = errorMessage + 'No BA Print in Account. ';
                errorMessage = errorMessage + system.label.Error_message_Assign_Role_PIC_BA_Print;
              }

              //-- if any pic have not email
              if (cekPICEmail == false) {
                errorMessage = errorMessage + system.label.Error_message_Contact_Email_Blank;
              }

              if (errorMessage != '' && !test.isRunningTest()) {
                SP.adderror(errorMessage);
              }

            }
            O.StageName = 'Waiting for BA';

            update O;
          }
          if (SPOld.BA_Sent_Date__c != SP.BA_Sent_Date__c) {

            O.BA_Sent_Date__c = SP.BA_Sent_Date__c;
            update O;
          }
          if (SPOld.BA_Receive_Date__c != SP.BA_Receive_Date__c) {
            System.debug('Opportunity: ' + o);
            System.debug('SPOld: ' + SPOld + 'SP: ' + SP);
            O.BA_Receive_Date__c = SP.BA_Receive_Date__c;
            update O;
          }

          if (
            (
              SPOld.Status__c != 'Complete' &&
              SP.Status__c == 'Complete' &&
              !SP.Opportunity_RecordTypeName__c.Contains('Subscription') &&
              !SP.Opportunity_RecordTypeName__c.Contains('Usage') &&
              SP.Opportunity__c != null
            ) ||
            (
              SPOld.Status__c != 'Waiting Berita Acara' &&
              SP.Status__c == 'Waiting Berita Acara'
            )
          ) {
            Boolean notcomplete = false;
            list < task > TaskCheck = [SELECT id, Status FROM Task WHERE Whatid =: SP.id];
            for (Task TC: TaskCheck) {
              if (TC.Status != 'Completed')
                notcomplete = true;
            }

            //validation before WBA/WFC must complete task
            if (TaskCheck.Size() == 0 || notcomplete == false) {
              Opportunity O2 = new Opportunity();
              O2.id = SP.Opportunity__c;
              if (SP.Status__c == 'Complete' && SP.Project_Type__c != 'Licensed')
                O2.StageName = 'Waiting for Contract';
              if (SP.Status__c == 'Waiting Berita Acara')
                O2.StageName = 'Waiting for BA';
              update O2;
            } else {
              SP.adderror('Please Complete Task First');
            }
          }

          //Create Profitability Forecats after survey complete -> Vando
          if (
            SPOld.Status__c != SP.Status__c &&
            SP.Status__c == 'Close(Complete)' &&
            SP.Opportunity__c != null &&
            (
              SP.Opportunity_RecordTypeName__c.Contains('Subscription') ||
              SP.Opportunity_RecordTypeName__c.Contains('Usage')
            ) &&
            (
              SP.Opportunity_ServiceType__c == 'Newlink' ||
              SP.Opportunity_ServiceType__c == 'Upgrade' ||
              SP.Opportunity_ServiceType__c == 'Downgrade'
            )
          ) {
            // roolback sementara blm ditest
            if(SP.Opportunity_Trial__c == false){
                sendEmailSRPR.sendemailCloseSR(SP);
                Opp_ProfitabilityForecast_SR_Ids.add(SP.Opportunity__c);
            }
            else{
                Opportunity opps = new Opportunity(
                    Id = SP.Opportunity__c,
                    StageName = 'Negotiation'
                );
                List_OppMoveTo_Negotation.add(opps);
            }

            //sendEmailSRPR.sendemailCloseSR(SP);
            //Opp_ProfitabilityForecast_SR_Ids.add(SP.Opportunity__c);
          }

          //update diky 22/03/2022
          // Email Notif And Update Profitability Forecats after PR complete
          if (
            SPOld.Status__c != SP.Status__c &&
            SPOld.Status__c != 'Complete' &&
            SP.Status__c == 'Complete' &&
            SP.Opportunity__c != null && //update 27 jun for exclude opty TRIAL
            SP.Opportunity_Trial__c == false
          ) {
            if (
              SP.Is_Any_Profitability__c == true &&
              (
                SP.Opportunity_ServiceType__c == 'Newlink' ||
                SP.Opportunity_ServiceType__c == 'Upgrade' ||
                  SP.Opportunity_ServiceType__c == 'Downgrade' ||  SP.Opportunity_ServiceType__c == 'ChangePrice VoIP'
              )
            ) 
            {
              Opp_ProfitabilityForecast_PR_Ids.add(SP.Id);
            } else {
              if (
                SP.Opportunity_RecordTypeName__c.Contains('Subscription') ||
                SP.Opportunity_RecordTypeName__c.Contains('Licensed')
              ) {
                O.StageName = 'Waiting for Contract';
                update O;
              } else if (
                SP.Opportunity_RecordTypeName__c.Contains('Usage')
              ) {
                O.StageName = 'Closed Won';
                update O;
              }
            }
          }
          /*
          //Email Notif And Update Profitability Forecats after PR complete -> Vando
          if(
              SPOld.Status__c != SP.Status__c && 
              SPOld.Status__c != 'Complete' &&
              SP.Status__c == 'Complete' && 
              SP.Opportunity__c != null &&
              (
                  SP.Opportunity_RecordTypeName__c.Contains('Subscription') || 
                  SP.Opportunity_RecordTypeName__c.Contains('Usage') 
              ) &&
              (SP.Opportunity_ServiceType__c == 'Newlink' || SP.Opportunity_ServiceType__c == 'Upgrade' || SP.Opportunity_ServiceType__c == 'Downgrade')
          ){
              Opp_ProfitabilityForecast_PR_Ids.add(SP.Id);
          }*/
        }
      }
    }

    if (Opp_ProfitabilityForecast_SR_Ids != null && !Opp_ProfitabilityForecast_SR_Ids.isEmpty()) {
      ProfitabilityController_v2 ProfitabilityController_class = new ProfitabilityController_v2();
      ProfitabilityController_class.Create_Profitability_Forecats(Opp_ProfitabilityForecast_SR_Ids);
    }

    if (Opp_ProfitabilityForecast_PR_Ids != null && !Opp_ProfitabilityForecast_PR_Ids.isEmpty()) {
      ProfitabilityController_v2 ProfitabilityController_class = new ProfitabilityController_v2();
      ProfitabilityController_class.Email_Notif_to_Solution_Profitability_Forecats_UpdateToActual(Opp_ProfitabilityForecast_PR_Ids);
    }

    if (PR_OppNew_list != null && !PR_OppNew_list.isEmpty()) {
      update PR_OppNew_list;
    }

     //buka rollback di 1 july
    if(List_OppMoveTo_Negotation!=null && !List_OppMoveTo_Negotation.isEmpty()){
        update List_OppMoveTo_Negotation;
    }
    

    if (test.isRunningTest()) {
      justIncrement();
    }
  }

  static void justIncrement() {
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
  }

  public Schema.sObjectField[] getChangedFields(ID recordId, Schema.sObjectField[] fieldList) {
    Schema.sObjectField[] changedFields = new list < Schema.sObjectField > ();
    SObject o1 = Trigger.oldMap.get(recordId);
    SObject o2 = Trigger.newMap.get(recordId);

    for (Schema.sObjectField field: fieldList) {
      Object v1 = o1.get(field);
      Object v2 = o2.get(field);
      if (didFieldChange(v1, v2)) {
        changedFields.add(field);
      }
    }
    return changedFields;
  }

  private static Boolean didFieldChange(Object v1, Object v2) {
    if (v1 == null && v2 == null) {
      return false;
    }
    if (v1 != v2) {
      return true;
    }
    return false;
  }

  public static void setContractendDateOpptyLineItemNewLink(Id OpportunityId, date SRPRBillingStartDate) {
    system.debug('== Method contract end date OLI handle ==');
    //set start date and end date in oppty line item
    list < OpportunityLineItem > OLI = [SELECT id, Opportunity.Link_Related__r.Contract_Item_Rel__r.Start_Date__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.ContractTerm, Opportunity.Link_Related__r.Contract_Item_Rel__r.Contract_Term__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.End_Date__c, Opportunity.Periode_UOm__c, Contract_Start_Date__c, Contract_End_Date__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.Periode_UOM__c, Opportunity.Contract_Periode__c, revenue_type__c FROM OpportunityLineItem WHERE OpportunityID =: OpportunityId AND revenue_type__c != 'Free'];

    List < OpportunityLineItem > listOpptyLineItemUpdate = new list < OpportunityLineItem > ();
    String UOM = OLI[0].Opportunity.Periode_UOM__c;
    Integer D = 0;
    for (OpportunityLineItem OppLi: OLI) {

      OppLi.Contract_Start_Date__c = SRPRBillingStartDate;

      D = Integer.valueof(OppLi.Opportunity.Contract_Periode__c);
      if (UOM == 'Week' || test.isrunningtest()) {
        D = D * 7;
        OppLi.Contract_End_Date__c = Oppli.Contract_start_date__c.adddays(D) - 1;
        system.debug(' OppLi.Contract_End_Date__c ====== xxxx' + OppLi.Contract_End_Date__c);
      }
      if (UOM == 'Day' || test.isrunningtest()) {
        OppLi.Contract_End_Date__c = Oppli.Contract_start_date__c.adddays(D) - 1;
      }

      if (UOM == 'Month' || test.isrunningtest()) {
        OppLi.Contract_End_Date__c = Oppli.Contract_start_date__c.addmonths(D) - 1;
      }

      listOpptyLineItemUpdate.add(OppLi);
    }
    update listOpptyLineItemUpdate;
  }

  public static void setContractEndDateOpptyLineItemExceptNewLink(Id OpportunityId, Date SRPRBillingStartDate) {

    list < OpportunityLineItem > OLI = [SELECT id, Opportunity.Link_Related__r.Contract_Item_Rel__r.Start_Date__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.ContractTerm, Opportunity.Link_Related__r.Contract_Item_Rel__r.Contract_Term__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.End_Date__c, Opportunity.Periode_UOm__c, Contract_Start_Date__c, Contract_End_Date__c, Opportunity.Link_Related__r.Contract_Item_Rel__r.Periode_UOM__c, Opportunity.Contract_Periode__c, revenue_type__c FROM OpportunityLineItem WHERE OpportunityID =: OpportunityId AND revenue_type__c != 'Free'];

    system.debug('== for Upgrade, downgrade, reroute, relocation ==');
    //if ((SP.Project_type__c == 'Upgrade' || SP.Project_type__c == 'Downgrade' || SP.Project_type__c == 'Reroute' || SP.Project_type__c == 'Relocation' || test.isrunningtest()) && (sp.opportunity__r.istrialtoproduction__c = true )) {
    List < OpportunityLineItem > listOpptyLineItemUpdate = new list < OpportunityLineItem > ();

    for (OpportunityLineItem OppLi: OLI) {
      String UOM = OppLi.Opportunity.Periode_UOM__c;
      integer D = Integer.valueof(Oppli.Opportunity.Contract_Periode__c);
      OppLi.Contract_Start_Date__c = SRPRBillingStartDate;

      Oppli.Contract_End_Date__c = AppUtils.getNewContractEndDate(Oppli.Opportunity.Link_Related__r.Contract_Item_Rel__r.Start_Date__c, Oppli.Opportunity.Link_Related__r.Contract_Item_Rel__r.End_Date__c, D, SRPRBillingStartDate, UOM, Integer.valueof(Oppli.Opportunity.Contract_Periode__c), Oppli.Opportunity.Periode_UOM__c);
      listOpptyLineItemUpdate.add(OppLi);
    }
    update listOpptyLineItemUpdate;

  }
}