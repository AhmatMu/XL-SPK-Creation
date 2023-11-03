trigger Trigger_ChangePriceLink on Change_Price_Link__c (after delete, after update) {
    //if (label.Trigger_ChangePriceLink_When_Deleted_ON == 'YES') {
    if (trigger.isAfter){
        if (trigger.isDelete) {
            
            String changePriceID ='';
            for(Change_Price_Link__c cpl : Trigger.old) {
                changePriceID= cpl.Change_Price__c;
            }            
            
            
            
            
            //-- ** Grouping cpls data by Bandwidth and UoM ** --
            ChangePriceLinkGroup_Controller cplgConn = new ChangePriceLinkGroup_Controller();
            cplgConn.createGroupRecords (changePriceID);
            
            
            /*
            //-- delete first
            List<Change_Price_Link_Group__c > cplgs = [select id from Change_Price_Link_Group__c where change_price__c =:changePriceID];
            system.debug ('=========== cplgs-1 :' + cplgs);
            if (cplgs.size()>0) { delete cplgs; }
            
            cplgs = [select id from Change_Price_Link_Group__c where change_price__c =:changePriceID];
            system.debug ('=========== cplgs-2 :' + cplgs);
            
            //-- insert group
            AggregateResult[] tmpCplgs = [select Bandwidth__c, UOM__c  from Change_Price_Link__c 
                where change_price__c =:changePriceID group by Bandwidth__c, UOM__c];
            
            if (tmpCplgs.size() > 0 ) {
                system.debug ('=========== tmpCplgs :' + tmpCplgs);
                for (AggregateResult tmpCplg: tmpCplgs) {
                    string bandWidth = (string) tmpCplg.get('Bandwidth__c');
                    string uom = (string) tmpCplg.get('UOM__c');
                    
                    Change_Price_Link_Group__c cplg = new Change_Price_Link_Group__c ();
                    //cplg.name = bandWidth ;
                    cplg.bandwidth__c = bandWidth ;
                    cplg.UOM__c   = uom;
                    cplg.Change_Price__c = changePriceID;
                    
                    cplgs.add(cplg); 
                }
                system.debug ('=========== cplgs-3 :' + cplgs);
                
                //-- TODO: add send email to administrator on error 
                try {
                    insert cplgs;
                } 
                catch (Exception e) {
                    errMessage = 'Error on Trigger_ChangePriceLink.::' + e.getmessage() + '::' + e.getLineNumber() ;
                    system.debug('==================== error message : ' + errMessage);
                    AppUtils.putError(errMessage );
                }
            }    
            
            */        
        }
    }      
    
    
     if (trigger.isAfter){
        if (trigger.isUpdate) {
        	
        	//-- if any update on Effective_Start_Date__c, To_Be_Autorenewal__c, and Selling_Price__c then update CONTRACT 
        	
        	Map <string, Date> mapDataStartDate = new Map <string,Date> {};
        	Map <string, boolean> mapDataAutoRenewal = new Map <string,boolean> {};
        	Map <string, decimal> mapDataPrice = new Map <string, decimal> {};
        	
        	list <string>  contractIDs = new List<string>();  
        	     	        	
        	for (Change_Price_Link__c CPLNew :system.trigger.new) {
	        	//-- get old change price link record -> CPLOld            
                Change_Price_Link__c CPLOld =Trigger.oldMap.get(CPLNew.id);
	        	
	        	
	        	system.debug ('============ CPLNew.Effective_Start_Date__c <> CPLOld.Effective_Start_Date__c : ' + CPLNew.Effective_Start_Date__c + ' ' + CPLOld.Effective_Start_Date__c);
	        	system.debug ('============ CPLNew.To_Be_Autorenewal__c <> CPLOld.To_Be_Autorenewal__c : ' + CPLNew.To_Be_Autorenewal__c + ' '+ CPLOld.To_Be_Autorenewal__c);
	        	system.debug ('============ CPLNew.Selling_Price__c <> CPLOld.Selling_Price__c : ' + CPLNew.Selling_Price__c + ' ' + CPLOld.Selling_Price__c );
	        		
	        	if ( (CPLNew.Effective_Start_Date__c <> CPLOld.Effective_Start_Date__c ) ||
	        			 (CPLNew.To_Be_Autorenewal__c <> CPLOld.To_Be_Autorenewal__c ) ||
	        			 (CPLNew.Selling_Price__c <> CPLOld.Selling_Price__c ) ) {
	        			 	
	        		mapDataStartDate.put(CPLNew.Contract__c, CPLNew.Effective_Start_Date__c);
	        		mapDataAutoRenewal.put(CPLNew.Contract__c, CPLNew.To_Be_Autorenewal__c);
	        		mapDataPrice.put(CPLNew.Contract__c, CPLNew.Selling_Price__c);

	        		contractIDs.add(CPLNew.Contract__c);
	        	}
	        	
        	}
        	system.debug ('============ contractIDs : ' + contractIDs);
        	
        	
        	List<Contract> contracts = [select id, Start_Date__c, Auto_Renewal__c, Price__c from Contract where id =:contractIDs];
        	for (Contract ctr: contracts ){
        		ctr.Start_Date__c = mapDataStartDate.get(ctr.id);
        		ctr.Auto_Renewal__c = mapDataAutoRenewal.get(ctr.id);
        		ctr.Price__c = mapDataPrice.get(ctr.id);
        	}
        	update contracts;
        	
        }
     }
    //}
}