global class Batch_CheckAccountBadDebt_Callout implements database.Batchable<sobject>, Database.AllowsCallouts {
	private string query;
    private string accountid;
    private string bpNumber;
    dateTime todaysDate = system.now();
    String dateTimeFormat = todaysDate.format('yyyyMMddhhmmss');
    String timeNow = dateTimeFormat.right(6);
    string dateNow = dateTimeFormat.left(8);
    private String request_id = 'BD' + '_' + dateNow + '_' + timeNow;

    global Batch_CheckAccountBadDebt_Callout(String soql){
        system.debug(' === in Batch_CheckAccountBadDebt_Callout === ');
        query = soql;
        system.debug(' query = '+query);
    }
    

    global database.queryLocator start (database.batchableContext BC) {
        return Database.getQueryLocator(query);
    } 
    
    global void execute(Database.BatchableContext BC, List<AggregateResult> opptyList) {
        
        // process each batch of records default size is 200
        system.debug('size opptyAggResult'+ opptyList);
        if(opptyList.size() > 0){
    		
            for(AggregateResult opportunityRecord : opptyList){

                opportunity opptyRecord = new opportunity ();
                opptyRecord.Name = (string) opportunityRecord.get('opptyName');
                opptyRecord.AccountId = (id) opportunityRecord.get('AccountId');
                bpNumber  = (string) opportunityRecord.get('accountBpNumber');
                opptyRecord.stagename = (string) opportunityRecord.get('stagename');

                GET_BODY_REQUEST GET_BODY_REQUEST_Obj = new GET_BODY_REQUEST();
                GET_BODY_REQUEST_Obj.request_id = request_id;
                GET_BODY_REQUEST_Obj.bp_number = bpNumber;

                system.debug(' GET_BODY_REQUEST_Obj = '+ GET_BODY_REQUEST_Obj);
                
                //opportunityNewlist.add(opptyRecord);
            }
        }   
    }
     
    global void finish(Database.BatchableContext BC) {
        //REST_CheckAccountBadDebt_Callout.checkAccountBadDebtMultipleRequest(payloadRequest);
    }
    
    global class GET_BODY_REQUEST {
        global string request_id {get; set;}
        global string bp_number{get; set;}
    }
    
}