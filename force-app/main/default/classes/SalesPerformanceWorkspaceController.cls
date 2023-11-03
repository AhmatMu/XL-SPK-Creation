/**
 * 
 *
 *
 *
 */
public class SalesPerformanceWorkspaceController  {
	public Sales_Performance_WorkSpace__c spwObj {get;set;}
	public SalesPerformancePageInfo pageInfoObj {get;set;}

	public Blob csvFileBody {get;set;}

	ApexPages.StandardController con;

	class SalesPerformancePageInfo {
		public string reveneuTargetInfo {get;set;}
		public string reveneuPartnershipTargetInfo {get;set;}
		
		public string newReveneuTargetInfo {get;set;}
		public string bauReveneuTargetInfo {get;set;}
		

		public string pipelineTargetInfo {get;set;}
		public string pipelinePOTargetInfo {get;set;}
		public string addLinkTargetInfo {get;set;}
		public string addSubscribeTargetInfo {get;set;}

		public string generateFormulaInfo {get;set;}
		
		public string fcsRevenueRecurringInfo {get;set;}
		public string fcsRevenuePipelineInfo {get;set;}
		public string fcsRevenuePendingRecurringInfo {get;set;}
		public string fcsWaivingInfo {get;set;}
		public string pipelineInfo {get;set;}
		public string pipelinePOInfo {get;set;}
		public string newRevenueInfo {get;set;}
		public string actualRevenueInfo {get;set;}

		public string linkGrossInfo {get;set;}
		public string linkChurnInfo {get;set;}
		
		public string subscribeGrossInfo {get;set;}
		public string subscribeChurnInfo {get;set;}
	}

	



	public void salesPerformanceWorkspaceController (Sales_Performance_WorkSpace__c spwObj) {
		this.spwObj = spwObj;
		System.debug ('========== this.spwObj : '  + this.spwObj);
	}


	public SalesPerformanceWorkspaceController (ApexPages.StandardController controller) {
		
		if (!Test.isRunningTest()) {
			controller.addFields(New List<String> {'year__c', 'quarter__c', 'Is_Formula_Generated__c', 'is_Formula_Locked__c'});
		}

		pageInfoObj = new SalesPerformancePageInfo(); 

		con = controller;
        spwObj = (Sales_Performance_WorkSpace__c) con.getRecord();
		
		//--test tanpa quesry : spwObj = [select id, year__c, quarter__c from Sales_Performance_WorkSpace__c WHERE id = :spwObj.id];
		System.debug ('========== this.spwObj : '  + this.spwObj);

		if (spwObj.Is_Formula_Generated__c) { pageInfoObj.generateFormulaInfo = 'Done..'; } else {pageInfoObj.generateFormulaInfo = 'Not Yet';}


    }

	public void init () {

		System.debug('=== spwObj.Quarter__c : ' + spwObj.Quarter__c);
		System.debug('=== spwObj.Year__c : ' + spwObj.Year__c);


		//-- 1. Show Summary Information
		showSummaryInformation(spwObj.Quarter__c, spwObj.Year__c);

		//-- 2. Set Related Data
		setRelatedData();



	}

	
	public void setAdjustmentFormulaStatus () {
		system.debug ('=== spwObj : ' + spwObj);
		system.debug ('=== spwObj.is_Formula_Locked__c : ' + spwObj.is_Formula_Locked__c);
		//spwObj.is_Formula_Locked__c = !spwObj.is_Formula_Locked__c; 
		update spwObj;
	}

