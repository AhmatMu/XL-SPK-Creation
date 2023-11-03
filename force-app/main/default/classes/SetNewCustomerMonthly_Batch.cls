global class SetNewCustomerMonthly_Batch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    private Set<String> BPNos = new Set<String>();
    private list<sales_revenue__c> srvList  = new list<sales_revenue__c>();
    private Date startDate;
    private Date endDate;
    private string year;
    private string month;

    //global SetNewCustomerMonthly_Batch(Set<String> BPNos, Date startDate, Date endDate, list<sales_revenue__c> srvList) {
    global SetNewCustomerMonthly_Batch(Set<String> BPNos, Date periodDate, list<sales_revenue__c> srvList) {
        this.BPNos = BPNos;
        //this.startDate = startDate;
        //this.endDate = endDate;
        this.srvList = srvList;

        this.startDate = periodDate.addyears(-1);
		this.endDate = periodDate.adddays(-1);
		
		this.year = string.valueof(periodDate.year());
		this.month = string.valueof(periodDate.month());

    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('=== BPNos from start method '+ BPNos);
        System.debug('=== BPNos size from start method '+ BPNos.size());

        System.debug('=== startDate : '+ startDate);
        System.debug('=== endDate : '+ endDate);

        
        return Database.getQueryLocator([
            select Customer__c , is_new_Customer_t__c, year__c, customer_bp_no__c 
			from sales_revenue__c
			where recordtype.name ='actual revenue'
            and period_Date__c >= :startDate
            and period_Date__c <= :endDate
            and customer_bp_no__c in :BPNos
        ]); 
        
        /*return Database.getQueryLocator([
            select customer_bp_no__c 
			from sales_revenue__c
			where recordtype.name ='actual revenue'
            and period_Date__c >= :startDate
            and period_Date__c <= :endDate
            and customer_bp_no__c in :BPNos
            group by customer_bp_no__c
        ]);*/

    }

    global void execute(Database.BatchableContext BC,  List<sales_revenue__c> srvPrevList){
    //global void execute(Database.BatchableContext BC,  List<AggregateResult> srvPrevARList){
        if(srvPrevList!=null && !srvPrevList.isEmpty()) {
        //if(srvPrevARList!=null && !srvPrevARList.isEmpty()) {
            
            // 3. mapping
            Map <String, String> bpOnPrevPeriodMap = new Map <String, String> ();
            Set<String> bpOnPrevPeriodList = new Set<String>();
            
            for (sales_revenue__c srvObj : srvPrevList) {
                string isThere = bpOnPrevPeriodMap.get(srvObj.customer_bp_no__c);
                if (isThere == null) {
                    bpOnPrevPeriodMap.put(srvObj.customer_bp_no__c, 'ON previous');
                    bpOnPrevPeriodList.add (srvObj.customer_bp_no__c);
                }
            }
            system.debug ('=== bpOnPrevPeriodMap : ' + bpOnPrevPeriodMap);
            /*
            for (AggregateResult srvPrevAR : srvPrevARList) {
                string bpNo = (string) srvPrevAR.get('customer_bp_no__c');
                bpOnPrevPeriodMap.put(bpNo, 'ON previous');
            }
            system.debug ('=== bpOnPrevPeriodMap : ' + bpOnPrevPeriodMap);*/


            // 4. check 
            Map <String, String> bpNewCustomerMap = new Map <String, String> ();
            Set<String> bpNewCustomers = new Set<String>();
            for (String bpNo : BPNos) {
                string onPrevious = bpOnPrevPeriodMap.get(bpNo);
                if (onPrevious == null ) {
                    //-- ada
                    bpNewCustomerMap.put (bpNo, 'New Customer');
                    bpNewCustomers.add (bpNo);
                }
            }
            system.debug ('=== bpNewCustomerMap : ' + bpNewCustomerMap);
            

            // 5. tandai mana yang new customer atau bukan.
            /*
            for (sales_revenue__c srvObj : srvList) {
                string isNewCustomer = bpNewCustomerMap.get (srvObj.customer_bp_no__c);
                if ( isNewCustomer <> null ) {
                    srvObj.is_new_Customer_T__c = true;
                }
                else {
                    srvObj.is_new_Customer_T__c = false;
                }
            }*/
            /*
            List<sales_revenue__c> srvList = [select id, is_new_Customer_T__c  
                                                from sales_revenue__c
                                                where customer_bp_no__c in :bpNewCustomers
                                                    and recordtype.name ='actual revenue'
                                                    and month__c = :this.month
                                                    and year__c = :this.year ] ;
            */
            List<sales_revenue__c> srvTmpList = [select id, is_new_Customer_T__c  
                                                from sales_revenue__c
                                                where customer_bp_no__c in :bpOnPrevPeriodList
                                                    and recordtype.name ='actual revenue'
                                                    and month__c = :this.month
                                                    and year__c = :this.year ] ;
            

            for (sales_revenue__c srvObj : srvTmpList) {
                srvObj.is_new_Customer_T__c = false;
                /*string onPrevious = bpOnPrevPeriodMap.get (srvObj.customer_bp_no__c);
                if ( onPrevious <> null ) {
                    srvObj.is_new_Customer_T__c = false;
                }*/
            }

            system.debug ('=== srvTmpList.size() : ' + srvTmpList.size());
            system.debug ('=== srvTmpList : ' + srvTmpList);
            update srvTmpList ;
        }
    }
    
    global void finish(Database.BatchableContext BC){

    }



    //public Date periodDate;
    /*public List<sales_revenue__c> srvList;

    global SetNewCustomerMonthly_Batch(List<sales_revenue__c> srvList) {
        this.srvList = srvList;
    }

    global List<sales_revenue__c> start(Database.BatchableContext BC){
        return this.srvList;
    }
    global void execute(Database.BatchableContext BC,  List<sales_revenue__c> scope){
        //Database.update(scope, false);
    }
    
    global void finish(Database.BatchableContext BC){

    }*/
    
//    }
    /*
    global SetNewCustomerMonthly_Batch(Date periodDate) {
        this.periodDate = periodDate;
    }
    
    global Database.QueryLocator start (Database.BatchableContext bc) {

        String year ='2021';
		String month ='1';
		//Date periodDate = Date.NewInstance(integer.valueof(year), integer.valueof(month), 1);
		Date startDate = this.periodDate.addyears(-1);
		Date endDate = this.periodDate.adddays(-1);
		
		year = string.valueof(periodDate.year());
		month = string.valueof(periodDate.month());

		system.debug ('=== periodDate : ' + periodDate);
		system.debug ('=== year : ' + year);
		system.debug ('=== month : ' + month);
		
		// 1. get unique data ---
        String sqlString =  'select Customer__c , is_new_Customer_t__c, year__c, customer_bp_no__c '
			+ ' from sales_revenue__c ' 
			+ ' where recordtype.name =\'actual revenue\' ' 
			+ ' 	and month__c = \'' + month + '\''
			+ ' 	and year__c = \'' + year + '\'' ;
        
        system.debug ('=== sqlString : ' + sqlString);
        return Database.getQueryLocator(sqlString);

    }

    global void execute(Database.BatchableContext context, List<Link__c> linkList) {
      
    }

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        // todo: send email to system administrator
    }   
    */



}