/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 09-16-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SalesRacingController {
    
    public string relatedSFIDs;
    public Sales_Racing__c salesRacingObj {get; set;}
    public list<AM_top_List__c> amTopList {get; set;}
    
    
    public string[] revGroupServiceSelected {get;set;}
    public string[] revCategoryNameSelected {get;set;}
    public string[] serviceSelected {get;set;}
    public string[] groupPricePlanSelected {get;set;}
    public string[] linkServiceTypeSelected {get;set;}
    public string[] pipelineGroupServiceSelected {get;set;}
    public string[] productNameSelected {get;set;}
    public string[] productNumberSelected {get;set;}
    public string[] stageNameSelected {get;set;}
    public string[] contractTicketStatusSelected {get;set;}
    
    
    public SalesRacingController(Sales_Racing__c salesRacingObj) {
        List<string> tmpStringList = new List<String>(); 
        // salesRacingObj = new Sales_Racing__c();
        //  amTopList = new List<AM_top_List__c> ();
        
        revGroupServiceSelected = new list<string>();
        revCategoryNameSelected = new list<string>();
        serviceSelected = new list<string>();
        groupPricePlanSelected = new list<string>();
        linkServiceTypeSelected = new list<string>();
        pipelineGroupServiceSelected = new list<string>();
        productNameSelected = new list<string>();
        productNumberSelected = new list<string>();
        stageNameSelected = new list<string>();
        contractTicketStatusSelected = new List<String>();
        
        
        if (salesRacingObj  <> null ) {
            this.salesRacingObj = salesRacingObj;
            relatedSFIDs = this.salesRacingObj.id;
            
            IF (this.salesRacingObj.group_services__c <> NULL ) {
                tmpStringList = this.salesRacingObj.group_services__c.split ('\n');
                for (string tmpString : tmpStringList) {
                    revGroupServiceSelected.add (tmpString);
                    pipelineGroupServiceSelected.add (tmpString);
                }
                
            }
            
            IF (this.salesRacingObj.Revenue_Category__c <> NULL ) {
                tmpStringList = this.salesRacingObj.Revenue_Category__c.split ('\n');
                for (string tmpString : tmpStringList) {
                    revCategoryNameSelected.add (tmpString);
                }
            }
            
            
            IF (this.salesRacingObj.Service__c <> NULL ) {
                tmpStringList = this.salesRacingObj.Service__c.split ('\n');
                for (string tmpString : tmpStringList) {
                    serviceSelected.add (tmpString);
                }
            }
            
            IF (this.salesRacingObj.Group_Price_Plans__c <> NULL ) {
                tmpStringList = this.salesRacingObj.Group_Price_Plans__c.split ('\n');
                for (string tmpString : tmpStringList) {
                    groupPricePlanSelected.add (tmpString);
                }
            }
            
            IF (this.salesRacingObj.Link_Service_Type__c <> NULL ) {
                tmpStringList = this.salesRacingObj.Link_Service_Type__c.split ('\n');
                for (string tmpString : tmpStringList) {
                    linkServiceTypeSelected.add (tmpString);
                }
            }
            
            IF (this.salesRacingObj.Product_Name__c <> NULL ) {
                tmpStringList = this.salesRacingObj.Product_Name__c.split ('\n');
                for (string tmpString : tmpStringList) {
                    productNameSelected.add (tmpString);
                }
            }
            
            IF (this.salesRacingObj.Stages__c <> NULL ) {
                tmpStringList = this.salesRacingObj.Stages__c.split ('\n');
                for (string tmpString : tmpStringList) {
                    stageNameSelected.add (tmpString);
                }
            }
            
            
            IF (this.salesRacingObj.Contract_Ticket_Status__c <> NULL ) {
                tmpStringList = this.salesRacingObj.Contract_Ticket_Status__c.split ('\n');
                for (string tmpString : tmpStringList) {
                    contractTicketStatusSelected.add (tmpString);
                }
            }
            
            
            
        }
        
    }
    
    
    public list<AM_top_List__c>  getAMTopList () {
        
        system.debug ('this.amTopList : ' + this.amTopList);
        return this.amTopList;
    }
    
    public void generateAMTopList () {
        //List<AM_top_List__c> amTopList = new List<AM_top_List__c> ();
        system.debug('masuk di generateAMTopList ===');
        amTopList = new List<AM_top_List__c> ();
        try {
            Map<string, string> amTopListReportIdMaps = new map<string, string>();
            
            List<AMTopListDetailReport__c> amdetailreportList = [select name, value__c from AMTopListDetailReport__c];
            system.debug('test == ' +amdetailreportList);
            
            if(amdetailreportList.size() != null || amdetailreportList.size() > 0){
                
                for(AMTopListDetailReport__c amtoplistObj : amdetailreportList){
                    
                    amTopListReportIdMaps.put(amtoplistObj.name, amtoplistObj.value__c);
                    
                }
            }
            
            if(salesRacingObj.Data_Source__c == 'revenue'){
                
                if(revCategoryNameSelected == null || revCategoryNameSelected.isEmpty() ){
                    //Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'Filter perlu dipilih'));
                    
                }else{
                    System.debug('revCategoryNameSelected**' +revCategoryNameSelected);
                    system.debug('revGroupServiceSelected = '+revGroupServiceSelected);
                    system.debug('salesRacingObj.Period_Start_Date__c = ' +salesRacingObj.Period_Start_Date__c);
                    system.debug('salesRacingObj.Period_End_Date__c = ' +salesRacingObj.Period_End_Date__c);
                    
                    List <AggregateResult> allsalesrevenue = [select AM__c, AM__r.name AMname, sum(Amount__c) amount 
                                                              from sales_revenue__c where type__c = 'actual revenue' 
                                                              and period_date__c >= :salesRacingObj.Period_Start_Date__c 
                                                              and period_date__c <= :salesRacingObj.Period_End_Date__c 
                                                              and group_service__r.name IN :revGroupServiceSelected 
                                                              and revenue_category__r.name in :revCategoryNameSelected
                                                              group by AM__r.name, AM__c
                                                              order by sum(amount__c) desc 
                                                              limit 25];
                    
                    system.debug('allsalesrevenue ==' + allsalesrevenue);
                    integer counter = 1;
                    
                    if(allsalesrevenue == null || allsalesrevenue.isEmpty()){
                        
                    }
                    else {
                        String groupServiceWithComma = string.join(revGroupServiceSelected, ',');
                        String revCategoryNameWithComma = String.join(revCategoryNameSelected, ',');
                        
                        for (AggregateResult srvRevenueObj : allsalesrevenue){
                            
                            Double amount = 0;
                            String AM ='';
                            String AMIDs = '';
                            amount = (Double) srvRevenueObj.get('amount');
                            AM = (String) srvRevenueObj.get('AMname');
                            AMIDs = (String) srvRevenueObj.get('AM__c');
                            
                            if(amount != null && amount != 0){
                                String names = '0' + string.valueof(counter);
                                AM_top_List__c topListObj = new AM_top_List__c();
                                topListObj.name = names.right(2) + '. ' + AM;
                                topListObj.am__c = AMIDs;
                                topListObj.amount__c = amount ;
                                topListObj.sales_racing__c = salesRacingObj.Id;
                                //topListObj.detail_report__c = 'lightning/r/Report/00ON0000001KYRDMA4/view?fv0=Actual Revenue&fv1=2021-6-1&fv2=2021-8-31&fv3=90006890&fv4='+revCategoryNameSelected+'&fv5='+groupServiceWithComma;
                                
                                string startDate = String.valueOf(salesRacingObj.Period_Start_Date__c);
                                string endDate = String.valueOf(salesRacingObj.Period_End_Date__c);
                                
                                String reportId = amTopListReportIdMaps.get(salesRacingObj.Data_Source__c);
                                //string reportID = '00ON0000001KYRDMA4'; //todo : put on custom setting
                                string fullReportUrl = '/lightning/r/Report/' + reportId + '/view?' +
                                    'fv0=' + 'Actual Revenue' + '&' +
                                    'fv1=' + startDate + '&' + 
                                    'fv2=' + endDate + '&' +
                                    'fv3=' + AMIDs.left(15) + '&' +
                                    'fv4=' + groupServiceWithComma.replace('&', '%26') + '&'+
                                    'fv5=' + revCategoryNameWithComma.replace('&', '%26');
                                
                                integer urlLength = fullReportUrl.length();
                                integer maxLength = 255;
                                integer sisa = math.mod(urlLength, maxLength);
                                integer groupCount =  urlLength/ maxLength;
                                if (sisa>0) groupCount = groupCount + 1;
                                system.debug ('==== groupCount : ' +  groupCount);
                                
                                integer startIndex=0;
                                integer endIndex=255;
                                for (integer strCounter=1; strCounter<=groupCount; strCounter++) {
                                    startIndex = (strCounter - 1 ) * 255;
                                    endIndex = strCounter * 255;
                                    if (endIndex > urlLength) endIndex = urlLength;
                                    
                                    system.debug ('==== strCounter : ' +  strCounter);
                                    system.debug ('==== startIndex : ' +  startIndex);
                                    system.debug ('==== endIndex : ' +  endIndex);
                                    system.debug ('==== hasil : ' +  fullReportUrl.substring(startIndex, endIndex));
                                    
                                    switch on strCounter {
                                        when 1 { topListObj.url1__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 2 { topListObj.url2__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 3 { topListObj.url3__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 4 { topListObj.url4__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 5 { topListObj.url5__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 6 { topListObj.url6__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 7 { topListObj.url7__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 8 { topListObj.url8__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 9 { topListObj.url9__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 10 { topListObj.url10__c = fullReportUrl.substring(startIndex, endIndex);}
                                    }
                                }
                                
                                
                                amTopList.add(topListObj);
                                
                                counter ++;
                            }
                            
                        }
                        system.System.debug('==== debug period date start'+ salesRacingObj.Period_Start_Date__c);
                        system.debug('=== debug end date ='+ salesRacingObj.Period_Start_Date__c);
                        
                    }
                }
                
            }
            else if(this.salesRacingObj.Data_Source__c == 'Subscribe'){
                if(groupPricePlanSelected == null || groupPricePlanSelected.isEmpty()){
                    
                }else{
                    List <AggregateResult> allsalesrevenue = [select am__c,  am__r.name AMnames, sum(quantity__c) quantity 
                                                              from sales_revenue__c 
                                                              where type__c = 'Subscribe gross add' and period_date__c >= :salesRacingObj.Period_Start_Date__c and period_date__c <= :salesRacingObj.Period_End_Date__c  
                                                              and service__c in :serviceSelected and group_price_plan__c in:groupPricePlanSelected
                                                              group by am__c, am__r.name order by sum(quantity__c) desc limit 25];
                    system.debug('subscribe.allsalesrevenue**' + allsalesrevenue);
                    if(allsalesrevenue == null || allsalesrevenue.isEmpty()){
                        //Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Data tidak ditemukan'));
                        
                    }else{
                        
                        integer counter = 1; 
                        
                        string groupPricePlanWithComma = string.join(groupPricePlanSelected, ',');
                        string serviceWithComma = string.join(serviceSelected, ',');
                        for (AggregateResult srvSubscribe : allsalesrevenue){
                            
                            double quantity = 0;
                            String AM ='';
                            String AMIDs = '';
                            quantity = (double) srvSubscribe.get('quantity');
                            AM = (String) srvSubscribe.get('AMnames');
                            AMIDs = (String) srvSubscribe.get('AM__c');
                            
                            
                            if(quantity != null && quantity != 0.0){
                                String names = '0' + string.valueof(counter);
                                
                                AM_top_List__c topListObjs = new AM_top_List__c();
                                topListObjs.name = names.right(2) + '. ' + AM;
                                topListObjs.am__c = AMIDs;
                                topListObjs.quantity__c = quantity ;
                                topListObjs.sales_racing__c = salesRacingObj.Id;
                                
                                //-- generate report LINK 
                                string startDate = String.valueOf(salesRacingObj.Period_Start_Date__c);
                                string endDate = String.valueOf(salesRacingObj.Period_End_Date__c);
                                system.debug('Salesrcobj.datasource =='+ salesRacingObj.data_source__c);
                                string reportID = amTopListReportIdMaps.get(salesRacingObj.data_source__c);//'00ON0000001KYwNMAW'; //todo : put on custom setting
                                string fullReportUrl = '/lightning/r/Report/' + reportID + '/view?' +
                                    'fv0=' + 'Subscribe Gross Add' + '&' +
                                    'fv1=' + startDate + '&' + 
                                    'fv2=' + endDate + '&' +
                                    'fv3=' + AMIDs.left(15) + '&' +
                                    'fv4=' + groupPricePlanWithComma.replace('&', '%26') + '&'+
                                    'fv5=' + serviceWithComma.replace('&', '%26');
                                
                                integer urlLength = fullReportUrl.length();
                                integer maxLength = 255;
                                integer sisa = math.mod(urlLength, maxLength);
                                integer groupCount =  urlLength/ maxLength;
                                if (sisa>0) groupCount = groupCount + 1;
                                system.debug ('==== groupCount : ' +  groupCount);
                                
                                integer startIndex=0;
                                integer endIndex=255;
                                for (integer strCounter=1; strCounter<=groupCount; strCounter++) {
                                    startIndex = (strCounter - 1 ) * 255;
                                    endIndex = strCounter * 255;
                                    if (endIndex > urlLength) endIndex = urlLength;
                                    
                                    system.debug ('==== strCounter : ' +  strCounter);
                                    system.debug ('==== startIndex : ' +  startIndex);
                                    system.debug ('==== endIndex : ' +  endIndex);
                                    system.debug ('==== hasil : ' +  fullReportUrl.substring(startIndex, endIndex));
                                    
                                    switch on strCounter {
                                        when 1 { topListObjs.url1__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 2 { topListObjs.url2__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 3 { topListObjs.url3__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 4 { topListObjs.url4__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 5 { topListObjs.url5__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 6 { topListObjs.url6__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 7 { topListObjs.url7__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 8 { topListObjs.url8__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 9 { topListObjs.url9__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 10 { topListObjs.url10__c = fullReportUrl.substring(startIndex, endIndex);}
                                    }
                                }
                                
                                
                                amTopList.add(topListObjs);
                                
                                counter ++;
                            }
                        }
                    }
                }
            }
            else if(salesRacingObj.Data_Source__c == 'Link'){
                system.debug('linkServiceTypeSelected ==' + linkServiceTypeSelected);
                if(linkServiceTypeSelected == null || linkServiceTypeSelected.isEmpty()){
                    
                }else{
                    
                    List <AggregateResult> allsalesrevenue = [select am__c,  am__r.name AMnames, sum(quantity__c) quantity 
                                                              from sales_revenue__c 
                                                              where type__c = 'Link gross add' and period_date__c >= :salesRacingObj.Period_Start_Date__c and period_date__c <= :salesRacingObj.Period_End_Date__c and Link_Service_Type__c in :linkServiceTypeSelected
                                                              group by am__c, am__r.name order by sum(quantity__c) desc limit 25];
                    
                    if(allsalesrevenue == null || allsalesrevenue.isEmpty() || allsalesrevenue.size() == 0 ){
                        //Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Data tidak ditemukan'));
                    }else{
                        integer counter = 1;
                        
                        String linkServiceTypeWithComma = string.join(linkServiceTypeSelected, ',');
                        
                        for (AggregateResult srvLink : allsalesrevenue){
                            
                            double quantity = 0;
                            String AM ='';
                            String AMIDs = '';
                            quantity = (double) srvLink.get('quantity');
                            AM = (String) srvLink.get('AMnames');
                            AMIDs = (String) srvLink.get('AM__c');
                            
                            
                            if(quantity != null && quantity != 0){
                                String names = '0' + string.valueof(counter);
                                
                                AM_top_List__c topListObjs2 = new AM_top_List__c();
                                topListObjs2.name = names.right(2) + '. ' + AM;
                                topListObjs2.am__c = AMIDs;
                                topListObjs2.quantity__c = quantity ;
                                topListObjs2.sales_racing__c = salesRacingObj.Id;
                                
                                //-- generate report LINK 
                                string startDate = String.valueOf(salesRacingObj.Period_Start_Date__c);
                                string endDate = String.valueOf(salesRacingObj.Period_End_Date__c);
                                
                                string reportID = amTopListReportIdMaps.get(salesRacingObj.data_source__c);//'00ON0000001KZ1TMAW'; //todo : put on custom setting
                                string fullReportUrl = '/lightning/r/Report/' + reportID + '/view?' +
                                    'fv0=' + 'Link Gross Add' + '&' +
                                    'fv1=' + startDate + '&' + 
                                    'fv2=' + endDate + '&' +
                                    'fv3=' + AMIDs.left(15) + '&' +
                                    'fv4=' + linkServiceTypeWithComma.replace('&', '%26');
                                
                                integer urlLength = fullReportUrl.length();
                                integer maxLength = 255;
                                integer sisa = math.mod(urlLength, maxLength);
                                integer groupCount =  urlLength/ maxLength;
                                if (sisa>0) groupCount = groupCount + 1;
                                system.debug ('==== groupCount : ' +  groupCount);
                                
                                integer startIndex=0;
                                integer endIndex=255;
                                for (integer strCounter=1; strCounter<=groupCount; strCounter++) {
                                    startIndex = (strCounter - 1 ) * 255;
                                    endIndex = strCounter * 255;
                                    if (endIndex > urlLength) endIndex = urlLength;
                                    
                                    system.debug ('==== strCounter : ' +  strCounter);
                                    system.debug ('==== startIndex : ' +  startIndex);
                                    system.debug ('==== endIndex : ' +  endIndex);
                                    system.debug ('==== hasil : ' +  fullReportUrl.substring(startIndex, endIndex));
                                    
                                    switch on strCounter {
                                        when 1 { topListObjs2.url1__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 2 { topListObjs2.url2__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 3 { topListObjs2.url3__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 4 { topListObjs2.url4__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 5 { topListObjs2.url5__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 6 { topListObjs2.url6__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 7 { topListObjs2.url7__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 8 { topListObjs2.url8__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 9 { topListObjs2.url9__c = fullReportUrl.substring(startIndex, endIndex);}
                                        when 10 { topListObjs2.url10__c = fullReportUrl.substring(startIndex, endIndex);}
                                    }
                                }
                                
                                
                                amTopList.add(topListObjs2);
                                
                                counter ++;
                            }
                        }
                    }                                          
                    
                }
            }
            else if(salesRacingObj.Data_Source__c == 'pipeline' && salesRacingObj.all_product__c == true){
                
                String StageNameVar = '';
                String stageNameWithComma = String.join(stageNameSelected, ',');
                integer indx = stageNameWithComma.indexOf(StageNameVar);
                
                //for(String StageNameVarString : stageNameSelected){
                
                list<AggregateResult> allsalesrevenue = new List<AggregateResult>();
                
                if(StageNameWithComma.indexOf('Closed Won') >= 0  || StageNameWithComma.indexOf('Waiting for Contract') >= 0 ){
                    system.debug('masuk di kriteria 1 ===');  
                    system.debug('hasil index of == : '+ StageNameWithComma.indexOf('closed won'));
                    if(pipelineGroupServiceSelected == null || pipelineGroupServiceSelected.isEmpty() || stageNameSelected == null || stageNameSelected.isEmpty() || contractTicketStatusSelected == null || contractTicketStatusSelected.isEmpty()){
                        
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Filter perlu dipilih'));
                        
                    }else {
                        system.debug('masuk di pipeline all product true ===');
                        system.debug('salesRacingObj.Period_Start_Date__c' + salesRacingObj.Period_Start_Date__c);
                        system.debug('salesRacingObj.Period_End_Date__c' + salesRacingObj.Period_End_Date__c);
                        system.debug('stageNameSelected ==' + stageNameSelected);
                        system.debug('pipelineGroupServiceSelected ==' + pipelineGroupServiceSelected);
                        system.debug('productNameSelected ==' + productNameSelected);
                        system.debug('contractTicketStatusSelected ==' + contractTicketStatusSelected);
                        
                        List <AggregateResult> allsalesrevenuewithticketStatus = [select AM__c, AM__r.name AMname, sum(Amount__c) amount 
                                                                                  from sales_revenue__c where type__c = 'Opportunity Product' 
                                                                                  and period_date__c >= :salesRacingObj.Period_Start_Date__c 
                                                                                  and period_date__c <= :salesRacingObj.Period_End_Date__c 
                                                                                  and opportunity_Stage__c in :stageNameSelected
                                                                                  and contract_ticket_status__C in:contractTicketStatusSelected
                                                                                  and group_service__r.name in :pipelineGroupServiceSelected 
                                                                                  group by AM__r.name, AM__c
                                                                                  order by sum(amount__c) desc 
                                                                                  limit 25];
                        
                        allsalesrevenue = allsalesrevenuewithticketStatus;                                                          
                        system.debug('allsalesrevenue pipeline ==  ' + allsalesrevenue);
                        system.debug('=== allsalesrevenue.size() : ' +  allsalesrevenue.size());
                        
                      /*
                        if(allsalesrevenue == null || allsalesrevenue.isEmpty()){
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Data tidak ditemukan'));
                        }
                        */
                    }
                }
                else if(StageNameWithComma.indexOf('Closed Won') < 0  && StageNameWithComma.indexOf('Waiting for Contract')  < 0 ){
                    system.debug('hasil index of  StageNameWithComma == : '+ StageNameWithComma.indexOf('closed won'));
                    if(pipelineGroupServiceSelected == null || pipelineGroupServiceSelected.isEmpty()){
                        
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Filter perlu dipilih'));
                        
                    }else {
                        system.debug('masuk di pipeline all product true ===');
                        system.debug('salesRacingObj.Period_Start_Date__c' + salesRacingObj.Period_Start_Date__c);
                        system.debug('salesRacingObj.Period_End_Date__c' + salesRacingObj.Period_End_Date__c);
                        system.debug('stageNameSelected ==' + stageNameSelected);
                        system.debug('pipelineGroupServiceSelected ==' + pipelineGroupServiceSelected);
                        system.debug('productNameSelected ==' + productNameSelected);
                        system.debug('contractTicketStatusSelected ==' + contractTicketStatusSelected);
                        
                        List <AggregateResult> allsalesrevenuewithoutTicketStatus = [select AM__c, AM__r.name AMname, sum(Amount__c) amount 
                                                                                     from sales_revenue__c where type__c = 'Opportunity Product' 
                                                                                     and period_date__c >= :salesRacingObj.Period_Start_Date__c 
                                                                                     and period_date__c <= :salesRacingObj.Period_End_Date__c 
                                                                                     and opportunity_Stage__c in :stageNameSelected
                                                                                     and group_service__r.name in :pipelineGroupServiceSelected 
                                                                                     group by AM__r.name, AM__c
                                                                                     order by sum(amount__c) desc 
                                                                                     limit 25];
                        
                        allsalesrevenue = allsalesrevenuewithoutTicketStatus;                                      
                        system.debug('allsalesrevenue pipeline ==  ' + allsalesrevenue);
                        if(allsalesrevenue == null || allsalesrevenue.isEmpty()){
                           // Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Data tidak ditemukan'));
                        }
                        
                    }   
                }
                system.debug('masuk di line perhitungan === ');
                integer counter = 1;    
                
                String pipelineGroupServiceWithComma = String.join(pipelineGroupServiceSelected, ',');
                //String productNameWithComma = String.join(productNameSelected, ',');
                String productNumberWithComma = String.join(productNumberSelected, ',');
                String contractTicketStatusWithComma = string.join(contractTicketStatusSelected, ',');
                stageNameWithComma = String.join(stageNameSelected, ',');
                
                for (AggregateResult srvPipeline : allsalesrevenue){
                    
                    double amount = 0;
                    String AM ='';
                    String AMIDs = '';
                    amount = (double) srvPipeline.get('amount');
                    AM = (String) srvPipeline.get('AMname');
                    AMIDs = (String) srvPipeline.get('AM__c');
                    
                    
                    if(amount != null && amount != 0){
                        String names = '0' + string.valueof(counter);
                        
                        AM_top_List__c topListObjs3 = new AM_top_List__c();
                        topListObjs3.name = names.right(2) + '. ' + AM;
                        topListObjs3.am__c = AMIDs;
                        topListObjs3.amount__c = amount ;
                        topListObjs3.sales_racing__c = salesRacingObj.Id;
                        
                        //-- generate report LINK 
                        string startDate = String.valueOf(salesRacingObj.Period_Start_Date__c);
                        string endDate = String.valueOf(salesRacingObj.Period_End_Date__c);
                        
                        string reportID = amTopListReportIdMaps.get(salesRacingObj.Data_Source__c);//'00ON0000001KZ1sMAG'; //todo : put on custom setting
                        string fullReportUrl = '/lightning/r/Report/' + reportID + '/view?' +
                            'fv0=' + 'Opportunity Product' + '&' +
                            'fv1=' + startDate + '&' + 
                            'fv2=' + endDate + '&' +
                            'fv3=' + AMIDs.left(15) + '&' +
                            'fv4=' + stageNameWithComma.replace('&', '%26') + '&'+
                            'fv5=' + pipelineGroupServiceWithComma.replace('&', '%26') + '&' +
                            /* 
                'fv6=' + productNameWithComma.replace('&' , '%26').replace(' ' , '%20').replace(',' , 
                '%2C').replace('(', '%28').replace(')', '%29').replace('>', '%3E').replace('+', '%2B')+
                */
                            'fv6=' + productNumberWithComma.replace('&' , '%26').replace(' ' , '%20').replace(',' , 
                                                                                                              '%2C').replace('(', '%28').replace(')', '%29').replace('>', '%3E').replace('+', '%2B') + '&'+
                            
                            'fv7=' + contractTicketStatusWithComma.replace('&', '%26').replace(' ', '%20');
                        
                        integer urlLength = fullReportUrl.length();
                        integer maxLength = 255;
                        integer sisa = math.mod(urlLength, maxLength);
                        integer groupCount =  urlLength/ maxLength;
                        if (sisa>0) groupCount = groupCount + 1;
                        system.debug ('==== groupCount : ' +  groupCount);
                        
                        integer startIndex=0;
                        integer endIndex=255;
                        for (integer strCounter=1; strCounter<=groupCount; strCounter++) {
                            startIndex = (strCounter - 1 ) * 255;
                            endIndex = strCounter * 255;
                            if (endIndex > urlLength) endIndex = urlLength;
                            
                            system.debug ('==== strCounter : ' +  strCounter);
                            system.debug ('==== startIndex : ' +  startIndex);
                            system.debug ('==== endIndex : ' +  endIndex);
                            system.debug ('==== hasil : ' +  fullReportUrl.substring(startIndex, endIndex));
                            
                            switch on strCounter {
                                when 1 { topListObjs3.url1__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 2 { topListObjs3.url2__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 3 { topListObjs3.url3__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 4 { topListObjs3.url4__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 5 { topListObjs3.url5__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 6 { topListObjs3.url6__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 7 { topListObjs3.url7__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 8 { topListObjs3.url8__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 9 { topListObjs3.url9__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 10 { topListObjs3.url10__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 11 { topListObjs3.url11__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 12 { topListObjs3.url12__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 13 { topListObjs3.url13__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 14 { topListObjs3.url14__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 15 { topListObjs3.url15__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 16 { topListObjs3.url16__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 17 { topListObjs3.url17__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 18 { topListObjs3.url18__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 19 { topListObjs3.url19__c = fullReportUrl.substring(startIndex, endIndex);}
                                when 20 { topListObjs3.url20__c = fullReportUrl.substring(startIndex, endIndex);}
                            }
                        }
                        
                        system.debug('=== topListObjs3 :' + topListObjs3);
                        amTopList.add(topListObjs3);
                        
                        counter ++;
                        system.debug('amTopList true == :' + amTopList);
                    }
                }
            }
            
            
            else if(salesRacingObj.Data_Source__c == 'pipeline' && salesRacingObj.all_product__c == false){
                system.debug(' === masuk di pipeline all product false === ');
                
                list<AggregateResult> allsalesrevenue = new List<AggregateResult>();
                
                list<Product2> productList = [select id, product_number__c from Product2 where name in :productNameSelected];
                
                if(productList.size() != null || productList.size() > 0 ){
                    
                    for (Product2 productObj : productList) {
                        
                        productNumberSelected.add (productObj.product_number__c);
                    }    
                }
                
                String StageNameVar = '';
                String stageNameWithComma = String.join(stageNameSelected, ',');
                integer indx = stageNameWithComma.indexOf(StageNameVar);
                
                system.debug(' == stageNameWithComma : '+ stageNameWithComma);
                system.debug(' == stageNameSelected : '+ stageNameSelected);
                system.debug('=before= StageNameWithComma.indexOf closed won:' + StageNameWithComma.indexOf('closed won'));
                system.debug('=before= StageNameWithComma.indexOf waiting for contract :' + StageNameWithComma.indexOf('Waiting for contract'));
                if(StageNameWithComma.indexOf('Closed Won') >= 0  || StageNameWithComma.indexOf('Waiting for Contract') >= 0 ){
                    
                    if(pipelineGroupServiceSelected == null || pipelineGroupServiceSelected.isEmpty() 	|| productNameSelected == null || productNameSelected.isEmpty()){
                        
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Filter perlu dipilih'));
                        
                    }else {
                        system.debug('masuk di pipeline all product false ===');
                        system.debug('masuk di tiket status closed won');
                        system.debug('=after= stagename index of StageNameWithComma == : ' + StageNameWithComma.indexOf('closed won'));
                        system.debug('=after= stagename index of StageNameWithComma == : ' + StageNameWithComma.indexOf('waiting for contract'));
                        system.debug('salesRacingObj.Period_Start_Date__c' + salesRacingObj.Period_Start_Date__c);
                        system.debug('salesRacingObj.Period_End_Date__c' + salesRacingObj.Period_End_Date__c);
                        system.debug('stageNameSelected ==' + stageNameSelected);
                        system.debug('pipelineGroupServiceSelected ==' + pipelineGroupServiceSelected);
                        system.debug('productNameSelected ==' + productNameSelected);
                        system.debug('contractTicketStatusSelected ==' + contractTicketStatusSelected);
                        
                        List <AggregateResult> allsalesrevenueTicketStatusproducttrure = [select AM__c, AM__r.name AMname, sum(Amount__c) amount 
                                                                                          from sales_revenue__c where type__c = 'Opportunity Product' 
                                                                                          and period_date__c >= :salesRacingObj.Period_Start_Date__c 
                                                                                          and period_date__c <= :salesRacingObj.Period_End_Date__c 
                                                                                          and opportunity_Stage__c in :stageNameSelected
                                                                                          and contract_ticket_status__c in :contractTicketStatusSelected
                                                                                          and group_service__r.name in :pipelineGroupServiceSelected 
                                                                                          and Product_Name__c in :productNameSelected
                                                                                          group by AM__r.name, AM__c
                                                                                          order by sum(amount__c) desc 
                                                                                          limit 25];
                        
                        allsalesrevenue = allsalesrevenueTicketStatusproducttrure;
                        
                        system.debug('allsalesrevenue pipeline ==  ' + allsalesrevenue);
                        if(allsalesrevenue == null || allsalesrevenue.isEmpty()){
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Data tidak ditemukan'));
                        }else{
                            integer counter = 1;    
                            
                            String pipelineGroupServiceWithComma = String.join(pipelineGroupServiceSelected, ',');
                            String productNameWithComma = String.join(productNameSelected, ',');
                            String productNumberWithComma = String.join(productNumberSelected, ',');
                            String contractTicketStatusWithComma = string.join(contractTicketStatusSelected, ',');
                            stageNameWithComma = String.join(stageNameSelected, ',');
                            
                            for (AggregateResult srvPipeline : allsalesrevenue){
                                
                                double amount = 0;
                                String AM ='';
                                String AMIDs = '';
                                amount = (double) srvPipeline.get('amount');
                                AM = (String) srvPipeline.get('AMname');
                                AMIDs = (String) srvPipeline.get('AM__c');
                                
                                
                                if(amount != null && amount != 0){
                                    String names = '0' + string.valueof(counter);
                                    
                                    AM_top_List__c topListObjs3 = new AM_top_List__c();
                                    topListObjs3.name = names.right(2) + '. ' + AM;
                                    topListObjs3.am__c = AMIDs;
                                    topListObjs3.amount__c = amount ;
                                    topListObjs3.sales_racing__c = salesRacingObj.Id;
                                    
                                    //-- generate report LINK 
                                    string startDate = String.valueOf(salesRacingObj.Period_Start_Date__c);
                                    string endDate = String.valueOf(salesRacingObj.Period_End_Date__c);
                                    
                                    string reportID = amTopListReportIdMaps.get(salesRacingObj.Data_Source__c);//'00ON0000001KZ1sMAG'; //todo : put on custom setting
                                    string fullReportUrl = '/lightning/r/Report/' + reportID + '/view?' +
                                        'fv0=' + 'Opportunity Product' + '&' +
                                        'fv1=' + startDate + '&' + 
                                        'fv2=' + endDate + '&' +
                                        'fv3=' + AMIDs.left(15) + '&' +
                                        'fv4=' + stageNameWithComma.replace('&', '%26') + '&'+
                                        'fv5=' + pipelineGroupServiceWithComma.replace('&', '%26') + '&'+
                                        
                                        //'fv6=' + productNameWithComma.replace('&' , '%26').replace(' ' , '%20').replace(',' , 
                                        //'%2C').replace('(', '%28').replace(')', '%29').replace('>', '%3E').replace('+', '%2B')
                                        
                                        'fv6=' + productNumberWithComma.replace('&' , '%26').replace(' ' , '%20').replace(',' , 
                                                                                                                          '%2C').replace('(', '%28').replace(')', '%29').replace('>', '%3E').replace('+', '%2B')
                                        + '&'+
                                        
                                        'fv7=' + contractTicketStatusWithComma.replace('&', '%26').replace(' ', '%20')
                                        ;
                                    
                                    integer urlLength = fullReportUrl.length();
                                    integer maxLength = 255;
                                    integer sisa = math.mod(urlLength, maxLength);
                                    integer groupCount =  urlLength/ maxLength;
                                    if (sisa>0) groupCount = groupCount + 1;
                                    system.debug ('==== groupCount : ' +  groupCount);
                                    
                                    integer startIndex=0;
                                    integer endIndex=255;
                                    for (integer strCounter=1; strCounter<=groupCount; strCounter++) {
                                        startIndex = (strCounter - 1 ) * 255;
                                        endIndex = strCounter * 255;
                                        if (endIndex > urlLength) endIndex = urlLength;
                                        
                                        system.debug ('==== strCounter : ' +  strCounter);
                                        system.debug ('==== startIndex : ' +  startIndex);
                                        system.debug ('==== endIndex : ' +  endIndex);
                                        system.debug ('==== hasil : ' +  fullReportUrl.substring(startIndex, endIndex));
                                        
                                        switch on strCounter {
                                            when 1 { topListObjs3.url1__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 2 { topListObjs3.url2__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 3 { topListObjs3.url3__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 4 { topListObjs3.url4__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 5 { topListObjs3.url5__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 6 { topListObjs3.url6__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 7 { topListObjs3.url7__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 8 { topListObjs3.url8__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 9 { topListObjs3.url9__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 10 { topListObjs3.url10__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 11 { topListObjs3.url11__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 12 { topListObjs3.url12__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 13 { topListObjs3.url13__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 14 { topListObjs3.url14__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 15 { topListObjs3.url15__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 16 { topListObjs3.url16__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 17 { topListObjs3.url17__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 18 { topListObjs3.url18__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 19 { topListObjs3.url19__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 20 { topListObjs3.url20__c = fullReportUrl.substring(startIndex, endIndex);}
                                        }
                                    }
                                    
                                    amTopList.add(topListObjs3);
                                    
                                    counter ++;
                                }
                            }
                        }
                    }
                }
                if(StageNameWithComma.indexOf('closed won') < 0  || StageNameWithComma.indexOf('Waiting for Contract') < 0 ){
                    if(pipelineGroupServiceSelected == null || pipelineGroupServiceSelected.isEmpty() 	|| productNameSelected == null || productNameSelected.isEmpty()){
                        
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Filter perlu dipilih'));
                        
                    }else {
                        system.debug('masuk di pipeline all product false ===');
                        system.debug('salesRacingObj.Period_Start_Date__c' + salesRacingObj.Period_Start_Date__c);
                        system.debug('salesRacingObj.Period_End_Date__c' + salesRacingObj.Period_End_Date__c);
                        system.debug('stageNameSelected ==' + stageNameSelected);
                        system.debug('pipelineGroupServiceSelected ==' + pipelineGroupServiceSelected);
                        system.debug('productNameSelected ==' + productNameSelected);
                        system.debug('contractTicketStatusSelected ==' + contractTicketStatusSelected);
                        
                        List <AggregateResult> allsalesrevenueTicketStatusFalse = [select AM__c, AM__r.name AMname, sum(Amount__c) amount 
                                                                                   from sales_revenue__c where type__c = 'Opportunity Product' 
                                                                                   and period_date__c >= :salesRacingObj.Period_Start_Date__c 
                                                                                   and period_date__c <= :salesRacingObj.Period_End_Date__c 
                                                                                   and opportunity_Stage__c in :stageNameSelected
                                                                                   and group_service__r.name in :pipelineGroupServiceSelected 
                                                                                   and Product_Name__c in :productNameSelected
                                                                                   group by AM__r.name, AM__c
                                                                                   order by sum(amount__c) desc 
                                                                                   limit 25];
                        
                        allsalesrevenue = allsalesrevenueTicketStatusFalse;
                        
                        system.debug('allsalesrevenue pipeline ==  ' + allsalesrevenue);
                        if(allsalesrevenue == null || allsalesrevenue.isEmpty()){
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Data tidak ditemukan'));
                        }else{
                            integer counter = 1;    
                            
                            String pipelineGroupServiceWithComma = String.join(pipelineGroupServiceSelected, ',');
                            String productNameWithComma = String.join(productNameSelected, ',');
                            String productNumberWithComma = String.join(productNumberSelected, ',');
                            String contractTicketStatusWithComma = string.join(contractTicketStatusSelected, ',');
                            stageNameWithComma = String.join(stageNameSelected, ',');
                            
                            for (AggregateResult srvPipeline : allsalesrevenue){
                                
                                double amount = 0;
                                String AM ='';
                                String AMIDs = '';
                                amount = (double) srvPipeline.get('amount');
                                AM = (String) srvPipeline.get('AMname');
                                AMIDs = (String) srvPipeline.get('AM__c');
                                
                                
                                if(amount != null && amount != 0){
                                    String names = '0' + string.valueof(counter);
                                    
                                    AM_top_List__c topListObjs4 = new AM_top_List__c();
                                    topListObjs4.name = names.right(2) + '. ' + AM;
                                    topListObjs4.am__c = AMIDs;
                                    topListObjs4.amount__c = amount ;
                                    topListObjs4.sales_racing__c = salesRacingObj.Id;
                                    
                                    //-- generate report LINK 
                                    string startDate = String.valueOf(salesRacingObj.Period_Start_Date__c);
                                    string endDate = String.valueOf(salesRacingObj.Period_End_Date__c);
                                    
                                    string reportID = amTopListReportIdMaps.get(salesRacingObj.Data_Source__c);//'00ON0000001KZ1sMAG'; //todo : put on custom setting
                                    string fullReportUrl = '/lightning/r/Report/' + reportID + '/view?' +
                                        'fv0=' + 'Opportunity Product' + '&' +
                                        'fv1=' + startDate + '&' + 
                                        'fv2=' + endDate + '&' +
                                        'fv3=' + AMIDs.left(15) + '&' +
                                        'fv4=' + stageNameWithComma.replace('&', '%26') + '&'+
                                        'fv5=' + pipelineGroupServiceWithComma.replace('&', '%26') + '&'+
                                        
                                        //'fv6=' + productNameWithComma.replace('&' , '%26').replace(' ' , '%20').replace(',' , 
                                        //'%2C').replace('(', '%28').replace(')', '%29').replace('>', '%3E').replace('+', '%2B')
                                        
                                        'fv6=' + productNumberWithComma.replace('&' , '%26').replace(' ' , '%20').replace(',' , 
                                                                                                                          '%2C').replace('(', '%28').replace(')', '%29').replace('>', '%3E').replace('+', '%2B')
                                        + '&'+
                                        
                                        'fv7=' + contractTicketStatusWithComma.replace('&', '%26').replace(' ', '%20')
                                        ;
                                    
                                    integer urlLength = fullReportUrl.length();
                                    integer maxLength = 255;
                                    integer sisa = math.mod(urlLength, maxLength);
                                    integer groupCount =  urlLength/ maxLength;
                                    if (sisa>0) groupCount = groupCount + 1;
                                    system.debug ('==== groupCount : ' +  groupCount);
                                    
                                    integer startIndex=0;
                                    integer endIndex=255;
                                    for (integer strCounter=1; strCounter<=groupCount; strCounter++) {
                                        startIndex = (strCounter - 1 ) * 255;
                                        endIndex = strCounter * 255;
                                        if (endIndex > urlLength) endIndex = urlLength;
                                        
                                        system.debug ('==== strCounter : ' +  strCounter);
                                        system.debug ('==== startIndex : ' +  startIndex);
                                        system.debug ('==== endIndex : ' +  endIndex);
                                        system.debug ('==== hasil : ' +  fullReportUrl.substring(startIndex, endIndex));
                                        
                                        switch on strCounter {
                                            when 1 { topListObjs4.url1__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 2 { topListObjs4.url2__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 3 { topListObjs4.url3__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 4 { topListObjs4.url4__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 5 { topListObjs4.url5__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 6 { topListObjs4.url6__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 7 { topListObjs4.url7__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 8 { topListObjs4.url8__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 9 { topListObjs4.url9__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 10 { topListObjs4.url10__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 11 { topListObjs4.url11__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 12 { topListObjs4.url12__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 13 { topListObjs4.url13__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 14 { topListObjs4.url14__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 15 { topListObjs4.url15__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 16 { topListObjs4.url16__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 17 { topListObjs4.url17__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 18 { topListObjs4.url18__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 19 { topListObjs4.url19__c = fullReportUrl.substring(startIndex, endIndex);}
                                            when 20 { topListObjs4.url20__c = fullReportUrl.substring(startIndex, endIndex);}
                                        }
                                    }
                                    
                                    amTopList.add(topListObjs4);
                                    
                                    counter ++;
                                }
                            }
                        }
                    }
                }
                
                
            }
            
        }
        
        catch(Exception e){
            string notes = 'Error on SalesRacingController.getAMTopDataList method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
        
        
    }
    
    
    public void saveAMTopList () {
        system.debug('=== in saveAMTopList method ===='); 
        List<AM_top_list__c> amTopList = [select id, name, Amount__c from am_top_list__c where sales_racing__c = :salesRacingObj.id];       
        try {
            
            //-- delete first ---
            
            if(amTopList.size() > 0 || amTopList.size() != null){
                delete amTopList;    
            }
            
            // -- insert AM Top list Data ---
            system.debug ('this.amTopList : ' + this.amTopList);
            insert this.amTopList;
            
            
            switch on salesRacingObj.data_source__c {
                
                when 'Revenue'{
                    
                    salesRacingObj.group_services__c = string.join(revGroupServiceSelected, '\n');
                    salesRacingObj.revenue_category__c = string.join(revCategoryNameSelected, '\n');
                    
                    
                }
                when 'Subscribe'{
                    
                    salesRacingObj.service__c = string.join(serviceSelected, '\n');
                    salesRacingObj.group_price_plans__c = string.join(groupPricePlanSelected, '\n');
                    
                    
                }
                
                when 'Link' {
                    salesRacingObj.Link_Service_Type__c = string.join(linkServiceTypeSelected, '\n');
                    system.System.debug('linkServiceTypeSelected == masuk');
                    
                    
                }
                
                when 'Pipeline' {
                    if(salesRacingObj.all_product__c == false){
                        salesRacingObj.group_services__c = string.join(pipelineGroupServiceSelected, '\n');
                        salesRacingObj.Product_Name__c = string.join(productNameSelected  , '\n');
                        salesRacingObj.stages__c = string.join(stageNameSelected  , '\n');
                        if(contractTicketStatusSelected != null){
                            salesRacingObj.contract_ticket_status__c = string.join(contractTicketStatusSelected, '\n');
                        }else{
                            salesRacingObj.contract_ticket_status__c = '';
                        }
                       
                        
                    }else if(salesRacingObj.all_product__c == true){
                        
                        salesRacingObj.group_services__c = string.join(pipelineGroupServiceSelected, '\n');
                        if(productNameSelected != null){
                            salesRacingObj.Product_Name__c = string.join(productNameSelected  , '\n');
                        }else{
                            salesRacingObj.Product_Name__c = '';
                        }
                        salesRacingObj.stages__c = string.join(stageNameSelected  , '\n');

                        if(contractTicketStatusSelected != null){
                            salesRacingObj.contract_ticket_status__c = string.join(contractTicketStatusSelected, '\n');
                        }else{
                            salesRacingObj.contract_ticket_status__c = '';
                        }                        
                        
                    }
                    
                }
                
            }
            
            system.debug('**salesRacingObj **' + salesRacingObj);
            salesRacingObj.as_of_date__c = system.now();
            update salesRacingObj;
            
        }
        catch(Exception e){
            
            string notes = 'Error on SalesRacingController.saveAMTopList method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
    
    public void saveParameterAMTopList () {
        
        system.debug('=== in saveParameterAMTopList method ===='); 
        
        try {
            
            
            switch on salesRacingObj.data_source__c {
                
                when 'Revenue'{
                    
                    salesRacingObj.group_services__c = string.join(revGroupServiceSelected, '\n');
                    salesRacingObj.revenue_category__c = string.join(revCategoryNameSelected, '\n');
                    
                    
                }
                when 'Subscribe'{
                    
                    salesRacingObj.service__c = string.join(serviceSelected, '\n');
                    salesRacingObj.group_price_plans__c = string.join(groupPricePlanSelected, '\n');
                    
                    
                }
                
                when 'Link' {
                    salesRacingObj.Link_Service_Type__c = string.join(linkServiceTypeSelected, '\n');
                    system.System.debug('linkServiceTypeSelected == masuk');
                    
                    
                }
                
                when 'Pipeline' {
                    if(salesRacingObj.all_product__c == false){
                        salesRacingObj.group_services__c = string.join(pipelineGroupServiceSelected, '\n');
                        salesRacingObj.Product_Name__c = string.join(productNameSelected  , '\n');
                        salesRacingObj.stages__c = string.join(stageNameSelected  , '\n');
                        if(contractTicketStatusSelected != null){
                            salesRacingObj.contract_ticket_status__c = string.join(contractTicketStatusSelected, '\n');
                        }
                        
                        
                    }else if(salesRacingObj.all_product__c == true){
                        
                        salesRacingObj.group_services__c = string.join(pipelineGroupServiceSelected, '\n');
                        //salesRacingObj.Product_Name__c = string.join(productNameSelected  , '\n');
                        salesRacingObj.stages__c = string.join(stageNameSelected  , '\n');
                        if(contractTicketStatusSelected != null ){
                            salesRacingObj.contract_ticket_status__c = string.join(contractTicketStatusSelected, '\n');
                        }
                        
                    }
                    
                    
                }
                
            }
            
            system.debug('**salesRacingObj **' + salesRacingObj);
            salesRacingObj.as_of_date__c = system.now();
            update salesRacingObj;
            
        }
        catch(Exception e){
            
            string notes = 'Error on SalesRacingController.saveParameterAMTopList method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            string errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }
    }
    
}