	//@Future()
	public void showSummaryInformation (string quarter, string year) { 

		//-- 1. get target data information -------------------------------------------------------------
		List <AggregateResult> strInfoList = [ SELECT recordtype.name RTName, Group_Service__r.type__c type,
												COUNT_DISTINCT(am__c) AM_Count, 
												COUNT_DISTINCT(Revenue_Category__c) REV_CAT_Count,
												COUNT_DISTINCT(Group_Service__c) GR_SERV_Count,
												COUNT_DISTINCT(Segment__c) SEGMENT_Count
											FROM Sales_Target__c
											WHERE Quarter__c = :Quarter
												AND Year__c = :Year
											GROUP BY recordtype.name, Group_Service__r.type__c
		];

		System.debug ('=== strInfoList : ' + strInfoList);
		
		string info1 = 'NO DATA', info2;
		pageInfoObj.reveneuTargetInfo = info1;
		pageInfoObj.pipelineTargetInfo = info1;
		pageInfoObj.pipelinePOTargetInfo = info1;
		pageInfoObj.newReveneuTargetInfo = info1;
		pageInfoObj.addLinkTargetInfo = info1;
		pageInfoObj.addSubscribeTargetInfo = info1;

		integer revenueAMCount = 0, revenueSegmentCount = 0, revenueGSCount = 0; 
		integer bauRevenueAMCount = 0, bauRevenueSegmentCount = 0, bauRevenueGSCount = 0; 
		integer newRevenueAMCount = 0, newRevenueSegmentCount = 0, newRevenueGSCount = 0; 

		For (AggregateResult strInfo : strInfoList) {
			integer AMCount = 0;
			info1 = 'NO DATA';
			info2 = '';
			
			AMCount = (integer) strInfo.get ('AM_Count') ;
			if (AMCount > 0) {
				info1 = String.valueOf(AMCount) + ' Account Managers. ' +
					String.valueOf((integer) strInfo.get ('SEGMENT_Count')) + ' Segements. ' ;
				info2 =
					//String.valueOf((integer) strInfo.get ('REV_CAT_Count')) + ' Rev. Categories. ' +
					String.valueOf((integer) strInfo.get ('GR_SERV_Count')) + ' Group Services. ' ;
			} 
			else info1 = 'NO DATA';

			Switch on ((String) strInfo.get ('RTName')) {
				When 'Target Revenue' { 
					if ((String) strInfo.get ('Type') == 'New Revenue' ) {
						newRevenueAMCount = (integer) strInfo.get ('AM_Count');
						newRevenueSegmentCount = (integer) strInfo.get ('SEGMENT_Count');
						newRevenueGSCount =  (integer) strInfo.get ('GR_SERV_Count');

						pageInfoObj.newreveneuTargetInfo = info1 + info2; 
					}
					else if ((String) strInfo.get ('Type') == 'BAU' ) {
						bauRevenueAMCount = (integer) strInfo.get ('AM_Count');
						bauRevenueSegmentCount = (integer) strInfo.get ('SEGMENT_Count');
						bauRevenueGSCount =  (integer) strInfo.get ('GR_SERV_Count');
						pageInfoObj.baureveneuTargetInfo = info1 + info2; 
					}

					
				}
				When 'Target Pipeline' { pageInfoObj.pipelineTargetInfo = info1; }
				When 'Target Pipeline PO' { pageInfoObj.pipelinePOTargetInfo = info1; }
				
				When 'Target Add Link' { pageInfoObj.addLinkTargetInfo = info1; }
				When 'Target Add Subscribe' { pageInfoObj.addSubscribeTargetInfo = info1; }
			}
		}

		pageInfoObj.reveneuTargetInfo = string.valueof(newRevenueAMCount+bauRevenueAMCount) + ' Account Managers. ' +
			string.valueof(newRevenuesegmentCount+bauRevenueSegmentCount) + ' Segements. ' +
			string.valueof(newRevenueGSCount+bauRevenueGSCount) + ' Group Services. ' ;


		//-- 2. get revenue data information --------------------------------------------------------------------
		List <AggregateResult> srvInfoList = [ SELECT recordtype.name RTName,
												COUNT_DISTINCT(am__c) AM_Count, 
												COUNT_DISTINCT(Revenue_Category__c) REV_CAT_Count,
												COUNT_DISTINCT(Group_Service__c) GR_SERV_Count,
												COUNT_DISTINCT(Segment__c) SEGMENT_Count
											FROM Sales_Revenue__c
											WHERE Quarter__c = :Quarter
												AND Year__c = :Year
											GROUP BY recordtype.name
		];

		System.debug ('=== srvInfoList : ' + srvInfoList);
		
		info1 = 'NO DATA';

		pageInfoObj.fcsRevenueRecurringInfo = info1;
		pageInfoObj.fcsRevenuePipelineInfo = info1;
		pageInfoObj.fcsRevenuePendingRecurringInfo = info1;
		pageInfoObj.fcsWaivingInfo = info1;
		pageInfoObj.pipelineInfo = info1;
		pageInfoObj.pipelinePOInfo = info1;
		pageInfoObj.newRevenueInfo = info1;
		pageInfoObj.actualRevenueInfo = info1;

		pageInfoObj.linkGrossInfo = info1;
		pageInfoObj.linkChurnInfo = info1;
	
		pageInfoObj.subscribeGrossInfo = info1;
		pageInfoObj.subscribeChurnInfo = info1; 


		For (AggregateResult strInfo : strInfoList) {
			integer AMCount = 0;
			info1 = 'NO DATA';
			AMCount = (integer) strInfo.get ('AM_Count') ;
			if (AMCount > 0) {
				info1 = String.valueOf(AMCount) + ' Account Manager(s). ' +
					String.valueOf((integer) strInfo.get ('SEGMENT_Count')) + ' Segment(s). ' ;
				info2 =
					String.valueOf((integer) strInfo.get ('REV_CAT_Count')) + ' Rev. Categorie(s). ' +
					String.valueOf((integer) strInfo.get ('GR_SERV_Count')) + ' Group Service(s). ' ;
			} 
			else info1 = 'NO DATA';

			Switch on ((String) strInfo.get ('RTName')) {
				When 'Actual Revenue' { pageInfoObj.actualRevenueInfo = info1 + info2; }
				When 'Forecast Revenue Pending Recurring' { pageInfoObj.fcsRevenuePendingRecurringInfo = info1; }
				When 'Forecast Revenue Recurring' { pageInfoObj.fcsRevenueRecurringInfo = info1; }
				When 'Forecast Waiving' { pageInfoObj.fcsWaivingInfo = info1; }
				When 'Link Churn' { pageInfoObj.linkChurnInfo = info1; }
				When 'Link Gross' { pageInfoObj.linkGrossInfo = info1; }
				When 'Pipeline' { pageInfoObj.pipelineInfo = info1; }
				When 'Subscribe Churn' { pageInfoObj.subscribeChurnInfo = info1; }
				When 'Subscribe Gross' { pageInfoObj.subscribeGrossInfo = info1; }
			}
		}


	}

