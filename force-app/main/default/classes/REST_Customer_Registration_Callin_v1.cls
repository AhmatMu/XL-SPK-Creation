/*
	version : 1
    End Point : /services/apexrest/v1/customerregistration 

    Sample Data :
	
	{
        
    }

*/    

@RestResource(urlMapping='/v1/customerregistration/*')
global with sharing class REST_Customer_Registration_Callin_v1 {
    global REST_Customer_Registration_Callin_v1() {

    }

    /* POST METHOD 
     *
     */
    @HttpPost
    global static POST_Return_Message doPost(){
        SYSTEM.DEBUG (' ================== In POST METHOD at REST_Customer_Registration_Callin_v1 ==============');

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string callerFrom = req.remoteAddress;
        String postBody = req.requestBody.toString(); 

        Integer errorNo = 201;
        String status = '';
        String callID = '';
        String customerRegistrationTicket_ID = '';
        String source = '';
	    POST_Return_Message returnMessage = null;
        String currentRequestURL;
        DateTime start_time = datetime.now();
        
        Call_Log__c calllog = new Call_Log__c();
        RESULT_DATA resDAta = new RESULT_DATA();
        ERROR_MESSAGE err = new ERROR_MESSAGE();

        //System.debug('>>> postBody REST_Customer_Registration_Callin_v1 : '+postBody);

        try {
            CustomerRegistration CustomerRegistration_extract = (CustomerRegistration)JSON.deserialize(postBody, CustomerRegistration.class);

            //System.debug('>>> CustomerRegistration_extract REST_Customer_Registration_Callin_v1 : '+CustomerRegistration_extract);

            callID =  CustomerRegistration_extract.call_id;
            source =  CustomerRegistration_extract.source;

            try {
                //-- DML Process
                Id newRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('New').getRecordTypeId();
                Id existingRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('Existing').getRecordTypeId();

                Customer_Registration_Ticket__c customerRegistrationTicket = new Customer_Registration_Ticket__c();

                if(CustomerRegistration_extract.company_type == 'new'){
                    customerRegistrationTicket.RecordTypeId = newRecordTypeId;
                    customerRegistrationTicket.Call_Id__c = CustomerRegistration_extract.call_id;
                    customerRegistrationTicket.Source__c = CustomerRegistration_extract.source;
                    customerRegistrationTicket.Service__c = CustomerRegistration_extract.service;
                    customerRegistrationTicket.Company_Type__c = CustomerRegistration_extract.company_type;
                    customerRegistrationTicket.Personal_First_Name__c = CustomerRegistration_extract.personal_first_name;
                    customerRegistrationTicket.Personal_Last_Name__c = CustomerRegistration_extract.personal_last_name;
                    customerRegistrationTicket.Personal_Email__c = CustomerRegistration_extract.personal_email;
                    customerRegistrationTicket.Personal_Phone__c = CustomerRegistration_extract.personal_phone;
                    customerRegistrationTicket.Industry__c = CustomerRegistration_extract.industry;
                    customerRegistrationTicket.Company_Unique_Name__c = CustomerRegistration_extract.company_unique_name;
                    customerRegistrationTicket.Company_Name__c = CustomerRegistration_extract.company_name;
                    customerRegistrationTicket.Number_Of_Employees__c = CustomerRegistration_extract.number_of_employees;
                    customerRegistrationTicket.Company_Group__c = CustomerRegistration_extract.company_group;
                    customerRegistrationTicket.Company_Vat_Name__c = CustomerRegistration_extract.company_vat_name;
                    customerRegistrationTicket.Npwp_No__c = CustomerRegistration_extract.npwp_no;
                    customerRegistrationTicket.Billing_Street__c = CustomerRegistration_extract.billing_street;
                    //customerRegistrationTicket.Billing_State__c = CustomerRegistration_extract.billing_state;
                    customerRegistrationTicket.Billing_Address_Province__c = CustomerRegistration_extract.billing_state;
                    customerRegistrationTicket.Billing_Building_Name__c = CustomerRegistration_extract.billing_building_name;
                    //customerRegistrationTicket.Billing_City__c = CustomerRegistration_extract.billing_city;
                    customerRegistrationTicket.Billing_Address_City__c = CustomerRegistration_extract.billing_city;
                    customerRegistrationTicket.Billing_Country__c = CustomerRegistration_extract.billing_country;
                    customerRegistrationTicket.Billing_Postal_Code__c = CustomerRegistration_extract.billing_postal_code;
                    customerRegistrationTicket.Shipping_Street__c = CustomerRegistration_extract.shipping_street;
                    //customerRegistrationTicket.Shipping_State__c = CustomerRegistration_extract.shipping_state;
                    customerRegistrationTicket.Shipping_Address_Province__c = CustomerRegistration_extract.shipping_state;
                    customerRegistrationTicket.Shipping_Building_Name__c = CustomerRegistration_extract.shipping_building_name;
                    //customerRegistrationTicket.Shipping_City__c = CustomerRegistration_extract.shipping_city;
                    customerRegistrationTicket.Shipping_Address_City__c = CustomerRegistration_extract.shipping_city;
                    customerRegistrationTicket.Shipping_Country__c = CustomerRegistration_extract.shipping_country;
                    customerRegistrationTicket.Shipping_Postal_Code__c = CustomerRegistration_extract.shipping_postal_code;
                    customerRegistrationTicket.BP_Number__c = CustomerRegistration_extract.bp_number;
                    customerRegistrationTicket.Record_Status__c = 'Created';

                    insert customerRegistrationTicket;

                    List<Documents> documentList = CustomerRegistration_extract.documents;
                    if(documentList!=null && !documentList.isEmpty()){
                        List<Customer_Registration_Document__c> customerRegistrationDocumentList = new List<Customer_Registration_Document__c>();

                        for(Documents documentListExtract : documentList){
                            Customer_Registration_Document__c customerRegistrationDocument = new Customer_Registration_Document__c();
                            customerRegistrationDocument.Name = documentListExtract.document_file_name;
                            customerRegistrationDocument.Customer_Registration_Ticket__c = customerRegistrationTicket.id;
                            customerRegistrationDocument.Document_Type_Name__c = documentListExtract.document_type_name;
                            customerRegistrationDocument.Document_Description__c = documentListExtract.document_description;
                            customerRegistrationDocumentList.add(customerRegistrationDocument);
                        }
                        insert customerRegistrationDocumentList; 
                    }
                }else if(CustomerRegistration_extract.company_type == 'existing'){
                    customerRegistrationTicket.RecordTypeId = existingRecordTypeId;
                    customerRegistrationTicket.Call_Id__c = CustomerRegistration_extract.call_id;
                    customerRegistrationTicket.Source__c = CustomerRegistration_extract.source;
                    customerRegistrationTicket.Service__c = CustomerRegistration_extract.service;
                    customerRegistrationTicket.Company_Type__c = CustomerRegistration_extract.company_type;
                    customerRegistrationTicket.Personal_First_Name__c = CustomerRegistration_extract.personal_first_name;
                    customerRegistrationTicket.Personal_Last_Name__c = CustomerRegistration_extract.personal_last_name;
                    customerRegistrationTicket.Personal_Email__c = CustomerRegistration_extract.personal_email;
                    customerRegistrationTicket.Personal_Phone__c = CustomerRegistration_extract.personal_phone;
                    customerRegistrationTicket.BP_Number__c = CustomerRegistration_extract.bp_number;
                    customerRegistrationTicket.Record_Status__c = 'Created';
                    
                    List<Account> AccountList = [Select Id From Account Where BP_Number__c =: CustomerRegistration_extract.bp_number];
                    if(AccountList!=null && !AccountList.isEmpty()){
                        customerRegistrationTicket.Account__c = AccountList[0].id;
                        insert customerRegistrationTicket;

                        List<Documents> documentList = CustomerRegistration_extract.documents;
                        if(documentList!=null && !documentList.isEmpty()){
                            List<Customer_Registration_Document__c> customerRegistrationDocumentList = new List<Customer_Registration_Document__c>();

                            for(Documents documentListExtract : documentList){
                                Customer_Registration_Document__c customerRegistrationDocument = new Customer_Registration_Document__c();
                                customerRegistrationDocument.Name = documentListExtract.document_file_name;
                                customerRegistrationDocument.Customer_Registration_Ticket__c = customerRegistrationTicket.id;
                                customerRegistrationDocument.Document_Type_Name__c = documentListExtract.document_type_name;
                                customerRegistrationDocument.Document_Description__c = documentListExtract.document_description;
                                customerRegistrationDocumentList.add(customerRegistrationDocument);
                            }
                            insert customerRegistrationDocumentList; 
                        }
                    }else{
                        resData.source = source;
                        resData.service = 'createticketcustomerreg' ;
                        resData.ticket_id = callID;
                        resData.ticket_record_id = null;

                        RestContext.response.statusCode = 403;
                        errorNo = 403;
                        err.err_no = RestContext.response.statusCode;
                        err.err_message = 'Error on POST method.:: Not Found BP Number = ' + CustomerRegistration_extract.bp_number + ' in Existing Account record';
                        
                        AppUtils.putError(err.err_message );
                    }
                }
                customerRegistrationTicket_ID = customerRegistrationTicket.id;
            }
            catch (DMLException e) {
                //-- if update error
                system.debug('Status DMLnya : ');

                RestContext.response.statusCode = 409;
                errorNo = 409;
                err.err_no = RestContext.response.statusCode;
                err.err_message = 'Error on POST method.::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber(); 
            }            
        }
        catch (Exception e) { 		
            //-- if json is not readble
            RestContext.response.statusCode = 400;
            errorNo = 400;
            
            //-- if error on validation
            RestContext.response.statusCode = 403;
            errorNo = 403;
            
            err.err_no = RestContext.response.statusCode;
            err.err_message = 'Error on POST method.::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            
            AppUtils.putError(err.err_message );
            
            //-- put log error
        }

        resData.source = source;
        resData.service = 'createticketcustomerreg' ;
        resData.ticket_id = callID; //'---PUT TICKET ID OVER HERE---'
        resData.ticket_record_id = customerRegistrationTicket_ID; //'---PUT TICKET RECORD ID (SF ID) OVER HERE---'

        if(errorNo == 201){
            status = 'success';
        }else{
            status = 'Failed';
        }

        returnMessage = new POST_Return_Message(callID, status, resData, err);
        
        //-- put call log information	    	
        calllog.type__c = 'Callin';
        calllog.method__c = 'POST';
        calllog.URI__c = '/services/apexrest/v1/customerregistration/';
        calllog.request_start_time__c = start_time;
        calllog.Request_Message__c = postBody;
        calllog.status__c = status ;
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(returnMessage) ;
        calllog.Salesforce_ID_1__c = customerRegistrationTicket_ID;
        if(String.isNotBlank(customerRegistrationTicket_ID)){
            calllog.Customer_Registration_Ticket__c = customerRegistrationTicket_ID;
        }
        calllog.endpoint__c = 'https://cs72.salesforce.com';
        calllog.Request_ID__c  = callID;
        insert calllog;

        system.debug('>>> returnMessagePOST REST_Customer_Registration_Callin_v1 : ' + returnMessage);

        return returnMessage;
    }

 
    /* PUT METHOD 
     *
     */
    @HttpPut
    global static PUT_Return_Message doPut() {
        SYSTEM.DEBUG (' ================== In PUT METHOD at REST_Customer_Registration_Callin_v1 ==============');

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string callerFrom = req.remoteAddress;
        String postBody = req.requestBody.toString(); 

        String callID = '';
        String status = '';
        String customerRegistrationTicket_ID = '';
        String source = '';
	    PUT_Return_Message returnMessage = null;
        String currentRequestURL;
        DateTime start_time = datetime.now();
        
        Call_Log__c calllog = new Call_Log__c();
        RESULT_DATA resDAta = new RESULT_DATA();
        ERROR_MESSAGE err = new ERROR_MESSAGE();        

        try {
            //-- UPDATE RECORD
            CustomerRegistrationUpdate CustomerRegistrationUpdate_extract = (CustomerRegistrationUpdate)JSON.deserialize(postBody, CustomerRegistrationUpdate.class);

            System.debug('>>> CustomerRegistrationUpdate_extract REST_Customer_Registration_Callin_v1 : '+CustomerRegistrationUpdate_extract);

            callID =  CustomerRegistrationUpdate_extract.call_id;
            customerRegistrationTicket_ID = CustomerRegistrationUpdate_extract.ticket_record_id;
            source =  CustomerRegistrationUpdate_extract.source;

            try {
                //-- DML Process for Updating
                Customer_Registration_Ticket__c customerRegistrationTicketList_extract = null;

                List<Customer_Registration_Ticket__c> customerRegistrationTicketList = [SELECT Id, Record_Status__c, Existing_Account__c, Stage__c, Name, Company_Name__c, Call_Id__c, Source__c, Service__c, Company_Type__c, Personal_First_Name__c, Personal_Last_Name__c, Personal_Email__c, Personal_Phone__c, Industry__c, Company_Unique_Name__c, Number_Of_Employees__c, Company_Group__c, Company_Vat_Name__c, Npwp_No__c, Billing_Street__c, Billing_State__c, Billing_Address_Province__c, Billing_Building_Name__c, Billing_City__c, Billing_Address_City__c, Billing_Country__c, Billing_Postal_Code__c, Shipping_Street__c, Shipping_State__c, Shipping_Address_Province__c, Shipping_Building_Name__c, Shipping_City__c, Shipping_Address_City__c, Shipping_Country__c, Shipping_Postal_Code__c FROM Customer_Registration_Ticket__c WHERE Id =: customerRegistrationTicket_ID]; 

                if(customerRegistrationTicketList!=null && !customerRegistrationTicketList.isEmpty()){
                    customerRegistrationTicketList_extract = customerRegistrationTicketList[0];
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.call_id)){
                        customerRegistrationTicketList_extract.Call_Id__c = CustomerRegistrationUpdate_extract.call_id;
                    }

                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.source)){
                        customerRegistrationTicketList_extract.Source__c = CustomerRegistrationUpdate_extract.source;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.service)){
                        customerRegistrationTicketList_extract.Service__c = CustomerRegistrationUpdate_extract.service;
                    }

                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.company_type)){
                        if(customerRegistrationTicketList_extract.Existing_Account__c == false){
                            customerRegistrationTicketList_extract.Company_Type__c = CustomerRegistrationUpdate_extract.company_type;
                        }
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.personal_first_name)){
                        customerRegistrationTicketList_extract.Personal_First_Name__c = CustomerRegistrationUpdate_extract.personal_first_name;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.personal_last_name)){
                        customerRegistrationTicketList_extract.Personal_Last_Name__c = CustomerRegistrationUpdate_extract.personal_last_name;
                    }

                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.personal_email)){
                        customerRegistrationTicketList_extract.Personal_Email__c = CustomerRegistrationUpdate_extract.personal_email;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.personal_phone)){
                        customerRegistrationTicketList_extract.Personal_Phone__c = CustomerRegistrationUpdate_extract.personal_phone;
                    }

                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.industry)){
                        customerRegistrationTicketList_extract.Industry__c = CustomerRegistrationUpdate_extract.industry;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.company_unique_name)){
                        customerRegistrationTicketList_extract.Company_Unique_Name__c = CustomerRegistrationUpdate_extract.company_unique_name;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.company_name)){
                        customerRegistrationTicketList_extract.Company_Name__c = CustomerRegistrationUpdate_extract.company_name;
                    }
                    
                    if(CustomerRegistrationUpdate_extract.number_of_employees != null){
                        customerRegistrationTicketList_extract.Number_Of_Employees__c = CustomerRegistrationUpdate_extract.number_of_employees;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.company_group)){
                        customerRegistrationTicketList_extract.Company_Group__c = CustomerRegistrationUpdate_extract.company_group;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.company_vat_name)){
                        customerRegistrationTicketList_extract.Company_Vat_Name__c = CustomerRegistrationUpdate_extract.company_vat_name;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.npwp_no)){
                        customerRegistrationTicketList_extract.Npwp_No__c = CustomerRegistrationUpdate_extract.npwp_no;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.billing_street)){
                        customerRegistrationTicketList_extract.Billing_Street__c = CustomerRegistrationUpdate_extract.billing_street;
                    }

                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.billing_state)){
                        //customerRegistrationTicketList_extract.Billing_State__c = CustomerRegistrationUpdate_extract.billing_state;

                        customerRegistrationTicketList_extract.Billing_Address_Province__c = CustomerRegistrationUpdate_extract.billing_state;
                    }

                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.billing_building_name)){
                        customerRegistrationTicketList_extract.Billing_Building_Name__c = CustomerRegistrationUpdate_extract.billing_building_name;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.billing_city)){
                        //customerRegistrationTicketList_extract.Billing_City__c = CustomerRegistrationUpdate_extract.billing_city;

                        customerRegistrationTicketList_extract.Billing_Address_City__c = CustomerRegistrationUpdate_extract.billing_city;
                    }

                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.billing_country)){
                        customerRegistrationTicketList_extract.Billing_Country__c = CustomerRegistrationUpdate_extract.billing_country;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.billing_postal_code)){
                        customerRegistrationTicketList_extract.Billing_Postal_Code__c = CustomerRegistrationUpdate_extract.billing_postal_code;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.shipping_street)){
                        customerRegistrationTicketList_extract.Shipping_Street__c = CustomerRegistrationUpdate_extract.shipping_street;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.shipping_state)){
                        //customerRegistrationTicketList_extract.Shipping_State__c = CustomerRegistrationUpdate_extract.shipping_state;

                        customerRegistrationTicketList_extract.Shipping_Address_Province__c = CustomerRegistrationUpdate_extract.shipping_state;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.shipping_building_name)){
                        customerRegistrationTicketList_extract.Shipping_Building_Name__c = CustomerRegistrationUpdate_extract.shipping_building_name;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.shipping_city)){
                        //customerRegistrationTicketList_extract.Shipping_City__c = CustomerRegistrationUpdate_extract.shipping_city;

                        customerRegistrationTicketList_extract.Shipping_Address_City__c = CustomerRegistrationUpdate_extract.shipping_city;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.shipping_country)){
                        customerRegistrationTicketList_extract.Shipping_Country__c = CustomerRegistrationUpdate_extract.shipping_country;
                    }
                    
                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.shipping_postal_code)){
                        customerRegistrationTicketList_extract.Shipping_Postal_Code__c = CustomerRegistrationUpdate_extract.shipping_postal_code;
                    }

                    if(String.isNotBlank(CustomerRegistrationUpdate_extract.bp_number)){
                        customerRegistrationTicketList_extract.BP_Number__c = CustomerRegistrationUpdate_extract.bp_number;
                    }

                    List<DocumentsUpdate> documentUpdateList = CustomerRegistrationUpdate_extract.documents;
                    if(documentUpdateList!=null && !documentUpdateList.isEmpty()){
                        set<string> documentUpdateUniqueIds = new set<string>();

                        for(DocumentsUpdate documentListUpdateExtract : documentUpdateList){
                            documentUpdateUniqueIds.add(documentListUpdateExtract.document_type_name + '/' + customerRegistrationTicket_ID);
                        }

                        Map<String,Customer_Registration_Document__c> customerRegistrationDocumentUpdateMap = new Map<String, Customer_Registration_Document__c>();

                        List<Customer_Registration_Document__c> customerRegistrationDocumentList = [SELECT Id, Customer_Registration_Ticket__c, Unique_Identity_Document__c, Name, Document_Type_Name__c, Document_Link__c FROM Customer_Registration_Document__c WHERE Unique_Identity_Document__c IN: documentUpdateUniqueIds];

                        Customer_Registration_Document__c newCustomerRegistrationDocument = null;
                        List<Customer_Registration_Document__c> newCustomerRegistrationDocumentList = new list<Customer_Registration_Document__c>();

                        if(customerRegistrationDocumentList!=null && !customerRegistrationDocumentList.isEmpty()){
                            for(Customer_Registration_Document__c customerRegistrationDocumentList_extract : customerRegistrationDocumentList){
                                customerRegistrationDocumentUpdateMap.put(customerRegistrationDocumentList_extract.Unique_Identity_Document__c, customerRegistrationDocumentList_extract);
                            }

                            for(DocumentsUpdate documentListUpdateExtract : documentUpdateList){
                                String uniqueIdentityDocument = documentListUpdateExtract.document_type_name + '/' + customerRegistrationTicket_ID;

                                Customer_Registration_Document__c customerRegistrationDocumentUpdateMap_extract = null;
                                customerRegistrationDocumentUpdateMap_extract = customerRegistrationDocumentUpdateMap.get(uniqueIdentityDocument);

                                if(customerRegistrationDocumentUpdateMap_extract != null){
                                    if(String.isNotBlank(documentListUpdateExtract.document_file_name)){
                                        customerRegistrationDocumentUpdateMap_extract.Name = documentListUpdateExtract.document_file_name;
                                    }
    
                                    if(String.isNotBlank(documentListUpdateExtract.document_type_name)){
                                        customerRegistrationDocumentUpdateMap_extract.Document_Type_Name__c = documentListUpdateExtract.document_type_name;
                                    }
                                    
                                    if(String.isNotBlank(documentListUpdateExtract.document_description)){
                                        customerRegistrationDocumentUpdateMap_extract.Document_Description__c = documentListUpdateExtract.document_description;
                                    }   
                                }else{
                                    newCustomerRegistrationDocument = new Customer_Registration_Document__c();
                                    newCustomerRegistrationDocument.Name = documentListUpdateExtract.document_file_name;
                                    newCustomerRegistrationDocument.Document_Type_Name__c = documentListUpdateExtract.document_type_name;
                                    newCustomerRegistrationDocument.Document_Description__c = documentListUpdateExtract.document_description;
                                    newCustomerRegistrationDocument.Customer_Registration_Ticket__c = customerRegistrationTicket_ID;
                                    newCustomerRegistrationDocumentList.add(newCustomerRegistrationDocument);
                                }                       
                            }
                            update(customerRegistrationDocumentUpdateMap.values());
                            insert newCustomerRegistrationDocumentList;
                        }else{
                            List<Customer_Registration_Document__c> newCustomerRegistrationDocumentList2 = new list<Customer_Registration_Document__c>();

                            for(DocumentsUpdate newDocumentListUpdateExtract : documentUpdateList){
                                Customer_Registration_Document__c newCustomerRegistrationDocument2 = new Customer_Registration_Document__c();
                                newCustomerRegistrationDocument2.Name = newDocumentListUpdateExtract.document_file_name;
                                newCustomerRegistrationDocument2.Document_Type_Name__c = newDocumentListUpdateExtract.document_type_name;
                                newCustomerRegistrationDocument2.Document_Description__c = newDocumentListUpdateExtract.document_description;
                                newCustomerRegistrationDocument2.Customer_Registration_Ticket__c = customerRegistrationTicket_ID;
                                newCustomerRegistrationDocumentList2.add(newCustomerRegistrationDocument2);
                            }
                            insert newCustomerRegistrationDocumentList2;
                        }
                        customerRegistrationTicketList_extract.Stage__c = 'Need To Review';
                        customerRegistrationTicketList_extract.Record_Status__c = 'Updated';
                        customerRegistrationTicketList_extract.Need_send_email_alert__c = true;
                        update customerRegistrationTicketList_extract;  
                    }else{
                        customerRegistrationTicketList_extract.Stage__c = 'Need To Review';
                        customerRegistrationTicketList_extract.Record_Status__c = 'Updated';
                        customerRegistrationTicketList_extract.Need_send_email_alert__c = true;
                        update customerRegistrationTicketList_extract;  
                    }
                }
            }
            catch (DMLException e) {
                status = 'failed';
                //-- if update error
                system.debug('Status DMLnya : ');

                RestContext.response.statusCode = 409;
                
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

        resData.source = source ;
        resData.service = 'updateticketcustomerreg' ;
        resData.ticket_id = callID ; //'---PUT TICKET ID OVER HERE---'
        resData.ticket_record_id = customerRegistrationTicket_ID; //'---PUT TICKET RECORD ID (SF ID) OVER HERE---'
        status = 'success';

        returnMessage = new PUT_Return_Message(callID, status, resData, err);

        //-- put call log information	    	
        calllog.type__c = 'Callin';
        calllog.method__c = 'PUT';
        calllog.URI__c = '/services/apexrest/v1/customerregistration/';
        calllog.request_start_time__c = start_time;
        calllog.status__c = status ;
        calllog.Request_Message__c = postBody;
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(returnMessage) ;
        calllog.Salesforce_ID_1__c = customerRegistrationTicket_ID;
        if(String.isNotBlank(customerRegistrationTicket_ID)){
            calllog.Customer_Registration_Ticket__c = customerRegistrationTicket_ID;
        }
        calllog.endpoint__c = 'https://cs72.salesforce.com';
        calllog.Request_ID__c  = callID;
        insert calllog;

        system.debug('>>> returnMessagePUT REST_Customer_Registration_Callin_v1 : ' + returnMessage);

        return returnMessage;
    }


    //-- DATA STRUCTUR 

    global class POST_Return_Message {
        String call_id;
        String status;
		RESULT_DATA data;
        ERROR_MESSAGE error_message;
        POST_Return_Message(String callID, String status, RESULT_DATA data, ERROR_MESSAGE errorMessage ){
            this.call_id = callID;
            this.status = status;
            this.data = data;
            this.error_message =  errorMessage;
        }
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

    global class CustomerRegistration {
        global String call_id { get; set; }
        global String source { get; set; }
        global String service { get; set; }
        global String company_type { get; set; }
        global String personal_first_name { get; set; }
        global String personal_last_name { get; set; }
        global String personal_email { get; set; }
        global String personal_phone { get; set; }
        global String industry { get; set; }
        global String company_unique_name { get; set; }
        global String company_name { get; set; }
        global Integer number_of_employees { get; set; }
        global String company_group { get; set; }
        global String company_vat_name { get; set; }
        global String npwp_no { get; set; }
        global String billing_street { get; set; }
        global String billing_state { get; set; }
        global String billing_building_name { get; set; }
        global String billing_city { get; set; }
        global String billing_country { get; set; }
        global String billing_postal_code { get; set; }
        global String shipping_street { get; set; }
        global String shipping_state { get; set; }
        global String shipping_building_name { get; set; }
        global String shipping_city { get; set; }
        global String shipping_country { get; set; }
        global String shipping_postal_code { get; set; }
        global String bp_number { get; set; }
        global List<Documents> documents { get; set; } 
    }

    global class Documents {
        global String document_type_name { get; set; }
        global String document_file_name { get; set; }
        global String document_description { get; set; }
    }

    global class CustomerRegistrationUpdate {
        global String ticket_record_id { get; set; }
        global String call_id { get; set; }
        global String source { get; set; }
        global String service { get; set; }
        global String company_type { get; set; }
        global String personal_first_name { get; set; }
        global String personal_last_name { get; set; }
        global String personal_email { get; set; }
        global String personal_phone { get; set; }
        global String industry { get; set; }
        global String company_unique_name { get; set; }
        global String company_name { get; set; }
        global Integer number_of_employees { get; set; }
        global String company_group { get; set; }
        global String company_vat_name { get; set; }
        global String npwp_no { get; set; }
        global String billing_street { get; set; }
        global String billing_state { get; set; }
        global String billing_building_name { get; set; }
        global String billing_city { get; set; }
        global String billing_country { get; set; }
        global String billing_postal_code { get; set; }
        global String shipping_street { get; set; }
        global String shipping_state { get; set; }
        global String shipping_building_name { get; set; }
        global String shipping_city { get; set; }
        global String shipping_country { get; set; }
        global String shipping_postal_code { get; set; }
        global String bp_number { get; set; }
        global List<DocumentsUpdate> documents { get; set; } 
    }

    global class DocumentsUpdate {
        global String document_type_name { get; set; }
        global String document_file_name { get; set; }
        global String document_description { get; set; }
    }

}