public class TA_AT_SRPRCalloutSPK implements TriggerAction.AfterUpdate{
    public void AfterUpdate (list<SR_PR_Notification__c> newList, list<SR_PR_Notification__c> oldList) {
        Map<Id,SR_PR_Notification__c> oldMap = new Map<Id,SR_PR_Notification__c>(oldList);
        Map<Id,SR_PR_Notification__c> newMap = new Map<Id,SR_PR_Notification__c>(newList);

        Set<Id> recordIds = new Set<Id>();
        string errorMsg;
        Id recordId;
        try {
            
            for(SR_PR_Notification__c record: newMap.values()) {
                recordId = (Id)record.get('Id');
        
                if(
                    record.get('Status__c') == 'In Progress' && 
                    (oldMap.get(recordId).substatus__c != 'SPK Partner Administration' && record.get('substatus__c') == 'SPK Partner Administration') 
                ){
                    //TODO: untuk send email to PMO perlu mengerjakan SPK dan mengubah ke release
                    // REST_SPK_Callout.requestSPKCreationToEasyopsBySRPRId(recordId);
                }
           }

        } 
        catch(Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_SRPRCalloutSPK After Update' +  e.getmessage() + ' - ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
       
       
    
}