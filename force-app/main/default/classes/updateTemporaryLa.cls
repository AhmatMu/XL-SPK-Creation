public with sharing class updateTemporaryLa {
      @future(callout=true)
  public static void temporaryLAupdate(String AccountID)
  {
     string endpoint = Label.REST_TransDB_GetToken_Endpoint ;
    string username = Label.REST_TransDB_GetToken_Username ;
    string password = appUtils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; 
    string token = apputils.getToken(endpoint, username, password, 1 );
    if(token!='failed')
    {
    string requestMessage ='';
    string responseMessage = '';
    string callerFrom='';    
    String restresult='';
    Call_Log__c calllog = new Call_Log__c();
    calllog.type__c='Callout';
    calllog.request_start_time__c = datetime.now();
    calllog.method__c = 'POST';
    endPoint = Label.REST_TransDB_CreateLA_Endpoint;
     HTTPResponse res = new HTTPResponse();  
      HTTPRequest req = new HttpRequest();
            String response ='';
    try{
    Account A=[SELECT Parent.BP_Number__c,Account_type__c,sl_id__c,Temporary_LA_or_IDCom__c,No_NPWP__c,NO_SIUP__C,NO_TDP__c,Fax,Akta_Notaris__c,Invoice_Via__c,Phone,SKUB__c,No_Legal__c,Faktur_Pajak__c,Kwitansi__c,summary_invoice__c from Account WHERE ID=:AccountID];
    Body oBody = new Body();
    
    oBody.header.service='updatela';
    obody.body.data.sl_id=A.sl_id__c;
    oBody.header.request_id = AppUtils.getNewGUID(); 
    oBody.body.data.branch_id=A.Parent.BP_Number__c;
    oBody.body.data.sl_telepon=A.Phone;
    oBody.body.data.sl_fax=A.Fax;
    oBody.body.data.sl_siup=A.No_Siup__c;
    oBody.body.data.sl_akta_notaris=A.Akta_notaris__c;
    oBody.body.data.sl_tdp=A.No_tdp__c;
    oBody.body.data.sl_skub=A.SKUB__c;
    oBody.body.data.sl_invoice_via=A.Invoice_via__c;
    oBody.body.data.sl_no_legal=A.No_Legal__c;
    oBody.body.data.sl_summary_invoice='NO';
    if(A.Summary_Invoice__c==true)
    oBody.body.data.sl_summary_invoice='YES';
    oBody.body.data.sl_fraktur_pajak='NO';
    if(A.Faktur_Pajak__c==true)
    oBody.body.data.sl_fraktur_pajak='YES';
    oBody.body.data.sl_kwitansi='NO';
    if(A.Kwitansi__c==true)
    oBody.body.data.sl_kwitansi='YES';
    obody.body.data.sl_la_number=A.Temporary_LA_or_IDCom__c;
    obody.body.data.sl_com=A.Account_type__c;
    
    list<pic> piclist=new list<pic>();
    
    list<AccountContactRelation> LC=[SELECT id,Contact.Email,Contact.mobilephone,Contact.Name,Contact.birthdate FROM AccountContactRelation WHERE AccountID=:AccountID AND Roles INCLUDES ('PIC GSM')];
    for(AccountContactRelation ACR:LC)
    {
        pic singlepic=new pic();
        singlepic.sld_pic=ACR.Contact.Name;
        singlepic.sld_email=ACR.Contact.Email;
        singlepic.sld_contact= ACR.Contact.Mobilephone;
        singlepic.sld_dob= string.valueof(ACR.Contact.birthdate);
        singlepic.sld_no_ktp= null;
        singlepic.sld_alamat= null;
        piclist.add(singlepic);
    }
    oBody.body.data.pic=piclist;
    
    string jsonString = JSON.serialize(oBody);  
          
            calllog.method__c = 'POST';
            
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token );
            req.setMethod('POST');
            req.setBody(jsonString);
                        
            system.debug('================= REQUEST message : ' + jsonstring);
            requestMessage = jsonstring;
            calllog.status__c = 'Success';
             Http http = new Http();
                res = http.send(req);            

                restResult = res.getBody ();
                responseMessage = restResult;
                System.debug ('================= response message : ' + restResult);
                
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped( restResult );
                System.debug ('================= responsemap : ' + responsemap);
              
                // put callout information
                String status = Apputils.getStringDataOnMap(responsemap, 'headers::status');
                if (! apputils.isKeysetNotFound(status) ) {
                    calllog.status__c = status;
                } else {
                    calllog.status__c = 'Failed';
                }
    }
    catch(exception e)
    {
          calllog.status__c = 'Failed';
         string errMessage = 'Error on CreateLA method.::' + e.getmessage() + '::' + e.getLineNumber() ;
           system.debug('==================== error message : ' + errMessage);
          AppUtils.putError(errMessage );
    }
    
     calllog.request_message__c = requestMessage; //jsonString;
    calllog.response_message__c = responseMessage; //restResult;
  
    calllog.callerFrom__c = 'Salesforce' ; 
    calllog.endpoint__c = endpoint ; 
    calllog.response_end_time__c = datetime.now();            
    insert calllog;
    }
  }
    
    @future(callout=true)
  public static void updatetemporaryLA(String AccountID)
  {
     string endpoint = Label.REST_TransDB_GetToken_Endpoint ;
    string username = Label.REST_TransDB_GetToken_Username ;
    string password = appUtils.doDecrypt(Label.REST_TransDB_GetToken_Password) ; 
    string token = apputils.getToken(endpoint, username, password, 1 );

    string requestMessage ='';
    string responseMessage = '';
    string callerFrom='';    
    String restresult='';
    Call_Log__c calllog = new Call_Log__c();
    calllog.type__c='Callout';
    calllog.request_start_time__c = datetime.now();
    calllog.method__c = 'POST';
    endPoint = Label.REST_TransDB_CreateLA_Endpoint;
     HTTPResponse res = new HTTPResponse();  
      HTTPRequest req = new HttpRequest();
            String response ='';
    try{
    Account A=[SELECT Parent.BP_Number__c,Account_type__c,sl_id__c,Temporary_LA_or_IDCom__c,No_NPWP__c,NO_SIUP__C,NO_TDP__c,Fax,Akta_Notaris__c,Invoice_Via__c,Phone,SKUB__c,No_Legal__c,Faktur_Pajak__c,Kwitansi__c,summary_invoice__c from Account WHERE ID=:AccountID];
    Body oBody = new Body();
    
    oBody.header.service='createla';
    oBody.header.request_id = AppUtils.getNewGUID(); 
    oBody.body.data.branch_id=A.Parent.BP_Number__c;
    oBody.body.data.sl_telepon=A.Phone;
    oBody.body.data.sl_fax=A.Fax;
    oBody.body.data.sl_siup=A.No_Siup__c;
    oBody.body.data.sl_akta_notaris=A.Akta_notaris__c;
    oBody.body.data.sl_tdp=A.No_tdp__c;
    oBody.body.data.sl_skub=A.SKUB__c;
    oBody.body.data.sl_invoice_via=A.Invoice_via__c;
    oBody.body.data.sl_no_legal=A.No_Legal__c;
    oBody.body.data.sl_summary_invoice='NO';
    if(A.Summary_Invoice__c==true)
    oBody.body.data.sl_summary_invoice='YES';
    oBody.body.data.sl_fraktur_pajak='NO';
    if(A.Faktur_Pajak__c==true)
    oBody.body.data.sl_fraktur_pajak='YES';
    oBody.body.data.sl_kwitansi='NO';
    if(A.Kwitansi__c==true)
    oBody.body.data.sl_kwitansi='YES';
    obody.body.data.sl_la_number=A.Temporary_LA_or_IDCom__c;
    obody.body.data.sl_com=A.Account_type__c;
    
    list<pic> piclist=new list<pic>();
    
    list<AccountContactRelation> LC=[SELECT id,Contact.Email,Contact.mobilephone,Contact.Name,Contact.birthdate FROM AccountContactRelation WHERE AccountID=:AccountID AND Roles INCLUDES ('PIC GSM')];
    for(AccountContactRelation ACR:LC)
    {
        pic singlepic=new pic();
        singlepic.sld_pic=ACR.Contact.Name;
        singlepic.sld_email=ACR.Contact.Email;
        singlepic.sld_contact= ACR.Contact.Mobilephone;
        singlepic.sld_dob= string.valueof(ACR.Contact.birthdate);
        singlepic.sld_no_ktp= null;
        singlepic.sld_alamat= null;
        piclist.add(singlepic);
    }
    oBody.body.data.pic=piclist;
    
    string jsonString = JSON.serialize(oBody);  
          
            calllog.method__c = 'POST';
            
            req.setEndpoint(endpoint);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token );
            req.setMethod('POST');
            req.setBody(jsonString);
                        
            system.debug('================= REQUEST message : ' + jsonstring);
            requestMessage = jsonstring;
            calllog.status__c = 'Success';
             Http http = new Http();
                res = http.send(req);            

                restResult = res.getBody ();
                responseMessage = restResult;
                System.debug ('================= response message : ' + restResult);
                
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped( restResult );
                System.debug ('================= responsemap : ' + responsemap);
                A.sl_id__c=Apputils.getStringDataOnMap(responsemap, 'body::data::sl_id');
                update A;
                // put callout information
                String status = Apputils.getStringDataOnMap(responsemap, 'headers::status');
                if (! apputils.isKeysetNotFound(status) ) {
                    calllog.status__c = status;
                } else {
                    calllog.status__c = 'Failed';
                }
    }
    catch(exception e)
    {
          calllog.status__c = 'Failed';
         string errMessage = 'Error on CreateLA method.::' + e.getmessage() + '::' + e.getLineNumber() ;
           system.debug('==================== error message : ' + errMessage);
          AppUtils.putError(errMessage );
    }
     calllog.request_message__c = requestMessage; //jsonString;
    calllog.response_message__c = responseMessage; //restResult;
  
    calllog.callerFrom__c = 'Salesforce' ; 
    calllog.endpoint__c = endpoint ; 
    calllog.response_end_time__c = datetime.now();            
    insert calllog;
    
  }
 
  class Header {
        string service='';
        string request_id ='';
    }
      class Body {
        Header header = new Header();
        DataBody body  = new DataBody();
    } 
    
    class DataBody {
        DataContent data = new DataContent();
    }
    class DataContent {
        //String sa_ticket_number;
        String sl_id;
        String branch_id;
        String sl_telepon;
       String sl_fax;
       String sl_siup;
       String sl_akta_notaris;
       String sl_tdp;
       String sl_skub;
       String sl_com;
       String sl_invoice_via;
       String sl_summary_invoice;
       String sl_fraktur_pajak;
       String sl_kwitansi;
       String sl_la_number;
       String sl_no_legal;
       list<pic> pic;
    }
    
    class pic
    {
        String sld_pic;
        String sld_email;
        String sld_contact;
        String sld_dob;
        String sld_no_ktp;
        String sld_alamat;
    }
    
}