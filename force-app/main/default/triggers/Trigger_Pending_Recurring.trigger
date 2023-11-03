trigger Trigger_Pending_Recurring on Pending_Recurring__c (after insert, after update, before insert, before update) {
 if(trigger.isbefore)
 {
    if(trigger.isinsert)
    {
        for(Pending_Recurring__c PR :system.trigger.new)
        {
        	
            if(PR.search_Link__c!=null)
            {
                Link__c L=[SELECT CID__c,Site_A_Name__r.Ownerid from Link__c WHERE ID=:PR.Search_Link__c];
                list<Link__c> ListLinkID=[SELECT Link_id__c FROM Link__c WHERE CID__c=:L.CID__c];
                 PR.Link_id__c='';
                if(L.Site_A_Name__r.Ownerid==null){
                    PR.adderror('Site A Name link must be filled');
                }
                
                for(Link__c Lin:ListLinkID)
                {
                    PR.Link_ID__c=PR.Link_ID__c+Lin.Link_id__c+';';
                }
        		PR.Ownerid=L.Site_A_Name__r.Ownerid;
            } 
        }
    }
    if(trigger.isupdate)
    {
        for(Pending_Recurring__c PR2 :system.trigger.new)
        {
            Pending_Recurring__c PRold2=trigger.oldmap.get(PR2.id);
            if(PR2.search_link__c!=prold2.search_link__c && PR2.search_Link__c!=null)
            {
            PR2.Link_id__c='';
            Link__c L2=[SELECT CID__c from Link__c WHERE ID=:PR2.Search_Link__c];
                list<Link__c> ListLinkID2=[SELECT Link_id__c FROM Link__c WHERE Name=:L2.CID__c];
                for(Link__c Lin2:ListLinkID2)
                {
                    PR2.Link_ID__c=PR2.Link_ID__c+Lin2.Link_id__c+';';
                }
            }
        }
    }
 }
  if(trigger.isbefore)
 {
 	if(trigger.isupdate)
 	{
 		for(Pending_Recurring__c PR :system.trigger.new)
        {
        	Pending_Recurring__c PRold=trigger.oldmap.get(PR.id);
        	if(PROld.Status__c!=PR.Status__c && PR.Status__c=='Sent To Sales')
        	{
        		
        	}
        }
 	}
 }   
}