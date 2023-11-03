public with sharing class TA_AT_SRVP_AI_SetSiteAssignment implements TriggerAction.AfterInsert{
    public void afterInsert(list<sr_vp_list__c> newSRVPList){
        system.debug('=== in TA_AT_SRVP_AI_SetSiteAssignment ===');
        string errorMsg;

        try {
            // get srId 
            Set<Id> srIds = new Set<Id>();
            Set<Id> srVPIds = new Set<Id>();
            System.debug('===srIds : ' + srIds);
            System.debug('===srVPIds : ' + srVPIds);
            
            for (sr_vp_list__c srIdRec : newSRVPList) {
                srIds.add(srIdRec.SR_Notif__c);
                srVPIds.add(srIdRec.Id);
            }

            List<SR_PR_Notification__c> srprList = [SELECT Id, Site_A__c, Site_B__c FROM SR_PR_Notification__c WHERE Id In: srIds];
            List<SR_VP_List__c> srVPList = [SELECT Id, Site__c, Site_Assignment__c, SR_Notif__c  FROM SR_VP_List__c WHERE Id In: srVPIds];
            System.debug('===srprList : ' + srprList);
            System.debug('===srVPList : ' + srVPList);

            Map<Id, SR_PR_Notification__c> srprMap = new Map<Id, SR_PR_Notification__c>();
            for (SR_PR_Notification__c srprRec : srprList) {
                srprMap.put(srprRec.Id, srprRec);
            }

            List<SR_VP_List__c> updSrVPList = new List<SR_VP_List__c>();
            for (SR_VP_List__c srvpRec : srVPList) {
                SR_PR_Notification__c srNotifRec = srprMap.get(srvpRec.SR_Notif__c);
                System.debug('===srNotifRec : ' + srNotifRec);

                if (srvpRec.Site__c == 'A') {
                    System.debug('=== in site A ===');

                    srvpRec.Site_Assignment__c = srNotifRec.Site_A__c;
                    System.debug('===srvpRec.Site_Assignment__c : ' + srvpRec.Site_Assignment__c);

                    updSrVPList.add(srvpRec);
                } else if (srvpRec.Site__c == 'B') {
                    System.debug('=== in site B ===');

                    srvpRec.Site_Assignment__c = srNotifRec.Site_B__c;
                    System.debug('===srvpRec.Site_Assignment__c : ' + srvpRec.Site_Assignment__c);
                    
                    updSrVPList.add(srvpRec);
                }
            }
            
            update updSrVPList;
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_SRVP_AI_SetSiteAssignment After insert' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}