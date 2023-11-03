/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 04-08-2022
 * @last modified by  : Novando Utoyo Agmawan
**/

@isTest()
public with sharing class NewProductRegistrationTicketServiceTest {
    private class WebServiceMockImpl implements WebServiceMock
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			if(request instanceof MetadataService.retrieve_element)
				response.put('response_x', new MetadataService.CustomField());
			else if(request instanceof MetadataService.checkDeployStatus_element)
				response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
			return;
		}
	}    


    class GlobalPicklistWebServiceMockImpl implements WebServiceMock {
        
        //WebServiceMock(string constructorArgs) {
        //   // save the constructor args in local vbls
        //}
        
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType){
                // using the variables you saved in the constructor as input, 
                // return values in the arguments to this method in response
                
                system.debug('=== stub : ' + stub);
                system.debug('=== request : ' + request);
                system.debug('=== response : ' + response);
                system.debug('=== endpoint : ' + endpoint);
                system.debug('=== soapAction : ' + soapAction);
                system.debug('=== requestName : ' + requestName);
                system.debug('=== responseNS : ' + responseNS);
                system.debug('=== responseName : ' + responseName);
                system.debug('=== responseType : ' + responseType);
                
                if (requestName == 'readMetadata') {
                    MetadataService.GlobalValueSet mockGlobalValueSet = new MetadataService.GlobalValueSet();
                    MetadataService.CustomValue newItem = new MetadataService.CustomValue();
                    newItem.fullName = 'value';
                    newItem.label = 'label';
                    newItem.isActive = true;
                    newItem.default_x = false;
                    
                    if(mockGlobalValueSet.customValue == null){
                        mockGlobalValueSet.customValue = new List<MetadataService.CustomValue>();
                    }
                    
                    mockGlobalValueSet.customValue.add(newItem);
                    
                    mockGlobalValueSet.masterLabel='test123';
                    mockGlobalValueSet.sorted=false;
                    mockGlobalValueSet.description='sd';
                    
                    List<MetadataService.GlobalValueSet> mockGlobalValueSetList = new List<MetadataService.GlobalValueSet>();
                    mockGlobalValueSetList.add (mockGlobalValueSet);
                    
                    MetadataService.readGlobalValueSetResponse_element mockRes  = new MetadataService.readGlobalValueSetResponse_element ();
                    mockRes.result           = new MetaDataService.ReadGlobalValueSetResult ();
                    mockRes.result.records   = mockGlobalValueSetList;
                    
                    response.put('response_x', mockRes);
                    
                }
                
                if (requestName == 'updateMetadata') {
                    
                    MetadataService.updateMetadataResponse_element metadataResponse = new MetadataService.updateMetadataResponse_element();
                    
                    MetadataService.Error errorObj = new MetadataService.Error();
                    errorObj.message = 'error broo';
                    errorObj.statusCode = '666';
                    
                    MetadataService.SaveResult saveresult = new MetadataService.SaveResult();
                    saveresult.errors = new List<MetadataService.Error>();
                    saveresult.errors.add(errorObj);
                    saveresult.fullName = 'TestApp';
                    saveresult.success = true;
                    
                    metadataResponse.result = new List<MetadataService.SaveResult>();
                    metadataResponse.result.add(saveresult);
                    response.put('response_x', metadataResponse); 
                    
                }
                
                
                
            }
    }


    class UpdatePicklistWebServiceMockImpl implements WebServiceMock {
        
        //WebServiceMock(string constructorArgs) {
        //   // save the constructor args in local vbls
        //}
        
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType){
                // using the variables you saved in the constructor as input, 
                // return values in the arguments to this method in response
                
                system.debug('=== stub : ' + stub);
                system.debug('=== request : ' + request);
                system.debug('=== response : ' + response);
                system.debug('=== endpoint : ' + endpoint);
                system.debug('=== soapAction : ' + soapAction);
                system.debug('=== requestName : ' + requestName);
                system.debug('=== responseNS : ' + responseNS);
                system.debug('=== responseName : ' + responseName);
                system.debug('=== responseType : ' + responseType);
                
                //MetadataService.CustomField customField_existing = (MetadataService.CustomField) service.readMetadata('CustomField', new 
                
                if (requestName == 'readMetadata') {
                    
                    if (responseType == 'MetadataService.readCustomFieldResponse_element') {
                        //MetadataService.MetadataPort service = createService();
                        MetadataService.CustomField mocCustomField = new MetadataService.CustomField();
                        mocCustomField.fullName = 'Product2.Product Code2__c';
                        mocCustomField.label = 'Product Code';
                        mocCustomField.type_x = 'Picklist';
                        mocCustomField.relationshipLabel = 'ProductCode';
                        mocCustomField.relationshipName = 'ProductCode';
                        mocCustomField.referenceTo = 'Product Code2__c';
                        
                        mocCustomField.valueSet = new MetadataService.ValueSet();
                        
                        List<MetadataService.CustomValue> picklistValueList = new List<MetadataService.CustomValue>();
                        
                        MetadataService.CustomValue customValue = new MetadataService.CustomValue();
                        customValue.fullName = '4G Access X'; //API name of picklist value
                        customValue.label = '4G Access X';
                        customValue.default_x = false;
                        customValue.isActive = true;
                        picklistValueList.add(customValue);
                        
                        
                        MetadataService.ValueSetValuesDefinition parentPicklist = new MetadataService.ValueSetValuesDefinition();
                        parentPicklist.sorted = true;
                        parentPicklist.value = picklistValueList;
                        
                        mocCustomField.valueSet.valueSetDefinition = parentPicklist;
                        mocCustomField.valueSet.controllingField = 'Family'; //parentPicklistFieldName;
                        
                        
                        List<MetadataService.CustomField> mocCustomFieldList = new List<MetadataService.CustomField>();
                        mocCustomFieldList.add (mocCustomField);
                        
                        
                        MetadataService.readCustomFieldResponse_element mockRes  = new MetadataService.readCustomFieldResponse_element ();
                        mockRes.result           = new MetaDataService.ReadCustomFieldResult();
                        mockRes.result.records   = mocCustomFieldList;
                        
                        response.put('response_x', mockRes);
                    }

                    else if (responseType == 'MetadataService.readStandardValueSetResponse_element') {
                        //MetadataService.MetadataPort service = createService();
                        MetadataService.StandardValue mocStandardValue = new MetadataService.StandardValue();
                        mocStandardValue.allowEmail = false;
                        mocStandardValue.closed = false;

                        List<MetadataService.StandardValue> mocStandardValueList = new List<MetadataService.StandardValue>();
                        mocStandardValueList.add(mocStandardValue);

                        MetadataService.StandardValueSet mocStandardValueSet = new MetadataService.StandardValueSet();
                        mocStandardValueSet.fullName = 'hello';
                        mocStandardValueSet.sorted = true;
                        mocStandardValueSet.standardValue = mocStandardValueList;
                        

                        List<MetadataService.StandardValueSet> mocStandardValueSetList = new List<MetadataService.StandardValueSet>();
                        mocStandardValueSetList.add (mocStandardValueSet);
                        
                        
                        MetadataService.readStandardValueSetResponse_element mockRes  = new MetadataService.readStandardValueSetResponse_element ();
                        mockRes.result           = new MetaDataService.ReadStandardValueSetResult();
                        mockRes.result.records   = mocStandardValueSetList;
                        
                        response.put('response_x', mockRes);
                    }
                    
                }
                
                if (requestName == 'updateMetadata') {
                    
                    MetadataService.updateMetadataResponse_element metadataResponse = new MetadataService.updateMetadataResponse_element();
                    
                    MetadataService.Error errorObj = new MetadataService.Error();
                    errorObj.message = 'error broo';
                    errorObj.statusCode = '666';
                    
                    MetadataService.SaveResult saveresult = new MetadataService.SaveResult();
                    saveresult.errors = new List<MetadataService.Error>();
                    saveresult.errors.add(errorObj);
                    saveresult.fullName = 'TestApp';
                    saveresult.success = true;
                    
                    metadataResponse.result = new List<MetadataService.SaveResult>();
                    metadataResponse.result.add(saveresult);
                    response.put('response_x', metadataResponse); 
                    
                }
               
            }
    }

    static testMethod void myUnitTest1() {
        Id recordTypeId_LicensedBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();

        Id recordTypeId_ProjectBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id recordTypeId_SIMCardBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id recordTypeId_SubscriptionBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id recordTypeId_UsageBased_NPRTicketProduct = Schema.SObjectType.NPRTicketProduct__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        Id recordTypeId_General_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('General').getRecordTypeId();

        Id recordTypeId_LicensedBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Licensed Based').getRecordTypeId();

        Id recordTypeId_ProjectBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Project Based').getRecordTypeId();

        Id recordTypeId_SIMCardBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('SIM-Card Based').getRecordTypeId();

        Id recordTypeId_SubscriptionBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Subscription Based').getRecordTypeId();

        Id recordTypeId_UsageBased_ProductOnboarding = Schema.SObjectType.New_Product_Registration_Ticket__c.getRecordTypeInfosByName().get('Usage Based').getRecordTypeId();

        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();

        Trigger_Controller__c TriggerController1 = new Trigger_Controller__c(
            Name = 'Trigger_NPRTicket',
            Is_Active__c = True
        );
        lstTriggerController.add(TriggerController1);

        Trigger_Controller__c TriggerController2 = new Trigger_Controller__c(
            Name = 'Trigger_ContentVersion_V2',
            Is_Active__c = True
        );
        lstTriggerController.add(TriggerController2);

        insert lstTriggerController;

        ServiceSetting__c serviceSettings = new ServiceSetting__c();
        serviceSettings.Name = 'ISP';
        serviceSettings.CircuitLastCounterNumber__c = 0;
        serviceSettings.CircuitPrefixName__c = '0';
        insert serviceSettings;

        POBEMAILSetting__c POBEMAILSetting = new POBEMAILSetting__c(
            Name = 'New Product Notification',
            Additional_Bcc_Email_Address__c = 'test.@gamil.com',
            Additional_CC_Email_Address__c = 'test.@gamil.com',
            Additional_To_Email_Address__c = 'test.@gamil.com',
            Email_Template_Name__c = 'New Product Approve Notification',
            Footer_URL__c = 'www.google.com',
            Header_URL__c = 'www.google.com',
            logo_url__c = 'www.google.com',
            Sender_Email_Address__c = 'Sales'
        );
        insert POBEMAILSetting;

        Pricebook2 standardPricebookREC = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        Update standardPricebookREC;

        
        list<POB_Product_Code_Config_Setting__c> List_POB_Product_Code_Config_Setting =new list<POB_Product_Code_Config_Setting__c>();

        POB_Product_Code_Config_Setting__c POB_Product_Code_Config_Setting1 = new POB_Product_Code_Config_Setting__c(
            Name = 'Circuit',
            Object_API_Name__c = 'Circuit__c',
            Field__c = 'Services__c',
            Type__c = 'Product Code',
            Have_Controlling_Field__c = false,
            Config_Type__c = 'No Site',
            isActive__c = true
        );
        List_POB_Product_Code_Config_Setting.add(POB_Product_Code_Config_Setting1);

        POB_Product_Code_Config_Setting__c POB_Product_Code_Config_Setting2 = new POB_Product_Code_Config_Setting__c(
            Name = 'NPRTicketProduct',
            Object_API_Name__c = 'NPRTicketProduct__c',
            Field__c = 'Services__c',
            Type__c = 'Product Code',
            Have_Controlling_Field__c = false,
            Config_Type__c = 'No Site',
             isActive__c = true
        );
        List_POB_Product_Code_Config_Setting.add(POB_Product_Code_Config_Setting2);

        POB_Product_Code_Config_Setting__c POB_Product_Code_Config_Setting3 = new POB_Product_Code_Config_Setting__c(
            Name = 'Product',
            Object_API_Name__c = 'Product2',
            Field__c = 'Product_Code2__c',
            Type__c = 'Product Code Code',
            Have_Controlling_Field__c = true,
            Config_Type__c = 'No Site',
             isActive__c = true
        );
        List_POB_Product_Code_Config_Setting.add(POB_Product_Code_Config_Setting3);

        insert List_POB_Product_Code_Config_Setting;
        

        

        New_Product_Registration_Ticket__c NewProductRegistrationTicket_SubscriptionBased = new New_Product_Registration_Ticket__c(
            Name = 'test4',
            Category__c = 'Subscription Based',
            RecordTypeId = recordTypeId_General_ProductOnboarding,
            Sim_Type__c = 'Postpaid',
            Site_Type__c = 'One Site',
            Approval_Status__c = 'Approved',
            Survey_Type__c = 'Auto Complete',
            Project_Type__c = 'Generic',
            Price_Book_Name__c = 'Test New Pricebook2',
            Price_Book_Active__c = true,
            Price_Book_Description__c = 'test',
            IsAgreement__c = false,
            Is_Standard_Price_Book__c = false
        );
        insert NewProductRegistrationTicket_SubscriptionBased;

        NPRTicketProduct__c NPRTicketProduct_LicensedBased = new NPRTicketProduct__c(
            Name = 'NPRTicketProduct_LicensedBased',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            RecordTypeId = recordTypeId_LicensedBased_NPRTicketProduct,
            Ticket_Product_Type__c = 'Licensed Based',
            Existing_Product_Code__c = 'MPLS',
            Product_Family__c = 'GSM',
            New_Product_Code__c = 'test1',
            New_Product_Family__c = 'Test1',
            Active__c = true,
            Valid__c = true,
            Charge_Type__c = 'Recurring',
            List_Price__c = 10000
        );
        insert NPRTicketProduct_LicensedBased;

        NPRTicketDocTempalate__c  NPRTicketDocTempalate = new NPRTicketDocTempalate__c(
            Name = 'BA_TEMPLATE',
            New_Product_Registration_Ticket__c = NewProductRegistrationTicket_SubscriptionBased.Id,
            Product_Code__c = 'test1',
            Service_Type__c = 'Newlink'
            //Type__c = ''
        );
        insert NPRTicketDocTempalate;

        Price_Plan__c PricePlan_Rec = new Price_Plan__c(
            Name = 'testPricePlan',
            Full_Name__c = 'testPricePlan'
        );
        insert PricePlan_Rec;

        Group_Service__c GroupService_Rec = new Group_Service__c(
            Name = 'TestGroupService',
            Unique_ID__c = 'TestGroupService',
            Type__c = 'New Revenue',
            Search_Term__c = 'Group Service'
        );
        insert GroupService_Rec;

        Device__c Device_Rec = new Device__c(
            Name = 'testDeviceRelated',
            Brand__c = 'Apple'
        );
        insert Device_Rec;

        AO__c AO_Rec = new AO__c(
            Name = 'testAORelated',
            AO_Code__c = '11123451', 
            Description__c = 'testAORelated',
            Full_Name__c = 'testAORelated'
        );
        insert AO_Rec;

        set<string> ticketIds = new set<string>();
        ticketIds.add(NewProductRegistrationTicket_SubscriptionBased.Id);

        set<string> newPicklistValues = new set<string>();
        newPicklistValues.add('Test123');

        String soapEnvelop = '';

        String DomDocSTring =  NewProductRegistrationTicketService.generateSoap(null,'SR_PR_Notification__c','One Site','One Site','One Site','Services__c','');

        Dom.Document DomDoc1 = new Dom.Document();
        DomDoc1.load(DomDocSTring);

        test.starttest(); 
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        MetadataService metaDataService = new MetadataService();
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();

        NewProductRegistrationTicketService NewProductRegistrationTicketService_Class = new NewProductRegistrationTicketService(ticketIds);


        NewProductRegistrationTicketService.getGlobalpicklist();

        NewProductRegistrationTicketService.checkGlobalPicklist('NPRTicketProduct__c');

        //NewProductRegistrationTicketService.makeHttpRequest();

        NewProductRegistrationTicketService.makeHttpCallout('update', soapEnvelop);

        NewProductRegistrationTicketService.updateGlobalPicklistRecordType('update', soapEnvelop);

        //NewProductRegistrationTicketService.parseSoapRepsonse(DomDoc1);

        //NewProductRegistrationTicketService.handleSoapFault(DomDoc1);

        //NewProductRegistrationTicketService.getNodeString();

        NewProductRegistrationTicketService.createService();

        //NewProductRegistrationTicketService.(JSON.serialize(newPicklistValues_Map.get(List_NewProductRegistrationTicket_Extract.Id)), JSON.serialize(newDependentPicklistValues_Map.get(List_NewProductRegistrationTicket_Extract.Id)), 'By Site Number', 'One Site',tikectIds);

        //NewProductRegistrationTicketService.updateGlobalPicklist(newAllPicklistValues_Set,valueSetName, List_POBProductCodeConfigSetting_Extract.Object_API_Name__c,List_POBProductCodeConfigSetting_Extract.Field__c);

        NewProductRegistrationTicketService.updateRecordType(newPicklistValues,'SR_PR_Notification__c','Services__c','One Site');

        NewProductRegistrationTicketService.generateSoap(null,'SR_PR_Notification__c','One Site','One Site','One Site','Services__c','');

        //NewProductRegistrationTicketService.updateDependentPicklist(DependentPicklistValues_Map,tikectIds);

        NewProductRegistrationTicketService.createPriceBookAndProduct(ticketIds);

        NewProductRegistrationTicketService.createTemplateMapping(ticketIds);

        NewProductRegistrationTicketService.sendEmailforNewProduct(ticketIds);

        //NewProductRegistrationTicketService.setDependentPicklist(newPicklistValues);
        test.stoptest();
    }


    static testMethod void parseSoapRepsonseTEST() {
        
        String XMLString = '';
        
        String successXMLString = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><updateMetadataResponse xmlns="urn:partner.soap.sforce.com"><result xmlns="urn:partner.soap.sforce.com"><success xmlns="urn:partner.soap.sforce.com">true</success></result></updateMetadataResponse></Body></Envelope>';
        
        string failedXMLString = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><updateMetadataResponse xmlns="urn:partner.soap.sforce.com"><result xmlns="urn:partner.soap.sforce.com"><success xmlns="urn:partner.soap.sforce.com">false</success><errors xmlns="urn:partner.soap.sforce.com"><statusCode xmlns="urn:partner.soap.sforce.com">999</statusCode><message xmlns="urn:partner.soap.sforce.com">error system of ..</message></errors></result></updateMetadataResponse></Body></Envelope>';
        
        DOM.Document doc = new DOM.Document();        
        system.debug ('===== doc : ' + doc);
        
        
        test.starttest(); //-----------------
        
        doc.load(successXMLString);
        string result1 = NewProductRegistrationTicketService.parseSoapRepsonse(doc);
        
        doc = new DOM.Document();
        doc.load(failedXMLString);
        string result2 = NewProductRegistrationTicketService.parseSoapRepsonse(doc);
        
        test.stoptest(); //___________________
    }

    static testMethod void handleSoapFaultTEST() {
        
        
        String XMLString = '<Envelope ><Body xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Fault xmlns="http://schemas.xmlsoap.org/soap/envelope/"><faultstring  >hello</faultstring></Fault></Body></Envelope>';
        
        
        DOM.Document doc = new DOM.Document(); 
        system.debug ('===== doc : ' + doc);
        
        
        test.starttest(); //----------------------------
        doc.load(XMLString);
        string result1 = NewProductRegistrationTicketService.handleSoapFault(doc);
        
        test.stoptest(); //_____________________________
    }

    class GlobalValueSetWebServiceMockImpl implements WebServiceMock {
        
        //WebServiceMock(string constructorArgs) {
        //   // save the constructor args in local vbls
        //}
        
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType){
                // using the variables you saved in the constructor as input, 
                // return values in the arguments to this method in response
                
                system.debug('=== stub : ' + stub);
                system.debug('=== request : ' + request);
                system.debug('=== response : ' + response);
                system.debug('=== endpoint : ' + endpoint);
                system.debug('=== soapAction : ' + soapAction);
                system.debug('=== requestName : ' + requestName);
                system.debug('=== responseNS : ' + responseNS);
                system.debug('=== responseName : ' + responseName);
                system.debug('=== responseType : ' + responseType);
                
                if (requestName == 'readMetadata') {
                    MetadataService.GlobalValueSet mockGlobalValueSet = new MetadataService.GlobalValueSet();
                    MetadataService.CustomValue newItem = new MetadataService.CustomValue();
                    newItem.fullName = 'value';
                    newItem.label = 'label';
                    newItem.isActive = true;
                    newItem.default_x = false;
                    
                    if(mockGlobalValueSet.customValue == null){
                        mockGlobalValueSet.customValue = new List<MetadataService.CustomValue>();
                    }
                    
                    mockGlobalValueSet.customValue.add(newItem);
                    
                    mockGlobalValueSet.masterLabel='test123';
                    mockGlobalValueSet.sorted=false;
                    mockGlobalValueSet.description='sd';
                    
                    List<MetadataService.GlobalValueSet> mockGlobalValueSetList = new List<MetadataService.GlobalValueSet>();
                    mockGlobalValueSetList.add (mockGlobalValueSet);
                    
                    MetadataService.readGlobalValueSetResponse_element mockRes  = new MetadataService.readGlobalValueSetResponse_element ();
                    mockRes.result           = new MetaDataService.ReadGlobalValueSetResult ();
                    mockRes.result.records   = mockGlobalValueSetList;
                    
                    response.put('response_x', mockRes);
                    
                }
                
                if (requestName == 'updateMetadata') {
                    
                    MetadataService.updateMetadataResponse_element metadataResponse = new MetadataService.updateMetadataResponse_element();
                    
                    MetadataService.Error errorObj = new MetadataService.Error();
                    errorObj.message = 'error broo';
                    errorObj.statusCode = '666';
                    
                    MetadataService.SaveResult saveresult = new MetadataService.SaveResult();
                    saveresult.errors = new List<MetadataService.Error>();
                    saveresult.errors.add(errorObj);
                    saveresult.fullName = 'TestApp';
                    saveresult.success = true;
                    
                    metadataResponse.result = new List<MetadataService.SaveResult>();
                    metadataResponse.result.add(saveresult);
                    response.put('response_x', metadataResponse); 
                    
                }
                
                
                
            }
    }

    static testMethod void updateGlobalPicklistTEST() {
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType = 'NPRTicketProduct__c' and isActive=true];
        
        test.starttest(); //------------------------------------------------------------------
        
        set<String> newPicklistValues = new set<String>();
        String valueSetName;
        String objectApiName;
        String fieldApiName;
        
        newPicklistValues.add ('Test');
        newPicklistValues.add ('Test2');
        newPicklistValues.add ('Test3');
        valueSetName = 'Test';
        objectApiName = 'NPRTicketProduct__c';
        fieldApiName = 'Existing_Product_Code__c';
        
        //-- for MetadataService.GlobalValueSet -------------------------------
        // given a mock web service
        GlobalPicklistWebServiceMockImpl myMockWs = new GlobalPicklistWebServiceMockImpl();
        
        // given mock web service injected
        Test.setMock(WebServiceMock.class, myMockWs);
        
        /*  method information ----------
            updateGlobalPicklist(
            set<String> newPicklistValues,
            String valueSetName, 
            String objectApiName, 
            String fieldApiName
            ){
        */

        datetime lastTimeOfRTDistribution = system.now().addMinutes(1);

        NewProductRegistrationTicketService.updateGlobalPicklist(newPicklistValues, valueSetName, objectApiName, fieldApiName, lastTimeOfRTDistribution);
        
        test.stoptest(); //__________________________________________________________________________
    }


    static testMethod void updatePicklistTEST() {
        ServiceSetting__c serviceSettings = new ServiceSetting__c();
        serviceSettings.Name = 'ISP';
        serviceSettings.CircuitLastCounterNumber__c = 0;
        serviceSettings.CircuitPrefixName__c = '0';
        insert serviceSettings;

        list<POB_Product_Code_Config_Setting__c> List_POB_Product_Code_Config_Setting =new list<POB_Product_Code_Config_Setting__c>();

        POB_Product_Code_Config_Setting__c POB_Product_Code_Config_Setting1 = new POB_Product_Code_Config_Setting__c(
            Name = 'Circuit',
            Object_API_Name__c = 'Circuit__c',
            Field__c = 'Services__c',
            Type__c = 'Product Code',
            Have_Controlling_Field__c = false,
            Config_Type__c = 'No Site'
        );
        List_POB_Product_Code_Config_Setting.add(POB_Product_Code_Config_Setting1);

        POB_Product_Code_Config_Setting__c POB_Product_Code_Config_Setting2 = new POB_Product_Code_Config_Setting__c(
            Name = 'NPRTicketProduct',
            Object_API_Name__c = 'NPRTicketProduct__c',
            Field__c = 'Services__c',
            Type__c = 'Product Code',
            Have_Controlling_Field__c = false,
            Config_Type__c = 'No Site'
        );
        List_POB_Product_Code_Config_Setting.add(POB_Product_Code_Config_Setting2);

        POB_Product_Code_Config_Setting__c POB_Product_Code_Config_Setting3 = new POB_Product_Code_Config_Setting__c(
            Name = 'Product',
            Object_API_Name__c = 'Product2',
            Field__c = 'Product_Code2__c',
            Type__c = 'Product Code',
            Have_Controlling_Field__c = true,
            Config_Type__c = 'By Site Number'
        );
        List_POB_Product_Code_Config_Setting.add(POB_Product_Code_Config_Setting3);

        POB_Product_Code_Config_Setting__c POB_Product_Code_Config_Setting4 = new POB_Product_Code_Config_Setting__c(
            Name = 'ProductName',
            Object_API_Name__c = 'Product2',
            Field__c = 'Name',
            Type__c = 'Product Code',
            Have_Controlling_Field__c = false,
            Config_Type__c = 'By Site Number'
        );
        List_POB_Product_Code_Config_Setting.add(POB_Product_Code_Config_Setting4);

        insert List_POB_Product_Code_Config_Setting;



        String newPicklistValues_String = '{"Product Code" : ["Test1", "Test2", "Test3", "Test4"], "Product Family" : ["Test11", "Test22", "Test33", "Test44"]}';
        String DependentPicklistValues_String = '{"test1":["test1"],"Test2":["Test2"] }';
        String ConfigType = 'By Site Number'; 
        String siteType = 'One Site';
        Set<String> tikectIds = new Set<String> ();

        test.starttest();
        
        // given a mock web service
        UpdatePicklistWebServiceMockImpl myMockWs = new UpdatePicklistWebServiceMockImpl();
                                                         
        Test.setMock(WebServiceMock.class, myMockWs);
        

        NewProductRegistrationTicketService.updatePicklist(newPicklistValues_String, DependentPicklistValues_String,  ConfigType, siteType, tikectIds);

        siteType = 'Two Site';
        NewProductRegistrationTicketService.updatePicklist(newPicklistValues_String, DependentPicklistValues_String,  ConfigType, siteType, tikectIds);

        siteType = 'All';
        NewProductRegistrationTicketService.updatePicklist(newPicklistValues_String, DependentPicklistValues_String,  ConfigType, siteType, tikectIds);
        
        test.stoptest();

    }

    static testMethod void fake_Test() {
        NewProductRegistrationTicketService.fakeMethod();
    }

}