public class ChangePriceLink_Controller{    
     
    ApexPages.StandardSetController setCon; 
    ApexPages.StandardController con;
    Change_Price_Link__c selectedCPL = new Change_Price_Link__c ();
    
    
    public List<link__c> linksList {get; set;}
    String customerID='' ;
    String accountHOID='' ;
    String accountHOBPNumber ='';
    String productCode='' ;
    //string changePriceID ='';
    public string changePriceID {get; set;}
    public Change_Price__c changePriceRecord {get;set;}
    
    public List<wrapLink > wraplinksList {get; set;}
    public List<wrapLink > wraplinksSisaList {get; set;}
    public List<wrapLink > wraplinksAllList {get; set;}


    public string wraplinksListJSON {get; set;}

    public List<string> linkIDUploadList = new List<string> ();
    
    public string cplcsvheader {get; set;}
    
    class wrapLink { 
        public link__c link {get; set;}
        public Boolean selected {get; set;}
        public string effectiveStartDate {get; set;}
        public boolean tobeAutoRenewal {get; set;}
        public boolean contractIsAvailable {get; set;}
        public boolean wrapIsDisable {get; set;}
        public string note {get; set;}
    }
    
    public class wrapLinkList {
    	public List<wrapLink> wrapLinks {get;set;}
    	
    }
    
    public ChangePriceLink_Controller() { 
    	system.debug ('==== masuk sini : ChangePriceLink_Controller() ');
    	wraplinksListJSON = apexpages.currentpage().getparameters().get('wraplinksListJSON');
        changePriceID = ApexPages.currentPage().getParameters().get('id');
        
    }

    public ChangePriceLink_Controller(ApexPages.StandardController controller) {
        system.debug ('==== masuk sini : ChangePriceLink_Controller(ApexPages.StandardController ');
        
        con = controller;    
        
        
        isRequestToUpload= false;
        
        Change_Price_Link__c tmpCPLink = (Change_Price_Link__c ) con.getRecord();
        string changePriceLinkID = tmpCPLink.id;
        selectedCPL = [select id from Change_Price_Link__c where id =:changePriceLinkID ];
    }
     
    public ChangePriceLink_Controller(ApexPages.StandardSetController controller) {
        setCon = controller;
        isRequestToUpload = false;
        
        system.debug ('==== masuk ChangePriceLink_Controller  StandardSetController ===='); 
        
        changePriceID = ApexPages.currentPage().getParameters().get('id');
        system.debug ('==== changePriceID : ' + changePriceID); 
        
        //String customerID = ApexPages.currentPage().getParameters().get('customer__c');
    	getChangePriceRecord(changePriceID);
    	getLinkList (changePriceID, null, null, null);
    }

    public void getChangePriceRecord (string changePriceID) {
        changePriceRecord = [SELECT id, name,
                                Links_string_1__c, Links_string_2__c, Links_string_3__c, Links_string_4__c, Links_string_5__c,
                                Links_string_6__c, Links_string_7__c, Links_string_8__c, Links_string_9__c, Links_string_10__c
                                from Change_Price__c WHERE  id =:changePriceID
                            ];
    }
    
