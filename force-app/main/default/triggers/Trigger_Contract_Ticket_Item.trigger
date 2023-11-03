trigger Trigger_Contract_Ticket_Item on Contract_Ticket_Item__c  (after insert, after update, before insert, before update) {

    if(trigger.isUpdate) {
        if(trigger.isBefore){
            for(Contract_Ticket_Item__c contractNewRec : system.trigger.new){
            
            
            }
        }
        
        if(trigger.isafter){
            for(Contract_Ticket_Item__c contractTicketItemNewRec : system.trigger.new){
                Contract_Ticket_Item__c contractTicketItemOldRec = Trigger.oldMap.get(contractTicketItemNewRec.id);
                
                
                /* INI TUTUP DULU -- AWALNYA UNTUK SET RELATED CONTRACT PADA LINK UPGRADE SAAT DAPAT LAST INVOICE
                if ( contractTicketItemOldRec.isInvoiced__c == FALSE 
                        && contractTicketItemNewRec.isInvoiced__c == TRUE 
                        && contractTicketItemNewRec.FLAG__c == 'LAST INVOICE' ) {
                    
                    string lastContract = contractTicketItemNewRec.Contract_Item__c;
                    
                    //-- get next contract
                    List <Contract> nextContractList = [select id, Link__c, Contract_ID__c, SAP_ID__c   
                                                        FROM CONTRACT where Previous_Contract__c =:lastContract ];
                    if (nextContractList.size() >0 ) {
                        string linkID = nextContractList[0].Link__c;
                        
                        List<Link__c> linkList = [  select id, Contract_Item_Rel__c from Link__c 
                                                where id=:linkID];
                    
                        if (linkList.size() > 0) {
                            //-- set contract on the link
                            linkList[0].Contract_Item_Rel__c = nextContractList[0].id;
                            linkList[0].Contract_Item__c = nextContractList[0].Contract_ID__c + '-' + nextContractList[0].SAP_ID__c ;
                            
                            update linkList;
                        }                     
                    }
                    
                }  
                */
                
            }
        }
    }
    
    
}