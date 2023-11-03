@isTest
public class TEST_REST_Customer_Reg_Callin_v1 {
    
    @testSetup 
    static void setup() {
        Id newRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('New').getRecordTypeId();
        
        Customer_Registration_Ticket__c customerRegistrationTicket = new Customer_Registration_Ticket__c();
        customerRegistrationTicket.RecordTypeId = newRecordTypeId;
        customerRegistrationTicket.Company_Type__c = 'new';
        customerRegistrationTicket.Company_Name__c = 'Test Admin Novando';
        insert customerRegistrationTicket;

        Customer_Registration_Ticket__c customerRegistrationTicket2 = new Customer_Registration_Ticket__c();
        customerRegistrationTicket2.RecordTypeId = newRecordTypeId;
        customerRegistrationTicket2.Company_Type__c = 'new';
        customerRegistrationTicket2.Company_Name__c = 'Test Admin Novando 2';
        insert customerRegistrationTicket2;
        
        Customer_Registration_Document__c customerRegistrationDocument = new Customer_Registration_Document__c();
        customerRegistrationDocument.Name = 'semenaduk_siup.pdf';
        customerRegistrationDocument.Customer_Registration_Ticket__c = customerRegistrationTicket.id;
        customerRegistrationDocument.Document_Type_Name__c = 'SIUP';
        insert customerRegistrationDocument;
        
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'semenaduk_siup.pdf';
        contentVersion.Document_Type_Name__c = 'SIUP';
        contentVersion.FirstPublishLocationId = customerRegistrationTicket.id;
        contentVersion.PathOnClient = 'semenaduk_siup.pdf';
        contentVersion.VersionData = Blob.valueOf('Test Content');
        contentVersion.IsMajorVersion = true;
        Insert contentVersion;
    }
    
    @isTest
    static void testPostMethodNew(){
        Map<String,Object> jsonBodyMap = new Map<String,Object>();
        jsonBodyMap.put('call_id', '1234567890');
        jsonBodyMap.put('source', 'marketplace');
        jsonBodyMap.put('service', 'createticketcustomerreg');
        jsonBodyMap.put('company_type', 'new');
        jsonBodyMap.put('personal_first_name', 'Raju');
        jsonBodyMap.put('personal_last_name', 'Ramadhan');
        jsonBodyMap.put('personal_email', 'rajuramadhan@semenaduk.com');
        jsonBodyMap.put('personal_phone', '089123321999');
        jsonBodyMap.put('industry', 'Constructions');
        jsonBodyMap.put('company_unique_name', 'Semen Aduk');
        jsonBodyMap.put('company_name', 'PT. Semen Aduk Persada');
        jsonBodyMap.put('number_of_employees', 1500);
        jsonBodyMap.put('company_group', 'PT');
        jsonBodyMap.put('company_vat_name', 'PT. Semen Aduk Persada Raya');
        jsonBodyMap.put('npwp_no', '987654123456789');
        jsonBodyMap.put('billing_street', 'Jl. Cempaka No. 212');
        jsonBodyMap.put('billing_state', 'DKI Jakarta');
        jsonBodyMap.put('billing_building_name', 'Totol Building');
        jsonBodyMap.put('billing_city', 'West Jakarta');
        jsonBodyMap.put('billing_country', 'Indonesia');
        jsonBodyMap.put('billing_postal_code', '11440');
        jsonBodyMap.put('shipping_street', 'Jl. Morodadi No. 411');
        jsonBodyMap.put('shipping_state', 'West Java');
        jsonBodyMap.put('shipping_building_name', 'Satay Padang Building');
        jsonBodyMap.put('shipping_city', 'Bandung');
        jsonBodyMap.put('shipping_country', 'Indonesia');
        jsonBodyMap.put('shipping_postal_code', '18201');
        jsonBodyMap.put('bp_number', '129213');
        
        Map<String,Object> jsonDocumentMap = new Map<String,Object>();
        jsonDocumentMap.put('document_type_name', 'SIUP');
        jsonDocumentMap.put('document_file_name', 'semenaduk_siup.pdf');
        jsonDocumentMap.put('document_description', 'scan dokumen SIUP');
        
        List<Map<String,Object>> documentList = new List<Map<String,Object>>();
        documentList.add(jsonDocumentMap);
        
        jsonBodyMap.put('documents', documentList);
        
        String jsonBody = JSON.serialize(jsonBodyMap);
        
        RestResponse response = new RestResponse(); 
        RestRequest request = new RestRequest();
        request.requestUri = Label.BizstoreCustomerRegistrationEndpoint + Label.BizstoreCustomerRegistrationUri;
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonBody);
        
