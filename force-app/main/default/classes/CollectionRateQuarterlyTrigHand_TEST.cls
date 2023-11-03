@IsTest

public class CollectionRateQuarterlyTrigHand_TEST {
    
    @IsTest
    static void testScenarioUsingBP(){

        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'sudi',                                                            // Alias
            Email = 'sudi@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'sudi@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
          //  ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003712',                                               // Employee ID
            firstName = 'sukosulistiyo',
            LastName='sudi'
        );
        insert salesManagerobj;


        Collection_Rate_Quarterly__c collRateobj = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q3_90003798',        // Name
            Quarter__c = 'Q3',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 1.00,                // Coll Ratio
            Employee_ID__c = '90003712',         // Employee ID
            Sales_Person__c = salesManagerobj.id       // Sales Person
            //Unique_ID__c = 'CRQ_21Q3_90003798'  // Unique ID
        );

        Collection_Rate_Quarterly__c collRateobj1 = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q3_90003798',        // Name
            Quarter__c = 'Q3',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 1.00,                // Coll Ratio
            Employee_ID__c = '90003712',         // Employee ID
            Sales_Person__c = salesManagerobj.id       // Sales Person
            //Unique_ID__c = 'CRQ_21Q3_90003798'  // Unique ID
        );
        test.startTest();
        
        insert collRateobj;
        delete collRateobj;
        undelete collRateobj;
        insert collRateobj1;

        test.stopTest();
    }

    @isTest
    static void testScenarioUsingemail(){

        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales']; 
        User salesManagerobj = new User(                                                 // Role
            Alias = 'sudi',                                                            // Alias
            Email = 'sudi@xl.co.id',                                                  // Email
            ProfileId = SMProfile.id,   
            EmailEncodingKey='UTF-8',
            Username = 'sudi@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
          //  ManagerId = groupHeadobj.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003712',                                               // Employee ID
            firstName = 'sukosulistiyo',
            LastName='sudi'
        );
        insert salesManagerobj;


        Collection_Rate_Quarterly__c collRateobj = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q3_90003798',        // Name
            Quarter__c = 'Q4',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 1.00,                // Coll Ratio
            sales_person_email__c = 'sudi@xl.co.id'        // Employee ID
           // Sales_Person__c = salesManagerobj.id       // Sales Person
            //Unique_ID__c = 'CRQ_21Q3_90003798'  // Unique ID
        );

        Collection_Rate_Quarterly__c collRateobj1 = new Collection_Rate_Quarterly__c(
            Name = 'CRQ_21Q3_90003798',        // Name
            Quarter__c = 'Q4',                   // Quarter
            Year__c = '2021',                    // Year
            Coll_Ratio__c = 1.00,                // Coll Ratio
            sales_person_email__c = 'sudi@xl.co.id'   // Employee ID
           // Sales_Person__c = salesManagerobj.id       // Sales Person
            //Unique_ID__c = 'CRQ_21Q3_90003798'  // Unique ID
        );
        test.startTest();
        
        insert collRateobj;
        delete collRateobj;
        undelete collRateobj;
        insert collRateobj1;

        test.stopTest();
    }
}