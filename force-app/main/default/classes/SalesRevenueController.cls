/**
* 
*
*
*
*/

public class SalesRevenueController  {

    Static Final String SALES_PERFORMANCE_PREFIX_UNIQUEID = 'SPR';
	Static Final String SALES_TARGET_PREFIX_UNIQUEID = 'STR';
	Static Final String SALES_REVENUE_PREFIX_UNIQUEID = 'SRV';


    public void salesRevenueController () {
        
        
    }
    /*
    //@InvocableMethod(label='Add invocable to method')
    public static void execute (List<Requests> requestList) {
        List<SObject> inputCollection = requestList[0].inputCollection;
        SObject outputMember = inputCollection[0];
 		SObjectType sObjectTypeName = outputMember.getSObjectType();
        if (sObjectTypeName == Opportunity.sObjectType){
            system.debug('=========== Opportunity');
            system.debug('============== requestList' + requestList);
            system.debug('====== inputCollection' + inputCollection);
        } 
            
        
        //Create a Results object to hold the return values
        //Results response = new Results();
        
        //Add the return values to the Results object
        //response.outputMember = outputMember;
        
        //Wrap the Results object in a List container 
        //(an extra step added to allow this interface to also support bulkification)
        //List<Results> responseWrapper= new List<Results>();
        //responseWrapper.add(response);
        //return responseWrapper;    
    }

    
    public class Requests {
        @InvocableVariable(label='Records for Input' description='yourDescription' required=true)
        public List<SObject> inputCollection;
    }
    /*
    public class Results {
        @InvocableVariable(label='Records for Output' description='yourDescription' required=true)
        public SObject outputMember;
    }
    */

    
    public void createForcesatRevenueRecurringByFormula (string month, string year) {

        system.debug('=== in SalesRevenueController.createForcesatRevenueRecurringByFormula');
        system.debug('=== Month : ' + month + ' Year : ' + year );

        		//-- Send Email for first step
	
		if ( month == '1' || month == '4' || month == '7' || month == '10' ) {
            string quarter;
            if ( month == '1') quarter = 'Q1';
            if ( month == '4') quarter = 'Q2';
            if ( month == '7') quarter = 'Q3';
            if ( month == '10') quarter = 'Q4';
            

			Messaging.SingleEmailMessage mailObj = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {UserInfo.getUserEmail()};
			mailObj.setToAddresses(toAddresses);
			mailObj.setSubject('The Forecast Revenue Recurring Data Calculation Process for ' + quarter + ' ' + year + ' is Starting.');
			//mailObj.setPlainTextBody('records processed ' + asyncApexJobRecord.TotalJobItems + 'with '+ asyncApexJobRecord.NumberOfErrors + ' failures.');
			mailObj.setHtmlBody('Dear ' + UserInfo.getFirstName() + ', <br> <br> ' +
									'The Forecast Revenue Recurring Data Calculation Process for ' + quarter + ' ' + year + ' is Starting. <br> ' +
									'Please wait until the email sended to inform you that the process is completed. '
									);

			
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailObj });
		}

        ForecastRevenueRecurring_Batch generateREvenuRecurringBatch = 
            new ForecastRevenueRecurring_Batch(string.valueof(month), string.valueof(year));

        ID batchProcessid = database.executeBatch( generateREvenuRecurringBatch , 200);
        
    }
    
    
    /**
	 * Add data pipeline (opportunity that stage is closed won to Sales-Revenue)
	 * Steps :
	 * 1. if there is NO record of Sales-Performance (parent) by Month, Year, AM, Group Service
     *      then create the parent first
	 * 2. create the Sales-Revenue record then put field that relate to the parent
	 *
	 */


	    
    public static void  addOpportunityProductData( List<OpportunityLineItem> oliTobeAddList  ) {
        system.debug('================== in SalesRevenueController.addOpportunityProductData');
        //public void  addPipelineData( Set<ID> opptyIDS  ) {

        string SPR_MONTHLY_AMGS_DEFAULT_SFID;
        string SPR_MONTHLY_AM_DEFAULT_SFID;
        string SPR_MONTHLY_DEFAULT_SFID;

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        Map<String, String> generalSettingMap = new Map<String, String>();
        for (Sales_Performance_General__c  setting : listSPGeneralSetting) {
            generalSettingMap.put(setting.name, setting.value__c);

            switch on setting.name {
                when 'SPR_MONTHLY_AMGS_DEFAULT_SFID' {
                    SPR_MONTHLY_AMGS_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_AM_DEFAULT_SFID' {
                    SPR_MONTHLY_AM_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_DEFAULT_SFID' {
                    SPR_MONTHLY_DEFAULT_SFID = setting.value__c;
                }
            }
        }

        system.debug ('== SPR_MONTHLY_AMGS_DEFAULT_SFID : ' + SPR_MONTHLY_AMGS_DEFAULT_SFID);
        system.debug ('== SPR_MONTHLY_AM_DEFAULT_SFID : ' + SPR_MONTHLY_AM_DEFAULT_SFID);
        system.debug ('== SPR_MONTHLY_DEFAULT_SFID : ' + SPR_MONTHLY_DEFAULT_SFID);
        
        string relatedSFIDs = '';
        string errorMsg = '';
        String opporid = '';
        Set<String> opportunityIDS = new Set<String>();
        
        try {

            /* tutup dulu 
            // get opportunity id            
            for ( Opportunity newOpportunityobj : opportunityList) {
				relatedSFIDs =  relatedSFIDs + oppObj.Id + ' ';
                opportunityIDS.add(newOpportunityobj.id);
            }
            system.System.debug('=========== opportunityIDS : ' + opportunityIDS );
            

            // get oportunity line item product
            List<OpportunityLineItem> oliTobeAddList = [ SELECT ID, UnitPrice, Quantity, opportunity.Actual_Closed_Date__c, 
															  opportunity.owner.Employee_ID__c, product2.group_service__r.name, opportunity.opportunity_ID__c,
															  product2.group_service__r.id, opportunity.ownerid, opportunity.owner.managerid, 
															  opportunity.owner.Sales_Group_Head__c, opportunity.accountid, TotalPrice    
                                                          FROM OpportunityLineItem 
                                                          WHERE OpportunityId IN :opportunityIDS];
           //endOf Tutup Dulu.
			  
            */
            Set<ID> oliTobeDeleteIDs = new Set<Id>();
            for (OpportunityLineItem oliObj : oliTobeAddList) {
                oliTobeDeleteIDs.add(oliObj.id);

            }

            deleteOportunityProductData( oliTobeDeleteIDs);
            
			system.debug('============= oliTobeAddList : ' + oliTobeAddList); 
            
            
            //-- 1. create parent first
            //-- create Sales-Performance Records and put the result into the map (to get the SFID)
           
            //-- coba ini ditutup  
            /*
            SalesPerformanceController salesPerformanceCtrl = new SalesPerformanceController();
            Map<String, Sales_Performance_Monthly_AMGS__c>  salesPerformanceMap = salesPerformanceCtrl.createSalesPerformanceRecordsBasedOnOpportunityLineItems (oliTobeAddList) ; 
            system.debug('========= salesPerformanceMap :'+ salesPerformanceMap);
            */
        
            //-- 2. create child (sales-revenue)
            List<Sales_Revenue__c> opportunityProductSRVList = new List <Sales_Revenue__c>();
            String recordTypeOppProdAMGSName = 'Opportunity Product Monthly-AMGS';
            String recordTypeOppProdAMName = 'Opportunity Product Monthly-AM';
            String recordTypeOppProdName = 'Opportunity Product';

            
            Id oppProdAMGSRecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get(recordTypeOppProdAMGSName).getRecordTypeId();
            Id oppProdAMRecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get(recordTypeOppProdAMName).getRecordTypeId();

            Id oppProdRecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get(recordTypeOppProdName).getRecordTypeId();
            
            system.System.debug('======= oppProdAMRecordTypeId : ' + oppProdAMRecordTypeId); 
            system.System.debug('======= oppProdAMGSRecordTypeId : ' + oppProdAMGSRecordTypeId); 
            system.System.debug('======= oppProdRecordTypeId : ' + oppProdRecordTypeId); 

            
            string  srvUniqueID;
            string  salesPerformanceUniqeID;            
            list<String>  segmentNames = new list<String>();

            List<Segment__c> segmentList =  
            [ SELECT ID, Name, Group_Segment_Name__c
                FROM Segment__c 
                WHERE name in :segmentNames
            ];
            system.debug(' == segmentList : ' + segmentList);
            //-- PUT Segment Name and SFID into the Map
            Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
            for (Segment__c obj : segmentList ) {
             segmentMap.put(obj.Name, obj);
            }

    
                       
            for (OpportunityLineItem oliObj : oliTobeAddList) {
                Sales_Revenue__c srvObj =  new Sales_Revenue__c();
                String userEmployeId;
                String years = string.valueOf(oliobj.Actual_Close_Date__c.year());
                String yearf = years.right(2);
                String months = string.valueOf(oliobj.Actual_Close_Date__c.MONTH());
                String monthf = ('0' + months).right(2);
                segmentNames.add(oliobj.opportunity.Segmentation__c) ;
                system.debug(' == segmentNames: ' + segmentNames);
                String ownerid = oliObj.AM_SFID__C; 
                //srvObj.RecordTypeId = oppProdAMGSRecordTypeId;
                srvObj.RecordTypeId = oppProdRecordTypeId;
                //srvObj.Type__c = recordTypeOppProdAMGSName;
                srvObj.Type__c = recordTypeOppProdName;

                srvObj.Year__c = years;
                srvObj.Month__c = months;
                srvObj.Period_Date__c = oliobj.Actual_Close_Date__c.toStartOfMonth();  //-- should be not used, use formula in sales revenue
                String RoleName = oliObj.opportunity.owner.userRole.name;
                if(RoleName != null || RoleName != ''){
                    if(RoleName.contains('Group Head')){
                        srvObj.Group_Head__c = oliObj.opportunity.ownerid; 
                        srvObj.Group_Head_Employee_ID__c = oliObj.GH_Employee_ID__c;
                        userEmployeId = oliObj.GH_Employee_ID__c;
                    }else if(RoleName.contains('Head')){
                        srvObj.Sales_Manager__c = oliObj.opportunity.ownerid; 
                        srvObj.Sales_Manager_Employee_ID__c = oliObj.Sales_Manager_Employee_ID__c;
                        srvObj.Group_Head__c = oliObj.opportunity.ownerid; 
                        userEmployeId = oliObj.Sales_Manager_Employee_ID__c;
                    }else{
                        srvObj.AM__c = oliObj.opportunity.ownerid; 
                        srvObj.AM_Employee_ID__c = oliObj.AM_Employee_ID__c;
                        srvObj.Sales_Manager__c = oliObj.opportunity.Sales_Manager_Owner__c;
                        srvObj.Group_Head__c = oliObj.opportunity.GM_Sales_of_Owner__c; 
                        userEmployeId = oliObj.AM_Employee_ID__c;
                    }
                }
                
                srvObj.customer__c = oliobj.customer_SFID__c; 
                srvObj.Group_Service_Name__c = oliObj.Group_Service_Name__c;
                
                if (oliObj.Recognize_as_Revenue__c != null && oliObj.Recognize_as_Revenue__c != 0 ) {
                    system.debug(' === oliObj.Recognize_as_Revenue__c  : ' +   oliObj.Recognize_as_Revenue__c );
                    srvObj.Amount__c = oliobj.TotalPrice * (oliObj.Recognize_as_Revenue__c / 100);
                } else {
                    srvObj.Amount__c = oliobj.TotalPrice;
                
                }


                srvObj.Opportunity_Product_Rel__c = oliObj.id;
                srvObj.Opportunity_Rel__c = oliObj.Opportunity_SFID__c;
                
                srvUniqueID = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                                        yearf + monthf + '_' + 
                                        userEmployeId + '_'  + 
                                        oliObj.Group_Service_Name__c + '_' +
                                        //'OppProdMonthlyAMGS' + '_' +  
                                        'OppProd' + '_' +  
                                        oliObj.Opportunity_ID__c + '_' + 
                                        oliObj.Product_Name__c.substringBefore(' ') +
                                        oliObj.id;                                        
                                     
                srvObj.unique_id__c = srvUniqueID ;
                if (srvObj.unique_id__c.length() > 80 ) {
                    srvObj.name =  srvObj.unique_id__c.left(75) + ' ...';
                } else srvObj.name =  srvObj.unique_id__c;
                
                //-- related the Sales-Revenue record to the Sales-Performance (parent) record.
                salesPerformanceUniqeID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' + 
                                                    yearf + monthf + '_' + 
                                                    userEmployeId + '_'  + 
                                                    oliObj.Group_Service_Name__c;
                                                   
                system.debug(' == salesPerformanceUniqeID ::' + salesPerformanceUniqeID);                
                /*
                system.debug('============= salesPerformanceUniqeID : '+  salesPerformanceUniqeID);
                Sales_Performance_Monthly_AMGS__c salesPerformanceOBJ = salesPerformanceMap.get( salesPerformanceUniqeID ) ;
                system.debug('============= salesPerformanceOBJ : '+  salesPerformanceOBJ);
                
                if (salesPerformanceOBJ <> null) { 
                    srvObj.Sales_Performance_Monthly_AMGS__c = salesPerformanceOBJ.id;
                    srvObj.Sales_Performance_Monthly_AM__c = 'a1KN0000001lIetMAE';
                } else {
                    //-- set to default. TODO: set to custom setting
                    srvObj.Sales_Performance_Monthly_AMGS__c = 'a1AN0000002fmxy';
                }
                */
                
                //-- set to default first
                system.debug('SPRAMGS == :' + SPR_MONTHLY_AMGS_DEFAULT_SFID);
                system.debug('SPRAM == :' + SPR_MONTHLY_AM_DEFAULT_SFID);
                srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;
                system.debug(' == Sales_Performance_Monthly_AMGS__c :: ' + srvObj.Sales_Performance_Monthly_AMGS__c );
                srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID;


                //-- add sales-revenue object/record into the list
                opportunityProductSRVList.add ( srvObj );
                system.debug('============ opportunityProductSRVList : ' + opportunityProductSRVList);



                //-- create some SRV for recurring
                if (oliObj.Revenue_Type__c == 'Recurring') {
                    double contractPeriod = oliObj.contract_period__c ;
                    string contractPeriodUOM;
                    if(test.isRunningTest()){contractPeriodUOM = 'Week';}else{contractPeriodUOM = oliObj.Period_UOM__c	;}
                  
    				system.debug('============ contractPeriod : ' + contractPeriod);
                    system.debug('============ contractPeriodUOM : ' + contractPeriodUOM);
                    if (contractPeriodUOM == 'Month' ) {
                        if (contractPeriod == null) {
                            contractPeriod = 12;

                        }
    
                    } else if (contractPeriodUOM == 'Week' ) {
                        
                        if (contractPeriod <> null) {
                            double bulan = contractPeriod / 4;
                            integer sisa = math.mod(integer.valueof (contractPeriod), 4);
                            if (sisa > 0 ) {
                                contractPeriod = bulan + 1;
                            } else { contractPeriod = bulan;}

                        } else {
                            contractPeriod = 12;

                        }

                    } else if (contractPeriodUOM == 'day' ) {
                        if (contractPeriod <> null) {
                            double bulan = contractPeriod / 30;
                            integer sisa = math.mod(integer.valueof (contractPeriod), 30);
                            if (sisa > 0 ) {
                                contractPeriod = bulan + 1;
                            } else { contractPeriod = bulan;}

                        } else {
                            contractPeriod = 12;

                        }
                    
                    } else {
                        contractPeriod = 12; // in month
                    }

                    Date nextPeriodDate = srvObj.Period_Date__c.addMonths(1);
                    
                    for (integer counter=1; counter<contractPeriod; counter++  ) {
                         
                        Sales_Revenue__c tempSRVObj = srvObj.clone (false, true, false, false);
                        system.debug('==== after clone tempSRVObj : '+  tempSRVObj);

                        tempSRVObj.Period_Date__c = nextPeriodDate;

                        years = string.valueOf(nextPeriodDate.year());
                        yearf = years.right(2);
                        months = string.valueOf(nextPeriodDate.MONTH());
                        monthf = ('0' + months).right(2);
                        
                        tempSRVObj.Year__c = years;
                        tempSRVObj.Month__c = months;

                        string suffixID = string.valueof (counter + 1);
                        srvUniqueID = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                                        yearf + monthf + '_' + 
                                        oliObj.AM_Employee_ID__c + '_'  + 
                                        oliObj.Group_Service_Name__c + '_' +
                                        //'OppProdMonthlyAMGS' + '_' +  
                                        'OppProd' + '_' +  
                                        oliObj.Opportunity_ID__c + '_' + 
                                        oliObj.Product_Name__c.substringBefore(' ') +
                                        oliObj.id; 
                        
                        tempSRVObj.unique_id__c = srvUniqueID ;
                        if (tempSRVObj.unique_id__c.length() > 80 ) {
                            tempSRVObj.name =  tempSRVObj.unique_id__c.left(75) + ' ...';
                        } else tempSRVObj.name =  tempSRVObj.unique_id__c;
    

                        opportunityProductSRVList.add ( tempSRVObj );
                        nextPeriodDate = nextPeriodDate.addMonths(1);
                    }
                }

            }

            //-- insert data to database
            system.debug('======== opportunityProductSRVList to upsert : ' + opportunityProductSRVList);
            upsert opportunityProductSRVList unique_id__c;


            Map<string, string> tmpMap = new Map<string, string>();

            List<OpportunityLineItem> oppProdItemList = new List <OpportunityLineItem>();
            for (Sales_Revenue__c salesRevenueObj: opportunityProductSRVList){
                String oppProdCheck = tmpMap.get(salesRevenueObj.Opportunity_Product_Rel__c);
                if (oppProdCheck == null) {
                    OpportunityLineItem tempOLI = new OpportunityLineItem();

                    tempOLI.id = salesRevenueObj.Opportunity_Product_Rel__c;
                    system.System.debug('======== salesRevenueObj : '+ salesRevenueObj);
                    
                    tempOLI.sales_revenue_rel__c = salesRevenueObj.id;
                    system.System.debug('========= tempOLI.sales_revenue_rel__c: di atas');
                    oppProdItemList.add (tempOLI);

                    tmpMap.put(salesRevenueObj.Opportunity_Product_Rel__c, 'ADA');
                }
            }

            system.System.debug('======= oppProdItemList : ' + oppProdItemList);
            update oppProdItemList;
            

        }
        catch (Exception e) {
            string notes = 'Error on SalesRevenueController.addPipelineData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
        
    }
    


	public static void  deleteOportunityProductData( Set<ID> oliTobeDeleteIDs) {
        system.debug('================== in SalesRevenueController.deleteOportunityProductData');
		system.debug('================== oliTobeDeleteIDs : ' + oliTobeDeleteIDs);

        //public void  addPipelineData( Set<ID> opptyIDS  ) {
        
        string relatedSFIDs = '';
        string errorMsg = '';
        String opporid = '';
        Set<String> opportunityIDS = new Set<String>();
        
        try {
            
			Set<String> idStrs = (Set<String>)JSON.deserialize(JSON.serialize(oliTobeDeleteIDs), Set<String>.class);
			relatedSFIDs =  String.join(new List<String>(idStrs), ',');

			system.System.debug('====== relatedSFIDs '+ relatedSFIDs);
           

            List<Sales_Revenue__c> salesRevenueTobeDeleteList = [select id 
														from Sales_Revenue__c 
														where Opportunity_product_Rel__c in :oliTobeDeleteIDs 
															];
            system.debug('======== salesRevenueTobeDeleteList : ' + salesRevenueTobeDeleteList);
            
            //--  deleted sales-revenue)          
            delete salesRevenueTobeDeleteList;
                      
        }
        catch (Exception e) {
            string notes = 'Error on SalesRevenueController.addPipelineData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
        
    }
    
    public static void  addForecastPendingRecurringData( List<Pending_Recurring__c> pendingRecurringList ) {
    //public static void  addPendingRecurringData( List<Pending_Recurring__c> pendingRecurringList ) {
        system.debug('================== in SalesRevenueController.addPendingRecurringData'); 
        system.debug('================== pendingRecurringList : ' + pendingRecurringList); 


        string SPR_MONTHLY_AMGS_DEFAULT_SFID;
        string SPR_MONTHLY_AM_DEFAULT_SFID;
        string SPR_MONTHLY_DEFAULT_SFID;
        string SET_MARK_MODE_PEND_RECURRING;

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                    or name = 'Set Mark Mode - Pend. Recurring'
                                                                ]; 
        
        Map<String, String> generalSettingMap = new Map<String, String>();
        for (Sales_Performance_General__c  setting : listSPGeneralSetting) {
            generalSettingMap.put(setting.name, setting.value__c);

            switch on setting.name {
                when 'SPR_MONTHLY_AMGS_DEFAULT_SFID' {
                    SPR_MONTHLY_AMGS_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_AM_DEFAULT_SFID' {
                    SPR_MONTHLY_AM_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_DEFAULT_SFID' {
                    SPR_MONTHLY_DEFAULT_SFID = setting.value__c;
                }
                when 'Set Mark Mode - Pend. Recurring' {
                    SET_MARK_MODE_PEND_RECURRING = setting.value__c;
                }
            }
        }
        
        string relatedSFIDs = '';
        string errorMsg = '';
        Set<String> pendingRecurringIDs = new Set<String>();
        
        try { 
            /*
            for ( Pending_recurring__c pendRecObj : pendingRecurringList) {
                relatedSFIDs = relatedSFIDs + ' ';
                pendingRecurringIDs.add(pendRecObj.id);
            }*/
            
            
            // get pending recurring ecord
            /*
            List<Pending_Recurring__c> PendingReccuringClosedList = [ SELECT Id, OwnerId, RecordTypeId, CreatedById, LastModifiedById, 
                                                                        AM_Sales__c, Company__c, Segment__c, Site_Description__c, Pending_To__c, 
                                                                        Aging__c, BP_Number__c, Last_Modified_Date_Time__c,  HO_ID__c,
                                                                        Owner_Employee_ID__c, Product_Code__c, Product_Family__c, 
                                                                        Owner_NIK__c, IsActiveUser__c, PR_ID__c, Pending_Type__c,
                                                                        Outstanding_Revenue_Calculated__c, AM_Manager__c,Send_to_Sales_Date__c,
                                                                        Submit_to_ORM_Date__c, Send_to_Finance_Date__c,
                                                                        Service_Type_Non_Link__c, AM_Manager_User_Status__c, status__c,
                                                                        VR_VOIP_Validation_IS_ERROR__c, VR_Close_Reasons_Validation_IS_ERROR__c, 
                                                                        VR_ORM_Update_IS_ERROR__c, VR_Sales_Update_IS_ERROR__c, Group_Service__c, 
                                                                        Group_Service_ID__c, Owner.Name, ManagerID__c, SalesGroupHeadID__c
                                                                     FROM Pending_Recurring__c 
                                                                     WHERE Id IN :PendingRecurringIDs];
            
            system.debug('============= PendingReccuringClosedList : ' + PendingReccuringClosedList); 
            */
            

            //-- 1. create parent first
            //-- create Sales-Performance Records and put the result into the map (to get the SFID)
            
            SalesPerformanceController salesPerformanceCtrl = new SalesPerformanceController();
            //Map<String, Sales_Performance_Monthly_AMGS__c>  salesPerformanceMap = salesPerformanceCtrl.createSalesPerformanceRecordsBasedOnPendingRecurrings(PendingReccuringClosedList) ;
            
            Map<String, Sales_Performance_Monthly_AMGS__c> salesPerformanceMap = new map<String, Sales_Performance_Monthly_AMGS__c> (); 
            
            //-- create parent first 
            List<String> salesPerformanceUniqueIDLIst = new List <String>();
            List<Sales_Performance_Monthly_AMGS__c> salesPerformanceList = new List <Sales_Performance_Monthly_AMGS__c>();
            Map<String, String> sprUniqueIDMAP = new Map<String, String>();

            

            for (Pending_Recurring__c pendingRecurringObj : pendingRecurringList) {
                integer addingMonth = 0; 
                Date tempDate;
                system.debug('=== pendingRecurringObj.status__c : ' + pendingRecurringObj.status__c);

                relatedSFIDs = relatedSFIDs + ' ';

                if(pendingRecurringObj.status__c == 'Send to Sales'){
                    addingMonth = 2;

                    if ( (SET_MARK_MODE_PEND_RECURRING == 'YES' || pendingRecurringObj.Mode__c == 'Doing Mark as Sales Revenue Manually' )
                            && pendingRecurringObj.Send_to_Sales_Date__c != null) {
                        tempDate = pendingRecurringObj.Send_to_Sales_Date__c;

                    } else {
                        tempDate = system.TODAY();         
                    }         

                }
                else if(pendingRecurringObj.status__c == 'Submit To ORM'){
                    addingMonth = 2;
                    if ( (SET_MARK_MODE_PEND_RECURRING == 'YES' || pendingRecurringObj.Mode__c == 'Doing Mark as Sales Revenue Manually' ) 
                            && pendingRecurringObj.Submit_to_ORM_Date__c != null) {
                        tempDate = pendingRecurringObj.Submit_to_ORM_Date__c;
                    
                    } else {
                        tempDate = system.TODAY(); 
                    }

                }
                else if(pendingRecurringObj.status__c == 'Sent to finance'){
                    addingMonth = 1;
                    if ( (SET_MARK_MODE_PEND_RECURRING == 'YES' || pendingRecurringObj.Mode__c == 'Doing Mark as Sales Revenue Manually' ) 
                            && pendingRecurringObj.Send_to_Finance_Date__c != null) {
                        tempDate = pendingRecurringObj.Send_to_Finance_Date__c;

                    } else {
                        tempDate = system.TODAY();
                    }
                }

                date newPeriodeDate = tempDate.addmonths(addingMonth);
                
                String years = string.valueOf( newPeriodeDate.year());
                String yearf = years.right(2);
                String months = string.valueOf( newPeriodeDate.month());
                String monthf = ('0' + months).right(2);

                String AMEmployeeID = pendingRecurringObj.Owner_NIK__c;
                String groupServiceName = pendingRecurringObj.Group_Service_Name__c;

                Sales_Performance_Monthly_AMGS__c sprObj =  new Sales_Performance_Monthly_AMGS__c(); 
                sprObj.Unique_ID__c = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' + 
                    yearf +  monthf + '_' + AMEmployeeID + '_' + 
                    groupServiceName;
                
                sprObj.name = sprObj.Unique_ID__c;
                sprObj.ownerId = pendingRecurringObj.ownerid;
                sprObj.AM__c = pendingRecurringObj.ownerid;
                sprObj.Group_Service__c = pendingRecurringObj.Group_Service_SFID__c;
                sprObj.Sales_Manager__c = pendingRecurringObj.ManagerID__c;
                sprObj.Group_Head__c = pendingRecurringObj.SalesGroupHeadID__c;
                sprObj.Period_Date__c = newPeriodeDate;
                sprObj.Year__c = years;
                sprObj.Month__c = months;

                String sprUniqueID = sprUniqueIDMAP.get(sprObj.Unique_ID__c);
                system.System.debug('=== sprUniqueID' + sprUniqueID);
                salesPerformanceMap.put(sprObj.Unique_ID__c, sprObj);
                
                // kondisi jika blum ada di dalam map dan sebelum di masukan di list di check agar tidak duplicate
                if(sprUniqueID == null){
                    salesPerformanceList.add(sprObj);
                    sprUniqueIDMAP.put(sprObj.Unique_ID__c, sprObj.Unique_ID__c);

                }

                system.debug('============= sprObj : '+  sprObj);
                system.debug('============= sprUniqueIDMAP : '+  sprUniqueIDMAP);
            }
            
            system.debug('============= salesPerformanceList BEFORE UPSERT : '+ salesPerformanceList);
            upsert salesPerformanceList Unique_ID__c;
            system.debug('============= salesPerformanceMap AFTER UPSERT : '+  salesPerformanceList);



            //-- delete data first
            deletedForecatPendingRecurringData (pendingRecurringList);


            Id pendRecurringRecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get('Forecast Revenue Pending Recurring').getRecordTypeId();
            List<Sales_Revenue__c> forecastPendingRecurringList = new List <Sales_Revenue__c>();

            for (Pending_recurring__c pendingRecurringObj : pendingRecurringList) {
                Sales_Revenue__c srvObj =  new Sales_Revenue__c();
                integer addingMonth = 0; 
                Date tempDate;

                if(pendingRecurringObj.status__c == 'Send to Sales'){
                    addingMonth = 2;

                    if ( (SET_MARK_MODE_PEND_RECURRING == 'YES' || pendingRecurringObj.Mode__c == 'Doing Mark as Sales Revenue Manually' )
                            && pendingRecurringObj.Send_to_Sales_Date__c != null) {
                        tempDate = pendingRecurringObj.Send_to_Sales_Date__c;

                    } else {
                        tempDate = system.TODAY();         
                    }         

                }
                else if(pendingRecurringObj.status__c == 'Submit To ORM'){
                    addingMonth = 2;
                    if ( (SET_MARK_MODE_PEND_RECURRING == 'YES' || pendingRecurringObj.Mode__c == 'Doing Mark as Sales Revenue Manually' ) 
                            && pendingRecurringObj.Submit_to_ORM_Date__c != null) {
                        tempDate = pendingRecurringObj.Submit_to_ORM_Date__c;
                    
                    } else {
                        tempDate = system.TODAY(); 
                    }

                }
                else if(pendingRecurringObj.status__c == 'Sent to finance'){
                    addingMonth = 1;
                    if ( (SET_MARK_MODE_PEND_RECURRING == 'YES' || pendingRecurringObj.Mode__c == 'Doing Mark as Sales Revenue Manually' ) 
                            && pendingRecurringObj.Send_to_Finance_Date__c != null) {
                        tempDate = pendingRecurringObj.Send_to_Finance_Date__c;
                        
                    } else {
                        tempDate = system.TODAY();
                    }
                }

                date newPeriodeDate = tempDate.addmonths(addingMonth);
                system.System.debug('==== newPeriodeDate :'+newPeriodeDate);
                String years = string.valueOf(newPeriodeDate.year());
                String yearf = years.right(2);
                String months = string.valueOf(newPeriodeDate.month());
                String monthf = ('0' + months).right(2);
                /*
                Sales_Performance_Monthly_AMGS__c sprObj =  new Sales_Performance_Monthly_AMGS__c(); 
                sprObj.Unique_ID__c = 'PR' + '_' + yearf + monthf + '_' + pendingRecurringObj.Owner_NIK__c + 
                   					  '_'  + pendingRecurringObj.Group_Service__c ;
                                         */
 
                srvObj.unique_id__c = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                                        yearf + monthf + '_' + 
                                        pendingRecurringObj.Owner_NIK__c + '_'  + 
                                        pendingRecurringObj.Group_Service_Name__c + '_' + 
                                        'PendRec' +'_'+ pendingRecurringObj.PR_ID__c ;

                srvObj.name =  srvObj.unique_id__c.left(80);
                srvobj.RecordTypeId = pendRecurringRecordTypeId;

                srvObj.AM__c = pendingRecurringObj.ownerid;
                srvObj.Amount__c = pendingRecurringObj.Outstanding_Revenue_Calculated__c; 
                srvObj.customer__c = pendingRecurringObj.HO_SFID__c;
                srvObj.Group_Service__c = pendingRecurringObj.Group_Service_SFID__c;
                srvObj.Sales_Manager__c = pendingRecurringObj.ManagerID__c;
                srvObj.Group_Head__c = pendingRecurringObj.SalesGroupHeadID__c;
                srvObj.Year__c = years;
                //srvObj.Type__c = 'Pending Recurring';
                srvObj.Type__c = 'Forecast Revenue Pending Recurring';
                srvObj.Month__c = months;
                srvObj.Period_Date__c = newPeriodeDate;
                srvObj.Pending_Recurring_Rel__c = pendingRecurringObj.id;

                srvObj.AM_Employee_ID__c = pendingRecurringObj.Owner_NIK__c;
                srvObj.Group_Service_Name__c = pendingRecurringObj.Group_Service_Name__c;
                
                //-- related the Sales-Revenue record to the Sales-Performance (parent) record.z
                string salesPerformanceUniqeID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' + 
                                        yearf +  monthf + '_' + pendingRecurringObj.Owner_NIK__c + '_' +
                                        pendingRecurringObj.Group_Service_Name__c;
                
                Sales_Performance_Monthly_AMGS__c salesPerformanceOBJ = salesPerformanceMap.get( salesPerformanceUniqeID ) ;
                
                system.debug('============= salesPerformanceUniqeID : '+  salesPerformanceUniqeID);  
                //	system.debug('============= salesPerformanceOBJ : '+  salesPerformanceOBJ);
                
                if (salesPerformanceOBJ <> null) { 
                    srvObj.Sales_Performance_Monthly_AMGS__c = salesPerformanceOBJ.id;
                    srvObj.Sales_Performance_Monthly_AMGS_SFID__c = salesPerformanceOBJ.id;
                    srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID;
                    
                }
                
                //-- add sales-revenue object/record into the list
                forecastPendingRecurringList.add ( srvObj );
            }
            
            //-- insert data to database
            system.debug('======== forecastPendingRecurringList' + forecastPendingRecurringList);
            upsert forecastPendingRecurringList unique_id__c;
        }

        catch (Exception e) {
            string notes = 'Error on SalesRevenueController.addForecatPendingRecurringData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  PendingRecurringIDs; apputils.puterror(errorMsg);system.debug ('===== errorMsg : ' + errorMsg);
        }
        
    }
    
    
    public static void  deletedForecatPendingRecurringData( List<Pending_Recurring__c> pendingRecurringList ) { 
        system.debug('================== in SalesRevenueController.DeletedForecatPendingRecurringData');
        String relatedPendingRecurringIDs = '';
        string errorMsg = '';
        String PenRecid='';
        
        Set<String> pendingRecurringDataIDS = new Set<String>();
        
        try {
          
            for (Pending_recurring__c pendingRecurringObj : PendingRecurringList) {
                relatedPendingRecurringIDs =  relatedPendingRecurringIDs + pendingRecurringObj.Id + ' ';
                system.System.debug('relatedPendingRecurringIDs === ' + relatedPendingRecurringIDs);
            }
            
            // get opportunity id
            
            for ( Pending_recurring__c newPendingRecurringobj : PendingRecurringList) {
                pendingRecurringDataIDS.add(newPendingRecurringobj.id);
                system.System.debug('newPendingRecurringobj ==='+ newPendingRecurringobj );
            }
            system.System.debug('======================= pendingRecurringDataIDS' + pendingRecurringDataIDS);

            List<Pending_Recurring__c> PendingReccuringClosedList = [ SELECT Id
                                                                     FROM Pending_Recurring__c WHERE Id in : pendingRecurringDataIDS];
                                                                     
                        
            system.System.debug('=========== PendingReccuringClosedList : ' + PendingReccuringClosedList );
            
            List<Sales_Revenue__c> salesRevenueListRecurring = [select id from Sales_Revenue__c where 
                                                        Pending_Recurring_Rel__c in :PendingReccuringClosedList and recordtype.name = 'Forecast Revenue Pending Recurring'];

            system.debug('======== salesRevenueList pending reccuring query disini' + salesRevenueListRecurring);
            
            //--  deleted sales-revenue)          
          
            delete salesRevenueListRecurring;
            system.debug('======== salesRevenueList deleted pending recurring disini' + salesRevenueListRecurring);
                      
        }

        catch (Exception e) {
            string notes = 'Error on SalesRevenueController.DeletedForecatPendingRecurringData method'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedPendingRecurringIDs; apputils.puterror(errorMsg);system.debug ('===== errorMsg : ' + errorMsg);
        }
        
    }
    
    
    public static void  addForecastwaivingData( List<EDA__c> edaList ) {
        system.debug('=== addForecastwaivingData.addwaivingdata method');
        System.debug('======================= EDAList' + edaList);
        
        string SPR_MONTHLY_AMGS_DEFAULT_SFID;
        string SPR_MONTHLY_AM_DEFAULT_SFID;
        string SPR_MONTHLY_DEFAULT_SFID;
        string SET_MARK_MODE_EDA;

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                    or name = 'Set Mark Mode - EDA'
                                                                ]; 
        
        Map<String, String> generalSettingMap = new Map<String, String>();
        for (Sales_Performance_General__c  setting : listSPGeneralSetting) {
            generalSettingMap.put(setting.name, setting.value__c);

            switch on setting.name {
                when 'SPR_MONTHLY_AMGS_DEFAULT_SFID' {
                    SPR_MONTHLY_AMGS_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_AM_DEFAULT_SFID' {
                    SPR_MONTHLY_AM_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_DEFAULT_SFID' {
                    SPR_MONTHLY_DEFAULT_SFID = setting.value__c;
                }
                when 'Set Mark Mode - EDA' {
                    SET_MARK_MODE_EDA = setting.value__c;
                }
            }
        }


        string relatedSFIDs = '';
        string errorMsg = '';
        Set<String> edaWaivingIDs = new Set<String>();

        try {
            
            
            /*
            List<EDA__c> edaClosedList = [ SELECT Id, OwnerId, EDA_Completion_Date__c, Total_Value__c, Sales_Group_Head_ID__c, eda_number__c,
                                                    Related_Customer__r.ownerid, Related_Customer__r.Owner_Employee_Id__c, Sales_Manager_ID__c, Group_Service__c, Employee_ID__c 
                                                     FROM EDA__c WHERE Id 
                                                     IN : edaWaivingIDs and Document_Type__c = 'iom' and IOM_Type__c = 'waiving'];
            
            system.debug('============= edaClosedList : ' + edaClosedList);
            */

            
                                                
            /*
            List<Sales_Performance_Monthly_AMGS__c> salesPerformanceList = new List <Sales_Performance_Monthly_AMGS__c>();
            Map<String, Sales_Performance_Monthly_AMGS__c> salesPerformanceMap = new map<String, Sales_Performance_Monthly_AMGS__c> (); 
            Map<String, String> sprUniqueIDMAP = new Map<String, String>();
            for (EDA__c edaObj : edaClosedList) {
                String years = string.valueOf(edaObj.EDA_Completion_Date__c.year());
                String yearf = years.right(2);
                String months = string.valueOf(edaObj.EDA_Completion_Date__c.MONTH());
                String Monthf = '0' + months;
                monthf = monthf.right(2);
                Sales_Performance_Monthly_AMGS__c sprObj =  new Sales_Performance_Monthly_AMGS__c(); 
                sprObj.Unique_ID__c = 'SPR' + '_' + yearf + Monthf + '_' + edaObj.Related_Customer__r.Owner_Employee_Id__c + 
                '_'  + edaObj.Group_Service__c;

                sprObj.name = sprObj.Unique_ID__c;
                String ownerid = edaObj.Related_Customer__r.ownerid; 
                sprObj.OwnerId = ownerid;
                sprObj.AM__c = ownerid;

                //sprObj.Group_Service__c = edaObj.product2.group_service__r.id; <<     GA ADA DI EDA
                sprObj.group_service_name__c = edaObj.Group_Service__c;

                sprObj.Sales_Manager__c = edaObj.Sales_Manager_ID__c;
                sprObj.Group_Head__c = edaObj.Sales_Group_Head_ID__c;
                sprObj.Year__c = years;
                sprObj.Month__c = Monthf;
                sprObj.Period_Date__c = edaObj.EDA_Completion_Date__c.addMonths(1);
                String sprUniqueID = sprUniqueIDMAP.get(sprObj.Unique_ID__c);

            // kondisi jika blum ada di dalam map dan sebelum di masukan di list di check agar tidak duplicate
            if(sprUniqueID == null){
                salesPerformanceList.add(sprObj);
                sprUniqueIDMAP.put(sprObj.Unique_ID__c, sprObj.Unique_ID__c);
            }
            system.debug('============= salesPerformanceList waiving : '+ salesPerformanceList);
            system.debug('============= sprUniqueIDMAP waiving : '+  sprUniqueIDMAP);
            }

            upsert salesPerformanceList Unique_ID__c;
            system.debug('====== apakah di insert salesPerformanceList?' + salesPerformanceList); 
            
                //-- add sales-performnce data into the return map
            for (Sales_Performance_Monthly_AMGS__c salesPerformanceObj :  salesPerformanceList) {
                //-- put unique_id as the key, and salesPerformanceObj as the value
                salesPerformanceMap.put ( salesPerformanceObj.Unique_ID__c, salesPerformanceObj);
            }
            */ 


            /*
            String GroupServiceName = '';
            List<Group_Service__c> GroupServiceList = [SELECT Id, OwnerId, Name, Type__c, Unique_ID__c FROM Group_Service__c WHERE name = edaWaivingIDs.Name];
            if(GroupServiceList.size() > 0){
                GroupServiceName = GroupServiceList[0].Name;
                system.System.debug('============ RecordTypeIds' + GroupServiceName);
            }
            */

            /* tutup dulu, tidak diperlukan
            //-- Get Groyup Service Map
            set<String> groupServiceNames = new Set<String>();
            for (EDA__c edaObj : edaList) {
                groupServiceNames.add(edaObj.Group_Service_Name__c);
            }

            //-- GET Group Services data -----------------------------------------
            List<Group_Service__c> groupServiceList =  
                                    [ SELECT ID, Name 
                                        FROM Group_Service__c 
                                        WHERE Name in :groupServiceNames
            ];
            //-- PUT NAME and SFID into the Map
            Map<String, String> groupServiceMap = new Map<String, String>();
            for (Group_Service__c obj : groupServiceList) {
                groupServiceMap.put(obj.Name.toUppercase(), obj.ID);
                system.debug('=== groupServiceMap : ' + groupServiceMap);

            }
			system.debug('=== groupServiceMap : ' + groupServiceMap);
            */

            /* get parent in SalesRevenueTriggerHandler (before insert)
            //-- 1. create parent first
            //-- create Sales-Performance Records and put the result into the map (to get the SFID)
            SalesPerformanceController salesPerformanceCtrl = new SalesPerformanceController();
            Map<String, Sales_Performance_Monthly_AMGS__c>  salesPerformanceMap = 
                salesPerformanceCtrl.createSalesPerformanceRecordsBasedOnEDAs (edaList) ; 
            system.debug('========= salesPerformanceMap :'+ salesPerformanceMap);
            */


            //-- 2. create child (sales-revenue)
            Id RecordType_EDAWaivingId = Schema.SObjectType.sales_revenue__c.getRecordTypeInfosByName().get('Forecast Waiving').getRecordTypeId();
            List<Sales_Revenue__c> forecastEDAWaivingList = new List <Sales_Revenue__c>();                                     
            for (EDA__c  edaWaivingObj : edaList) {

                
                Sales_Revenue__c srvObj =  new Sales_Revenue__c();

                if ( (SET_MARK_MODE_EDA == 'YES' || edaWaivingObj.Mode__c == 'Doing Mark as Revenue EDA Waiving Manually' )
                            && edaWaivingObj.EDA_Completion_Date__c != null) {
                        srvObj.Period_Date__c = edaWaivingObj.EDA_Completion_Date__c.addMonths(1);

                    } else {
                        srvObj.Period_Date__c = system.today().addMonths(1);
                } 


                Integer addingMonth = 1;
                Date tempDate = srvObj.Period_Date__c ; // --- system.today(); //edaWaivingObj.EDA_Completion_Date__c;
                
                Date newPeriodeDate = tempDate.addMonths(addingMonth);
                String years = string.valueOf(newPeriodeDate.year());
                String yearf = years.right(2);
                String months = string.valueOf(newPeriodeDate.month());
                String monthf = '0' + months;
                monthf = monthf.right(2);
                
                Sales_Performance_Monthly_AMGS__c sprObj =  new Sales_Performance_Monthly_AMGS__c(); 
                srvObj.unique_id__c = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                            yearf +  monthf + '_' + edaWaivingObj.AM_Employee_Id__c + '_'  + 
                            edaWaivingObj.Group_Service_Name__c + '_' + 
                            'Waiving' + '_' + edaWaivingObj.eda_number__c ;
                
                if (srvObj.unique_id__c.length () > 80)
                    srvObj.Name = srvObj.unique_id__c.left(75) + ' ...';
                else srvObj.Name = srvObj.unique_id__c;

                srvobj.RecordTypeId = RecordType_EDAWaivingId;
                String ownerid = edaWaivingObj.ownerid;
                srvObj.Amount__c = edaWaivingObj.Total_Value__c; 
                srvObj.AM__c = ownerid;
                //srvObj.Type__c = 'Waiving';
                srvObj.Type__c = 'Forecast Waiving';

                srvObj.Customer__c = edaWaivingObj.Related_Customer__c;
               // srvObj.Group_Service__c = groupServiceMap.get ( edaWaivingObj.Group_Service_Name__c.toUppercase());
                
                srvObj.Group_Service_Name__c = edaWaivingObj.Group_Service_Name__c;
                srvObj.Sales_Manager__c = edaWaivingObj.SM_SFID__c;
                srvObj.Group_Head__c = edaWaivingObj.GH_SFID__c;
                srvObj.Year__c = years;
                srvObj.Month__c = months;

                /* OLD WAY
                if (edaWaivingObj.EDA_Completion_Date__c <> null) {
                    srvObj.Period_Date__c = edaWaivingObj.EDA_Completion_Date__c.addMonths(1);
                }
                else {
                    srvObj.Period_Date__c = system.today().addMonths(1);
                } */

                


                //srvObj.Period_Date__c = edaWaivingObj.EDA_Completion_Date__c.addmonths(1);
                srvObj.EDA_Rel__c = edaWaivingObj.id;

                srvObj.AM_Employee_Id__c = edaWaivingObj.AM_Employee_Id__c;
            
                string salesPerformanceUniqeID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' + 
                                        yearf + monthf + '_' + edaWaivingObj.AM_Employee_Id__c + '_'  +  
                                        edaWaivingObj.Group_Service_Name__c
                                        ;
                system.System.debug('===== salesPerformanceUniqeID dapat ? ' + salesPerformanceUniqeID);

                /* -- tutup dulu
                Sales_Performance_Monthly_AMGS__c salesPerformanceOBJ = salesPerformanceMap.get( salesPerformanceUniqeID );
                system.debug('============= salesPerformanceOBJ : '+  salesPerformanceOBJ);
                  
                if (salesPerformanceOBJ <> null) { 
                    srvObj.Sales_Performance_Monthly_AMGS__c = salesPerformanceOBJ.id;
                    srvObj.group_service__c = salesPerformanceOBJ.Group_Service__c;
                    system.System.debug('=== salesPerformanceOBJ.id : ' + srvObj.Sales_Performance_Monthly_AMGS__c);
                    
                    //--todo: try to investigate: harusnya tidak perlu set kesini.
                    srvObj.Sales_Performance_Monthly_AMGS_SFID__c = srvObj.Sales_Performance_Monthly_AMGS__c;
                    srvObj.Sales_Performance_Monthly_AM__c = 'a1KN0000001lIetMAE';
                } else { 
                    //set to default 
                    //srvObj.Sales_Performance_Monthly_AMGS__c = 'a1AN0000002fmxy'; 
                    
                } */
                // ganti jadi ini :
                
                srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;
                srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID;
                
                
                //-- add sales-revenue object/record into the list
                forecastEDAWaivingList.add ( srvObj );
                system.debug('============ forecastEDAWaivingList' + forecastEDAWaivingList);
            }
        
            system.debug('============ forecastEDAWaivingList BEFORE UPSERT : ' + forecastEDAWaivingList);
            upsert forecastEDAWaivingList unique_id__c;
            system.debug('============ forecastEDAWaivingList AFTER UPSERT : ' + forecastEDAWaivingList);

            system.debug('======== masuk');
                    
        }
        catch (Exception e) {
            string notes = 'Error on SalesRevenueController.addForecastWaivingData method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  edaWaivingIDs; apputils.puterror(errorMsg);system.debug ('===== errorMsg : ' + errorMsg);
        }
        
    }


    public static void deletedForecastWaivingData (List<EDA__c> edaWaivingList){
        system.debug('================== in SalesRevenueController.deletedForecastWaivingData');
        //public void  addPipelineData( Set<ID> opptyIDS  ) {
        
        //string relatedSFIDs = '';
        //String opporid = '';
        //Set<String> opportunityIDS = new Set<String>();
        string edaWaivingSFIDs = '';
        string errorMsg = '';
        Set<String> edaWaivingIDs = new Set<String>();

               // List<RecordType> RecordTypeList= [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType where sobjectType = 'Sales_revenue__c' and developername = 'forecast_waiving'];
        
        try {
            
            for (EDA__c edaWaivingObj : edaWaivingList) {
                edaWaivingSFIDs =  edaWaivingSFIDs + edaWaivingObj.Id + ' ';
            }
            
            // get opportunity id
            
            for ( EDA__c newEdaWaivingObj : edaWaivingList) {
                edaWaivingIDs.add(newEdaWaivingObj.id);
            }
            system.System.debug('============== edaWaivingIDs' +edaWaivingIDs);

            List<EDA__c> edaClosedList = [ SELECT Id, OwnerId, EDA_Completion_Date__c, Total_Value__c FROM EDA__c WHERE 
                                                      Id IN : edaWaivingIDs and Document_Type__c = 'iom' and IOM_Type__c = 'waiving'];
            
            system.debug('============= edaClosedList query check : ' + edaClosedList);

            List<Sales_Revenue__c> salesRevenueWaivingList = [select id from Sales_Revenue__c where 
                                                                EDA_Rel__c in :edaClosedList and recordtype.name = 'Forecast Waiving'];

            system.debug('======== salesRevenueList pending reccuring query disini' + salesRevenueWaivingList);

            //--  deleted sales-revenue)          

            delete salesRevenueWaivingList;
            system.debug('== deleted salesRevenueWaivingList disini' + salesRevenueWaivingList);
                      
        }

        catch (Exception e) {
            string notes = 'Error on SalesRevenueController.deletedForecastWaivingData method'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  edaWaivingSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

    public static Integer addNewLinkMultiplierData(String UOMBWAfter, Double CapacityAfter) {
        Integer newLinkMultiplier = 0;
        List<GrossAddLinkMultiPlierSettings__c> MultiPlierSettingList = GrossAddLinkMultiPlierSettings__c.getAll().values();
		list<String> UOMBWList = new list<String>();
        Map<String,List<String>> UOMBWMap = new Map<String,List<String>>();
		list<String> NameSettingList = new list<String>();
        for(GrossAddLinkMultiPlierSettings__c MultiPlierSettingRec :MultiPlierSettingList){
            UOMBWList.add(MultiPlierSettingRec.Uom_BW_After__c);
        }
         
 		set<String> UOMBWSet = new set<String>(UOMBWList);
        for(String UOMBWAfterRec : UOMBWSet){
            for(GrossAddLinkMultiPlierSettings__c row :MultiPlierSettingList){
                if(UOMBWAfterRec == row.Uom_BW_After__c){
                   nameSettingList.add(row.Name);
                }
                UOMBWMap.put(UOMBWAfterRec, nameSettingList);
            }
           
            if(UOMBWAfter == UOMBWAfterRec){
                system.debug('UOMBW-->' + UOMBWAfterRec);
                 for(String UOMBWMapRec : UOMBWMap.get(UOMBWAfterRec)){
                    system.debug('Name -->' + UOMBWMapRec);
                    GrossAddLinkMultiPlierSettings__c MultiPlierSetting = GrossAddLinkMultiPlierSettings__c.getValues(UOMBWMapRec);
                    
                    if(CapacityAfter > MultiPlierSetting.Interval_Min__c && CapacityAfter <= MultiPlierSetting.Interval_Max__c){
                        newLinkMultiplier = Integer.valueOf(MultiPlierSetting.Propose__c);
                        system.debug('newLinkMultiplier-->' + newLinkMultiplier);
                        break;
                    }
                }   
            }
        }
        return newLinkMultiplier;
    }

    public static void addNewLinkData (List <Opportunity> newLinkOppportunityTobeAddList) {
        system.debug('================== in SalesRevenueController.addNewLinkData');
        
        
        string relatedSFIDs = '';
        string errorMsg = '';
        String opporid = '';
        Set<String> opportunityIDS = new Set<String>();
        List<Sales_Revenue__c>   addLinkSRVList = new List<Sales_Revenue__c>();

        try {
            
            /* dibuatkan oleh triger before insert
            //-- 1. create parent first
            //-- create Sales-Performance Records and put the result into the map (to get the SFID)
            SalesPerformanceController salesPerformanceCtrl = new SalesPerformanceController();
            Map<String, Sales_Performance_Monthly_AMGS__c>  salesPerformanceMap = salesPerformanceCtrl.createSalesPerformanceRecordsBasedOnNewLinkOpportunities (newLinkOppportunityTobeAddList) ; 
            system.debug('========= salesPerformanceMap :'+ salesPerformanceMap);
            */
        
            //-- 2. create child (sales-revenue)
            string recordTypeName = 'Link Gross Add';
            Id linkGrossAddRecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            system.System.debug('======= recordTypeList'+ linkGrossAddRecordTypeId); 
            
            string AMEmployeeID;
            string BPNo;
            string linkServiceTypeName;

            for (Opportunity opptyObj : newLinkOppportunityTobeAddList) {
                relatedSFIDs = relatedSFIDs + ' ' + opptyObj;


                Sales_Revenue__c srvObj =  new Sales_Revenue__c();
                
                String years = string.valueOf(opptyObj.Actual_Closed_Date__c.year());
                String yearf = years.right(2);
                String months = string.valueOf(opptyObj.Actual_Closed_Date__c.MONTH());
                String monthf = ('0' + months).right(2);

                AMEmployeeID = opptyObj.Owner_NIK__c;
                BPNo = opptyObj.Account_BP_No__c;
                linkServiceTypeName = opptyObj.Link_Service_Type__c;

                Sales_Performance_Monthly_AMGS__c sprObj =  new Sales_Performance_Monthly_AMGS__c();                 
                srvObj.Type__c = recordTypeName;
                srvObj.Year__c = years;
                srvObj.Month__c = months;
                srvObj.Period_Date__c = opptyObj.Actual_Closed_Date__c;

                srvObj.RecordTypeId = linkGrossAddRecordTypeId;
                srvObj.AM__c = opptyObj.ownerid;        
                srvObj.AM_Employee_ID__c = AMEmployeeID;
                srvObj.Link_service_type__c = linkServiceTypeName;

                srvObj.Customer_BP_no__c = BPNo;
                srvObj.customer__c = opptyObj.AccountID;
                
                /*
                srvObj.Sales_Manager__c = oliObj.SM_SF_ID__c;
                srvObj.Group_Head__c = oliObj.GH_SF_ID__c; 
                */
            
                Double BWAfter = Double.valueOf(opptyObj.BW_after__c);
                
                Decimal QtyMultiplier = Decimal.valueOf(addNewLinkMultiplierData(opptyObj.Uom_BW_After__c,BWAfter));
                srvObj.quantity__c = 1;

                srvObj.Quantity_Multiplier__c = QtyMultiplier;
                
                srvObj.unique_id__c = SALES_REVENUE_PREFIX_UNIQUEID + '_' 
                                + yearf + monthf + '_' 
                                + AMEmployeeID + '_'  
                                + BPNo + '_'
                                + linkServiceTypeName + '_'
                                + 'LinkGrossAdd' + '_'
                                + opptyObj.opportunity_id__c;


                if (srvObj.unique_id__c.length() > 80) {
                    srvObj.name =  srvObj.unique_id__c.left(75) + ' ...';
                } else srvObj.name =  srvObj.unique_id__c;
                

                srvObj.Opportunity_Rel__c = opptyObj.id;

                /*
                //-- related the Sales-Revenue record to the Sales-Performance (parent) record.
                string salesPerformanceUniqeID = 'SPR' + '_' + yearf + monthf + '_' + oliObj.AM_Employee_ID__c + 
                                                    '_'  + oliObj.Group_Service_Name__c;
                
                Sales_Performance_Monthly_AMGS__c salesPerformanceOBJ = salesPerformanceMap.get( salesPerformanceUniqeID ) ;
                
                system.debug('============= salesPerformanceUniqeID : '+  salesPerformanceUniqeID);
                
                if (salesPerformanceOBJ <> null) { 
                    srvObj.Sales_Performance_Monthly_AMGS__c = salesPerformanceOBJ.id;
                }
                */

                //-- add sales-revenue object/record into the list
                system.debug('============ srvObj' + srvObj);
                addLinkSRVList.add ( srvObj );
            }
            
            //-- insert data to database
            system.debug('======== addLinkSRVList' + addLinkSRVList);
            upsert addLinkSRVList unique_id__c;
            

            List<Opportunity> opptyList = new List <Opportunity>();
            for (Sales_Revenue__c salesRevenueObj: addLinkSRVList){
                Opportunity tempOpptyOBJ = new Opportunity();
                tempOpptyOBJ.id = salesRevenueObj.Opportunity_Rel__c;
                system.System.debug('======== salesRevenueObj : '+salesRevenueObj);
               
                tempOpptyOBJ.sales_revenue_rel__c = salesRevenueObj.id;
                system.System.debug('========= tempOpptyOBJ.sales_revenue_rel__c : ' + tempOpptyOBJ.sales_revenue_rel__c);
                opptyList.add (tempOpptyOBJ);
            }

            update opptyList;
            system.System.debug('======= opptyList : ' + opptyList);            
        
        }
        catch (Exception e) {
            string notes = 'Error on SalesRevenueController.addNewLinkData method'; 
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; 
            integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; 
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }


    }


    public static void deleteNewLinkData ( Set<ID> opptyTobeDeleteIDs) {
        system.debug('================== in SalesRevenueController.deleteNewLinkData');
        
        string relatedSFIDs = '';
        string errorMsg = '';
        String opporid = '';
        
        try {
            Set<String> idStrs = (Set<String>)JSON.deserialize(JSON.serialize(opptyTobeDeleteIDs), Set<String>.class);
			relatedSFIDs =  String.join(new List<String>(idStrs), ',');

			system.System.debug('====== relatedSFIDs '+ relatedSFIDs);

            List<Sales_revenue__c> srvTobeDelete = [select id 
                                                        from Sales_Revenue__c 
                                                        where Opportunity_Rel__c in :opptyTobeDeleteIDs];
            
             delete  srvTobeDelete;
        
        }
        catch (Exception e) {string notes = 'Error on SalesRevenueController.deleteNewLinkData method'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }


    public static void addTerminationBAPData (List <BAP__c> bapTobeAddList) {
        system.debug('================== in SalesRevenueController.addTerminationBAPData');
        
        
        string relatedSFIDs = '';
        string errorMsg = '';

        List<Sales_Revenue__c>   churnLinkSRVList = new List<Sales_Revenue__c>();

        try {
            
            /* dibuatkan oleh triger before insert
            //-- 1. create parent first
            //-- create Sales-Performance Records and put the result into the map (to get the SFID)
            SalesPerformanceController salesPerformanceCtrl = new SalesPerformanceController();
            Map<String, Sales_Performance_Monthly_AMGS__c>  salesPerformanceMap = salesPerformanceCtrl.createSalesPerformanceRecordsBasedOnNewLinkOpportunities (newLinkOppportunityTobeAddList) ; 
            system.debug('========= salesPerformanceMap :'+ salesPerformanceMap);
            */
        
            //-- 2. create child (sales-revenue)
            string recordTypeName = 'Link Churn';
            Id linkChurnRecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            system.System.debug('======= recordTypeList'+ linkChurnRecordTypeId); 
            
            string AMEmployeeID;
            string BPNo;
            string linkServiceTypeName;

            for (BAP__c bapObj : bapTobeAddList) {

                relatedSFIDs = relatedSFIDs + ' ' + bapObj.id;


                Sales_Revenue__c srvObj =  new Sales_Revenue__c();
                
                String years = string.valueOf(bapObj.Terminate_Date__c.year());
                String yearf = years.right(2);
                String months = string.valueOf(bapObj.Terminate_Date__c.MONTH());
                String monthf = ('0' + months).right(2);

                AMEmployeeID = bapObj.AM_EMployee_ID__c;
                BPNo = bapObj.Customer_BP_No__c;
                linkServiceTypeName = bapObj.Link_Service_Type__c;
       
                srvObj.Type__c = recordTypeName;
                srvObj.Year__c = years;
                srvObj.Month__c = months;
                srvObj.Period_Date__c = bapObj.Terminate_Date__c;

                srvObj.RecordTypeId = linkChurnRecordTypeId;      
                srvObj.AM_Employee_ID__c = AMEmployeeID;
                srvObj.Link_service_type__c = linkServiceTypeName;
                srvObj.Customer_BP_no__c = BPNo;
                srvObj.quantity__c = 1;  
                
                srvObj.unique_id__c = SALES_REVENUE_PREFIX_UNIQUEID + '_' 
                                + yearf + monthf + '_' 
                                + AMEmployeeID + '_'  
                                + BPNo + '_'
                                + linkServiceTypeName + '_'
                                + 'LinkChurn' + '_'
                                + bapObj.BAP_no__c;


                if (srvObj.unique_id__c.length() > 80) {
                    srvObj.name =  srvObj.unique_id__c.left(75) + ' ...'; 
                } else srvObj.name =  srvObj.unique_id__c;
                

                srvObj.BAP_Rel__c = bapObj.id;

                /*
                //-- related the Sales-Revenue record to the Sales-Performance (parent) record.
                string salesPerformanceUniqeID = 'SPR' + '_' + yearf + monthf + '_' + oliObj.AM_Employee_ID__c + 
                                                    '_'  + oliObj.Group_Service_Name__c;
                
                Sales_Performance_Monthly_AMGS__c salesPerformanceOBJ = salesPerformanceMap.get( salesPerformanceUniqeID ) ;
                
                system.debug('============= salesPerformanceUniqeID : '+  salesPerformanceUniqeID);
                
                if (salesPerformanceOBJ <> null) { 
                    srvObj.Sales_Performance_Monthly_AMGS__c = salesPerformanceOBJ.id;
                }
                */

                //-- add sales-revenue object/record into the list
                system.debug('============ srvObj' + srvObj);
                churnLinkSRVList.add ( srvObj );
            }
            
            //-- insert data to database
            system.debug('======== churnLinkSRVList' + churnLinkSRVList);
            upsert churnLinkSRVList unique_id__c;


            List<BAP__c> bapList = new List <BAP__c>();
            for (Sales_Revenue__c salesRevenueObj: churnLinkSRVList){
                BAP__c tempBAPOBJ = new BAP__c();
                tempBAPOBJ.id = salesRevenueObj.BAP_Rel__c;
                system.System.debug('======== salesRevenueObj : '+salesRevenueObj);
               
                tempBAPOBJ.sales_revenue_rel__c = salesRevenueObj.id;
                system.System.debug('========= tempBAPOBJ.sales_revenue_rel__c : ' + tempBAPOBJ.sales_revenue_rel__c);
                bapList.add (tempBAPOBJ);
            }

            update bapList;
            system.System.debug('======= bapList : ' + bapList);            
        
        }
        catch (Exception e) {string notes = 'Error on SalesRevenueController.addTerminationBAPData method'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }

    public static void deleteTerminationBAPData ( Set<ID> bapTobeDeleteIDs) {
        system.debug('================== in SalesRevenueController.deleteTerminationBAPData');
        
        string relatedSFIDs = '';
        string errorMsg = '';
        
        try {
            Set<String> idStrs = (Set<String>)JSON.deserialize(JSON.serialize(bapTobeDeleteIDs), Set<String>.class);
			relatedSFIDs =  String.join(new List<String>(idStrs), ',');

			system.System.debug('====== relatedSFIDs '+ relatedSFIDs);

            List<Sales_revenue__c> srvTobeDelete = [select id 
                                                        from Sales_Revenue__c 
                                                        where BAP_Rel__c in :bapTobeDeleteIDs];
            
             delete  srvTobeDelete;
        
        }
        catch (Exception e) {string notes = 'Error on SalesRevenueController.deleteTerminationBAPData method'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }


	public static void setNewCustomer (Date periodDate) {
        String year ='2021';
		String month ='1';
		//Date periodDate = Date.NewInstance(integer.valueof(year), integer.valueof(month), 1);
		Date startDate = periodDate.addyears(-1);
		Date endDate = periodDate.adddays(-1);
		
		year = string.valueof(periodDate.year());
		month = string.valueof(periodDate.month());

		system.debug ('=== periodDate : ' + periodDate);
		system.debug ('=== year : ' + year);
		system.debug ('=== month : ' + month);
		
		// 1. get unique data (BP) ---
		list<sales_revenue__c> srvList = [
			select Customer__c , is_new_Customer_t__c, year__c, customer_bp_no__c 
			from sales_revenue__c
			where recordtype.name ='actual revenue'
				and month__c = :month
				and year__c = :year];
		
		Set<String> BPNos = new Set<String>();
		
		for (sales_revenue__c srvObj : srvList) {
			if (srvObj.customer_bp_no__c<> null && srvObj.customer_bp_no__c<> '')
				BPNos.add (srvObj.customer_bp_no__c);
        
                srvObj.is_new_Customer_t__c=true;
		}
        
        update srvList;

		system.debug ('=== BPNos : ' + BPNos);
		system.debug ('=== BPNos.size() : ' + BPNos.size());
		
        /*this function is not used
		// 2. get data in previous period
		list<sales_revenue__c> srvPrevList = [
			select Customer__c , is_new_Customer_t__c, year__c, customer_bp_no__c 
			from sales_revenue__c
			where recordtype.name ='actual revenue'
				and period_Date__c >= :startDate
				and period_Date__c <= :endDate
				and customer_bp_no__c in :BPNos

				];
		system.debug ('=== srvPrevList : ' + srvPrevList);

		// 3. mapping
		Map <String, String> bpOnPrevPeriodMap = new Map <String, String> ();
		for (sales_revenue__c srvObj : srvPrevList) {
			bpOnPrevPeriodMap.put(srvObj.customer_bp_no__c, 'ON previous');
		}
		system.debug ('=== bpOnPrevPeriodMap : ' + bpOnPrevPeriodMap);

		// 4. check 
		Map <String, String> bpNewCustomerMap = new Map <String, String> ();
		for (String bpNo : BPNos) {
			string onPrevious = bpOnPrevPeriodMap.get(bpNo);
			if (onPrevious == null ) {
				//-- ada
				bpNewCustomerMap.put (bpNo, 'New Customer');
			}
		}
		system.debug ('=== bpNewCustomerMap : ' + bpNewCustomerMap);
		
		// 5. tandai mana yang new customer atau bukan.
		for (sales_revenue__c srvObj : srvList) {
			string isNewCustomer = bpNewCustomerMap.get (srvObj.customer_bp_no__c);
			if ( isNewCustomer <> null ) {
				srvObj.is_new_Customer_T__c = true;
			}
			else {
				srvObj.is_new_Customer_T__c = false;
			}
		}

		system.debug ('=== srvList.size() : ' + srvList.size());
		system.debug ('=== srvList : ' + srvList);
		//update srvList ;
        */
        

		SetNewCustomerMonthly_Batch myBatchObject = new SetNewCustomerMonthly_Batch(BPNos, periodDate, srvList);
        Id batchId = Database.executeBatch(myBatchObject, 10000);
       

	}

	
    
}