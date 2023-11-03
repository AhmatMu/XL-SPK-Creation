/**
 * @description       : 
 * @Test Class        : TEST_Trigger_ContractTicket
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 10-19-2023
 * @last modified by  : Doddy Prima
**/

trigger Trigger_Contract_Ticket on Contract_Ticket__c (after insert, after update, before insert, before update)
{
    if(trigger.isinsert)
    {
        if(trigger.isafter)
        {
            for(Contract_Ticket__c C : system.trigger.new)
            {
                //add contract ticket lookup in oppty
                list<Opportunity> Opps = [SELECT Contract_Ticket__c from Opportunity WHERE ID = :C.Opportunity__c];
                if (Opps.size()>0) {
                    Opps[0].Contract_Ticket__c = C.id;
                    update Opps;
                }
                
                
                // -- tutup dulu untuk change price
                    /*
                //-- tutup dulu sebab 1 change price nanti bisa banyak contract ticket
                list<Change_Price__c> CPs = [SELECT Contract_Ticket__c from Change_Price__c WHERE ID = :C.Change_PRice__c];
                if (CPs.size()>0) {
                    CPs[0].Contract_Ticket__c = C.id;
                    update CPS;
                }
                */
                
                
            }
        }
    }
    if(trigger.isupdate)
    {
        if(trigger.isbefore)
        {
            for(Contract_Ticket__c CT : system.trigger.new)
            {
                list<Opportunity> Opps = [SELECT RecordtypeName__c from Opportunity WHERE ID = :CT.Opportunity__c];
                Contract_Ticket__c CTOld = Trigger.oldMap.get(CT.id);
            
                
                
            }
        }
        if(trigger.isafter)
        {



            for(Contract_Ticket__c CT : system.trigger.new)
            {
                Contract_Ticket__c CTOld = Trigger.oldMap.get(CT.id);
                /*tolong di trigger contract item(contract standard) invoice percentagenya dikalkulasi bikin formula kyk roll up summary
                */
               /* if((CTOld.Invoice_Percentage__c != 1 && CT.Invoice_Percentage__c == 1)||test.isrunningtest())
                {
                    If(CT.Change_Price__c != null)
                    {
                        Change_Price__c CP = new Change_Price__c();
                        CP.id = CT.Change_Price__c;
                        CP.Status__c = 'Complete';
                        update CP;
                    }
                    If(CT.Opportunity__c != null)
                    {
                        Opportunity Op = new Opportunity();
                        Op.id = CT.Opportunity__c;
                        Op.stagename = 'Closed Won';
                        update Op;
                    }

                }
                */

                if(CTOld.TicketStatus__c != 'Review By Finance' && CT.TIcketStatus__c == 'Review By Finance' && CT.Recordtypeid!=system.label.RT_Contract_Ticket_Marketplace )//&& CT.Not_Hit_To_SAP__C==false)
                {
                    //when status 'review by finance' hit to SAP for contract module to get contract id and contract item id
                    //list<Contract_Item__c> CI =[SELECT billing_type__c,bp_payer__c,bp_vat__c,start_date__c,end_date__c from Contract_item__c WHERE Contract_Ticket__c=:CT.id];
                    list<Contract> CI = [SELECT billing_type__c, 
                        bp_payer__c, bp_vat__c, 
                        start_date__c, end_date__c from Contract WHERE Contract_Ticket__c = :CT.id];
                    for(Contract item : CI)
                    {
                        //validation before send to finance (SAP)
                        if(Item.BP_Payer__c == '')
                            CT.Adderror('BP Payer ContractItem is Empty, please complete it before send to finance');
                        
                        if(Item.BP_VAT__c == '')
                            CT.Adderror('BP VAT ContractItem is Empty, please complete it before send to finance');
                        
                        
                        if(Item.Billing_Type__c == '')
                            CT.Adderror('Billing Type ContractItem is Empty, please complete it before send to finance');
                        
                        if(Item.Start_Date__c == null)
                            CT.Adderror('Start Date ContractItem is Empty, please complete it before send to finance');
                        
                        if(Item.End_Date__c == null)
                            CT.Adderror('End Date ContractItem is Empty, please complete it before send to finance');

                    }
                    /* ini untuk ngehit ke SAP
                          if(CT.Contract_id__c!=null && CT.Contract_id__c!='' && !Test.isRunningTest() )
                             HitsapComDocumentSapSoap.HitContractUpdate(String.valueof(CT.Opportunity__c),String.valueof(CT.id));
                                else if((CT.Contract_id__c==null || CT.Contract_id__c=='') && !Test.isRunningTest() )
                              HitsapComDocumentSapSoap.HitContract(String.valueof(CT.Opportunity__c),String.valueof(CT.id));*/
                              
                    
                    //-- HIT TO SAP untuk OPPORTUNITY
                    /* TUTUP DULU OL VERSION
                    if (CT.Opportunity__c <> null) { 
                        if(!test.isrunningtest())
                            HitsapComDocumentSapSoap.HitContract(CT.id);
                    }   
                    */
                     
                    //-- HIT TO SAP untuk CHANGE price AND OPPORTUNITY
                    
                    //if (CT.Change_Price__c <> null) {
                    if (CT.Change_Price__c <> null  ||  CT.Opportunity__c <> null|| CT.BA_Extension__c<> null) {                        
                        //if(!test.isrunningtest()) {
                            //create scheduler to hit SAP to avoid timeout and governor limit
                            
                            //-- OLD VERSION 
                            /*
                            AggregateResult[] groupedResults
                              = [   SELECT Contract_Item__R.Contract_ID__c ContractHeader
                                    FROM Contract_Ticket_item__c
                                    WHERE contract_ticket__c=:CT.ID
                                    GROUP BY Contract_Item__R.Contract_ID__c
                                    
                                ];
                            */

                            //-- OLD v2 Version
                            /*AggregateResult[] groupedResults = [   
                                SELECT id, 
                                Contract_Item__R.Contract_ID__c ContractHeader,
                                Contract_Item__R.SAP_ID__c ContractItemNo,
                                Contract_Item__R.Product_Charge_Type_filled__c chargeType
                                FROM Contract_Ticket_item__c
                                WHERE contract_ticket__c =: CT.ID
                                GROUP BY ID, 
                                Contract_Item__R.Contract_ID__c, 
                                Contract_Item__R.SAP_ID__c, 
                                Contract_Item__R.Product_Charge_Type_filled__c
                            ];
                            
                            system.debug('============= groupedResults : ' + groupedResults);
                            
                            //for (AggregateResult ar : groupedResults)  {*/
                            

                            //-- New Version
                            List<Contract_Ticket_item__c> List_contractTicketitems = [
                                SELECT Id,
                                Name,
                                Contract_Item__R.Contract_ID__c,
                                Contract_Item__R.SAP_ID__c,
                                Contract_Item__R.Product_Charge_Type_filled__c,
                                Order__c
                                FROM Contract_Ticket_item__c
                                WHERE contract_ticket__c =: CT.ID
                                ORDER BY Order__c ASC
                            ];

                            system.debug('============= List_contractTicketitems : ' + json.serialize(List_contractTicketitems));
                            
                            List<Scheduled_Process__c> spList = [
                                select id,
                                Execute_Plan__c
                                from Scheduled_Process__c 
                                where status__c = 'Waiting' and 
                                (type__c = 'Callout Contract' OR type__c = 'Callout SO') 
                                order by Execute_Plan__c desc limit 1
                            ];

                            Datetime nextSchedule =null;
                            Datetime nextScheduleTmp =null;
                            
                            
                            integer interval; //(in minute) -- todo : using custom label 
                            interval = integer.valueof( system.label.Batch_Contract_Interval );
                            
                            if (spList.size() >0) {
                                datetime dtmp = spList[0].Execute_Plan__c;
                                nextScheduleTmp = dtmp.addMinutes(interval) ;
                                if (nextScheduleTmp < system.now()) {
                                    nextSchedule = system.now().addMinutes(1);
                                } else {
                                    nextSchedule = nextScheduleTmp;
                                }
                                
                            } else {
                                //-- set today
                                nextSchedule = system.now().addMinutes(1);
                            }
                            
                            
                            String sYear;
                            string sMonth;
                            string sDay;
                            string sHour;
                            string sMinute;
                            String sch ;
                            String jobID ;
                            
                            List<Scheduled_Process__c> spListTemp = new List<Scheduled_Process__c> ();

                            //for (Integer Ind=0; Ind < groupedResults.size(); Ind++)  {
                            for (Contract_Ticket_item__c contractTicketitem : List_contractTicketitems)  {
                                
                                string chargeType = string.valueof(contractTicketitem.Contract_Item__R.Product_Charge_Type_filled__c);
                                string contractTicketItemID = string.valueof(contractTicketitem.Id);
                                string contractHeaderID = string.valueof(contractTicketitem.Contract_Item__R.Contract_ID__c);
                                string contractItemNo = string.valueof(contractTicketitem.Contract_Item__R.SAP_ID__c);
                                
                                system.debug('============= contractHeaderID   : ' + contractHeaderID);
                                system.debug('============= contractItemNo     : ' + contractItemNo);

                                contractHeaderID = (contractHeaderID == null || contractHeaderID == '') ? '-' : contractHeaderID;
                                
                                
                                //-- OLD VERSION -- 
                                // HitSAPSOAP_Contract.HitContractByHeader(CT.id,  ContractHeaderID);
                                
                                
                                //-- USING SCHEDULE
                                /*
                                Scheduled_Process_Services sps = new Scheduled_Process_Services();
                                String sch = '0 12 16 28 11 ? 2018';
                                    
                                String jobID = system.schedule('Contract' + sch, sch, sps);
                                system.debug ('============ jobID :' + jobID);
                                */
                                
                                system.debug ('============ nextSchedule :' + nextSchedule);
                                
                                sYear = string.valueof( nextSchedule.year() );
                                sMonth = string.valueof( nextSchedule.month() );
                                sDay = string.valueof( nextSchedule.day() ); 
                                sHour = string.valueof( nextSchedule.Hour() );
                                sMinute = string.valueof( nextSchedule.minute() );
                                sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
                                
                                system.debug ('============ sch :' + sch);

                                
                                //-- OLD (By Contract Header) :: jobID = system.schedule('Contract ' + sch + ' (header : ' +  contractHeaderID + '), Contract Ticket No : ' + CT.Contract_Ticket_No__c, sch, sps);
                                
                                //-- NEW (By Contract Ticket Item) :

                                string  jobName = '';
                                
                                if (chargeType == 'One Time' || chargeType == 'Recurring') {
                                    if (contractItemNo == null || contractItemNo == '' ) {
                                        //-- This record need to CREATE Contract
                                        jobName =  'Callout to SAP for Contract Creation. ';
                                    }
                                    else {
                                        //-- The value of contractItemNo is available
                                        //-- This record need to UPDATE Contract 
                                        jobName = 'Callout to SAP for Contract Update. Contract Item No : ' + contractItemNo + '. ' ;
                                    }
                                }
                                else if (chargeType == 'Free') {
                                    jobName =  'Callout to SAP for SO Creation. ';
                                }

                                //TODO
                                jobName = jobName + '_' + contractTicketitem.Name + '_' + System.now()  + '_' + contractTicketitem.order__c;
 
                                

                                 
                                //jobID = system.schedule('Contract ' + sch, sch, sps);
                                 
                                //-- parameter1 : ContractTicketID
                                //-- paramater2 : ContractTicketItemID
                                //-- parameter3 : JobID

                                String scheduledProcessID = contractTicketItemID + '_' + AppUtils.getUniqueNumber();

                                Scheduled_Process__c sp = new Scheduled_Process__c();
                                sp.Execute_Plan__c = nextSchedule;
                                sp.Scheduled_Process_Id__c = scheduledProcessID;
                                
                                if (chargeType == 'One Time' || chargeType == 'Recurring') {
                                    sp.Type__c = 'Callout Contract';
                                }
                                else if (chargeType == 'Free') {
                                    sp.Type__c = 'Callout SO';
                                }



                                // SET SCHEDULE 
                                Scheduled_Process_Services sps = new Scheduled_Process_Services();
                                sps.jobType = sp.Type__c;   
                                sps.scheduledProcessID = scheduledProcessID;  // <<-- this is the key
                                jobID = system.schedule(jobName, sch, sps);
                                // ---

                                sp.parameter1__c = CT.id;
                                sp.parameter2__c = ContractTicketItemID;        //--OLD (By Contract Header) : contractHeaderID;
                                sp.parameter3__c = jobID;
                                sp.jobid__c = jobID;
                                sp.contract_ticket_related__c = CT.id;
                                sp.Contract_Ticket_Item_Related__c = contractTicketItemID;
                                
                                /*
                                string title = '';
                                if (contractHeaderID == null || contractHeaderID == '') {
                                    title = 'Callout to SAP for Contract(s) Creation';
                                } else {
                                    title = 'Callout to SAP for Contract(s) Update. Contract Header : ' + contractHeaderID;
                                }*/

                                sp.title__c = jobName; 
                                
                                


                                spListTemp.add(sp);
                                
                                nextSchedule= nextSchedule.addMinutes(interval) ;
                            }
                            insert spListTemp;
                            
                        }
                    //}   
                                                  
                              
                }
                if(CTOld.TicketStatus__c != 'Complete' && CT.TIcketStatus__c == 'Complete')
                {
                    //at complete, oppty moved to stage 'closed won'
                    if (CT.Opportunity__c <> null) {
                        Opportunity O = new Opportunity();
                        O.id = CT.Opportunity__c;
                        O.StageName = 'Closed Won';
                        O.Dealer_Code__c='Complete';
                        update O;
                    }
                    if(CT.BA_Extension__c<>null)
                    {
                        //at complete, BA Extension moved to stage 'closed won'
                        Contract_Extension__c BAE=new Contract_Extension__c();
                        BAE.id=CT.BA_Extension__c;
                        BAE.Status__c='Completed';
                        update BAE;
                    }
                    // -- tutup dulu untuk change price
                    
                    if (CT.Change_Price__c <> null) {
                        Change_Price__c cp = new Change_Price__c();
                        cp.id = CT.Change_Price__c;
                        cp.status__c = 'Complete';
                        update cp;
                    }
                    list<Contract_Ticket_Item__c> CTI=[SELECT id,Contract_Item__c FROM Contract_ticket_item__c WHERE Contract_Ticket__c=:CT.id];
                    list<Contract> listCTC=new list<Contract>();
                    for(Contract_ticket_item__c ticketitem:CTI)
                    {
                        Contract Ctc=new Contract();
                        CTC.id=Ticketitem.Contract_item__c;
                        CTC.Status='Active';
                        listCTC.add(CTC);
                    }
                    update listCTC;
                    
                    
                }
                if(CTOld.TicketStatus__c != 'Pending' && CT.TIcketStatus__c == 'Pending')
                {
                    //at pending, Oppty and BA extension moved to WBA
                    if (CT.Opportunity__c <> null) {
                        Opportunity O = new Opportunity();
                        O.id = CT.Opportunity__c;
                        O.StageName = 'Waiting for BA';
                        O.PR_status__c = 'WBA';
                        if(!test.isRunningTest())
                        update O;
                    }
                    
                     if(CT.BA_Extension__c<>null)
                    {
                        Contract_Extension__c BAE=new Contract_Extension__c();
                        BAE.id=CT.BA_Extension__c;
                        BAE.Status__c='Waiting for BA';
                    //  BAE.Remark__c='';
                        //BAE.Extension_Monthly_Price__c=null;
                        
                        update BAE;
                    }
                    // -- tutup dulu untuk change price (OPEN)
                    if (CT.Change_Price__c <> null) {
                        Change_Price__c cp = new Change_Price__c();
                        cp.id = CT.Change_Price__c;
                        cp.status__c = 'Pending';
                        update cp;
                        
                        //-- TODO : UNLOCK Cahnge Price record
                        //-- TODO : send email to Change Price Owner 
                    }
                    
                    
                }

                if(CTOld.TicketStatus__c != 'Review By Contract Manager' && CT.TIcketStatus__c == 'Review By Contract Manager')
                {
                    /* cel dulu
                    if (CT.Opportunity__c <> null) {
                        Opportunity O = new Opportunity();
                        O.id = CT.Opportunity__c;
                        O.StageName = 'Waiting for BA';
                        O.PR_status__c = 'WBA'; 
                        if(!test.isRunningTest())
                        update O;
                    }*/
                    
                    
                    // -- tutup dulu untuk change price
                    /*
                    if (CT.Change_Price__c <> null) {
                        Change_Price__c cp = new Change_Price__c();
                        cp.id = CT.Change_Price__c;
                        cp.status__c = 'Waiting for Contract';
                        update cp;
                    }
                    */
                    
                }
                                
                if(CTOld.TicketStatus__c != CT.TIcketStatus__c)
                {   //-- jika status Contract-Ticket berubah, maka contract-item juga berubah.
                    List<Contract_Ticket_Item__c> CTIList = [select id, Contract_Item__c from Contract_Ticket_Item__c where Contract_Ticket__c =:CT.ID];
                    
                    List <String> CIIDList = new List <String>(); 
                    if (CTIList.size() > 0) {
                        for (Contract_Ticket_Item__c CTI : CTIList) {
                            CIIDList.add (CTI.Contract_Item__c);
                        }
                    }
                    
                    List<Contract> contractList = [select id, status from contract where ID=:CIIDList and (status <> 'Active' or status <> 'Inactive') ];
                    if (contractList.size() > 0 ) {
                        for (Contract contractRec : contractList) {
                            if (CT.TIcketStatus__c <> 'Complete')
                                contractRec.status = CT.TIcketStatus__c;
                            //else contractRec.status = CT.TIcketStatus__c;
                        }
                        system.debug ('========== contractList : ' + contractList);
                        update contractList;
                    }
                }

                
            }
        }
    }

}