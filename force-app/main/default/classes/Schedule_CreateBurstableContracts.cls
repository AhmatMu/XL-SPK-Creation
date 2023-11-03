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

global class Schedule_CreateBurstableContracts implements Schedulable {
    
    global void execute(SchedulableContext sc){
        
        List<String> billingRequestIdList = new List<String>();
        //todo : pastikan masuk
        //todo : pastikan masuk jika scheduler adalah H-1 dst 
        // List <Link__c> linkList = [ 
        //     SELECT Id, Name, Link_ID__c, Status_Link__c
        //         , Service_Type__c, UoM__c, Partner__c
        //         , Contract_Item_Rel__r.Start_Date__c
        //         , Contract_Item_Rel__r.End_Date__c 
        //     FROM Link__c 
        //     WHERE isBursable__c = 'TRUE' 
        //         AND Status_Link__c = 'IN_SERVICE' 
        //         AND Contract_Item_Rel__r.Start_Date__c <= TODAY    
        //         AND Contract_Item_Rel__r.End_Date__c >= TODAY                               
        // ];
        
        List <Billing_Request__c> billingRequestList = [SELECT Id, Month_Bills__c,Link__c FROM Billing_Request__c];
        system.debug ('=== billingRequestList.size() : ' + billingRequestList.size() );
        for (Billing_Request__c billingRequestRec : billingRequestList) {
            billingRequestIdList.add(billingRequestRec.id);
        }
        Batch_CreateBrustableContract batchObj = new Batch_CreateBrustableContract(billingRequestIdList);
        Database.executeBatch(batchObj, 10);
        
        /*
        For (Link__c linkRec : brustableLinkList ) {
            Contract_Services_v2 ContractServices = New Contract_services_v2();
            
            ContractServices.CreateBrustableContractsFromLink(linkRec.id);
            
        }
       */
        
    }

}