    //-- GET LINK LIST TO SHOW UP IN PAGE FOR SELECTION PROCESS
    public void getLinkList (string changePriceID, 
    		Map <String, String> mapDataLinkUploaded,
    		Map <String, String> mapDataEffectiveDate, 
    		Map <String, String> mapDataToBeAutoRenewal) {    
        system.debug ('==== changePriceID :' + changePriceID );
        system.debug ('==== customerID :' + customerID );
        
        List<Change_Price__c> tmpCMPList = [select id, customer__r.Organization_type__c, customer__r.BP_Number__c, customer__c, customer__r.parentID, customer__r.parent.BP_Number__c, currency__c, product__c from change_price__c where id =:changePriceID ];
        if (tmpCMPList.size() >0){
            customerID = tmpCMPList[0].customer__c;
            accountHOID = tmpCMPList[0].customer__r.parentID ;
            
            if (tmpCMPList[0].customer__r.Organization_type__c == 'Branch')
	            accountHOBPNumber = tmpCMPList[0].customer__r.parent.BP_Number__c ;
    	    
    	    if (tmpCMPList[0].customer__r.Organization_type__c == 'Head Office')
	            accountHOBPNumber = tmpCMPList[0].customer__r.BP_Number__c ;
	                
            productCode = tmpCMPList[0].product__c;
            
            system.debug ('==== customerID :' + customerID );
            system.debug ('==== productCode :' + productCode );
            system.debug ('==== accountHOBPNumber :' + accountHOBPNumber );
            
            
            //-- Get existing Change-Price-Link items -- to to except on query in the LINK object
            List<Change_Price_Link__c> cpls = [select name from Change_Price_Link__c where Change_Price__c =:changePriceID];
            List<string> cplIDs = new List<String>();
            if (cpls.size()>0 ) {
                for (Change_Price_Link__c cpl : cpls) {
                    cplIDS.add(cpl.name);
                    
                }
            }
            system.debug ('==== cplIDS :' + cplIDS );

            integer maxLimitNumber = (integer) integer.valueof (system.label.Change_Price_Max_Limit_Number);
            
                        
            //-- Get Link List data where Account, Product, and Currency is related to Change Price (header) data
            //-- TODO: get start-contract-date, end-contract-Date from Contract (item) -- DONE
            List<link__c> tmpLinksUploadList = [select id, Link_ID__c, service_type__c , BP_Site_A__c, BP_Site_B__c, Capacity_Bandwidth__c, UoM__c, selected__c,
                    Site_A_Name__r.BP_Number__c, Site_A_Name__r.name, Site_A_Name__r.Unique_Name__c,
                    Contract_Item_Rel__c, Contract_Item_Rel__r.StartDate, Contract_Item_Rel__r.EndDate, 
                    Contract_Item_Rel__r.Start_Date__c, Contract_Item_Rel__r.End_Date__c,
                    Contract_Item_Rel__r.Start_Date_yyyy_mm_dd__c, Contract_Item_Rel__r.End_Date_yyyy_mm_dd__c, 
                    Contract_Item_Rel__r.Auto_Renewal__c
                from link__c 
                where (Parent_BP_Number__c =: accountHOBPNumber  OR Site_A_Name__r.BP_Number__c =:accountHOBPNumber)  
                    and service_type__c =:productCode 
                    and link_ID__c not in :cplIDS
                    and link_ID__c in : linkIDUploadList
                    order by Link_ID__c desc
                limit :maxLimitNumber
                ]; 
            
            integer limitNumber;
            limitNumber = maxLimitNumber - tmpLinksUploadList.size(); 


            List<link__c> tmplinksWithContractList = new List<link__c> ();
            List<link__c> tmplinksWithNOContractList = new List<link__c> ();

            if (limitNumber>0) {
                tmplinksWithContractList = [select id, Link_ID__c, service_type__c , BP_Site_A__c, BP_Site_B__c, Capacity_Bandwidth__c, UoM__c, selected__c,
                        Site_A_Name__r.BP_Number__c, Site_A_Name__r.name, Site_A_Name__r.Unique_Name__c,
                        Contract_Item_Rel__c, Contract_Item_Rel__r.StartDate, Contract_Item_Rel__r.EndDate, 
                        Contract_Item_Rel__r.Start_Date__c, Contract_Item_Rel__r.End_Date__c,
                        Contract_Item_Rel__r.Start_Date_yyyy_mm_dd__c, Contract_Item_Rel__r.End_Date_yyyy_mm_dd__c, 
                        Contract_Item_Rel__r.Auto_Renewal__c
                    from link__c 
                    where (Parent_BP_Number__c =: accountHOBPNumber  OR Site_A_Name__r.BP_Number__c =:accountHOBPNumber)  
                        and service_type__c =:productCode 
                        and link_ID__c not in :cplIDS 
                        and link_ID__c not in : linkIDUploadList 
                        and Contract_Item_Rel__c <> null
                    order by Link_ID__c desc
                    limit :limitNumber 
                    ]; 

                limitNumber = maxLimitNumber - tmplinksWithContractList.size(); 

                if (limitNumber>0) { 
                    tmplinksWithNOContractList = [select id, Link_ID__c, service_type__c , BP_Site_A__c, BP_Site_B__c, Capacity_Bandwidth__c, UoM__c, selected__c,
                        Site_A_Name__r.BP_Number__c, Site_A_Name__r.name, Site_A_Name__r.Unique_Name__c,
                        Contract_Item_Rel__c, Contract_Item_Rel__r.StartDate, Contract_Item_Rel__r.EndDate, 
                        Contract_Item_Rel__r.Start_Date__c, Contract_Item_Rel__r.End_Date__c,
                        Contract_Item_Rel__r.Start_Date_yyyy_mm_dd__c, Contract_Item_Rel__r.End_Date_yyyy_mm_dd__c, 
                        Contract_Item_Rel__r.Auto_Renewal__c
                    from link__c 
                    where (Parent_BP_Number__c =: accountHOBPNumber  OR Site_A_Name__r.BP_Number__c =:accountHOBPNumber)  
                        and service_type__c =:productCode 
                        and link_ID__c not in :cplIDS 
                        and link_ID__c not in : linkIDUploadList 
                        and Contract_Item_Rel__c = null
                    order by Link_ID__c desc
                    limit :limitNumber 
                    ]; 
                }
            }


            system.debug ('==== tmpLinksUploadList :' + tmpLinksUploadList );
            system.debug ('==== tmplinksWithContractList :' + tmplinksWithContractList );
            system.debug ('==== tmplinksWithNOContractList :' + tmplinksWithNOContractList );


            linksList = new List<link__c>();
            linksList.addAll(tmpLinksUploadList);
            linksList.addAll(tmplinksWithContractList);
            linksList.addAll(tmplinksWithNOContractList);

            system.debug ('==== linksList :' + linksList );
            system.debug ('==== linksList.size() :' + linksList.size() );
            
            //-- PUT LINK INFORMATION in WRAP ----------- 
            wraplinksList= new List<wrapLink>();
            wraplinksSisaList= new List<wrapLink>();

            string tmpToBeAutoRenewalString='';
            boolean tmpToBeAutoRenewal;
            double dataCounter = 0;
            for (Link__c link : linksList ) {
                dataCounter++;
                wrapLink wl = new wrapLink ();
                wl.link = link ;
                wl.Note = '';
                
                if (link.Contract_Item_Rel__c == null) {
                	wl.contractIsAvailable = false;
                	wl.wrapIsDisable = true;
                	wl.Note = 'Contract is NOT available';
                } else {
                	wl.contractIsAvailable = true;
                	wl.wrapIsDisable = false;
                	wl.ToBeAutoRenewal = true;
                }
                
                //-- put data from csv
                if (mapDataEffectiveDate <> null && wl.contractIsAvailable) {
                	wl.effectiveStartDate = mapDataEffectiveDate.get(link.Link_ID__c);
                	
                	if (wl.effectiveStartDate != null) {
                		Date tmpDate =null;
                		try {
                			tmpDate= date.valueOf(wl.effectiveStartDate);
                		} catch (exception e) {
                			wl.Note = 'Effective Start Date format is invalid ';
                		}
                	}
                }
                
                //-- put data from csv
                if (mapDataToBeAutoRenewal <> null && wl.contractIsAvailable) {
                	tmpToBeAutoRenewalString = mapDataToBeAutoRenewal.get(link.Link_ID__c);
                	tmpToBeAutoRenewal = tmpToBeAutoRenewalString == 'true' ? true : false;
                	wl.ToBeAutoRenewal = tmpToBeAutoRenewal;
                }
                
                /*
                //if (mapDataEffectiveDate <> null && mapDataToBeAutoRenewal <> null) {
                system.debug ('===== wl.effectiveStartDate : ' + wl.effectiveStartDate );
                system.debug ('=====tmpToBeAutoRenewalString : ' + tmpToBeAutoRenewalString );
                
                if (wl.effectiveStartDate <> null && tmpToBeAutoRenewalString <> null && 
                		wl.effectiveStartDate <> null && tmpToBeAutoRenewalString <> null ) {
                	if (wl.contractIsAvailable) 
                		wl.selected = true;
                	else 
                		wl.selected = false;
                		
                } else {
                	wl.selected = false;
                }*/
                
                
                if (mapDataLinkUploaded<>null) { 
	                string uploadedStatus = mapDataLinkUploaded.get(link.Link_ID__c);
	                if (uploadedStatus == 'uploaded') {
	                	if (wl.contractIsAvailable) {
	                		wl.selected = true;
	                	} else {
	                		wl.selected = false;
	                	}
	                } else {
	                	wl.selected = false;
	                }
                }
                //--- sampai sini
                
                
                if (dataCounter <= maxLimitNumber) {
                    wraplinksList.add (wl);    
                } else { wraplinksSisaList.add (wl) ;}

                //--put all data over here
                //wraplinksAllList.add (wl);    
            }     
            

            system.debug ('==== wraplinksList.size()     :' + wraplinksList.size() );
            system.debug ('==== wraplinksSisaList.size() :' + wraplinksSisaList.size() );


            system.debug ('==== wraplinksList :' + wraplinksList );
            system.debug ('==== wraplinksSisaList :' + wraplinksSisaList );
            //system.debug ('==== wraplinksAllList :' + wraplinksAllList );
                               
        } 
    }
    
