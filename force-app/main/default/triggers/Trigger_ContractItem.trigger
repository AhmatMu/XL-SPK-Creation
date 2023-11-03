trigger Trigger_ContractItem on Contract_Item__c (after insert, after update, before insert, before update) {
    for(Contract_Item__c Contractitem:system.trigger.new)
    if(trigger.isupdate)
    {
    	if(trigger.isafter)
    	{
    		if(ContractItem.Opportunity__c!=null)
    		{
    		Opportunity O=[select StageName,id from opportunity where id=:ContractItem.Opportunity__c];
    		Contract__c CC=[select id from contract__c where id=:ContractItem.Contract__c];
    		if(ContractItem.lastmodifieddate<system.now().addminutes(-1) && !O.stagename.contains('Closed'))
    		{
    	//		HitsapComDocumentSapSoap.HitContractUpdate(String.valueof(O.id),String.valueof(CC.id));
    		}
    		}
    	}
    }
}