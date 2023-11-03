/* ====================================================================================================
 * Class Name		        : Trigger_Opportunity_Profitabilty
 * Test Class		        : Test_Trigger_Opportunity_Profitabilty
 * Created By		        : 
 * Created Date		        : 
 * Created Description		: - 
 * 					          - 
 * Updated By               : Novando Utoyo Agmawan
 * Updated Date	            : 09/2021
 * Updated Description		: - 
 * 					          - 
 * ====================================================================================================
 */

trigger Trigger_Opportunity_Profitabilty on Opportunity (after update) {

    if (system.label.is_Trigger_Opportunity_Profitabilty_On == 'YES') {
        
        set < String > set_ProfitabilityIds_DeleteAfterCloseLost = new set < String > ();
        List < String > List_OppId_Negotation_OR_QuotationFinal = new List < String > ();
        set < String > set_ProfitabilityIds_DeleteAfterCloseWon = new set < String > ();
        set < String > set_ProfitabilityIds_ChangeLink = new set < String > ();

        //-- UPDATE
        system.debug ('=== UPDATE === ');
        if (trigger.isupdate) {
            if (trigger.isAfter) {
                system.debug ('=== AFTER.UPDATE === '); 

                for (Opportunity Opp: system.trigger.new) {
                    Opportunity Old = Trigger.oldMap.get(Opp.id);

                    system.debug ('=== Opp.RecordtypeName__c : '  + Opp.RecordtypeName__c);


                    //Update Vando -> 07/05/2021 
                    //sudah ada di trigger_opportunity untuk handel NON GSM
                    if (
                        Opp.Profitability__c != null &&
                        (Old.Recurring_Revenue__c != Opp.Recurring_Revenue__c || Old.Onetime_revenue__c != Opp.Onetime_revenue__c)
                    ) {
                        List < Profitability__c > ProfitabilityList = [SELECT Id, Deal_Price__c, One_Time_Revenue__c, Status__c FROM Profitability__c WHERE Id =: Opp.Profitability__c AND Status__c = 'Forecast'
                        AND (RecordType.Name = 'IOT MCA' OR RecordType.Name = 'NON GSM')
                        ];

                        if (ProfitabilityList != null && !ProfitabilityList.isEmpty()) {
                            for (Profitability__c ProfitabilityList_extract: ProfitabilityList) {
                                ProfitabilityList_extract.Deal_Price__c = Opp.Recurring_Revenue__c;
                                ProfitabilityList_extract.One_Time_Revenue__c = Opp.Onetime_revenue__c;
                            }
                            update ProfitabilityList;
                        }
                    }
                    

                    //Update Vando -> ketika opp stage close-lose, record profitability dihapus
                    if (
                        Opp.Profitability__c != null &&
                        Old.StageName != Opp.StageName &&
                        Opp.StageName == 'Closed Lost'
                    ) {
                        set_ProfitabilityIds_DeleteAfterCloseLost.add(Opp.Profitability__c);
                    }

                    //Update Vando -> ketika opp stage close-Won, record profitability Forecast dihapus
                    if (
                        Old.StageName != Opp.StageName &&
                        Opp.StageName == 'Closed Won' &&
                        (Opp.RecordtypeName__c == 'GSM (Activation)' || Opp.RecordtypeName__c == 'Device Bundling' || Opp.RecordtypeName__c == 'Digital Advertising')
                    ) {
                        set_ProfitabilityIds_DeleteAfterCloseWon.add(Opp.Id);
                    }

                    //Update Vando -> ketika opp stage Negotation atau Quotation_Final untuk record type GSM -> upsert PNL
                    if (
                        Old.StageName != Opp.StageName &&
                        (Opp.StageName == 'Negotiation' || Opp.StageName == 'Quotation Final') &&
                        (Opp.RecordtypeName__c == 'GSM (Activation)' || Opp.RecordtypeName__c == 'Device Bundling' || Opp.RecordtypeName__c == 'Digital Advertising')
                    ) {
                        List_OppId_Negotation_OR_QuotationFinal.add(Opp.Id);
                    }

                    //Update Vando -> ketika opp Rollup_Total_Price_Pipeline_Product__c berubah di stage Negotation atau Quotation_Final untuk record type GSM -> upsert PNL
                    if (
                        Old.Rollup_Total_Price_Pipeline_Product__c != Opp.Rollup_Total_Price_Pipeline_Product__c &&
                        (Opp.StageName == 'Negotiation' || Opp.StageName == 'Quotation Final') &&
                        (Opp.RecordtypeName__c == 'GSM (Activation)' || Opp.RecordtypeName__c == 'Device Bundling' || Opp.RecordtypeName__c == 'Digital Advertising')
                    ) {
                        List_OppId_Negotation_OR_QuotationFinal.add(Opp.Id);
                    }

                    if(
                        Opp.Link_Related__c != Old.Link_Related__c &&
                        Opp.Link_Related__c != null &&
                        (Opp.RecordtypeName__c.Contains('Non GSM') || Opp.RecordtypeName__c.Contains('IoT')) &&
                        Opp.Profitability__c != null
                    ){
                        set_ProfitabilityIds_ChangeLink.add(Opp.Profitability__c);
                    }
                } //.. end for opportunities


                //-- Delete GSM Profitabilty when opportunity stage move to CLOSED LOST  
                if (set_ProfitabilityIds_DeleteAfterCloseLost != null && !set_ProfitabilityIds_DeleteAfterCloseLost.isEmpty()) {
                    List < Profitability__c > ProfitabilityList = [SELECT Id FROM Profitability__c WHERE Id IN: set_ProfitabilityIds_DeleteAfterCloseLost];
                    if (ProfitabilityList != null && !ProfitabilityList.isEmpty()) {
                        delete ProfitabilityList;
                    }
                }
                
                //-- Delete GSM Profitabilty when opportunity stage move to CLOSED Won          
                if (set_ProfitabilityIds_DeleteAfterCloseWon != null && !set_ProfitabilityIds_DeleteAfterCloseWon.isEmpty()) {
                    List < Profitability__c > ProfitabilityList = [SELECT Id FROM Profitability__c WHERE Opportunity__c IN: set_ProfitabilityIds_DeleteAfterCloseWon AND Status__c =: 'Forecast'];
                    if (ProfitabilityList != null && !ProfitabilityList.isEmpty()) {
                        delete ProfitabilityList;
                    }
                }
        
                //-- PUT/UPSERT GSM Profitabilty when opportunity stage move to Negotiation / Quotation Final  
                if (List_OppId_Negotation_OR_QuotationFinal != null && !List_OppId_Negotation_OR_QuotationFinal.isEmpty()) {
                    ProfitabilityController ProfitabilityController_class = new ProfitabilityController();
                    ProfitabilityController_class.Upsert_Profitability_GSM_Forecats(List_OppId_Negotation_OR_QuotationFinal);
                }

                if(set_ProfitabilityIds_ChangeLink!=null && !set_ProfitabilityIds_ChangeLink.isEmpty()){
                    Map<Id,Profitability__c> Profitability_Map = new Map<Id, Profitability__c>([SELECT Id, Name, CID__c FROM Profitability__c WHERE Id IN : set_ProfitabilityIds_ChangeLink]);

                    if(Profitability_Map!=null && !Profitability_Map.isEmpty()){
                        for (Opportunity Opp: system.trigger.new) {
                            Opportunity Old = Trigger.oldMap.get(Opp.id);

                           if(
                                Opp.Link_Related__c != Old.Link_Related__c &&
                                Opp.Link_Related__c != null &&
                                (Opp.RecordtypeName__c.Contains('Non GSM') || Opp.RecordtypeName__c.Contains('IoT')) &&
                                Opp.Profitability__c != null
                            ){
                                Profitability__c Profitability_Record = Profitability_Map.get(opp.Profitability__c);

                                Profitability_Record.CID__c = opp.Link_Related__c;
                                Profitability_Record.Name = opp.Link_ID__c;
                            }
                        }
                        update(Profitability_Map.values());
                    }
                }
            }
        }
    }
}