	public void setRelatedData () {
		string errorMsg = '';

		//-- 1. set Sales Performance
		List<Sales_Performance_Monthly_AMGS__c> sprList = [SELECT id 
												FROM Sales_Performance_Monthly_AMGS__c 
												WHERE Quarter__c = :spwObj.Quarter__c
													AND Year__c = :spwObj.Year__c
													AND Sales_Performance_WorkSpace__c = null
												];
		if (sprList.size() > 0) {
			for ( Sales_Performance_Monthly_AMGS__c sprObj : sprList ) {
				sprObj.Sales_Performance_WorkSpace__c = spwObj.Id;
			}
			try {
				update sprList;
			}
			catch (Exception e) {
				string notes = 'Error on SalesPerformanceWorkspaceController.setRelatedData method'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
				errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  spwObj.id; apputils.puterror(errorMsg);
				system.debug ('===== errorMsg : ' + errorMsg);
			}


		}
		

		//-- 2. set forecast formula
		errorMsg = '';
		List<Forecast_Recurring_Revenue_Formula__c>  formulaList = [SELECT id, Sales_Performance_WorkSpace__c 
													FROM Forecast_Recurring_Revenue_Formula__c 
													WHERE Quarter__c = :spwObj.Quarter__c
														AND Year__c = :spwObj.Year__c
														AND Sales_Performance_WorkSpace__c = null
														AND is_template__c = FALSE
														];

		system.debug('== formulaList :' + formulaList);

		if (sprList.size() > 0) {
			for ( Forecast_Recurring_Revenue_Formula__c formulaObj : formulaList ) {
				formulaObj.Sales_Performance_WorkSpace__c = spwObj.Id;
			}
			try {
				system.debug('== formulaList :' + formulaList);
				update formulaList;
			}
			catch (Exception e) {
				string notes = 'Error on SalesPerformanceWorkspaceController.setRelatedData method'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
				errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  spwObj.id; apputils.puterror(errorMsg);
				system.debug ('===== errorMsg : ' + errorMsg);
			}


		}

	}






