trigger Trigger_Prevent_Delete_Contact2 on Contact (before delete) {
    List<Profile> profileRecord = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    if(profileRecord[0].Name != 'System Administrator'){
        for(Contact con : trigger.old){
            con.addError('Only Administrator can delete record');
        }
    }
}