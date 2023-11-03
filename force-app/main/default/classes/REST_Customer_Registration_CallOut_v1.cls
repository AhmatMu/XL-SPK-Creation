/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 09-01-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-01-2023   Novando Utoyo Agmawan   Initial Version
**/
global with sharing class REST_Customer_Registration_CallOut_v1 {
    /*global REST_Customer_Registration_CallOut_v1() {

    }*/


    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String xsrfToken = '' ;
    public static String xxsrfToken = '' ;

    public static Boolean doCallOut = false;
    
    
    public static void getAccessToken () {
        
        String callID = '' ;
        String responseMsg ;
        String tokenStatusMsg = '';
        string result = '';
        string errorMsg;
        string request;
        Datetime startDate = System.now();

        String endpoint = Label.REST_ApptiumEndpoint;
        String uriToken = Label.REST_ApptiumUriToken;


        // Instantiate a new http object
        Http httpObj = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest httpRequestObj = new HttpRequest(); 
        
        try {  
            String url = endpoint + uriToken; //'https://axiata-dev.apptium.com/router/consumer/auth/token';
            httpRequestObj.setEndpoint(url);

            httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');

            httpRequestObj.setHeader('client_secret', Label.REST_ApptiumClientSecret);  //'hGp42q6Ac4tzTZ-H9XglAPrxiSeSnIdYOUG+Seh-9GoJb6d3f14p2omQxWJo6Nu5JbLmWGjYSE+CJpiqye4InQ=='

            httpRequestObj.setHeader('client_id', Label.REST_ApptiumClientId); //'8sDBAWZBSGY9w90f'

            httpRequestObj.setHeader('Content-length', '0');    //additional header for UAT environment :P
            httpRequestObj.setMethod('POST');
            httpRequestObj.setTimeout(120000);

            // Send the request, and return a response
            HttpResponse httpResponseObj = httpObj.send(httpRequestObj);

            request = String.ValueOf(httpRequestObj);
            System.debug('>>> request_getAccessToken : '+request);

            result=httpResponseObj.getBody();
            System.debug('>>> result1 : '+result);

            Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(httpResponseObj.getBody ());
            String token = (string) responsemap.get('token');

            System.debug ('================= response token : ' + token );
            
            GET_TOKEN_RESPONSE response = (GET_TOKEN_RESPONSE) JSON.deserialize(result, GET_TOKEN_RESPONSE.class);
            String tokenStatus = response.status;

            System.debug ('================= GET_TOKEN_RESPONSE : ' + response );
            
            xsrfToken = (String) httpResponseObj.getHeader('XSRF-TOKEN');
            xxsrfToken = (String) httpResponseObj.getHeader('X-XSRF-TOKEN');
            
            //System.debug('>>> xsrfToken : '+xsrfToken);
            //System.debug('>>> xxsrfToken : '+xxsrfToken);

            if(tokenStatus=='success'){
                tokenStatusMsg = Label.REST_ApptiumSuccessResponse; //'CLOSED.COMPLETED';
                doCallOut = true;
            }else{
                tokenStatusMsg = Label.REST_ApptiumFailureResponse; //'CLOSED.ABORTED.ABORTED_BYSERVER';
            }
        }
        catch (Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');

            tokenStatusMsg = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Customer_Registration_CallOut_v1.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

        Datetime endDate = System.now();
        Call_Log__c log = new Call_Log__c(CallerFrom__c='Salesforce', 
                                            Endpoint__c=endpoint,     //'https://axiata-dev.apptium.com', 
                                            URI__c=uriToken,          //'/router/consumer/auth/token',
                                            Type__c='Callout',
                                            Request_Message__c= request,
                                            Response_Message__c=result + ' ### xsrfToken : ' + xsrfToken + ' ### xxsrfToken : ' + xxsrfToken,
                                            Method__c='POST',
                                            Status__c=tokenStatusMsg,
                                            Request_ID__c=callId,
                                            Request_Start_Time__c=startDate,
                                            Response_End_Time__c= endDate);
        callLogList.add(log);
    }



    @future(Callout=true)
    public static void sendApprovalInfo (ID custRegTicketID){
        SYSTEM.DEBUG ('============== in REST_Customer_Registration_CallOut_v1 class, sendApprovalInfo method ==============' );

        getAccessToken();

        string URI;
        string bodyMesage;
        string status;
        integer responseCode;
        String responseMsg;
        string errorMsg;
        string result;

        String endpoint = Label.REST_ApptiumEndpoint;

         // Instantiate a new http object
         Http httpObj = new Http();

         HttpRequest httpRequestObj = new HttpRequest();        

        Datetime requestStartTime = datetime.now();

        list<CUSTOMER_REGISTRATION_TICKET__C> custRegTicketList = new list<CUSTOMER_REGISTRATION_TICKET__C>();

        if(Test.isRunningTest()){
            Id newRecordTypeId = Schema.SObjectType.Customer_Registration_Ticket__c.getRecordTypeInfosByName().get('New').getRecordTypeId();

            Customer_Registration_Ticket__c customerRegistrationTicket = new Customer_Registration_Ticket__c();
            customerRegistrationTicket.RecordTypeId = newRecordTypeId;
            customerRegistrationTicket.Company_Type__c = 'new';
            customerRegistrationTicket.Company_Name__c = 'Test Admin Novando';
            insert customerRegistrationTicket;

            custRegTicketList.add(customerRegistrationTicket);
        }else{
           custRegTicketList = [SELECT Id, Name, Customer_Registration_Ticket_Reason__c, Customer_Registration_Ticket_Status__c, Company_Name__c, Personal_First_Name_Status__c, Call_Id__c, Source__c, Service__c, Company_Type__c, Personal_First_Name__c, Personal_Last_Name__c, Personal_Email__c, Personal_Phone__c, Industry__c, Company_Unique_Name__c, Number_Of_Employees__c, Company_Group__c, Company_Vat_Name__c, Npwp_No__c, Billing_Street__c, Billing_State__c, Billing_Address_Province__c, Billing_Building_Name__c, Billing_City__c, Billing_Address_City__c, Billing_Country__c, Billing_Postal_Code__c, Shipping_Street__c, Shipping_State__c, Shipping_Address_Province__c, Shipping_Building_Name__c, Shipping_City__c, Shipping_Address_City__c, Shipping_Country__c, Shipping_Postal_Code__c, BP_Number__c, Personal_First_Name_Reason__c, Personal_Last_Name_Status__c, Personal_Last_Name_Reason__c, Personal_Email_Status__c, Personal_Email_Reason__c, Personal_Phone_Status__c, Personal_Phone_Reason__c, Industry_Status__c, Industry_Reason__c, Company_Unique_Name_Status__c, Company_Unique_Name_Reason__c, Number_Of_Employees_Status__c, Number_Of_Employees_Reason__c, Company_Group_Status__c, Company_Group_Reason__c, Company_Vat_Name_Status__c, Company_Vat_Name_Reason__c, Npwp_No_Status__c, Npwp_No_Reason__c, Billing_Street_Status__c, Billing_Street_Reason__c, Billing_State_Status__c, Billing_State_Reason__c, Billing_Building_Name_Status__c, Billing_Building_Name_Reason__c, Billing_City_Status__c, Billing_City_Reason__c, Billing_Country_Status__c, Billing_Country_Reason__c, Billing_Postal_Code_Status__c, Billing_Postal_Code_Reason__c, Shipping_Street_Status__c, Shipping_Street_Reason__c, Shipping_State_Status__c, Shipping_State_Reason__c, Shipping_Building_Status__c, Shipping_Building_Reason__c, Shipping_City_Status__c, Shipping_City_Reason__c, Shipping_Country_Status__c, Shipping_Country_Reason__c, Shipping_Postal_Code_Status__c, Shipping_Postal_Code_Reason__c, BP_Number_Status__c, BP_Number_Reason__c, Company_Name_Status__c, Company_Name_Reason__c FROM Customer_Registration_Ticket__c WHERE Id =:custRegTicketID];
        }
        
        String callId = AppUtils.getNewGUID();

        Customer_Registration_Ticket__c custRegTicketObj = null;

        if(custRegTicketList!=null && !custRegTicketList.isEmpty()){
            custRegTicketObj = custRegTicketList[0];
        }

        system.debug('custRegTicketObj : ' + custRegTicketObj);

        // TODO : String registrationId = opportunityObj. ..... ;


        if (doCallOut) {
            try {
                //-- do call out
                SYSTEM.DEBUG ('============== try to do call out ==============');

                String uriUpdateRegistration = Label.REST_ApptiumUpdateRegistrationDetails;
                String url = endpoint + uriUpdateRegistration ; //'https://axiata-dev.apptium.com/router/axixl/cust/action/api/customer/updateRegistrationDetails';

                httpRequestObj.setTimeout(120000);
                httpRequestObj.setEndpoint(url);
                httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
                if(Test.isRunningTest()){
                    xsrfToken = '2121sa';
                    xxsrfToken = 'sas312';
                }
                httpRequestObj.setHeader('xsrf-token',   xsrfToken);
                httpRequestObj.setHeader('x-xsrf-token', xxsrfToken);
                httpRequestObj.setHeader('ep-accountname', Label.REST_ApptiumEpAccountName);  //'Axixl'
                httpRequestObj.setHeader('ep_appname', Label.REST_ApptiumEpAppName);          //'Cust'
                httpRequestObj.setMethod('POST');
                
                /*
                    {
                    "SalesForceTicketID": "a1A5D000001DZgXUAW",
                    "activationStatus": "Rejected",
                    "activationStatusReason": "Please submit the necessary details and submit again",
                    "Form Verification": [
                        {
                        "field": "companyVatName",
                        "value": "Apptium VAT",
                        "approvalStatus": "Rejected",
                        "statusReason": "Company Vat name doesn't match with our records"
                        },
                        {
                        "field": "companyUniqueName",
                        "value": "Apptium",
                        "approvalStatus": "Approved",
                        "statusReason": "Approved - Record Match"
                        }
                    ],
                    "Documents Verification": [
                        {
                        "document_type_name": "NPWP",
                        "attachmentName": "attachmentLisensi-lisensi.docx",
                        "approvalStatus": "Rejected",
                        "statusReason": "Please reupload, image is not very clear/name mismatch"
                        },
                        {
                        "document_type_name": "NPWP1",
                        "attachmentName": "attachmentLisensi-lisensi.docx",
                        "approvalStatus": "Approved",
                        "statusReason": "This document is verified and good to go"
                        }
                    ]
                    }
                */ 
                
                CustomerRegistrationTicketDetail CustomerRegistrationTicketDetail_extract = new CustomerRegistrationTicketDetail();
                CustomerRegistrationTicketDetail_extract.SalesForceTicketID = custRegTicketObj.Id;
                CustomerRegistrationTicketDetail_extract.activationStatus = custRegTicketObj.Customer_Registration_Ticket_Status__c;
                CustomerRegistrationTicketDetail_extract.bp_number = custRegTicketObj.BP_Number__c;
                CustomerRegistrationTicketDetail_extract.activationStatusReason = custRegTicketObj.Customer_Registration_Ticket_Reason__c;

                Form_Verification_List Form_Verification_extract_Company_Name = new Form_Verification_List();
                Form_Verification_extract_Company_Name.field = 'companyName';
                Form_Verification_extract_Company_Name.value = custRegTicketObj.Company_Name__c;
                Form_Verification_extract_Company_Name.approvalStatus = custRegTicketObj.Company_Name_Status__c;
                Form_Verification_extract_Company_Name.statusReason = custRegTicketObj.Company_Name_Reason__c;

                Form_Verification_List Form_Verification_extract_Personal_First_Name = new Form_Verification_List();
                Form_Verification_extract_Personal_First_Name.field = 'firstName';
                Form_Verification_extract_Personal_First_Name.value = custRegTicketObj.Personal_First_Name__c;
                Form_Verification_extract_Personal_First_Name.approvalStatus = custRegTicketObj.Personal_First_Name_Status__c;
                Form_Verification_extract_Personal_First_Name.statusReason = custRegTicketObj.Personal_First_Name_Reason__c;

                Form_Verification_List Form_Verification_extract_Personal_Last_Name = new Form_Verification_List();
                Form_Verification_extract_Personal_Last_Name.field = 'lastName';
                Form_Verification_extract_Personal_Last_Name.value = custRegTicketObj.Personal_Last_Name__c;
                Form_Verification_extract_Personal_Last_Name.approvalStatus = custRegTicketObj.Personal_Last_Name_Status__c;
                Form_Verification_extract_Personal_Last_Name.statusReason = custRegTicketObj.Personal_Last_Name_Reason__c;

                Form_Verification_List Form_Verification_extract_Personal_Email = new Form_Verification_List();
                Form_Verification_extract_Personal_Email.field = 'emailAddress';
                Form_Verification_extract_Personal_Email.value = custRegTicketObj.Personal_Email__c;
                Form_Verification_extract_Personal_Email.approvalStatus = custRegTicketObj.Personal_Email_Status__c;
                Form_Verification_extract_Personal_Email.statusReason = custRegTicketObj.Personal_Email_Reason__c;

                Form_Verification_List Form_Verification_extract_Personal_Phone = new Form_Verification_List();
                Form_Verification_extract_Personal_Phone.field = 'Phone';
                Form_Verification_extract_Personal_Phone.value = custRegTicketObj.Personal_Phone__c;
                Form_Verification_extract_Personal_Phone.approvalStatus = custRegTicketObj.Personal_Phone_Status__c;
                Form_Verification_extract_Personal_Phone.statusReason = custRegTicketObj.Personal_Phone_Reason__c;

                Form_Verification_List Form_Verification_extract_Industry = new Form_Verification_List();
                Form_Verification_extract_Industry.field = 'industryType';
                Form_Verification_extract_Industry.value = custRegTicketObj.Industry__c;
                Form_Verification_extract_Industry.approvalStatus = custRegTicketObj.Industry_Status__c;
                Form_Verification_extract_Industry.statusReason = custRegTicketObj.Industry_Reason__c;

                Form_Verification_List Form_Verification_extract_Company_Unique_Name = new Form_Verification_List();
                Form_Verification_extract_Company_Unique_Name.field = 'companyUniqueName';
                Form_Verification_extract_Company_Unique_Name.value = custRegTicketObj.Company_Unique_Name__c;
                Form_Verification_extract_Company_Unique_Name.approvalStatus = custRegTicketObj.Company_Unique_Name_Status__c;
                Form_Verification_extract_Company_Unique_Name.statusReason = custRegTicketObj.Company_Unique_Name_Reason__c;

                Form_Verification_List Form_Verification_extract_Number_Of_Employees = new Form_Verification_List();
                Form_Verification_extract_Number_Of_Employees.field = 'numberOfEmployees';
                Form_Verification_extract_Number_Of_Employees.value = String.valueOf(custRegTicketObj.Number_Of_Employees__c);
                Form_Verification_extract_Number_Of_Employees.approvalStatus = custRegTicketObj.Number_Of_Employees_Status__c;
                Form_Verification_extract_Number_Of_Employees.statusReason = custRegTicketObj.Number_Of_Employees_Reason__c;

                Form_Verification_List Form_Verification_extract_Company_Group= new Form_Verification_List();
                Form_Verification_extract_Company_Group.field = 'companyGroup';
                Form_Verification_extract_Company_Group.value = custRegTicketObj.Company_Group__c;
                Form_Verification_extract_Company_Group.approvalStatus = custRegTicketObj.Company_Group_Status__c;
                Form_Verification_extract_Company_Group.statusReason = custRegTicketObj.Company_Group_Reason__c;

                Form_Verification_List Form_Verification_extract_Company_Vat_Name= new Form_Verification_List();
                Form_Verification_extract_Company_Vat_Name.field = 'companyVatName';
                Form_Verification_extract_Company_Vat_Name.value = custRegTicketObj.Company_Vat_Name__c;
                Form_Verification_extract_Company_Vat_Name.approvalStatus = custRegTicketObj.Company_Vat_Name_Status__c;
                Form_Verification_extract_Company_Vat_Name.statusReason = custRegTicketObj.Company_Vat_Name_Reason__c;

                Form_Verification_List Form_Verification_extract_Npwp_No= new Form_Verification_List();
                Form_Verification_extract_Npwp_No.field = 'taxNumber';
                Form_Verification_extract_Npwp_No.value = custRegTicketObj.Npwp_No__c;
                Form_Verification_extract_Npwp_No.approvalStatus = custRegTicketObj.Npwp_No_Status__c;
                Form_Verification_extract_Npwp_No.statusReason = custRegTicketObj.Npwp_No_Reason__c;

                Form_Verification_List Form_Verification_extract_Billing_Street= new Form_Verification_List();
                Form_Verification_extract_Billing_Street.field = 'companyStreet';
                Form_Verification_extract_Billing_Street.value = custRegTicketObj.Billing_Street__c;
                Form_Verification_extract_Billing_Street.approvalStatus = custRegTicketObj.Billing_Street_Status__c;
                Form_Verification_extract_Billing_Street.statusReason = custRegTicketObj.Billing_Street_Reason__c;

                Form_Verification_List Form_Verification_extract_Billing_State= new Form_Verification_List();
                Form_Verification_extract_Billing_State.field = 'companyState';
                //Form_Verification_extract_Billing_State.value = custRegTicketObj.Billing_State__c;
                Form_Verification_extract_Billing_State.value = custRegTicketObj.Billing_Address_Province__c;
                Form_Verification_extract_Billing_State.approvalStatus = custRegTicketObj.Billing_State_Status__c;
                Form_Verification_extract_Billing_State.statusReason = custRegTicketObj.Billing_State_Reason__c;

                Form_Verification_List Form_Verification_extract_Billing_Building_Name= new Form_Verification_List();
                Form_Verification_extract_Billing_Building_Name.field = 'companyBuildingName';
                Form_Verification_extract_Billing_Building_Name.value = custRegTicketObj.Billing_Building_Name__c;
                Form_Verification_extract_Billing_Building_Name.approvalStatus = custRegTicketObj.Billing_Building_Name_Status__c;
                Form_Verification_extract_Billing_Building_Name.statusReason = custRegTicketObj.Billing_Building_Name_Reason__c;

                Form_Verification_List Form_Verification_extract_Billing_City= new Form_Verification_List();
                Form_Verification_extract_Billing_City.field = 'companyCity';
                //Form_Verification_extract_Billing_City.value = custRegTicketObj.Billing_City__c;
                Form_Verification_extract_Billing_City.value = custRegTicketObj.Billing_Address_City__c;
                Form_Verification_extract_Billing_City.approvalStatus = custRegTicketObj.Billing_City_Status__c;
                Form_Verification_extract_Billing_City.statusReason = custRegTicketObj.Billing_City_Reason__c;

                Form_Verification_List Form_Verification_extract_Billing_Country= new Form_Verification_List();
                Form_Verification_extract_Billing_Country.field = 'companyCountry';
                Form_Verification_extract_Billing_Country.value = custRegTicketObj.Billing_Country__c;
                Form_Verification_extract_Billing_Country.approvalStatus = custRegTicketObj.Billing_Country_Status__c;
                Form_Verification_extract_Billing_Country.statusReason = custRegTicketObj.Billing_Country_Reason__c;

                Form_Verification_List Form_Verification_extract_Billing_Postal_Code= new Form_Verification_List();
                Form_Verification_extract_Billing_Postal_Code.field = 'companyPostalCode';
                Form_Verification_extract_Billing_Postal_Code.value = custRegTicketObj.Billing_Postal_Code__c;
                Form_Verification_extract_Billing_Postal_Code.approvalStatus = custRegTicketObj.Billing_Postal_Code_Status__c;
                Form_Verification_extract_Billing_Postal_Code.statusReason = custRegTicketObj.Billing_Postal_Code_Reason__c;

                Form_Verification_List Form_Verification_extract_Shipping_Street= new Form_Verification_List();
                Form_Verification_extract_Shipping_Street.field = 'vatAddressStreet';
                Form_Verification_extract_Shipping_Street.value = custRegTicketObj.Shipping_Street__c;
                Form_Verification_extract_Shipping_Street.approvalStatus = custRegTicketObj.Shipping_Street_Status__c;
                Form_Verification_extract_Shipping_Street.statusReason = custRegTicketObj.Shipping_Street_Reason__c;

                Form_Verification_List Form_Verification_extract_Shipping_State= new Form_Verification_List();
                Form_Verification_extract_Shipping_State.field = 'vatAddressState';
                //Form_Verification_extract_Shipping_State.value = custRegTicketObj.Shipping_State__c;
                Form_Verification_extract_Shipping_State.value = custRegTicketObj.Shipping_Address_Province__c;
                Form_Verification_extract_Shipping_State.approvalStatus = custRegTicketObj.Shipping_State_Status__c;
                Form_Verification_extract_Shipping_State.statusReason = custRegTicketObj.Shipping_State_Reason__c;

                Form_Verification_List Form_Verification_extract_Shipping_Building_Name= new Form_Verification_List();
                Form_Verification_extract_Shipping_Building_Name.field = 'vatAddressBuildingName';
                Form_Verification_extract_Shipping_Building_Name.value = custRegTicketObj.Shipping_Building_Name__c;
                Form_Verification_extract_Shipping_Building_Name.approvalStatus = custRegTicketObj.Shipping_Building_Status__c;
                Form_Verification_extract_Shipping_Building_Name.statusReason = custRegTicketObj.Shipping_Building_Reason__c;

                Form_Verification_List Form_Verification_extract_Shipping_City= new Form_Verification_List();
                Form_Verification_extract_Shipping_City.field = 'vatAddressCity';
                //Form_Verification_extract_Shipping_City.value = custRegTicketObj.Shipping_City__c;
                Form_Verification_extract_Shipping_City.value = custRegTicketObj.Shipping_Address_City__c;
                Form_Verification_extract_Shipping_City.approvalStatus = custRegTicketObj.Shipping_City_Status__c;
                Form_Verification_extract_Shipping_City.statusReason = custRegTicketObj.Shipping_City_Reason__c;
                
                Form_Verification_List Form_Verification_extract_Shipping_Country= new Form_Verification_List();
                Form_Verification_extract_Shipping_Country.field = 'vatAddressCountry';
                Form_Verification_extract_Shipping_Country.value = custRegTicketObj.Shipping_Country__c;
                Form_Verification_extract_Shipping_Country.approvalStatus = custRegTicketObj.Shipping_Country_Status__c;
                Form_Verification_extract_Shipping_Country.statusReason = custRegTicketObj.Shipping_Country_Reason__c;

                Form_Verification_List Form_Verification_extract_Shipping_Postal_Code= new Form_Verification_List();
                Form_Verification_extract_Shipping_Postal_Code.field = 'vatAddressPostalCode';
                Form_Verification_extract_Shipping_Postal_Code.value = custRegTicketObj.Shipping_Postal_Code__c;
                Form_Verification_extract_Shipping_Postal_Code.approvalStatus = custRegTicketObj.Shipping_Postal_Code_Status__c;
                Form_Verification_extract_Shipping_Postal_Code.statusReason = custRegTicketObj.Shipping_Postal_Code_Status__c;

                Form_Verification_List Form_Verification_extract_BP_Number= new Form_Verification_List();
                Form_Verification_extract_BP_Number.field = 'bp_number';
                Form_Verification_extract_BP_Number.value = custRegTicketObj.BP_Number__c;
                Form_Verification_extract_BP_Number.approvalStatus = custRegTicketObj.BP_Number_Status__c;
                Form_Verification_extract_BP_Number.statusReason = custRegTicketObj.BP_Number_Reason__c;
            
                CustomerRegistrationTicketDetail_extract.registrationformVerification = new List<Form_Verification_List>();
                if(custRegTicketObj.Company_Name_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Company_Name);
                }
                if(custRegTicketObj.Personal_First_Name_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Personal_First_Name);
                }
                if(custRegTicketObj.Personal_Last_Name_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Personal_Last_Name);
                }
                if(custRegTicketObj.Personal_Email_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Personal_Email);
                }
                if(custRegTicketObj.Personal_Phone_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Personal_Phone);
                }
                if(custRegTicketObj.Industry_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Industry);
                }
                if(custRegTicketObj.Company_Unique_Name_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Company_Unique_Name);
                }
                if(custRegTicketObj.Number_Of_Employees_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Number_Of_Employees);
                }
                if(custRegTicketObj.Company_Group_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Company_Group);
                }
                if(custRegTicketObj.Company_Vat_Name_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Company_Vat_Name);
                }
                if(custRegTicketObj.Npwp_No_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Npwp_No);
                }
                if(custRegTicketObj.Billing_Street_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Billing_Street);
                }
                if(custRegTicketObj.Billing_State_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Billing_State);
                }
                if(custRegTicketObj.Billing_Building_Name_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Billing_Building_Name);
                }
                if(custRegTicketObj.Billing_City_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Billing_City);
                }
                if(custRegTicketObj.Billing_Country_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Billing_Country);
                }
                if(custRegTicketObj.Billing_Postal_Code_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Billing_Postal_Code);
                }
                if(custRegTicketObj.Shipping_Street_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Shipping_Street);
                }
                if(custRegTicketObj.Shipping_State_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Shipping_State);
                }
                if(custRegTicketObj.Shipping_Building_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Shipping_Building_Name);
                }
                if(custRegTicketObj.Shipping_City_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Shipping_City);
                }
                if(custRegTicketObj.Shipping_Country_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Shipping_Country);
                }
                if(custRegTicketObj.Shipping_Postal_Code_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_Shipping_Postal_Code);
                }
                if(custRegTicketObj.BP_Number_Status__c != 'Pending'){
                    CustomerRegistrationTicketDetail_extract.registrationformVerification.add(Form_Verification_extract_BP_Number);
                }

                List<Customer_Registration_Document__c> customerRegistrationTicketList = [SELECT Id, Name, Document_Type_Name__c, Document_Description__c, Status__c FROM Customer_Registration_Document__c WHERE Customer_Registration_Ticket__c =:custRegTicketID];

                if(customerRegistrationTicketList!=null && !customerRegistrationTicketList.isEmpty()){
                    List<Documents_Verification_List> Documents_Verification_AllList = new List<Documents_Verification_List>();
                    for(Customer_Registration_Document__c customerRegistrationTicketList_extract : customerRegistrationTicketList){
                        Documents_Verification_List Documents_Verification_List_Extract = new Documents_Verification_List();
                        if(customerRegistrationTicketList_extract.Status__c != 'Pending'){
                            Documents_Verification_List_Extract.approvalStatus = customerRegistrationTicketList_extract.Status__c;
                            Documents_Verification_List_Extract.attachmentName = customerRegistrationTicketList_extract.Name;
                            Documents_Verification_List_Extract.document_type_name = customerRegistrationTicketList_extract.Document_Type_Name__c;
                            Documents_Verification_List_Extract.statusReason = customerRegistrationTicketList_extract.Document_Description__c;
                            Documents_Verification_AllList.add(Documents_Verification_List_Extract);
                        }                        
                    }

                    if(Documents_Verification_AllList!=null && !Documents_Verification_AllList.isEmpty()){
                        CustomerRegistrationTicketDetail_extract.registrationDocumentStatus = new List<Documents_Verification_List>();
                        CustomerRegistrationTicketDetail_extract.registrationDocumentStatus.addAll(Documents_Verification_AllList);
                    }
                }

                // TODO :  create class structure for request message rejection and approve
                // TODO :  change object data to string using JSON.serialize (obj), put in reqBody

                String reqBody = JSON.serialize(CustomerRegistrationTicketDetail_extract);
                //system.debug('CustomerRegistrationTicketDetail_extract : ' +CustomerRegistrationTicketDetail_extract);
                //System.debug('>>> reqBody : '+reqBody);
                httpRequestObj.setBody(reqBody);
                httpRequestObj.setHeader('Content-length', ''+reqBody.length());    //additional header for UAT environment :P
                bodyMesage = reqBody;
                Datetime startDate = System.now();
        
                // Send the request, and return a response
                HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                result = httpResponseObj.getBody();
                //System.debug('>>> result : '+result);
                
                
                //errorMsg = result;

                //responseMsg = result;

                /*  RESPONSE SAMPLE
                    {
                        "SalesForceTicketID":"a1A5D000001DZgXUAW",
                        "errorCode”: 200,
                        "errorDescription": "Customer Details Updated Successfully"
                    }
                */

                CUSTOMER_UPDATE_DETAIL_RESPONSE response = (CUSTOMER_UPDATE_DETAIL_RESPONSE) JSON.deserialize(result, CUSTOMER_UPDATE_DETAIL_RESPONSE.class);
                Integer errorCode = response.errorCode;

                String statusMsg = '';
                if(errorCode==200){
                    status = 'success';
                    statusMsg = Label.REST_ApptiumSuccessResponse; //'CLOSED.COMPLETED';
                    responseMsg = response.errorCode + response.SalesForceTicketID + response.errorDescription;
                }else if(errorCode==404){
                    statusMsg = Label.REST_ApptiumFailureResponse; //'CLOSED.ABORTED.ABORTED_BYSERVER';
                    status = 'failed';
                    errorMsg = response.errorCode + response.SalesForceTicketID + response.errorDescription;
                }else{
                    status = 'failed';
                    errorMsg = response.errorCode + response.SalesForceTicketID + response.errorDescription;
                }

                responseCode = errorCode;

                //System.debug('>>> response : '+response);

                try {
                    //-- try to DML processs
                    SYSTEM.DEBUG ('============== try to do UPDATE ... ==============');

                    if(errorCode == 404 || errorCode == 500){
                        Customer_Registration_Ticket__c customerRegistrationTicket = [SELECT Id, Stage__c FROM Customer_Registration_Ticket__c WHERE Id =:custRegTicketID];
                        customerRegistrationTicket.Stage__c = 'Need To Review';
                        update (customerRegistrationTicket);
                    }

                }
                catch (DmlException e) {
                    //-- error handling for DML process
                    SYSTEM.DEBUG ('============== error found at DML Process ==============');
                    
                    status = 'Failed';
                    errorMsg = errorMsg +  '. Error on REST_Customer_Registration_CallOut_v1.sendApprovalInfo method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
                }

            }
            catch (Exception e) {
                //-- error handling for callout
                SYSTEM.DEBUG ('============== error found at Call-Out ==============');

                status = 'Failed';
                errorMsg = errorMsg +  '. Error on REST_Customer_Registration_CallOut_v1.sendApprovalInfo method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
                apputils.puterror(errorMsg);
                SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
            }

         // put callout information then save the data on Call_Log object
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callout';
        calllog.request_start_time__c = requestStartTime;
        calllog.method__c = 'POST';
        calllog.callerFrom__c = 'Salesforce' ;
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
        calllog.uri__c = uri ; 
        calllog.request_message__c = bodyMesage;
        calllog.status__c = status;
        calllog.response_message__c = responseMsg;            
        calllog.Error_Message__c = errorMsg;


        calllog.Salesforce_ID_1__c = custRegTicketID;
        // TODO  : put related record (ticket sf id)
        calllog.Customer_Registration_Ticket__c = custRegTicketID;


        calllog.response_end_time__c = datetime.now();     
        //calllog.cURL__c = cURL.left(131070);
        
        callLogList.add(calllog);
        insert callLogList;

        }

    } 


    global class   GET_TOKEN_RESPONSE {
        global String status{ get; set; }
    }


    /*
        {
            "SalesForceTicketID":"a1A5D000001DZgXUAW",
            "errorCode”: 200,
            "errorDescription": "Customer Details Updated Successfully"
        }
    */
    global class  CUSTOMER_UPDATE_DETAIL_RESPONSE {
        global String SalesForceTicketID { get; set; }
        global integer errorCode { get; set; }
        global String errorDescription { get; set; }
    }

    global class CustomerRegistrationTicketDetail{
        global String SalesForceTicketID { get; set; }
        global String activationStatus { get; set; }
        global String bp_number { get; set; }
        global String activationStatusReason { get; set; }
        global List<Form_Verification_List> registrationformVerification { get; set; }  
        global List<Documents_Verification_List> registrationDocumentStatus { get; set; }  
    }

    global class Form_Verification_List{
        global String field { get; set; }
        global String value { get; set; }
        global String approvalStatus { get; set; }
        global String statusReason { get; set; }
    }

    global class Documents_Verification_List{
        global String document_type_name { get; set; }
        global String attachmentName { get; set; }
        global String approvalStatus { get; set; }
        global String statusReason { get; set; }
    }

}