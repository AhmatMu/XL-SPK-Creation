/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 08-01-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
public class TA_VR_CheckMandatoryField implements TriggerAction.BeforeUpdate {

    public void beforeUpdate(List<Presurvey__c> newListPresurvey, List<Presurvey__c> oldListPresurvey){
      System.debug('----TA_VR_CheckMandatoryField----');
      List<String> towerCandidateIds = new List<String>();
      try {
        List<Tower_Candidate__c> listOfTowers = [
          SELECT Id, 
          Customer_Site__c, 
          Select_For_Assessment__c, 
          IP_Loopback__c, 
          Routepath__c, 
          Router_ID__c, 
          Tower_ID__c, 
          SR_Router__c, 
          Note_NPD__c, 
          Site_ID__c,  
          Presurvey__c 
          FROM Tower_Candidate__c 
          WHERE Select_For_Assessment__c = TRUE AND  
          Presurvey__r.id In: newListPresurvey
        ];
        
        for (Presurvey__c newPresurveyReq : newListPresurvey) {
          // cek presurvey status
          System.debug('newPresurveyReq.Presurvey_Status__c: ' + newPresurveyReq.Presurvey_Status__c);
          if (
              newPresurveyReq.Presurvey_Status__c == 'Waiting Capacity Assessment' ||
              newPresurveyReq.Presurvey_Status__c == 'Final Review' ||
              newPresurveyReq.Presurvey_Status__c == 'Completed'
              ) {
            // cek size record
            if (listOfTowers.size() > 0) {
              // cek site A
              for (Tower_Candidate__c listOfTowersRec : listOfTowers) {
                if (newPresurveyReq.Need_Tower_Candidate_Site_A__c == true && newPresurveyReq.Need_Tower_Candidate_Site_B__c == false) {
                  if (
                      listOfTowersRec.Customer_Site__c == 'Site-A' &&
                      (
                        listOfTowersRec.Tower_ID__c == null               ||
                        listOfTowersRec.Router_ID__c == null              ||
                        listOfTowersRec.IP_Loopback__c == null            ||
                        listOfTowersRec.Select_For_Assessment__c == false ||
                        listOfTowersRec.Routepath__c == null              ||
                        listOfTowersRec.Note_NPD__c == null
                      )
                    ) {
                      newPresurveyReq.addError('Check Mandatory Field Site-A!');
                  } 

                  towerCandidateIds.add(listOfTowersRec.Id);
                }
                else if (newPresurveyReq.Need_Tower_Candidate_Site_A__c == false && newPresurveyReq.Need_Tower_Candidate_Site_B__c == true) {
                  if ( 
                    listOfTowersRec.Customer_Site__c == 'Site-B' &&
                    (
                      listOfTowersRec.Tower_ID__c == null               ||
                      listOfTowersRec.Router_ID__c == null              ||
                      listOfTowersRec.IP_Loopback__c == null            ||
                      listOfTowersRec.Select_For_Assessment__c == false ||
                      listOfTowersRec.Routepath__c == null              ||
                      listOfTowersRec.Note_NPD__c == null
                    )
                  ) {
                    newPresurveyReq.addError('Check Mandatory Field Site-B!');
                  }

                  towerCandidateIds.add(listOfTowersRec.Id);
                }
                else if (newPresurveyReq.Need_Tower_Candidate_Site_A__c == true && newPresurveyReq.Need_Tower_Candidate_Site_B__c == true) {
                  if ( 
                    listOfTowersRec.Tower_ID__c == null               ||
                    listOfTowersRec.Router_ID__c == null              ||
                    listOfTowersRec.IP_Loopback__c == null            ||
                    listOfTowersRec.Select_For_Assessment__c == false ||
                    listOfTowersRec.Routepath__c == null              ||
                    listOfTowersRec.Note_NPD__c == null
                  ) {
                    newPresurveyReq.addError('Check Mandatory Field Site-A & Site-B!');
                  }
                  towerCandidateIds.add(listOfTowersRec.Id);
                }

                towerCandidateIds.add(listOfTowersRec.Id);
              }
            }
          }
        }
      } catch (Exception e) {
        string notes = 'Error on TA_VR_CheckMandatoryField.BeforeUpdate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
        string errorMsg = notes + '::' +  message + '::' + lineNumber + ' :: ' + towerCandidateIds; apputils.puterror(errorMsg);
        system.debug ('===== errorMsg : ' + errorMsg);
      }
    }
}