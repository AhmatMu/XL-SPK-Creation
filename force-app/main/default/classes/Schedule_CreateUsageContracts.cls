/**
 * @description       : 
 * @Test Class		  :
 * @author            :
 * @group             : 
 * @last modified on  : 01-25-2023
 * @last modified by  : Diky Nurosid
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0  12-21-22   Muhammad Bustamil Adam     Initial Version
**/

global class Schedule_CreateUsageContracts implements Schedulable {
    
    global void execute(SchedulableContext sc){
        
        //list <Link__c> A = [ Select Id, Name, Link_ID__c, Status_Link__c, Service_Type__c, UoM__c, Partner__c From Link__c Where  Status_Link__c='IN_SERVICE' And Free_Link__c= True];
        List <Billing_Request__c> billingRequestList = [SELECT Id, Month_Bills__c,Link__c FROM Billing_Request__c];
        for (Billing_Request__c billingRec:billingRequestList) {
            Contract_Services_v2 ContractServices = New Contract_services_v2();
            ContractServices.CreateUsageContractsFromLink(billingRec.Link__c);
        }
       
        
    }

}