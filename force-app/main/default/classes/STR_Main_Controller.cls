public with sharing class STR_Main_Controller {
    
    /* 
    	SEND TO SALES
    	SUBMIT TO ORM
    	
    	paramDT <> null : for specific date (ex. today)
    	paramDT = null  : related to STS and STO date (ex. bulk update pending recurring only the STS and STO date)
    	
    	dataToSet = End of Quarter of STS or STO date 
    	
    	TODO : handling for paramDT = null 
     */
    
    public boolean calculationPendingRecurring_STS_STO (List<ID> paramPRIDs, date paramDT) {
		Boolean ret=false;
		
		String forecastRTID = System.Label.Forecast;
		String forecastDetailRTID = System.Label.Forecast_Detail;
		integer tempMonth;
		integer tempYear;
		
		
		//Date dt = Date.newInstance(2019, 10, 1);
		Date dt = null;
		Date dateToSet = null;
		
		//Integer quarterEndMonth = (((Math.ceil((Decimal.valueOf(dt.month()) / 12) * 4))*3)).intValue(); //rumus get end of current quarter
	    //Date monthToSetdt = Date.newInstance(dt.year(), quarterEndMonth , 1); //--- end of quarter
		//Date dateToSet = Date.newInstance(dt.year(), quarterEndMonth , 1); //--- end of quarter
		
	    //-- get owner NIK
	    Pending_Recurring__c[] ownerList = [SELECT  
											Ownerid , 
											Owner_Employee_ID__c
										FROM Pending_Recurring__c 
										WHERE 
											status__c in ('Send to Sales', 'Submit to ORM') AND
											id in :paramPRIDs
											];
										
		Map <id, string> ownerMap = new Map <id, string>();
		for (Pending_Recurring__c own : ownerList) {
			ownerMap.put(own.Ownerid, own.Owner_Employee_ID__c );
		}									
	
		ownerMap.put(system.label.User_ID_System_Administrator, system.label.NIK_System_Administrator);
	
		//-- group by Sales and Product Family
		AggregateResult[] prGroups = null;
		
		if (paramDT == null ) {
					/* TODO :
					prGroups =	[SELECT Owner.Name prOwnerName, 
											Ownerid prOwnerID, 
											Owner.isactive prOwnerStatus,
											Search_Link__r.Contract_Item_Rel__r.Product__r.Family prProductFamily,
											sum(Amount__c) amount 
										FROM Pending_Recurring__c 
										WHERE 
											status__c in ('Send to Sales', 'Submit to ORM') AND
											id in :paramPRIDs
										group by Owner.Name, Ownerid, Owner.isactive, 
											Search_Link__r.Contract_Item_Rel__r.Product__r.Family
	                                   		];
	                 */
	
		} else {
					prGroups =	[SELECT Owner.Name prOwnerName, 
											Ownerid prOwnerID, 
											Owner.isactive prOwnerStatus,
											Search_Link__r.Contract_Item_Rel__r.Product__r.Family prProductFamily,
											sum(Amount__c) amount 
										FROM Pending_Recurring__c 
										WHERE 
											status__c in ('Send to Sales', 'Submit to ORM') AND
											id in :paramPRIDs
										group by Owner.Name, Ownerid, Owner.isactive, 
											Search_Link__r.Contract_Item_Rel__r.Product__r.Family
	                                   		];
			
		}
		Sales_Target_and_Revenue__c str = new Sales_Target_and_Revenue__c();
		List<Sales_Target_and_Revenue__c> strList = new List<Sales_Target_and_Revenue__c>();
	
		system.debug(' === ownerMap : '+ ownerMap);
		for (AggregateResult prGroup : prGroups ){
			str = new Sales_Target_and_Revenue__c();
	
			String ownerID = null;
	
			boolean prOwnerStatus = (boolean) prGroup.get('prOwnerStatus');
			string prOwnerName = (string) prGroup.get('prOwnerName');
			system.debug ('=== prOwnerName : ' + prOwnerName);
			system.debug ('=== prOwnerStatus : ' + prOwnerStatus);
	
			if (prOwnerStatus) {
				ownerID = (string) prGroup.get('prOwnerID');
			} else if (prOwnerStatus == false) {
				ownerID = system.label.User_ID_System_Administrator;
			}
			system.debug ('=== ownerID : ' + ownerID);
			
			string productFamily = (string) prGroup.get('prProductFamily');
			
			if (paramDT <> null ) {
				dt = paramDT;
			} else {
				dt = paramDT;
				/* TODO : handle for ..
				tempMonth = (integer) oppGroup.get('mm');
				tempYear = (integer) oppGroup.get('yy');
				dt = date.newinstance(tempYear,tempMonth,1 );
				*/
			}
			
			
			Integer quarterEndMonth = (((Math.ceil((Decimal.valueOf(dt.month()) / 12) * 4))*3)).intValue(); //rumus get end of current quarter
			dateToSet = Date.newInstance(dt.year(), quarterEndMonth , 1); //--- end of quarter
			tempMonth = dateToSet.Month();
			tempYear = dateToSet.year();
				
		    str.RecordTypeId = forecastRTID;
		    str.Type__c = 'Forecast';
		    str.User__c = ownerID;
		    str.AM__c = ownerID;
		    str.NIK__c = ownerMap.get(ownerID);
		    str.Product_Family__c = productFamily;
		    str.Date__c = dateToSet;
		    str.Unique_ID__c = str.NIK__c+'-Forecast-'+str.Product_Family__c+'-'+tempMonth+'-'+tempYear;  
	
		    system.debug ('=== str.NIK__c : ' + str.NIK__c);
	
		    strList.add (str);
		}
		system.debug('==== strList : ' + strList);
	
	
		List<string> prIds = new List<string> ();
		try {
			upsert strList Unique_ID__c; 
	
			Map <String, ID> strUniqueIDMap = new Map <String, ID>();
			for (Sales_Target_and_Revenue__c tmpStr : strList) {
				strUniqueIDMap.put(tmpStr.Unique_ID__c, tmpStr.ID);
			}
	
			Pending_Recurring__c[] prList = [SELECT 
												id, 
												Owner.Name , 
												Ownerid , 
												Owner.isactive ,
												Owner_Employee_ID__c,
												Search_Link__r.Parent_Name__c, 
												Owner_NIK__c,	
												Search_Link__r.Contract_Item_Rel__r.Product__r.Family ,
												Search_Link__r.Contract_Item_Rel__r.Product__r.ProductCode,
												Status__c, 
												search_link__r.Parent_BP_Number__c,
												Search_link__r.HO_ID__c,	
												Total_Revenue__c
											FROM Pending_Recurring__c 
											WHERE 
												status__c in ('Send to Sales', 'Submit to ORM') AND
											id in :paramPRIDs];
	
			Sales_Target_and_Revenue_Detail__c strd = new Sales_Target_and_Revenue_Detail__c();
			List<Sales_Target_and_Revenue_Detail__c> strdList = new List<Sales_Target_and_Revenue_Detail__c>();
	
			
			
			for (Pending_Recurring__c pr : prList) {
				strd = new Sales_Target_and_Revenue_Detail__c();
				strd.am__c  = pr.Ownerid;
				strd.Amount__c = pr.Total_Revenue__c;
				strd.Invoicing_Company__c = pr.Search_link__r.HO_ID__c; //pr.Search_Link__r.Parent_Name__c;
				
				String ownerID = null;
	
				boolean prOwnerStatus = pr.Owner.isactive;
				if (prOwnerStatus) {
					ownerID = pr.Ownerid;
				} else if (prOwnerStatus == false) {
					ownerID = system.label.User_ID_System_Administrator;
				}
				system.debug ('=== ownerID : ' + ownerID);
	
				strd.NIK__c = ownerMap.get(ownerID);
	
				strd.Product_code__c = pr.Search_Link__r.Contract_Item_Rel__r.Product__r.ProductCode;
				strd.Product_Family__c = pr.Search_Link__r.Contract_Item_Rel__r.Product__r.Family;
				strd.Type__c = 'Forecast';
				
				
				if (paramDT <> null ) {
					dt = paramDT;
				} else {
					dt = paramDT;
					/* TODO : handle for ..
					tempMonth = (integer) oppGroup.get('mm');
					tempYear = (integer) oppGroup.get('yy');
					dt = date.newinstance(tempYear,tempMonth,1 );
					*/
				}
				Integer quarterEndMonth = (((Math.ceil((Decimal.valueOf(dt.month()) / 12) * 4))*3)).intValue(); //rumus get end of current quarter
				dateToSet = Date.newInstance(dt.year(), quarterEndMonth , 1); //--- end of quarter
				tempMonth = dateToSet.Month();
				tempYear = dateToSet.year();
				strd.Date__c = dateToSet;
				
				string uniqueID = strd.NIK__c+'-Forecast-'+strd.Product_Family__c+'-'+tempMonth+'-'+tempYear;  
	
				system.debug ('=== cek uniqueID : ' + uniqueID);
	            system.debug ('=== str id : ' + strUniqueIDMap.get(uniqueID));
	            strd.Sales_Target_and_Revenue__c = strUniqueIDMap.get(uniqueID);
				strd.RecordTypeId = forecastDetailRTID; 
				strd.Pending_Recurring__c = pr.id;
				strd.Forecast_Type__c = 'Pending Recurring';
				strd.Pending_Recurring_Status__c = pr.Status__c;
				strd.Unique_ID__c = pr.id;
	
				system.debug ('=== strd : ' + strd);
				strdList.add (strd);
	
				prIds.add( pr.id);
	        }
	
	        //-- delete first
			Sales_Target_and_Revenue_Detail__c[] tmpstrdList= [select id 
																	from Sales_Target_and_Revenue_Detail__c 
																	where Unique_ID__c in :prIds ];
			delete tmpstrdList;
	
	
	        system.debug ('=== strdList : ' + strdList);
			upsert strdList Unique_ID__c;
			
			ret = true;
	
	    } catch (system.Dmlexception e) {
	        system.debug (e);
	        string errMessage = 'Error on create STRD Pending Recurring - Send to Sales, Submit to ORM. Record IDs : ' + prIds + '.::' + e.getmessage() + '::' + e.getLineNumber() ;
	        system.debug('==================== error message : ' + errMessage);
	        AppUtils.putError(errMessage );
	        ret = false;
	    }
	    
	    return ret;
    }
    

    /*
    	SENT TO FINANCE

    	paramDT <> null : for specific date (ex. today)
    	paramDT = null  : related to STF date (ex. bulk update pending recurring only the STF date)

		dataToSet = STF date + 1 month 
     */
    public boolean calculationPendingRecurring_STF (List<ID> paramPRIDs, date paramDT) {
		String forecastRTID = System.Label.Forecast;
		String forecastDetailRTID = System.Label.Forecast_Detail;
		integer tempMonth;
		integer tempYear;
		boolean ret=false;
		
		Date sendToFinanceDate = null;
		Date dt = null;
		Date dateToSet = null;
		
		//Date dt = Date.newInstance(2019, 10, 1);
		//Date nextMonthdt = dt.addMonths(1);
	    //Integer quarterEndMonth = (((Math.ceil((Decimal.valueOf(dt.month()) / 12) * 4))*3)).intValue(); //rumus get end of current quarter
	    //Date monthToSetdt = Date.newInstance(dt.year(), quarterEndMonth , 1); //--- end of quarter
	
	
	    //-- get owner NIK
	    Pending_Recurring__c[] ownerList = [SELECT  
											Ownerid , 
											Owner_Employee_ID__c
										FROM Pending_Recurring__c 
										WHERE 
											status__c in ('Sent to Finance') AND
											id in :paramPRIDs];
										
		
		Map <id, string> ownerMap = new Map <id, string>();
		for (Pending_Recurring__c own : ownerList) {
			ownerMap.put(own.Ownerid, own.Owner_Employee_ID__c );
		}									
	
		ownerMap.put(system.label.User_ID_System_Administrator, system.label.NIK_System_Administrator);
	
		//-- group by Sales and Product Family
		AggregateResult[] prGroups = null;
		
		if (paramDT == null ) {
			prGroups = [SELECT Owner.Name prOwnerName, 
											Ownerid prOwnerID, 
											Owner.isactive prOwnerStatus,
											Search_Link__r.Contract_Item_Rel__r.Product__r.Family prProductFamily,
											CALENDAR_MONTH(send_to_finance_date__c) mm,
											CALENDAR_Year(send_to_finance_date__c) yy,
											sum(Amount__c) amount
										FROM Pending_Recurring__c 
										WHERE 
											status__c in ('Sent to Finance') AND
											id in :paramPRIDs
										group by Owner.Name, Ownerid, Owner.isactive, 
											Search_Link__r.Contract_Item_Rel__r.Product__r.Family,
											CALENDAR_MONTH(send_to_finance_date__c),
											CALENDAR_Year(send_to_finance_date__c)
	                                   		];
	
		} else {
			prGroups = [SELECT Owner.Name prOwnerName, 
											Ownerid prOwnerID, 
											Owner.isactive prOwnerStatus,
											Search_Link__r.Contract_Item_Rel__r.Product__r.Family prProductFamily,
											sum(Amount__c) amount
										FROM Pending_Recurring__c 
										WHERE 
											status__c in ('Sent to Finance') AND
											id in :paramPRIDs
										group by Owner.Name, Ownerid, Owner.isactive, 
											Search_Link__r.Contract_Item_Rel__r.Product__r.Family
	                                   		];
		}
		
		
		Sales_Target_and_Revenue__c str = new Sales_Target_and_Revenue__c();
		List<Sales_Target_and_Revenue__c> strList = new List<Sales_Target_and_Revenue__c>();
	
		system.debug(' === ownerMap : '+ ownerMap);
		for (AggregateResult prGroup : prGroups ){
			str = new Sales_Target_and_Revenue__c();
	
			String ownerID = null;
	
			boolean prOwnerStatus = (boolean) prGroup.get('prOwnerStatus');
			string prOwnerName = (string) prGroup.get('prOwnerName');
			system.debug ('=== prOwnerName : ' + prOwnerName);
			system.debug ('=== prOwnerStatus : ' + prOwnerStatus);
	
			if (prOwnerStatus) {
				ownerID = (string) prGroup.get('prOwnerID');
			} else if (prOwnerStatus == false) {
				ownerID = system.label.User_ID_System_Administrator;
			}
			system.debug ('=== ownerID : ' + ownerID);
			
			string productFamily = (string) prGroup.get('prProductFamily');	
			
			if (paramDT <> null ) {
				dt = paramDT;
			} else {
				tempMonth = (integer) prGroup.get('mm');
				tempYear = (integer) prGroup.get('yy');
				dt = date.newinstance(tempYear,tempMonth,1 );
			}
			dateToSet = dt.addMonths(1);
			tempMonth = dateToSet.Month();
			tempYear = dateToSet.year();
	
		    str.RecordTypeId = forecastRTID;
		    str.Type__c = 'Forecast';
		    str.User__c = ownerID;
		    str.AM__c = ownerID;
		    //str.NIK__c = (string) prGroup.get('Owner_Employee_ID__c');
		    str.NIK__c = ownerMap.get(ownerID);
		    str.Product_Family__c = productFamily; 
		    str.Date__c = dateToSet; 
	
		    string uniqueID = str.NIK__c+'-Forecast-'+str.Product_Family__c+'-'+ tempMonth +'-'+ tempYear;  
		    str.Unique_ID__c = uniqueID;
		    system.debug ('=== uniqueID : ' + uniqueID);
		    system.debug ('=== str.NIK__c : ' + str.NIK__c);
	
		    strList.add (str);
		}
		system.debug('==== strList : ' + strList);
	
	
		List<string> prIds = new List<string> ();
		try {
			upsert strList Unique_ID__c; 
	
			Map <String, ID> strUniqueIDMap = new Map <String, ID>();
			for (Sales_Target_and_Revenue__c tmpStr : strList) {
				strUniqueIDMap.put(tmpStr.Unique_ID__c, tmpStr.ID);
			}
	
			Pending_Recurring__c[] prList = [SELECT 
												id, 
												Owner.Name , 
												Ownerid , 
												Owner.isactive ,
												Owner_Employee_ID__c,
												Search_Link__r.Parent_Name__c, 
												Owner_NIK__c,	
												Search_Link__r.Contract_Item_Rel__r.Product__r.Family ,
												Search_Link__r.Contract_Item_Rel__r.Product__r.ProductCode,
												Status__c, 
												search_link__r.Parent_BP_Number__c,
												Search_link__r.HO_ID__c,
												send_to_finance_date__c,	
												Total_Revenue__c
											FROM Pending_Recurring__c 
											WHERE 
												status__c in ('Sent to Finance') AND
												id in :paramPRIDs];
	
			Sales_Target_and_Revenue_Detail__c strd = new Sales_Target_and_Revenue_Detail__c();
			List<Sales_Target_and_Revenue_Detail__c> strdList = new List<Sales_Target_and_Revenue_Detail__c>();
	
			for (Pending_Recurring__c pr : prList) {
				strd = new Sales_Target_and_Revenue_Detail__c();
				strd.am__c  = pr.Ownerid;
				strd.Amount__c = pr.Total_Revenue__c;
				strd.Invoicing_Company__c = pr.Search_link__r.HO_ID__c; //pr.Search_Link__r.Parent_Name__c;
				
				String ownerID = null;
	
				boolean prOwnerStatus = pr.Owner.isactive;
				if (prOwnerStatus) {
					ownerID = pr.Ownerid;
				} else if (prOwnerStatus == false) {
					ownerID = system.label.User_ID_System_Administrator;
				}
				system.debug ('=== ownerID : ' + ownerID);
	
				strd.NIK__c = ownerMap.get(ownerID);
	
				strd.Product_code__c = pr.Search_Link__r.Contract_Item_Rel__r.Product__r.ProductCode;
				strd.Product_Family__c = pr.Search_Link__r.Contract_Item_Rel__r.Product__r.Family;
				strd.Type__c = 'Forecast';
	
				if (paramDT <> null ) {
					dt = paramDT;
				} else {
					dt = pr.send_to_finance_date__c;
				} 
				
				dateToSet = dt.addMonths(1); // add (+) 1 month
				strd.Date__c = dateToSet;
				tempMonth = dateToSet.month();
				tempYear = dateToSet.year();
				string uniqueID = strd.NIK__c+'-Forecast-'+strd.Product_Family__c+'-'+tempMonth+'-'+tempYear;  
	
				system.debug ('=== cek uniqueID : ' + uniqueID);
	            system.debug ('=== str id : ' + strUniqueIDMap.get(uniqueID));
	            strd.Sales_Target_and_Revenue__c = strUniqueIDMap.get(uniqueID);
				strd.RecordTypeId = forecastDetailRTID; 
	
				strd.Pending_Recurring__c = pr.id;
				strd.Forecast_Type__c = 'Pending Recurring';
				strd.Pending_Recurring_Status__c = pr.Status__c;
				strd.Unique_ID__c = pr.id;
	
				system.debug ('=== strd : ' + strd);
				strdList.add (strd);
	
				prIds.add( pr.id);
	        }
	
	        //-- delete first
			Sales_Target_and_Revenue_Detail__c[] tmpstrdList= [select id 
																	from Sales_Target_and_Revenue_Detail__c 
																	where Unique_ID__c in :prIds ];
			delete tmpstrdList;
	
	
	        system.debug ('=== strdList : ' + strdList);
			upsert strdList Unique_ID__c;
	
	    } catch (system.Dmlexception e) {
	        system.debug (e);
	        string errMessage = 'Error on create STRD Pending Recurring - Sent to Finance. Record IDs : ' + prIds + '.::' + e.getmessage() + '::' + e.getLineNumber() ;
	        system.debug('==================== error message : ' + errMessage);
	        AppUtils.putError(errMessage );
	    }
    	
    	return ret;
    }



    /*
    	OPPORTUNITY - WBA WFC

    	paramDT <> null : for specific date (ex. today)
    	paramDT = null  : related to target closed date (ex. bulk update pending recurring only the target closed date)

		dataToSet = Target Closed Date + 1 month 
     */
    public boolean calculationOpportunity_WBA_WFC (List<ID> paramOppIDs, date paramDT) {

		String forecastRTID = System.Label.Forecast;
		String forecastDetailRTID = System.Label.Forecast_Detail;
		integer tempMonth;
		integer tempYear;
		boolean ret=false;
		
		
		//Date dt = Date.newInstance(2019, 10, 1);
		Date dt = null;
		Date dateToSet = null;

	    //-- get owner NIK
	    /*
	    opportunity[] ownerList = [SELECT  
											Ownerid , 
											owner.Employee_ID__c
										FROM opportunity
										WHERE stagename in ('Closed Won')
											and service_type__c <> 'Simcard Order'
											AND id in :paramOppIDs
											//and Actual_Closed_Date__c>= 2019-10-01
											];

		Map <id, string> ownerMap = new Map <id, string>();
		for (Opportunity own : ownerList) {
			ownerMap.put(own.Ownerid, own.Owner.Employee_ID__c );
		}										
		ownerMap.put(system.label.User_ID_System_Administrator, system.label.NIK_System_Administrator); */
											
		//-- group by Sales and Product Family
		AggregateResult[] oppGroups = null;
		
		if (paramDT == null) {
			
			oppGroups = [select 
	                                   		opportunity.owner.name oppOwnerName, 
	                                   		opportunity.ownerid oppOwnerID, 
	                                   		opportunity.owner.isactive oppOwnerStatus, 
	                                   		opportunity.owner.Employee_ID__c oppOwnerNIK,
											Product2.Family oppProductFamily, 
											CALENDAR_MONTH(opportunity.CloseDate) mm,
											CALENDAR_Year(opportunity.CloseDate) yy,
	                                   		sum (TotalPrice)
										from opportunitylineitem 
										where opportunity.stagename in ('Waiting for BA', 'Waiting for Contract')
											and opportunity.service_type__c <> 'Simcard Order' 
											and opportunity.id in :paramOppIDs
										group by opportunity.owner.name,
	                                   		opportunity.ownerid, 
	                                   		opportunity.owner.isactive,
	                                   		opportunity.owner.Employee_ID__c,
	                                   		Product2.Family,
	                                   		CALENDAR_MONTH(opportunity.CloseDate),
											CALENDAR_Year(opportunity.CloseDate)
	                                   		];
		} else {
			oppGroups = [select 
	                                   		opportunity.owner.name oppOwnerName, 
	                                   		opportunity.ownerid oppOwnerID, 
	                                   		opportunity.owner.isactive oppOwnerStatus, 
	                                   		opportunity.owner.Employee_ID__c oppOwnerNIK,
											Product2.Family oppProductFamily, 
	                                   		sum (TotalPrice)
										from opportunitylineitem 
										where opportunity.stagename in ('Waiting for BA', 'Waiting for Contract')
											and opportunity.service_type__c <> 'Simcard Order' 
											and opportunity.id in :paramOppIDs
										group by opportunity.owner.name,
	                                   		opportunity.ownerid, 
	                                   		opportunity.owner.isactive,
	                                   		opportunity.owner.Employee_ID__c,
	                                   		Product2.Family
	                                   		];
		}
	
	
		Sales_Target_and_Revenue__c str = new Sales_Target_and_Revenue__c();
		List<Sales_Target_and_Revenue__c> strList = new List<Sales_Target_and_Revenue__c>();
	
		for (AggregateResult oppGroup : oppGroups ){
			str = new Sales_Target_and_Revenue__c();
			String ownerID = null;
	
			boolean oppOwnerStatus = (boolean) oppGroup.get('oppOwnerStatus');
			string oppOwnerName = (string) oppGroup.get('oppOwnerName');
			system.debug ('=== oppOwnerName : ' + oppOwnerName);
			system.debug ('=== oppOwnerStatus : ' + oppOwnerStatus);
			
			string NIK = '';
			if (oppOwnerStatus) {
				ownerID = (string) oppGroup.get('oppOwnerID');
				NIK = (string) oppGroup.get('oppOwnerNIK');
			} else if (oppOwnerStatus == false) {
				ownerID = system.label.User_ID_System_Administrator;
				NIK = system.label.NIK_System_Administrator;
			}
			system.debug ('=== ownerID : ' + ownerID);
	
			//string NIK = (string) oppGroup.get('oppNIK');
			string productFamily = (string) oppGroup.get('oppProductFamily');
			//string opportunityId = (string) oppGroup.get('oppID');
	
			if (paramDT <> null ) {
				dt = paramDT;
			} else {
				tempMonth = (integer) oppGroup.get('mm');
				tempYear = (integer) oppGroup.get('yy');
				dt = date.newinstance(tempYear,tempMonth,1 );				
			}
			dateToSet = dt.addMonths(1);
			tempMonth = dateToSet.Month();
			tempYear = dateToSet.year();
				
		    str.RecordTypeId = forecastRTID;
		    str.Type__c = 'Forecast';
		    str.User__c = ownerID;
		    str.AM__c = ownerID;
		    str.NIK__c = NIK;
		    str.Product_Family__c = productFamily;
		    str.Date__c = dateToSet;
		    str.Unique_ID__c = str.NIK__c+'-Forecast-'+str.Product_Family__c+'-'+tempMonth+'-'+tempYear;  
		    system.debug('==== str.Unique_ID__c : ' + str.Unique_ID__c);
	
		    strList.add (str);
		}
		system.debug('==== strList : ' + strList);
	 	
	 	try {
			upsert strList Unique_ID__c; 
	
			Map <String, ID> strUniqueIDMap = new Map <String, ID>();
			for (Sales_Target_and_Revenue__c tmpStr : strList) {
				strUniqueIDMap.put(tmpStr.Unique_ID__c, tmpStr.ID);
			}
	
			//-- group by opportunityID
			AggregateResult[] oppLIGroup = [select id, opportunity.id oppID, opportunity.ownerid oppOwnerID, 
												opportunity.owner.isactive oppOwnerStatus,
	                                        	opportunity.owner.name own, 
	                                        	opportunity.owner.Employee_ID__c oppOwnerNIK,
										Product2.Family oppProductFamily, Product2.ProductCode oppProductCode, 
	                                        opportunity.Accountid oppAccountID, 
										opportunity.stageName oppStageName,
										opportunity.closedate targetCloseDate,
										sum (TotalPrice) Amount
									from opportunitylineitem 
									where opportunity.stagename in ('Waiting for BA', 'Waiting for Contract')
										and opportunity.service_type__c <> 'Simcard Order'
										and opportunity.id in :paramOppIDs
									group by id, opportunity.id, opportunity.ownerid, opportunity.owner.isactive, opportunity.owner.name, opportunity.owner.Employee_ID__c, 
										Product2.Family, Product2.ProductCode, opportunity.Accountid, opportunity.stageName,
										opportunity.closedate ];
	
			Sales_Target_and_Revenue_Detail__c strd = new Sales_Target_and_Revenue_Detail__c();
			List<Sales_Target_and_Revenue_Detail__c> strdList = new List<Sales_Target_and_Revenue_Detail__c>();
	
			List<string> opIds = new List<string> ();
	
			for (AggregateResult opp : oppLIGroup) {
				strd = new Sales_Target_and_Revenue_Detail__c();
				strd.am__c  = (string) opp.get('oppOwnerID');
				strd.Amount__c = (double) opp.get('Amount');
				strd.Invoicing_Company__c =(string)  opp.get('oppAccountID');
				 
				
				strd.Product_code__c = (string)  opp.get('oppProductCode');
				strd.Product_Family__c = (string)  opp.get('oppProductFamily');
				strd.Type__c = 'Forecast';
				
				string NIK='';
				string ownerID = null;
				boolean oppOwnerStatus = (boolean) opp.get('oppOwnerStatus');
				if (oppOwnerStatus) {
					ownerID = (string) opp.get('oppOwnerID');
					NIK = (string) opp.get('oppOwnerNIK');
				} else if (oppOwnerStatus == false) {
					ownerID = system.label.User_ID_System_Administrator;
					NIK = system.label.NIK_System_Administrator;
				}
				strd.NIK__c= NIK;
				
				if (paramDT <> null ) {
					dt = paramDT;
				} else {
					dt = (date) opp.get('targetCloseDate');
				}
				dateToSet = dt.addMonths(1);
				tempMonth = dateToSet.month();
				tempYear = dateToSet.year();
	
				string uniqueID = strd.NIK__c+'-Forecast-'+strd.Product_Family__c+'-'+tempMonth+'-'+tempYear;  
				ID tmpID = strUniqueIDMap.get(uniqueID);
				if (tmpID == null) system.debug ('=== STR record is not found. uniqueID : ' + uniqueID + ' - '); 
				strd.Sales_Target_and_Revenue__c = tmpID;
				strd.RecordTypeId = forecastDetailRTID; 
				
				strd.Date__c = dateToSet;
				strd.Opportunity__c = (string) opp.get('oppID');
				strd.Forecast_Type__c = 'Pipeline';
				strd.Opportunity_Status__c = (string) opp.get('oppStageName');
				strd.Unique_ID__c = (string) opp.get('oppID') + '-' + (string) opp.get('id');
	
				system.debug ('=== strd : ' + strd);
				strdList.add (strd);
	
				opIds.add(strd.Unique_ID__c );
	        }
	
	        //-- delete first
			Sales_Target_and_Revenue_Detail__c[] tmpstrdList= [select id 
																	from Sales_Target_and_Revenue_Detail__c 
																	where Unique_ID__c in :opIds ];
			delete tmpstrdList;
	
	
	        system.debug ('=== strdList : ' + strdList);
			upsert strdList Unique_ID__c;
			ret=true;
	
	    } catch (system.Dmlexception e) {
	        system.debug (e);
	        string errMessage = 'Error on create STRD Opportunity - WBA WFC. Record IDs : ' + paramOppIDs + '::' + e.getmessage() + '::' + e.getLineNumber() ;
	        system.debug('==================== error message : ' + errMessage);
	        AppUtils.putError(errMessage );
	        ret=false;
	    }
	    return ret;
	}
	
	
    /*
    	OPPORTUNITY - CLOSED WON

    	paramDT <> null : for specific date (ex. today)
    	paramDT = null  : related to target closed date (ex. bulk update pending recurring only the target closed date)

		dataToSet = Target Closed Date + 1 month 
     */
    public boolean calculationOpportunity_ClosedWon (List<ID> paramOppIDs, date paramDT) {
    	boolean ret = false;

		String forecastRTID = System.Label.Forecast;
		String forecastDetailRTID = System.Label.Forecast_Detail;
		integer tempMonth;
		integer tempYear;
		
		//Date dt = Date.newInstance(2019, 10, 1);
		//Date monthToSetdt = dt;
		
		Date dt = null;
		Date dateToSet = null;
	
	    //-- get owner NIK
	    /*
	    opportunity[] ownerList = [SELECT  
											Ownerid , 
											owner.Employee_ID__c
										FROM opportunity
										WHERE stagename in ('Closed Won')
											and service_type__c <> 'Simcard Order'
											AND id in :paramOppIDs
											//and Actual_Closed_Date__c>= 2019-10-01
											];
		Map <id, string> ownerMap = new Map <id, string>();
		for (Opportunity own : ownerList) {
			ownerMap.put(own.Ownerid, own.Owner.Employee_ID__c );
		}										
		ownerMap.put(system.label.User_ID_System_Administrator, system.label.NIK_System_Administrator);
		*/
	
		//-- group by Sales and Product Family
		AggregateResult[] oppGroups = null;
		if (paramDT == null) {
				oppGroups = [select 
	                                   		opportunity.owner.name oppOwnerName, 
	                                   		opportunity.ownerid oppOwnerID, 
	                                   		opportunity.owner.isactive oppOwnerStatus, 
	                                   		opportunity.owner.Employee_ID__c oppOwnerNIK,
											Product2.Family oppProductFamily, 
											CALENDAR_MONTH(opportunity.Actual_Closed_Date__c) mm,
											CALENDAR_Year(opportunity.Actual_Closed_Date__c) yy,
	                                   		sum (TotalPrice)
										from opportunitylineitem 
										where opportunity.stagename in ('Closed Won')
											and opportunity.service_type__c <> 'Simcard Order'
											AND opportunity.id in :paramOppIDs
											//and opportunity.Actual_Closed_Date__c>= 2019-10-01
										group by opportunity.owner.name,
	                                   		opportunity.ownerid, 
	                                   		opportunity.owner.isactive,
	                                   		opportunity.owner.Employee_ID__c,
	                                   		Product2.Family,
	                                   		CALENDAR_MONTH(opportunity.Actual_Closed_Date__c),
											CALENDAR_Year(opportunity.Actual_Closed_Date__c) 
	                                   		];
    	} else {
    			oppGroups = [select 
	                                   		opportunity.owner.name oppOwnerName, 
	                                   		opportunity.ownerid oppOwnerID, 
	                                   		opportunity.owner.isactive oppOwnerStatus, 
	                                   		opportunity.owner.Employee_ID__c oppOwnerNIK,
											Product2.Family oppProductFamily, 
	                                   		sum (TotalPrice)
										from opportunitylineitem 
										where opportunity.stagename in ('Closed Won')
											and opportunity.service_type__c <> 'Simcard Order'
											AND opportunity.id in :paramOppIDs
											//and opportunity.Actual_Closed_Date__c>= 2019-10-01
										group by opportunity.owner.name,
	                                   		opportunity.ownerid, 
	                                   		opportunity.owner.isactive,
	                                   		opportunity.owner.Employee_ID__c,
	                                   		Product2.Family
	                                   		];
    	}
	
		Sales_Target_and_Revenue__c str = new Sales_Target_and_Revenue__c();
		List<Sales_Target_and_Revenue__c> strList = new List<Sales_Target_and_Revenue__c>();
	
		for (AggregateResult oppGroup : oppGroups ){
			str = new Sales_Target_and_Revenue__c();
	
			String ownerID = null;
			boolean oppOwnerStatus = (boolean) oppGroup.get('oppOwnerStatus');
			string oppOwnerName = (string) oppGroup.get('oppOwnerName');
			system.debug ('=== oppOwnerName : ' + oppOwnerName);
			system.debug ('=== oppOwnerStatus : ' + oppOwnerStatus);
	
			string NIK = '';
	
			if (oppOwnerStatus) {
				ownerID = (string) oppGroup.get('oppOwnerID');
				NIK = (string) oppGroup.get('oppOwnerNIK');
	
			} else if (oppOwnerStatus == false) {
				ownerID = system.label.User_ID_System_Administrator;
				NIK = system.label.NIK_System_Administrator;
			}
	
			string productFamily = (string) oppGroup.get('oppProductFamily');
			
			if (paramDT <> null ) {
				dt = paramDT;
				dateToSet = dt;
			} else {
				tempMonth = (integer) oppGroup.get('mm');
				tempYear = (integer) oppGroup.get('yy');
				dt = date.newinstance(tempYear,tempMonth,1 );
				dateToSet = dt;
			}
			tempMonth = dateToSet.month();
			tempYear = dateToSet.year();
	
		    str.RecordTypeId = forecastRTID;
		    str.Type__c = 'Forecast';
		    str.User__c = ownerID;
		    str.AM__c = ownerID;
		    str.NIK__c = NIK;
		    str.Product_Family__c = productFamily;
		    str.Date__c = dateToSet;
		    str.Unique_ID__c = str.NIK__c+'-Forecast-'+str.Product_Family__c+'-'+tempMonth+'-'+tempYear;  
			system.debug('==== str.Unique_ID__c : ' + str.Unique_ID__c);
			
		    strList.add (str);
		}
		system.debug('==== strList : ' + strList);
	
	 	
	 	try {
			upsert strList Unique_ID__c; 
	
			Map <String, ID> strUniqueIDMap = new Map <String, ID>();
			for (Sales_Target_and_Revenue__c tmpStr : strList) {
				strUniqueIDMap.put(tmpStr.Unique_ID__c, str.ID);
			}
	
			//-- group by opportunityID
			AggregateResult[] oppLIGroup = [select id, opportunity.id oppID, opportunity.ownerid oppOwnerID, 
												opportunity.Owner.isactive oppOwnerStatus,
	                                        	opportunity.owner.name own, 
	                                        	opportunity.owner.Employee_ID__c oppOwnerNIK,
										Product2.Family oppProductFamily, Product2.ProductCode oppProductCode, 
	                                        opportunity.Accountid oppAccountID, 
										opportunity.stageName oppStageName,
										opportunity.Actual_Closed_Date__c actualClosedDate,
										sum (TotalPrice) Amount
									from opportunitylineitem 
									where opportunity.stagename in ('Closed Won')
										and opportunity.service_type__c <> 'Simcard Order'
										and opportunity.id in :paramOppIDs
										//and opportunity.Actual_Closed_Date__c>= 2019-10-01
									group by id, opportunity.id, opportunity.ownerid, opportunity.Owner.isactive, opportunity.owner.name, opportunity.owner.Employee_ID__c, 
										Product2.Family, Product2.ProductCode, opportunity.Accountid, opportunity.stageName,
										opportunity.Actual_Closed_Date__c];
	
			Sales_Target_and_Revenue_Detail__c strd = new Sales_Target_and_Revenue_Detail__c();
			List<Sales_Target_and_Revenue_Detail__c> strdList = new List<Sales_Target_and_Revenue_Detail__c>();
	
			List<string> opIds = new List<string> ();
	
			for (AggregateResult opp : oppLIGroup) {
				strd = new Sales_Target_and_Revenue_Detail__c();
				strd.am__c  = (string) opp.get('oppOwnerID');
				strd.Amount__c = (double) opp.get('Amount');
				strd.Invoicing_Company__c =(string)  opp.get('oppAccountID');
	
				boolean oppOwnerStatus = (boolean) opp.get('oppOwnerStatus');
	            string NIK='';
				if (oppOwnerStatus) {
					NIK = (string) opp.get('oppOwnerNIK');
	
				} else if (oppOwnerStatus == false) {
					NIK = system.label.NIK_System_Administrator;
				}
	
				strd.NIK__c = NIK;
				strd.Product_code__c = (string)  opp.get('oppProductCode');
				strd.Product_Family__c = (string)  opp.get('oppProductFamily');
				strd.Type__c = 'Forecast';
				
				if (paramDT <> null ) {
					dt = paramDT;
				} else {
					dt = (date) opp.get('actualClosedDate');
				}
				dateToSet = dt;
				tempMonth = dateToSet.month();
				tempYear = dateToSet.year();
				
				string uniqueID = strd.NIK__c+'-Forecast-'+strd.Product_Family__c+'-'+tempMonth+'-'+tempYear;  
				ID tmpID = strUniqueIDMap.get(uniqueID);
				if (tmpID == null) system.debug ('=== STR record is not found. uniqueID : ' + uniqueID + ' - '); 
				strd.Sales_Target_and_Revenue__c = tmpID;
				
				strd.RecordTypeId = forecastDetailRTID; 
	
				strd.Date__c = dateToSet;
				strd.Opportunity__c = (string) opp.get('oppID');
				strd.Forecast_Type__c = 'Pipeline';
				strd.Opportunity_Status__c = (string) opp.get('oppStageName');
				strd.Unique_ID__c = (string) opp.get('oppID') + '-' + (string) opp.get('id') ;
	
				//system.debug ('=== strd : ' + strd);
				strdList.add (strd);
	
				opIds.add(strd.Unique_ID__c );
	        }
	
	        //-- delete first
			Sales_Target_and_Revenue_Detail__c[] tmpstrdList= [select id 
																	from Sales_Target_and_Revenue_Detail__c 
																	where Unique_ID__c in :opIds ];
			delete tmpstrdList;
	
	        system.debug ('=== strdList : ' + strdList);
			upsert strdList Unique_ID__c;
	
	    } catch (system.Dmlexception e) {
	        system.debug (e);
	        string errMessage = 'Error on create STRD Opportunity - Closed Won.:: Record IDs : ' + paramOppIDs + '::' + e.getmessage() + '::' + e.getLineNumber() ;
	        system.debug('==================== error message : ' + errMessage);
	        AppUtils.putError(errMessage );
	    }    	
    	
    
    
    	return ret;
    }



}