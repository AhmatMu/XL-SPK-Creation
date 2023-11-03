public with sharing class AddPendingRecurringtoSalesRevenueAction {
    
    @InvocableMethod
    public static void AddPendingRecurringtoSalesRevenueAction(List<Pending_Recurring__c> PendingRecurringList) {
        system.debug('================== ini AddPendingRecurringtoSalesRevenueAction.addPendingRecurringData');
        string errorMsg = '';
        String pendingRecurringid = '';
        
        List<Pending_Recurring__c> addForecastPendingRecurringList = new List<Pending_Recurring__c>();
        List<Pending_Recurring__c> deletedForecatPendingRecurringList = new List<Pending_Recurring__c>();
        system.debug('========== DeletedForecatPendingRecurringData' + deletedForecatPendingRecurringList);
   
        
        try{
        for(Pending_Recurring__c pendingRecurringObj : pendingRecurringList){
            if(pendingRecurringObj.Mark_as_Revenue_Pending_Recurring__c == true){
                addForecastPendingRecurringList.add(pendingRecurringObj);
                system.System.debug('== ada disini addForecastPendingRecurringList' + addForecastPendingRecurringList);
            }
            if(pendingRecurringObj.Mark_as_Revenue_Pending_Recurring__c == false){
                deletedForecatPendingRecurringList.add(pendingRecurringObj);
            system.System.debug('=== ada disini deletedForecatPendingRecurringList'+ deletedForecatPendingRecurringList);
            }
                        
        }

        if(addForecastPendingRecurringList.size() > 0){
            SalesRevenueController.addForecastPendingRecurringData(addForecastPendingRecurringList);
            system.System.debug('=== nambah pending recurring disini'+ addForecastPendingRecurringList);
        }

        if(deletedForecatPendingRecurringList.size() > 0){
                SalesRevenueController.DeletedForecatPendingRecurringData(deletedForecatPendingRecurringList);
                system.System.debug('======= disini deletedForecatPendingRecurringList' +deletedForecatPendingRecurringList);
        }
        
        }
        catch (Exception e) {
            string notes = 'Error on AddPendingRecurringtoSalesRevenueAction.addForecastPending Reurring Data method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  deletedForecatPendingRecurringList +'::'+ addForecastPendingRecurringList; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
    
}