public class MSISDNController {

    // the results from the search. do not init the results or a blank rows show up initially on page load
    public List<MSISDN__c> searchResults {get;set;}
    //public List<MSISDN__c> searchResults2 {get;set;}
        
    string accID = '';
    string oppID = '';
    public boolean reqToDelete {get;set;}
    public boolean reqToAdd {get;set;}
    public boolean reqToUpload {get;set;}


    public string msisdn {get;set;}
    public string iccid {get;set;}
    public string label {get;set;}
    
    public Blob csvFileBody{get;set;}

    // the categories that were checked/selected.
   /* public List<categoryWrapper> selectedCategories {
        get {
            if (selectedCategories == null) selectedCategories = new List<categoryWrapper>();
            return selectedCategories;
        }
        set;
    }*/      

    // the text in the search box
    public string searchText {
        get {
            if (searchText == null) searchText = ''; // prefill the serach box for ease of use
            return searchText;
        }
        set;
    } 

    // constructor
    public MSISDNController() { }
    public MSISDNController(ApexPages.StandardController controller) {
        reqToDelete = false ;
        Opportunity tmpopp = (Opportunity) controller.getRecord();
        oppID = tmpopp.id;

        Opportunity opp = [select id, Accountid from opportunity where id =:oppID ];
        accID = opp.Accountid;
        
        
        searchByOpportunity(accID, oppID, 'NOT ACTIVE' );
    }

    private void searchByOpportunity (string accID, string oppID, string type) {
        if (searchResults == null) {
            searchResults = new List<MSISDN__c>();
        } else {
            searchResults.clear();
        }
        String j= '%'+searchText +'%';        
        String qry= 'Select c.MSISDN_No__c, c.request_to_activate__c, c.Id, status_C, Account__c, Package_Activation_Opportunity__c, Simcard_Order_Opportunity__c ' +
            ' From MSISDN__c c Where c.MSISDN_No__c LIKE \'%' + searchText + '%\'' + 
            ' Order By c.MSISDN_No__c ' ;


        searchResults = [Select name, c.MSISDN_No__c, 
                request_to_activate__c, c.Id , 
                status__C, Account__c, Package_Activation_Opportunity__c, 
                Simcard_Order_Opportunity__c, Added_Manually__c
            From MSISDN__c c 
            Where c.name LIKE :j 
                AND Account__c =:accID
                and (status__C <> 'Active' or status__C = null or status__C ='')
                AND ( (request_to_activate__c = false AND  Account__c =:accID ) // yang belum request to active  
                        OR
                      (request_to_activate__c = true AND  Package_Activation_Opportunity__c =:oppID ) //request to active milik opportunity ini sendiri     
                    )
                
            Order By request_to_activate__c desc, c.MSISDN_No__c];

        system.debug('===================== searchResults : ' + searchResults);    
        system.debug('===================== searchResults : ' + j + '---' +  accID);    
    }    

    // fired when the search button is clicked
    public PageReference search() { return null; }
    
    public PageReference searchNotActive() {
        /*
        if (searchResults == null) {
            searchResults = new List<MSISDN__c>();            
        } else {
            searchResults.clear();
        }
        String j= '%'+searchText +'%';
        
        //String qry = 'Select c.Name, c.Id From Cat3__c c Where c.Name LIKE ' + j +' Order By c.Name';
        String qry= 'Select c.MSISDN_No__c, c.request_to_activate__c, c.Id From MSISDN__c c Where c.MSISDN_No__c LIKE \'%' + searchText + '%\'' + ' Order By c.MSISDN_No__c ' ;
        searchResults = [Select c.MSISDN_No__c,request_to_activate__c, c.Id From MSISDN__c c Where c.MSISDN_No__c LIKE :j Order By c.MSISDN_No__c];

        */

        searchByOpportunity(accID, oppID, 'NOT ACTIVE' );
        return null;
        
    }   
    public PageReference save() {
        
        //update searchResults;
        //searchResults.clear();
        //searchResults = [select id, msisdn_no__c, activate__c from msisdn__c limit 2];      
        
        update searchResults; 
        return null;
        
    }
    public PageReference NeedToAdd(){
        reqToAdd = true ;
        //reqToUpload = true ;
        return null;
    }

    public PageReference NeedToUpload(){
        reqToUpload = true ;
        //reqToAdd = true ;
        return null;
    }


    public PageReference toDelete() {
        List<MSISDN__c> tmpMSISDNs = new List<MSISDN__c>();

        for (MSISDN__c msisdn : searchResults) {
            if ( msisdn.request_to_activate__c && msisdn.Added_Manually__c  ) {
                tmpMSISDNs.add(msisdn);
            }
        }
        try {
            delete tmpMSISDNs;
            searchByOpportunity(accID, oppId, 'NOT ACTIVE' );
            
        } catch (DmlException e) {
            // Process exception here
            string errMessage = 'Error on delete misisdn at activation opportunity.::' 
                + e.getmessage() + '::' + e.getLineNumber() ;
            system.debug('==================== error message : ' + errMessage);
            AppUtils.putError(errMessage );
        }

        return null;
    }
    public PageReference toActivate() {
        
        //update searchResults;
        //searchResults.clear();
        //searchResults = [select id, msisdn_no__c, activate__c from msisdn__c limit 2];      
        
        /*
        c.MSISDN_No__c, 
                request_to_activate__c, c.Id , 
                status__C, Account__c, Package_Activation_Opportunity__c, Simcard_Order_Opportunity__c
*/
        for (MSISDN__c msisdn : searchResults) {
            system.debug('========== msisdn name : ' + msisdn.name );
            system.debug('========== msisdn status : ' + msisdn.status__C );
            system.debug('========== msisdn account : ' + msisdn.Account__c );
            system.debug('========== msisdn RTA : ' + msisdn.request_to_activate__c );
            system.debug('========== msisdn name : ' + msisdn.name );

            if ( msisdn.request_to_activate__c) {
                msisdn.Package_Activation_Opportunity__c = oppID;
            } else {
                msisdn.Package_Activation_Opportunity__c = null;
            }
            
        }

        update searchResults; 
        return null;
        
    }

