/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-28-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class TrialMonitoringTicketTriggerHandler {
    private Boolean m_isExecuting = false;
    private Integer batchSize = 0;
    
    
    public TrialMonitoringTicketTriggerHandler(Boolean isExecuting, Integer size) {
        m_isExecuting = isExecuting;
        batchSize = size;
    }
    
    public void OnAfterInsert(List<Trial_Monitoring_Ticket__c> linkConversionTicketList) {
        system.debug ('== MasukAfterInsert : YAAAAAAAAAAAAA');
        TrialMonitoringTicketServices trialLinkServicesObject = new TrialMonitoringTicketServices();    		
    }

    public void OnBeforeInsert(List<Trial_Monitoring_Ticket__c> linkConversionTicketList) {
        system.debug('masuk ke TrialMonitoringTicketTriggerHandler.OnBeforeInsert');
       
        		
    }

}