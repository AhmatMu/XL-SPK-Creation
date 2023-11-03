/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 02-28-2023
 * @last modified by  : Diky Nurosid
**/
public class SoqlHelper{

    public static List<SObject> getRecordListWithAllFieldsByIds(Set<Id> Ids, String sObjectType){
        List<String> fields = getFieldStrings(sObjectType);
        List<SObject> sobjectList = new List<SObject>(Database.query(
            'SELECT ' + String.join(fields, ',') + ' FROM ' + sObjectType + ' WHERE Id IN: Ids'
        ));
        System.debug('sobject list size: ' + sobjectList.size());

        return sobjectList;
    }

    public static List<SObject> getRecordListWithReferenceByIds(Set<Id> Ids, String sObjectType, String referenceField) {
        String query = buildQuery(sObjectType, referenceField, false, '');
        query += ' WHERE Id IN: Ids';
        List<SObject> sobjectList = new List<SObject>(Database.query(query));
        return sobjectList;
    }

    public static List<SObject> getRecordListWithSubQueryByIds(Set<Id> Ids, String sObjectType, String referenceField, String sObjectSubQuery) {
        String query = buildQuery(sObjectType, referenceField, true, sObjectSubQuery);
        query += ' WHERE Id IN: Ids';
        List<SObject> sobjectList = new List<SObject>(Database.query(query));
        return sobjectList;
    }
    
    // -------------------- private section -------------------- //

    private static String buildQuery(String sObjectType, String referenceField, Boolean haveSubQuery,String sObjectSubQuery) {
        String query = 'SELECT ';
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
        for (String fieldName : fieldsMap.keySet()) {
            query += fieldName + ',';
            if(fieldName == ReferenceField){
                if (fieldsMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.REFERENCE) {
                    Map<String, Schema.SObjectField> subFieldsMap = fieldsMap.get(fieldName).getDescribe().getReferenceTo().get(0).getDescribe().fields.getMap();
                    query += buildReferenceFields(fieldName,subFieldsMap);
                }
            }
        }
        query = query.substring(0, query.length() - 1);
        if(haveSubQuery){
            query += buildSubquery(sObjectSubQuery);
        }
        query += ' FROM '+ sObjectType;
        return query;
    }
    
    private static String buildReferenceFields(String fieldName, Map<String, Schema.SObjectField> subFieldsMap) {
        String lookupFieldName = '';
        String referenceField = fieldName.replace('__c','__r');
        for (String subFieldName : subFieldsMap.keySet()) {
            lookupFieldName += referenceField + '.' + subFieldName + ',';
        }
        return lookupFieldName;
    }
    
    private static String buildSubquery(String sObjectSubQuery) {
        String subquery = ', (SELECT ';
        Map<String, Schema.SObjectField> subqueryFieldsMap = Schema.getGlobalDescribe().get(sObjectSubQuery).getDescribe().fields.getMap();
        for (String subqueryFieldName : subqueryFieldsMap.keySet()) {
            subquery += subqueryFieldName + ',';
        }
        subquery = subquery.substring(0, subquery.length() - 1);
        subquery += ' FROM '+sObjectSubQuery.replace('__c','s__r')+')';
        return subquery;
    }

    private static List<String> getFieldStrings(String sObjectType){
        Set<String> setFieldNames = new Set<String>();
        Set<String> finalSetFieldNames = new Set<String>();
        list<String> lstFieldNames;
        list<String> finalLstFieldNames;
        try {
            Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
            Schema.SObjectType objectType = globalDescribe.get(sObjectType); 
        
            // Get the Map of Schema of the SObject
            Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

            // Get all of the fields on the object
            setFieldNames = fieldMap.keySet();
            lstFieldNames = new List<String>(setFieldNames);

            // remove person account fields
            for(String s : lstFieldNames){
                if(!s.endsWith('__pc'))
                    finalSetFieldNames.add(s);
            }

            finalLstFieldNames = new List<String>(finalSetFieldNames);
        } catch (Exception e) {
            System.debug('an exception occured during object description process: ' + e);
        }
        
        return finalLstFieldNames;
    }



}