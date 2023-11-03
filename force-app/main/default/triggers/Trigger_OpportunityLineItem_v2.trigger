/* ====================================================================================================
 * Class Name		        : Trigger_OpportunityLineItem_v2
 * Test Class		        : Trigger_OpportunityLineItem_v2Test
 * Created By		        : Novando Utoyo Agmawan
 * Created Date		        : 01/23/2022
 * Created Description		: - 
 * 					          - 
 * Updated By               : Kahfi Frimanda
 * Updated Date	            : 04/06/2022
 * Updated Description		: Using Framework
 * 					          - 
 * ====================================================================================================
 */

trigger Trigger_OpportunityLineItem_v2 on OpportunityLineItem (before insert, before update, before delete, after insert, after update, after delete) {
    
   List<Trigger_Controller__c> TriggerController = [select Is_Active__c from Trigger_Controller__c where name = 'Trigger_Opportunity_Product'];
    
    if(TriggerController!=null && !TriggerController.isEmpty()){
        if(TriggerController[0].Is_Active__c){
            TriggerDispatcher.Run(new OpportunityLineItemTriggerHandler());
        }
    } /* 
     if(system.label.IS_Trigger_OpportunityLineItem_v2_ON=='YES')  {
           if(!trigger.isdelete){
              /* for(OpportunityLineItem OLI:system.trigger.new) {
           	   	Opportunity O=[SELECT StageName,Probability,RecordType.Name from Opportunity WHERE ID=:OLI.OpportunityID];
               if(trigger.isbefore)
                   {
                       if(O.RecordType.Name.contains('Subscription'))
                       {
                       if(O.Probability>=0.5 &&trigger.isinsert && !test.isrunningtest())
                       {
                           OLI.AddError('Cannot insert at this Stage');		
                       }
                       }
                   }
                   if(trigger.isafter) {
                       if(trigger.isupdate) {
                        OpportunityLineItem OldOLI=trigger.oldmap.get(OLI.id);
                           if(O.RecordType.Name.contains('Subscription')) {
                               if(O.Probability>=0.5  && OldOLI.Product2id!=OLI.Product2id && !test.isrunningtest()){
                                   OLI.AddError('Cannot ChangeProduct at this Stage');	
                               }
                           }
                       }
                   }
               }
           }
           else {
               for(OpportunityLineItem OLI:system.trigger.old) {
                   Opportunity O=[SELECT StageName,Probability,RecordType.Name from Opportunity WHERE ID=:OLI.OpportunityID];
                   if(trigger.isbefore && trigger.isdelete) {
                       if(O.RecordType.Name.contains('Subscription') && O.Probability>=0.5 && !test.isrunningtest()) {
                           OLI.Adderror('Cannot Delete Product At This Stage');
                       }
                   }
               }
           }
           
   }*/
       /*
       if(trigger.isbefore)
       {
           for(OpportunityLineItem OLI:system.trigger.new)
           {
           Opportunity O=[select Pricebook2id,RecordType.Name FROM Opportunity WHERE ID=:OLI.OpportunityID];
           if(O.PriceBook2id!=null && O.RecordType.Name=='Simcard Postpaid/Prepaid')
           {    
                  list<PriceBookEntry> PBE2=[SELECT id,start_from__c,up_to__c,product2id,unitprice from PricebookEntry WHERE Product2id=:OLI.product2id AND Pricebook2.id=:O.Pricebook2id AND Start_from__c<=:OLI.Quantity AND Up_to__c>=:OLI.Quantity];
                  if(PBE2.size()==0)
                   OLI.addError('Kuantitas tidak sesuai Tier dan tidak ada penggantinya');
                   else
                   {
                       OLI.Unitprice=PBE2[0].Unitprice;
                       update OLI;
                   }
           }
       }
       }       
       */
}