public class MassRecordUpdateController {

    public class MAS_UPDATE_OBJECT{
        public String value;
        public String lablel;
    }

    public class FILTER_RECORD_WRAPPER{
        public String textField;
        public Integer numberField;
        public Boolean checkboxField;
        public Date startDateField;
        public Date endDateField;
        public Date dateTimeField;
        public String filterUpdateField;
        public String fieldType;
        public String pickListField;
        public String textareaField;
    }

    public class SearchRecordItemsDataWrapper {
        public Integer pageSize {get;set;}
        public Integer pageNumber {get;set;}
        public Integer totalRecords {get;set;}
        public Integer recordStart {get;set;}
        public Integer recordEnd {get;set;}
        public List<sobject> sobjectrecordList {get;set;}
        public List<sobject> sobjectrecordAllItemList {get;set;}

    }   

    public class RecordItemsDataWrapper {
        public Integer pageSize {get;set;}
        public Integer pageNumber {get;set;}
        public Integer totalRecords {get;set;}
        public Integer recordStart {get;set;}
        public Integer recordEnd {get;set;}
        public List<sobject> massRecordUpdateItems {get;set;}
        public List<sobject> massRecordUpdateAllItems {get;set;}
    } 

    public class TYPE_ATTRIBUTE {
        public String fieldName = '';
    }

    // gakepake public List<Mass_Record_Update_Item__c> removeRecordUpdateItems {get;set;}
    // method
    @AuraEnabled
    public static String getSobjectHeaderColumn(String SobjectApiName) {
        system.debug('in getSobjectHeaderColumn ');
        system.debug('SobjectApiName: '+ SobjectApiName);
        String whereCondition = '';
        List<String> whereConditionList = new List<String>();

        String bodyJson;
        List<String> fieldList = new List<String>();
        List<String> fieldInitiateList = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        JSONGenerator bodyJsonMessage = JSON.createGenerator(true);
        system.debug(' fieldMap.keySet(): ' + fieldMap.keySet());
        system.debug(' fieldMap.values(): ' + fieldMap.values());
        
        bodyJsonMessage.writeStartArray();
        
        for (Schema.SObjectField fieldName : fieldMap.values()) {
            TYPE_ATTRIBUTE typeAttribute = new TYPE_ATTRIBUTE();
            system.debug('fieldName: ' + fieldName);
            
            String fieldLabel = fieldName.getDescribe().getLabel();
            Schema.DisplayType fieldType = fieldName.getDescribe().getType();
            String fieldTypeValue = String.valueOf(fieldType);
            String fieldNameValue = String.valueOf(fieldName);
            String fieldLabelValue = String.valueOf(fieldLabel);
            String sortable = String.valueOf(true);
            
            bodyJsonMessage.writeStartObject();
            if (fieldLabel != null){                 
                if (fieldLabelValue == 'Record ID') {
                    fieldLabel = 'SR/PR Notification Name';
                } else {
                    fieldLabel = fieldLabel;
                }

                bodyJsonMessage.writeStringField('label', fieldLabel);
            } else {
                bodyJsonMessage.writeNullField('label');
            }

            if(fieldName != null){
                bodyJsonMessage.writeStringField('fieldName', fieldNameValue);
            }else {
                bodyJsonMessage.writeNullField('fieldName');
            }

            if (sortable != null) {
                bodyJsonMessage.writeStringField('sortable', sortable);
            } else {
                bodyJsonMessage.writeNullField('sortable');
            }
            
            if (fieldTypeValue != null){
                if (fieldTypeValue == 'REFERENCE' || fieldTypeValue == 'ID') {
                    bodyJsonMessage.writeStringField('type', 'url');
                    bodyJsonMessage.writeFieldName('typeAttributes');
                    bodyJsonMessage.writeStartObject();
                        bodyJsonMessage.writeFieldName('label');
                            bodyJsonMessage.writeStartObject();
                                if (fieldNameValue.right(3) == '__c') {
                                    fieldNameValue = fieldNameValue.replace('__c', '__r');
                                } else if (fieldNameValue.right(2) == 'Id' && fieldNameValue != 'Id') {
                                    fieldNameValue = fieldNameValue.replace('Id', '');
                                } else if (fieldNameValue == 'Id') {
                                    fieldNameValue = 'Name';
                                } else {
                                    fieldNameValue = fieldNameValue;
                                }

                                bodyJsonMessage.writeStringField('fieldName', fieldNameValue);
                            bodyJsonMessage.writeEndObject();
                        bodyJsonMessage.writeStringField('target', '_blank');
                    bodyJsonMessage.writeEndObject();
                } else {
                    bodyJsonMessage.writeStringField('type', fieldTypeValue);
                }     
            } else {
                bodyJsonMessage.writeNullField('type');
            }
            bodyJsonMessage.writeEndObject();
        }
        
        bodyJsonMessage.writeEndArray();                                
        bodyJson = bodyJsonMessage.getAsString();
        system.debug('bodyJson: ' + bodyJson);
        return bodyJson;
    } 