    public Blob csvFileBody{get;set;}
    public boolean isRequestToUpload{get; set;}

    public PageReference selectTheLinks() {
    	String listofErrorLinkID ='';
    	
        List<Change_Price_Link__c> cpls = new List<Change_Price_Link__c>();
        for (wrapLink wl: wraplinksList) {
                //wl.link = link ;
                //wl.selected = false;
                system.debug ('==== link info :' + wl.link  + ' : ' + wl.selected  ); 
                    
            //-- ADD LINK data to Change Price Link
            
            date tmpeffectiveStartDate=null;
            
            if (wl.selected == true) {
                //-- selected 
                Change_Price_Link__c cpl = new Change_Price_Link__c();
                cpl.name = wl.link.Link_ID__c;
                cpl.Site__c = wl.link.Site_A_Name__r.BP_Number__c + ' ' + wl.link.Site_A_Name__r.name  + ' - ' + wl.link.Site_A_Name__r.Unique_Name__c;
                cpl.Bandwidth__c = wl.link.Capacity_Bandwidth__c;
                cpl.UOM__c = wl.link.UoM__c;
                
                cpl.Contract_Start_Date__c = wl.link.Contract_Item_Rel__r.Start_Date__c;
                cpl.Contract_End_Date__c = wl.link.Contract_Item_Rel__r.End_Date__c;
                cpl.Is_Auto_Renewal__c = wl.link.Contract_Item_Rel__r.Auto_Renewal__c ; 
                
                cpl.Change_Price__c = changePriceID ;
                cpl.Link__c = wl.link.id;
                cpl.Previous_Contract__c = wl.link.Contract_Item_Rel__c;
                
                wl.Note = '';
                if (wl.effectiveStartDate <> null && wl.effectiveStartDate <>'') {
                	tmpeffectiveStartDate = apputils.strtodate(wl.effectiveStartDate,'yyyy-mm-dd');
                	cpl.Effective_Start_Date__c = tmpeffectiveStartDate;
                }
                else {
                	listofErrorLinkID = listofErrorLinkID + wl.link.Link_ID__c + ', ';
                	wl.Note = 'Effective-Start-Date is not correct';
                }
                	
                //boolean toBeAutoRenewal = wl.link.Contract_Item_Rel__r.Auto_Renewal__c == false ? true : false;
                cpl.To_Be_Autorenewal__c = wl.toBeAutoRenewal; 
                
                cpls.add (cpl);
                
            }             
        } 
        
        if (listofErrorLinkID<>'') {
        	listofErrorLinkID = listofErrorLinkID.left(listofErrorLinkID.length()-2);
	        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Check the Effective-Start-Date (' + listofErrorLinkID  + ')');
			ApexPages.addMessage(myMsg); 
			return null;
        }
        insert cpls;
        
        
        
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
            insert cplgs;
        }
        */
        
