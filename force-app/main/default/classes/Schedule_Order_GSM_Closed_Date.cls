global class  Schedule_Order_GSM_Closed_Date implements Schedulable {

    global void revisiOpptyProduct(Opportunity O,AggregateResult[] AR_OrderProduct)
    {
    	list<OpportunityLineItem> OLI=[SELECT id,Pricebookentry.Product2ID,Quantity FROM OpportunityLineItem WHERE OpportunityID=:O.id];
    	for(integer x=0;x<OLI.size();x++)
    	{
    		for(integer y=0;y<AR_OrderProduct.size();y++)
    		{
    			if(AR_Orderproduct[y].get('Result')==OLI[x].PricebookEntry.Product2ID)
    			{
    				OLI[X].Previous_Quantity__c=OLI[x].Quantity;
    				OLI[x].Quantity=Integer.valueof((Decimal) AR_Orderproduct[y].get('Total'));
    			}
    		}
    	}
    	update OLI;
    }
    global void execute(SchedulableContext sc) 
    {        
    	list<Opportunity> listO=[SELECT ID,RecordtypeName__c,TotalOpportunityQuantity,StageName FROM Opportunity WHERE RecordtypeName__c LIKE 'GSM%' AND CloseDate=:system.today() AND StageName!='Closed Won' AND StageName!='Closed Lost'];
    	Integer totalall=0;
    	if(listO.size()>0)
    	{
    	for(Opportunity O:listO)
    	{
    		AggregateResult[] AR_OrderProduct=[SELECT SUM(Quantity) Total,PricebookEntry.Product2ID Result FROM OrderItem WHERE Order.Status!='Draft' AND Order.OpportunityID=:O.id GROUP BY Pricebookentry.Product2ID];
            for(AggregateResult AR:AR_OrderProduct)
            {
            	totalall=totalall+Integer.valueof((Decimal)AR.get('Total'));
            }
            if(totalall==0)
            {
            	O.StageName='Closed Lost';
            	O.Loss_Reason__c='No Activation until closed date';
            	O.Loss_Reason_Description__c='Sales Order SIM CARD But None Activated';
            }
            else
            {
            	O.StageName='Closed Won';
            	revisiOpptyProduct(O,AR_OrderProduct);
            }    		
    	}
    	update listO;
    	}
    	
    }
    
}