	public void generateFormulaFromTemplate () {
		String relatedSFIDs;
		String errorMsg;

		if (spwObj.is_Formula_Locked__c == true ) { 
			ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 
												'The formula is locked, you can\'not replace from tempalate');
            ApexPages.addMessage(message);

			return ;
		} 

		string quarter = spwObj.quarter__c;
		string year = spwObj.year__c;

		List <Forecast_Recurring_Revenue_Formula__c> templateFormulaList =
						[SELECT id, year__c, quarter__c, revenue_category__c,
								Revenue_Category__r.name,
								specific_formula__c, churn__c, 
								total_forecast__c, total_last_month__c,
								Active__c 
							FROM Forecast_Recurring_Revenue_Formula__c
							WHERE Is_Template__c = TRUE
		];
		System.debug ('========== templateFormulaList : '  + templateFormulaList);

		try {  

			//-- delete first
			List <Forecast_Recurring_Revenue_Formula__c> existingFormulaList =
							[SELECT id
								FROM Forecast_Recurring_Revenue_Formula__c
								WHERE year__c = :year	
									AND Quarter__c = :quarter
									AND Is_Template__c = FALSE
			];
			System.debug ('========== existingFormulaList : '  + existingFormulaList);
			delete existingFormulaList;


			List <Forecast_Recurring_Revenue_Formula__c> newFormulaList =  new List <Forecast_Recurring_Revenue_Formula__c>();

			for (Forecast_Recurring_Revenue_Formula__c templateFormulaObj : templateFormulaList) {
				Forecast_Recurring_Revenue_Formula__c tmpFormulaObj = new Forecast_Recurring_Revenue_Formula__c();
				relatedSFIDs = relatedSFIDs + templateFormulaObj.id + ' ';

				tmpFormulaObj.Name = spwObj.Year__c + '_' + spwObj.Quarter__c + '_' + templateFormulaObj.Revenue_Category__r.name;
				tmpFormulaObj.Is_Template__c = false;
				tmpFormulaObj.Sales_Performance_WorkSpace__c = spwObj.Id;
				tmpFormulaObj.Year__c = year;
				tmpFormulaObj.Quarter__c = quarter;
				tmpFormulaObj.Revenue_Category__c = templateFormulaObj.Revenue_Category__c;
				tmpFormulaObj.Specific_Formula__c = templateFormulaObj.Specific_Formula__c;
				tmpFormulaObj.active__c = templateFormulaObj.active__c;




				newFormulaList.add(tmpFormulaObj);
			}

			insert newFormulaList;

			spwObj.Is_Formula_Generated__c = true;
			update spwObj;

		}
		catch (Exception e) {
            string notes = 'Error on SalesPerformanceWorkspaceController.generateFormulaFromTemplate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
		}


		
	}

	public void generateRevenueRecurring () {
		
		integer startMonth ;
		integer endMonth;
		Switch on ( spwObj.quarter__c ) {
			when 'Q1' {
				startMonth = 1;
			}
			when 'Q2' {
				startMonth = 4;
			}
			when 'Q3' {
				startMonth = 7;
			}
			when 'Q4' {
				startMonth = 10;
			}
		}
		endMonth = startMonth + 0;

		
		SalesRevenueController srvController = new SalesRevenueController();
		srvController.createForcesatRevenueRecurringByFormula (string.valueof(startMonth), string.valueof(spwObj.year__c));


	}


}