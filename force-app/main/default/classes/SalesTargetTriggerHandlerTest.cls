@isTest(SeeAllData=true)
private class SalesTargetTriggerHandlerTest {
    /*
    public String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
    public String SPR_MONTHLY_AM_DEFAULT_SFID = null;
    public String SPR_MONTHLY_DEFAULT_SFID = null;
    */ 
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
        insert lstTriggerController;

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

    } */

    static testMethod void targetRevenue() {


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

        Sales_Target__c strObj = new Sales_Target__c();
        strObj.type__c = 'Target Revenue';
        strObj.month__c = '1';
        strObj.year__c = '2021';
        strObj.group_service_name__c = 'VOIP';
        strObj.AM_Employee_ID__C = '90003799';
        strObj.Amount__c = 1000000;

        strObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; // 'a1AN0000002fmxy'; //--todo: change to custom label
        strObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID ; // 'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert strObj;
            delete strObj;
            undelete strObj;
        test.stoptest();
    }

    static testMethod void targetPipeline() {

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

        Sales_Target__c strObj = new Sales_Target__c();
        strObj.type__c = 'Target Pipeline';
        strObj.month__c = '1';
        strObj.year__c = '2021';
        strObj.AM_Employee_ID__C = '90003799';
        strObj.Amount__c = 2000000;

        strObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        strObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert strObj;
            delete strObj;
            undelete strObj;
        test.stoptest();
    }

    static testMethod void targetPipelinePO() {


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


        Sales_Target__c strObj = new Sales_Target__c();
        strObj.type__c = 'Target Pipeline PO';
        strObj.month__c = '1';
        strObj.year__c = '2021';
        strObj.AM_Employee_ID__C = '90003799';
        strObj.Amount__c = 3000000;

        strObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        strObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIet'; //--todo: change to custom label
  
        test.starttest();
            insert strObj;
            delete strObj;
            undelete strObj;
        test.stoptest();
    }

    static testMethod void targetAddLink() {

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


        Sales_Target__c strObj = new Sales_Target__c();
        strObj.type__c = 'Target Add Link';
        strObj.month__c = '1';
        strObj.year__c = '2021';
        strObj.AM_Employee_ID__C = '90003799';
        strObj.quantity__c = 10;
        strObj.fcs_churn__c = 2;
        strObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; // 'a1AN0000002fmxy'; //--todo: change to custom label
        strObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; ///'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert strObj;
            delete strObj;
            undelete strObj;
        test.stoptest();
    }

    static testMethod void targetAddSubscribe() {

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


        Sales_Target__c strObj = new Sales_Target__c();
        strObj.type__c = 'Target Add Subscribe';
        strObj.month__c = '1';
        strObj.year__c = '2021';
        strObj.AM_Employee_ID__C = '90003799';
        strObj.subscription_type__c = 'Postpaid';
        strObj.quantity__c = 30;
        strObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        strObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert strObj;
            delete strObj;
            undelete strObj;
        test.stoptest();  
    }

    static testMethod void targetSMAddSubscribe() {

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


        Sales_Target__c strObj = new Sales_Target__c();
        strObj.type__c = 'Target Add Subscribe';
        strObj.month__c = '1';
        strObj.year__c = '2021';
        strObj.Sales_Manager_Employee_ID__C = '90003822';
        strObj.subscription_type__c = 'Postpaid';
        strObj.quantity__c = 30;
        strObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        strObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert strObj;
            delete strObj;
            undelete strObj;
        test.stoptest();  
    }

    static testMethod void targetGHAddSubscribe() {

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


        Sales_Target__c strObj = new Sales_Target__c();
        strObj.type__c = 'Target Add Subscribe';
        strObj.month__c = '1';
        strObj.year__c = '2021';
        strObj.group_head_Employee_ID__C = '90007879';
        strObj.subscription_type__c = 'Postpaid';
        strObj.quantity__c = 30;
        strObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        strObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert strObj;
            delete strObj;
            undelete strObj;
        test.stoptest();  
    }

    static testMethod void targetRevenuePartnership() {

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


        Sales_Target__c strObj = new Sales_Target__c();
        strObj.type__c = 'Target Revenue (Partnership)';
        strObj.month__c = '1';
        strObj.year__c = '2021';
        strObj.AM_Employee_ID__C = '90003799';
        strObj.quantity__c = 4000000;
        strObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy'; //--todo: change to custom label
        strObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; ///'a1KN0000001lIet'; //--todo: change to custom label

        test.starttest();
            insert strObj;
            delete strObj;
            undelete strObj;
        test.stoptest();  
    }
    
}