/*
    Created By : Victor S
    13 Maret 2020
    
*/

trigger Trigger_Target on Target__c (before insert,after insert,before update) {
	if(system.label.IS_TRIGGER_TARGET_ON=='YES') {
		List<Target__c> lTarget = new List<Target__c>();
		List<Target__c> lYearTarget = new List<Target__c>();
		List<User> lUser = new List<User>();
		List<Target_Per_Sales__c> lTargetPerSales = new List<Target_Per_Sales__c>();
		
		
	    for(Target__c myTarget : trigger.new){
			if(trigger.isBefore && trigger.isUpdate)
			{
				target__c Told=trigger.oldMap.get(mytarget.id);
				if(told.revenue_non_gsm__c!=mytarget.revenue_non_gsm__c && mytarget.revenue_non_gsm__c!=null)
				{
					mytarget.Target_Active_Link_Non_GSM__c=mytarget.revenue_non_gsm__c/mytarget.revenueperlink__c;
				}
			}
			if(trigger.isBefore && trigger.isInsert)
			{

				if(mytarget.type_segment__c!='red' && mytarget.timeline__c=='Baseline' )
				{
					List<AggregateResult> AGR=[SELECT COUNT(ID) TotalLink,SUM(Contract_item_rel__r.Price__c) totalprice FROM Link__c WHERE Free_Link__c=false and Status_Link__c='IN_SERVICE' AND Contract_item_rel__r.Account.Segmentation_formula__c=:mytarget.type_segment__c];
					
					if(AGR.size()>0 && AGR[0].get('Totalprice')!=null)
					{
					mytarget.RevenuePerLink__c=(Decimal)AGR[0].get('Totalprice')/(Decimal) AGR[0].get('TotalLink');
					}
					mytarget.Target_Active_Link_Non_GSM__c=mytarget.revenue_non_gsm__c/mytarget.revenueperlink__c;


				}
			}
		    if(trigger.isafter && trigger.isinsert){
		        if(myTarget.Timeline__c == 'Baseline'){
		            Target__c newTarget = new Target__c();
		            newTarget.Timeline__c = 'Baseline/3';
		            newTarget.Type_Segment__c = myTarget.Type_Segment__c;
		         
		           
		            newTarget.Churn_BAP__c = mytarget.Churn_BAP__c/3;
		            newTarget.Revenue_GSM__c = myTarget.Revenue_GSM__c / 3;
		            newTarget.Revenue_IOT__c = myTarget.Revenue_IOT__c / 3;
		            newTarget.Revenue_M_ads__c = myTarget.Revenue_M_ads__c /3;
		            newTarget.Revenue_Non_GSM__c = myTarget.Revenue_Non_GSM__c /3;
					newTarget.Revenue_VOIP__c = myTarget.Revenue_VOIP__c /3;
					newtarget.revenueperlink__c=mytarget.revenueperlink__c;
					newTarget.Parent_Target__c=mytarget.id;
					newtarget.Target_Active_Link_Non_GSM__c= newTarget.Revenue_Non_GSM__c/newtarget.revenueperlink__c;
		            lTarget.add(newTarget);
		            
					lUser = [SELECT id FROM user WHERE Profile.Name='Sales' AND userrole.name = :myTarget.Type_Segment__c AND isactive=true];
					if(test.isRunningTest())
					{
						lUser = [SELECT id FROM user WHERE Profile.Name='Sales' AND userrole.name = :myTarget.Type_Segment__c AND isactive=true LIMIT 2];
					}
		            for(User myUser : lUser){
		            	Target_Per_Sales__c newTargetPerSales = new Target_Per_Sales__c();
		            	newTargetPerSales.Sales__c = myUser.id;
		            	newTargetPerSales.Target__c = myTarget.id;
		            	newtargetpersales.created_by_system__c=true;
		            	lTargetPerSales.add(newTargetPerSales);
		            }
		        } else if(myTarget.Timeline__c == 'Monthly Target' && myTarget.type_segment__c != 'Red' && (myTarget.Month_Target__c == 'March' || myTarget.Month_Target__c == 'June' || myTarget.Month_Target__c == 'September' || myTarget.Month_Target__c == 'December')){
		        	lYearTarget = [SELECT Month_Target__c, Churn_BAP__c, Target_Active_Link_Non_GSM__c, Revenue_GSM__c, Revenue_IOT__c, Revenue_M_ads__c, Revenue_Non_GSM__c, Revenue_VOIP__c FROM Target__c WHERE Year_Target__c = :myTarget.Year_Target__c AND Type_Segment__c = :myTarget.Type_Segment__c AND Timeline__c = 'Monthly Target'];
					Double Total_ChurnBAP = 0;
					Double Total_TargetActiveLinkNonGSM = 0;
					Double Total_TargetAdditionalLinkNonGSM = 0;
					Double Total_RevenueGSM = 0;
					Double Total_RevenueIOT = 0;
					Double Total_RevenueMads = 0;
					Double Total_RevenueNonGSM = 0;
					Double Total_RevenueVOIP = 0;
					if(myTarget.Month_Target__c == 'March'){
		        		Target__c newTarget = new Target__c();
		        		newTarget.Type_Segment__c = myTarget.Type_Segment__c;
		        		newTarget.Timeline__c = 'Quarter 1';
		        		for(Target__c myPreviousTarget : lYearTarget){
		        			if(myPreviousTarget.Month_Target__c == 'January' || myPreviousTarget.Month_Target__c == 'February' || myPreviousTarget.Month_Target__c == 'March'){
		        				Total_ChurnBAP = Total_ChurnBAP + myPreviousTarget.Churn_BAP__c;
		        			
				        		
				        		Total_RevenueGSM = Total_RevenueGSM + myPreviousTarget.Revenue_GSM__c;
				        		Total_RevenueIOT = Total_RevenueIOT + myPreviousTarget.Revenue_IOT__c;
				        		Total_RevenueMads = Total_RevenueMads + myPreviousTarget.Revenue_M_ads__c;
				        		Total_RevenueNonGSM = Total_RevenueNonGSM + myPreviousTarget.Revenue_Non_GSM__c;
				        		Total_RevenueVOIP = Total_RevenueVOIP + myPreviousTarget.Revenue_VOIP__c;
		        			} 
						}
						newTarget.Churn_BAP__c = Total_ChurnBAP;
	    				newTarget.Target_Active_Link_Non_GSM__c = Total_TargetActiveLinkNonGSM;
		        		
		        		newTarget.Revenue_GSM__c = Total_RevenueGSM;
		        		newTarget.Revenue_IOT__c = Total_RevenueIOT;
		        		newTarget.Revenue_M_ads__c = Total_RevenueMads;
		        		newTarget.Revenue_Non_GSM__c = Total_RevenueNonGSM;
						newTarget.Revenue_VOIP__c = Total_RevenueVOIP;
						newtarget.revenueperlink__c=mytarget.revenueperlink__c;
						newtarget.year_target__c=system.today().year()+1;
					//	newtarget.Target_Active_Link_Non_GSM__c= newTarget.Revenue_Non_GSM__c/newtarget.revenueperlink__c;
						lTarget.add(newTarget);
		        		
		        	} else if(myTarget.Month_Target__c == 'June'){
		        		Target__c newTarget = new Target__c();
		        		newTarget.Type_Segment__c = myTarget.Type_Segment__c;
		        		newTarget.Timeline__c = 'Quarter 2';
		        		for(Target__c myPreviousTarget : lYearTarget){
		        			if(myPreviousTarget.Month_Target__c == 'April' || myPreviousTarget.Month_Target__c == 'May' || myPreviousTarget.Month_Target__c == 'June'){
		        				Total_ChurnBAP = Total_ChurnBAP + myPreviousTarget.Churn_BAP__c;
		        		
				        		
				        		Total_RevenueGSM = Total_RevenueGSM + myPreviousTarget.Revenue_GSM__c;
				        		Total_RevenueIOT = Total_RevenueIOT + myPreviousTarget.Revenue_IOT__c;
				        		Total_RevenueMads = Total_RevenueMads + myPreviousTarget.Revenue_M_ads__c;
				        		Total_RevenueNonGSM = Total_RevenueNonGSM + myPreviousTarget.Revenue_Non_GSM__c;
				        		Total_RevenueVOIP = Total_RevenueVOIP + myPreviousTarget.Revenue_VOIP__c;
		        			}
						}
						newTarget.Churn_BAP__c = Total_ChurnBAP;
	    				newTarget.Target_Active_Link_Non_GSM__c = Total_TargetActiveLinkNonGSM;
		        		
		        		newTarget.Revenue_GSM__c = Total_RevenueGSM;
		        		newTarget.Revenue_IOT__c = Total_RevenueIOT;
		        		newTarget.Revenue_M_ads__c = Total_RevenueMads;
		        		newTarget.Revenue_Non_GSM__c = Total_RevenueNonGSM;
		        		newTarget.Revenue_VOIP__c = Total_RevenueVOIP;
						newtarget.year_target__c=system.today().year();
						newtarget.revenueperlink__c=mytarget.revenueperlink__c;
						//newtarget.Target_Active_Link_Non_GSM__c= newTarget.Revenue_Non_GSM__c/newtarget.revenueperlink__c;
						lTarget.add(newTarget);
		        		
		        	} else if(myTarget.Month_Target__c == 'September'){
		        		Target__c newTarget = new Target__c();
		        		newTarget.Type_Segment__c = myTarget.Type_Segment__c;
		        		newTarget.Timeline__c = 'Quarter 3';
		        		
		        		for(Target__c myPreviousTarget : lYearTarget){
		        			if(myPreviousTarget.Month_Target__c == 'July' || myPreviousTarget.Month_Target__c == 'August' || myPreviousTarget.Month_Target__c == 'September'){
		        				Total_ChurnBAP = Total_ChurnBAP + myPreviousTarget.Churn_BAP__c;
		        			
				        		Total_RevenueGSM = Total_RevenueGSM + myPreviousTarget.Revenue_GSM__c;
				        		Total_RevenueIOT = Total_RevenueIOT + myPreviousTarget.Revenue_IOT__c;
				        		Total_RevenueMads = Total_RevenueMads + myPreviousTarget.Revenue_M_ads__c;
				        		Total_RevenueNonGSM = Total_RevenueNonGSM + myPreviousTarget.Revenue_Non_GSM__c;
				        		Total_RevenueVOIP = Total_RevenueVOIP + myPreviousTarget.Revenue_VOIP__c;
		        			}
						}
						newTarget.Churn_BAP__c = Total_ChurnBAP;
	    				newTarget.Target_Active_Link_Non_GSM__c = Total_TargetActiveLinkNonGSM;
		        		
		        		newTarget.Revenue_GSM__c = Total_RevenueGSM;
		        		newTarget.Revenue_IOT__c = Total_RevenueIOT;
		        		newTarget.Revenue_M_ads__c = Total_RevenueMads;
		        		newTarget.Revenue_Non_GSM__c = Total_RevenueNonGSM;
		        		newTarget.Revenue_VOIP__c = Total_RevenueVOIP;
						newtarget.year_target__c=system.today().year();
						newtarget.revenueperlink__c=mytarget.revenueperlink__c;
				//	newtarget.Target_Active_Link_Non_GSM__c= newTarget.Revenue_Non_GSM__c/newtarget.revenueperlink__c;
						lTarget.add(newTarget);
		        		
		        	} else if(myTarget.Month_Target__c == 'December'){
		        		Target__c newTarget = new Target__c();
		        		newTarget.Type_Segment__c = myTarget.Type_Segment__c;
		        		newTarget.Timeline__c = 'Quarter 4';
						
		        		for(Target__c myPreviousTarget : lYearTarget){
		        			if(myPreviousTarget.Month_Target__c == 'October' || myPreviousTarget.Month_Target__c == 'November' || myPreviousTarget.Month_Target__c == 'December'){
		        				Total_ChurnBAP = Total_ChurnBAP + myPreviousTarget.Churn_BAP__c;
		        			
				        		
				        		Total_RevenueGSM = Total_RevenueGSM + myPreviousTarget.Revenue_GSM__c;
				        		Total_RevenueIOT = Total_RevenueIOT + myPreviousTarget.Revenue_IOT__c;
				        		Total_RevenueMads = Total_RevenueMads + myPreviousTarget.Revenue_M_ads__c;
				        		Total_RevenueNonGSM = Total_RevenueNonGSM + myPreviousTarget.Revenue_Non_GSM__c;
				        		Total_RevenueVOIP = Total_RevenueVOIP + myPreviousTarget.Revenue_VOIP__c;
		        			} 
		        		}
		        		
		        		newTarget.Churn_BAP__c = Total_ChurnBAP;
	    				newTarget.Target_Active_Link_Non_GSM__c = Total_TargetActiveLinkNonGSM;
		        		
		        		newTarget.Revenue_GSM__c = Total_RevenueGSM;
		        		newTarget.Revenue_IOT__c = Total_RevenueIOT;
		        		newTarget.Revenue_M_ads__c = Total_RevenueMads;
		        		newTarget.Revenue_Non_GSM__c = Total_RevenueNonGSM;
		        		newTarget.Revenue_VOIP__c = Total_RevenueVOIP;
		        		newtarget.year_target__c=system.today().year();
						newtarget.revenueperlink__c=mytarget.revenueperlink__c;
					//	newtarget.Target_Active_Link_Non_GSM__c= newTarget.Revenue_Non_GSM__c/newtarget.revenueperlink__c;
						lTarget.add(newTarget);
					}
					
				}
			
		        // Add by Surya 16 Maret 2020, Set Monthly Target According to Red
		        if(myTarget.Timeline__c == 'Monthly Target' && myTarget.type_segment__c=='Red'){
		            date previousdate=mytarget.Date_of_Target__c.addmonths(-1);
		            list<Target__c> TargetPrevious=new list<Target__c>();
		            if(math.mod(previousdate.month(),3)==0)
		            {
		                TargetPrevious=[SELECT id,revenueperlink__c,Type_Segment__c,Timeline__c,Revenue_GSM__c,Revenue_Non_GSM__c,Revenue_IOT__c,Revenue_VOIP__c,Revenue_M_ads__c,churn_bap__c FROM Target__c WHERE Createddate=THIS_MONTH AND timeline__c='Baseline/3'];
		            }
		            else
		            {
		             String previousmonth='';
		                if(previousdate.month()==1)
		                    previousmonth='January';
		                    if(previousdate.month()==2)
		                    previousmonth='February';
		                    if(previousdate.month()==3)
		                 previousmonth='March';
		                 if(previousdate.month()==4)
		                    previousmonth='April';
		                    if(previousdate.month()==5)
		                    previousmonth='May';
		                    if(previousdate.month()==6)
		                 previousmonth='June';
		                 if(previousdate.month()==7)
		                 previousmonth='July';
		                 if(previousdate.month()==8)
		                 previousmonth='August';
		                 if(previousdate.month()==9)
		              previousmonth='September';
		              if(previousdate.month()==10)
		              previousmonth='October';
		              if(previousdate.month()==11)
		              previousmonth='November';
		              if(previousdate.month()==12)
		           previousmonth='December';
		            
		            TargetPrevious=[SELECT id,Type_Segment__c,churn_bap__c,revenueperlink__c,Timeline__c,Revenue_GSM__c,Revenue_Non_GSM__c,Revenue_IOT__c,Revenue_VOIP__c,Revenue_M_ads__c FROM Target__c WHERE (Month_Target__c=:previousmonth AND YEAR_Target__c=:previousdate.year() AND Type_Segment__c!='Red')];
		            }
		            decimal totalVOIP=0;
		            decimal totalNonGSM=0;
		            decimal totalMads=0;
		            decimal totalGSM=0;
		            decimal totalIOT=0;
		            
		            decimal incremIOT=0;
		            decimal incremGSM=0;
		            decimal incremnonGSM=0;
		            decimal incremVOIP=0;
		            decimal incremMads=0;
		            for(Target__c T:targetprevious)
		            {
		            
		               TotalVoip=totalvoip+T.revenue_voip__c;
		               totalNonGSM=totalNonGSM+T.revenue_non_gsm__c;
		               totaliot=totaliot+T.revenue_iot__c;
		               totalgsm=totalgsm+T.revenue_gsm__c;
		               totalmads=totalmads+T.revenue_m_ads__c;
		            }
		            incremGSM=mytarget.revenue_gsm__c/totalgsm;
		            incremnongsm=mytarget.revenue_non_gsm__c/totalnongsm;
		            incremIOT=mytarget.revenue_iot__c/totaliot;
		            incremVOIP=mytarget.revenue_voip__c/totalvoip;
		            incremMads=mytarget.revenue_m_ads__c/totalmads;
		        /*	incremGSM=(mytarget.revenue_gsm__c-totalgsm)/targetprevious.size();
		            incremnongsm=(mytarget.revenue_non_gsm__c-totalnongsm)/targetprevious.size();
		            incremIOT=(mytarget.revenue_iot__c-totaliot)/targetprevious.size();
		            incremVOIP=(mytarget.revenue_voip__c-totalvoip)/targetprevious.size();
		          */  
		            for(target__c T:Targetprevious)
		            {
		                Target__c newT=new Target__c();
		                newT.type_segment__c=T.type_segment__c;
		                newT.timeline__c=mytarget.timeline__c;
		                newT.Parent_target__c=mytarget.id;
		                newT.Month_Target__c=mytarget.month_target__c;
		                newT.Year_Target__c=mytarget.Year_target__c;
		                newT.Revenue_GSM__c=T.revenue_gsm__c*incremGSM;
		                newT.Revenue_non_GSM__c=T.revenue_non_gsm__c*incremnonGSM;
		                newT.Revenue_iot__c= T.revenue_iot__c*incremIOT;
		                newT.Revenue_M_ads__c=T.revenue_M_ads__c*incremMads;
	                    newT.revenue_voip__c=T.revenue_VOIP__c*incremVOIP;
						newT.Churn_BAP__c=T.churn_bap__c;
						newt.revenueperlink__c=T.revenueperlink__c;
	                    newT.Target_Active_Link_Non_GSM__c=newT.Revenue_Non_GSM__c/newT.revenueperlink__c;
						
						
		                ltarget.add(newT);
		            }
		        }
				// Add by Surya 16 Maret 2020, END
					//Surya 18 Maret 2020 add sales per target for each monthly target created
					if(MyTarget.Timeline__c=='Monthly Target' && mytarget.type_segment__c!='Red')
					{
						lUser = [SELECT id FROM user WHERE Profile.Name='Sales' AND userrole.name = :myTarget.Type_Segment__c AND isactive=true];
						if(test.isRunningTest())
						{
							lUser = [SELECT id FROM user WHERE Profile.Name='Sales' AND userrole.name = :myTarget.Type_Segment__c AND isactive=true LIMIT 2];
						}
						for(User myUser : lUser){
							Target_Per_Sales__c newTargetPerSales = new Target_Per_Sales__c();
							newTargetPerSales.Sales__c = myUser.id;
							newTargetPerSales.Target__c = myTarget.id;
							newtargetpersales.created_by_system__c=true;
							lTargetPerSales.add(newTargetPerSales);
						}
					}
		    }
	    }
		if(ltarget.size()>0) {
			insert lTarget;
			
		}
		if(ltargetpersales.size()>0)
		{
		insert lTargetPerSales;
		}
	}
}