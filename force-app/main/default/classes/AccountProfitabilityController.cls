/* ====================================================================================================
 * Class Name		        : AccountProfitabilityController
 * Test Class		        : AccountProfitabilityController_Test
 * Created By		        : Novando Utoyo Agmawan
 * Created Date		        : 06/2021
 * Created Description		: - 
 * 					          - 
 * Updated By               :
 * Updated Date	            :
 * Updated Description		: - 
 * 					          - 
 * ====================================================================================================
 */

public class AccountProfitabilityController {
    public String accountId {get;set;}
    public List<OpportunityWrapper> oppsw = new List<OpportunityWrapper>();
    public List<User> usrs;
    public List<Profitability__c> selectedOpportunities {get;set;}
    public Set<String> opportunityListIds {get;set;}
    public Set<String> selectedOpportunityListIds {get;set;}


    public Decimal Total_DealPrice_Actual {get; set;}
    public Decimal Total_OneTimeRevenue_Actual {get; set;}
    public Decimal Total_TotalAllCost_Actual {get; set;}
    public Decimal Total_Margin_Actual {get; set;}
    public Decimal Total_Pnl_Actual {get; set;}

    public Decimal Total_DealPrice_Actual_2 {get; set;}
    public Decimal Total_OneTimeRevenue_Actual_2 {get; set;}
    public Decimal Total_TotalAllCost_Actual_2 {get; set;}
    public Decimal Total_Margin_Actual_2 {get; set;}
    public Decimal Total_Pnl_Actual_2 {get; set;}

    public Decimal Total_DealPrice_Forecast {get; set;}
    public Decimal Total_OneTimeRevenue_Forecast {get; set;}
    public Decimal Total_TotalAllCost_Forecast {get; set;}
    public Decimal Total_Margin_Forecast {get; set;}
    public Decimal Total_Pnl_Forecast {get; set;}


    public Boolean RenderPage {get; set;}
    
    public class OpportunityWrapper{
        public Profitability__c opp{get;set;}
        public Boolean isSelected{get;set;}
        
        public OpportunityWrapper(Profitability__c o){
            opp = o;
            isSelected = false;
        }
    }

    //limited display list
    public List<OpportunityWrapper> oppsToshow;
    
    //Navigation Variables
    Integer counter = 0;    // To track number of records parsed
    Integer limitSize = 30; // Number of records to be displayed
    Integer totalSize = 0;  // To store the total number of records available
    
