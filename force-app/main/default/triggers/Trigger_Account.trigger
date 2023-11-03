/**
* @description       : 
* @Test Class        : TestHitSoapAccountContact
* @author            : -
* @group             : 
* @last modified on  : 11-25-2022
* @last modified by  : Novando Utoyo Agmawan
* Modifications Log
* Ver   Date         Author                  Modification
* 1.0   07-28-2022   Novando Utoyo Agmawan   Initial Version
* 1.1   30-09-2022   Doddy Prima             update bypass methode using custom settings trigger_controller___c
**/

trigger Trigger_Account on Account (after insert, after update, before insert, before update) {
    Boolean execute = false;

    List<Trigger_Controller__c> triggerControllerList = Trigger_Controller__c.getall().values();

    Map<string, boolean> isActiveTriggerMap = new Map<string, boolean> (); 
    for (Trigger_Controller__c  triggerCntr : triggerControllerList) {
        isActiveTriggerMap.put (triggerCntr.name, triggerCntr.Is_Active__c);
    } 

    if (isActiveTriggerMap.get ('Trigger_Account') <> null) {
        if (isActiveTriggerMap.get ('Trigger_Account') == TRUE) {
            execute = TRUE;
        }
    }


    //if(system.label.Is_Trigger_Account_On=='YES')
    if (execute)
    {
        list<Scheduled_Process__c> listSP=new list<Scheduled_Process__c>();
        datetime nextschedule=system.now().addminutes(2);
        String sYear = string.valueof( nextSchedule.year() );
        String sMonth = string.valueof( nextSchedule.month() );
        String sDay = string.valueof( nextSchedule.day() ); 
        String sHour = string.valueof( nextSchedule.Hour() );
        String sMinute = string.valueof( nextSchedule.minute() );
        String ssecond=string.valueof(nextschedule.second());
        if(trigger.isinsert)
        {
            Transaction__c settings = Transaction__c.getOrgDefaults();
            if(trigger.isbefore) 
            {
                for(Account A:system.trigger.new)
                {
                    if(
                        A.Account_Type__c =='LA' || 
                        A.Account_type__c =='ID COM' 
                    ){ 
                        
                        A.Temporary_LA_or_IDCom__c=String.valueof(settings.Temporary_LA_or_IDCom__c);//'01234567';
                        settings.Temporary_LA_or_IDCom__c= settings.Temporary_LA_or_IDCom__c+1;
                        update settings;
                        
                    }
                }
            }
            if(trigger.isafter)
            {
                for(Account A:system.trigger.new)
                {
                    if(
                        A.Account_Type__c =='LA' || 
                        A.Account_type__c =='ID COM' 
                    ){ 
                        updateTemporaryLa.updateTemporaryLa(String.valueof(A.id));
                    } 
                    else{
                        if(test.isrunningtest())
                            HitsapComDocumentSapSoap.InsertAccount2(String.valueof(A.id));        
                    }       
                }
                // update settings;
            }
        }
        if(trigger.isupdate)
        {
            if(trigger.isbefore)
            {
                /*   Map<Id, Account> rejectedAccount = new Map<Id, Account>{};
                    for(Account Acc:system.trigger.new)
                    {

                    Account Accold=Trigger.oldMap.get(Acc.id);
                    if(Accold.Approval_Status__c!='Rejected' && Acc.Approval_Status__c=='Rejected')
                    {
                    rejectedAccount.put(Acc.id,Acc);
                    }
                    }
                    if (!rejectedAccount.isEmpty())  
                    {
                    List<Id> processInstanceIds = new List<Id>{};

                    for (Account Acc : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1)
                    FROM Account
                    WHERE ID IN :rejectedAccount.keySet()])
                    {
                    processInstanceIds.add(Acc.ProcessInstances[0].Id);
                    }
                    for (ProcessInstance pi : [SELECT TargetObjectId,
                    (SELECT Id, StepStatus, Comments 
                    FROM Steps
                    ORDER BY CreatedDate DESC
                    LIMIT 1 )
                    FROM ProcessInstance
                    WHERE Id IN :processInstanceIds
                    ORDER BY CreatedDate DESC])   
                    {                   

                    for(Account Ac:system.trigger.new)
                    {
                    if(Ac.id==pi.targetobjectid)
                    {
                    if ((pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0))
                    {                                               
                    rejectedAccount.get(pi.TargetObjectId).addError(
                    'Please provide a rejection reason!');
                    }
                    else
                    {
                    Ac.rejection_reason__c=pi.Steps[0].Comments;
                    }
                    }
                    }   

                    }  
                    }*/
                
            }
            if(trigger.isafter)
            { 
                for(Account A:system.trigger.new)
                {
                    Account Aold=Trigger.oldMap.get(A.id);
                    
                    if(
                        Aold.Bp_Number__c != A.Bp_Number__c &&
                        (
                            A.Bp_Number__c!='' || 
                            A.BP_Number__c!=null
                        ) && 
                        (
                            A.Field_Source__c == 'Bizstore Customer Registration' ||
                            A.Field_Source__c == 'Bizcare Customer Registration'
                        ) && 
                        A.Bizstore_Complete__c == false
                    ){
                        List<Customer_Registration_Ticket__c> customerRegistrationTicket = [
                            SELECT Id, 
                            Bizstore_Complete__c, 
                            Account__c, 
                            BP_Number__c
                            FROM CUSTOMER_REGISTRATION_TICKET__C 
                            WHERE Company_Type__c =: 'new' AND 
                            Bizstore_Complete__c =: false AND 
                            Account__c =: A.Id AND 
                            Stage__c =: 'Complete'
                        ];
                        
                        if(customerRegistrationTicket!=null && !customerRegistrationTicket.isEmpty()){
                            customerRegistrationTicket[0].BP_Number__c = A.BP_Number__c;
                            customerRegistrationTicket[0].Bizstore_Complete__c = True;
                        }
                        update customerRegistrationTicket;
                    }
                    
                    if(A.Account_Type__c=='BP'||A.Account_Type__c==''||A.Account_Type__c==null)
                    {
                        
                        if(Aold.Approval_Status__c!=A.Approval_Status__c && A.Approval_Status__c=='Approved' && (A.BP_Number__c==''||A.BP_Number__c==null))
                        {                 
                            HitsapComDocumentSapSoap.InsertAccount2(String.valueof(A.id)); 
                        }
                        if(A.Bp_Number__c!='' && A.BP_Number__c!=null)
                        {
                            
                            Scheduled_Process__c sp = new Scheduled_Process__c();
                            sp.Execute_Plan__c = nextSchedule;
                            sp.Type__c = 'Callout Account';
                            sp.parameter1__c = A.id ;
                            
                            
                            String  sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
                            
                            if(!test.isrunningtest())
                            {
                                String jobID2 = 'Sync BP' + sch + '  AccountID : ' + sp.parameter1__c;
                                sp.parameter3__c = jobID2;
                                sp.jobid__c = jobID2;
                                sp.title__c = 'SyncBPEasyOps';
                                listSP.add(sp);
                                //  insert sp; 
                            }
                            //    {REST_Callout_Update_Link.updatelink(link.link_id__c);}
                        }
                        
                        /*  if(AOld.LA_Number__c!='')
                        HitsapComDocumentSapSoap.InsertLANumber(String.valueof(A.id),A.La_Number__c,Aold.LA_Number__c);
                        else
                        HitsapComDocumentSapSoap.InsertLANumber(String.valueof(A.id),A.La_Number__c,'');
                        */
                        
                        if((Aold.BP_Number__c==A.BP_Number__c && A.BP_Number__c!=null && A.Bp_Number__c!='')||test.isrunningtest())
                        {
                            if(Aold.Ownerid!=A.Ownerid && Aold.ownerid!=null)
                            {
                                
                                HitsapComDocumentSapSoap.UpdateAccountChangeowner(String.valueof(A.id),Aold.ownerid,A.ownerid);
                            }
                            else
                            {
                                if(A.BP_Number__c!=null && A.BP_Number__c!='')
                                {
                                    if(Aold.lastmodifieddate<system.now().addminutes(-1)||test.isrunningtest()||(Aold.Approval_Status__c!=A.Approval_Status__c && A.Approval_Status__c=='Approved')||(Aold.term_of_payment_temp__c!=A.term_of_payment_temp__c))
                                    {
                                        if((Aold.LA_Number__c!=A.LA_number__c && A.LA_Number__c!=null && A.LA_Number__c!='')||(test.isrunningtest()))
                                        {
                                            HitsapComDocumentSapSoap.UpdateAccount2(String.valueof(A.id),true,A.LA_Number__c,Aold.LA_Number__c);
                                        }
                                        else
                                        {
                                            HitsapComDocumentSapSoap.UpdateAccount2(String.valueof(A.id),false,'','');
                                        }
                                    }
                                }
                            }
                        }
                    }
                    system.debug('After uPdate');
                    if(A.Account_type__c=='LA'||test.isRunningTest())
                    {
                        
                        if(Aold.SL_Id__c!=null && Aold.sl_id__c!='')
                        {                        
                            list<Opportunity> OppImplementation=[SELECT id FROM Opportunity WHERE Accountid=:A.Parentid AND Probability>=50 AND RecordType.Name='GSM (Activation)'];
                            if(Oppimplementation.size()==0)
                            {
                                
                                updateTemporaryLa.temporaryLAUpdate(String.valueof(A.id));
                            }
                        }
                    }
                    
                }
            }
        }
        //  Scheduled_Process_Services sps = new Scheduled_Process_Services();
        //  String    sch2 = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
        //  system.schedule('Sync BP'+math.random() + sch2 , sch2, sps);
        
        insert listSP;
        
    }
}