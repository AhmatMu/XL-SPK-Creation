public class SalesRacingReportController {
    ApexPages.StandardController con;

    public List<SelectOption> srvGrName {get;set;}
    public List<SelectOption> srvService {get;set;}
    public List<SelectOption> srvLinkSTName {get;set;}
    public List<SelectOption> srvstageName {get;set;}
    public List<SelectOption> srvContracTicketStatusName {get;set;}
    public string productNameAutocompleted  {get;set;}
    
    public List<SelectOption> dataSourceOptions{get;set;}
    public List<SelectOption> productNameSearchOption{get;set;}
    public List<selectoption> productNameSelectedOption{get;set;}

    public string dataSourceSelectedValue {get;set;}
    
    public List<AM_top_List__c> amTopList {get;set;}
    public Boolean alreadyContractTicket{get;set;}
    public Sales_racing__c SalesRcObj {get;set;}
    
    public string[] revGroupServiceSelected {get;set;}
    public string[] revCategoryNameSelected {get;set;}
    public string[] serviceSelected {get;set;}
    public string[] groupPricePlanSelected {get;set;}
    public string[] linkServiceTypeSelected {get;set;}
    public string[] pipelineGroupServiceSelected {get;set;}
    public string[] productNameSelected {get;set;}
    public string[] productNameSearchResultSelected{get;set;}
    public string[] stageNameSelected {get;set;}
    public String[] contractTicketStatusSelected {get;set;}  
    public String[] dataSoureNameSelected {get;set;}
    public string productNameSearchValue{get;set;}

    public boolean displayGroupService {get;set;}  
    public boolean displayDataSource {get;set;}  
    public boolean displayRevenueCategory {get;set;}
    public boolean displayService {get;set;}
    public boolean displayLinkType {get;set;}
    public boolean displayGroupPricePlan {get;set;}
    public boolean displayGroupservice1 {get;set;}
    public boolean displayProductName {get;set;}
    public boolean displayStageName {get;set;}
    public boolean displayContractTicketStatusName {get;set;}
    public boolean displayDataSourceName {get;set;}
    public boolean displayProductSearch {get;set;}
    public Boolean displayproductNameSearchResult {get;set;}
    public Boolean displayAddButtonproductNameResult {get;set;}
    public Boolean displayallProductCheckBox {get;set;}
    list<string> productNameList {get;set;}

    
    public boolean  refreshPage {get;set;}
    
    public SalesRacingController srcController {get;set;}
    
    public SalesRacingReportController() {
        system.debug ('=== in SalesRacingReportController constructor ==');
        
    }
    
    
    public SalesRacingReportController(ApexPages.StandardController controller) {
        system.debug('SalesRacingReportController masuk disini ==== ');
        
      //  alreadyContractTicket = false;
        productNameList = new list <string>(); 
        productNameSelectedOption = new List <SelectOption>();
        
      //  hideStageNameSelectList();

       
      try{
        this.displayContractTicketStatusName = false;
            if(!test.isRunningTest()){
                controller.addFields(New List<String> {'id','data_source__c','Period_Start_Date__c','Period_End_Date__c','Racing_ID__c', 'Group_services__c', 'Revenue_Category__c', 'Revenue_Category__c', 'Sales_Racing_Report_Path__c', 'stages__C', 'service__c','Group_Price_Plans__c', 'Link_service_type__c', 'product_name__c', 'Already_Contract_Ticket__c', 'Contract_Ticket_Status__c', 'all_product__c'});
            }
            
            //pageInfoObj = new SalesRacingReportControllers();
            refreshPage = false;
            String srvSalesRace = '';
            con = controller;
            SalesRcObj = (sales_racing__c) con.getRecord();
            system.debug('check data masuk sales racing ? : ==' + SalesRcObj);
            
            srcController = new SalesRacingController(SalesRcObj);


            
            if(SalesRcObj.Data_Source__c == 'Revenue'){
                this.displayDataSource = true;
                this.displayGroupService = true;
                this.displayRevenueCategory = true;
                this.displayService = false;
                this.displayLinkType = false;
                this.displayGroupPricePlan = false;
                this.displayGroupservice1 = false;
                this.displayProductName =false;
                this.displayStageName = false;
                this.displayContractTicketStatusName = false;
                
                /*
                    List<AggregateResult> srvListgrName = [select group_service__r.name grName 
                    from sales_revenue__c
                    where type__c = 'actual revenue' and period_date__c >= :SalesRcObj.Period_Start_Date__c and period_date__c <= :SalesRcObj.Period_End_Date__c
                    group by group_service__r.name
                    order by group_service__r.name];
                    srvGrName = new List<SelectOption>();
                    for(AggregateResult srvObjgrName : srvListgrName){

                    String grName = '';
                    grName = (String) srvObjgrName.get('grName');

                    if(grName != null){

                    srvGrName.add(new SelectOption(grName, grName));
                    system.debug('srvGrName' + srvGrName );
                    }

                    }     
                    */
            }
            else if(SalesrcObj.Data_Source__c == 'subscribe'){
                
                this.displayDataSource = true;
                this.displayGroupService = false;            
                this.displayRevenueCategory = false;
                this.displayService = true;
                this.displayLinkType = false;
                this.displayGroupPricePlan = true;
                this.displayGroupservice1 = false;
                this.displayProductName =false;
                this.displayStageName =false;
                this.displayContractTicketStatusName = false;
                    /* 
                    List<AggregateResult> srvListserviceName = [select Service__c from sales_revenue__c
                                                                where (type__c = 'Subscribe Churn' or type__c = 'Subscribe gross add') and period_date__c >= :SalesRcObj.Period_Start_Date__c and period_date__c <= :SalesRcObj.Period_End_Date__c
                                                                group by Service__c
                                                                order by Service__c];
                    srvService = new List<SelectOption>();
                    for(AggregateResult srvObjServiceName : srvListserviceName){
                        
                        String ServiceName = '';
                        ServiceName = (String) srvObjServiceName.get('Service__c');
                        
                        if(ServiceName != null){
                            
                            srvService.add(new SelectOption(ServiceName, ServiceName));
                            
                            
                        }
                    }
                */                
            }
            else if(SalesrcObj.Data_Source__c == 'Link'){
                
                this.displayDataSource = true;
                this.displayGroupService = false;            
                this.displayRevenueCategory = false;
                this.displayService = false;
                this.displayLinkType = true;
                this.displayGroupPricePlan = false;
                this.displayGroupservice1 = false;
                this.displayProductName =false;
                this.displayStageName =false;
                this.displayContractTicketStatusName = false;
                    /*                
                    List<AggregateResult> srvListLinkSTName = [select Link_Service_Type__c 
                                                            from sales_revenue__c
                                                            where (type__c = 'Link Churn' or type__c = 'Link gross add') and period_date__c >= :SalesRcObj.Period_Start_Date__c and period_date__c <= :SalesRcObj.Period_End_Date__c
                                                            group by Link_Service_Type__c
                                                            order by Link_Service_Type__c];
                    srvLinkSTName = new List<SelectOption>();
                    for(AggregateResult srvObjLinkSTName : srvListLinkSTName){
                        
                        String LSTName = '';
                        LSTName = (String) srvObjLinkSTName.get('Link_Service_Type__c');
                        system.debug('logLevel data Link_Service_Type__c apa saja === **' + LSTName);
                        if(LSTName != null){
                            
                            srvLinkSTName.add(new SelectOption(LSTName, LSTName));
                            
                            
                        }
                    }
                    system.debug('alreadyContractTicket == :' + alreadyContractTicket);

                    */
            }
            else if(SalesrcObj.Data_Source__c == 'pipeline' && SalesrcObj.all_product__c == true){
                
                system.System.debug('masuk di pipeline biasa');
                
                
                this.displayDataSource = true;
                this.displayGroupService = false;
                this.displayRevenueCategory = false;
                this.displayService = false;
                this.displayLinkType = false;
                this.displayGroupPricePlan = false;
                this.displayGroupservice1 = true;
                this.displayProductName =true;
                this.displayStageName = true;
                
                
                /*
                            List<AggregateResult> srvListStageName = [select Opportunity_Product_Rel__r.opportunity.StageName stageName 
                                                                    from sales_revenue__c  where
                                                                    period_date__c <= :SalesRcObj.Period_End_Date__c 
                                                                    and period_date__c >= :SalesRcObj.Period_start_Date__c 
                                                                    group by Opportunity_Product_Rel__r.opportunity.StageName 
                                                                    order by Opportunity_Product_Rel__r.opportunity.StageName];
                            
                            srvStageName = new List<SelectOption>();
                            System.debug('srvListStageName !! '+ srvListStageName );
                            for(AggregateResult srvObjStageName : srvListStageName){
                                
                                String stageNames = '';
                                stageNames = (String) srvObjStageName.get('stageName');
                                system.debug('stageNames **' + stageNames);
                                if(stageNames != null){
                                    
                                    srvStageName.add(new SelectOption(stageNames, stageNames));
                                    
                                }
                            }*/                           
            }
            else if(SalesrcObj.Data_Source__c == 'pipeline' && SalesrcObj.all_product__c == false){
                
                system.debug('masuk di sini contract tiket true');
                
                this.displayDataSource = true;
                this.displayGroupService = false;
                this.displayRevenueCategory = false;
                this.displayService = false;
                this.displayLinkType = false;
                this.displayGroupPricePlan = false;
                this.displayGroupservice1 = true;
                this.displayProductName = true;
                this.displayStageName = true;
                this.displayContractTicketStatusName = false;
                this.displayDataSourceName = true;
                this.displayProductSearch = true;
                this.displayproductNameSearchResult = true;
                this.displayAddButtonproductNameResult = true;
                    /*                
                        List<AggregateResult> srvListStageName = [select Opportunity_Product_Rel__r.opportunity.StageName stageName 
                                                                from sales_revenue__c  where
                                                                period_date__c <= :SalesRcObj.Period_End_Date__c 
                                                                and period_date__c >= :SalesRcObj.Period_start_Date__c
                                                                and   Opportunity_Product_Rel__r.opportunity.Contract_Ticket__c !=null
                                                                group by Opportunity_Product_Rel__r.opportunity.StageName 
                                                                order by Opportunity_Product_Rel__r.opportunity.StageName];
                        
                        srvStageName = new List<SelectOption>();
                        System.debug('srvListStageName !! '+ srvListStageName );
                        for(AggregateResult srvObjStageName : srvListStageName){
                            
                            String stageNames = '';
                            stageNames = (String) srvObjStageName.get('stageName');
                            system.debug('stageNames **' + stageNames);
                            if(stageNames != null){
                                
                                srvStageName.add(new SelectOption(stageNames, stageNames));
                                
                            }
                        }    
              */
            }
            
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on SalesRacingReportController constructor' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
        }
        
    }
 
    Public Pagereference tutup(){
        
        refreshPage = true;
        
        return null;
    }
    
    public list<SelectOption> getActualGroupServiceName() {
        system.debug('=== masuk method actualGroupServiceName ===');
        
        List<SelectOption> srvGrName = new List <SelectOption>();
        List<AggregateResult> srvListgrName = new List<AggregateResult>();
        
        try{ 
            if(dataSourceSelectedValue == 'Transaction Data'){

                List<AggregateResult> srvTransactionDataListgrName = [select group_service__r.name Name 
                                                        from sales_revenue__c
                                                        where type__c = 'actual revenue' and period_date__c >= :SalesRcObj.Period_Start_Date__c and period_date__c <= :SalesRcObj.Period_End_Date__c
                                                        group by group_service__r.name
                                                        order by group_service__r.name];
                

                srvListgrName = srvTransactionDataListgrName ;

                system.debug('srvListgrName === : ' + srvListgrName);
                system.debug('srvTransactionDataListgrName == :'+ srvTransactionDataListgrName);
            }
            
           else if(dataSourceSelectedValue == 'Master Data'){
             
                List<AggregateResult> srvFromMasterDataListgrName = [select name Name
                                                                        from group_service__c
                                                                        group by name
                                                                        order by name
                                                                       ];
                srvListgrName = srvFromMasterDataListgrName;
            }

            system.debug('=== srvListgrName :' + srvListgrName );

           // srvGrName = new List<SelectOption>();
            system.debug('grpServiceName === :' + srvGrName);

                for(AggregateResult srvObjgrName : srvListgrName){
                    
                    String grpServiceName = '';
                    grpServiceName = (String) srvObjgrName.get('Name');
                    
                    if(grpServiceName != null){
                        
                        srvGrName.add(new SelectOption(grpServiceName, grpServiceName));
                        system.debug('srvGrName ===' + srvGrName );
                        
                    }
                }
            }
            catch(Exception e){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on getProductName method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
                    
                    
                } 
                return srvGrName;
            }
        
    
    public list<SelectOption> getContractTicketStatusName(){
        
        List<SelectOption> contractTicketStatusNameOption = new List <SelectOption>();
        
        try{
            
            if(dataSourceSelectedValue == 'Transaction Data'){
                
                if(contractTicketStatusSelected != null || test.isRunningTest()){
                    system.debug('== stageNameSelected : ' + stageNameSelected);
                    
                    List<AggregateResult> srvListTransactionDataContractTicketStatusName = 
                        [select TicketStatus__c ticketStatusName from Contract_Ticket__c 
                         where opportunity__r.stagename in :stageNameSelected
                         group by TicketStatus__c
                         order by TicketStatus__c limit 5];
                    
                    system.debug('srvListTransactionDataContractTicketStatusName == :' + srvListTransactionDataContractTicketStatusName);
                    
                    contractTicketStatusNameOption = new List <SelectOption>();

                for (AggregateResult srvListContractTicketStatusNameObj : srvListTransactionDataContractTicketStatusName) {
                    
                    String ContractTicketStatusName = '';
                    ContractTicketStatusName = (String) srvListContractTicketStatusNameObj.get('ticketStatusName');   
                    if(ContractTicketStatusName != null){
                        
                        contractTicketStatusNameOption.add(new SelectOption(ContractTicketStatusName, ContractTicketStatusName));
                        system.debug('ContractTicketStatusName == :' + ContractTicketStatusName );
                        
                    }
                    
                }
            }
        }
            else if(dataSourceSelectedValue  == 'Master Data'){
                system.debug('masuk di pipeline master data===');
                
                    List<String> ticketStatutsNameValuesList= new List<String>();
                    Schema.DescribeFieldResult fieldResult = Contract_Ticket__c.ticketstatus__c.getDescribe();
                    List<Schema.PicklistEntry> ticketStatusNameList = fieldResult.getPicklistValues();
                    contractTicketStatusNameOption = new List<SelectOption>();
                    system.debug('fieldresult master data tiket status === ');
                    for( Schema.PicklistEntry ticketStatusNameObj : ticketStatusNameList){
                        ticketStatutsNameValuesList.add(ticketStatusNameObj.getLabel());
                        system.debug(' == ticketStatutsNameValuesList : ' +ticketStatutsNameValuesList);
                        if(contractTicketStatusNameOption != null){
                            contractTicketStatusNameOption.add(new SelectOption(ticketStatusNameObj.getLabel(), ticketStatusNameObj.getLabel()));
                        }
                    
                    }
                }
            
            
            
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on getProductName method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber())); 
        } 
        return contractTicketStatusNameOption;
    }
    
    
    
    public list<SelectOption> getRevenueCategories(){
        system.debug('masuk di getRevenueCategories ====');
        list<SelectOption> option = new list <SelectOption>(); 
        
        try{
            
            List<AggregateResult> srvListrevCatName = new List<AggregateResult>();

            if(dataSourceSelectedValue == 'Master Data' ){
                    
                    List<AggregateResult> srvListMasterDatarevCatName = [select name revCatName from  revenue_category__C 
                                                                        where group_service__r.name in :revGroupServiceSelected
                                                                        group by name
                                                                        order by name];
                    srvListrevCatName = srvListMasterDatarevCatName;
                
                    system.debug('srvListrevCatName**'+srvListrevCatName);
            }
            
            if(dataSourceSelectedValue == 'Transaction Data'){
                    
                    List<AggregateResult> srvListTransactionDatarevCatName = [select Revenue_category__r.name revCatName 
                                                                              from sales_revenue__c
                                                                              where type__c = 'actual revenue' and period_date__c >= :SalesRcObj.Period_Start_Date__c 
                                                                              and period_date__c <= :SalesRcObj.Period_End_Date__c and group_service__r.name = :revGroupServiceSelected
                                                                              group by Revenue_category__r.name
                                                                              order by Revenue_category__r.name];
                    
                    srvListrevCatName = srvListTransactionDatarevCatName;                                        
                    
                    system.debug('srvListTransactionDatarevCatName == : ' + srvListTransactionDatarevCatName); 
                }
                
                
                // srvRevCatName = new List<SelectOption>();
                
                for (AggregateResult srvObjRevCatName : srvListrevCatName) {
                    
                    String revCatName = '';
                    revCatName = (String) srvObjRevCatName.get('revCatName');   
                    if(revCatName != null){
                        
                        option.add(new SelectOption(revCatName, revCatName));
                        system.debug('revCatName' + revCatName );
                        
                    }
                    /* Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'Data tidak ditemukan')); */  
                
                
                
            }
        }catch(Exception e){
            
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on get revenue categories' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
            
        } 
        
        return option; 
        
    }
    
    
    public list<SelectOption> getProductName(){
        list<SelectOption> productNameOption = new list <SelectOption>(); 
        List<AggregateResult> srvListPordName = new List <AggregateResult>(); 

    try{
        system.debug(' === masuk di method getProductName ===');
        system.debug(' === masuk di sini === 520');
        system.debug('dataSourceSelectedValue == ::' + dataSourceSelectedValue);
        system.debug(' === masuk di sini === 522');
        system.debug('pipelineGroupServiceSelected == :' +pipelineGroupServiceSelected);
        system.debug('productNameList == :' +productNameList);
            
            if(dataSourceSelectedValue == 'Master Data'){
                system.debug(' === masuk di sini === 531');
                for(String productName : this.productNameList){     
                    system.debug(' === productName ==== + ' +productName);
                    system.debug(' === this.productNameList ==== + ' +this.productNameList);
                    productNameOption.add(new SelectOption(productName, productName));
                    system.debug('productNameOption =='+ productNameOption);
                }

/*
                if(pipelineGroupServiceSelected != null){

                    List<AggregateResult> srvListMasterDataPordName = [Select Product2.Name ProductName
                                                                        From PricebookEntry where 
                                                                        product2.group_service__r.name in :pipelineGroupServiceSelected
                                                                        group by product2.Name 
                                                                        order by product2.Name];

                    srvListPordName = srvListMasterDataPordName;

                    system.debug('srvListPordName**' + srvListPordName);
                    
                    
                }
                */
            }
                
        

            if(dataSourceSelectedValue == 'Transaction Data'){
                system.debug('masuk di line sini ====');
                    List<AggregateResult> srvListTransactionDataPordName = [select opportunity_product_rel__r.product2.Name ProductName 
                                                                            from sales_revenue__c where 
                                                                            period_date__c <= :SalesRcObj.Period_End_Date__c 
                                                                            and period_date__c >= :SalesRcObj.Period_start_Date__c
                                                                            and Opportunity_stage__c in :stageNameSelected
                                                                            and group_service__r.name in :pipelineGroupServiceSelected
                                                                            group by opportunity_product_rel__r.product2.Name 
                                                                            order by opportunity_product_rel__r.product2.Name];
                    
                    
                    srvListPordName = srvListTransactionDataPordName;
                    system.debug('srvListPordName**' + srvListPordName);                                          
                

                    productNameOption = new List<SelectOption>();
            
                    for (AggregateResult srvObjProdName : srvListPordName) {
                        
                        String prodName = '';
                        prodName = (String) srvObjProdName.get('ProductName');   
                        if(prodName != null){
                            
                            productNameOption.add(new SelectOption(prodName, prodName));
                            system.debug('productNameOption == **' + productNameOption );
                            
                        }     
                    }
            }
            
          
            
            
            
            
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on getProductName method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
            
            
        } 

        system.debug('productNameOption =='+ productNameOption);
        return productNameOption;

    }
    
    
    public List<SelectOption>  getServiceType(){
        system.debug('==== masuk di getServiceType =====/');

        list<selectoption> serviceType = new list <SelectOption>();

        try{

            if(dataSourceSelectedValue == 'Master Data'){

                List<String> serviceTypeValueList= new List<String>();
                Schema.DescribeFieldResult fieldResult = sales_revenue__c.service__c.getDescribe();
                List<Schema.PicklistEntry> serviceTypeList = fieldResult.getPicklistValues();
            
                serviceType = new List<SelectOption>();
                for( Schema.PicklistEntry serviceTypeNameObj : serviceTypeList){

                    serviceTypeValueList.add(serviceTypeNameObj.getLabel());
                    
                    if(serviceTypeList != null){
                        serviceType.add(new SelectOption(serviceTypeNameObj.getLabel(), serviceTypeNameObj.getLabel()));
                    }
                }
                
                
            }
            else if (dataSourceSelectedValue == 'Transaction Data'){

                List<AggregateResult> srvListserviceName = [select Service__c from sales_revenue__c
                                                            where type__c = 'Subscribe gross add' and period_date__c >= :SalesRcObj.Period_Start_Date__c and period_date__c <= :SalesRcObj.Period_End_Date__c
                                                            group by Service__c
                                                            order by Service__c];
               // srvService = new List<SelectOption>();
                for(AggregateResult srvObjServiceName : srvListserviceName){
                    
                    String ServiceName = '';
                    ServiceName = (String) srvObjServiceName.get('Service__c');
                    
                    if(ServiceName != null){
                        
                        serviceType.add(new SelectOption(ServiceName, ServiceName));
                        
                        
                    }
                }

            }

        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on getProductName method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
            
            
        } 
        return serviceType;
    }

    public list<SelectOption> getGroupPricePlan(){
        system.debug('method.getGroupPricePlan.metohd**');
        system.debug('dataSourceOption == : ' + dataSourceOptions); 
        
        list<SelectOption> groupPricePlanOption = new list <SelectOption>();
        List<AggregateResult>  srvListGroupPricePlan = new list <AggregateResult>();
        
        try{
            system.debug('dataSourceOption == : ' + dataSourceOptions); 
            
            if(dataSourceSelectedValue == 'Master Data'){
                
                List<String> pickListValuesList= new List<String>();
                Schema.DescribeFieldResult fieldResult = sales_revenue__c.group_price_plan__c.getDescribe();
                List<Schema.PicklistEntry> groupPricePlanList = fieldResult.getPicklistValues();
                for( Schema.PicklistEntry pickListVal : groupPricePlanList){
                    pickListValuesList.add(pickListVal.getLabel());
                    if(pickListValuesList != null){

                        groupPricePlanOption.add(new SelectOption(pickListVal.getLabel(), pickListVal.getLabel()));

                    }
                }     
                
                
                system.debug('== + hasil value' + groupPricePlanList);       
                
            }
            if(dataSourceSelectedValue == 'Transaction Data'){
                
                if(serviceSelected!= null ){
                    
                    List<AggregateResult> srvListTransactionDataGroupPricePlan = [select group_price_plan__c GroupPricePlanName
                                                                                  from sales_revenue__c
                                                                                  where type__c = 'Subscribe gross add' and quantity__c != 0 and period_date__c >= :SalesRcObj.Period_Start_Date__c and period_date__c <= :SalesRcObj.Period_End_Date__c and service__c in :serviceSelected
                                                                                  group by group_price_plan__c
                                                                                  order by group_price_plan__c];
                    
                    srvListGroupPricePlan = srvListTransactionDataGroupPricePlan;
                    
                    system.debug('srvListGroupPricePlan**' + srvListGroupPricePlan);                                           
                    system.System.debug('serviceSelected**'+ serviceSelected);
                    
                }
                
                
            }
            
            // srvRevCatName = new List<SelectOption>();
            
            for (AggregateResult srvObjGroupPricePlan : srvListGroupPricePlan) {
                
                String GroupPricePlanName = '';
                GroupPricePlanName = (String) srvObjGroupPricePlan.get('GroupPricePlanName');   
                if(GroupPricePlanName != null){
                    
                    groupPricePlanOption.add(new SelectOption(GroupPricePlanName, GroupPricePlanName));
                    system.debug('GroupPricePlanName**' + groupPricePlanOption );
                    
                }     
            }
            
            
            
        }catch(Exception e){
            
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on getProductName method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
            
        } return groupPricePlanOption;
    }
    
    
    public list<SelectOption> getGroupServiceName(){
        
        system.debug('method.getGroupServiceName.metohd**');
        
        
        list<SelectOption> getGroupserviceNameOption = new list <SelectOption>();  
        List<AggregateResult> srvListGroupServiceName = new List<AggregateResult>();
        
        
        system.debug('dataSourceSelectedValue == : ' +dataSourceSelectedValue);
        try{
           
            if(dataSourceSelectedValue == 'Transaction Data'){

              
                system.debug('masuk data transaksi');
                system.debug('stageNameSelected :: ' + stageNameSelected);
                system.debug('contractTicketStatusSelected ::' + contractTicketStatusSelected);

                if(stageNameSelected!= null ){

                    for(String StageNameVarString : stageNameSelected){
                    
                        if(StageNameVarString == 'closed won' || StageNameVarString == 'waiting for contract'){
                            
                            List<AggregateResult> groupServiceFromTransactionDataList = [select group_service__r.name name 
                                                                                     from sales_revenue__c
                                                                                        where type__c = 'Opportunity Product' 
                                                                                        and opportunity_rel__r.stageName in :stageNameSelected
                                                                                        and contract_ticket_status__c in:contractTicketStatusSelected
                                                                                        and period_date__c >= :SalesRcObj.Period_Start_Date__c 
                                                                                        and period_date__c <= :SalesRcObj.Period_End_Date__c
                                                                                        group by group_service__r.name
                                                                                        order by group_service__r.name];
                    
                    srvListGroupServiceName = groupServiceFromTransactionDataList;
                    
                    system.debug('groupServiceFromTransactionDataList**' + groupServiceFromTransactionDataList);  
                    system.debug('srvListGroupServiceName ===' + srvListGroupServiceName);          
            
                        }
                    else  if(StageNameVarString != 'closed won' || StageNameVarString != 'waiting for contract'){
                            
                            List<AggregateResult> groupServiceFromTransactionDataList = [select group_service__r.name name 
                                                                                     from sales_revenue__c
                                                                                 where type__c = 'Opportunity Product' 
                                                                                 and opportunity_rel__r.stageName in :stageNameSelected
                                                                                 and period_date__c >= :SalesRcObj.Period_Start_Date__c 
                                                                                 and period_date__c <= :SalesRcObj.Period_End_Date__c
                                                                                 group by group_service__r.name
                                                                                 order by group_service__r.name];
                    
                    srvListGroupServiceName = groupServiceFromTransactionDataList;
                    
                    system.debug('groupServiceFromTransactionDataList**' + groupServiceFromTransactionDataList);  
                    system.debug('srvListGroupServiceName ===' + srvListGroupServiceName);          

                    }



                    }
                    
                }
                
            }
            
            else if(dataSourceSelectedValue == 'Master Data' ){
                                
                system.debug('dataSourceSelectedValue2 === ' + dataSourceSelectedValue);
                
                List<AggregateResult> groupServiceFromMasterDataList = [select name 
                                                                        from group_service__c
                                                                        group by name
                                                                        order by name
                                                                       ];
                
                
                srvListGroupServiceName = groupServiceFromMasterDataList;
                system.debug('groupServiceFromMasterDataList**'+groupServiceFromMasterDataList);             
                                
                system.debug(' === srvListGroupServiceName :   ' + srvListGroupServiceName);                             
                // srvRevCatName = new List<SelectOption>();
            }
                for (AggregateResult srvObjGroupServiceName : srvListGroupServiceName) {
                    
                    String groupServiceNames = '';
                    groupServiceNames = (String) srvObjGroupServiceName.get('name');   
                    if(groupServiceNames != null){
                        
                        getGroupserviceNameOption.add(new SelectOption(groupServiceNames, groupServiceNames));
                        system.debug('groupServiceNames**' + groupServiceNames );
                        
                    }     
                }
            
            
            
            
        } catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on view data method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
        }
        
        return getGroupserviceNameOption;
    }



    public list<SelectOption> getOppStageName(){
        
        list<SelectOption> srvStageName = new list <SelectOption>();  
        List<AggregateResult> srvListStageName = new List<AggregateResult>();

        system.debug('method.getOppStageName.metohd**');
        system.debug('dataSourceSelectedValue == : ' +dataSourceSelectedValue);
    try{
            
        system.debug('masuk stagename transaction ====');
        
            if(dataSourceSelectedValue == 'Transaction Data'){
                    List<AggregateResult> srvListTransactionStageName = [select Opportunity_Product_Rel__r.opportunity.StageName stageName 
                                                                from sales_revenue__c  where
                                                                period_date__c <= :SalesRcObj.Period_End_Date__c 
                                                                and period_date__c >= :SalesRcObj.Period_start_Date__c
                                                               // and   Opportunity_Product_Rel__r.opportunity.Contract_Ticket__c !=null
                                                                group by Opportunity_Product_Rel__r.opportunity.StageName 
                                                                order by Opportunity_Product_Rel__r.opportunity.StageName]; 
                                                                
                    srvListStageName = srvListTransactionStageName;
                    system.debug('srvListStageName :: == '+ srvListStageName);
                
            srvStageName = new List<SelectOption>();
                for (AggregateResult srvStageNameObj : srvListStageName) {
                    
                    String stageNames = '';
                    stageNames = (String) srvStageNameObj.get('stageName');   
                    if(stageNames != null){
                        
                        srvStageName.add(new SelectOption(stageNames, stageNames));
                        system.debug('stageNames**' + stageNames );
                        
                    }     
                }
            }

            // hasil sobject type ga bisa dimasukin ke dalam for
            else if(dataSourceSelectedValue == 'Master Data' ){
                
                system.debug('dataSourceSelectedValue2 === ' + dataSourceSelectedValue);

                List<String> stageNameValuesList= new List<String>();
                Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
                List<Schema.PicklistEntry> stageNameList = fieldResult.getPicklistValues();
                srvStageName = new List<SelectOption>();
                for( Schema.PicklistEntry oppStageNameObj : stageNameList){
                    stageNameValuesList.add(oppStageNameObj.getLabel());
                    
                    if(stageNameValuesList != null){
                        srvStageName.add(new SelectOption(oppStageNameObj.getLabel(), oppStageNameObj.getLabel()));
                    }
                }
            }     
                
            
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on getOppStageName method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
        }
        
        return srvStageName;
    }
    
    
    public List<SelectOption> getLinkServiceType(){

        List<selectoption> linkServiceTypeOption = new List<SelectOption>();


        try{

            if(dataSourceSelectedValue == 'Transaction Data'){
                
                List<AggregateResult> srvListLinkSTName = [select Link_Service_Type__c 
                                                            from sales_revenue__c
                                                            where type__c = 'Link gross add' 
                                                            and period_date__c >= :SalesRcObj.Period_Start_Date__c 
                                                            and period_date__c <= :SalesRcObj.Period_End_Date__c
                                                            group by Link_Service_Type__c
                                                            order by Link_Service_Type__c];

        
                for(AggregateResult srvObjLinkSTName : srvListLinkSTName){

                        String LSTName = '';
                        LSTName = (String) srvObjLinkSTName.get('Link_Service_Type__c');
                        system.debug('logLevel data Link_Service_Type__c apa saja === **' + LSTName);
                        if(LSTName != null){

                            linkServiceTypeOption.add(new SelectOption(LSTName, LSTName));


                    }
                }

            }
            else if(dataSourceSelectedValue == 'Master Data'){
                
                system.debug('dataSourceSelectedValue2 === ' + dataSourceSelectedValue);

                List<String> linkServiceTypeValuesList= new List<String>();
                Schema.DescribeFieldResult fieldResult = sales_revenue__c.link_service_type__c.getDescribe();
                List<Schema.PicklistEntry> linkServiceTypeNameList = fieldResult.getPicklistValues();
                
                for( Schema.PicklistEntry linkServiceTypeNameObj : linkServiceTypeNameList){
                    linkServiceTypeValuesList.add(linkServiceTypeNameObj.getLabel());
                    
                    if(linkServiceTypeValuesList != null){
                        linkServiceTypeOption.add(new SelectOption(linkServiceTypeNameObj.getLabel(), linkServiceTypeNameObj.getLabel()));
                    }
                }
                
            }

        }  catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on getLinkServiceType method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
        }
        return linkServiceTypeOption;
    }

    
    public list<Product2> getMasterProductRecords(){

        return [select name from product2 where IsActive = true limit 1000];
        
    }



    public void setProductListbySearch(){

    try{
        if(dataSourceSelectedValue == 'Master Data'){

            System.debug('=== productNameSearchValue : ' + productNameSearchValue);
            productNameSearchOption = new list <SelectOption>();
    
            list<product2> productList = [select name from product2 where name like :'%'+productNameSearchValue+'%' and group_service__r.name in:pipelineGroupServiceSelected limit 999];
            System.debug('=== productList : ' + productList);
    
            for(product2 product2Obj : productList){
                productNameSearchOption.add(new SelectOption( product2Obj.Name, product2Obj.Name));
            }
            System.debug('=== productNameSearchOption : ' + productNameSearchOption);

        }

        else if(dataSourceSelectedValue == 'Transaction data'){
            List<AggregateResult> srvListTransactionDataPordName = [select opportunity_product_rel__r.product2.Name ProductName 
                                                                            from sales_revenue__c where 
                                                                            period_date__c <= :SalesRcObj.Period_End_Date__c 
                                                                            and period_date__c >= :SalesRcObj.Period_start_Date__c
                                                                            and Opportunity_stage__c in :stageNameSelected
                                                                            and group_service__r.name in :pipelineGroupServiceSelected      
                                                                            group by opportunity_product_rel__r.product2.Name 
                                                                            order by opportunity_product_rel__r.product2.Name];
                    
        
                    system.debug('stageNameSelected == :' + stageNameSelected);
                    system.debug('pipelineGroupServiceSelected == :'+ pipelineGroupServiceSelected);
                    system.debug('srvListTransactionDataPordName == :'+srvListTransactionDataPordName);
         


        
                    productNameSearchOption = new List<SelectOption>();
            
                    for (AggregateResult srvObjProdName : srvListTransactionDataPordName) {
                        
                        String prodName = '';
                        prodName = (String) srvObjProdName.get('ProductName');   
                        if(prodName != null){
                            
                            productNameSearchOption.add(new SelectOption(prodName, prodName));
                            system.debug('productNameSearchOption == **' + productNameSearchOption );
                            
                        }
                    }
                }
                
            } 
            catch(Exception e){
                
                string notes = 'Error on SalesRacingController.saveAMTopList method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
                
                string errorMsg = notes + '::' +  message + '::' + lineNumber + '::';
                system.debug ('===== errorMsg : ' + errorMsg);
            
        }    
    }


        
      
    

    public List<selectoption> getProductListbySearch(){
        return productNameSearchOption;
    }


    public void addProductSelected(){
        /*
        system.debug('productNameOption === 922 ');
        system.debug(' productNameList berfore === ' +productNameList);

        productNameList.add(productNameAutocompleted);
        
        system.debug('productNameList === after' +productNameList);
       */
        
       for(string productName : productNameSearchResultSelected){
        productNameSelectedOption.add(new SelectOption(productName, productName));
       }
    }

    public void addRecordAMTopList(){
    try{
        if(srcController.getAMTopList().Size() == 0){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Parameter berhasil di simpan'));
            srcController.saveParameterAMTopList();

        }else if(srcController.getAMTopList().Size() > 0){
            
            srcController.saveAMTopList();
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Data berhasil disimpan'));   
            
        }
    }catch(Exception e){
        Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on AddRecord method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
    }
        
    }

       // ============= new data define for put in sales racing controller   
       public void viewDatatopAMData(){
        system.debug('revCategoryNameSelected##'+ revCategoryNameSelected);
        
        try{
            boolean viewData = true;
            
            switch on SalesRcObj.data_source__c {
                
                when 'Revenue' {
                    if(revGroupServiceSelected.size() == 0 || revCategoryNameSelected.size() == 0){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Silahkan pilih filter terlebih dahulu'));
                        viewData = false;
                    }
                    else{
                        srcController.revGroupServiceSelected = revGroupServiceSelected;
                        srcController.revCategoryNameSelected = revCategoryNameSelected;
                    
                    }
                }
                
                when 'Pipeline' {
                    
                    if(stageNameSelected == null || pipelineGroupServiceSelected == null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Silahkan pilih filter terlebih dahulu'));
                        viewData = false;
                    }
                    else{
                        srcController.productNameSelected = productNameSelected ;
                        srcController.stageNameSelected  = stageNameSelected ;
                        srcController.pipelineGroupServiceSelected  = pipelineGroupServiceSelected ;
                        srcController.contractTicketStatusSelected = contractTicketStatusSelected ;
                        system.System.debug('srcController.contractTicketStatusSelected ===' + srcController.contractTicketStatusSelected);
                    }
                }
                
                when 'Subscribe' {
                    if(serviceSelected == null || groupPricePlanSelected == null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Silahkan pilih filter terlebih dahulu'));
                        viewData = false;
                    }
                    else{
                        srcController.serviceSelected  = serviceSelected ;
                        srcController.groupPricePlanSelected  = groupPricePlanSelected ;
                    }
                    
                }
                
                when 'Link' {
                    if(linkServiceTypeSelected == null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Silahkan pilih filter terlebih dahulu'));
                        viewData = false;
                    }else{
                        srcController.linkServiceTypeSelected  = linkServiceTypeSelected ;
                    }
                }
            }
                if(viewData){
                    srcController.generateAMTopList();
                    this.amTopList = srcController.getAMTopList();
                }
            }
            catch(Exception e){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on viewDatatopAMData method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
            }
        }

    public void setDataParametertopAMData(){
        system.debug('revCategoryNameSelected##'+ revCategoryNameSelected);

        try{
        boolean viewData = true;
        
        switch on SalesRcObj.data_source__c {
            
            when 'Revenue' {
                if(revGroupServiceSelected.size() == 0 || revCategoryNameSelected.size() == 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Silahkan pilih filter terlebih dahulu'));
                    viewData = false;
                }
                else{
                    srcController.revGroupServiceSelected = revGroupServiceSelected;
                    srcController.revCategoryNameSelected = revCategoryNameSelected;
                  
                }
            }
            
            when 'Pipeline' {
                
                if(stageNameSelected == null || pipelineGroupServiceSelected == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Silahkan pilih filter terlebih dahulu'));
                    viewData = false;
                }
                else{
                    srcController.productNameSelected = productNameSelected ;
                    srcController.stageNameSelected  = stageNameSelected ;
                    srcController.pipelineGroupServiceSelected  = pipelineGroupServiceSelected ;
                    srcController.contractTicketStatusSelected = contractTicketStatusSelected ;
                    system.System.debug('srcController.contractTicketStatusSelected ===' + srcController.contractTicketStatusSelected);
                }
            }
            
            when 'Subscribe' {
                if(serviceSelected == null || groupPricePlanSelected == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Silahkan pilih filter terlebih dahulu'));
                    viewData = false;
                }
                else{
                    srcController.serviceSelected  = serviceSelected ;
                    srcController.groupPricePlanSelected  = groupPricePlanSelected ;
                }
                
            }
            
            when 'Link' {
                if(linkServiceTypeSelected == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Silahkan pilih filter terlebih dahulu'));
                    viewData = false;
                }else{
                    srcController.linkServiceTypeSelected  = linkServiceTypeSelected ;
                }
            }
        }
        if(viewData){
            srcController.generateAMTopList();
            this.amTopList = srcController.getAMTopList();
        }
    }
    catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on setDataParametertopAMData method' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
        }
    }

    public void saveAMtopData(){

        setDataParametertopAMData();

        addRecordAMTopList();


    }

    

    /*
    public void addSelectOptionDataSource(){
        
        try{
            List<SelectOption> dataSourceOptions = new List<SelectOption>();
            
            if(dataSourceSelectedValue != null){
                
                dataSourceOptions.add (new selectoption ('Transaction Data', 'Transaction Data'));
                
                dataSourceOptions.add (new selectoption ( 'Master data', 'Master Data'));
                
                
                system.debug('tester == +' + dataSourceOptions);
                
            }        
            
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on addSelectOptionDataSource' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
            
        }
        
    }
    */

  

    public void viewTicketStatusPanelId(){

        try{
            if(stageNameSelected != null &&  !stageNameSelected.isEmpty()){
            	this.displayContractTicketStatusName = false;
                for(String StageNameVarString : stageNameSelected){
                    
                    if(StageNameVarString == 'closed won' || StageNameVarString == 'waiting for contract'){
                        
                        this.displayContractTicketStatusName = true;
        
                    }
                    system.debug('hasil stageNameSelected == : ' + stageNameSelected);
                    system.debug(' this.displayContractTicketStatusName == ' +  displayContractTicketStatusName);
                    
                }
                
                    if  (this.displayContractTicketStatusName == FALSE) {
                        contractTicketStatusSelected = new List<string>();
                    }
              
            }
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'something wrong on SalesRacingReportController constructor' + '-'+ 'Name =' + e.getmessage() + ';;' +  '-' + e.getStackTraceString() + ';;' + '-' + 'line number =' + e.getLineNumber()));
        }
        
    }

    public boolean getdisplayContractTicketStatusName(){
        return displayContractTicketStatusName;

    } 
    
    

}