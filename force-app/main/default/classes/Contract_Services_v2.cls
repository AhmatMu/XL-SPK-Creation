/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-13-2023
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-21-2022   Novando Utoyo Agmawan   Initial Version
 **/
Public with Sharing Class Contract_Services_v2 {
    /*
    Code History
    1. First Creation :
    2. Update : ??-???-2019 by doddy : Change Price
    3. Update : ??-???-2019 by surya : BA Extension     
    4. Update : 20-Sep-2019 by doddy : set invoice status on last contract to TRUE, to handle the back date invoice (SAP not send the last invoice status)
	5. Update : 23-Feb-2020 by doddy : to handle the Project Bulkshare opportunity data
    6. Update : 21-Des-2022 by Adam : Created Contract Burstable and Usage From Link
    7. Update : 04-Oct-2023 by Dicky : Add two methods :  CreateBrustableContractFromLink and  CreateUsageContractsFromLink
    8. update : 14-Sept-2023 by doddy : update CreateContractsFromOpportunity, related to adding for Free MRC (SO)
    
    */
    String labelName;

    /**
     * Create contract ticket, contract item from oppty when WFC
     *  
     * */    
    public void CreateContractsFromOpportunity(string opportunityID) {
        system.debug ('================ Contract_Services_v2.CreateContractsFromOpportunity ================');
        system.debug ('=====================================================================================');

        Double recurringProdUnitPrice = 0; 

        Opportunity opportunityRec = [
            SELECT Id, Link_Related__r.Contract_Item_Rel__r.Name
                , OneTime_Revenue__c, Recurring_Revenue__c, Link_Related__r.Contract_Item_Rel__c
                , Link_Related__r.Contract_Item_Rel__r.ContractTerm, Link_Related__r.Contract_Item_Rel__r.start_date__c
                , Link_Related__r.Contract_Item_Rel__r.end_date__c, Link_Related__r.Contract_Item_Rel__r.Periode_UOM__c
                , Link_Related__r.Contract_Item_Rel__r.Contract_Term__c, Link_Related__r.Contract_Item_Rel__r.Bandwidth_filled__c
                , Link_Related__r.Contract_Item_Rel__r.Bandwidth_UoM_filled__c
                , Link_Related__r.Contract_Item_Rel__r.Contract_ID__c, Link_Related__r.Contract_Item_Rel__r.SAP_ID__c
                , recordTypeName__c, BW_after__c, Uom_BW_After__c, service_type__c, AccountID, Name, BP_Payer__c, BP_VAT__c, Link_Related__c
                , Account_Site_A__c, Account_Site_B__c, Auto_renewal__c
                , recordtype.name, Site_A_Relocation_Street__c, Site_A_Relocation_State_Province__c
                , Site_A_Relocation_Zip_Postal_Code__c,Site_A_Relocation_City__c, Site_B_Relocation_Street__c
                , Site_B_Relocation_State_Province__c, Site_B_Relocation_Zip_Postal_Code__c
                , Site_B_Relocation_City__c,Contract_Periode__c, Periode_UOM__c, CurrencyIsoCode
                , Contract_Ticket__c, Free_MRC_Periode_Month_Invoice__c
            FROM Opportunity
            WHERE Id =: opportunityID
        ];
        
        string recordTypeName = opportunityRec.recordtype.name;
        String zeroPriceString = '';
        
        List<Contract_ticket__c> contractTicketList = [
            SELECT id 
            FROM Contract_ticket__c 
            WHERE Opportunity__c =: opportunityRec.Id
        ];
        
        //-- IF there is NO Contract-Ticket for the this Opportunity : CREATE NEW CONTRACT TICKET Package
        //if (contractTicketList.size() == 0) { 
        if ( opportunityRec.Contract_Ticket__c == null ) {
            /* THEN create : 
                I. Contract-Ticket, 
                II. Contracts, and 
                III. Contract-Ticket-Items
            */


            //-- I. Create Contract Ticket (header) -------------------------------------------------------------------------
            Contract_ticket__c contractTicket = new Contract_ticket__c();
            contractTicket.Opportunity__c = opportunityRec.id;
            contractTicket.Account__c = OpportunityRec.AccountID;
            contractTicket.Currency__c = OpportunityRec.CurrencyIsoCode;
            contractTicket.CurrencyIsoCode = OpportunityRec.CurrencyIsoCode;

            // create Contract-Ticket Name and full-name
            String labelContractTicketName = 'Contract Ticket for "' + opportunityRec.Name + '" Opportunity';
            
            // set contract nama (length 80)
            if (labelContractTicketName.length() > 75) {
                contractTicket.Name = labelContractTicketName.left(75) + ' ...';
            }
            else {
                contractTicket.Name = labelContractTicketName;
            }

            // set contract full-nama
            contractTicket.Full_Name__C = labelContractTicketName.left(255);

            // set Ticket status
            contractTicket.TicketStatus__c = 'Review By Contract Manager';
            
            // create Ticket record
            insert contractTicket;

            //---------------------------------.end of Create CONTRACT TICKET ------------------------------------------------


            
            //-- II. Create contract-items (Contract object) -----------------------------------------------------------------
            List <Contract> contractList = new list <Contract>();
            List <OpportunityLineItem > opptyProdList = [
                SELECT Billing_Type__c, Product2Id, Product2.Name, Revenue_Type__c
                    , Contract_Start_Date__c, Contract_End_Date__c, Unitprice, totalprice, Quantity
                    , Product2.Revenue_Type__c, Product2.Bandwidth__c, Product2.UoM_Bandwidth__c
                    , Product2.SAP_Code__c , Product2.Distribution_Channel__c, FreeMRC_Price__c
                    , CurrencyIsoCode
                FROM OpportunityLineItem 
                WHERE OpportunityID =: opportunityRec.id
                ORDER BY createdDate ASC
            ];

            

            //-- get last FREE MRC
            List <OpportunityLineItem > opptyProdFreeMRCList = [
                SELECT id, Contract_End_Date__c
                FROM OpportunityLineItem 
                WHERE OpportunityID =: opportunityRec.id
                    AND Revenue_Type__c = 'Free'
                ORDER BY Contract_End_Date__c DESC
                LIMIT 1
            ];
            
            //-- if any Free MRC then start contract set to the Day AFTER the end of last Free MRC periode
            Date newRecurringContractStartDate = null;
            if ( opptyProdFreeMRCList.size() > 0 ) {
                newRecurringContractStartDate = opptyProdFreeMRCList[0].Contract_End_Date__c.addDays(1);
            }

            /*
            Opportunity opportunityRec = new Opportunity();
            opportunityRec = [  select id, Link_Related__r.Contract_Item_Rel__r.name
                                    , Link_Related__r.Contract_Item_Rel__c
                                    , Link_Related__r.Contract_Item_Rel__r.end_date__c
                                    , service_type__c
                                from Opportunity 
                                where id =:O.id];
              */

            
            if (opportunityRec.OneTime_Revenue__c > 0 || opportunityRec.Recurring_Revenue__c > 0) { //-- dibuat contract jika amount nya > 0
                for (OpportunityLineItem opptyProdREC : opptyProdList) {
                    if (    ( opptyProdREC.UnitPrice > 0  && ( opptyProdREC.Product2.Revenue_Type__c == 'One Time' 
                                                                || opptyProdREC.Product2.Revenue_Type__c == 'Recurring'
                                                            )
                            ) 
                        || 
                            ( opptyProdREC.UnitPrice == 0 && opptyProdREC.Product2.Revenue_Type__c == 'Free'
                            )
                        )
                        
                    {

                        //-- II. Create Contract-Item (disini CREATE CONTRACT baik new LINK / existing / free SO)

                        // Create new Contract Instance object
                        Contract newContractObj = new Contract();

                        // set Contract Name
                        if ( opptyProdREC.Product2.Revenue_Type__c == 'One Time' || opptyProdREC.Product2.Revenue_Type__c == 'Recurring' ) {
                            labelName = 'Contract: ' + opptyProdREC.Product2.Name + '';
                        }
                        else if ( opptyProdREC.Product2.Revenue_Type__c == 'Free') {
                            Date startDate = opptyProdREC.Contract_Start_Date__c;
                            String startDTString = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day()).format('ddMMMyy');
                            Date endDate = opptyProdREC.Contract_End_Date__c;
                            String endDTString = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day()).format('ddMMMyy');

                            labelName = 'SO (Free): ['  +  startDTString  + '-' + endDTString + '] ' + ' ' + opptyProdREC.Product2.Name + '';
                        }

                        if (labelName.length() > 75){
                            newContractObj.Name = labelName.left(75) + ' ...';
                        } else {
                            newContractObj.Name = labelName; 
                        }


                        newContractObj.Full_Name__c = labelName.left(255);
                        newContractObj.AccountID = OpportunityRec.AccountID;
                        newContractObj.Opportunity__c = opportunityRec.id;
                        newContractObj.Product__c = opptyProdREC.Product2id;
                        newContractObj.Billing_Type__c = opptyProdREC.Billing_Type__c;
                        newContractObj.Account_BP_Payer__c = opportunityRec.BP_Payer__c;
                        newContractObj.Account_BP_VAT__c = opportunityRec.BP_VAT__c;


                        if (recordTypeName == 'Licensed') {
                            //-- for BizStore 
                            newContractObj.recordtypeid = system.label.RT_Contract_Marketplace; //TODO: need to check for new marketplace project!!
                            newContractObj.Bandwidth_Before_UoM_filled__c = 'Unit';
                            newContractObj.Bandwidth_UoM_filled__c = 'Unit';
                            newContractObj.Auto_Renewal__c = true;
                        } 
                        
                        else if (recordTypeName == 'Project Bulkshare') {
                            //-- for Project Bulkshare
                            //TODO: need to check for new marketplace project!!
                        } 
                        
                        else {
                            //TODO: need to specific criteria for else !!
                            //-- for OTHERS
                            newContractObj.Link__c = opportunityRec.Link_Related__c;
                            newContractObj.Account_Site_A_BP_Site__c = OpportunityRec.Account_Site_A__c;
                            newContractObj.Account_Site_B_BP_Site__c = OpportunityRec.Account_Site_B__c;
                            
                            if ( opptyProdREC.Product2.Revenue_Type__c == 'Recurring' ) {
                                newContractObj.Auto_renewal__C = OpportunityRec.Auto_renewal__C;
                            }
                            
                        }
                        
                        //-- SET Contract Start Date
                        //-- set custom fields : Start_Date__c
                        if ( opptyProdREC.Product2.Revenue_Type__c == 'Recurring'  && newRecurringContractStartDate <> null ) {
                            // if the newRecurringContractStartDate is not null then set recurring start date with newRecurringContractStartDate (any free mrc) 
                            newContractObj.Start_Date__c = newRecurringContractStartDate;
                        }
                        else {
                            newContractObj.Start_Date__c = opptyProdREC.Contract_Start_Date__c;
                        }

                        //-- set standart fields - NOT USED
                        //newContractObj.StartDate = OLI.Contract_Start_Date__c; 
                        
                        
                        
                        //-- SET PROJECT TYPE
                        if (opportunityRec.service_type__c == 'NewLink' ||
                            opportunityRec.service_type__c == 'E-Commerce' ||
                            recordTypeName == 'Project Bulkshare'
                        ) {
                            newContractObj.PROJECT_TYPE__c = 'NEW';
                        }

                        //-- SET END DATE
                        if (opportunityRec.service_type__c == 'NewLink' ||
                            opportunityRec.service_type__c == 'E-Commerce' ||
                            recordTypeName == 'Project Bulkshare'
                            ) 
                        {
                            newContractObj.End_Date__c = opptyProdREC.Contract_End_Date__c;
                        }

                        //-- FILL PRODUCT INFORMATION
                        //-- new way : get value from technical detail on opportunity
                        //-- v1 : if(OpportunityRec.service_type__c!='E-Commerce' && recordTypeName != 'Project Bulkshare')
                        if (recordTypeName != 'Licensed' && recordTypeName != 'Project Bulkshare') //--< v2
                        {
                            newContractObj.Bandwidth_filled__c = integer.valueof(opportunityRec.BW_after__c);
                            newContractObj.Bandwidth_UoM_filled__c = opportunityRec.Uom_BW_After__c;
                        }
                        
                        newContractObj.Product_Charge_Type_filled__c = opptyProdREC.Product2.Revenue_Type__c;
                        newContractObj.Product_SAP_Code__c = opptyProdREC.Product2.SAP_Code__c;
                        newContractObj.Distribution_Channel__c = opptyProdREC.Product2.Distribution_Channel__c;


                        //-- set Contract Term
                        system.debug('================ opportunityRec.Contract_Periode__c : ' + opportunityRec.Contract_Periode__c);

                        if ( opptyProdREC.Product2.Revenue_Type__c == 'One Time' || opptyProdREC.Product2.Revenue_Type__c == 'Recurring' ) {
                            newContractObj.ContractTerm = integer.valueof(opportunityRec.Contract_Periode__c);
                            newContractObj.Contract_Term__c = integer.valueof(opportunityRec.Contract_Periode__c);
                            newContractObj.Periode_UOM__c = opportunityRec.Periode_UOM__c;
                        }
                        else if ( opptyProdREC.Product2.Revenue_Type__c == 'Free') {
                            newContractObj.ContractTerm = 1;
                            newContractObj.Contract_Term__c = 1;
                            newContractObj.Periode_UOM__c = 'Month';
                        }
                        system.debug('================ newContractObj.ContractTerm : ' + newContractObj.ContractTerm);
                        
                        
                        //-- SET QUANTITY and PRICE ---
                        newContractObj.CurrencyIsoCode = opptyProdREC.CurrencyIsoCode;
                        if (recordtypename == 'Project Bulkshare') {
                            //-- for Project Bulkshare set the quantity in contract to be 1
                            newContractObj.Quantity__c = 1;
                            newContractObj.Price__c = opptyProdREC.TotalPrice;
                        } else {
                            //-- for standard product set the quantity in contract same like quantity product
                            newContractObj.Quantity__c = opptyProdREC.Quantity;

                            if ( opptyProdREC.Product2.Revenue_Type__c != 'Free') {
                                newContractObj.Price__c = opptyProdREC.UnitPrice;
                                recurringProdUnitPrice = opptyProdREC.UnitPrice;
                            }
                            else {
                                //-- set the price of free contract using the field of FreeMRC_Price__c (calculate in billing_startdate is change, full or prorate)
                                newContractObj.Price__c = opptyProdREC.FreeMRC_Price__c; 
                                
                            }
                        }


                        
                        Date newContractStartDate = null;
                        Date newContractEndDate = null;
                        /***
                         * This is for handling for UPGRADE, DOWNGRADE, REROUTE, RELOCATION
                         ***/
                        if (opportunityRec.service_type__c == 'Upgrade' ||
                            opportunityRec.service_type__c == 'Downgrade' ||
                            opportunityRec.service_type__c == 'Reroute' ||
                            opportunityRec.service_type__c == 'Relocation') 
                        {
                            

                            //-- GET New Contract End Date for Upgrade/Downgrade purpose
                            String UOM = '';
                            Integer ContractTerm = 0;
                            UOM = opportunityRec.Link_Related__r.Contract_Item_Rel__r.Periode_UOM__c;
                            ContractTerm = Integer.valueof(opportunityRec.Link_Related__r.Contract_Item_Rel__r.Contract_Term__c);
                            Date lastContractEndDate = opportunityRec.Link_Related__r.Contract_Item_Rel__r.end_date__c;
                            //-- get real Last Contract Start Date
                            Date lastContractStartDate = null;
                            if (lastContractEndDate <> null) lastContractStartDate = lastContractEndDate.addmonths(ContractTerm * -1).adddays(1);
                            //-- set NEW contract Start Date
                            newContractStartDate = newContractObj.Start_Date__c;
                            //-- get NEW contract END Date
                            newContractEndDate = apputils.getNewContractEndDate(lastContractStartDate, lastContractEndDate, ContractTerm,
                                newContractStartDate, UOM, integer.valueof(opportunityRec.Contract_Periode__c), opportunityRec.Periode_UOM__c);
                            /*---------------------------------------------------*/
                            if (opptyProdREC.Product2.Revenue_Type__c == 'Recurring') {
                                //-- fill previous contract information (bandwidth before and contract before)
                                newContractObj.Bandwidth_Before_Filled__c = opportunityRec.Link_Related__r.Contract_Item_Rel__r.Bandwidth_filled__c;
                                newContractObj.Bandwidth_Before_UoM_filled__c = opportunityRec.Link_Related__r.Contract_Item_Rel__r.Bandwidth_UoM_filled__c;
                                newContractObj.Previous_Contract_Header_ID_filled__c = opportunityRec.Link_Related__r.Contract_Item_Rel__r.Contract_ID__c;
                                newContractObj.Previous_Contract_Item_No_filled__c = opportunityRec.Link_Related__r.Contract_Item_Rel__r.SAP_ID__c;

                            }
                        }

                        //-- UPGRADE --
                        if (opportunityRec.service_type__c == 'Upgrade') {
                            newContractObj.PROJECT_TYPE__c = 'UPGR';
                            if (opptyProdREC.Product2.Revenue_Type__c == 'Recurring') {
                                //-- set end-contract-date from calculation above                               
                                newContractObj.End_Date__c = newContractEndDate;
                                //-- set previous contract 
                                newContractObj.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                            } else {
                                //-- set to end date on opportunity-lineitem (product)
                                newContractObj.End_Date__c = opptyProdREC.Contract_End_Date__c;
                            }
                        }

                        //-- DOWNGRADE --
                        if (opportunityRec.service_type__c == 'Downgrade') {
                            newContractObj.PROJECT_TYPE__c = 'DWGR';
                            if (opptyProdREC.Product2.Revenue_Type__c == 'Recurring') {
                                //-- set end-contract-date from calculation above                               
                                newContractObj.End_Date__c = newContractEndDate;
                                //-- set previous contract 
                                newContractObj.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                            } else {
                                //-- set to end date on opportunity-lineitem (product)
                                newContractObj.End_Date__c = opptyProdREC.Contract_End_Date__c;
                            }
                        }

                        //-- REROUTE --
                        if (opportunityRec.service_type__c == 'Reroute') {
                            newContractObj.PROJECT_TYPE__c = 'RERU';
                            //-- set previous contract 
                            newContractObj.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                            //-- set to end date on opportunity-lineitem (product)
                            newContractObj.End_Date__c = opptyProdREC.Contract_End_Date__c;
                        }

                        //-- RELOCATION --
                        if (opportunityRec.service_type__c == 'Relocation') {
                            newContractObj.PROJECT_TYPE__c = 'RELO';
                            //-- set previous contract 
                            newContractObj.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                            //-- set to end date on opportunity-lineitem (product)
                            newContractObj.End_Date__c = opptyProdREC.Contract_End_Date__c;
                        }

                        //-- REACTIVATION --
                        if (opportunityRec.service_type__c == 'Reactivation') {
                            newContractObj.PROJECT_TYPE__c = 'REAC';
                            //-- set previous contract 
                            newContractObj.previous_contract__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                            //-- set to end date on opportunity-lineitem (product)
                            newContractObj.End_Date__c = opptyProdREC.Contract_End_Date__c;
                        }

                        

                        //-- add contract object to the list
                        contractList.add(newContractObj);


                        //-- keep the start-date of recurring contract. for upgrade/downgrade purposes
                        if (opptyProdREC.Product2.Revenue_Type__c == 'Recurring' && newRecurringContractStartDate <> null) {
                            newRecurringContractStartDate = opptyProdREC.Contract_Start_Date__c;
                        }
                        

                    }
                }

                //-- Do Insert Contract-Items on database (after loop)
                system.debug('================ contractList : ' + contractList);
                insert contractList;

                //------------------------------------------------------------------------------- .end of Create CONTRACT_ITEMS (CONTRACT object)







                //-- III. Create Contact-Ticket-Items (detail)  --- related to Contract-Item
                List <Contract_ticket_item__c> CTIList = new List <Contract_ticket_item__c>();
                Integer orderNo = 1;
                for (Contract contractItemRec: contractList) {
                    //-- create Contact-Ticket-Item
                    Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
                    labelName = 'Item for ' + contractItemRec.name;
                    //label.replace('Contract Item of','');
                    if (labelName.length() > 75){
                        CTI.Name = labelName.left(75) + ' ...';
                    }
                       
                    else CTI.Name = labelName;
                    CTI.full_name__c = labelName.left(255);
                    CTI.Contract_Ticket__c = contractTicket.id;
                    CTI.Contract_Item__c = contractItemRec.id;
                    CTI.Flag__c = 'FIRST INVOICE';

                    CTI.order__c = orderNo;
                    orderNo++;

                    CTIList.add(CTI);

                }
                //----------------------------...............................----- .end of Create CONTRACT_TICKET ITEMS 
                
                
                
                
                
                //-- ADD PREVIOUS CONTRACT FOR UPGRADE / DOWNGRADE (existing)
                if ((OpportunityRec.Service_Type__c == 'Upgrade' || OpportunityRec.Service_Type__c ==
                    'Downgrade')) { //-- get last contract from related link on this opportunity
                    //Contract prevContract = O.Link_Related__r.Contract_Item_Rel__c;
                    //-- *** info : O.Link_Related__r.Contract_Item_Rel__r IS THE LAST-CONTRACT-THAT-LINK-USED *** 
                    List < Contract > contractItemPrevList = [select id, start_date__c, end_date__c, end_date_before__c
                        FROM Contract
                        WHERE ID =: opportunityRec.Link_Related__r.Contract_Item_Rel__c
                    ];
                    system.debug('========= hello :' + contractItemPrevList);
                    system.debug('========= hello :' + opportunityRec.Link_Related__r.Contract_Item_Rel__r.end_date__c + ' ** ' +
                        newRecurringContractStartDate);
                    if (contractItemPrevList.size() > 0) {
                        Contract contractItemPrevRec = contractItemPrevList[0];

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
                        if (newRecurringContractStartDate != null) {
                            contractItemPrevRec.Bill_Plan_End_Date__c = newRecurringContractStartDate.adddays(-1);
                        }
                        update contractItemPrevRec;
                    }

                    Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
                    labelName = 'Item for ' + opportunityRec.Link_Related__r.Contract_Item_Rel__r.name + ' (last)';
                    if (labelName.length() > 75)
                        CTI.Name = labelName.left(75) + ' ...';
                    else CTI.Name = labelName;
                    CTI.full_name__C = labelName.left(255);
                    CTI.Contract_Ticket__c = contractTicket.id;
                    CTI.Contract_Item__c = opportunityRec.Link_Related__r.Contract_Item_Rel__c;
                    CTI.FLAG__c = 'LAST INVOICE';
                    //** 4. Update : 20-Sep-2019 by doddy 
                    //-- Set invoced status to true for last/previous contract
                    //-- handling for some contract that had been invoiced before this event
                    //-- so, the SAP will not send the last invoice status
                    CTI.isInvoiced__c = true;
                    CTIList.add(CTI);
                }
                //-- insert contract-Ticket-item list into Contract_Ticket_item__c object db
                insert CTIList;
            }
        } //-- .endOF IF there is NO Contract-Ticket for the this Opportunity --> CREATE NEW CONTRACT TICKET
        else { //-- IF there is Contract-Ticket on database (exist)
            if (contractTicketList.size() == 1) {
                Contract_Ticket__c contractTicket = contractTicketList[0];
                contractTicket.TicketStatus__c = 'Review By Contract Manager';
            }
            update contractTicketList;
        }
    }

    /**
     * method CreateBrustableContractFromLink & CreateUsageContractsFromLink commeted by doddy 11 oct 2023
     * for FRE MRC deplyment purpose
     * 

    /**
    * @description : Create the Contract-Package of BURSTable usage based on specific Link-ID 
    * @author Doddy Prima | 10-01-2023 
    * @param Id linkID 
    **/

    
    public Id CreateBrustableContractFromLink(Id linkID,Id BillingReqId) {
        
        Id contractBurstable;

        /*
        //TODO: please implement to try catch for error handling
        try {
            String labelName = '';
            Link__c linkRec = new Link__c();
            Set<Id> recurringContractIds = new Set<Id>();
            List<Link__c> linkList = [
                SELECT Id, Contract_Item_Rel__r.Name, 
                    Contract_Item_Rel__c, Contract_Item_Rel__r.Opportunity__c, Contract_Item_Rel__r.ContractTerm, 
                    Contract_Item_Rel__r.BP_Payer__c,Contract_Item_Rel__r.Auto_renewal__C, Contract_Item_Rel__r.start_date__c, 
                    Contract_Item_Rel__r.BP_VAT__c, Contract_Item_Rel__r.end_date__c,
                    Contract_Item_Rel__r.RecordTypeId, Contract_Item_Rel__r.Periode_UOM__c, 
                    Contract_Item_Rel__r.Account_Site_A_BP_Site__c, Contract_Item_Rel__r.Contract_Term__c, 
                    Contract_Item_Rel__r.Account_Site_B_BP_Site__c, Contract_Item_Rel__r.Bandwidth_filled__c,
                    Contract_Item_Rel__r.Product_Charge_Type_filled__c, 
                    Contract_Item_Rel__r.Bandwidth_UoM_filled__c, Contract_Item_Rel__r.Product_SAP_Code__c, 
                    Contract_Item_Rel__r.Contract_ID__c, Contract_Item_Rel__r.Account_BP_Payer__c, 
                    Contract_Item_Rel__r.SAP_ID__c, Contract_Item_Rel__r.Account_BP_VAT__c,
                    Contract_Item_Rel__r.Quantity__c, Contract_Item_Rel__r.Account__c, Contract_Item_Rel__r.Bandwidth_Before_UoM_filled__c, 
                    Contract_Item_Rel__r.Product__c, Contract_Item_Rel__r.Billing_Type__c
                FROM Link__c
                WHERE id =: linkID
            ];

            // If Link is available ->
            if ( linkList.size() > 0 ) {
                linkRec = linkList[0];
                recurringContractIds.add(linkRec.Contract_Item_Rel__c);
                List<Contract> recurringContractItemList = SoqlHelper.getRecordListWithAllFieldsByIds(recurringContractIds,'Contract');
                // IF Contract Record is available ->
                if ( recurringContractItemList.size() > 0 ) {
                    /**
                     *  Processing Order : 
                        I. Create CONTRACT-TICKET, 
                        II. Create CONTRACT-ITEM, and 
                        III. Create Contract-TICKET-ITEM
                    * 
                    *  */ 
    /*
                    //-- I. Create CONTRACT-TICKET (header) ---------------------------------------------------------------
                    Contract_ticket__c contractTicket = new Contract_ticket__c();
                
                    contractTicket.Account__c = linkRec.Contract_Item_Rel__r.Account__c;
                    contractTicket.Currency__c = 'IDR';

                    labelName = 'Contract Ticket for "' + linkRec.Contract_Item_Rel__r.name + '" Link "(" Burstable ")"';
                    contractTicket.Name = labelName.length() > 75  ? labelName.left(75) + ' ...' : labelName;
                    contractTicket.Full_Name__C = labelName.left(255);

                    contractTicket.TicketStatus__c = 'Review By Contract Manager';
                    insert contractTicket;
                    //------------------------------------------------------------------- .end of Create CONTRACT TICKET


                    //-- II. Create CONTRACT-ITEM (Contract object) -----------------------------------------------------
                    date newRecurringContractStartDate;
                    
                    // Clone Contract-Item Existing
                    Contract recurringContractRec = recurringContractItemList[0];

                    Contract burstableContractRec = new Contract();
                    burstableContractRec = recurringContractRec.clone (false, true,false,false);
                    
                    labelName = linkRec.Contract_Item_Rel__r.Name + ' (Burstable) ';
                    burstableContractRec.Name = labelName.length() > 75 ? labelName.left(75) + ' ...' : labelName;

                    burstableContractRec.Full_Name__C = labelName.left(255);
                    
                    Integer dStart = recurringContractRec.start_date__c.day();
                    DateTime dt = System.now();
                    Date extactedDate = dt.date();
                    Datetime mydate = datetime.now();
                    Integer dNow = mydate.Day();
                    Integer mNow = mydate.month();
                    Integer yNow = mydate.Year();
                    Date DtEnd = extactedDate.addMonths(1).toStartofMonth().addDays(-1);
                    
                    // Set Start and End Date Contract
                    burstableContractRec.Start_Date__c = (recurringContractRec.Start_Date__c >= extactedDate 
                        ? recurringContractRec.Start_Date__c : Date.newInstance(yNow,mNow, 01));

                    burstableContractRec.End_Date__c = (recurringContractRec.End_Date__c <= DtEnd 
                        ? recurringContractRec.End_Date__c : DtEnd);

                    burstableContractRec.Status = 'Draft';
                    burstableContractRec.Billing_Request__c =BillingReqId;
                    // ResSet Price and Bandwidth
                    burstableContractRec.Price__c = 0;      //TODO: TBC to XL business user
                    burstableContractRec.Bandwidth_filled__c = 0;  //TODO: TBC to XL business user

                    //-- Do Insert Contract-Items on database
                    system.debug('================ burstableContractRec : ' + burstableContractRec);
                    insert burstableContractRec;
                    system.debug('================ burstableContractRec ID : ' + burstableContractRec.Id);
                    
                    //------------------------------------------ .end of Create CONTRACT-ITEM (CONTRACT object)   
                
                    //-- III. Create Contract-TICKET-ITEM (detail)  --- related to Contract-Item
                    Contract_Ticket_Item__c contractTicketItemRec = new Contract_Ticket_Item__c();
                    labelName = 'Item for ' + burstableContractRec.name;
                    contractTicketItemRec.Name = labelName.length() > 75 ? labelName.left(75) + ' ...' : labelName;
                    
                    contractTicketItemRec.full_name__c = labelName.left(255);

                    contractTicketItemRec.Contract_Ticket__c = contractTicket.id;
                    contractTicketItemRec.Contract_Item__c = burstableContractRec.id;
                    contractTicketItemRec.FLAG__c = 'FIRST INVOICE';    //TODO: need confirmation to XL business user


                    // put the recurring contract as a parent of burstable contract 
                    // TODO: add new custom field in contract object, need confirmation to XL business user
                    // TEMP-SYNTAX-OFF: contractTicketItemRec.contract_Parent__c = recurringContractRec.id;
                    insert contractTicketItemRec;
                    //----------------------------..........................----- .end of Create CONTRACT_TICKET ITEMS 
                    contractBurstable = burstableContractRec.Id;
                }
            
            }
        } catch (Exception e) {
            contractBurstable = null;
            String errMessage = 'Error on Contract_Service_v2.cls - CreateBrustableContractFromLink method::' 
                + e.getmessage() + ' - ' + e.getStacktraceString() + '::' + e.getLineNumber();
            System.Debug('========== errMessage : ' + errMessage);
            AppUtils.putError(errMessage);
        }

        */
        return contractBurstable;
    
    }

    public Id CreateUsageContractsFromLink(Id linkID, Id billingRequestId) {
        
        Id contractUsage;

        /*
        try {
        Link__c linkRec = [
            SELECT Id, BP_Payer__c, BP_Site_A__c, BP_VAT__c, Contract_Item_Rel__r.Name, 
            Contract_Item_Rel__c, Contract_Item_Rel__r.Opportunity__c, Contract_Item_Rel__r.ContractTerm, 
            Contract_Item_Rel__r.BP_Payer__c,Contract_Item_Rel__r.Auto_renewal__C, Contract_Item_Rel__r.start_date__c, 
            Contract_Item_Rel__r.BP_VAT__c, Contract_Item_Rel__r.end_date__c,
            Contract_Item_Rel__r.RecordTypeId, Contract_Item_Rel__r.Periode_UOM__c, 
            Contract_Item_Rel__r.Account_Site_A_BP_Site__c, Contract_Item_Rel__r.Contract_Term__c, 
            Contract_Item_Rel__r.Account_Site_B_BP_Site__c, Contract_Item_Rel__r.Bandwidth_filled__c,
            Contract_Item_Rel__r.Product_Charge_Type_filled__c, 
            Contract_Item_Rel__r.Bandwidth_UoM_filled__c, Contract_Item_Rel__r.Product_SAP_Code__c, 
            Contract_Item_Rel__r.Contract_ID__c, Contract_Item_Rel__r.Account_BP_Payer__c, 
            Contract_Item_Rel__r.SAP_ID__c, Contract_Item_Rel__r.Account_BP_VAT__c,
            Contract_Item_Rel__r.Quantity__c, Contract_Item_Rel__r.Account__c, Contract_Item_Rel__r.Bandwidth_Before_UoM_filled__c, 
            Contract_Item_Rel__r.Product__c, Contract_Item_Rel__r.Billing_Type__c,Contract_Item_Rel__r.AccountId
        FROM Link__c
        WHERE id =: linkID
        ];

        String zeroPriceString = '';
        //-- II. Create contract-items (Contract object)
        List<Contract> contractList = new List<Contract>();
        
        date newRecurringContractStartDate;
        Contract newContractObj = new Contract();
        labelName = 'Contract Ticket for "' + linkRec.Contract_Item_Rel__r.name + '" Link "(" Usage ")"';
        if (labelName.length() > 75){
            newContractObj.Name = labelName.left(75) + ' ...';
        }else{
            newContractObj.Name = labelName;
        }
           
        newContractObj.Full_Name__C = labelName.left(255);
      //  newContractObj.Start_Date__c = ;

        //newContractObj.End_Date__c = ;
        newContractObj.AccountID = linkRec.Contract_Item_Rel__r.AccountId;
        newContractObj.Billing_Type__c = 'Monthly';
        newContractObj.Account_BP_Payer__c = linkRec.BP_Payer__c;
        newContractObj.Account_BP_VAT__c = linkRec.BP_VAT__c;
        newContractObj.Previous_Contract__c = null;
        newContractObj.Previous_Contract_Header_ID_filled__c = null;
        newContractObj.Previous_Contract_Item_No_filled__c = null;
        //-- for BizStore 
        //newContractObj.recordtypeid='';
       // newContractObj.Bandwidth_Before_UoM_filled__c = 'Unit';
       // newContractObj.Bandwidth_UoM_filled__c = 'Unit';
       // newContractObj.Auto_Renewal__c = true;
        //-- for OTHERS
        //
        newContractObj.Link__c = linkRec.Id;
        newContractObj.Account_Site_A_BP_Site__c = linkRec.Contract_Item_Rel__r.Account_Site_A_BP_Site__c;
        newContractObj.Account_Site_B_BP_Site__c = linkRec.Contract_Item_Rel__r.Account_Site_B_BP_Site__c;
        newContractObj.ContractTerm = 1;
        newContractObj.Billing_Request__c =billingRequestId;
       // newContractObj.Auto_renewal__c = True;
        Date newContractStartDate = null;
        Date newContractEndDate = null;

       // contractList.add(newContractObj);
        system.debug('========== contractList ' + newContractObj);
        system.debug('================ contractList : ' + contractList);
        insert newContractObj;

        //-- III. Create Contact-Ticket-Items (detail)  --- related to Contract-Item
        List <Contract_ticket_item__c> CTIList = new List <Contract_ticket_item__c>();
        for (Contract contractItemRec: contractList) {
            //-- create Contact-Ticket-Item
            Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
            labelName = 'Item for ' + contractItemRec.name;
            //labelName.replace('Contract Item of','');

            if (labelName.length() > 75)
                CTI.Name = labelName.left(75) + ' ...';
            else CTI.Name = labelName;
            CTI.full_name__c = labelName.left(255);

            //CTI.Contract_Ticket__c = contractTicket.id;
            CTI.Contract_Item__c = contractItemRec.id;
            CTI.FLAG__c = 'FIRST INVOICE';

            CTIList.add(CTI);
        }
        insert CTIList;
        contractUsage = newContractObj.Id;
        } catch (Exception e) {
            contractUsage = null;
            String errMessage = 'Error on Contract_Service_v2.cls - CreateUsageContractsFromLink method::' 
                + e.getmessage() + ' - ' + e.getStacktraceString() + '::' + e.getLineNumber();
            System.Debug('========== errMessage : ' + errMessage);
            AppUtils.putError(errMessage);
        }
        
        */


        return contractUsage;

        
    }

    

    public void updateContractsFromOpportunity (string opportunityID) {
        
        Date freeMRCContractLastEndDate = null;
        
        //update contract if oppty already have contract ticket & item
        system.debug('========== get in updateContractsFromOpportunity');
        Opportunity opportunityRec = [
            SELECT id, Note__c, StageName, Account_Site_A__c, Link_Related__c, BP_Payer__c,
                BP_VAT__c, Service_Type__c, auto_renewal__c, recordtype.Name, Account_Site_B__c, 
                Contract_Periode__c, Periode_UOM__c, AccountID,
                BW_after__c, Uom_BW_After__c 
            FROM opportunity 
            WHERE id =: OpportunityID
        ];
        String recordTypeName = opportunityRec.recordtype.name;

        try {
            //query contract ticket dan oppty line itemnya
            List<Contract_Ticket__c> contractTicketList = [
                SELECT id 
                FROM Contract_Ticket__c 
                WHERE Opportunity__c =: OpportunityID
                ORDER BY CreatedDate DESC limit 1
            ];

            Contract_Ticket__c contractTicketREC = new Contract_Ticket__c();
            if (contractTicketList.size()> 0) {
                contractTicketREC = contractTicketList[0];
            }

            list < OpportunityLineItem > nonFreeMRCOpptyProd = [
                SELECT id, Quantity, product2id, billing_type__c, 
                    contract_start_date__c, contract_end_date__c, UnitPrice ,
                    Product2.Revenue_Type__c
                FROM OpportunityLineItem 
                WHERE OpportunityID =: OpportunityID
                    AND Revenue_Type__c <> 'Free'
            ];

            //  list<Contract_Ticket_Item__c> listCTI=[SELECT id FROM Contract_ticket_item__c WHERE Contract_Ticket__c=:CT.id];
            List < Contract > contractList = [
                SELECT id, Quantity__c, Link__c, Account_BP_Payer__c, Account_Site_A_BP_Site__c, Account_BP_VAT__c, Product__c,                
                    Billing_Type__c, Start_Date__c, End_Date__c, price__c, auto_renewal__c, StartDate, EndDate 
                FROM Contract 
                WHERE Opportunity__c =:OpportunityID
                    AND Product__r.Revenue_Type__c <> 'Free'
            ];

            // get FRE MRC SO (contract) with so_number is not empty
            List < Contract > freeMRCWithSONumberContractList = [
                SELECT id
                FROM Contract 
                WHERE Opportunity__c =:OpportunityID
                    AND (SO_Number__c <> '' OR SO_Number__c <> null )
            ];

            // if any freeMRC with SO number then do not re-create freeMRC contract (SO)
            // if NO freeMRC with SO number then re-create freeMRC contract (SO)
            // delete first then re-create

            if (freeMRCWithSONumberContractList.size() == 0 ) {
                // delete contract ticket item first
                List < Contract_ticket_item__c > freeMRCContracTicketItemtList = [
                    SELECT id
                    FROM Contract_ticket_item__c 
                    WHERE contract_ticket__c =:contractTicketREC.id
                        AND Contract_Item__r.Product__r.Revenue_Type__c = 'Free'
                ];
                
                if (freeMRCContracTicketItemtList.size() > 0)  {
                    delete freeMRCContracTicketItemtList;
                }
                
                // delete contract first
                List < Contract > freeMRCContractList = [
                    SELECT id
                    FROM Contract 
                    WHERE Opportunity__c =:OpportunityID
                        AND Product__r.Revenue_Type__c = 'Free'
                ];
                
                if (freeMRCContractList.size() > 0)  {
                    delete freeMRCContractList;
                }

                // re-create
                //-- II. Create contract-items (Contract object) -----------------------------------------------------------------
                List <Contract> newFreeMRCContractList = new list <Contract>();
                List <OpportunityLineItem > freeMRCOpptyProdList = [
                    SELECT Billing_Type__c, Product2Id, Product2.Name, Revenue_Type__c
                        , Contract_Start_Date__c, Contract_End_Date__c, Unitprice, totalprice, Quantity
                        , Product2.Revenue_Type__c, Product2.Bandwidth__c, Product2.UoM_Bandwidth__c
                        , Product2.SAP_Code__c , Product2.Distribution_Channel__c, FreeMRC_Price__c
                        , CurrencyIsoCode
                    FROM OpportunityLineItem 
                    WHERE OpportunityID =: opportunityRec.id
                        AND Revenue_Type__c = 'Free'
                    ORDER BY createdDate ASC
                ];

                
                for (OpportunityLineItem opptyProdREC : freeMRCOpptyProdList) {

                    // Create new Contract Instance object
                    Contract newContractObj = new Contract();

                    // set Contract Name
                    if ( opptyProdREC.Product2.Revenue_Type__c == 'One Time' || opptyProdREC.Product2.Revenue_Type__c == 'Recurring' ) {
                        labelName = 'Contract: ' + opptyProdREC.Product2.Name + '';
                    }
                    else if ( opptyProdREC.Product2.Revenue_Type__c == 'Free') {
                        Date startDate = opptyProdREC.Contract_Start_Date__c;
                        String startDTString = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day()).format('ddMMMyy');
                        Date endDate = opptyProdREC.Contract_End_Date__c;
                        String endDTString = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day()).format('ddMMMyy');

                        labelName = 'SO (Free): ['  +  startDTString  + '-' + endDTString + '] ' + ' ' + opptyProdREC.Product2.Name + '';
                    }

                    if (labelName.length() > 75){
                        newContractObj.Name = labelName.left(75) + ' ...';
                    } else {
                        newContractObj.Name = labelName; 
                    }

                    

                    newContractObj.Full_Name__c = labelName.left(255);
                    newContractObj.AccountID = OpportunityRec.AccountID;
                    newContractObj.Opportunity__c = opportunityRec.id;
                    newContractObj.Product__c = opptyProdREC.Product2id;
                    newContractObj.Billing_Type__c = opptyProdREC.Billing_Type__c;
                    newContractObj.Account_BP_Payer__c = opportunityRec.BP_Payer__c;
                    newContractObj.Account_BP_VAT__c = opportunityRec.BP_VAT__c;
                    newContractObj.Link__c = opportunityRec.Link_Related__c;
                    newContractObj.Account_Site_A_BP_Site__c = OpportunityRec.Account_Site_A__c;
                    newContractObj.Account_Site_B_BP_Site__c = OpportunityRec.Account_Site_B__c;
                    newContractObj.Auto_renewal__C = false;

                    //-- SET Contract Start Date
                    newContractObj.Start_Date__c = opptyProdREC.Contract_Start_Date__c;
                    
                    //-- SET PROJECT TYPE
                    if (opportunityRec.service_type__c == 'NewLink' ||
                        opportunityRec.service_type__c == 'E-Commerce' ||
                        recordTypeName == 'Project Bulkshare'
                    ) {
                        newContractObj.PROJECT_TYPE__c = 'NEW';
                    }

                    //-- SET END DATE
                    if (opportunityRec.service_type__c == 'NewLink' ||
                        opportunityRec.service_type__c == 'E-Commerce' ||
                        recordTypeName == 'Project Bulkshare'
                        ) 
                    {
                        newContractObj.End_Date__c = opptyProdREC.Contract_End_Date__c;
                        freeMRCContractLastEndDate = opptyProdREC.Contract_End_Date__c;
                    }

                    //-- FILL PRODUCT INFORMATION
                    //-- new way : get value from technical detail on opportunity
                    newContractObj.Bandwidth_filled__c = integer.valueof(opportunityRec.BW_after__c);
                    newContractObj.Bandwidth_UoM_filled__c = opportunityRec.Uom_BW_After__c;
                    newContractObj.Product_Charge_Type_filled__c = opptyProdREC.Product2.Revenue_Type__c;
                    newContractObj.Product_SAP_Code__c = opptyProdREC.Product2.SAP_Code__c;
                    newContractObj.Distribution_Channel__c = opptyProdREC.Product2.Distribution_Channel__c;


                    //-- set Contract Term
                    newContractObj.ContractTerm = 1;
                    newContractObj.Contract_Term__c = 1;
                    newContractObj.Periode_UOM__c = 'Month';

                    
                    //-- SET QUANTITY and PRICE ---
                    newContractObj.CurrencyIsoCode = opptyProdREC.CurrencyIsoCode;
                    newContractObj.Quantity__c = opptyProdREC.Quantity;
                    //-- set the price of free contract using the field of FreeMRC_Price__c (calculate in billing_startdate is change, full or prorate)
                    newContractObj.Price__c = opptyProdREC.FreeMRC_Price__c; 


                    //-- add contract object to the list
                    newFreeMRCContractList.add(newContractObj);
                
                } // end of loop
                

                //-- Do Insert Contract-Items on database (after loop)
                system.debug('================ newFreeMRCContractList : ' + newFreeMRCContractList);
                insert newFreeMRCContractList;

                //------------------------------------------------------------------------------- .end of Create CONTRACT_ITEMS (CONTRACT object)


                //-- III. Create Contact-Ticket-Items (detail)  --- related to Contract-Item
                List <Contract_ticket_item__c> CTIList = new List <Contract_ticket_item__c>();
                Integer orderNo = nonFreeMRCOpptyProd.size() + 1;
                for (Contract contractItemRec: newFreeMRCContractList) {
                    //-- create Contact-Ticket-Item
                    Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
                    labelName = 'Item for ' + contractItemRec.name;
                    //label.replace('Contract Item of','');
                    if (labelName.length() > 75){
                        CTI.Name = labelName.left(75) + ' ...';
                    }
                    
                    else CTI.Name = labelName;
                    CTI.full_name__c = labelName.left(255);
                    CTI.Contract_Ticket__c = contractTicketREC.id;
                    CTI.Contract_Item__c = contractItemRec.id;
                    CTI.Flag__c = 'FIRST INVOICE';

                    CTI.order__c = orderNo;
                    orderNo++;

                    CTIList.add(CTI);

                }
                //----------------------------...............................----- .end of Create CONTRACT_TICKET ITEMS 
                
                //-- insert contract-Ticket-item list into Contract_Ticket_item__c object db
                insert CTIList;

            }


            //-- if any Free MRC then start contract set to the Day AFTER the end of last Free MRC periode
            Date newRecurringContractStartDate = null;
            if ( freeMRCContractLastEndDate <> null ) {
                newRecurringContractStartDate = freeMRCContractLastEndDate.addDays(1);
            }



            // --------------------------------------------------------------------------------------------------------
            // UPDATE ON TIME AND RECURRING CONTRACT (NON FREE MRC)
            system.debug('========== nonFreeMRCOpptyProd : ' + nonFreeMRCOpptyProd);

            for (Integer i = 0; i < nonFreeMRCOpptyProd.size(); i++) {
                for (Integer j = 0; j < contractList.size(); j++) {

                    // set general values
                    contractList[j].Account_Site_A_BP_Site__c = opportunityRec.Account_Site_A__c;
                    if (opportunityRec.RecordType.Name.Contains('Subscription Two Site')) {
                        contractList[j].Account_Site_B_BP_Site__c = opportunityRec.Account_Site_B__c;
                    }
                    contractList[j].Account_BP_Payer__c = opportunityRec.BP_Payer__c;
                    contractList[j].Account_BP_VAT__c = opportunityRec.BP_VAT__c;

                    if (opportunityRec.Link_Related__c != contractList[j].Link__c) {
                        contractList[j].Link__c = opportunityRec.Link_Related__c;
                    }

                    // set contract values  based on product name
                    if (nonFreeMRCOpptyProd[i].Product2id == contractList[j].Product__c || test.isrunningtest()) {
                        contractList[j].billing_type__c = nonFreeMRCOpptyProd[i].billing_type__c;
                        
                        // set start contract date
                        if ( nonFreeMRCOpptyProd[i].Product2.Revenue_Type__c == 'Recurring' &&
                            newRecurringContractStartDate <> null
                        ) {
                            // if any free mrc then using newRecurringContractStartDate variable
                            contractList[j].startdate = newRecurringContractStartDate;
                            contractList[j].start_date__c = newRecurringContractStartDate;
                        }
                        else { 
                            contractList[j].startdate = nonFreeMRCOpptyProd[i].Contract_start_date__C;
                            contractList[j].start_date__c = nonFreeMRCOpptyProd[i].Contract_start_date__C;
                        }


                        contractList[j].end_date__c = nonFreeMRCOpptyProd[i].Contract_end_date__c;
                        contractList[j].Quantity__c = nonFreeMRCOpptyProd[i].Quantity;
                        contractList[j].Price__c = nonFreeMRCOpptyProd[i].UnitPrice;
                        
                        contractList[j].contractterm = Integer.valueof(opportunityRec.Contract_Periode__c);
                    }
                }
            }
            //Opp.StageName='Waiting for Contract';
            //Opp.Note__c='Send Email To Contract Manager';
            //update Opp;
            
            system.debug('========== contractList : ' + contractList);
            update contractList;

        } catch (exception e) {
            string errMessage = e.getmessage() + '  ' + e.getstacktracestring();
            system.debug('========== errMessage : ' + errMessage);
            AppUtils.putError(errMessage);
        }


        
        
    }

    /** 
     * old versian - archive as of October 12, 2023
     * by doddy
     * */ 
    
    public void updateContractsFromOpportunity_v1 (string opportunityID) {
        /*
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
                    if(Opp.RecordType.Name.Contains('Subscription Two Site'))
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
        
        */
    }
    

    public void UpdateContractsFromBAExtension(string extensionID) {
        //update contract ticket from BA Extension
        Contract_Extension__c CE = [SELECT Link__c, Extension_Start_Date__c, Extension_End_Date__c FROM Contract_Extension__c WHERE ID =: ExtensionID];
        Contract_Ticket__c CT = [SELECT id FROM Contract_Ticket__c WHERE BA_Extension__c =: extensionid];
        list < Contract_Ticket_Item__c > CTIlist = [SELECT id, Contract_Item__c FROM Contract_Ticket_Item__c WHERE Contract_Ticket__c =: CT.id AND Flag__c =
            'FIRST INVOICE'
        ];
        Contract C = new Contract();
        C.id = CTILIST[0].Contract_Item__c;
        C.link__c = CE.Link__c;
        C.Start_Date__c = CE.Extension_Start_Date__c;
        C.End_Date__C = CE.Extension_End_Date__c;
        update C;
    }

    public void CreateContractsFromBAExtension(string extensionID) {
        //create contract ticket from BA Extension
        Contract_Extension__c contractExtension = [SELECT id, Existing_Contract_Item__r.Contract_id__c, Existing_Contract_Item__r.ContractTerm, 
            Existing_Contract_Item__r.SAP_ID__c, Existing_Contract_Item__r.Billing_Type__c, 
            Existing_Contract_Item__r.Contract_Header__c, Existing_Contract_Item__r.Quantity__c,
            Existing_Contract_Item__r.Account_BP_Payer__c, Existing_Contract_Item__r.Account_BP_VAT__c, Name, 
            Link__r.Contract_item_rel__c, Link__r.Contract_item_rel__r.Name, Account__c, Link__c, Extension_Start_Date__c, 
            Extension_End_Date__c, Link__r.Uom__c, Link__r.Capacity_Bandwidth__c, Link__r.Site_A_Name__c, Link__r.Site_B_Name__c, 
            Link__r.Link_id__c, Existing_Contract_item__c,
            Existing_Contract_Item__r.Product__c, Existing_Contract_Item__r.Opportunity__c, 
            Extension_Monthly_Price__c, Status__c,
            Existing_Contract_Item__r.Bandwidth_UoM_filled__c, 
            Existing_Contract_Item__r.Bandwidth_filled__c, 
            Existing_Contract_Item__r.Product_SAP_Code__c, 
            Existing_Contract_Item__r.Product_Charge_Type_Filled__c 
            FROM Contract_Extension__c WHERE ID =: extensionID
        ];
        Contract_Ticket__c newContractTicket = new Contract_Ticket__c();
        labelName = 'Contract Ticket for "' + contractExtension.Name + '"';
        newContractTicket.Name = labelName.left(75);
        newContractTicket.Full_Name__C = labelName.left(255);
        newContractTicket.Account__c = contractExtension.Account__c;
        newContractTicket.TicketStatus__c = 'Review By Contract Manager';
        newContractTicket.BA_Extension__c = contractExtension.id;
        //  CT.Opportunity__c=CE.Existing_Contract_Item__r.Opportunity__c;
        insert newContractTicket;
        Contract contractObj = new Contract();
        labelName = 'Contract For "' + contractExtension.Name + '"';
        contractObj.Name = labelName.left(75);
        contractObj.Full_Name__C = labelName.left(255);
        contractObj.Billing_type__c = contractExtension.Existing_Contract_Item__r.Billing_Type__c;
        contractObj.ContractTerm = (contractExtension.Extension_start_date__c.daysbetween(contractExtension.Extension_end_date__c)) / 12; //CE.Existing_Contract_Item__r.ContractTerm;
        contractObj.Accountid = contractExtension.Account__c;
        contractObj.Auto_Renewal__c = false;
        contractObj.Link__c = contractExtension.Link__c;
        contractObj.Product__c = contractExtension.Existing_Contract_Item__r.Product__c;
        contractObj.Price__c = contractExtension.Extension_Monthly_Price__c;
        contractObj.Start_Date__c = contractExtension.Extension_Start_Date__c;
        contractObj.End_Date__C = contractExtension.Extension_End_Date__c;
        contractObj.Previous_Contract__c = contractExtension.Existing_Contract_item__c;
        contractObj.Project_Type__c = 'RENE';
        contractObj.Account_BP_Payer__c = contractExtension.Existing_Contract_Item__r.Account_bp_payer__c;
        contractObj.Account_BP_VAT__c = contractExtension.Existing_Contract_Item__r.Account_bp_VAT__c;
        contractObj.previous_Contract__c = contractExtension.Existing_Contract_Item__c;
        contractObj.Account_Site_A_bp_Site__c = contractExtension.Link__r.Site_A_Name__c;
        contractObj.Account_Site_B_bp_Site__c = contractExtension.Link__r.Site_B_Name__c;
        contractObj.Previous_Contract_Header_ID_filled__c = contractExtension.Existing_Contract_Item__r.Contract_id__c;
        contractObj.Previous_Contract_Item_No_filled__c = contractExtension.Existing_Contract_Item__r.SAP_ID__c;
        contractObj.Quantity__c = contractExtension.Existing_Contract_Item__r.Quantity__c;
        contractObj.Bandwidth_filled__c = contractExtension.Existing_Contract_Item__r.Bandwidth_filled__c;
        contractObj.Bandwidth_UoM_filled__c = contractExtension.Existing_Contract_Item__r.Bandwidth_UoM_filled__c;
        contractObj.Bandwidth_Before_Filled__c = contractExtension.Existing_Contract_Item__r.Bandwidth_filled__c;
        contractObj.Bandwidth_Before_UOM_Filled__c = contractExtension.Existing_Contract_Item__r.Bandwidth_UoM_filled__c;
        contractObj.Product_SAP_Code__c = contractExtension.Existing_Contract_Item__r.Product_SAP_Code__c;
        contractObj.Product_Charge_Type_filled__c = contractExtension.Existing_Contract_Item__r.Product_Charge_Type_filled__c;
        contractObj.Opportunity__c=contractExtension.Existing_Contract_Item__r.Opportunity__c;
        insert contractObj;

        Contract_Ticket_Item__c newContractTicketItem = new Contract_Ticket_Item__c();
        labelName = 'Item for ' + contractExtension.name;
        //labelName.replace('Contract Item of','');

        if (labelName.length() > 75)
        newContractTicketItem.Name = labelName.left(75) + ' ...';
        else newContractTicketItem.Name = labelName;
        newContractTicketItem.full_name__c = labelName.left(255);

        newContractTicketItem.Contract_Ticket__c = newContractTicket.id;
        newContractTicketItem.Contract_Item__c = contractObj.id;
        newContractTicketItem.FLAG__c = 'FIRST INVOICE';
        insert newContractTicketItem;

        List < Contract > contractItemPrevList = [select id, start_date__c, end_date__c, end_date_before__c
            FROM Contract
            WHERE ID =: contractExtension.Link__r.Contract_Item_Rel__c
        ];

        if (contractItemPrevList.size() > 0) {
            Contract contractItemPrevRec = contractItemPrevList[0];
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
            contractItemPrevRec.Bill_Plan_End_Date__c = contractExtension.Extension_Start_Date__c.adddays(-1);
            update contractItemPrevRec;

            Contract_Ticket_Item__c newContractTicketItem2 = new Contract_Ticket_Item__c();
            labelName = 'Item for ' + contractExtension.Link__r.Contract_Item_Rel__r.name + ' (last)';
            if (labelName.length() > 75)
            newContractTicketItem2.Name = labelName.left(75) + ' ...';
            else newContractTicketItem2.Name = labelName;
            newContractTicketItem2.full_name__C = labelName.left(255);
            newContractTicketItem2.Contract_Ticket__c = newContractTicket.Id;
            newContractTicketItem2.Contract_Item__c = contractExtension.LinK__r.Contract_Item_Rel__c;
            newContractTicketItem2.FLAG__c = 'LAST INVOICE';
            //**  4. Update : 20-Sep-2019 by doddy 
            //-- Set invoced status to true for last/previous contract
            //-- handling for some contract that had been invoiced before this event
            //-- so, the SAP will not send the last invoice status
            newContractTicketItem2.isInvoiced__c = true;
            insert newContractTicketItem2;
        }


        //-- insert contract-Ticket-item list into Contract_Ticket_item__c object db
        contractExtension.Contract_Ticket_Created__c = newContractTicket.id;
        contractExtension.Remark__c = 'Customer Confirmed to Extend Contract';
        //CE.Status__c='Completed';
        update contractExtension;
    }

    public void CreateChangePriceFromBAExtension(string extensionID) {
        //create change price from BA Extension
        Contract_Extension__c contractExtension = [SELECT id, link__r.Site_A_Name__r.BP_Number__c, link__r.Site_A_Name__r.Name, link__r.Site_A_Name__r.Unique_Name__c,
            Account__c, Account__r.Organization_Type__c, Account__r.Parentid, Link__c, Extension_Start_Date__c, Extension_End_Date__c, Link__r.Uom__c,
            Link__r.Capacity_Bandwidth__c, Link__r.Link_id__c, Existing_Contract_item__c, Extension_Monthly_Price__c, Solution_pic__c,
            Existing_Contract_Item__r.Product__c FROM Contract_Extension__c WHERE ID =: extensionID
        ];
        Change_Price__c newContractPrice = new Change_Price__c();
        if (contractExtension.Account__r.Organization_Type__c == 'Head Office') {
            newContractPrice.Customer__c = contractExtension.Account__c;
        } else {
            newContractPrice.Customer__c = contractExtension.Account__r.Parentid;
        }
        newContractPrice.BA_Extension__c = contractExtension.id;
        newContractPrice.Name = 'Change Price For Renewal Link:' + contractExtension.Link__r.Link_id__c;
        newContractPrice.Status__c = 'Draft';
        newContractPrice.Solution_PIC__c = contractExtension.Solution_PIC__c;


        insert newContractPrice;
        Change_Price_Link__c newChangePriceLink = new Change_Price_Link__c();
        newChangePriceLink.Change_Price__c = newContractPrice.id;
        newChangePriceLink.Link__c = contractExtension.Link__c;
        newChangePriceLink.Previous_Contract__c = contractExtension.Existing_Contract_Item__c;
        newChangePriceLink.Name = contractExtension.Link__r.Link_id__c;
        newChangePriceLink.Bandwidth__c = contractExtension.Link__r.Capacity_Bandwidth__c;
        newChangePriceLink.Site__c = contractExtension.link__r.Site_A_Name__r.BP_Number__c + ' ' + contractExtension.link__r.Site_A_Name__r.name + ' - ' + contractExtension.link__r.Site_A_Name__r.Unique_Name__c;

        newChangePriceLink.Uom__c = contractExtension.Link__r.Uom__c;
        newChangePriceLink.Contract_Start_Date__c = contractExtension.Extension_Start_Date__c;
        newChangePriceLink.Contract_End_Date__c = contractExtension.Extension_End_Date__C;
        newChangePriceLink.Is_Auto_Renewal__c = false;
        newChangePriceLink.Selling_Price__c = contractExtension.Extension_Monthly_Price__c;
        insert newChangePriceLink;
        Change_Price_Link_Group__c newChangePriceGroup = new Change_Price_Link_Group__c();
        newChangePriceGroup.Change_Price__c = newContractPrice.id;
        newChangePriceGroup.Bandwidth__c = contractExtension.Link__r.Capacity_Bandwidth__c;
        newChangePriceGroup.Uom__c = contractExtension.Link__r.Uom__c;
        newChangePriceGroup.Selling_Price__c = contractExtension.Extension_Monthly_Price__c;
        insert newChangePriceGroup;
        contractExtension.Change_Price_Created__c = newContractPrice.id;
        contractExtension.Remark__c = 'Customer Want to Negotiate New Price';
        contractExtension.Status__c = 'Completed';
        update contractExtension;
    }

}