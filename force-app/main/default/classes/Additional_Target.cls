/*SURYA 16 March 2020 for additional target ,calculation after red and additional percent set, set quarter after monthly target modified*/
global class Additional_Target {
    public class Deficit{
        String Month;
        String Service;
        Decimal Revenue;
    }
   
    //count original additional/update new additional
    public static void AddTotal() {
        list<Target__c> TargetBaseline=[SELECT id,Total_Segment__c,Type_Segment__c,Revenue_GSM__c,Revenue_Non_GSM__c,Revenue_IOT__c,Revenue_VOIP__c,Revenue_M_Ads__c FROM Target__c WHERE Timeline__c='Baseline' and Createddate>=LAST_MONTH ORDER BY Type_Segment__c DESC];
        list<Additional_Target__c> ATrget=[select id FROM Additional_Target__c WHERE Createddate>=LAST_MONTH];
        Additional_Target__c A=new Additional_Target__c();
        if(Atrget.size()>0)
        A.id=Atrget[0].id;
        Decimal Selisih=0;
        Decimal TotalQuarter=0;
        Decimal TotalBaseline=0;
        String Timeline='';
        String Year='';
        list<Target__c> TargetQuarter=[SELECT id,year_target__c,Total_Segment__c,Timeline__c,Type_Segment__c,Revenue_GSM__c,Revenue_Non_GSM__c,Revenue_IOT__c,Revenue_VOIP__c,Revenue_M_Ads__c FROM Target__c WHERE Timeline__c LIKE '%Quarter%' and Createddate>=LAST_MONTH ORDER BY Type_Segment__c DESC];
        for(Integer I=0;i<targetquarter.size();i++)
        {
            Selisih=TargetQuarter[i].Total_Segment__c-TargetBaseline[i].Total_Segment__c;
            if(TargetBaseline[i].type_segment__c=='Banking & Financial Services')
            A.Additional_1__c=selisih;
            if(TargetBaseline[i].type_segment__c=='Energy & ISP')
            A.Additional_2__c=selisih;
            if(TargetBaseline[i].type_segment__c=='FMCG & Translog')
            A.Additional_3__c=selisih;
            if(TargetBaseline[i].type_segment__c=='Government & Public Sector')
            A.Additional_4__c=selisih;
            if(TargetBaseline[i].type_segment__c=='Media & E-Commerce')
            A.Additional_5__c=selisih;
            if(TargetBaseline[i].type_segment__c=='Indirect Sales')
            A.Additional_6__c=selisih;
            if(TargetBaseline[i].type_segment__c=='Direct Sales')
            A.Additional_7__c=selisih;
            TotalBaseline=TotalBaseline+TargetBaseline[i].total_segment__c;
            TotalQuarter=TotalQuarter+TargetQuarter[i].total_segment__c;
            Timeline=TargetQuarter[i].timeline__c;
            Year=String.valueof(TargetQuarter[i].year_target__c);
        }
        A.Total__c=totalquarter;
        A.Total_Baseline__c=TotalBaseline;
        A.Name='Additional for '+Timeline+'   '+  year;
        if(timeline !='' && year !='')
        upsert A;
    }
    //modify additional according to percentage set
    public static void ModifyAdditional(String Quarter) {
       
            Additional_Target__c A=[SELECT id,Expected_Total_LE__c,Expected_Total_ME__c,Total_LE__c,Total_ME__c,Percent_1__c,Percent_2__c,Percent_3__c,Percent_4__c,Percent_5__c,Percent_6__c,Percent_7__c,Additional_1__c,Additional_2__c,Additional_3__c,Additional_4__c,Additional_5__c,Additional_6__c,Additional_7__c FROM Additional_Target__c WHERE Createddate>=LAST_month LIMIT 1];
           Decimal Total1=A.Total_LE__c*A.Percent_1__c/100;
           Decimal Total2=A.Total_LE__c*A.Percent_2__c/100;
           Decimal Total3=A.Total_LE__c*A.Percent_3__c/100;
           Decimal Total4=A.Total_LE__c*A.Percent_4__c/100;
           Decimal Total5=A.Total_LE__c*A.Percent_5__c/100;
           Decimal Total6=A.Total_ME__c*A.Percent_6__c/100;
           Decimal Total7=A.Total_ME__c*A.Percent_7__c/100;
          
           Decimal Selisih=0;
            if(A.Additional_1__c<Total1)
            {
                Selisih=Total1-A.Additional_1__c;
                AddTarget('Banking & Financial Services',Selisih,Quarter);
            }
            else if(total1>0) {
                Selisih=A.Additional_1__c-total1;
                ReduceTarget('Banking & Financial Services',Selisih,Quarter);
            }
            if(A.Additional_2__c<Total2)
            {
                Selisih=Total2-A.Additional_2__c;
                AddTarget('Energy & ISP',Selisih,Quarter);
            }
            else if(total2>0){
                Selisih=A.Additional_2__c-Total2;
                ReduceTarget('Energy & ISP',Selisih,Quarter);
            }
            if(A.Additional_3__c<Total3)
            {
                Selisih=Total3-A.Additional_3__c;
                AddTarget('FMCG & Translog',Selisih,Quarter);
            }
            else if(total3>0){
                Selisih=A.Additional_3__c-Total3;
                ReduceTarget('FMCG & Translog',Selisih,Quarter);
            }
            if(A.Additional_4__c<Total4)
            {
                Selisih=Total4-A.Additional_4__c;
                AddTarget('Government & Public Sector',Selisih,Quarter);
            }
            else if(total4>0){
                Selisih=A.Additional_4__c-Total4;
                ReduceTarget('Government & Public Sector',Selisih,Quarter);
            }
            if(A.Additional_5__c<Total5)
            {
                Selisih=Total5-A.Additional_5__c;
                AddTarget('Media & E-Commerce',Selisih,Quarter);
            }
            else if(total5>0){
                Selisih=A.Additional_5__c-Total5;
                ReduceTarget('Media & E-Commerce',Selisih,Quarter);
            }
            if(A.Additional_6__c<Total6)
            {
                Selisih=Total6-A.Additional_6__c;
                AddTarget('Indirect Sales',Selisih,Quarter);
            }
            else if(total6>0){
                Selisih=A.Additional_6__c-Total6;
                ReduceTarget('Indirect Sales',Selisih,Quarter);
            }
            if(A.Additional_7__c<Total7)
            {
                Selisih=Total7-A.Additional_7__c;
                AddTarget('Direct Sales',Selisih,Quarter);
            }
            else if(total7>0){
                Selisih=A.Additional_7__c-Total7;
                ReduceTarget('Direct Sales',Selisih,Quarter);
            }
            

            if(Quarter=='1')
            {
            cekred('January',system.today().year()+1);
            cekred('February',system.today().year()+1);
            cekred('March',system.today().year()+1);
            }
            if(Quarter=='2')
            {
                cekred('April',system.today().year());
                cekred('May',system.today().year());
                cekred('June',system.today().year());
            }
            if(Quarter=='3')
            {
                cekred('July',system.today().year());
                cekred('August',system.today().year());
                cekred('September',system.today().year());
            }
            if(Quarter=='4')
            {
                cekred('October',system.today().year());
                cekred('November',system.today().year());
                cekred('December',system.today().year());
            }
            setquarter();
        }
        
        //if additional want to add target using this function ,to increase proportion according to expected %
        public Static void AddTarget(String Segment,Decimal Selisih,String Quarter)
        {
            Decimal Selisihper3= Selisih/3;
            String Month1='';
            String Month2='';
            String Month3='';
            if(Quarter=='1')
            {
                 Month1='January';
                 Month2='February';
                 Month3='March';
            }
            if(Quarter=='2')
            {
                 Month1='April';
                 Month2='May';
                 Month3='June';
            }
            if(Quarter=='3')
            {
                 Month1='July';
                 Month2='August';
                 Month3='September';
            }
            if(Quarter=='4')
            {
                 Month1='October';
                 Month2='November';
                 Month3='December';
            }
            
            list<Target__c> listT=[SELECT id,segment_classification__c,number_of_sales__c,total_segment__c,type_segment__c,revenue_iot__c,revenue_voip__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c FROM Target__c WHERE type_segment__c=:segment AND Timeline__c='Monthly Target' AND (month_target__c=:Month1 OR month_target__c=:Month2 OR Month_target__c=:month3)];
          
            for(target__c T:listT)
            {
                Decimal TotalAll=0;
                if(T.revenue_iot__c>Integer.valueof(system.label.lower_limit_IOT)*T.number_of_sales__c)
                    TotalAll=TotalAll+T.revenue_iot__c;
                    if(T.revenue_VOIP__c>Integer.valueof(system.label.lower_limit_VOIP)*T.number_of_sales__c)
                    TotalAll=TotalAll+T.revenue_VOIP__c;
                    if(T.revenue_GSM__c>Integer.valueof(system.label.lower_limit_GSM)*T.number_of_sales__c)
                    TotalAll=TotalAll+T.revenue_GSM__c;
                    if(T.segment_classification__c=='LE')
                    {
                    if(T.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM)*T.number_of_sales__c)
                    TotalAll=TotalAll+T.revenue_NON_GSM__c;
                    }
                    if(T.segment_classification__c=='ME')
                    {
                    if(T.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM_ME)*T.number_of_sales__c)
                    TotalAll=TotalAll+T.revenue_NON_GSM__c;
                    }
                    if(T.revenue_M_Ads__c>Integer.valueof(system.label.lower_limit_M_Ads)*T.number_of_sales__c)
                    TotalAll=TotalAll+T.revenue_M_Ads__c;
                    if(T.revenue_iot__c>Integer.valueof(system.label.lower_limit_IOT)*T.number_of_sales__c)
                T.revenue_iot__c=T.revenue_iot__c+(selisihper3*T.revenue_iot__c/TotalAll);
                if(T.segment_classification__c=='LE')
                {
                if(T.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM)*T.number_of_sales__c)
                T.revenue_non_gsm__c=T.revenue_non_gsm__c+(selisihper3*T.revenue_non_gsm__c/TotalAll);
                }
                if(T.segment_classification__c=='ME')
                {
                if(T.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM_ME)*T.number_of_sales__c)
                T.revenue_non_gsm__c=T.revenue_non_gsm__c+(selisihper3*T.revenue_non_gsm__c/TotalAll);
                }

                if(T.revenue_GSM__c>Integer.valueof(system.label.lower_limit_GSM)*T.number_of_sales__c)
                T.revenue_gsm__c=T.revenue_gsm__c+(selisihper3*T.revenue_gsm__c/T.total_segment__c);
                if(T.revenue_VOIP__c>Integer.valueof(system.label.lower_limit_VOIP)*T.number_of_sales__c)
                T.revenue_VOIP__c=T.revenue_VOIP__c+(selisihper3*T.revenue_VOIP__c/T.total_segment__c);
                if(T.revenue_M_Ads__c>Integer.valueof(system.label.lower_limit_M_Ads)*T.number_of_sales__c)
                T.revenue_M_ads__c=T.revenue_M_ads__c+(selisihper3*T.revenue_M_Ads__c/T.total_segment__c);
            }
            update listT;
          
        }
         //if additional want to reduce target using this function,to reduce proportion according to expected %
         public Static Void ReduceTarget(String Segment,Decimal Selisih,String Quarter)
         {
             String Month1='';
             String Month2='';
             String Month3='';
             if(Quarter=='1')
             {
                  Month1='January';
                  Month2='February';
                  Month3='March';
             }
             if(Quarter=='2')
             {
                  Month1='April';
                  Month2='May';
                  Month3='June';
             }
             if(Quarter=='3')
             {
                  Month1='July';
                  Month2='August';
                  Month3='September';
             }
             if(Quarter=='4')
             {
                  Month1='October';
                  Month2='November';
                  Month3='December';
             }
             Decimal Selisihper3= Selisih/3;
             
             Decimal LowerGSM=0;
             Decimal LowerNOnGSM=0;
             Decimal LowerIOT=0;
             Decimal LowerVOIP=0;
             Decimal LowerMads=0;
             deficit def=new deficit();
             list<Target__c> listT=[SELECT id,Month_Target__c,Number_of_Sales__c,revenue_iot__c,revenue_voip__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,total_segment__c,segment_classification__c FROM Target__c WHERE type_segment__c=:segment AND Timeline__c='Monthly Target' AND (Month_Target__c=:Month1 OR Month_Target__c=:Month2 OR Month_Target__c=:Month3)];
             Target__c previous=new target__c();
                  if(test.isRunningTest())
                  {
             previous=[SELECT id,Month_Target__c,Number_of_Sales__c,revenue_iot__c,revenue_voip__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,total_segment__c FROM Target__c WHERE Timeline__c='Baseline/3' AND createddate>=LAST_MONTH LIMIT 1];
                  }
             else {
                previous=[SELECT id,Month_Target__c,Number_of_Sales__c,revenue_iot__c,revenue_voip__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,total_segment__c FROM Target__c WHERE type_segment__c=:segment AND Timeline__c='Baseline/3' AND createddate>=LAST_MONTH];
        
             }
             for(Target__c T:ListT)
             {
                 Decimal TotalAll=0;
                if(T.revenue_iot__c>2*Integer.valueof(system.label.lower_limit_IOT)*T.number_of_sales__c && previous.revenue_iot__c<T.revenue_iot__c)
                TotalAll=TotalAll+T.revenue_iot__c;
                if(T.revenue_VOIP__c>2*Integer.valueof(system.label.lower_limit_VOIP)*T.number_of_sales__c && previous.revenue_voip__c<T.revenue_voip__c)
                TotalAll=TotalAll+T.revenue_VOIP__c;
                if(T.revenue_GSM__c>2*Integer.valueof(system.label.lower_limit_GSM)*T.number_of_sales__c && previous.revenue_GSM__c<T.revenue_GSM__c)
                TotalAll=TotalAll+T.revenue_GSM__c;
                if(T.segment_classification__c=='LE')
                {
                if(T.revenue_NON_GSM__c>2*Integer.valueof(system.label.lower_limit_NON_GSM)*T.number_of_sales__c && previous.revenue_non_GSM__c<T.revenue_non_GSM__c)
                TotalAll=TotalAll+T.revenue_NON_GSM__c;
                }
                if(T.segment_classification__c=='ME')
                {
                if(T.revenue_NON_GSM__c>2*Integer.valueof(system.label.lower_limit_NON_GSM_ME)*T.number_of_sales__c && previous.revenue_non_GSM__c<T.revenue_non_GSM__c)
                TotalAll=TotalAll+T.revenue_NON_GSM__c;
                }
                if(T.revenue_M_Ads__c>2*Integer.valueof(system.label.lower_limit_M_Ads)*T.number_of_sales__c && previous.revenue_M_Ads__c<T.revenue_M_Ads__c)
                TotalAll=TotalAll+T.revenue_M_Ads__c;

                if(T.revenue_iot__c>2*Integer.valueof(system.label.lower_limit_IOT)*T.number_of_sales__c && previous.revenue_iot__c<T.revenue_iot__c)
                 T.revenue_iot__c=T.revenue_iot__c-(selisihper3*T.revenue_iot__c/totalAll);
                 if(T.segment_classification__c=='LE')
                 {
                 if(T.revenue_NON_GSM__c>2*Integer.valueof(system.label.lower_limit_NON_GSM)*T.number_of_sales__c && previous.revenue_Non_GSM__c<T.revenue_NON_GSM__c)
                 T.revenue_non_gsm__c=T.revenue_non_gsm__c-(selisihper3*T.revenue_non_gsm__c/totalAll);
                 }
                 if(T.segment_classification__c=='ME')
                 {
                 if(T.revenue_NON_GSM__c>2*Integer.valueof(system.label.lower_limit_NON_GSM_ME)*T.number_of_sales__c && previous.revenue_Non_GSM__c<T.revenue_NON_GSM__c)
                 T.revenue_non_gsm__c=T.revenue_non_gsm__c-(selisihper3*T.revenue_non_gsm__c/totalAll);
                 }
                 if(T.revenue_GSM__c>2*Integer.valueof(system.label.lower_limit_GSM)*T.number_of_sales__c && previous.revenue_GSM__c<T.revenue_GSM__c)
                 T.revenue_gsm__c=T.revenue_gsm__c-(selisihper3*T.revenue_gsm__c/totalAll);
                 if(T.revenue_VOIP__c>2*Integer.valueof(system.label.lower_limit_VOIP)*T.number_of_sales__c && previous.revenue_voip__c<T.revenue_voip__c)
                 T.revenue_VOIP__c=T.revenue_VOIP__c-(selisihper3*T.revenue_voip__c/TotalAll);
                 if(T.revenue_M_Ads__c>2*Integer.valueof(system.label.lower_limit_M_Ads)*T.number_of_sales__c && previous.revenue_M_Ads__c<T.revenue_M_Ads__c)
                 T.revenue_M_ads__c=T.revenue_M_ads__c-(selisihper3*T.revenue_m_ads__c/TotalAll);
         
             }
             update listT;
            
             
         }
 //fix deficit and set lower limit by each segment (minimum target * number of sales)
        public static void fixdeficit(String month1,Integer year)
        {
            list<Target__c> listT=[SELECT id,number_of_sales__c,revenue_gsm__c,revenue_voip__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_iot__c,segment_classification__c FROM Target__c Where Month_target__c=:month1 and year_target__c=:year and type_segment__c!='red'];
            Decimal lowerIOT=0;
            Decimal lowervoip=0;
            Decimal lowernongsm=0;
            Decimal lowergsm=0;
            Decimal lowerMads=0;
            Decimal deficitvoip=0;
            Decimal deficitnongsm=0;
            Decimal deficitgsm=0;
            Decimal deficitiot=0;
            Decimal deficitmads=0;
            Integer totaldeficitiot=0;
            integer totaldeficitgsm=0;
            integer totaldeficitnongsm=0;
            integer totaldeficitvoip=0;
            integer totaldeficitmads=0;
            for(integer i=0;i<listT.size();i++)
            {
                loweriot=integer.valueof(system.label.Lower_Limit_IOT)*listT[i].number_of_sales__c;
                lowervoip=integer.valueof(system.label.Lower_Limit_VOIP)*listT[i].number_of_sales__c;
                lowerMads=integer.valueof(system.label.Lower_Limit_M_Ads)*listT[i].number_of_sales__c;
                if(listT[i].segment_classification__c=='LE')
                lowerNONGSM=integer.valueof(system.label.Lower_Limit_Non_GSM)*listT[i].number_of_sales__c;
                if(listT[i].segment_classification__c=='ME')
                lowerNONGSM=integer.valueof(system.label.Lower_Limit_Non_GSM_ME)*listT[i].number_of_sales__c;
                
                lowerGSM=integer.valueof(system.label.Lower_Limit_GSM)*listT[i].number_of_sales__c;
                if(listT[i].revenue_GSM__c<lowergsm)
                {
                    totaldeficitgsm=totaldeficitgsm+1;
                    deficitgsm=deficitgsm+(lowergsm-listT[i].revenue_gsm__c);
                }
                if(listT[i].revenue_non_GSM__c<lowernongsm)
                {
                    totaldeficitnongsm=totaldeficitnongsm+1;
                    deficitnongsm=deficitnongsm+(lowernongsm-listT[i].revenue_non_gsm__c);
                }
                if(listT[i].revenue_iot__c<loweriot)
                {
                    totaldeficitiot=totaldeficitiot+1;
                    deficitiot=deficitiot+(loweriot-listT[i].revenue_iot__c);
                }
                if(listT[i].revenue_voip__c<lowervoip)
                {
                    totaldeficitvoip=totaldeficitvoip+1;
                    deficitvoip=deficitvoip+(lowervoip-listT[i].revenue_voip__c);
                }
                if(listT[i].revenue_m_ads__c<lowermads)
                {
                    totaldeficitmads=totaldeficitmads+1;
                    deficitmads=deficitmads+(lowermads-listT[i].revenue_m_ads__c);
                }
            }
           
            for(integer i=0;i<listT.size();i++)
            {
                loweriot=integer.valueof(system.label.Lower_Limit_IOT)*listT[i].number_of_sales__c;
                lowervoip=integer.valueof(system.label.Lower_Limit_VOIP)*listT[i].number_of_sales__c;
                lowerMads=integer.valueof(system.label.Lower_Limit_M_Ads)*listT[i].number_of_sales__c;
                if(listT[i].segment_classification__c=='LE')             
                lowerNONGSM=integer.valueof(system.label.Lower_Limit_Non_GSM)*listT[i].number_of_sales__c;
                if(listT[i].segment_classification__c=='ME')             
                lowerNONGSM=integer.valueof(system.label.Lower_Limit_Non_GSM_ME)*listT[i].number_of_sales__c;
                lowerGSM=integer.valueof(system.label.Lower_Limit_GSM)*listT[i].number_of_sales__c;
                if(listT[i].revenue_GSM__c<lowergsm)
                {
                  listT[i].revenue_GSM__c=lowergsm;
                }
                if(listT[i].revenue_non_GSM__c<lowernongsm)
                {
                    listT[i].revenue_non_GSM__c=lowernongsm;
                }
                if(listT[i].revenue_iot__c<loweriot)
                {
                    listT[i].revenue_iot__c=loweriot;
                }
                if(listT[i].revenue_voip__c<lowervoip)
                {
                    listT[i].revenue_voip__c=lowervoip;
                }
                if(listT[i].revenue_m_ads__c<lowermads)
                {
                    listT[i].revenue_m_ads__c=lowermads;
                }
            }
            update listT;
            list<Target__c> listT2=[SELECT id,number_of_sales__c,revenue_gsm__c,revenue_voip__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_iot__c FROM Target__c Where Month_target__c=:month1 and year_target__c=:year and type_segment__c!='red' ORDER BY Revenue_VOIP__c desc];
            decimal limitasi=Integer.valueof(system.label.lower_limit_voip)*listT2[1].number_of_sales__c+deficitvoip/3;
            if(listT2[1].revenue_voip__c>limitasi)
               { listT2[1].revenue_voip__c=listT2[1].revenue_voip__c-deficitvoip/3;
                listT2[0].revenue_voip__c=listT2[0].revenue_voip__c-(deficitvoip*2/3);
               }
               else {
                listT2[0].revenue_voip__c=listT2[0].revenue_voip__c-deficitvoip;
               }
               update listT2;
               list<Target__c> listT3=[SELECT id,number_of_sales__c,segment_classification__c,revenue_gsm__c,revenue_voip__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_iot__c FROM Target__c Where Month_target__c=:month1 and year_target__c=:year and type_segment__c!='red' ORDER BY Revenue_non_gsm__c desc];
               if(listT3[1].segment_classification__c=='LE')             
               limitasi=Integer.valueof(system.label.lower_limit_non_gsm)*listT3[1].number_of_sales__c+deficitnongsm/3;
               if(listT3[1].segment_classification__c=='ME')             
               limitasi=Integer.valueof(system.label.lower_limit_non_gsm_ME)*listT3[1].number_of_sales__c+deficitnongsm/3;
               
               if(listT3[1].revenue_non_gsm__c>limitasi)
                  { listT3[1].revenue_non_gsm__c=listT3[1].revenue_non_gsm__c-deficitnongsm/3;
                   listT3[0].revenue_non_gsm__c=listT3[0].revenue_non_gsm__c-(deficitnongsm*2/3);
                  }
                else {
                    listT3[0].revenue_non_gsm__c=listT3[0].revenue_non_gsm__c-deficitnongsm;
                }
               update listT3; 
               listT3=[SELECT id,number_of_sales__c,revenue_gsm__c,revenue_voip__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_iot__c FROM Target__c Where Month_target__c=:month1 and year_target__c=:year and type_segment__c!='red' ORDER BY Revenue_gsm__c desc];
               limitasi=Integer.valueof(system.label.lower_limit_gsm)*listT3[1].number_of_sales__c+deficitgsm/3;
               if(listT3[1].revenue_non_gsm__c>limitasi)
                  { listT3[1].revenue_gsm__c=listT3[1].revenue_gsm__c-deficitgsm/3;
                   listT3[0].revenue_gsm__c=listT3[0].revenue_gsm__c-(deficitgsm*2/3);
                  }
                else {
                    listT3[0].revenue_gsm__c=listT3[0].revenue_gsm__c-deficitgsm;
                }
               update listT3; 
               listT3=[SELECT id,number_of_sales__c,revenue_gsm__c,revenue_voip__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_iot__c FROM Target__c Where Month_target__c=:month1 and year_target__c=:year and type_segment__c!='red' ORDER BY Revenue_iot__c desc];
               limitasi=Integer.valueof(system.label.lower_limit_iot)*listT3[1].number_of_sales__c+deficitiot/5;
               if(listT3[1].revenue_iot__c>limitasi)
                  { listT3[1].revenue_iot__c=listT3[1].revenue_iot__c-deficitiot/3;
                   listT3[0].revenue_iot__c=listT3[0].revenue_iot__c-(deficitiot*2/3);
                  }
                else {
                    listT3[0].revenue_iot__c=listT3[0].revenue_iot__c-deficitiot;
                }
               update listT3; 
               listT3=[SELECT id,number_of_sales__c,revenue_gsm__c,revenue_voip__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_iot__c FROM Target__c Where Month_target__c=:month1 and year_target__c=:year and type_segment__c!='red' ORDER BY Revenue_m_ads__c desc];
               limitasi=Integer.valueof(system.label.lower_limit_m_ads)*listT3[1].number_of_sales__c+deficitmads/5;
               if(listT3[1].revenue_m_ads__c>limitasi)
                  { listT3[1].revenue_m_ads__c=listT3[1].revenue_m_ads__c-deficitmads/3;
                   listT3[0].revenue_m_ads__c=listT3[0].revenue_m_ads__c-(deficitmads*2/3);
                  }
                else {
                    listT3[0].revenue_m_ads__c=listT3[0].revenue_m_ads__c-deficitmads;
                }
               update listT3; 
               setquarter();
        }
        //balance the number with red number in each service
        public Static Void CekRed(String Month,Decimal Year)
        {
            Decimal TotalVOIP=1;
            Decimal RedVOIP=0;
            Decimal TotalIOT=1;
            Decimal RedIOT=0;
            Decimal TotalGSM=1;
            Decimal RedGSM=0;
            Decimal TotalNonGSM=1;
            Decimal RedNonGSM=0;
            Decimal TotalMads=1;
            Decimal RedMads=0;
            list<Target__c> listT=[SELECT id,revenue_iot__c,revenue_voip__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,type_segment__c FROM Target__c WHERE Month_Target__c=:Month AND Year_Target__c=:Year];
          
            for(Target__c T:listT)
            {
                if(T.type_segment__c!='Red')
                {
                   
                  
                        TotalVOIP=T.revenue_VOIP__c+totalVOIP;
                       
                        TotalGSM=T.revenue_GSM__c+totalGSM;
                  
                        TotalNonGSM=T.revenue_non_GSM__c+totalnonGSM;
                  
                        TotalIOT=T.revenue_iot__c+totaliot;
                 
                        TotalMads=T.revenue_m_ads__c+totalMads;
                }
                else {
                    RedVOIP=T.revenue_VOIP__c;
                    RedGSM=T.revenue_GSM__c;
                    RedNonGSM=T.revenue_non_GSM__c;
                    RedIOT=T.revenue_iot__c;
                    RedMads=T.revenue_m_ads__c;
                }
            }
            Decimal selisihVOIP=totalVOIP-RedVOIP;
            Decimal selisihNonGSM=TotalNonGSM-RedNonGSM;
            Decimal selisihGSM=TotalGSM-RedGSM;
            Decimal selisihIOT=TotalIOT-RedIOT;
           Decimal selisihMAds=TotalMads-RedMads;
           for(target__c T2:listT)
           {
                if(t2.type_segment__c!='Red')
                {
                  
                   
                    t2.revenue_voip__c=t2.revenue_voip__c-(selisihVOIP*(T2.revenue_voip__c/TotalVOIP));
                  
                    t2.revenue_GSM__c=t2.revenue_GSM__c-(selisihGSM*(T2.revenue_GSM__c/TotalGSM));
                   
                    t2.revenue_Non_GSM__c=t2.revenue_Non_GSM__c-(selisihNonGSM*(T2.revenue_Non_GSM__c/TotalNonGSM));
                  
                    t2.revenue_IOT__c=t2.revenue_IOT__c-(selisihIOT*(T2.revenue_IOT__c/TotalIOT));
                  
                    t2.revenue_M_Ads__c=t2.revenue_M_Ads__c-(selisihMAds*(T2.revenue_m_ads__c/TotalMads));

                }
           }
           update listT;

        }
       
      
        //update quarter after additional modified according to modified monthly target
        public static void setquarter()
        {
            String Quarter='';
            String Month1='';
            String Month2='';
            String Month3='';
            Integer Year=system.today().year();
            if(system.today().month()==3||System.today().month()==4)
            {
                Quarter='Quarter 2';
            Month1='April';
            Month2='May';
            Month3='June';
            }   
            if(system.today().month()==6||System.today().month()==7||system.today().month()==8)
            {
            Quarter='Quarter 3';
            Month1='July';
            Month2='August';
            Month3='September';
            }
            if(system.today().month()==9||system.today().month()==10)
            {Quarter='Quarter 4';
            Month1='October';
            Month2='November';
            Month3='December';
            }
            if(system.today().month()==12)
            {Quarter='Quarter 1';
            Month1='January';
            Month2='February';
            Month3='March';
            Year=year+1;
            }
            if(Quarter!='')
            {
            list<Target__c> QuarterT=[SELECT id,type_segment__c,revenue_iot__c,revenue_voip__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c FROM Target__c WHERE  Timeline__c=:Quarter];
            list<AggregateResult> Targetthree=[SELECT Type_Segment__c,SUM(Revenue_GSM__c) GSM,SUM(Revenue_non_gsm__c) NONGSM,SUM(Revenue_IOT__c) IOT,SUM(Revenue_M_Ads__c) MADS,SUM(Revenue_VOIP__c) VOIP FROM Target__c WHERE Timeline__c='Monthly Target' AND Year_Target__c=:year AND (Month_Target__c=:Month1 OR Month_Target__c=:Month2 OR Month_Target__c=:Month3) AND Type_Segment__c!='Red' GROUP BY Type_Segment__c];
            for(Integer I=0;I<QuarterT.size();I++)
            {
                for(Integer J=0;J<Targetthree.size();J++)
                {
                    if(QuarterT[i].type_segment__c==(String) Targetthree[j].get('Type_Segment__c'))
                    {
                        QuarterT[i].revenue_GSM__c=(Decimal) Targetthree[j].get('GSM');
                        QuarterT[i].revenue_non_GSM__c=(Decimal) Targetthree[j].get('NONGSM');
                        QuarterT[i].revenue_VOIP__c=(Decimal) Targetthree[j].get('VOIP');
                        QuarterT[i].revenue_IOT__c=(Decimal) Targetthree[j].get('IOT');
                        QuarterT[i].revenue_M_Ads__c=(Decimal) Targetthree[j].get('MADS');
                    }
                }
                
            }
            update QuarterT;
            
            }
        }
        //increase/decrease percentage of segment according to difference with proportion
        public static void checkproportion(String Quarter)
        {
            String Month1='';
            String Month2='';
            String Month3='';
            Integer year=system.today().year();
            if(Quarter=='1')
            {
                 Month1='January';
                 Month2='February';
                 Month3='March';
                 year=year+1;
            }
            if(Quarter=='2')
            {
                 Month1='April';
                 Month2='May';
                 Month3='June';
            }
            if(Quarter=='3')
            {
                 Month1='July';
                 Month2='August';
                 Month3='September';
            }
            if(Quarter=='4')
            {
                 Month1='October';
                 Month2='November';
                 Month3='December';
                 
            }
            String Segment='';
            Decimal Largest=0;
            Additional_target__c A=[select total_LE__c,current_percentage_1__c,current_percentage_2__c,current_percentage_3__c,current_percentage_4__c,current_percentage_5__c,percent_1__c,percent_2__c,percent_3__c,percent_4__c,percent_5__c from additional_target__c where createddate>=LAST_MONTH];
            if(A.current_percentage_1__c-A.percent_1__c>Largest)
            {
                largest=A.current_percentage_1__c-A.percent_1__c;
                Segment='Banking & Financial Services';
            }
            if(A.current_percentage_2__c-A.percent_2__c>largest)
            {
                largest=A.current_percentage_2__c-A.percent_2__c;
                Segment='Energy & ISP';
            }
            if(A.current_percentage_3__c-A.percent_3__c>Largest)
            {
                largest=A.current_percentage_3__c-A.percent_3__c;
                Segment='FMCG & Translog';
            }
            if(A.current_percentage_4__c-A.percent_4__c>Largest)
            {
                largest=A.current_percentage_4__c-A.percent_4__c;
                Segment='Government & Public Sector';
            }
            if(A.current_percentage_5__c-A.percent_5__c>Largest)
            {
                largest=A.current_percentage_5__c-A.percent_5__c;
                Segment='Media & E-Commerce';
            }
            if(segment!='' && largest>3)
            {
            fixproportion(Segment, Month1, year, A.total_le__c/120);  
            fixproportion(Segment, Month2, year, A.total_le__c/120); 
            fixproportion(Segment, Month3, year, A.total_le__c/120);
           
            }
            else if(segment!='' && largest>2)
            {
            fixproportion(Segment, Month1, year, A.total_le__c/150);  
            fixproportion(Segment, Month2, year, A.total_le__c/150); 
            fixproportion(Segment, Month3, year, A.total_le__c/150); 
          
            }
            Segment='';
            largest=0;
            if(A.percent_1__c-A.current_percentage_1__c>Largest)
            {
                largest=A.percent_1__c-A.current_percentage_1__c;
                Segment='Banking & Financial Services';
            }
            if(A.percent_2__c-A.current_percentage_2__c>Largest)
            {
                largest=A.percent_2__c-A.current_percentage_2__c;
                Segment='Energy & ISP';
            }
            if(A.percent_3__c-A.current_percentage_3__c>Largest)
            {
                largest=A.percent_3__c-A.current_percentage_3__c;
                Segment='FMCG & Translog';
            }
            if(A.percent_4__c-A.current_percentage_4__c>Largest)
            {
                largest=A.percent_4__c-A.current_percentage_4__c;
                Segment='Government & Public Sector';
            }
            if(A.percent_5__c-A.current_percentage_5__c>Largest)
            {
                largest=A.percent_5__c-A.current_percentage_5__c;
                Segment='Media & E-Commerce';
            }
            if(segment!='' && largest>3)
            {
            fixproportionup(Segment, Month1, year, A.total_le__c/120);  
            fixproportionup(Segment, Month2, year, A.total_le__c/120); 
            fixproportionup(Segment, Month3, year, A.total_le__c/120); 
          
            }
            else  if(segment!='' && largest>2)
            {
            fixproportionup(Segment, Month1, year, A.total_le__c/150);  
            fixproportionup(Segment, Month2, year, A.total_le__c/150); 
            fixproportionup(Segment, Month3, year, A.total_le__c/150); 
          
            }
            setquarter(); 
        }
        //decrease revenue segment so align with required percentage
        public static void fixproportion(String Segment,String Month,Integer year,Decimal Total)
        {
            Target__c T=[SELECT id,total_segment__c,number_of_sales__c,revenue_voip__c,type_segment__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_m_ads__c,total_segment_without_m_ads__c FROM Target__c WHERE Month_target__c=:month AND Year_target__c=:year AND Type_segment__c=:segment AND Segment_Classification__c='LE'];
            Target__c TBaseline=[SELECT id,total_segment__c,number_of_sales__c,type_segment__c,revenue_voip__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_m_ads__c,total_segment_without_m_ads__c FROM Target__c WHERE Timeline__c='Baseline/3' AND Type_segment__c=:segment AND Segment_Classification__c='LE' AND Createddate>=LAST_MONTH];
           
            Decimal GSMTransfer=0;
            Decimal NonGSMTransfer=0;
            Decimal VOIPTransfer=0;
            Decimal MAdsTransfer=0;
            Decimal IOTTransfer=0;
            if(T.revenue_gsm__c>3*Integer.valueof(system.label.lower_limit_gsm)*T.number_of_sales__c)
            {
           
            GSMtransfer=(Total*T.revenue_gsm__c/T.total_segment_without_m_ads__c);
            }
            if(T.revenue_non_gsm__c>3*Integer.valueof(system.label.lower_limit_non_gsm)*T.number_of_sales__c)
            {
               
            NonGSMtransfer=(Total*T.revenue_non_gsm__c/T.total_segment_without_m_ads__c);
            }
            if(T.revenue_voip__c>3*Integer.valueof(system.label.lower_limit_voip)*T.number_of_sales__c)
            {
            VOIPtransfer=(Total*T.revenue_VOIP__c/T.total_segment_without_m_ads__c);
            }
            if(T.revenue_iot__c>3*Integer.valueof(system.label.lower_limit_iot)*T.number_of_sales__c)
            {
            IOTTransfer=(Total*T.revenue_IOT__c/T.total_segment_without_m_ads__c);
            }
            if(T.revenue_m_ads__c>3*Integer.valueof(system.label.lower_limit_m_ads)*T.number_of_sales__c)
            {
            Madstransfer=(Total*T.revenue_M_Ads__c/T.total_segment__c);
            if(Madstransfer>10000000)
            Madstransfer=10000000;
            }
            list<target__c> nonT=[SELECT id,total_segment__c,number_of_sales__c,revenue_voip__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_m_ads__c FROM Target__c WHERE Month_target__c=:month AND Year_target__c=:year AND Type_segment__c!=:segment AND Type_segment__c!='Red' AND Segment_Classification__c='LE'];
            Decimal NonTIOT=1;
            Decimal NonTGSM=1;
            Decimal NonTNONGSM=1;
            Decimal NonTVOIP=1;
            Decimal NonTMads=1;
            for(target__c Ex:NonT)
            {
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_GSM)*2<Ex.revenue_gsm__c)
                {
                    NonTGSM=nonTGSM+ex.revenue_gsm__c;
                }
                else {
                    NOnTGSM=NONTGSM+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_GSM);
                }
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_VOIP)*2<Ex.revenue_VOIP__c)
                {
                    NonTVOIP=nonTVOIP+ex.revenue_VOIP__c;
                }
                else {
                    NonTVOIP=NonTVOIP+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_VOIP);
                    
                }
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_IOT)*2<Ex.revenue_IOT__c)
                {
                    NonTIOT=NonTIOT+ex.revenue_IOT__c;
                }
                else {
                    NonTIOT=NonTIOT+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_IOT);
                    
                }
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_NON_GSM)*2<Ex.revenue_NON_gsm__c)
                {
                    NonTNONGSM=NonTNONGSM+ex.revenue_Non_GSM__c;
                }
                else {
                    NonTNONGSM=NonTNONGSM+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_NON_GSM);
                    
                }
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_M_Ads)<Ex.revenue_M_Ads__c)
                {
                    NonTMads=NonTMads+ex.revenue_M_Ads__c;
                }
                else {
                    NonTMads=NonTMads+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_M_Ads);
                    
                }
            }
            Decimal Proporsi=0;
            for(Integer i=0;i<nonT.size();i++)
            {
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_GSM)*2<NonT[i].revenue_gsm__c)
                {
                    if(Tbaseline.revenue_gsm__c<T.revenue_gsm__c-GSMTransfer)
                    {
                    Proporsi=GSMTransfer*NonT[i].REVENUE_GSM__c/NonTGSM;
                    NonT[i].Revenue_GSM__c=NonT[i].revenue_gsm__c+Proporsi;
                    T.revenue_gsm__c=T.revenue_gsm__c-Proporsi;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_VOIP)*2<NonT[i].revenue_VOIP__c)
                {
                    if(Tbaseline.revenue_VOIP__c<T.revenue_VOIP__c-VOIPTransfer)
                    {
                    Proporsi=VOIPTransfer*NonT[i].REVENUE_VOIP__c/NonTVOIP;
                    NonT[i].Revenue_VOIP__c=NonT[i].revenue_VOIP__c+Proporsi;
                    T.revenue_VOIP__c=T.revenue_VOIP__c-Proporsi;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_IOT)*2<NonT[i].revenue_IOT__c)
                {
                    if(Tbaseline.revenue_IOT__c<T.revenue_IOT__c-IOTTransfer)
                    {
                    Proporsi=IOTTransfer*NonT[i].REVENUE_IOT__c/NonTIOT;
                    NonT[i].Revenue_IOT__c=NonT[i].revenue_IOT__c+Proporsi;
                    T.revenue_IOT__c=T.revenue_IOT__c-Proporsi;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_NON_GSM)*2<NonT[i].revenue_NON_gsm__c)
                {
                    if(Tbaseline.revenue_NON_GSM__c<T.revenue_NON_GSM__c-NONGSMTransfer)
                    {
                    Proporsi=NONGSMTransfer*NonT[i].REVENUE_NON_GSM__c/NonTNONGSM;
                    NonT[i].Revenue_NON_GSM__c=NonT[i].revenue_NON_gsm__c+Proporsi;
                    T.revenue_NON_gsm__c=T.revenue_NON_gsm__c-Proporsi;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_M_Ads)<NonT[i].revenue_M_Ads__c)
                {
                    if(Tbaseline.revenue_M_Ads__c<T.revenue_M_Ads__c-MadsTransfer)
                    {
                    Proporsi=Madstransfer*NonT[i].REVENUE_M_Ads__c/NonTMads;
                    NonT[i].Revenue_M_Ads__c=NonT[i].revenue_M_Ads__c+Proporsi;
                    T.revenue_M_Ads__c=T.revenue_M_Ads__c-Proporsi;
                    }
                }

            }
            update T;
            update NonT;
        }
        //increase revenue segment to align with percentage required
        public static void fixproportionup(String Segment,String Month,Integer year,Decimal Total)
        {
            Target__c T=[SELECT id,total_segment__c,number_of_sales__c,revenue_voip__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_m_ads__c FROM Target__c WHERE Month_target__c=:month AND Year_target__c=:year AND Type_segment__c=:segment AND Segment_Classification__c='LE'];
            Decimal NonTIOT=1;
            Decimal NonTGSM=1;
            Decimal NonTNONGSM=1;
            Decimal NonTVOIP=1;
            Decimal NonTMads=1;
            Decimal totalAll=0;
            list<target__c> nonT=[SELECT id,total_segment__c,number_of_sales__c,revenue_voip__c,type_segment__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_m_ads__c FROM Target__c WHERE Month_target__c=:month AND Year_target__c=:year AND Type_segment__c!=:segment AND Type_segment__c!='Red' AND Segment_Classification__c='LE' ORDER BY Type_Segment__c];
            list<target__c> nonTbaseline=[SELECT id,total_segment__c,number_of_sales__c,revenue_voip__c,type_segment__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_m_ads__c FROM Target__c WHERE Timeline__c='Baseline/3' AND Createddate>=LAST_MONTH AND Type_segment__c!=:segment AND Type_segment__c!='Red' AND Segment_Classification__c='LE' ORDER BY Type_Segment__c];
        
            for(target__c Ex:NonT)
            {
                TotalAll=Ex.Total_Segment__c+TotalAll;
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_GSM)*2<Ex.revenue_gsm__c)
                {
                    NonTGSM=nonTGSM+ex.revenue_gsm__c;
                }
                else {
                    NonTGSM=NonTGSM+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_GSM);
                    
                }
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_VOIP)*2<Ex.revenue_VOIP__c)
                {
                    NonTVOIP=nonTVOIP+ex.revenue_VOIP__c;
                }
                else {
                    NonTVOIP=NonTVOIP+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_VOIP);
                    
                }
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_IOT)*2<Ex.revenue_IOT__c)
                {
                    NonTIOT=nonTVOIP+ex.revenue_IOT__c;
                }
                else {
                    NonTIOT=NonTIOT+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_IOT);
                    
                }
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_NON_GSM)*2<Ex.revenue_NON_gsm__c)
                {
                    NonTNONGSM=NonTNONGSM+ex.revenue_Non_GSM__c;
                }
                else {
                    NonTNONGSM=NonTNONGSM+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_NON_GSM);
                    
                }
                if(Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_M_Ads)<Ex.revenue_M_Ads__c)
                {
                    NonTMads=NonTMads+ex.revenue_M_Ads__c;
                }
                else {
                    NonTMads=NonTMads+Ex.Number_of_sales__c*Integer.valueof(system.label.lower_limit_M_Ads);
                    
                }
            }
            Decimal TotalGSM=total*NonTGSM/totalAll;
            Decimal TotalMads=total*NonTMads/totalAll;
            Decimal TotalIOT=total*NonTiot/TotalAll;
            Decimal TotalVOIP=total*NonTVOIP/totalAll;
            Decimal TotalNONGSM=total*NonTNONGSM/TotalAll;
            Decimal Proporsi=0;
            Decimal BaselineGSM=0;
            Decimal BaselineVOIP=0;
            Decimal BaselineIOT=0;
            Decimal BaselineNONGSM=0;
            Decimal BaselineMAds=0;
            for(Integer i=0;i<nonT.size();i++)
            {
                for(Target__c B3:nonTbaseline)
                {
                    if(B3.type_segment__c==NonT[i].type_segment__c)
                    {
                        BaselineGSM=b3.revenue_gsm__c;
                        BaselineVOIP=b3.revenue_voip__c;
                        BaselineIOT=b3.revenue_iot__c;
                        BaselineNONGSM=b3.revenue_NON_GSM__c;
                        BaselineMAds=b3.revenue_M_Ads__c;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_GSM)*2<NonT[i].revenue_gsm__c)
                {
                    if(T.number_of_sales__c*2*Integer.valueof(system.label.lower_limit_GSM)<T.revenue_gsm__c && nonT[i].revenue_gsm__c-TotalGSM>BaselineGSM)
                    {
                   
                    Proporsi=TotalGSM*NonT[i].revenue_gsm__c/nontGSM;
                    NonT[i].Revenue_GSM__c=NonT[i].revenue_gsm__c-Proporsi;
                    T.revenue_gsm__c=T.revenue_gsm__c+Proporsi;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_VOIP)*2<NonT[i].revenue_VOIP__c )
                {
                    if(T.number_of_sales__c*2*Integer.valueof(system.label.lower_limit_VOIP)<T.revenue_VOIP__c && nonT[i].revenue_VOIP__c-TotalVOIP>BaselineVOIP)
                    {
                    Proporsi=TotalVOIP*NonT[i].revenue_VOIP__c/NonTVOIP;
                    NonT[i].Revenue_VOIP__c=NonT[i].revenue_VOIP__c-Proporsi;
                    T.revenue_VOIP__c=T.revenue_VOIP__c+Proporsi;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_IOT)*2<NonT[i].revenue_gsm__c)
                {
                    if(T.number_of_sales__c*2*Integer.valueof(system.label.lower_limit_IOT)<T.revenue_IOT__c && nonT[i].revenue_iot__c-TotalIOT>BaselineIOT)
                    {
                    Proporsi=TotalIOT*NonT[i].REVENUE_IOT__c/NonTIOT;
                    NonT[i].Revenue_IOT__c=NonT[i].revenue_IOT__c-Proporsi;
                    T.revenue_IOT__c=T.revenue_IOT__c+Proporsi;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_NON_GSM)*2<NonT[i].revenue_NON_gsm__c)
                {
                    if(T.number_of_sales__c*2*Integer.valueof(system.label.lower_limit_NON_GSM)<T.revenue_NON_GSM__c && NonT[i].revenue_non_gsm__c-TotalNONGSM>BaselineNONGSM)
                    {
                    Proporsi=TotalNONGSM*NonT[i].REVENUE_NON_GSM__c/NonTNONGSM;
                    NonT[i].Revenue_NON_GSM__c=NonT[i].revenue_NON_gsm__c-Proporsi;
                    T.revenue_NON_gsm__c=T.revenue_NON_gsm__c+Proporsi;
                    }
                }
                if(NonT[i].Number_of_sales__c*Integer.valueof(system.label.lower_limit_M_Ads)<NonT[i].revenue_M_Ads__c)
                {
                    if(T.number_of_sales__c*Integer.valueof(system.label.lower_limit_M_Ads)<T.revenue_M_Ads__c && NonT[i].revenue_M_Ads__c-TotalMads>BaselineMAds)
                    {
                    Proporsi=10000000;//TotalMads*NonT[i].REVENUE_M_Ads__c/NonTMads;
                    NonT[i].Revenue_M_Ads__c=NonT[i].revenue_M_Ads__c-Proporsi;
                    T.revenue_M_Ads__c=T.revenue_M_Ads__c+Proporsi;
                    }
                }

            }
            update T;
            update NonT;
        }
       //transfer revenue from LE Segment to ME segment or vice versa according to expected total ME & expected total LE
        public static void TransferMELE(String Quarter)
        {
            String Month1='';
            String Month2='';
            String Month3='';
            Integer year=system.today().year();
            Additional_target__c A=[SELECT total_le__c,expected_total_le__c,expected_total_me__c,total_me__c FROM Additional_Target__c WHERE CREATEDDATE>=LAST_MONTH];
            if(Quarter=='1')
            {
                 Month1='January';
                 Month2='February';
                 Month3='March';
                 year=year+1;
            }
            if(Quarter=='2')
            {
                 Month1='April';
                 Month2='May';
                 Month3='June';
            }
            if(Quarter=='3')
            {
                 Month1='July';
                 Month2='August';
                 Month3='September';
            }
            if(Quarter=='4')
            {
                 Month1='October';
                 Month2='November';
                 Month3='December';
            }
            Decimal Selisih=0;
         Decimal ExpectedTotal=A.expected_total_le__c+A.expected_total_me__c;
          Decimal currenttotal=A.total_le__c+A.total_me__c;
            Decimal ExpectedpersenLE=A.expected_total_le__c/expectedtotal*100;
            Decimal ExpectedpersenME=A.expected_total_me__c/expectedtotal*100;
            Decimal CurrentpersenLE=A.total_le__c/currenttotal*100;
            Decimal CurrentpersenME=A.total_me__c/currenttotal*100;
            Decimal AddLE=0;
            if(currentpersenLE<expectedpersenLE)
            {
                selisih=((expectedpersenLE-currentpersenLE)/100)*Currenttotal;
                Addle=1;
            }
            else {
                selisih=((currentpersenLE-expectedpersenLE)/100)*currenttotal;
            }
            
           
            list<Target__c> TargetQuarterLE=[SELECT id,number_of_sales__c,revenue_gsm__c,revenue_m_ads__c,type_segment__c,revenue_non_gsm__c,revenue_iot__c,revenue_voip__c,total_segment__c FROM Target__c WHERE timeline__c LIKE '%Quarter%' and segment_classification__c='LE' and createddate>=LAST_MONTH];
            list<Target__c> TargetQuarterME=[SELECT id,number_of_sales__c,revenue_gsm__c,revenue_m_ads__c,type_segment__c,revenue_non_gsm__c,revenue_iot__c,revenue_voip__c,total_segment__c FROM Target__c WHERE timeline__c LIKE '%Quarter%' and segment_classification__c='ME' and createddate>=LAST_MONTH];
           
            Decimal totalGSMLE=0;
            Decimal totalNONGSMLE=0;
            Decimal totalVOIPLE=0;
            Decimal totalIOTLE=0;
            Decimal TotalAllLE=0;
            Decimal totalGSMME=0;
            Decimal totalNONGSMME=0;
            Decimal totalVOIPME=0;
            Decimal totalIOTME=0;
            Decimal TotalAllME=0;
            for(Target__c TQLE:TargetQuarterLE)
            {
                if(TQLE.revenue_gsm__c>Integer.valueof(system.label.lower_limit_GSM)*3*TQLE.number_of_sales__c)
                {
                    totalGSMLE=totalGSMLE+TQLE.revenue_gsm__c;
                }
                if(TQLE.revenue_VOIP__c>Integer.valueof(system.label.lower_limit_VOIP)*3*TQLE.number_of_sales__c)
                {
                    totalVOIPLE=totalVOIPLE+TQLE.revenue_VOIP__c;
                }
                if(TQLE.revenue_IOT__c>Integer.valueof(system.label.lower_limit_IOT)*3*TQLE.number_of_sales__c)
                {
                    totalIOTLE=totalIOTLE+TQLE.revenue_IOT__c;
                }
                if(TQLE.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM)*3*TQLE.number_of_sales__c)
                {
                    totalNONGSMLE=totalNONGSMLE+TQLE.revenue_NON_GSM__c;
                }
            }
          
            TotalAllLE=totalNONGSMLE+totalGSMLE+totalVOIPLE+totalIOTLE;
           
            for(Target__c TQME:TargetQuarterME)
            {
                if(TQME.revenue_gsm__c>Integer.valueof(system.label.lower_limit_GSM)*3*TQME.number_of_sales__c)
                {
                    totalGSMME=totalGSMME+TQME.revenue_gsm__c;
                }
                if(TQME.revenue_VOIP__c>Integer.valueof(system.label.lower_limit_VOIP)*3*TQME.number_of_sales__c)
                {
                    totalVOIPME=totalVOIPME+TQME.revenue_VOIP__c;
                }
                if(TQME.revenue_IOT__c>Integer.valueof(system.label.lower_limit_IOT)*3*TQME.number_of_sales__c)
                {
                    totalIOTME=totalIOTME+TQME.revenue_IOT__c;
                }
                if(TQME.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM_ME)*3*TQME.number_of_sales__c)
                {
                    totalNONGSMME=totalNONGSMME+TQME.revenue_NON_GSM__c;
                }
            }
            TotalAllME=totalNONGSMME+totalVOIPME+totalIOTME+totalGSMME;
            if(AddLE==1)
            {
                Decimal AddLEGSM=totalGSMLE/TotalAllLE*Selisih;
                Decimal AddLEVOIP=totalVOIPLE/totalALlLE*selisih;
                Decimal AddLENONGSM=totalNONGSMLE/TotalAllLE*selisih;
                Decimal AddLEIOT=totalIOTLE/TotalAllLE*selisih;
                if(totalVOIPME/2<AddLEVOIP)
                {
                    ADDLEGSM=ADDLEVOIP+AddLEGSM;
                    AddLEVOIP=0;
                }
                if(totalIOTME/2<AddLEIOT)
                {
                    AddLEGSM=ADDLEIOT+AddLEGSM;
                    AddLEIOT=0;
                }
                if(totalNONGSMME/2<AddLENONGSM)
                {
                    AddLEGSM=AddLENONGSM+AddLEGSM;
                    AddLENONGSM=0;
                }
                if(totalGSMME/2<AddLEGSM)
                {
                   return;
                }
                ReduceTargetMELE(Month1, year, AddLEGSM/3, AddLENONGSM/3, AddLEVOIP/3, AddLEIOT/3, 'ME');
                ReduceTargetMELE(Month2, year, AddLEGSM/3, AddLENONGSM/3, AddLEVOIP/3, AddLEIOT/3, 'ME');
                ReduceTargetMELE(Month3, year, AddLEGSM/3, AddLENONGSM/3, AddLEVOIP/3, AddLEIOT/3, 'ME');
                AddTargetMELE(Month1, year, AddLEGSM/3, AddLENONGSM/3, AddLEVOIP/3, AddLEIOT/3, 'LE');
                AddTargetMELE(Month2, year, AddLEGSM/3, AddLENONGSM/3, AddLEVOIP/3, AddLEIOT/3, 'LE');
                AddTargetMELE(Month3, year, AddLEGSM/3, AddLENONGSM/3, AddLEVOIP/3, AddLEIOT/3, 'LE');
            }
            else {
                Decimal AddMEGSM=totalGSMME/TotalAllME*Selisih;
                Decimal AddMEVOIP=totalVOIPME/totalALlME*selisih;
                Decimal AddMENONGSM=totalNONGSMME/TotalAllME*selisih;
                Decimal AddMEIOT=totalIOTME/TotalAllME*selisih;
               if(totalVOIPLE/2<AddMEVOIP)
               {
                   addmeGSM=addmeVOIP+AddMEGSM;
                   AddMEVOIP=0;
               }
               if(totalIOTLE/2<AddMEIOT)
               {
                   AddMEGSM=addmeIOT+AddMEGSM;
                   AddMEIOT=0;
               }
               if(totalNONGSMLE/2<AddMENONGSM)
               {
                   AddMEGSM=AddMENONGSM+AddMEGSM;
                   AddMENONGSM=0;
               }
               if(totalGSMLE/2<AddMEGSM)
               {
                  return;
               }
               ReduceTargetMELE(Month1, year, AddMEGSM/3, AddMENONGSM/3, AddMEVOIP/3, AddMEIOT/3, 'LE');
               ReduceTargetMELE(Month2, year, AddMEGSM/3, AddMENONGSM/3, AddMEVOIP/3, AddMEIOT/3, 'LE');
               ReduceTargetMELE(Month3, year, AddMEGSM/3, AddMENONGSM/3, AddMEVOIP/3, AddMEIOT/3, 'LE');
               AddTargetMELE(Month1, year, AddMEGSM/3, AddMENONGSM/3, AddMEVOIP/3, AddMEIOT/3, 'ME');
               AddTargetMELE(Month2, year, AddMEGSM/3, AddMENONGSM/3, AddMEVOIP/3, AddMEIOT/3, 'ME');
               AddTargetMELE(Month3, year, AddMEGSM/3, AddMENONGSM/3, AddMEVOIP/3, AddMEIOT/3, 'ME');
            }
            setquarter();

        }
        //reduce from LE/ME
        public static void ReduceTargetMELE(String Month,integer year,Decimal GSM,Decimal NONGSM,Decimal VOIP,Decimal IOT,String Clas)
        {
            list<target__c> Targettoreduce=[Select id,type_segment__c,Number_of_sales__c,revenue_m_ads__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_voip__c FROM Target__c WHERE Month_target__c=:Month AND Year_target__c=:YEAR and segment_classification__c=:clas];
            list<target__c> Targetprevious=[Select id,type_segment__c,Number_of_sales__c,revenue_m_ads__c,revenue_gsm__c,revenue_non_gsm__c,revenue_iot__c,revenue_voip__c FROM Target__c WHERE timeline__c='Baseline/3' AND Createddate>last_month and segment_classification__c=:clas];
          
            Decimal TotalGSM=0;
            Decimal TotalNONGSM=0;
            Decimal TotalIOT=0;
            Decimal TotalVOIP=0;
            Decimal TotalMads=0;
            for(Target__c T:targettoreduce)
            {
                for(target__c P:targetprevious)
                {
                    if(P.type_segment__c==T.type_segment__c)
                    {
                if(T.revenue_gsm__c>Integer.valueof(system.label.lower_limit_GSM)*3*T.number_of_sales__c && T.revenue_gsm__c>P.revenue_gsm__c)
                {
                    totalGSM=totalGSM+T.revenue_gsm__c;
                }
                if(T.revenue_VOIP__c>Integer.valueof(system.label.lower_limit_VOIP)*3*T.number_of_sales__c && T.revenue_voip__c>P.revenue_voip__c)
                {
                    totalVOIP=totalVOIP+T.revenue_VOIP__c;
                }
                if(T.revenue_IOT__c>Integer.valueof(system.label.lower_limit_IOT)*3*T.number_of_sales__c && T.revenue_iot__c>P.revenue_iot__c)
                {
                    totalIOT=totalIOT+T.revenue_IOT__c;
                }
                if(clas=='LE')
                {
                if(T.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM)*3*T.number_of_sales__c && T.revenue_non_gsm__c>P.revenue_non_gsm__c)
                {
                    totalNONGSM=totalNONGSM+T.revenue_NON_GSM__c;
                }
                }
                if(clas=='ME')
                {
                if(T.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM_ME)*3*T.number_of_sales__c && T.revenue_non_gsm__c>P.revenue_non_gsm__c)
                {
                    totalNONGSM=totalNONGSM+T.revenue_NON_GSM__c;
                }
                }
                if(T.revenue_M_Ads__c>Integer.valueof(system.label.lower_limit_M_Ads)*T.number_of_sales__c && P.revenue_m_ads__c<T.revenue_m_ads__c)
                {
                    totalMads=totalMads+T.revenue_M_Ads__c;
                }
                }
            }

            }
            for(target__c T2:targettoreduce)
            {
                for(target__c P:targetprevious)
                {
                    if(P.type_segment__c==T2.type_segment__c)
                    {
                Decimal proporsi=0;
                if(T2.revenue_gsm__c>Integer.valueof(system.label.lower_limit_GSM)*3*T2.number_of_sales__c && T2.revenue_gsm__c>P.revenue_gsm__c)
                {
                    proporsi=GSM*T2.revenue_gsm__c/totalGSM;
                    T2.revenue_gsm__c=T2.revenue_gsm__c-proporsi;
                }
                if(T2.revenue_VOIP__c>Integer.valueof(system.label.lower_limit_VOIP)*3*T2.number_of_sales__c && T2.revenue_VOIP__c>P.revenue_VOIP__c)
                {
                    proporsi=VOIP*T2.revenue_VOIP__c/totalVOIP;
                    T2.revenue_VOIP__c=T2.revenue_VOIP__c-proporsi;
                   
                }
                if(T2.revenue_IOT__c>Integer.valueof(system.label.lower_limit_IOT)*3*T2.number_of_sales__c && T2.revenue_IOT__c>P.revenue_IOT__c)
                {
                    proporsi=IOT*T2.revenue_IOT__c/totalIOT;
                    T2.revenue_IOT__c=T2.revenue_IOT__c-proporsi;
                   
                }
               if(Clas=='LE') 
               {
                if(T2.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM)*3*T2.number_of_sales__c && T2.revenue_NON_GSM__c>P.revenue_NON_gsm__c)
                {
                    proporsi=NONGSM*T2.revenue_non_gsm__c/totalNONGSM;
                    T2.revenue_non_gsm__c=T2.revenue_non_gsm__c-proporsi;
                   
                }
            }
            if(Clas=='ME') 
            {
             if(T2.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM_ME)*3*T2.number_of_sales__c && T2.revenue_NON_GSM__c>P.revenue_NON_gsm__c)
             {
                 proporsi=NONGSM*T2.revenue_non_gsm__c/totalNONGSM;
                 T2.revenue_non_gsm__c=T2.revenue_non_gsm__c-proporsi;
                
             }
         }
                if(T2.revenue_M_Ads__c>Integer.valueof(system.label.lower_limit_M_Ads)*3*T2.number_of_sales__c && T2.revenue_M_Ads__c>P.revenue_M_Ads__c)
                {
                    proporsi=10000000*T2.revenue_M_Ads__c/totalMads;
                    T2.revenue_M_Ads__c=T2.revenue_M_Ads__c-proporsi;
                   
                }
            }
            }
            }
            update Targettoreduce;

        }
        //add from ME/LE
        public static void AddTargetMELE(String Month,integer year,Decimal GSM,Decimal NONGSM,Decimal VOIP,Decimal IOT,String Clas)
        {
            list<target__c> TargettoAdd=[Select id,Number_of_sales__c,revenue_gsm__c,revenue_m_ads__c,revenue_non_gsm__c,revenue_iot__c,revenue_voip__c FROM Target__c WHERE Month_target__c=:Month AND Year_target__c=:YEAR and segment_classification__c=:clas];
            Decimal TotalGSM=0;
            Decimal TotalNONGSM=0;
            Decimal TotalIOT=0;
            Decimal TotalVOIP=0;
            Decimal TotalMads=0;
            for(Target__c T:targettoAdd)
            {
                if(T.revenue_gsm__c>Integer.valueof(system.label.lower_limit_GSM)*T.number_of_sales__c)
                {
                    totalGSM=totalGSM+T.revenue_gsm__c;
                }
                if(T.revenue_VOIP__c>Integer.valueof(system.label.lower_limit_VOIP)*T.number_of_sales__c)
                {
                    totalVOIP=totalVOIP+T.revenue_VOIP__c;
                }
                if(T.revenue_IOT__c>Integer.valueof(system.label.lower_limit_IOT)*T.number_of_sales__c)
                {
                    totalIOT=totalIOT+T.revenue_IOT__c;
                }
                if(Clas=='LE') 
                {
                if(T.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM)*T.number_of_sales__c)
                {
                    totalNONGSM=totalNONGSM+T.revenue_NON_GSM__c;
                }
                }
                if(Clas=='ME') 
                {
                if(T.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM_ME)*T.number_of_sales__c)
                {
                    totalNONGSM=totalNONGSM+T.revenue_NON_GSM__c;
                }
                }
                if(T.revenue_M_Ads__c>Integer.valueof(system.label.lower_limit_M_Ads)*T.number_of_sales__c)
                {
                    totalMads=totalMads+T.revenue_M_Ads__c;
                }

            }
            for(target__c T2:targettoAdd)
            {
                decimal proporsi=0;
                if(T2.revenue_gsm__c>Integer.valueof(system.label.lower_limit_GSM)*T2.number_of_sales__c)
                {
                    proporsi=GSM*T2.revenue_gsm__c/totalGSM;
                    T2.revenue_gsm__c=T2.revenue_gsm__c+proporsi;
                }
                if(T2.revenue_VOIP__c>Integer.valueof(system.label.lower_limit_VOIP)*T2.number_of_sales__c)
                {
                    proporsi=VOIP*T2.revenue_VOIP__c/totalVOIP;
                    T2.revenue_VOIP__c=T2.revenue_VOIP__c+proporsi;
                   
                }
                if(T2.revenue_IOT__c>Integer.valueof(system.label.lower_limit_IOT)*T2.number_of_sales__c)
                {
                    proporsi=IOT*T2.revenue_IOT__c/totalIOT;
                    T2.revenue_IOT__c=T2.revenue_IOT__c+proporsi;
                   
                }
                if(Clas=='LE') 
                {
                if(T2.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM)*T2.number_of_sales__c)
                {
                    proporsi=NONGSM*T2.revenue_non_gsm__c/totalNONGSM;
                    T2.revenue_non_gsm__c=T2.revenue_non_gsm__c+proporsi;
                   
                }
                }
                if(Clas=='ME') 
                {
                if(T2.revenue_NON_GSM__c>Integer.valueof(system.label.lower_limit_NON_GSM_ME)*T2.number_of_sales__c)
                {
                    proporsi=NONGSM*T2.revenue_non_gsm__c/totalNONGSM;
                    T2.revenue_non_gsm__c=T2.revenue_non_gsm__c+proporsi;
                   
                }
                }
                if(T2.revenue_M_Ads__c>Integer.valueof(system.label.lower_limit_M_Ads)*T2.number_of_sales__c)
                {
                    proporsi=10000000*T2.revenue_M_Ads__c/TotalMads;
                    T2.revenue_M_Ads__c=T2.revenue_M_Ads__c+proporsi;
                   
                }
            }
            update TargettoAdd;

        }
    
}