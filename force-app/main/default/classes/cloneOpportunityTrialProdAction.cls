/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-25-2022
 * @last modified by  : Diky Nurosid
**/
public with sharing class cloneOpportunityTrialProdAction {

    @InvocableMethod
    public static void cloneOpportunityTrialProdAction(List<Trial_Monitoring_Ticket__c> lctList) {
        system.debug('================== ini cloneOpportunityTrialProdAction.cloneOpportunityTrialProdAction');
        //   system.debug('======= Opportunity ID : ' + OpportunityId);
        system.debug('opportunityID ----> ' + lctList);
           string errorMsg = '';
           string relatedSFIDs = '';

           try {
            for(Trial_Monitoring_Ticket__c trialMonitoringTicketRec : lctList){
                
                Id  oppID = trialMonitoringTicketRec.Old_OpportunityID__c;
                system.debug('opportunityID ----> ' + oppID);
                Id  lctID = trialMonitoringTicketRec.Id;
                system.debug('LCTID ----> ' + lctID);
                // id prID = trialMonitoringTicketRec.PR_Rel__c;
                // system.debug('prID--------->'+prID);
                relatedSFIDs = lctID;
                TrialMonitoringTicketServices trialLinkServicesObject = new TrialMonitoringTicketServices();
                TrialMonitoringTicketServices.createOpportunityForTrialToProduction(oppID,lctID);
            }
      
        }
        catch (Exception e) {
            string notes = 'Error on addTrialLinkConversionRecords.addTrialLinkConversionRecords method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
    
}