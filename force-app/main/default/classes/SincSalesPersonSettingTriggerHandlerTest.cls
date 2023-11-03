/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 05-11-2022
 * @last modified by  : Diky Nurosid
**/
@isTest
public class SincSalesPersonSettingTriggerHandlerTest {
     @IsTest
    static void testScenario1(){
        Trigger_Controller__c triggerControllerSetting = new Trigger_Controller__c();
        triggerControllerSetting.Name = 'SincSalesPersonSetting.beforeInsert';
        triggerControllerSetting.Is_Active__c = true;
        insert triggerControllerSetting;
        
        Trigger_Controller__c triggerControllerSetting2 = new Trigger_Controller__c();
        triggerControllerSetting2.Name = 'SincSalesPersonSetting.afterInsert';
        triggerControllerSetting2.Is_Active__c = true;
        insert triggerControllerSetting2;

        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        Sales_Incentive_Workspace__c incentiveobj = new Sales_Incentive_Workspace__c(
            Name = 'Sales Incentive Workspace for Q1 2022',                // Name
            Year__c = '2022',                                                // Year
            Quarter__c = 'Q1'                                              // Quarter
            );
        insert incentiveobj;
        SInc_Sales_Person_Setting__c Sincsobj = new SInc_Sales_Person_Setting__c(
            Name = 'SETT_PERSON_22Q1_90004358',                                                                                                                                                                       // SInc Sales Person Setting Name
            //Sales_Person__c = salesManagerobj.Id,                                                                                                                                                                              // Sales Person
            Employee_Id__c = '90004358',                                                                                                                                                                                // Employee Id
            Year__c = '2022',                                                                                                                                                                                           // Year
            unique_id__c = 'SETT_PERSON_22Q1_90004358',                                                                                                                                                                 // unique id
            Quarter__c = 'Q1',                                                                                                                                                                                          // Quarter
            Sales_Incentive_Workspace__c = incentiveobj.Id,                                                                                                                                                                 // Sales Incentive Workspace
            Revenue_Type__c = 'Revenue Total;New Revenue;Net-Adds Fixed Links;Gross-Adds Fixed Links;Partnership Revenue;Pipeline PO;Pipeline Total;Calculation;Pipeline New Revenue;Pipeline BAU;Partnership Number'  // Revenue Type
        );
       
        test.startTest();
        
        insert Sincsobj;
      //  delete Sincsobj;
      //  undelete Sincsobj;
       // insert collRateobj1;

        test.stopTest();
    }
}