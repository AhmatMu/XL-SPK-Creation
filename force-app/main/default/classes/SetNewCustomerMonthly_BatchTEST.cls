@istest (seealldata=false)
private class SetNewCustomerMonthly_BatchTEST {
    static testMethod VOID schenario1() {
        String year ='2021';
		String month ='1';
		Date periodDate = Date.NewInstance(integer.valueof(year), integer.valueof(month), 1);
		Date startDate = periodDate.addyears(-1);
		Date endDate = periodDate.adddays(-1);
		
		year = string.valueof(periodDate.year());
		month = string.valueof(periodDate.month());

		system.debug ('=== periodDate : ' + periodDate);
		system.debug ('=== year : ' + year);
		system.debug ('=== month : ' + month);


		
		list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.undelete', Is_Active__c=true));
        insert lstTriggerController;

        Revenue_Category__c revenueCategory = new Revenue_Category__c();
        revenueCategory.Name = '4G Access';
        revenueCategory.Full_Name__c = '4G Access';
        Insert revenueCategory;

		Id newRecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get('Actual Revenue').getRecordTypeId();
        List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue';
		salesRevenueObj.recordtypeid = newRecordTypeId;
        salesRevenueObj.month__c = '11';
        salesRevenueObj.year__c = '2020';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = '4G Access';
        salesRevenueObj.customer_bp_no__c = '755957';
        salesRevenueObj.amount__c = 10000000;
        salesRevenueObj.Revenue_Category__c = revenueCategory.Id;
        salesRevenueList.add (salesRevenueObj);

        insert salesRevenueList;


		
		// 1. get unique data (BP) ---
		list<sales_revenue__c> srvList = [
			select Customer__c , is_new_Customer_t__c, year__c, customer_bp_no__c 
			from sales_revenue__c
			where type__c ='Actual Revenue'
				and month__c = '11'
				and year__c = '2020'];
		
		Set<String> BPNos = new Set<String>();
		
		for (sales_revenue__c srvObj : srvList) {
			if (srvObj.customer_bp_no__c<> null && srvObj.customer_bp_no__c<> '')
				BPNos.add (srvObj.customer_bp_no__c);
        
                srvObj.is_new_Customer_t__c=true;
		}
        update srvList;
		
		system.debug ('=== srvList : ' + srvList);

        
        Test.startTest();
            SetNewCustomerMonthly_Batch batchObj = new SetNewCustomerMonthly_Batch( BPNos, periodDate,  srvList);
            Id jobid= Database.executeBatch(batchObj, 200);
        Test.stopTest();
    }
}