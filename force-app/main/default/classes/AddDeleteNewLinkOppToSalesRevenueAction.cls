/*
 * hello
 */

public class AddDeleteNewLinkOppToSalesRevenueAction {
    
    @InvocableMethod
    public static void addDeleteNewLinkOppToSalesRevenueAction( List<Opportunity> opptyList  ) {
        system.debug('================== in AddDeleteNewLinkOppToSalesRevenueAction.addDeleteNewLinkOppToSalesRevenueAction');
        system.debug('======= opptyList : ' + opptyList); 
        
        string errorMsg = '';
        string relatedSFIDs = '';
        
        
        List<Opportunity> opptyTobeAddList = new List<Opportunity>();        
 		Set <ID> opptyTobeDeleteIDs = new Set <ID>();
        
        try {
            for(Opportunity opptyObj : opptyList){
                System.debug('=============== opptyObj : ' + opptyObj);
                
                relatedSFIDs =  relatedSFIDs + opptyObj.Id + ' ';
                    
                if(opptyObj.Mark_as_Add_Link_Sales_Revenue__c == true && opptyObj.stageName == 'Closed Won' && opptyObj.service_type__c == 'Newlink'){
                    opptyTobeAddList.add(opptyObj);
                    system.System.debug('========== opptyTobeAddList : ' + opptyTobeAddList);
                }
                if(opptyObj.Mark_as_Add_Link_Sales_Revenue__c == false || opptyObj.stageName <> 'Closed Won' ){
                    opptyTobeDeleteIDs.add(opptyObj.ID);
                    system.System.debug('========== opptyTobeDeleteIDs : ' + opptyTobeDeleteIDs);
                }
                           
            }
                
            if(opptyTobeAddList.size() > 0) {
                SalesRevenueController.addNewLinkData(opptyTobeAddList);
                system.System.debug('========== opptyTobeAddList' + opptyTobeAddList);
            }
            
            if (opptyTobeDeleteIDs.size() > 0) {
                SalesRevenueController.deleteNewLinkData(opptyTobeDeleteIDs);
                system.System.debug('=================== opptyTobeDeleteIDs : ' +  opptyTobeDeleteIDs); 
           }
      
    	}
        catch (Exception e) {
            string notes = 'Error on AddDeleteNewLinkOpptiesToSalesRevenue.AddDeleteNewLinkOpptiesToSalesRevenue method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
}