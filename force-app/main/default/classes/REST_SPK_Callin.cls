/*
	version : 1
    End Point : /services/apexrest/v1/SPK 

    Sample Data :
	
	{
    "request_id": "b51e0126-8d20-6b10-5676-59568d16c885",
    "data": [
        {
		"sf_spk_id":"SPK_01",
            "spk_no": "01/SPK/04/23",
            "status":"Sent to Partner"
        },
        {
		"sf_spk_id":"SPK_02",
            "spk_no": "01/SPK/04/23",
            "status":"Sent to Partner"
        },
    ]
    }


*/

@RestResource(urlMapping='/v1/SPK/*')
global with sharing class REST_SPK_Callin {

    global REST_SPK_Callin() { 
    
    
    }
    
      /* PUT METHOD 
     *
     */
    @HttpPut
    global static PUT_Return_Message doPut() {
        SYSTEM.DEBUG (' ================== In PUT METHOD at REST_SPK_Callin_v1 ==============');
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string callerFrom = req.remoteAddress;
        String postBody = req.requestBody.toString(); 

        System.debug('Isi Dari Body Post'+postBody);

        String callID = '';
        String status = '';
        String SPKTicket_ID = '';
        
	    PUT_Return_Message returnMessage = null;
        String currentRequestURL;
        DateTime start_time = datetime.now();
        
        Call_Log__c calllog = new Call_Log__c();
        RESULT_DATA resDAta = new RESULT_DATA();
        ERROR_MESSAGE err = new ERROR_MESSAGE(); 
        
       try {
            //-- UPDATE RECORD
            SPKUpdate SPKUpdate_Extract = (SPKUpdate)JSON.deserialize(postBody, SPKUpdate.class);



            System.debug('>>> SPKUpdate_Extract REST_SPK_Callin_v1 : '+SPKUpdate_Extract);

            callID =  SPKUpdate_Extract.RequestID;
            SPKTicket_ID = SPKUpdate_Extract.Name;

            try {
                //-- DML Process for Updating
                SPK__c SPKList_Exctract = null;

                List<SPK__c> SPKList = [SELECT Id,Name, PR_Rel__c, 	RequestID__c, status__c FROM SPK__c WHERE RequestID__c =: callID]; 

                system.debug('Jumlah SPK'+SPKList.size());

                if(SPKList!=null && !SPKList.isEmpty()){
               
                   SPKList_Exctract.Status__c = 'Sent to Partner';
                    
                    update SPKList_Exctract;  
                    
                }
            }
            catch (DMLException e) {
                status = 'failed';
                //-- if update error
                system.debug('Status DMLnya : ');

                RestContext.response.statusCode = 204;
                err.err_no = RestContext.response.statusCode;
                err.err_message = 'Error on PUT method.::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
                calllog.status__c = status;
                
                returnMessage = new PUT_Return_Message(callID, status, resData, err);
                
            }

        }
        catch (Exception e) {
            status = 'failed';    		
            //-- if json is not readble
            RestContext.response.statusCode = 400;
            
            //-- if error on validation
            RestContext.response.statusCode = 403;
            
            calllog.status__c = status;
            err.err_no = RestContext.response.statusCode;
            err.err_message = 'Error on PUT method.::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            
            AppUtils.putError(err.err_message );
            
            //-- put log error 
        }	

        resData.source = 'SPK' ;
        resData.service = 'updateSPK' ;
        resData.ticket_id = callID ; //'---PUT TICKET ID OVER HERE---'
        resData.ticket_record_id = SPKTicket_ID; //'---PUT TICKET RECORD ID (SF ID) OVER HERE---'
        status = 'success';

        returnMessage = new PUT_Return_Message(callID, status, resData, err);

        //-- put call log information	    	
        calllog.type__c = 'Callin';
        calllog.method__c = 'PUT';
        calllog.URI__c = '/services/apexrest/v1/SPK/';
        calllog.request_start_time__c = start_time;
        calllog.status__c = status ;
        calllog.Request_Message__c = postBody;
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(returnMessage) ;
        //calllog.Salesforce_ID_1__c = SPKTicket_ID;
        // TODO  : put related record (ticket sf id)
        //calllog.SPK__c = SPKTicket_ID;
        calllog.endpoint__c = 'https://cs72.salesforce.com';
        calllog.Request_ID__c  = callID;

        //-- put object record related to callog
        //--
                   
        insert calllog;

        system.debug('>>> returnMessagePUT REST_Customer_Registration_Callin_v1 : ' + returnMessage);

        return returnMessage;
        

        
        }
    
    
    
    global class PUT_Return_Message {
        String call_id;
        String status;
		RESULT_DATA data;
        ERROR_MESSAGE error_message;
        PUT_Return_Message(String callID, String status, RESULT_DATA data, ERROR_MESSAGE errorMessage ){
            this.call_id = callID;
            this.status = status;
            this.data = data;
            this.error_message =  errorMessage;
        }
      }
    
   
    global class RESULT_DATA {
        string source = '' ;
        string service = '' ;
        string ticket_id = '';
        string ticket_record_id = null;

    }
    
    global class ERROR_MESSAGE {
    	integer err_no ;
    	string err_message;
    }
    
    global class SPKUpdate {
        global String name { get; set; }
        global String call_id { get; set; }
        global String RequestID { get; set; }
        global String status { get; set; }
        
    }

    
    
}