public class SPKCreationSendToEasyOpsAction {
    @InvocableMethod(label = 'CallMultipleSendSPKCreation')
    public static void spkCreationSendToEasyOps(List<SPKRequest> requestList){
        system.debug('=== requestList : ' + requestList);

        List<SPK__c> spkCollectionCreation = requestList[0].spkListCreation;

        if(!spkCollectionCreation.isempty()){
            System.debug('=== SPK Creation ===');

            Set<Id> spkRecIds = new Set<Id>();
            for(SPK__c spkCollectionCreationRec : spkCollectionCreation){
                spkRecIds.add(spkCollectionCreationRec.Id);
            }
            if(!spkRecIds.isEmpty()){
                REST_SPK_Callout.requestSPKCreationToEasyopsBySPKId(spkRecIds);
            }
        } 
    }

    public class SPKRequest{
        @InvocableVariable(required = true)
        public list<SPK__c> spkListCreation;
    }
}