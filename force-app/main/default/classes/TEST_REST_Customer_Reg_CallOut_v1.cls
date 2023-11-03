@isTest
public class TEST_REST_Customer_Reg_CallOut_v1 {
    
    @isTest
    static void testApexCallout() {
        String endpoint = Label.REST_ApptiumEndpoint;
        String uriToken = Label.REST_ApptiumUriToken;
        
        String uriUpdateRegistration = Label.REST_ApptiumUpdateRegistrationDetails;
        String urlUpdateRegistration = endpoint + uriUpdateRegistration ;
        
        Test.startTest();
        
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                           'success',
                                                           '{"status":"success"}',
                                                           null);
        
        SingleRequestMock addcustomerRegistrationTicket = new SingleRequestMock(200,
                                                                                'success',
                                                                                '{"SalesForceTicketID":"a1A5D000001AzDDUA0","registrationformVerification":[{"value":"delhi","statusReason":null,"field":"companyName","approvalStatus":"Approved"},{"value":"rtyuiopl","statusReason":null,"field":"firstName","approvalStatus":"Approved"},{"value":"wertyuiopo","statusReason":null,"field":"lastName","approvalStatus":"Approved"},{"value":"delhi@delhi.com","statusReason":null,"field":"emailAddress","approvalStatus":"Approved"},{"value":"4566544566","statusReason":null,"field":"Phone","approvalStatus":"Approved"},{"value":"Transport & Logistics","statusReason":null,"field":"industryType","approvalStatus":"Approved"},{"value":"delhi","statusReason":null,"field":"companyUniqueName","approvalStatus":"Approved"},{"value":"100","statusReason":null,"field":"numberOfEmployees","approvalStatus":"Approved"},{"value":"Perusahaan Asing","statusReason":null,"field":"companyGroup","approvalStatus":"Approved"},{"value":"delhi","statusReason":null,"field":"companyVatName","approvalStatus":"Approved"},{"value":"12324","statusReason":null,"field":"taxNumber","approvalStatus":"Approved"},{"value":"delhi","statusReason":null,"field":"companyStreet","approvalStatus":"Approved"},{"value":"delhi","statusReason":null,"field":"companyState","approvalStatus":"Approved"},{"value":"delhi","statusReason":null,"field":"companyBuildingName","approvalStatus":"Approved"},{"value":"delhi","statusReason":null,"field":"companyCity","approvalStatus":"Approved"},{"value":"delhi","statusReason":null,"field":"companyCountry","approvalStatus":"Approved"},{"value":"121212","statusReason":"Approved","field":"companyPostalCode","approvalStatus":"Approved"},{"value":"pondy","statusReason":null,"field":"vatAddressStreet","approvalStatus":"Approved"},{"value":"pondy","statusReason":null,"field":"vatAddressState","approvalStatus":"Approved"},{"value":"pondy","statusReason":null,"field":"vatAddressBuildingName","approvalStatus":"Approved"},{"value":"pondy","statusReason":null,"field":"vatAddressCity","approvalStatus":"Approved"},{"value":"121212","statusReason":"Approved","field":"vatAddressPostalCode","approvalStatus":"Approved"},{"value":"759303","statusReason":null,"field":"bp_number","approvalStatus":"Approved"}],"registrationDocumentStatus":[{"statusReason":"AOA","document_type_name":"AOA","attachmentName":"download 1608103779603.pdf","approvalStatus":"Approved"},{"statusReason":"BOD LIST","document_type_name":"BOD LIST","attachmentName":"download 1608103789182.pdf","approvalStatus":"Approved"},{"statusReason":"SK","document_type_name":"SK","attachmentName":"download 1608103798297.pdf","approvalStatus":"Approved"}],"bp_number":"759303","activationStatusReason":null,"activationStatus":"Approved"}',
                                                                                null);
        
        Map<String, HttpCalloutMock> endpoint2TestResp =
            new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(endpoint + uriToken, getToken) ; // 'https://axiata-dev.apptium.com/router/consumer/auth/token', getToken);
        //endpoint2TestResp.put('https://axiata-dev.apptium.com/router/axixl/cust/action/api/customer/updateRegistrationDetails', addcustomerRegistrationTicket);
        endpoint2TestResp.put(urlUpdateRegistration, addcustomerRegistrationTicket); 
        
        HttpCalloutMock multiCalloutMock =
            new MultiRequestMock(endpoint2TestResp);
        
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        
        REST_Customer_Registration_CallOut_v1.sendApprovalInfo(null);
        Test.stopTest();
    }
    
}