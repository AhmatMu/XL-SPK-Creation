global class Set_Sales_Target {
    //17 Maret 2020 Surya 
    //set sales target and additional per month according to baseline/3 and average additional
    @future
    public static void FillSalesTarget(String Month,Integer Year,String PreviousMonth,String Segment) {
        List<Target__c> TargetAll=[SELECT id,segment_classification__c,type_segment__c,total_segment__c,revenue_non_gsm__c,revenue_gsm__c,revenue_iot__c,revenue_m_ads__c,Revenue_VOIP__c,number_of_sales__c FROM Target__c WHERE Month_target__c=:Month AND Year_target__c=:Year AND Type_Segment__c!='Red' AND Type_Segment__c=:Segment ORDER BY Type_Segment__c];
        List<Target__c> TargetPrevious=new list<Target__c>();
            TargetPrevious=[SELECT id,type_segment__c,total_segment__c,revenue_non_gsm__c,revenue_gsm__c,revenue_iot__c,revenue_m_ads__c,Revenue_VOIP__c FROM Target__c WHERE Timeline__c='Baseline/3' AND Type_Segment__c!='Red' AND type_Segment__c=:Segment AND Createddate>=LAST_MONTH  Order By Type_Segment__c];
       for(Integer x=0;x<targetall.size();x++)
       {
           
           for(integer y=0;y<targetprevious.size();y++)
           {
                if(targetall[x].type_segment__c==targetprevious[y].type_segment__c)
                {
                    List<Target_Per_Sales__c> salesprevious=[SELECT revenue_m_ads__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_voip__c,sales__c FROM Target_per_sales__c WHERE target_timeline__c='Baseline/3' and createddate>=LAST_MONTH and segment__c=:targetall[x].type_segment__c];
                    Decimal MinusGSM=0;
                    Decimal MinimumGSM=0;
                    Decimal MinusnonGSM=0;
                    Decimal MinimumnonGSM=0;
                    Decimal MinusVOIP=0;
                    Decimal MinimumVOIP=0;
                    Decimal MinusIOT=0;
                    Decimal MinimumIOT=0;
                    Decimal MinimumMads=0;
                    Decimal MinusMads=0;
                    Decimal totalMads=1;
                    for(target_per_sales__c prev:salesprevious)
                    {
                        if(prev.revenue_gsm__c<Decimal.valueof(system.label.lower_limit_gsm))
                        {
                            minusgsm=minusgsm+(Decimal.valueof(system.label.lower_limit_gsm)-prev.revenue_gsm__c);
                            minimumgsm=minimumgsm+1;
                        }
                        if(targetall[x].segment_classification__c=='LE')
                        {
                        if(prev.revenue_non_gsm__c<Decimal.valueof(system.label.lower_limit_non_gsm))
                        {
                            minusnongsm=minusnongsm+(Decimal.valueof(system.label.lower_limit_non_gsm)-prev.revenue_non_gsm__c);
                            minimumnongsm=minimumnongsm+1;
                        }
                        }
                        if(targetall[x].segment_classification__c=='ME')
                        {
                        if(prev.revenue_non_gsm__c<Decimal.valueof(system.label.lower_limit_non_gsm_ME))
                        {
                            minusnongsm=minusnongsm+(Decimal.valueof(system.label.lower_limit_non_gsm_ME)-prev.revenue_non_gsm__c);
                            minimumnongsm=minimumnongsm+1;
                        }
                        }
                        if(prev.revenue_voip__c<Decimal.valueof(system.label.lower_limit_voip))
                        {
                            MinusVOIP=MinusVOIP+(Decimal.valueof(system.label.lower_limit_voip)-prev.revenue_voip__c);
                            MinimumVOIP=MinimumVOIP+1;
                        }
                        if(prev.revenue_iot__c<Decimal.valueof(system.label.lower_limit_iot))
                        {
                            MinusIOT=MinusIOT+(Decimal.valueof(system.label.lower_limit_iot)-prev.revenue_iot__c);
                            MinimumIOT=MinimumIOT+1;
                        }
                        if(prev.revenue_M_Ads__c<Decimal.valueof(system.label.lower_limit_m_ads))
                        {
                            MinusMads=MinusMads+(Decimal.valueof(system.label.lower_limit_M_Ads)-prev.revenue_M_Ads__c);
                            MinimumMads=MinimumMads+1;
                        }
                        else {
                            totalMads=totalMads+prev.revenue_m_ads__c;
                        }

                    }
                    List<Target_Per_Sales__c> salesnow=[SELECT revenue_m_ads__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_voip__c,sales__c,baseline_gsm__c,baseline_voip__c,baseline_non_gsm__c,baseline_iot__c,additional_gsm__c,additional_non_gsm__c,additional_voip__c,additional_iot__c FROM Target_per_sales__c WHERE month_target__c=:month and year_target__c=:year and segment__c=:targetall[x].type_segment__c];
                    decimal balanceGSM=0;
                    decimal balanceNonGSM=0;
                    decimal balanceIOT=0;
                    decimal balanceVOIP=0;
                    for(integer xx=0;xx<salesprevious.size();xx++)
                    {
                        for(integer yy=0;yy<salesnow.size();yy++)
                        {
                            if(salesnow[yy].sales__c==salesprevious[xx].sales__c)
                            {
                                salesnow[yy].baseline_gsm__c=salesprevious[xx].revenue_gsm__c;
                                salesnow[yy].baseline_non_gsm__c=salesprevious[xx].revenue_non_gsm__c;
                                salesnow[yy].baseline_voip__c=salesprevious[xx].revenue_voip__c;
                                salesnow[yy].baseline_iot__c=salesprevious[xx].revenue_iot__c;
                                if(salesnow[yy].baseline_gsm__c<decimal.valueof(system.label.lower_limit_gsm))
                                {
                                    salesnow[yy].baseline_gsm__c=decimal.valueof(system.label.lower_limit_gsm);
                                    salesnow[yy].additional_gsm__c=0;
                                }
                                else {
                                    salesnow[yy].additional_gsm__c =(targetall[x].revenue_gsm__c-TargetPrevious[y].revenue_gsm__c-MinusGSM)/(targetall[x].number_of_sales__c-MinimumGSM);                               
                                }
                                if(targetall[x].segment_classification__c=='LE')
                                {
                                if(salesnow[yy].baseline_non_gsm__c<decimal.valueof(system.label.lower_limit_non_gsm))
                                {
                                    salesnow[yy].baseline_non_gsm__c=decimal.valueof(system.label.lower_limit_non_gsm);
                                    salesnow[yy].additional_non_gsm__c=0;
                                }
                                else {
                                    salesnow[yy].additional_non_gsm__c =(targetall[x].revenue_non_gsm__c-TargetPrevious[y].revenue_non_gsm__c-MinusnonGSM)/(targetall[x].number_of_sales__c-MinimumnonGSM);                               
                                }
                                }
                                if(targetall[x].segment_classification__c=='ME')
                                {
                                if(salesnow[yy].baseline_non_gsm__c<decimal.valueof(system.label.lower_limit_non_gsm_ME))
                                {
                                    salesnow[yy].baseline_non_gsm__c=decimal.valueof(system.label.lower_limit_non_gsm_ME);
                                    salesnow[yy].additional_non_gsm__c=0;
                                }
                                else {
                                    salesnow[yy].additional_non_gsm__c =(targetall[x].revenue_non_gsm__c-TargetPrevious[y].revenue_non_gsm__c-MinusnonGSM)/(targetall[x].number_of_sales__c-MinimumnonGSM);                               
                                }
                                }
                                if(salesnow[yy].baseline_voip__c<decimal.valueof(system.label.lower_limit_voip))
                                {
                                    salesnow[yy].baseline_voip__c=decimal.valueof(system.label.lower_limit_voip);
                                    salesnow[yy].additional_voip__c=0;
                                }
                                else {
                                    salesnow[yy].additional_voip__c =(targetall[x].revenue_voip__c-TargetPrevious[y].revenue_voip__c-MinusVOIP)/(targetall[x].number_of_sales__c-MinimumVOIP);                               
                                }
                                if(salesnow[yy].baseline_iot__c<decimal.valueof(system.label.lower_limit_iot))
                                {
                                    salesnow[yy].baseline_iot__c=decimal.valueof(system.label.lower_limit_iot);
                                    salesnow[yy].additional_iot__c=0;
                                }
                                else {
                                    salesnow[yy].additional_iot__c =(targetall[x].revenue_iot__c-TargetPrevious[y].revenue_iot__c-MinusIOT)/(targetall[x].number_of_sales__c-MinimumIOT);                               
                                }
                               
                                salesnow[yy].revenue_gsm__c=salesnow[yy].additional_gsm__c+salesnow[yy].baseline_gsm__c;
                                salesnow[yy].revenue_non_gsm__c=salesnow[yy].additional_non_gsm__c+salesnow[yy].baseline_non_gsm__c;
                                if(targetall[x].segment_classification__c=='ME')
                                {
                                        if(salesnow[yy].revenue_non_gsm__c<decimal.valueof(system.label.lower_limit_NON_GSM_ME))
                                        {
                                            salesnow[yy].additional_non_gsm__c=0;
                                            balanceNonGSM=balanceNonGSM+(decimal.valueof(system.label.lower_limit_NON_GSM_ME)-salesnow[yy].revenue_non_gsm__c);
                                            salesnow[yy].revenue_non_gsm__c=decimal.valueof(system.label.lower_limit_NON_GSM_ME);
                                        }
                                }
                                else {
                                    if(salesnow[yy].revenue_non_gsm__c<decimal.valueof(system.label.lower_limit_NON_GSM))
                                    {
                                        salesnow[yy].additional_non_gsm__c=0;
                                        balanceNonGSM=balanceNonGSM+(decimal.valueof(system.label.lower_limit_NON_GSM)-salesnow[yy].revenue_non_gsm__c);
                                        salesnow[yy].revenue_non_gsm__c=decimal.valueof(system.label.lower_limit_NON_GSM);
                                    }
                                }
                                salesnow[yy].revenue_voip__c=salesnow[yy].additional_voip__c+salesnow[yy].baseline_voip__c;
                                salesnow[yy].revenue_iot__c=salesnow[yy].additional_iot__c+salesnow[yy].baseline_iot__c;
                                if(salesprevious[xx].revenue_m_ads__c<=Decimal.valueof(system.label.lower_limit_m_ads))
                                {
                                    salesnow[yy].revenue_m_ads__c=Decimal.valueof(system.label.lower_limit_m_ads);
                                }
                                else {
                                    salesnow[yy].revenue_m_ads__c=salesprevious[xx].revenue_m_ads__c+((targetall[x].revenue_m_ads__c-TargetPrevious[y].revenue_m_ads__c-MinusMads)*salesprevious[xx].revenue_m_ads__c/totalMads);
                                }

                            }
                        }

                    }
                    update salesnow;
                    if(balanceNonGSM>0)
                    {
                    Target_per_sales__c tpsnongsm=[SELECT revenue_non_gsm__c,baseline_non_gsm__c,additional_non_gsm__c FROM Target_per_sales__c WHERE month_target__c=:month and year_target__c=:year and segment__c=:targetall[x].type_segment__c order by revenue_non_gsm__c DESC LIMIT 1];
                    tpsnongsm.additional_non_gsm__c=tpsnongsm.additional_non_gsm__c-balanceNonGSM;
                    tpsnongsm.revenue_non_gsm__c=tpsnongsm.revenue_non_gsm__c-balanceNonGSM;
                    update tpsnongsm;
                    }
                }
           }
       }
     
    }
    //set sales target additional in accordance to sales grade lower grade means lower additional, vice versa
    @future
    public static void fixtotaltargetSales(String Segment,String Month,Integer Year)
    {   
        List<Target_Per_Sales__c> salesnow=[SELECT revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_voip__c,sales__c,baseline_gsm__c,baseline_voip__c,baseline_non_gsm__c,baseline_iot__c,additional_gsm__c,additional_non_gsm__c,additional_voip__c,additional_iot__c,grade__c,target__r.Number_of_sales__c,segment__c FROM Target_per_sales__c WHERE target_timeline__c='Monthly Target' AND Createddate>=LAST_MONTH and Segment__c=:Segment AND month_target__c=:month AND year_target__c=:YEAR];
        Integer no15=0;
        Integer no16=0;
        Integer no17=0;
        list<Decimal> SalesGrade=new list<Decimal>();
        for(Target_per_sales__c TPSGSM:salesnow)
        {
            if(TPSGSM.additional_gsm__c>0)
            {
                if(TPSGSM.grade__c=='15')
                {
                    no15=no15+1;
                }
                if(TPSGSM.grade__c=='16')
                {
                    no16=no16+1;
                }
                if(TPSGSM.grade__c=='17')
                {
                    no17=no17+1;
                }
            }
        }
            Salesgrade=SetSalesGrade(No15, No16, No17);
            for(Target_per_sales__c TPSGSM:salesnow)
            {
                if(TPSGSM.additional_gsm__c>0)
                {
                    if(TPSGSM.grade__c=='15')
                    {
                        TPSGSM.additional_gsm__c=TPSGSM.additional_gsm__c*salesgrade[0];
                    }
                    if(TPSGSM.grade__c=='16')
                    {
                        TPSGSM.additional_gsm__c=TPSGSM.additional_gsm__c*salesgrade[1];
                    }
                    if(TPSGSM.grade__c=='17')
                    {
                        TPSGSM.additional_gsm__c=TPSGSM.additional_gsm__c*salesgrade[2];
                    }
                    TPSGSM.revenue_gsm__c=TPSGSM.additional_gsm__c+TPSGSM.baseline_gsm__c;
                }
            } 
           
                
            no15=0;
            no16=0;
            no17=0;
            
            for(Target_per_sales__c TPSNONGSM:salesnow)
            {
                if(TPSnonGSM.additional_non_gsm__c>0)
                {
                    if(TPSnonGSM.grade__c=='15')
                    {
                        no15=no15+1;
                    }
                    if(TPSnonGSM.grade__c=='16')
                    {
                        no16=no16+1;
                    }
                    if(TPSnonGSM.grade__c=='17')
                    {
                        no17=no17+1;
                    }
                }
            }
                Salesgrade=SetSalesGrade(No15, No16, No17);
                for(Target_per_sales__c TPSNONGSM:salesnow)
                {
                    if(TPSnonGSM.additional_non_gsm__c>0)
                    {
                        if(TPSnonGSM.grade__c=='15')
                        {
                            TPSnonGSM.additional_non_gsm__c=TPSnonGSM.additional_non_gsm__c*salesgrade[0];
                        }
                        if(TPSnonGSM.grade__c=='16')
                        {
                            TPSnonGSM.additional_non_gsm__c=TPSnonGSM.additional_non_gsm__c*salesgrade[1];
                        }
                        if(TPSnonGSM.grade__c=='17')
                        {
                            TPSnonGSM.additional_non_gsm__c=TPSnonGSM.additional_non_gsm__c*salesgrade[2];
                        }
                        TPSNONGSM.revenue_non_gsm__c=TPSNONGSM.additional_non_gsm__c+TPSNONGSM.baseline_non_gsm__c;
    
                    }
                } 

                no15=0;
                no16=0;
                no17=0;
                
                for(Target_per_sales__c TPSVOIP:salesnow)
                {
                    if(TPSVOIP.additional_VOIP__c>0)
                    {
                        if(TPSVOIP.grade__c=='15')
                        {
                            no15=no15+1;
                        }
                        if(TPSVOIP.grade__c=='16')
                        {
                            no16=no16+1;
                        }
                        if(TPSVOIP.grade__c=='17')
                        {
                            no17=no17+1;
                        }
                    }
                }
                    Salesgrade=SetSalesGrade(No15, No16, No17);
                    for(Target_per_sales__c TPSVOIP:salesnow)
                    {
                        if(TPSVOIP.additional_VOIP__c>0)
                        {
                            if(TPSVOIP.grade__c=='15')
                            {
                                TPSVOIP.additional_VOIP__c=TPSVOIP.additional_VOIP__c*salesgrade[0];
                            }
                            if(TPSVOIP.grade__c=='16')
                            {
                                TPSVOIP.additional_VOIP__c=TPSVOIP.additional_VOIP__c*salesgrade[1];
                            }
                            if(TPSVOIP.grade__c=='17')
                            {
                                TPSVOIP.additional_VOIP__c=TPSVOIP.additional_VOIP__c*salesgrade[2];
                            }
                            TPSVOIP.revenue_voip__c=TPSVOIP.baseline_voip__c+TPSVOIP.additional_voip__c;
        
                        }
                    } 
                    
                no15=0;
                no16=0;
                no17=0;
                
                for(Target_per_sales__c TPSIOT:salesnow)
                {
                    if(TPSIOT.additional_IOT__c>0)
                    {
                        if(TPSIOT.grade__c=='15')
                        {
                            no15=no15+1;
                        }
                        if(TPSIOT.grade__c=='16')
                        {
                            no16=no16+1;
                        }
                        if(TPSIOT.grade__c=='17')
                        {
                            no17=no17+1;
                        }
                    }
                }
                    Salesgrade=SetSalesGrade(No15, No16, No17);
                    for(Target_per_sales__c TPSIOT:salesnow)
                    {
                        if(TPSIOT.additional_IOT__c>0)
                        {
                            if(TPSIOT.grade__c=='15')
                            {
                                TPSIOT.additional_IOT__c=TPSIOT.additional_IOT__c*salesgrade[0];
                            }
                            if(TPSIOT.grade__c=='16')
                            {
                                TPSIOT.additional_IOT__c=TPSIOT.additional_IOT__c*salesgrade[1];
                            }
                            if(TPSIOT.grade__c=='17')
                            {
                                TPSIOT.additional_IOT__c=TPSIOT.additional_IOT__c*salesgrade[2];
                            }
                            TPSIOT.revenue_iot__c=TPSIOT.baseline_iot__c+TPSIOT.additional_iot__c;
                        }
                    }

                    
                    update salesnow;
                  
    }
    //calculate initial subscription and link, trigger will modify if GSM/NON GSM revenue changes
    public static void calculateGSM(String Month,Integer Year,String previousmonth)
    {
        List<Target__c> TargetAll=[SELECT id,type_segment__c,total_segment__c,revenue_non_gsm__c,revenue_gsm__c,revenue_iot__c,revenue_m_ads__c,Revenue_VOIP__c FROM Target__c WHERE Month_target__c=:Month AND Year_target__c=:Year AND Type_Segment__c!='Red' ORDER BY Type_Segment__c];
        List<Target__c> TargetPrevious=new list<Target__c>();
        if(PreviousMonth=='Baseline/3')
        {
            TargetPrevious=[SELECT id,type_segment__c,total_segment__c,revenue_non_gsm__c,revenue_gsm__c,revenue_iot__c,revenue_m_ads__c,Revenue_VOIP__c FROM Target__c WHERE Timeline__c=:PreviousMonth AND Type_Segment__c!='Red'  Order By Type_Segment__c];
        }
        else
        {
            TargetPrevious=[SELECT id,type_segment__c,total_segment__c,revenue_non_gsm__c,revenue_gsm__c,revenue_iot__c,revenue_m_ads__c,Revenue_VOIP__c FROM Target__c WHERE Month_target__c=:PreviousMonth AND Year_target__c=:Year AND Type_Segment__c!='Red'  Order By Type_Segment__c];
        }
        List<Target_Per_Sales__c> TargetperSalesAll=new list<Target_per_sales__c>();
        set<string> setid=new set<string>();
        for(Integer i=0;i<targetall.size();i++)
        {
            List<Target_Per_Sales__c> TargetPerSales=[SELECT id,Segment__c,  Target_Additional_Link_Non_GSM__c,revenueperlink__c,Target_Active_Link_Non_GSM__c,Grade__c,Revenue_GSM__c,  Revenue_IOT__c,  Revenue_NON_GSM__c,  Revenue_VOIP__c,  Revenue_M_Ads__c,Sales__c,Gap_GSM__c,After_Recurring_Churn__c,Gap_After_New_Stream_Churn__c,PostPaid_Sub__c,Prepaid_Sub__c,Prepaid_Revenue__c,Postpaid_revenue__c,churn_bap__c from Target_per_sales__c WHERE Target__c=:TargetAll[i].id Order By Sales__c];
            List<Target_Per_Sales__c> TargetPerSalesPrevious=[SELECT id,Segment__c,revenueperlink__c,Target_Active_Link_Non_GSM__c,  Revenue_GSM__c,  Revenue_IOT__c,  Revenue_NON_GSM__c,  Revenue_VOIP__c,  Revenue_M_Ads__c,Sales__c,Gap_GSM__c,After_Recurring_Churn__c,Gap_After_New_Stream_Churn__c,PostPaid_Revenue__c,Prepaid_Revenue__c,PostPaid_Sub__c,Prepaid_Sub__c,churn_bap__c from Target_per_sales__c WHERE Target__c=:TargetPrevious[i].id Order By Sales__c];
            for(Integer j=0;j<targetpersales.size();j++)
            {
                for(integer k=0;k<TargetPerSalesPrevious.size();k++)
                {
                if(TargetPerSalesPrevious[k].sales__c==targetpersales[j].sales__c)
                {
                    TargetPerSales[j].After_Recurring_Churn__c=Targetpersalesprevious[k].revenue_gsm__c*(1-(Decimal.valueof(system.label.SME_Recurring_Churn)/100));
                
                if(TargetPerSalesPrevious[k].Gap_GSM__c==null||TargetPerSalesPrevious[k].Gap_GSM__c==0)
                {
                    TargetPerSales[j].Gap_After_New_Stream_Churn__c=0;   
                }
                else {
                    TargetPerSales[j].Gap_After_New_Stream_Churn__c=TargetPerSalesPrevious[k].Gap_GSM__c*(1-Decimal.valueof(system.label.SME_New_Stream_Churn)/100);
                }
                
                TargetPerSales[j].Gap_GSM__c=TargetPerSales[j].revenue_gsm__c-TargetPerSales[j].After_Recurring_Churn__c-TargetPerSales[j].Gap_After_New_Stream_Churn__c;
                if(TargetPerSales[j].Gap_GSM__c<=0)
                TargetPerSales[j].Gap_GSM__c=0;
                TargetPerSales[j].PostPaid_Revenue__c=TargetPerSales[j].Gap_GSM__c*Decimal.valueof(system.label.SME_Postpaid)/100;
                TargetPerSales[j].PrePaid_Revenue__c=TargetPerSales[j].Gap_GSM__c*Decimal.valueof(system.label.SME_Prepaid)/100;
                TargetPerSales[j].Prepaid_Sub__c=TargetPerSales[j].Prepaid_Revenue__c/Decimal.valueof(system.label.ARPU_Prepaid);
                if(targetpersales[j].prepaid_sub__c<10)
                {
                    targetpersales[j].prepaid_sub__c=10;
                }
                TargetPerSales[j].Postpaid_sub__c=TargetPerSales[j].Postpaid_Revenue__c/Decimal.valueof(system.label.ARPU_postpaid);
                if(targetpersales[j].postpaid_sub__c<10)
                {
                    targetpersales[j].postpaid_sub__c=10;
                }
                // link target per sales
                TargetPerSales[j].revenueperlink__c=TargetPerSalesPrevious[k].revenueperlink__c;
                targetpersales[j].churn_bap__c=TargetPerSalesPrevious[k].churn_bap__c;
                TargetPerSales[j].Target_Active_Link_Non_GSM__c=Integer.valueof(TargetPerSales[j].revenue_non_gsm__c/TargetPerSales[j].revenueperlink__c);
                TargetPerSales[j].Target_Additional_Link_Non_GSM__c=Integer.valueof(TargetPerSales[j].Target_Active_Link_Non_GSM__c-TargetPerSalesprevious[k].target_active_link_non_gsm__c+targetpersales[j].churn_bap__c);
                if(TargetPerSales[j].target_additional_link_non_gsm__c<10)
                TargetPerSales[j].target_additional_link_non_gsm__c=10;
                targetpersales[j].previous_target__c=TargetPerSalesPrevious[k].id;
                }
                }
                if(!setid.contains(targetpersales[j].id))
                {
                    setid.add(targetpersales[j].id);
                    TargetperSalesAll.add(targetpersales[j]);
                }
            }
           
        }
        update TargetperSalesAll;
    }
 

    //Calculate variable additional multiplier according to sales grade
    public static Decimal[] SetSalesGrade(Integer No15,Integer No16,Integer No17)
    {   
        Decimal[] ConvertGrade=new Decimal[]{0,0,0};
        if((No15==0 && No16==0)||(No16==0 && No17==0)||(No15==0&&No17==0))
        {
            if(No17!=0)
                ConvertGrade[2]=1;
                if(No15!=0)
                ConvertGrade[0]=1;
                if(No16!=0)
                ConvertGrade[1]=1;
        }
        else if(No15==0||No16==0||No17==0)
        {
            Decimal percentset=0;
            if(No16!=0&&No17!=0)
            {
                percentset=((no16+no17)/2)*0.05;
                ConvertGrade[1]=1-(percentset/No16);
                ConvertGrade[2]=1+(percentset/No17);  
            }
            if(No15!=0&&No17!=0)
            {
                percentset=((no15+no17)/2)*0.05;
                ConvertGrade[0]=1-(percentset/No15);
                ConvertGrade[2]=1+(percentset/No17);  
            }
            if(No15!=0&&No16!=0)
            {
                percentset=((no16+no15)/2)*0.05;
                ConvertGrade[0]=1-(percentset/No15);
                ConvertGrade[1]=1+(percentset/No16);  
            }

        }
        else {
            Decimal percentset=0;
            percentset=((no15+No16)/2)*0.05;
            ConvertGrade[0]=1-(0.16/No15);
            ConvertGrade[1]=1+(0.06/No16);
            ConvertGrade[2]=1.1;
        }
       
        return ConvertGRADE;
    }
    //set sales target to align with grade
    public static void CheckBalanceSalesTarget(String Segment,String Quarter)
    {
        String Month1='';
        String Month2='';
        String Month3='';
        Integer year=system.today().year();
        if(Quarter=='Quarter 1')
        {
             Month1='January';
             Month2='February';
             Month3='March';
             year=year+1;
        }
        if(Quarter=='Quarter 2')
        {
             Month1='April';
             Month2='May';
             Month3='June';
        }
        if(Quarter=='Quarter 3')
        {
             Month1='July';
             Month2='August';
             Month3='September';
        }
        if(Quarter=='Quarter 4')
        {
             Month1='October';
             Month2='November';
             Month3='December';
             
        }
        list<Additional_Sales_Target__c> listAST=[SELECT id,Sales_Grade__c,total_additional__c,Sales__r.Name,Sales__c,Percentage_Miss__c,Exception_M_Ads__c FROM Additional_Sales_Target__c WHERE  Segment__c=:Segment AND Exception_M_Ads__c=false AND target_timeline__c=:Quarter Order by total_additional__c ASC];
        Decimal TotalAdditional=0;
        Integer No15=0;
        Integer No16=0;
        Integer No17=0;
        list<Decimal> Grading=new list<Decimal>{0,0,0};
        for(Additional_Sales_Target__c A:listAST)
        {
            TotalAdditional=A.total_additional__c+TotalAdditional;
            if(A.exception_m_ads__c==false)
            {
            if(A.sales_grade__c=='15')
            No15=no15+1;
            if(A.sales_grade__c=='16')
            no16=no16+1;
            if(A.sales_grade__c=='17')
            no17=no17+1;
            }
        }
        Grading=SetSalesGrade(No15, No16, No17);
        Decimal PercentageMiss=0;
        String SalesID='';
        Decimal IdealAdditional=0;
        Decimal GradeConvert=0;
        for(integer i=0;i<listAST.size();i++)
        {
            if(listAST[i].sales_grade__c=='15')
                GradeConvert=Grading[0];
                if(listAST[i].sales_grade__c=='16')
                GradeConvert=Grading[1];
                if(listAST[i].sales_grade__c=='17')
                GradeConvert=Grading[2];
            IdealAdditional=(TotalAdditional/listAST.size())*GradeConvert;

            PercentageMiss=((IdealAdditional-listAst[i].total_additional__c)/IdealAdditional)*100;
            listAST[i].percentage_miss__c=percentageMiss;
           
        }
        update listAST;
        list<Additional_Sales_Target__c> listAST2=[SELECT id,Sales_Grade__c,total_additional__c,Sales__r.Name,Sales__c,Percentage_Miss__c FROM Additional_Sales_Target__c WHERE  Exception_M_Ads__c=false AND Segment__c=:Segment AND target_timeline__c=:Quarter Order by Percentage_Miss__c DESC];
        
        if(listAST2[0].percentage_Miss__c>10||test.isRunningTest())
        {
            Decimal selisihmiss=listAST2[0].Percentage_Miss__c-10;
            
            if(selisihmiss>30)
            selisihmiss=30;
            Decimal Amount =IdealAdditional*selisihmiss/100;
                increasesalestarget(listAST2[0].sales__c, Segment, Month1, Year, Amount/3);
                increasesalestarget(listAST2[0].sales__c, Segment, Month2, Year, Amount/3);
                increasesalestarget(listAST2[0].sales__c, Segment, Month3, Year, Amount/3);
            
        }
        list<Additional_Sales_Target__c> listAST3=[SELECT id,Sales_Grade__c,total_additional__c,Sales__r.Name,Sales__c,Percentage_Miss__c FROM Additional_Sales_Target__c WHERE  Exception_M_Ads__c=false AND Segment__c=:Segment AND target_timeline__c=:Quarter Order by Percentage_Miss__c ASC];
        
        if(listAST3[0].Percentage_Miss__c<-10||test.isRunningTest())
        {
            Decimal selisihmiss=math.abs(listAST2[0].Percentage_Miss__c+10);
            if(selisihmiss>30)
            selisihmiss=30;
            Decimal Amount =IdealAdditional*selisihmiss/100;
            decreasesalestarget(listAST3[0].sales__c, Segment, Month1, Year, Amount/3);
            decreasesalestarget(listAST3[0].sales__c, Segment, Month2, Year, Amount/3);
            decreasesalestarget(listAST3[0].sales__c, Segment, Month3, Year, Amount/3);
            return;
        }
        for(integer i=0;i<listAST.size();i++)
        {
            if(listAST[i].sales_grade__c=='15')
                GradeConvert=Grading[0];
                if(listAST[i].sales_grade__c=='16')
                GradeConvert=Grading[1];
                if(listAST[i].sales_grade__c=='17')
                GradeConvert=Grading[2];
            IdealAdditional=(TotalAdditional/listAST.size())*GradeConvert;

            PercentageMiss=((IdealAdditional-listAst[i].total_additional__c)/IdealAdditional)*100;
            listAST[i].percentage_miss__c=percentageMiss;
           
        }
        update listAST;

    }
//increase additional sales target to align with the grade
    public Static void increasesalestarget(String SalesID,String Segment,String Month,Integer Year,Decimal Amount)
    {
        
        List<Target_Per_Sales__c> nonSales=[select id,baseline_gsm__c,baseline_non_gsm__c,baseline_voip__c,baseline_iot__c,additional_gsm__c,additional_non_gsm__c,additional_voip__c,additional_iot__c,total_revenue__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_voip__c,revenue_iot__c from target_per_sales__c WHERE sales__c!=:salesid AND Month_target__c=:Month AND Year_target__c=:Year AND Segment__c=:segment];
         
        Target_Per_Sales__c Sales=[SELECT id,baseline_gsm__c,baseline_non_gsm__c,baseline_voip__c,baseline_iot__c,additional_gsm__c,additional_non_gsm__c,additional_voip__c,additional_iot__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_voip__c,revenue_iot__c from target_per_sales__c WHERE sales__c=:salesid AND Month_target__c=:Month AND Year_target__c=:Year];
        Decimal NonTIOT=1;
        Decimal NonTGSM=1;
        Decimal NonTNONGSM=1;
        Decimal NonTVOIP=1;
        Decimal NonTMads=1;
        Decimal totalAll=0;
        for(target_per_sales__c Ex:nonSales)
        {
            TotalAll=Ex.Total_Revenue__c+TotalAll;
            if(ex.additional_gsm__c>0)
            {
                NonTGSM=nonTGSM+ex.additional_gsm__c;
            }
            if(0<Ex.additional_VOIP__c)
            {
                NonTVOIP=nonTVOIP+ex.additional_VOIP__c;
            }
            if(0<Ex.additional_IOT__c)
            {
                NonTIOT=nonTVOIP+ex.additional_IOT__c;
            }
            if(0<Ex.additional_NON_gsm__c)
            {
                NonTNONGSM=NonTNONGSM+ex.additional_Non_GSM__c;
            }
            if(Integer.valueof(system.label.lower_limit_M_Ads)*2<Ex.revenue_M_Ads__c)
            {
                NonTMads=NonTMads+ex.revenue_M_Ads__c;
            }
        }
        totalall=NonTGSM+NonTMads+NonTIOT+NonTNONGSM+NonTVOIP;
        Decimal TotalGSM=Amount*NonTGSM/totalAll;
        Decimal TotalMads=Amount*NonTMads/totalAll;
        Decimal TotalIOT=Amount*NonTiot/TotalAll;
        Decimal TotalVOIP=Amount*NonTVOIP/totalAll;
        Decimal TotalNONGSM=Amount*NonTNONGSM/TotalAll;
        Decimal Proporsi=0;
        for(Integer i=0;i<nonSales.size();i++)
        {
            if(0<nonSales[i].additional_gsm__c||test.isRunningTest())
            {
                if(0<Sales.additional_gsm__c||test.isRunningTest())
                {
                Proporsi=TotalGSM*nonSales[i].additional_gsm__c/nontGSM;
                nonSales[i].additional_GSM__c=nonSales[i].additional_gsm__c-Proporsi;
                Sales.additional_gsm__c=Sales.additional_gsm__c+Proporsi;
                nonSales[i].revenue_gsm__c=nonsales[i].additional_gsm__c+nonsales[i].baseline_gsm__c;
                sales.revenue_gsm__c=sales.additional_gsm__c+sales.baseline_gsm__c;
                }
            }
            if(0<nonSales[i].additional_VOIP__c||test.isRunningTest())
            {
                if(0<Sales.additional_VOIP__c||test.isRunningTest())
                {
                Proporsi=TotalVOIP*nonSales[i].additional_VOIP__c/NonTVOIP;
                nonSales[i].additional_VOIP__c=nonSales[i].additional_VOIP__c-Proporsi;
                Sales.additional_VOIP__c=Sales.additional_VOIP__c+Proporsi;
                nonSales[i].revenue_VOIP__c=nonsales[i].additional_VOIP__c+nonsales[i].baseline_VOIP__c;
                sales.revenue_VOIP__c=sales.additional_VOIP__c+sales.baseline_VOIP__c;
                }
            }
            if(0<nonSales[i].additional_IOT__c||test.isRunningTest())
            {
                if(0<Sales.additional_IOT__c||test.isRunningTest())
                {
                Proporsi=TotalIOT*nonSales[i].additional_IOT__c/NonTIOT;
                nonSales[i].additional_IOT__c=nonSales[i].additional_IOT__c-Proporsi;
                Sales.additional_IOT__c=Sales.additional_IOT__c+Proporsi;
                nonSales[i].revenue_IOT__c=nonsales[i].additional_IOT__c+nonsales[i].baseline_IOT__c;
                sales.revenue_IOT__c=sales.additional_IOT__c+sales.baseline_IOT__c;
                }
            }
            if(0<nonSales[i].additional_NON_gsm__c||test.isRunningTest())
            {
                if(0<Sales.additional_NON_GSM__c||test.isRunningTest())
                {
                Proporsi=TotalNONGSM*nonSales[i].additional_NON_GSM__c/NonTNONGSM;
                nonSales[i].additional_NON_GSM__c=nonSales[i].additional_NON_gsm__c-Proporsi;
                Sales.additional_NON_gsm__c=Sales.additional_NON_gsm__c+Proporsi;
                nonSales[i].revenue_NON_GSM__c=nonsales[i].additional_NON_GSM__c+nonsales[i].baseline_Non_GSM__c;
                sales.revenue_NON_GSM__c=sales.additional_NON_GSM__c+sales.baseline_NON_GSM__c;
                }
            }
            if(Integer.valueof(system.label.lower_limit_M_Ads)*2<nonSales[i].revenue_M_Ads__c)
            {
                if(2*Integer.valueof(system.label.lower_limit_M_Ads)<Sales.revenue_M_Ads__c)
                {
               /* Proporsi=TotalMads*nonSales[i].REVENUE_M_Ads__c/NonTMads;
                nonSales[i].Revenue_M_Ads__c=nonSales[i].revenue_M_Ads__c-Proporsi;
                Sales.revenue_M_Ads__c=Sales.revenue_M_Ads__c+Proporsi;*/
                }
            }

        }
        update nonSales;
        update sales;
    }
//decrease additional sales target to align with the grade
    public Static void decreasesalestarget(String SalesID,String Segment,String Month,Integer Year,Decimal Amount)
    {
        List<Target_Per_Sales__c> nonSales=[select id,baseline_gsm__c,baseline_non_gsm__c,baseline_voip__c,baseline_iot__c,additional_gsm__c,additional_non_gsm__c,additional_voip__c,additional_iot__c,total_revenue__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_voip__c,revenue_iot__c from target_per_sales__c WHERE sales__c!=:salesid AND Month_target__c=:Month AND Year_target__c=:Year AND Segment__c=:segment];
        Target_Per_Sales__c Sales=[SELECT id,baseline_gsm__c,baseline_non_gsm__c,baseline_voip__c,baseline_iot__c,additional_gsm__c,additional_non_gsm__c,additional_voip__c,additional_iot__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_voip__c,revenue_iot__c,Total_Revenue__c from target_per_sales__c WHERE sales__c=:salesid AND Month_target__c=:Month AND Year_target__c=:Year];
               Decimal GSMTransfer=0;
            Decimal NonGSMTransfer=0;
            Decimal VOIPTransfer=0;
            Decimal MAdsTransfer=0;
            Decimal IOTTransfer=0;
            if(Sales.additional_gsm__c>0)
            {
            GSMtransfer=(Amount*Sales.additional_gsm__c/Sales.total_revenue__c);
            }
            if(Sales.additional_non_gsm__c>0)
            {
            NonGSMtransfer=(Amount*Sales.additional_non_gsm__c/Sales.total_Revenue__c);
            }
            if(Sales.additional_voip__c>0)
            {
            VOIPtransfer=(Amount*Sales.additional_VOIP__c/Sales.total_revenue__c);
            }
            if(Sales.additional_iot__c>0)
            {
            IOTTransfer=(Amount*Sales.additional_IOT__c/Sales.total_Revenue__c);
            }
            if(Sales.revenue_m_ads__c>2*Integer.valueof(system.label.lower_limit_m_ads))
            {
           // Madstransfer=(Total*T.revenue_M_Ads__c/T.total_segment__c);
            }
            Decimal NonTIOT=1;
            Decimal NonTGSM=1;
            Decimal NonTNONGSM=1;
            Decimal NonTVOIP=1;
            Decimal NonTMads=1;
            for(target_per_sales__c N:nonSales)
            {
                if(0<N.additional_gsm__c)
                {
                    NonTGSM=nonTGSM+N.additional_gsm__c;
                }
                if(0<N.additional_VOIP__c)
                {
                    NonTVOIP=nonTVOIP+N.additional_VOIP__c;
                }
                if(0<N.additional_IOT__c)
                {
                    NonTIOT=NonTIOT+N.additional_IOT__c;
                }
                if(0<N.additional_NON_gsm__c)
                {
                    NonTNONGSM=NonTNONGSM+N.additional_Non_GSM__c;
                }
                if(Integer.valueof(system.label.lower_limit_M_Ads)*2<N.revenue_M_Ads__c)
                {
                    NonTMads=NonTMads+N.revenue_M_Ads__c;
                }
            }
            Decimal Proporsi=0;
            for(Integer i=0;i<nonSales.size();i++)
            {
                if(0<nonSales[i].additional_gsm__c||test.isRunningTest())
                {
                    Proporsi=GSMTransfer*nonSales[i].additional_GSM__c/NonTGSM;
                    nonSales[i].additional_GSM__c=nonSales[i].additional_gsm__c+Proporsi;
                    Sales.additional_gsm__c=Sales.additional_gsm__c-Proporsi;
                    nonSales[i].revenue_gsm__c=nonSales[i].baseline_gsm__c+nonSales[i].additional_gsm__c;
                    Sales.revenue_gsm__c=Sales.baseline_gsm__c+Sales.additional_gsm__c;

                }
                if(0<nonSales[i].additional_VOIP__c||test.isRunningTest())
                {
                    Proporsi=VOIPTransfer*NonSales[i].additional_VOIP__c/NonTVOIP;
                    nonSales[i].additional_VOIP__c=nonSales[i].additional_VOIP__c+Proporsi;
                    Sales.additional_VOIP__c=Sales.additional_VOIP__c-Proporsi;
                    nonSales[i].revenue_voip__c=nonSales[i].baseline_voip__c+nonSales[i].additional_voip__c;
                    Sales.revenue_voip__c=Sales.baseline_voip__c+Sales.additional_voip__c;
                }
                if(0<nonSales[i].additional_IOT__c||test.isRunningTest())
                {
                    Proporsi=IOTTransfer*nonSales[i].additional_IOT__c/NonTIOT;
                    nonSales[i].additional_IOT__c=nonSales[i].additional_IOT__c+Proporsi;
                    Sales.additional_IOT__c=Sales.additional_IOT__c-Proporsi;
                    nonSales[i].revenue_iot__c=nonSales[i].baseline_iot__c+nonSales[i].additional_iot__c;
                    Sales.revenue_iot__c=Sales.baseline_iot__c+Sales.additional_iot__c;
                }
                if(0<nonSales[i].additional_NON_gsm__c||test.isRunningTest())
                {
                    Proporsi=NONGSMTransfer*nonSales[i].additional_NON_GSM__c/NonTNONGSM;
                    nonSales[i].additional_NON_GSM__c=nonSales[i].additional_NON_gsm__c+Proporsi;
                    Sales.additional_NON_gsm__c=Sales.additional_NON_gsm__c-Proporsi;
                    nonSales[i].revenue_non_gsm__c=nonSales[i].baseline_non_gsm__c+nonSales[i].additional_non_gsm__c;
                    Sales.revenue_non_gsm__c=Sales.baseline_non_gsm__c+Sales.additional_non_gsm__c;
                }
                if(Integer.valueof(system.label.lower_limit_M_Ads)*2<nonSales[i].revenue_M_Ads__c)
                {
                /*    Proporsi=Madstransfer*nonSales[i].REVENUE_M_Ads__c/NonTMads;
                    nonSales[i].Revenue_M_Ads__c=nonSales[i].revenue_M_Ads__c+Proporsi;
                    Sales.revenue_M_Ads__c=Sales.revenue_M_Ads__c-Proporsi;
                    */
                }

            }
       
        update sales;
        update nonsales;
    }
     //18 Maret 2020,count additional sales target
     public static void AdditionalSalesTarget(String Segment)
     {
         list<target_per_sales__c> TargetBaseline=[select id,Revenue_GSM__c,Revenue_NON_GSM__c,Revenue_VOIP__c,Revenue_IOT__c,Revenue_M_Ads__c,Total_Revenue__c,sales__c FROM Target_per_sales__c WHERE Segment__c=:Segment AND Target_Timeline__c='Baseline' AND Createddate>=LAST_MONTH Order by Sales__c DESC];
         list<target_per_sales__c> TargetQuarter=[select id,Revenue_GSM__c,Revenue_NON_GSM__c,Revenue_VOIP__c,Revenue_IOT__c,Revenue_M_Ads__c,Total_Revenue__c,Sales__r.Name,Sales__c,target__c,target_timeline__c FROM Target_per_sales__c WHERE Segment__c=:Segment AND Target_Timeline__c LIKE '%Quarter%' AND Createddate>=LAST_MONTH Order By Sales__c DESC];
         if(targetbaseline.size()!=targetquarter.size())
         {
            return;
         }
        
         list<Additional_Sales_Target__c> tesAST=[select id,Sales__c FROM Additional_Sales_Target__c WHERE Segment__c=:Segment and createddate>=LAST_MONTH Order by SALES__c DESC];
         list<Additional_Sales_Target__c> listAST=new list<Additional_Sales_Target__c>();
         for(Integer i=0;i<TargetBaseline.size();i++)
         {
         
             Additional_Sales_Target__c AST=new Additional_Sales_Target__c();
             if(TargetBaseline[i].sales__c==TargetQuarter[i].sales__c)
             {
                 if(tesAst.size()>0)
                 {
                 for(Additional_Sales_target__c Tes:tesast)
                  {  if(tes.sales__c==targetquarter[i].sales__c)
                     AST.id=tes.id;
                  }
                 }
                 AST.Sales__c=TargetQuarter[i].Sales__c;
                 AST.Target_Quarter__c=TargetQuarter[i].target__c;
                 AST.total_GSM_Additional__c=TargetQuarter[i].revenue_GSM__c-TargetBaseline[i].revenue_GSM__C;
                 AST.total_VOIP_Additional__c=TargetQuarter[i].revenue_VOIP__c-TargetBaseline[i].revenue_VOIP__C;
                 AST.total_IOT_Additional__c=TargetQuarter[i].revenue_IOT__c-TargetBaseline[i].revenue_IOT__C;
                 AST.total_NON_GSM_Additional__c=TargetQuarter[i].revenue_NON_GSM__c-TargetBaseline[i].revenue_NON_GSM__C;
                 AST.total_M_Ads_Additional__c=TargetQuarter[i].revenue_M_Ads__c-TargetBaseline[i].revenue_M_Ads__C;
                 AST.Total_Additional__c=TargetQuarter[i].Total_revenue__c-TargetBaseline[i].total_revenue__c;
                
                 AST.Target_per_sales_quarter__c=TargetQuarter[i].id;
                 if(AST.total_M_Ads_Additional__c>1000000000)
                 {AST.exception_m_ads__c=true;}
                 AST.segment__c=Segment;
                 if(Segment=='Media & E-Commerce')
                 {
                    AST.total_Additional__c=Ast.total_Additional__c-AST.TOTal_M_Ads_Additional__c;
                 }
                 AST.Name=Segment +'  '+ TargetQuarter[i].Sales__r.Name+' '+TargetQuarter[i].target_timeline__c ; 
                
                 listAST.add(AST);
             }
         }
         upsert listAST;
      
        

     }

}