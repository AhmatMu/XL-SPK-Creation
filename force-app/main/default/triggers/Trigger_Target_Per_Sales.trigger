/*
    Created By : Victor S
    16 Maret 2020
    
*/

trigger Trigger_Target_Per_Sales on Target_Per_Sales__c (before update,before insert) {
	List<Target__c> lTarget = new List<Target__c>();
	List<Target_Per_Sales__c> lTargetPerSales = new List<Target_Per_Sales__c>();
	list<target_per_sales__c> lprevious=[SELECT Sales__c,id,gap_gsm__c,After_Recurring_Churn__c,Gap_After_New_Stream_Churn__c,revenue_gsm__c,revenue_non_gsm__c,revenueperlink__c,churn_bap__c,Target_Active_Link_Non_GSM__c,Target_Additional_Link_Non_GSM__c FROM Target_per_sales__c];
    for(Target_Per_Sales__c myTargetPerSales : trigger.new){
    	
			if(trigger.isUpdate && trigger.isbefore)
			{
			target_per_sales__c Told=Trigger.oldMap.get(mytargetpersales.id);
			if(myTargetPerSales.Target_Timeline__c == 'Baseline'){
    		if(myTargetPerSales.Revenue_GSM__c != null && myTargetPerSales.Revenue_IOT__c != null && myTargetPerSales.Revenue_M_ads__c != null && myTargetPerSales.Revenue_Non_GSM__c != null && myTargetPerSales.Revenue_VOIP__c != null && myTargetPerSales.HasGenerateSecondBaseline__c == false){
    			lTarget = [SELECT id FROM Target__c WHERE Parent_Target__c = :myTargetPerSales.Target__c AND Timeline__c = 'Baseline/3' AND type_Segment__c=:mytargetpersales.segment__c AND Parent_Target__c=:mytargetpersales.target__c];
    		
	    		if(lTarget.size() == 1){
	    			Target_Per_Sales__c newTargetPerSales = myTargetPerSales.clone(false);
		    		newTargetPerSales.Revenue_GSM__c = myTargetPerSales.Revenue_GSM__c / 3;
		    		newTargetPerSales.Revenue_IOT__c = myTargetPerSales.Revenue_IOT__c / 3;
		    		newTargetPerSales.Revenue_M_ads__c = myTargetPerSales.Revenue_M_ads__c / 3;
		    		newTargetPerSales.Revenue_Non_GSM__c = myTargetPerSales.Revenue_Non_GSM__c / 3;
					newTargetPerSales.Revenue_VOIP__c = myTargetPerSales.Revenue_VOIP__c / 3;
					newtargetpersales.churn_bap__c=mytargetpersales.churn_bap__c;
		    		newTargetPerSales.Target__c = lTarget[0].id;
					newtargetpersales.revenueperlink__c=mytargetpersales.revenueperlink__c;
					newtargetpersales.Target_Active_Link_Non_GSM__c=Integer.valueof(newtargetpersales.revenue_non_gsm__c/mytargetpersales.revenueperlink__c);
					newtargetpersales.created_by_system__c=true;
					lTargetPerSales.add(newTargetPerSales);
	    		}
	    		myTargetPerSales.HasGenerateSecondBaseline__c = true;
			}
		}
			
			if((told.revenue_gsm__c!=mytargetpersales.revenue_gsm__c||told.revenue_non_gsm__c!=mytargetpersales.revenue_non_gsm__c) && mytargetpersales.previous_target__c!=null)
			{
				target_per_sales__c previous=new target_per_sales__c();
				for(target_per_sales__c TPS:lprevious)
				{
					if(TPS.id==mytargetpersales.previous_target__C)
					{
						previous=TPS;
					}
				}
				if(previous.after_recurring_churn__c!=null && previous.after_recurring_churn__c!=0)
				mytargetpersales.After_Recurring_Churn__c=previous.after_recurring_churn__c*(1-(Decimal.valueof(system.label.SME_Recurring_Churn)/100));
				else
				mytargetpersales.After_Recurring_Churn__c=previous.revenue_gsm__c*(1-(Decimal.valueof(system.label.SME_Recurring_Churn)/100));
                
				if(previous.Gap_GSM__c==null||previous.Gap_GSM__c==0)
				{
					mytargetpersales.Gap_After_New_Stream_Churn__c=0;   
				}
				else {
					mytargetpersales.Gap_After_New_Stream_Churn__c=previous.Gap_GSM__c*(1-Decimal.valueof(system.label.SME_New_Stream_Churn)/100);
				}
				
				mytargetpersales.Gap_GSM__c=mytargetpersales.revenue_gsm__c-mytargetpersales.After_Recurring_Churn__c-mytargetpersales.Gap_After_New_Stream_Churn__c;
				if(mytargetpersales.GAP_GSM__c<=0)
					mytargetpersales.gap_gsm__c=0;
				mytargetpersales.PostPaid_Revenue__c=mytargetpersales.Gap_GSM__c*Decimal.valueof(system.label.SME_Postpaid)/100;
				mytargetpersales.PrePaid_Revenue__c=mytargetpersales.Gap_GSM__c*Decimal.valueof(system.label.SME_Prepaid)/100;
				mytargetpersales.Prepaid_Sub__c=mytargetpersales.Prepaid_Revenue__c/Decimal.valueof(system.label.ARPU_Prepaid);
						if(mytargetpersales.prepaid_sub__c<10)
						{
							mytargetpersales.prepaid_sub__c=10;
						}
						mytargetpersales.Postpaid_sub__c=mytargetpersales.Postpaid_Revenue__c/Decimal.valueof(system.label.ARPU_postpaid);
						if(mytargetpersales.postpaid_sub__c<10)
						{
							mytargetpersales.postpaid_sub__c=10;
						}
						/* link target per sales*/
						mytargetpersales.revenueperlink__c=previous.revenueperlink__c;
						if(mytargetpersales.churn_bap__c<=0)
						mytargetpersales.churn_bap__c=previous.churn_bap__c;
						mytargetpersales.Target_Active_Link_Non_GSM__c=Integer.valueof(mytargetpersales.revenue_non_gsm__c/mytargetpersales.revenueperlink__c);
						mytargetpersales.Target_Additional_Link_Non_GSM__c=Integer.valueof(mytargetpersales.Target_Active_Link_Non_GSM__c-previous.target_active_link_non_gsm__c+mytargetpersales.churn_bap__c);
						if(mytargetpersales.target_additional_link_non_gsm__c<10)
						mytargetpersales.target_additional_link_non_gsm__c=10;
			}

		}
		if(trigger.isbefore && trigger.isinsert)
		{
			if(myTargetPerSales.Target_Timeline__c == 'Baseline'){
			List<AggregateResult> AGR=[SELECT COUNT(ID) TotalLink,SUM(Contract_item_rel__r.Price__c) totalprice FROM Link__c WHERE Free_Link__c=false and Status_Link__c='IN_SERVICE' AND Contract_item_rel__r.Account.ownerid=:mytargetpersales.sales__c];
			
			if(AGR.size()>0 && AGR[0].get('Totalprice')!=null)
			{
			mytargetpersales.RevenuePerLink__c=(Decimal)AGR[0].get('Totalprice')/(Decimal) AGR[0].get('TotalLink');
			}
			if(mytargetpersales.revenueperlink__c==1)
			{
				target__c tar=[SELECT Revenueperlink__c from Target__c WHERE ID=:mytargetpersales.target__c];
				mytargetpersales.revenueperlink__c=tar.revenueperlink__c;
			}
			mytargetpersales.Target_Active_Link_Non_GSM__c=mytargetpersales.revenue_non_gsm__c/mytargetpersales.revenueperlink__c;
		}
		}
    	
    }
    insert lTargetPerSales;
}