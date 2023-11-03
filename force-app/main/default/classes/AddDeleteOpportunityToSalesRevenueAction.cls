/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 09-21-2023
 * @last modified by  : Doddy Prima
**/
public class AddDeleteOpportunityToSalesRevenueAction {
    @InvocableMethod
    public static void addDeleteOpportunityToSalesRevenueAction( List<Opportunity> opptyList  ) {
        system.debug('================== in AddDeleteOpportunityToSalesRevenueAction.addDeleteOpportunityToSalesRevenueAction');
        system.debug('======= opptyList : ' + opptyList);

        string errorMsg = '';
        string relatedSFIDs = '';
        
        
        List<Opportunity> opptyTobeAddList = new List<Opportunity>();        
        //List<OpportunityLineItem> oliTobeDeleteList = new List<OpportunityLineItem>();
 		Set <ID> opptyTobeAddDeleteIDs = new Set <ID>();
        
        try {
            if (opptyList.size() > 0 ) {
                for (Opportunity opptyObj : opptyList){
                    System.debug('=============== opptyObj : ' + opptyObj);
                    
                    relatedSFIDs =  relatedSFIDs + opptyObj.Id + ' ';
                    opptyTobeAddDeleteIDs.add (opptyObj.Id ) ;
                }

                List<OpportunityLineItem> oliTobeAddDeleteList = [SELECT Id, OpportunityId, SortOrder, PricebookEntryId, Product2Id, ProductCode, Name, Quantity, TotalPrice, UnitPrice, ListPrice, ServiceDate, Description,  Bottom_Price__c, Notes_From_Sales__c, Sales_Price_is_Valid__c, Note_From_Solution__c, XCharge_Type__c, Distance_Km__c, Recommended_Price__c, Percentage_Calculation__c, Revenue_Type__c, Billing_Type__c, Contract_End_Date__c, Contract_Start_Date__c, Capacity__c, AO_Priceplan__c, AO__c, Previous_Quantity__c, Priceplan__c, QTY_Actual__c, QTY_Plan__c, Total_Price_Actual__c, Total_Price_Plan__c, Injection_Item__c, Product_Name__c, Request_QTY__c, Temp_Sales_Price__c, Sales_Revenue_Rel__c, Is_Pipeline__c, is_Forecast_Revenue__c, Actual_injection_Is_Null__c, Temp_Actual_injection_Is_Null__c, Is_Pipeline_PO__c, NO__c, Mark_as_Sales_Revenue__c, Actual_Close_Date__c, Owner_is_Active__c, Opportunity_SFID__c, Owner_SFID__c, Opportunity_ID__c, Group_Service_SFID__c, Group_Service_Name__c, AM_Employee_ID__c, Sales_Manager_Employee_ID__c, GH_Employee_ID__c, Mark_as_Revenue_Pipeline_OLD__c, Mark_as_Revenue_OppProduct__c, SM_SFID__c, GH_SFID__c, AM_SFID__c, Customer_SFID__c, Group_Service_Type__c, Recognize_as_Revenue__c, contract_period__c, Period_UOM__c, role_level__c, opportunity.Sales_Manager_Owner__c, opportunity.GM_Sales_of_Owner__c, opportunity.ownerid, opportunity.SM_Employee_ID__c, opportunity.GH_Employee_ID__c, opportunity.owner.userRole.name, Opportunity.Segmentation__c  FROM OpportunityLineItem
                WHERE Opportunityid in :opptyTobeAddDeleteIDs ];

                AddOppProductsToSalesRevenueAction.addOpportunityProductData ( oliTobeAddDeleteList );
            }

        
        }
        catch (Exception e) {
            string notes = 'Error on AddDeleteOpportunityToSalesRevenueAction.addDeleteOpportunityToSalesRevenueAction method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }

    
    }

}