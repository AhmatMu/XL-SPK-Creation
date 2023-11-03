public class TA_AT_SRPR_SPKCreation implements TriggerAction.AfterInsert {

    public void AfterInsert(List<SR_PR_Notification__c> newList){
        System.debug('----TA_AT_SRPR_SPKCreation----');

        set<string> projectCordinatorNiks = new set<string>();
        set<string> srNames = new set<string>();
        set<id> opportunityIds = new set<id>();
        set<string> projectCoordinatorNik = new Set<String>();

        String errorMsg;

        try {
            for(SR_PR_Notification__c newPRListRec :newList){
                string ProjectCoordinator = newPRListRec.project_coordinator__c;
                list<string> nikProjectCoordinator = ProjectCoordinator.split(' ');

                srNames.add('sr-' + newPRListRec.SR_Name__c);
                projectCoordinatorNik.add(nikProjectCoordinator[0]);
                opportunityIds.add(newPRListRec.opportunity__c);
            }
    
            map<String, user> projectCoordinatorMap = new map<String, user>();
            list<user> pojectCoordinatorUserList = [
                SELECT id, email, Employee_ID__c FROM User where Employee_ID__c IN:projectCoordinatorNik
            ];
            for(user pojectCoordinatorUserListRec :pojectCoordinatorUserList){
                projectCoordinatorMap.put(pojectCoordinatorUserListRec.Employee_ID__c, pojectCoordinatorUserListRec);
            }

            // TODO:: kalau object lease dijadikan automated maka query ke vendor object lease(ambil object lease)
            list<SR_VP_List__c> SRVPList= [
                SELECT id,
                name,
                Vendor__c,
                Vendor__r.listemail__c,
                Vendor__r.Name,
                site__c,
                Survey_LastMile_Type__c,
                Type_of_Lastmile__c,
                Site_Assignment__c,
                SR_Notif__c,
                SR_Notif__r.name,
                SR_Notif__r.Services__c,
                SR_Notif__r.Vendor__r.name,
                SR_Notif__r.opportunity__c,
                SR_Notif__r.opportunity__r.accountid,
                SR_Notif__r.opportunity__r.PR_Rel__r.Project_Coordinator_Email__c,
                SR_Notif__r.Project_Coordinator__c
                FROM SR_VP_List__c
                WHERE SR_Notif__r.opportunity__c in: opportunityIds
            ];

            for(SR_PR_Notification__c newPRListRec :newList){
                list<SPK__c> spkListtoInsert = new list<SPK__c>();
                if(!SRVPList.isempty()){
                    for (SR_VP_List__c SRVPListRec : SRVPList){
                        string ProjectCoordinator = SRVPListRec.SR_Notif__r.Project_Coordinator__c;
                        list<string> nikProjectCoordinator = ProjectCoordinator.split(' ');

                        SPK__c newSPKObj = new SPK__c();
                        
                        newSPKObj.status__c                     = 'Draft';
                        newSPKObj.Name                          = 'Draft SPK - ' + SRVPListRec.Vendor__r.name ;
                        newSPKObj.Account__c                    = SRVPListRec.SR_Notif__r.opportunity__r.accountid;
                        newSPKObj.Opportunity__c                = SRVPListRec.SR_Notif__r.opportunity__c;
                        newSPKObj.Project_Coordinator_Email__c  = (projectCoordinatorMap != null ) ? projectCoordinatorMap.get(nikProjectCoordinator[0]).email : null;
                        newSPKObj.Site_Assignment__c            = SRVPListRec.Site_Assignment__c;

                        // TODO:: jika two site maka ngirim site yang tidak di assign ke field other_site_assignment__c
                        if (newPRListRec.RecordType.Name.contains('Two Site')) {
                            if (newPRListRec.Site_B__c != SRVPListRec.Site_Assignment__c) { // kalau assignmentnya ternyata site A di object SRVPList
                                newSPKObj.Other_Site_Assignment__c = newPRListRec.Site_B__c; // other side assignment di isi site B dari pr
                            } else if (newPRListRec.Site_A__c != SRVPListRec.Site_Assignment__c) { // kalau assignmentnya ternyata site B di object SRVPList
                                newSPKObj.Other_Site_Assignment__c = newPRListRec.Site_A__c; // other side assignment di isi site A dari PR
                            } 
                        }
                        
                        newSPKObj.Site__c                       = SRVPListRec.site__c;
                        newSPKObj.Partner_Name__c               = SRVPListRec.Vendor__c;
                        newSPKObj.PR_Rel__c                     = newPRListRec.id;
                        newSPKObj.Partner_Email__c              = SRVPListRec.Vendor__r.listemail__c;
                        newSPKObj.sR_Rel__c                     = SRVPListRec.SR_Notif__c;

                        spkListtoInsert.add(newSPKObj);
                    }
                    if(!spkListtoInsert.isempty()){
                        insert spkListtoInsert;
                    }
                }    
            }
            
        } catch (Exception e) {
            errorMsg = errorMsg +  '. Error on TA_AT_SRPR_SPKCreation After Insert :: ' +  e.getmessage() + ' :: ' + e.getStacktraceString() + e.getLineNumber();
            apputils.puterror(errorMsg); SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }
    }
}