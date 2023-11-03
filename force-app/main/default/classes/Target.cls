/*
    Created By : Victor S
    18 Maret 2020
    
*/

public with sharing class Target {
	List<Target_Per_Sales__c> lTargetPerSales = new List<Target_Per_Sales__c>();
	List<Target_Per_Sales__c> lNewTargetPerSales = new List<Target_Per_Sales__c>();
    
    Target__c myTarget = new Target__c();
    User myUser = new User();
    Double Total_ChurnBAP;
	Double Total_TargetActiveLinkNonGSM;
	Double Total_TargetAdditionalLinkNonGSM;
	Double Total_RevenueGSM;
	Double Total_RevenueIOT;
	Double Total_RevenueMads;
	Double Total_RevenueNonGSM;
	Double Total_RevenueVOIP;
	
    public Target(){
    	Total_ChurnBAP = 0;
		Total_TargetActiveLinkNonGSM = 0;
		Total_TargetAdditionalLinkNonGSM = 0;
		Total_RevenueGSM = 0;
		Total_RevenueIOT = 0;
		Total_RevenueMads = 0;
		Total_RevenueNonGSM = 0;
		Total_RevenueVOIP = 0;
	}
	public void updateQuarter(String Quarter)
	{
		//update created target AM per Quarter
		String Month1='';
        String Month2='';
        String Month3='';
        Integer year=system.today().year();
        if(Quarter=='Quarter 1'||test.isRunningTest())
        {
             Month1='January';
             Month2='February';
             Month3='March';
             year=year+1;
        }
        if(Quarter=='Quarter 2'||test.isRunningTest())
        {
             Month1='April';
             Month2='May';
             Month3='June';
        }
        if(Quarter=='Quarter 3'||test.isRunningTest())
        {
             Month1='July';
             Month2='August';
             Month3='September';
        }
        if(Quarter=='Quarter 4'||test.isRunningTest())
        {
             Month1='October';
             Month2='November';
             Month3='December';
             
		}
		List<Target_Per_Sales__c> lquarter=[SELECT id,sales__c,revenue_gsm__c,revenue_non_gsm__c,revenue_voip__c,revenue_iot__c,revenue_m_ads__c from target_per_sales__c WHERE Target_timeline__c=:Quarter ];
		for(target_per_sales__c TPSQuarter:lquarter)
		{
			list<AggregateResult> Targetthree=[SELECT SUM(Revenue_GSM__c) GSM,SUM(Revenue_non_gsm__c) NONGSM,SUM(Revenue_IOT__c) IOT,SUM(Revenue_M_Ads__c) MADS,SUM(Revenue_VOIP__c) VOIP FROM Target_per_sales__c WHERE Target_Timeline__c='Monthly Target' AND Year_Target__c=:year AND (Month_Target__c=:Month1 OR Month_Target__c=:Month2 OR Month_Target__c=:Month3) AND Sales__c=:TPSQuarter.sales__c];
			TPSQuarter.revenue_GSM__c=(Decimal)Targetthree[0].get('GSM');
			TPSQuarter.revenue_NON_GSM__c=(Decimal)Targetthree[0].get('NONGSM');
			TPSQuarter.revenue_VOIP__c=(Decimal)Targetthree[0].get('VOIP');
			TPSQuarter.revenue_IOT__c=(Decimal)Targetthree[0].get('IOT');
			TPSQuarter.revenue_M_Ads__c=(Decimal)Targetthree[0].get('MADS');
		}
		update lquarter;
	}
    public Void CalculateAll(String MonthTarget,Integer YearTarget,String Segment)
	{
		//create quarter target for AM/Sales
		lNewTargetPerSales=new List<Target_Per_Sales__c>();
		list<Target_Per_Sales__c> TPS=[SELECT id,Sales__c,Segment__c FROM Target_Per_Sales__c WHERE Month_Target__c=:Monthtarget AND Year_target__c=:Yeartarget AND Segment__c=:Segment];
		for(Integer i=0;i<Tps.size();i++)
		{
			
			generateTargetPerSales(MonthTarget, yearTarget, TPS[i].Segment__c, TPS[i].Sales__c);
	//		if(lNewTargetPerSales.size()==1)
    
		}
		
		insert lNewTargetPerSales;
	}

    public void generateTargetPerSales(String monthTarget, Integer yearTarget, String typeSegment, String UserId){
		//Add 3 monthly target to create quarter
		Total_ChurnBAP = 0;
		Total_TargetActiveLinkNonGSM = 0;
		Total_TargetAdditionalLinkNonGSM = 0;
		Total_RevenueGSM = 0;
		Total_RevenueIOT = 0;
		Total_RevenueMads = 0;
		Total_RevenueNonGSM = 0;
		Total_RevenueVOIP = 0;
		decimal totaladditionallink=0;
		decimal totalsubprepaid=0;
		decimal totalsubpostpaid=0;
		lTargetPerSales = [SELECT id, Month_Target__c, Churn_BAP__c,revenueperlink__c,gap_gsm__c,prepaid_sub__c,postpaid_sub__c, Target_Active_Link_Non_GSM__c, Target_Additional_Link_Non_GSM__c, Revenue_GSM__c, Revenue_IOT__c, Revenue_M_ads__c, Revenue_Non_GSM__c, Revenue_VOIP__c FROM Target_Per_Sales__c WHERE Year_Target__c = :yearTarget AND Segment__c = :typeSegment AND Sales__c = :UserId];
    	Target_Per_Sales__c newTargetPerSales = new Target_Per_Sales__c();
    	if(monthTarget == 'March'){
    		myTarget = [SELECT id FROM Target__c WHERE Year_Target__c = :yearTarget AND Type_Segment__c = :typeSegment AND Timeline__c = 'Quarter 1'];
    		for(Target_Per_Sales__c myPreviousTargetPerSales : lTargetPerSales){
    			if(myPreviousTargetPerSales.Month_Target__c == 'January' || myPreviousTargetPerSales.Month_Target__c == 'February' || myPreviousTargetPerSales.Month_Target__c == 'March'){
    				Total_ChurnBAP = Total_ChurnBAP + myPreviousTargetPerSales.Churn_BAP__c;
    		//		Total_TargetActiveLinkNonGSM = Total_TargetActiveLinkNonGSM + myPreviousTargetPerSales.Target_Active_Link_Non_GSM__c;
	        		Total_TargetAdditionalLinkNonGSM = Total_TargetAdditionalLinkNonGSM + myPreviousTargetPerSales.Target_Additional_Link_Non_GSM__c;
	        		Total_RevenueGSM = Total_RevenueGSM + myPreviousTargetPerSales.Revenue_GSM__c;
	        		Total_RevenueIOT = Total_RevenueIOT + myPreviousTargetPerSales.Revenue_IOT__c;
	        		Total_RevenueMads = Total_RevenueMads + myPreviousTargetPerSales.Revenue_M_ads__c;
	        		Total_RevenueNonGSM = Total_RevenueNonGSM + myPreviousTargetPerSales.Revenue_Non_GSM__c;
					Total_RevenueVOIP = Total_RevenueVOIP + myPreviousTargetPerSales.Revenue_VOIP__c;
					newTargetPerSales.revenueperlink__c=myPreviousTargetPerSales.revenueperlink__c;
					totaladditionallink=totaladditionallink+myprevioustargetpersales.Target_Additional_Link_Non_GSM__c;
					totalsubpostpaid=totalsubpostpaid+myPreviousTargetPerSales.postpaid_sub__c;
					totalsubprepaid=totalsubprepaid+myPreviousTargetPerSales.prepaid_sub__c;
    			}
			}
			newTargetPerSales.Churn_BAP__c = Total_ChurnBAP;
			
		//	newTargetPerSales.Target_Active_Link_Non_GSM__c = Total_TargetActiveLinkNonGSM;
    		newTargetPerSales.Target_Additional_Link_Non_GSM__c = Total_TargetAdditionalLinkNonGSM;
    		newTargetPerSales.Revenue_GSM__c = Total_RevenueGSM;
    		newTargetPerSales.Revenue_IOT__c = Total_RevenueIOT;
    		newTargetPerSales.Revenue_M_ads__c = Total_RevenueMads;
			newTargetPerSales.Revenue_Non_GSM__c = Total_RevenueNonGSM;
				newTargetPerSales.Revenue_VOIP__c = Total_RevenueVOIP;
    		newTargetPerSales.Sales__c = UserId;
			newTargetPerSales.Target__c = myTarget.id;
			newTargetPerSales.Target_Active_Link_Non_GSM__c=newTargetPerSales.revenue_non_gsm__c/newTargetPerSales.revenueperlink__c;
			newTargetPerSales.prepaid_sub__c=totalsubprepaid;
			newTargetPerSales.postpaid_sub__c=totalsubprepaid;
			newtargetpersales.Target_Additional_Link_Non_GSM__c=totaladditionallink;
			newtargetpersales.created_by_system__c=true;
			lNewTargetPerSales.add(newTargetPerSales);
    	} else if(monthTarget == 'June'){
    		myTarget = [SELECT id FROM Target__c WHERE Year_Target__c = :yearTarget AND Type_Segment__c = :typeSegment AND Timeline__c = 'Quarter 2'];
    		for(Target_Per_Sales__c myPreviousTargetPerSales : lTargetPerSales){
    			if(myPreviousTargetPerSales.Month_Target__c == 'April' || myPreviousTargetPerSales.Month_Target__c == 'May' || myPreviousTargetPerSales.Month_Target__c == 'June'){
    				Total_ChurnBAP = Total_ChurnBAP + myPreviousTargetPerSales.Churn_BAP__c;
    			//	Total_TargetActiveLinkNonGSM = Total_TargetActiveLinkNonGSM + myPreviousTargetPerSales.Target_Active_Link_Non_GSM__c;
	        		Total_TargetAdditionalLinkNonGSM = Total_TargetAdditionalLinkNonGSM + myPreviousTargetPerSales.Target_Additional_Link_Non_GSM__c;
	        		Total_RevenueGSM = Total_RevenueGSM + myPreviousTargetPerSales.Revenue_GSM__c;
	        		Total_RevenueIOT = Total_RevenueIOT + myPreviousTargetPerSales.Revenue_IOT__c;
	        		Total_RevenueMads = Total_RevenueMads + myPreviousTargetPerSales.Revenue_M_ads__c;
	        		Total_RevenueNonGSM = Total_RevenueNonGSM + myPreviousTargetPerSales.Revenue_Non_GSM__c;
					Total_RevenueVOIP = Total_RevenueVOIP + myPreviousTargetPerSales.Revenue_VOIP__c;
					newTargetPerSales.revenueperlink__c=myPreviousTargetPerSales.revenueperlink__c;
					totaladditionallink=totaladditionallink+myprevioustargetpersales.Target_Additional_Link_Non_GSM__c;
					totalsubpostpaid=totalsubpostpaid+myPreviousTargetPerSales.postpaid_sub__c;
					totalsubprepaid=totalsubprepaid+myPreviousTargetPerSales.prepaid_sub__c;
    			} 
			}
			newTargetPerSales.Churn_BAP__c = Total_ChurnBAP;
			//newTargetPerSales.Target_Active_Link_Non_GSM__c = Total_TargetActiveLinkNonGSM;
    		newTargetPerSales.Target_Additional_Link_Non_GSM__c = Total_TargetAdditionalLinkNonGSM;
    		newTargetPerSales.Revenue_GSM__c = Total_RevenueGSM;
    		newTargetPerSales.Revenue_IOT__c = Total_RevenueIOT;
    		newTargetPerSales.Revenue_M_ads__c = Total_RevenueMads;
    		newTargetPerSales.Revenue_Non_GSM__c = Total_RevenueNonGSM;
    		newTargetPerSales.Revenue_VOIP__c = Total_RevenueVOIP;
    		newTargetPerSales.Sales__c = UserId;
    		newTargetPerSales.Target__c = myTarget.id;
			newTargetPerSales.Target_Active_Link_Non_GSM__c=newTargetPerSales.revenue_non_gsm__c/newTargetPerSales.revenueperlink__c;
			newTargetPerSales.prepaid_sub__c=totalsubprepaid;
			newTargetPerSales.postpaid_sub__c=totalsubprepaid;
			newtargetpersales.Target_Additional_Link_Non_GSM__c=totaladditionallink;
			newtargetpersales.created_by_system__c=true;
			lNewTargetPerSales.add(newTargetPerSales);
    	} else if(monthTarget == 'September'){
    		myTarget = [SELECT id FROM Target__c WHERE Year_Target__c = :yearTarget AND Type_Segment__c = :typeSegment AND Timeline__c = 'Quarter 3'];
    		for(Target_Per_Sales__c myPreviousTargetPerSales : lTargetPerSales){
    			if(myPreviousTargetPerSales.Month_Target__c == 'July' || myPreviousTargetPerSales.Month_Target__c == 'August' || myPreviousTargetPerSales.Month_Target__c == 'September'){
    				Total_ChurnBAP = Total_ChurnBAP + myPreviousTargetPerSales.Churn_BAP__c;
    			//	Total_TargetActiveLinkNonGSM = Total_TargetActiveLinkNonGSM + myPreviousTargetPerSales.Target_Active_Link_Non_GSM__c;
	        		Total_TargetAdditionalLinkNonGSM = Total_TargetAdditionalLinkNonGSM + myPreviousTargetPerSales.Target_Additional_Link_Non_GSM__c;
	        		Total_RevenueGSM = Total_RevenueGSM + myPreviousTargetPerSales.Revenue_GSM__c;
	        		Total_RevenueIOT = Total_RevenueIOT + myPreviousTargetPerSales.Revenue_IOT__c;
	        		Total_RevenueMads = Total_RevenueMads + myPreviousTargetPerSales.Revenue_M_ads__c;
	        		Total_RevenueNonGSM = Total_RevenueNonGSM + myPreviousTargetPerSales.Revenue_Non_GSM__c;
					Total_RevenueVOIP = Total_RevenueVOIP + myPreviousTargetPerSales.Revenue_VOIP__c;
					newTargetPerSales.revenueperlink__c=myPreviousTargetPerSales.revenueperlink__c;
					totaladditionallink=totaladditionallink+myprevioustargetpersales.Target_Additional_Link_Non_GSM__c;
					totalsubpostpaid=totalsubpostpaid+myPreviousTargetPerSales.postpaid_sub__c;
					totalsubprepaid=totalsubprepaid+myPreviousTargetPerSales.prepaid_sub__c;
    			} 
			}
			newTargetPerSales.Churn_BAP__c = Total_ChurnBAP;
		//	newTargetPerSales.Target_Active_Link_Non_GSM__c = Total_TargetActiveLinkNonGSM;
    		newTargetPerSales.Target_Additional_Link_Non_GSM__c = Total_TargetAdditionalLinkNonGSM;
    		newTargetPerSales.Revenue_GSM__c = Total_RevenueGSM;
    		newTargetPerSales.Revenue_IOT__c = Total_RevenueIOT;
    		newTargetPerSales.Revenue_M_ads__c = Total_RevenueMads;
    		newTargetPerSales.Revenue_Non_GSM__c = Total_RevenueNonGSM;
    		newTargetPerSales.Revenue_VOIP__c = Total_RevenueVOIP;
			newTargetPerSales.Sales__c = UserId;
			newTargetPerSales.Target__c = myTarget.id;
			newTargetPerSales.Target_Active_Link_Non_GSM__c=newTargetPerSales.revenue_non_gsm__c/newTargetPerSales.revenueperlink__c;
			newTargetPerSales.prepaid_sub__c=totalsubprepaid;
			newTargetPerSales.postpaid_sub__c=totalsubprepaid;
			newtargetpersales.Target_Additional_Link_Non_GSM__c=totaladditionallink;
			newtargetpersales.created_by_system__c=true;
			lNewTargetPerSales.add(newTargetPerSales);
    	} else if(monthTarget == 'December'){
    		myTarget = [SELECT id FROM Target__c WHERE Year_Target__c = :yearTarget AND Type_Segment__c = :typeSegment AND Timeline__c = 'Quarter 4'];
    		for(Target_Per_Sales__c myPreviousTargetPerSales : lTargetPerSales){
    			if(myPreviousTargetPerSales.Month_Target__c == 'October' || myPreviousTargetPerSales.Month_Target__c == 'November' || myPreviousTargetPerSales.Month_Target__c == 'December'){
    				Total_ChurnBAP = Total_ChurnBAP + myPreviousTargetPerSales.Churn_BAP__c;
    		//		Total_TargetActiveLinkNonGSM = Total_TargetActiveLinkNonGSM + myPreviousTargetPerSales.Target_Active_Link_Non_GSM__c;
	        		Total_TargetAdditionalLinkNonGSM = Total_TargetAdditionalLinkNonGSM + myPreviousTargetPerSales.Target_Additional_Link_Non_GSM__c;
	        		Total_RevenueGSM = Total_RevenueGSM + myPreviousTargetPerSales.Revenue_GSM__c;
	        		Total_RevenueIOT = Total_RevenueIOT + myPreviousTargetPerSales.Revenue_IOT__c;
	        		Total_RevenueMads = Total_RevenueMads + myPreviousTargetPerSales.Revenue_M_ads__c;
	        		Total_RevenueNonGSM = Total_RevenueNonGSM + myPreviousTargetPerSales.Revenue_Non_GSM__c;
					Total_RevenueVOIP = Total_RevenueVOIP + myPreviousTargetPerSales.Revenue_VOIP__c;
					newTargetPerSales.revenueperlink__c=myPreviousTargetPerSales.revenueperlink__c;
					totaladditionallink=totaladditionallink+myprevioustargetpersales.Target_Additional_Link_Non_GSM__c;
					totalsubpostpaid=totalsubpostpaid+myPreviousTargetPerSales.postpaid_sub__c;
					totalsubprepaid=totalsubprepaid+myPreviousTargetPerSales.prepaid_sub__c;
    			} 
			}
			newTargetPerSales.Churn_BAP__c = Total_ChurnBAP;
			//newTargetPerSales.Target_Active_Link_Non_GSM__c = Total_TargetActiveLinkNonGSM;
    		newTargetPerSales.Target_Additional_Link_Non_GSM__c = Total_TargetAdditionalLinkNonGSM;
    		newTargetPerSales.Revenue_GSM__c = Total_RevenueGSM;
    		newTargetPerSales.Revenue_IOT__c = Total_RevenueIOT;
    		newTargetPerSales.Revenue_M_ads__c = Total_RevenueMads;
    		newTargetPerSales.Revenue_Non_GSM__c = Total_RevenueNonGSM;
    		newTargetPerSales.Revenue_VOIP__c = Total_RevenueVOIP;
			newTargetPerSales.Sales__c = UserId;
			newTargetPerSales.Target__c = myTarget.id;
			newTargetPerSales.Target_Active_Link_Non_GSM__c=newTargetPerSales.revenue_non_gsm__c/newTargetPerSales.revenueperlink__c;
			newTargetPerSales.prepaid_sub__c=totalsubprepaid;
			newTargetPerSales.postpaid_sub__c=totalsubprepaid;
			newtargetpersales.Target_Additional_Link_Non_GSM__c=totaladditionallink;
			newtargetpersales.created_by_system__c=true;
			lNewTargetPerSales.add(newTargetPerSales);
    	}
    	
    }
}