public class ChangePriceLinkGroup_Controller{  

    ApexPages.StandardSetController setCon;
    ApexPages.StandardController con;
    Change_Price_Link_Group__c selectedCPLG = new Change_Price_Link_Group__c ();
    
             
    public ChangePriceLinkGroup_Controller() {
     
    }
    public ChangePriceLinkGroup_Controller(ApexPages.StandardSetController controller) {
        setCon = controller;         
    }

    public ChangePriceLinkGroup_Controller(ApexPages.StandardController controller) {
        con = controller;
        
        Change_Price_Link_Group__c tmpCPLG = (Change_Price_Link_Group__c) con.getRecord();
        string changePriceLinkGroupID = tmpCPLG.id;
        
        selectedCPLG = [select id from Change_Price_Link_Group__c where id =:changePriceLinkGroupID ];
        
    }
    
    
    public void createGroupRecords (string changePriceID) {
        //-- ** Grouping cpls data by Bandwidth and UoM ** --
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
                
                string errMessage = 'Error on Trigger_ChangePriceLink.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }
        }  
        
        //return null;  
    
    }
     

    
 
}