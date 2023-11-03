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

global class ProfitabilityHistoryActual_Week_Batch implements Database.Batchable<AggregateResult> {
    public Decimal totalDealPrice = 0;
    public Decimal totalAllCosts = 0;
    public Decimal totalMargin = 0;
    public Decimal totalPnl = 0;
    public Integer totalNumberOfRecord = 0;

    public string scheduleTimes;
    public datetime scheduleRunDateTimes;

    global ProfitabilityHistoryActual_Week_Batch(string scheduleTimes, datetime scheduleRunDateTimes) {
		this.scheduleTimes = scheduleTimes;
        this.scheduleRunDateTimes = scheduleRunDateTimes;
	}

    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        Id recordTypeId_NonGsm = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();
        Id recordTypeId_Iot = Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get('IOT MCA').getRecordTypeId();

        String query = 'SELECT ' +
        'SUM(Deal_Price_Contract__c) dealPrice, ' + 
        'SUM(Total_All_Cost__c) totalAllCost, ' +
        'SUM(Margin__c) margin, ' +
        'SUM(PNL__c) pnl, ' +
        'Count(Id) numberOfRecord ' +
        'FROM Profitability__c ' + 
        'where (Status__c = \'Actual\' AND ' +
        'Stage__c = \'Actual Cost is Complete\' AND ' +
        'Status_Link__c != \'EXPIRED\' AND ' +
        'Status_Link__c != \'DISMANTLED\' AND ' +
        '(recordTypeId = ' + '\'' + recordTypeId_NonGsm + '\'' + ' OR recordTypeId = ' + '\'' + recordTypeId_Iot + '\'' + ')) ' ;
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
                System.debug('>>>>  ProfitabilityHistoryActual_Week_Batch totalDealPrice : ' + totalDealPrice);
                System.debug('>>>>  ProfitabilityHistoryActual_Week_Batch totalAllCosts : ' + totalAllCosts);
                System.debug('>>>>  ProfitabilityHistoryActual_Week_Batch totalMargin : ' + totalMargin);
                System.debug('>>>>  ProfitabilityHistoryActual_Week_Batch totalPnl : ' + totalPnl);
                System.debug('>>>>  ProfitabilityHistoryActual_Week_Batch totalNumberOfRecord : ' + totalNumberOfRecord);

                Profitability_History__c profitabilityHistoryActual = new Profitability_History__c();
                if(this.scheduleTimes == 'Week'){
                    profitabilityHistoryActual.Name = 'Profitability Actual - Week ' + AppUtils.weekOfMonth(todaysDate) + ' - ' + todaysDate_Format;
                    profitabilityHistoryActual.Time_type__c = 'Week';
                }else if(this.scheduleTimes == 'Month'){
                    profitabilityHistoryActual.Name = 'Profitability Actual - Month ' + todaysDate_monthValue + ' - ' + todaysDate_Format;
                    profitabilityHistoryActual.Time_type__c = 'Month';
                }else if(this.scheduleTimes == 'Year'){
                    profitabilityHistoryActual.Name = 'Profitability Actual - Year ' + todaysDate_YearValue + ' - ' + todaysDate_Format;
                    profitabilityHistoryActual.Time_type__c = 'Year';
                }
                
                profitabilityHistoryActual.Type__c = 'Actual';
                profitabilityHistoryActual.Data_type__c = 'Non sim card based';
                profitabilityHistoryActual.As_Of_Date__c = todaysDate;
                profitabilityHistoryActual.Week_Of_Month__c = AppUtils.weekOfMonth(todaysDate);
                profitabilityHistoryActual.Week_Of_Year__c = AppUtils.weekOfYear(dT1);
                profitabilityHistoryActual.Number_of_record__c = totalNumberOfRecord;
                profitabilityHistoryActual.Deal_Price__c = totalDealPrice;
                profitabilityHistoryActual.Total_All_Cost__c = totalAllCosts;
                profitabilityHistoryActual.Margin__c = totalMargin;
    
                Database.SaveResult insertResults_profitabilityHistoryActual = Database.insert(profitabilityHistoryActual, true);
            }
        }catch (Exception e) {
            String err_message = 'Error on ProfitabilityHistoryActual_Week_Batch.cls - execute ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
    
    global void finish(Database.BatchableContext bc){ 
        if(this.scheduleTimes == 'Week'){
            ProfitabilityHistoryForecast_Week_Batch ProfitabilityHistoryForecast_Week_Batch_Class = new ProfitabilityHistoryForecast_Week_Batch('Week',scheduleRunDateTimes);
            Database.executebatch(ProfitabilityHistoryForecast_Week_Batch_Class);
        }else if(this.scheduleTimes == 'Month'){
            ProfitabilityHistoryForecast_Week_Batch ProfitabilityHistoryForecast_Week_Batch_Class = new ProfitabilityHistoryForecast_Week_Batch('Month',scheduleRunDateTimes);
            Database.executebatch(ProfitabilityHistoryForecast_Week_Batch_Class);
        }else if(this.scheduleTimes == 'Year'){
            ProfitabilityHistoryForecast_Week_Batch ProfitabilityHistoryForecast_Week_Batch_Class = new ProfitabilityHistoryForecast_Week_Batch('Year',scheduleRunDateTimes);
            Database.executebatch(ProfitabilityHistoryForecast_Week_Batch_Class);
        }
    }
}