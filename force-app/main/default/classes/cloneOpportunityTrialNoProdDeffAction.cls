/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-16-2022
 * @last modified by  : Diky Nurosid
**/
public with sharing class cloneOpportunityTrialNoProdDeffAction {

    @InvocableMethod
    public static void cloneOpportunityTrialNoProdDeffAction(List<Trial_Monitoring_Ticket__c> lctList) {

        system.debug('================== ini cloneOpportunityTrialNoProdDeffAction.cloneOpportunityTrialNoProdDeffAction');

        system.debug('ListLCT ----> ' + lctList);
        string errorMsg = '';
        string relatedSFIDs = '';
        
      //  List<link__c> linkTobeAddList = new List<link__c>();
      
        try {
            for(Trial_Monitoring_Ticket__c linkConversionRec : lctList){
                
                Id  oppID = linkConversionRec.Old_OpportunityID__c;
                system.debug('opportunityID ----> ' + oppID);
                Id  lctID = linkConversionRec.Id;
                relatedSFIDs = lctID;
                system.debug('LCTID ----> ' + lctID);
                TrialMonitoringTicketServices TrialMonitoringTicketServicesObject = new TrialMonitoringTicketServices();
            
            }
      
        }
        catch (Exception e) {
            string notes = 'Error on addTrialLinkConversionRecords.addTrialLinkConversionRecords method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }

    }
    
}