    @AuraEnabled
    public static String getSobjectItemsHeaderColumn(String SobjectApiName) {
        system.debug('in getSobjectItemsHeaderColumn ');
        system.debug('SobjectApiName: '+ SobjectApiName);
        String whereCondition = '';
        List<String> whereConditionList = new List<String>();

        String bodyJsonSobject;
        String bodyJsonRecordItem;
        List<String> fieldList = new List<String>();
        List<String> fieldInitiateList = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        //Map<String, Schema.SObjectField> fieldMap = schemaMap.get('Mass_Record_Update_item__c').getDescribe().fields.getMap();

        JSONGenerator bodyJsonMessage = JSON.createGenerator(true);
        system.debug(' fieldMap.keySet(): ' + fieldMap.keySet());
        system.debug(' fieldMap.values(): ' + fieldMap.values());
        
        bodyJsonMessage.writeStartArray();
        
        for (Schema.SObjectField fieldName : fieldMap.values()) {
            TYPE_ATTRIBUTE typeAttribute = new TYPE_ATTRIBUTE();

            system.debug('fieldName: ' + fieldName);
            
            String fieldLabel = fieldName.getDescribe().getLabel();
            if (fieldLabel == 'Mass Update Status' ) {
                fieldLabel = 'Mass Update Status';
            }
    
            Schema.DisplayType fieldType = fieldName.getDescribe().getType();
            String fieldTypeValue = String.valueOf(fieldType);
            String fieldNameValue = String.valueOf(fieldName);
            String fieldLabelValue = String.valueOf(fieldLabel);
            String sortable = String.valueOf(true);
            
            bodyJsonMessage .writeStartObject();
                if (fieldLabel != null) {
                    if (fieldLabelValue == 'Record ID') {
                        fieldLabel = 'SR/PR Notification Name';
                    } else {
                        fieldLabel = fieldLabel;
                    }

                    bodyJsonMessage.writeStringField('label', fieldLabel);
                } else {
                    bodyJsonMessage.writeNullField('label');
                }

                if (fieldName != null){
                    bodyJsonMessage.writeStringField('fieldName', fieldNameValue);
                } else {
                    bodyJsonMessage.writeNullField('fieldName');
                }

                /*
                if(editable != null){
                    if (fieldTypeValue != 'ID' && fieldTypeValue == 'PICKLIST') {
                        List<Schema.PickListEntry> pick_List_values = fieldMap.get(fieldNameValue).getDescribe().getPickListValues();

                        if (fieldLabel != 'Mass Update Status' && fieldLabel != 'Project Completed Date IDN' && fieldLabel != 'Created Date' && fieldLabel != 'Last Activity Date' && fieldLabel != 'Last Modified Date' && fieldLabel != 'Last Viewed Date' && fieldLabel != 'System Modstamp' && fieldLabel != 'SR/PR Notification Name' && fieldLabel != 'Deleted' && fieldLabel != 'A Number' && fieldLabel != 'CPE Additional Request' && fieldLabel != 'Opportunity ID' && fieldLabel != 'Billing Start Date IND' && fieldLabel != 'Billing_Start_Date_DAY_IND' && fieldLabel != 'Opportunity_ServiceType' && fieldLabel != 'Opportunity_RecordTypeName' && fieldLabel != 'Aging SLA Category' && fieldLabel != 'Project Coordinator' && fieldLabel != 'Formula Opportunity ID' && fieldLabel != 'Site A Full Address' && fieldLabel != 'Site B Full Address' && fieldLabel != 'Sales Name' && fieldLabel != 'Opportunity Name' && fieldLabel != 'Service Type' && fieldLabel != 'BA_Date_DAY_IND' && fieldLabel != 'Auto Renewal UOM' && fieldLabel != 'Auto Renewal Periode' && fieldLabel != 'Periode UOM' && fieldLabel != 'Contract Periode' && fieldLabel != 'LinkInOpportunity' && fieldLabel != 'project_completed_date_idn__c' && fieldLabel != 'pic_customer_name__c' && fieldLabel != 'account_name__c' && fieldLabel != 'Aging Survey Complete' && fieldLabel != 'Aging SR Close' && fieldLabel != 'Aging SLA' && fieldLabel != 'Aging Trial (Days)' && fieldLabel != 'Aging WBA (Days)' && fieldLabel != 'Aging Waiting PR' && fieldLabel != 'Aging(days)' && fieldLabel != 'Opportunity Trial' && fieldLabel != 'Is Any Profitability' && fieldLabel != 'PIC Customer Name' && fieldLabel != 'Account Name') {
                            bodyJsonMessage.writeStringField('editable', editable);
                            bodyJsonMessage.writeFieldName('typeAttributes');
                            bodyJsonMessage.writeStartObject();
                                bodyJsonMessage.writeStringField('placeholder', 'Choose Type');
                                bodyJsonMessage.writeFieldName('options');
                                bodyJsonMessage.writeStartArray();

                                for (Schema.PickListEntry pickListValue : pick_List_values) { //for all values in the pickList List
                                    String fieldLabelPickList = (String) pickListValue.getLabel();
                                    String fieldNameValuePickList = (String) pickListValue.getValue();
                        
                                    bodyJsonMessage.writeStartObject();

                                        if(fieldLabel != null){                 
                                            bodyJsonMessage.writeStringField('label', fieldLabelPickList );
                                        }else {
                                            bodyJsonMessage.writeNullField('label');
                                        }
                        
                                        if(fieldName != null){
                                            bodyJsonMessage.writeStringField('value',  fieldNameValuePickList);
                                        }else {
                                            bodyJsonMessage.writeNullField('value');
                                        }

                                    bodyJsonMessage.writeEndObject();
                                }
                                bodyJsonMessage.writeEndArray();
                            bodyJsonMessage.writeEndObject();
                        }
                    }
                }else {
                    bodyJsonMessage.writeNullField('editable');
                }
                */

                if (sortable != null) {
                    bodyJsonMessage.writeStringField('sortable', sortable);
                } else {
                    bodyJsonMessage.writeNullField('sortable');
                }
                
                if (fieldTypeValue != null){
                    if (fieldTypeValue == 'REFERENCE' || fieldTypeValue == 'ID') {
                        bodyJsonMessage.writeStringField('type', 'url');
                        bodyJsonMessage.writeFieldName('typeAttributes');
                        bodyJsonMessage.writeStartObject();
                            bodyJsonMessage.writeFieldName('label');
                                bodyJsonMessage.writeStartObject();
                                    if (fieldNameValue.right(3) == '__c') {
                                        fieldNameValue = fieldNameValue.replace('__c', '__r');
                                    } else if (fieldNameValue.right(2) == 'Id' && fieldNameValue != 'Id') {
                                        fieldNameValue = fieldNameValue.replace('Id', '');
                                    } else if (fieldNameValue == 'Id') {
                                        fieldNameValue = 'Name';
                                    } else {
                                        fieldNameValue = fieldNameValue;
                                    }

                                    bodyJsonMessage.writeStringField('fieldName', fieldNameValue);
                                bodyJsonMessage.writeEndObject();    
                            bodyJsonMessage.writeStringField('target', '_blank');
                        bodyJsonMessage.writeEndObject();
                    }
                } else {
                    bodyJsonMessage.writeNullField('type');
                }

            bodyJsonMessage.writeEndObject();
        }
        
        //bodyJsonMessage.writeEndArray();                                
        bodyJsonSobject = bodyJsonMessage.getAsString();
        system.debug('bodyJsonSobject: ' + bodyJsonSobject);
        return bodyJsonSobject;
    } 
 
