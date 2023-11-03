trigger TriggerAccountContactRelationship on AccountContactRelation (after insert, before insert,after update, before update) {
    if(system.label.IS_TRIGGER_CONTACT_ON=='YES')
    {
    if(trigger.isAfter)
    {
    	if(trigger.isinsert)
    	{ 
    	for(AccountContactRelation ACR:system.trigger.new)
    	{
    		if(ACR.Roles!=null)
    		HitsapComDocumentSapSoap.InsertContact2(String.valueof(ACR.Contactid), String.valueof(ACR.AccountID), ACR.roles, ACR.mode__c);  		
    	}
    	}
    	if(trigger.isupdate)
    	{
    		for(AccountContactRelation ACR:system.trigger.new)
    		{
    			AccountContactRelation ACROld=trigger.oldmap.get(ACR.id);
    		/*	if(ACROld.Roles!=null)
				HitsapComDocumentSapSoap.DeleteContact(String.valueof(ACR.Contactid),String.valueof(ACR.AccountID),ACRold.roles);
				*/
    			HitsapComDocumentSapSoap.InsertContact2(String.valueof(ACR.Contactid), String.valueof(ACR.AccountID), ACR.roles, ACR.mode__c);  		
    		}
    	}
    }
    }
    
}