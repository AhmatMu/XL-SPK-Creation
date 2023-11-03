public with sharing class hitupdatePRStatus{
//hasil generate wsdl dari updateprstatus dilakukan disini

	@future(callout=true) 
    public static void updatePRStatus(String OpportunityID)
    {
    	
    	//Opportunity O=[SELECT PR__c,PR_Status__c,StageName,Opportunity_ID__c FROM Opportunity WHERE ID=:OpportunityID];
    	//contoh parameter sapComDocumentSapRfcFunctions2.ZEXDSDST00098 opportunity=new sapComDocumentSapRfcFunctions2.ZEXDSDST00098();
    	sapComDocumentSapSoapFunctionsMcS3.Zexdsdst00116 opportunity = new sapComDocumentSapSoapFunctionsMcS3.Zexdsdst00116();
        sapComDocumentSapSoapFunctionsMcS3.ZBIND_SF_NOTIF_CHANGESTATUS HitSAP = new sapComDocumentSapSoapFunctionsMcS3.ZBIND_SF_NOTIF_CHANGESTATUS();
		sapComDocumentSapSoapFunctionsMcS3.Zexdsdtt00059 Result = new sapComDocumentSapSoapFunctionsMcS3.Zexdsdtt00059();
        list<sapComDocumentSapSoapFunctionsMcS3.Zexdsdst00115> listresponse = new list<sapComDocumentSapSoapFunctionsMcS3.Zexdsdst00115>();
        	
        
        HitSAP.inputHttpHeaders_x = new Map<String,String>();
		String username = system.label.SAPUsername;//'xlsapint';
		String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';
		Blob headerValue = Blob.valueOf(username + ':' + password);
		String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
		HitSAP.inputHttpHeaders_x.put('Authorization',authorizationHeader);
		HitSAP.inputHttpHeaders_x.put('Content-Type', 'text/xml');    	
		Datetime startTime;
		try{
			startTime = system.now();
        	Opportunity O=[SELECT PR__c,PR_Status__c,StageName,Opportunity_ID__c FROM Opportunity WHERE ID=:OpportunityID];
    	
        	opportunity.SapId = O.PR__c;
        	opportunity.Status = O.PR_Status__c;
        	opportunity.Source = 'SF';
        	
        	Result=HitSAP.ZexdSfChangeStatus(opportunity);
        	
        	listresponse=Result.item;
        	
        	
        	Call_Log__c CL = new Call_Log__c();
        	CL.endpoint__c = hitSAP.endpoint_x;
        	CL.request_start_time__c = startTime;
        	CL.Request_Message__c = String.valueof('Opportunity'+opportunity);
			CL.response_message__c = String.valueof(listresponse[0]);
			
			//CL.Request_Message__c = JSON.serialize (opportunity);
            //CL.response_message__c = JSON.serialize (Contract4);
			CL.response_end_time__c = system.now();
	        CL.Type__c = 'Callout';
	        insert CL;
	        
        }
        catch(exception e)
        {
        	startTime = system.now();
        	
        	Result=HitSAP.ZexdSfChangeStatus(opportunity);
        	
        	listresponse=Result.item;
        	
        	
        	Call_Log__c CL = new Call_Log__c();
        	CL.endpoint__c = hitSAP.endpoint_x;
        	CL.request_start_time__c = startTime;
        	CL.Request_Message__c = String.valueof('Opportunity'+opportunity);
			CL.response_message__c = String.valueof(listresponse[0]);
			
			//CL.Request_Message__c = JSON.serialize (opportunity);
            //CL.response_message__c = JSON.serialize (Contract4);
			CL.response_end_time__c = system.now();
	        CL.Type__c = 'Callout';
	        insert CL;
	       
        }
		
    }
}