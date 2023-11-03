public class MarketplaceOpportunityStageController {
    public MarketplaceOpportunityStageController() {

    }

    @InvocableMethod
    public static void invokeApexCallout(list<Opportunity> oppty) {
        //call FutureCallout when opportunity stage exist in custom label 'REST_StageForCallout'

        system.debug ('== masuk MarketplaceOpportunityStageController ==');

        if ( (Label.REST_ApptiumStageForCallout.indexOf(oppty[0].StageName)>=0  && oppty[0].recordTypeID == system.label.RT_Marketplace ) ||  test.isrunningtest())
        {
            //-- OLD WAY : ApptiumFutureCallout.apexCallout(AppUtils.getNewGUID(), oppty[0].Order_Id__c, oppty[0].id, oppty[0].StageName, oppty[0].Closed_Lost_Flag__c);
            
            //-- NEW WAY : only using Opportunity ID

            REST_MarketPlaceOrder_Callout_v2.apexCallout (oppty[0].id);
            
        }
    }

}