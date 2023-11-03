/*-----------------------------------------------------------------------------------------------------------//
* Class Name	: Schedule_CheckAccountBadDebt
* Author		: ahmat zulkifli murad <ahmat.murad@saasten.com>
* Date			: 10 / 09 / 2022
* Description	: Description of the class
* TEST CLASS    : Schedule_CheckAccountBadDebt_Test 
*
* Changes (version)
* -------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	-----------------------------------
* @version		1.0		2022-09-10		ahmat zulkifli murad	Created
* 
*-----------------------------------------------------------------------------------------------------------*/
global class Schedule_CheckAccountBadDebt implements Schedulable, Database.AllowsCallouts{

    global void execute (SchedulableContext sc){

        //digunakan untuk update berkala status bad debt daily 1 jam after easyops update dari SAP
        string errorMsg;    
        try{
            list<id> accountIds = new list <id>();
            list<Opportunity> opportunityNewlist = new List<Opportunity>();           

           //put stagenmae di custom setting 
           //query group by accountid and stage in
            Sobject_Query_Condition__c opptyConditionSettings = Sobject_Query_Condition__c.getValues('Schedule_CheckAccountBadDebt');
            string stageCondition = opptyConditionSettings.Where_Condition__c;
            list<string> opptyStageList = stageCondition.split(';');
            set<string> setOpptyStageNames = new set <string>();
            for(string stringValues:opptyStageList ){
                    setOpptyStageNames.add(stringValues.trim());
            }
            
            system.debug('opptyConditionSettings : '+ opptyConditionSettings);    
            system.debug('stageCondition = '+ stageCondition);
            system.debug(' setOpptyStageNames = '+ setOpptyStageNames);
            
            set<string> accountBpNumbers = new set <string>();
            list<AggregateResult> opptyList = [select name opptyName, accountid AccountId, account.bp_number__c accountBpNumber, 
                                                account.name accountName, Account.Id accountIDs, stagename stageName 
                                                from opportunity where stagename IN :setOpptyStageNames and accountid != null and 
                                                account.bp_number__c != null group by name, accountid, account.name, Account.Id, 
                                                stagename, account.bp_number__c];
            system.debug('opptyList ='+ opptyList);
            system.debug('opptyList.size() ='+ opptyList.size());

            for(AggregateResult opportunityRecord : opptyList){

                opportunity opptyRecord = new opportunity ();
                opptyRecord.Name = (string) opportunityRecord.get('opptyName');
                opptyRecord.AccountId = (id) opportunityRecord.get('AccountId');
                opptyRecord.stagename = (string) opportunityRecord.get('stagename');
                accountBpNumbers.add((string) opportunityRecord.get('accountBpNumber'));
            }
            REST_CheckAccountBadDebt_Callout.checkAccountBadDebtRequestAsync(accountBpNumbers);

        }catch(exception e){
            errorMsg = errorMsg +  '. Error on Schedule_CheckAccountBadDebt' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }      
    }
}