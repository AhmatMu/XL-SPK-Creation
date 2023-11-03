/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 22-09-2021
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   22-09-2021   Doddy Prima   Initial Version
**/

trigger SalesIncentiveTrigger on Sales_Incentive__c (after insert) {

    /* based on this pb
    Process Builder - sales incentive - report link update link with schedule
    Back To SetupHelp
    */
    
    /*

    List<Sales_Incentive__c> salesIncentiveToBeUpdateList = new List<Sales_Incentive__c>();
    Map<ID, String> sincMap = new Map<ID, String>();
    SET<ID> sincIDs = new SET<ID>(); 

    for(Sales_Incentive__c sinNewRec : Trigger.New) {

        system.debug('=== sinNewRec.Role_level__c : ' + sinNewRec.Role_level__c);
        system.debug('=== sinNewRec.Type__c : ' + sinNewRec.Type__c);

        sincIDs.add (sinNewRec.id);

        if (sinNewRec.Role_level__c == 'AM') {
            switch on sinNewRec.Type__c  {
                when 'Revenue Total' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Revenue_Total_AM__c;
                }
                when 'New Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_New_Revenue_AM__c;
                }
                when 'Net-Adds Mobile' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Net_Adds_Mobile_AM__c;
                }
                when 'Gross-Adds Mobile' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Gross_Adds_Mobile_AM__c;
                }
                when 'Net-Adds Fixed Links' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Net_Adds_Fixed_Links_AM__c;
                }
                when 'Gross-Adds Fixed Links' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_SincGross_Adds_Links_AM__c;
                }
                when 'Partnership Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Partnership_Revenue_AM__c;
                }
                when 'Pipeline PO' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Pipeline_PO_AM__c;
                }
                when 'Pipeline Total' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Pipeline_Total_AM__c;
                }
                when 'Pipeline New Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_Link_Sinc_Pipeline_New_Reven_AM__c;
                }
                when 'Pipeline BAU' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Pipeline_BAU_AM__c;
                }
                when 'Partnership Number' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Partnership_Number_AM__c;
                }
            }

        }

        else if (sinNewRec.Role_level__c == 'SM') {
            switch on sinNewRec.Type__c  {
                when 'Revenue Total' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Revenue_Total_SM__C;
                }
                when 'New Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_New_Revenue_SM__C;
                }
                when 'Net-Adds Mobile' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_Link_Nett_Adds_Mobile_SM__c;
                }
                when 'Gross-Adds Mobile' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Gross_Adds_Mobile_SM__C;
                }
                when 'Net-Adds Fixed Links' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_Link_Net_Adds_Links_SM__c;
                }
                when 'Gross-Adds Fixed Links' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Gross_Adds_Links_SM__C;
                }
                when 'Partnership Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Partnership_Revenue_SM__C;
                }
                when 'Pipeline PO' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Pipeline_PO_SM__C;
                }
                when 'Pipeline Total' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Pipeline_Total_SM__C;
                }
                /*
                when 'Pipeline New Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.??;
                }*/
/*                when 'Pipeline BAU' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Pipeline_BAU_SM__C;
                }
                when 'Partnership Number' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Partnership_Number_SM__C;
                }
            }
        
        }

        else if (sinNewRec.Role_level__c == 'GH') {
            switch on sinNewRec.Type__c  {
                when 'Revenue Total' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Sinc_Revenue_Total_GH__c;
                }
                when 'New Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_New_Revenue_GH__c;
                }
                when 'Net-Adds Mobile' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_Link_Nett_Adds_Mobile_GH__c;
                }
                when 'Gross-Adds Mobile' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Gross_Adds_Mobile_GH__c;
                }
                when 'Net-Adds Fixed Links' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_Link_Net_Adds_Links_GH__c;
                }
                when 'Gross-Adds Fixed Links' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Gross_Adds_Links_GH__c;
                }
                when 'Partnership Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Partnership_Revenue_GH__c;
                }
                when 'Pipeline PO' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Pipeline_PO_GH__c;
                }
                when 'Pipeline Total' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Pipeline_Total_GH__c;
                }
                when 'Pipeline New Revenue' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_New_Revenue_GH__c;
                }
                when 'Pipeline BAU' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Pipeline_BAU_GH__c;
                }
                when 'Partnership Number' {
                    sinNewRec.report_link_actual_detail_by_type_3__c = sinNewRec.Report_link_Partnership_Number_GH__c;
                }
            }
        }

        //-- add sales incentive record after update to the list
        /*
        Sales_Incentive__c sincTemp = 
            new Sales_Incentive__c (id = sinNewRec.id,  
                    report_link_actual_detail_by_type_3__c = sinNewRec.report_link_actual_detail_by_type_3__c);

        salesIncentiveToBeUpdateList.add (sinNewRec.id, sinNewRec.report_link_actual_detail_by_type_3__c );
        */
/*
        sincMap.put (sinNewRec.id, sinNewRec.report_link_actual_detail_by_type_3__c  );
    } 


    salesIncentiveToBeUpdateList =  [SELECT 
        id, report_link_actual_detail_by_type_3__c 
    FROM Sales_Incentive__c
    WHERE id in :sincIDs
    ];


    for (Sales_Incentive__c sincREC : salesIncentiveToBeUpdateList) {
        sincREC.report_link_actual_detail_by_type_3__c = sincMap.get (sincREC.id);
    }

    
    //update Trigger.New;
    update salesIncentiveToBeUpdateList;
      */
}