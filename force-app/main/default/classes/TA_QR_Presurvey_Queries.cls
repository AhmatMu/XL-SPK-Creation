/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 08-02-2023
 * testClass          : TA_QR_Presurvey_QueriesTEST
 * @last modified by  : Ahmat Zulkifli Murad
**/
public with sharing class TA_QR_Presurvey_Queries {
    
    public static TA_QR_Presurvey_Queries instance;
 
    public TA_QR_Presurvey_Queries() {
     
    }
    
    public static TA_QR_Presurvey_Queries getInstance() {
        if (TA_QR_Presurvey_Queries.instance == null) {
            TA_QR_Presurvey_Queries.instance = new TA_QR_Presurvey_Queries();
        }
        return TA_QR_Presurvey_Queries.instance;
    }
    
    public list<Tower_Candidate__c> towerCandidateList { get; private set; }
  
    public class Services implements TriggerAction.BeforeUpdate{

      public void beforeUpdate(List<presurvey__c> newList, List<presurvey__c> oldList) {
        TA_QR_Presurvey_Queries.getInstance().towerCandidateList = gettowerCandidateListFromPresurvey( oldList );
      }

      public list<Tower_Candidate__c> gettowerCandidateListFromPresurvey(list<presurvey__c> oldPresurveyList){
            Set<Id> presurveyIds = new Set<Id>();

            for(presurvey__c presurveyRec: oldPresurveyList){
                presurveyIds.add(presurveyRec.id);
            }

            return new list<Tower_Candidate__c>(
                [
                    SELECT Id, 
                    Name, 
                    Presurvey__c, 
                    Select_For_Assessment__c, 
                    Source__c, 
                    Customer_Site__c, 
                    Final_Review_Selection__c 
                    FROM Tower_Candidate__c 
                    WHERE Presurvey__c IN: presurveyIds 
                ]
            );
        }
    }
}