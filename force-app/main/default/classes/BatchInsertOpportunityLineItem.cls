global class BatchInsertOpportunityLineItem implements Database.Batchable <sObject> {
    
   List<sObject> batchList;
   
   global BatchInsertOpportunityLineItem(List<sObject> objList) {
      // modify list if necessary (e.g., trap null)
      if (objList == null) objList = new List<sObject>();      
      this.batchList = objList;
   }
   
   global Iterable<sObject> start(Database.BatchableContext info){ 
       return this.batchList; 
   }
        
   global void execute(Database.BatchableContext info, List<sObject> scope){
       // do whatever you need to prep scoped records for insert
       // insert scoped records  
       if (scope.size()>0) {
		
        try {
        	List<OpportunityLineItem> oliList = scope;
        	insert oliList;
    		
    		} catch(DmlException e) {
    			//isError =true;
			    System.debug('The following exception has occurred: ' + e.getMessage());
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
				ApexPages.addMessage(myMsg);
			}
       }
   }
        
   global void finish(Database.BatchableContext info){     
   		//todo: send email :
   		//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'Create Opportunitiy Lineitems process have been done.' );
		//ApexPages.addMessage(myMsg);
   }
    
}