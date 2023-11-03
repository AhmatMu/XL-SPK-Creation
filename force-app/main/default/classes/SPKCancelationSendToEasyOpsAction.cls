public class SPKCancelationSendToEasyOpsAction {
    @InvocableMethod(label = 'CallMultipleSendSPKCancelation')
    public static void SPKCancelationSendToEasyOpsAction(List<SPKRequest> requestList) {
        system.debug('=== requestList : ' + requestList);

        List<SPK__c> spkCollectionCancelation = requestList[0].spkListCancelation;  

        if(!spkCollectionCancelation.isempty()){
            System.debug('=== SPK Cancelation ===');

            Set<Id> spkRecIds = new Set<Id>();
            for(SPK__c spkCollectionCancelationRec :spkCollectionCancelation){
                spkRecIds.add(spkCollectionCancelationRec.Id);
            }
            if(!spkRecIds.isEmpty()){
                REST_SPK_Callout.requestSPKCancelationBySPKId(spkRecIds);
            }
        }
    }

    public class SPKRequest{
        @InvocableVariable(required = true)
        public list<SPK__c> spkListCancelation;
    }
}