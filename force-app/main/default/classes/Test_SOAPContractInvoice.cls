@isTest (seealldata=true)
public class Test_SOAPContractInvoice {
  /*
        01 : FIRST INVOICE
        02 : FIRST INVOICE CANCEL
        03 : LAST INVOICE
        04 : LAST INVOICE CANCEL
        05 : BOTH INVOICE
        06 : BOTH INVOICE CANCEL
        
        string strFLAG = '';
        if (FLAG == '01') strFLAG = 'FIRST INVOICE';
        if (FLAG == '02') strFLAG = 'FIRST INVOICE';
        if (FLAG == '03') strFLAG = 'LAST INVOICE';
        if (FLAG == '04') strFLAG = 'LAST INVOICE';
        //if (FLAG == '05') strFLAG = 'FIRST INVOICE';
        //if (FLAG == '06') strFLAG = 'FIRST INVOICE';
*/        
       
       static testMethod void testInvoice1()
       {
            test.starttest();
            
            String ContractitemNO;
            string FLAG;
            string BillDate;
            
            //-- CREATE OPPORTUNITY
            List <Opportunity> opportunityList = [  select id, Link_Related__r.Contract_Item_Rel__r.name
                                    , OneTime_Revenue__c, Recurring_Revenue__c
                                    , Link_Related__r.Contract_Item_Rel__c
                                    , Link_Related__r.Contract_Item_Rel__r.end_date__c
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
                                    
                                from Opportunity 
                                where service_group__c='Non-GSM'
                                    AND service_type__c = 'upgrade'
                                    and stagename <> 'Closed Won' limit 1 ];
                                            
        Opportunity opportunityRec = opportunityList[0];                        
        string recordTypeName = opportunityRec.recordtype.name;
            
            //-- CREATE CONTRACT tICKET
            Contract_ticket__c contractTicket=new Contract_ticket__c();
            contractTicket.Opportunity__c=opportunityRec.id;
            contractTicket.Account__c=OpportunityRec.AccountID;
            contractTicket.Currency__c='IDR';
            contractTicket.Name='Contract Ticket for "'+ opportunityRec.Name + '" Oportunity';
            contractTicket.TicketStatus__c='Review By Contract Manager';
            insert contractTicket;
            
            List <Contract_ticket_item__c> CTIList = new List <Contract_ticket_item__c> (); 
            list<Contract> listCI=new list<Contract>();
            
            //-- CREATE CONTRACT #1
            Contract CI=new Contract();
            CI.Name='Contract Item of "'+   'AA' + '"' ;             
            CI.AccountID = OpportunityRec.AccountID;
            CI.Opportunity__c=opportunityRec.id;
            //CI.Product__c= OLI.Product2id;
            CI.Billing_Type__c='Monthly';
            //CI.Link__c=opportunityRec.Link_Related__c;
            
            CI.Account_BP_Payer__c = opportunityRec.BP_Payer__c;
            CI.Account_BP_VAT__c = opportunityRec.BP_VAT__c;
            
            CI.Account_Site_A_BP_Site__c = OpportunityRec.Account_Site_A__c;
            CI.Account_Site_B_BP_Site__c = OpportunityRec.Account_Site_B__c;
            CI.Auto_renewal__C = OpportunityRec.Auto_renewal__C ;
            
            CI.Start_Date__c = null;
            CI.End_Date__c = null;
            CI.SAP_ID__c = 'CI-01';
            
            //ListCI.ADD(CI);
            insert CI;
            
            //-- CREATE CONTRACT tICKET ITEM
            Contract_Ticket_Item__c CTI = new Contract_Ticket_Item__c();
            string label = 'Ticket Item for ' + CI.name;
            CTI.name = label;
            CTI.Contract_Ticket__c = contractTicket.id;
            CTI.Contract_Item__c = CI.id;
            CTI.FLAG__c= 'FIRST INVOICE';
            
            CTIList.add (CTI);
            
            
            //-- CREATE CONTRACT #2
            CI=new Contract();
            CI.Name='Contract Item of "'+   'BB' + '"' ;             
            CI.AccountID = OpportunityRec.AccountID;
            CI.Opportunity__c=opportunityRec.id;
            //CI.Product__c= OLI.Product2id;
            CI.Billing_Type__c='Monthly';
            //CI.Link__c=opportunityRec.Link_Related__c;
            
            CI.Account_BP_Payer__c = opportunityRec.BP_Payer__c;
            CI.Account_BP_VAT__c = opportunityRec.BP_VAT__c;
            
            CI.Account_Site_A_BP_Site__c = OpportunityRec.Account_Site_A__c;
            CI.Account_Site_B_BP_Site__c = OpportunityRec.Account_Site_B__c;
            CI.Auto_renewal__C = OpportunityRec.Auto_renewal__C ;
            
            CI.Start_Date__c = null;
            CI.End_Date__c = null;
            CI.SAP_ID__c = 'CI-02';
            
            
            //ListCI.ADD(CI);
            insert CI;
            
            //-- CREATE CONTRACT tICKET ITEM
            CTI = new Contract_Ticket_Item__c();
            label = 'Ticket Item for ' + CI.name;
            CTI.name = label;
            CTI.Contract_Ticket__c = contractTicket.id;
            CTI.Contract_Item__c = CI.id;
            CTI.FLAG__c= 'LAST INVOICE';
            
            CTIList.add (CTI);    
            
            insert CTIList;
            
            
            //-- FIRST INVOICE
            ContractitemNO ='-CI-01';
            FLAG  = '01' ;       
            BillDate  = '20180808';
            SOAPContractInvoice.Invoice(ContractitemNO, FLAG, BillDate );
            
            ContractitemNO ='-CI-01';
            FLAG  = '05' ;       
            BillDate  = '20180808';
            SOAPContractInvoice.Invoice(ContractitemNO, FLAG, BillDate );
            
            
            ContractitemNO ='-CI-01';
            FLAG  = '02' ;       
            BillDate  = '20180808';
            SOAPContractInvoice.Invoice(ContractitemNO, FLAG, BillDate );
            
            ContractitemNO ='-CI-01';
            FLAG  = '06' ;       
            BillDate  = '20180808';
            SOAPContractInvoice.Invoice(ContractitemNO, FLAG, BillDate );
            
            ContractitemNO ='-CI-02';
            FLAG  = '03' ;       
            BillDate  = '20180808';
            SOAPContractInvoice.Invoice(ContractitemNO, FLAG, BillDate );
            
            ContractitemNO ='-CI-02';
            FLAG  = '04' ;       
            BillDate  = '20180808';
            SOAPContractInvoice.Invoice(ContractitemNO, FLAG, BillDate );
            
            test.stoptest();
       }
      
    
       
}