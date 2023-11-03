public with sharing class CalculateTargetController {
    public String Months = '';
    public String Year{get;set;}
    public String TargetSegment='';
    public String Textbox{get;set;}
    public String visibleall{get;set;}  
    public String displaysegment{get;set;}  
    public String displaysales{get;set;}
    public CalculateTargetController() {
      
         
    }
    //set months dropdown list
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('January','January'));
        options.add(new SelectOption('February','February'));
        options.add(new SelectOption('March','March'));
        options.add(new SelectOption('April','April'));
        options.add(new SelectOption('May','May'));
        options.add(new SelectOption('June','June'));
        options.add(new SelectOption('July','July'));
        options.add(new SelectOption('August','August'));
        options.add(new SelectOption('September','September'));
        options.add(new SelectOption('October','October'));
        options.add(new SelectOption('November','November'));
        options.add(new SelectOption('December','December'));
        return options;
    }
    //set segment dropdown list
    public List<SelectOption> getItemSegment() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Banking & Financial Services','Banking & Financial Services'));
        options.add(new SelectOption('Energy & ISP','Energy & ISP'));
        options.add(new SelectOption('FMCG & Translog','FMCG & Translog'));
        options.add(new SelectOption('Government & Public Sector','Government & Public Sector'));
        options.add(new SelectOption('Media & E-Commerce','Media & E-Commerce'));
        options.add(new SelectOption('Indirect Sales','Indirect Sales'));
        options.add(new SelectOption('Direct Sales','Direct Sales'));
       
        return options;
    }
    public String gettargetsegment()
    {
        return TargetSegment;
    }
    public String getMonths() {
        return Months;
    }
    public void settargetsegment(String TargetSegment) {
        this.TargetSegment=TargetSegment;
    }
 public void setMonths(String Months) {
        this.Months=Months;
    }
    //additional calculate button
    public void AdditionalCreate()
    {
       
        Additional_Target.AddTotal();
            visibleall='';
        Textbox='Calculate Additional Done';  
        displaysegment='';
      
        refresh();

    }
    public Pagereference refresh()
    {
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
    }
    //additional sales target button
    public void AdditionalSalesCreate()
    {
        Set_Sales_Target.AdditionalSalesTarget('Banking & Financial Services');
        Set_Sales_Target.AdditionalSalesTarget('Energy & ISP');
        Set_Sales_Target.AdditionalSalesTarget('FMCG & Translog');
        Set_Sales_Target.AdditionalSalesTarget('Media & E-Commerce');
        Set_Sales_Target.AdditionalSalesTarget('Government & Public Sector');
        Set_Sales_Target.AdditionalSalesTarget('Indirect Sales');
        Set_Sales_Target.AdditionalSalesTarget('Direct Sales');
        textbox='Additional Sales Target Set,please check report';
        displaysales='';
        refresh();
    }
    //modify additional button
    public void AdditionalModify()
    {
        list<Additional_Target__c> listA=[select id from Additional_target__c WHERE Createddate>=last_MONTH];
        if(listA.size()>0)
        {
        if(system.today().month()==3||system.today().month()==4)
        Additional_Target.ModifyAdditional('2');
        if(system.today().month()==6||system.today().month()==7||system.today().month()==8)
        Additional_Target.ModifyAdditional('3');
        if(system.today().month()==9||system.today().month()==10)
        Additional_Target.ModifyAdditional('4');
        if(system.today().month()==12)
        Additional_Target.ModifyAdditional('1');
        }
        Textbox='Additional Modify Done,Please Click Calculate Additional';
        displaysegment='Display:none';
        refresh();
    
    }
    //create sales quarter button
   public void Quarter()
    {
        gettargetsegment();
        Integer M=system.today().month();
        target mytarget=new target();
        list<Target_Per_Sales__c> TPS=[SELECT id from target_per_sales__c WHERE Target_timeline__c LIKE '%Quarter%' AND Segment__c=:TargetSegment AND Createddate>=LAST_MONTH];
        if(TPS.size()==0)
        {
        gettargetsegment();
        if(M==3||M==4)
            mytarget.CalculateAll('June', system.today().year(),TargetSegment);
            if(M==6||M==7||M==8)
            mytarget.CalculateAll('September', system.today().year(),TargetSegment);
            if(M==9)
            mytarget.CalculateAll('December', system.today().year(),TargetSegment);
            if(M==3)
            mytarget.CalculateAll('March', system.today().year()+1,TargetSegment);
            Textbox='Sales Target Quarter Created, Set Additional Sales Target';
            displaysales='Display:none';
        }
        else {
            Textbox='Sales Target for this quarter already created';
        }
        refresh();
    }
    //transfer ME LE button
    public void transferMELE()
    {
        if(system.today().month()==3||system.today().month()==4)
        Additional_Target.TransferMELE('2');
        if(system.today().month()==6||system.today().month()==7||system.today().month()==8)
        Additional_Target.TransferMELE('3');
        if(system.today().month()==9)
        Additional_Target.TransferMELE('4');
        if(system.today().month()==12)
        Additional_Target.TransferMELE('1');
        displaysegment='Display:none';
        refresh();
    }
    //update sales quarter button
    public void updateQuarter()
    {
        Integer M=system.today().month();
        target mytarget=new target();
        if(M==3||M==4)
            mytarget.updateQuarter('Quarter 2');
            if(M==6||M==7||M==8)
            mytarget.updateQuarter('Quarter 3');
            if(M==9)
            mytarget.updateQuarter('Quarter 4');
            if(M==3)
            mytarget.updateQuarter('Quarter 1');
            textbox='After Update Quarter Set Additional Sales Target';
            
            refresh();
    }
    //fix deficit button (add month and year variable)
    public void fixdeficit()
    {
        getMonths();
        Additional_Target.fixdeficit(months, Integer.valueof(Year));
        displaysegment='Display:none';
        Textbox='Fix Deficit Done,,Please Click Calculate Additional';
        refresh();
    }
    public void checkproportion()
    {
        list<Additional_Target__c> listA=[select id from Additional_target__c WHERE Createddate>=last_MONTH];
        if(listA.size()>0)
        {
        if((system.today().month()==3||system.today().month()==4) && !Test.isRunningTest())
        Additional_Target.checkproportion('2');
        if((system.today().month()==6||system.today().month()==7||system.today().month()==8) && !Test.isRunningTest())
        Additional_Target.checkproportion('3');
        if((system.today().month()==9||system.today().month()==10) && !Test.isRunningTest())
        Additional_Target.checkproportion('4');
        if(system.today().month()==12 && !Test.isRunningTest())
        Additional_Target.checkproportion('1');
        }
        TextBox='Check Proportion Done,Please Click Calculate Additional';
        displaysegment='Display:none';
        refresh();
    }
    //set sales target(initial)
    public void setsalestarget()
    {
        getmonths();
       gettargetsegment();
        
         
            String Previous='';
            if(Months=='January'||Months=='April'||Months=='July'||Months=='October')
            {
                Previous='Baseline/3';
            }
            if(Months=='February')
                Previous='January';
            if(Months=='March')
                Previous='February';
            if(Months=='May')
                Previous='April';
            if(Months=='June')
                Previous='May';
            if(Months=='August')
                Previous='July';
            if(Months=='September')
                Previous='August';
            if(Months=='November')
                Previous='October';
            if(Months=='December')
                Previous='November';

                string errAccId = 'Please Enter Number';
                AuraHandledException ex = new AuraHandledException(errAccId);
                
     try{        
           if(Integer.valueof(Year)<2020)
       //    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter relevant year'));
       {
           erraccid='Please Enter Relevant Year';
       ex.setMessage(errAccId);
       throw ex;
       }
        
    }
    catch(exception e)
    {
        ex.setMessage(errAccId);
        throw ex;
 //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter numer'));
    }
       Set_Sales_Target.FillSalesTarget(Months, Integer.valueof(Year), '','Banking & Financial Services');
       Set_Sales_Target.FillSalesTarget(Months, Integer.valueof(Year), '','Energy & ISP');
       Set_Sales_Target.FillSalesTarget(Months, Integer.valueof(Year), '','FMCG & Translog');
       Set_Sales_Target.FillSalesTarget(Months, Integer.valueof(Year), '','Government & Public Sector');
       Set_Sales_Target.FillSalesTarget(Months, Integer.valueof(Year), '','Media & E-Commerce');
       Set_Sales_Target.FillSalesTarget(Months, Integer.valueof(Year), '','Indirect Sales');
       Set_Sales_Target.FillSalesTarget(Months, Integer.valueof(Year), '','Direct Sales');
       Set_Sales_Target.calculateGSM(Months, Integer.valueof(Year), Previous);
       textbox='Sales Target Fill Done';
       refresh();
    }
    //fix total, set additional according to grades
    public void fixtotal()
    {
 
        getMonths();
        Set_Sales_Target.fixtotaltargetSales('Banking & Financial Services', Months, Integer.valueof(Year));
        Set_Sales_Target.fixtotaltargetSales('Energy & ISP', Months, Integer.valueof(Year));
        Set_Sales_Target.fixtotaltargetSales('FMCG & Translog', Months, Integer.valueof(Year));
        Set_Sales_Target.fixtotaltargetSales('Government & Public Sector', Months, Integer.valueof(Year));
        Set_Sales_Target.fixtotaltargetSales('Media & E-Commerce', Months, Integer.valueof(Year));
        Set_Sales_Target.fixtotaltargetSales('Indirect Sales', Months, Integer.valueof(Year));
        Set_Sales_Target.fixtotaltargetSales('Direct Sales', Months, Integer.valueof(Year));
        textbox='Sales Target Fix Total Done';
        refresh();
    }
    //fix sales additional according to grades if the additional is too low/high
    public void checkbalancesalestarget()
    {
        gettargetsegment();
        if((system.today().month()==3||system.today().month()==4) && !test.isRunningTest())
        Set_Sales_Target.CheckBalanceSalesTarget(TargetSegment, 'Quarter 2');
        if((system.today().month()==6||system.today().month()==7||system.today().month()==8) && !test.isRunningTest())
        Set_Sales_Target.CheckBalanceSalesTarget(TargetSegment, 'Quarter 3');
        if((system.today().month()==9||system.today().month()==10) && !test.isRunningTest())
        Set_Sales_Target.CheckBalanceSalesTarget(TargetSegment, 'Quarter 4');
        if(system.today().month()==12 && !test.isRunningTest())
        Set_Sales_Target.CheckBalanceSalesTarget(TargetSegment, 'Quarter 1');
        textbox='Balance Set, please update sales quarter and set additional sales target';
        displaysales='Display:none';
        refresh();
    }
        
}