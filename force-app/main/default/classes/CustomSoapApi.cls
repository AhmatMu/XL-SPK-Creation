/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 09-29-2022
 * @last modified by  : Diky Nurosid
**/
global class CustomSoapApi {
    
    webservice static String createTemplateMapping(String Name, String Type){
        Call_Log__c callLogRecord=new Call_Log__c();
        callLogRecord.type__c = 'Callin';
        callLogRecord.request_start_time__c = datetime.now();
        String returnMessage;
        string status;
        callLogRecord.Request_Message__c = 'Insert Data SOAP';
        try{
            Template_Mapping__c tmpMap =new Template_Mapping__c();
            tmpMap.Name =Name;
            tmpMap.Type__c = Type;
            insert tmpMap;
            
            status = 'Success';
            returnMessage = 'success';
        }catch(Exception e){
            callLogRecord.status__c = 'Failed';
            status = 'Failed';
            string errMessage = 'Error on createTemplateMapping, Invoice method.::' + e.getmessage() + '::' + e.getLineNumber() ;
            system.debug('==================== error message : ' + errMessage);
            AppUtils.putError(errMessage);
            callLogRecord.error_message__c = errMessage;
            returnMessage = errMessage ;
        }
        callLogRecord.endpoint__C = 'SOAPContractInvoice';
        callLogRecord.status__c = status;
        callLogRecord.response_end_time__c = datetime.now();
        
        insert callLogRecord;
        return returnMessage;
        
    }
}