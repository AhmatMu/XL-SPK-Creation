global class Schedule_Notification_Contract_Extension implements Schedulable{
	global void execute(SchedulableContext sc){
		list<Contract> listContract=new list<Contract>();
		if(test.isrunningtest())
		listContract=[SELECT id,Link__c,extension_created__c,Link__r.Link_id__c,Accountid,Price__c,Start_Date__C,End_Date__C,Account.Name,Account.Segmentation__c,Contract_ID__c,SAP_ID__c,Product__c,Product__r.SAP_Code__c,Sales__c,Account.Owner.Email,Account.Ownerid,Status from Contract  ORDER BY SALES__C LIMIT 4];
		else
		listcontract=[SELECT id,Link__c,extension_created__c,Link__r.Link_id__c,Accountid,Price__c,Start_Date__C,End_Date__C,Account.Name,Account.Segmentation__c,Contract_ID__c,SAP_ID__c,Product__c,Product__r.SAP_Code__c,Sales__c,Account.Owner.Email,Account.Ownerid,Status from Contract WHERE (Product_Charge_Type_filled__c='Recurring' OR Product_Charge_Type__c='Recurring') AND Auto_Renewal__c = false AND Extension_Created__c=false AND Active__c=true AND End_Date__c>=:system.today() AND End_Date__c<=:system.today().adddays(90) ORDER BY SALES__C LIMIT 20];
    	Integer ChangeUser=1;
    	list<Contract_Extension__c> CEXT=new list<Contract_Extension__c>();
    	list<User> Ulist=[SELECT id,email FROM User WHERE Name='Contract Manager' OR Name='Sales Admin'];
    	list<String>AddressList=new String[]{Ulist[0].Email,Ulist[1].Email,'kahfif@xl.co.id'};
    //	list<Link__c> listlinkpartner=new list<Link__c>();
    	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    	String MessageBody='';
    	for(Integer lcount=0;lcount<listCOntract.size();lcount++)
    	{
    	IntegrationLinkPartner(listContract[lcount].link__c,listContract[lcount].link__r.Link_id__c);
    	}
    	for(Integer i=0;i<listContract.size();i++)
    	{
    		
    	
    		
    		if(changeuser==1)
    		{
    		
    		if(addresslist.size()>2)
    			addresslist.remove(2);
			Addresslist.add(listContract[i].account.owner.email);
			//message.toAddresses = new String[] {};
			
			message.toAddresses=addresslist;
			message.optOutPolicy = 'FILTER';
			message.subject = 'Contract Extensions';
    		
			messageBody = '<html><body>Dear '+listContract[i].Sales__c+' <br><br>Terlampir Contract Item yang perlu diproses extensionnya <br><br>';
			messagebody=messagebody+'<table border="1"><tr><td>Contract Number</td><td>Company Name</td><td>Product Code</td><td>Link ID</td><td>Segment</td><td>Start Date</td><td>End Date</td><td>Price IDR/Month</td></tr>';
    		}
    		
    		Changeuser=0;
    		 
    		
    		if(changeuser==0)
    		{
    			messagebody=messagebody+'<tr><td>'+listContract[i].contract_id__c+'-'+listContract[i].SAP_ID__c+'</td><td>'+listContract[i].Account.Name+'</td><td>'+listContract[i].Product__r.SAP_Code__c+'</td><td>'+listContract[i].Link__r.Link_id__c+'</td><td>'+listContract[i].Account.Segmentation__c+'</td><td>'+listContract[i].Start_Date__c+'</td><td>'+listContract[i].End_Date__c+'</td><td>'+listContract[i].Price__c+'</td></tr>';
    			Contract_Extension__c ext=new Contract_Extension__c();
    			ext.Name='BA Extension '+listContract[i].Account.Name+'  '+listContract[i].Link__r.Link_id__c;
    			ext.Status__c='Fill BA Recipient and BA Print';
    			ext.Account__c=listContract[i].Accountid;
    			ext.Account_Manager__c=listContract[i].Account.Ownerid;
    			ext.Link__c=listContract[i].Link__c;
    			ext.Existing_Contract_item__c=listContract[i].id;
    		//	Link__c LP=[SELECT Partner__c FROM Link__c WHERE ID=:listContract[i].Link__c];
    		//	ext.link_partner__c=LP.Partner__c;
    			CEXT.add(ext);
    		}
    		if(listcontract.size()==i+1)
    		{
    			Changeuser=1;
    		} 
    		else if(listContract[i+1].sales__c!=listContract[i].sales__c||i==listContract.size()-1)
    		{
    			changeuser=1;
    		}
    		
    		if(changeuser==1)
    		{
			messagebody=messagebody+'</table><br>Best Regards<br></body>  </html>';
			message.setHtmlBody(messageBody); 
			Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
			
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    		}
    	listContract[i].status='Active';
    	listContract[i].extension_created__c=true;
    	}
    	if(!test.isrunningtest())
    	{
    	insert CEXT;
    	update listContract;
    	}
    	
		}
		
		 @future(callout=true)
		public static void IntegrationLinkPartner(string linksfid, string link_id)
		{
			 String endpoint = system.label.REST_TransDB_GetToken_Endpoint;
        String body = 'username='+system.label.REST_TransDB_GetToken_Username+'&password='+system.label.REST_TransDB_GetToken_Password;
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setbody(body);
        req.setHeader('Accept', 'application/json');
        Http http = new Http();
        HTTPResponse response=new HTTPResponse();
        Map<String,Object> responsemap=new Map<String,Object> ();
        string token='';
        if(!test.isRunningTest())
        {
        response = http.send(req);
        responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
        token=(string) responsemap.get('token');
        }
        
         
                   
        // POST request
        endpoint = system.label.REST_LinkPartner;
        req.setEndpoint(endpoint);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token );
        body='[{"linkid":"'+link_id+'"}]';
        
        
        req.setbody(body);
        String restresult='';
        if(!test.isrunningtest())
        {
        response = http.send(req);
        restResult = response.getBody();
        }
        Link__c L=new Link__c();
        L.id=linksfid;
        L.Link_id__c=Link_id;
        if(restresult!='[]' && !test.isrunningtest())
        {
        list<Object> RRlist=(list<Object>)JSON.deserializeUntyped(restResult);
        String WithPartner='';
       
        	responsemap=(Map<String,Object>)RRList[0];
        	WithPartner=(String)responsemap.get('with_partner');
        
        if(WithPartner=='true')
        	L.Partner__c=true;
        	if(WithPartner=='false')
        	L.Partner__c=false;
        update L;
       
        }
       
     //  system.debug(restResult);
	
		
		}
		Class returnRest
		{
			String linkid;
			String with_partner;
			String status;
			String message;
		}
		
		
}