    //Our collection of the class/wrapper objects OpportunityWrapper
    public List<OpportunityWrapper> OpportunityList {get; set;}
    
    
    public AccountProfitabilityController(ApexPages.StandardController controller){
        accountId = ApexPages.CurrentPage().getParameters().get('id');
        oppsToshow = new List<OpportunityWrapper>();
        Total_DealPrice_Forecast = 0;
        Total_OneTimeRevenue_Forecast = 0;
        Total_TotalAllCost_Forecast = 0;
        Total_Margin_Forecast = 0;
        Total_Pnl_Forecast = 0;

        Total_DealPrice_Actual = 0;
        Total_OneTimeRevenue_Actual = 0;
        Total_TotalAllCost_Actual = 0;
        Total_Margin_Actual = 0;
        Total_Pnl_Actual = 0;

        Total_DealPrice_Actual_2 = 0;
        Total_OneTimeRevenue_Actual_2 = 0;
        Total_TotalAllCost_Actual_2 = 0;
        Total_Margin_Actual_2 = 0;
        Total_Pnl_Actual_2 = 0;

        system.debug('accountId : '+ accountId);
        
        List<Profitability__c> opportunityList = 
        [SELECT Id, 
        Name, 
        Status__c,
        Stage__c,
        Margin__c, 
        Deal_Price__c, 
        One_Time_Revenue__c,
        Total_All_Cost__c,
        Cost_Last_Update__c,
        Account__c,
        Opportunity__c, 
        Opportunity__r.StageName,
        Opportunity__r.Name,
        Opportunity__r.Service_Type__c,
        PNL__c
        FROM Profitability__c 
        WHERE Account__c =: accountId AND
        Opportunity__r.StageName != 'Closed Won' AND 
        Opportunity__r.StageName != 'Closed Lost' AND 
        Opportunity__r.StageName != 'Closed Not Delivered' AND
        Status__c = 'Forecast' AND 
        Stage__c = 'Forecast Cost is Complete' AND
        Opportunity__c != null
        ORDER BY Cost_Last_Update__c DESC];

        system.debug('opportunityList : '+ opportunityList);

        if(opportunityList!=null && !opportunityList.isEmpty()){
            opportunityListIds = new set<string>();
            for(Profitability__c opportunityList_Extract : opportunityList){
                oppsw.add(new OpportunityWrapper(opportunityList_Extract));
                opportunityListIds.add(opportunityList_Extract.Id);
            }

            AggregateResult[] AgR = 
            [SELECT
            SUM(Deal_Price_Contract__c), 
            SUM(One_Time_Revenue__c),
            SUM(Total_All_Cost__c),
            SUM(Margin__c),
            SUM(PNL__c)
            FROM Profitability__c 
            where Account__c =: accountId AND 
            Status__c = 'Actual' AND
            Status_Link__c != 'EXPIRED' AND
            Status_Link__c != 'DISMANTLED']; 

            if(AgR!=null && !AgR.isEmpty()){
                Total_DealPrice_Actual = (Decimal)AgR[0].get('expr0');
                Total_OneTimeRevenue_Actual = (Decimal)AgR[0].get('expr1');
                Total_TotalAllCost_Actual = (Decimal)AgR[0].get('expr2');
                Total_Margin_Actual = (Decimal)AgR[0].get('expr3');
                
                if (Total_Margin_Actual !=null && Total_DealPrice_Actual != null && Total_DealPrice_Actual != 0) {
                	Total_Pnl_Actual = Total_Margin_Actual / Total_DealPrice_Actual;
                } 
                else {
                    Total_Pnl_Actual =0;
                }
            }
        }

        totalSize = oppsw.size();
        
        if((counter+limitSize) <= totalSize){
            for(Integer i = 0; i<limitSize; i++)
                oppsToshow.add(oppsw.get(i));
            
        }
        else{
            for(Integer i=0;i<totalSize;i++)
                oppsToshow.add(oppsw.get(i));
            
        }

        List<Profitability__c> opportunityActualList = 
        [SELECT Id, 
        Status__c
        FROM Profitability__c 
        WHERE Account__c =: accountId AND
        Status__c = 'Actual' AND
        Status_Link__c != 'EXPIRED' AND
        Status_Link__c != 'DISMANTLED'];

        if(opportunityActualList!=null && !opportunityActualList.isEmpty()){
            AggregateResult[] AgR = 
            [SELECT
            SUM(Deal_Price_Contract__c), 
            SUM(One_Time_Revenue__c),
            SUM(Total_All_Cost__c),
            SUM(Margin__c),
            SUM(PNL__c)
            FROM Profitability__c 
            where Account__c =: accountId AND 
            Status__c = 'Actual' AND
            Status_Link__c != 'EXPIRED' AND
            Status_Link__c != 'DISMANTLED']; 

            if(AgR!=null && !AgR.isEmpty()){
                Total_DealPrice_Actual = (Decimal)AgR[0].get('expr0');
                Total_OneTimeRevenue_Actual = (Decimal)AgR[0].get('expr1');
                Total_TotalAllCost_Actual = (Decimal)AgR[0].get('expr2');
                Total_Margin_Actual = (Decimal)AgR[0].get('expr3');
                
                if (Total_Margin_Actual !=null && Total_DealPrice_Actual != null && Total_DealPrice_Actual != 0) {
                    Total_Pnl_Actual = Total_Margin_Actual / Total_DealPrice_Actual; 
                } else {
                    Total_Pnl_Actual = 0;
                }
            }
        }

        RenderPage = false;
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;

        List<ProfitabilityController__c> ProfitabilityControllerList = [SELECT Name, Profile_Name__c, Additional_toAddress__c, Additional_toCCAddress__c FROM ProfitabilityController__c WHERE Name =: 'AccountProfitabilityPage_Profile'];

        List<String> profileNameList = ProfitabilityControllerList[0].Profile_Name__c.split(','); 

        for(String profileNameList_extract : profileNameList){
            if(profileNameList_extract == profileName){
                RenderPage = true;
            }
        }
    }
    
    
    //Navigation methods
    
