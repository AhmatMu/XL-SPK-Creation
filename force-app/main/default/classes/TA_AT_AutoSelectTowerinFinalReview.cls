/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 08-29-2023
 * @testClass		  : TA_AT_AutoSelectTowerinFinalReviewTEST
 * @last modified by  : Ahmat Zulkifli Murad
**/
public with sharing class TA_AT_AutoSelectTowerinFinalReview implements TriggerAction.AfterUpdate {
    public void AfterUpdate(List<Presurvey__c> newPresurveyList, List<Presurvey__c> oldPresurveyList) {
        System.debug('----TA_AT_AutoSelectTowerinFinalReview----');
        
        String notes;
        String errorMsg;
        String presurveyId;
        String message;

        integer lineNumber;

        Map<Id, Presurvey__c> oldMap = new Map<Id, Presurvey__c>(oldPresurveyList);
        list<Tower_Candidate__c> getcandidateTowerList = TA_QR_Presurvey_Queries.getInstance().towerCandidateList;
        list<Tower_Candidate__c> candidateTowerSiteAList = new list<Tower_Candidate__c>();
        list<Tower_Candidate__c> candidateTowerSiteBList = new list<Tower_Candidate__c>();
        list<Tower_Candidate__c> candidateTowerListtoUpdate = new list<Tower_Candidate__c>();

        try {

            for(Presurvey__c newPresurveyListRec :newPresurveyList){
                Presurvey__c oldPresurveyRec = oldMap.get(newPresurveyListRec.Id);

                if(
                    oldPresurveyRec.Presurvey_Status__c != 'Final Review' &&
                    newPresurveyListRec.Presurvey_Status__c == 'Final Review'
                ){
                    if(getcandidateTowerList != null){

                        system.debug('getcandidateTowerList: ' + json.serialize(getcandidateTowerList));
                        for(Tower_Candidate__c getcandidateTowerListRec :getcandidateTowerList){
                            if(
                                getcandidateTowerListRec.customer_site__c == 'Site-A' &&
                                getcandidateTowerListRec.Select_For_Assessment__c == true
        
                            ){
                                candidateTowerSiteAList.add(getcandidateTowerListRec);
                            }
        
                            if(
                                getcandidateTowerListRec.customer_site__c == 'Site-B' &&
                                getcandidateTowerListRec.Select_For_Assessment__c == true
                            ){
                                candidateTowerSiteBList.add(getcandidateTowerListRec);
                            }
                        }
                        
                        if(candidateTowerSiteAList.size() == 1){
                            candidateTowerSiteAList[0].Final_Review_Selection__c = true;
                            
                            candidateTowerListtoUpdate.add(candidateTowerSiteAList[0]);
                        }
        
                        if(candidateTowerSiteBList.size() == 1){
                            candidateTowerSiteBList[0].Final_Review_Selection__c = true;
        
                            candidateTowerListtoUpdate.add(candidateTowerSiteBList[0]);
                        }
                        system.debug('candidateTowerListtoUpdate: ' + json.serialize(candidateTowerListtoUpdate));
                    }
                }
            }

            if(candidateTowerListtoUpdate != null){
                update candidateTowerListtoUpdate;
            }
        } catch (Exception e) {
            notes = 'Error on TA_AT_AutoSelectTowerinFinalReview.AfterUpdate method.'; message =  e.getmessage() + ' - ' +e.getStacktraceString() ; lineNumber = e.getLineNumber();
            errorMsg = notes + '::' +  message + '::' + lineNumber + ' :: ' + presurveyId; apputils.puterror(errorMsg);
            system.debug ('errorMsg : ' + errorMsg);
        }
    }
}