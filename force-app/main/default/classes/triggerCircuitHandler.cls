/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 12-27-2021
 * @last modified by  : Diky Nurosid
**/
public with sharing class triggerCircuitHandler {
    private Boolean m_isExecuting = false;
    private Integer batchSize = 0;

    public triggerCircuitHandler(Boolean isExecuting, Integer size) {
        m_isExecuting = isExecuting;
        batchSize = size;
    }

     public void OnBeforeInsert(List<Circuit__c> circuitList) {
        String circuitName='';
        try {
            String CIDInitial='';
            String CIDNumber='';
            for(Circuit__c circuitRec : circuitList){
                system.debug('SERVICE -->' + circuitRec.Services__c);
                ServiceSetting__c serviceSetting = ServiceSetting__c.getValues(circuitRec.Services__c); 
                system.debug('serviceSetting -->' + serviceSetting);
                if(circuitRec.Services__c == serviceSetting.name){
                    Map<String, Decimal> lastCounter = new Map<String, Decimal>();
                    CIDInitial = serviceSetting.CircuitPrefixName__c; 
                    Decimal dlastCounter = serviceSetting.CircuitLastCounterNumber__c+1;
                    lastCounter.put('lastCounter',dlastCounter);
                    system.debug('lastCounter-->' + lastCounter.get('lastCounter'));
                    //Integer intlastCounter = dlastCounter.intValue();
                    CIDNumber = String.valueOf(lastCounter.get('lastCounter')).leftPad(7, '0');
                    system.debug('CIDNumberLEFTPAD-->' + CIDNumber);
                    CIDNumber = CIDNumber.left(CIDNumber.length()-2);
                    serviceSetting.CircuitLastCounterNumber__c = dlastCounter;
                    update serviceSetting;
               }
               circuitName = CIDInitial + '-' + CIDNumber;
               system.debug('circuitName-->' + circuitName);
               circuitRec.Name = circuitName;
            }
            
         } catch (Exception e) {
            string errorMsg = '';
            string notes = 'Error on triggerCircuitHandler.OnBeforeInsert method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' ; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
         }
        
     }
}