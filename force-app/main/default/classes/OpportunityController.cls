public class OpportunityController {
    
    public void opportunityMonthlyCleansing(){
        /*================== Start / Initiation ==================*/
        List<Opportunity> opptyToCleanse = new List<Opportunity>();
          
        /*================== start cleansing process by updating opportunity to closed lost ==================*/
        
        for(Opportunity oppty : [Select id, opportunity_id__c, name, closedate, stagename from opportunity where closedate < today and (stagename = 'Prospecting' or stagename = 'Negotiation') ]){
            oppty.StageName = 'Closed Lost';
            Oppty.Loss_Reason__c = 'Others';
            Oppty.Loss_Reason_Description__c = 'Opportunity Expired';
            //system.debug('Opportunity id: '+oppty.Id);
            opptyToCleanse.add(oppty);
        }
        system.debug('Number of Opportunity to be cleanse: '+opptyToCleanse.size());
                                 
        /*================== start database update ==================*/
        Database.SaveResult[] opptyCleansedList = Database.update(opptyToCleanse, false);
        
        /*================== Getting Result Logs ==================*/
        for (Database.SaveResult ocl : opptyCleansedList) {
            if (ocl.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + ocl.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : ocl.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Opportunity fields that affected this error: ' + err.getFields());
                }
            }
        }
        /*================== END ==================*/
    } 

}