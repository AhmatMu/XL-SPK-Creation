public with sharing class ReadAvailableMaterialInfo_Controller {
	public List <OrderItem> orderItemList {get;set;}
	public string  message {get;set;}
	Order tmpOrder;
	public integer getInfoCount=0; 
	public boolean enabled {get;set;} 
	
	ApexPages.StandardController con;
	
    public ReadAvailableMaterialInfo_Controller (ApexPages.StandardController controller) {
    	con = controller;
        tmpOrder = (Order) con.getRecord();
        enabled=true;
    }

    public PageReference getInfo() {
        getInfoCount++;
        
        order orderRec = [select id, status from order where id=:tmpOrder.id];
        if (orderRec.status=='Draft' || orderRec.status=='Submit Order' || orderRec.status== 'Order Fulfillment') 
        	enabled=true;
        else enabled=false;
        	
        //if (getInfoCount == 3 ) enabled=false;
        
        orderItemList = [select PricebookEntry.Product2.Name,  is_Available__c, available__c 
											from orderItem where orderid =:tmpOrder.id];
		
		
		boolean isError = false;
		message= '';
		for (orderitem item: orderItemList) {
			if (item.is_available__c==false){
				message = 'Some or all materials is not available. Stage back to draft, refresh the page to get latest condition.';
				isError = true;
			}
		}
		
		if (orderItemList.size() == 0) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'No Material selected. Select the material first!.'));
		}
		else if(isError)
       		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, message));
      	else if(!isError)
      		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'All Materials is available'));
      		
		/*      		
 		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Account number'));
 		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Account phone'));
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Account site'));
 	    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Please enter Account industry'));
 			*/
											
        return null;
    }    
    
    public void refresh() {
    	REST_Material.readAvailableMaterialOnOrder(tmpOrder.id); getInfo();
    	
    }
}