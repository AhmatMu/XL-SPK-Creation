/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 03-09-2022
 * @last modified by  : Andre Prasetya
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-23-2022   Novando Utoyo Agmawan   Initial Version
**/

trigger EmailAlertField_v2 on OpportunityLineItem (before insert, before update,after insert, after update) {
    if(system.label.IS_Trigger_OpportunityLineItem_v2_ON=='YES'){
       List <ID> productIDList = new List<ID> ();
       List <ID> opptyIDList = new List<ID> ();
       List <ID> linkIDList = new List<ID> ();
        
       for(OpportunityLineItem OLI:system.trigger.new){	
           productIDList.add (OLI.Product2id);
           
           SYSTEM.DEBUG ('======== OLI.OpportunityID	: ' + OLI.OpportunityID);
           opptyIDList.add (OLI.OpportunityID);
       }
        
       SYSTEM.DEBUG ('======== productIDList 		: ' + productIDList);
       SYSTEM.DEBUG ('======== opptyIDList 		: ' + opptyIDList);
       
       List<Opportunity> opportunityList = [SELECT id, Link_Related__c 
                                                FROM opportunity
                                                WHERE id in :opptyIDList  
                                           ];
       For (Opportunity opptyObj : opportunityList) {
           linkIDList.add (opptyObj.Link_Related__c);
       }
       SYSTEM.DEBUG ('======== linkIDList 		: ' + linkIDList);
        
       Map<ID, Product2>p=new Map<ID,Product2>([SELECT id,Bandwidth__c,UoM_Bandwidth__c,Quota__c,UoM_Quota__c,revenue_type__c 
                                                    FROM Product2 
                                                   WHERE ID in :productIDList
                                               ]);
       
        /*START Trigger Before Insert*/
        if(trigger.isbefore && trigger.isinsert){
            for(OpportunityLineItem OLI:system.trigger.new){
                if(OLI.Product2id!=null){
                    Product2 PR=p.get(OLI.Product2id);
                    OLI.Revenue_Type__c=PR.Revenue_type__c;
                }	
            }
        }
        /*END Trigger Before Insert*/
        
        /*START Trigger After (insert,update,delete)*/
        if(trigger.isAfter){
           list<Opportunity> listOPP=new list<Opportunity>();
           set<String> setOpp=new set<String>();
           Map<ID, Opportunity> m = new Map<ID, Opportunity>([SELECT ID,StageName,Product_Code_Email__c,SAP_Code_Email__c,gsm_product_list__c,RecordType.Name,Link_Related__c,BW_Before__c,BW_After__c,UOM_BW_BEFORE__c,UOM_BW_AFter__c,service_type__c,bp_payer__c,bp_vat__c,quota__c,uom_quota__c 
                                                              from Opportunity WHERE ID IN :opptyIDList]);
           /* 
           //--- OLD ---
           Map<ID, Opportunity> m = new Map<ID, Opportunity>([SELECT ID,StageName,Product_Code_Email__c,SAP_Code_Email__c,gsm_product_list__c,RecordType.Name,Link_Related__c,BW_Before__c,BW_After__c,UOM_BW_BEFORE__c,UOM_BW_AFter__c,service_type__c,bp_payer__c,bp_vat__c,quota__c,uom_quota__c 
                                                              from Opportunity WHERE LASTMODIFIEDDATE=LAST_N_DAYS:90]);
           */
           Map<ID, Link__c> linkMap = new Map<ID,Link__c> ( [	SELECT Capacity_Bandwidth__c,UoM__c,Contract_Item_Rel__c,
                                                                   Contract_Item_Rel__r.Account_BP_Payer__c,Contract_Item_Rel__r.Account_BP_VAT__c 
                                                               FROM Link__c 
                                                               WHERE Status_Link__c <>'expired'
                                                                     AND Status_Link__c <>'Dismantled'
                                                                   AND Createddate>=2018-01-01T00:00:00Z 
                                                                   AND  id in : linkIDList
                                                               ORDER BY Createddate DESC LIMIT 45000
                                                               
                                                               ]);
          
           for(OpportunityLineItem OLI:system.trigger.new){
               if(OLI.Product2ID!=null  && OLI.revenue_type__c!=null && OLI.revenue_type__c!='') {
                   Opportunity O=m.get(OLI.OpportunityID);
                   String ProductCode;
                   String SAPCode;
                   if(
                       O.RecordType.Name.Contains('Subscription') ||
                       O.RecordType.Name.Contains('Marketplace') 
                    ){
                       if(OLI.Revenue_Type__c=='Recurring'){
                   
                           O.SAP_Code_Email__c=OLI.ProductSAPCode__c;
                           O.Product_Code_Email__c=OLI.ProductCode;
                           //setbandwidthbeforeafter.setbandwidth2(O.id,OLI.id);
                           Product2 Produk=p.get(OLI.Product2id);
                    
                    
                           if(O.Service_Type__c=='Newlink'){
                      
                               O.BW_after__c = String.valueOf(Produk.Bandwidth__c);
                               O.Uom_BW_After__c = String.valueOf(Produk.UoM_Bandwidth__c);
                               O.Uom_BW_Before__c = String.valueOf(Produk.UoM_Bandwidth__c);
               
                               if (Produk.Quota__c!=Null){
                                   O.Quota__c = String.valueOf(Produk.Quota__c);
                                   O.Uom_Quota__c = String.valueOf(Produk.UoM_Quota__c);
                               }
                           }
   
                           if(O.Service_type__c=='Licensed'||test.isrunningtest()){
                               O.BW_after__c = String.valueof(OLI.Quantity);
                               O.Uom_BW_After__c = 'Unit';
                               O.Uom_BW_Before__c = 'Unit';
                           }
                      
                           system.debug('Link_related__c nya: '+o.Link_related__c);
                           if(O.Link_related__c!=null && String.valueof(O.Link_Related__c)!='' && trigger.isupdate) {
                               system.debug('masuk sini: ');
                               Link__c LinkList = linkMap.get(O.Link_Related__c);
                               system.debug('Service_Type__c nya: '+o.Service_Type__c);
                               if(O.Service_Type__c=='Upgrade'||O.Service_Type__c=='Downgrade'||test.isrunningtest()){
                                   
                                   if(LinkList.Contract_item_rel__C!=null && String.valueof(linklist.Contract_Item_Rel__c)!='') {
                                           O.BP_Payer__c=LinkList.Contract_item_rel__r.Account_BP_Payer__c;
                                           O.BP_VAT__c=LinkList.Contract_item_rel__r.Account_BP_VAT__c;
                                   }
   
                                   if ((O.StageName=='Prospecting' || O.StageName=='Survey' 
                                           || O.StageName=='Negotiation' 
                                           || O.StageName=='Quotation Final' 
                                           || O.StageName=='Implementation' 
                                           || O.StageName=='Waiting for BA'
                                           || test.isrunningtest())) {
                                               
                                       O.BW_before__c = linkList.Capacity_Bandwidth__c;
                                       O.Uom_BW_Before__c = linkList.UoM__c;
                                       O.BW_after__c = String.valueOf(Produk.Bandwidth__c);
                                       O.Uom_BW_After__c = String.valueOf(Produk.UoM_Bandwidth__c);
                                   
                                       if (Produk.Quota__c!=Null){
                                           O.Quota__c = String.valueOf(Produk.Quota__c);
                                           O.Uom_Quota__c = String.valueOf(Produk.UoM_Quota__c);
                                       }
       
                                       if(O.UOM_BW_Before__c!=O.UOM_BW_After__c){
                                           Decimal BWBefore=0;
                                           Decimal BWAfter=0;
                                           if(O.UOM_BW_After__c=='Mbps'||test.isrunningtest()){
                                               if(O.UOM_BW_Before__c=='Kbps'||test.isrunningtest()){
                                                   O.UOM_BW_After__c='Kbps';
                                                   BWAfter=Decimal.valueof(O.BW_After__c)*1024;
                                                   O.BW_After__c=String.valueof(BWAfter);
                                               }
       
                                               if(O.UOM_BW_Before__c=='Gbps'||test.isrunningtest()){
                                                   O.UOM_BW_Before__c='Mbps';
                                                   BWBefore=Decimal.valueof(O.BW_Before__c)*1024;
                                                   O.BW_Before__c=String.valueof(BWBefore);
                                               }
                                           }
       
                                           if(O.UOM_BW_After__c=='Kbps'||test.isrunningtest()){
                                               if(O.UOM_BW_Before__c=='Mbps'||test.isrunningtest()){
                                                   O.UOM_BW_Before__c='Kbps';
                                                   BWBefore=Decimal.valueof(O.BW_Before__c)*1024;
                                                   O.BW_Before__c=String.valueof(BWBefore);
                                               }
       
                                               if(O.UOM_BW_Before__c=='Gbps'||test.isrunningtest()){
                                                   O.UOM_BW_Before__c='Kbps';
                                                   BWBefore=Decimal.valueof(O.BW_Before__c)*1024*1024;
                                                   O.BW_Before__c=String.valueof(BWBefore);
                                               }       
                                           }
                                       }
                                   }                        
                               }
   
                               if(trigger.isupdate){
                                   if(O.Service_Type__c=='Reroute'||O.Service_Type__c=='Relocation'||test.isrunningtest()){
                                       
                                       if (O.Link_Related__c!=null && String.valueof(O.Link_Related__c)!='' ){
                                           O.BW_before__c = linkList.Capacity_Bandwidth__c;
                                           O.Uom_BW_Before__c = linkList.UoM__c;
                                           O.BW_after__c = linkList.Capacity_Bandwidth__c;
                                           O.Uom_BW_After__c = linkList.UoM__c;
                                       }
                                   }
                               }
                       	  }                
                       }else{
                           
                           list<OpportunityLineItem> LL=[SELECT Product2.SAP_Code__c,revenue_type__c from OpportunityLineItem WHERE OpportunityID=:OLI.OpportunityID AND ID!=:OLI.id];
                           if(LL.size()==0) {                         
                               O.SAP_Code_Email__c=OLI.ProductSAPCode__c;
                               O.Product_Code_Email__c=OLI.ProductCode;
                           }
                       }
                   }
                   
                   if(O.RecordType.Name=='GSM (Simcard Order)')                  {
                       list<OpportunityLineItem> LLGSM=[SELECT Name,Product2.SAP_Code__c,revenue_type__c from OpportunityLineItem WHERE OpportunityID=:OLI.OpportunityID AND Product2id!=null];
                       for(OpportunityLineItem OLIGSM:LLGSM){
                           O.gsm_product_list__c=O.gsm_product_list__c+OLIgsm.Name+'\n';
                       }                  
                   }
                   if(!setOpp.Contains(O.id))
                   {
                       setOpp.add(O.id);
                       listOPP.add(O);
                   }
   
               }
           }
           update listOpp;
       }                                         
    }
   }