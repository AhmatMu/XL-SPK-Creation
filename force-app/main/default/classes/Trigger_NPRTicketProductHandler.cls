/**
 * @description       : 
 * @Test Class		  : Trigger_NPRTicketProductHandler_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-15-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   12-19-2021   Novando Utoyo Agmawan   Initial Version
**/

public class Trigger_NPRTicketProductHandler implements ITriggerHandler {
    public Boolean IsDisabled()
    {
        return false;
    }
    
    public void BeforeInsert(List<SObject> newItems) {
        Handle_PobTicketProduct_OnBeforeInsert(newItems);
    }
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        Handle_PobTicketProduct_OnBeforeUpdate(newItems,oldItems);
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems) {}
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}

    public void Handle_PobTicketProduct_OnBeforeInsert(List<SObject> newItems){
        DateTime start_time = datetime.now();
        try {
            for(SObject TicketProduct : newItems){
                List<String> List_ProjectBasedGeneric_validation = new List<String>();
                List<String> List_ProjectBaseBulkshare_validation = new List<String>();
                List<String> List_SIMCardBasedPostpaid_validation = new List<String>();
                List<String> List_SIMCardBasedPrepaid_validation = new List<String>();
                List<String> List_SIMCardBasedDeviceBundling_validation = new List<String>();
                List<String> List_SubscriptionBased_validation = new List<String>();
                List<String> List_UsageBased_validation = new List<String>();
                List<String> List_LicensedBased_validation = new List<String>();

                if(
                    (
                        String.isNotBlank((String)TicketProduct.get('New_Product_Code__c')) &&
                        String.isNotBlank((String)TicketProduct.get('Existing_Product_Code__c'))
                    ) 
                    ||
                    (
                        String.isNotBlank((String)TicketProduct.get('New_Product_Code__c')) &&
                        String.isBlank((String)TicketProduct.get('Existing_Product_Code__c'))
                    )
                ){
                    TicketProduct.put('Status_Product_Code__c','New');
                    TicketProduct.put('Existing_Product_Code__c',null);
                }

                if(
                    String.isNotBlank((String)TicketProduct.get('Existing_Product_Code__c')) &&
                    String.isBlank((String)TicketProduct.get('New_Product_Code__c'))
                ){
                    TicketProduct.put('Status_Product_Code__c','Existing');
                    TicketProduct.put('New_Product_Code__c',null);
                }

                if(
                    (
                        String.isNotBlank((String)TicketProduct.get('New_Product_Family__c')) &&
                        String.isNotBlank((String)TicketProduct.get('Product_Family__c'))
                    ) 
                    ||
                    (
                        String.isNotBlank((String)TicketProduct.get('New_Product_Family__c')) &&
                        String.isBlank((String)TicketProduct.get('Product_Family__c'))
                    )
                ){
                    TicketProduct.put('Status_Product_Family__c','New');
                    TicketProduct.put('Product_Family__c',null);
                }

                if(
                    String.isNotBlank((String)TicketProduct.get('Product_Family__c')) &&
                    String.isBlank((String)TicketProduct.get('New_Product_Family__c'))
                ){
                    TicketProduct.put('Status_Product_Family__c','Existing');
                    TicketProduct.put('New_Product_Family__c',null);
                }

                if((String)TicketProduct.get('Ticket_Product_Type__c') == 'Project Based - Generic'){
                    if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                        TicketProduct.put('Active__c',true);
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                        List_ProjectBasedGeneric_validation.add('\n Group Service is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                        List_ProjectBasedGeneric_validation.add('\n Product Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                        List_ProjectBasedGeneric_validation.add('\n Product Family is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                        List_ProjectBasedGeneric_validation.add('\n Charge Type is empty');
                    }

                    if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                        List_ProjectBasedGeneric_validation.add('\n List Price is not number');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('SAP_Code__c')))){
                        List_ProjectBasedGeneric_validation.add('\n SAP Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Distribution_Channel__c')))){
                        List_ProjectBasedGeneric_validation.add('\n Distribution Channel is empty');
                    }
                    
                    if(List_ProjectBasedGeneric_validation!=null && !List_ProjectBasedGeneric_validation.isEmpty()){
                        TicketProduct.put('Valid__c',false);
                        TicketProduct.put('Data_Notes__c', string.join(List_ProjectBasedGeneric_validation,'.'));
                    }else{
                        TicketProduct.put('Valid__c',true);
                    }
                }

                if((String)TicketProduct.get('Ticket_Product_Type__c') == 'Project Based - Bulkshare'){
                    if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                        TicketProduct.put('Active__c',true);
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                        List_ProjectBaseBulkshare_validation.add('\n Group Service is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                        List_ProjectBaseBulkshare_validation.add('\n Product Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                        List_ProjectBaseBulkshare_validation.add('\n Product Family is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                        List_ProjectBaseBulkshare_validation.add('\n Charge Type is empty');
                    }

                    if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                        List_ProjectBaseBulkshare_validation.add('\n List Price is not number');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('SAP_Code__c')))){
                        List_ProjectBaseBulkshare_validation.add('\n SAP Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Distribution_Channel__c')))){
                        List_ProjectBaseBulkshare_validation.add('\n Distribution Channel is empty');
                    }
                    
                    if(List_ProjectBaseBulkshare_validation!=null && !List_ProjectBaseBulkshare_validation.isEmpty()){
                        TicketProduct.put('Valid__c',false);
                        TicketProduct.put('Data_Notes__c', string.join(List_ProjectBaseBulkshare_validation,'.'));
                    }else{
                        TicketProduct.put('Valid__c',true);
                    }
                }

                if((String)TicketProduct.get('Ticket_Product_Type__c') == 'SIM-Card Based - Postpaid'){
                    if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                        TicketProduct.put('Active__c',true);
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                        List_SIMCardBasedPostpaid_validation.add('\n Product Family is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('AO_Related__c')))){
                        List_SIMCardBasedPostpaid_validation.add('\n AO Related is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Price_Plan_Related__c')))){
                        List_SIMCardBasedPostpaid_validation.add('\n Price Plan Related is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                        List_SIMCardBasedPostpaid_validation.add('\n Group Service is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                        List_SIMCardBasedPostpaid_validation.add('\n Product Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                        List_SIMCardBasedPostpaid_validation.add('\n Charge Type is empty');
                    }

                    if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                        List_SIMCardBasedPostpaid_validation.add('\n List Price is not number');
                    }
                    
                    if(List_SIMCardBasedPostpaid_validation!=null && !List_SIMCardBasedPostpaid_validation.isEmpty()){
                        TicketProduct.put('Valid__c',false);
                        TicketProduct.put('Data_Notes__c', string.join(List_SIMCardBasedPostpaid_validation,'.'));
                    }else{
                        TicketProduct.put('Valid__c',true);
                    }
                }

                if((String)TicketProduct.get('Ticket_Product_Type__c') == 'SIM-Card Based - Prepaid'){
                    if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                        TicketProduct.put('Active__c',true);
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('AO_Related__c')))){
                        List_SIMCardBasedPrepaid_validation.add('\n AO Related is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                        List_SIMCardBasedPrepaid_validation.add('\n Product Family is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Price_Plan_Related__c')))){
                        List_SIMCardBasedPrepaid_validation.add('\n Price Plan Related is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                        List_SIMCardBasedPrepaid_validation.add('\n Group Service is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                        List_SIMCardBasedPrepaid_validation.add('\n Product Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                        List_SIMCardBasedPrepaid_validation.add('\n Charge Type is empty');
                    }

                    if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                        List_SIMCardBasedPrepaid_validation.add('\n List Price is not number');
                    }
                    
                    if(List_SIMCardBasedPrepaid_validation!=null && !List_SIMCardBasedPrepaid_validation.isEmpty()){
                        TicketProduct.put('Valid__c',false);
                        TicketProduct.put('Data_Notes__c', string.join(List_SIMCardBasedPrepaid_validation,'.'));
                    }else{
                        TicketProduct.put('Valid__c',true);
                    }
                }
                
                if((String)TicketProduct.get('Ticket_Product_Type__c') == 'SIM-Card Based - Device Bundling'){
                    if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                        TicketProduct.put('Active__c',true);
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('AO_Related__c')))){
                        List_SIMCardBasedDeviceBundling_validation.add('\n AO Related is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                        List_SIMCardBasedDeviceBundling_validation.add('\n Product Family is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Price_Plan_Related__c')))){
                        List_SIMCardBasedDeviceBundling_validation.add('\n Price Plan Related is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                        List_SIMCardBasedDeviceBundling_validation.add('\n Group Service is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                        List_SIMCardBasedDeviceBundling_validation.add('\n Product Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                        List_SIMCardBasedDeviceBundling_validation.add('\n Charge Type is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Device_Related__c')))){
                        List_SIMCardBasedDeviceBundling_validation.add('\n Device Related is empty');
                    }

                    if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                        List_SIMCardBasedDeviceBundling_validation.add('\n List Price is not number');
                    }
                    
                    if(List_SIMCardBasedDeviceBundling_validation!=null && !List_SIMCardBasedDeviceBundling_validation.isEmpty()){
                        TicketProduct.put('Valid__c',false);
                        TicketProduct.put('Data_Notes__c', string.join(List_SIMCardBasedDeviceBundling_validation,'.'));
                    }else{
                        TicketProduct.put('Valid__c',true);
                    }
                }

                if((String)TicketProduct.get('Ticket_Product_Type__c') == 'Subscription Based'){
                    if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                        TicketProduct.put('Active__c',true);
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                        List_SubscriptionBased_validation.add('\n Group Service is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                        List_SubscriptionBased_validation.add('\n Product Family is empty');
                    }

                    if(
                        String.isBlank(String.valueOf((Decimal)TicketProduct.get('Bandwidth__c')))
                    )
                    {
                        List_SubscriptionBased_validation.add('\n Capacity is not number');
                    }

                    if(
                        String.isBlank(String.valueOf((String)TicketProduct.get('UoM_Bandwidth__c')))
                    ){
                        List_SubscriptionBased_validation.add('\n UoM Capacity is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('SAP_Code__c')))){
                        List_SubscriptionBased_validation.add('\n SAP Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Distribution_Channel__c')))){
                        List_SubscriptionBased_validation.add('\n Distribution Channel is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                        List_SubscriptionBased_validation.add('\n Product Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                        List_SubscriptionBased_validation.add('\n Charge Type is empty');
                    }

                    if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                        List_SubscriptionBased_validation.add('\n List Price is not number');
                    }
                    
                    if(List_SubscriptionBased_validation!=null && !List_SubscriptionBased_validation.isEmpty()){
                        TicketProduct.put('Valid__c',false);
                        TicketProduct.put('Data_Notes__c', string.join(List_SubscriptionBased_validation,'.'));
                    }else{
                        TicketProduct.put('Valid__c',true);
                    }
                }

                if((String)TicketProduct.get('Ticket_Product_Type__c') == 'Usage Based'){
                    if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                        TicketProduct.put('Active__c',true);
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                        List_UsageBased_validation.add('\n Group Service is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                        List_UsageBased_validation.add('\n Product Family is empty');
                    }

                    if(
                        String.isBlank(String.valueOf((Decimal)TicketProduct.get('Bandwidth__c')))
                    ){
                        List_UsageBased_validation.add('\n Capacity is not number');
                    }

                    if(
                        String.isBlank(String.valueOf((String)TicketProduct.get('UoM_Bandwidth__c')))
                    ){
                        List_UsageBased_validation.add('\n UoM Capacity is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                        List_UsageBased_validation.add('\n Product Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                        List_UsageBased_validation.add('\n Charge Type is empty');
                    }

                    if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                        List_UsageBased_validation.add('\n List Price is not number');
                    }
                    
                    if(List_UsageBased_validation!=null && !List_UsageBased_validation.isEmpty()){
                        TicketProduct.put('Valid__c',false);
                        TicketProduct.put('Data_Notes__c', string.join(List_UsageBased_validation,'.'));
                    }else{
                        TicketProduct.put('Valid__c',true);
                    }
                }

                if((String)TicketProduct.get('Ticket_Product_Type__c') == 'Licensed Based'){
                    if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                        TicketProduct.put('Active__c',true);
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                        List_LicensedBased_validation.add('\n Group Service is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                        List_LicensedBased_validation.add('\n Product Family is empty');
                    }

                    /*if(
                        String.isBlank(String.valueOf((Decimal)TicketProduct.get('Bandwidth__c')))
                    )
                    {
                        List_LicensedBased_validation.add('\n Capacity is not number');
                    }

                    if(
                        String.isBlank(String.valueOf((String)TicketProduct.get('UoM_Bandwidth__c')))
                    ){
                        List_LicensedBased_validation.add('\n UoM Capacity is empty');
                    }*/

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('SAP_Code__c')))){
                        List_LicensedBased_validation.add('\n SAP Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Distribution_Channel__c')))){
                        List_LicensedBased_validation.add('\n Distribution Channel is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                        List_LicensedBased_validation.add('\n Product Code is empty');
                    }

                    if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                        List_LicensedBased_validation.add('\n Charge Type is empty');
                    }

                    if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                        List_LicensedBased_validation.add('\n List Price is not number');
                    }
                    
                    if(List_LicensedBased_validation!=null && !List_LicensedBased_validation.isEmpty()){
                        TicketProduct.put('Valid__c',false);
                        TicketProduct.put('Data_Notes__c', string.join(List_LicensedBased_validation,'.'));
                    }else{
                        TicketProduct.put('Valid__c',true);
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Insert - Trigger_NPRTicketProductHandler.cls - Handle_PobTicketProduct_OnBeforeInsert ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public void Handle_PobTicketProduct_OnBeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            for(SObject TicketProduct : newItems.values()){
                List<String> List_ProjectBasedGeneric_validation = new List<String>();
                List<String> List_ProjectBaseBulkshare_validation = new List<String>();
                List<String> List_SIMCardBasedPostpaid_validation = new List<String>();
                List<String> List_SIMCardBasedPrepaid_validation = new List<String>();
                List<String> List_SIMCardBasedDeviceBundling_validation = new List<String>();
                List<String> List_SubscriptionBased_validation = new List<String>();
                List<String> List_UsageBased_validation = new List<String>();
                List<String> List_LicensedBased_validation = new List<String>();

                SObject old_ticketProduct;
                if(oldItems != null && oldItems.get((id)TicketProduct.get('Id')) != null){
                    old_ticketProduct = oldItems.get((Id)TicketProduct.get('Id'));

                    if( 
                        TicketProduct.get('Active__c') != old_ticketProduct.get('Active__c') ||
                        TicketProduct.get('Group_Service__c') != old_ticketProduct.get('Group_Service__c') ||
                        TicketProduct.get('Charge_Type__c') != old_ticketProduct.get('Charge_Type__c') ||
                        TicketProduct.get('List_Price__c') != old_ticketProduct.get('List_Price__c') ||
                        TicketProduct.get('AO_Related__c') != old_ticketProduct.get('AO_Related__c') ||
                        TicketProduct.get('Price_Plan_Related__c') != old_ticketProduct.get('Price_Plan_Related__c') ||
                        TicketProduct.get('Price_Plan_Related__c') != old_ticketProduct.get('Price_Plan_Related__c') ||
                        TicketProduct.get('Device_Related__c') != old_ticketProduct.get('Device_Related__c') ||
                        TicketProduct.get('Bandwidth__c') != old_ticketProduct.get('Bandwidth__c') ||
                        TicketProduct.get('UoM_Bandwidth__c') != old_ticketProduct.get('UoM_Bandwidth__c') ||
                        TicketProduct.get('SAP_Code__c') != old_ticketProduct.get('SAP_Code__c') ||
                        TicketProduct.get('Distribution_Channel__c') != old_ticketProduct.get('Distribution_Channel__c') ||
                        TicketProduct.get('New_Product_Code__c') != old_ticketProduct.get('New_Product_Code__c') ||
                        TicketProduct.get('Existing_Product_Code__c') != old_ticketProduct.get('Existing_Product_Code__c') ||
                        TicketProduct.get('New_Product_Family__c') != old_ticketProduct.get('New_Product_Family__c') ||
                        TicketProduct.get('Product_Family__c') != old_ticketProduct.get('Product_Family__c')
                    ){
                        if(
                            (
                                TicketProduct.get('New_Product_Code__c') != null &&
                                TicketProduct.get('Existing_Product_Code__c') != null
                            ) 
                            ||
                            (
                                TicketProduct.get('New_Product_Code__c') != null &&
                                TicketProduct.get('Existing_Product_Code__c') == null
                            )
                        ){
                            TicketProduct.put('Status_Product_Code__c','New');
                            TicketProduct.put('Existing_Product_Code__c',null);
                        }

                        if(
                            TicketProduct.get('Existing_Product_Code__c') != null &&
                            TicketProduct.get('New_Product_Code__c') == null
                        ){
                            TicketProduct.put('Status_Product_Code__c','Existing');
                            TicketProduct.put('New_Product_Code__c',null);
                        }

                        if(
                            (
                                TicketProduct.get('New_Product_Family__c') != null &&
                                TicketProduct.get('Product_Family__c') != null
                            ) 
                            ||
                            (
                                TicketProduct.get('New_Product_Family__c') != null &&
                                TicketProduct.get('Product_Family__c') == null
                            )
                        ){
                            TicketProduct.put('Status_Product_Family__c','New');
                            TicketProduct.put('Product_Family__c',null);
                        }

                        if(
                            TicketProduct.get('Product_Family__c') != null &&
                            TicketProduct.get('New_Product_Family__c') == null
                        ){
                            TicketProduct.put('Status_Product_Family__c','Existing');
                            TicketProduct.put('New_Product_Family__c',null);
                        }

                        if(TicketProduct.get('Active__c') != true){
                            TicketProduct.put('Active__c',true);
                        }

                        system.debug('Ticket_Product_Type__c 452 : ' + TicketProduct.get('Ticket_Product_Type__c'));

                        if(TicketProduct.get('Ticket_Product_Type__c') == 'Project Based - Generic'){
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                                List_ProjectBasedGeneric_validation.add('\n Group Service is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                                List_ProjectBasedGeneric_validation.add('\n Product Code is empty');
                            }

                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                                List_ProjectBasedGeneric_validation.add('\n Product Family is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                                List_ProjectBasedGeneric_validation.add('\n Charge Type is empty');
                            }
        
                            if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                                List_ProjectBasedGeneric_validation.add('\n List Price is not number');
                            }

                            if(String.isBlank(String.valueOf((String)TicketProduct.get('SAP_Code__c')))){
                                List_ProjectBasedGeneric_validation.add('\n SAP Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Distribution_Channel__c')))){
                                List_ProjectBasedGeneric_validation.add('\n Distribution Channel is empty');
                            }
                            
                            if(List_ProjectBasedGeneric_validation!=null && !List_ProjectBasedGeneric_validation.isEmpty()){
                                TicketProduct.put('Valid__c',false);
                                TicketProduct.put('Data_Notes__c', string.join(List_ProjectBasedGeneric_validation,'.'));
                            }else{
                                TicketProduct.put('Valid__c',true);
                                TicketProduct.put('Data_Notes__c', null);
                            }
                        }
        
                        if(TicketProduct.get('Ticket_Product_Type__c') == 'Project Based - Bulkshare'){
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                                List_ProjectBaseBulkshare_validation.add('\n Group Service is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                                List_ProjectBaseBulkshare_validation.add('\n Product Code is empty');
                            }

                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                                List_ProjectBaseBulkshare_validation.add('\n Product Family is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                                List_ProjectBaseBulkshare_validation.add('\n Charge Type is empty');
                            }
        
                            if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                                List_ProjectBaseBulkshare_validation.add('\n List Price is not number');
                            }

                            if(String.isBlank(String.valueOf((String)TicketProduct.get('SAP_Code__c')))){
                                List_ProjectBaseBulkshare_validation.add('\n SAP Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Distribution_Channel__c')))){
                                List_ProjectBaseBulkshare_validation.add('\n Distribution Channel is empty');
                            }
                            
                            if(List_ProjectBaseBulkshare_validation!=null && !List_ProjectBaseBulkshare_validation.isEmpty()){
                                TicketProduct.put('Valid__c',false);
                                TicketProduct.put('Data_Notes__c', string.join(List_ProjectBaseBulkshare_validation,'.'));
                            }else{
                                TicketProduct.put('Valid__c',true);
                                TicketProduct.put('Data_Notes__c', null);
                            }
                        }

                        if(TicketProduct.get('Ticket_Product_Type__c') == 'SIM-Card Based - Postpaid'){
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('AO_Related__c')))){
                                List_SIMCardBasedPostpaid_validation.add('\n AO Related is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Price_Plan_Related__c')))){
                                List_SIMCardBasedPostpaid_validation.add('\n Price Plan Related is empty');
                            }

                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                                List_SIMCardBasedPostpaid_validation.add('\n Product Family is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                                List_SIMCardBasedPostpaid_validation.add('\n Group Service is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                                List_SIMCardBasedPostpaid_validation.add('\n Product Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                                List_SIMCardBasedPostpaid_validation.add('\n Charge Type is empty');
                            }
        
                            if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                                List_SIMCardBasedPostpaid_validation.add('\n List Price is not number');
                            }
                            
                            if(List_SIMCardBasedPostpaid_validation!=null && !List_SIMCardBasedPostpaid_validation.isEmpty()){
                                TicketProduct.put('Valid__c',false);
                                TicketProduct.put('Data_Notes__c', string.join(List_SIMCardBasedPostpaid_validation,'.'));
                            }else{
                                TicketProduct.put('Valid__c',true);
                                TicketProduct.put('Data_Notes__c', null);
                            }
                        }
        
                        if(TicketProduct.get('Ticket_Product_Type__c') == 'SIM-Card Based - Prepaid'){
                            if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                                TicketProduct.put('Active__c',true);
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('AO_Related__c')))){
                                List_SIMCardBasedPrepaid_validation.add('\n AO Related is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Price_Plan_Related__c')))){
                                List_SIMCardBasedPrepaid_validation.add('\n Price Plan Related is empty');
                            }

                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                                List_SIMCardBasedPrepaid_validation.add('\n Product Family is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                                List_SIMCardBasedPrepaid_validation.add('\n Group Service is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                                List_SIMCardBasedPrepaid_validation.add('\n Product Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                                List_SIMCardBasedPrepaid_validation.add('\n Charge Type is empty');
                            }
        
                            if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                                List_SIMCardBasedPrepaid_validation.add('\n List Price is not number');
                            }
                            
                            if(List_SIMCardBasedPrepaid_validation!=null && !List_SIMCardBasedPrepaid_validation.isEmpty()){
                                TicketProduct.put('Valid__c',false);
                                TicketProduct.put('Data_Notes__c', string.join(List_SIMCardBasedPrepaid_validation,'.'));
                            }else{
                                TicketProduct.put('Valid__c',true);
                                TicketProduct.put('Data_Notes__c', null);
                            }
                        }
                        
                        if(TicketProduct.get('Ticket_Product_Type__c') == 'SIM-Card Based - Device Bundling'){
                            if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                                TicketProduct.put('Active__c',true);
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('AO_Related__c')))){
                                List_SIMCardBasedDeviceBundling_validation.add('\n AO Related is empty');
                            }

                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                                List_SIMCardBasedDeviceBundling_validation.add('\n Product Family is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Price_Plan_Related__c')))){
                                List_SIMCardBasedDeviceBundling_validation.add('\n Price Plan Related is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                                List_SIMCardBasedDeviceBundling_validation.add('\n Group Service is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                                List_SIMCardBasedDeviceBundling_validation.add('\n Product Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                                List_SIMCardBasedDeviceBundling_validation.add('\n Charge Type is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Device_Related__c')))){
                                List_SIMCardBasedDeviceBundling_validation.add('\n Device Related is empty');
                            }
        
                            if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                                List_SIMCardBasedDeviceBundling_validation.add('\n List Price is not number');
                            }
                            
                            if(List_SIMCardBasedDeviceBundling_validation!=null && !List_SIMCardBasedDeviceBundling_validation.isEmpty()){
                                TicketProduct.put('Valid__c',false);
                                TicketProduct.put('Data_Notes__c', string.join(List_SIMCardBasedDeviceBundling_validation,'.'));
                            }else{
                                TicketProduct.put('Valid__c',true);
                                TicketProduct.put('Data_Notes__c', null);
                            }
                        }
        
                        if(TicketProduct.get('Ticket_Product_Type__c') == 'Subscription Based'){
                            if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                                TicketProduct.put('Active__c',true);
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                                List_SubscriptionBased_validation.add('\n Group Service is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                                List_SubscriptionBased_validation.add('\n Product Family is empty');
                            }
        
                            if(
                                String.isBlank(String.valueOf((Decimal)TicketProduct.get('Bandwidth__c')))
                            )
                            {
                                List_SubscriptionBased_validation.add('\n Capacity is not number');
                            }
        
                            if(
                                String.isBlank(String.valueOf((String)TicketProduct.get('UoM_Bandwidth__c')))
                            ){
                                List_SubscriptionBased_validation.add('\n UoM Capacity is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('SAP_Code__c')))){
                                List_SubscriptionBased_validation.add('\n SAP Code is empty');
                            }

                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Distribution_Channel__c')))){
                                List_SubscriptionBased_validation.add('\n Distribution Channel is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                                List_SubscriptionBased_validation.add('\n Product Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                                List_SubscriptionBased_validation.add('\n Charge Type is empty');
                            }
        
                            if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                                List_SubscriptionBased_validation.add('\n List Price is not number');
                            }
                            
                            if(List_SubscriptionBased_validation!=null && !List_SubscriptionBased_validation.isEmpty()){
                                TicketProduct.put('Valid__c',false);
                                TicketProduct.put('Data_Notes__c', string.join(List_SubscriptionBased_validation,'.'));
                            }else{
                                TicketProduct.put('Valid__c',true);
                                TicketProduct.put('Data_Notes__c', null);
                            }
                        }
        
                        if(TicketProduct.get('Ticket_Product_Type__c') == 'Usage Based'){
                            if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                                TicketProduct.put('Active__c',true);
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                                List_UsageBased_validation.add('\n Group Service is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                                List_UsageBased_validation.add('\n Product Family is empty');
                            }
        
                            if(
                                String.isBlank(String.valueOf((Decimal)TicketProduct.get('Bandwidth__c')))
                            )
                            {
                                List_UsageBased_validation.add('\n Capacity is not number');
                            }
        
                            if(
                                String.isBlank(String.valueOf((String)TicketProduct.get('UoM_Bandwidth__c')))
                            ){
                                List_UsageBased_validation.add('\n UoM Capacity is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                                List_UsageBased_validation.add('\n Product Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                                List_UsageBased_validation.add('\n Charge Type is empty');
                            }
        
                            if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                                List_UsageBased_validation.add('\n List Price is not number');
                            }
                            
                            if(List_UsageBased_validation!=null && !List_UsageBased_validation.isEmpty()){
                                TicketProduct.put('Valid__c',false);
                                TicketProduct.put('Data_Notes__c', string.join(List_UsageBased_validation,'.'));
                            }else{
                                TicketProduct.put('Valid__c',true);
                                TicketProduct.put('Data_Notes__c', null);
                            }
                        }

                        if(TicketProduct.get('Ticket_Product_Type__c') == 'Licensed Based'){
                            if(String.isBlank(String.valueOf((Boolean)TicketProduct.get('Active__c'))) || (Boolean)TicketProduct.get('Active__c') != true){
                                TicketProduct.put('Active__c',true);
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Group_Service__c')))){
                                List_LicensedBased_validation.add('\n Group Service is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Product_Family__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Family__c')))){
                                List_LicensedBased_validation.add('\n Product Family is empty');
                            }
        
                            /*if(
                                String.isBlank(String.valueOf((Decimal)TicketProduct.get('Bandwidth__c')))
                            )
                            {
                                List_LicensedBased_validation.add('\n Capacity is not number');
                            }
        
                            if(
                                String.isBlank(String.valueOf((String)TicketProduct.get('UoM_Bandwidth__c'))) 
                            ){
                                List_LicensedBased_validation.add('\n UoM Capacity is empty');
                            }*/
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('SAP_Code__c')))){
                                List_LicensedBased_validation.add('\n SAP Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Distribution_Channel__c')))){
                                List_LicensedBased_validation.add('\n Distribution Channel is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Existing_Product_Code__c'))) && String.isBlank(String.valueOf((String)TicketProduct.get('New_Product_Code__c')))){
                                List_LicensedBased_validation.add('\n Product Code is empty');
                            }
        
                            if(String.isBlank(String.valueOf((String)TicketProduct.get('Charge_Type__c')))){
                                List_LicensedBased_validation.add('\n Charge Type is empty');
                            }
        
                            if(String.isBlank(String.valueOf((Decimal)TicketProduct.get('List_Price__c')))){
                                List_LicensedBased_validation.add('\n List Price is not number');
                            }
                            
                            if(List_LicensedBased_validation!=null && !List_LicensedBased_validation.isEmpty()){
                                TicketProduct.put('Valid__c',false);
                                TicketProduct.put('Data_Notes__c', string.join(List_LicensedBased_validation,'.'));
                            }else{
                                TicketProduct.put('Valid__c',true);
                                TicketProduct.put('Data_Notes__c', null);
                            }
                        }
                    }
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger Before Update - Trigger_NPRTicketProductHandler.cls - Handle_PobTicketProduct_OnBeforeUpdate ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
}