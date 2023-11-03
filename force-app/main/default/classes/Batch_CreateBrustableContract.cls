/**
 * @description       : 
 * @author            : Adam
 * @group             : 
 * @last modified on  : 01-28-2023
 * @last modified by  : Diky Nurosid
**/
global class Batch_CreateBrustableContract implements  Database.Batchable<Billing_Request__c>,Database.Stateful {
	
    public List<Billing_Request__c> billingRequestList;
    public Set<Id> billingRequestIds;
    public Map<Id,Id> mapContractBillingRequest;
	//-- constructor
	public Batch_CreateBrustableContract(List<Billing_Request__c> billingRequestList ){
		this.billingRequestList = billingRequestList;
        this.billingRequestIds = new Set<Id>();
        this.mapContractBillingRequest = new Map<Id,Id>();
	}
     
    public Iterable<Billing_Request__c> start(Database.BatchableContext BC){
    	return billingRequestList;
    }
    
    public void execute(Database.BatchableContext BC, List<Billing_Request__c> billingRequestList){
        
        for (Billing_Request__c billingRequestRec : billingRequestList) {
            Contract_services_v2 contract_service = new  Contract_services_v2();
            Id contractBrustable =contract_service.CreateBrustableContractFromLink(billingRequestRec.Link__c,billingRequestRec.Id);
    
            if(contractBrustable != null){
                billingRequestIds.add(billingRequestRec.Id);
                mapContractBillingRequest.put(billingRequestRec.Id,contractBrustable);
            }
            
        }   
    }   
    
    global void finish(Database.BatchableContext BC){
        /* :TODO IF ERROR CREATE LOG ERROR */
        List<Billing_Request__c> newBillingRequestList = new List<Billing_Request__c>();
        if(billingRequestIds.size()>0){
            for(Id extractId : billingRequestIds){
                Billing_Request__c billingRequestObj = new Billing_Request__c();
                billingRequestObj.Id = extractId;
                billingRequestObj.Status__c = 'Created';
                billingRequestObj.Contract_Ticket__c = (Id) mapContractBillingRequest.get(extractId);
                newBillingRequestList.add(billingRequestObj);
            }
            System.debug('BillingRequest ==> ' + newBillingRequestList);
            update newBillingRequestList;
        }
    }
    
    
    
}