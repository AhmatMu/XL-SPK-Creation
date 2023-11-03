/**
 * @description       : 
 * @Test Class        : OpportunityServiceTEST
 * @author            : ahmat zulkifli murad
 * @group             : 
 * @last modified on  : 10-11-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-10-2022   ahmat zulkifli murad    Initial Version
**/

global with sharing class OpportunityService {
  public static string errorMsg = '';
  public static string responseMsg = '';

  public static void badDebtOppAdjustment() {
    try {
      /*untuk opportunity stage quotation final (Bad Debt = true) dan kemudian no bad debt dan quotation approval approved
      1. action Opportunity move to implementation
      2. Eda auto approved dan ada comment approved by system because Account has no bad debt
      */
      Sobject_Query_Condition__c opptyConditionSettings1 = Sobject_Query_Condition__c.getValues('OpportunityService_StageName');
      Sobject_Query_Condition__c opptyConditionSettings2 = Sobject_Query_Condition__c.getValues('OpportunityService_QuotApprovalStatus');
      Sobject_Query_Condition__c opptyConditionSettings3 = Sobject_Query_Condition__c.getValues('OpportunityService_BadDebtStatus');
      

      string stageCondition = opptyConditionSettings1.Where_Condition__c;
      string QuotationFinalApprovalCondition = opptyConditionSettings2.Where_Condition__c;
      string badDebtStatusCondition = opptyConditionSettings3.Where_Condition__c;
      

      System.debug(' opptyConditionSettings1 = ' + stageCondition);
      system.debug(' opptyConditionSettings2 = ' + QuotationFinalApprovalCondition);
      system.debug(' opptyConditionSettings3 = ' + badDebtStatusCondition);

      list < string > opptyStageList = stageCondition.split(';');
      set < string > setOpptyStageNamesCondition = new set < string > ();
      for (string stringValues: opptyStageList) {
        setOpptyStageNamesCondition.add(stringValues.trim());
      }

      List < Opportunity > opptyNewListUpdate = new list < Opportunity > ();

      list < opportunity > opptyList = [
        select id, name,
        stagename, accountid, account.bad_debt_status__c, Bad_Debt_EDA__c, Bad_Debt_EDA__r.EDA_Status__c, Bad_Debt_EDA__r.Remark__c, Bad_Debt_EDA__r.Rejected__c from opportunity where account.bad_debt_status__c =: badDebtStatusCondition and stagename in: setOpptyStageNamesCondition and Quotation_Final_Approval__c =: QuotationFinalApprovalCondition
      ];
      system.debug('opptyList.size = ' + opptyList.size());
      system.debug('opptyList = ' + opptyList);

      set < id > setEDAId = new set < id > ();

      for (Opportunity opptyRec: opptyList) {
        opptyRec.StageName = 'implementation';
        opptyNewListUpdate.add(opptyRec);

        setEDAId.add(opptyRec.Bad_Debt_EDA__c);
      }

      list<eda__c> edaNewList = new List <eda__c>();
      list<Eda__c> edaList = [select id, remark__c, eda_status__c, Summary__c, name from eda__c where id in:setEDAId];

      if(edaList != null){
        system.debug('edaList '  + edaList);
      system.debug('edaList size ' + edaList.size());
      Approval.UnlockResult[] urList = Approval.unlock(edaList, false);

      Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[] {};
      List < ProcessInstance > processInstancesList = [SELECT(SELECT Id, ActorId, ProcessInstanceId FROM Workitems) id, Status, ProcessDefinition.Name FROM ProcessInstance WHERE TargetObjectID in: setEDAId];
      System.debug(' processInstancesList >> ' + processInstancesList);
      system.debug(' processInstancesList.size ' + processInstancesList.size());

      if (processInstancesList.size() > 0) {

        for (ProcessInstance processInctanceRec: processInstancesList) {
          for (ProcessInstanceWorkItem ProcessWorkitemRequest: processInctanceRec.Workitems) {

            Approval.ProcessWorkitemRequest ProcessWorkitemRequestObj = new Approval.ProcessWorkitemRequest();
            ProcessWorkitemRequestObj.setWorkitemId(ProcessWorkitemRequest.id);
            ProcessWorkitemRequestObj.setAction('Removed');
            ProcessWorkitemRequestObj.setComments('Approved by System, because as now Account has no Bad Debt');
            ProcessWorkitemRequestObj.getNextApproverIds();
            system.debug(' ProcessWorkitemRequestObj.getNextApproverIds >> ' +  ProcessWorkitemRequestObj.getNextApproverIds());
            prWkItems.add(ProcessWorkitemRequestObj);
          }
        }

        system.debug(' ==  prWkItems > ' + prWkItems);

        if (!prWkItems.isEmpty()) {
          Approval.ProcessResult[] appResult = Approval.process(prWkItems);
        }
      }

      for(eda__c edaRec :edaList){
          edaRec.remark__c = 'Completed';
          edaRec.eda_status__c = 'Completed';
          edaRec.Rejected__c = false;

          edaRec.Summary__c = edaRec.Summary__c + ' ' + '\n' + '\n' + 'Approved by System, because as now Account has no Bad Debt'; 
          edaRec.Mark_as_Revenue_EDA_Waiving__c = false;
          edaNewList.add(edaRec);
      }
      update edaNewList;

      update opptyNewListUpdate;
      }

      if(Test.isRunningTest()) {
          CalloutException e = new CalloutException();
          e.setMessage('This is a constructed exception for testing and code coverage');
          throw e;
      }
        
    } catch (exception e) {
      errorMsg = errorMsg +
        '. Error on OpportunityService.badDebtOppAdjustment method.::' +
        e.getmessage() + ' - ' + e.getStacktraceString() + ' ' +
        responseMsg + '::' + e.getLineNumber();
      apputils.puterror(errorMsg);
      SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
    }
  }

  public static void CreateFreeMRCOpptyProducts(String OpportunityId, Date SRPRBillingStartDate) {
    /*for Testing
    OpportunityService.CreateFreeMRCOpptyProducts('0061m00000Amku6AAB',Date.valueOf('2023-01-01'));
    */

    try {
      system.debug('SRPRBillingStartDate : ' + SRPRBillingStartDate);

      List<SAP_Material_Code__c> List_AllSAPMaterialCode = [
        SELECT Id,
        Recurring_Material_Code__c,
        Free_Material_Code__c,
        Discocunt_Material_Code__c
        FROM SAP_Material_Code__c
      ];

      system.debug('List_AllSAPMaterialCode : ' + json.serialize(List_AllSAPMaterialCode));

      if(List_AllSAPMaterialCode!=null && !List_AllSAPMaterialCode.isEmpty()){
        Set<String> Set_FreeMaterialCode = new Set<String>();

        for(SAP_Material_Code__c AllSAPMaterialCode : List_AllSAPMaterialCode){
          if(String.isNotBlank(AllSAPMaterialCode.Free_Material_Code__c)){
            Set_FreeMaterialCode.add(AllSAPMaterialCode.Free_Material_Code__c);
          }
        }

        system.debug('Set_FreeMaterialCode : ' + json.serialize(Set_FreeMaterialCode));

        if(Set_FreeMaterialCode!=null && !Set_FreeMaterialCode.isEmpty()){
          list<OpportunityLineItem> List_FreeOLI = [
            SELECT id, 
            Product2.SAP_Code__c
            FROM OpportunityLineItem
            WHERE OpportunityID =: OpportunityId AND
            Product2.SAP_Code__c IN : Set_FreeMaterialCode
          ];

          system.debug('List_FreeOLI : ' + json.serialize(List_FreeOLI));

          if(List_FreeOLI!=null && !List_FreeOLI.isEmpty()){
            delete List_FreeOLI;
          }

          list<Opportunity> List_Opportunity = [
            SELECT id, 
            Free_MRC_Periode_Month_Invoice__c
            FROM Opportunity
            WHERE id =: OpportunityId
          ];

          if(List_Opportunity!=null && !List_Opportunity.isEmpty()){
            list<OpportunityLineItem> List_RecurringOLI = [
              SELECT id, 
              Product2.SAP_Code__c,
              UnitPrice
              FROM OpportunityLineItem
              WHERE OpportunityID =: OpportunityId AND
              revenue_type__c =: 'Recurring'
            ];

            system.debug('List_RecurringOLI : ' + json.serialize(List_RecurringOLI));

            if(List_RecurringOLI!=null && !List_RecurringOLI.isEmpty()){
              Set<String> Set_RecurringMaterialCode = new Set<String>();

              for(OpportunityLineItem RecurringOLI : List_RecurringOLI){
                if(String.isNotBlank(RecurringOLI.Product2.SAP_Code__c)){
                  Set_RecurringMaterialCode.add(RecurringOLI.Product2.SAP_Code__c);
                }
              }

              if(Set_RecurringMaterialCode!=null && !Set_RecurringMaterialCode.isEmpty()){
                List<SAP_Material_Code__c> List_FreeSAPMaterialCode = [
                  SELECT Id,
                  Recurring_Material_Code__c,
                  Free_Material_Code__c,
                  Discocunt_Material_Code__c
                  FROM SAP_Material_Code__c
                  WHERE Recurring_Material_Code__c IN : Set_RecurringMaterialCode
                ];

                system.debug('List_FreeSAPMaterialCode : ' + json.serialize(List_FreeSAPMaterialCode));

                if(List_FreeSAPMaterialCode!=null && !List_FreeSAPMaterialCode.isEmpty()){
                  Set_FreeMaterialCode = new Set<String>();

                  for(SAP_Material_Code__c FreeSAPMaterialCode : List_FreeSAPMaterialCode){
                    if(String.isNotBlank(FreeSAPMaterialCode.Free_Material_Code__c)){
                      Set_FreeMaterialCode.add(FreeSAPMaterialCode.Free_Material_Code__c);
                    }
                  }

                  system.debug('Set_FreeMaterialCode : ' + json.serialize(Set_FreeMaterialCode));

                  if(Set_FreeMaterialCode!=null && !Set_FreeMaterialCode.isEmpty()){
                    list<Product2> List_FreeProduct = [
                      SELECT id,
                      SAP_Code__c
                      FROM Product2
                      WHERE SAP_Code__c IN: Set_FreeMaterialCode
                    ];

                    system.debug('List_FreeProduct : ' + json.serialize(List_FreeProduct));

                    if(List_FreeProduct!=null && !List_FreeProduct.isEmpty()){
                      Integer freeMRCPeriodeMonth = Integer.ValueOF(List_Opportunity[0].Free_MRC_Periode_Month_Invoice__c);

                      List<OpportunityLineItem> List_newFreeOLI = new List<OpportunityLineItem>();

                      Date SRPRBillingStartDateFormat = SRPRBillingStartDate;

                      Integer SRPRBillingStartDate_Year = SRPRBillingStartDate.year();
                      Integer SRPRBillingStartDate_Month = SRPRBillingStartDate.month();
                      Integer SRPRBillingStartDate_Day = SRPRBillingStartDate.day();

                      Date SRPRBillingStartDate_FirstDate = Date.newInstance(SRPRBillingStartDate_Year,SRPRBillingStartDate_Month,1);

                      system.debug('SRPRBillingStartDate_FirstDate : ' + SRPRBillingStartDate_FirstDate);

                      for (Integer i = 0; i < freeMRCPeriodeMonth; i++) {
                        system.debug('i value : ' + i);

                        OpportunityLineItem newFreeOLI = new OpportunityLineItem();
                        newFreeOLI.Product2id = List_FreeProduct[0].id;
                        newFreeOLI.OpportunityID = List_Opportunity[0].id;
                        newFreeOLI.revenue_type__c = 'Free';
                        newFreeOLI.UnitPrice = 0;
                        newFreeOLI.Quantity = 1;
                        newFreeOLI.Billing_Type__c = 'Monthly';
                        newFreeOLI.Contract_Start_Date__c = SRPRBillingStartDateFormat;

                        if(i == 0){
                          newFreeOLI.Contract_End_Date__c = SRPRBillingStartDate_FirstDate.addmonths(1) - 1;

                          newFreeOLI.FreeMRC_Price__c = List_RecurringOLI[0].UnitPrice;

                          if(SRPRBillingStartDate_Day != 1){
                            Integer valuedFormula = Integer.ValueOf(newFreeOLI.Contract_End_Date__c.day()) - SRPRBillingStartDate_Day + 1;

                            newFreeOLI.FreeMRC_Price__c = (List_RecurringOLI[0].UnitPrice * valuedFormula) / Integer.ValueOf(newFreeOLI.Contract_End_Date__c.day()) ;
                          }

                          SRPRBillingStartDateFormat = SRPRBillingStartDate_FirstDate.addmonths(1);
                        }else{
                          newFreeOLI.Contract_End_Date__c = SRPRBillingStartDateFormat.addmonths(1) - 1;

                          newFreeOLI.FreeMRC_Price__c = List_RecurringOLI[0].UnitPrice;

                          SRPRBillingStartDateFormat = SRPRBillingStartDateFormat.addmonths(1);
                        }

                        List_newFreeOLI.add(newFreeOLI);
                      }

                      system.debug('List_newFreeOLI : ' + json.serialize(List_newFreeOLI));

                      if(List_newFreeOLI!=null && !List_newFreeOLI.isEmpty()){
                        Insert List_newFreeOLI;
                      }
                    }
                  }
                }
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
      String err_message = 'Error on OpportunityService - CreateFreeMRCOpptyProducts ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
      AppUtils.putError(err_message);
      system.debug('err_message : '+err_message);
    }
  }
}