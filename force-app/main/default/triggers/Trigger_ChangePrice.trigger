trigger Trigger_ChangePrice on Change_Price__c (after insert, after update, before insert, before update) {

	/*
	Code History
	1. First Creation : 
	2. Update : 20-Sep-2019 by doddy : set invoice status on last contract to TRUE, to handle the back date invoice (SAP not send the last invoice status)
	
	
	*/    
    Datetime datelimit=datetime.newinstance(2018,7,3,0,0,0);
    
    
    //-- on INSERT  
    if(trigger.isinsert)
    {
        if(trigger.isbefore)
        {
           for(Change_Price__c CP:system.trigger.new)
            { list<AM_Portfolio_Mapping__c> Mapping=[SELECT id,Portfolio_Management_Support__c 
                                                   FROM AM_Portfolio_Mapping__c WHERE AM__c=:CP.ownerid AND Status__c='Active'];
                if(Mapping.size()>0)
                {
                    for(Integer i=0;i<mapping.size();i++)
                    { 
                        //-- TO SET Solution PIC user field related to Mapping of AM-Portfolio <-- used for approval
                        CP.Solution_PIC__c=Mapping[i].Portfolio_Management_Support__c;
                    }
                }
              
              //-- TO SET Owner Sales Manager
              list<User> usrs = [select managerid from user where id=:cp.Ownerid];
              CP.Sales_Manager__c = usrs[0].managerid;
              
              //-- TO SET Sales Admin
              system.debug ('label.Sales_Admin : ' + label.Sales_Admin);
              CP.Sales_Admin__c = label.Sales_Admin;
            }
        }
    }
    
    //-- on UPDATE
    if(trigger.isUpdate)
    {   
        //-- IF AFTER Update
        if(trigger.isAfter) {

        
        }
        
        //-- IF BEFORE Update
        if(trigger.isbefore) {
            for(Change_Price__c CPNew :system.trigger.new) {
                
                //-- get old change price record -> CPOld            
                Change_Price__c CPOld=Trigger.oldMap.get(CPNew.id);
                
                
                //-- TO SET Owner Sales Manager
                if (CPOld.Ownerid <> CPNew.ownerid) {
		        	//-- TO SET Owner Sales Manager
			        list<User> usrs = [select managerid from user where id=:CPNew.Ownerid];
			        CPNew.Sales_Manager__c = usrs[0].managerid;
	        	}
	        	
	        	//-- TO SET Sales Admin
	            system.debug ('label.Sales_Admin : ' + label.Sales_Admin);
	            if (label.Sales_Admin <> CPNew.Sales_Admin__c )
	            	CPNew.Sales_Admin__c = label.Sales_Admin;
                
                
                if (CPOld.status__c != 'Waiting for Contract' && CPNew.status__c == 'Waiting for Contract' && CPNew.Contract_Ticket__c == null) {
                    //-- if Change Price is Approved and stage move to 'Waiting for Contract'
                    //-- CREATE CONTRACT --
                    /*--    1. Create Contract-Ticket as header
                            2. Create Contract-Item (aka Contract standard object) tobe related to Contract-Ticket-Detail 
                            3. Create Contract-Ticket-Detail (relate to Contract-Item)
                    */
                    
                    //-- #1. Create Contract Ticket (as header) -------------------------------------------------------------
                    Contract_Ticket__C contractTicketRec = new Contract_Ticket__C ();
                    contractTicketRec.Change_Price__c = CPNew.id;
                    
                    //--TODO: change to HO
                    system.debug ('========= CPNew.customer__r.organization_type__c : ' + CPNew.customer__r.organization_type__c);
                    system.debug ('========= CPNew.customer__c : ' + CPNew.customer__c);
                    if (CPNew.Customer_Organization_Type__c == 'Branch') {
                    	contractTicketRec.Account__c = CPNew.Customer_Parent_ID__c;
                    	
                    } else if (CPNew.Customer_Organization_Type__c == 'Head Office' || CPNew.Customer_Organization_Type__c == 'Holding') {
                    	contractTicketRec.Account__c = CPNew.customer__c;
                    }
                    
                    contractTicketRec.Currency__c = CPNew.Currency__c; 
                    
                    string label = 'Contract Ticket for "'+ CPNew.Name + '" Change Price';
                    if (label.length() > 75)
		                contractTicketRec.Name = label.left(75) + ' ...'; 
		            else contractTicketRec.Name = label;
		            contractTicketRec.Full_Name__C = label.left(255);
            
                    contractTicketRec.TicketStatus__c = 'Review By Contract Manager'; 
                    //contractTicketRec.Invoice_Percentage__c = 0; -- TODO: check kegunaannya ! 
                     
                    insert contractTicketRec;
                    CPNew.Contract_Ticket__c = contractTicketRec.id	;
                    //-- .endOf Create Contract Ticket (as header) -----------------------------------------------------------
                    
                    
                    
                    //-- #2. Create Contract-Item (aka Contract standard object) tobe related to Contract-Ticket-Detail ----------------------------------
                    
                    //-- the contract-item data based on change-price (detail ~ Change_Price_Link__c) data list 
                    List <Change_Price_Link__c> cplList= [select id, name, change_price__c, link__c, Effective_Start_Date__c, Selling_price__c 
                                                            , link__r.Service_Type__c , link__r.Capacity_Bandwidth__c  
                                                            , link__r.Contract_Item_Rel__r.name
                                                            , link__r.Contract_Item_Rel__r.AccountID
                                                            , link__r.Contract_Item_Rel__r.Account__c
                                                            , link__r.Contract_Item_Rel__r.Product__c
                                                            , link__r.Contract_Item_Rel__r.Billing_type__c
                                                            , link__r.Contract_Item_Rel__r.Link__c
                                                            , link__r.Contract_Item_Rel__r.Account_BP_Payer__c
                                                            , link__r.Contract_Item_Rel__r.Account_BP_VAT__c
                                                            , link__r.Contract_Item_Rel__r.Account_Site_A_BP_Site__c
                                                            , link__r.Contract_Item_Rel__r.Account_Site_B_BP_Site__c
                                                            , link__r.Contract_Item_Rel__r.Start_Date__c
                                                            , link__r.Contract_Item_Rel__r.End_Date__c
                                                            , link__r.Contract_Item_Rel__r.Price__c
                                                            , link__r.Contract_Item_Rel__r.Quantity__c
                                                            , link__r.Contract_Item_Rel__r.CPE_Price__c
                                                            , link__r.Contract_Item_Rel__r.Auto_Renewal__c
                                                            , link__r.Contract_Item_Rel__r.Contract_Term__c
                                                            , To_Be_Autorenewal__c
                                                            , link__r.Contract_Item_Rel__r.Full_Name__C
                                                            , link__r.Contract_Item_Rel__r.Bandwidth_filled__c
                                                            , link__r.Contract_Item_Rel__r.Bandwidth_UoM_filled__c
                                                            , link__r.Contract_Item_Rel__r.Product_Charge_Type_filled__c
                                                            , link__r.Contract_Item_Rel__r.Product_SAP_Code__c
                                                            , link__r.Contract_Item_Rel__r.Bandwidth_Before_UoM_filled__c 
                        									, link__r.Contract_Item_Rel__r.Contract_ID__c
                        									, link__r.Contract_Item_Rel__r.SAP_ID__c
                        									, link__r.Contract_Item_Rel__r.Periode_UOM__c
                        									, link__r.Contract_Item_Rel__r.Product__r.Bandwidth__c
                                                            , link__r.Contract_Item_Rel__r.Product__r.UoM_Bandwidth__c
                                                            , link__r.Contract_Item_Rel__r.Product__r.Revenue_Type__c
                        									, link__r.Contract_Item_Rel__r.Product__r.SAP_Code__c
                                                            
                                                            //, link__r.Contract_Item_Rel__r.Contract_Item__c
                                        from Change_Price_link__c where change_price__c= :CPNew.id];
					
					
                    List<Contract> contractItemList = new List<Contract>();
                    String cplNames = '';
                    for (Change_Price_Link__c cpl : cplList) {
                        
                        Contract contractItemRec = new Contract();
                        
                        contractItemRec.name = cpl.link__r.Contract_Item_Rel__r.name; //'Contract Item of "'+ contractName  + '"' ; 
                        contractItemRec.Full_Name__C = cpl.link__r.Contract_Item_Rel__r.Full_Name__C; 
                        
                        contractItemRec.AccountID = cpl.link__r.Contract_Item_Rel__r.AccountID;
                        contractItemRec.Account__c = cpl.link__r.Contract_Item_Rel__r.Account__c ;
                        contractItemRec.Product__c = cpl.link__r.Contract_Item_Rel__r.Product__c;
                        contractItemRec.Billing_type__c= cpl.link__r.Contract_Item_Rel__r.Billing_type__c;
                        contractItemRec.Link__c= cpl.link__r.Contract_Item_Rel__r.Link__c;
                        contractItemRec.Account_BP_Payer__c= cpl.link__r.Contract_Item_Rel__r.Account_BP_Payer__c;
                        contractItemRec.Account_BP_VAT__c= cpl.link__r.Contract_Item_Rel__r.Account_BP_VAT__c;
                        contractItemRec.Account_Site_A_BP_Site__c= cpl.link__r.Contract_Item_Rel__r.Account_Site_A_BP_Site__c;
                        contractItemRec.Account_Site_B_BP_Site__c= cpl.link__r.Contract_Item_Rel__r.Account_Site_B_BP_Site__c;
                        
                        //contractItemRec.Auto_renewal__C = cpl.link__r.Contract_Item_Rel__r.Auto_Renewal__c;
                        contractItemRec.Auto_renewal__C = cpl.To_Be_Autorenewal__c;
                        
                        contractItemRec.Quantity__c= cpl.link__r.Contract_Item_Rel__r.Quantity__c;
                        contractItemRec.CPE_Price__c= cpl.link__r.Contract_Item_Rel__r.CPE_Price__c;
                        contractItemRec.Change_Price__c= CPNew.id; 
                        
                        contractItemRec.Contract_Term__c = cpl.link__r.Contract_Item_Rel__r.Contract_Term__c; //-- standard field
                        contractItemRec.Periode_UOM__c = cpl.link__r.Contract_Item_Rel__r.Periode_UOM__c; //-- standard field
                       
                        contractItemRec.Project_Type__c = 'NEC';
                        
                        //-- Technical Info 
                        //-- old way
                        //contractItemRec.Bandwidth_filled__c = cpl.link__r.Contract_Item_Rel__r.Bandwidth_filled__c;
                        //contractItemRec.Bandwidth_UoM_filled__c = cpl.link__r.Contract_Item_Rel__r.Bandwidth_UoM_filled__c;
                        //-- NEW way
                        contractItemRec.Bandwidth_filled__c = cpl.link__r.Contract_Item_Rel__r.Product__r.Bandwidth__c;
                        contractItemRec.Bandwidth_UoM_filled__c = cpl.link__r.Contract_Item_Rel__r.Product__r.UoM_Bandwidth__c;
                        
                        //-- old way
                        //contractItemRec.Product_Charge_Type_filled__c = cpl.link__r.Contract_Item_Rel__r.Product_Charge_Type_filled__c;
                        //contractItemRec.Product_SAP_Code__c = cpl.link__r.Contract_Item_Rel__r.Product_SAP_Code__c;
                        //-- NEW way
                        contractItemRec.Product_Charge_Type_filled__c = cpl.link__r.Contract_Item_Rel__r.Product__r.Revenue_Type__c;
                        contractItemRec.Product_SAP_Code__c = cpl.link__r.Contract_Item_Rel__r.Product__r.SAP_Code__c;
                        
                        
                        
                        //-- OLD WAY : contractItemRec.Bandwidth_Before_Filled__c = 0;
                        //-- OLD WAY : contractItemRec.Bandwidth_Before_UoM_filled__c = cpl.link__r.Contract_Item_Rel__r.Bandwidth_Before_UoM_filled__c ;
                        contractItemRec.Bandwidth_Before_Filled__c = cpl.link__r.Contract_Item_Rel__r.Product__r.Bandwidth__c;
                        contractItemRec.Bandwidth_Before_UoM_filled__c = cpl.link__r.Contract_Item_Rel__r.Product__r.UoM_Bandwidth__c;
                        
                        contractItemRec.Previous_Contract_Header_ID_filled__c = cpl.link__r.Contract_Item_Rel__r.Contract_ID__c;
                        contractItemRec.Previous_Contract_Item_No_filled__c = cpl.link__r.Contract_Item_Rel__r.SAP_ID__c;
                                
                        
                        //--TODO: check, kenapa error : contractItemRec.Status = 'Review By Contract Manager'; !!!!!!!!!
                        contractItemRec.Active__c = false;
                        
                        
                        //-- set start date , end date 
                        
                        //-- Effective_Start_Date__c
                        //-- contractItemRec.Start_Date__c= cpl.link__r.Contract_Item_Rel__r.Start_Date__c;
                        
                        //-- VALIDATAION RULES : Effective_Start_Date__c cannot not null
                        system.debug('========== cpl.Effective_Start_Date__c : ' + cpl.Effective_Start_Date__c);
                        
                        if (cpl.Effective_Start_Date__c == null ) {
                        	cplNames = cplNames + cpl.name +', ';
                        } else {
	                        
	                        contractItemRec.Start_Date__c= cpl.Effective_Start_Date__c;
	                        contractItemRec.StartDate = cpl.Effective_Start_Date__c; //-- standard field
	                        
	                        //-- End_Date__c : effectivedate + ContractTerm
	                        //-- old ver : contractItemRec.End_Date__c= cpl.link__r.Contract_Item_Rel__r.End_Date__c;
	                        
	                        Date newContractStartDate = null;
                        	Date newContractEndDate = null;
                        	
                        	Integer ContractTerm = Integer.valueof(contractItemRec.Contract_Term__c);
                        	String PeriodUOM=contractItemRec.Periode_UOM__c;
                            Date lastContractEndDate = cpl.link__r.Contract_Item_Rel__r.end_date__c;
                            
                            //-- get real Last Contract Start Date
                            Date lastContractStartDate = null;
                            if (lastContractEndDate <> null) lastContractStartDate = lastContractEndDate.addmonths(ContractTerm * -1).adddays(1);
                             
                             
                        	//-- set NEW contract Start Date
                            newContractStartDate = contractItemRec.Start_Date__c;
                            //-- get NEW contract END Date
                            newContractEndDate = apputils.getNewContractEndDate (lastContractStartDate, lastContractEndDate, ContractTerm, newContractStartDate,PeriodUOM,ContractTerm,PeriodUOM);
                            /*---------------------------------------------------*/ 
                        	
	                        //-- OLD way :contractItemRec.End_Date__c = cpl.Effective_Start_Date__c.addmonths(integer.valueof(cpl.link__r.Contract_Item_Rel__r.ContractTerm) );
	                        // new way :
	                        contractItemRec.End_Date__c = newContractEndDate ;
	                                                                    
                        }
                        if (cplNames.length()>0) {
                        	CPNew.adderror('Effective Date field for Link ' + cplNames + ' is empty, please fill the date first');
                        }
                        
                        
                        
                        //-- Set New Price 
                        contractItemRec.Price__c= cpl.Selling_price__c;
                        
                        //-- set previous Contract
                        contractItemRec.Previous_Contract__c = cpl.link__r.Contract_Item_Rel__c;
                        
                        //-- set Change Price
                        contractItemRec.Change_Price__c = cpl.change_price__c;
                        
                        //-- set Change Price Link
                        contractItemRec.Change_Price_Link__c = cpl.id;
                        
                        
                        //-- ADD TO LIST
                        contractItemList.add(contractItemRec);
                        
                    
                    }
                    
                    //-- insert Contract Item List
                    system.debug ('========= contractItemList : '+ contractItemList);
                    Insert contractItemList;
                    
                    
                    //-- .endOf Create Contract-Item
                    
                    
                    //-- #3. Create Contract-Ticket-Item (relate to Contract-Item)
                    List<Contract> contractItemPREVList = new List<Contract>();
                    
                    List <Contract_ticket_item__c> CTIList = new List <Contract_ticket_item__c> (); 
                    for (Contract contractItemRec : contractItemList) {   
                        //-- create Contact-Ticket-Item FOR NEW CONTRACT
                        Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
                        label = 'Item for ' + contractItemRec.name;
                        //label.replace('Contract Item of','');
                        
                        if (label.length() > 75)
                            CTI.Name = label.left(75) + ' ...'; 
                        else CTI.Name = label;
                        CTI.full_name__c = label.left(255);
                        
                        CTI.Contract_Ticket__c = contractTicketRec.id;
                        CTI.Contract_Item__c = contractItemRec.id;
                        CTI.FLAG__c= 'FIRST INVOICE';
                        
                        CTIList.add (CTI);  
                        
                        //-- CREATE Contact-Ticket-Item FOR PREVIOUS CONTRACT, handling limit pending recurring approved
                          Contract_Ticket_Item__c CTIPrev = new Contract_Ticket_Item__c();
                      
                        label = 'Item for ' + contractItemRec.name + ' (last contract)';
						CTIPrev.Name = label.left(59) + + label.right(16); 
                       
                        CTIPrev.Contract_Ticket__c = contractTicketRec.id;
                        CTIPrev.Contract_Item__c = contractItemRec.Previous_Contract__c;
                        CTIPrev.FLAG__c= 'LAST INVOICE';
                        
                        //** 2. Update : 20-Sep-2019 by doddy
                        //-- Set invoced status to true for last/previous contract
	                    //-- handling for some contract that had been invoiced before this event
	                    //-- so, the SAP will not send the last invoice status
                        CTIPrev.isInvoiced__c = true;
                        
                        CTIList.add (CTIPrev);
                        
                        //-- update billing plan end date for previous
                        Contract contractRecPrev = new Contract();
                        contractRecPrev.id = CTIPrev.Contract_Item__c;
                        if (contractItemRec.Start_Date__c != null)
                        	contractRecPrev.Bill_Plan_End_Date__c = contractItemRec.Start_Date__c.adddays(-1);
                        
                        contractItemPREVList.add (contractRecPrev);
                        
                    } 
                    
                    //-- Insert Contract Ticket Item List
                    insert CTIList;
                    
                    //-- update billing plan end date 
                    update contractItemPREVList;
                    
                    
                    //-- .endOf Create Contract Ticket Item
                
                } //-- .endOf : If CPNew.status__c == 'Waiting for Contract'
                
                else if (CPOld.status__c != 'Waiting for Contract' && CPNew.status__c == 'Waiting for Contract' && CPNew.Contract_Ticket__c != null) {
                	//-- IF there is Contract-Ticket on database (exist)
	                Contract_Ticket__c  contractTicket = new Contract_Ticket__c ();
	                
	                contractTicket.id = CPNew.Contract_Ticket__c;
	                contractTicket.TicketStatus__c='Review By Contract Manager';
					update contractTicket;
                }
                
                    
            } //.endOf FOR                    
            
        
        
        }
        
        
    }
    
    
}