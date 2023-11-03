public with sharing class REST_Material {
    class Body {
        Header header = new Header();
        DataBody body  = new DataBody();
    } 
    
    class DataBody {
        DataContent data = new DataContent();
    }

    class DataContentMaterial {
        string id;
        string qty;
    } 
    
    class DataContent {
    	List<string> material = new List<string>();
    }
    
    class Header {
        string service='';
        string request_id ='';
        string response_id='';
        string status ='';
    }
    
	public class Material {
		string idMaterial;
		string material;
		string sloc;
		integer available;
		boolean isAvailable;
	}
	
    @future(callout=true) 
    public static void readAvailableMaterialOnOrder (Id orderID) {
		String endpoint = Label.REST_TransDB_GetToken_Endpoint ;
		String username = Label.REST_TransDB_GetToken_Username ;
		String password = appUtils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; 
		string token = apputils.getToken(endpoint, username, password, 1 );
		
		HttpRequest req = new HttpRequest();
		string requestId = '';
		Http http = new Http();
		HTTPResponse res = new HTTPResponse();  
		
		String headerService='availablematerial';   
		string requestMessage='';
		string responseMessage ='';
		
		string callStatus='Success';
		datetime callStartTime;
		string errMessage='';
		boolean isAllMaterialsAvailable = true;
		
		string SLOC='';
		
		if (token <> 'failed') {   
		
			List<orderItem> oiList = [select order.sloc__r.name , PricebookEntry.Product2.Name,  is_Available__c, available__c 
										from orderItem where orderid =:orderID];
			List<string> tmpProductNameList = new List<string>();
			for (OrderItem oi : oiList) {
				tmpProductNameList.add(oi.PricebookEntry.Product2.Name);
				SLOC = oi.order.sloc__r.name;
			}									
			
			
			
			//----- SET BODY DATA
	        Body oBody = new Body();
	        oBody.header.service=headerService;
	        oBody.header.request_id = AppUtils.getNewGUID();
	        
	        DataContent dc = new DataContent();
	        dc.material = tmpProductNameList;
            oBody.body.data = dc;
            
            //requestMessage = '{"header":{"service":"availablematerial","request_id":"657878986879"},"body":{"data":{"material":["SP0K4GPOSTPAID-JKT","SP0KDATALTEOR-JKT"]}}}';
            requestMessage = JSON.serialize(oBody);
            system.debug ('=== requestMessage : ' + requestMessage);
            
			
			req = new HttpRequest();
			//endpoint = 'https://easy-ops.xl.co.id/dev/api//material';
			endpoint = Label.REST_TransDB_Material_Endpoint ; 
			
			req.setEndpoint(endpoint);
			req.setHeader('Accept', 'application/json');
			req.setHeader('Content-Type', 'application/json');
			req.setHeader('Authorization', 'Bearer ' + token );
			req.setMethod('POST');
			req.setTimeout(Integer.ValueOf(label.WS_Callout_Timeout));
			req.setBody(requestMessage);
			
			try {
				callStatus = 'Success';
				callStartTime = datetime.now();
				http = new Http();
				res = http.send(req);  
				responseMessage = res.getBody ();
				System.debug ('================= response message : ' + responseMessage );    
				
				Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseMessage);
				List<Object> objList = (List<Object>) appUtils.getListDataOnMap(results,'body::list');
				
				List<Material> tmpMaterialList = new List<Material>();
				
				for (OrderItem oi : oiList) {
					Material tmpMaterialObj = new Material();
					
					tmpMaterialObj.material = oi.PricebookEntry.Product2.Name;
					tmpMaterialObj.isAvailable = false;
					oi.is_available__c = false;
					
					for (object obj :objList) {
					    Map<String, Object> mapRec = (Map<String, Object>) obj;
					    
						System.debug ('================= result : ' + tmpMaterialObj.idMaterial +' - ' + tmpMaterialObj.material +' - ' + tmpMaterialObj.sloc +' - ' +   tmpMaterialObj.available) ;
						
						string tmpMaterial = (string) mapRec.get('material');
						
						if (tmpMaterialObj.material == tmpMaterial) {
							tmpMaterialObj.idMaterial = (string) mapRec.get('id_material');
							tmpMaterialObj.sloc = (string) mapRec.get('sloc');
							tmpMaterialObj.available =integer.valueof( (string) mapRec.get('available'));
							oi.available__c = integer.valueof((string) mapRec.get('available'));
							
							if(  tmpMaterialObj.sloc == SLOC) {
								if (tmpMaterialObj.available > 0) {				
									tmpMaterialObj.isAvailable = true;					
									oi.is_available__c = true;
									
								} else {
									tmpMaterialObj.isAvailable = false;
									oi.is_available__c = false;
								}
							}
						}
					
					}
					tmpMaterialList.add(tmpMaterialObj);
					
				} //--endFor 
				
				//update Order Item
				update oiList;
				
				
				string errorMessages = '';
				
				for (Material tmpMaterial: tmpMaterialList) {
					if (tmpMaterial.isAvailable == false) {
						isAllMaterialsAvailable = false;
						//errorMessages = errorMessages + tmpMaterial.material + ' is not available. ';
					}
				}
				
				
			
			} catch (Exception e) {
                callStatus = 'Failed';
                errMessage = 'Error on readAvailableMaterialOnOrder method.::' + 
                	e.getTypeName() + ' - ' + e.getCause() + ' - ' + e.getmessage() + ' - ' +  e.getStackTraceString() +
                	'::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
			}
			
			Order orderRec = [select id, status, isReadyToApproval__c from order where id =:orderID];
			if (isAllMaterialsAvailable == false || callStatus =='Failed') {
				//-- update order status to draft
				orderRec.status = 'Draft';
				orderRec.isReadyToApproval__c = false;
			} else if (callStatus =='Success') {
				orderRec.isReadyToApproval__c = true;
			}
			system.debug('===== orderRec : ' + orderRec);
			update orderRec;
			
			
			//-- PUT RESULT to CALLLOG ---
			Call_Log__c calllog = new Call_Log__c();
            calllog.type__c = 'Callout';
            calllog.request_start_time__c = callStartTime;
            calllog.method__c = 'POST';
            calllog.callerFrom__c = 'Salesforce' ; 
            calllog.endpoint__c = endpoint ;
            calllog.status__c = callStatus;
           	calllog.request_message__c = requestMessage;
            calllog.response_message__c = responseMessage;
            calllog.response_end_time__c = datetime.now();     
            calllog.error_message__c = errMessage;
            calllog.Salesforce_ID_1__c = orderID;
            calllog.Order_Related__c = orderID;
            
            insert calllog;
			
		}//-- endOfIFToken
		
    }
}