    public void beginning(){
        
        oppsToshow.clear();
        counter=0;
        if((counter + limitSize) <= totalSize){
            
            
            for(Integer i=0;i<limitSize;i++){
                oppsToshow.add(oppsw.get(i));
            }  
            
        } else{
            
            for(Integer i=0;i<totalSize;i++){
                oppsToshow.add(oppsw.get(i));
            }      
            
        }
        
    }
    
    public void next(){
        
        oppsToshow.clear();
        counter=counter+limitSize;
        
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+limitSize);i++){
                oppsToshow.add(oppsw.get(i));
            }
            
        } else{
            for(Integer i=counter;i<totalSize;i++){
                oppsToshow.add(oppsw.get(i));
            }
        }
    }
    
    public void previous(){
        
        oppsToshow.clear();
        
        counter=counter-limitSize;      
        
        for(Integer i=counter;i<(counter+limitSize); i++){
            oppsToshow.add(oppsw.get(i));
        }
    }
    
    public void last (){
        
        oppsToshow.clear();
        
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        } else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
        
        for(Integer i=counter-1;i<totalSize-1;i++){
            oppsToshow.add(oppsw.get(i));
        }
        
    }
    
    public Boolean getDisableNext(){
        
        if((counter + limitSize) >= totalSize )
            return true ;
        else
            return false ;
    }
    
    public Boolean getDisablePrevious(){
        
        if(counter == 0)
            return true ;
        else
            return false ;
    }

    public Boolean getDisableSelectAll(){
        
        if(totalSize == 0)
            return true ;
        else
            return false ;
    }

    public Boolean getRenderPage(){
        return RenderPage;
    }
    
    public List <OpportunityWrapper> getOpps(){
        return oppsToshow;
    }
    
    public PageReference processSelected() {
        System.debug('entering processing ..');
        //We create a new list of Opportunity that wil be populated only with Opportunity if they are selected
        selectedOpportunities = new List<Profitability__c>();
        selectedOpportunityListIds = new Set<String>();
        Set<String> profitability_LinkIds = new Set<String>();
        
        //We will cycle through our list of OpportunityWrapper and will check to see if the selected property is set to true, if it is we add the Opportunity to the selectedOpportunities list
        for(OpportunityWrapper opp: getOpportunities()) {
            if(opp.isSelected == true) {
                System.debug('process going on');
                
                selectedOpportunities.add(opp.opp);
            }
        }
        
        // Now we have our list of selected Opportunity and can perform any type of logic we want, sending emails, updating a field on the Opportunity, etc
        System.debug('Results');
        for(Profitability__c opp: selectedOpportunities) {
            System.debug(opp);
            selectedOpportunityListIds.add(opp.Id);
        }

        if(selectedOpportunityListIds!=null && !selectedOpportunityListIds.isEmpty()){
            List<Profitability__c> profitabilityForecast_list = [
                SELECT Id,
                CID__c,
                Opportunity__c, 
                Opportunity__r.Service_Type__c
                FROM Profitability__c
                WHERE Id IN :selectedOpportunityListIds
            ];

            for(Profitability__c profitabilityForecast_list_extract : profitabilityForecast_list){
                if(profitabilityForecast_list_extract.Opportunity__r.Service_Type__c == 'Upgrade' || profitabilityForecast_list_extract.Opportunity__r.Service_Type__c == 'Downgrade'){
                    profitability_LinkIds.add(profitabilityForecast_list_extract.CID__c);
                }
            }

            if(profitability_LinkIds!=null && !profitability_LinkIds.isEmpty()){
                AggregateResult[] AgR1 = 
                [SELECT
                SUM(Deal_Price_Contract__c), 
                SUM(One_Time_Revenue__c),
                SUM(Total_All_Cost__c),
                SUM(Margin__c),
                SUM(PNL__c)
                FROM Profitability__c 
                where Account__c =: accountId AND 
                Status__c = 'Actual' AND
                Status_Link__c != 'EXPIRED' AND
                Status_Link__c != 'DISMANTLED' AND
                CID__c NOT IN : profitability_LinkIds]; 
    
                if(AgR1!=null && !AgR1.isEmpty()){
                    Total_DealPrice_Actual_2 = (Decimal)AgR1[0].get('expr0');
                    Total_OneTimeRevenue_Actual_2 = (Decimal)AgR1[0].get('expr1');
                    Total_TotalAllCost_Actual_2 = (Decimal)AgR1[0].get('expr2');
                    Total_Margin_Actual_2 = (Decimal)AgR1[0].get('expr3');
                    
                    if (Total_Margin_Actual_2 !=null && Total_DealPrice_Actual_2 != null && Total_DealPrice_Actual_2 != 0) {
                    	Total_Pnl_Actual_2 = Total_Margin_Actual_2 / Total_DealPrice_Actual_2;
                    }
                    else {
                        Total_Pnl_Actual_2 = 0;
                    }
                }
    
                AggregateResult[] AgR = 
                [SELECT
                SUM(Deal_Price_Contract__c) sumDealPrice, 
                SUM(One_Time_Revenue__c) sumOneTimeRev,
                SUM(Total_All_Cost__c) sumTotalCost,
                SUM(Margin__c) sumMargin,
                SUM(PNL__c)
                FROM Profitability__c 
                where Id IN :selectedOpportunityListIds]; 
        
                double sumDealPrice = (double) AgR[0].get('sumDealPrice');
                double sumOneTimeRev = (double) AgR[0].get('sumOneTimeRev');
                double sumTotalCost = (double) AgR[0].get('sumTotalCost');
                double sumMargin = (double) AgR[0].get('sumMargin');
                
                if (sumDealPrice == null) sumDealPrice = 0;
                if (sumOneTimeRev == null) sumOneTimeRev = 0;
                if (sumTotalCost == null) sumTotalCost = 0;
                if (sumMargin == null) sumMargin = 0;
                
                
                if(AgR!=null && !AgR.isEmpty()){
                    /*
                    Total_DealPrice_Forecast = (Decimal)AgR[0].get('expr0') + Total_DealPrice_Actual_2;
                    Total_OneTimeRevenue_Forecast = (Decimal)AgR[0].get('expr1') + Total_OneTimeRevenue_Actual_2;
                    Total_TotalAllCost_Forecast = (Decimal)AgR[0].get('expr2') + Total_TotalAllCost_Actual_2;
                    Total_Margin_Forecast = (Decimal)AgR[0].get('expr3') + Total_Margin_Actual_2;
                    Total_Pnl_Forecast = Total_Margin_Forecast / Total_DealPrice_Forecast;*/
                    
                    if (Total_DealPrice_Actual_2 == null) Total_DealPrice_Actual_2 = 0;
                    if (Total_OneTimeRevenue_Actual_2 == null) Total_OneTimeRevenue_Actual_2 = 0;
                    if (Total_TotalAllCost_Actual_2 == null) Total_TotalAllCost_Actual_2 = 0;
                    if (Total_Margin_Actual_2 == null) Total_Margin_Actual_2 = 0;
                    
                    Total_DealPrice_Forecast = Integer.valueOf (sumDealPrice) + Total_DealPrice_Actual_2;
                    Total_OneTimeRevenue_Forecast = Integer.valueOf (sumOneTimeRev ) + Total_OneTimeRevenue_Actual_2;
                    Total_TotalAllCost_Forecast = Integer.valueOf ( sumTotalCost ) + Total_TotalAllCost_Actual_2;
                    Total_Margin_Forecast = Integer.valueOf (sumMargin) + Total_Margin_Actual_2;
                    
                    if ( Total_DealPrice_Forecast != 0 ) {
                        Total_Pnl_Forecast = Total_Margin_Forecast / Total_DealPrice_Forecast;
                    } 
                    else {
                        Total_Pnl_Forecast = 0;
                    }
                    

                }
            }else{
                AggregateResult[] AgR = 
                [SELECT
                SUM(Deal_Price_Contract__c) sumDealPrice, 
                SUM(One_Time_Revenue__c) sumOneTimeRev,
                SUM(Total_All_Cost__c) sumTotalCost,
                SUM(Margin__c) sumMargin,
                SUM(PNL__c)
                FROM Profitability__c 
                where Id IN :selectedOpportunityListIds]; 
                
                Decimal sumDealPrice = (Decimal) AgR[0].get('sumDealPrice');
                Decimal sumOneTimeRev = (Decimal) AgR[0].get('sumOneTimeRev');
                Decimal sumTotalCost = (Decimal) AgR[0].get('sumTotalCost');
                Decimal sumMargin = (Decimal) AgR[0].get('sumMargin');
                
                if (sumDealPrice == null) sumDealPrice = 0;
                if (sumOneTimeRev == null) sumOneTimeRev = 0;
                if (sumTotalCost == null) sumTotalCost = 0;
                if (sumMargin == null) sumMargin = 0;
                
        
                if(AgR!=null && !AgR.isEmpty()){
                    /*
                    Total_DealPrice_Forecast = (Decimal)AgR[0].get('expr0') + Total_DealPrice_Actual;
                    Total_OneTimeRevenue_Forecast = (Decimal)AgR[0].get('expr1') + Total_OneTimeRevenue_Actual;
                    Total_TotalAllCost_Forecast = (Decimal)AgR[0].get('expr2') + Total_TotalAllCost_Actual;
                    Total_Margin_Forecast = (Decimal)gR[0].get('expr3') + Total_Margin_Actual;
                    Total_Pnl_Forecast = Total_Margin_Forecast / Total_DealPrice_Forecast;
					*/
                    
                    if (Total_DealPrice_Actual == null ) Total_DealPrice_Actual = 0;
                    if (Total_OneTimeRevenue_Actual == null ) Total_OneTimeRevenue_Actual = 0;
                    if (Total_TotalAllCost_Actual == null) Total_TotalAllCost_Actual = 0;
                    if (Total_Margin_Actual == null ) Total_Margin_Actual = 0;
                    
                    Total_DealPrice_Forecast = sumDealPrice + Total_DealPrice_Actual;
                    Total_OneTimeRevenue_Forecast = sumOneTimeRev + Total_OneTimeRevenue_Actual;
                    Total_TotalAllCost_Forecast = sumTotalCost + Total_TotalAllCost_Actual;
                    Total_Margin_Forecast = sumMargin + Total_Margin_Actual;
                    
                    if ( Total_DealPrice_Forecast != 0 ) {
                        Total_Pnl_Forecast = Total_Margin_Forecast / Total_DealPrice_Forecast;
                    } else {
                        Total_Pnl_Forecast = 0;
                    }   
                }
            }            
        }else{
            Total_DealPrice_Forecast = 0;
            Total_OneTimeRevenue_Forecast = 0;
            Total_TotalAllCost_Forecast = 0;
            Total_Margin_Forecast = 0;
            Total_Pnl_Forecast = 0;
        }
        
        OpportunityList=null; // we need this line if we performed a write operation  because getOpportunities gets a fresh list now
        return null;
    }
    
    //This method uses a simple SOQL query to return a List of Opportunity
    public List<OpportunityWrapper> getOpportunities() {
        if(OpportunityList == null) {
            OpportunityList = oppsw;
        }
        return OpportunityList;
    }
}