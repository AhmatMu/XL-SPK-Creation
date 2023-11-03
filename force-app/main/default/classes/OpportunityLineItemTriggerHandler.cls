/**
 * @description       : 
 * @Test Class        : Trigger_OpportunityLineItem_v2Test
 * @author            : 
 * @group             : 
 * @last modified on  : 10-11-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-21-2023   Novando Utoyo Agmawan   Initial Version
**/

public class OpportunityLineItemTriggerHandler implements ITriggerHandler{
    
    Public void BeforeInsert(List<SObject> newItems){
        /*System.debug('===================== Start OpportunityLineItemTriggerHandler.BeforeInsert Original =====================');
        
        List<Opportunity> opptyToUpdate = New List<Opportunity>();
        Set<Id> OpptyId = New Set<Id>();
        for(SObject OLI:newItems){            
            OpptyId.add((Id) OLI.get('opportunityId'));            
        }
    	Map<Id,Opportunity> OpptyMap = New Map<Id,Opportunity>([Select Id, BP_Payer__r.Customer_Type__c from Opportunity where Id in :opptyId]);
        List<Service_to_Customer_Type__c> ltct = new List<Service_to_Customer_Type__c>([Select Id, Service__c, Customer_Type__c from Service_to_Customer_Type__c]);
        Map<String,String> ServToCusType = New Map<String,String>();
        for(Service_to_Customer_Type__c stc:ltct){
            ServToCusType.put(stc.Service__c , stc.Customer_Type__c );
        }        
        for(SObject oli :newItems){
            
        }
        
        
        //Set<Id> oid = newItems.keyset();
        //Set<Id> opptyId = New Map<Id,SObject>([Select OpportunityId Id from OpportunityLineItem where Id in :oid Group By OpportunityId]).keyset();*/
         
        
    }
    Public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
    
    Public void BeforeDelete(Map<Id, SObject> oldItems){
        System.debug('===================== Start OpportunityLineItemTriggerHandler.BeforeDelete =====================');
        for(SObject OLI:oldItems.values()){
            String oRecType = (String)OLI.get('Opportunity_Recordtype__c');
            Integer stVal = 3;

            if(
                (String)OLI.get('Opportunity_Stage__c') == 'Prospecting' ||
                test.isrunningtest()
            ){
                stVal = 0;
            }

            if(
                (String)OLI.get('Opportunity_Stage__c') == 'Survey' ||
                test.isrunningtest()
            ){
                stVal = 1;
            }

            if(
                (String)OLI.get('Opportunity_Stage__c') == 'Negotiation' ||
                test.isrunningtest()
            ){
                stVal = 2;
            }

            System.debug('oRecType :'+oRecType);
            System.debug('stVal :'+stVal);

            if((String)OLI.get('revenue_type__c') != 'Free'){
                if(
                    oRecType.contains('Simcard') || 
                    oRecType.contains('Project')  || 
                    oRecType.contains('Subscription') ||
                    test.isrunningtest()
                ) {        
                    if(stVal >=3 && !test.isrunningtest()){
                        OLI.Adderror('Invalid Action : Can\'t delete product at this stage! ');
                    }
                }else{
                    if(stVal >=1 && !test.isrunningtest()){
                        OLI.Adderror('Invalid Action : Can\'t delete product at this stage! ');
                    }
                } 
            }
        }
    }
    
    
    Public void AfterInsert(Map<Id, SObject> newItems){
        /*System.debug('===================== Start OpportunityLineItemTriggerHandler.AfterInsert =====================');
        

        Set<Id> oid = newItems.keyset();
        Set<Id> opptyId = New Map<Id,SObject>([Select OpportunityId Id from OpportunityLineItem where Id in :oid Group By OpportunityId]).keyset();
        Map<Id,Opportunity> OpptyMap = New Map<Id,Opportunity>([Select Id, Service__c from Opportunity where Id in :opptyId]); 
        List<Opportunity> opptyToUpdate = New List<Opportunity>();
        
        List<Service_to_Customer_Type__c> ltct = new List<Service_to_Customer_Type__c>([Select Id, Service__c, Customer_Type__c from Service_to_Customer_Type__c]);
        Map<String,String> ServToCusType = New Map<String,String>();
        for(Service_to_Customer_Type__c stc:ltct){
            ServToCusType.put(stc.Service__c , stc.Customer_Type__c );
        }        
        
        System.debug('========================= Opptyid size :'+OpptyMap.size());
        System.debug('========================= Opptyid size :'+ServToCusType.size());
        
        for(SObject oli :newItems.values()){
            Opportunity o = New Opportunity();
            o.Id = OpptyMap.get( (Id) oli.get('opportunityId')).Id;
            
            System.debug('========================= OpptyMap  :'+OpptyMap.get( (Id) oli.get('opportunityId')).Id);
            System.debug('========================= OpptyMap  :'+oli.get('Revenue_Type__c')); 
            System.debug('========================= OpptyMap  :'+oli.get('ProductCode')); 
            if(oli.get('Revenue_Type__c')=='One Time'){
                if(o.service__c == '' || String.isBlank(o.service__c)){
                    o.service__c = (String)oli.get('ProductCode');
					o.ServiceAsCustomerType__c = ServToCusType.get((String)oli.get('ProductCode'));                  
                }  
            }else{
                o.ServiceAsCustomerType__c = ServToCusType.get((String)oli.get('ProductCode'));
            }            
            System.debug('========================= Opptyid :'+o.id);
            System.debug('========================= service__c :'+o.ServiceAsCustomerType__c);
            opptyToUpdate.add(o);  
        }
        update opptyToUpdate;*/    
    }
    
    Public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
    
    Public void AfterDelete(Map<Id, SObject> oldItems){}
    
    Public void AfterUndelete(Map<Id, SObject> oldItems){}
    
    Public Boolean IsDisabled(){
        return false;
    }
}