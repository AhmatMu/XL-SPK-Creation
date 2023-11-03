@istest
private class Test_Sales_Target {
    static testMethod void testtrigger() {
        Target__c T=new Target__c();
        T.Timeline__c='Baseline';
        T.Type_Segment__c='Energy & ISP';
        T.Revenueperlink__c=3;
        T.revenue_GSM__c=3;
        T.revenue_non_GSM__c=3;
        T.Revenue_IOT__c=3;
        T.revenue_VOIP__c=3;
        T.revenue_m_ads__c=3;
        insert T;
        list<target_per_sales__c> listtps=[select id,revenue_gsm__c,revenue_non_gsm__c,revenueperlink__c,revenue_m_ads__c,revenue_voip__c,revenue_iot__c from target_per_sales__c];
        for(target_per_sales__c TPS:listtps)
        {
            TPS.Revenueperlink__c=1;
            TPS.revenue_GSM__c=1;
            TPS.revenue_non_GSM__c=1;
            TPS.Revenue_IOT__c=1;
            TPS.revenue_VOIP__c=1;
            TPS.revenue_m_ads__c=1;
        }
        update listtps;
        list<String> S1=new list<String>{'January','April','July','October'};
       
        list<Target__c> listT=new list<Target__c> ();
        for(String S:S1)
        {
        Target__c T1=new Target__c();
        T1.Timeline__c='Monthly Target';
        T1.Type_Segment__c='Red';
        T1.Month_Target__c=S;
        T1.Year_Target__c=system.today().year();
        T1.Revenueperlink__c=100;
        T1.revenue_GSM__c=100;
        T1.revenue_non_GSM__c=100;
        T1.Revenue_IOT__c=100;
        T1.revenue_VOIP__c=100;
        T1.revenue_m_ads__c=100;
        listT.add(T1);
        }
        insert listT;
        listT=new list<Target__c>();
        list<String> S3=new list<String>{'February','May','August','November'};
        for(String S:S3)
        {
         Target__c T3=new Target__c();
         T3.Timeline__c='Monthly Target';
         T3.Type_Segment__c='Red';
         T3.Month_Target__c=S;
         T3.Year_Target__c=system.today().year();
         T3.Revenueperlink__c=150;
         T3.revenue_GSM__c=150;
         T3.revenue_non_GSM__c=150;
         T3.Revenue_IOT__c=150;
         T3.revenue_VOIP__c=150;
         T3.revenue_m_ads__c=150;
         listT.add(T3);
        }
        insert ListT; 
        listT=new list<Target__c>();
       list<String> S2=new list<String>{'March','June','September','December'};
       for(String S:S2)
       {
        Target__c T2=new Target__c();
        T2.Timeline__c='Monthly Target';
        T2.Type_Segment__c='Red';
        T2.Month_Target__c=S;
        T2.Year_Target__c=system.today().year();
        T2.Revenueperlink__c=200;
        T2.revenue_GSM__c=200;
        T2.revenue_non_GSM__c=200;
        T2.Revenue_IOT__c=200;
        T2.revenue_VOIP__c=200;
        T2.revenue_m_ads__c=200;
        listT.add(T2);
       }
       insert ListT;
 
       List<Target_Per_Sales__c> listTPS2=[SELECT Sales__c,Revenue_GSM__c,Revenue_IOT__C,Revenue_NON_GSM__c,Revenue_VOIP__c,Revenue_M_Ads__c FROM Target_per_sales__C WHERE Target_timeline__c='Monthly Target'];
       Target_Per_Sales__c tps2=[SELECT id,Sales__c,Revenue_GSM__c,Revenue_IOT__C,Revenue_NON_GSM__c,Revenue_VOIP__c,Revenue_M_Ads__c FROM Target_per_sales__C WHERE Target_timeline__c='baseline/3' LIMIT 1];
       String Sales='';
       for(Target_per_Sales__c TPS:listTPS2)
       {
        Sales=TPS.Sales__c;
        TPS.Revenueperlink__c=1;
        TPS.revenue_GSM__c=1;
        TPS.revenue_non_GSM__c=1;
        TPS.Revenue_IOT__c=1;
        TPS.revenue_VOIP__c=1;
        TPS.revenue_m_ads__c=1;
        tps.previous_target__c=tps2.id;
       }
       update listTPS2;
     //  Set_Sales_Target.fillsalestarget('October',system.today().year(),'Baseline/3');
       Target Tg=new Target();
       Tg.CalculateAll('March',system.today().year()+1,'Energy & ISP'); 
       Tg.generateTargetPerSales('June',system.today().year(),'Energy & ISP',listTPS2[0].sales__c); 
       Tg.generateTargetPerSales('September',system.today().year(),'Energy & ISP',listTPS2[0].sales__c); 
       Tg.generateTargetPerSales('December',system.today().year(),'Energy & ISP',listTPS2[0].sales__c); 
    }
    
