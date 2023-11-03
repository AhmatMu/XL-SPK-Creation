public class BrustableLink_controller {
    
    Public Void Create_BrustableLink(Set<Id> LinkId){
        
   
            list<link__c> link_List = 
            [ select id, Contract_Item_Rel__r.name
                                    //, OneTime_Revenue__c, Recurring_Revenue__c
                                    , Contract_Item_Rel__c,Contract_Item_Rel__r.Opportunity__c
                                    , Contract_Item_Rel__r.ContractTerm, Contract_Item_Rel__r.BP_Payer__c, Contract_Item_Rel__r.Auto_renewal__C
                                    , Contract_Item_Rel__r.start_date__c, Contract_Item_Rel__r.BP_VAT__c
                                    , Contract_Item_Rel__r.end_date__c, Contract_Item_Rel__r.RecordTypeId
                                    , Contract_Item_Rel__r.Periode_UOM__c, Contract_Item_Rel__r.Account_Site_A_BP_Site__c
                                    , Contract_Item_Rel__r.Contract_Term__c, Contract_Item_Rel__r.Account_Site_B_BP_Site__c
                                    , Contract_Item_Rel__r.Bandwidth_filled__c, Contract_Item_Rel__r.Product_Charge_Type_filled__c
                                    , Contract_Item_Rel__r.Bandwidth_UoM_filled__c, Contract_Item_Rel__r.Product_SAP_Code__c
                                    , Contract_Item_Rel__r.Contract_ID__c, Contract_Item_Rel__r.Account_BP_Payer__c
                                    , Contract_Item_Rel__r.SAP_ID__c, Contract_Item_Rel__r.Account_BP_VAT__c, Contract_Item_Rel__r.Quantity__c
                                    , Contract_Item_Rel__r.Account__c,Contract_Item_Rel__r.Bandwidth_Before_UoM_filled__c
                                    , Contract_Item_Rel__r.Product__c
                                    , Contract_Item_Rel__r.Billing_Type__c

                                from Link__c
                                where Id IN :LinkId
                          
                          ];

            system.debug('list Link  ' + link_list);

            if(link_List!=null && !link_List.isEmpty()){
                
               // I. Create Contract Ticket (header) 
                List<Contract_ticket__c> New_contract_ticket_List = new List<Contract_ticket__c>();

                for(link__c contract_List_Extract: link_List){
                    Contract_ticket__c CTlist = new Contract_ticket__c();
            		CTlist.Opportunity__c = contract_List_Extract.Contract_Item_Rel__r.Opportunity__c;
            		CTlist.Account__c= contract_List_Extract.Contract_Item_Rel__r.Account__c ;
            		CTlist.Currency__c='IDR';
            
            		string label = 'Contract Ticket for "'+ contract_List_Extract.Contract_Item_Rel__r.name + '" Link "(" Burstable ")"';
            		if (label.length() > 75)
                		CTlist.Name = label.left(75) + ' ...'; 
            		else CTlist.Name = label;
                		CTlist.Full_Name__C = label.left(255);			
            			CTlist.TicketStatus__c='Review By Contract Manager';
                   
                    
                    New_contract_ticket_List.add(CTlist);
                    
                }
                   insert New_contract_ticket_List;
           }
                
        }
  
        
        

}