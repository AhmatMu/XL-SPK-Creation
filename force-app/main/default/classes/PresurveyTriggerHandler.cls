/* ====================================================================================================
 * Class Name		        : PresurveyTriggerHandler
 * Test Class		        : TestPresurveyTriggerHandler
 * Created By		        : Kahfi Frimanda
 * Created Date		        : 03/2022
 * Created Description		: - 
 * 					          - 
 * Updated By               : Ahmad Aulia Fahmi
 * Updated Date	            : 12/06/2023
 * Updated Description		: - Mengupdate trigger after update, untuk handling jika lead sudah terbentuk sebelumnya maka tidak melakukan create new lead
 * 					          - 
 * ====================================================================================================
 */
public class PresurveyTriggerHandler implements ITriggerHandler{
    
    private Lead contructNewLead(SObject pSurvey, String leadStatus){
        Lead newLead = new Lead();
        newLead.Company = (String)pSurvey.get('Customer_Name__c');
        newLead.Status = leadStatus;
        newLead.OwnerId = (String)pSurvey.get('Ownerid');
        newLead.Lastname = (String)pSurvey.get('Customer_Name__c');
       	newLead.Business_Partner__c = ( (String)pSurvey.get('Account__c') != Null) ? (String)pSurvey.get('Account__c') : Null;
        newLead.LeadSource = 'Presurvey';
        newLead.Description = (String)pSurvey.get('Customer_Requirement__c');
        newLead.Service_Group__c = ( (String)pSurvey.get('Service_Group__c') != Null && (String)pSurvey.get('Service_Group__c') == 'NON GSM') ? 'Non-GSM' : 'GSM';
		newLead.Presurvey__c =  (String)pSurvey.get('id');   
        return newLead;
    }
    
    Private String getSolutionPIC(SObject pSurvey, List<AM_Portfolio_Mapping__c> SolMapp){
        String SolutionPIC = '';
        for(AM_Portfolio_Mapping__c apm : SolMapp) { 
            //map solution assigned to presurvey depend on owner of presurvey
            if(apm.AM__c==pSurvey.get('Ownerid')){                       
                SolutionPIC = apm.Portfolio_Management_Support__c;
                break;
            }            
        }  
        return SolutionPIC;
    }

    Public void BeforeInsert(List<SObject> newItems){
        DateTime start_time = datetime.now();
        try{
            list<AM_Portfolio_Mapping__c> SolMapp=[SELECT id,AM__c,Portfolio_Management_Support__c FROM AM_Portfolio_Mapping__c WHERE Status__c='Active'];                      
            for( SObject pSurvey : newItems ){
                //get PIC Solution based on AM_Portfolio_Mapping
                psurvey.put('Solution_PIC__c',getSolutionPIC(pSurvey,SolMapp));                             
            }        
            
        }catch (Exception e){
            String err_message = 'Error on Trigger before insert - PresurveyTriggerHandler.cls - BeforeInsert ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
    Public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
    }
    
    Public void BeforeDelete(Map<Id, SObject> oldItems){}
    
    Public void AfterInsert(Map<Id, SObject> newItems){}
    
    Public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        SObject dataPresurvey;
        String keyPresurvey;
        
        for(String key: newItems.keySet()){
            dataPresurvey = newItems.get(key);
            keyPresurvey = key;
        }
        
        List<Lead> dataLeadofPresurvey = [Select Id, Name From Lead Where Presurvey__c =: keyPresurvey];
        
        if(dataLeadofPresurvey.size() > 0){
            System.debug('Dont create new lead');
        }else{
            System.debug('Create new lead');
            
            try{
                System.debug('Presurvey_trigger_after_update hit at : '+start_time);
                List<Lead> newLeads = new List<Lead>();
                
                for(SObject pSurvey : newItems.values()){
                    SObject oldpSurvey;
                    if(oldItems != null && oldItems.get((id)pSurvey.get('Id')) != null){
                        oldpSurvey = oldItems.get((Id)pSurvey.get('Id'));
                    }
                    if(oldpSurvey.get('Presurvey_Status__c') != pSurvey.get('Presurvey_Status__c') &&
                       (String)pSurvey.get('Presurvey_Status__c') == 'In Progress'){
                        System.debug('oldPresurveyStatus :'+(String)oldpSurvey.get('Presurvey_Status__c'));
                        System.debug('newPresurveyStatus :'+(String)pSurvey.get('Presurvey_Status__c'));
                        newLeads.add(contructNewLead(pSurvey,'Working - Contacted'));
                    }                
                }
                System.debug('New Lead Size : '+newLeads.size());
                insert newLeads;
            }Catch(Exception e){
                String err_message = 'Error on Trigger before insert - PresurveyTriggerHandler.cls - AfterInsert ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
                AppUtils.putError(err_message);
           }
            
        }
    }
    
    Public void AfterDelete(Map<Id, SObject> oldItems){}
    
    Public void AfterUndelete(Map<Id, SObject> oldItems){}
    
    Public Boolean IsDisabled(){
        return false;
    }
}