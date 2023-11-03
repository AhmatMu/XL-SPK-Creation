/**
 * @description       : 
 * @Test Class        : REST_MarketPlaceOrder_Callin_v3Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 08-31-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   08-31-2023   Novando Utoyo Agmawan   Initial Version
**/

@RestResource(urlMapping='/v3/marketplaceorders/*') 
//-- /services/apexrest/v3/marketplaceorders/
global with sharing class REST_MarketPlaceOrder_Callin_v3 {
    
    /*global REST_MarketPlaceOrder_Callin_v3() {

    }*/

    @HttpPost
    global static Response createOrder(){
        Response response = new Response();
        RespData data = new RespData();
        ErrorMsg err = new ErrorMsg ();

        Datetime startDate = System.now();
        String responseStr = '';
        

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string callerFrom = req.remoteAddress;

        system.debug('body string length : '+req.requestBody.size());
        if(req.requestBody.size()>6000000){
            err.err_no = 204;
            err.err_message = 'Insert process is failed. String length of body exceeds limit 6000000 characters.';

            response.status = 'failed';      
            response.error_message = err;
            
            responseStr = JSON.serialize(response);
            insertCallLog('POST', '', responseStr, 'Failed', err.err_message, startDate, callerFrom, null);
            
            return response;        
        }
        
        String postBody = req.requestBody.toString(); 
        //String postBody = EncodingUtil.base64Encode(req.requestBody);
        //String postBody = blobToString( req.requestBody, Label.CallInCharSet );    // Label.CallInCharSet = 'ISO-8859-1'        
        System.debug('>>> createOrder');
        System.debug('>>> postBody : '+postBody);
        String simplePostBody = simplifyPostBody(postBody, 'cof_file');
        
        try {
            Order order = (Order)JSON.deserialize(postBody, Order.class);
            
            data.type = order.type;
            data.service = order.service;
            data.order_id = order.order_id;
            
            String filename = order.file_name;
            
            response.call_id = order.call_id;
            response.data = data;
    
            String customerEmail = order.customer_email;
            String customerName = order.customer_name;
            

            if (order.provisioning_type == null || order.provisioning_type == '') {
                err.err_no = 204;
                err.err_message = 'Insert process is failed. There is no "Provisioning Type" parameter in Request Message';
    
                response.status = 'failed';      
                response.error_message = err;
                
                responseStr = JSON.serialize(response);
                insertCallLog('POST', simplePostBody, responseStr, 'Failed', err.err_message, startDate, callerFrom, null);
                
                return response;

            }


            List<Account> accountList = [Select Id,OwnerID From Account Where BP_Number__c = :order.bp_number limit 1];
            Account acc = null;
            String accountId = null;
            String OwnerId = null;
            Contact con = null;
            
            If(accountList.size()>0){
                acc = accountList[0];
                accountId = acc.Id;
                ownerId = acc.OwnerID;
            }else{
                //acc = new Account(Name=customerName);
                //insert acc;
                //accountId = acc.Id;
                
                //con = new Contact(AccountId=accountId, LastName=customerName, Email=customerEmail);
                //insert con;
                err.err_no = 204;
                err.err_message = 'Insert process is failed. No account '+order.bp_number+' found in the system.';
    
                response.status = 'failed';      
                response.error_message = err;
                
                responseStr = JSON.serialize(response);
                insertCallLog('POST', simplePostBody, responseStr, 'Failed', err.err_message, startDate, callerFrom, null);
                
                return response;
            }
            
            if(customerName!=null && customerEmail!=null){
                //and LastName=:customerName
                List<Contact> contactList = [Select Id From Contact Where AccountId=:accountId and Email=:customerEmail limit 1];
                if(contactList.size()==0){
                    err.err_no = 204;
                    err.err_message = 'Insert process is failed. No contact has Name '+customerName+' and Email '+customerEmail+' found in the system.';
        
                    response.status = 'failed';      
                    response.error_message = err;
                    
                    responseStr = JSON.serialize(response);
                    insertCallLog('POST', simplePostBody, responseStr, 'Failed', err.err_message, startDate, callerFrom, null);
    
                    return response;
                }
            }          

            if(((order.mime_type!=null && order.mime_type!='') && (order.cof_file==null || order.cof_file=='') && (order.file_name==null || order.file_name=='')) || 
                ((order.mime_type==null || order.mime_type=='') && (order.cof_file!=null && order.cof_file!='') && (order.file_name==null || order.file_name=='')) || 
                ((order.mime_type==null || order.mime_type=='') && (order.cof_file==null && order.cof_file=='') && (order.file_name!=null || order.file_name!='')) ||                               
                ((order.mime_type!=null && order.mime_type!='') && (order.cof_file!=null && order.cof_file!='') && (order.file_name==null || order.file_name=='')) || 
                ((order.mime_type==null || order.mime_type=='') && (order.cof_file!=null && order.cof_file!='') && (order.file_name!=null && order.file_name!='')) || 
                ((order.mime_type!=null && order.mime_type!='') && (order.cof_file==null || order.cof_file=='') && (order.file_name!=null && order.file_name!='')) ){
                
                err.err_no = 204;
                err.err_message = 'Insert process is failed due to either file_name, mime_type or cof_file are empty.';
    
                response.status = 'failed';      
                response.error_message = err;
                
                responseStr = JSON.serialize(response);
                insertCallLog('POST', simplePostBody, responseStr, 'Failed', err.err_message, startDate, callerFrom, null);

                return response;
            }              
                    
            String orderDate = order.order_date;
            String dd = orderDate.substring(6,8);
            String mm = orderDate.substring(4,6);
            String yyyy = orderDate.substring(0,4);
            system.debug('>>> order.order_date : '+order.order_date);
    
            //List<PriceBook2> pbList = [select id from PriceBook2 Where Name = 'Marketplace'];
            PriceBook2 pb = null;
            String priceBookId = null;
            /*
            if(pbList.size()>0){
                pb = pbList[0]; 
            }
            */
            
            Map<String,String> pbeMap = new Map<String,String>();
            List<PriceBookEntry> pbeList = [SELECT Id,Name,Pricebook2Id,Pricebook2.Name,Product2Id,ProductCode,Product2.Product_Unique_ID__c FROM PricebookEntry Where Pricebook2.Name = 'Marketplace' and Product2.Product_Unique_ID__c != null];
            if(pbeList.size()==0){
                err.err_no = 204;
                err.err_message = 'Insert process is failed. No product has been configured in the system.';
    
                response.status = 'failed';      
                response.error_message = err;
    
                responseStr = JSON.serialize(response);
                insertCallLog('POST', simplePostBody, responseStr, 'Failed', err.err_message, startDate, callerFrom, null);
    
                return response;
            }else{
                for(PriceBookEntry pbe : pbeList ){
                    priceBookId = pbe.Pricebook2Id;
                    pbeMap.put(pbe.Product2.Product_Unique_ID__c, pbe.Product2Id);
                }
            }
            
            // TODO : lakukan validasi cek opportunity-product terlebih dahulu
            // Jika ada product yang tidak ada maka tidak perlu create Opportunity. 


            //-- Handling for any product not found is system.
            List<Item> itemList = order.product_items;
            Integer itemSize = itemList.size();
            String notFoundProducts = '';
            String productId = null;
            for(Item it : itemList){
                productId = (String) pbeMap.get(it.product_id);
                if(productId==null){
                    notFoundProducts = notFoundProducts + it.product_id + ',' ;
                }
            }
            
            if(notFoundProducts!=''){
                err.err_no = 204;
                err.err_message = 'Insert process is failed. Products : '+notFoundProducts+' not found in the system.';
    
                response.status = 'failed';      
                response.error_message = err; 

                responseStr = JSON.serialize(response);
                insertCallLog('POST', simplePostBody, responseStr, 'Failed', err.err_message, startDate, callerFrom, null);

                return response;                    
            }

            Id RecordTypeOppty_Licensed_Id = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Licensed').getRecordTypeId();

            Opportunity oppty = new Opportunity(AccountId=accountId, 
                                                Name=order.order_name, 
                                                //StageName='Closed Won',

                                                provisioning_type__c = order.provisioning_type,
                                                StageName=Label.CallInCreateOrderStatus, //'Prospecting',
                                                Type=order.type,
                                                Service_type__c='Licensed', 
                                                Call_Id__c=order.call_id, 
                                                Service__c=order.service,
                                                Order_Id__c=order.order_id,
                                                CloseDate=date.newInstance(Integer.valueOf(yyyy), Integer.valueOf(mm), Integer.valueOf(dd)+7),
                                                BP_Number__c=order.bp_number,
                                                //Pricebook2Id=pb.Id,
                                                Pricebook2Id=priceBookId,
                                                //recordtypeid=system.label.RT_Marketplace,
                                                recordtypeid=RecordTypeOppty_Licensed_Id,
                                                OwnerId = ownerId,
                                                Contract_Periode__c=12,
                                                Periode_Uom__c='Month',
                                                Auto_renewal__c=true
                                                );
            insert oppty;                                            
                    
            
            if(itemSize>0){
                List<OpportunityLineItem> prodItemList = new List<OpportunityLineItem>();
                OpportunityLineItem prodItem = null;
                List<String> productCodeList = new List<String>();
                
                for(Item it : itemList){
                    productId = (String) pbeMap.get(it.product_id);
                    prodItem = new OpportunityLineItem(OpportunityId=oppty.Id, Quantity=Double.valueOf(it.quantity), UnitPrice=Double.valueOf(it.sales_price), Description=it.notes, Product2Id=productId); 
                    prodItemList.add(prodItem);
                }
                
                insert prodItemList; 
                oppty.stagename='Survey';
                update oppty;           
            }
        
            String extension = null;
            system.debug('>>> mime_type : '+order.mime_type);
            system.debug('>>> file_name: '+order.file_name);
            system.debug('>>> cof_file: '+order.cof_file);
            if((order.mime_type!=null && order.mime_type!='') && (order.cof_file!=null && order.cof_file!='') && (filename!=null && filename!='')){
                
                /* */
                if('application/pdf' == order.mime_type){
                    extension = 'pdf';
                }else if('video/x-msvideo' == order.mime_type){
                    extension = 'avi';
                }else if('image/bmp' == order.mime_type){
                    extension = 'bmp';
                }else if('text/csv' == order.mime_type){
                    extension = 'csv';
                }else if('image/gif' == order.mime_type){
                    extension = 'gif';
                }else if('image/jpeg' == order.mime_type){
                    extension = 'jpg';
                }else if('image/x-citrix-jpeg' == order.mime_type){
                    extension = 'jpg';
                }else if('application/msword' == order.mime_type){
                    extension = 'doc';
                }else if('application/vnd.ms-powerpoint' == order.mime_type){
                    extension = 'ppt';
                }else if('audio/midi' == order.mime_type){
                    extension = 'mid';
                }else if('application/vnd.openxmlformats-officedocument.wordprocessingml.document' == order.mime_type){
                    extension = 'docx';
                }else if('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' == order.mime_type){
                    extension = 'xlsx';
                }else if('application/vnd.openxmlformats-officedocument.presentationml.presentation' == order.mime_type){
                    extension = 'pptx';
                }
                /* */
                //order.mime_type = getCorrectMimeType(filename, order.mime_type);
                
                blob fileContent = EncodingUtil.base64Decode(order.cof_file.replace('b\'', '').replace('\\n', '').replace('\'', ''));

                //Attachment att = new Attachment(parentId=oppty.Id, Name='cof_'+order.order_id+'.'+extension, Body=fileContent, ContentType=order.mime_type);
                Attachment att = new Attachment(parentId=oppty.Id, Name=filename+'.'+extension, Body=fileContent, ContentType=order.mime_type);
                //Attachment att = new Attachment(parentId=oppty.Id, Name=filename, Body=fileContent, ContentType=order.mime_type);
                
                insert att;
            }else{
            
            }
                    
            
            //RespData data = new RespData();
            //data.type = order.type;
            //data.service = order.service;
            //data.order_id = order.order_id;
            data.opportunity_id = oppty.Id;
            
            //Response response = new Response();
            //response.call_id = order.call_id;
            response.status = 'success';      
            response.data = data;
            response.error_message = null;
            
            //system.debug('>>> before insert callLog ');    
            responseStr = JSON.serialize(response);
            insertCallLog('POST', simplePostBody, responseStr, 'Success', null, startDate, callerFrom, oppty.id);
            //system.debug('>>> after insert callLog ');    
    
            return response;                
            
        } catch (Exception e){
            response.status = 'failed';    
            data.opportunity_id = null;  
            response.data = data;
            
            ErrorMsg errMsg = new ErrorMsg();
            errMsg.err_no = 403;
            errMsg.err_message = 'The request has been refused.'+e.getMessage();
            response.error_message = errMsg;

            System.debug('>>> errMsg: '+e.getMessage());
            
            responseStr = JSON.serialize(response);
            insertCallLog('POST', simplePostBody, responseStr, 'Failed', e.getMessage(), startDate, callerFrom, null);
        
            return response;                
        } 
            
    }

    /**
     *  THIS METHOD FOR UPDATING THE ORDER STATUS 
     *  
     */

    @HttpPut
    global static ResponseUpdate updateStatus(){
        ResponseUpdate response = new ResponseUpdate();
        RespDataUpdate data = new RespDataUpdate();
        ErrorMsg errMsg = new ErrorMsg ();

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;

        Datetime startDate = System.now();
        String responseStr = '';
        string callerFrom = req.remoteAddress;

        String postBody = req.requestBody.toString(); 
        //String postBody = EncodingUtil.base64Encode(req.requestBody);
        //String postBody = blobToString( req.requestBody, Label.CallInCharSet );    // Label.CallInCharSet = 'ISO-8859-1'        
        
        System.debug('>>> updateStatus');
        System.debug('>>> postBody : '+postBody);

        system.debug('body string length : '+req.requestBody.size());
        if(req.requestBody.size()>6000000){
            errMsg.err_no = 204;
            errMsg.err_message = 'Update process is failed. String length of body exceeds limit 6000000 characters.';

            response.status = 'failed';      
            response.error_message = errMsg;
            
            responseStr = JSON.serialize(response);
            insertCallLog('POST', '', responseStr, 'Failed', errMsg.err_message, startDate, callerFrom, null);
            
            return response;        
        }
        
        
        
        String simplePostBody = simplifyPostBody(postBody, 'agreement_file');
        Opportunity oppty = null;
        try {   
            OrderUpdate order = (OrderUpdate)JSON.deserialize(postBody, OrderUpdate.class);
    
            data.type = order.type;
            data.service = order.service;
            data.order_id = order.order_id;
            data.order_status = order.order_status;

            String filename = order.file_name;
            
            if(((order.mime_type!=null && order.mime_type!='') && (order.agreement_file==null || order.agreement_file=='') && (order.file_name==null || order.file_name=='')) || 
                ((order.mime_type==null || order.mime_type=='') && (order.agreement_file!=null && order.agreement_file!='') && (order.file_name==null || order.file_name=='')) || 
                ((order.mime_type==null || order.mime_type=='') && (order.agreement_file==null && order.agreement_file=='') && (order.file_name!=null || order.file_name!='')) ||                           
                ((order.mime_type!=null && order.mime_type!='') && (order.agreement_file!=null && order.agreement_file!='') && (order.file_name==null || order.file_name=='')) || 
                ((order.mime_type==null || order.mime_type=='') && (order.agreement_file!=null && order.agreement_file!='') && (order.file_name!=null && order.file_name!='')) || 
                ((order.mime_type!=null && order.mime_type!='') && (order.agreement_file==null || order.agreement_file=='') && (order.file_name!=null && order.file_name!='')) ){
                
                errMsg.err_no = 204;
                errMsg.err_message = 'Update process is failed due to either file_name, mime_type or agreement_file are empty.';
    
                response.status = 'failed';      
                response.error_message = errMsg;
                
                responseStr = JSON.serialize(response);
                insertCallLog('POST', simplePostBody, responseStr, 'Failed', errMsg.err_message, startDate, callerFrom, null);

                return response;
            }              
            
            
            List<Opportunity> opptyList = [Select Id, Call_Id__c, Type, Service__c, Order_Id__c, StageName, provisioning_type__c, Probability From Opportunity Where Id=:order.opportunity_id]; 
            
            if(opptyList.size()>0){
                oppty = opptyList[0];
                
                //String stageName = order.order_status;
                //if(Label.CallInAllowedUpdateOrderStatus.indexOf(stageName)>=0){
                //    stageName = Label.CallInUpdateOrderStatus;
                //}
                
                
                
                // ------------ ATTACHMENT CHEKCING First -------------
                
                String extension = null;
                system.debug('>>> mime_type : '+order.mime_type);
                system.debug('>>> file_name: '+order.file_name);
                system.debug('>>> agreement_file: '+order.agreement_file);
                if((order.mime_type!=null && order.mime_type!='') && (order.agreement_file!=null && order.agreement_file!='') 
                        && (order.file_name!=null && order.file_name!='')) {
                    
                    /* */
                    if('application/pdf' == order.mime_type){
                        extension = 'pdf';
                    }else if('video/x-msvideo' == order.mime_type){
                        extension = 'avi';
                    }else if('image/bmp' == order.mime_type){
                        extension = 'bmp';
                    }else if('text/csv' == order.mime_type){
                        extension = 'csv';
                    }else if('image/gif' == order.mime_type){
                        extension = 'gif';
                    }else if('image/jpeg' == order.mime_type){
                        extension = 'jpg';
                    }else if('image/x-citrix-jpeg' == order.mime_type){
                        extension = 'jpg';
                    }else if('application/msword' == order.mime_type){
                        extension = 'doc';
                    }else if('application/vnd.ms-powerpoint' == order.mime_type){
                        extension = 'ppt';
                    }else if('audio/midi' == order.mime_type){
                        extension = 'mid';
                    }else if('application/vnd.openxmlformats-officedocument.wordprocessingml.document' == order.mime_type){
                        extension = 'docx';
                    }else if('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' == order.mime_type){
                        extension = 'xlsx';
                    }else if('application/vnd.openxmlformats-officedocument.presentationml.presentation' == order.mime_type){
                        extension = 'pptx';
                    }
                    /*    */
                    //order.mime_type = getCorrectMimeType(filename, order.mime_type);
                    
                    blob fileContent = EncodingUtil.base64Decode(order.agreement_file.replace('b\'', '').replace('\\n', '').replace('\'', ''));

                    //Attachment att = new Attachment(parentId=oppty.Id, Name='agreement_'+order.order_id+'.'+extension, Body=fileContent, ContentType=order.mime_type);
                    Attachment att = new Attachment(parentId=oppty.Id, Name=filename+'.'+extension, Body=fileContent, ContentType=order.mime_type);
                    //Attachment att = new Attachment(parentId=oppty.Id, Name=filename, Body=fileContent, ContentType=order.mime_type);
                    insert att;
                    
                }  // ------------------ end of ATTACHMENT CHECKING


                // ----------------  Update OPPORTUNITY or SR/PR ---------------------------------
                oppty.Call_Id__c = order.call_id;
                oppty.Type = order.type;
                oppty.Service__c = order.service;
                oppty.Order_Id__c = order.order_id;
                

                //-- STATUS PARAM : WBA  ------
                if (order.order_status == 'success' && oppty.provisioning_type__c == 'auto') {
                    //-- SET PR status to 'Waiting for BA'
                    List<SR_PR_Notification__c> SRPRNotifList = [select id, status__c from SR_PR_Notification__c where Opportunity__c=:oppty.id AND Notif_type__c='PR' order by createddate desc limit 1]  ;
                    if (SRPRNotifList.size()>0) {
                        SRPRNotifList[0].status__c = 'Waiting Berita Acara';
                        SRPRNotifList[0].Billing_Start_Date__c = system.today();
                        SRPRNotifList[0].Project_Complete_Date__c = system.today();
                        SRPRNotifList[0].BA_Sent_Date__c = system.today();

                        update SRPRNotifList;
                    }
                    update oppty;

                }

                if (order.order_status == 'ba-approved' && oppty.provisioning_type__c == 'auto') {
                    // --  update opportunity stage related to mapping and set ba receive date
                    String stageName = translateStatus(order.order_status);
                    oppty.StageName = stageName; 
                    update oppty;

                    List<SR_PR_Notification__c> SRPRNotifList = [select id, status__c from SR_PR_Notification__c where Opportunity__c=:oppty.id AND Notif_type__c='PR' order by createddate desc limit 1]  ;
                    if (SRPRNotifList.size()>0) {
                        SRPRNotifList[0].BA_Receive_Date__c = system.today();
                        update SRPRNotifList;
                    }

                }
                

                //-- STATUS PARAM : FAILED  ------
                else if (order.order_status == 'Failed' && oppty.provisioning_type__c == 'auto') {
                    //-- SET PR status to 'CANCEL'
                    List<SR_PR_Notification__c> SRPRNotifList = [select id, status__c from SR_PR_Notification__c where Opportunity__c=:oppty.id AND Notif_type__c='PR' order by createddate desc limit 1]  ;
                    if (SRPRNotifList.size()>0) {
                        SRPRNotifList[0].status__c = 'Cancel';
                        SRPRNotifList[0].Reasons__c = 'Provisioning Failed';

                        SYSTEM.DEBUG ('===========  SRPRNotifList : ' + SRPRNotifList);
                        update SRPRNotifList;
                    }

                    SYSTEM.DEBUG ('===========  oppty : ' + oppty);
                    //update oppty;
                }

                //-- STATUS PARAM : CANCELLED ORDER  ------
                else if (order.order_status == 'Cancelled Order' ) {
                    if (oppty.Probability < 50 ) {
                        //-- Before stage IMPLEMENTATION
                        
                        // TODO: TEST THIS functioonality
                        //Class used for Approving Record
                        Approval.ProcessWorkitemRequest PWIReq = new Approval.ProcessWorkitemRequest();
                        PWIReq.setComments('Approving request for Opportunity');
                        
                        //Approve or Reject Record
                        PWIReq.setAction('Reject');
                        
                        //Getting Work Item Id
                        ProcessInstanceWorkitem pItem = [Select Id from ProcessInstanceWorkitem 
                                                            where ProcessInstance.TargetObjectId =: oppty.id];
                        if (pItem <> null) {
                        PWIReq.setWorkitemId(pItem.Id);
                        // Submit the request for approval
                        Approval.ProcessResult result = Approval.process(PWIReq);
                        }
                        // -----------------------------------------------------------------------------------------
                        
                        oppty.stageName = 'Closed Lost';
                        oppty.Loss_Reason__c = 'Customer Cancel Order';
                        oppty.Loss_Reason_Description__c = 'Customer Cancel Order from BizStore';
                        update oppty;


                    }

                    else if (oppty.Probability >= 50 ) {
                        //-- AFTER stage IMPLEMENTATION
                        update oppty;

                        errMsg.err_no = 204;
                        errMsg.err_message = 'The Order (Salesforce Opportunity) can not be Cancelled. The Stage Name now in ' + oppty.stageName  + '.';

                        response.status = 'failed';      
                        response.error_message = errMsg;

                        responseStr = JSON.serialize(response);
                        insertCallLog('PUT', simplePostBody, responseStr, 'Failed', errMsg.err_message, startDate, callerFrom, oppty.id);
                    
                        return response;
                        
                    }                    
                }

                else {
                    // -- just update opportunity stage related to mapping
                    String stageName = translateStatus(order.order_status);
                    oppty.StageName = stageName; 
                    update oppty;
                }


            } else {
                //no opportunity found
                errMsg = new ErrorMsg();
                errMsg.err_no = 204;
                errMsg.err_message = 'Update process is failed. No opportunity found for ID : '+order.opportunity_id;
    
                response.status = 'failed';      
                response.error_message = errMsg;

                responseStr = JSON.serialize(response);
                insertCallLog('PUT', simplePostBody, responseStr, 'Failed', errMsg.err_message, startDate, callerFrom, null);
            
                return response;                
            }
            
            
            response.call_id = order.call_id;
            response.status = 'success';      
            response.data = data;
            response.error_message = null;
    
            responseStr = JSON.serialize(response);
            insertCallLog('PUT', simplePostBody, responseStr, 'Success', null, startDate, callerFrom, oppty.id);
            
            return response;
                            
        } catch (Exception e){
            
            response.status = 'failed';      
            response.data = data;

            errMsg = new ErrorMsg();
            errMsg.err_no = 403;
            errMsg.err_message = 'The request has been refused. '+e.getMessage();
            response.error_message = errMsg;

            System.debug('>>> errMsg : '+e.getMessage());

            responseStr = JSON.serialize(response);
            insertCallLog('PUT', simplePostBody, responseStr, 'Failed', errMsg.err_message, startDate, callerFrom, null);
            
            string errMessage = 'Error on PUT method.::' + 'record id : ' +  oppty.id + '. ' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(errMessage);
                
            return response;                
        
        }
    }
    
    private static void insertCallLog(String method, String reqBody, String result, String status, String errMsg, Datetime startDate, string callerFrom, ID opportunityID){
        Datetime endDate = System.now();
        Call_Log__c log = new Call_Log__c(CallerFrom__c=callerFrom, 
                                            Endpoint__c=Label.MarketplaceEndpoint,  //'https://cs72.salesforce.com'
                                            URI__c= '/services/apexrest/v3/marketplaceorders/',
                                            Type__c='Callin',
                                            Request_Message__c=reqBody.left(131000),
                                            Response_Message__c=result,
                                            Status__c=status,
                                            Method__c=method,
                                            Error_Message__c=errMsg,
                                            Request_Start_Time__c=startDate,
                                            Response_End_Time__c=endDate,
                                            Opportunity_related__c =opportunityID
                                            
                                            );
        insert log;
    
    }

    private static String translateStatus(String stageName){
        String sfStatus = '';

        String mapping = Label.REST_CallInMappingStatus;        
        List<String> mappingList = mapping.split('#');
        String sfStage = null;
        
        for(String mp : mappingList){
            String[] elementArr = mp.split('=>');
            sfStage = elementArr[0].trim();
            sfStatus = '';
            if(sfStage == stageName){
                sfStatus = elementArr[1].trim();
                break;                            
            }            
        }
        if(sfStatus == ''){
            sfStatus = stageName;
        }
        
        return sfStatus;
    
    }
    
    private static String simplifyPostBody(String postBody, String fileKey){
        system.debug('>>> original postBody : '+postBody);
        //String[] postArr = postBody.split(',');
        Utility_RowIterator postArr = New Utility_RowIterator(postBody,',');
        String json = '';
        String el = '';
        String p = '';
        Integer begFileIdx = -1;

        //for(String p : postArr){
        while(postArr.hasNext()){        
            p = postArr.next();
            begFileIdx = p.indexOf(fileKey);
            el = p;
            if(begFileIdx>-1){
                el = '"cof_file"'+':"--FILECONTENT--"';
            }
            json = json + el + ',';     
        }
        
        json = json.substring(0, json.length()-1);
        system.debug('>>> simple postBody : '+json); 
        
        return json;   
    }
    
    global class Order {
        global String call_id { get; set; }
        global String type { get; set; }
        global String service { get; set; }
        global String product_type { get; set; }
        global String order_id { get; set; }
        global String order_date { get; set; }
        global String bp_number { get; set; }
        global String customer_name { get; set; }
        global String customer_email { get; set; }
        global String order_name { get; set; }
        global String provisioning_type { get; set; }
        global String cof_file { get; set; }
        global String file_name { get; set; }
        global String mime_type { get; set; }
        global List<Item> product_items { get; set; }    
        
    }

    global class OrderUpdate {
        global String call_id { get; set; }
        global String type { get; set; }
        global String service { get; set; }
        global String opportunity_id { get; set; }
        global String order_id { get; set; }
        global String order_status { get; set; }
        global String agreement_file { get; set; }
        global String file_name { get; set; }
        global String mime_type { get; set; }
    }
    
    
    global class Item {
        global String product_id { get; set; }
        //global String sales_price { get; set; }
        //global String quantity { get; set; }

        global double sales_price { get; set; }
        global double quantity { get; set; }

        global String notes { get; set; }
    }

    global class Response {
        global String call_id { get; set; }
        global String status { get; set; }
        global RespData data { get; set; }
        global ErrorMsg error_message { get; set; }
    }

    global class ResponseUpdate {
        global String call_id { get; set; }
        global String status { get; set; }
        global RespDataUpdate data { get; set; }
        global ErrorMsg error_message { get; set; }
    }


    global class RespData {
        global String type { get; set; }
        global String service { get; set; }
        global String order_id { get; set; }
        global String opportunity_id { get; set; }
    }

    global class RespDataUpdate {
        global String type { get; set; }
        global String service { get; set; }
        global String order_id { get; set; }
        global String order_status { get; set; }
    }

    global class RespDataFailed {
        global String type { get; set; }
        global String service { get; set; }
        global String order_id { get; set; }
    }

    /*
    global class RespDataUpdate {
        global String type { get; set; }
        global String service { get; set; }
        global String order_id { get; set; }
        global String opportunity_id { get; set; }
    }
    */

    global class ErrorMsg {
        //global String err_no { get; set; }
        global Integer err_no { get; set; }
        global String err_message { get; set; }
    }    
}