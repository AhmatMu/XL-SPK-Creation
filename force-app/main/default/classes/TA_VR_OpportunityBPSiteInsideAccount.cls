/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 08-08-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
public with sharing class TA_VR_OpportunityBPSiteInsideAccount implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<Opportunity> oppNewList, List<Opportunity> oppOldList){
        
        try{
            system.debug('=========== TA_VR_OpportunityBPSiteInsideAccount ============' );
   
            map<id, Opportunity> opportunityOldMap = new map<id, Opportunity>(oppOldList);
            map<id, Opportunity> opportunityNewMap = new map<id, Opportunity>(oppNewList);

            boolean validationSite = false;
            
            String OpportunityAccountId = '';
            String opportunityAccountSiteA = '';
            String opportunityAccountSiteB = '';

            id opportunityId;

            for (Opportunity opp : oppNewList) {
                opportunityId = opp.Id;
                OpportunityAccountId = opp.AccountId;
                opportunityAccountSiteA = opp.Account_Site_A__c;
                opportunityAccountSiteB = opp.Account_Site_B__c;

            }


            system.debug(' == OpportunityAccountId >>' + OpportunityAccountId);
            system.debug('== opportunityId >>' + opportunityId);

            list <Account> accSiteA = [select id, ParentId, parent.name from account where id = :opportunityAccountSiteA ];
            system.debug(' == accSiteA > ' + accSiteA);

            list <Account> accSiteB = [select id, ParentId, parent.name from account where id = :opportunityAccountSiteB ];
            system.debug(' == accSiteB > ' + accSiteB);

            if(accSiteA != null){
                for(Account accSiteARec : accSiteA){

                    system.debug(' opportunityOldMap.get(opportunityId).Account_Site_A__c  == opportunityNewMap.get(opportunityId).Account_Site_A__c ' + opportunityOldMap.get(opportunityId).Account_Site_A__c + ' == '+ opportunityNewMap.get(opportunityId).Account_Site_A__c);

                    if(opportunityOldMap.get(opportunityId).Account_Site_A__c != opportunityNewMap.get(opportunityId).Account_Site_A__c && opportunityNewMap.get(opportunityId).Account_Site_A__c !=null){

                        system.debug(' OpportunityAccountId != accSiteARec.ParentId ' + OpportunityAccountId + ' == '+ accSiteARec.ParentId);
                        if(OpportunityAccountId != accSiteARec.ParentId && accSiteARec.id != OpportunityAccountId){
                            
                            opportunityNewMap.get(opportunityId).addError(System.Label.OPPORTUNITY_TA_VR_OpportunityBPSiteInsideAccountSiteA);
                            
                        }
                    }
                }
            }

            if(accSiteB != null){
                for(Account accSiteBRec : accSiteB){

                    system.debug(' opportunityOldMap.get(opportunityId).Account_Site_B__c  == opportunityNewMap.get(opportunityId).Account_Site_B__c ' + opportunityOldMap.get(opportunityId).Account_Site_B__c + ' == '+ opportunityNewMap.get(opportunityId).Account_Site_B__c);
                    if(opportunityOldMap.get(opportunityId).Account_Site_B__c != opportunityNewMap.get(opportunityId).Account_Site_B__c && opportunityNewMap.get(opportunityId).Account_Site_B__c !=null){
                        system.debug(' OpportunityAccountId == accSiteBRec.ParentId ' + OpportunityAccountId + ' == '+ accSiteBRec.ParentId);
                        if(OpportunityAccountId != accSiteBRec.ParentId && accSiteBRec.id != OpportunityAccountId ){
                            
                            opportunityNewMap.get(opportunityId).addError(System.Label.OPPORTUNITY_TA_VR_OpportunityBPSiteInsideAccountSiteB);
                            
                        }
                    }                  
                }
            }

        }catch(exception e){
            string notes = 'Error on TA_VR_OpportunityBPSiteInsideAccount.BeforeUpdate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }
}