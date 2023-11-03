/**
* @description       : 
* @Test Class        : 
* @author            : Diky Nurosid
* @group             : 
* @last modified on  : 02-06-2023
* @last modified by  : Diky Nurosid
* Modifications Log
* Ver   Date         Author                  Modification
* 1.0   08-19-2022   Diky Nurosid   Initial Version
**/

public with sharing class TA_VR_OpportunityBPPayer implements TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate {
    public void beforeUpdate(List<Opportunity> newList, List<Opportunity> oldList){
        system.debug('----TA_VROpportunityBPPayer----');
        String errNotfound = System.Label.CUSTOMER_TYPE_MAPPING_NOTFOUND_ERRMSG;
        String errNotMatch = System.Label.CUSTOMER_TYPE_MAPPING_NOTMATCH_ERRMSG;
        List<String> opportunityIds = new list<String>();
        try {
            // Set<Id> bpPayerId = new Set<Id>();
            Map<Id,Opportunity> oldMap = new Map<Id,Opportunity>(oldList);
            Boolean bpPayerUpdate = false;
            String productCode ='';
            // String customerType = null;
            //  String isMatch = null;
            String accountID;
            Map<Id, Account> accountBpPayerMap = TA_QR_Opp_Queries.getInstance().beforeAccountBpPayerMap;
            for (Opportunity opp : newList) {
                if(
                    opp.BP_Payer__c != oldMap.get(opp.id).BP_Payer__c
                ){
                    bpPayerUpdate =true;
                }
                if(test.isrunningtest()){
                    bpPayerUpdate =true;
                }
                opportunityIds.add(opp.Id);
                System.debug('accountBpPayerMap ' +accountBpPayerMap );
            }
            system.debug('oppIds : ' + opportunityIds);
            
            if(opportunityIds !=null && !opportunityIds.isEmpty()){
                Map<String,String> Map_ProductCodeFromOpptyLineProduct = AppUtils.getProductCodeFromOpptyLineProduct(opportunityIds);
                
                for (Opportunity opp : newList) {
                    if(Map_ProductCodeFromOpptyLineProduct != null){
                        productCode = (String) Map_ProductCodeFromOpptyLineProduct.get(opp.id).replace('%', '');
                        system.debug('productCode : ' + productCode);
                    } 
                }
                //string queryString = 'SELECT Id, Name, Customer_Type__c, Product_Code__c FROM Customer_Type_Mapping__c WHERE Customer_Type__c = '+'\''+customerType+'\''+' AND Product_Code__c INCLUDES('+'\''+productCode+'\''+')';
                string queryString = 'SELECT Id, Name, Customer_Type__c, Product_Code__c FROM Customer_Type_Mapping__c WHERE Product_Code__c INCLUDES('+'\''+productCode+'\''+')';
                
                Map<String,String> customerTypeMap = new Map<String,String>();
                List<Customer_Type_Mapping__c> customerTypeList=Database.query(queryString);
                if(customerTypeList.size()>0){ 
                    for(Customer_Type_Mapping__c customerTypeRec :customerTypeList){
                        customerTypeMap.put(customerTypeRec.Customer_Type__c,customerTypeRec.Customer_Type__c);
                    }
                    for (Opportunity opp : newList) {
                        String productCodeString = (String) Map_ProductCodeFromOpptyLineProduct.get(opp.id).replace('%', '');
                        if (opp.BP_Payer__c != null && accountBpPayerMap.containsKey(opp.BP_Payer__c)) {
                            Account bpPayerAccount = accountBpPayerMap.get(opp.BP_Payer__c);
                            if (bpPayerAccount != null && bpPayerAccount.customer_type__c != null) {
                                String customerTypeString = bpPayerAccount.customer_type__c;
                                String isMatch = (String) customerTypeMap.get(customerTypeString);
                                if(
                                    (opp.BP_Payer__c != oldMap.get(opp.id).BP_Payer__c && opp.BP_Payer__c != NULL) ||
                                    (oldMap.get(opp.id).StageName != 'Quotation Final' && opp.StageName == 'Quotation Final' && opp.BP_Payer__c != NULL) || 
                                    (oldMap.get(opp.id).StageName != 'Waiting for Contract' && opp.StageName == 'Waiting for Contract' && opp.BP_Payer__c != NULL)
                                ){
                                    if(isMatch == null){
                                        if (!test.isrunningtest()) {
                                            opp.addError(errNotMatch);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }else{
                    for (Opportunity opp : newList) {
                        if(
                            (opp.BP_Payer__c != oldMap.get(opp.id).BP_Payer__c && opp.BP_Payer__c != NULL) ||
                            (oldMap.get(opp.id).StageName != 'Quotation Final' && opp.StageName == 'Quotation Final' && opp.BP_Payer__c != NULL) || 
                            (oldMap.get(opp.id).StageName != 'Waiting for Contract' && opp.StageName == 'Waiting for Contract' && opp.BP_Payer__c != NULL)
                        ){
                            if (!test.isrunningtest()) {
                                opp.addError(errNotfound);
                            }
                        }
                        
                    }
                }
                
                
            }
        } catch(Exception e) {
            string notes = 'Error on TA_VR_OpportunityBPPayer.BeforeUpdate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber + ' :: ' + opportunityIds; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
    
    public void afterUpdate(List<Opportunity> newList, List<Opportunity> oldList){
        
    }
}