        //return null;
        PageReference p = new PageReference('/' + changePriceID  );
        //PageReference p = new PageReference('https://cs72.lightning.force.com/lightning/r/Change_Price__c/'+ changePriceID + '/view');

        p.setRedirect(true);
        return p;
    }

    public void requestToUpload() {
        isRequestToUpload = true;
    }

    
    //-- need to upload
//    public pagereference doImportCSV () {
    public void doImportCSV () {
        system.debug('============ masuk doImportCSV =======');
        
        List <String> dataLines = new List<String>();
        Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
        List<String> lstFieldNames = new List<String>();
        
        string tmpLinkID ;
        string tmpEffectiveDateString ;
        String tmpToBeAutoRenewalString;
        boolean tmpToBeAutoRenewal;
        
        Change_Price_Link__c cpl = new Change_Price_Link__c ();
        
        Integer fieldNumber;
        String fieldValue;
        
        Map <String, String> mapDataLinkUploaded = new Map<String, String>{};
        Map <String, String> mapDataEffectiveDate = new Map<String, String>{}; 
        Map <String, String> mapDataToBeAutoRenewal = new Map<String, String>{};
        
        
        try {
        	system.debug('===== csvFileBody  : ' + csvFileBody );
            string fileDataAsString = csvFileBody.toString();
            system.debug('===== fileDataAsString  : ' + fileDataAsString );
            fileDataAsString = fileDataAsString.replace(';', ',');    //-- replace ';' into ','
            
            system.debug('===== fileDataAsString  : ' + fileDataAsString );
            
            //readCSVFile();
            dataLines  = fileDataAsString.split('\n');
            string[] csvFieldNames = dataLines[0].split(',');
            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                fieldNumberMap.put(csvFieldNames[i], i);
                lstFieldNames.add(csvFieldNames[i].trim());        
            }
            
            system.debug('===== dataLines : ' + dataLines);
            system.debug('===== csvFieldNames : ' + csvFieldNames);
            
            linkIDUploadList = new List<string> ();
            
            for (Integer i = 1; i < dataLines.size(); i++) {
                
                string[] csvRecordData = dataLines[i].split(',');
                //-- loop for FIELDS
                tmpLinkID = '';
                for (String fieldName: csvFieldNames) {
                    
                    //-- get field value
                    fieldNumber = fieldNumberMap.get(fieldName); 
                    fieldValue = csvRecordData[fieldNumber];
                    
                    if (fieldName.trim() == 'Link ID') {
                        tmpLinkID = fieldValue.trim().replace('\'','');
                        linkIDUploadList.add(tmpLinkID);
                        mapDataLinkUploaded.put(tmpLinkID, 'uploaded');
                    }                    
                    
                    if (fieldName.trim() == 'Effective Start Date (yyyy-mm-dd)') {
                        tmpEffectiveDateString = fieldValue.trim().replace('\'','');
                        mapDataEffectiveDate.put(tmpLinkID, tmpEffectiveDateString.trim() );
                    }
                    
                    if (fieldName.trim() == 'To Be AutoRenewal (true/false)') {
                        tmpToBeAutoRenewalString = fieldValue.trim().replace('\'','');
                        mapDataToBeAutoRenewal.put(tmpLinkID, tmpToBeAutoRenewalString.trim() );
                    }
                }
            }
            
            
            /* TUTUP DULU
            
            //--     
            List <Link__c> links = [select id, Link_ID__c, service_type__c , BP_Site_A__c, BP_Site_B__c, Capacity_Bandwidth__c, UoM__c, selected__c,
                                        Site_A_Name__r.BP_Number__c, Site_A_Name__r.name, Site_A_Name__r.Unique_Name__c,
                                        Contract_Item_Rel__c, Contract_Item_Rel__r.StartDate, Contract_Item_Rel__r.EndDate, 
                                        Contract_Item_Rel__r.Auto_Renewal__c,
                                        Contract_Item_Rel__r.Start_Date__c, Contract_Item_Rel__r.End_Date__c
                                    from link__c  
                                    where Link_ID__c in :linkIDList];
            
            
            system.debug('============ linkIDList : ' + linkIDList);
            system.debug('============ links : ' + links);

            
            if (links.size()>0) {
                List<Change_Price_Link__c> cpls = new List<Change_Price_Link__c>();
                for (Link__c link : links) {
                    cpl = new Change_Price_Link__c ();
                    cpl.put('name', link.Link_ID__c);
                    cpl.put('Bandwidth__c', link.Capacity_Bandwidth__c);
                    cpl.put('UoM__c', link.UoM__c);
                    cpl.put('Site__c', link.BP_Site_A__c);
                    cpl.put('Contract_Start_Date__c', link.Contract_Item_Rel__r.Start_Date__c);
                    cpl.put('Contract_End_Date__c', link.Contract_Item_Rel__r.End_Date__c);
                    cpl.put('Is_Auto_Renewal__c', link.Contract_Item_Rel__r.Auto_Renewal__c);
                    
                    //-- EFFECTIVE DATE
                    tmpEffectiveDateString = mapDataEffectiveDate.get(link.Link_ID__c);
                    Date tmpEffectiveDate = appUtils.strToDate(tmpEffectiveDateString, 'yyyy-mm-dd');
                    cpl.put('Effective_Start_Date__c', tmpEffectiveDate);
                    
                    //-- TOBE AUTORENEWAL
                    
                    tmpToBeAutoRenewalString = mapDataToBeAutoRenewal.get(link.Link_ID__c);
                    tmpToBeAutoRenewal = tmpToBeAutoRenewalString == 'yes' ? true : false;
                    
                    system.debug ('======= tmpToBeAutoRenewalString : ' + tmpToBeAutoRenewalString);
                    system.debug ('======= tmpToBeAutoRenewal : ' + tmpToBeAutoRenewal);
                    
                    if (tmpToBeAutoRenewal) { cpl.put('To_Be_Autorenewal__c', tmpToBeAutoRenewal); } 
                    	else {
                    		cpl.put('To_Be_Autorenewal__c', link.Contract_Item_Rel__r.Auto_Renewal__c == false ? true : false);
                    	}
                    	
                    cpl.put('Change_Price__c', changePriceID);
                    cpl.put('Link__c', link.id);
                    cpl.put('Previous_Contract__c', link.Contract_Item_Rel__c); 
                    
                    cpls.add(cpl);
                }
                insert cpls;
                
                //-- ** Grouping cpls data by Bandwidth and UoM ** --
                ChangePriceLinkGroup_Controller cplgConn = new ChangePriceLinkGroup_Controller();
                cplgConn.createGroupRecords (changePriceID);
                
                
           }        
           */                 
        }
        
        catch(exception e){
            //readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file');
            ApexPages.addMessage(errorMessage);
        }
        
        /*----------tutulp dulu
        PageReference p = new PageReference('/' + changePriceID  );
        //PageReference p = new PageReference('https://cs72.lightning.force.com/lightning/r/Change_Price__c/'+ changePriceID + '/view');

        p.setRedirect(true);
        
        
        return p;
        */
        
        //return null;
        
        getLinkList (changePriceID, mapDataLinkUploaded, mapDataEffectiveDate, mapDataToBeAutoRenewal);
    
    }
    
    
    public void CancelUpload () {
        isRequestToUpload = false;
    
    }
    
    public pagereference doDownloadTemplate () {
		//string ugId = ApexPages.currentPage().getParameters().get('id');
		//Pagereference ref = new Pagereference('/apex/UG_PDF_Page?id=' + ugId);
		
		Pagereference ref = new Pagereference(label.changeprice_linksdata_template_url);
		
		
        ref.setRedirect(true);
            
        // if successfully inserted new lform, then displays the thank you page.
        return ref;        	
    }

	public void getData() {
		system.debug ('==== masuk  getData()');
		system.debug ('==== changePriceID :' + changePriceID );
		system.debug ('==== wraplinksListJSON :' + wraplinksListJSON );
		
		cplcsvheader = 'Link ID,Site A,Bandwidth,UoM,Contract Start Date,Contract End Date,Auto Renewal,Effective Start Date (yyyy-mm-dd),To Be AutoRenewal (true/false)';
    	
    	//-- OLD WAY
    	if( wraplinksListJSON <> null) 
			wraplinksList = (List<wrapLink>) JSON.deserialize(wraplinksListJSON, List<wrapLink>.class);
		system.debug ('==== wraplinksList :' + wraplinksList );
		//---
		
		//-- NEW Way
		List<Change_Price__c> tmplinksList = [select links_string_1__c, links_string_2__c, links_string_3__c, 
                links_string_4__c, links_string_5__c, links_string_6__c, links_string_7__c, links_string_8__c, links_string_9__c, 
                links_string_10__c
				from Change_Price__c where id=:changePriceID
			];
        string tmpString ='';
		if (tmplinksList.size()>0) {
            tmpString = tmplinksList[0].links_string_1__c 
                + tmplinksList[0].links_string_2__c
                + tmplinksList[0].links_string_3__c 
                + tmplinksList[0].links_string_4__c
                + tmplinksList[0].links_string_5__c
                + tmplinksList[0].links_string_6__c 
                + tmplinksList[0].links_string_7__c
                + tmplinksList[0].links_string_8__c 
                + tmplinksList[0].links_string_9__c
                + tmplinksList[0].links_string_10__c
                ;
			
			wraplinksList = (List<wrapLink>) JSON.deserialize(tmpString, List<wrapLink>.class);
        }
        
        system.debug ('=== tmplinksList  : ' + tmplinksList);
        system.debug ('=== tmpString     : ' + tmpString);
        system.debug ('=== wraplinksList : ' + wraplinksList);

        
		//getLinkList (changePriceID, null, null); 
		
	}
	
	/*
	public void setData() {
		system.debug ('==== masuk  SETtData()');
		system.debug ('==== changePriceID :' + changePriceID );
		system.debug ('==== wraplinksList :' + wraplinksList );
	
		wraplinksListJSON = jSON.serialize(wraplinksList);
	}*/
	
	/*	
	public pagereference exportIsDone() { 
    	Pagereference ref = new Pagereference('/apex/VF_Form_Link_ID');
    	ref.setRedirect(true);
    	ref.getParameters().put('wraplinksListJSON', jSON.serialize(wraplinksList));
    	return ref; 
	}*/   
        
    public pagereference doExportToCSV() {
    	/*
    	{!link.link.Link_ID__c}, {!link.link.BP_Site_A__c} - {!link.link.Site_A_Name__r.name},{!link.link.Capacity_Bandwidth__c}, {!link.link.UoM__c},
       	{!link.link.Contract_Item_Rel__r.Start_Date__c}, {!link.link.Contract_Item_Rel__r.End_Date__c}, 
       	{!link.link.Contract_Item_Rel__r.Auto_Renewal__c}, {!link.effectiveStartDate}, {!link.tobeAutoRenewal}
       	*/
       	
       	system.debug ('==== wraplinksList in doExportToExcel :' + wraplinksList );
       	
    	Pagereference ref = new Pagereference('/apex/VF_Change_Price_Link_Export');
    	ref.setRedirect(true);
    	ref.getParameters().put('wraplinksListJSON', jSON.serialize(wraplinksList));
    	return ref; 
    }
    
    public string getwraplinksListJSONString () {
    	
    	return jSON.serialize(wraplinksList);
    }


    public void updateItemString () {
        system.debug ('=== updateItemString');
    	
        //-- update items 1 string
        
        //--old way
        //string tmpString = jSON.serialize(wraplinksList);
        wraplinksAllList= new List<wrapLink>();
        wraplinksAllList.addAll(wraplinksList);
        //--TUTUP DULU :: wraplinksAllList.addAll(wraplinksSisaList);        
        string tmpString = jSON.serialize(wraplinksAllList);



		integer tmpStringLength = tmpString.length();
		integer variableNumber = 1;
        //Change_Price__c tmpCP = new Change_Price__c();
        //tmpCP.id = changePriceID;
        
		system.debug ('=== tmpStringLength : ' + tmpStringLength);
		
		integer stringMax =  131072;
		double tmpNumber = tmpStringLength / 131072; 
		integer sum = math.mod(tmpStringLength, 131072);
		if (sum>0) tmpNumber++;
		
		integer startChar=0;
		integer endChar=startChar + stringMax - 1 ;
		
		changePriceRecord.Links_string_1__c = ''; changePriceRecord.Links_string_2__c = '';
		changePriceRecord.Links_string_3__c = ''; changePriceRecord.Links_string_4__c = '';
        changePriceRecord.Links_string_5__c = ''; changePriceRecord.Links_string_6__c = ''; 
        changePriceRecord.Links_string_7__c = ''; changePriceRecord.Links_string_8__c = ''; 
        changePriceRecord.Links_string_9__c = ''; changePriceRecord.Links_string_10__c = ''; 
		
		for (integer ind=1 ; ind<=tmpNumber; ind++) {
			system.debug ('=== ind : '  + ind);
			
			system.debug ('=== tmpString : '  + tmpString);
			
			endChar = startChar + stringMax - 1 ;
			if (endChar>tmpStringLength)
				endChar = tmpStringLength;
			
			system.debug ('=== startChar : '  + startChar);
			system.debug ('=== endChar : '  + endChar);
	
			string tmpStringPartial = tmpString.subString(startChar, endChar); 
			system.debug ('=== tmpStringPartial (' + ind + ') : '  + tmpStringPartial);
			
			if (ind==1) changePriceRecord.Links_string_1__c = tmpStringPartial;
			if (ind==2) changePriceRecord.Links_string_2__c = tmpStringPartial;
			if (ind==3) changePriceRecord.Links_string_3__c = tmpStringPartial;
			if (ind==4) changePriceRecord.Links_string_4__c = tmpStringPartial;
			if (ind==5) changePriceRecord.Links_string_5__c = tmpStringPartial;
			if (ind==6) changePriceRecord.Links_string_6__c = tmpStringPartial;
            if (ind==7) changePriceRecord.Links_string_7__c = tmpStringPartial;
            if (ind==8) changePriceRecord.Links_string_8__c = tmpStringPartial;
            if (ind==9) changePriceRecord.Links_string_9__c = tmpStringPartial;
            if (ind==10) changePriceRecord.Links_string_10__c = tmpStringPartial;

			startChar = endChar ;
		}
		

		
		update changePriceRecord;
    }
    
    
}