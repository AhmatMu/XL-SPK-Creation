/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 09-13-2022
 * @last modified by  : Diky Nurosid
**/

public with sharing class TA_VR_Opportunity_PreventToDelete implements TriggerAction.BeforeDelete {
    public void beforeDelete(List<Opportunity> oldList){
        try {
            List<String> opportunityIds = new list<String>();
            List<Profile> profileRecord = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
           if(profileRecord[0].Name != 'System Administrator'){
            for (Opportunity opp : oldList) {
                opp.addError('Only Administrator can delete record');
            }
           }
            
        }catch(Exception e) {
            string notes = 'Error on TA_VR_Opportunity_PreventToDelete.BeforeDelete method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
}