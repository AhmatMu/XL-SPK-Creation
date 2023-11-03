global class ForecastRevenueRecurring_Batch implements Database.Batchable<SObject> {
	public string month;
	public string year;
	public string quarter;


	public Date requestDate;
	public Date requestMMinOneDate;
	
	 

	global ForecastRevenueRecurring_Batch(string month, string year) {
		this.month = month;
		this.year = year;

        Switch on this.month {
            when '1', '2', '3' {
                this.quarter = 'Q1'; 
            }
            when '4', '5', '6' {
                this.quarter = 'Q2'; 
            }
            when '7', '8', '9' {
                this.quarter = 'Q3'; 
            }
            when '10', '11', '12' {
                this.quarter = 'Q4'; 
            }
        }

	}
	
	/**
	 * @description gets invoked when the batch job starts
	 * @param context contains the job ID
	 * @returns the record set as a QueryLocator object that will be batched for execution
	 */ 
	global Database.QueryLocator start(Database.BatchableContext context) {
		

		system.debug ('=== this.year : ' + this.year);
		system.debug ('=== this.month : ' + this.month);

		requestDate = Date.newInstance(Integer.valueOf(this.year), Integer.valueOf(this.month), 1 );
		Date dataSourceDate = requestDate.addMonths(-1);
		String monthData = String.valueOf ( dataSourceDate.month() ) ; 
		String yearData = String.valueOf ( dataSourceDate.year() ) ; 

		string recordtType='';
		if (monthData == '12' || monthData == '3' || monthData == '6' || monthData == '9') {
			recordtType = 'Actual Revenue';
		} else {recordtType = 'Forecast Revenue Recurring';}

		

		String sqlString = 'SELECT Id, Name, ' +
								'   Revenue_Category__c, Revenue_Category__r.name, Group_Service__c, Customer__c,  ' +
								'   Sales_Manager__c, Group_Head__c, Segment__c, ' +
								'   AM_Employee_ID__c, Sales_Manager_Employee_ID__c, Customer_BP_No__c, ' +
								'   Group_Head_Employee_ID__c, '  +
								'   Sales_Performance_Monthly_AMGS__c, Amount__c, Unique_ID__c ' +
								' FROM Sales_Revenue__c ' + 
								' WHERE RecordType.Name = \'' + recordtType  + '\'' +
								'	AND month__c = \'' + monthData + '\'' + 
								'	AND year__c = \'' + yearData + '\'' 
								//+ '   AND AM_EMPLOYEE_ID__C = \'90006890\' ' 

							;

		system.debug ('=== sqlString : ' + sqlString);
		return Database.getQueryLocator(sqlString);
	}

	/**
	 * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
	 * @param context contains the job ID
	 * @param scope contains the batch of records to process.
	 */ 
   	global void execute(Database.BatchableContext context, List<Sales_Revenue__c> scope) {
		

		Map <String, Forecast_Recurring_Revenue_Formula__c> formmulaMap = new Map <String, Forecast_Recurring_Revenue_Formula__c>();	
		List <Sales_Revenue__c> srvNewDataList = new List <Sales_Revenue__c>();



		//-- get "Actual Revenue" RecordType ID
		/*
		List<RecordType> recordTypeList = [SELECT Id, Name, DeveloperName, SobjectType 
											FROM RecordType 
											WHERE sobjectType = 'Sales_revenue__c' 
												AND developername = 'Actual_Revenue'];                                    
        system.System.debug('======= recordTypeList'+ recordTypeList);
        if(recordTypeList.size() > 0){
            actualRevenueRecordTypeID = recordTypeList[0].Id;
            system.System.debug('============ actualRevenueRecordTypeID : ' + actualRevenueRecordTypeID);
        } */
		string recordTypeName = 'Forecast Revenue Recurring';
		Id forecastRevenueRecurringRecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            


		//-- get formula string list, and put in the map
		List<Forecast_Recurring_Revenue_Formula__c> formulaList = [SELECT specific_formula__c, free_formula__c,
																			revenue_category__c, 
																			Total_Forecast__c,
																			Total_Last_Month__c,
																			Total_Forecast_1__c,
																			Total_Last_Month_1__c,
																			Total_Forecast_2__c,
																			Total_Last_Month_2__c,
																			Total_Forecast_3__c,
																			Total_Last_Month_3__c,
																			Churn__c,
																			Active__c
																		FROM Forecast_Recurring_Revenue_Formula__c
																		WHERE year__c = :this.year
																			AND quarter__c = :this.quarter	
																			];

		for (Forecast_Recurring_Revenue_Formula__c formula : formulaList ) {
			formmulaMap.put (formula.revenue_category__c, formula );
		}
		//-- .endOf mapping formula 
		
		Integer daysMonthMinOne = 31;	//-- todo: get from calculation
		Integer daysThisMonth = 30;	//-- todo: get from calculation

		system.debug ('=== this.year : ' + this.year);
		system.debug ('=== this.month : ' + this.month);

		requestDate = Date.newInstance(Integer.valueOf(this.year), Integer.valueOf(this.month), 1 );
		system.debug ('== requestDate : ' +  requestDate);

		requestMMinOneDate = requestDate.addMonths(-1);

		daysMonthMinOne =  Date.daysInMonth( requestMMinOneDate.year(), requestMMinOneDate.month());
		daysThisMonth =  Date.daysInMonth( requestDate.year(), requestDate.month());
		

		system.debug ('=== scope : ' + scope);
		//-- iterate data source, put in new data.
		integer counter=1;
		string additonalInfo = '';
		for ( Sales_Revenue__c srvObj : scope  ) {
			additonalInfo = '';
			Sales_Revenue__c tmpSRVObj = new Sales_Revenue__c();

			system.debug ('=== srvObj : ' + srvObj);

			tmpSRVObj.name = counter + '. --will be generate in trigger before update--'; 
			tmpSRVObj.Month__c = this.month ; 
			tmpSRVObj.Year__c = this.year ; 

			tmpSRVObj.RecordTypeId = forecastRevenueRecurringRecordTypeId; 
			tmpSRVObj.type__c = recordTypeName;

			tmpSRVObj.Revenue_Category_Name__c = srvObj.Revenue_Category__r.name;
			tmpSRVObj.Revenue_Category__c = srvObj.Revenue_Category__c; 
			tmpSRVObj.Group_Service__c = srvObj.Group_Service__c;

			tmpSRVObj.Customer__c = srvObj.Customer__c;

			tmpSRVObj.Sales_Manager__c = srvObj.Sales_Manager__c ; 
			tmpSRVObj.Group_Head__c = srvObj.Group_Head__c; 
			tmpSRVObj.Segment__c = srvObj.Segment__c; 

			tmpSRVObj.AM_Employee_ID__c = srvObj.AM_Employee_ID__c; 
			tmpSRVObj.Sales_Manager_Employee_ID__c = srvObj.Sales_Manager_Employee_ID__c; 
			tmpSRVObj.Customer_BP_No__c = srvObj.Customer_BP_No__c; 
			tmpSRVObj.Group_Head_Employee_ID__c = srvObj.Group_Head_Employee_ID__c; 

			

			/*
			revenue category name
			customer BP No
			group service name


			*/
			

			tmpSRVObj.Unique_ID__c = counter + '. --will be generate in trigger before update--';
			tmpSRVObj.Sales_Performance_Monthly_AMGS__c = srvObj.Sales_Performance_Monthly_AMGS__c ; //-- will be generate in trigger before update



			//-- calculate new amount based on formula
			Double tmpValue = 0;
			Double lastAmount = 0;
			String lastOperation = '';

			Forecast_Recurring_Revenue_Formula__c formulaObj = formmulaMap.get (srvObj.Revenue_Category__c);
			String specificFormulaString = formulaObj.specific_formula__c;
			String freeFormulaString =  formulaObj.free_formula__c;
			String formulaString;

			//if ( specificFormulaString == '( [M-1] * [1-CHURN] / [#DAYS_M-1] ) * [#DAYS_M] )') {


			if ( freeFormulaString <> ''  && freeFormulaString <> null) {
				formulaString = freeFormulaString;
			} else formulaString = specificFormulaString;

			if (formulaObj.active__c == TRUE && formulaString <> '' & formulaString <> null) {
				

				//formulaString = '[M-1] * [1-CHURN] / [#DAYS_M-1] * [#DAYS_M]';	//-- sementara set untuk test!! todo: use above syntax

				tmpSRVObj.formula__c = formulaString;
				tmpSRVObj.formula_info__c = formulaString;
				

				formulaString = formulaString.replaceAll('\\(','').replaceAll('\\)','').replace('  ',' ').replace(' ','');
				formulaString = formulaString.replaceAll('\\*',' \\* ').replaceAll('\\/',' \\/ ');
				//.replaceAll('\\-',' \\- ').replaceAll('\\+',' \\+ ');
				

				List<String> formulaItemList = formulaString.split(' ');
				System.debug ('=========== formulaItemList ' + formulaItemList );

				Double oneMinChurnValue = 0.8;	//-- todo: get from formula
				
				Double totalForecast = formulaObj.Total_Forecast__c;	//110000000;	
				Double totalLastMonth = formulaObj.Total_Last_Month__c;	//120000000;

				switch on  (this.month) {
					when '1', '4', '7', '10' {
						totalForecast = formulaObj.Total_Forecast_1__c;
						totalLastMonth = formulaObj.Total_Last_Month_1__c;
					}
					when '2', '5', '8', '11' {
						totalForecast = formulaObj.Total_Forecast_2__c;
						totalLastMonth = formulaObj.Total_Last_Month_2__c;
					}
					when '3', '6', '9', '12' {
						totalForecast = formulaObj.Total_Forecast_3__c;
						totalLastMonth = formulaObj.Total_Last_Month_3__c;
					}
				}


				if (formulaObj.churn__c <> null) {
					oneMinChurnValue = 1 - (formulaObj.churn__c/100);
				} else { oneMinChurnValue = 1; }


				
				
				Boolean isFirstItem = true;

				for (String formulaItem : formulaItemList ) {
					
					switch on formulaItem.trim() {
						when '[M-1]' {
							tmpValue = srvObj.Amount__c ;
						}
						when '[1-CHURN]' {
							tmpValue = oneMinChurnValue;
						}
						when '[#DAYS_M-1]' {
							tmpValue = daysMonthMinOne;
						}
						when '[#DAYS_M]' {
							tmpValue = daysThisMonth;
						}
						when '[TOTAL_FORECAST]' {
							tmpValue = totalForecast;
						}
						when '[TOTAL_LAST_MONTH]' {
							tmpValue = totalLastMonth;
						}

						//-- todo: include [M-2]
					} 
					
					
					if (isFirstItem) {
						lastAmount = tmpValue;
						isFirstItem = false;

						additonalInfo = additonalInfo + '::' + string.valueof (lastAmount);
					}

					

					system.debug ('=== tmpValue : ' + tmpValue);
					system.debug ('=== lastOperation : ' + lastOperation);

					switch on lastOperation.trim()  {
						when '+' {
							system.debug ('=== lastAmount + tmpValue ' + lastAmount + ' ' + tmpValue);
							lastAmount = lastAmount + tmpValue;
							additonalInfo = additonalInfo + '::' + string.valueof (lastAmount) + '+' + string.valueof (tmpValue);

						}
						when '-' {
							system.debug ('=== lastAmount - tmpValue ' + lastAmount + ' ' + tmpValue);
							lastAmount = lastAmount - tmpValue;
							additonalInfo = additonalInfo + '::' + string.valueof (lastAmount) + '-' + string.valueof (tmpValue);

						}
						when '*' {
							system.debug ('=== lastAmount * tmpValue ' + lastAmount + ' ' + tmpValue);
							lastAmount = lastAmount * tmpValue;
							additonalInfo = additonalInfo + '::' + string.valueof (lastAmount) + '*' + string.valueof (tmpValue);

						}
						when '/' {
							system.debug ('=== lastAmount / tmpValue ' + lastAmount + ' ' + tmpValue);
							if (tmpValue <> 0) {
								lastAmount = lastAmount / tmpValue;
								additonalInfo = additonalInfo + '::' + string.valueof (lastAmount) + '/' + string.valueof (tmpValue);

							}

						}
					}
					system.debug ('=== lastAmount in loop : ' + lastAmount);
					

					if (formulaItem.trim() == '+' || formulaItem.trim() == '-' || formulaItem.trim() == '*' || formulaItem.trim() == '/') {
						lastOperation = formulaItem;
					} else lastOperation = '';
				}
				//-- .endOf Calculate amount based on formula

				tmpSRVObj.formula_info__c = tmpSRVObj.formula_info__c + ' > ' +
					' RESULT : ' + string.valueof(lastAmount) + ' :: ' +
					' [M-1] : ' +  string.valueof(srvObj.Amount__c) + ' :: ' +
					' CHURN : ' + formulaObj.churn__c + ' :: ' +
					' [1-CHURN] : ' + oneMinChurnValue + ' :: ' +
					' [#DAYS_M-1] : ' + daysMonthMinOne + ' :: ' +
					' [#DAYS_M] : ' + daysThisMonth + ' :: ' +
					' [TOTAL_FORECAST] : ' +  string.valueof(totalForecast) + ' :: ' +
					' [TOTAL_LAST_MONTH] : ' +  string.valueof(totalLastMonth) + ' <<  '  +
					additonalInfo ;
				
				System.debug ('=========== tmpSRVObj.formula_info__c ' + tmpSRVObj.formula_info__c );





				//-- set Amount from formula calculation above
				system.debug ('=== lastAmount : ' + lastAmount);
				tmpSRVObj.Amount__c = lastAmount;


				//-- add Sales Revenue new data to list
				srvNewDataList.add (tmpSRVObj) ;

				counter++;
		
			}

			
		}

		system.debug ('=== srvNewDataList : ' + srvNewDataList);
		upsert srvNewDataList unique_id__c;
		
		
	}
	
	/**
	 * @description gets invoked when the batch job finishes. Place any clean up code in this method.
	 * @param context contains the job ID
	 */ 
	global void finish(Database.BatchableContext context) {
		system.debug ('==== in ForecastRevenueRecurring_Batch.finish ===');
		system.debug ('==== month : ' + month );
		system.debug ('==== year : ' + year );
		
		if (month <> '3' && month <> '6' && month <> '9' && month <> '12') {
			

			integer intMonth = integer.valueof (month) + 1;
			string nextMonth = string.valueOf(intMonth);
			system.debug ('==== ready to executeBatch. Month : ' + nextMonth + ' Year : ' + year );

			SalesRevenueController salesRevenueControllerOBJ = new SalesRevenueController();
			salesRevenueControllerOBJ.createForcesatRevenueRecurringByFormula(nextMonth, year);


			
 
			/*
			Datetime nextSchedule = system.now().addSeconds(30);
			system.debug ('============ nextSchedule :' + nextSchedule);
                                
			string sYear = string.valueof( nextSchedule.year() );
			string sMonth = string.valueof( nextSchedule.month() );
			string sDay = string.valueof( nextSchedule.day() ); 
			string sHour = string.valueof( nextSchedule.Hour() );
			string sMinute = string.valueof( nextSchedule.minute() );
			string sSecond = string.valueof( nextSchedule.second() );

			ForecastRevenueRecurring_Schedule forecastRevRecSCH = new ForecastRevenueRecurring_Schedule();
			forecastRevRecSCH.month = nextMonth;
			forecastRevRecSCH.year = year; 
			
			string sch = sSecond + ' ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
			
			system.debug ('============ sch :' + sch);
		
			string jobName = 'FCS Rev. Recurring Callculation. ' 
				+ 'Month : ' + nextMonth + ' Year : ' + year + '. ' + sch + ' '
			 	+ System.now()  + ' ' + Integer.valueof((Math.random() * 1000)) ;

			string jobID = system.schedule(jobName, sch, forecastRevRecSCH);
			system.debug ('============ jobID :' + jobID);

			*/
		}


		if (month == '3' || month == '6' || month == '9' || month == '12') {
			//-- send email to inform that process is completed
			AsyncApexJob asyncApexJobRecord = [Select Id, Status,ExtendedStatus,NumberOfErrors,     JobItemsProcessed,
												TotalJobItems, CreatedBy.Email
												from AsyncApexJob where Id =:context.getJobId()];
			
			Messaging.SingleEmailMessage mailObj = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {asyncApexJobRecord.CreatedBy.Email};
			mailObj.setToAddresses(toAddresses);
			mailObj.setSubject('Forecast Revenue Recurring Data Calculation Process (' + this.quarter + ' ' + this.year + ') ' + asyncApexJobRecord.Status);
			//mailObj.setPlainTextBody('records processed ' + asyncApexJobRecord.TotalJobItems + 'with '+ asyncApexJobRecord.NumberOfErrors + ' failures.');
			mailObj.setHtmlBody('Dear ' + UserInfo.getFirstName() + ', <br> <br>' +
									'The Forecast Revenue Recurring Data Calculation Process for 3 months is Completed. <br> <br> ' +
									'Below is detail the information. If any errors please contact your System Administrator. <br> ' +
									'Job processed : '+ asyncApexJobRecord.TotalJobItems + '<br> ' +
									'Batches with : '+ asyncApexJobRecord.NumberOfErrors + ' failures' + '<br> ' +
									'Job Item processed are : ' + asyncApexJobRecord.JobItemsProcessed
									);

			
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailObj });
		}
		
	}
}