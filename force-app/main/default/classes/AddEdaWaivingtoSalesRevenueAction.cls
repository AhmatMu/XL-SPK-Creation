public class AddEdaWaivingtoSalesRevenueAction {
  
    @InvocableMethod
    public static void AddEdaWaivingtoSalesRevenueAction(List<EDA__c> EDAList) {
        system.debug('================== ini AddEdaWaivingtoSalesRevenueAction.EdaWaivingData');
        string errorMsg = '';
        String edaWaivingid = '';
        
        List<EDA__c> addForecastEdaWaivingList = new List<EDA__c>();
        List<EDA__c> deletedEdaWaivingList = new List<EDA__c>();
        system.debug('========== deletedEdaWaivingList' + EDAList);

        try{
        for(EDA__c edaWaivingObj : EDAList){
            if(edaWaivingObj.Mark_as_Revenue_EDA_Waiving__c == true){
                addForecastEdaWaivingList.add(edaWaivingObj);
                system.debug('== ada disini addEdaWaivingList' + addForecastEdaWaivingList);
            }
            if(edaWaivingObj.Mark_as_Revenue_EDA_Waiving__c == false){
                deletedEdaWaivingList.add(edaWaivingObj);
                system.debug('=== ada disini deletedEdaWaivingList'+ deletedEdaWaivingList);
            }
                        
        }

        if(addForecastEdaWaivingList.size() > 0){
            SalesRevenueController.addForecastwaivingData(addForecastEdaWaivingList);
            system.System.debug('========== addForecastEdaWaivingList' + addForecastEdaWaivingList);
        }
        else{
            SalesRevenueController.deletedForecastWaivingData(deletedEdaWaivingList);
            system.System.debug('=================== deletedEdaWaivingList' +  deletedEdaWaivingList);
       }
      
    }
        catch (Exception e) {
            string notes = 'Error on AddEdaWaivingtoSalesRevenueAction.addForecastEdaWaivingmethod.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  deletedEdaWaivingList +'::'+ addForecastEdaWaivingList; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }

}