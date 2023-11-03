/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 08-11-2023
 * @last modified by  : Doddy Prima
**/


@RestResource(urlMapping='/Inbound_Capture/*')
global with sharing class REST_Inbound_Capture {

	@HttpGet
	global static string get(){


        String param ='';
        String status ='';
        String service ='';
        String requestid ='';
        String errMessage ='-';
        String errCode ='-';
        
        String ipAddressRequestCameFrom='';
        String currentRequestURL;
        String sfdcBaseURL;        
        
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'GET';
        calllog.request_start_time__c = datetime.now();

        Link__c[] tmpLinks = new List <Link__c>();                        
        
        try  {
                RestRequest request = RestContext.request;
                String recordId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

                //RestResponse response = RestContext.response;
                param = RestContext.request.requestBody.toString().trim();
                status ='success';

                ipAddressRequestCameFrom = request.remoteAddress;


                
                // put callout information
                calllog.request_message__c = param ;
                calllog.response_message__c = status;
                calllog.status__c = status ;
                calllog.uri__c = request.requestURI;
                calllog.CallerFrom__c = ipAddressRequestCameFrom;

                calllog.Request_Message__c = '== request.headers : ' + request.headers + ' ::: ' + 
                    '== request.resourcePath : ' + request.resourcePath + ' ::: ' + 
                    '== request.httpMethod : ' + request.httpMethod + ' ::: ' + 
                    '== request.params : ' + request.params + ' ::: ' + 
                    '== request.remoteAddress : ' + request.remoteAddress + ' ::: ' + 
                    '== request.requestBody : ' + request.requestBody + ' ::: ' + 
                    '';
                
                system.debug ('============= ipAddressRequestCameFrom : ' + ipAddressRequestCameFrom );
                system.debug ('============= request.headers          : ' + request.headers);
                system.debug ('============= request.httpMethod       : ' + request.httpMethod);
                system.debug ('============= request.params           : ' + request.params);
                system.debug ('============= request.remoteAddress    : ' + request.remoteAddress);
                system.debug ('============= request.requestBody      : ' + request.requestBody);
                system.debug ('============= request.requestURI       : ' + request.requestURI);
                system.debug ('============= request.resourcePath     : ' + request.resourcePath);

        }
        catch (Exception e) {
                status ='failed';
                errMessage = e.getmessage() + ' - error line : '  + e.getLineNumber();
                errCode = '1';
                
            }
            
        // put response data 
        /*
        RESTResult restResult = new RESTResult(); 
        restResult.header.service = service;
        restResult.header.request_id = requestid;
        restResult.header.response_id = AppUtils.getUniqueNumber();
        restResult.header.status = status;
        restResult.body.except.error_message = errMessage;
        restResult.body.except.error_code = errCode;
        */
        
        // put callout information then save the data on Call_Log object
        calllog.response_end_time__c = datetime.now();     
        //calllog.response_message__c = JSON.serialize(restResult) ;            
        insert calllog;

        
        return 'success';





	} 

    /*
	@HttpPost
	global static void post(String name){

	}

	@HttpDelete
	global static void delete(){
		RestRequest request = RestContext.request;
		String recordId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
		sObject deleteRecord = [SELECT Id FROM sObject WHERE Id = :recordId];
		delete deleteRecord;
	}

	@HttpPut
	global static void put(String name,String recordId){
		Account acc=new Account(name=:name,Id=:recordId)
		update acc;
	}

	@HttpPatch
	global static void patch(){
		RestRequest request = RestContext.request;
		String recordId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
	}
    */
}