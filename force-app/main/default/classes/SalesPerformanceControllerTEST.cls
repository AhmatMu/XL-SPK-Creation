/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 05-25-2022
 * @last modified by  : Diky Nurosid
**/
@isTest(seealldata=false)
private class SalesPerformanceControllerTEST {

    @testSetup
    static void createUser(){
        
        UserRole urHead = [SELECT Id FROM UserRole WHERE Name='Head - Banking & Financial Services'];
        UserRole urSales = [SELECT Id FROM UserRole WHERE Name='Banking & Financial Services'];
        
        Profile GHprofiles = [SELECT Id FROM Profile WHERE Name='Sales Group Head']; 
        Profile SMProfile = [SELECT Id FROM Profile WHERE Name='Sales Manager']; 
        Profile AMProfile = [SELECT Id FROM Profile WHERE Name='Sales' limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User GHUser = new User(  
            Alias = 'ahmad',                                                              // Alias
            Email = 'ahmad@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = GHprofiles.id,                                                     // Profile
            Username = 'ahmad@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '900078723',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'ahmad',
            LastName='murti',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US');
        insert GHUser;
        
        User salesManagerUser = new User(  
            Alias = 'ngibrit',                                                            // Alias
            Email = 'ngibrit@xl.co.id',                                                  // Email
            EmailEncodingKey='UTF-8',
            Username = 'ngibrit@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = GHUser.id,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003712',                                               // Employee ID
            firstName = 'ngibrit',
            LastName='banget',
            ProfileId = SMProfile.Id,
            UserRoleId = urHead.id);
        insert salesManagerUser;
        User salesUser = new User(  firstname = 'Ahmat',
                                  lastName = 'Murad',
                                  email = uniqueName + '@test' + orgId + '.org',
                                  Username = uniqueName + '@test' + orgId + '.org',
                                  EmailEncodingKey = 'ISO-8859-1',
                                  Alias = uniqueName.substring(18, 23),
                                  TimeZoneSidKey = 'America/Los_Angeles',
                                  LocaleSidKey = 'en_US',
                                  Employee_ID__c = '90004036',
                                  ManagerId = salesManagerUser.id,
                                  LanguageLocaleKey = 'en_US',
                                  ProfileId = AMProfile.id,
                                  UserRoleId = urSales.Id);
        insert salesUser;
    }
    
    static testMethod void createSalesPerformanceRecordsBasedOnSalesTargetsAM() { 
        List<Sales_Target__c> salesTargetList = new List<Sales_Target__c>();
		 User sales = [SELECT Id, Employee_ID__c  FROM User WHERE firstname = 'Ahmat' AND lastName = 'Murad' Limit 1];
        User SM = [SELECT Id, Employee_ID__c FROM User WHERE username = 'ngibrit@xl.co.id' Limit 1];
        
        Sales_Target__c salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        salesTargetObj.group_service_name__c = 'IOT';
        salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        
        salesTargetObj.amount__c = 10000000;
        
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
          salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline PO';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        
        salesTargetList.add (salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue (Partnership)';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       
        salesTargetList.add(salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Link';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.quantity__c = 20;
       	salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Subscribe';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.Subscription_type__c = 'postpaid';
        salesTargetObj.quantity__c = 20;
        salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       
        salesTargetList.add (salesTargetObj);

        

        SalesPerformanceController sprController = new SalesPerformanceController();
        Map<String, String>  resultMap = sprController.createSalesPerformanceRecordsBasedOnSalesTargets(salesTargetList);
        

    }

    static testMethod void createSalesPerformanceRecordsBasedOnSalesTargetsSM() { 
        List<Sales_Target__c> salesTargetList = new List<Sales_Target__c>();
		 User sales = [SELECT Id, Employee_ID__c  FROM User WHERE firstname = 'Ahmat' AND lastName = 'Murad' Limit 1];
        User SM = [SELECT Id, Employee_ID__c FROM User WHERE username = 'ngibrit@xl.co.id' Limit 1];
        
        Sales_Target__c salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        salesTargetObj.group_service_name__c = 'IOT';
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetObj.amount__c = 10000000;
        
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
          salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline PO';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add (salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue (Partnership)';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add(salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Link';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.quantity__c = 20;
       	//salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Subscribe';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.Subscription_type__c = 'postpaid';
        salesTargetObj.quantity__c = 20;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        

        SalesPerformanceController sprController = new SalesPerformanceController();
        Map<String, String>  resultMap = sprController.createSalesPerformanceRecordsBasedOnSalesTargets(salesTargetList);
        

    }

    
    static testMethod void createSalesPerformanceRecordsBasedOnSalesTargetsSMNull() { 
        List<Sales_Target__c> salesTargetList = new List<Sales_Target__c>();
		 User sales = [SELECT Id, Employee_ID__c  FROM User WHERE firstname = 'Ahmat' AND lastName = 'Murad' Limit 1];
        User SM = [SELECT Id, Employee_ID__c FROM User WHERE username = 'ngibrit@xl.co.id' Limit 1];
        
        Sales_Target__c salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        salesTargetObj.group_service_name__c = 'IOT';
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        //salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetObj.amount__c = 10000000;
        
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
          salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline PO';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       // salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add (salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue (Partnership)';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       // salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add(salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Link';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.quantity__c = 20;
       	//salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       // salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Subscribe';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.Subscription_type__c = 'postpaid';
        salesTargetObj.quantity__c = 20;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        //salesTargetObj.Sales_Manager__c = SM.Id;
        salesTargetObj.Sales_Manager_Employee_ID__c =SM.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        

        SalesPerformanceController sprController = new SalesPerformanceController();
        Map<String, String>  resultMap = sprController.createSalesPerformanceRecordsBasedOnSalesTargets(salesTargetList);
        

    }

    
    static testMethod void createSalesPerformanceRecordsBasedOnSalesTargetsGH() { 
        List<Sales_Target__c> salesTargetList = new List<Sales_Target__c>();
		 User sales = [SELECT Id, Employee_ID__c  FROM User WHERE firstname = 'Ahmat' AND lastName = 'Murad' Limit 1];
        User GH = [SELECT Id, Employee_ID__c FROM User WHERE username = 'ahmad@xl.co.id' Limit 1];
        
        Sales_Target__c salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        salesTargetObj.group_service_name__c = 'IOT';
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetObj.amount__c = 10000000;
        
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
          salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
          salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline PO';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add (salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue (Partnership)';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add(salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Link';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.quantity__c = 20;
       	//salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
           salesTargetObj.Group_Head__c = GH.Id;
           salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Subscribe';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.Subscription_type__c = 'postpaid';
        salesTargetObj.quantity__c = 20;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
        salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        

        SalesPerformanceController sprController = new SalesPerformanceController();
        Map<String, String>  resultMap = sprController.createSalesPerformanceRecordsBasedOnSalesTargets(salesTargetList);
        

    }

    static testMethod void createSalesPerformanceRecordsBasedOnSalesTargetsGHNull() { 
        List<Sales_Target__c> salesTargetList = new List<Sales_Target__c>();
		 User sales = [SELECT Id, Employee_ID__c  FROM User WHERE firstname = 'Ahmat' AND lastName = 'Murad' Limit 1];
        User GH = [SELECT Id, Employee_ID__c FROM User WHERE username = 'ahmad@xl.co.id' Limit 1];
        
        Sales_Target__c salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        salesTargetObj.group_service_name__c = 'IOT';
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       // salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetObj.amount__c = 10000000;
        
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
          salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       //   salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Pipeline PO';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
     //   salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add (salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Revenue (Partnership)';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.amount__c = 10000000;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       // salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add(salesTargetObj);


        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Link';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.quantity__c = 20;
       	//salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       //    salesTargetObj.Group_Head__c = GH.Id;
           salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        salesTargetObj = new Sales_Target__c();
        salesTargetObj.type__c = 'Target Add Subscribe';
        salesTargetObj.month__c = '1';
        salesTargetObj.year__c = '2021';
        //salesTargetObj.AM_Employee_ID__c = '90004036';
        salesTargetObj.Subscription_type__c = 'postpaid';
        salesTargetObj.quantity__c = 20;
        //salesTargetObj.AM_Employee_ID__c = sales.Employee_ID__c;
       // salesTargetObj.Group_Head__c = GH.Id;
        salesTargetObj.Group_Head_Employee_ID__c = GH.Employee_ID__c;
        salesTargetList.add (salesTargetObj);

        

        SalesPerformanceController sprController = new SalesPerformanceController();
        Map<String, String>  resultMap = sprController.createSalesPerformanceRecordsBasedOnSalesTargets(salesTargetList);
        

    }

    static testMethod void createSalesPerformanceRecordsBasedOnSalesRevenues() { 
        List<Sales_Revenue__c> salesRevenueList = new List<Sales_Revenue__c>();
        
        Sales_Revenue__c salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = 'VOIP';
        salesRevenueObj.customer_bp_no__c = '755957';
        salesRevenueObj.amount__c = 10000000;
        salesRevenueList.add (salesRevenueObj);

        salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Forecast Revenue Recurring';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.revenue_category_name__c = 'VOIP';
        salesRevenueObj.customer_bp_no__c = '755957';
        salesRevenueObj.amount__c = 10000000;
        salesRevenueList.add (salesRevenueObj);

        salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Forecast Revenue Pending Recurring';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.group_service_name__c = 'IOT';
        salesRevenueObj.amount__c = 10000000;
        salesRevenueList.add (salesRevenueObj);

        salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Forecast Waiving';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.group_service_name__c = 'IOT';
        salesRevenueObj.amount__c = 10000000;
        salesRevenueList.add (salesRevenueObj);

        salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Opportunity Product';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.group_service_name__c = 'IOT';
        salesRevenueObj.amount__c = 10000000;
        salesRevenueList.add (salesRevenueObj);


        salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Link Churn';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.customer_bp_no__c = '755957';
        salesRevenueObj.link_service_type__c = 'Digital Reward';
        salesRevenueObj.quantity__c = 20;
        salesRevenueList.add (salesRevenueObj);

        salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Link Gross Add';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.AM_Employee_ID__c = '90004036';
        salesRevenueObj.customer_bp_no__c = '755957';
        salesRevenueObj.link_service_type__c = 'Digital Reward';
        salesRevenueObj.quantity__c = 30;
        salesRevenueList.add (salesRevenueObj);

        salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Subscribe Churn';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
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
        salesRevenueObj.year__c = '2021';
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
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.amount__c = 1000000;
        salesRevenueList.add (salesRevenueObj);

        salesRevenueObj = new Sales_Revenue__c();
        salesRevenueObj.type__c = 'Actual Revenue M-Ads ADAI';
        salesRevenueObj.month__c = '1';
        salesRevenueObj.year__c = '2021';
        salesRevenueObj.amount__c = 2000000;
        salesRevenueList.add (salesRevenueObj);


        SalesPerformanceController sprController = new SalesPerformanceController();
        Map<String, String>  resultMap = sprController.createSalesPerformanceRecordsBasedOnSalesRevenues(salesRevenueList);
    }


}