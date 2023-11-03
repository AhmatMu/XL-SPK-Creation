/**
 * @description       :
 * @Test Class		  : ProfitabilityHistory_Schedule_Test  
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 07-29-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-13-2021   Novando Utoyo Agmawan   Initial Version
**/

global class ProfitabilityHstryGSMForecast_Week_Batch implements Database.Batchable<AggregateResult> {
    public Decimal totalDealPrice = 0;
    public Decimal totalAllCosts = 0;
    public Decimal totalMargin = 0;
    public Decimal totalPnl = 0;
    public Integer totalNumberOfRecord = 0;

    public string scheduleTimes;
    public datetime scheduleRunDateTimes;

    global ProfitabilityHstryGSMForecast_Week_Batch(string scheduleTimes, datetime scheduleRunDateTimes) {
		this.scheduleTimes = scheduleTimes;
        this.scheduleRunDateTimes = scheduleRunDateTimes;
	}

    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        Id recordTypeId_GSM = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('GSM').getRecordTypeId();

        String query = 'SELECT ' +
        'SUM(Deal_Price_Contract__c) dealPrice, ' + 
        'SUM(Total_All_Cost__c) totalAllCost, ' +
        'SUM(Margin__c) margin, ' +
        'SUM(PNL__c) pnl, ' +
        'Count(Id) numberOfRecord ' +
        'FROM Profitability__c ' + 
        'where (Status__c = \'Forecast\' AND ' +
        'Stage__c = \'Forecast Cost is Complete\' AND ' +
        'recordTypeId = ' + '\'' + recordTypeId_GSM + '\'' + ')' ;
        return new AggregateResultIterable(query);
    } 
   
    global void execute(Database.BatchableContext bc, List<sObject> scope){ 
        DateTime start_time = datetime.now();
        try {
            if(scope!=null && !scope.isEmpty()){
                DateTime dT1 = scheduleRunDateTimes;
                Date todaysDate = dT1.date();

                String todaysDate_month = AppUtils.getDateMonthName_FORMAT_MMM_ID(todaysDate);
                String todaysDate_Format = dT1.day() + ' ' + todaysDate_month + ' ' + dT1.year();

                String todaysDate_monthValue = String.valueOf(dT1.month());
                String todaysDate_YearValue = String.valueOf(dT1.year());

                for(sObject sObj : scope) {
                    AggregateResult ar = (AggregateResult)sObj;
                    totalDealPrice = (Decimal)ar.get('dealPrice');
                    totalAllCosts = (Decimal)ar.get('totalAllCost');
                    totalMargin = (Decimal)ar.get('margin');
                    totalPnl = (Decimal)ar.get('pnl');
                    totalNumberOfRecord = (Integer)ar.get('numberOfRecord');
                }
                System.debug('>>>>  ProfitabilityHstryGSMForecast_Week_Batch totalDealPrice : ' + totalDealPrice);
                System.debug('>>>>  ProfitabilityHstryGSMForecast_Week_Batch totalAllCosts : ' + totalAllCosts);
                System.debug('>>>>  ProfitabilityHstryGSMForecast_Week_Batch totalMargin : ' + totalMargin);
                System.debug('>>>>  ProfitabilityHstryGSMForecast_Week_Batch totalPnl : ' + totalPnl);
                System.debug('>>>>  ProfitabilityHstryGSMForecast_Week_Batch totalNumberOfRecord : ' + totalNumberOfRecord);

                Profitability_History__c profitabilityHistoryPipeline = new Profitability_History__c();
                if(this.scheduleTimes == 'Week'){
                    profitabilityHistoryPipeline.Name = 'Profitability GSM Pipeline - Week ' + AppUtils.weekOfMonth(todaysDate) + ' - ' + todaysDate_Format;
                    profitabilityHistoryPipeline.Time_type__c = 'Week';
                }else if(this.scheduleTimes == 'Month'){
                    profitabilityHistoryPipeline.Name = 'Profitability GSM Pipeline - Month ' + todaysDate_monthValue + ' - ' + todaysDate_Format;
                    profitabilityHistoryPipeline.Time_type__c = 'Month';
                }else if(this.scheduleTimes == 'Year'){
                    profitabilityHistoryPipeline.Name = 'Profitability GSM Pipeline - Year ' + todaysDate_YearValue + ' - ' + todaysDate_Format;
                    profitabilityHistoryPipeline.Time_type__c = 'Year';
                }

                profitabilityHistoryPipeline.Type__c = 'Pipeline';
                profitabilityHistoryPipeline.Data_type__c = 'Sim card based';
                profitabilityHistoryPipeline.Deal_Price__c = totalDealPrice;
                profitabilityHistoryPipeline.As_Of_Date__c = todaysDate;
                profitabilityHistoryPipeline.Week_Of_Month__c = AppUtils.weekOfMonth(todaysDate);
                profitabilityHistoryPipeline.Week_Of_Year__c = AppUtils.weekOfYear(dT1);
                profitabilityHistoryPipeline.Number_of_record__c = totalNumberOfRecord;
                profitabilityHistoryPipeline.Total_All_Cost__c = totalAllCosts;
                profitabilityHistoryPipeline.Margin__c = totalMargin;
                
                Database.SaveResult insertResults_profitabilityHistoryForecast = Database.insert(profitabilityHistoryPipeline, true);
            }
        }catch (Exception e) {
            String err_message = 'Error on ProfitabilityHstryGSMForecast_Week_Batch.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
    global void finish(Database.BatchableContext bc){ 
        if(this.scheduleTimes == 'Week'){
            ProfitabilityHistoryGSMAll_Week_Batch ProfitabilityHistoryGSMAll_Week_Batch_Class = new ProfitabilityHistoryGSMAll_Week_Batch('Week',scheduleRunDateTimes);
        Database.executebatch(ProfitabilityHistoryGSMAll_Week_Batch_Class);
        }else if(this.scheduleTimes == 'Month'){
            ProfitabilityHistoryGSMAll_Week_Batch ProfitabilityHistoryGSMAll_Week_Batch_Class = new ProfitabilityHistoryGSMAll_Week_Batch('Month',scheduleRunDateTimes);
            Database.executebatch(ProfitabilityHistoryGSMAll_Week_Batch_Class);
        }else if(this.scheduleTimes == 'Year'){
            ProfitabilityHistoryGSMAll_Week_Batch ProfitabilityHistoryGSMAll_Week_Batch_Class = new ProfitabilityHistoryGSMAll_Week_Batch('Year',scheduleRunDateTimes);
            Database.executebatch(ProfitabilityHistoryGSMAll_Week_Batch_Class);
        }
    }
}