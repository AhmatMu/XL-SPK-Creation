@isTest
private class ForecastRevenueRecurring_BatchTEST {
    static testMethod void schenario1 () {
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

        Forecast_Recurring_Revenue_Formula__c sobj = new Forecast_Recurring_Revenue_Formula__c(
            Name = '2021_Q1_4G Access',                  // Name
            Year__c = '2021',                              // Year
            Active__c = true,                             // Active
            Quarter__c = 'Q3',                             // Quarter
            Revenue_Category__c = revenueCategory.Id,             // Revenue Category
            Total_Forecast__c = 0,                         // Total Forecast
            Total_Last_Month__c = 0,                       // Total Last Month
            Free_Formula__c = '[M-1]',
            Specific_Formula__c = '[M-1]',
            Churn__c = 0.1,
            Is_Template__c = false                        // Is Template
            );
        insert sobj;

        List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        
        Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue';
        salesRevenueObj.month__c = '6';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = '4G Access';
        salesRevenueObj.customer_bp_no__c = '755957';
        salesRevenueObj.amount__c = 10000000;
        salesRevenueObj.Revenue_Category__c = revenueCategory.Id;
        salesRevenueList.add (salesRevenueObj);

        insert salesRevenueList;

        
        Test.startTest();

        ForecastRevenueRecurring_Batch obj = new ForecastRevenueRecurring_Batch('7', '2021');
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}