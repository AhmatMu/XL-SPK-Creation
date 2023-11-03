/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Diky Nurosid
**/
public with sharing class TrialMonitoringTicketAddRecordsAction {
    
    @InvocableMethod
    public static void addTrialTicketMonitoringRecords(List<link__c> linkList) {
        system.debug('================== ini TrialMonitoringTicketAddRecordsAction.addTrialTicketMonitoringRecords');
        system.debug('======= linkList : ' + linkList);
        
        string errorMsg = '';
        string relatedSFIDs = '';
      
 	    Id linkIDs;

        try {
            for(link__c linkRec : linkList){
                System.debug('=============== linkRec : ' + linkRec);
                
                relatedSFIDs =  relatedSFIDs + linkRec.Id + ' ';
                linkIDs = linkRec.Id;
                if(linkRec.is_Trial__c == true){
                    TrialMonitoringTicketServices trialLinkServicesObject = new TrialMonitoringTicketServices();
                    TrialMonitoringTicketServices.createTrialMonitoringTicketRecords(linkIDs);
                }else{
                    system.debug('=============== ERROR TRIAL LINK HARUS TRUE');
                }
            }
      
    	}
        catch (Exception e) {
            string notes = 'Error on TrialMonitoringTicketAddRecordsAction.addTrialTicketMonitoringRecords method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            system.debug('xxx');
        }

    }
}