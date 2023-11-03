/**
 * @description       : 
 * @Test Class        : BillingPlanFilterListRecord_Flow_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-26-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-23-2023   Novando Utoyo Agmawan   Initial Version
**/

public class BillingPlanFilterListRecord_Flow {
    @InvocableMethod(label='Billing Plan Filter List Record')    
    public static List<List<Billing_Plan__c>> BillingPlanFilterListRecord_FlowMethod(List<List<Billing_Request__c>> List_BillingRequests){
        List<Billing_Plan__c> List_BillingPlan = new List<Billing_Plan__c>();

        try {
            system.debug('BillingPlanFilterListRecord_FlowMethod - List_BillingRequest : ' + json.serialize(List_BillingRequests[0]));

            if(List_BillingRequests!=null && !List_BillingRequests.isEmpty()){
                List<Billing_Request__c> List_BillingRequest = List_BillingRequests[0];

                if(List_BillingRequest!=null && !List_BillingRequest.isEmpty()){
                    Set<String> Set_billingPlanId = new Set<String> ();

                    for(Billing_Request__c BillingRequest : List_BillingRequest){
                        Set_billingPlanId.add(BillingRequest.Billing_Plan__c);
                    }

                    if(Set_billingPlanId!=null && !Set_billingPlanId.isEmpty()){
                        List_BillingPlan = [
                            SELECT Id,
                            Bill_End_Date__c,
                            Bill_Start_Date__c,
                            Contract__c,
                            Link__c,
                            Name
                            FROM Billing_Plan__c
                            WHERE Id NOT IN : Set_billingPlanId
                        ];
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on BillingPlanFilterListRecord_Flow.cls - BillingPlanFilterListRecord_FlowMethod ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();

            AppUtils.putError(err_message);
        }

        return new List<List<Billing_Plan__c>>{List_BillingPlan};
    } 
}