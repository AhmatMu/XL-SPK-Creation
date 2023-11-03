trigger Trigger_setBandwidthBeforeAfter on Opportunity (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isUpdate){
            for(Opportunity oppRecord:trigger.new){
                Opportunity OldOpp=trigger.oldmap.get(Opprecord.id);
                system.debug('*** OldOpp.Link_related__c = ' + OldOpp.Link_related__c);
                system.debug('*** Opprecord.Link_related__c = ' + Opprecord.Link_related__c);
                if(OldOpp.Link_related__c!=Opprecord.Link_related__c && OppRecord.Link_Related__c!=null)
                {        
                    system.debug('*** Ini Debug, masuk line sini ya 2******* ');
                    setbandwidthbeforeafter.setbandwidth(opprecord);
                }
            }   
        }
        if(trigger.isinsert)
        {
              for(Opportunity oppRecord:trigger.new){
                if(opprecord.link_related__c!=null)              
                    setbandwidthbeforeafter.setbandwidth(opprecord);
                
            }   
        }
    }
}