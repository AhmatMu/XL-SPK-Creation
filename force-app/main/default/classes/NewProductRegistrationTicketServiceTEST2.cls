/**
* @description       : 
* @author            : Doddy Prima
* @group             : 
* @last modified on  : 29-03-2022
* @last modified by  : Doddy Prima
* Modifications Log
* Ver   Date         Author        Modification
* 1.0   22-03-2022   Doddy Prima   Initial Version
**/

@isTest()
public with sharing class NewProductRegistrationTicketServiceTEST2 {
    
    /*
public string XMLgen(){
DOM.Document doc = new DOM.Document();

dom.XmlNode products = doc.createRootElement('products', null, null);
dom.XmlNode body1= products.addChildElement('product', null, null);

body1.addChildElement('Name', null, null).addTextNode('Xbox One');
body1.addChildElement('Code', null, null).addTextNode('XBO');

dom.XmlNode body2= products.addChildElement('product', null, null);

body2.addChildElement('Name', null, null).addTextNode('PlayStation 4');
body2.addChildElement('Code', null, null).addTextNode('PS4');

dom.XmlNode body3= products.addChildElement('product', null, null);

body3.addChildElement('Name', null, null).addTextNode('WII');
body3.addChildElement('Code', null, null).addTextNode('Wii');

xmlstring = doc.toXmlString();

return xmlstring;
}*/
    
    class WebServiceMockImpl01 implements WebServiceMock {
        
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
                
                
                /*
                MetadataService.CustomLabel[] mockCustomLabels = new 
                List<MetadataService.CustomLabel>();
                MetadataService.CustomLabel mockLabel = new MetadataService.CustomLabel();
                mockLabel.fullname = 'foo';
                mockLabel.xxx = ... // set other fields here
                mockCustomLabels.add(mockLabel);
                */
                
                //---
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
                
                //service.createMetadata( new MetadataService.Metadata[]{ mockGlobalValueSet });
                
                
                // do more labels
                /*MetadataService.readCustomFieldResponse_element mockRes  = new  
                MetadataService.readCustomFieldResponse_element();
                mockRes.result           = new MetaDataService.ReadCustomLabelsResult();
                mockRes.result.records   = mockGlobalValueSet;
                */
                
                MetadataService.readGlobalValueSetResponse_element mockRes  = new MetadataService.readGlobalValueSetResponse_element ();
                mockRes.result           = new MetaDataService.ReadGlobalValueSetResult ();
                mockRes.result.records   = mockGlobalValueSetList;
                
                
                
                //if(request instanceof MetadataService.readMetadata) {
                //		response.put('response_x', new MetadataService.readCustomMetadataResponse_element());
                //}
                response.put('response_x', mockRes);
                
            }
    }
    
    class WebServiceMockImpl02 implements WebServiceMock {
        
        //WebServiceMock(string constructorArgs) {
        //   // save the constructor args in local vbls
        //}
        
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType){
                // using the variables you saved in the constructor as input, 
                // return values in the arguments to this method in response
                
                
                
                
                MetadataService.createMetadataResponse_element metadataResponse = new MetadataService.createMetadataResponse_element();
                
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
    
    
    class WebServiceMockImpl implements WebServiceMock {
        
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
    
    
    
    static testMethod void parseSoapRepsonseTEST() {
        
        String XMLString = '';
        
        String successXMLString = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><updateMetadataResponse xmlns="urn:partner.soap.sforce.com"><result xmlns="urn:partner.soap.sforce.com"><success xmlns="urn:partner.soap.sforce.com">true</success></result></updateMetadataResponse></Body></Envelope>';
        
        string failedXMLString = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><updateMetadataResponse xmlns="urn:partner.soap.sforce.com"><result xmlns="urn:partner.soap.sforce.com"><success xmlns="urn:partner.soap.sforce.com">false</success><errors xmlns="urn:partner.soap.sforce.com"><statusCode xmlns="urn:partner.soap.sforce.com">999</statusCode><message xmlns="urn:partner.soap.sforce.com">error system of ..</message></errors></result></updateMetadataResponse></Body></Envelope>';
        
        DOM.Document doc = new DOM.Document();
        
        
        system.debug ('===== doc : ' + doc);
        
        Set<String> IDs = new Set<String> ();
        IDs.add ('123321');
        test.starttest();
        doc.load(successXMLString);
        string result1 = NewProductRegistrationTicketService.parseSoapRepsonse(doc);
        
        doc = new DOM.Document();
        doc.load(failedXMLString);
        string result2 = NewProductRegistrationTicketService.parseSoapRepsonse(doc);
        test.stoptest();
    }
    
    static testMethod void handleSoapFaultTEST() {
        
        
        String XMLString = '<Envelope ><Body xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Fault xmlns="http://schemas.xmlsoap.org/soap/envelope/"><faultstring  >hello</faultstring></Fault></Body></Envelope>';
        
        
        DOM.Document doc = new DOM.Document(); 
        system.debug ('===== doc : ' + doc);
        
        
        test.starttest();
        doc.load(XMLString);
        string result1 = NewProductRegistrationTicketService.handleSoapFault(doc);
        
        test.stoptest();
    }
    static testMethod void updateGlobalPicklistTEST() {
        
        
        test.starttest();
        
        set<String> newPicklistValues = new set<String>();
        String valueSetName;
        String objectApiName;
        String fieldApiName;
        
        newPicklistValues.add ('Test');
        valueSetName = 'Test';
        objectApiName = 'Pricebook2';
        fieldApiName = 'Product_Category';
        
        //-- for MetadataService.GlobalValueSet -------------------------------
        // given a mock web service
        // string dependencyinjectionArgs = '';
        WebServiceMockImpl myMockWs = new WebServiceMockImpl();
        
        // given mock web service injected
        Test.setMock(WebServiceMock.class, myMockWs);
        
        
        
        //-- for MetadataService.GlobalValueSet -------------------------------
        // given a mock web service
        // string dependencyinjectionArgs = '';
        //WebServiceMockImpl01 myMockWs01 = new WebServiceMockImpl01();
        
        // given mock web service injected
        //Test.setMock(WebServiceMock.class, myMockWs01);
        
        
        
        
        
        //-- for MetadataService.SaveResult -----------------------------------
        // given a mock web service
        //WebServiceMockImpl02 myMockWs02 = new WebServiceMockImpl02();
        
        // given mock web service injected
        //Test.setMock(WebServiceMock.class, myMockWs02);
        
        
        
        
        /*  method information ----------
        updateGlobalPicklist(
        set<String> newPicklistValues,
        String valueSetName, 
        String objectApiName, 
        String fieldApiName
        ){
        */
        NewProductRegistrationTicketService.updateGlobalPicklist(newPicklistValues, valueSetName, objectApiName, fieldApiName );
        
        
        test.stoptest();
    }
    
    
    
    
    static testMethod void updateDependentPicklistTEST() {
        
        Map<String, List<String>> dependentPicklistValues_Map = new Map<String, List<String>>();
        Set<String> tikectIds = new Set<String> ();
        
        test.starttest();
        
        NewProductRegistrationTicketService.updateDependentPicklist (dependentPicklistValues_Map, tikectIds);
        
        
        test.stoptest();
    }
    static testMethod void setDependentPicklistTEST() {
        
        test.starttest();
        
        
        
        test.stoptest();
    }


    static testMethod void updatePicklistTEST() {
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

        test.starttest();

        
        // NewProductRegistrationTicketService.updatePicklist(String newPicklistValues_String, String DependentPicklistValues_String,  String ConfigType, String siteType,Set<String> tikectIds){

            String newPicklistValues_String = '{"Product Code" : ["Test1", "Test2", "Test3", "Test4"], "Product Family" : ["Test11", "Test22", "Test33", "Test44"]}';
            String DependentPicklistValues_String = '{"test1":["test1"],"Test2":["Test2"] }';
            String ConfigType = 'By Site Number'; 
            String siteType = 'One Site';
            Set<String> tikectIds = new Set<String> ();

            
            // given a mock web service
            UpdatePicklistWebServiceMockImpl myMockWs = new UpdatePicklistWebServiceMockImpl();
            
            // given mock web service injected
            Test.setMock(WebServiceMock.class, myMockWs);

            NewProductRegistrationTicketService.updatePicklist(newPicklistValues_String, DependentPicklistValues_String,  ConfigType, siteType, tikectIds);
    
            siteType = 'Two Site';
            NewProductRegistrationTicketService.updatePicklist(newPicklistValues_String, DependentPicklistValues_String,  ConfigType, siteType, tikectIds);
            
        
        test.stoptest();
    }

}