        RestContext.request = request;
        RestContext.response = response;
        REST_Customer_Registration_Callin_v1.POST_Return_Message res = REST_Customer_Registration_Callin_v1.doPost();
    }
    
    @isTest
    static void testPostMethodExisting(){
        Map<String,Object> jsonBodyMap = new Map<String,Object>();
        jsonBodyMap.put('call_id', '1234567890');
        jsonBodyMap.put('source', 'marketplace');
        jsonBodyMap.put('service', 'createticketcustomerreg');
        jsonBodyMap.put('company_type', 'existing');
        jsonBodyMap.put('personal_first_name', 'Raju');
        jsonBodyMap.put('personal_last_name', 'Ramadhan');
        jsonBodyMap.put('personal_email', 'rajuramadhan@semenaduk.com');
        jsonBodyMap.put('personal_phone', '089123321999');
        jsonBodyMap.put('industry', 'Constructions');
        jsonBodyMap.put('company_unique_name', 'Semen Aduk');
        jsonBodyMap.put('company_name', 'PT. Semen Aduk Persada');
        jsonBodyMap.put('number_of_employees', 1500);
        jsonBodyMap.put('company_group', 'PT');
        jsonBodyMap.put('company_vat_name', 'PT. Semen Aduk Persada Raya');
        jsonBodyMap.put('npwp_no', '987654123456789');
        jsonBodyMap.put('billing_street', 'Jl. Cempaka No. 212');
        jsonBodyMap.put('billing_state', 'DKI Jakarta');
        jsonBodyMap.put('billing_building_name', 'Totol Building');
        jsonBodyMap.put('billing_city', 'West Jakarta');
        jsonBodyMap.put('billing_country', 'Indonesia');
        jsonBodyMap.put('billing_postal_code', '11440');
        jsonBodyMap.put('shipping_street', 'Jl. Morodadi No. 411');
        jsonBodyMap.put('shipping_state', 'West Java');
        jsonBodyMap.put('shipping_building_name', 'Satay Padang Building');
        jsonBodyMap.put('shipping_city', 'Bandung');
        jsonBodyMap.put('shipping_country', 'Indonesia');
        jsonBodyMap.put('shipping_postal_code', '18201');
        jsonBodyMap.put('bp_number', '129213');
        
        Map<String,Object> jsonDocumentMap = new Map<String,Object>();
        jsonDocumentMap.put('document_type_name', 'SIUP');
        jsonDocumentMap.put('document_file_name', 'semenaduk_siup.pdf');
        jsonDocumentMap.put('document_description', 'scan dokumen SIUP');
        
        List<Map<String,Object>> documentList = new List<Map<String,Object>>();
        documentList.add(jsonDocumentMap);
        
        jsonBodyMap.put('documents', documentList);
        
        String jsonBody = JSON.serialize(jsonBodyMap);
        
        RestResponse response = new RestResponse(); 
        RestRequest request = new RestRequest();
        request.requestUri = Label.BizstoreCustomerRegistrationEndpoint + Label.BizstoreCustomerRegistrationUri;
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonBody);
        
        RestContext.request = request;
        RestContext.response = response;
        REST_Customer_Registration_Callin_v1.POST_Return_Message res = REST_Customer_Registration_Callin_v1.doPost();
    }
    
    @isTest
    static void testPutMethodNew(){
        List<Customer_Registration_Ticket__c> customerRegistrationTicket = [select id from Customer_Registration_Ticket__c where Company_Type__c = 'new'];
        
        Map<String,Object> jsonBodyMap = new Map<String,Object>();
        jsonBodyMap.put('ticket_record_id', customerRegistrationTicket[0].id);
        jsonBodyMap.put('call_id', '1234567890');
        jsonBodyMap.put('source', 'marketplace');
        jsonBodyMap.put('service', 'createticketcustomerreg');
        jsonBodyMap.put('company_type', 'existing');
        jsonBodyMap.put('personal_first_name', 'Raju');
        jsonBodyMap.put('personal_last_name', 'Ramadhan');
        jsonBodyMap.put('personal_email', 'rajuramadhan@semenaduk.com');
        jsonBodyMap.put('personal_phone', '089123321999');
        jsonBodyMap.put('industry', 'Constructions');
        jsonBodyMap.put('company_unique_name', 'Semen Aduk');
        jsonBodyMap.put('company_name', 'PT. Semen Aduk Persada');
        jsonBodyMap.put('number_of_employees', 1500);
        jsonBodyMap.put('company_group', 'PT');
        jsonBodyMap.put('company_vat_name', 'PT. Semen Aduk Persada Raya');
        jsonBodyMap.put('npwp_no', '987654123456789');
        jsonBodyMap.put('billing_street', 'Jl. Cempaka No. 212');
        jsonBodyMap.put('billing_state', 'DKI Jakarta');
        jsonBodyMap.put('billing_building_name', 'Totol Building');
        jsonBodyMap.put('billing_city', 'West Jakarta');
        jsonBodyMap.put('billing_country', 'Indonesia');
        jsonBodyMap.put('billing_postal_code', '11440');
        jsonBodyMap.put('shipping_street', 'Jl. Morodadi No. 411');
        jsonBodyMap.put('shipping_state', 'West Java');
        jsonBodyMap.put('shipping_building_name', 'Satay Padang Building');
        jsonBodyMap.put('shipping_city', 'Bandung');
        jsonBodyMap.put('shipping_country', 'Indonesia');
        jsonBodyMap.put('shipping_postal_code', '18201');
        jsonBodyMap.put('bp_number', '129213');
        
        Map<String,Object> jsonDocumentMap = new Map<String,Object>();
        jsonDocumentMap.put('document_type_name', 'SIUP');
        jsonDocumentMap.put('document_file_name', 'semenaduk_siup.pdf');
        jsonDocumentMap.put('document_description', 'scan dokumen SIUP');
        
        List<Map<String,Object>> documentList = new List<Map<String,Object>>();
        documentList.add(jsonDocumentMap);
        
        jsonBodyMap.put('documents', documentList);
        
        String jsonBody = JSON.serialize(jsonBodyMap);
        
        RestRequest request = new RestRequest();
        request.requestUri = Label.BizstoreCustomerRegistrationEndpoint + Label.BizstoreCustomerRegistrationUri;
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        REST_Customer_Registration_Callin_v1.doPut(); 
    }

    @isTest
    static void testPutMethodNew2(){
        List<Customer_Registration_Ticket__c> customerRegistrationTicket = [select id from Customer_Registration_Ticket__c where Company_Name__c = 'Test Admin Novando 2'];
        
        Map<String,Object> jsonBodyMap = new Map<String,Object>();
        jsonBodyMap.put('ticket_record_id', customerRegistrationTicket[0].id);
        jsonBodyMap.put('call_id', '1234567890');
        jsonBodyMap.put('source', 'marketplace');
        jsonBodyMap.put('service', 'createticketcustomerreg');
        jsonBodyMap.put('company_type', 'existing');
        jsonBodyMap.put('personal_first_name', 'Raju');
        jsonBodyMap.put('personal_last_name', 'Ramadhan');
        jsonBodyMap.put('personal_email', 'rajuramadhan@semenaduk.com');
        jsonBodyMap.put('personal_phone', '089123321999');
        jsonBodyMap.put('industry', 'Constructions');
        jsonBodyMap.put('company_unique_name', 'Semen Aduk');
        jsonBodyMap.put('company_name', 'PT. Semen Aduk Persada');
        jsonBodyMap.put('number_of_employees', 1500);
        jsonBodyMap.put('company_group', 'PT');
        jsonBodyMap.put('company_vat_name', 'PT. Semen Aduk Persada Raya');
        jsonBodyMap.put('npwp_no', '987654123456789');
        jsonBodyMap.put('billing_street', 'Jl. Cempaka No. 212');
        jsonBodyMap.put('billing_state', 'DKI Jakarta');
        jsonBodyMap.put('billing_building_name', 'Totol Building');
        jsonBodyMap.put('billing_city', 'West Jakarta');
        jsonBodyMap.put('billing_country', 'Indonesia');
        jsonBodyMap.put('billing_postal_code', '11440');
        jsonBodyMap.put('shipping_street', 'Jl. Morodadi No. 411');
        jsonBodyMap.put('shipping_state', 'West Java');
        jsonBodyMap.put('shipping_building_name', 'Satay Padang Building');
        jsonBodyMap.put('shipping_city', 'Bandung');
        jsonBodyMap.put('shipping_country', 'Indonesia');
        jsonBodyMap.put('shipping_postal_code', '18201');
        jsonBodyMap.put('bp_number', '129213');
        
        Map<String,Object> jsonDocumentMap = new Map<String,Object>();
        jsonDocumentMap.put('document_type_name', 'SIUP');
        jsonDocumentMap.put('document_file_name', 'semenaduk_siup.pdf');
        jsonDocumentMap.put('document_description', 'scan dokumen SIUP');
        
        List<Map<String,Object>> documentList = new List<Map<String,Object>>();
        documentList.add(jsonDocumentMap);
        
        jsonBodyMap.put('documents', documentList);
        
        String jsonBody = JSON.serialize(jsonBodyMap);
        
        RestRequest request = new RestRequest();
        request.requestUri = Label.BizstoreCustomerRegistrationEndpoint + Label.BizstoreCustomerRegistrationUri;
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        REST_Customer_Registration_Callin_v1.doPut(); 
    }
    
}