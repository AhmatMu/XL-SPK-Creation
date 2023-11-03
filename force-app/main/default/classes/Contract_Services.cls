Public with Sharing Class Contract_Services { 
    /*
    Code History
    1. First Creation :
    2. Update : ??-???-2019 by doddy : Change Price
    3. Update : ??-???-2019 by surya : BA Extension     
    4. Update : 20-Sep-2019 by doddy : set invoice status on last contract to TRUE, to handle the back date invoice (SAP not send the last invoice status)
	5. Update : 23-Feb-2020 by doddy : to handle the Digital Advertising opportunity data
    */
    
 
    public void CreateContractsFromOpportunity (string opportunityID) {
    //create contract ticket,contract item from oppty when WFC
        Opportunity opportunityRec = [  select id, Link_Related__r.Contract_Item_Rel__r.name
                                    , OneTime_Revenue__c, Recurring_Revenue__c
                                    , Link_Related__r.Contract_Item_Rel__c
                                    , Link_Related__r.Contract_Item_Rel__r.ContractTerm
                                    , Link_Related__r.Contract_Item_Rel__r.start_date__c
                                    , Link_Related__r.Contract_Item_Rel__r.end_date__c
                                    , Link_Related__r.Contract_Item_Rel__r.Periode_UOM__c
                                    ,Link_Related__r.Contract_Item_Rel__r.Contract_Term__c
                                    , Link_Related__r.Contract_Item_Rel__r.Bandwidth_filled__c
                                    , Link_Related__r.Contract_Item_Rel__r.Bandwidth_UoM_filled__c
                                    , Link_Related__r.Contract_Item_Rel__r.Contract_ID__c
                                    , Link_Related__r.Contract_Item_Rel__r.SAP_ID__c
                                    ,recordTypeName__c
                                    , BW_after__c
                                    , Uom_BW_After__c
                                    
                                    , service_type__c, AccountID, Name
                                    , BP_Payer__c, BP_VAT__c, Link_Related__c 
                                    , Account_Site_A__c, Account_Site_B__c
                                    , Auto_renewal__C  
                                    , recordtype.name
                                    , Site_A_Relocation_Street__c
                                    , Site_A_Relocation_State_Province__c
                                    , Site_A_Relocation_Zip_Postal_Code__c
                                    , Site_A_Relocation_City__c
                                    
                                    , Site_B_Relocation_Street__c
                                    , Site_B_Relocation_State_Province__c
                                    , Site_B_Relocation_Zip_Postal_Code__c
                                    , Site_B_Relocation_City__c
                                    , Contract_Periode__c
                                    , Periode_UOM__c
                                    
                                from Opportunity 
                                where id =:opportunityID];
                                
        string recordTypeName = opportunityRec.recordtype.name; 
        
        
        String Zeroprice='';
        
        list <Contract_ticket__c> contractTicketList=[select id FROM Contract_ticket__c WHERE Opportunity__c=:opportunityRec.id];
        if(contractTicketList.size()==0)
        {   //-- IF there is NO Contract-Ticket for the this Opportunity : CREATE NEW CONTRACT TICKET Package
            /* THEN create : 
                    I. Contract-Ticket, 
                    II. Contracts, and 
                    III. Contract-Ticket-Items
            */
        
            //-- I. Create Contract Ticket (header) 
            Contract_ticket__c contractTicket=new Contract_ticket__c();
            contractTicket.Opportunity__c=opportunityRec.id;
            contractTicket.Account__c=OpportunityRec.AccountID;
            contractTicket.Currency__c='IDR';
            
            //-- TODO : ini harusnya tidak perlu !! (created by surya, warning by doddy)
            if(OpportunityRec.service_type__c=='E-Commerce')
            {
                Contractticket.recordtypeid=system.label.RT_Contract_Ticket_Marketplace;
            }
            
            string label = 'Contract Ticket for "'+ opportunityRec.Name + '" Opportunity';
            if (label.length() > 75)
                contractTicket.Name = label.left(75) + ' ...'; 
            else contractTicket.Name = label;
            contractTicket.Full_Name__C = label.left(255);
            
            contractTicket.TicketStatus__c='Review By Contract Manager';
            insert contractTicket;
            //------------------------------------------------------------------------------- .end of Create CONTRACT TICKET
            
            
            
            
            //-- II. Create contract-items (Contract object)
            list<Contract> listCI=new list<Contract>();
            list<OpportunityLineItem> listOLI=[SELECT Billing_Type__c,Product2id,Product2.Name,Revenue_Type__c,
                                                    Contract_Start_Date__c,Contract_End_Date__c,Unitprice, totalprice, Quantity, 
                                                    Product2.Revenue_Type__c,  Product2.Bandwidth__c, Product2.UoM_Bandwidth__c, Product2.SAP_Code__c
                                                FROM OpportunityLineItem WHERE OpportunityID=:opportunityRec.id ];
            
            date newRecurringContractStartDate;
            /*
            Opportunity opportunityRec = new Opportunity();
            opportunityRec = [  select id, Link_Related__r.Contract_Item_Rel__r.name
                                    , Link_Related__r.Contract_Item_Rel__c
                                    , Link_Related__r.Contract_Item_Rel__r.end_date__c
                                    , service_type__c
                                from Opportunity 
                                where id =:O.id];
              */
                                
            
            if(opportunityRec.OneTime_Revenue__c>0 || opportunityRec.Recurring_Revenue__c>0)
            {   //-- dibuat contract jika amount nya > 0
                for(OpportunityLineItem OLI:listOLI)
                {
                    if(OLI.UnitPrice>0)  {
                        //-- II. Create Contract-Item (disini CREATE CONTRACT baik new LINK / existing)
                        Contract CI=new Contract();
                        
                        label = 'Contract: '+   + OLI.Product2.Name + '' ; 
                        if (label.length() > 75)
                            CI.Name = label.left(75) + ' ...'; 
                        else CI.Name = label;
                        CI.Full_Name__C = label.left(255);
                        
                        //-- ini harusnya nga perlu. contractTicket mempunyai detail di Contract-Ticket-Item
                        //CI.Contract_Ticket__c = contractTicket.id;
                        
                        system.debug ('================ opo : ' + CI.Account +' ' + opportunityRec.AccountID);
                        
                        CI.AccountID = OpportunityRec.AccountID;
                        CI.Opportunity__c=opportunityRec.id;
                        CI.Product__c=OLI.Product2id;
                        CI.Billing_Type__c=OLI.Billing_Type__c;
                        CI.Account_BP_Payer__c = opportunityRec.BP_Payer__c;
      
                        CI.Account_BP_VAT__c = opportunityRec.BP_VAT__c;

                        
						if (recordTypeName == 'B2B Marketplace') {
                            //-- for BizStore 
                            CI.recordtypeid=system.label.RT_Contract_Marketplace;
                            CI.Bandwidth_Before_UoM_filled__c='Unit';
                            CI.Bandwidth_UoM_filled__c='Unit';
                            CI.Auto_Renewal__c=true;
                        }
                        else if (recordTypeName == 'Digital Advertising') {
                            //-- for Digital Advertising
                            
                        }
                        
						else {
                            //-- for OTHERS
                            //
                            CI.Link__c=opportunityRec.Link_Related__c;
                            CI.Account_Site_A_BP_Site__c = OpportunityRec.Account_Site_A__c;
                            CI.Account_Site_B_BP_Site__c = OpportunityRec.Account_Site_B__c;
                            CI.Auto_renewal__C = OpportunityRec.Auto_renewal__C ;
                            
                            //CI.BP_Payer__c=O.BP_Payer__c;
                        }
                        
                        
                        //-- set custom fields : Start_Date__c
                        CI.Start_Date__c = OLI.Contract_Start_Date__c;
                        
                        //-- set standart fields - NOT USED
                        //CI.StartDate = OLI.Contract_Start_Date__c; 
                        
                        system.debug ('================ opportunityRec.Contract_Periode__c : ' +opportunityRec.Contract_Periode__c);
                        CI.ContractTerm = integer.valueof( opportunityRec.Contract_Periode__c ) ;
                        system.debug ('================ CI.ContractTerm : ' + CI.ContractTerm);
                        

						//-- SET PROJECT TYPE
                        if(opportunityRec.service_type__c == 'NewLink' 
								|| opportunityRec.service_type__c == 'E-Commerce'
								|| recordTypeName== 'Digital Advertising'
								) {

                            CI.PROJECT_TYPE__c = 'NEW';
                        }


						//-- SET END DATE
						if(opportunityRec.service_type__c == 'NewLink' 
								|| opportunityRec.service_type__c == 'E-Commerce'
								|| recordTypeName== 'Digital Advertising'
								) {
                            CI.End_Date__c = OLI.Contract_End_Date__c;
                        }



                        
                        //-- FILL PRODUCT INFORMATION
                        
                        /* if(OLI.Revenue_Type__c=='Recurring')
                            { 
                            //-- old way : get value from product 
                            CI.Bandwidth_filled__c = OLI.Product2.Bandwidth__c;
                            CI.Bandwidth_UoM_filled__c = OLI.Product2.UoM_Bandwidth__c;
                            }*/
                        
                        //-- new way : get value from technical detail on opportunity
                        if(OpportunityRec.service_type__c!='E-Commerce' && recordTypeName != 'Digital Advertising')
                        {
                            CI.Bandwidth_filled__c = integer.valueof (opportunityRec.BW_after__c);
                            CI.Bandwidth_UoM_filled__c = opportunityRec.Uom_BW_After__c;
                        }
                        
                        CI.Product_Charge_Type_filled__c = OLI.Product2.Revenue_Type__c;
                        CI.Product_SAP_Code__c = OLI.Product2.SAP_Code__c;
                        
                        CI.Periode_UOM__c =  opportunityRec.Periode_UOM__c;
                        CI.Contract_Term__c = integer.valueof( opportunityRec.Contract_Periode__c );
                        
                        Date newContractStartDate = null;
                        Date newContractEndDate = null;
                        
                        
                        /***
                         * This is for handling for UPGRADE, DOWNGRADE, REROUTE, RELOCATION
                         ***/
                        
                        if(opportunityRec.service_type__c == 'Upgrade' || 
                           	opportunityRec.service_type__c == 'Downgrade'||
                           	opportunityRec.service_type__c == 'Reroute' || 
                           	opportunityRec.service_type__c == 'Relocation') {                       
                            
                            /*********
                              * GET New Contract End Date for Upgrade/Downgrade purpose
                              ********/
                            
                             String UOM='';
                             Integer ContractTerm = 0;
                         	 /*      if(opportunityRec.Link_Related__r.Contract_Item_Rel__r.ContractTerm!=null)
                             {
                                UOM='Month';
                                ContractTerm = opportunityRec.Link_Related__r.Contract_Item_Rel__r.ContractTerm;
                             }
                             else*/
								//    {

                                UOM=opportunityRec.Link_Related__r.Contract_Item_Rel__r.Periode_UOM__c;
                                ContractTerm = Integer.valueof(opportunityRec.Link_Related__r.Contract_Item_Rel__r.Contract_Term__c);
								
								 //    }
                            
                            Date lastContractEndDate = opportunityRec.Link_Related__r.Contract_Item_Rel__r.end_date__c;
                               
                            //-- get real Last Contract Start Date
                            Date lastContractStartDate = null;
                            if (lastContractEndDate <> null) lastContractStartDate = lastContractEndDate.addmonths(ContractTerm * -1).adddays(1);
                               
                            //-- set NEW contract Start Date
                            newContractStartDate = CI.Start_Date__c;
                            //-- get NEW contract END Date
                            newContractEndDate = apputils.getNewContractEndDate (lastContractStartDate, lastContractEndDate, ContractTerm, newContractStartDate,UOM,integer.valueof(opportunityRec.Contract_Periode__c),opportunityRec.Periode_UOM__c);
                            /*---------------------------------------------------*/ 
                            
                            
                            if (OLI.Product2.Revenue_Type__c=='Recurring') {
                                //-- fill previous contract information (bandwidth before and contract before)
                                CI.Bandwidth_Before_Filled__c = opportunityRec.Link_Related__r.Contract_Item_Rel__r.Bandwidth_filled__c;
                                CI.Bandwidth_Before_UoM_filled__c = opportunityRec.Link_Related__r.Contract_Item_Rel__r.Bandwidth_UoM_filled__c;
                                CI.Previous_Contract_Header_ID_filled__c = opportunityRec.Link_Related__r.Contract_Item_Rel__r.Contract_ID__c;
                                CI.Previous_Contract_Item_No_filled__c = opportunityRec.Link_Related__r.Contract_Item_Rel__r.SAP_ID__c;
                                
                            }
                            
                        }
   
                        
                        //-- UPGRADE --
                        if(opportunityRec.service_type__c == 'Upgrade') {
                            CI.PROJECT_TYPE__c = 'UPGR';
                            
                            if (OLI.Product2.Revenue_Type__c=='Recurring') {
                                //-- set end-contract-date from calculation above                               
                                CI.End_Date__c = newContractEndDate;
                                
                                //-- set previous contract 
                                CI.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                                
                            } else {
                                //-- set to end date on opportunity-lineitem (product)
                                CI.End_Date__c=OLI.Contract_End_Date__c;
                            } 
                        }
                        
                        //-- DOWNGRADE --
                        if(opportunityRec.service_type__c == 'Downgrade'){
                            CI.PROJECT_TYPE__c = 'DWGR';
                            
                            if (OLI.Product2.Revenue_Type__c=='Recurring') {
                                //-- set end-contract-date from calculation above                               
                                CI.End_Date__c = newContractEndDate;
                                
                                //-- set previous contract 
                                CI.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                                
                            } else {
                                //-- set to end date on opportunity-lineitem (product)
                                CI.End_Date__c=OLI.Contract_End_Date__c;
                            }                             
                        }
                        
                        //-- REROUTE --
                        if(opportunityRec.service_type__c == 'Reroute') {
                            CI.PROJECT_TYPE__c = 'RERU';
                            
                            //-- set previous contract 
                            CI.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                            
                            //-- set to end date on opportunity-lineitem (product)
                            CI.End_Date__c=OLI.Contract_End_Date__c;
                                
                        }
                        
                        //-- RELOCATION --
                        if(opportunityRec.service_type__c == 'Relocation') {
                            CI.PROJECT_TYPE__c = 'RELO';
                            
                            //-- set previous contract 
                            CI.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                            
                            //-- set to end date on opportunity-lineitem (product)
                            CI.End_Date__c=OLI.Contract_End_Date__c;
                        }
                        
                        //-- REACTIVATION --
                        if(opportunityRec.service_type__c == 'Reactivation') {
                            CI.PROJECT_TYPE__c = 'REAC';
                            
                            //-- set previous contract 
                            CI.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                            
                            //-- set to end date on opportunity-lineitem (product)
                            CI.End_Date__c=OLI.Contract_End_Date__c;
                        }
                        
                        
                        
						//-- SET QUANTITY and PRICE ---
						if ( recordtypename == 'Digital Advertising') {
							//-- for digital advertising set the quantity in contract to be 1
							CI.Quantity__c = 1;
							CI.Price__c = OLI.TotalPrice;
                            
							 
						} else { 
							//-- for standard product set the quantity in contract same like quantity product
							CI.Quantity__c=OLI.Quantity;
							CI.Price__c=OLI.UnitPrice;
						}


                        ListCI.ADD(CI);
                        
                        //-- keep the start-date of recurring contract. for upgrade/downgrade purposes
                        if (OLI.Product2.Revenue_Type__c=='Recurring') {
                            newRecurringContractStartDate = OLI.Contract_Start_Date__c;
                        }
                    }
                }
                
                //-- Do Insert Contract-Items on database
                system.debug ('================ listCI : ' + listCI);
                insert listCI;
                //------------------------------------------------------------------------------- .end of Create CONTRACT_ITEMS (CONTRACT object)
            
                
                
                //-- III. Create Contact-Ticket-Items (detail)  --- related to Contract-Item
                
                List <Contract_ticket_item__c> CTIList = new List <Contract_ticket_item__c> (); 
                for (Contract contractItemRec : listCI) 
				{   
                    //-- create Contact-Ticket-Item
                    Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
                    label = 'Item for ' + contractItemRec.name;
                    //label.replace('Contract Item of','');
                    
                    if (label.length() > 75)
                            CTI.Name = label.left(75) + ' ...'; 
                        else CTI.Name = label;
                    CTI.full_name__c = label.left(255);
                    
                    CTI.Contract_Ticket__c = contractTicket.id;
                    CTI.Contract_Item__c = contractItemRec.id;
                    CTI.FLAG__c= 'FIRST INVOICE';
                    
                    CTIList.add (CTI);
                    
                }
				//----------------------------...............................----- .end of Create CONTRACT_TICKET ITEMS 
            
                

                //-- ADD PREVIOUS CONTRACT FOR UPGRADE / DOWNGRADE (existing)
                if( (OpportunityRec.Service_Type__c=='Upgrade' || OpportunityRec.Service_Type__c=='Downgrade') )
                {   //-- get last contract from related link on this opportunity
                    
                    //Contract prevContract = O.Link_Related__r.Contract_Item_Rel__c;
                    //-- *** info : O.Link_Related__r.Contract_Item_Rel__r IS THE LAST-CONTRACT-THAT-LINK-USED *** 
                    
                    
                    List<Contract>  contractItemPrevList = [    select id, start_date__c, end_date__c, end_date_before__c 
                                                                FROM Contract
                                                                WHERE ID = :opportunityRec.Link_Related__r.Contract_Item_Rel__c];
                    
                    system.debug ('========= hello :' + contractItemPrevList );
                    system.debug ('========= hello :' + opportunityRec.Link_Related__r.Contract_Item_Rel__r.end_date__c +' ** ' + newRecurringContractStartDate );
                    
                    if (contractItemPrevList.size() >0) {
                        Contract contractItemPrevRec =  contractItemPrevList[0];
                        
                        //-- OLD WAY : jika new contract start-date kurang dari end-date last contract  
                        /*
                        if (opportunityRec.Link_Related__r.Contract_Item_Rel__r.end_date__c > newRecurringContractStartDate  ) {
                            //-- set temporary end to for rollback purposes
                            contractItemPrevRec.end_date_before__c= opportunityRec.Link_Related__r.Contract_Item_Rel__r.end_date__c;
                            
                            //-- set end-date from previous contract to start-date H - 1  (PROSES MENDEKIN END DATE)
                            //contractItemPrevRec.end_date__c = newRecurringContractStartDate.adddays(-1);
                            contractItemPrevRec.Bill_Plan_End_Date__c = newRecurringContractStartDate.adddays(-1);
                            
                        }*/
                        
                        //-- NEW WAY : bill-plan-date adalah h-1 dari NEW Contract Start Date.
                        contractItemPrevRec.Bill_Plan_End_Date__c = newRecurringContractStartDate.adddays(-1);  
                        
                        update contractItemPrevRec;
                    
                    }
                    
                    Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
                    label = 'Item for ' + opportunityRec.Link_Related__r.Contract_Item_Rel__r.name + ' (last)';
                    if (label.length() > 75)
                        CTI.Name = label.left(75) + ' ...'; 
                    else CTI.Name = label;
                    CTI.full_name__C = label.left(255);
                    
                    CTI.Contract_Ticket__c = contractTicket.id;
                    CTI.Contract_Item__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                    
                    CTI.FLAG__c= 'LAST INVOICE';
                    
                    //** 4. Update : 20-Sep-2019 by doddy 
                    //-- Set invoced status to true for last/previous contract
                    //-- handling for some contract that had been invoiced before this event
                    //-- so, the SAP will not send the last invoice status
                    CTI.isInvoiced__c = true;
                    
                    CTIList.add (CTI);
                        
                }
                
                //-- insert contract-Ticket-item list into Contract_Ticket_item__c object db
                insert CTIList;
                
            }
            else
            { //-- Jika amount 0 atau< 0 THEN WHAT ???
                //O.StageName='Closed Won';
                //update O;
            }
            

        
        } //-- .endOF IF there is NO Contract-Ticket for the this Opportunity --> CREATE NEW CONTRACT TICKET
        
        else
        { //-- IF there is Contract-Ticket on database (exist)
            
            if (contractTicketList.size() ==1 ) {
                Contract_Ticket__c  contractTicket = contractTicketList[0];
                contractTicket.TicketStatus__c='Review By Contract Manager';
            }
            
            update contractTicketList;
        }
    }
    
    public void updateContractsFromOpportunity (string opportunityID) {
        //update contract if oppty already have contract ticket & item
        system.debug('========== get in updateContractsFromOpportunity');
        Opportunity Opp = [select id,Note__c,StageName, Account_Site_A__c,Link_Related__c,BP_Payer__c,
            BP_VAT__c,Service_Type__c,auto_renewal__c,recordtype.Name,Account_Site_B__c,Contract_Periode__c 
            from opportunity where id=:OpportunityID]; 
        
        try {
            //query contract ticket dan oppty line itemnya
            Contract_Ticket__c CT=[SELECT id FROM Contract_Ticket__c WHERE Opportunity__c=:OpportunityID];
            list<OpportunityLineItem> listOLI=[SELECT id,Quantity,product2id,billing_type__c,contract_start_date__c,contract_end_date__c,UnitPrice FROM OpportunityLineItem WHERE OpportunityID=:OpportunityID];
            //  list<Contract_Ticket_Item__c> listCTI=[SELECT id FROM Contract_ticket_item__c WHERE Contract_Ticket__c=:CT.id];
            list<Contract> listCI=[SELECT id,Quantity__c,Link__c,Account_BP_Payer__c,Account_Site_A_BP_Site__c,Account_BP_VAT__c,Product__c,Billing_Type__c,Start_Date__c,End_Date__c,price__c,auto_renewal__c,StartDate,EndDate FROM Contract WHERE Opportunity__c=:OpportunityID];
            
            system.debug('========== listOLI : ' + listOLI);
            
            for(Integer i=0;i<listOLI.size();i++)
            {
                for(Integer j=0;j<listCI.size();j++)
                {
                    listCI[j].Account_Site_A_BP_Site__c=Opp.Account_Site_A__c;
                    if(Opp.RecordType.Name.Contains('Leased Line'))
                        listCI[j].Account_Site_B_BP_Site__c=Opp.Account_Site_B__c;
                    
                    listCI[j].Account_BP_Payer__c=Opp.BP_Payer__c;
                    listCI[j].Account_BP_VAT__c=Opp.BP_VAT__c;
                    
                    if(OPP.Link_Related__c!=listCI[j].Link__c)
                        listCI[j].Link__c=Opp.Link_Related__c;
                        
                    if(listOLI[i].Product2id==listCI[j].Product__c || test.isrunningtest())
                    {
                        listCI[j].billing_type__c =listOLI[i].billing_type__c;
                        listCI[j].start_date__c=listOLI[i].Contract_start_date__C;
                        listCI[j].end_date__c=listOLI[i].Contract_end_date__c;
                        listCI[j].Quantity__c=listOLI[i].Quantity;
                        listCI[j].Price__c=listOLI[i].UnitPrice;
                        listCI[j].startdate=listOLI[i].Contract_start_date__C;
                        listCI[j].contractterm=Integer.valueof(Opp.Contract_Periode__c);
                    }
                }
            }
            //Opp.StageName='Waiting for Contract';
            //Opp.Note__c='Send Email To Contract Manager';
            
            system.debug('========== listCI : ' + listCI);
            update Opp;
            update listCI;
        
        }
        catch(exception e)
        {
            string errMessage = e.getmessage()+'  '+e.getstacktracestring();
            system.debug('========== errMessage : ' + errMessage);
            AppUtils.putError(errMessage );
        }
    }

    public void UpdateContractsFromBAExtension (string extensionID)
    {
        //update contract ticket from BA Extension
        Contract_Extension__c CE=[SELECT Link__c,Extension_Start_Date__c,Extension_End_Date__c FROM Contract_Extension__c WHERE ID=:ExtensionID];
        Contract_Ticket__c CT=[SELECT id FROM Contract_Ticket__c WHERE BA_Extension__c=:extensionid];
        list<Contract_Ticket_Item__c> CTIlist=[SELECT id,Contract_Item__c FROM Contract_Ticket_Item__c WHERE Contract_Ticket__c=:CT.id AND Flag__c='FIRST INVOICE'];
        Contract C=new Contract();
        C.id=CTILIST[0].Contract_Item__c;
        C.link__c=CE.Link__c;
        C.Start_Date__c=CE.Extension_Start_Date__c;
        C.End_Date__C=CE.Extension_End_Date__c;
        update C;
        }
     public void CreateContractsFromBAExtension (string extensionID)
    {
        //create contract ticket from BA Extension
        Contract_Extension__c CE=[SELECT id,Existing_Contract_Item__r.Contract_id__c,Existing_Contract_Item__r.ContractTerm,Existing_Contract_Item__r.SAP_ID__c,Existing_Contract_Item__r.Billing_Type__c,Existing_Contract_Item__r.Contract_Header__c,Existing_Contract_Item__r.Quantity__c,Existing_Contract_Item__r.Account_BP_Payer__c,Existing_Contract_Item__r.Account_BP_VAT__c,Name,Link__r.Contract_item_rel__c,Link__r.Contract_item_rel__r.Name,Account__c,Link__c,Extension_Start_Date__c,Extension_End_Date__c,Link__r.Uom__c,Link__r.Capacity_Bandwidth__c,Link__r.Site_A_Name__c,    Link__r.Site_B_Name__c,Link__r.Link_id__c,Existing_Contract_item__c,Existing_Contract_Item__r.Product__c,Existing_Contract_Item__r.Opportunity__c,Extension_Monthly_Price__c,Status__c,Existing_Contract_Item__r.Bandwidth_UoM_filled__c,Existing_Contract_Item__r.Bandwidth_filled__c,Existing_Contract_Item__r.Product_SAP_Code__c,Existing_Contract_Item__r.Product_Charge_Type_Filled__c   FROM Contract_Extension__c WHERE ID=:extensionID];
        Contract_Ticket__c CT=new Contract_Ticket__c();
        string label = 'Contract Ticket for "'+ CE.Name + '"';
        CT.Name=label.left(75);
        CT.Full_Name__C = label.left(255);
        CT.Account__c=CE.Account__c;
        CT.TicketStatus__c='Review By Contract Manager';
        CT.BA_Extension__c=CE.id;
    //  CT.Opportunity__c=CE.Existing_Contract_Item__r.Opportunity__c;
        insert CT;
        Contract C=new Contract();
        label='Contract For "'+CE.Name+'"';
        C.Name=label.left(75);
         C.Full_Name__C = label.left(255);
         C.Billing_type__c=CE.Existing_Contract_Item__r.Billing_Type__c;
         C.ContractTerm=(CE.Extension_start_date__c.daysbetween(CE.Extension_end_date__c))/12;//CE.Existing_Contract_Item__r.ContractTerm;
        system.debug('ContractTerm'+C.ContractTerm);
        C.Accountid=CE.Account__c;
        C.Auto_Renewal__c=false;
        C.Link__c=CE.Link__c;
        C.Product__c=CE.Existing_Contract_Item__r.Product__c;
        C.Price__c=CE.Extension_Monthly_Price__c;
        C.Start_Date__c=CE.Extension_Start_Date__c;
        C.End_Date__C=CE.Extension_End_Date__c;
        C.Previous_Contract__c=CE.Existing_Contract_item__c;
        C.Project_Type__c='RENE';
        C.Account_BP_Payer__c=CE.Existing_Contract_Item__r.Account_bp_payer__c;
        C.Account_BP_VAT__c=CE.Existing_Contract_Item__r.Account_bp_VAT__c;
        C.previous_Contract__c=CE.Existing_Contract_Item__c;
        C.Account_Site_A_bp_Site__c=CE.Link__r.Site_A_Name__c;
        C.Account_Site_B_bp_Site__c=CE.Link__r.Site_B_Name__c;
        C.Previous_Contract_Header_ID_filled__c=CE.Existing_Contract_Item__r.Contract_id__c;
        C.Previous_Contract_Item_No_filled__c=CE.Existing_Contract_Item__r.SAP_ID__c;
        C.Quantity__c=CE.Existing_Contract_Item__r.Quantity__c;
        C.Bandwidth_filled__c=CE.Existing_Contract_Item__r.Bandwidth_filled__c;
        C.Bandwidth_UoM_filled__c=CE.Existing_Contract_Item__r.Bandwidth_UoM_filled__c;
        C.Bandwidth_Before_Filled__c=CE.Existing_Contract_Item__r.Bandwidth_filled__c;
        C.Bandwidth_Before_UOM_Filled__c=CE.Existing_Contract_Item__r.Bandwidth_UoM_filled__c;
        C.Product_SAP_Code__c=CE.Existing_Contract_Item__r.Product_SAP_Code__c;
        C.Product_Charge_Type_filled__c=CE.Existing_Contract_Item__r.Product_Charge_Type_filled__c;
   //   C.Opportunity__c=CE.Existing_Contract_Item__r.Opportunity__c;
        insert C;
         
             
                    Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
                    label = 'Item for ' + CE.name;
                    //label.replace('Contract Item of','');
                    
                    if (label.length() > 75)
                            CTI.Name = label.left(75) + ' ...'; 
                        else CTI.Name = label;
                    CTI.full_name__c = label.left(255);
                    
                    CTI.Contract_Ticket__c = CT.id;
                    CTI.Contract_Item__c = C.id;
                    CTI.FLAG__c= 'FIRST INVOICE';
                    insert CTI;
                    
            List<Contract>  contractItemPrevList = [    select id, start_date__c, end_date__c, end_date_before__c 
                                                                FROM Contract
                                                                WHERE ID = :CE.Link__r.Contract_Item_Rel__c];
                    
                    
                    if (contractItemPrevList.size() >0) {
                        Contract contractItemPrevRec =  contractItemPrevList[0];
                        
                        //-- OLD WAY : jika new contract start-date kurang dari end-date last contract  
                        /*
                        if (opportunityRec.Link_Related__r.Contract_Item_Rel__r.end_date__c > newRecurringContractStartDate  ) {
                            //-- set temporary end to for rollback purposes
                            contractItemPrevRec.end_date_before__c= opportunityRec.Link_Related__r.Contract_Item_Rel__r.end_date__c;
                            
                            //-- set end-date from previous contract to start-date H - 1  (PROSES MENDEKIN END DATE)
                            //contractItemPrevRec.end_date__c = newRecurringContractStartDate.adddays(-1);
                            contractItemPrevRec.Bill_Plan_End_Date__c = newRecurringContractStartDate.adddays(-1);
                            
                        }*/
                        
                        //-- NEW WAY : bill-plan-date adalah h-1 dari NEW Contract Start Date.
                        contractItemPrevRec.Bill_Plan_End_Date__c = CE.Extension_Start_Date__c.adddays(-1);  
                        
                        update contractItemPrevRec;
                    
                    
                    
                   Contract_Ticket_Item__c CTI2 = new Contract_Ticket_Item__c();
                   label = 'Item for ' + CE.Link__r.Contract_Item_Rel__r.name + ' (last)';
                    if (label.length() > 75)
                        CTI2.Name = label.left(75) + ' ...'; 
                    else CTI2.Name = label;
                    CTI2.full_name__C = label.left(255);
                    
                    CTI2.Contract_Ticket__c = CT.id;
                    CTI2.Contract_Item__c = CE.LinK__r.Contract_Item_Rel__c;
                    
                    CTI2.FLAG__c= 'LAST INVOICE';
                    
                    //**  4. Update : 20-Sep-2019 by doddy 
                    //-- Set invoced status to true for last/previous contract
                    //-- handling for some contract that had been invoiced before this event
                    //-- so, the SAP will not send the last invoice status
                    CTI2.isInvoiced__c = true;
                    
                   insert CTI2;
                        }    
                
                
                //-- insert contract-Ticket-item list into Contract_Ticket_item__c object db
                     
                
                
        Ce.Contract_Ticket_Created__c=CT.id;
        CE.Remark__c='Customer Confirmed to Extend Contract';
        //CE.Status__c='Completed';
        update CE;
    }
    public void CreateChangePriceFromBAExtension (string extensionID)
    {
        //create change price from BA Extension
        Contract_Extension__c CE=[SELECT id,link__r.Site_A_Name__r.BP_Number__c,link__r.Site_A_Name__r.Name,link__r.Site_A_Name__r.Unique_Name__c,Account__c,Account__r.Organization_Type__c,Account__r.Parentid,Link__c,Extension_Start_Date__c,Extension_End_Date__c,Link__r.Uom__c,Link__r.Capacity_Bandwidth__c,Link__r.Link_id__c,Existing_Contract_item__c,Extension_Monthly_Price__c,Solution_pic__c,Existing_Contract_Item__r.Product__c   FROM Contract_Extension__c WHERE ID=:extensionID];
        Change_Price__c CP=new Change_Price__c();
        if(CE.Account__r.Organization_Type__c=='Head Office')
        {
        CP.Customer__c=CE.Account__c;   
        }
        else
        {
            CP.Customer__c=CE.Account__r.Parentid;
        }
        CP.BA_Extension__c=CE.id;
        CP.Name='Change Price For Renewal Link:'+CE.Link__r.Link_id__c;
        CP.Status__c='Draft';
        CP.Solution_PIC__c=CE.Solution_PIC__c;
        
        
        insert CP;
        Change_Price_Link__c CPL=new Change_Price_Link__c();
        CPL.Change_Price__c=CP.id;
        CPL.Link__c=CE.Link__c;
        CPL.Previous_Contract__c=CE.Existing_Contract_Item__c;
        CPL.Name=CE.Link__r.Link_id__c;
        CPL.Bandwidth__c=CE.Link__r.Capacity_Bandwidth__c;
        cpl.Site__c = CE.link__r.Site_A_Name__r.BP_Number__c + ' ' + CE.link__r.Site_A_Name__r.name  + ' - ' + CE.link__r.Site_A_Name__r.Unique_Name__c;
               
        CPL.Uom__c=CE.Link__r.Uom__c;
        CPL.Contract_Start_Date__c=CE.Extension_Start_Date__c;
        CPL.Contract_End_Date__c=CE.Extension_End_Date__C;
        CPL.Is_Auto_Renewal__c=false;
        CPL.Selling_Price__c=CE.Extension_Monthly_Price__c;
        insert CPL;
        Change_Price_Link_Group__c Pr=new Change_Price_Link_Group__c();
        Pr.Change_Price__c =CP.id;
        Pr.Bandwidth__c=CE.Link__r.Capacity_Bandwidth__c;
        Pr.Uom__c=CE.Link__r.Uom__c;
        Pr.Selling_Price__c=CE.Extension_Monthly_Price__c;
        insert Pr;
        CE.Change_Price_Created__c=CP.id;
        CE.Remark__c='Customer Want to Negotiate New Price';
        CE.Status__c='Completed';
        update CE;
    }
    
}