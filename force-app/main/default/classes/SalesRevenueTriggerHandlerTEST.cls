@isTest(seealldata=true)
private class SalesRevenueTriggerHandlerTEST {
    /*
    @testSetup static void setup() {
        //-- add custom setting
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
    }*/

    static testMethod void actualRevenue() { 

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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


        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Actual Revenue';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.revenue_category_name__c = 'postpaid';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.customer_bp_no__c = '759581';
        srvObj.Amount__c = 1000000;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID ; //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();
    }

    static testMethod void forecastRevenueRecurring() {

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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


        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Forecast Revenue Recurring';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.revenue_category_name__c = 'postpaid';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.customer_bp_no__c = '759581';
        srvObj.Amount__c = 1000000;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();
    }

    static testMethod void forecastRevenuePendingRecurring() {

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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


        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Forecast Revenue Pending Recurring';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.group_service_name__c = 'Connectivity Fixed';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.Amount__c = 1000000;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();  
    }

    static testMethod void forecastWaiving() {

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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

        
        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Forecast Waiving';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.group_service_name__c = 'Fixed';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.Amount__c = 1000000;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;  //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID;   //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();  
    }

    static testMethod void opportunityProduct() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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

        //-- todo : try to use the scenario : create opportunity
        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Opportunity Product';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.customer_bp_no__c = '751687';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.link_service_type__c = '4GAccess';
        srvObj.amount__c = 1000000;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;  //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID;  //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();        
    }

    static testMethod void linkChurn() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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

        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Link Churn';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.customer_bp_no__c = '751687';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.link_service_type__c = '4GAccess';
        srvObj.quantity__c = 1;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;  //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; ///'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();    
    }

    static testMethod void linkGrossAdd() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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

        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Link Gross Add';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.customer_bp_no__c = '751687';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.link_service_type__c = '4GAccess';
        srvObj.quantity__C = 1;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;   ///'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID;   //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();    
    }

    static testMethod void subscribeChurn() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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

        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Subscribe Churn';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.subscription_type__C = 'postpaid';
        srvObj.service__c = 'M2M';
        srvObj.quantity__c = 1;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;   //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();   
    }
    static testMethod void subscribeGrossAdd() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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


        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Subscribe Gross Add';
        srvObj.month__c = '1';
        srvObj.year__c = '2021';
        srvObj.AM_Employee_ID__C = '90003799'; 
        srvObj.subscription_type__C = 'postpaid';
        srvObj.service__c = 'M2M';
        srvObj.quantity__c = 2;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;   //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c =  SPR_MONTHLY_AM_DEFAULT_SFID; ///'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();   
    }

    static testMethod void subscribeSMGrossAdd() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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


        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Subscribe Gross Add';
        srvObj.month__c = '1';
        srvObj.year__c = '2019';
        srvObj.Sales_manager_Employee_ID__C = '90003799'; 
        srvObj.subscription_type__C = 'postpaid';
        srvObj.service__c = 'M2M';
        srvObj.quantity__c = 2;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;   //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c =  SPR_MONTHLY_AM_DEFAULT_SFID; ///'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();   
    }

    static testMethod void subscribeGHGrossAdd() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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


        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Subscribe Gross Add';
        srvObj.month__c = '1';
        srvObj.year__c = '2019';
        srvObj.Group_Head_Employee_ID__C = '90003799'; 
        srvObj.subscription_type__C = 'postpaid';
        srvObj.service__c = 'M2M';
        srvObj.quantity__c = 2;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;   //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c =  SPR_MONTHLY_AM_DEFAULT_SFID; ///'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();   
    }

    static testMethod void actualRevenueMAdsEnterprise() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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

        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Actual Revenue M-Ads Enterprise';
        srvObj.month__c = '1';
        srvObj.year__c = '2019';
        srvObj.amount__c = 1000000;
        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;   //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c =  SPR_MONTHLY_AM_DEFAULT_SFID;  //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();   
    }

    static testMethod void actualRevenueMAdsADAI() {
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
        String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
        String SPR_MONTHLY_AM_DEFAULT_SFID = null;
        String SPR_MONTHLY_DEFAULT_SFID = null;
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

        Sales_Revenue__c srvObj = new Sales_Revenue__c();
        srvObj.type__c = 'Actual Revenue M-Ads ADAI';
        srvObj.month__c = '1';
        srvObj.year__c = '2019';
        srvObj.amount__c = 1000000;

        srvObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;  //'a1AN0000002fmxy'; //--todo: change to custom label
        srvObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; ///'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert srvObj;
            delete srvObj;
            undelete srvObj;
        test.stoptest();       
    }
}