    static testMethod void testVF() {
        Target__c T=new Target__c();
        T.Timeline__c='Baseline';
        T.Type_Segment__c='Energy & ISP';
        T.Revenueperlink__c=3;
        T.revenue_GSM__c=3;
        T.revenue_non_GSM__c=3;
        T.Revenue_IOT__c=3;
        T.revenue_VOIP__c=3;
        T.revenue_m_ads__c=3;
        insert T;
        list<target_per_sales__c> listtps=[select id,Sales__c,Segment__c,revenue_gsm__c,revenue_non_gsm__c,revenueperlink__c,revenue_m_ads__c,revenue_voip__c,revenue_iot__c from target_per_sales__c];
        for(target_per_sales__c TPS:listtps)
        {
            TPS.Revenueperlink__c=1;
            TPS.revenue_GSM__c=1;
            TPS.revenue_non_GSM__c=1;
            TPS.Revenue_IOT__c=1;
            TPS.revenue_VOIP__c=1;
            TPS.revenue_m_ads__c=1;
        }
        update listtps;
        list<String> S1=new list<String>{'April'};
       
        list<Target__c> listT=new list<Target__c> ();
        for(String S:S1)
        {
        Target__c T1=new Target__c();
        T1.Timeline__c='Monthly Target';
        T1.Type_Segment__c='Red';
        T1.Month_Target__c=S;
        T1.Year_Target__c=system.today().year();
        T1.Revenueperlink__c=100;
        T1.revenue_GSM__c=100;
        T1.revenue_non_GSM__c=100;
        T1.Revenue_IOT__c=100;
        T1.revenue_VOIP__c=100;
        T1.revenue_m_ads__c=100;
        listT.add(T1);
        }
        insert listT;
        listT=new list<Target__c>();
        list<String> S3=new list<String>{'May'};
        for(String S:S3)
        {
         Target__c T3=new Target__c();
         T3.Timeline__c='Monthly Target';
         T3.Type_Segment__c='Red';
         T3.Month_Target__c=S;
         T3.Year_Target__c=system.today().year();
         T3.Revenueperlink__c=150;
         T3.revenue_GSM__c=150;
         T3.revenue_non_GSM__c=150;
         T3.Revenue_IOT__c=150;
         T3.revenue_VOIP__c=150;
         T3.revenue_m_ads__c=150;
         listT.add(T3);
        }
        insert ListT; 
        listT=new list<Target__c>();
       list<String> S2=new list<String>{'June'};
       for(String S:S2)
       {
        Target__c T2=new Target__c();
        T2.Timeline__c='Monthly Target';
        T2.Type_Segment__c='Red';
        T2.Month_Target__c=S;
        T2.Year_Target__c=system.today().year();
        T2.Revenueperlink__c=200;
        T2.revenue_GSM__c=200;
        T2.revenue_non_GSM__c=200;
        T2.Revenue_IOT__c=200;
        T2.revenue_VOIP__c=200;
        T2.revenue_m_ads__c=200;
        listT.add(T2);
       }
       insert ListT;
    
       CalculateTargetController CTC=new CalculateTargetController();
       CTC.getItems();
       CTC.getMonths();
       CTC.setMonths('April');
       CTC.AdditionalCreate();
       Additional_Target__c AT=[SELECT id,percent_1__c,percent_2__c,percent_3__c,percent_4__c,percent_5__c,percent_6__c,percent_7__c,Additional_1__c,Additional_2__c,Additional_3__c,Additional_4__c,Additional_5__c,Additional_6__c,Additional_7__c FROM Additional_Target__c WHERE Createddate=TODAY];
       AT.Percent_2__c=100;
       AT.percent_1__c=0;
       AT.Percent_3__c=0;
       AT.percent_4__c=0;
       AT.Percent_5__c=0;
       AT.percent_6__c=0;
       AT.Percent_7__c=0;
       AT.Additional_1__c=0;
       AT.Additional_3__c=0;
       AT.Additional_4__c=0;
       AT.Additional_5__c=0;
       AT.Additional_6__c=0;
       AT.Additional_7__c=0;
       update AT;
       CTC.AdditionalModify();
       CTC.year='2020';
      CTC.setsalestarget();
      CTC.fixtotal();
      Additional_Target.CekRed('April', system.today().year());
     
       CTC.Quarter();
      
       CTC.AdditionalSalesCreate();
      
       Ctc.checkbalancesalestarget();
       Set_Sales_Target.decreasesalestarget(listTPS[0].sales__c, 'Energy & ISP', 'April', system.today().year(), 50);

    }
    static testMethod void testsetsalestarget() {
        Target__c T=new Target__c();
        T.Timeline__c='Baseline';
        T.Type_Segment__c='Energy & ISP';
        T.Revenueperlink__c=60000000*5;
        T.revenue_GSM__c=600000000*5;
        T.revenue_non_GSM__c=600000000*5;
        T.Revenue_IOT__c=600000000*5;
        T.revenue_VOIP__c=600000000*5;
        T.revenue_m_ads__c=600000000*5;
      
        insert T;
        list<target_per_sales__c> listtps=[select id,revenue_gsm__c,revenue_non_gsm__c,revenueperlink__c,revenue_m_ads__c,revenue_voip__c,revenue_iot__c from target_per_sales__c];
        for(target_per_sales__c TPS:listtps)
        {
            TPS.Revenueperlink__c=2000*2000;
            TPS.revenue_GSM__c=20000*20000;
            TPS.revenue_non_GSM__c=20000*20000;
            TPS.Revenue_IOT__c=20000*20000;
            TPS.revenue_VOIP__c=20000*20000;
            TPS.revenue_m_ads__c=20000*20000;
            TPS.additional_GSM__c=3;
            TPS.additional_non_GSM__c=3;
            TPS.additional_IOT__c=3;
            TPS.additional_VOIP__c=3;
        }
        update listtps;
        list<String> S1=new list<String>{'April'};
       
        list<Target__c> listT=new list<Target__c> ();
        for(String S:S1)
        {
        Target__c T1=new Target__c();
        T1.Timeline__c='Monthly Target';
        T1.Type_Segment__c='Red';
        T1.Month_Target__c=S;
        T1.Year_Target__c=system.today().year();
        T1.Revenueperlink__c=100;
        T1.revenue_GSM__c=100;
        T1.revenue_non_GSM__c=100;
        T1.Revenue_IOT__c=100;
        T1.revenue_VOIP__c=100;
        T1.revenue_m_ads__c=100;
        listT.add(T1);
        }
        insert listT;
        listT=new list<Target__c>();
        list<String> S3=new list<String>{'May'};
        for(String S:S3)
        {
         Target__c T3=new Target__c();
         T3.Timeline__c='Monthly Target';
         T3.Type_Segment__c='Red';
         T3.Month_Target__c=S;
         T3.Year_Target__c=system.today().year();
         T3.Revenueperlink__c=150;
         T3.revenue_GSM__c=150;
         T3.revenue_non_GSM__c=150;
         T3.Revenue_IOT__c=150;
         T3.revenue_VOIP__c=150;
         T3.revenue_m_ads__c=150;
         listT.add(T3);
        }
        insert listT;
       
         Target__c T5=new Target__c();
         T5.Timeline__c='Monthly Target';
         T5.Type_Segment__c='Red';
         T5.Month_Target__c='June';
         T5.Year_Target__c=system.today().year();
         T5.Revenueperlink__c=150;
         T5.revenue_GSM__c=150;
         T5.revenue_non_GSM__c=150;
         T5.Revenue_IOT__c=150;
         T5.revenue_VOIP__c=150;
         T5.revenue_m_ads__c=150;
         insert T5;
        
        Set_Sales_Target.FillSalesTarget(S1[0], system.today().year(), 'Baseline/3','Energy & ISP');
        Set_Sales_Target.fixtotaltargetSales('Energy & ISP', S1[0], system.today().year());
        Set_Sales_Target.FillSalesTarget('May', system.today().year(), 'April','Energy & ISP');
        Target Tgt=new Target();
        Tgt.CalculateAll('June', system.today().year(),'Energy & ISP');
        Set_Sales_Target.AdditionalSalesTarget('Energy & ISP');
    
          Set_Sales_Target.CheckBalanceSalesTarget('Energy & ISP', 'Quarter 2');
          target_per_sales__c A=[select id,sales__c,segment__c from target_per_sales__c LIMIT 1];
          Set_Sales_Target.increasesalestarget(A.sales__c, A.segment__c, 'April',system.today().year(), 50000);
    }
    static testMethod void testAdditional() {
        Target__c T=new Target__c();
        T.Timeline__c='Baseline';
        T.Type_Segment__c='Energy & ISP';
        T.Revenueperlink__c=3000;
        T.revenue_GSM__c=3000000*30000;
        T.revenue_non_GSM__c=3000000*30000;
        T.Revenue_IOT__c=3000000*30000;
        T.revenue_VOIP__c=3000000*30000;
        T.revenue_m_ads__c=3000000*30000;
        insert T;
        Target__c TS=new Target__c();
        TS.Timeline__c='Baseline';
        TS.Type_Segment__c='Banking & Financial Services';
        TS.Revenueperlink__c=3000;
        TS.revenue_GSM__c=3000000*30000;
        TS.revenue_non_GSM__c=3000000*30000;
        TS.Revenue_IOT__c=3000000*30000;
        TS.revenue_VOIP__c=3000000*30000;
        TS.revenue_m_ads__c=3000000*30000;
        insert TS;
        list<target_per_sales__c> listtps=[select id,revenue_gsm__c,revenue_non_gsm__c,revenueperlink__c,revenue_m_ads__c,revenue_voip__c,revenue_iot__c from target_per_sales__c];
        for(target_per_sales__c TPS:listtps)
        {
            TPS.Revenueperlink__c=5000;
            TPS.revenue_GSM__c=50000*50000;
            TPS.revenue_non_GSM__c=5000*500;
            TPS.Revenue_IOT__c=50000*500;
            TPS.revenue_VOIP__c=5000000*50000;
            TPS.revenue_m_ads__c=5000000*50000;
        }
        update listtps;
        list<String> S1=new list<String>{'July'};
       
        list<Target__c> listT=new list<Target__c> ();
        for(String S:S1)
        {
        Target__c T1=new Target__c();
        T1.Timeline__c='Monthly Target';
        T1.Type_Segment__c='Red';
        T1.Month_Target__c=S;
        T1.Year_Target__c=system.today().year();
        T1.Revenueperlink__c=5000;
        T1.revenue_GSM__c=500000000*50000000;
        T1.revenue_non_GSM__c=500000000*50000000;
        T1.Revenue_IOT__c=500000000*50000000;
        T1.revenue_VOIP__c=500000000*50000000;
        T1.revenue_m_ads__c=500000000*50000000;
        listT.add(T1);
        }
        insert listT;
        listT=new list<Target__c>();
        list<String> S3=new list<String>{'August'};
        for(String S:S3)
        {
         Target__c T3=new Target__c();
         T3.Timeline__c='Monthly Target';
         T3.Type_Segment__c='Red';
         T3.Month_Target__c=S;
         T3.Year_Target__c=system.today().year();
         T3.Revenueperlink__c=500000000*50000000;
         T3.revenue_GSM__c=500000000*50000000;
         T3.revenue_non_GSM__c=500000000*50000000;
         T3.Revenue_IOT__c=500000000*50000000;
         T3.revenue_VOIP__c=155000000*50000000;
         T3.revenue_m_ads__c=500000000*50000000;
         listT.add(T3);
        }
        insert ListT; 
        listT=new list<Target__c>();
       list<String> S2=new list<String>{'September'};
       for(String S:S2)
       {
        Target__c T2=new Target__c();
        T2.Timeline__c='Monthly Target';
        T2.Type_Segment__c='Red';
        T2.Month_Target__c=S;
        T2.Year_Target__c=system.today().year();
        T2.Revenueperlink__c=200;
        T2.revenue_GSM__c=500000000*50000000;
        T2.revenue_non_GSM__c=500000000*50000000;
        T2.Revenue_IOT__c=500000000*50000000;
        T2.revenue_VOIP__c=500000000*50000000;
        T2.revenue_m_ads__c=500000000*50000000;
        listT.add(T2);
       }
       insert ListT;
       Additional_Target.Addtotal();
       Additional_Target__c AT=[SELECT id,percent_1__c,percent_2__c,percent_3__c,percent_4__c,percent_5__c,percent_6__c,percent_7__c,Additional_1__c,Additional_2__c,Additional_3__c,Additional_4__c,Additional_5__c,Additional_6__c,Additional_7__c FROM Additional_Target__c WHERE Createddate=TODAY];
       AT.Percent_2__c=100;
       AT.percent_1__c=0;
       AT.Percent_3__c=0;
       AT.percent_4__c=0;
       AT.Percent_5__c=0;
       AT.percent_6__c=0;
       AT.Percent_7__c=0;
       AT.Additional_1__c=0;
       AT.Additional_3__c=0;
       AT.Additional_4__c=0;
       AT.Additional_5__c=0;
       AT.Additional_6__c=0;
       AT.Additional_7__c=0;
       update AT;
       Additional_Target.ModifyAdditional('3');
       Additional_Target.Addtarget('Banking & FInancial Services',225,'3');
       Additional_Target.checkproportion('3');
       Additional_Target.fixproportionup('Banking & Financial Services','July',system.today().year(), 400);
       Additional_Target.fixdeficit('July', system.today().year());
       Additional_Target.fixproportion('Energy & ISP','July',system.today().year(), 400);
    }
    static testmethod void targetMELE()
    {
        /*
        Target__c T=new Target__c();
        T.Timeline__c='Baseline';
        T.Type_Segment__c='Energy & ISP';
        T.Revenueperlink__c=3000;
        T.revenue_GSM__c=3000000*30000;
        T.revenue_non_GSM__c=3000000*30000;
        T.Revenue_IOT__c=3000000*30000;
        T.revenue_VOIP__c=3000000*30000;
        T.revenue_m_ads__c=3000000*30000;
        insert T;
        Target__c TS=new Target__c();
        TS.Timeline__c='Baseline';
        TS.Type_Segment__c='Banking & Financial Services';
        TS.Revenueperlink__c=3000;
        TS.revenue_GSM__c=3000000*30000;
        TS.revenue_non_GSM__c=3000000*30000;
        TS.Revenue_IOT__c=3000000*30000;
        TS.revenue_VOIP__c=3000000*30000;
        TS.revenue_m_ads__c=3000000*30000;
        insert TS;
        list<String> S1=new list<String>{'July'};
       
        list<Target__c> listT=new list<Target__c> ();
        for(String S:S1)
        {
        Target__c T1=new Target__c();
        T1.Timeline__c='Monthly Target';
        T1.Type_Segment__c='Red';
        T1.Month_Target__c=S;
        T1.Year_Target__c=system.today().year();
        T1.Revenueperlink__c=5000;
        T1.revenue_GSM__c=500000000*50000000;
        T1.revenue_non_GSM__c=500000000*50000000;
        T1.Revenue_IOT__c=500000000*50000000;
        T1.revenue_VOIP__c=500000000*50000000;
        T1.revenue_m_ads__c=500000000*50000000;
        listT.add(T1);
        }
        insert listT;
        listT=new list<Target__c>();
        list<String> S3=new list<String>{'August'};
        for(String S:S3)
        {
         Target__c T3=new Target__c();
         T3.Timeline__c='Monthly Target';
         T3.Type_Segment__c='Red';
         T3.Month_Target__c=S;
         T3.Year_Target__c=system.today().year();
         T3.Revenueperlink__c=500000000*50000000;
         T3.revenue_GSM__c=500000000*50000000;
         T3.revenue_non_GSM__c=500000000*50000000;
         T3.Revenue_IOT__c=500000000*50000000;
         T3.revenue_VOIP__c=155000000*50000000;
         T3.revenue_m_ads__c=500000000*50000000;
         listT.add(T3);
        }
        insert ListT; 
        listT=new list<Target__c>();
       list<String> S2=new list<String>{'September'};
       for(String S:S2)
       {
        Target__c T2=new Target__c();
        T2.Timeline__c='Monthly Target';
        T2.Type_Segment__c='Red';
        T2.Month_Target__c=S;
        T2.Year_Target__c=system.today().year();
        T2.Revenueperlink__c=200;
        T2.revenue_GSM__c=50000*50000;
        T2.revenue_non_GSM__c=500000*50000;
        T2.Revenue_IOT__c=50000*50000;
        T2.revenue_VOIP__c=500000*50000;
        T2.revenue_m_ads__c=50000*50000;
        listT.add(T2);
       }
       insert ListT;
       Additional_Target.Addtotal();
       Additional_Target__c AT=[SELECT id,percent_1__c,percent_2__c,percent_3__c,percent_4__c,percent_5__c,percent_6__c,percent_7__c,Additional_1__c,Additional_2__c,Additional_3__c,Additional_4__c,Additional_5__c,Additional_6__c,Additional_7__c FROM Additional_Target__c WHERE Createddate=TODAY];
       AT.Percent_2__c=100;
       AT.percent_1__c=0;
       AT.Percent_3__c=0;
       AT.percent_4__c=0;
       AT.Percent_5__c=0;
       AT.percent_6__c=0;
       AT.Percent_7__c=0;
       AT.Additional_1__c=0;
       AT.Additional_3__c=0;
       AT.Additional_4__c=0;
       AT.Additional_5__c=0;
       AT.Additional_6__c=0;
       AT.Additional_7__c=0;
       AT.expected_total_LE__c=109399393*32444;
       AT.expected_total_ME__c=1000000*100000;
       update AT;*/
    }
    static testMethod void testVF2() {
        List<Target__c> listT=new list<Target__c>();
        list<String> listSegment=new list<String>{'Energy & ISP','Banking & Financial Services','Indirect Sales'};
        for(String S:listSegment)
        {
        Target__c T=new Target__c();
        T.Timeline__c='Baseline';
        T.Type_Segment__c=S;
        T.Revenueperlink__c=3;
        T.revenue_GSM__c=30000000;
        T.revenue_non_GSM__c=3000000;
        T.Revenue_IOT__c=3000000;
        T.revenue_VOIP__c=3000000;
        T.revenue_m_ads__c=300000;
        listT.add(T);
        }
        insert ListT;
        list<target_per_sales__c> listtps=[select id,revenue_gsm__c,revenue_non_gsm__c,revenueperlink__c,revenue_m_ads__c,revenue_voip__c,revenue_iot__c from target_per_sales__c];
        for(target_per_sales__c TPS:listtps)
        {
            TPS.Revenueperlink__c=1;
            TPS.revenue_GSM__c=1;
            TPS.revenue_non_GSM__c=1;
            TPS.Revenue_IOT__c=1;
            TPS.revenue_VOIP__c=1;
            TPS.revenue_m_ads__c=1;
        }
        update listtps;
       
       
       
        Target__c T1=new Target__c();
        T1.Timeline__c='Monthly Target';
        T1.Type_Segment__c='Red';
        T1.Month_Target__c='July';
        T1.Year_Target__c=system.today().year();
        T1.Revenueperlink__c=4;
        T1.revenue_GSM__c=400000000;
        T1.revenue_non_GSM__c=400000000;
        T1.Revenue_IOT__c=400000000;
        T1.revenue_VOIP__c=400000000;
        T1.revenue_m_ads__c=400000000;
       insert T1;
       
         Target__c T3=new Target__c();
         T3.Timeline__c='Monthly Target';
         T3.Type_Segment__c='Red';
         T3.Month_Target__c='August';
         T3.Year_Target__c=system.today().year();
         T3.Revenueperlink__c=55;
         T3.revenue_GSM__c=500000050;
         T3.revenue_non_GSM__c=550000000;
         T3.Revenue_IOT__c=5000000;
         T3.revenue_VOIP__c=5000000;
         T3.revenue_m_ads__c=50000000;
       insert T3;
        listT=new list<Target__c>();
       list<String> S2=new list<String>{'September'};
       for(String S:S2)
       {
        Target__c T2=new Target__c();
        T2.Timeline__c='Monthly Target';
        T2.Type_Segment__c='Red';
        T2.Month_Target__c=S;
        T2.Year_Target__c=system.today().year();
        T2.Revenueperlink__c=200;
        T2.revenue_GSM__c=200;
        T2.revenue_non_GSM__c=200;
        T2.Revenue_IOT__c=200;
        T2.revenue_VOIP__c=200;
        T2.revenue_m_ads__c=200;
        listT.add(T2);
       }
       insert ListT;
    
       CalculateTargetController CTC=new CalculateTargetController();
       CTC.getItems();
       CTC.getMonths();
       CTC.setMonths('July');
       Ctc.AdditionalCreate();
       Additional_Target__c AT=[SELECT id,percent_1__c,percent_2__c,percent_3__c,percent_4__c,percent_5__c,percent_6__c,percent_7__c,Additional_1__c,Additional_2__c,Additional_3__c,Additional_4__c,Additional_5__c,Additional_6__c,Additional_7__c FROM Additional_Target__c WHERE Createddate=TODAY];
       AT.Percent_2__c=100;
       AT.percent_1__c=0;
       AT.Percent_3__c=0;
       AT.percent_4__c=0;
       AT.Percent_5__c=0;
       AT.percent_6__c=0;
       AT.Percent_7__c=0;
       AT.Additional_1__c=0;
       AT.Additional_3__c=0;
       AT.Additional_4__c=0;
       AT.Additional_5__c=0;
       AT.Additional_6__c=0;
       AT.Additional_7__c=0;
       AT.expected_total_LE__c=109399393*32444;
       AT.expected_total_ME__c=1000000*100000;
       update AT;
       CTC.settargetsegment('Banking & Financial Services');
       CTC.Year=String.valueof(system.today().year());
       CTC.getItemSegment();
       CTC.gettargetsegment();
       CTC.fixdeficit();
       CTC.updateQuarter();
       CTC.transferMELE();
       CTC.AdditionalCreate();
       CTC.checkproportion();

    }
    
    
}