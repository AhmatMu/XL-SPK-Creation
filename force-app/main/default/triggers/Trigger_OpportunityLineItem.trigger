trigger Trigger_OpportunityLineItem on OpportunityLineItem (after insert, after update, before insert, before update,before delete) {
 if(system.label.IS_Trigger_OpportunityLineItem_ON=='YES')
 {
    	if(!trigger.isdelete)
    	{
    	for(OpportunityLineItem OLI:system.trigger.new)
    	{
    /*	Opportunity O=[SELECT StageName,Probability,RecordType.Name from Opportunity WHERE ID=:OLI.OpportunityID];
    	if(trigger.isbefore)
    		{
    			if(O.RecordType.Name.contains('Non GSM'))
    			{
    			if(O.Probability>=0.5 &&trigger.isinsert && !test.isrunningtest())
    			{
    				OLI.AddError('Cannot insert at this Stage');		
    			}
    			}
    		}
    		if(trigger.isafter)
    		{
    			if(trigger.isupdate)
    			{
    			 OpportunityLineItem OldOLI=trigger.oldmap.get(OLI.id);
    			if(O.RecordType.Name.contains('Non GSM'))
    			{
    			if(O.Probability>=0.5  && OldOLI.Product2id!=OLI.Product2id && !test.isrunningtest())
    			{
    				
    				OLI.AddError('Cannot ChangeProduct at this Stage');	
    			}
    			}
    			}
    		}*/
    	}
    	}
    	else
    	{
    	for(OpportunityLineItem OLI:system.trigger.old)
    	{
    		Opportunity O=[SELECT StageName,Probability,RecordType.Name from Opportunity WHERE ID=:OLI.OpportunityID];
    		if(trigger.isbefore && trigger.isdelete)
    		{
    			if(O.RecordType.Name.contains('Non GSM') && O.Probability>=0.5 && !test.isrunningtest())
    			{
    				OLI.Adderror('Cannot Delete Product At This Stage');
    			}
    		}
    	}
    	}
    	
}
    /*
    if(trigger.isbefore)
    {
        for(OpportunityLineItem OLI:system.trigger.new)
        {
        Opportunity O=[select Pricebook2id,RecordType.Name FROM Opportunity WHERE ID=:OLI.OpportunityID];
        if(O.PriceBook2id!=null && O.RecordType.Name=='GSM (Activation)')
        {    
               list<PriceBookEntry> PBE2=[SELECT id,start_from__c,up_to__c,product2id,unitprice from PricebookEntry WHERE Product2id=:OLI.product2id AND Pricebook2.id=:O.Pricebook2id AND Start_from__c<=:OLI.Quantity AND Up_to__c>=:OLI.Quantity];
               if(PBE2.size()==0)
                OLI.addError('Kuantitas tidak sesuai Tier dan tidak ada penggantinya');
                else
                {
                    OLI.Unitprice=PBE2[0].Unitprice;
                    update OLI;
                }
        }
    }
    }
    
    */
}