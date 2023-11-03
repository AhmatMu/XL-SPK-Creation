@isTest (seeAlldata=true)
private class SalesPerformanceWorkspaceControllerTEST {
    /*
    @testSetup static void setup() {
        //-- add custom setting
        list<Trigger_Controller__c> lstTriggerController=new list<Trigger_Controller__c>();
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesTargetTrigger', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesTargetTrigger.beforeInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesTargetTrigger.afterInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesTargetTrigger.beforeUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesTargetTrigger.afterUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesTargetTrigger.beforeDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesTargetTrigger.afterDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesTargetTrigger.undelete', Is_Active__c=true));

        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterInsert', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterUpdate', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.beforeDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.afterDelete', Is_Active__c=true));
        lstTriggerController.add(new Trigger_Controller__c(name= 'SalesRevenueTrigger.undelete', Is_Active__c=true));
        insert lstTriggerController;
    } */

    static testMethod void methodName(){
        
        
        
        //System.runAs(contextuser){
            List<Sales_Target__c> salesTargetList = new List<Sales_Target__c>();

            Sales_Target__c salesTargetObj = new Sales_Target__c();
            salesTargetObj.type__c = 'Target Revenue';
            salesTargetObj.month__c = '1';
            salesTargetObj.year__c = '2020';
            salesTargetObj.AM_Employee_ID__c = '90004036';
            salesTargetObj.group_service_name__c = 'IOT';
            salesTargetObj.amount__c = 10000000;
            salesTargetList.add (salesTargetObj);
    
            salesTargetObj = new Sales_Target__c();
            salesTargetObj.type__c = 'Target Pipeline';
            salesTargetObj.month__c = '1';
            salesTargetObj.year__c = '2020';
            salesTargetObj.AM_Employee_ID__c = '90004036';
            salesTargetObj.amount__c = 10000000;
            salesTargetList.add (salesTargetObj);
    
            salesTargetObj = new Sales_Target__c();
            salesTargetObj.type__c = 'Target Pipeline PO';
            salesTargetObj.month__c = '1';
            salesTargetObj.year__c = '2020';
            salesTargetObj.AM_Employee_ID__c = '90004036';
            salesTargetObj.amount__c = 10000000;
            salesTargetList.add (salesTargetObj);
    
    
            salesTargetObj = new Sales_Target__c();
            salesTargetObj.type__c = 'Target Revenue (Partnership)';
            salesTargetObj.month__c = '1';
            salesTargetObj.year__c = '2020';
            salesTargetObj.AM_Employee_ID__c = '90004036';
            salesTargetObj.amount__c = 10000000;
            salesTargetList.add (salesTargetObj);
    
    
    
            salesTargetObj = new Sales_Target__c();
            salesTargetObj.type__c = 'Target Add Link';
            salesTargetObj.month__c = '1';
            salesTargetObj.year__c = '2020';
            salesTargetObj.AM_Employee_ID__c = '90004036';
            salesTargetObj.quantity__c = 20;
            salesTargetList.add (salesTargetObj);
    
            salesTargetObj = new Sales_Target__c();
            salesTargetObj.type__c = 'Target Add Subscribe';
            salesTargetObj.month__c = '1';
            salesTargetObj.year__c = '2020';
            salesTargetObj.AM_Employee_ID__c = '90004036';
            salesTargetObj.Subscription_type__c = 'postpaid';
            salesTargetObj.quantity__c = 20;
            salesTargetList.add (salesTargetObj);
            insert salesTargetList;
            //---


            List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        
            Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Actual Revenue';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.revenue_category_name__c = 'VOIP';
            salesRevenueObj.customer_bp_no__c = '755957';
            salesRevenueObj.amount__c = 10000000;
            salesRevenueList.add (salesRevenueObj);

            /*
            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Forecast Revenue Recurring';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.revenue_category_name__c = 'VOIP';
            salesRevenueObj.customer_bp_no__c = '755957';
            salesRevenueObj.amount__c = 10000000;
            salesRevenueList.add (salesRevenueObj);

            
            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Forecast Revenue Pending Recurring';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.group_service_name__c = 'IOT';
            salesRevenueObj.amount__c = 10000000;
            salesRevenueList.add (salesRevenueObj);

            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Forecast Waiving';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.group_service_name__c = 'IOT';
            salesRevenueObj.amount__c = 10000000;
            salesRevenueList.add (salesRevenueObj);

            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Opportunity Product';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.group_service_name__c = 'IOT';
            salesRevenueObj.amount__c = 10000000;
            salesRevenueList.add (salesRevenueObj);


            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Link Churn';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.customer_bp_no__c = '755957';
            salesRevenueObj.link_service_type__c = 'Digital Reward';
            salesRevenueObj.quantity__c = 20;
            salesRevenueList.add (salesRevenueObj);

            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Link Gross Add';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.customer_bp_no__c = '755957';
            salesRevenueObj.link_service_type__c = 'Digital Reward';
            salesRevenueObj.quantity__c = 30;
            salesRevenueList.add (salesRevenueObj);

            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Subscribe Churn';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.customer_bp_no__c = '755957';
            salesRevenueObj.subscription_type__c = 'Postpaid';
            salesRevenueObj.service__c = 'M2M';
            salesRevenueObj.group_price_plan__c = 'BIZ';
            salesRevenueObj.quantity__c = 40;
            salesRevenueList.add (salesRevenueObj);

            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Subscribe Gross Add';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.AM_Employee_ID__c = '90004036';
            salesRevenueObj.customer_bp_no__c = '755957';
            salesRevenueObj.subscription_type__c = 'Postpaid';
            salesRevenueObj.service__c = 'M2M';
            salesRevenueObj.group_price_plan__c = 'BIZ';
            salesRevenueObj.quantity__c = 40;
            salesRevenueList.add (salesRevenueObj);


            
            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Actual Revenue M-Ads Enterprise';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.amount__c = 1000000;
            salesRevenueList.add (salesRevenueObj);

            salesRevenueObj = new Sales_Revenue__c();
            salesRevenueObj.type__c = 'Actual Revenue M-Ads ADAI';
            salesRevenueObj.month__c = '1';
            salesRevenueObj.year__c = '2020';
            salesRevenueObj.amount__c = 2000000;
            salesRevenueList.add (salesRevenueObj);
            */

            insert salesRevenueList;
            //----

            Sales_Performance_Workspace__c sprWObj = new Sales_Performance_Workspace__c();
            sprWObj.quarter__c = 'Q1';
            sprWObj.year__c = '2020';
            sprWObj.name = '2020 Q1';
            insert sprWObj;
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(sprWObj);
            SalesPerformanceWorkspaceController salesPerformanceWorkspaceControllerObj = new SalesPerformanceWorkspaceController(sc); //Instantiate the Class
        
            salesPerformanceWorkspaceControllerObj.setRelatedData();
            salesPerformanceWorkspaceControllerObj.init();
            salesPerformanceWorkspaceControllerObj.setAdjustmentFormulaStatus();
            salesPerformanceWorkspaceControllerObj.showSummaryInformation(sprWObj.quarter__c, sprWObj.year__c);
            
            salesPerformanceWorkspaceControllerObj.generateFormulaFromTemplate();
            salesPerformanceWorkspaceControllerObj.generateRevenueRecurring();

            
            
        //}
        Test.stopTest();
        
    } 
}