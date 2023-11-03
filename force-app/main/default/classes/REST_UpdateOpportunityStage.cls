@RestResource(urlMapping='/simcardactivations/*')
global class REST_UpdateOpportunityStage {
     class RESTParameter {
        Header header = new Header();
        Body body  = new Body();
    } 
    class Header{
    	String service;
    	String request_id;
    }
    class Body{
    	Data Data=new Data();
    }
    class Data{
    	String Opportunity_No;
    	String Stage;
    	String la_number;
    }
     global class RESTResultX{
        String Status;
        String Message;
        
        RESTResultX(String Status, String Message){
            this.Status = Status;
            this.Message = Message;
        }
    } 
     @HttpPut
    global static RESTResultX doPut(){
    	RESTResultX restResult = new RESTResultX('',''); 
    	  String param ='';
        String status ='';
        String service ='';
        String requestid ='';
        String errMessage ='-';
        String errCode ='-';
        String OpportunityNo='';
        String Stage='';
        String LANumber='';
         Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'PUT';
        calllog.request_start_time__c = datetime.now();
           try  {
                RestRequest request = RestContext.request;
                //RestResponse response = RestContext.response;
                param = RestContext.request.requestBody.toString().trim();
                status ='success';
                
                // put callout information
                calllog.request_message__c = param ;
                calllog.response_message__c = status;
                calllog.status__c = status ;
                calllog.uri__c = request.requestURI;
                calllog.callerFrom__c = request.remoteAddress;   
                 String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();               
                calllog.endpoint__c = currentRequestURL.replace (calllog.uri__c,'');   
                   Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped(param);
              
                
                if(paramMap.size() > 0){   
                   requestid = AppUtils.getStringDataOnMap(paramMap , 'header::request_id');
                   service = AppUtils.getStringDataOnMap(paramMap , 'header::service');
                     Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');
                   OpportunityNo=AppUtils.getStringDataOnMap(mapRec , 'opportunity_no');
                   Stage=AppUtils.getStringDataOnMap(mapRec , 'stage');
                   LaNumber=AppUtils.getStringDataOnMap(mapRec , 'la_number');
                   list<Opportunity> O=[SELECT StageName,Account_LA_IDCOM__c FROM Opportunity WHERE Opportunity_ID__c=:OpportunityNo LIMIT 1];
                  	Account A=[SELECT LA_Number__c from Account WHERE ID=:O[0].Account_LA_IDCOM__c];
                  	
                  	if(O.size()==1)
                  {	O[0].StageName=Stage;
                  	if(Stage=='Closed Won')
                  	{
                  		if (LANumber<>'') {A.LA_Number__c=LANumber;}
                  		update A;
                  	}
                  	update O;}
                  	else
                  	status='Opportunity ID False';
                }
           }
           catch(exception e)
           {
           	  status ='failed';
                errMessage = e.getmessage() + ' - error line : '  + e.getLineNumber();
                errCode = '1';
           }
           restResult.status=status;
           restResult.Message=errmessage;
           calllog.response_end_time__c = datetime.now();     
            calllog.response_message__c = JSON.serialize(restResult) ;      
            insert calllog;
    	return restResult;
    }
}