global with sharing class Schedule_Send_BA implements Schedulable{
    global void execute(SchedulableContext sc) 
    {        
        date dateMinus3 = system.today().adddays(-3);
        date dateMinus6 = system.today().adddays(-6);

        system.debug ('======= today        : ' + system.today() );
        system.debug ('======= dateMinus3   : ' + dateMinus3 );
        system.debug ('======= dateMinus6   : ' + dateMinus6 );


        List<Opportunity> opportunityList = [ select id, name, opportunity_id__c,  BA_sent_date__c 
                                                from Opportunity 
                                                where stagename = 'Waiting for BA'
                                                 AND ( BA_sent_date__c = :dateMinus3
                                                        OR BA_sent_date__c = :dateMinus6 )
												 AND Contract_Ticket__c = null
                                                 ];

        for (Opportunity opportunityObj : opportunityList) {
            

            system.debug ('======= opportunityObj.name        : ' + opportunityObj.name );
            system.debug ('======= opportunityObj.opportunity_id__c        : ' + opportunityObj.opportunity_id__c );
            system.debug ('======= opportunityObj.BA_sent_date__c        : ' + opportunityObj.BA_sent_date__c );


            SendWBAUtils.futuresendemail(opportunityObj.id);

        }
    
    
    }
}