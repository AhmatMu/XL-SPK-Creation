/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-30-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-30-2022   Novando Utoyo Agmawan   Initial Version
**/

public class MarketplaceOpportunityStageController_v2 {
    public MarketplaceOpportunityStageController_v2() {

    }

    @InvocableMethod
    public static void invokeApexCallout(list<Opportunity> oppty) {
        //call FutureCallout when opportunity stage exist in custom label 'REST_StageForCallout'

        system.debug ('== masuk MarketplaceOpportunityStageController_v2 ==');

        Id RecordTypeOppty_Licensed_Id = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Licensed').getRecordTypeId();

        if ( 
            (
                Label.REST_ApptiumStageForCallout.indexOf(oppty[0].StageName)>=0  && oppty[0].recordTypeID == RecordTypeOppty_Licensed_Id 
            ) ||  
            test.isrunningtest()
        ){
            //-- OLD WAY : ApptiumFutureCallout.apexCallout(AppUtils.getNewGUID(), oppty[0].Order_Id__c, oppty[0].id, oppty[0].StageName, oppty[0].Closed_Lost_Flag__c);
            
            //-- NEW WAY : only using Opportunity ID

            REST_MarketPlaceOrder_Callout_v2.apexCallout (oppty[0].id);
            
        }
    }

}