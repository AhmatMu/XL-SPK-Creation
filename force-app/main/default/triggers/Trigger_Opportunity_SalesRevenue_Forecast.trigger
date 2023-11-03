trigger Trigger_Opportunity_SalesRevenue_Forecast on Opportunity ( after update) {
    if(trigger.isafter) {
         if(trigger.isupdate) {
             
             for(Opportunity oppNew:system.trigger.new) {
                Opportunity oppOld=Trigger.oldMap.get(oppNew.id);
                
                // if any update on amount
                if (oppOlD.StageName!='Closed Won' && OppNew.StageName=='Closed Won') {
                    //-- get owner
                    /*
                    string ownerID;
                    ownerID = oppNew.ownerID;

                    //-- get invoicing estimate date (month and year)
                    Integer iedDay=0; 
                    Integer iedMonth=0; 
                    Integer iedYear=0; 
                    double soa;

                    iedDay = oppNew.invoicing_estimate_date__c.day();
                    iedMonth = oppNew.invoicing_estimate_date__c.month();
                    iedYear = oppNew.invoicing_estimate_date__C.year();

                    //-- get sum of amount of that month
                    system.debug ('============= ownerID ' + ownerid );
                    system.debug ('============= iedDay ' + iedDay );
                    system.debug ('============= iedMonth ' + iedMonth );
                    system.debug ('============= iedYear ' + iedYear );
                    
                    AggregateResult[] groupedResults = [select ownerid, sum(Amount) soa from opportunity 
                        where ownerid = :ownerID and CALENDAR_MONTH(invoicing_estimate_date__c) = :iedMonth and 
                            CALENDAR_YEAR(invoicing_estimate_date__c) = :iedYear
                            group by ownerid];
                    
                    double totAmount=0;
                    for (AggregateResult ar : groupedResults)  {
                        soa= (double) ar.get('soa') ;
                        totAmount=totAmount + soa ;
                    }

                    //-- check availablity data Salestarget
                    Sales_Target_and_Revenue__c[] strs = [ select id from Sales_Target_and_Revenue__c 
                        where Type__c = 'Forecast' and 
                            User__c = :ownerID and 
                            CALENDAR_MONTH(Date__c) = :iedMonth and 
                            CALENDAR_YEAR(Date__c) = :iedYear ];
                    
                    Sales_Target_and_Revenue__c tmpStr = new Sales_Target_and_Revenue__c();
                    Sales_Target_and_Revenue__c[] tmpStrs = new List<Sales_Target_and_Revenue__c>();
                    
                    try {
                        if (strs.size() >0) {
                            //-- exist, then update
                            tmpStr.id= strs[0].id;
                            tmpStr.Amount__c = totAmount;
                            tmpStrs.add (tmpStr);
                            update tmpStrs;
                        }
                        else{
                            //-- no-record-data, then create
                            date periode = date.newInstance(iedYear, iedMonth, iedDay);

                            tmpStr.User__c= ownerID;
                            tmpStr.Date__c= periode;
                            tmpStr.Type__c= 'Forecast';
                            
                            tmpStr.Amount__c = totAmount;
                            tmpStrs.add (tmpStr);

                            insert tmpStrs;
                        }
                    }
                    catch (Exception e) {
                        string errMessage = e.getmessage() + ' - error line : '  + e.getLineNumber() ;
                        // note::message::linenumber
                        apputils.putError('error on trigger Trigger_Opportunity_SalesRevenue_Forecast on Opportunity ( after update) ' +
                            ' data: ' + tmpStrs +
                            '::'+ e.getmessage() + '::' + e.getLineNumber() ); 

                    }*/
                }
             }
             

         }
    }
}