    @AuraEnabled
    public static String getSobjectListFieldsType(String fieldName, String SobjectApiName){
        system.debug('in getSobjectListFieldsType');
        system.debug('=== fieldName: ' + fieldName);
        system.debug('=== SobjectApiName: ' + SobjectApiName);

        fieldName = fieldName.toLowerCase();
        fieldName = fieldName.trim();
        system.debug('=== fieldName: ' + fieldName);

        try {
 
            String fieldTypeValue;

            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            system.debug('schemaMap: ' + schemaMap );
            if(SobjectApiName != null){
                Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
                system.debug('=== fieldMap: ' + fieldMap); // test
                
                if(fieldName != null){
                    Schema.SObjectField fieldNameMap = fieldMap.get(fieldName);
                    Schema.DisplayType fieldType = fieldNameMap.getDescribe().getType();
                    fieldTypeValue = String.valueOf(fieldType) ;
                    system.debug('=== fieldTypeValue: '+ fieldTypeValue);
                }
            }
            return fieldTypeValue;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSobjectListFieldsName(String fieldLable, String SobjectApiName){
        system.debug(' in getSobjectListFieldsName');
        system.debug(' fieldLable: ' + fieldLable);
        try {
            String fieldLableValue = '';

            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            system.debug('schemaMap: ' + schemaMap );
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

            system.debug('fieldMap: ' + fieldMap);
            for(String fieldName : fieldMap.keyset()){
                system.debug('fieldName: '+ fieldName);
                system.debug('fieldLable: '+ fieldLable);
                if(fieldMap.get(fieldName).getDescribe().getLabel() == fieldLable){
                    fieldLableValue = fieldName;
                }
            }
            system.debug('fieldLableValue: ' + fieldLableValue);

            return fieldLableValue;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getSobjectListFieldsLable(String SobjectApiName, string recordTypeName){
        system.debug('in getSobjectListFieldsLable');
        system.debug('in recordTypeName: ' + recordTypeName);
        system.debug('SobjectApiName: ' + SobjectApiName);
        //try {
            List<String> fieldInitiateList = new List<String>();
            /*
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            system.debug('schemaMap: ' + schemaMap );
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

            system.debug('fieldMap: ' + fieldMap);
            for(String fieldName : fieldMap.keyset()){
                String fieldType = MassRecordUpdateController.getSobjectListFieldsType(fieldName, SobjectApiName);

                if (fieldType != 'TEXTAREA' && fieldType != 'ID' && fieldType != 'REFERENCE') {
                    fieldInitiateList.add(fieldMap.get(fieldName).getDescribe().getLabel());   
                }
            }
            system.debug('fieldInitiateList: ' + fieldInitiateList);
            */

            /**
            **  get field based on page layout ini tidak ideal 
            **  seharusnya mengambil record type terlebih dahulu baru mendapatkan page layout berdasarkan user login
            **  "untuk search by criteria"
            **/
            List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {SobjectApiName+ '-' + recordTypeName});
            Metadata.Layout layoutMetaData = (Metadata.Layout)layouts.get(0);
            for (Metadata.LayoutSection section : layoutMetaData.layoutSections) {
                for (Metadata.LayoutColumn column : section.layoutColumns) {
                    if (column.layoutItems != null) {
                        for (Metadata.LayoutItem item : column.layoutItems) {
                            system.debug('=== item.field : ' + item.field );
                            if(item.field != null){
                                String fieldType = MassRecordUpdateController.getSobjectListFieldsType(item.field, SobjectApiName);
                                System.debug('=== fieldType : ' + fieldType);

                                if (fieldType != 'TEXTAREA' && fieldType != 'ID' && fieldType != 'REFERENCE') {
                                    System.debug('=== item : ' + item.field);
                                    Schema.SObjectType objectType = Schema.getGlobalDescribe().get(SobjectApiName);
                                    Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
                                    Schema.SObjectField field = objectDescribe.fields.getMap().get(item.field);
                                    String fieldLabel = field.getDescribe().getLabel();
                                    System.debug('=== fieldLabel : ' + fieldLabel);
                                    fieldInitiateList.add(fieldLabel);
                                }
                            }
                        }
                    }
                }
            }
            System.debug('=== fieldInitiateList : ' + fieldInitiateList.size());

            return fieldInitiateList;
        /*
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }*/
    }   

    @AuraEnabled
    public static List<String> getSobjectRecordItemListFieldsLable(String SobjectApiName, string recordTypeName){
        system.debug(' in getSobjectRecordItemListFieldsLable');
        system.debug(' SobjectApiName: ' + SobjectApiName);
        try {
            List<String> fieldInitiateList = new List<String>();
            /*
            List<String> fieldInitiateList = new List<String>();

            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            system.debug('schemaMap: ' + schemaMap );
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

            system.debug('fieldMap: ' + fieldMap);
            for (String fieldName : fieldMap.keyset()){
                String fieldType = MassRecordUpdateController.getSobjectListFieldsType(fieldName, SobjectApiName);

                if (fieldType != 'ID' && fieldType != 'REFERENCE') {
                    if (fieldName != 'name' && fieldName != 'createddate' && fieldName != 'lastactivitydate' && fieldName != 'lastmodifieddate' && fieldName != 'lastvieweddate' && fieldName != 'systemmodstamp' && fieldName != 'name' && fieldName != 'isdeleted' && fieldName != 'a_number__c' && fieldName != 'cpe_additional_request__c' && fieldName != 'opportunity_id__c' && fieldName != 'billing_start_date_ind__c' && fieldName != 'billing_start_date_day_ind__c' && fieldName != 'opportunity_servicetype__c' && fieldName != 'opportunity_recordtypename__c' && fieldName != 'aging_sla_category__c' && fieldName != 'project_coordinator__c' && fieldName != 'opportunity_id_formula__c' && fieldName != 'site_a_full_address__c' && fieldName != 'site_b_full_address__c' && fieldName != 'sales_name__c' && fieldName != 'opportunity_name__c' && fieldName != 'service_type__c' && fieldName != 'ba_date_day_ind__c' && fieldName != 'auto_renewal_uom__c' && fieldName != 'auto_renewal_periode__c' && fieldName != 'periode_uom__c' && fieldName != 'contract_periode__c' && fieldName != 'linkinopportunity__c' && fieldName != 'project_completed_date_idn__c' && fieldName != 'pic_customer_name__c' && fieldName != 'account_name__c' && fieldName != 'aging_survey_complete__c' && fieldName != 'aging_sr_close__c' && fieldName != 'aging_sla__c' && fieldName != 'aging_trial_days__c' && fieldName != 'aging_wba_days__c' && fieldName != 'aging_waiting_pr__c' && fieldName != 'aging_days__c' && fieldName != 'opportunity_trial__c' && fieldName != 'is_any_profitability__c' && fieldName != 'cpe_managed_by__c' && fieldName != 'vendor_name__c' && fieldName != 'mass_update_status__c') {
                        fieldInitiateList.add(fieldMap.get(fieldName).getDescribe().getLabel());                           
                    }
                }
            }
            system.debug('fieldInitiateList: ' + fieldInitiateList);
            */

            /**
            **  get field based on page layout ini tidak ideal 
            **  seharusnya mengambil record type terlebih dahulu baru mendapatkan page layout berdasarkan user login
            **  "untuk workspace item selected"
            **/
            List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {SobjectApiName+ '-' + recordTypeName});
            Metadata.Layout layoutMetaData = (Metadata.Layout)layouts.get(0);
            for (Metadata.LayoutSection section : layoutMetaData.layoutSections) {
                for (Metadata.LayoutColumn column : section.layoutColumns) {
                    if (column.layoutItems != null) {
                        for (Metadata.LayoutItem item : column.layoutItems) {
                            system.debug('item.field: ' + item.field );
                            if(item.field != null){
                                String fieldType = MassRecordUpdateController.getSobjectListFieldsType(item.field, SobjectApiName);
                                System.debug('fieldType: ' + fieldType);    

                                Schema.SObjectType objectTypes = Schema.getGlobalDescribe().get(SobjectApiName);
                                boolean fieldCanUpdate = false;
                                if (objectTypes != null) {
                                    Schema.DescribeSObjectResult objectDescribe = objectTypes.getDescribe();
                                    
                                    // Get the field describe dynamically
                                    Schema.DescribeFieldResult fieldDescribe = objectDescribe.fields.getMap().get(item.field).getDescribe();
                                    
                                    System.debug('fieldDescribe: ' + fieldDescribe.isUpdateable() + ' == ' + item.field + ' == ' + fieldType);
                                    fieldCanUpdate = fieldDescribe.isUpdateable();
                                } else {
                                    System.debug('Invalid object name: ' + SobjectApiName);
                                }

                                if (fieldType != 'TEXTAREA' && fieldType != 'ID' && fieldType != 'REFERENCE') {
                                    if(fieldCanUpdate == true){
                                        System.debug('item: ' + item.field);
                                        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(SobjectApiName);
                                        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
                                        Schema.SObjectField field = objectDescribe.fields.getMap().get(item.field);
                                        String fieldLabel = field.getDescribe().getLabel();
                                        System.debug('fieldLabel: ' + fieldLabel);

                                        fieldInitiateList.add(fieldLabel);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            System.debug('fieldInitiateList: ' + fieldInitiateList.size());

            return fieldInitiateList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } 

    @AuraEnabled(cacheable=false)
    public static String getSobjectRecordList(String SobjectApiName, String FilterRecord, Integer pageSize, Integer pageNumber, String operatorCondition, String fieldType, String recordType){
        system.debug('SobjectApiName: '+ SobjectApiName);
        system.debug('FilterRecord: '+ FilterRecord);
        system.debug('operatorCondition: '+ operatorCondition);
        system.debug('fieldType.370: ' + fieldType);
        String whereCondition = '';
        String recordValue;
        String JsonData = '';
        date startDate;
        date endDate;
        String convertStringtoStartDate = '';
        String convertStringtoEndDate = '';
        List<String> whereConditionList = new List<String>();
        
        List<FILTER_RECORD_WRAPPER> FILTER_RECORD_WRAPPERList = (List<FILTER_RECORD_WRAPPER>) JSON.deserialize(FilterRecord, List<FILTER_RECORD_WRAPPER>.class);           
        System.debug('FILTER_RECORD_WRAPPERList: ' + FILTER_RECORD_WRAPPERList);
        for(FILTER_RECORD_WRAPPER FILTER_RECORD_WRAPPERRec : FILTER_RECORD_WRAPPERList){
            String fieldApiName = MassRecordUpdateController.getSobjectListFieldsName(FILTER_RECORD_WRAPPERRec.filterUpdateField, SobjectApiName);
            System.debug('fieldApiName: ' + fieldApiName);
            
            system.debug('FILTER_RECORD_WRAPPERRec: ' + FILTER_RECORD_WRAPPERRec);

            String fieldTypeResult = MassRecordUpdateController.getSobjectListFieldsType(fieldApiName , SobjectApiName);

            if(fieldTypeResult == 'DATE'){
                convertStringtoStartDate = String.valueOf(FILTER_RECORD_WRAPPERRec.startDateField).subStringbefore(' ');
                convertStringtoEndDate = String.valueOf(FILTER_RECORD_WRAPPERRec.endDateField).subStringbefore(' ');
                system.debug('convertStringtoStartDate: ' + convertStringtoStartDate);
                system.debug('convertStringtoEndDate: ' + convertStringtoEndDate);

                if (FILTER_RECORD_WRAPPERRec.startDateField != null && FILTER_RECORD_WRAPPERRec.endDateField != null) {
                    whereCondition = '(' + fieldApiName + ' >= ' +  convertStringtoStartDate  + ' AND ' + fieldApiName + ' <= ' + convertStringtoEndDate + ')';
                    whereConditionList.add(whereCondition);
                }

                if(FILTER_RECORD_WRAPPERRec.startDateField != null && FILTER_RECORD_WRAPPERRec.endDateField == null){
                    whereCondition = fieldApiName + ' >= ' +  convertStringtoStartDate;
                }

                if(FILTER_RECORD_WRAPPERRec.startDateField == null && FILTER_RECORD_WRAPPERRec.endDateField != null){
                    whereCondition = fieldApiName + ' <= ' + convertStringtoEndDate;
                }
            }

            if (fieldTypeResult == 'DATETIME') {
                convertStringtoStartDate = String.valueOf(FILTER_RECORD_WRAPPERRec.startDateField).subStringbefore(' ');
                convertStringtoEndDate = String.valueOf(FILTER_RECORD_WRAPPERRec.endDateField).subStringbefore(' ');
                system.debug('convertStringtoStartDate: ' + convertStringtoStartDate);
                system.debug('convertStringtoEndDate: ' + convertStringtoEndDate);

                if (FILTER_RECORD_WRAPPERRec.startDateField != null && FILTER_RECORD_WRAPPERRec.endDateField != null) {
                    whereCondition = '(' + fieldApiName + ' >= ' +  convertStringtoStartDate + 'T00:00:00Z' + ' AND ' + fieldApiName + ' <= ' + convertStringtoEndDate + 'T23:59:59Z' + ')';
                    whereConditionList.add(whereCondition);
                }

                if(FILTER_RECORD_WRAPPERRec.startDateField != null && FILTER_RECORD_WRAPPERRec.endDateField == null){
                    whereCondition = fieldApiName + ' >= ' +  convertStringtoStartDate + 'T00:00:00Z';
                }

                if(FILTER_RECORD_WRAPPERRec.startDateField == null && FILTER_RECORD_WRAPPERRec.endDateField != null){
                    whereCondition = fieldApiName + ' <= ' + convertStringtoEndDate + 'T23:59:59Z';
                }
            }
            
            //text
            if(FILTER_RECORD_WRAPPERRec.textField != null){
                whereCondition = fieldApiName + ' like ' + '\'%' + FILTER_RECORD_WRAPPERRec.textField + '%\'' ;
                whereConditionList.add(whereCondition);
            }

            //number
            if(FILTER_RECORD_WRAPPERRec.numberField != null){
                whereCondition = fieldApiName + ' like ' + '\'%' + FILTER_RECORD_WRAPPERRec.numberField + '%\'' ;
                whereConditionList.add(whereCondition);
            }

            //checkbox
            if (FILTER_RECORD_WRAPPERRec.checkboxField != null) {
                whereCondition = fieldApiName + ' = ' + FILTER_RECORD_WRAPPERRec.checkboxField ;
                whereConditionList.add(whereCondition);
            }

            //pickList
            if (FILTER_RECORD_WRAPPERRec.pickListField != null) {
                whereCondition = fieldApiName + ' like ' + '\'%' + FILTER_RECORD_WRAPPERRec.pickListField + '%\'' ;
                whereConditionList.add(whereCondition);
            }
        }
                    
        whereCondition = String.join(whereConditionList, ',');

        if(operatorCondition == 'AND'){
            whereCondition = whereCondition.replace(',' , ' AND ');
        }else if(operatorCondition == 'OR'){
            whereCondition = whereCondition.replace(',' , ' OR ');
        }
        system.debug('finalwhereCondition: ' + whereCondition);
        
        // get SR_PR_Notification__c
        String fieldInitiate = '';
        String fieldTypeValue = '';
        String relatedRecordValue = '';
        String currentUser =  UserInfo.getName();
        String profileUser = UserInfo.getProfileId(); // new
        String querySobject; // new
        String querySobjectAllItem; // new
        String countRecord; // new

        System.debug('currentUser: ' + currentUser);
        System.debug('profileUser: ' + profileUser);


        List<String> fieldList = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset()){

            Schema.SObjectField fieldNameMap = fieldMap.get(fieldName);
            Schema.DisplayType fieldTyperesult = fieldNameMap.getDescribe().getType();
            fieldTypeValue = String.valueOf(fieldTyperesult);
            if ( fieldTypeValue == 'REFERENCE' && fieldName.right(3) == '__c' ){
                relatedRecordValue = fieldName.replace('__c', '__r.name');
            } else if (fieldName.right(2) == 'id' && fieldName != 'id'){
                relatedRecordValue = fieldName.replace('id', '.name');
            } else {
                relatedRecordValue = fieldName;
            }
            fieldList.add(relatedRecordValue);
            System.debug('relatedRecordValue: ' + relatedRecordValue);
        }
        fieldInitiate = String.join(fieldList, ',');
        system.debug('fieldInitiate.241: ' +  fieldInitiate);

        Integer offset = (pageNumber - 1) * pageSize;
        if (profileUser == '00e7F000001tpeaQAA') { // jika system administrator (00e7F000001tpeaQAA)
            System.debug('in System Administration (query)');
            querySobject         = 'SELECT ' + fieldInitiate + ' FROM ' + SobjectApiName + ' WHERE RecordType.Name = ' + '\'' + recordType + '\'' + ' AND ( ' + whereCondition + ' ) LIMIT ' + pageSize + ' OFFSET ' + offset;
            querySobjectAllItem  = 'SELECT ' + fieldInitiate + ' FROM ' + SobjectApiName + ' WHERE RecordType.Name = ' + '\'' + recordType + '\'' + ' AND ( ' + whereCondition + ' ) ';
        } else { // selain system administrator
            System.debug('in other profile (query)');
            querySobject         = 'SELECT ' + fieldInitiate + ' FROM ' + SobjectApiName + ' WHERE RecordType.Name = ' + '\'' + recordType + '\'' + ' AND Project_Coordinator__c LIKE ' + '\'%' + currentUser + '%\'' + ' AND ( ' + whereCondition + ' ) LIMIT ' + pageSize + ' OFFSET ' + offset;
            querySobjectAllItem  = 'SELECT ' + fieldInitiate + ' FROM ' + SobjectApiName + ' WHERE RecordType.Name = ' + '\'' + recordType + '\'' + ' AND Project_Coordinator__c LIKE ' + '\'%' + currentUser + '%\'' + ' AND ( ' + whereCondition + ' ) ';
        }

        System.debug('querySobject: ' + querySobject);
        System.debug('querySobjectAllItem: ' + querySobjectAllItem);

        List<SObject> sobjectList = database.query(querySobject);
        List<SObject> sobjectAllItemList = database.query(querySobjectAllItem);

        System.debug('sobjectList: ' + sobjectList);
        System.debug('sobjectAllItemList: ' + sobjectAllItemList);

        
        Integer recordEnd = pageSize * pageNumber;

        if (profileUser == '00e7F000001tpeaQAA') { // jika system administrasi (00e7F000001tpeaQAA)
            System.debug('in System Administration (query count)');
            countRecord = 'SELECT COUNT() FROM ' + SobjectApiName + ' WHERE ' + 'RecordType.Name = ' + '\'' + recordType + '\'' + 'AND ( ' + whereCondition + ' ) ';
        } else { // selain system administr
            System.debug('in other profile (query count)');
            countRecord = 'SELECT COUNT() FROM ' + SobjectApiName + ' WHERE ' + 'RecordType.Name = ' + '\'' + recordType + '\'' + ' AND Project_Coordinator__c LIKE ' + '\'%' + currentUser + '%\'' + 'AND ( ' + whereCondition + ' ) ';
        }
        integer totalrecords = database.countQuery(countRecord);
        System.debug('totalrecords: ' + totalrecords);
        
        SearchRecordItemsDataWrapper SearchRecordItemsDataWrapperObject = new SearchRecordItemsDataWrapper();
        SearchRecordItemsDataWrapperObject.pageNumber = pageNumber;
        SearchRecordItemsDataWrapperObject.pageSize = pageSize;
        SearchRecordItemsDataWrapperObject.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        SearchRecordItemsDataWrapperObject.recordStart = offset + 1;
        SearchRecordItemsDataWrapperObject.sobjectrecordList = sobjectList;
        SearchRecordItemsDataWrapperObject.sobjectrecordAllItemList = sobjectAllItemList;

        SearchRecordItemsDataWrapperObject.totalRecords = totalrecords;

        JsonData = JSON.serialize(SearchRecordItemsDataWrapperObject);
        System.debug('JsonData: ' + JsonData);

        return JsonData;
    }

    @AuraEnabled
    public static String putSelectedRowtoMassRecordUpdateItems(String selectedRecordRowId, id massUpdateRecordId, String SobjectApiName, Integer pageSize, Integer pageNumber, Boolean selectedAllRecordItem, List<String> recordItemIdList){
        
        System.debug('selectedRecordRowId: ' +  selectedRecordRowId);
        System.debug('massUpdateRecordId: ' +  massUpdateRecordId);
        System.debug('SobjectApiName: ' +  SobjectApiName);
        System.debug('selectedAllRecordItem: ' + selectedAllRecordItem);
        System.debug('recordItemIdList: ' +  recordItemIdList);

        List<String> selectedrecordIdList = new List<String>();
        if (recordItemIdList != null || recordItemIdList != null) { // new
            if(selectedAllRecordItem == true){
                selectedrecordIdList = recordItemIdList;
            }else if(selectedAllRecordItem == false){
                selectedrecordIdList = selectedRecordRowId.split(',');
            }
        }
       
        System.debug('==>selectedrecordIdList: '+ selectedrecordIdList);

        List<String> selectedrecordIdListValue = new List<String>();
        String JsonData = '';

        //loop for get selected id and add String for each item then convert to List
        for(String selectedrecordIdListRec :selectedrecordIdList){
            String value =  '\'' + selectedrecordIdListRec + '\'' ;
            selectedrecordIdListValue.add(value);
        }

        // get Mass_Record_Update_Item__c
        String fieldItemInitiate = '';
        List<String> fieldItemList = new List<String>();
        Map<String, Schema.SObjectType> schemaMapItem = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMapItem = schemaMapItem.get('Mass_Record_Update_Item__c').getDescribe().fields.getMap();
        for (String fieldName : fieldMapItem.keyset()) {
            fieldItemList.add(fieldName);   
        }

        //get field name and convert to String used for query
        fieldItemInitiate = String.join(fieldItemList, ', ');
        
        //loop for create item
        List<Mass_Record_Update_Item__c> massRecordUpdateItemList = new List<Mass_Record_Update_Item__c>();
        for(String selectedrecordIdVal :selectedrecordIdListValue){
            System.debug('selectedrecordIdVal: ' + selectedrecordIdVal);
            System.debug('selectedRecordRowId: ' +  selectedRecordRowId);
            System.debug('massUpdateRecordId: ' +  massUpdateRecordId);
            System.debug('SobjectApiName: ' +  SobjectApiName);
            String replaceSelectedrecordIdVal = selectedrecordIdVal.replace('\'', '');
            System.debug('replaceSelectedrecordIdVal: ' + replaceSelectedrecordIdVal);

            Mass_Record_Update_Item__c Mass_Record_Update_ItemObj = new Mass_Record_Update_Item__c();
            Mass_Record_Update_ItemObj.Object_Name__c = SobjectApiName;
            Mass_Record_Update_ItemObj.Mass_Record_Update__c = massUpdateRecordId;
            Mass_Record_Update_ItemObj.Selected_Sobject_Record_ID__c = replaceSelectedrecordIdVal;

            massRecordUpdateItemList.add(Mass_Record_Update_ItemObj);
        }
        System.debug('massRecordUpdateItemList: '+ massRecordUpdateItemList);
        insert massRecordUpdateItemList;

        //todo: loop data to get item record id for each mas record update item then put the value to the List of String
        // loop the List String then manipulate value with in {'value', 'value'}, then put to query below to show data
        String recordItemValues = '';
        String recordItemValue = '';
        List<String> recordItemValueList = new List<String>();
        for(Mass_Record_Update_Item__c Mass_Record_Update_ItemRec : massRecordUpdateItemList){
            if(Mass_Record_Update_ItemRec.Mass_Record_Update__c == massUpdateRecordId){
                recordItemValue = Mass_Record_Update_ItemRec.Selected_Sobject_Record_ID__c;
                recordItemValueList.add( '\'' + recordItemValue + '\'');
            }
        }

        recordItemValue = String.join(recordItemValueList, ',');
        System.debug('recordItemValue: ' + recordItemValue);

        String querySobjectItem = '';
        querySobjectItem = 'select ' + fieldItemInitiate + ' from ' + 'Mass_Record_Update_Item__c' ;
        system.debug('querySobjectItem: ' + querySobjectItem);

        List<sobject> selectedItemList = database.query(querySobjectItem);
        system.debug('selectedItemList: ' + selectedItemList);
        system.debug('selectedItemListsize: ' + selectedItemList.size());

        List<String> selectedRecordItemList = new List<String>();
        for(sobject selectedItemListRec :selectedItemList){
            system.debug('selectedItemListRec: ' + selectedItemListRec);
        }

        String fieldInitiate = '';
        List<String> fieldList = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset()){
            fieldList.add(fieldName);   
        }
        fieldInitiate = String.join(fieldList, ',');
        
        Integer offset = (pageNumber - 1) * pageSize;

        String querySobject = '';
        System.debug('selectedAllRecordItem: ' + selectedAllRecordItem);
      
        querySobject = 'select ' + fieldInitiate + ' from ' + SobjectApiName + ' where ' + 'id' + ' in ' +  '(' + recordItemValue + ')' + ' LIMIT ' + pageSize + ' OFFSET ' + offset;
        
        system.debug('querySobjectsize: ' + fieldList.size());

        List<sobject> sobjectItemRecordList = database.query(querySobject);
        system.debug('sobjectItemRecordList: ' + sobjectItemRecordList);
        

        // for pagination
        
        Integer recordEnd = pageSize * pageNumber;

        String countRecord = 'SELECT COUNT() FROM ' + 'Mass_Record_Update_Item__c' + ' where ' + ' Mass_Record_Update__c = ' + '\'' + massUpdateRecordId + '\'';
        system.debug('countRecord: ' + countRecord);
        integer totalrecords = database.countQuery(countRecord);
        System.debug('totalrecords: ' + totalrecords);
        
        RecordItemsDataWrapper RecordItemsDataWrapperObject = new RecordItemsDataWrapper();
        RecordItemsDataWrapperObject.pageNumber = pageNumber;
        RecordItemsDataWrapperObject.pageSize = pageSize;
        RecordItemsDataWrapperObject.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        RecordItemsDataWrapperObject.recordStart = offset + 1;
        RecordItemsDataWrapperObject.massRecordUpdateItems = sobjectItemRecordList;
        RecordItemsDataWrapperObject.totalRecords = totalrecords;

        JsonData = JSON.serialize(RecordItemsDataWrapperObject);

        return JsonData;
    }
    
    @AuraEnabled
    public static String getSelectedMassRecordUpdateItems(id massUpdateRecordId, String SobjectApiName, Integer pageSize, Integer pageNumber, String searchKeyUpdateRecordItem, String selectedRecordUpdateItemViewDefault){
        System.debug('massUpdateRecordId: ' +  massUpdateRecordId);
        System.debug('SobjectApiName: ' +  SobjectApiName);
        System.debug('searchKeyUpdateRecordItem: ' +  searchKeyUpdateRecordItem);
        System.debug('selectedRecordUpdateItemViewDefault: ' +  selectedRecordUpdateItemViewDefault);

        // for searchKey
        String inSelectedRecordRowId = '';
        String JsonData = '';
        String querySobject = '';
        String querySobjectAllSearchItem = '';
        List<String> searchKeyUpdateList = new List <String>();
        String searchKeyUpdate = '';

        if(selectedRecordUpdateItemViewDefault != null){
            List<String> searchKeyField = selectedRecordUpdateItemViewDefault.split(';') ;
            System.debug('searchKeyField: ' + searchKeyField);

            // String strsearchKeyUpdateRecordItem = searchKeyUpdateRecordItem;
            // Integer itgsearchKeyUpdateRecordItem = strsearchKeyUpdateRecordItem.length();
            // System.debug('strsearchKeyUpdateRecordItem -> ' + strsearchKeyUpdateRecordItem);
            // System.debug('itgsearchKeyUpdateRecordItem -> ' + itgsearchKeyUpdateRecordItem);

            for(String searchKeyFieldRec :searchKeyField){
                System.debug('searchKeyFieldRec.556: ' + searchKeyFieldRec);

                if (searchKeyFieldRec.right(3) <> 'URL') {
                    String fieldTypeRecord = MassRecordUpdateController.getSobjectListFieldsType(searchKeyFieldRec, SobjectApiName);
                    System.debug('fieldTypeRecord.559: ' + fieldTypeRecord);
                    
                    if (fieldTypeRecord == 'STRING' || fieldTypeRecord == 'PICKLIST') {
                        if(searchKeyFieldRec != 'partner_network__c' && searchKeyFieldRec != 'Mass_Update_Status__c'){
                            searchKeyUpdateList.add(' OR ' +  searchKeyFieldRec + ' LIKE ' + '\'%' + searchKeyUpdateRecordItem + '%\'');
                            System.debug('searchKeyUpdateList: ' + searchKeyUpdateList);  
                        } 
                    }
                }
            }

            searchKeyUpdate = String.join(searchKeyUpdateList, ',');    
            searchKeyUpdate = searchKeyUpdate.replace(',', '');
            searchKeyUpdate = searchKeyUpdate.subString(3);
            searchKeyUpdate = ' AND ' + '(' + searchKeyUpdate;
            System.debug('searchKeyUpdate: ' + searchKeyUpdate);
        }
        
        // get Mass_Record_Update_Item__c
        String fieldItemInitiate = '';
        List<String> fieldItemList = new List<String>();

        Map<String, sObject> updateItemMap = new Map <String, sObject>();
        Map<String, Schema.SObjectType> schemaMapItem = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMapItem = schemaMapItem.get('Mass_Record_Update_Item__c').getDescribe().fields.getMap();
        for(String fieldName : fieldMapItem.keyset()){
            fieldItemList.add(fieldName);
        }

        //get field name and convert to String used for query
        fieldItemInitiate = String.join(fieldItemList, ', ');

        String querySobjectItem = 'select ' + fieldItemInitiate + ' from ' + ' Mass_Record_Update_Item__c ' +  ' where ' + ' Mass_Record_Update__c ' + ' = ' + '\'' +  massUpdateRecordId + '\'';
        system.debug('querySobjectItem: ' + querySobjectItem);

            
        List<sObject> selectedItemList = database.query(querySobjectItem);
        system.debug('selectedItemList: ' + selectedItemList);
        system.debug('selectedItemList.size: ' + selectedItemList.size());

        List<String> sobjectItemIds = new List <String>();
        for(Sobject selectedItemListRec :selectedItemList){
            sobjectItemIds.add('\'' + (String)selectedItemListRec.get('Selected_Sobject_Record_ID__c') + '\'');
            System.debug('selectedItemListRec: ' + selectedItemListRec);
        }
        System.debug('sobjectItemIds: ' + sobjectItemIds);
        System.debug('sobjectItemIds.size(): ' + sobjectItemIds.size());

        String SobjectRecordItemsID = String.join(sobjectItemIds, ', ');
        System.debug('SobjectRecordItemsID: ' + SobjectRecordItemsID);

        // get SR_PR_Notification__c
        String fieldInitiate = '';
        String fieldTypeValue = '';
        String relatedRecordValue = '';
        List<String> fieldList = new List<String>();
        List<String> fieldListDebug = new List<String>();

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset()){
            Schema.SObjectField fieldNameMap = fieldMap.get(fieldName);
            Schema.DisplayType fieldTyperesult = fieldNameMap.getDescribe().getType();
            fieldTypeValue = String.valueOf(fieldTyperesult);

            if ( fieldTypeValue == 'REFERENCE' && fieldName.right(3) == '__c' ) {
                relatedRecordValue = fieldName.replace('__c', '__r.name');
            } else if ( fieldName.right(2) == 'id' && fieldName != 'id' ) {
                relatedRecordValue = fieldName.replace('id', '.name');
            } else {
                relatedRecordValue = fieldName;
            }

            fieldListDebug.add(relatedRecordValue);
            
            System.debug('hasil: ' + fieldTypeValue + ' = ' + fieldNameMap);
            fieldList.add(fieldName);   
        }

        System.debug('fieldListDebug: ' + fieldListDebug);
        System.debug('fieldList: ' + fieldList);
        fieldInitiate = String.join(fieldListDebug, ', ');//String.join(fieldList, ', ');

        System.debug('fieldInitiate: ' + fieldInitiate);
        
        Integer offset = (pageNumber - 1) * pageSize;
        System.debug('OFFSET: ' + offset + ' = ' + pagenumber + ' - 1' + ' * ' + pageSize);

        if (searchKeyUpdateRecordItem != null && searchKeyUpdateRecordItem != '') {
            System.debug('in 703');

            querySobject = 'select ' + fieldInitiate + ' from ' + SobjectApiName + ' where ' + 'id' + ' in ' +  '(' + SobjectRecordItemsID + ')' + searchKeyUpdate + ' ) ' + ' LIMIT ' + pageSize + ' OFFSET ' + offset;
            querySobjectAllSearchItem = 'select ' + fieldInitiate + ' from ' + SobjectApiName + ' where ' + 'id' + ' in ' +  '(' + SobjectRecordItemsID + ')' + searchKeyUpdate + ' ) ';
            
            System.debug('querySobject: ' + querySobject);
            System.debug('querySobjectAllSearchItemL ' + querySobjectAllSearchItem);
        } else {
            System.debug('in 711');
            if (SobjectRecordItemsID != null) {
                querySobject = 'select ' + fieldInitiate + ' from ' + SobjectApiName + ' where ' + 'id' + ' in ' +  '(' + SobjectRecordItemsID + ')' + ' LIMIT ' + pageSize + ' OFFSET ' + offset;
                querySobjectAllSearchItem = 'select ' + fieldInitiate + ' from ' + SobjectApiName + ' where ' + 'id' + ' in ' +  '(' + SobjectRecordItemsID + ')';
                System.debug('querySobject: ' + querySobject);
                System.debug('querySobjectAllSearchItem: ' + querySobjectAllSearchItem);
            }
        }

        // BARU NIH
        List<SObject> sobjectAllSearchItemList = new List<SObject>();
        List<SObject> sobjectItemRecordList = new List<SObject>();

        System.debug('SobjectRecordItemsID: ' + SobjectRecordItemsID);

        if (SobjectRecordItemsID != '') {
            sobjectAllSearchItemList = database.query(querySobjectAllSearchItem); // RETURN ALL
            system.debug('sobjectAllSearchItemList: ' + sobjectAllSearchItemList);

            sobjectItemRecordList = database.query(querySobject); //RETURN SRPR
            system.debug('sobjectItemRecordList' + sobjectItemRecordList);
        }

        List<sobject> newSobjectItemRecordList = new List<sobject>(); 
        
        //QUERY RECORD ITEMS
        if (SobjectRecordItemsID != '') {
            String queryItemSobject = 'select' + ' Object_Name__c, Mass_Record_Update__c, Selected_Sobject_Record_ID__c, Update_Status__c ' + 'from' + ' Mass_Record_Update_Item__c ' + 'where' + ' Selected_Sobject_Record_ID__c ' + 'in ' + '(' + SobjectRecordItemsID +')' + ' AND ' + ' Mass_Record_Update__c ' + ' = ' + '\'' +  massUpdateRecordId + '\'';
            system.debug('queryItemSobject: ' + queryItemSobject);

            List<sObject> sobjectItemList = database.query(queryItemSobject); // RETURN MASS RECORD UPDATE ITEM
            system.debug('sobjectItemList.size: ' + sobjectItemList.size());
            
            //loop query item
            for(sObject recordItem :sobjectItemList){
                updateItemMap.put((String)recordItem.get('Selected_Sobject_Record_ID__c'), recordItem);
            }
        }

        List<String> recordIdItemList = new List<String>();

        //loop Sobject item
        if(sobjectItemRecordList.size() > 0){
            for(sobject sobjectItemRecordListRec :sobjectItemRecordList){
            
                sobject sobjectItemRecord = updateItemMap.get((String) sobjectItemRecordListRec.get('id')); // map get record item
                String itemRecordId = (String) sobjectItemRecord.get('id');
                System.debug('itemRecordId: ' + itemRecordId);
    
                recordIdItemList.add('\'' + itemRecordId + '\'');
                if(sobjectItemRecord != null){
                    String updatestatus = (String) sobjectItemRecord.get('Update_Status__c');
                    if(updatestatus != null && updatestatus != ''){
                        System.debug('updatestatus: ' + updatestatus);
                        sobjectItemRecordListRec.put('Mass_Update_Status__c', updatestatus);
                    }else{
                        sobjectItemRecordListRec.put('Mass_Update_Status__c', '');
                    }
                }                
                newSobjectItemRecordList.add(sobjectItemRecordListRec);
            }
        }
        

        String recordItemId = String.join(recordIdItemList, ',');

        System.debug('recordItemId: ' + recordItemId);
        //system.debug('sobjectItemList: ' + sobjectItemList);
        system.debug('sobjectItemRecordList: ' + sobjectItemRecordList);
        system.debug('sobjectItemRecordList.size(): ' + sobjectItemRecordList.size());
        System.debug('newSobjectItemRecordList: ' + newSobjectItemRecordList);
        System.debug('newSobjectItemRecordList.size(): ' + newSobjectItemRecordList.size());

        // for pagination
        Integer recordEnd = pageSize * pageNumber;
        integer totalrecords = 0;

        String countRecord = '';
        if(searchKeyUpdateRecordItem != null && searchKeyUpdateRecordItem != ''){
            countRecord = 'select COUNT() from ' + SobjectApiName + ' where ' + 'id' + ' in ' +  '(' + SobjectRecordItemsID + ')' + searchKeyUpdate + ' ) ';
            totalrecords = database.countQuery(countRecord);
            System.debug('totalrecords: ' + totalrecords);
        }else{
            if (SobjectRecordItemsID != '') {
                countRecord = 'select COUNT() from ' + SobjectApiName + ' where ' + 'id' + ' in ' +  '(' + SobjectRecordItemsID + ')';
                totalrecords = database.countQuery(countRecord);
                System.debug('totalrecords: ' + totalrecords);
            }
        }        

        RecordItemsDataWrapper RecordItemsDataWrapperObject = new RecordItemsDataWrapper();
        RecordItemsDataWrapperObject.pageNumber = pageNumber;
        RecordItemsDataWrapperObject.pageSize = pageSize;
        RecordItemsDataWrapperObject.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        RecordItemsDataWrapperObject.recordStart = offset + 1;
        RecordItemsDataWrapperObject.totalRecords = totalrecords;
        // per-page existing
        RecordItemsDataWrapperObject.massRecordUpdateItems = newSobjectItemRecordList;
        // semua record di semua page
        if (sobjectAllSearchItemList != null) {
            RecordItemsDataWrapperObject.massRecordUpdateAllItems = sobjectAllSearchItemList;
        }

        JsonData = JSON.serialize(RecordItemsDataWrapperObject);

        return JsonData;
    }

    @AuraEnabled
    public static String removeRecordUpdateItem(id massRecordUpdateId, String selectedRowRemoveItems, List<String> selectedRemoveItems, Boolean selectedAllRecordRemoveItems, String SobjectApiName){
        system.debug('In removeRecordUpdateItem');
        system.debug('massRecordUpdateId: ' + massRecordUpdateId);
        system.debug('selectedRemoveItems: ' + selectedRemoveItems);
        system.debug('SobjectApiName: ' + SobjectApiName);
        system.debug('selectedRowRemoveItems: ' + selectedRowRemoveItems);
        system.debug('selectedAllRecordRemoveItems: ' + selectedAllRecordRemoveItems);

        String removeItemStatus = '';
        //String massRecordRemoveItemRecValue = '';

        List<String> selectedRecordIdList = new List<String>();
        if (selectedAllRecordRemoveItems == true) {
            selectedRecordIdList = selectedRemoveItems;
        } else if (selectedAllRecordRemoveItems == false) {
            selectedRecordIdList = selectedRowRemoveItems.split(',');
        }
        System.debug('=>selectedRecordIdList: ' + selectedRecordIdList);
        
        List<String> massRecordRemoveItemRecValue = new List<String>();
        for (String massRecordUpdateItemRec : selectedRecordIdList) {
            String value = '\'' + massRecordUpdateItemRec + '\'';
            massRecordRemoveItemRecValue.add(value);
        }
        System.debug('=>massRecordRemoveItemRecValue: ' + massRecordRemoveItemRecValue);

        String massRecordRemoveItemRecStringValue = String.join(massRecordRemoveItemRecValue, ', ');
        System.debug('=>massRecordRemoveItemRecStringValue: ' + massRecordRemoveItemRecStringValue);


        /*
        List<String> massRecordRemoveList = new List<String>();
        for(String massRecordUpdateItemRec : selectedRemoveItems){
            massRecordRemoveItemRecValue = '\'' + massRecordUpdateItemRec + '\'';
            massRecordRemoveList.add(massRecordRemoveItemRecValue);
        }
        system.debug('massRecordRemoveItemRecValue: ' + massRecordRemoveItemRecValue);
        system.debug('massRecordRemoveList: ' + massRecordRemoveList);
        */

        String removeItem = 'select Id, Name from Mass_Record_Update_Item__c where Mass_Record_Update__c = ' + '\'' + massRecordUpdateId + '\'' + ' AND Selected_Sobject_Record_ID__c In ' + '(' + massRecordRemoveItemRecStringValue + ')';
        system.debug('removeItem: '+ removeItem);
        
        List<Mass_Record_Update_Item__c> recordUpdateItemRemoveList = Database.query(removeItem);

        if (recordUpdateItemRemoveList.size() > 0) {
            Delete recordUpdateItemRemoveList;
            removeItemStatus = 'Success';
        }else {
            removeItemStatus = 'Failed - Record not Select';
        }

        return removeItemStatus;
    }

    // @AuraEnabled(cacheable=false)
    @AuraEnabled
    public static List<String> updateSobjectRecordItems(List<String> SobjectrecordIds, String SobjectApiName, String massUpdateRecordId, String fieldDataType, String fieldApiName, String valuetoUpdate, boolean selectedAllRecordItem, String fieldLabel){
        system.debug('updateSobjectRecordItems');
        system.debug('SobjectrecordIds: ' + SobjectrecordIds);
        system.debug('SobjectApiName: ' + SobjectApiName);
        system.debug('massUpdateRecordId' + massUpdateRecordId);
        system.debug('fieldDataType: ' + fieldDataType);
        system.debug('fieldApiName: ' + fieldApiName);
        system.debug('fieldLabel: ' + fieldLabel);
        system.debug('valuetoUpdate: ' + valuetoUpdate);
        System.debug('selectedAllRecordItem: ' + selectedAllRecordItem);
        // try {

        String inSelectedRecordRowId = '';
        String JsonData = '';
        String errorMessage = '';
        String SuccessMessage = '';
        
        List<String> MessageResponse = new List <String>();
        List<String> SobjectrecordItemIdList = new List<String>();
        
        for(String SobjectrecordIdsRec :SobjectrecordIds){
            SobjectrecordItemIdList.add( '\'' + SobjectrecordIdsRec + '\'');
        }
        
        system.debug('SobjectrecordItemIdList.size: ' + SobjectrecordItemIdList.size());
        system.debug('SobjectrecordItemIdList: ' + SobjectrecordItemIdList);
        
        String SobjectrecordItemIdListValue = String.join(SobjectrecordItemIdList, ', ');
        system.debug('SobjectrecordItemIdListValue: ' + SobjectrecordItemIdListValue);

        String fieldInitiate = '';
        List<String> fieldList = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset()){
            fieldList.add(fieldName);   
        }
        fieldInitiate = String.join(fieldList, ', ');
        System.debug('SobjectrecordItemIdList: ' + SobjectrecordItemIdList);

        //get record item value
        String querytoRecordItem = '';
        querytoRecordItem = 'select ' + 'id, Selected_Sobject_Record_ID__c' + ' from ' + 'Mass_Record_Update_Item__c' + ' where ' + 'Mass_Record_Update__c = ' + '\'' + massUpdateRecordId + '\'';
        System.debug('querytoRecordItem: ' + querytoRecordItem);
        List<Mass_Record_Update_Item__c> sobjectItemRecordItemList = database.query(querytoRecordItem);    
        List<String> sobjectRecordItemselectedList = new List<String>();
        String sobjectRecordItemselected = '';
        for(Mass_Record_Update_Item__c sobjectItemRecordItemListRec: sobjectItemRecordItemList){
            sobjectRecordItemselectedList.add( '\'' + sobjectItemRecordItemListRec.Selected_Sobject_Record_ID__c + '\'');
        }
        sobjectRecordItemselected = String.join(sobjectRecordItemselectedList, ',');
        
        System.debug('sobjectRecordItemselected: ' + sobjectRecordItemselected);

        //query to sobject
        String querySobject = '';
        if(selectedAllRecordItem == false){
            System.debug('In 879 False');
            querySobject = 'select ' + fieldInitiate + ' from ' + SobjectApiName + ' where ' + 'id' + ' in ' + '(' + SobjectrecordItemIdListValue + ')';  
            system.debug('querySobject: ' + querySobject);
        }else if(selectedAllRecordItem == true){
            System.debug('In 883 True');
            querySobject = 'select ' + fieldInitiate + ' from ' + SobjectApiName + ' where ' + 'id' + ' in ' + '(' + sobjectRecordItemselected + ')';  
            system.debug('querySobject: ' + querySobject);
        }
        List<sobject> sobjectItemRecordList = database.query(querySobject);

        system.debug('sobjectItemRecordList: ' + sobjectItemRecordList);
        system.debug('sobjectItemRecordList.size(): ' + sobjectItemRecordList.size());
        
        for(sobject sobjectItemRecordListRecord : sobjectItemRecordList ){
            System.debug('sobjectItemRecordListRecord.751: ' + sobjectItemRecordListRecord);
            /*
            Check this url https://salesforce.stackexchange.com/questions/155536/dynamic-method-to-take-in-a-List-of-sobjects-cast-and-loop-through-them-and-per
            */
            system.debug('fieldDataType: ' + fieldDataType);
            system.debug('fieldApiName: ' + fieldApiName);


            switch on fieldDataType {
                when  'STRING' {
                    sobjectItemRecordListRecord.put(fieldApiName, String.valueOf(valuetoUpdate));
                    System.debug('fieldDataType = String line 793: ' + sobjectItemRecordList);
                }
                when  'LONG TEXTAREA' {
                    sobjectItemRecordListRecord.put(fieldApiName, String.valueOf(valuetoUpdate));
                    System.debug('fieldDataType = String line 793: ' + sobjectItemRecordList);
                }
                when  'TEXTAREA' {
                    sobjectItemRecordListRecord.put(fieldApiName, String.valueOf(valuetoUpdate));
                    System.debug('fieldDataType = String line 793: ' + sobjectItemRecordList);
                }
                when 'BOOLEAN' {
                    sobjectItemRecordListRecord.put(fieldApiName, valuetoUpdate);
                    System.debug('fieldDataType = Boolean line 797: ' + sobjectItemRecordList);
                }
                when 'DATE' {
                    sobjectItemRecordListRecord.put(fieldApiName, Date.valueOf(valuetoUpdate));
                    System.debug('fieldDataType = DATE line 801: ' + sobjectItemRecordList);
                }
                when 'PICKLIST' {
                    sobjectItemRecordListRecord.put(fieldApiName, String.valueOf(valuetoUpdate));
                    System.debug('fieldDataType = PICKLIST line 805: ' + sobjectItemRecordList);
                }
                when else {
                    System.debug('FieldDataTypeNotFound');
                }
            }
            
            system.debug('sobjectItemRecordListRecord: ' + sobjectItemRecordListRecord);
        }
        
        Batch_MassRecordUpdateItem batchMassRecordUpdateItemClass = new Batch_MassRecordUpdateItem();
        System.debug('massUpdateRecordId: ' + massUpdateRecordId);
        System.debug('fieldApiName: ' + fieldApiName);
        System.debug('sobjectItemRecordList: ' + sobjectItemRecordList);

        batchMassRecordUpdateItemClass.Batch_MassRecordUpdateItem(sobjectItemRecordList, fieldLabel, massUpdateRecordId, valuetoUpdate);
        
        database.executeBatch(batchMassRecordUpdateItemClass, 50);

        /*
        List<String> succesRecordIdList = new List<String>();
        List<String> failedRecordIdList = new List<String>();
        List<String> resultRecordIdList = new List<String>();

        map<String, String> updateStatusMap = new map<String, String>();

        Database.SaveResult[] databaseUpdateSobejectRecordList = Database.update(sobjectItemRecordList, false);
            for (Database.SaveResult databaseUpdateSobejectRecordListResults : databaseUpdateSobejectRecordList) {
            resultRecordIdList.add(databaseUpdateSobejectRecordListResults.getId());
            String resultRecordIdListValue = String.join(resultRecordIdList, ', ');
            system.debug('resultRecordIdListValue: '+ resultRecordIdListValue);

            if (databaseUpdateSobejectRecordListResults.isSuccess()) {
                
                updateStatusMap.put(databaseUpdateSobejectRecordListResults.getId(), 'Success: ' + fieldApiName + ' to ' + valuetoUpdate);
                // Operation was successful, so get the ID of the record that was processed
                succesRecordIdList.add( '\'' + databaseUpdateSobejectRecordListResults.getId() + '\'');
                MessageResponse.add('Success: ' + fieldApiName + ' to ' + valuetoUpdate); 
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : databaseUpdateSobejectRecordListResults.getErrors()) {   
                    updateStatusMap.put(databaseUpdateSobejectRecordListResults.getId(), 'Error: ' + err.getMessage() );
                                    
                    System.debug('The following error has occurred : ' + err.getStatusCode() + ' >> ' + err.getMessage() + err);
                    errorMessage = ('Error on : ' + fieldApiName + '| Message: ' + err.getMessage());
                    failedRecordIdList.add('\'' + databaseUpdateSobejectRecordListResults.getId() + '\'');
                    MessageResponse.add('Error on : ' + fieldApiName + ' Message: ' + err.getMessage());
                }
            }
        }
       

        List<mass_record_update_item__c> sobjectRecoirdItemList = [select id, Selected_Sobject_Record_ID__c, Update_Status__c from mass_record_update_item__c where Mass_Record_Update__c =:massUpdateRecordId and Selected_Sobject_Record_ID__c in :resultRecordIdList];
        if(sobjectRecoirdItemList.size() > 0 ){
            List<mass_record_update_item__c> newMasRecordItemUpdateList = new List<mass_record_update_item__c>();    
            for(mass_record_update_item__c sobjectRecoirdItemListRec :sobjectRecoirdItemList){
                if(updateStatusMap.get(sobjectRecoirdItemListRec.Selected_Sobject_Record_ID__c) != null){
                    String status = updateStatusMap.get(sobjectRecoirdItemListRec.Selected_Sobject_Record_ID__c);

                    sobjectRecoirdItemListRec.Update_Status__c = status;
                    newMasRecordItemUpdateList.add(sobjectRecoirdItemListRec);   
                }
            }
            update newMasRecordItemUpdateList;
        }
        System.debug('MessageResponse: ' + MessageResponse);
        */

        return MessageResponse;
            
        /*
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }*/
    }

    @AuraEnabled
    public static String SaveSearchItemListView(List<String> searchItemColumnView, String SobjectrecordIds){
        
        String updateListViewRecordItem = '';

        System.debug('searchItemColumnView: ' + searchItemColumnView);
        System.debug('SobjectrecordIds: ' + SobjectrecordIds);

        try {

            updateListViewRecordItem = String.join(searchItemColumnView, ';');
            List<Mass_Record_Update__c> massRecordUpdateList = [select id, name, Selected_Search_Items_View__c from Mass_Record_Update__c where id =:SobjectrecordIds];
            List<Mass_Record_Update__c> newMassRecordUpdateListUpdate = new List<Mass_Record_Update__c>();

            if(massRecordUpdateList.size() > 0 ){
                for(Mass_Record_Update__c massRecordUpdateListRec : massRecordUpdateList){
                    massRecordUpdateListRec.Selected_Search_Items_View__c = updateListViewRecordItem;
                    
                    newMassRecordUpdateListUpdate.add(massRecordUpdateListRec);
                }

                update newMassRecordUpdateListUpdate;
            }
        } catch (Exception e) {
            String notes = 'Error on massRecordUpdateController.updateSobjectRecordItems method.'; 
            String message =  e.getmessage() + ' - ' +e.getStacktraceString() ; 
            integer lineNumber = e.getLineNumber();

            String errorMsg = notes + '::' +  message + '::' + lineNumber;
            apputils.puterror(errorMsg);
        }

        return updateListViewRecordItem; 
    }

    @AuraEnabled
    public static String SaveRecordItemListView(List<String> selectedItemColumnView, String SobjectrecordIds){
        
        String updateListViewRecordItem = '';

        System.debug('selectedItemColumnView: ' + selectedItemColumnView);
        System.debug('SobjectrecordIds: ' + SobjectrecordIds);

        try {

            updateListViewRecordItem = String.join(selectedItemColumnView, ';');
            List<Mass_Record_Update__c> massRecordUpdateList = [select id, name, Selected_Record_Items_View__c from Mass_Record_Update__c where id =:SobjectrecordIds];
            List<Mass_Record_Update__c> newMassRecordUpdateListUpdate = new List<Mass_Record_Update__c>();

            if(massRecordUpdateList.size() > 0 ){
                for(Mass_Record_Update__c massRecordUpdateListRec : massRecordUpdateList){
                    massRecordUpdateListRec.Selected_Record_Items_View__c = updateListViewRecordItem;
                    
                    newMassRecordUpdateListUpdate.add(massRecordUpdateListRec);
                }

                update newMassRecordUpdateListUpdate;
            }
        } catch (Exception e) {
            String notes = 'Error on massRecordUpdateController.updateSobjectRecordItems method.'; 
            String message =  e.getmessage() + ' - ' +e.getStacktraceString() ; 
            integer lineNumber = e.getLineNumber();

            String errorMsg = notes + '::' +  message + '::' + lineNumber;
            apputils.puterror(errorMsg);
        }

        return updateListViewRecordItem; 
    }

    @AuraEnabled
    public static String getSobjectPicklistValues(String sobjectApiName, String fieldName) {
        System.debug('in getSobjectPickListValues');
        System.debug('in sobjectApiName' + sobjectApiName);
        System.debug('in fieldName' + fieldName);

        String fieldLabel = '';
        String fieldNameValue = '';
        String bodyJson = '';

        JSONGenerator bodyJsonMessage = JSON.createGenerator(true);
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> field_map = schemaMap.get(sobjectApiName).getDescribe().fields.getMap();
        List<Schema.PickListEntry> pick_List_values = field_map.get(fieldName).getDescribe().getPickListValues(); 
        System.debug('pick_List_values: ' + pick_List_values);
        System.debug('field_map: ' + field_map);
        
        bodyJsonMessage.writeStartArray();
        for (Schema.PickListEntry pickListValue : pick_List_values) { //for all values in the pickList List
            fieldLabel = (String) pickListValue.getLabel();
            fieldNameValue = (String) pickListValue.getValue();
            System.debug('fieldLabel: ' + fieldLabel);
            System.debug('fieldNameValue: ' + fieldNameValue);

            
                bodyJsonMessage.writeStartObject();
                if(fieldLabel != null){                 
                    bodyJsonMessage.writeStringField('label', fieldLabel );
                }else {
                    bodyJsonMessage.writeNullField('label');
                }

                if(fieldName != null){
                    //bodyJsonMessage.writeStringField('fieldName',  '/lightning/r/' + SobjectApiName + '/' + fieldNameValue + '/view' );
                    bodyJsonMessage.writeStringField('value',  fieldNameValue);
                }else {
                    bodyJsonMessage.writeNullField('value');
                }
                
                bodyJsonMessage.writeEndObject();
        }

        bodyJsonMessage.writeEndArray();                                
        bodyJson = bodyJsonMessage.getAsString();
        System.debug('bodyJson: ' + bodyJson);
      
        return bodyJson; //return the List
    }
}