    public PageReference cancel() {
        reqToAdd = false ;
        reqToUpload = false ;
        return null;
    }    

    public PageReference cancelUpload() {
        reqToAdd = false ;
        reqToUpload = false ;
        return null;
    }    


    public PageReference add() {

        /*
        PageReference addMSISDNPage = new PageReference('/apex/VF_Add_MSISDN');
        addMSISDNPage.setRedirect(true);
        return addMSISDNPage;        
        */
        List<MSISDN__c> tmpmsisdns = new List<MSISDN__c>();

        MSISDN__C tmpmsisdn = new MSISDN__c();
        tmpmsisdn.name=msisdn;
        tmpmsisdn.label__C= label;
        tmpmsisdn.iccid__c = iccid;
        tmpmsisdn.account__C = accID;
        tmpmsisdn.Package_Activation_Opportunity__c = oppID;
        
        tmpmsisdn.request_to_activate__c = true;
        tmpmsisdn.Added_Manually__c = true;
        tmpmsisdns.add (tmpmsisdn);

        insert tmpmsisdns;
        searchByOpportunity(accID, oppID, 'NOT ACTIVE' );
        reqToAdd = false ;

        return null;
    }
    
    public void importMSISDN(){
        List <String> msisdnDataLines = new List<String>();
        Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
        
        //public List<String> lstFieldNames{get;set;}
        List<String> lstFieldNames = new List<String>();
        MSISDN__c msisdnObj = new MSISDN__c();
        List<MSISDN__c> lstMSISDNs = new List<MSISDN__c>(); 
        Integer fieldNumber;
        String fieldValue;
        
        List<string>tmplstMSISDNNumbers = new list<string>();
        string tmpmsisdn ;
        
        /*
        1. bulk upload Add New msisdn 
        2. bulk upload set msisdn for activation (ini perlu validasi msisdn dari list upload vs Simcard Order)
        */
        
        try{
            string msisdnFileAsString = csvFileBody.toString();
            //readCSVFile();
            msisdnDataLines  = msisdnFileAsString.split('\n');
            string[] csvFieldNames = msisdnDataLines[0].split(',');
            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                fieldNumberMap.put(csvFieldNames[i], i);
                lstFieldNames.add(csvFieldNames[i].trim());
            }
            for (Integer i = 1; i < msisdnDataLines.size(); i++) {
                //conObj = new Contact();
                msisdnObj = new MSISDN__c();
                
                string[] csvRecordData = msisdnDataLines[i].split(',');
                //-- loop for FIELDS
                for (String fieldName: csvFieldNames) {
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    //msisdnObj.put(fieldName.trim(), fieldValue.trim());
                 
                    if (fieldName.trim() == 'MSISDN') {
                        tmpmsisdn = fieldValue.trim().replace('\'','');
                        msisdnObj.put('name', tmpmsisdn );
                        tmplstMSISDNNumbers.add (tmpmsisdn); //<-- for query existing msisdn
                    }
                    if (fieldName.trim() == 'ICCID') msisdnObj.put('iccid__c', fieldValue.trim().replace('\'',''));
                    if (fieldName.trim() == 'LABEL') msisdnObj.put('label__c', fieldValue.trim().replace('\'',''));
                    
                }
                
                msisdnObj.put('Account__c', accID);
                msisdnObj.put('Package_Activation_Opportunity__c', oppID);
                msisdnObj.put('Request_to_Activate__c', true);
                msisdnObj.put('Added_Manually__c', true);   
                
                lstMSISDNs.add(msisdnObj); 
                               
            }
            
            //--- query for existing msisdns
            List<MSISDN__c> existingMSISDNs = [select id, Package_Activation_Opportunity__c, Request_to_Activate__c
                     from msisdn__c where name in :tmplstMSISDNNumbers AND account__c =:accID and Request_to_Activate__c = false];
            for (MSISDN__c msisdn : existingMSISDNs) {
                msisdn.Package_Activation_Opportunity__c = oppID;
                msisdn.Request_to_Activate__c =true;
            }
            //--- if there is ezisting data
            if (existingMSISDNs.size()>0) update existingMSISDNs;    

            // DML (Database) statement
            Database.SaveResult[] srList = Database.insert(lstMSISDNs, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted MSISDN. MSISDN ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            //-- call search method to refresh new data
            searchByOpportunity(accID, oppID, 'NOT ACTIVE' );
            
            /*
            try {
                insert lstMSISDNs;
            }        
            catch(exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMessage);
            }
            */
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'Import successfull');
            ApexPages.addMessage(msg);
        }
        catch(exception e){
            //readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file');
            ApexPages.addMessage(errorMessage);
        }
    } 

}