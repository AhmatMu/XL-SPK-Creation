/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 05-05-2023
 * @last modified by  : Diky Nurosid
**/
public with sharing class TA_AT_BillingReqCalculateSalesPrice implements TriggerAction.BeforeInsert{
    
    public void beforeInsert(List<Billing_Request__c> newList){
        System.debug('=========== TA_AT_CalculateSalesPriceBillingReq ============' );

        try {
            
            Map<String, Link__c> linkProductMap = TA_QR_BillingReq_Queries.getInstance().getlinkProductItem;
            System.debug('linkProductMap==> '+ linkProductMap);
            Map<String,Id> productMap = new Map<String,Id>();
            Map<Id,Decimal> productBandwidth = new Map<Id,Decimal>();
            Map<Id,Decimal> productSalesPrice = new Map<Id,Decimal>();
            Map<Id,String> productSAPCode = new Map<Id,String>();
          
            if (!linkProductMap.isEmpty()) {
                List<String> keysList = new List<String>(linkProductMap.keySet());
                System.debug('Id==> '+ keysList);
                String linkId = keysList[0];
                for (Billing_Request__c billingRequestRec : newList) {
                    Link__c link = linkProductMap.get(linkId);
                    if (link != null && link.Link_Products__r != null) {
                        System.debug('MASUK');
                        for (Link_Product__c linkProdRec : link.Link_Products__r) {
                            String chargeType = linkProdRec.Product__r.Revenue_Type__c;
                            productMap.put(chargeType, linkProdRec.Product__c);
                            productBandwidth.put(linkProdRec.Product__c, linkProdRec.Bandwidth__c);
                            productSalesPrice.put(linkProdRec.Product__c, linkProdRec.Sales_Price__c);
                            productSAPCode.put(linkProdRec.Product__c,linkProdRec.SAP_Code__c);
                        }
                    }
                }
       
                for (Billing_Request__c billingReqRec : newList) {
                    Link__c linkRec = linkProductMap.get(linkId);
                    System.debug('linkRec==> '+ linkRec);
                    String typeBillingRequest =null;
                    if(linkRec.isBurstable__c){
                        typeBillingRequest = 'Burstable';
                    }
                    if(linkRec.isUsage__c){
                        typeBillingRequest = 'Usage';
                    } 
                    billingReqRec.Type__c = typeBillingRequest;
                    billingReqRec.Account__c = linkRec.Account__c;
                
                    billingReqRec.Link__c = linkRec.Id;
                    Date period = billingReqRec.Period__c;
                    if (typeBillingRequest != null) {
                        Id product = productMap.get(typeBillingRequest);
                        if (product != null) {
                            Decimal salesPrice = productSalesPrice.get(product);
                            Decimal bandwidth = productBandwidth.get(product);
                            billingReqRec.SAP_Code__c = productSAPCode.get(product);
                            if (bandwidth != null && bandwidth > 0) {
                                Decimal unitPrice = salesPrice / bandwidth;
                                if (billingReqRec.Amount__c == null) {
                                    billingReqRec.Amount__c = Decimal.valueOf(billingReqRec.Usage__c) * unitPrice;
                                }
                            }
                        }
                    }
                }
            }

        } catch(Exception e) {
            string notes = 'Error on TA_AT_CalculateSalesPriceBillingReq.AfterUpdate method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);    
        }
    }
}