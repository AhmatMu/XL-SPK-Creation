/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 05-11-2023
 * @last modified by  : Diky Nurosid
**/
public with sharing class TA_AT_LinkProdCreationOnPRComplete implements TriggerAction.AfterUpdate {
    
    public void afterUpdate (list<SR_PR_Notification__c> newList, list<SR_PR_Notification__c> oldList) {
        system.debug('==== TA_AT_LinkProdCreationOnPRComplete.afterUpdate ====== ');
        string errorMsg;
        Map<Id,SR_PR_Notification__c> oldMap = new Map<Id,SR_PR_Notification__c>(oldList);
        List<Link_Product__c> linkProductList = new List<Link_Product__c>();
        List<Link__c> linkList = new List<Link__c>();
        List<Link_Product__c> linkProductExistList = new List<Link_Product__c>();
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
     //   try {
            Map<Id, Opportunity> opportunityProductMap = TA_QR_SRPR_Queries.getInstance().getOpportunityProductItem;
            System.debug('Opp Product==> '+opportunityProductMap);
            Map<Id, Link__c> linkProductMap = TA_QR_SRPR_Queries.getInstance().getLinkProductItem;
            for (SR_PR_Notification__c srprRec : newList) {
                Map<String,Id> productMap = new Map<String,Id>();
                Map<String,Id> productExistMap = new Map<String,Id>();
                
                if(srprRec.Status__c != oldMap.get(srprRec.id).Status__c && srprRec.Status__c == 'Complete'){
                    if(linkProductMap != null){
                        if (linkProductMap.containsKey(opportunityProductMap.get(srprRec.Opportunity__c).Link_Related__c)) {
                            System.debug('masuk kondisi ==> ');
                            List<Link_Product__c> linkProductExsting = linkProductMap.get(opportunityProductMap.get(srprRec.Opportunity__c).Link_Related__c).Link_Products__r;
                            if(!linkProductExsting.isEmpty()){
                                for(Link_Product__c linkProductRec : linkProductExsting){
                                    productExistMap.put(linkProductRec.Type__c,linkProductRec.Id);
                                }
                            }
                        }
                    }
                    
                    Link__c link = new Link__c();
                    Decimal capacityBefore = Decimal.valueOf(opportunityProductMap.get(srprRec.Opportunity__c).BW_Before__c);
                    Decimal capacityAfter = Decimal.valueOf(opportunityProductMap.get(srprRec.Opportunity__c).BW_After__c);
                    link.Id = opportunityProductMap.get(srprRec.Opportunity__c).Link_Related__c;
                    link.BP_Payer__c = opportunityProductMap.get(srprRec.Opportunity__c).BP_Payer__c;
                    link.BP_VAT__c = opportunityProductMap.get(srprRec.Opportunity__c).BP_VAT__c;
                    link.Account__c = opportunityProductMap.get(srprRec.Opportunity__c).AccountId;
                    link.SAP_Code__c = opportunityProductMap.get(srprRec.Opportunity__c).SAP_Code__c;
                    link.Capacity_Before__c = capacityBefore;
                    link.Capacity_After__c = capacityAfter;
                    link.Capacity_UoM_Before__c = opportunityProductMap.get(srprRec.Opportunity__c).Uom_BW_Before__c;
                    link.Capacity_UoM_After__c = opportunityProductMap.get(srprRec.Opportunity__c).Uom_BW_After__c;
                   
                    for (OpportunityLineItem oliRec :opportunityProductMap.get(srprRec.Opportunity__c).OpportunityLineItems) {
                        if(productExistMap.get(oliRec.Revenue_Type__c) != null){
                            Link_Product__c linkProductExist = new Link_Product__c();
                            linkProductExist.Id = productExistMap.get(oliRec.Revenue_Type__c);
                            linkProductExist.is_Last__c = false;
                            linkProductExistList.add(linkProductExist);
                        }
                        productMap.put(oliRec.Revenue_Type__c,oliRec.Product2Id);
                        Link_Product__c linkProduct = new Link_Product__c();
                        String nameLinkProduct =srprRec.Link_ID__c+'_'+oliRec.Product2.Name;
                       
                        linkProduct.Name =  nameLinkProduct.length() > 80  ? nameLinkProduct.left(80) + ' ...' : nameLinkProduct;
                        linkProduct.Link__c = opportunityProductMap.get(srprRec.Opportunity__c).Link_Related__c;
                        linkProduct.Product__c = oliRec.Product2Id;
                        linkProduct.Product_ID__c = oliRec.Opportunity_Product_ID__c;
                        linkProduct.Sales_Price__c = oliRec.UnitPrice;
                        linkProduct.Type__c = oliRec.Revenue_Type__c;
                        linkProduct.SAP_Code__c = oliRec.Product2.SAP_Code__c;
                        linkProduct.is_Last__c = true;
                        linkProductList.add(linkProduct);
                    }

                    if(productMap.get('Usage') != null){
                        link.isUsage__c = true;
                    }
                    
                    if(productMap.get('Burstable') != null){
                        link.isBurstable__c = true;
                    }
                   
                    link.Product_Usage_Name__c = productMap.get('Usage');
                    link.Product_Burstable_Name__c = productMap.get('Burstable');
                    link.Product_One_Time__c = productMap.get('One Time');
                    link.Product_Recurring__c = productMap.get('Recurring');

                    linkList.add(link);
                }
            }
            update linkProductExistList;
            insert linkProductList;
            update linkList;
            
        // }
        // catch (Exception e) {
        //     errorMsg ='Error on TA_AT_LinkProdCreationOnPRComplete After Update' +  e.getmessage() + ' - ' +e.getStacktraceString() + e.getLineNumber();
        //     apputils.puterror(errorMsg);
        //     SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        // }
    }
}