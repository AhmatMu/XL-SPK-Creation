global class SyncBPToEasyOps {
     class Body {
        Header header = new Header();
        DataBody body  = new DataBody();
    } 
    
    class DataBody {
        DataContent data = new DataContent();
    }

   
    
    class DataContent {
        String bp_number;
        String bp_type;
        String name;
        String phone;
        String am_name;
        String am_email;
        String sm_name;
        String sm_email;
        String gm_name;
        String gm_email;
        String city;
        String region;
        String address;
        String segmentation;

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
    public static void updateBP ( string requestid,String JobID//,
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
            endpoint = Label.REST_EasyOps_SyncBP ; //'https://easy-ops.xl.co.id/dev/api/sales_forecast'; 
            String headerService='synchBp';
            calllog.method__c = 'POST';
            
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token );
            req.setMethod('POST');
            req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
        
           
          

            Body oBody = new Body();
            oBody.header.service=headerService;
            oBody.header.request_id = AppUtils.getNewGUID();
            
           list<Account> A= [select id, billingcity,Phone,region__c,Segmentation_formula__c,Organization_Type__c,billingstreet,owner.name,owner.email,owner.manager.name,owner.manager.email,owner.manager.manager.email,owner.manager.manager.name,bp_number__c,Name
            	from Account
                where ID= :requestId ];
           
           if (A.size() > 0) {
           		oBody.body.data.bp_number=A[0].BP_Number__c;
           		oBody.body.data.bp_type=A[0].organization_type__c;
           		oBody.body.data.name=A[0].Name;
           		oBody.body.data.phone=A[0].Phone;
           		oBody.body.data.am_name=A[0].Owner.Name;
           		oBody.body.data.am_email=A[0].Owner.Email;
           	    oBody.body.data.sm_name=A[0].Owner.Manager.Name;
           	    oBody.body.data.sm_email=A[0].Owner.Manager.Email;
           	    oBody.body.data.gm_email=A[0].Owner.Manager.manager.Email;
           	    oBody.body.data.gm_name=A[0].Owner.Manager.manager.name;
           	    oBody.body.data.region=A[0].Region__c;
           	    oBody.body.data.city=A[0].BillingCity;
           	    oBody.body.data.address=A[0].BillingStreet;
           	    oBody.body.data.segmentation=A[0].Segmentation_formula__c;
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