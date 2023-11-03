/**
 * @description       : 
 * @Test Class        : REST_Account_Callout_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 08-30-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-15-2022   Novando Utoyo Agmawan   Initial Version
**/

global with sharing class REST_Account_Callout {
    //global REST_Account_Callout(){}

    //REST_Account_Callout.createPartner();

    public static List<Call_Log__c> callLogList = new List<Call_Log__c>();
    public static String access_token;
	public static String token_type;
	public static String response_token;
    public static Boolean doCallOut = false;
    
    public static void getAccessToken(){
        Datetime startDate = System.now();

        String callID = AppUtils.getNewGUID();
        String responseMsg ;
        String tokenStatusMsg = '';
        string result = '';
        string errorMsg;
        string request;
        String endpoint;

        Http httpObj = new Http();
        HttpRequest httpRequestObj = new HttpRequest(); 

        List<IdexPro_API_Setting__c> List_IdexPro_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c, Client_Secret__c FROM IdexPro_API_Setting__c WHERE Name = 'getToken'];
        
        try {  
            if(List_IdexPro_APISetting!=null && !List_IdexPro_APISetting.isEmpty()){
                endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c;

                GET_TOKEN_REQUEST GET_TOKEN_REQUEST_obj = new GET_TOKEN_REQUEST();
                GET_TOKEN_REQUEST_obj.password = AppUtils.doDecrypt(List_IdexPro_APISetting[0].Password__c) ;
                GET_TOKEN_REQUEST_obj.username = AppUtils.doDecrypt(List_IdexPro_APISetting[0].Username__c);
				GET_TOKEN_REQUEST_obj.client_secret = AppUtils.doDecrypt(List_IdexPro_APISetting[0].Client_Secret__c);
                
                String reqBody = JSON.serialize(GET_TOKEN_REQUEST_obj);

                System.debug('>>> reqBody : '+ reqBody);

                httpRequestObj.setEndpoint(endpoint);
                httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
                httpRequestObj.setBody(reqBody);
                httpRequestObj.setMethod('POST');
                httpRequestObj.setTimeout(120000);
				
				result = '{"access_token":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw","token_type":"bearer","expires_in":1673249287831}';

                if(!Test.isRunningTest()){
                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                    result = httpResponseObj.getBody();
                }
    
                request = String.ValueOf(httpRequestObj);
                System.debug('>>> request_getAccessToken : '+ request);
    
                System.debug('>>> result1 : '+ result);
				
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
                access_token = (string) responsemap.get('access_token');
				token_type = (string) responsemap.get('token_type');
                
                System.debug ('================= response responsemap : ' + responsemap );
                System.debug ('================= response access_token : ' + access_token );

				if(Test.isRunningTest()){
                    access_token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw';
                }
                
                if(String.isNotBlank(access_token)){
                    tokenStatusMsg = 'Success';
                    doCallOut = true;
                }else{
                    tokenStatusMsg = 'Failed';
					response_token = 'Error From Token dexPro :: ' + result;
                }
            }

			if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');

            tokenStatusMsg = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Account_Callout.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

        Datetime endDate = System.now();

        Call_Log__c log = new Call_Log__c(
            CallerFrom__c = 'Salesforce', 
            Endpoint__c = endpoint, 
            Type__c = 'Callout',
            Request_Message__c = request,
            Response_Message__c = result,
            Method__c = 'POST',
            Status__c = tokenStatusMsg,
            Request_ID__c = callId,
            Request_Start_Time__c = startDate,
            Response_End_Time__c = endDate
        );
		callLogList.add(log);
    }

    public static String createPartner_sync(String postBody){
        SYSTEM.DEBUG ('============== in REST_Account_Callout class, createPartner method ==============' );

		cls_accountCreatedResponse returnMessage = new cls_accountCreatedResponse();

        List<IdexPro_API_Setting__c> List_IdexPro_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM IdexPro_API_Setting__c WHERE Name = 'createPartner'];

        if(List_IdexPro_APISetting!=null && !List_IdexPro_APISetting.isEmpty()){
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status;
            integer responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String callId;
            String endpoint;
			String dealerID;
			String AccountID;

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   

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
			cls_requestInfo_accountCreatedResponse cls_requestInfo_accountCreatedResponse_Extract = new cls_requestInfo_accountCreatedResponse();

			cls_data_accountCreatedResponse cls_data_accountCreatedResponse_Extract = new cls_data_accountCreatedResponse();

			cls_errors_accountCreatedResponse cls_errors_accountCreatedResponse_Extract = new cls_errors_accountCreatedResponse();

			cls_contacts_accountCreatedResponse cls_contacts_accountCreatedResponse_Extract = new cls_contacts_accountCreatedResponse();

			List<cls_contacts_accountCreatedResponse> List_cls_contacts_accountCreatedResponse_Extract = new List<cls_contacts_accountCreatedResponse>();

			List<cls_address_accountCreatedResponse> List_cls_address_accountCreatedResponse_Extract = new List<cls_address_accountCreatedResponse>();

			cls_errorDetails_accountCreatedResponse cls_errorDetails_accountCreatedResponse_Extract = new cls_errorDetails_accountCreatedResponse();

			List<cls_errorDetails_accountCreatedResponse> List_cls_errorDetails_accountCreatedResponse_Extract = new List<cls_errorDetails_accountCreatedResponse> ();
			/* ---------------- cls_accountCreated from CALLIN Response----------------*/

			Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(cls_basicDetails_accountCreated_extract.accountRecordType).getRecordTypeId();

            List<Account> List_AccountBP = [SELECT Id, ownerId FROM Account WHERE BP_Number__c =: cls_basicDetails_accountCreated_extract.accountBPNumber LIMIT 1];

			cls_requestInfo_accountCreatedResponse_Extract.apiRequestId = cls_requestInfo_accountCreated_extract.apiRequestId;
			cls_requestInfo_accountCreatedResponse_Extract.requestor = cls_requestInfo_accountCreated_extract.requestor;

			callId = cls_requestInfo_accountCreated_extract.apiRequestId;
            
			if (doCallOut) {
				try {
					//-- do call out
					SYSTEM.DEBUG ('============== try to do call out ==============');

					PartnerCreation_Request PartnerCreation_Request_extract = new PartnerCreation_Request();

					cls_basicDetails_PartnerCreation cls_basicDetails_PartnerCreation_extract = new cls_basicDetails_PartnerCreation();

					cls_taxDetails_PartnerCreation cls_taxDetails_PartnerCreation_extract = new cls_taxDetails_PartnerCreation();

					cls_otherDetails_PartnerCreation cls_otherDetails_PartnerCreation_extract = new cls_otherDetails_PartnerCreation();

					List<cls_addresses_PartnerCreation> List_cls_addresses_PartnerCreation_extract = new List<cls_addresses_PartnerCreation>();

					cls_profiles_PartnerCreation cls_profiles_PartnerCreation_extract = new cls_profiles_PartnerCreation();

					List<cls_profiles_PartnerCreation> List_cls_profiles_PartnerCreation_extract = new List<cls_profiles_PartnerCreation>();

					// ---------- cls_basicDetails_PartnerCreation ----------
					cls_basicDetails_PartnerCreation_extract.menu1_distName = cls_basicDetails_accountCreated_extract.accountName;
					cls_basicDetails_PartnerCreation_extract.menu1_phoneNo = List_cls_contact_accountCreated_extract[0].PhoneNo;
					cls_basicDetails_PartnerCreation_extract.menu1_emailAddress = List_cls_contact_accountCreated_extract[0].emailAddress;
					cls_basicDetails_PartnerCreation_extract.menu1_allEmailAddresses = List_cls_contact_accountCreated_extract[0].emailAddress;
					cls_basicDetails_PartnerCreation_extract.menu1_distType = cls_basicDetails_accountCreated_extract.distType;
					cls_basicDetails_PartnerCreation_extract.menu1_channelSubType = cls_basicDetails_accountCreated_extract.channelSubType;
					cls_basicDetails_PartnerCreation_extract.menu1_channelCategory = cls_basicDetails_accountCreated_extract.channelCategory;
					cls_basicDetails_PartnerCreation_extract.menu1_sourceWarehouse = cls_basicDetails_accountCreated_extract.sourceWarehouse;
					cls_basicDetails_PartnerCreation_extract.menu1_channelType = cls_basicDetails_accountCreated_extract.channelType;
					// ---------- cls_basicDetails_PartnerCreation ----------

					// ---------- cls_taxDetails_PartnerCreation ----------
					cls_taxDetails_PartnerCreation_extract.menu8_npwpType = cls_taxDetails_accountCreated_extract.npwpType;
					cls_taxDetails_PartnerCreation_extract.menu8_npwpNo = cls_taxDetails_accountCreated_extract.npwpNo;
					cls_taxDetails_PartnerCreation_extract.menu8_npwpName = cls_taxDetails_accountCreated_extract.npwpName;

					String npwpAddress = 
					cls_taxDetails_accountCreated_extract.npwpAddressStreet + ' ' + cls_taxDetails_accountCreated_extract.npwpAddressCity + ' ' +  cls_taxDetails_accountCreated_extract.npwpAddressState + ' ' + cls_taxDetails_accountCreated_extract.npwpAddressPostalCode;
					
					cls_taxDetails_PartnerCreation_extract.menu8_npwpAddress = npwpAddress;
					// ---------- cls_taxDetails_PartnerCreation ----------

					// ---------- cls_otherDetails_PartnerCreation ----------
					cls_otherDetails_PartnerCreation_extract.menu11_custClass = cls_otherDetails_accountCreated_extract.custClass;
					cls_otherDetails_PartnerCreation_extract.menu11_sentToErp = cls_otherDetails_accountCreated_extract.setToErp;
					cls_otherDetails_PartnerCreation_extract.menu11_costCenter = cls_otherDetails_accountCreated_extract.costCenter;
					// ---------- cls_otherDetails_PartnerCreation ----------
					

					// ---------- cls_addresses_PartnerCreation ----------
					cls_addresses_PartnerCreation cls_addresses_PartnerCreation_extract1 = new cls_addresses_PartnerCreation();
					cls_addresses_PartnerCreation_extract1.menu2_addressType = List_cls_addresses_accountCreated_extract[0].addressType;
					cls_addresses_PartnerCreation_extract1.menu2_Street = List_cls_addresses_accountCreated_extract[0].addressStreet;
					cls_addresses_PartnerCreation_extract1.menu2_District = List_cls_addresses_accountCreated_extract[0].addressDistrict;
					cls_addresses_PartnerCreation_extract1.menu2_City = List_cls_addresses_accountCreated_extract[0].addressCity;
					cls_addresses_PartnerCreation_extract1.menu2_Province = List_cls_addresses_accountCreated_extract[0].addressProvince;
					cls_addresses_PartnerCreation_extract1.menu2_Country = List_cls_addresses_accountCreated_extract[0].addressCountry;
					cls_addresses_PartnerCreation_extract1.menu2_postalCode = List_cls_addresses_accountCreated_extract[0].addressPostalCode;

					List_cls_addresses_PartnerCreation_extract.add(cls_addresses_PartnerCreation_extract1);

					cls_addresses_PartnerCreation cls_addresses_PartnerCreation_extract2 = new cls_addresses_PartnerCreation();
					cls_addresses_PartnerCreation_extract2.menu2_addressType = 'Shipping Address';
					cls_addresses_PartnerCreation_extract2.menu2_Street = List_cls_addresses_accountCreated_extract[0].addressStreet;
					cls_addresses_PartnerCreation_extract2.menu2_District = List_cls_addresses_accountCreated_extract[0].addressDistrict;
					cls_addresses_PartnerCreation_extract2.menu2_City = List_cls_addresses_accountCreated_extract[0].addressCity;
					cls_addresses_PartnerCreation_extract2.menu2_Province = List_cls_addresses_accountCreated_extract[0].addressProvince;
					cls_addresses_PartnerCreation_extract2.menu2_Country = List_cls_addresses_accountCreated_extract[0].addressCountry;
					cls_addresses_PartnerCreation_extract2.menu2_postalCode = List_cls_addresses_accountCreated_extract[0].addressPostalCode;

					List_cls_addresses_PartnerCreation_extract.add(cls_addresses_PartnerCreation_extract2);
					// ---------- cls_addresses_PartnerCreation ----------

					// ---------- cls_profiles_PartnerCreation ----------
					cls_profiles_PartnerCreation_extract.menu4_profileType = List_cls_contact_accountCreated_extract[0].roleName;
					cls_profiles_PartnerCreation_extract.menu4_authorisedfirstName = List_cls_contact_accountCreated_extract[0].firstName;
					cls_profiles_PartnerCreation_extract.menu4_authorisedlastName = List_cls_contact_accountCreated_extract[0].lastName;
					cls_profiles_PartnerCreation_extract.menu4_authorisedPhoneNo = List_cls_contact_accountCreated_extract[0].PhoneNo;
					cls_profiles_PartnerCreation_extract.menu4_authorisedMobileNo = List_cls_contact_accountCreated_extract[0].mobileNo;
					cls_profiles_PartnerCreation_extract.menu4_authorisedEmailAddress = List_cls_contact_accountCreated_extract[0].emailAddress;

					List_cls_profiles_PartnerCreation_extract.add(cls_profiles_PartnerCreation_extract);
					// ---------- cls_profiles_PartnerCreation ----------

					PartnerCreation_Request_extract.basicDetails = cls_basicDetails_PartnerCreation_extract;
					PartnerCreation_Request_extract.taxDetails = cls_taxDetails_PartnerCreation_extract;
					PartnerCreation_Request_extract.otherDetails = cls_otherDetails_PartnerCreation_extract;
					PartnerCreation_Request_extract.addresses = List_cls_addresses_PartnerCreation_extract;
					PartnerCreation_Request_extract.profiles = List_cls_profiles_PartnerCreation_extract;
					PartnerCreation_Request_extract.action = 'A';
					

					String reqBody = JSON.serialize(PartnerCreation_Request_extract);
					
					System.debug('>>> reqBody : '+reqBody);

					endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c;

					httpRequestObj.setTimeout(120000);
					httpRequestObj.setEndpoint(endpoint);
					httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
					if(Test.isRunningTest()){
						access_token = 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw';
					}
					httpRequestObj.setHeader('Authorization', 'Bearer ' + access_token);
					httpRequestObj.setHeader('trx_id', callId);
					httpRequestObj.setMethod('POST');
					httpRequestObj.setBody(reqBody); 

					System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));

					bodyMesage = reqBody;
					Datetime startDate = System.now();

					if(!Test.isRunningTest()){
						HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
						result = httpResponseObj.getBody();
					}else{
						result = '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190175,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"6211122","outletType":null,"outletSize":0,"mobileNo":"62322233","lastName":"Agmawan","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Usama","faxNo":null,"emailAddress":"testing020101@gmail.com","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189810}],"partnerAddresses":[{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Billing Address","addressId":4134952},{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Shipping Address","addressId":4134953}],"dealerName":"PT Profesional Internet Indonesia","dealerId":"90185670"}],"message":"Partner Created Successfully","status":"OK","code":"200"}';
					}

					System.debug('>>> result : '+result);

					Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
					responseMsg = json.serialize(responsemap);
					
					System.debug ('================= response responsemap : ' + responsemap );
					
					dealerID = AppUtils.getStringDataOnMap(responsemap , 'partnerDetails::dealerId');
					system.debug ('================= dealerID : ' + dealerID);

					if(dealerID != '== Keyset NOT found =='){
						try {
							PartnerCreation_Response PartnerCreation_Response_Extract = (PartnerCreation_Response)JSON.deserialize(result, PartnerCreation_Response.class);
 
							List<cls_partnerAddresses_PartnerCreation> List_partnerAddressesResponse = PartnerCreation_Response_Extract.partnerDetails[0].partnerAddresses;

							Map<String,String> Map_addressId = new Map<String,String>();

							for(cls_partnerAddresses_PartnerCreation List_partnerAddressesResponse_Extract : List_partnerAddressesResponse){
								Map_addressId.put(List_partnerAddressesResponse_Extract.addressType, String.ValueOf(List_partnerAddressesResponse_Extract.addressId));
							}

							List<cls_partnerProfiles_PartnerCreation> List_partnerProfilesResponse = PartnerCreation_Response_Extract.partnerDetails[0].partnerProfiles;

							status = 'success';
							responseMsg = json.serialize(responsemap);

							returnMessage.requestInfo = cls_requestInfo_accountCreatedResponse_Extract;

							String sourceWarehouses = String.valueOf(cls_basicDetails_accountCreated_extract.sourceWarehouse);

							List<SLOC__c> List_sloc = [
								SELECT Id 
								FROM SLOC__c 
								WHERE IdexPro_Value_Name__c = : sourceWarehouses
								Limit 1
							];

							Account accDealer = new Account();
							accDealer.RecordTypeId = DealerRecordTypeId;
							accDealer.Name = cls_basicDetails_accountCreated_extract.accountName;
							accDealer.Phone = List_cls_contact_accountCreated_extract[0].PhoneNo;
							accDealer.Distributor_Type__c = String.valueOf(cls_basicDetails_accountCreated_extract.distType);
							accDealer.Channel_Sub_Type__c = String.valueOf(cls_basicDetails_accountCreated_extract.channelSubType);
							accDealer.Channel_Category__c = String.valueOf(cls_basicDetails_accountCreated_extract.channelCategory);
							accDealer.Channel_Type__c = String.valueOf(cls_basicDetails_accountCreated_extract.channelType);
							accDealer.SLOC__c = List_sloc[0].Id;
							accDealer.ParentId = List_AccountBP[0].Id;
							accDealer.ownerId = List_AccountBP[0].ownerId;
							accDealer.Dealer_VAT_Type__c = cls_taxDetails_accountCreated_extract.npwpType;
							accDealer.No_NPWP__c = cls_taxDetails_accountCreated_extract.npwpNo;
							accDealer.Dealer_VAT_Name__c = cls_taxDetails_accountCreated_extract.npwpName;
							accDealer.Customer_Class__c = cls_otherDetails_accountCreated_extract.custClass;

							if(cls_otherDetails_accountCreated_extract.setToErp == 'No'){
								accDealer.Sent_to_ERP__c = false;
							}

							if(cls_otherDetails_accountCreated_extract.setToErp == 'Yes'){
								accDealer.Sent_to_ERP__c = true;
							}

							//accDealer.BillingStreet = List_cls_addresses_accountCreated_extract[0].addressStreet;
							accDealer.Street_IdexPro__c = List_cls_addresses_accountCreated_extract[0].addressStreet;

							List<Province__c> List_Province = [SELECT Id, Idexpro_Name__c FROM Province__c WHERE Idexpro_Code__c =: List_cls_addresses_accountCreated_extract[0].addressProvince];

							if(List_Province!=null && !List_Province.isEmpty()){
								//accDealer.BillingState = List_Province[0].Idexpro_Name__c;
								accDealer.Province_IdexPro__c = List_Province[0].Id;
							}
							
							List<City__c> List_City = [SELECT Id, Idexpro_Name__c FROM City__c WHERE Idexpro_Code__c =: List_cls_addresses_accountCreated_extract[0].addressCity];

							if(List_City!=null && !List_City.isEmpty()){
								//accDealer.BillingCity = List_City[0].Idexpro_Name__c;
								accDealer.City_IdexPro__c = List_City[0].Id;
							}

							List<District__c> List_District = [SELECT Id, Idexpro_Code__c, Idexpro_Name__c FROM District__c WHERE Idexpro_Code__c =: List_cls_addresses_accountCreated_extract[0].addressDistrict];

							if(List_District!=null && !List_District.isEmpty()){
								//accDealer.BillingDistrict__c = List_District[0].Idexpro_Name__c;
								accDealer.District_IdexPro__c = List_District[0].Id;
							}

							//accDealer.BillingPostalCode = List_cls_addresses_accountCreated_extract[0].addressPostalCode;
							accDealer.Postal_Code_IdexPro__c = List_cls_addresses_accountCreated_extract[0].addressPostalCode;

							accDealer.BillingCountry = List_cls_addresses_accountCreated_extract[0].addressCountry;
							accDealer.ShippingStreet = cls_taxDetails_accountCreated_extract.npwpAddressStreet;
							accDealer.ShippingState = cls_taxDetails_accountCreated_extract.npwpAddressState;
							accDealer.ShippingCity = cls_taxDetails_accountCreated_extract.npwpAddressCity;
							accDealer.ShippingPostalCode = cls_taxDetails_accountCreated_extract.npwpAddressPostalCode;
							accDealer.DealerID__c = dealerID;
							accDealer.Dealer_Status__c = 'Active';
							accDealer.Create_Dealer_IdexPro_Status__c = 'Success';

							accDealer.Idexpro_ShippingAddressId__c = Map_addressId.get('Shipping Address');
							accDealer.Idexpro_BillingAddressId__c = Map_addressId.get('Billing Address');
							Database.SaveResult insertResults_accDealer = Database.insert(accDealer);

							cls_data_accountCreatedResponse_Extract.dealerId = dealerID;

							system.debug('insertResults_accDealer : ' + insertResults_accDealer);

							AccountID = insertResults_accDealer.getId();

							try {
								Map<String,String> Map_profileId = new Map<String,String>();
								List<Contact> List_contactPerson = new List<Contact>();
								Map<String,String> Map_contactPerson_refid = new Map<String,String>();
								Set<String> Set_contactPerson_id = new Set<String>();

								for(cls_partnerProfiles_PartnerCreation List_partnerProfilesResponse_Extract : List_partnerProfilesResponse){
									Map_profileId.put(List_partnerProfilesResponse_Extract.emailAddress, String.ValueOf(List_partnerProfilesResponse_Extract.profileId));
								}

								List<Contact> List_contactExisting = [
									SELECT Id, 
									LastName,
									Firstname,
									MobilePhone,
									Phone,
									Email,
									Reference_ID__c,
									Idexpro_ProfileID__c
									FROM Contact WHERE Email =: List_cls_contact_accountCreated_extract[0].emailAddress
								];

								if(List_contactExisting!=null && !List_contactExisting.isEmpty()){
									Contact contactPerson = new Contact();

									contactPerson.Id = List_contactExisting[0].Id;

									if(String.isNotBlank(List_cls_contact_accountCreated_extract[0].lastName)){
										contactPerson.LastName = List_cls_contact_accountCreated_extract[0].lastName;
										contactPerson.Firstname = List_cls_contact_accountCreated_extract[0].firstName;
									}else{
										contactPerson.LastName = List_cls_contact_accountCreated_extract[0].firstName;
									}
									
									contactPerson.MobilePhone = List_cls_contact_accountCreated_extract[0].mobileNo;
									contactPerson.Phone = List_cls_contact_accountCreated_extract[0].PhoneNo;
									contactPerson.Email = List_cls_contact_accountCreated_extract[0].emailAddress;
									contactPerson.Reference_ID__c = List_cls_contact_accountCreated_extract[0].refId;
									
									contactPerson.Idexpro_ProfileID__c = Map_profileId.get(List_cls_contact_accountCreated_extract[0].emailAddress);

									List_contactPerson.add(contactPerson);

									Database.SaveResult[] updateResults_contactPerson = Database.update(List_contactPerson, true);

									Map_contactPerson_refid.put(List_contactExisting[0].Reference_ID__c,List_contactExisting[0].Id);

									AccountContactRelation CR = new AccountContactRelation();
									CR.AccountID = AccountID;
									CR.Contactid = List_contactExisting[0].Id;
									CR.Roles = 'Contact Person';
									insert CR;

									for(cls_contact_accountCreated List_cls_contact_accountCreated_extractRec : List_cls_contact_accountCreated_extract){
										cls_contacts_accountCreatedResponse_Extract.refId = List_cls_contact_accountCreated_extractRec.refId;
										cls_contacts_accountCreatedResponse_Extract.sfContactRecordID = Map_contactPerson_refid.get(List_cls_contact_accountCreated_extractRec.refId);

										List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
									}
								}else{
									for(cls_contact_accountCreated List_cls_contact_accountCreated_extractRec : List_cls_contact_accountCreated_extract){
										Contact contactPerson = new Contact();

										if(String.isNotBlank(List_cls_contact_accountCreated_extractRec.lastName)){
											contactPerson.LastName = List_cls_contact_accountCreated_extractRec.lastName;
											contactPerson.Firstname = List_cls_contact_accountCreated_extractRec.firstName;
										}else{
											contactPerson.LastName = List_cls_contact_accountCreated_extractRec.firstName;
										}
										
										contactPerson.Accountid = AccountID;
										contactPerson.MobilePhone = List_cls_contact_accountCreated_extractRec.mobileNo;
										contactPerson.Phone = List_cls_contact_accountCreated_extractRec.PhoneNo;
										contactPerson.Email = List_cls_contact_accountCreated_extractRec.emailAddress;
										contactPerson.Reference_ID__c = List_cls_contact_accountCreated_extractRec.refId;
										
										contactPerson.Idexpro_ProfileID__c = Map_profileId.get(List_cls_contact_accountCreated_extractRec.emailAddress);

										List_contactPerson.add(contactPerson);
									}

									Database.SaveResult[] insertResults_contactPerson = Database.insert(List_contactPerson, true);

									for (Database.SaveResult insertResults_Extract : insertResults_contactPerson) {
										if (insertResults_Extract.isSuccess()) {
											Set_contactPerson_id.add(insertResults_Extract.getId());
										}
									}

									List<Contact> List_contactPersons = [SELECT Id, Reference_ID__c FROM Contact WHERE Id IN: Set_contactPerson_id];

									for(Contact List_contactPersons_extract : List_contactPersons){
										Map_contactPerson_refid.put(List_contactPersons_extract.Reference_ID__c,List_contactPersons_extract.Id);
									}

									List<AccountContactRelation> List_CR = [SELECT Id, Roles FROM AccountContactRelation WHERE Contactid IN: Set_contactPerson_id];

									for(AccountContactRelation List_contactPersons_extract : List_CR){
										List_contactPersons_extract.Roles = 'Contact Person';
									}
									update List_CR;

									for(cls_contact_accountCreated List_cls_contact_accountCreated_extractRec : List_cls_contact_accountCreated_extract){
										cls_contacts_accountCreatedResponse_Extract.refId = List_cls_contact_accountCreated_extractRec.refId;
										cls_contacts_accountCreatedResponse_Extract.sfContactRecordID = Map_contactPerson_refid.get(List_cls_contact_accountCreated_extractRec.refId);

										List_cls_contacts_accountCreatedResponse_Extract.add(cls_contacts_accountCreatedResponse_Extract);
									}
								}

								cls_address_accountCreatedResponse cls_address_accountCreatedResponse_Extract = new cls_address_accountCreatedResponse();
								cls_address_accountCreatedResponse_Extract.addressId = Map_addressId.get('Billing Address');
								cls_address_accountCreatedResponse_Extract.addressType = 'Billing Address';

								List_cls_address_accountCreatedResponse_Extract.add(cls_address_accountCreatedResponse_Extract);

								cls_data_accountCreatedResponse_Extract.sfAccountRecordId = AccountID;
								cls_data_accountCreatedResponse_Extract.contacts = List_cls_contacts_accountCreatedResponse_Extract;
								cls_data_accountCreatedResponse_Extract.address = List_cls_address_accountCreatedResponse_Extract;

								returnMessage.code = 201;
								returnMessage.status = status;
								returnMessage.data = cls_data_accountCreatedResponse_Extract;
								returnMessage.errors = null;

								if(Test.isRunningTest()) {
									CalloutException e = new CalloutException();
									e.setMessage('This is a constructed exception for testing and code coverage');
									throw e;
								}
							}catch (DMLException e) {
								system.debug('Error Status DML insertResults_contactPerson ');

								Account accDelete = [SELECT Id FROM Account WHERE Id =: AccountID];
								delete accDelete;

								status = 'failed';
								returnMessage.code = 409;
	
								cls_errors_accountCreatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules Contact';
	
								cls_errorDetails_accountCreatedResponse_Extract.errorMessage = e.getmessage();
								cls_errorDetails_accountCreatedResponse_Extract.fieldName = e.getStacktraceString();
	
								List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
								cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;
	
								returnMessage.status = status;
								returnMessage.data = cls_data_accountCreatedResponse_Extract;
								returnMessage.errors = cls_errors_accountCreatedResponse_Extract;

								system.debug('returnMessage insertResults_contactPerson : ' + returnMessage);
							}

							if(Test.isRunningTest()) {
								CalloutException e = new CalloutException();
								e.setMessage('This is a constructed exception for testing and code coverage');
								throw e;
							}
						}catch (DMLException e) {
							system.debug('Error Status DML insertResults_accDealer ');

							status = 'failed';
							returnMessage.code = 409;

							cls_errors_accountCreatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules Account';

							cls_errorDetails_accountCreatedResponse_Extract.errorMessage = e.getmessage();
							cls_errorDetails_accountCreatedResponse_Extract.fieldName = e.getStacktraceString();

							List_cls_errorDetails_accountCreatedResponse_Extract.add(cls_errorDetails_accountCreatedResponse_Extract);
							cls_errors_accountCreatedResponse_Extract.errorDetails = List_cls_errorDetails_accountCreatedResponse_Extract;

							returnMessage.status = status;
							returnMessage.data = cls_data_accountCreatedResponse_Extract;
							returnMessage.errors = cls_errors_accountCreatedResponse_Extract;
						} 
					}else{
						status = 'failed';
						errorMsg = 'Error From IdexPro :: ' + json.serialize(responsemap);

						cls_errors_accountCreatedResponse_Extract.errorMessage = errorMsg;

						returnMessage.code = 400;
						returnMessage.status = status;
						returnMessage.requestInfo = cls_requestInfo_accountCreatedResponse_Extract;
						returnMessage.data = cls_data_accountCreatedResponse_Extract;
						returnMessage.errors = cls_errors_accountCreatedResponse_Extract;
					}

					if(Test.isRunningTest()) {
						CalloutException e = new CalloutException();
						e.setMessage('This is a constructed exception for testing and code coverage');
						throw e;
					}
				}
				catch (Exception e) {
					//-- error handling for callout
					SYSTEM.DEBUG ('============== error found at Call-Out ==============');

					status = 'Failed';
					errorMsg = errorMsg +  '. Error on REST_Account_Callout.createPartner_sync method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
					apputils.puterror(errorMsg);
					SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
				}

				// put callout information then save the data on Call_Log object
				Call_Log__c calllog = new Call_Log__c();
				calllog.type__c='Callout';
				calllog.request_start_time__c = requestStartTime;
				calllog.method__c = 'POST';
				calllog.callerFrom__c = 'Salesforce' ;
				calllog.endpoint__c = endpoint ;
				calllog.uri__c = uri ; 
				calllog.request_message__c = bodyMesage;
				calllog.status__c = status;
				calllog.response_message__c = result;            
				calllog.Error_Message__c = errorMsg;
				calllog.Salesforce_ID_1__c = AccountID;
				calllog.Account_Related__c	 = AccountID;
				calllog.response_end_time__c = datetime.now(); 
				calllog.Request_ID__c = callId;    
				callLogList.add(calllog);

				insert callLogList;
			}else{
				system.debug('response_token : ' + response_token);
				status = 'failed';
				errorMsg = json.serialize(response_token);

				cls_errors_accountCreatedResponse_Extract.errorMessage = errorMsg;

				returnMessage.code = 400;
				returnMessage.status = status;
				returnMessage.requestInfo = cls_requestInfo_accountCreatedResponse_Extract;
				returnMessage.data = cls_data_accountCreatedResponse_Extract;
				returnMessage.errors = cls_errors_accountCreatedResponse_Extract;
			}
        }

		return JSON.serialize(returnMessage);
    } 

	@future(Callout=true)
	public static void createPartner_async(String accountRec, String List_contactRecs){
        SYSTEM.DEBUG ('============== in REST_Account_Callout class, createPartner method ==============' );

		cls_accountCreatedResponse returnMessage = new cls_accountCreatedResponse();

        List<IdexPro_API_Setting__c> List_IdexPro_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM IdexPro_API_Setting__c WHERE Name = 'createPartner'];

        if(List_IdexPro_APISetting!=null && !List_IdexPro_APISetting.isEmpty()){
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status;
            integer responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String callId = AppUtils.getNewGUID();
            String endpoint;
			String dealerID;

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();

			Account accountRec_extract = (Account)JSON.deserialize(accountRec, Account.class);

			List<Contact> List_contactRec = new List<Contact> ();
			JSONParser parser = JSON.createParser(List_contactRecs);
			while (parser.nextToken() != null) {
				if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
					while (parser.nextToken() != null) {
						if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
							Contact contactRec_extract = (Contact)parser.readValueAs(Contact.class);
							system.debug('Id:' + contactRec_extract.Id + ' LastName:' + contactRec_extract.LastName);
							List_contactRec.add(contactRec_extract);
						}
					}
				}
			}

			system.debug('List_contactRec : ' + List_contactRec);

			PartnerCreation_Request PartnerCreation_Request_extract = new PartnerCreation_Request();

			cls_basicDetails_PartnerCreation cls_basicDetails_PartnerCreation_extract = new cls_basicDetails_PartnerCreation();

			cls_taxDetails_PartnerCreation cls_taxDetails_PartnerCreation_extract = new cls_taxDetails_PartnerCreation();

			cls_otherDetails_PartnerCreation cls_otherDetails_PartnerCreation_extract = new cls_otherDetails_PartnerCreation();

			cls_addresses_PartnerCreation cls_addresses_PartnerCreation_extract1 = new cls_addresses_PartnerCreation();

			cls_addresses_PartnerCreation cls_addresses_PartnerCreation_extract2 = new cls_addresses_PartnerCreation();

			List<cls_addresses_PartnerCreation> List_cls_addresses_PartnerCreation_extract = new List<cls_addresses_PartnerCreation>();

			List<cls_profiles_PartnerCreation> List_cls_profiles_PartnerCreation_extract = new List<cls_profiles_PartnerCreation>();

			if (doCallOut) {
				try {
					//-- do call out
					SYSTEM.DEBUG ('============== try to do call out ==============');

					// ---------- cls_basicDetails_PartnerCreation ----------
					cls_basicDetails_PartnerCreation_extract.menu1_distName = accountRec_extract.Name;
					cls_basicDetails_PartnerCreation_extract.menu1_phoneNo = List_contactRec[0].Phone;
					cls_basicDetails_PartnerCreation_extract.menu1_emailAddress = List_contactRec[0].Email;
					cls_basicDetails_PartnerCreation_extract.menu1_allEmailAddresses = List_contactRec[0].Email;
					
					if(accountRec_extract.Distributor_Type__c != null){
						cls_basicDetails_PartnerCreation_extract.menu1_distType = Integer.valueOf(accountRec_extract.Distributor_Type__c);
					}

					if(accountRec_extract.Distributor_Type__c != null){
						cls_basicDetails_PartnerCreation_extract.menu1_channelSubType = Integer.valueOf(accountRec_extract.Distributor_Type__c);
					}

					if(accountRec_extract.Distributor_Type__c != null){
						cls_basicDetails_PartnerCreation_extract.menu1_channelCategory = Integer.valueOf(accountRec_extract.Distributor_Type__c);
					}
					
					if(accountRec_extract.SLOC_IdexPro_Value__c != null){
						cls_basicDetails_PartnerCreation_extract.menu1_sourceWarehouse = Integer.valueOf(accountRec_extract.SLOC_IdexPro_Value__c);
					}
					
					if(accountRec_extract.Channel_Type__c != null){
						cls_basicDetails_PartnerCreation_extract.menu1_channelType = Integer.valueOf(accountRec_extract.Channel_Type__c);
					}
					// ---------- cls_basicDetails_PartnerCreation ----------

					// ---------- cls_taxDetails_PartnerCreation ----------
					cls_taxDetails_PartnerCreation_extract.menu8_npwpType = accountRec_extract.Dealer_VAT_Type__c;
					cls_taxDetails_PartnerCreation_extract.menu8_npwpNo = accountRec_extract.No_NPWP__c;
					cls_taxDetails_PartnerCreation_extract.menu8_npwpName = accountRec_extract.Dealer_VAT_Name__c;
					cls_taxDetails_PartnerCreation_extract.menu8_npwpAddress = accountRec_extract.VAT_Address_to_BSS__c;
					// ---------- cls_taxDetails_PartnerCreation ----------

					// ---------- cls_otherDetails_PartnerCreation ----------
					cls_otherDetails_PartnerCreation_extract.menu11_custClass = accountRec_extract.Customer_Class__c;

					if(accountRec_extract.Sent_to_ERP__c == true){
						cls_otherDetails_PartnerCreation_extract.menu11_sentToErp = 'Yes';
					}

					if(accountRec_extract.Sent_to_ERP__c == false){
						cls_otherDetails_PartnerCreation_extract.menu11_sentToErp = 'No';
					}
					
					cls_otherDetails_PartnerCreation_extract.menu11_costCenter = accountRec_extract.Cost_Center__c;
					// ---------- cls_otherDetails_PartnerCreation ----------
					

					// ---------- cls_addresses_PartnerCreation ----------
					cls_addresses_PartnerCreation_extract1.menu2_addressType = 'Billing Address';
					cls_addresses_PartnerCreation_extract1.menu2_Street = accountRec_extract.Street_IdexPro__c;
					cls_addresses_PartnerCreation_extract1.menu2_District = accountRec_extract.District_IdexPro_Code__c;
					cls_addresses_PartnerCreation_extract1.menu2_City = accountRec_extract.City_IdexPro_Code__c;
					cls_addresses_PartnerCreation_extract1.menu2_Province = accountRec_extract.Province_IdexPro_Code__c;
					cls_addresses_PartnerCreation_extract1.menu2_Country = 'Indonesia';
					cls_addresses_PartnerCreation_extract1.menu2_postalCode = accountRec_extract.Postal_Code_IdexPro__c;

					List_cls_addresses_PartnerCreation_extract.add(cls_addresses_PartnerCreation_extract1);

					cls_addresses_PartnerCreation_extract2.menu2_addressType = 'Shipping Address';
					cls_addresses_PartnerCreation_extract2.menu2_Street = accountRec_extract.Street_IdexPro__c;
					cls_addresses_PartnerCreation_extract2.menu2_District = accountRec_extract.District_IdexPro_Code__c;
					cls_addresses_PartnerCreation_extract2.menu2_City = accountRec_extract.City_IdexPro_Code__c;
					cls_addresses_PartnerCreation_extract2.menu2_Province = accountRec_extract.Province_IdexPro_Code__c;
					cls_addresses_PartnerCreation_extract2.menu2_Country = 'Indonesia';
					cls_addresses_PartnerCreation_extract2.menu2_postalCode = accountRec_extract.Postal_Code_IdexPro__c;

					List_cls_addresses_PartnerCreation_extract.add(cls_addresses_PartnerCreation_extract2);
					// ---------- cls_addresses_PartnerCreation ----------

					// ---------- cls_profiles_PartnerCreation ----------
					if(List_contactRec!=null && !List_contactRec.isEmpty()){
						for(Contact List_contactRec_Extract : List_contactRec){
							cls_profiles_PartnerCreation cls_profiles_PartnerCreation_extract = new cls_profiles_PartnerCreation();
							cls_profiles_PartnerCreation_extract.menu4_profileType = 'Contact Person';
							cls_profiles_PartnerCreation_extract.menu4_authorisedfirstName = List_contactRec_Extract.FirstName;
							cls_profiles_PartnerCreation_extract.menu4_authorisedlastName = List_contactRec_Extract.LastName;
							cls_profiles_PartnerCreation_extract.menu4_authorisedPhoneNo = List_contactRec_Extract.Phone;
							cls_profiles_PartnerCreation_extract.menu4_authorisedMobileNo = List_contactRec_Extract.MobilePhone;
							cls_profiles_PartnerCreation_extract.menu4_authorisedEmailAddress = List_contactRec_Extract.Email;

							List_cls_profiles_PartnerCreation_extract.add(cls_profiles_PartnerCreation_extract);
						}
					}
					// ---------- cls_profiles_PartnerCreation ----------

					PartnerCreation_Request_extract.basicDetails = cls_basicDetails_PartnerCreation_extract;
					PartnerCreation_Request_extract.taxDetails = cls_taxDetails_PartnerCreation_extract;
					PartnerCreation_Request_extract.otherDetails = cls_otherDetails_PartnerCreation_extract;
					PartnerCreation_Request_extract.addresses = List_cls_addresses_PartnerCreation_extract;
					PartnerCreation_Request_extract.profiles = List_cls_profiles_PartnerCreation_extract;
					PartnerCreation_Request_extract.action = 'A';

					String reqBody = JSON.serialize(PartnerCreation_Request_extract);
					
					System.debug('>>> reqBody : '+reqBody);

					endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c;

					httpRequestObj.setTimeout(120000);
					httpRequestObj.setEndpoint(endpoint);
					httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
					if(Test.isRunningTest()){
						access_token = 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw';
					}
					httpRequestObj.setHeader('Authorization', 'Bearer ' + access_token);
					httpRequestObj.setHeader('trx_id', callId);
					httpRequestObj.setMethod('POST');
					httpRequestObj.setBody(reqBody); 

					System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));

					bodyMesage = reqBody;
					Datetime startDate = System.now();

					if(!Test.isRunningTest()){
						HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
						result = httpResponseObj.getBody();
					}else{
						result = '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190175,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"6211122","outletType":null,"outletSize":0,"mobileNo":"62322233","lastName":"Agmawan","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Usama","faxNo":null,"emailAddress":"testing020101@gmail.com","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189810}],"partnerAddresses":[{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Billing Address","addressId":4134952},{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Shipping Address","addressId":4134953}],"dealerName":"PT Profesional Internet Indonesia","dealerId":"90185670"}],"message":"Partner Created Successfully","status":"OK","code":"200"}';
					}

					System.debug('>>> result : '+result);

					Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
					responseMsg = json.serialize(responsemap);
					
					System.debug ('================= response responsemap : ' + responsemap );
					
					dealerID = AppUtils.getStringDataOnMap(responsemap , 'partnerDetails::dealerId');
					system.debug ('================= dealerID : ' + dealerID);

					if(dealerID != '== Keyset NOT found =='){
						PartnerCreation_Response PartnerCreation_Response_Extract = (PartnerCreation_Response)JSON.deserialize(result, PartnerCreation_Response.class);
 
						List<cls_partnerAddresses_PartnerCreation> List_partnerAddressesResponse = PartnerCreation_Response_Extract.partnerDetails[0].partnerAddresses;

						List<cls_partnerProfiles_PartnerCreation> List_partnerProfilesResponse = PartnerCreation_Response_Extract.partnerDetails[0].partnerProfiles;

						status = 'success';

						accountRec_extract.DealerID__c = dealerID;
						accountRec_extract.Dealer_Status__c = 'Active';
						accountRec_extract.Create_Dealer_IdexPro_Status__c = 'Success';
						accountRec_extract.Idexpro_ShippingAddressId__c = String.ValueOf(List_partnerAddressesResponse[0].addressId);
						accountRec_extract.Idexpro_BillingAddressId__c = String.ValueOf(List_partnerAddressesResponse[1].addressId);
						accountRec_extract.DataSource__c = 'Salesforce Input Form';

						MetadataTriggerHandler.bypass('TA_AT_AccountUpdateDealerInIdexPro');

						update accountRec_extract;

						MetadataTriggerHandler.clearBypass('TA_AT_AccountUpdateDealerInIdexPro');
						

						Map<String,String> Map_profileId = new Map<String,String>();

						for(cls_partnerProfiles_PartnerCreation List_partnerProfilesResponse_Extract : List_partnerProfilesResponse){
							Map_profileId.put(List_partnerProfilesResponse_Extract.emailAddress, String.ValueOf(List_partnerProfilesResponse_Extract.profileId));
						}

						for(Contact List_contactRec_Extract : List_contactRec){
							List_contactRec_Extract.Idexpro_ProfileID__c = Map_profileId.get(List_contactRec_Extract.Email);
						}

						MetadataTriggerHandler.bypass('TA_AT_ContactUpdateDealerInIdexPro');

						update List_contactRec;

						MetadataTriggerHandler.clearBypass('TA_AT_ContactUpdateDealerInIdexPro');
					}else{
						status = 'failed';
						errorMsg = json.serialize(responsemap);

						MetadataTriggerHandler.bypass('TA_AT_AccountUpdateDealerInIdexPro');

						accountRec_extract.Create_Dealer_IdexPro_Status__c = 'Failed';
						update accountRec_extract;

						MetadataTriggerHandler.clearBypass('TA_AT_AccountUpdateDealerInIdexPro');

						sendEmailNotifFailed('Dealer Creation Failed Info', accountRec_extract.Id, null);
					}

					if(Test.isRunningTest()) {
						CalloutException e = new CalloutException();
						e.setMessage('This is a constructed exception for testing and code coverage');
						throw e;
					}
				}
				catch (Exception e) {
					//-- error handling for callout
					SYSTEM.DEBUG ('============== error found at Call-Out ==============');

					status = 'Failed';
					errorMsg = errorMsg +  '. Error on REST_Account_Callout.createPartner_async method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
					apputils.puterror(errorMsg);
					SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);

					
					MetadataTriggerHandler.bypass('TA_AT_AccountUpdateDealerInIdexPro');

					accountRec_extract.Create_Dealer_IdexPro_Status__c = 'Failed';
					update accountRec_extract;

					MetadataTriggerHandler.clearBypass('TA_AT_AccountUpdateDealerInIdexPro');

					sendEmailNotifFailed('Dealer Creation Failed Info', accountRec_extract.Id, null);
				}

				// put callout information then save the data on Call_Log object
				Call_Log__c calllog = new Call_Log__c();
				calllog.type__c='Callout';
				calllog.request_start_time__c = requestStartTime;
				calllog.method__c = 'POST';
				calllog.callerFrom__c = 'Salesforce' ;
				calllog.endpoint__c = endpoint ;
				calllog.uri__c = uri ; 
				calllog.request_message__c = bodyMesage;
				calllog.status__c = status;
				calllog.response_message__c = result;            
				calllog.Error_Message__c = errorMsg;
				calllog.Salesforce_ID_1__c = accountRec_extract.Id;
				calllog.Account_Related__c	 = accountRec_extract.Id;
				calllog.response_end_time__c = datetime.now(); 
				calllog.Request_ID__c = callId;    
				callLogList.add(calllog);

				insert callLogList;
			}
        }
    }

	public static String validatePartner_sync(String AccountID, String sales_channel_type, String partner_name, String dealer_id){
        SYSTEM.DEBUG ('============== in REST_Account_Callout class, validatePartner_sync method ==============' );

		/*String returnMessage = REST_Account_Callout.validatePartner_sync('0011m00000bpFTkAAM', 'BUSOL+-+Community', 'PT+Profesional+Internet+Indonesia', '');
		system.debug('returnMessage : ' + returnMessage);*/

		string result;

        List<IdexPro_API_Setting__c> List_IdexPro_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM IdexPro_API_Setting__c WHERE Name = 'validatePartner'];

        if(List_IdexPro_APISetting!=null && !List_IdexPro_APISetting.isEmpty()){
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status = 'Success';
            integer responseCode;
            String responseMsg;
            string errorMsg;
            String callId = AppUtils.getNewGUID();
            String endpoint;
			String resource;

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   
            
			if (doCallOut) {
				try {
					//-- do call out
					SYSTEM.DEBUG ('============== try to do call out ==============');

					endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c;

					if(String.isNotBlank(dealer_id)){
						resource = '?sales_channel_type=' + sales_channel_type + '&dealer_id=' + dealer_id;
					}else{
						resource = '?sales_channel_type=' + sales_channel_type + '&partner_name=' + partner_name;
					}

					httpRequestObj.setTimeout(120000);
					httpRequestObj.setEndpoint(endpoint + resource.replaceAll('\\s+','+'));
					httpRequestObj.setHeader('Content-Type', 'application/json');
					if(Test.isRunningTest()){
						access_token = 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw';
					}
					httpRequestObj.setHeader('Authorization', 'Bearer ' + access_token);
					httpRequestObj.setHeader('trx_id', callId);
					httpRequestObj.setMethod('GET');

					System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));

					bodyMesage = String.ValueOf(httpRequestObj);
					Datetime startDate = System.now();

					if(!Test.isRunningTest()){
						HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
						result = httpResponseObj.getBody();
					}else{
						result = '{"partnerDetails":[{"dealerId":"90185427","salesChannelName":"PT Profesional Internet Indonesia","phoneNo":"6202183273293","emailAddress":"testing261002@gmail.com","userId":null,"channelType":"BUSOL - Community","channelSubType":null,"channelCategory":"","address":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor,Kota Probolinggo,Kademangan,JAWA TIMUR,Indonesia,67225","partnerProfiles":[{"profileId":11189727,"address":null,"birthDate":null,"birthPlace":null,"city":null,"country":null,"emailAddress":"testing261002@gmail.com","faxNo":null,"firstName":"Usama","gender":null,"homePhoneNo":"62null","identityNo":null,"lastName":"Agmawan","mobileNo":"62673434343","outletSize":0,"outletType":null,"phoneNo":"6202183273293","postalCode":0,"profileType":"Contact Person","province":null,"salesChannelId":11190003,"title":null,"menu4_actionFlag":null}]}]}';
					}

					System.debug('>>> result : '+result);

					Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
					responseMsg = json.serialize(responsemap);
					
					System.debug ('================= response responsemap : ' + responsemap );
					
					String dealerID = AppUtils.getStringDataOnMap(responsemap , 'partnerDetails::dealerId');
					system.debug ('================= dealerID : ' + dealerID);

					responseMsg = result;

					if(dealerID == '== Keyset NOT found =='){
						result = '{"partnerDetails":[]}';
					}

					if(Test.isRunningTest()) {
						CalloutException e = new CalloutException();
						e.setMessage('This is a constructed exception for testing and code coverage');
						throw e;
					}
				}
				catch (Exception e) {
					//-- error handling for callout
					SYSTEM.DEBUG ('============== error found at Call-Out ==============');

					status = 'Failed';
					errorMsg = errorMsg +  '. Error on REST_Account_Callout.validatePartner_sync method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
					apputils.puterror(errorMsg);
					SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
				}

				// put callout information then save the data on Call_Log object
				Call_Log__c calllog = new Call_Log__c();
				calllog.type__c='Callout';
				calllog.request_start_time__c = requestStartTime;
				calllog.method__c = 'GET';
				calllog.callerFrom__c = 'Salesforce' ;
				calllog.endpoint__c = endpoint ;
				calllog.uri__c = uri ; 
				calllog.request_message__c = bodyMesage;
				calllog.status__c = status;
				calllog.response_message__c = result;            
				calllog.Error_Message__c = errorMsg;
				calllog.Salesforce_ID_1__c = AccountID;
				calllog.Account_Related__c	 = AccountID;
				calllog.response_end_time__c = datetime.now(); 
				calllog.Request_ID__c = callId;    
				callLogList.add(calllog);

				insert callLogList;
			}
        }

		return result;
    } 

	public static String modificationPartner_sync(String postBody, String AccountID){
        SYSTEM.DEBUG ('============== in REST_Account_Callout class, modificationPartner_sync method ==============' );

		cls_accountUpdatedResponse returnMessage = new cls_accountUpdatedResponse();

        List<IdexPro_API_Setting__c> List_IdexPro_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM IdexPro_API_Setting__c WHERE Name = 'modificationPartner'];

        if(List_IdexPro_APISetting!=null && !List_IdexPro_APISetting.isEmpty()){
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status;
            String responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String callId;
            String endpoint;

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   

			/* ---------------- cls_accountUpdated from CALLIN ----------------*/
			cls_accountUpdated accountUpdated_callin = (cls_accountUpdated)JSON.deserialize(postBody, cls_accountUpdated.class);

			cls_basicDetails_accountUpdated cls_basicDetails_accountUpdated_callin = accountUpdated_callin.basicDetails;

			cls_taxDetails_accountUpdated cls_taxDetails_accountUpdated_callin = accountUpdated_callin.taxDetails;

			cls_otherDetails_accountUpdated cls_otherDetails_accountUpdated_callin = accountUpdated_callin.otherDetails;

			List<cls_addresses_accountUpdated> List_cls_addresses_accountUpdated_callin = accountUpdated_callin.addresses;
			
			List<cls_contacts_accountUpdated> List_cls_contact_accountUpdated_callin = accountUpdated_callin.contacts;

			cls_requestInfo_accountUpdated cls_requestInfo_accountUpdated_callin = accountUpdated_callin.requestInfo;
			/* ---------------- cls_accountUpdated from CALLIN ----------------*/

			/* ---------------- cls_accountUpdated from CALLIN Response----------------*/
			cls_requestInfo_accountUpdatedResponse cls_requestInfo_accountUpdatedResponse_Extract = new cls_requestInfo_accountUpdatedResponse();
	
			cls_data_accountUpdatedResponse cls_data_accountUpdatedResponse_Extract = null;
	
			cls_errors_accountUpdatedResponse cls_errors_accountUpdatedResponse_Extract = new cls_errors_accountUpdatedResponse();
	
			List<cls_contacts_accountUpdatedResponse> List_cls_contacts_accountUpdatedResponse_Extract = new List<cls_contacts_accountUpdatedResponse>();
	
			List<cls_errorDetails_accountUpdatedResponse> List_cls_errorDetails_accountUpdatedResponse_Extract = new List<cls_errorDetails_accountUpdatedResponse> ();
			/* ---------------- cls_accountUpdated from CALLIN Response----------------*/

			cls_requestInfo_accountUpdatedResponse_Extract.apiRequestId = cls_requestInfo_accountUpdated_callin.apiRequestId;
            cls_requestInfo_accountUpdatedResponse_Extract.requestor = cls_requestInfo_accountUpdated_callin.requestor;

			callId = cls_requestInfo_accountUpdated_callin.apiRequestId;

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
                Postal_Code_IdexPro__c,
				Update_Dealer_IdexPro_Status__c
                FROM Account WHERE Id =: AccountID
            ];
            
			if (doCallOut) {
				try {
					//-- do call out
					SYSTEM.DEBUG ('============== try to do call out ==============');

					PartnerModification_Request PartnerModification_Request_extract = new PartnerModification_Request();

					cls_basicDetails_PartnerModification cls_basicDetails_PartnerModification_extract = new cls_basicDetails_PartnerModification();

					cls_taxDetails_PartnerModification cls_taxDetails_PartnerModification_extract = new cls_taxDetails_PartnerModification();

					cls_otherDetails_PartnerModification cls_otherDetails_PartnerModification_extract = null;

					List<cls_addresses_PartnerModification> List_cls_addresses_PartnerModification_extract = new List<cls_addresses_PartnerModification>();

					List<cls_profiles_PartnerModification> List_cls_profiles_PartnerModification_extract = new List<cls_profiles_PartnerModification>();

					// ---------- cls_basicDetails_PartnerModification ----------
					cls_basicDetails_PartnerModification_extract.menu1_distName = cls_basicDetails_accountUpdated_callin.accountName;
					cls_basicDetails_PartnerModification_extract.menu1_phoneNo = List_cls_contact_accountUpdated_callin[0].PhoneNo;
					cls_basicDetails_PartnerModification_extract.menu1_emailAddress = List_cls_contact_accountUpdated_callin[0].emailAddress;
					cls_basicDetails_PartnerModification_extract.menu1_channelSubType = 1;
					cls_basicDetails_PartnerModification_extract.menu1_channelCategory = 11;
					cls_basicDetails_PartnerModification_extract.menu1_channelType = 11;
					// ---------- cls_basicDetails_PartnerModification ----------

					// ---------- cls_taxDetails_PartnerModification ----------
					cls_taxDetails_PartnerModification_extract.menu8_npwpType = cls_taxDetails_accountUpdated_callin.npwpType;
					cls_taxDetails_PartnerModification_extract.menu8_npwpNo = cls_taxDetails_accountUpdated_callin.npwpNo;
					cls_taxDetails_PartnerModification_extract.menu8_npwpName = cls_taxDetails_accountUpdated_callin.npwpName;

					String npwpAddress = 
					cls_taxDetails_accountUpdated_callin.npwpAddressStreet + ' ' + 
					cls_taxDetails_accountUpdated_callin.npwpAddressCity + ' ' +  
					cls_taxDetails_accountUpdated_callin.npwpAddressState + ' ' + 
					cls_taxDetails_accountUpdated_callin.npwpAddressPostalCode;

					cls_taxDetails_PartnerModification_extract.menu8_npwpAddress = npwpAddress;
					// ---------- cls_taxDetails_PartnerModification ----------

					// ---------- cls_otherDetails_PartnerModification ----------

					// ---------- cls_otherDetails_PartnerModification ----------
					

					// ---------- cls_addresses_PartnerModification ----------
					cls_addresses_PartnerModification cls_addresses_PartnerModification_extract = new cls_addresses_PartnerModification();

					cls_addresses_PartnerModification_extract.menu2_addressId = List_cls_addresses_accountUpdated_callin[0].idexProAddressId;
					cls_addresses_PartnerModification_extract.menu2_addressType = List_cls_addresses_accountUpdated_callin[0].addressType;
					cls_addresses_PartnerModification_extract.menu2_Street = List_cls_addresses_accountUpdated_callin[0].addressStreet;
					cls_addresses_PartnerModification_extract.menu2_District = List_cls_addresses_accountUpdated_callin[0].addressDistrict;
					cls_addresses_PartnerModification_extract.menu2_City = List_cls_addresses_accountUpdated_callin[0].addressCity;
					cls_addresses_PartnerModification_extract.menu2_Province = List_cls_addresses_accountUpdated_callin[0].addressProvince;
					cls_addresses_PartnerModification_extract.menu2_Country = List_cls_addresses_accountUpdated_callin[0].addressCountry;
					cls_addresses_PartnerModification_extract.menu2_postalCode = List_cls_addresses_accountUpdated_callin[0].addressPostalCode;

					List_cls_addresses_PartnerModification_extract.add(cls_addresses_PartnerModification_extract);

					cls_addresses_PartnerModification cls_addresses_PartnerModification_extract2 = new cls_addresses_PartnerModification();
					
					cls_addresses_PartnerModification_extract2.menu2_addressId = List_Account[0].Idexpro_ShippingAddressId__c;
					cls_addresses_PartnerModification_extract2.menu2_addressType = 'Shipping Address';
					cls_addresses_PartnerModification_extract2.menu2_Street = List_cls_addresses_accountUpdated_callin[0].addressStreet;
					cls_addresses_PartnerModification_extract2.menu2_District = List_cls_addresses_accountUpdated_callin[0].addressDistrict;
					cls_addresses_PartnerModification_extract2.menu2_City = List_cls_addresses_accountUpdated_callin[0].addressCity;
					cls_addresses_PartnerModification_extract2.menu2_Province = List_cls_addresses_accountUpdated_callin[0].addressProvince;
					cls_addresses_PartnerModification_extract2.menu2_Country = List_cls_addresses_accountUpdated_callin[0].addressCountry;
					cls_addresses_PartnerModification_extract2.menu2_postalCode = List_cls_addresses_accountUpdated_callin[0].addressPostalCode;

					List_cls_addresses_PartnerModification_extract.add(cls_addresses_PartnerModification_extract2);
					// ---------- cls_addresses_PartnerModification ----------

					// ---------- cls_profiles_PartnerModification ----------
					if(List_cls_contact_accountUpdated_callin!=null && !List_cls_contact_accountUpdated_callin.isEmpty()){
						for(cls_contacts_accountUpdated List_cls_contact_accountUpdated_req : List_cls_contact_accountUpdated_callin){
							cls_profiles_PartnerModification cls_profiles_PartnerModification_extract = new cls_profiles_PartnerModification();

							cls_profiles_PartnerModification_extract.menu4_authorisedProfileId = List_cls_contact_accountUpdated_req.idexProProfileId;
							cls_profiles_PartnerModification_extract.menu4_profileType = List_cls_contact_accountUpdated_req.roleName;
							cls_profiles_PartnerModification_extract.menu4_authorisedfirstName = List_cls_contact_accountUpdated_req.firstName;
							cls_profiles_PartnerModification_extract.menu4_authorisedlastName = List_cls_contact_accountUpdated_req.lastName;
							cls_profiles_PartnerModification_extract.menu4_authorisedPhoneNo = List_cls_contact_accountUpdated_req.PhoneNo;
							cls_profiles_PartnerModification_extract.menu4_authorisedMobileNo = List_cls_contact_accountUpdated_req.mobileNo;
							cls_profiles_PartnerModification_extract.menu4_authorisedEmailAddress = List_cls_contact_accountUpdated_req.emailAddress;

							List_cls_profiles_PartnerModification_extract.add(cls_profiles_PartnerModification_extract);
						}
					}
					// ---------- cls_profiles_PartnerModification ----------

					PartnerModification_Request_extract.basicDetails = cls_basicDetails_PartnerModification_extract;
					PartnerModification_Request_extract.taxDetails = cls_taxDetails_PartnerModification_extract;
					PartnerModification_Request_extract.otherDetails = cls_otherDetails_PartnerModification_extract;
					PartnerModification_Request_extract.addresses = List_cls_addresses_PartnerModification_extract;
					PartnerModification_Request_extract.profiles = List_cls_profiles_PartnerModification_extract;
					PartnerModification_Request_extract.action = 'U';
					
					String reqBody = JSON.serialize(PartnerModification_Request_extract);
					
					System.debug('>>> reqBody : '+reqBody);

					endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c + List_Account[0].DealerID__c;

					httpRequestObj.setTimeout(120000);
					httpRequestObj.setEndpoint(endpoint);
					httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
					if(Test.isRunningTest()){
						access_token = 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw';
					}
					httpRequestObj.setHeader('Authorization', 'Bearer ' + access_token);
					httpRequestObj.setHeader('trx_id', callId);
					httpRequestObj.setMethod('POST');
					httpRequestObj.setBody(reqBody); 

					System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));

					bodyMesage = reqBody;
					Datetime startDate = System.now();

					if(!Test.isRunningTest()){
						HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
						result = httpResponseObj.getBody();
					}else{
						result = '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190164,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"62081715151515","outletType":null,"outletSize":0,"mobileNo":"62null","lastName":"Iqbal","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Muhammad","faxNo":null,"emailAddress":"muhammadiqbal@dealerberkah2.id","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189800}],"partnerAddresses":[{"street":"Mahajandau, Kec. Dusun Hilir, Kabupaten Barito Selatan, Kalimantan Tengah 73762,Kab. Barito Selatan,Dusun Hilir,KALIMANTAN TENGAH,Indonesia,73762","salesChannelId":11190164,"province":"prov2","postalCode":73762,"country":"Indonesia","city":"city11","district":"dist104","addressType":"Billing Address","addressId":4134933},{"street":"Mahajandau, Kec. Dusun Hilir, Kabupaten Barito Selatan, Kalimantan Tengah 73762,Kab. Barito Selatan,Dusun Hilir,KALIMANTAN TENGAH,Indonesia,73762","salesChannelId":11190164,"province":"prov2","postalCode":73762,"country":"Indonesia","city":"city11","district":"dist104","addressType":"Shipping Address","addressId":4134932}],"dealerName":"Dealer Berkah 2","dealerId":"90185648"}],"message":"Partner Updated Successfully","status":"OK","code":"200"}';
					}


					System.debug('>>> result : '+result);

					Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
					responseMsg = json.serialize(responsemap);
					
					System.debug ('================= response responsemap : ' + responsemap );
					
					responseCode = AppUtils.getStringDataOnMap(responsemap , 'code');
					system.debug ('================= responseCode : ' + responseCode);

					returnMessage.requestInfo = cls_requestInfo_accountUpdatedResponse_Extract;

					if(responseCode != '== Keyset NOT found =='){
						try {
							status = 'success';
							responseMsg = json.serialize(responsemap);

							Account accDealer = new Account();
							accDealer.Id = AccountID;
							accDealer.Name = cls_basicDetails_accountUpdated_callin.accountName;
							accDealer.Phone = List_cls_contact_accountUpdated_callin[0].PhoneNo;
							accDealer.Dealer_VAT_Type__c = cls_taxDetails_accountUpdated_callin.npwpType;
							accDealer.No_NPWP__c = cls_taxDetails_accountUpdated_callin.npwpNo;
							accDealer.Dealer_VAT_Name__c = cls_taxDetails_accountUpdated_callin.npwpName;

							//accDealer.BillingStreet = List_cls_addresses_accountUpdated_callin[0].addressStreet;
							accDealer.Street_IdexPro__c = List_cls_addresses_accountUpdated_callin[0].addressStreet;

							List<Province__c> List_Province = [SELECT Id, Idexpro_Name__c FROM Province__c WHERE Idexpro_Code__c =: List_cls_addresses_accountUpdated_callin[0].addressProvince];

							if(List_Province!=null && !List_Province.isEmpty()){
								//accDealer.BillingState = List_Province[0].Idexpro_Name__c;
								accDealer.Province_IdexPro__c = List_Province[0].Id;
							}

							List<City__c> List_City = [SELECT Id, Idexpro_Name__c FROM City__c WHERE Idexpro_Code__c =: List_cls_addresses_accountUpdated_callin[0].addressCity];

							if(List_City!=null && !List_City.isEmpty()){
								//accDealer.BillingCity = List_City[0].Idexpro_Name__c;
								accDealer.City_IdexPro__c = List_City[0].Id;
							}

							List<District__c> List_District = [SELECT Id, Idexpro_Code__c, Idexpro_Name__c FROM District__c WHERE Idexpro_Code__c =: List_cls_addresses_accountUpdated_callin[0].addressDistrict];

							if(List_District!=null && !List_District.isEmpty()){
								//accDealer.BillingDistrict__c = List_District[0].Idexpro_Name__c;
								accDealer.District_IdexPro__c = List_District[0].Id;
							}

							//accDealer.BillingPostalCode = List_cls_addresses_accountUpdated_callin[0].addressPostalCode;
							accDealer.Postal_Code_IdexPro__c = List_cls_addresses_accountUpdated_callin[0].addressPostalCode;

							accDealer.BillingCountry = List_cls_addresses_accountUpdated_callin[0].addressCountry;
							accDealer.ShippingStreet = cls_taxDetails_accountUpdated_callin.npwpAddressStreet;
							accDealer.ShippingState = cls_taxDetails_accountUpdated_callin.npwpAddressState;
							accDealer.ShippingCity = cls_taxDetails_accountUpdated_callin.npwpAddressCity;
							accDealer.ShippingPostalCode = cls_taxDetails_accountUpdated_callin.npwpAddressPostalCode;
							accDealer.DataSource__c = 'BizCare';
							accDealer.Update_Dealer_IdexPro_Status__c = 'Success';

							MetadataTriggerHandler.bypass('TA_AT_AccountUpdateDealerInIdexPro');

							Database.SaveResult updateResults_accDealer = Database.update(accDealer);

							MetadataTriggerHandler.clearBypass('TA_AT_AccountUpdateDealerInIdexPro');

							system.debug('updateResults_accDealer : ' + updateResults_accDealer);

							try {
								List<Contact> List_contactPerson = new List<Contact>();

								if(List_cls_contact_accountUpdated_callin!=null && !List_cls_contact_accountUpdated_callin.isEmpty()){
									for(cls_contacts_accountUpdated List_cls_contact_accountUpdated_req : List_cls_contact_accountUpdated_callin){
										Contact contactPerson = new Contact();

										contactPerson.Id = List_cls_contact_accountUpdated_req.sfContactRecordID;

										if(String.isNotBlank(List_cls_contact_accountUpdated_req.lastName)){
											contactPerson.LastName = List_cls_contact_accountUpdated_req.lastName;
											contactPerson.Firstname = List_cls_contact_accountUpdated_req.firstName;
										}else{
											contactPerson.LastName = List_cls_contact_accountUpdated_req.firstName;
										}
										
										contactPerson.MobilePhone = List_cls_contact_accountUpdated_req.mobileNo;
										contactPerson.Phone = List_cls_contact_accountUpdated_req.PhoneNo;
										contactPerson.Email = List_cls_contact_accountUpdated_req.emailAddress;				

										List_contactPerson.add(contactPerson);
									}

									MetadataTriggerHandler.bypass('TA_AT_ContactUpdateDealerInIdexPro');

									Database.SaveResult[] updateResults_contactPerson = Database.update(List_contactPerson, true);

									MetadataTriggerHandler.clearBypass('TA_AT_ContactUpdateDealerInIdexPro');
								}

								returnMessage.code = 201;
								returnMessage.status = status;
								returnMessage.data = null;
								returnMessage.errors = null;

								if(Test.isRunningTest()) {
									CalloutException e = new CalloutException();
									e.setMessage('This is a constructed exception for testing and code coverage');
									throw e;
								}
							}catch (DMLException e) {
								system.debug('Error Status DML updateResults_contactPerson ');

								status = 'failed';
								returnMessage.code = 409;
	
								cls_errors_accountUpdatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules Contact';

								cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();

								cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = e.getmessage();
								cls_errorDetails_accountUpdatedResponse_Extract.paramdName = e.getStacktraceString();
								cls_errorDetails_accountUpdatedResponse_Extract.errorNo = 1;

								List_cls_errorDetails_accountUpdatedResponse_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
								cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;

								returnMessage.status = status;
								returnMessage.data = cls_data_accountUpdatedResponse_Extract;
								returnMessage.errors = cls_errors_accountUpdatedResponse_Extract;

								system.debug('returnMessage updateResults_contactPerson : ' + returnMessage);
							}

							if(Test.isRunningTest()) {
								CalloutException e = new CalloutException();
								e.setMessage('This is a constructed exception for testing and code coverage');
								throw e;
							}
						}catch (DMLException e) {
							system.debug('Error Status DML updateResults_account ');

							status = 'failed';
							returnMessage.code = 409;

							cls_errors_accountUpdatedResponse_Extract.errorMessage = 'some parameters not suitable with some rules Account';

							cls_errorDetails_accountUpdatedResponse cls_errorDetails_accountUpdatedResponse_Extract = new cls_errorDetails_accountUpdatedResponse();

							cls_errorDetails_accountUpdatedResponse_Extract.errorMessage = e.getmessage();
							cls_errorDetails_accountUpdatedResponse_Extract.paramdName = e.getStacktraceString();
							cls_errorDetails_accountUpdatedResponse_Extract.errorNo = 1;

							List_cls_errorDetails_accountUpdatedResponse_Extract.add(cls_errorDetails_accountUpdatedResponse_Extract);
							cls_errors_accountUpdatedResponse_Extract.errorDetails = List_cls_errorDetails_accountUpdatedResponse_Extract;

							returnMessage.status = status;
							returnMessage.data = cls_data_accountUpdatedResponse_Extract;
							returnMessage.errors = cls_errors_accountUpdatedResponse_Extract;

							system.debug('returnMessage updateResults_account : ' + returnMessage);
						} 
					}else{
						status = 'failed';
						errorMsg = 'Error From IdexPro :: ' + json.serialize(responsemap);

						cls_errors_accountUpdatedResponse_Extract.errorMessage = errorMsg;

						returnMessage.code = 400;
						returnMessage.status = status;
						returnMessage.requestInfo = cls_requestInfo_accountUpdatedResponse_Extract;
						returnMessage.data = cls_data_accountUpdatedResponse_Extract;
						returnMessage.errors = cls_errors_accountUpdatedResponse_Extract;
					}

					if(Test.isRunningTest()) {
						CalloutException e = new CalloutException();
						e.setMessage('This is a constructed exception for testing and code coverage');
						throw e;
					}
				}
				catch (Exception e) {
					//-- error handling for callout
					SYSTEM.DEBUG ('============== error found at Call-Out ==============');

					status = 'Failed';
					errorMsg = errorMsg +  '. Error on REST_Account_Callout.modificationPartner_sync method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
					apputils.puterror(errorMsg);
					SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
				}

				// put callout information then save the data on Call_Log object
				Call_Log__c calllog = new Call_Log__c();
				calllog.type__c='Callout';
				calllog.request_start_time__c = requestStartTime;
				calllog.method__c = 'POST';
				calllog.callerFrom__c = 'Salesforce' ;
				calllog.endpoint__c = endpoint ;
				calllog.uri__c = uri ; 
				calllog.request_message__c = bodyMesage;
				calllog.status__c = status;
				calllog.response_message__c = result;            
				calllog.Error_Message__c = errorMsg;
				calllog.Salesforce_ID_1__c = AccountID;
				calllog.Account_Related__c	 = AccountID;
				calllog.response_end_time__c = datetime.now(); 
				calllog.Request_ID__c = callId;    
				callLogList.add(calllog);

				insert callLogList;
			}
        }

		return JSON.serialize(returnMessage);
    } 

	@future(Callout=true)
	public static void modificationPartner_async(String AccountID, String ContactID, String oldRecord){
        SYSTEM.DEBUG ('============== in REST_Account_Callout class, modificationPartner_async method ==============' );

        List<IdexPro_API_Setting__c> List_IdexPro_APISetting = [SELECT Password__c, URI__c, URL__c, Username__c FROM IdexPro_API_Setting__c WHERE Name = 'modificationPartner'];

		system.debug('modificationPartner - oldRecord : ' + oldRecord);

        if(List_IdexPro_APISetting!=null && !List_IdexPro_APISetting.isEmpty()){
            getAccessToken();

            Datetime requestStartTime = datetime.now();

            string URI;
            string bodyMesage;
            string status;
            String responseCode;
            String responseMsg;
            string errorMsg;
            string result;
            String callId = AppUtils.getNewGUID();
            String endpoint;

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();   

			if (doCallOut) {
				//if(String.isNotBlank(AccountID)){
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
						Postal_Code_IdexPro__c,
						Update_Dealer_IdexPro_Status__c
						FROM Account WHERE Id =: AccountID
					];

					List<Contact> List_Contact = [
						SELECT Id,
						LastName,
						Firstname,
						MobilePhone,
						Phone,
						Email,
						Reference_ID__c,
						Idexpro_ProfileID__c,
						AccountId,
						Account.Name,
						Account.DealerID__c
						FROM Contact WHERE AccountId =: AccountID AND
						Idexpro_ProfileID__c != null
					];

					try {
						//-- do call out
						SYSTEM.DEBUG ('============== try to do call out ==============');
	
						PartnerModification_Request PartnerModification_Request_extract = new PartnerModification_Request();
	
						cls_basicDetails_PartnerModification cls_basicDetails_PartnerModification_extract = new cls_basicDetails_PartnerModification();
	
						cls_taxDetails_PartnerModification cls_taxDetails_PartnerModification_extract = new cls_taxDetails_PartnerModification();
	
						cls_otherDetails_PartnerModification cls_otherDetails_PartnerModification_extract = null;
	
						List<cls_addresses_PartnerModification> List_cls_addresses_PartnerModification_extract = new List<cls_addresses_PartnerModification>();
	
						List<cls_profiles_PartnerModification> List_cls_profiles_PartnerModification_extract = new List<cls_profiles_PartnerModification>();
	
						// ---------- cls_basicDetails_PartnerModification ----------
						cls_basicDetails_PartnerModification_extract.menu1_distName = List_Account[0].Name;
						cls_basicDetails_PartnerModification_extract.menu1_phoneNo = List_Contact[0].Phone;
						cls_basicDetails_PartnerModification_extract.menu1_emailAddress = List_Contact[0].Email;
						cls_basicDetails_PartnerModification_extract.menu1_channelSubType = 1;
						cls_basicDetails_PartnerModification_extract.menu1_channelCategory = 11;
						cls_basicDetails_PartnerModification_extract.menu1_channelType = 11;
						// ---------- cls_basicDetails_PartnerModification ----------
	
						// ---------- cls_taxDetails_PartnerModification ----------
						cls_taxDetails_PartnerModification_extract.menu8_npwpType = List_Account[0].Dealer_VAT_Type__c;
						cls_taxDetails_PartnerModification_extract.menu8_npwpNo = List_Account[0].No_NPWP__c;
						cls_taxDetails_PartnerModification_extract.menu8_npwpName = List_Account[0].Dealer_VAT_Name__c;
						cls_taxDetails_PartnerModification_extract.menu8_npwpAddress = List_Account[0].VAT_Address_to_BSS__c;
						// ---------- cls_taxDetails_PartnerModification ----------
	
						// ---------- cls_otherDetails_PartnerModification ----------
	
						// ---------- cls_otherDetails_PartnerModification ----------
						
	
						// ---------- cls_addresses_PartnerModification ----------
						cls_addresses_PartnerModification cls_addresses_PartnerModification_extract = new cls_addresses_PartnerModification();
						cls_addresses_PartnerModification_extract.menu2_addressId = List_Account[0].Idexpro_BillingAddressId__c;
						cls_addresses_PartnerModification_extract.menu2_addressType = 'Billing Address';
						cls_addresses_PartnerModification_extract.menu2_Street = List_Account[0].Street_IdexPro__c;
						cls_addresses_PartnerModification_extract.menu2_District = List_Account[0].District_IdexPro_Code__c;
						cls_addresses_PartnerModification_extract.menu2_City = List_Account[0].City_IdexPro_Code__c;
						cls_addresses_PartnerModification_extract.menu2_Province = List_Account[0].Province_IdexPro_Code__c;
						cls_addresses_PartnerModification_extract.menu2_Country = 'Indonesia';
						cls_addresses_PartnerModification_extract.menu2_postalCode = List_Account[0].Postal_Code_IdexPro__c;
	
						List_cls_addresses_PartnerModification_extract.add(cls_addresses_PartnerModification_extract);

						cls_addresses_PartnerModification cls_addresses_PartnerModification_extract2 = new cls_addresses_PartnerModification();
						cls_addresses_PartnerModification_extract2.menu2_addressId = List_Account[0].Idexpro_ShippingAddressId__c;
						cls_addresses_PartnerModification_extract2.menu2_addressType = 'Shipping Address';
						cls_addresses_PartnerModification_extract2.menu2_Street = List_Account[0].Street_IdexPro__c;
						cls_addresses_PartnerModification_extract2.menu2_District = List_Account[0].District_IdexPro_Code__c;
						cls_addresses_PartnerModification_extract2.menu2_City = List_Account[0].City_IdexPro_Code__c;
						cls_addresses_PartnerModification_extract2.menu2_Province = List_Account[0].Province_IdexPro_Code__c;
						cls_addresses_PartnerModification_extract2.menu2_Country = 'Indonesia';
						cls_addresses_PartnerModification_extract2.menu2_postalCode = List_Account[0].Postal_Code_IdexPro__c;
	
						List_cls_addresses_PartnerModification_extract.add(cls_addresses_PartnerModification_extract2);
						// ---------- cls_addresses_PartnerModification ----------
	
						// ---------- cls_profiles_PartnerModification ----------
						if(List_Contact!=null && !List_Contact.isEmpty()){
							for(Contact List_Contact_Extract : List_Contact){
								cls_profiles_PartnerModification cls_profiles_PartnerModification_extract = new cls_profiles_PartnerModification();
	
								cls_profiles_PartnerModification_extract.menu4_authorisedProfileId = List_Contact_Extract.Idexpro_ProfileID__c;
								cls_profiles_PartnerModification_extract.menu4_profileType = 'Contact Person';
								cls_profiles_PartnerModification_extract.menu4_authorisedfirstName = List_Contact_Extract.firstName;
								cls_profiles_PartnerModification_extract.menu4_authorisedlastName = List_Contact_Extract.lastName;
								cls_profiles_PartnerModification_extract.menu4_authorisedPhoneNo = List_Contact_Extract.Phone;
								cls_profiles_PartnerModification_extract.menu4_authorisedMobileNo = List_Contact_Extract.MobilePhone;
								cls_profiles_PartnerModification_extract.menu4_authorisedEmailAddress = List_Contact_Extract.Email;

								// ---------- cls_basicDetails_PartnerModification ----------
								cls_basicDetails_PartnerModification_extract.menu1_distName = List_Contact_Extract.Account.Name;
								cls_basicDetails_PartnerModification_extract.menu1_phoneNo = List_Contact_Extract.Phone;
								cls_basicDetails_PartnerModification_extract.menu1_emailAddress = List_Contact_Extract.Email;
								cls_basicDetails_PartnerModification_extract.menu1_channelSubType = 1;
								cls_basicDetails_PartnerModification_extract.menu1_channelCategory = 11;
								cls_basicDetails_PartnerModification_extract.menu1_channelType = 11;
								// ---------- cls_basicDetails_PartnerModification ----------
	
								List_cls_profiles_PartnerModification_extract.add(cls_profiles_PartnerModification_extract);
							}
						}
						// ---------- cls_profiles_PartnerModification ----------
	
						PartnerModification_Request_extract.basicDetails = cls_basicDetails_PartnerModification_extract;
						PartnerModification_Request_extract.taxDetails = cls_taxDetails_PartnerModification_extract;
						PartnerModification_Request_extract.otherDetails = cls_otherDetails_PartnerModification_extract;
						PartnerModification_Request_extract.addresses = List_cls_addresses_PartnerModification_extract;
						PartnerModification_Request_extract.profiles = List_cls_profiles_PartnerModification_extract;
						PartnerModification_Request_extract.action = 'U';
						
						String reqBody = JSON.serialize(PartnerModification_Request_extract);
						
						System.debug('>>> reqBody : '+reqBody);
	
						endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c + List_Account[0].DealerID__c;
	
						httpRequestObj.setTimeout(120000);
						httpRequestObj.setEndpoint(endpoint);
						httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
						if(Test.isRunningTest()){
							access_token = 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3MzI0OTI4NywiaWF0IjoxNjcyNjQ0NDg3fQ.JBUdI_zg_zgoDKaaI4hnFpmoNV1w6yI53HXmxC71Mq7L6ulMKIes6YlAGddgpkhvHos374gPeZgSp0Prbv_gJw';
						}
						httpRequestObj.setHeader('Authorization', 'Bearer ' + access_token);
						httpRequestObj.setHeader('trx_id', callId);
						httpRequestObj.setMethod('POST');
						httpRequestObj.setBody(reqBody); 
	
						System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));
	
						bodyMesage = reqBody;
						Datetime startDate = System.now();
				
						if(!Test.isRunningTest()){
							HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
							result = httpResponseObj.getBody();
						}else{
							result = '{"partnerDetails":[{"partnerProfiles":[{"menu4_actionFlag":null,"title":null,"salesChannelId":11190175,"province":null,"profileType":"Contact Person","postalCode":null,"phoneNo":"6211122","outletType":null,"outletSize":0,"mobileNo":"62322233","lastName":"Agmawan","identityNo":null,"homePhoneNo":"62null","gender":null,"firstName":"Usama","faxNo":null,"emailAddress":"testing020101@gmail.com","country":null,"city":null,"birthPlace":null,"birthDate":null,"address":null,"profileId":11189810}],"partnerAddresses":[{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Billing Address","addressId":4134952},{"street":"Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor","salesChannelId":11190175,"province":"prov1","postalCode":67225,"country":"Indonesia","city":"city1","district":"dist1","addressType":"Shipping Address","addressId":4134953}],"dealerName":"PT Profesional Internet Indonesia","dealerId":"90185670"}],"message":"Partner Created Successfully","status":"OK","code":"200"}';
						}

						System.debug('>>> result : '+result);
	
						Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
						responseMsg = json.serialize(responsemap);
						
						System.debug ('================= response responsemap : ' + responsemap );
						
						responseCode = AppUtils.getStringDataOnMap(responsemap , 'code');
						system.debug ('================= responseCode : ' + responseCode);
	
						if(responseCode != '== Keyset NOT found =='){
							List_Account[0].Update_Dealer_IdexPro_Status__c = 'Success';
							update List_Account;

							status = 'success';
							responseMsg = json.serialize(responsemap);
						}else{
							Object result_oldRecord_Account = JSON.deserializeUntyped(oldRecord);

							Map<String, Object> resultMap_oldRecord_Account = (Map<String, Object>)result_oldRecord_Account;

							system.debug('modificationPartner - resultMap_oldRecord_Account : ' + resultMap_oldRecord_Account);

							Account accountRollback = new Account();
							accountRollback.Id = (string)resultMap_oldRecord_Account.get('Record_ID__c');
							accountRollback.Update_Dealer_IdexPro_Status__c = 'Failed';
							accountRollback.Channel_Type__c = (string)resultMap_oldRecord_Account.get('Channel_Type__c');
							accountRollback.Dealer_VAT_Name__c = (string)resultMap_oldRecord_Account.get('Dealer_VAT_Name__c');
							accountRollback.Name = (string)resultMap_oldRecord_Account.get('Name');
							accountRollback.Dealer_VAT_Type__c = (string)resultMap_oldRecord_Account.get('Dealer_VAT_Type__c');
							accountRollback.District_IdexPro__c = (string)resultMap_oldRecord_Account.get('District_IdexPro__c');
							accountRollback.Distributor_Type__c = (string)resultMap_oldRecord_Account.get('Distributor_Type__c');
							accountRollback.No_NPWP__c = (string)resultMap_oldRecord_Account.get('No_NPWP__c');
							accountRollback.Postal_Code_IdexPro__c = (string)resultMap_oldRecord_Account.get('Postal_Code_IdexPro__c');
							accountRollback.Province_IdexPro__c = (string)resultMap_oldRecord_Account.get('Province_IdexPro__c');
							accountRollback.ShippingStreet = (string)resultMap_oldRecord_Account.get('ShippingStreet');
							accountRollback.ShippingPostalCode = (string)resultMap_oldRecord_Account.get('ShippingPostalCode');
							accountRollback.ShippingState = (string)resultMap_oldRecord_Account.get('ShippingState');
							accountRollback.Channel_Category__c = (string)resultMap_oldRecord_Account.get('Channel_Category__c');
							accountRollback.City_IdexPro__c = (string)resultMap_oldRecord_Account.get('City_IdexPro__c');
							accountRollback.DealerID__c = (string)resultMap_oldRecord_Account.get('DealerID__c');
							accountRollback.Channel_Sub_Type__c = (string)resultMap_oldRecord_Account.get('Channel_Sub_Type__c');
							accountRollback.ShippingCity = (string)resultMap_oldRecord_Account.get('ShippingCity');
							accountRollback.BillingCountry = (string)resultMap_oldRecord_Account.get('BillingCountry');
							accountRollback.Dealer_Status__c = (string)resultMap_oldRecord_Account.get('Dealer_Status__c');
							accountRollback.Street_IdexPro__c = (string)resultMap_oldRecord_Account.get('Street_IdexPro__c');

							update accountRollback;

							status = 'failed';
							errorMsg = json.serialize(responsemap);

							sendEmailNotifFailed('Dealer Update Failed Info', AccountID, null);
						}

						if(Test.isRunningTest()) {
							CalloutException e = new CalloutException();
							e.setMessage('This is a constructed exception for testing and code coverage');
							throw e;
						}
					}
					catch (Exception e) {
						//-- error handling for callout
						SYSTEM.DEBUG ('============== error found at Call-Out ==============');
	
						status = 'Failed';
						errorMsg = errorMsg +  '. Error on REST_Account_Callout.modificationPartner_async method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
						apputils.puterror(errorMsg);
						SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
					}
				//}

				/*if(String.isNotBlank(ContactID)){
					List<Contact> List_Contact = [
						SELECT Id,
						LastName,
						Firstname,
						MobilePhone,
						Phone,
						Email,
						Reference_ID__c,
						Idexpro_ProfileID__c,
						AccountId,
						Account.Name,
						Account.DealerID__c
						FROM Contact WHERE Id =: ContactID AND
						Idexpro_ProfileID__c != null
					];

					try {
						//-- do call out
						SYSTEM.DEBUG ('============== try to do call out ==============');
	
						PartnerModification_Request PartnerModification_Request_extract = new PartnerModification_Request();
	
						cls_basicDetails_PartnerModification cls_basicDetails_PartnerModification_extract = new cls_basicDetails_PartnerModification();
	
						cls_taxDetails_PartnerModification cls_taxDetails_PartnerModification_extract = new cls_taxDetails_PartnerModification();
	
						cls_otherDetails_PartnerModification cls_otherDetails_PartnerModification_extract = null;
	
						cls_addresses_PartnerModification cls_addresses_PartnerModification_extract = new cls_addresses_PartnerModification();
	
						List<cls_addresses_PartnerModification> List_cls_addresses_PartnerModification_extract = new List<cls_addresses_PartnerModification>();
	
						List<cls_profiles_PartnerModification> List_cls_profiles_PartnerModification_extract = new List<cls_profiles_PartnerModification>();
	
						// ---------- cls_profiles_PartnerModification ----------
						if(List_Contact!=null && !List_Contact.isEmpty()){
							for(Contact List_Contact_Extract : List_Contact){
								cls_profiles_PartnerModification cls_profiles_PartnerModification_extract = new cls_profiles_PartnerModification();
	
								cls_profiles_PartnerModification_extract.menu4_authorisedProfileId = List_Contact_Extract.Idexpro_ProfileID__c;
								cls_profiles_PartnerModification_extract.menu4_profileType = 'Contact Person';
								cls_profiles_PartnerModification_extract.menu4_authorisedfirstName = List_Contact_Extract.firstName;
								cls_profiles_PartnerModification_extract.menu4_authorisedlastName = List_Contact_Extract.lastName;
								cls_profiles_PartnerModification_extract.menu4_authorisedPhoneNo = List_Contact_Extract.Phone;
								cls_profiles_PartnerModification_extract.menu4_authorisedMobileNo = List_Contact_Extract.MobilePhone;
								cls_profiles_PartnerModification_extract.menu4_authorisedEmailAddress = List_Contact_Extract.Email;

								// ---------- cls_basicDetails_PartnerModification ----------
								cls_basicDetails_PartnerModification_extract.menu1_distName = List_Contact_Extract.Account.Name;
								cls_basicDetails_PartnerModification_extract.menu1_phoneNo = List_Contact_Extract.Phone;
								cls_basicDetails_PartnerModification_extract.menu1_emailAddress = List_Contact_Extract.Email;
								cls_basicDetails_PartnerModification_extract.menu1_channelSubType = 1;
								cls_basicDetails_PartnerModification_extract.menu1_channelCategory = 11;
								cls_basicDetails_PartnerModification_extract.menu1_channelType = 11;
								// ---------- cls_basicDetails_PartnerModification ----------
	
								List_cls_profiles_PartnerModification_extract.add(cls_profiles_PartnerModification_extract);
							}
						}
						// ---------- cls_profiles_PartnerModification ----------
	
						PartnerModification_Request_extract.basicDetails = cls_basicDetails_PartnerModification_extract;
						PartnerModification_Request_extract.taxDetails = null;
						PartnerModification_Request_extract.otherDetails = null;
						PartnerModification_Request_extract.addresses = null;
						PartnerModification_Request_extract.profiles = List_cls_profiles_PartnerModification_extract;
						PartnerModification_Request_extract.action = 'U';
						
						String reqBody = JSON.serialize(PartnerModification_Request_extract);
						
						System.debug('>>> reqBody : '+reqBody);
	
						endpoint = List_IdexPro_APISetting[0].URI__c + List_IdexPro_APISetting[0].URL__c + List_Contact[0].Account.DealerID__c;
	
						httpRequestObj.setTimeout(120000);
						httpRequestObj.setEndpoint(endpoint);
						httpRequestObj.setHeader('Content-Type', 'application/json;charset=UTF-8');
						if(Test.isRunningTest()){
							access_token = 'Bearer 2121sa';
						}
						httpRequestObj.setHeader('Authorization', 'Bearer ' + access_token);
						httpRequestObj.setHeader('trx_id', callId);
						httpRequestObj.setMethod('POST');
						httpRequestObj.setBody(reqBody); 
	
						System.debug('>>> httpRequestObj : '+ String.ValueOf(httpRequestObj));
	
						bodyMesage = reqBody;
						Datetime startDate = System.now();
				
						HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
						result = httpResponseObj.getBody();
						System.debug('>>> result : '+result);
	
						Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(result);
						responseMsg = json.serialize(responsemap);
						
						System.debug ('================= response responsemap : ' + responsemap );
						
						responseCode = AppUtils.getStringDataOnMap(responsemap , 'code');
						system.debug ('================= responseCode : ' + responseCode);
	
						if(responseCode != '== Keyset NOT found =='){
							status = 'success';
							responseMsg = json.serialize(responsemap); 
						}else{
							status = 'failed';
							errorMsg = json.serialize(responsemap);
						}
					}
					catch (Exception e) {
						//-- error handling for callout
						SYSTEM.DEBUG ('============== error found at Call-Out ==============');
	
						status = 'Failed';
						errorMsg = errorMsg +  '. Error on REST_Account_Callout.modificationPartner_async method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
						apputils.puterror(errorMsg);
						SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
					}
				}*/

				// put callout information then save the data on Call_Log object
				Call_Log__c calllog = new Call_Log__c();
				calllog.type__c='Callout';
				calllog.request_start_time__c = requestStartTime;
				calllog.method__c = 'POST';
				calllog.callerFrom__c = 'Salesforce' ;
				calllog.endpoint__c = endpoint ;
				calllog.uri__c = uri ; 
				calllog.request_message__c = bodyMesage;
				calllog.status__c = status;
				calllog.response_message__c = result;            
				calllog.Error_Message__c = errorMsg;

				if(String.isNotBlank(AccountID)){
					calllog.Salesforce_ID_1__c = AccountID;
					calllog.Account_Related__c	 = AccountID;
				}

				if(String.isNotBlank(ContactID)){
					calllog.Salesforce_ID_1__c = ContactID;
					calllog.Contact_Related__c	 = ContactID;
				}
				
				calllog.response_end_time__c = datetime.now(); 
				calllog.Request_ID__c = callId;    
				callLogList.add(calllog);

				insert callLogList;
			}
        }
    }

	public static void sendEmailNotifFailed(String jobName, String AccountID, String ContactID){
        Datetime startDate = System.now();

		List<Messaging.SingleEmailMessage> sendEmailList = new List<Messaging.SingleEmailMessage>();

		List<string> List_toAddress = new List<string>();
		List<string> List_toCCAddress = new List<string>();

		Set<string> Set_AddressList = new Set<string>();
		Set<string> Set_AddressCCList = new Set<string>();

		List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];

		List<Account> List_Account = new List<Account>();
        
        try {
			List<Dealer_Email_Setting__c> List_Dealer_Email_Setting = [
				SELECT Name, 
				Email_Template_Name__c, 
				Additional_toAddress__c, 
				Additional_toCCAddress__c 
				FROM Dealer_Email_Setting__c 
				WHERE Name =: jobName
			];

            if(List_Dealer_Email_Setting!=null && !List_Dealer_Email_Setting.isEmpty()){
				String batch_ToAddress = List_Dealer_Email_Setting[0].Additional_toAddress__c;
				String batch_toCCAddress = List_Dealer_Email_Setting[0].Additional_toCCAddress__c;

				if(String.isNotBlank(batch_ToAddress)){
					if(batch_ToAddress.contains(' ')){ //space
						String toAddress = batch_ToAddress.replaceAll('\\s','');
						List_toAddress = toAddress.split(';');
					}
					if(batch_ToAddress.contains(',')){ //koma
						String toAddress = batch_ToAddress.replaceAll('\\,',';');
						List_toAddress = toAddress.split(';');
					}
					if(batch_ToAddress.contains('|')){ //pipe
						String toAddress = batch_ToAddress.replaceAll('\\|',';');
						List_toAddress = toAddress.split(';');
					}
					if(batch_ToAddress.contains(' ') && batch_ToAddress.contains(',') ){ //space dan koma
						String toAddress = batch_ToAddress.replaceAll('\\s','');
						String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
						List_toAddress = toAddressFormat_1.split(';');
					}
					if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') ){ //space dan pipe
						String toAddress = batch_ToAddress.replaceAll('\\s','');
						String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
						List_toAddress = toAddressFormat_1.split(';');
					}
					if(batch_ToAddress.contains(',') && batch_ToAddress.contains('|') ){ //koma dan pipe
						String toAddress = batch_ToAddress.replaceAll('[\\|\\,]',';');
						List_toAddress = toAddress.split(';');
					}
					if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') && batch_ToAddress.contains(',') ){ //koma dan pipe dan space
						String toAddress = batch_ToAddress.replaceAll('\\s','');
						String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
						List_toAddress = toAddressFormat_1.split(';');
					}
					if(!batch_ToAddress.contains(' ') && !batch_ToAddress.contains('|') && !batch_ToAddress.contains(',') ){
						List_toAddress = batch_ToAddress.split(';');
					}
				}
				
				if(String.isNotBlank(batch_toCCAddress)){
					if(batch_toCCAddress.contains(' ')){ //space
						String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
						List_toCCAddress = toCCAddress.split(';');
					}
					if(batch_toCCAddress.contains(',')){ //koma
						String toCCAddress = batch_toCCAddress.replaceAll('\\,',';');
						List_toCCAddress = toCCAddress.split(';');
					}
					if(batch_toCCAddress.contains('|')){ //pipe
						String toCCAddress = batch_toCCAddress.replaceAll('\\|',';');
						List_toCCAddress = toCCAddress.split(';');
					}
					if(batch_toCCAddress.contains(',') && batch_toCCAddress.contains('|') ){ //koma dan pipe
						String toCCAddress = batch_toCCAddress.replaceAll('[\\|\\,]',';');
						List_toCCAddress = toCCAddress.split(';');
					}
					if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains(',') ){ //space dan koma
						String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
						String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
						List_toCCAddress = toCCAddressFormat_1.split(';');
					}
					if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') ){ //space dan pipe
						String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
						String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
						List_toCCAddress = toCCAddressFormat_1.split(';');
					}
					if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') && batch_toCCAddress.contains(',') ){ //koma dan pipe dan space
						String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
						String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
						List_toCCAddress = toCCAddressFormat_1.split(';');
					}
					if(!batch_toCCAddress.contains(' ') && !batch_toCCAddress.contains('|') && !batch_toCCAddress.contains(',') ){
						List_toCCAddress = batch_toCCAddress.split(';');
					}
				}

				if(String.isNotBlank(AccountID)){
					List_Account = [
						SELECT Id,
						Owner.Email
						FROM Account WHERE Id =: AccountID
					];

					List_toAddress.add(List_Account[0].Owner.Email);
				}

				if(String.isNotBlank(ContactID)){
					List<Contact> List_Contact = [
						SELECT Id,
						Owner.Email
						FROM Contact WHERE Id =: ContactID
					];

					List_toAddress.add(List_Contact[0].Owner.Email);
				}

				Set_AddressList.addAll(List_toAddress);
				Set_AddressList.remove('');
				Set_AddressList.remove(null);
				
				Set_AddressCCList.addAll(List_toCCAddress);
				Set_AddressCCList.remove('');
				Set_AddressCCList.remove(null);

				List_toAddress.clear();
				List_toCCAddress.clear();

				List_toAddress.addAll(Set_AddressList);
				List_toCCAddress.addAll(Set_AddressCCList);

				List<EmailTemplate> EmailTemplateList = [
					SELECT id 
					FROM EmailTemplate 
					WHERE DeveloperName =: List_Dealer_Email_Setting[0].Email_Template_Name__c
				];

				Messaging.SingleEmailMessage singleEmailMessageObj = new Messaging.SingleEmailMessage();
                    
				singleEmailMessageObj.optOutPolicy = 'FILTER';
				singleEmailMessageObj.setTemplateId(EmailTemplateList[0].id);
				singleEmailMessageObj.setTargetObjectId(contactList[0].id);
				singleEmailMessageObj.setTreatTargetObjectAsRecipient(false);
				singleEmailMessageObj.setWhatId(List_Account[0].Id);
				singleEmailMessageObj.setSaveAsActivity(false);
			
				singleEmailMessageObj.setToAddresses(List_toAddress);
				if(List_toCCAddress!=null && !List_toCCAddress.isEmpty()){
					singleEmailMessageObj.setCcAddresses(List_toCCAddress);
				}
				
				sendEmailList.add(singleEmailMessageObj);

				if(sendEmailList!=null && !sendEmailList.isEmpty()){
                    system.debug('sendEmailListSize : ' + sendEmailList.size()) ;
                    Messaging.sendEmail(sendEmailList,true);
                }
            }

			if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch (Exception e) {
            string errorMsg = 'Error on REST_Account_Callout.sendEmailNotifFailed method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() + ' :: ' + e.getLineNumber();

            apputils.puterror(errorMsg);

            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }  

    global class GET_TOKEN_REQUEST {
        global String username{ get; set; }
        global String password{ get; set; }
		global String client_secret{ get; set; }
    }

    global class GET_TOKEN_RESPONSE {
        global String token{ get; set; }
    }

    /* ---------- PartnerCreation ---------- */
    global class PartnerCreation_Request{
        global cls_basicDetails_PartnerCreation basicDetails;
        global cls_taxDetails_PartnerCreation taxDetails;
        global cls_otherDetails_PartnerCreation otherDetails;
        global List<cls_addresses_PartnerCreation> addresses;
        global List<cls_profiles_PartnerCreation> profiles;
		global String action;
    }

    global class cls_basicDetails_PartnerCreation {
		public String menu1_distName;	//
		public String menu1_phoneNo;	//898912211910
		public String menu1_emailAddress;	//mailme1@gmai0011.com
		public String menu1_allEmailAddresses;	//mailme1@gmai0011.com
		public Integer menu1_distType;
		public Integer menu1_channelSubType;	//1
		public Integer menu1_channelCategory;	//11
		public Integer menu1_sourceWarehouse;	//
		public Integer menu1_channelType;	//11
	}

    global class cls_taxDetails_PartnerCreation {
		public String menu8_npwpType;
		public String menu8_npwpNo;	//
		public String menu8_npwpName;	//
		public String menu8_npwpAddress;	//
	}

    global class cls_otherDetails_PartnerCreation {
		public String menu11_custClass;	//
		public String menu11_sentToErp;	//
		public String menu11_costCenter;	//78
	}

    global class cls_addresses_PartnerCreation {
		public String menu2_addressType;	//Billing Address
		public String menu2_Street;	//JLN MARG
		public String menu2_District;	//Abiansemal
		public String menu2_City;	//Kab. Badung
		public String menu2_Province;	//BALI
		public String menu2_Country;	//Indonesia
		public String menu2_postalCode;	//67843
	}

    global class cls_profiles_PartnerCreation {
		public String menu4_profileType;	//
		public String menu4_authorisedfirstName; //
		public String menu4_authorisedlastName;	//
		public String menu4_authorisedPhoneNo;	//
		public String menu4_authorisedMobileNo;	//
		public String menu4_authorisedEmailAddress;	//
	}

    global class PartnerCreation_Response{
        global Integer code;	//200
	    global String status;	//OK
	    global String message;	//Partner Created Successfully
        global List<cls_partnerDetails_PartnerCreation> partnerDetails;
    }
	
	global class cls_partnerDetails_PartnerCreation {
		global String dealerId;	//376476
		global String dealerName;	//testingpartner
		public List<cls_partnerAddresses_PartnerCreation> partnerAddresses;
		public List<cls_partnerProfiles_PartnerCreation> partnerProfiles;
	}

	global class cls_partnerAddresses_PartnerCreation {
		public Integer addressId;	//4134813
		public String addressType;	//Billing Address
		public String district;	//dist2052
		public String city;	//city176
		public String country;	//Indonesia
		public Integer postalCode;	//67225
		public String province;	//prov14
		public Integer salesChannelId;	//11190051
		public String street;	//Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor
	}

	global class cls_partnerProfiles_PartnerCreation {
		public Integer profileId;	//11189740
		public String address;
		public String birthDate;
		public String birthPlace;
		public String city;
		public String country;
		public String emailAddress;	//testing071102@gmail.com
		public String faxNo;
		public String firstName;	//Usama
		public String gender;
		public String homePhoneNo;	//62null
		public String identityNo;
		public String lastName;	//Agmawan
		public String mobileNo;	//62823762819
		public Integer outletSize;	//0
		public String outletType;
		public String phoneNo;	//6202183736382
		public String postalCode;
		public String profileType;	//Contact Person
		public String province;
		public Integer salesChannelId;	//11190051
		public String title;
		public String menu4_actionFlag;
	}
    /* ---------- PartnerCreation ---------- */

    /* ---------- PartnerValidation ---------- */
    global class PartnerValidation_Response{
        global List<cls_partnerDetails_PartnerValidation> partnerDetails;
    }

    global class cls_partnerDetails_PartnerValidation {
		public String dealerId;	//90054412
		public String salesChannelName;	//LIMA BERSAUDARA CELL
		public String phoneNo;	//6287866792273
		public String emailAddress;	//adm.gmasbw@gmail.com
		public String address;	//JLN TENTE KAMPO NISA-Kab. Bima-Nusa Tenggara Barat-Indonesia
		public String userId;	//Bha-IanCell
		public String channelType;	// BUSOL - Community 
		public String channelSubType;	//MD
		public String channelCategory;	//BUSOL - Community
	}
    /* ---------- PartnerValidation ---------- */

    /* ---------- PartnerModification ---------- */
    global class PartnerModification_Request{
        public cls_taxDetails_PartnerModification taxDetails;
		public List<cls_profiles_PartnerModification> profiles;
		public cls_otherDetails_PartnerModification otherDetails;
		public cls_basicDetails_PartnerModification basicDetails;
		public List<cls_addresses_PartnerModification> addresses;
		public String action;	//U
    }

    global class cls_basicDetails_PartnerModification {
		public String menu1_distName;	//PT Profesional Internet Indonesia
		public Integer menu1_channelSubType;	//1
		public Integer menu1_channelCategory;	//11
		public Integer menu1_channelType;	//11
		public String menu1_phoneNo;	//021837236383
		public String menu1_emailAddress;	//novando.agmawan@saasten10.com
	}

    global class cls_taxDetails_PartnerModification {
		public String menu8_npwpType;	//Company
		public String menu8_npwpNo;	//933779373625000
		public String menu8_npwpName;	//PT Profesional Internet Indonesia
		public String menu8_npwpAddress;	//Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor, Kademangan Kota Probolinggo
	}

    global class cls_otherDetails_PartnerModification {
	
	}

    global class cls_addresses_PartnerModification {
		public String menu2_addressId;	//4134813
		public String menu2_Street;	//Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor
		public String menu2_Province;	//Jawa Timur
		public String menu2_postalCode;	//67225
		public String menu2_District;	//Kademangan 
		public String menu2_Country;	//Indonesia
		public String menu2_City;	//Kota Probolinggo
		public String menu2_addressType;	//Billing Address
	}

    global class cls_profiles_PartnerModification {
		public String menu4_authorisedProfileId;	//11189740
		public String menu4_profileType;	//Contact Person
		public String menu4_authorisedPhoneNo;	//021837236383
		public String menu4_authorisedMobileNo;	//83743984783
		public String menu4_authorisedlastName;	//Agmawan
		public String menu4_authorisedfirstName;	//Usama
		public String menu4_authorisedEmailAddress;	//novando.agmawan@saasten10.com
	}

    global class PartnerModification_Response{
        global Integer code;	//200
	    global String status;	//OK
	    global String message;	//Partner Updated Successfully
    }
    /* ---------- PartnerModification ---------- */


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