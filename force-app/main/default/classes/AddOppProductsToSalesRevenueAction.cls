/**
 *  Opportunity Product to Sales Revenue
 * 
 */

public class AddOppProductsToSalesRevenueAction {
   
    @InvocableMethod
    public static void addOpportunityProductData( List<OpportunityLineItem> oliList  ) {
        
        system.debug('================== ini AddOppProductsToSalesRevenueAction.addOpportunityProductData');
        system.debug('======= oliList : ' + oliList);
        
        string errorMsg = '';
        string relatedSFIDs = '';
        
        
        List<OpportunityLineItem> oliTobeAddList = new List<OpportunityLineItem>();        
        //List<OpportunityLineItem> oliTobeDeleteList = new List<OpportunityLineItem>();
 		Set <ID> oliTobeDeleteIDs = new Set <ID>();
        
        try {
            for(OpportunityLineItem oliObj : oliList){
                System.debug('=============== oliObj : ' + oliObj);
                
                relatedSFIDs =  relatedSFIDs + oliObj.Id + ' ';
                    
                //if(oliObj.Mark_as_Revenue_OppProduct__c == true){
                if(oliObj.Mark_as_Sales_Revenue__c == true){
                    oliTobeAddList.add(oliObj);
                    system.System.debug('========== oliTobeAddList : ' + oliTobeAddList);
                }
                //if(oliObj.Mark_as_Revenue_OppProduct__c == false){
                if(oliObj.Mark_as_Sales_Revenue__c == false){                    
                    oliTobeDeleteIDs.add(oliObj.ID);
                    system.System.debug('========== oliTobeDeleteIDs : ' + oliTobeDeleteIDs);
                }
                           
            }
                
            if(oliTobeAddList.size() > 0) {
                SalesRevenueController.addOpportunityProductData(oliTobeAddList);
                system.System.debug('========== oliTobeAddList' + oliTobeAddList);
            }
            
            if (oliTobeDeleteIDs.size() > 0) {
                SalesRevenueController.deleteOportunityProductData(oliTobeDeleteIDs);
                system.System.debug('=================== oliTobeDeleteIDs : ' +  oliTobeDeleteIDs); 
           }
      
    	}
        catch (Exception e) {
            string notes = 'Error on AddOppProductsToSalesRevenueAction.addForecastPipelineData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
    
    /*   
    public static void addForecastPipelineData( List<Opportunity> opportunityList  ) {
        system.debug('================== ini AddOppProductsToSalesRevenueAction.addPipelineData');
        string errorMsg = '';
        String opporid = '';
        List<Opportunity> opportunityAddForeList = new List<Opportunity>();
        system.debug('======= ini opportunityDelForeList' +opportunityAddForeList);
        List<Opportunity> opportunityDelForeList = new List<Opportunity>();
        system.debug('========== opportunityDelForeList' + opportunityDelForeList);
        system.System.debug('=============== opportunityList'+ opportunityList);
        try{
        for(Opportunity oppObj : opportunityList){
            system.System.debug('=============== loop berhasil' + oppObj);
            if(oppObj.Mark_as_Revenue_Pipeline__c == true){
                opportunityAddForeList.add(oppObj);
                system.System.debug('========== apakah di isi opportunityAddForeList ?'+opportunityAddForeList);
            }
           if(oppObj.Mark_as_Revenue_Pipeline__c == false){
            opportunityDelForeList.add(oppObj); 
           }
                       
        }
        if(opportunityAddForeList.size() > 0){
            SalesRevenueController.addForecastPipelineData(opportunityAddForeList);
            system.System.debug('========== opportunityAddForeList' + opportunityAddForeList);
        }
       else{
            SalesRevenueController.deleteForecastPipelineData(opportunityDelForeList);
            system.System.debug('=================== opportunityDelForeList' +  opportunityDelForeList);
       }
      
    }
        catch (Exception e) {
            string notes = 'Error on AddOppProductsToSalesRevenueAction.addForecastPipelineData method.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  opportunityDelForeList +'::'+ opportunityAddForeList;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
       
    }
	 }*/
    
}