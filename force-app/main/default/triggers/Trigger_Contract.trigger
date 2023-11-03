trigger Trigger_Contract on Contract__c (after insert, after update, before insert, before update) {
    if(trigger.isinsert)
    {
        if(trigger.isafter)
        {
            for(Contract__c C:system.trigger.new)
            {
            Opportunity O=[SELECT Contract__c from Opportunity WHERE ID=:C.Opportunity__c];
            O.Contract__c=C.id;
            update O;
            }
        }
    }
    if(trigger.isupdate)
    {
        if(trigger.isafter)
        {
            for(Contract__c Cc:system.trigger.new)
            {
            Contract__c Cold=Trigger.oldMap.get(Cc.id);
            
            if(Cold.TicketStatus__c!='Review By Finance' && CC.TIcketStatus__c=='Review By Finance')
            {
                list<Contract_Item__c> CI =[SELECT billing_type__c,bp_payer__c,bp_vat__c,start_date__c,end_date__c from Contract_item__c WHERE Contract__c=:CC.id];
                for(Contract_item__c item:CI)
                {
                    if(Item.BP_Payer__c=='')
                    CC.Adderror('BP Payer ContractItem is Empty,please complete it before send to finance');
                    if(Item.BP_VAT__c=='')
                    CC.Adderror('BP VAT ContractItem is Empty,please complete it before send to finance');
                    if(Item.Billing_Type__c=='')
                    CC.Adderror('Billing Type ContractItem is Empty,please complete it before send to finance');
                    if(Item.Start_Date__c==null)
                    CC.Adderror('Start Date ContractItem is Empty,please complete it before send to finance');
                    if(Item.End_Date__c==null)
                    CC.Adderror('End Date ContractItem is Empty,please complete it before send to finance');
                    
                }
      /*          if(CC.Contract_id__c!=null && CC.Contract_id__c!='' && !Test.isRunningTest() )
               HitsapComDocumentSapSoap.HitContractUpdate(String.valueof(CC.Opportunity__c),String.valueof(CC.id));
                  else if((CC.Contract_id__c==null || CC.Contract_id__c=='') && !Test.isRunningTest() )
                HitsapComDocumentSapSoap.HitContract(String.valueof(CC.Opportunity__c),String.valueof(CC.id));*/
            }
            if(Cold.TicketStatus__c!='Complete' && CC.TIcketStatus__c=='Complete')
            {
                Opportunity O=new Opportunity();    
                O.id=CC.Opportunity__c;
                O.StageName='Closed Won';
                update O;
            }
            if(Cold.TicketStatus__c!='Pending' && CC.TIcketStatus__c=='Pending')
            {
                Opportunity O=new Opportunity();    
                O.id=CC.Opportunity__c;
                O.StageName='Waiting for BA';
                update O;
            }
            }
        }
    }
    
    
}