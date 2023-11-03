/* Code by CafeForce || www.cafeforce.com || support@cafeforce.com || Mandatory Header */
public class MassApprovalController {

    @AuraEnabled
    public static List<ApprovalResult> fetchApprovals() {
        try {
            List<ApprovalResult> result = new List<ApprovalResult>();
            Map<Id, Id> recordAndProcessIdMap = new Map<Id, Id>();
            Map<String, List<Id>> objectAndrecordIdMap = new Map<String, List<Id>>();
            Id userId = UserInfo.getUserId();

            for(ProcessInstanceWorkitem pIWorkItem : [SELECT Id, actorId, ProcessInstance.Status, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE actorId =: userId LIMIT 49999]) {
                recordAndProcessIdMap.put(pIWorkItem.ProcessInstance.TargetObjectId, pIWorkItem.id);
                if(objectAndrecordIdMap.get(pIWorkItem.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName()) == null) 
                    objectAndrecordIdMap.put(pIWorkItem.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName(), new List<Id>());
                objectAndrecordIdMap.get(pIWorkItem.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName()).add(pIWorkItem.ProcessInstance.TargetObjectId);
            }

            Map<String, String> objectAndFieldMap = new Map<String, String>();
            if(objectAndrecordIdMap.size() > 0 && objectAndrecordIdMap.size() <= 25) {
                for(String objName : objectAndrecordIdMap.keySet()) {
                    String fieldName = '';
                    String fieldLabel = '';
                    Schema.DescribeSObjectResult ObjResult = Schema.getGlobalDescribe().get(objName).getDescribe();
                    Map<String, Schema.SObjectField> mapFields = ObjResult.fields.getMap();
                    for(String objField : mapFields.keySet()) {
                        if(mapFields.get(objField).getDescribe().isNameField()) {
                            fieldName = mapFields.get(objField).getDescribe().getName();
                            fieldLabel = mapFields.get(objField).getDescribe().getLabel();
                            objectAndFieldMap.put(objName, String.valueof(mapFields.get(objField).getDescribe().getName()));
                            break;
                        }
                    }

                    if(String.isNotBlank(fieldName)) {
                        List<RecordData> recordList = new List<RecordData>();
                        List<Id> records = objectAndrecordIdMap.get(objName);
                        String query = 'SELECT id, ' + fieldName + ' FROM ' + objName + ' WHERE id IN : records LIMIT 49999';

                        for(sObject rec : Database.query(query)) {
                            recordList.add(new RecordData(rec, recordAndProcessIdMap.get(rec.Id)));
                        }
                        result.add(new ApprovalResult(ObjResult.getLabel(), fieldName, fieldLabel, recordList));
                    }
                }
            }
            if(recordAndProcessIdMap.size() > 0) {
                if(objectAndrecordIdMap.size() >= 25)
                    throw new MyException('Approvals of more than 25 different objects found.');
                else
                    return result;
            } else {
                throw new MyException('No Pending Approvals found.');
            }
        } catch(Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0]);
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }

    @AuraEnabled
    public static void updateApprovalProcess(String processInstanceWorkitemIds, String action, String comment) {
        try {
            if(String.isNotBlank(processInstanceWorkitemIds)) {
                Set<String> setProcessInstanceWorkitemIds = (Set<String>) JSON.deserialize(processInstanceWorkitemIds, Set<String>.class);
                if(setProcessInstanceWorkitemIds != null && setProcessInstanceWorkitemIds.Size() > 0) {
                    List<Approval.ProcessWorkitemRequest> submitReturnOrderList = new list<Approval.ProcessWorkitemRequest>();
                    for(String proInsWorkId : setProcessInstanceWorkitemIds) {
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setComments(comment);
                        req.setWorkitemId(Id.valueOf(proInsWorkId));
                        req.setAction(action);
                        submitReturnOrderList.add(req);
                    }
                    // Submit the request for approval
                    if(submitReturnOrderList != null && submitReturnOrderList.Size() > 0) {
                        List<Approval.ProcessResult> resultList = Approval.process(submitReturnOrderList);
                    }
                } else {
                    throw new MyException('Invalid Data');
                }
            } else {
                throw new MyException('No Pending Approvals found.');
            }
        } catch(Exception err) {
            throw new AuraHandledException(err.getMessage());
        }
    }

    public class ApprovalResult {
        @AuraEnabled public String objName;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public List<RecordData> data;

        public ApprovalResult(String objName, String fieldName, String fieldLabel, List<RecordData> data) {
            this.objName = objName;
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.data = data;
        }
    }

    public class RecordData {
        @AuraEnabled public sObject record;
        @AuraEnabled public Id processInstanceId;

        public RecordData(sObject record, Id processInstanceId) {
            this.record = record;
            this.processInstanceId = processInstanceId;
        }
    }
}
/* 
    Code by CafeForce 
    Website: http://www.cafeforce.com 
    DO NOT REMOVE THIS HEADER/FOOTER FOR FREE CODE USAGE 
*/