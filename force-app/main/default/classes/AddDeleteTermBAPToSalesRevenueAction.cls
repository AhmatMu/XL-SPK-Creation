public class AddDeleteTermBAPToSalesRevenueAction {

    @InvocableMethod
    public static void addDeleteTermBAPToSalesRevenueAction( List<BAP__c> bapList  ) {
        system.debug('================== ini AddDeleteTermBAPToSalesRevenueAction.addDeleteTermBAPToSalesRevenueAction');
        system.debug('======= bapList : ' + bapList); 
        
        string errorMsg = '';
        string relatedSFIDs = '';
        
        
        List<BAP__c> bapTobeAddList = new List<BAP__c>();        
            Set <ID> bapTobeDeleteIDs = new Set <ID>();
        
        try {
            for(BAP__c bapObj : bapList){
                System.debug('=============== bapObj : ' + bapObj);
                
                relatedSFIDs =  relatedSFIDs + bapObj.Id + ' ';
                
                system.debug('=== bapObj.Mark_as_Churn_Link_Sales_Revenue__c : ' + bapObj.Mark_as_Churn_Link_Sales_Revenue__c);
                system.debug('=== bapObj.request_status__c : ' + bapObj.request_status__c);
                //system.debug('=== bapObj.recordtype : ' + bapObj.recordtype);
                system.debug('=== bapObj.recordtypeID : ' + bapObj.recordtypeID);
                system.debug('=== bapObj.recordtype_Name__c : ' + bapObj.recordtype_Name__c);
                system.debug('=== bapObj.Type_of_Request__c : ' + bapObj.Type_of_Request__c);
                system.debug('=== bapObj.Request_Status_Full__c : ' + bapObj.Request_Status_Full__c);
                system.debug(' isi data masuk if ===' + bapObj.Type_of_Request__c + bapObj.Mark_as_Churn_Link_Sales_Revenue__c);

                

                String requestStatusString = '' ;
                List<Sales_Performance_General__c> salesPerformanceGeneralCustomSettingList = [select id, name, value__c from Sales_Performance_General__c where name = 'SRV Criteria - BAP Link Churn' ];
                
                requestStatusString = salesPerformanceGeneralCustomSettingList[0].value__c;
					
                
                integer indx = requestStatusString.indexOf(bapList[0].request_status_full__c);
                system.debug('== indx : ' + string.valueof(indx) );
                
                if( bapObj.Type_of_Request__c == 'Pemutusan' &&

                        (   bapObj.Mark_as_Churn_Link_Sales_Revenue__c == true && requestStatusString.indexOf(bapList[0].request_status_full__c) >= 0
            

                        )
                   /* (
                           ( bapObj.Mark_as_Churn_Link_Sales_Revenue__c == true   &&
                            bapObj.request_status__c <> 'Draft' && 
                            bapObj.request_status__c <> 'Canceled' && bapObj.request_status__c <> 'Cancelled' && bapObj.complete_status__c <> 'Canceled'
                           )

                        || 
                            ( bapObj.request_status__c == 'Submit' ||
                                ( bapObj.request_status__c == 'Complete' && bapObj.complete_status__c == 'Done' ) )
                    )
                    */


                  ){
                                
                    bapTobeAddList.add(bapObj);
                    system.System.debug('========== bapTobeAddList : ' + bapTobeAddList);
                }
                if(  bapObj.Mark_as_Churn_Link_Sales_Revenue__c == false || requestStatusString.indexOf(bapList[0].request_status_full__c) < 0
                            ) 
                            
                {
                    bapTobeDeleteIDs.add(bapObj.ID);
                    //bapObj.Mark_as_Churn_Link_Sales_Revenue__c = false;


                    system.System.debug('========== bapTobeDeleteIDs : ' + bapTobeDeleteIDs);
                }
                            
            }
                
            if(bapTobeAddList.size() > 0) {
                SalesRevenueController.addTerminationBAPData(bapTobeAddList);
                system.System.debug('========== bapTobeAddList' + bapTobeAddList);
            }
            
            if (bapTobeDeleteIDs.size() > 0) {
                SalesRevenueController.deleteTerminationBAPData(bapTobeDeleteIDs);
                system.System.debug('=================== bapTobeDeleteIDs : ' +  bapTobeDeleteIDs); 
            }

//            update bapList;
        
        }
        catch (Exception e) {
            string notes = 'Error on AddDeleteNewLinkOpptiesToSalesRevenue.AddDeleteNewLinkOpptiesToSalesRevenue method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
}