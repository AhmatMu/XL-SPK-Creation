/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-22-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class LinkConvertionTicketTriggerHandler {
    private Boolean m_isExecuting = false;
    private Integer batchSize = 0;
    
    
    public LinkConvertionTicketTriggerHandler(Boolean isExecuting, Integer size) {
        m_isExecuting = isExecuting;
        batchSize = size;
    }
 /*   
    public void OnAfterInsert(List<Link_Conversion_Ticket__c> linkConvertionTicketList) {
      	
        TrialLinkServices trialLinkServicesObject = new TrialLinkServices();
     	trialLinkServicesObject.sendTrialEmailNotification(linkConvertionTicketList);
        		
    }
*/
    // public void OnBeforeInsert(List<Link_Conversion_Ticket__c> linkConvertionTicketList) {
      	
    //     TrialLinkServices trialLinkServicesObject = new TrialLinkServices();
    //  	//trialLinkServicesObject.sendTrialEmailNotification(linkConvertionTicketList);
        
    //      List<Contact> lstcon = [select Id, lastName from Contact where lastName in :nameSet];

    //     For(Contact con2 : trigger.new){
    //     If(lstcon.size()>0){
    //         con2.lastName.adderror('duplicate last name found');
    //     }
                    
    //     }
    // }

}