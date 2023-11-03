/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 09-13-2022
 * @last modified by  : Diky Nurosid
**/
trigger Trigger_Prevent_Delete_Opportunity on Opportunity (before delete) {
    /*List<Profile> profileRecord = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    if(profileRecord[0].Name != 'System Administrator'){
        for(Opportunity opp : trigger.old){
            opp.addError('Only Administrator can delete record');
        }
    }*/
}