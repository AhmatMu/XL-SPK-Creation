/**
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 * This schedule run every day
 * do call menthod salesracingcontroller.generateAMtopList
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 * @author         Ahmat
 * @modifiedBy     ...
 * @maintainedBy   ...
 * @version        1.0
 * @created        2021-06-25
 * @modified       YYYY-MM-DD
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 * @changes
 * vX.X            ...
 * YYYY-MM-DD      ...
 *
 */


global class Schedule_SalesRacingController implements Schedulable{
    
public SalesRacingController srcController {get;set;}


	  global void execute(SchedulableContext sc) {


        List<Sales_Racing__c> salesRacingObj = [SELECT Id, OwnerId, Name, Data_Source__c, Period_End_Date__c, Period_Start_Date__c, 
                                                    Racing_ID__c, Sales_Racing_Report_Path__c, Report_Link__c, Group_services__c, 
                                                    Group_Price_Plans__c, Product_Name__c, Revenue_Category__c, Service__c, Link_Service_Type__c, 
                                                    Stages__c, IsActive__c, all_product__c, Contract_Ticket_Status__c
                                                    FROM Sales_Racing__c WHERE IsActive__c = true
                                                    and Period_Start_Date__c <= today and Period_End_Date__c >= today 
                                                    ];

        system.debug('salesRacingObj size = ' + salesRacingObj.size());
        for(Sales_Racing__c srcObj : salesRacingObj){
            SalesRacingController srcController = new SalesRacingController(srcObj);
		    
            srcController.generateAMTopList();
            srcController.saveAMTopList();
        }    
        
          
     }
}