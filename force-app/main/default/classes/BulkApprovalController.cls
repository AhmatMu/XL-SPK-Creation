global with sharing class   BulkApprovalController {
 public List<Id> selectedOpportunitiesId;
 public String selectedOpportunitiesIdJSON{get;set;}
    
 public BulkApprovalController(Apexpages.StandardSetController  standardController){
     
 	selectedOpportunitiesId   = new List<Id>();
 	for(Opportunity oppty:    (List<Opportunity>)standardController.getSelected()){
  		selectedOpportunitiesId.add(oppty.Id);
  		// you   will get only Ids from controller.
 	}
 	if(selectedOpportunitiesId.size()>0){
   		selectedOpportunitiesIdJSON =    JSON.serialize(selectedOpportunitiesId);
 	}
}
    
@RemoteAction
global static String submitForApproval(String   selectedOpportunities){
  try{
    List<String> selectedOpptys   = (List<String>)JSON.deserialize(selectedOpportunities,  List<String>.class);
    List<Approval.ProcessSubmitRequest>   approvalRequests = new   List<Approval.ProcessSubmitRequest>();
    //Creating an approval requests for each Opportunity using  ProcessSubmitRequest
    Approval.ProcessSubmitRequest approvalRequest;
    for(Id opptyId: selectedOpptys){
      approvalRequest   = new Approval.ProcessSubmitRequest();
      approvalRequest.setComments('Submitting   request for approval');
      approvalRequest.setObjectId(opptyId);// which record to approve
		//change approver id
       approvalRequest.setNextApproverIds(new   Id[]      {UserInfo.getUserId()});
       approvalRequests.add(approvalRequest);
   }
	// Submit the approval request
    Approval.ProcessResult[] result   =    Approval.process(approvalRequests);
   return 'success';
  }catch(Exception ex){
     return 'error '+ex.getMessage();
  }
}
public Pagereference redirectToListView(){
    Schema.DescribeSObjectResult destination;
    PageReference pageRef;
    try{
      destination = Opportunity.SObjectType.getDescribe();
      pageRef = new PageReference('/' + destination.getKeyPrefix()     );
      pageRef.setRedirect(true);
      return pageRef;
    }catch(Exception ex){
      return pageRef;
    }
  }
}