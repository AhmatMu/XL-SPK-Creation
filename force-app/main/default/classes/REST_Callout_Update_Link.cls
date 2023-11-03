global class REST_Callout_Update_Link {
      class Body {
        Header header = new Header();
        DataBody body  = new DataBody();
    } 
    
    class DataBody {
        DataContent data = new DataContent();
    }

    class DataContentDetail {
        string sfd_material;
        string sfd_qty;
    }
    
    class DataContent {
        string tli_id ='';
        string contract_item ='';
        string bandwidth='';
        decimal uom=0;
        integer free_link=0;
        List<DataContentDetail> material= new List<DataContentDetail>() ;

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
    public static void updateLink ( string requestid,String JobID//,
        //string requestorId, string simcardName, decimal quantity, string status
        ) {
        list<Scheduled_Process__c> spList = [select id, status__C from Scheduled_Process__c where jobID__c=:JobID];
        system.debug ('============ spList : ' + spList);
        if (spList.size() >0 ) {
        	spList[0].Execute_Start__c = system.now();
        }	
		list<Link__c> Link=new list<Link__c>();
        //-- GET TOKEN 
        System.debug('===== requestid  : ' + requestid);
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
            endpoint = Label.REST_EasyOps_Update_Link ; //'https://easy-ops.xl.co.id/dev/api/sales_forecast'; 
            String headerService='updatelink';
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
            
           link= [select id, Capacity_Bandwidth__c, ID__c,Contract_Item_Rel__r.Contract_id__c,Contract_Item_Rel__r.SAP_ID__c, UoM__c, free_link__c ,CID__c,Link_id__c
            	from Link__c
                where link_id__c= :requestId ];
           System.debug('===== link_id__c  : ' + link.size());
            
           if (link.size() > 0) {
           		oBody.body.data.tli_id=link[0].id__c;
            	oBody.body.data.contract_item=link[0].contract_item_rel__r.Contract_id__c+'-'+link[0].contract_item_rel__r.SAP_ID__c;
            	oBody.body.data.bandwidth=link[0].Capacity_Bandwidth__c;
           		if(link[0].uom__c=='Kbps')
           		oBody.body.data.uom=1;
           		if(link[0].uom__c=='Mbps')
           		oBody.body.data.uom=2;
           		if(link[0].uom__c=='Gbps')
           		oBody.body.data.uom=3;
           		if(link[0].uom__c=='E1')
           		oBody.body.data.uom=5;
           		if(link[0].uom__c=='Rack')
           		oBody.body.data.uom=4;
           		if(link[0].free_link__c==false)
           		oBody.body.data.free_link=0;
           		if(link[0].free_link__c==true)
           		oBody.body.data.free_link=1;
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