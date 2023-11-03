global class ReplicatePRToEasyOps {
     class Body {
        Header header = new Header();
        DataBody body  = new DataBody();
    } 
    
    class DataBody {
        DataContent data = new DataContent();
    }

   
    
    class DataContent {
        String bp_number;
        String bp_site_a;
        String bp_site_b;
		String bandwith;
		String cid;
		String uom;
		String service_type;
		String free_link;
		String pr;
		String sr;

    }
    
    class Header {
    	string status='';
        string service='';
        string request_id ='';
    
    }
    
    class Except {
        string status='';
        string message = '';
    }
    
    class ErrBody {
        Except except; 
        
        ErrBody () {
           except = new Except();
        }
    }
    
    global class RESTResult{
        Header header;
        ErrBody body;        
        RESTResult(){
            header= new Header();
            body= new ErrBody();
        }
    }
    
    
   
    
    @future(callout=true)
    public static void ReplicatePR ( string requestid,String JobID//,
        //string requestorId, string simcardName, decimal quantity, string status
        ) {
        list<Scheduled_Process__c> spList = [select id, status__C from Scheduled_Process__c where jobID__c=:JobID];
        system.debug ('============ spList : ' + spList);
        if (spList.size() >0 ) {
        	spList[0].Execute_Start__c = system.now();
        }	
		
        //-- GET TOKEN 
        
        String endpoint = Label.REST_TransDB_GetToken_Endpoint ;
        String username = Label.REST_TransDB_GetToken_Username ;
        String password = appUtils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; 
        string token = apputils.getToken(endpoint, username, password, 1 );
        //string token ='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyODEiLCJ1c2VybmFtZSI6ImFwaWRlbW8iLCJyZWFsX25hbWUiOiJBUEkgRGVtbyIsInVzZXJzdWJncm91cCI6IjM0IiwidXNlcnN1Ymdyb3VwX25hbWUiOiJPUFMtR09WIiwidXNlcmdyb3VwIjoiMjQiLCJ1c2VyZ3JvdXBfbmFtZSI6IkRTLU9QUyIsImVtYWlsIjoiYXBpZGVtb0B4bC5jby5pZCIsImlzX3Jvb3QiOm51bGwsImlhdCI6MTUzMTk4Nzc2MSwiZXhwIjoxNTMxOTk0OTYxfQ.V75zzhreguGBnDi1B2BDkrHXP02wF6tD0sJfLRQTPtA';

        System.debug('==================== token : ' + token);        
        //------------
        if (token <> 'failed') {    
            Call_Log__c calllog = new Call_Log__c();
            calllog.type__c='Callout';
            calllog.request_start_time__c = datetime.now();
            
            // REQUEST to transDB for create a Simcard request
            //----- POST REQUEST
            HttpRequest req = new HttpRequest();
            endpoint = Label.REST_EasyOps_Replicate_PR ; //'https://easy-ops.xl.co.id/dev/api/sales_forecast'; 
            String headerService='replicatePR';
            calllog.method__c = 'POST';
            
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token );
            req.setMethod('POST');
        
           
          

            Body oBody = new Body();
            oBody.header.service=headerService;
            oBody.header.request_id = AppUtils.getNewGUID();
            
          list<SR_PR_Notification__c> A= [select id,CID__c,No_SR_Khusus_PR__c,Account__r.BP_Number__c,Project_Type__c,Services__c,UOM_After__c,Capacity_After__c,Opportunity__c,Opportunity__r.Amount,Opportunity__r.Account_Site_A__r.BP_Number__c,Opportunity__r.Account_Site_B__r.BP_Number__c,Opportunity__r.PR__c
            	from SR_PR_Notification__c
                where ID= :requestId ];
           
           if (A.size() > 0) {
           		oBody.body.data.bp_number=A[0].Account__r.BP_Number__c;
           		oBody.body.data.cid=A[0].CID__c;
           		oBody.body.data.bp_site_a=A[0].Opportunity__r.Account_Site_A__r.BP_Number__c;
				oBody.body.data.bp_site_b=A[0].Opportunity__r.Account_Site_B__r.BP_Number__c;
				oBody.body.data.bandwith=A[0].Capacity_After__c;
				oBody.body.data.pr=A[0].Opportunity__r.PR__c;
				oBody.body.data.sr=A[0].No_SR_Khusus_PR__c;
				if(A[0].uom_After__c=='Gbps')
				{
					oBody.body.data.uom='3';
				}
				if(A[0].uom_After__c=='Mbps')
				{
					oBody.body.data.uom='2';
				}
				if(A[0].uom_After__c=='Kbps')
				{
					oBody.body.data.uom='1';
				}
				if(A[0].uom_After__c=='Rack')
				{
					oBody.body.data.uom='4';
				}
				if(A[0].uom_After__c=='E1')
				{
					oBody.body.data.uom='5';
				}
				if(A[0].uom_After__c=='STM')
				{
					oBody.body.data.uom='6';
				}
			if(A[0].Services__c=='LL')
			{
				oBody.body.data.service_type='04';
			}
				if(A[0].services__c=='MPLS')
				{
					oBody.body.data.service_type='07';
				}
				if(A[0].Services__c=='ISP')
		{
			oBody.body.data.service_type='06';
			
		}
		if(A[0].Services__c=='NAP')
		{
			oBody.body.data.service_type='08';
			
		}
		if(A[0].Services__c=='VOIP')
		{
			oBody.body.data.service_type='05';
			
		}
		if(A[0].Services__c=='APN Corporate')
		{
	//	oBody.body.data.service_type='05';
			
		}
		if(A[0].Services__c=='MDS Bulkshare')
		{
		//	oBody.body.data.service_type='05';
			
		}
				if(A[0].Opportunity__r.Amount==0)
				oBody.body.data.free_link= '1';
				else
				oBody.body.data.free_link= '0';
           		 string jsonString = JSON.serialize(oBody);
           		
           		  req.setBody(jsonString);
           		  Http http = new Http();
           		  String restResult='';
           		  if(!test.isrunningtest())
           		  {
                HTTPResponse response = http.send(req);            
               restResult = response.getBody ();
               
              
           		  }
           		  else
           		  {
           		  	restResult='{success:ok}';
           		  }
           		   if (spList.size() >0 ) {
            	  SPLIST[0].Status__c='Success';
               spList[0].Execute_End__c = system.now();
               update SPLIST;
            		}
                calllog.request_message__c = jsonString;
            	calllog.response_message__c = restResult;
            	
            	//calllog.uri__c = req.requestURI;        
            	calllog.callerFrom__c = 'Salesforce' ; 
            	calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
 
            // put callout information then save the data on Call_Log object
            	calllog.response_end_time__c = datetime.now();     
                  
            	insert calllog;
            }
        }
 
    } 
}