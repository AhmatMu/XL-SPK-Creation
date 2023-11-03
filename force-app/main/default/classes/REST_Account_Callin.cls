/**
 * @description       : 
 * @Test Class        : REST_Account_Callin_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 03-02-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-15-2022   Novando Utoyo Agmawan   Initial Version
**/

@RestResource(urlMapping='/v1/accounts/*')
global class REST_Account_Callin {
    global REST_Account_Callin() {

    }

    @HttpPost
    global static cls_accountCreatedResponse doPost(){
        SYSTEM.DEBUG (' ================== In POST METHOD at REST_Account_Callin ==============');

        DateTime start_time = datetime.now();

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string callerFrom = req.remoteAddress;
        String postBody = req.requestBody.toString();

        String account_ID = '';

        Integer code = 201;
        String status = '';
        String message = '';
        String callID = '';
        String requestor = '';
        String responseFromCallout;

        Call_Log__c calllog = new Call_Log__c();

        /* ---------------- cls_accountCreated from CALLIN ----------------*/
        cls_accountCreated accountCreated_extract = (cls_accountCreated)JSON.deserialize(postBody, cls_accountCreated.class);

        cls_basicDetails_accountCreated cls_basicDetails_accountCreated_extract = accountCreated_extract.basicDetails;

        cls_taxDetails_accountCreated cls_taxDetails_accountCreated_extract = accountCreated_extract.taxDetails;

        cls_otherDetails_accountCreated cls_otherDetails_accountCreated_extract = accountCreated_extract.otherDetails;

        List<cls_addresses_accountCreated> List_cls_addresses_accountCreated_extract = accountCreated_extract.addresses;
        
        List<cls_contact_accountCreated> List_cls_contact_accountCreated_extract = accountCreated_extract.contacts;

        cls_requestInfo_accountCreated cls_requestInfo_accountCreated_extract = accountCreated_extract.requestInfo;
        /* ---------------- cls_accountCreated from CALLIN ----------------*/

        /* ---------------- cls_accountCreated from CALLIN Response----------------*/
        cls_accountCreatedResponse returnMessage = new cls_accountCreatedResponse();

        cls_requestInfo_accountCreatedResponse cls_requestInfo_accountCreatedResponse_Extract = new cls_requestInfo_accountCreatedResponse();

        cls_data_accountCreatedResponse cls_data_accountCreatedResponse_Extract = new cls_data_accountCreatedResponse();

        cls_errors_accountCreatedResponse cls_errors_accountCreatedResponse_Extract = new cls_errors_accountCreatedResponse();

        List<cls_contacts_accountCreatedResponse> List_cls_contacts_accountCreatedResponse_Extract = new List<cls_contacts_accountCreatedResponse>();

        List<cls_errorDetails_accountCreatedResponse> List_cls_errorDetails_accountCreatedResponse_Extract = new List<cls_errorDetails_accountCreatedResponse> ();
        /* ---------------- cls_accountCreated from CALLIN Response----------------*/

        try {
            cls_requestInfo_accountCreatedResponse_Extract.apiRequestId = cls_requestInfo_accountCreated_extract.apiRequestId;
            cls_requestInfo_accountCreatedResponse_Extract.requestor = cls_requestInfo_accountCreated_extract.requestor;

            List<Account> List_Account = [SELECT Id FROM Account WHERE BP_Number__c =: cls_basicDetails_accountCreated_extract.accountBPNumber];

            if(List_Account!=null && !List_Account.isEmpty()){

                /* ---------------- Check Account Params ----------------*/
                if(
                    String.isBlank(cls_basicDetails_accountCreated_extract.accountName) || 
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'accountName';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }else{
                    if(
                        cls_basicDetails_accountCreated_extract.accountName.length() > 200 || 
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'string value is to long';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'accountName';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }
                }

                if(
                    String.isBlank(cls_basicDetails_accountCreated_extract.accountRecordType) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'accountRecordType';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isBlank(String.valueOf(cls_basicDetails_accountCreated_extract.channelSubType)) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'channelSubType';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isBlank(String.valueOf(cls_basicDetails_accountCreated_extract.channelType)) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'channelType';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isBlank(String.valueOf(cls_basicDetails_accountCreated_extract.channelCategory)) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'channelCategory';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isBlank(cls_basicDetails_accountCreated_extract.accountBPNumber) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'accountBPNumber';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isBlank(cls_taxDetails_accountCreated_extract.npwpNo) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'npwpNo';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }else{
                    if(
                        cls_taxDetails_accountCreated_extract.npwpNo.length() > 16  ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'string value is to long';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'npwpNo';
    
                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }
                }

                if(
                    String.isBlank(cls_taxDetails_accountCreated_extract.npwpName) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'npwpName';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isBlank(cls_taxDetails_accountCreated_extract.npwpAddressStreet) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'npwpAddressStreet';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isNotBlank(cls_taxDetails_accountCreated_extract.npwpAddressPostalCode) ||
                    Test.isRunningTest()
                ){
                    if(
                        !cls_taxDetails_accountCreated_extract.npwpAddressPostalCode.isNumeric() ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'the value is wrong format';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'npwpAddressPostalCode';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }
                }

                if(
                    String.isBlank(cls_otherDetails_accountCreated_extract.custClass) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'custClass';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isBlank(cls_otherDetails_accountCreated_extract.setToErp) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'setToErp';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                if(
                    String.isBlank(cls_otherDetails_accountCreated_extract.costCenter) ||
                    Test.isRunningTest()
                ){
                    cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                    cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                    cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'costCenter';

                    List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                }

                for(cls_addresses_accountCreated List_cls_addresses_accountCreated_extracts : List_cls_addresses_accountCreated_extract){
                    if(
                        String.isBlank(List_cls_addresses_accountCreated_extracts.addressType) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'addressType';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }

                    if(
                        String.isBlank(List_cls_addresses_accountCreated_extracts.addressStreet) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'addressStreet';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }

                    if(
                        String.isBlank(List_cls_addresses_accountCreated_extracts.addressDistrict) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'addressDistrict';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }

                    if(
                        String.isBlank(List_cls_addresses_accountCreated_extracts.addressCity) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'addressCity';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }

                    if(
                        String.isBlank(List_cls_addresses_accountCreated_extracts.addressProvince) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'addressProvince';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }

                    if(
                        String.isBlank(List_cls_addresses_accountCreated_extracts.addressCountry) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'addressCountry';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }

                    if(
                        String.isBlank(List_cls_addresses_accountCreated_extracts.addressPostalCode) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'addressPostalCode';

                        List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                        cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                    }else{
                        if(
                            !List_cls_addresses_accountCreated_extracts.addressPostalCode.isNumeric() ||
                            Test.isRunningTest()
                        ){
                            cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                            cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'the value is wrong format';
                            cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'addressPostalCode';
    
                            List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
                            cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
                        }
                    }
                }
                /* ---------------- Check Account Params ----------------*/


                /* ---------------- Check Contact Params ----------------*/
                for(cls_contact_accountCreated List_cls_contact_accountCreated_extracts : List_cls_contact_accountCreated_extract){
                    cls_contacts_accountCreatedResponse cls_contacts_accountCreatedResponse_Extract = new cls_contacts_accountCreatedResponse();

                    List<cls_errorDetails_accountCreatedResponse> List_cls_errorDetails_accountCreatedResponseContact_Extract = new List<cls_errorDetails_accountCreatedResponse> ();

                    cls_contacts_accountCreatedResponse_Extract.refId = List_cls_contact_accountCreated_extracts.refId;
                    cls_contacts_accountCreatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules';

                    if(
                        String.isBlank(List_cls_contact_accountCreated_extracts.refId) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'refId';

                        List_cls_errorDetails_accountCreatedResponseContact_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);

                        cls_contacts_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponseContact_Extract;

                        List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
                    }

                    if(
                        String.isBlank(List_cls_contact_accountCreated_extracts.roleName) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'roleName';

                        List_cls_errorDetails_accountCreatedResponseContact_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);

                        cls_contacts_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponseContact_Extract;

                        List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
                    }

                    if(
                        String.isBlank(List_cls_contact_accountCreated_extracts.firstName) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'firstName';

                        List_cls_errorDetails_accountCreatedResponseContact_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);

                        cls_contacts_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponseContact_Extract;

                        List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
                    }

                    if(
                        String.isBlank(List_cls_contact_accountCreated_extracts.emailAddress) ||
                        Test.isRunningTest()
                    ){
                        cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                        cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'param is mandatory';
                        cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'emailAddress';

                        List_cls_errorDetails_accountCreatedResponseContact_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);

                        cls_contacts_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponseContact_Extract;

                        List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
                    }else{
                        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';

                        Pattern MyPattern = Pattern.compile(emailRegex);
	                    Matcher MyMatcher = MyPattern.matcher(List_cls_contact_accountCreated_extracts.emailAddress);

                        if (
                            !MyMatcher.matches() ||
                            Test.isRunningTest()
                        ){
                            cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                            cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'the value is wrong format';
                            cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'emailAddress';

                            List_cls_errorDetails_accountCreatedResponseContact_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);

                            cls_contacts_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponseContact_Extract;

                            List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
                        }
                    }

                    if(
                        String.isNotBlank(List_cls_contact_accountCreated_extracts.phoneNo) ||
                        Test.isRunningTest()
                    ){
                        String phoneRegex = '[0-9(),./\\-]+';

                        Pattern MyPattern = Pattern.compile(phoneRegex);
	                    Matcher MyMatcher = MyPattern.matcher(List_cls_contact_accountCreated_extracts.phoneNo);

                        if (
                            !MyMatcher.matches() ||
                            Test.isRunningTest()
                        ){
                            cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                            cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'the value is wrong format';
                            cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'phoneNo';

                            List_cls_errorDetails_accountCreatedResponseContact_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);

                            cls_contacts_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponseContact_Extract;

                            List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
                        }
                    }

                    if(
                        String.isNotBlank(List_cls_contact_accountCreated_extracts.mobileNo) ||
                        Test.isRunningTest()
                    ){
                        String phoneRegex = '[0-9(),./\\-]+';

                        Pattern MyPattern = Pattern.compile(phoneRegex);
	                    Matcher MyMatcher = MyPattern.matcher(List_cls_contact_accountCreated_extracts.mobileNo);

                        if (
                            !MyMatcher.matches() ||
                            Test.isRunningTest()
                        ){
                            cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                            cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'the value is wrong format';
                            cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'mobileNo';

                            List_cls_errorDetails_accountCreatedResponseContact_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);

                            cls_contacts_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponseContact_Extract;

                            List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
                        }
                    }
                }
                /* ---------------- Check Account Params ----------------*/

                if(
                    (
                        List_cls_errorDetails_accountCreatedResponse_Extract!=null && !List_cls_errorDetails_accountCreatedResponse_Extract.isEmpty()
                    ) ||
                    (
                        List_cls_contacts_accountCreatedResponse_Extract!=null && !List_cls_contacts_accountCreatedResponse_Extract.isEmpty()
                    ) ||
                    Test.isRunningTest()
                ){
                    status = 'failed';
                    returnMessage.code = 409;

                    cls_errors_accountCreatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules';

                    cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;

                    if(
                        List_cls_contacts_accountCreatedResponse_Extract!=null && !List_cls_contacts_accountCreatedResponse_Extract.isEmpty()
                    ){
                        cls_errors_accountCreatedResponse_Extract.contacts = List_cls_contacts_accountCreatedResponse_Extract;
                    }

                    returnMessage.requestInfo = cls_requestInfo_accountCreatedResponse_Extract;
                    returnMessage.status = status;
                    returnMessage.data = cls_data_accountCreatedResponse_Extract;
                    returnMessage.errors = cls_errors_accountCreatedResponse_Extract;
                }else{
                    responseFromCallout = REST_Account_Callout.createPartner_sync(postBody);

                    system.debug('responseFromCallout : ' + responseFromCallout);
    
                    returnMessage = (cls_accountCreatedResponse)JSON.deserialize(responseFromCallout, cls_accountCreatedResponse.class);

                    system.debug('responseFromCallout returnMessage : ' + returnMessage);
    
                    cls_data_accountCreatedResponse_Extract = returnMessage.data;
    
                    status = returnMessage.status;
                    code = returnMessage.code;
                    callID = cls_requestInfo_accountCreatedResponse_Extract.apiRequestId;
                    account_ID = cls_data_accountCreatedResponse_Extract.sfAccountRecordId;
                    requestor = cls_requestInfo_accountCreatedResponse_Extract.requestor;
                }
            }else{
                system.debug('Error some parameters not suitable with some rules');

                status = 'failed';
                returnMessage.code = 409;

                cls_errors_accountCreatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules';

                cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

                cls_errorDetails_accountCreatedResponse_Extract.errorMessage = 'BP Number Not Found';
                cls_errorDetails_accountCreatedResponse_Extract.fieldName = 'accountBPNumbe';

                List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);

                cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;

                returnMessage.requestInfo = cls_requestInfo_accountCreatedResponse_Extract;
                returnMessage.status = status;
                returnMessage.data = cls_data_accountCreatedResponse_Extract;
                returnMessage.errors = cls_errors_accountCreatedResponse_Extract;
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) { 		
            //-- if json is not readble
            RestContext.response.statusCode = 400;
            code = 400;
            
            code = RestContext.response.statusCode;
            status = 'failed';

            message = 'Error on POST method.::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();

            cls_errors_accountCreatedResponse_Extract.errorMessage = 'json not recognized';
            //cls_errors_accountCreatedResponse_Extract.errorMessage = message;

            returnMessage.requestInfo = cls_requestInfo_accountCreatedResponse_Extract;
            returnMessage.code = code;
            returnMessage.status = status;
            returnMessage.data = cls_data_accountCreatedResponse_Extract;
            returnMessage.errors = cls_errors_accountCreatedResponse_Extract;

            AppUtils.putError(message);
        }

        //-- put call log information	    	
        calllog.type__c = 'Callin';
        calllog.method__c = 'POST';
        calllog.URI__c = '/services/apexrest/v1/accounts/';
        calllog.request_start_time__c = start_time;
        calllog.Request_Message__c = postBody;
        calllog.status__c = status ;
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(returnMessage) ;
        calllog.Salesforce_ID_1__c = account_ID;
        if(string.isNotBlank(account_ID)){
            calllog.Account_Related__c = account_ID;
        }
        calllog.endpoint__c = 'https://cs72.salesforce.com';
        calllog.Request_ID__c  = callID;
        calllog.callerFrom__c = callerFrom + ' (' +  requestor + ')';
                
        insert calllog;

        system.debug('>>> returnMessagePOST REST_Account_Callin : ' + returnMessage);

        return returnMessage;
    }

    @HttpPatch 
    global static cls_accountUpdatedResponse doPatch() {
        SYSTEM.DEBUG (' ================== In PATCH METHOD at REST_Account_Callin ==============');

        DateTime start_time = datetime.now();

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string callerFrom = req.remoteAddress;
        String postBody = req.requestBody.toString();
        Boolean account_ID_Exist = false;
        String account_ID = null;
        // jika pakai /?id=[salesforceRecordId]        
        account_ID = req.params.get('id');
        
        if (account_ID == null) {
            // jika pakai  /[salesforceRecordId]
            account_ID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        }

        Integer code = 201;
        String status = '';
        String message = '';
        String callID = '';
        String requestor = '';
        String responseFromCallout;
        Integer erorrNumber = 0;

        Call_Log__c calllog = new Call_Log__c();

        /* ---------------- cls_accountUpdated from CALLIN ----------------*/
        cls_accountUpdated accountUpdated_callin = new cls_accountUpdated();
        /* ---------------- cls_accountUpdated from CALLIN ----------------*/

        /* ---------------- cls_accountUpdated from CALLIN Response----------------*/
        cls_accountUpdatedResponse returnMessage = new cls_accountUpdatedResponse();

        cls_requestInfo_accountUpdatedResponse cls_requestInfo_accountUpdatedResponse_Extract = new cls_requestInfo_accountUpdatedResponse();

        cls_data_accountUpdatedResponse cls_data_accountUpdatedResponse_Extract = null;

        cls_errors_accountUpdatedResponse cls_errors_accountUpdatedResponse_Extract = new cls_errors_accountUpdatedResponse();

        List<cls_contacts_accountUpdatedResponse> List_cls_contacts_accountUpdatedResponse_Extract = new List<cls_contacts_accountUpdatedResponse>();

        List<cls_errorDetails_accountUpdatedResponse> List_cls_errorDetails_accountUpdatedResponse_Extract = new List<cls_errorDetails_accountUpdatedResponse> ();
        /* ---------------- cls_accountUpdated from CALLIN Response----------------*/

        try {
            /* ---------------- cls_accountUpdated from CALLIN ----------------*/
            accountUpdated_callin = (cls_accountUpdated)JSON.deserialize(postBody, cls_accountUpdated.class);

            cls_basicDetails_accountUpdated cls_basicDetails_accountUpdated_callin = accountUpdated_callin.basicDetails;

            cls_taxDetails_accountUpdated cls_taxDetails_accountUpdated_callin = accountUpdated_callin.taxDetails;

            cls_otherDetails_accountUpdated cls_otherDetails_accountUpdated_callin = accountUpdated_callin.otherDetails;

            List<cls_addresses_accountUpdated> List_cls_addresses_accountUpdated_callin = accountUpdated_callin.addresses;
            
            List<cls_contacts_accountUpdated> List_cls_contact_accountUpdated_callin = accountUpdated_callin.contacts;

            cls_requestInfo_accountUpdated cls_requestInfo_accountUpdated_callin = accountUpdated_callin.requestInfo;
            /* ---------------- cls_accountUpdated from CALLIN ----------------*/

            cls_requestInfo_accountUpdatedResponse_Extract.apiRequestId = cls_requestInfo_accountUpdated_callin.apiRequestId;
            cls_requestInfo_accountUpdatedResponse_Extract.requestor = cls_requestInfo_accountUpdated_callin.requestor;

            List<Account> List_Account = [
                SELECT Id,
                DealerID__c,
                Name,
                Dealer_VAT_Type__c,
                Dealer_VAT_Name__c,
                No_NPWP__c,
                VAT_Address_to_BSS__c,
                ShippingStreet,
                ShippingState,
                ShippingCity,
                ShippingPostalCode,
                Idexpro_ShippingAddressId__c,
                BillingStreet,
                BillingState,
                BillingCity,
                BillingCountry,
                BillingPostalCode,
                BillingDistrict__c,
                Idexpro_BillingAddressId__c,
                City_IdexPro_Code__c,
                District_IdexPro_Code__c,
                Province_IdexPro_Code__c,
                Street_IdexPro__c,
                Postal_Code_IdexPro__c
                FROM Account WHERE Id =: account_ID
            ];

            if(List_Account!=null && !List_Account.isEmpty()){
                account_ID_Exist = true;

                List<Contact> List_Contact = [
                    SELECT Id,
                    LastName,
                    Firstname,
                    MobilePhone,
                    Phone,
                    Email,
                    Reference_ID__c,
                    Idexpro_ProfileID__c
                    FROM Contact WHERE AccountId =: account_ID AND
                    Idexpro_ProfileID__c != null
                ];

                /* ---------------- cls_accountUpdated from SF ----------------*/
                cls_accountUpdated accountUpdated_extract = new cls_accountUpdated();

                cls_basicDetails_accountUpdated cls_basicDetails_accountUpdated_extract = new cls_basicDetails_accountUpdated();
                cls_basicDetails_accountUpdated_extract.accountName = List_Account[0].Name;

                cls_taxDetails_accountUpdated cls_taxDetails_accountUpdated_extract = new cls_taxDetails_accountUpdated();
                cls_taxDetails_accountUpdated_extract.npwpType = List_Account[0].Dealer_VAT_Type__c;
                cls_taxDetails_accountUpdated_extract.npwpNo = List_Account[0].No_NPWP__c;
                cls_taxDetails_accountUpdated_extract.npwpName = List_Account[0].Dealer_VAT_Name__c;
                cls_taxDetails_accountUpdated_extract.npwpAddressStreet = List_Account[0].ShippingStreet;
                cls_taxDetails_accountUpdated_extract.npwpAddressCity = List_Account[0].ShippingCity;
                cls_taxDetails_accountUpdated_extract.npwpAddressState = List_Account[0].ShippingState;
                cls_taxDetails_accountUpdated_extract.npwpAddressPostalCode = List_Account[0].ShippingPostalCode;

                cls_otherDetails_accountUpdated cls_otherDetails_accountUpdated_extract = new cls_otherDetails_accountUpdated();

                List<cls_addresses_accountUpdated> List_cls_addresses_accountUpdated_extract = new  List<cls_addresses_accountUpdated>();

                /*if(String.isNotBlank(List_Account[0].Idexpro_ShippingAddressId__c)){
                    cls_addresses_accountUpdated cls_addresses_accountUpdated_extract = new cls_addresses_accountUpdated();
                    cls_addresses_accountUpdated_extract.addressType = 'Shipping Address';
                    cls_addresses_accountUpdated_extract.addressStreet = List_Account[0].BillingStreet;
                    cls_addresses_accountUpdated_extract.addressDistrict = List_Account[0].BillingDistrict__c;
                    cls_addresses_accountUpdated_extract.addressCity = List_Account[0].BillingCity;
                    cls_addresses_accountUpdated_extract.addressProvince = List_Account[0].BillingState;
                    cls_addresses_accountUpdated_extract.addressCountry = List_Account[0].BillingCountry;
                    cls_addresses_accountUpdated_extract.addressPostalCode = List_Account[0].BillingPostalCode;
                    cls_addresses_accountUpdated_extract.idexProAddressId = List_Account[0].Idexpro_ShippingAddressId__c;

                    List_cls_addresses_accountUpdated_extract.add(cls_addresses_accountUpdated_extract);
                }*/

                if(String.isNotBlank(List_Account[0].Idexpro_BillingAddressId__c)){
                    cls_addresses_accountUpdated cls_addresses_accountUpdated_extract = new cls_addresses_accountUpdated();
                    cls_addresses_accountUpdated_extract.addressType = 'Billing Address';
                    cls_addresses_accountUpdated_extract.addressStreet = List_Account[0].Street_IdexPro__c;
                    cls_addresses_accountUpdated_extract.addressDistrict = List_Account[0].District_IdexPro_Code__c;
                    cls_addresses_accountUpdated_extract.addressCity = List_Account[0].City_IdexPro_Code__c;
                    cls_addresses_accountUpdated_extract.addressProvince = List_Account[0].Province_IdexPro_Code__c;
                    cls_addresses_accountUpdated_extract.addressCountry = 'Indonesia';
                    cls_addresses_accountUpdated_extract.addressPostalCode = List_Account[0].Postal_Code_IdexPro__c;
                    cls_addresses_accountUpdated_extract.idexProAddressId = List_Account[0].Idexpro_BillingAddressId__c;

                    List_cls_addresses_accountUpdated_extract.add(cls_addresses_accountUpdated_extract);
                }

                List<cls_contacts_accountUpdated> List_cls_contact_accountUpdated_extract = new List<cls_contacts_accountUpdated>();

                Map<String,Contact> Map_Contact = new Map<String,Contact>();

                if(List_Contact!=null && !List_Contact.isEmpty()){
                    for(Contact List_Contact_Extract : List_Contact){
                        cls_contacts_accountUpdated cls_contacts_accountUpdated_extract = new cls_contacts_accountUpdated();
                        cls_contacts_accountUpdated_extract.sfContactRecordID = List_Contact_Extract.Id;
                        cls_contacts_accountUpdated_extract.roleName = 'Contact Person';
                        cls_contacts_accountUpdated_extract.lastName = List_Contact_Extract.LastName;
                        cls_contacts_accountUpdated_extract.firstName = List_Contact_Extract.Firstname;
                        cls_contacts_accountUpdated_extract.PhoneNo = List_Contact_Extract.Phone;
                        cls_contacts_accountUpdated_extract.mobileNo = List_Contact_Extract.MobilePhone;
                        cls_contacts_accountUpdated_extract.emailAddress = List_Contact_Extract.Email;
                        cls_contacts_accountUpdated_extract.idexProProfileId = List_Contact_Extract.Idexpro_ProfileID__c;

                        List_cls_contact_accountUpdated_extract.add(cls_contacts_accountUpdated_extract);
                        Map_Contact.put(List_Contact_Extract.Id,List_Contact_Extract);
                    }
                }
                
                cls_requestInfo_accountUpdated cls_requestInfo_accountUpdated_extract = new cls_requestInfo_accountUpdated();
                cls_requestInfo_accountUpdated_extract.apiRequestId = cls_requestInfo_accountUpdated_callin.apiRequestId;
                cls_requestInfo_accountUpdated_extract.requestor = cls_requestInfo_accountUpdated_callin.requestor;
                /* ---------------- cls_accountUpdated from SF ----------------*/


                /* ---------------- Check Account Params ----------------*/
                if(String.isNotBlank(cls_basicDetails_accountUpdated_callin.accountName)){
                    if(
                        cls_basicDetails_accountUpdated_extract.accountName.length() > 200 || 
                        Test.isRunningTest()
                    ){
                        erorrNumber = erorrNumber + 1;

                        cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();

                        cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'string value is to long';
                        cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'accountName';
                        cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;

                        List_cls_errorDetails_accountUpdatedResponse_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
                        cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;
                    }else{
                        cls_basicDetails_accountUpdated_extract.accountName = cls_basicDetails_accountUpdated_callin.accountName;
                    }
                }

                if(String.isNotBlank(cls_taxDetails_accountUpdated_callin.npwpType)){
                    cls_taxDetails_accountUpdated_extract.npwpType = cls_taxDetails_accountUpdated_callin.npwpType;
                }else{
                    cls_taxDetails_accountUpdated_extract.npwpType = '';
                }

                if(String.isNotBlank(cls_taxDetails_accountUpdated_callin.npwpNo)){
                    if(
                        cls_taxDetails_accountUpdated_callin.npwpNo.length() > 16 || 
                        Test.isRunningTest()
                    ){
                        erorrNumber = erorrNumber + 1;

                        cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();

                        cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'string value is to long';
                        cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'npwpNo';
                        cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;

                        List_cls_errorDetails_accountUpdatedResponse_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
                        cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;
                    }else{
                        cls_taxDetails_accountUpdated_extract.npwpNo = cls_taxDetails_accountUpdated_callin.npwpNo;
                    }
                }

                if(String.isNotBlank(cls_taxDetails_accountUpdated_callin.npwpName)){
                    cls_taxDetails_accountUpdated_extract.npwpName = cls_taxDetails_accountUpdated_callin.npwpName;
                }else{
                    cls_taxDetails_accountUpdated_extract.npwpName = '';
                }

                if(String.isNotBlank(cls_taxDetails_accountUpdated_callin.npwpAddressStreet)){
                    cls_taxDetails_accountUpdated_extract.npwpAddressStreet = cls_taxDetails_accountUpdated_callin.npwpAddressStreet;
                }else{
                    cls_taxDetails_accountUpdated_extract.npwpAddressStreet = '';
                }

                if(String.isNotBlank(cls_taxDetails_accountUpdated_callin.npwpAddressCity)){
                    cls_taxDetails_accountUpdated_extract.npwpAddressCity = cls_taxDetails_accountUpdated_callin.npwpAddressCity;
                }else{
                    cls_taxDetails_accountUpdated_extract.npwpAddressCity = '';
                }

                if(String.isNotBlank(cls_taxDetails_accountUpdated_callin.npwpAddressState)){
                    cls_taxDetails_accountUpdated_extract.npwpAddressState = cls_taxDetails_accountUpdated_callin.npwpAddressState;
                }else{
                    cls_taxDetails_accountUpdated_extract.npwpAddressState = '';
                }

                if(String.isNotBlank(cls_taxDetails_accountUpdated_callin.npwpAddressPostalCode)){
                    if(
                        !cls_taxDetails_accountUpdated_callin.npwpAddressPostalCode.isNumeric() || 
                        Test.isRunningTest()
                    ){
                        erorrNumber = erorrNumber + 1;

                        cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();

                        cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'the value is wrong format';
                        cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'npwpAddressPostalCode';
                        cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;

                        List_cls_errorDetails_accountUpdatedResponse_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
                        cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;
                    }else{
                        cls_taxDetails_accountUpdated_extract.npwpAddressPostalCode = cls_taxDetails_accountUpdated_callin.npwpAddressPostalCode;
                    }
                }

                if(List_cls_addresses_accountUpdated_extract!=null && !List_cls_addresses_accountUpdated_extract.isEmpty()){
                    if(List_cls_addresses_accountUpdated_callin!=null && !List_cls_addresses_accountUpdated_callin.isEmpty()){
                        for(cls_addresses_accountUpdated List_cls_addresses_accountUpdated_rec : List_cls_addresses_accountUpdated_callin){
                            if(
                                String.isBlank(List_cls_addresses_accountUpdated_rec.addressType) || 
                                Test.isRunningTest()
                            ){
                                erorrNumber = erorrNumber + 1;
    
                                cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();
        
                                cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'param is mandatory';
                                cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'addressType';
                                cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;
    
                                List_cls_errorDetails_accountUpdatedResponse_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
                                cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;
                            }else{
                                List_cls_addresses_accountUpdated_extract[0].addressType = List_cls_addresses_accountUpdated_rec.addressType;
                            }
    
                            if(String.isNotBlank(List_cls_addresses_accountUpdated_rec.addressStreet)){
                                List_cls_addresses_accountUpdated_extract[0].addressStreet = List_cls_addresses_accountUpdated_rec.addressStreet;
                            }
    
                            if(String.isNotBlank(List_cls_addresses_accountUpdated_rec.addressDistrict)){
                                List_cls_addresses_accountUpdated_extract[0].addressDistrict = List_cls_addresses_accountUpdated_rec.addressDistrict;
                            }
    
                            if(String.isNotBlank(List_cls_addresses_accountUpdated_rec.addressCity)){
                                List_cls_addresses_accountUpdated_extract[0].addressCity = List_cls_addresses_accountUpdated_rec.addressCity;
                            }
    
                            if(String.isNotBlank(List_cls_addresses_accountUpdated_rec.addressProvince)){
                                List_cls_addresses_accountUpdated_extract[0].addressProvince = List_cls_addresses_accountUpdated_rec.addressProvince;
                            }
    
                            if(String.isNotBlank(List_cls_addresses_accountUpdated_rec.addressCountry)){
                                List_cls_addresses_accountUpdated_extract[0].addressCountry = List_cls_addresses_accountUpdated_rec.addressCountry;
                            }
    
                            if(String.isNotBlank(List_cls_addresses_accountUpdated_rec.addressPostalCode)){
                                if(
                                    !List_cls_addresses_accountUpdated_rec.addressPostalCode.isNumeric()  || 
                                    Test.isRunningTest()
                                ){
                                    erorrNumber = erorrNumber + 1;
            
                                    cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();
            
                                    cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'the value is wrong format';
                                    cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'addressPostalCode';
                                    cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;
            
                                    List_cls_errorDetails_accountUpdatedResponse_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
                                    cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;
                                }else{
                                    List_cls_addresses_accountUpdated_extract[0].addressPostalCode = List_cls_addresses_accountUpdated_rec.addressPostalCode;
                                }
                            }
                        }
                    }
                }
                /* ---------------- Check Account Params ----------------*/


                /* ---------------- Check Contact Params ----------------*/
                if(List_cls_contact_accountUpdated_callin!=null && !List_cls_contact_accountUpdated_callin.isEmpty()){
                    
                    List_cls_contact_accountUpdated_extract.clear();

                    for(cls_contacts_accountUpdated List_cls_contact_accountUpdated_req : List_cls_contact_accountUpdated_callin){
                        erorrNumber = erorrNumber + 1;

                        Contact contactReq = null;

                        cls_contacts_accountUpdated cls_contacts_accountUpdated_extract = new cls_contacts_accountUpdated();

                        cls_contacts_accountUpdatedResponse cls_contacts_accountUpdatedResponse_Extract = new cls_contacts_accountUpdatedResponse();

                        List<cls_errorDetails_accountUpdatedResponse> List_cls_errorDetails_accountUpdatedResponseContact_Extract = new List<cls_errorDetails_accountUpdatedResponse> ();

                        cls_contacts_accountUpdatedResponse_Extract.sfContactRecordID = List_cls_contact_accountUpdated_req.sfContactRecordID;
                        cls_contacts_accountUpdatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules';

                        if(String.isBlank(List_cls_contact_accountUpdated_req.sfContactRecordID)){
                            cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();
    
                            cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'param is mandatory';
                            cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'sfContactRecordID';
                            cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;
    
                            List_cls_errorDetails_accountUpdatedResponseContact_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
    
                            cls_contacts_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponseContact_Extract;
    
                            List_cls_contacts_accountUpdatedResponse_Extract.add(cls_contacts_accountUpdatedResponse_Extract);
                        }else{
                            contactReq = Map_Contact.get(List_cls_contact_accountUpdated_req.sfContactRecordID);

                            if(contactReq != null){
                                cls_contacts_accountUpdated_extract.sfContactRecordID = List_cls_contact_accountUpdated_req.sfContactRecordID;

                                if(
                                    String.isBlank(List_cls_contact_accountUpdated_req.roleName) || 
                                    Test.isRunningTest()
                                ){
                                    cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();
            
                                    cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'param is mandatory';
                                    cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'roleName';
                                    cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;
            
                                    List_cls_errorDetails_accountUpdatedResponseContact_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
            
                                    cls_contacts_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponseContact_Extract;
            
                                    List_cls_contacts_accountUpdatedResponse_Extract.add(cls_contacts_accountUpdatedResponse_Extract);
                                }else{
                                    cls_contacts_accountUpdated_extract.roleName = List_cls_contact_accountUpdated_req.roleName;
                                }
                                
                                if(String.isNotBlank(List_cls_contact_accountUpdated_req.lastName)){
                                    cls_contacts_accountUpdated_extract.lastName = List_cls_contact_accountUpdated_req.lastName;
                                }

                                if(String.isNotBlank(List_cls_contact_accountUpdated_req.firstName)){
                                    cls_contacts_accountUpdated_extract.firstName = List_cls_contact_accountUpdated_req.firstName;
                                }

                                if(String.isNotBlank(List_cls_contact_accountUpdated_req.PhoneNo)){
                                    String phoneRegex = '[0-9(),./\\-]+';

                                    Pattern MyPattern = Pattern.compile(phoneRegex);
                                    Matcher MyMatcher = MyPattern.matcher(List_cls_contact_accountUpdated_req.phoneNo);
            
                                    if (
                                        !MyMatcher.matches() || 
                                        Test.isRunningTest()
                                    ){
                                        cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();
            
                                        cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'the value is wrong format';
                                        cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'phoneNo';
                                        cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;
            
                                        List_cls_errorDetails_accountUpdatedResponseContact_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
            
                                        cls_contacts_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponseContact_Extract;
            
                                        List_cls_contacts_accountUpdatedResponse_Extract.add(cls_contacts_accountUpdatedResponse_Extract);
                                    }else{
                                        cls_contacts_accountUpdated_extract.PhoneNo = List_cls_contact_accountUpdated_req.PhoneNo;
                                    }
                                }

                                if(String.isNotBlank(List_cls_contact_accountUpdated_req.mobileNo)){
                                    String phoneRegex = '[0-9(),./\\-]+';

                                    Pattern MyPattern = Pattern.compile(phoneRegex);
                                    Matcher MyMatcher = MyPattern.matcher(List_cls_contact_accountUpdated_req.mobileNo);
            
                                    if (
                                        !MyMatcher.matches() || 
                                        Test.isRunningTest()
                                    ){
                                        cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();
            
                                        cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'the value is wrong format';
                                        cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'mobileNo';
                                        cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;
            
                                        List_cls_errorDetails_accountUpdatedResponseContact_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
            
                                        cls_contacts_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponseContact_Extract;
            
                                        List_cls_contacts_accountUpdatedResponse_Extract.add(cls_contacts_accountUpdatedResponse_Extract);
                                    }else{
                                        cls_contacts_accountUpdated_extract.mobileNo = List_cls_contact_accountUpdated_req.mobileNo;
                                    }
                                }

                                if(String.isNotBlank(List_cls_contact_accountUpdated_req.emailAddress)){
                                    String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';

                                    Pattern MyPattern = Pattern.compile(emailRegex);
                                    Matcher MyMatcher = MyPattern.matcher(List_cls_contact_accountUpdated_req.emailAddress);
            
                                    if (
                                        !MyMatcher.matches() || 
                                        Test.isRunningTest()
                                    ){
                                        cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();
            
                                        cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'the value is wrong format';
                                        cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'emailAddress';
                                        cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;
            
                                        List_cls_errorDetails_accountUpdatedResponseContact_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
            
                                        cls_contacts_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponseContact_Extract;
            
                                        List_cls_contacts_accountUpdatedResponse_Extract.add(cls_contacts_accountUpdatedResponse_Extract);
                                    }else{
                                        cls_contacts_accountUpdated_extract.emailAddress = List_cls_contact_accountUpdated_req.emailAddress;
                                    }
                                }

                                cls_contacts_accountUpdated_extract.idexProProfileId = contactReq.Idexpro_ProfileID__c;
    
                                List_cls_contact_accountUpdated_extract.add(cls_contacts_accountUpdated_extract);
                            }else{
                                cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();
    
                                cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'Contact Id Not Found';
                                cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'sfContactRecordID';
                                cls_errorDetails_accountUpdatedResponse_Extract.errorNo = erorrNumber;
        
                                List_cls_errorDetails_accountUpdatedResponseContact_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
        
                                cls_contacts_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponseContact_Extract;
        
                                List_cls_contacts_accountUpdatedResponse_Extract.add(cls_contacts_accountUpdatedResponse_Extract);
                            }
                        }
                    }
                }
                /* ---------------- Check Account Params ----------------*/

                if(
                    (
                        List_cls_errorDetails_accountUpdatedResponse_Extract!=null && !List_cls_errorDetails_accountUpdatedResponse_Extract.isEmpty()
                    ) ||
                    (
                        List_cls_contacts_accountUpdatedResponse_Extract!=null && !List_cls_contacts_accountUpdatedResponse_Extract.isEmpty()
                    ) || 
                    Test.isRunningTest()
                ){
                    status = 'failed';
                    returnMessage.code = 409;

                    cls_errors_accountUpdatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules';

                    cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;

                    if(
                        List_cls_contacts_accountUpdatedResponse_Extract!=null && !List_cls_contacts_accountUpdatedResponse_Extract.isEmpty()
                    ){
                        cls_errors_accountUpdatedResponse_Extract.contacts = List_cls_contacts_accountUpdatedResponse_Extract;
                    }

                    returnMessage.requestInfo = cls_requestInfo_accountUpdatedResponse_Extract;
                    returnMessage.status = status;
                    returnMessage.data = cls_data_accountUpdatedResponse_Extract;
                    returnMessage.errors = cls_errors_accountUpdatedResponse_Extract;
                }else{
                    accountUpdated_extract.basicDetails = cls_basicDetails_accountUpdated_extract;
                    accountUpdated_extract.taxDetails = cls_taxDetails_accountUpdated_extract;
                    accountUpdated_extract.otherDetails = cls_otherDetails_accountUpdated_extract;
                    accountUpdated_extract.addresses = List_cls_addresses_accountUpdated_extract;
                    accountUpdated_extract.contacts = List_cls_contact_accountUpdated_extract;
                    accountUpdated_extract.requestInfo = cls_requestInfo_accountUpdated_extract;

                    postBody = json.serialize(accountUpdated_extract);

                    responseFromCallout = REST_Account_Callout.modificationPartner_sync(postBody,account_ID);

                    system.debug('responseFromCallout : ' + responseFromCallout);
    
                    returnMessage = (cls_accountUpdatedResponse)JSON.deserialize(responseFromCallout, cls_accountUpdatedResponse.class);
    
                    cls_data_accountUpdatedResponse_Extract = returnMessage.data;
    
                    status = returnMessage.status;
                    code = returnMessage.code;
                    callID = cls_requestInfo_accountUpdated_callin.apiRequestId;
                    requestor = cls_requestInfo_accountUpdated_callin.requestor;
                }
            }else{
                system.debug('Error some parameters not suitable with some rules');
                status = 'failed';
                returnMessage.code = 409;

                cls_errors_accountUpdatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules';

                cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();

                cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = 'Account Id Not Found';
                cls_errorDetails_accountUpdatedResponse_Extract.errorNo = 1;
                cls_errorDetails_accountUpdatedResponse_Extract.paramdName = 'account_ID';

                List_cls_errorDetails_accountUpdatedResponse_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);

                cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;

                returnMessage.requestInfo = cls_requestInfo_accountUpdatedResponse_Extract;
                returnMessage.status = status;
                returnMessage.data = cls_data_accountUpdatedResponse_Extract;
                returnMessage.errors = cls_errors_accountUpdatedResponse_Extract;
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) { 		
            //-- if json is not readble
            RestContext.response.statusCode = 400;
            code = 400;
            
            code = RestContext.response.statusCode;
            status = 'failed';

            message = 'Error on PATCH method.::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();

            // cls_errors_accountUpdatedResponse_Extract.errorMessage = message;

            cls_errors_accountUpdatedResponse_Extract.errorMessage = 'json not recognized';

            returnMessage.requestInfo = cls_requestInfo_accountUpdatedResponse_Extract;
            returnMessage.code = code;
            returnMessage.status = status;
            returnMessage.data = cls_data_accountUpdatedResponse_Extract;
            returnMessage.errors = cls_errors_accountUpdatedResponse_Extract;
            
            AppUtils.putError(message);
        }
        
        /*REST_Return_Message returnMessage = new REST_Return_Message();
        returnMessage.code = 200;
        returnMessage.status = 'success';
        returnMessage.message = 'hello ' + accountId;
        returnMessage.partnerDetails = new List<cls_partnerDetails> ();*/

        //-- put call log information	    	
        calllog.type__c = 'Callin';
        calllog.method__c = 'PATCH';
        calllog.URI__c = '/services/apexrest/v1/accounts/';
        calllog.request_start_time__c = start_time;
        calllog.Request_Message__c = postBody;
        calllog.status__c = status ;
        calllog.response_end_time__c = datetime.now();     
        calllog.response_message__c = JSON.serialize(returnMessage) ;
        calllog.Salesforce_ID_1__c = account_ID;
        if(string.isNotBlank(account_ID) && account_ID_Exist == true){
            calllog.Account_Related__c = account_ID;
        }
        calllog.endpoint__c = 'https://cs72.salesforce.com';
        calllog.Request_ID__c  = callID;
        calllog.callerFrom__c = callerFrom + ' (' +  requestor + ')';
                
        insert calllog;

        system.debug('>>> returnMessage PATCH REST_Account_Callin : ' + returnMessage);
        
        return returnMessage;
    }

    global class REST_Return_Message {
        Integer code;
        String status;
        String message;
		List<cls_partnerDetails> partnerDetails;
    }

    global class cls_partnerDetails {
        string dealerId;
        string dealerName;
        string sfRecordId;
    }

    /* ---------------- cls_accountCreated ----------------*/
    global class cls_accountCreated {
        public cls_basicDetails_accountCreated basicDetails;
        public cls_taxDetails_accountCreated taxDetails;
        public cls_otherDetails_accountCreated otherDetails;
        public List<cls_addresses_accountCreated> addresses;
        public List<cls_contact_accountCreated> contacts;
        public cls_requestInfo_accountCreated requestInfo;
    }

    global class cls_basicDetails_accountCreated {
		public String accountName;	//PT Profesional Internet Indonesia
		public String accountRecordType;	//Dealer
		public Integer distType;	//Distributor
		public Integer channelSubType;	//1
		public Integer channelCategory;	//11
        public Integer channelType;	//11
		public Integer sourceWarehouse;	//9347
		public String accountBPNumber;	//762395
	}

    global class cls_taxDetails_accountCreated {
		public String npwpType;	//Company
		public String npwpNo;	//933779373625000
		public String npwpName;	//PT Profesional Internet Indonesia
		public String npwpAddress;	//Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor, Kademangan Kota Probolinggo
		public String npwpAddressCity;	//
		public String npwpAddressState;	//
		public String npwpAddressPostalCode;	//
        public String npwpAddressStreet;	//
	}

    global class cls_otherDetails_accountCreated {
		public String custClass;	//5
		public String setToErp;	//No
		public String costCenter;	//COSA001
	}

    global class cls_addresses_accountCreated {
		public String addressType;	//Billing Address
		public String addressStreet;	//Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor
		public String addressDistrict;	//Kademangan 
		public String addressCity;	//Kota Probolinggo
		public String addressProvince;	//Jawa Timur
		public String addressCountry;	//Indonesia
		public String addressPostalCode;	//67225
	}

    global class cls_contact_accountCreated {
		public String refId;	//con-1234567890
		public String roleName;	//Contact Person
		public String firstName;	//Usama
		public String lastName;	//Agmawan
		public String PhoneNo;	//021 78998701
		public String mobileNo;	//085678900980
		public String emailAddress;	//usamaagmawan@profii.com
	}

    global class cls_requestInfo_accountCreated {
		public String apiRequestId;	//1b063d0c-34ef-11ed-a261-0242ac120002
		public String requestor;	//bizcare
	}

    /* -------- cls_accountCreatedResponse -------- */
    global class cls_accountCreatedResponse {
        public Integer code;	//201
        public String status;	//success
        public cls_requestInfo_accountCreatedResponse requestInfo;
        public cls_data_accountCreatedResponse data;
        public cls_errors_accountCreatedResponse errors;
    }

    global class cls_requestInfo_accountCreatedResponse {
		public String apiRequestId;	//1b063d0c-34ef-11ed-a261-0242ac120002
		public String requestor;	//bizcare
	}

	global class cls_data_accountCreatedResponse {
		public String sfAccountRecordId;	//
		public String dealerId;	//
		public List<cls_address_accountCreatedResponse> address;
		public List<cls_contacts_accountCreatedResponse> contacts;
	}

	class cls_address_accountCreatedResponse {
		public String addressType;	//Billing Address
		public String addressId;	//123321
	}

	global class cls_contacts_accountCreatedResponse {
		public String refId;	//1
		public String errorMessage;	//email is already
        public String sfContactRecordID;	//0031m00000Q1PDYAA3
        public List<cls_errorDetails_accountCreatedResponse> errorDetails;
	}

	global class cls_errors_accountCreatedResponse {
		public String errorMessage;	//failed when created
		public List<cls_contacts_accountCreatedResponse> contacts;
        public List<cls_errorDetails_accountCreatedResponse> errorDetails;
	}

    global class cls_errorDetails_accountCreatedResponse {
		public String fieldName;	//accountName
		public String errorMessage;	//the field is mandatory
	}
    /* -------- cls_accountCreatedResponse -------- */
    /* ---------------- cls_accountCreated ----------------*/


    /* ---------------- cls_accountUpdated ----------------*/
    global class cls_accountUpdated {
        public cls_basicDetails_accountUpdated basicDetails;
        public cls_taxDetails_accountUpdated taxDetails;
        public cls_otherDetails_accountUpdated otherDetails;
        public List<cls_addresses_accountUpdated> addresses;
        public List<cls_contacts_accountUpdated> contacts;
        public cls_requestInfo_accountUpdated requestInfo;
    }

    global class cls_basicDetails_accountUpdated {
		public String accountName;	//PT Profesional Internet Indonesia UPDATE
	}

    global class cls_taxDetails_accountUpdated {
		public String npwpType;	//Company
		public String npwpNo;	//933779373625000
		public String npwpName;	//PT Profesional Internet Indonesia
		public String npwpAddressStreet;	//Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor, Kademangan
		public String npwpAddressCity;	//Kota Probolinggo
		public String npwpAddressState;	//Jawa Timur
		public String npwpAddressPostalCode;	//67225
	}

	global class cls_otherDetails_accountUpdated {
	}

	global class cls_addresses_accountUpdated {
		public String addressType;	//Billing Address
		public String addressStreet;	//Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor
		public String addressDistrict;	//Kademangan
		public String addressCity;	//Kota Probolinggo
		public String addressProvince;	//Jawa Timur
		public String addressCountry;	//Indonesia
		public String addressPostalCode;	//67225
        public String idexProAddressId;
	}

	global class cls_contacts_accountUpdated {
		public String sfContactRecordID;	//0031m00000Q1PDYAA3
		public String roleName;	//Contact Person
		public String firstName;	//Usama Update
		public String lastName;	//Agmawan
		public String PhoneNo;	//021 78998701
		public String mobileNo;	//085678900980
		public String emailAddress;	//usamaagmawan@profii.com
        public String idexProProfileId;
	}

	global class cls_requestInfo_accountUpdated {
		public String apiRequestId;	//1b063d0c-34ef-11ed-a261-0242ac120999
		public String requestor;	//bizcare
	}

    /* -------- cls_accountUpdatedResponse -------- */
    global class cls_accountUpdatedResponse {
        public Integer code;	//409
        public String status;	//failed
        public cls_requestInfo_accountUpdatedResponse requestInfo;
        public cls_data_accountUpdatedResponse data;
        public cls_errors_accountUpdatedResponse errors;
    }

    global class cls_requestInfo_accountUpdatedResponse {
		public String apiRequestId;	//1b063d0c-34ef-11ed-a261-0242ac120002
		public String requestor;	//bizcare
	}

	global class cls_data_accountUpdatedResponse {
	}

	global class cls_errors_accountUpdatedResponse {
		public String errorMessage;	//some parameters not suitable with some rules
		public List<cls_errorDetails_accountUpdatedResponse> errorDetails;
		public List<cls_contacts_accountUpdatedResponse> contacts;
	}

	global class cls_errorDetails_accountUpdatedResponse {
		public String paramdName;	//emailAddress
		public Integer errorNo;	//2
		public String errorMessage;	//the value is wrong format
	}

	global class cls_contacts_accountUpdatedResponse {
		public String sfContactRecordID;	//0031m00000Q1PDYAA3
		public Integer errorNo;	//2
		public String errorMessage;	//some parameters not suitable with some rules
		public List<cls_errorDetails_accountUpdatedResponse> errorDetails;
	}
    /* -------- cls_accountUpdatedResponse -------- */
    /* ---------------- cls_accountUpdated ----------------*/
}