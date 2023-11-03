trigger Trigger_Simcard_Production_Request_Header on Simcard_Production_Request_Header__c (after insert, after update, before insert, before update) {

if (label.Is_Trigger_Simcard_Production_Request_Header_ON== 'YES') {

  if(trigger.isUpdate)
    {
        if(trigger.isAfter)
        { 
            for(Simcard_Production_Request_Header__c req:system.trigger.new) {
                 //for(Opportunity newOpp:system.trigger.new) {
                 Simcard_Production_Request_Header__c oldReq = Trigger.oldMap.get(req.id);
                 
//                if ( ( req.Status__C == 'Submit' && oldReq.Approval_Status__c <> req.Approval_Status__c && req.Approval_Status__c == 'Approved' ) ||   //-- status "Submit" dan sudah di-approve
//                      ( req.Approval_Status__c == 'Approved' && oldReq.Status__C <> req.Status__C && req.Status__C == 'Submit'  )  //-- sudah approved, mencoba submit (hit)
//                  ) {
                        
                  if (oldReq.Status__C <> req.Status__C && req.Status__C == 'Submit'  ) {                   
                    // then request or hit to GSM system API for creating a SIMCard request record
                    //system.debug('======= Emp ID   :' + req.Requestor_ID__c);
                    
                    REST_SIMCardRequest.addSimCardRequest (
                           req.id //, 
                           //req.Requestor_ID__c, req.Simcard__c, req.Quantity__c, req.Status__c
                        );
                }
            }
        
        }
        
        
    }
} // endof trigger activation    
}