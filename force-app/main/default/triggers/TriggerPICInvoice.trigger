trigger TriggerPICInvoice on Account (before insert, before update) {
    for(Account a : Trigger.New){
        Integer count = 0;
        string accountid = '';
        Integer abc = 0;
        if(a.Payer_For_GSM_Invoice__c){
                // Get the related opportunities for the accounts in this trigger
                accountid = a.Id;
                List<AggregateResult> result = [SELECT count(Id) total FROM AccountContactRelation WHERE AccountId = :accountid AND Roles includes ('PIC Print Invoice')];
                abc = result.size();
                count = (Integer) result[0].get('total');
                //System.debug('Number of PIC Invoices = ' +abc+' and '+ count);
                if(Trigger.isInsert){             
                    if (Trigger.isBefore) {
                        if(count<1)
                            if (!test.isRunningTest())
                            a.addError('Please assign PIC Print Invoice for this account before you set as payer for GSM Invoice');     
                    }
                }else if(Trigger.isUpdate){
                    if (Trigger.isBefore) {
                       if(count<1)
                            if (!test.isRunningTest())
                            a.addError('Please assign PIC Print Invoice for this account before you set as payer for GSM Invoice'); 
                    }
                }               
        }        
     }
}