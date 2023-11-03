public class ApptiumAPICallout {
    
    @InvocableMethod
    public static void invokeApexCallout(list<Opportunity> oppty) {
        //call FutureCallout when opportunity stage exist in custom label 'REST_StageForCallout'
        if(Label.REST_ApptiumStageForCallout.indexOf(oppty[0].StageName)>=0||test.isrunningtest()){
            ApptiumFutureCallout.apexCallout(AppUtils.getNewGUID(), oppty[0].Order_Id__c, oppty[0].id, oppty[0].StageName, oppty[0].Closed_Lost_Flag__c);
        }
    }

}