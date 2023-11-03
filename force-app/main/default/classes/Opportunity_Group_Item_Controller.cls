public with sharing class Opportunity_Group_Item_Controller {
    
    ApexPages.StandardSetController setCon;
    ApexPages.StandardController con;
    
    Public String currentProfileName ;
    
    public Opportunity_Group__c opportunityGroup {get;set;}
    public string oppGroupID {get;set;}
    public string needTemplate {get;set;}
    
    public boolean isCheckAll {get;set;}
    public boolean isGenerate {get;set;}
    public boolean isMassUpdate {get;set;}
    public boolean isImport {get;set;}
    public boolean deleteBtnIsVisible {get;set;}
    
    public Blob csvFileBody{get;set;}
    
    
    public Pricebook2 pb {get;set;}
    public Integer genRecordNumber {get;set;}

	//-- for mass update 
    //public boolean serviceTypeIsChecked {get;set;}
    //public boolean opportunityNameIsChecked {get;set;}
    public boolean stageNameIsChecked {get;set;}


    public string serviceType {get;set;}
    public string tmpStageName {get;set;}  

	
	//-- Export
	public string bulkOppcsvheader {get;set;}
	
    
    public List<Wrap_Item> wrapItemsList {get;set;}
    
    class Wrap_Item { 
        public Opportunity_Group_Item__c itemRec {get; set;}
        public Boolean selected {get; set;}
        public boolean wrapIsDisable {get; set;}
        public string notes {get; set;}
        
        public string targetClosedDate {get; set;}
        public string expectedRFSDate {get; set;}
        public string BPSiteA {get; set;}
        public string BPSiteB {get; set;}
        public string LinkID {get; set;}
        
        public Account BPSiteA_Account {get;set;} 
        
        //public integer contractPeriod {get; set;}
        //public boolean usingAggrement {get; set;}
        public string stageName {get; set;}
        //public string leadSource  {get; set;}
        //public string lossReason  {get; set;}
        //public string lossReasonDescription  {get; set;}

    }
    
    private void getUserProfile() {
    	List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
		currentProfileName = PROFILE[0].Name;
		system.debug ('=== currentProfileName : ' + currentProfileName);
		
		if ( currentProfileName == 'System Administrator') {
			deleteBtnIsVisible = true;
		} else deleteBtnIsVisible = false;
    }
    
    public Opportunity_Group_Item_Controller () {
    	wrapBulkOpportunityListJSON = apexpages.currentpage().getparameters().get('wrapBulkOpportunityListJSON');
    	oppGroupID = apexpages.currentpage().getparameters().get('opportunitygroupid');
    	needTemplate = apexpages.currentpage().getparameters().get('needtemplate');
    	
    	getUserProfile();
    }
    
    public Opportunity_Group_Item_Controller (ApexPages.StandardController controller) {
    	con = controller;
    	getUserProfile();
    }

	public void getOpportunityGroupRecord () {
		opportunityGroup = [select id, name, service_type__c, 
	    							opportunity_name__c, Account__r.name, DEscription__c,
	    							BP_PAyer__r.name, BP_VAT__r.name,
	    							stage__c, target_closed_date__c, Expected_RFS_Date__c, 
	    							lead_source__c,
	    							contract_period__c, price_book__c, 
	    							product__c, product_installation__c,
									Billing_Type_Product__c, Billing_Type_Installation__c,
	    							Sales_Price_Product__c,
	    							Sales_Price_Product_Installation__c,
	    							PKS_Number__c,
                            		COF_Number__c,
                            		Periode_UOM__c,
                            		Auto_Renewal__c,
                            		Trial__c
                            		
                            
	    							 
	    						from Opportunity_group__c where id=:oppGroupID];
	}
     
    public Opportunity_Group_Item_Controller (ApexPages.StandardSetController controller) {
    	
    	setCon = controller;
    	getUserProfile();
    	
    	isGenerate = false;
    	
    	oppGroupID = ApexPages.currentPage().getParameters().get('id'); 
    	
    	system.debug ('=== oppGroupID : ' + oppGroupID);
    	
    	if (oppGroupID<>null) {
	    	//--get data from Opportunity Group
			getOpportunityGroupRecord ();
	    	system.debug ('=== opportunityGroup : ' + opportunityGroup);
    	
	    	getItemsList (oppGroupID, 'fromconstructor');
    	}
    }
    
    public void getItemsList(string oppGroupID, string callType) {
        system.debug ('=== oppGroupID in getItemsList : ' + oppGroupID);
    	
    	wrapItemsList = new List<Wrap_Item>();
    	list <Opportunity_group_item__c> ogiList = [select id, name, opportunity_name__c 
    														, related_opportunity__c, related_opportunity__r.id 
    														, related_opportunity__r.name
    														, related_opportunity__r.stageName
    														, related_opportunity__r.Opportunity_ID__c
    														, related_opportunity__r.closeDate
    														, related_opportunity__r.Expected_RFS_Date__c
    														
    														, target_closed_date__c
    														, expected_rfs_date__c
    														
    														, tmp_target_closed_date__c
    														, tmp_expected_rfs_date__c
    														
    														, Account_Site_A_BP_Site__c 
    														, Account_Site_A_BP_Site__r.name
    														, Account_Site_A_BP_Site__r.BP_Number__c	
    														, Account_Site_B_BP_Site__c 
    														, Account_Site_B_BP_Site__r.name
    														, Account_Site_B_BP_Site__r.BP_Number__c
    														
    														, PKS_Number__c
    														, COF_Number__c
    														
    														, Link_Related__c
    														, Link_Related__r.Link_ID__c
    														
    														, Opportunity_Group__r.Price_Book__r.Name
    														, Opportunity_Group__r.Product__r.Name
    														, Opportunity_Group__r.Product_Installation__r.Name
    														, isUpload__c, isSelect__c
    														, tmp_Notes__c
                                                    		, Periode_UOM__c
                                                    		, Auto_Renewal__c
                                                    		, Trial__c
    																				
    													from Opportunity_group_item__c where opportunity_group__c =:oppGroupID
    													order by name
    													];

    	system.debug ('=== ogiList : ' + ogiList);

    	if (ogiList.size() > 0) {
	    	for (Opportunity_group_item__c ogi : ogiList) {
	    		Wrap_Item wrapItemRec = new Wrap_Item();
	    		
	    		//-- update opportunity-group-item from OPPORTUNITY
	    		if (ogi.related_opportunity__c<>null) {
	    			ogi.target_closed_date__c = ogi.related_opportunity__r.closeDate;
	    			ogi.Expected_RFS_Date__c = ogi.related_opportunity__r.Expected_RFS_Date__c;
	    		}
	    		
	    		//-- set itemRec from opportunity-group-item
	    		wrapItemRec.itemRec = ogi;
	    		
	    		//-- SET wrapItem --  
	    		//Date tmpDate = ogi.related_opportunity__r.closeDate;
	    		system.debug ('==== ogi : ' + ogi );
	    		
	    		//if (ogi.isUpload__c == true) {
	    		if (callType=='fromdoimportcsv') {
	    			//- jika hasil upload maka isi dengan var tmp
	    			wrapItemRec.targetClosedDate = ogi.tmp_target_closed_date__c;
	    			//ogi.tmp_target_closed_date__c = '';
	    			
	    			wrapItemRec.expectedRFSDate = ogi.tmp_Expected_RFS_Date__c;
	    			//ogi.tmp_Expected_RFS_Date__c = '';
	    		} else {
	    			
		    		system.debug ('==== ogi.target_closed_date__c : ' + ogi.target_closed_date__c );
		    		Date tmpDate1 = ogi.target_closed_date__c;
		    		system.debug ('==== tmpDate1 : ' + tmpDate1 );
		    		if (tmpDate1 <> null) wrapItemRec.targetClosedDate = string.valueof(tmpDate1);
		    		
		    		//--jika kosong tapi temporary ada
		    		system.debug ('== ceeek : ' 
		    				+ wrapItemRec.targetClosedDate + ' - ' + ogi.tmp_Target_Closed_Date__c);
		    				
		    		if (( wrapItemRec.targetClosedDate =='' || wrapItemRec.targetClosedDate == null ) 
		    				&& ( ogi.tmp_Target_Closed_Date__c <> '' || ogi.tmp_Target_Closed_Date__c <> null)
		    				)
		    			wrapItemRec.targetClosedDate = ogi.tmp_Target_Closed_Date__c;
		    		
		    		
		    		Date tmpDate2 = ogi.Expected_RFS_Date__c;
		    		system.debug ('==== tmpDate2 : ' + tmpDate2 );
		    		if (tmpDate2 <> null) wrapItemRec.expectedRFSDate = string.valueof(tmpDate2);

		    		//--jika kosong tapi temporary ada
		    		if (( wrapItemRec.expectedRFSDate =='' || wrapItemRec.expectedRFSDate == null ) 
		    				&& ( ogi.tmp_Expected_RFS_Date__c <> '' || ogi.tmp_Expected_RFS_Date__c <> null)
		    				)
		    			wrapItemRec.expectedRFSDate = ogi.tmp_Expected_RFS_Date__c;


	    		}
	    		

	    		
	    		wrapItemRec.BPSiteA = ogi.Account_Site_A_BP_Site__r.BP_Number__c;
	    		wrapItemRec.BPSiteB = ogi.Account_Site_B_BP_Site__r.BP_Number__c;
	    		
	    		wrapItemRec.LinkID = ogi.Link_Related__r.Link_ID__c;
	    		
	    		
	    		wrapItemRec.selected = ogi.isUpload__c; 
	    		ogi.isUpload__c = false;
	    		ogi.isSelect__c = false;
	    		
	    		wrapItemRec.notes = ogi.tmp_Notes__c;
	    		ogi.tmp_Notes__c = '';
	    		
	    		wrapItemRec.wrapIsDisable = false;
	    		
	    		
	    		
	    		//system.debug('=== wrapItemRec.itemRec.tmp_Notes__c : ' +  wrapItemRec.itemRec.tmp_Notes__c); 
	    		//wrapItemRec.notes = string.valueof(wrapItemRec.itemRec.tmp_Notes__c);
	    		//wrapItemRec.note = 'tost'; 
	    		
	    		wrapItemsList.add (wrapItemRec);
	    	}
	    	
	    	if (callType <> 'fromconstructor' && callType <> 'fromdoimportcsv' ) 
	    		update ogiList;
    	}
    	
    	isCheckAll=false;

    }


    public List<SelectOption> getStagelist() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Prospecting','Prospecting'));
        options.add(new SelectOption('Survey','Survey'));
        options.add(new SelectOption('Negotiation','Negotiation'));
        options.add(new SelectOption('Quotation Final','Quotation Final'));
        options.add(new SelectOption('Implementation','Implementation'));
        options.add(new SelectOption('Waiting for BA','Waiting for BA'));
        options.add(new SelectOption('Waiting for Contract','Waiting for Contract'));
        options.add(new SelectOption('Closed Won','Closed Won'));
        options.add(new SelectOption('Closed Lost','Closed Lost'));
        options.add(new SelectOption('Closed Not Delivered','Closed Not Delivered'));
        
/*
        if (stpc.size()>0) {
            options.add(new SelectOption( '--Select Package--', '--Select Package--') );
            for (Short_Term_Package__c stp : stpc ){
            	
                string stpName = stp.Name;
                options.add(new SelectOption( stp.id, stpName) );
            }
        }
*/        
        return options;
    }
    
        
    public void showGenerateSection(){
    	isGenerate=true;
    }
    public void hideGenerateSection(){
    	isGenerate=false;
    }
    
    public void showMassUpdateSection(){
    	isMassUpdate=true;
    }
    public void hideMassUpdateSection(){
    	isMassUpdate=false;
    }

    public void showImportSection(){
    	isImport=true;
    }
    public void hideImportSection(){
    	isImport=false;
    }
    
    
    //-------------------------------------------------------------
    public void generateItems () {
    	
    	if (genRecordNumber >0 ) {
    		List<Opportunity_group_item__c> ogiList = new List<Opportunity_group_item__C>();
    		for (Integer i=0; i<genRecordNumber;i++) {
    			Opportunity_group_item__c ogi = new Opportunity_group_item__c ();
    			ogi.opportunity_group__c = oppGroupID;
    			
    			ogi.opportunity_name__c = opportunityGroup.opportunity_name__c;
    			//ogi.target_closed_date__c = opportunityGroup.target_closed_date__c;
    			
    			//date tmpDate = appUtils.strToDate(wrapItemRec.targetClosedDate, 'yyyy-mm-dd');
    			//if (tmpDate<>null) ogiTmp.target_closed_date__c = tmpDate;
    			
    			ogi.target_closed_date__c =  opportunityGroup.target_closed_date__c;
    			ogi.expected_rfs_date__c =  opportunityGroup.expected_rfs_date__c;
    			
    			ogi.pks_number__c = opportunityGroup.pks_number__c;
    			ogi.cof_number__c = opportunityGroup.cof_number__c; 
    			
    			
    			/*
    			ogi.service_type__c = opportunityGroup.service_type__c;
    			ogi.Opportunity_Group_Name__c = opportunityGroup.Opportunity_Group_Name__c;
    			ogi.opportunity_name__c = opportunityGroup.opportunity_name__c;
    			ogi.service_type__c = opportunityGroup.service_type__c;
    			*/
    			
    			ogiList.add (ogi);
    		}
    		insert ogiList;
    		
    		getItemsList (oppGroupID, 'fromgeneratetems');
    	}
    	
    }
    
    public void deleteSelectedItems () {
    	// List<Opportunity_Group_item__c> ogiList = setCon.getSelected();
    	// delete ogiList;
     	
    	List<Opportunity_Group_item__c> ogiListTmp = new List<Opportunity_Group_item__c>();
    	List<Opportunity> oppListTmp = new List<Opportunity>();
    	
    	for (Wrap_Item wrapItemRec : wrapItemsList) {
    		/*
    		if (wrapItemRec.selected && wrapItemRec.itemRec.RElated_Opportunity__c ==null) {
    			ogiListTmp.add(wrapItemRec.itemRec);
    			
    		} */
    		if (wrapItemRec.selected) {
	    		ogiListTmp.add(wrapItemRec.itemRec);
	    		if (wrapItemRec.itemRec.RElated_Opportunity__c <>null) {
	    			Opportunity oppTmp = new Opportunity();
	    			oppTmp.id = wrapItemRec.itemRec.RElated_Opportunity__c;
	    			oppListTmp.add(oppTmp);
	    		}
    		}

    	}
    	
    	system.debug ('====== ogiListTmp : ' + ogiListTmp);
    	try {
    		delete ogiListTmp;
    		delete oppListTmp;
    	} catch (Exception e)  {
    		Log_Error__c logError = new Log_Error__c();
            logError.Message__c = e.getmessage() + ' - ' +  e.getStackTraceString() + ' ' + e.getLineNumber(); 
            //logError.Stack_Trace__c = e.getStackTraceString(); 
            //logError.Line_Number__c = e.getLineNumber();
            logError.Notes__c = 'Error in CLASS : Opportunity_Group_Item_Controller, METHOD : deleteSelectedItems';
			insert logError;
    	}
    	
    	getItemsList (oppGroupID, 'fromdeleteselecteditems');
    }
    
    public void moveStageSelectedItems() {
    	
    }

    public void updateSelectedItem() {
    	//update 
    	
    }   
    
    public void createOpportunitySelectedItems () {
    	List <Opportunity> oppList = new List<Opportunity>();
    	integer selectedCount = 0;
    	integer selectedOppCount = 0;
    	
		getOpportunityGroupRecord ();

    	list<String> BPList = new list<string>();
    	Map<string,string > accMap = new Map<string,string >(); 
    	
    	for (Wrap_Item wrapItemRec : wrapItemsList) {
    		system.debug ('== wrapItemRec.selected : ' + wrapItemRec.selected);
    		system.debug ('== wrapItemRec.BPSiteA : ' + wrapItemRec.BPSiteA);
    		
    		if (wrapItemRec.selected) {
    			if (wrapItemRec.BPSiteA <>'')
    				BPList.add (wrapItemRec.BPSiteA);
    			if (wrapItemRec.BPSiteB <>'')
    				BPList.add (wrapItemRec.BPSiteB);		
    			
    		}
    	}
    	
    	List<Account> accList = [select id, BP_Number__c from account where BP_Number__c =: BPList ];
    	if (accList .size()>0){
    		for (Account acc :accList ) {
    			accMap.put(acc.BP_Number__c, acc.id);
    		}
    	}    	
    	
    	List<Opportunity_Group_Item__c> tmpOGIList = new List<Opportunity_Group_Item__c>();
    	for (Wrap_Item wrapItemRec : wrapItemsList) {
    		if (wrapItemRec.selected)
    			selectedCount++;
    		
    		if (wrapItemRec.selected    		 
    				&& wrapItemRec.itemRec.Related_Opportunity__c == null 
    				
    				) {
    			/*opportunityGroup = [select id, name, service_type__c, 
	    							opportunity_name__c, Account__r.name, DEscription__c,
	    							BP_PAyer__r.name, BP_VAT__r.name,
	    							stage__c, target_closed_date__c, lead_source__c,
	    							contract_period__c, price_book__c, 
	    							product__c, product_installation__c 
	    							*/
	    		selectedOppCount++;					
    			Opportunity tmpOpp = new Opportunity();
    			
    			tmpOpp.Project_Group__c = opportunityGroup.name;
    			tmpOpp.Opportunity_Group_Related__c = opportunityGroup.id;
    			tmpOpp.Opportunity_Group_Item_Related__c = wrapItemRec.itemRec.id;
    			
    			tmpOpp.service_type__c = opportunityGroup.service_type__c;
    			tmpOpp.name = wrapItemRec.itemRec.opportunity_name__c;
    			tmpOpp.Accountid = opportunityGroup.Account__c;
    			tmpOpp.Periode_UOM__c = opportunityGroup.Periode_UOM__c;
                tmpOpp.Auto_Renewal__c = opportunityGroup.Auto_Renewal__c;  
                tmpOpp.trial__c = opportunityGroup.trial__c;   
                        
    			if (wrapItemRec.itemRec.Target_Closed_Date__c <> null)
    				//-- jika ada data di item maka tidak perlu ambil dari group (header)
    				tmpOpp.CloseDate = wrapItemRec.itemRec.Target_Closed_Date__c;
    				else tmpOpp.CloseDate = opportunityGroup.target_closed_date__c; 
    				
    			if (wrapItemRec.itemRec.Expected_RFS_Date__c <> null)
    				//-- jika ada data di item maka tidak perlu ambil dari group (header)
    				tmpOpp.Expected_RFS_Date__c = wrapItemRec.itemRec.Expected_RFS_Date__c;
    				else tmpOpp.Expected_RFS_Date__c = opportunityGroup.Expected_RFS_Date__c;
    			
    			
    			tmpOpp.LeadSource = opportunityGroup.Lead_Source__c;
    			
    			tmpOpp.BP_Payer__c = opportunityGroup.BP_Payer__c;
    			tmpOpp.BP_VAT__c = opportunityGroup.BP_VAT__c;
    			
    			tmpOpp.Contract_Periode__c = opportunityGroup.Contract_Period__c;
    			  
    			tmpOpp.stageName = 'Prospecting';
    			tmpOpp.Periode_UOM__c = 'Month';
    			tmpOpp.Description = opportunityGroup.Description__c;
     
                        
                        
    			
    			string tmpBPNumberSiteA = wrapItemRec.BPSiteA;
                string tmpBPNumberSiteB = wrapItemRec.BPSiteB;
                //-- SET SITE A from MAP
                if (tmpBPNumberSiteA <> '' && tmpBPNumberSiteA <> null) {
                    string tmpAccId = accMap.get(tmpBPNumberSiteA);
                    //ogiTmp.Account_Site_A_BP_Site__c = tmpAccId;                    
                    tmpOpp.Account_Site_A__c = tmpAccId;
                    wrapItemRec.itemRec.Account_Site_A_BP_Site__c = tmpAccId;
                    
                } else {
                	tmpOpp.Account_Site_A__c = null;
                    wrapItemRec.itemRec.Account_Site_A_BP_Site__c = null;
                }
                //-- SET SITE B from MAP
                system.debug('=== tmpBPNumberSiteB : ' + tmpBPNumberSiteB);
                if (tmpBPNumberSiteB <> '' && tmpBPNumberSiteB <> null) {   
                    string tmpAccId = accMap.get(tmpBPNumberSiteB);
                    //ogiTmp.Account_Site_B_BP_Site__c = tmpAccId;
                    tmpOpp.Account_Site_B__c = tmpAccId;
                    wrapItemRec.itemRec.Account_Site_B_BP_Site__c = tmpAccId;
                } else {
                	tmpOpp.Account_Site_B__c = null;
                    wrapItemRec.itemRec.Account_Site_B_BP_Site__c = null;
                }
                
                //-- set PKS Number
    			if (wrapItemRec.itemRec.PKS_Number__c == null || wrapItemRec.itemRec.PKS_Number__c == '')
    				tmpOpp.PKS_Number__c = opportunityGroup.PKS_Number__c;
    			 else tmpOpp.PKS_Number__c = wrapItemRec.itemRec.PKS_Number__c;

    			//-- set COF Number
    			if (wrapItemRec.itemRec.COF_Number__c == null || wrapItemRec.itemRec.COF_Number__c =='')
    				tmpOpp.COF_Number__c = opportunityGroup.COF_Number__c;
    			 else tmpOpp.COF_Number__c = wrapItemRec.itemRec.COF_Number__c;    			 
    			 
    			                 
    			tmpOpp.Link_Related__c = wrapItemRec.itemRec.Link_Related__c;
    			
    			tmpOpp.Pricebook2id = opportunityGroup.price_book__c;
    			
    			//tmpOpp.service_type__c = opportunityGroup.service_type__c;
    			//tmpOpp.service_type__c = opportunityGroup.service_type__c;
    			//tmpOpp.service_type__c = opportunityGroup.service_type__c;
    			
    			tmpOpp.Product_List__c = opportunityGroup.product__c + ';' + opportunityGroup.product_installation__c;
				tmpOpp.Billing_Type_List__c = opportunityGroup.Billing_Type_Product__c + ';' + opportunityGroup.Billing_Type_Installation__c;
    			tmpOpp.Product_Price_List__c = string.valueof(opportunityGroup.Sales_Price_Product__c) + ';' + string.valueof(opportunityGroup.Sales_Price_Product_Installation__c);
    			
    			system.debug('=== tmpOpp : ' + tmpOpp);
    			oppList.add(tmpOpp);
    			
    			tmpOGIList.add(wrapItemRec.itemRec);
    		}
    	}
    	
    	Boolean isError=false;
    	
    	if (selectedOppCount > 0 ) {
	    	try {
	    		//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 
	    		//	'Wait a minute, opportunity creation process is in-progress.' );
				//ApexPages.addMessage(myMsg);
	    		
	    		system.debug('=== oppList : ' + oppList);
	    		//-- TUTUP DULU : 
	    		insert oppList;
	    		update tmpOGIList;
	    		
	    		//-- BATCH PROCESS --
	    		//BatchInsertOpportunity bio = new BatchInsertOpportunity (oppList); 
	    		//Database.executeBatch (bio, 20);
	    		
	    		
	    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 
	    			'Opportunity creation is done.' );
				ApexPages.addMessage(myMsg);
				
				
	    		
	    		} catch(DmlException e) {
	    			isError =true;
				    System.debug('The following exception has occurred: ' + e.getMessage());
				    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
					ApexPages.addMessage(myMsg);
				}
    	} else {
    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Select the record with no related opportunity first');
			ApexPages.addMessage(myMsg);
    		
    	}
    	
    	if (isError == false)	{
    		
    		system.debug('=== oppList : ' + oppList);
    		
    		//-- atached opportunity
    		List<Opportunity_Group_Item__c> ogiList = new List<Opportunity_Group_Item__c>();
    		List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
    		
    		for (Opportunity opp : oppList) {
    			Opportunity_Group_Item__c ogiTmp = new Opportunity_Group_Item__c();
    			ogiTmp.id = opp.Opportunity_Group_Item_Related__c;
    			ogiTmp.related_opportunity__c = opp.id;
    			
    			ogiList.add (ogiTmp);
    			
    			//-- create opportunity product
    			string tmpProductList = opp.Product_List__c;
				string tmpBillingTypeList =opp.Billing_Type_List__c;
    			string tmpProductPriceList = opp.Product_Price_List__c;
    			List<String> productIDList = tmpProductList.split(';', 2);
				List<String> billingTypeList = tmpBillingTypeList.split(';', 2);
    			List<String> productPriceList = tmpProductPriceList.split(';', 2);
    			
    			if (productIDList.size() >0) {
    				integer ind=0;
	    			for (String productID :  productIDList) {
	    				system.debug('=== productID : ' + productID);
	    				if (productID.trim() == '' || productID.trim()  == 'null' ) {
	    					//do nothing
	    				}else {
			    			OpportunityLineItem oli = new OpportunityLineItem();
			    			oli.OpportunityId = opp.id;
			    			oli.Product2Id	= productID;
							oli.Billing_Type__c = billingTypeList[ind] ;
			    			oli.Quantity = 1;
			    			
			    			oli.UnitPrice = double.valueOf(productPriceList[ind]);
			    			ind++;
			    			
			    			oliList.add(oli);
	    				}
	    			}
    			}
    		}
    		
    		 
    		isError = false;
    		try {
	    		system.debug('=== ogiList : ' + ogiList);
	    		update ogiList;
    		} catch(DmlException e) {
    			isError =true;
			    appUtils.putError('Error on Opportunity_Group_Item_Controller.createOpportunitySelectedItems, oppGroupID : ' + oppGroupID + '::' + e.getmessage() + '-' + e.getStackTraceString() + '::' + e.getLineNumber()  );

				System.debug('The following exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' - ' + e.getLineNumber());
				ApexPages.addMessage(myMsg);
				
			}
    		
    		
    		
    		try {
	    		
	    		//TUTUP DULU : 
	    		system.debug('=== oliList : ' + oliList);
	    		//insert oliList;
	    		
	    		//-- Batch Process
	    		BatchInsertOpportunityLineItem bioli = new BatchInsertOpportunityLineItem (oliList); 
    			Database.executeBatch (bioli, 25);
	    		
	    		
    		} catch(DmlException e) {
    			isError =true;
			    System.debug('The following exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber() );
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' - ' + e.getLineNumber());
				ApexPages.addMessage(myMsg);
			}
    		
    		if (isError == false)	{
    			getItemsList (oppGroupID, 'fromcreateopportunityselecteditems');
    		}
		}
    	
    }
     
    public void updateSelectedItems() {
    	system.debug ('==== in  ');
    	list<Opportunity> oppList = new list<Opportunity>();
    	list<Opportunity_Group_Item__c> ogiList = new list<Opportunity_Group_Item__c> ();
    	
    	list<String> BPList = new list<string>();
    	Map<string,string > accMap = new Map<string,string >(); 
    	
    	for (Wrap_Item wrapItemRec : wrapItemsList) {
    		if (wrapItemRec.selected) {
    			if (wrapItemRec.BPSiteA <>'')
    				BPList.add (wrapItemRec.BPSiteA);
    			if (wrapItemRec.BPSiteB <>'')
    				BPList.add (wrapItemRec.BPSiteB);		
    		}
    	}
    	
    	List<Account> accList = [select id, BP_Number__c from account where BP_Number__c =: BPList ];
    	if (accList .size()>0){
    		
    		for (Account acc :accList ) {
    			accMap.put(acc.BP_Number__c, acc.id);
    		}
    		
    	}

		getOpportunityGroupRecord ();
    	
    	for (Wrap_Item wrapItemRec : wrapItemsList) {
    		system.debug('=== wrapItemRec.selected : ' + wrapItemRec.selected);
    		system.debug('=== wrapItemRec.itemRec.isSelect__c : ' + wrapItemRec.itemRec.isSelect__c);
    		
    		if (wrapItemRec.selected || wrapItemRec.itemRec.isSelect__c ) {
    			
    			
    			//ogiListTmp.add(wrapItemRec.itemRec);
    			string tmpBPNumberSiteA = wrapItemRec.BPSiteA;
    			string tmpBPNumberSiteB = wrapItemRec.BPSiteB;
    			
    			string tmpLinkId = wrapItemRec.LinkId;
    			
    			Opportunity_Group_Item__c ogiTmp = new Opportunity_Group_Item__c();
    			ogiTmp.id=wrapItemRec.itemRec.id;
    			ogiTmp.opportunity_name__c = wrapItemRec.itemRec.opportunity_name__c;
    			ogiTmp.tmp_notes__c ='';
    			
    			//-- set PKS Number
    			if (wrapItemRec.itemRec.PKS_Number__c == null || wrapItemRec.itemRec.PKS_Number__c == '')
    				ogiTmp.PKS_Number__c = opportunityGroup.PKS_Number__c;
    			 else ogiTmp.PKS_Number__c = wrapItemRec.itemRec.PKS_Number__c;
    			
    			//-- set COF Number
    			if (wrapItemRec.itemRec.COF_Number__c == null || wrapItemRec.itemRec.COF_Number__c =='')
    				ogiTmp.COF_Number__c = opportunityGroup.COF_Number__c;
    			 else ogiTmp.COF_Number__c = wrapItemRec.itemRec.COF_Number__c;
    			
    			
    			system.debug('=== tmpBPNumberSiteA : ' + tmpBPNumberSiteA);
    			if (tmpBPNumberSiteA <> '' && tmpBPNumberSiteA <> null) {
    				/* belum jalan 
    				//ogiTmp.putSObject('Account_Site_A_BP_Site__r', new Account(BP_Number__c = tmpBPNumberSiteA));
    				
    				SObjectField lookup = Opportunity_group_item__c.Account_Site_A_BP_Site__c, external = Account.BP_Number__c;
    				SObjectType childType = Contact.sObjectType, parentType = Account.sObjectType;
					String relationshipName = lookup.getDescribe().getRelationshipName();

    				SObject parent = parentType.newSObject();
					parent.put(external, tmpBPNumberSiteA);
    				
    				SObject child = childType.newSObject();
    				system.debug('=== parent : ' + parent);
					ogiTmp.putSObject(relationshipName, parent);
    				//ogiTmp.putSObject('Account_Site_A__r',  parent );
    				*/
    				
    				string tmpAccId = accMap.get(tmpBPNumberSiteA);
    				ogiTmp.Account_Site_A_BP_Site__c = tmpAccId;
    				
    			} else {
    				ogiTmp.Account_Site_A_BP_Site__c = null;
    			}
    			system.debug('=== cek ogiTmp first : ' + ogiTmp);
    			
    			system.debug('=== tmpBPNumberSiteB : ' + tmpBPNumberSiteB);
    			if (tmpBPNumberSiteB <> '' && tmpBPNumberSiteB <> null) {	
    				/* belum jalan
    				ogiTmp.putSObject('Account_Site_B_BP_Site__r', new Account(BP_Number__c = tmpBPNumberSiteB));
    				*/
    				string tmpAccId = accMap.get(tmpBPNumberSiteB);
    				system.debug('=== tmpAccId : ' + tmpAccId);
    				ogiTmp.Account_Site_B_BP_Site__c = tmpAccId;
    				
    			} else {
    				ogiTmp.Account_Site_B_BP_Site__c = null;
    			}
    			
    			if (tmpLinkId <> '' && tmpLinkId <> null)	
    				ogiTmp.putSObject('Link_Related__r', new Link__c(Link_ID__c = tmpLinkId));
    			
    			if (wrapItemRec.targetClosedDate == null || wrapItemRec.targetClosedDate == '') 
    				wrapItemRec.targetClosedDate = string.valueof(opportunityGroup.target_closed_date__c);

    			date tmpClosedDate = appUtils.strToDate(wrapItemRec.targetClosedDate, 'yyyy-mm-dd');
    			system.debug ('=== cek tmpClosedDate : ' + tmpClosedDate);
    			
    			if (tmpClosedDate<>null) 
    				ogiTmp.target_closed_date__c = tmpClosedDate;
    				else 
    				ogiTmp.tmp_notes__c ='Target Close Date format is not valid. ';
    				

    			if (wrapItemRec.expectedRFSDate == null || wrapItemRec.expectedRFSDate == '')
    				wrapItemRec.expectedRFSDate = string.valueof(opportunityGroup.expected_RFS_date__c);
    			
    			date tmpExpRFSDate = appUtils.strToDate(wrapItemRec.expectedRFSDate, 'yyyy-mm-dd');
    			system.debug ('=== cek tmpExpRFSDate : ' + tmpExpRFSDate);
    			
    			if (tmpExpRFSDate<>null) 
    				ogiTmp.expected_RFS_date__c = tmpExpRFSDate;
    				else
    				ogiTmp.tmp_notes__c = ogiTmp.tmp_notes__c + 'Expected RFS Date format is not valid. ';
    				
    			
    			
    			
    			system.debug('=== cek ogiTmp : ' + ogiTmp);
    			ogiList.add (ogiTmp);
    			//wrapItemRec.opportunity_name__c 
    			
    			system.debug('=== wrapItemRec.itemRec.related_opportunity__c : ' + wrapItemRec.itemRec.related_opportunity__c);
    			
    			//-- IF RELATED TO OPPORTUNITY
    			if (wrapItemRec.itemRec.related_opportunity__c <> null) {
	    			
	    			
	    			//Opportunity tmpOpp = new Opportunity(); 
	    			//tmpOpp.id = wrapItemRec.itemRec.related_opportunity__r.id;
	    			string tmpOppId = wrapItemRec.itemRec.related_opportunity__r.id;
	    			 	
	    			//-- update opportunity name
	    			//tmpOpp.name = wrapItemRec.itemRec.opportunity_name__c;
	    			string tmpOppName = wrapItemRec.itemRec.opportunity_name__c;
	    			
	    			//tmpOpp.Account_Site_A__c = '730206'; //wrapItemRec.itemRec.Account_Site_A_BP_Site__c;
	    			//Account tmpAcc = new Account (BP_Number__c = '730206' );
	    			//tmpOpp.Account_Site_A__c = tmpAcc.id;
	    	    			
	    			//tmpOpp.putSObject ('Account_Site_A__c', new Account (BP_Number__c = '730206' ) );
	    			
	    			//Account code = new Account(BP_Number__c = '730206');
	    			//system.debug('=== code : ' + code);
	    			
//	    			Opportunity tmpOpp = new Opportunity(id =tmpOppId, Name = tmpOppName, 			Account_Site_A__r = code );
	    			
	    			Opportunity tmpOpp = new Opportunity();
	    			tmpOpp.id = tmpOppId;
	    			tmpOpp.name = tmpOppName;

	    			/*
	    			//-- sementara
	    			string tmpBPNumber = wrapItemRec.BPSiteA;
	    			string tmpAccountID='';
	    			list<account> accountList =[select id, BP_Number__c from account where BP_Number__c =:tmpBPNumber];
	    			if (accountList.size()>0) {
	    				tmpAccountID = accountList[0].id;
	    			}*/
	    			
	    			/*
	    			tmpOpp.putSObject('Account_Site_A__r', new Account(BP_Number__c = tmpBPNumberSiteA));
	    			tmpOpp.putSObject('Account_Site_B__r', new Account(BP_Number__c = tmpBPNumberSiteB));
	    			tmpOpp.putSObject('Link_Related__r', new L(BP_Number__c = tmpBPNumberSiteB));
	    			*/
	    			
	    			
	    			if (tmpClosedDate<>null) tmpOpp.closeDate = tmpClosedDate;
	    			if (tmpExpRFSDate<>null) tmpOpp.Expected_RFS_Date__c = tmpExpRFSDate;
	    			
	    			if (ogiTmp.PKS_Number__c == null || ogiTmp.PKS_Number__c == '' )
	    				tmpOpp.PKS_Number__c = opportunityGroup.PKS_Number__c;
	    				else tmpOpp.PKS_Number__c = ogiTmp.PKS_Number__c;
	    			
	    			
	    				
	    			if (ogiTmp.COF_Number__c == null || ogiTmp.COF_Number__c == '' )
	    				tmpOpp.COF_Number__c = opportunityGroup.COF_Number__c;
	    				else tmpOpp.COF_Number__c = ogiTmp.COF_Number__c;
	    				
	    			
	    			
	    			
	    			system.debug('=== cek ogiTmp.Account_Site_A_BP_Site__c : ' + ogiTmp.Account_Site_A_BP_Site__c);
	    			system.debug('=== cek ogiTmp.Account_Site_B_BP_Site__c : ' + ogiTmp.Account_Site_B_BP_Site__c);
	    			
	    			tmpOpp.Account_Site_A__c = ogiTmp.Account_Site_A_BP_Site__c;
	    			tmpOpp.Account_Site_B__c = ogiTmp.Account_Site_B_BP_Site__c;
	    			tmpOpp.Link_Related__c = ogiTmp.Link_Related__c;
	    			tmpOpp.Periode_UOM__c = ogiTmp.Periode_UOM__c;
                    tmpOpp.Auto_Renewal__c = ogiTmp.Auto_Renewal__c;
                    tmpOpp.Trial__c = ogiTmp.Trial__c;
                    
	    			
	    			if (stageNameisChecked) {
	    				tmpOpp.stageName = tmpStageName; 
	    			}
	    			
	    			system.debug('=== tmpOpp : ' + tmpOpp);
	    			
	    			oppList.add (tmpOpp);
    			}
    			
    			
    			ogiTmp.isSelect__c =false;
    		} 
    	}
    	
    	boolean isError =false;
    	try {
    		system.debug('=== ogiList : ' + ogiList);
    		update ogiList;
    		
    		} catch(DmlException e) {
    			isError =true;
			    System.debug('The following exception has occurred: ' + e.getMessage());
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
				ApexPages.addMessage(myMsg);
			}
    	
    	try {
    		system.debug('=== oppList : ' + oppList);
    		update oppList;
    		} catch(DmlException e) {
    			isError =true;
			    System.debug('The following exception has occurred: ' + e.getMessage());
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
				ApexPages.addMessage(myMsg);
			}
		
		if (isError == false)	{
    		getItemsList (oppGroupID, 'fromupdateselecteditems');
    		isCheckAll = false;
		}	
    	
    	
    	
    	
    }
    
    public void refreshItems() {
    	getItemsList (oppGroupID, 'fromrefreshitems');
    }
    
    public void doImportCSV () {
        system.debug('============ masuk doImportCSV =======');
        
        List <String> dataLines = new List<String>();
        Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
        List<String> lstFieldNames = new List<String>();
        
        /*
        string tmpLinkID ;
        string tmpEffectiveDateString ;
        String tmpToBeAutoRenewalString;
        boolean tmpToBeAutoRenewal;
        */
        
        string tmpID = '';
        string tmpItemName = '';
        string tmpOpportunityName = '';
        string tmpBPNumberSiteA = '';
        string tmpBPNumberSiteB = '';
        string tmpLinkID = '';
        string tmpTargetCloseDate = '';
        string tmpExpectedRFSDate = '';
        string tmpPKSNumber = '' ;
        string tmpCOFNumber = '' ;
        
        
        Change_Price_Link__c cpl = new Change_Price_Link__c ();
        
        Integer fieldNumber;
        String fieldValue;
        
        Map <String, String> mapDataEffectiveDate = new Map<String, String>{}; 
        Map <String, String> mapDataToBeAutoRenewal = new Map<String, String>{};
        
        try {
        	system.debug('===== csvFileBody  : ' + csvFileBody );
            string fileDataAsString = csvFileBody.toString();
            //String fileDataAsString = EncodingUtil.base64Encode(csvFileBody);
            
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
            
            //List<string> linkIDList = new List<string> ();
            List <Opportunity_Group_Item__c> ogiListInsert = new  List <Opportunity_Group_Item__c>();
            List <Opportunity_Group_Item__c> ogiListUpdate = new  List <Opportunity_Group_Item__c>();
            
            for (Integer i = 1; i < dataLines.size(); i++) {
                
                string[] csvRecordData = dataLines[i].split(',');
                //-- loop for FIELDS
                tmpLinkID = '';
                for (String fieldName: csvFieldNames) {
                    
                    //-- get field value
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    
                    system.debug ('==== fieldNumber : ' + fieldNumber);
                    system.debug ('==== fieldName  : ' + fieldName.trim());	
                    system.debug ('==== fieldValue : ' + fieldValue);	
                    
                    /*
                    if (fieldName.trim() == 'Link ID') {
                        tmpLinkID = fieldValue.trim().replace('\'','');
                        linkIDList.add(tmpLinkID);
                    }                    
                    
                    if (fieldName.trim() == 'Effective Start Date (yyyy-mm-dd)') {
                        tmpEffectiveDateString = fieldValue.trim().replace('\'','');
                        mapDataEffectiveDate.put(tmpLinkID, tmpEffectiveDateString.trim() );
                    }
                    
                    if (fieldName.trim() == 'To Be AutoRenewal (true/false)') {
                        tmpToBeAutoRenewalString = fieldValue.trim().replace('\'','');
                        mapDataToBeAutoRenewal.put(tmpLinkID, tmpToBeAutoRenewalString.trim() );
                    }
                    */
                    
                    if (fieldName.trim() == 'ID') {
                        tmpID = fieldValue.trim().replace('\'','');
                        
                    }
                    if (fieldName.trim() == 'Name') {
                        tmpItemName = fieldValue.trim().replace('\'','');
                    } 
                    if (fieldName.trim() == 'BP Site A') {
                        tmpBPNumberSiteA = fieldValue.trim().replace('\'','');
                        tmpBPNumberSiteA = tmpBPNumberSiteA.replace(' ','');
                        tmpBPNumberSiteA = tmpBPNumberSiteA.replace('(\\s+)','');
                        tmpBPNumberSiteA = tmpBPNumberSiteA.replaceAll('[^a-zA-Z0-9]', '');
                    } 
                    if (fieldName.trim() == 'BP Site B') {
                        tmpBPNumberSiteB = fieldValue.trim().replace('\'','');
                        tmpBPNumberSiteB = tmpBPNumberSiteB.replaceAll(' ','');
                        tmpBPNumberSiteB = tmpBPNumberSiteB.replaceall('\\s+','');
                        tmpBPNumberSiteB = tmpBPNumberSiteB.deleteWhitespace();
                        tmpBPNumberSiteB = tmpBPNumberSiteB.replaceAll('[^a-zA-Z0-9]', '');
                    } 
                    if (fieldName.trim() == 'Opportunity Name') {
                        tmpOpportunityName = fieldValue.trim().replace('\'','');
                    } 
                    if (fieldName.trim() == 'Link ID') {
                        tmpLinkID = fieldValue.trim().replace('\'','');
                    } 
                    if (fieldName.trim() == 'Target Close Date (yyyy-mm-dd)') {
                        tmpTargetCloseDate = fieldValue.trim().replace('\'','');
                    }
                    if (fieldName.trim() == 'Expected RFS Date (yyyy-mm-dd)') {
                        tmpExpectedRFSDate = fieldValue.trim().replace('\'','');
                    }
                    
                    
                    if (fieldName.trim() == 'PKS Number') {
                        tmpPKSNumber = fieldValue.trim().replace('\'','');
                    }
                    if (fieldName.trim() == 'COF Number') {
                        tmpCOFNumber = fieldValue.trim().replace('\'','');
                    }
                    
                    
                }
                system.debug ('==== tmpBPNumberSiteB : ' + tmpBPNumberSiteB + '##');
                
                Opportunity_Group_Item__c ogiTmp = new Opportunity_Group_Item__c();
                    
                ogiTmp.Opportunity_Group__c = opportunityGroup.id;
                ogiTmp.Opportunity_Name__c = tmpOpportunityName;
                
                system.debug ('==== tmpID : ' + tmpID);
                system.debug ('==== tmpBPNumberSiteA : ' + tmpBPNumberSiteA);
                system.debug ('==== tmpBPNumberSiteB : ' + tmpBPNumberSiteB);
                system.debug ('==== tmpLinkID : ' + tmpLinkID);
                
                
                if (tmpBPNumberSiteA <> '' && tmpBPNumberSiteA <> null)
					ogiTmp.putSObject('Account_Site_A_BP_Site__r', new Account(BP_Number__c = tmpBPNumberSiteA));
				
				if (tmpBPNumberSiteB <> '' && tmpBPNumberSiteB <> null)
					ogiTmp.putSObject('Account_Site_B_BP_Site__r', new Account(BP_Number__c = tmpBPNumberSiteB));
				
				if (tmpLinkID <> '' && tmpLinkID <> null)
					ogiTmp.putSObject('Link_Related__r', new Link__c(Link_ID__c = tmpLinkID));
				


				
				if (tmpTargetCloseDate <> '' && tmpTargetCloseDate <> null) {
					ogiTmp.tmp_Target_Closed_Date__c = tmpTargetCloseDate;
					/*
					date tmpDate = apputils.strToDate(tmpTargetCloseDate, 'yyyy-mm-dd');	
					if 	(tmpDate <> null) 
						ogiTmp.Target_Closed_Date__c = tmpDate;
						else 
							ogiTmp.tmp_Notes__c = 'Target Closed Date format is not valid. ';
							*/
				}
				
				if (tmpExpectedRFSDate <> '' && tmpExpectedRFSDate <> null) {
					ogiTmp.tmp_Expected_RFS_Date__c = tmpExpectedRFSDate;
					
					/*
					date tmpDate = apputils.strToDate(tmpExpectedRFSDate, 'yyyy-mm-dd');
					if 	(tmpDate <> null) 
						ogiTmp.Expected_RFS_Date__c = tmpDate;
						else 
							ogiTmp.tmp_Notes__c = ogiTmp.tmp_Notes__c  + 'Expected RFS Date format is not valid. ';
					*/
				}
				
				ogiTmp.PKS_Number__c = tmpPKSNumber;
				ogiTmp.COF_Number__c = tmpCOFNumber;
				
				
				ogiTmp.isUpload__c = true;
				ogiTmp.isSelect__c = true;
			
				system.debug ('==== tmpID : ' + tmpID);	
				if (tmpItemName == '' && tmpID == '') {
                	ogiListInsert.add (ogiTmp);
				}
				else {
					ogiTmp.id = tmpID;
                	ogiListUpdate.add (ogiTmp);
				}
                 
                
                
            }
            
            system.debug ('==== ogiListInsert : ' + ogiListInsert);
            system.debug ('==== ogiListUpdate : ' + ogiListUpdate);
            
            if (ogiListInsert.size() > 0) insert ogiListInsert;
            if (ogiListUpdate.size() > 0) update ogiListUpdate;
                      
        }
        
        catch(exception e){
            //readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file - ' + e.getMessage() + ' - ' + e.getLineNumber() ) ;
            ApexPages.addMessage(errorMessage);
        }
        
                
        
        getItemsList (oppGroupID, 'fromdoimportcsv');
        updateSelectedItems();
    
    }    
    
    public void doOppGroupUpdate(){
    	update opportunityGroup;
    	
    }
    
    
    public string wrapBulkOpportunityListJSON {get;set;}
    //public string bulkOppcsvheader {get;set;}
    
    //-- for export data
    public void getData() { 
    	list <Opportunity_Group__c> tmpOGList = new list <Opportunity_Group__c> ();
		system.debug ('==== masuk  getData()');
		system.debug ('==== wrapBulkOpportunityListJSON :' + wrapBulkOpportunityListJSON );
		system.debug ('==== oppGroupID :' + oppGroupID );
		
		/* Name, Opportunity Name,
					Related Opportunity,
					Opportunity ID, 
					BP Site A, 
					BP Site B, 
					BP Site A Account Name,
					BP Site B Account Name,
					Stage Name,
					Link ID,
					Price book, 
					Product, 
					Product (Installation) */
		
		if (needTemplate=='no')			
			bulkOppcsvheader = 'Name,Opportunity Name,Opportunity ID,BP Site A,BP Site B,BP Site A Account Name,BP Site B Account Name,Stage Name,Target Close Date (yyyy-mm-dd),Expected RFS Date (yyyy-mm-dd),PKS Number,COF Number,Price book,Product,Product (Installation),ID';
		else if (needTemplate=='yes')			
			bulkOppcsvheader = 'Opportunity Name,BP Site A,BP Site B,Target Close Date (yyyy-mm-dd),Expected RFS Date (yyyy-mm-dd),PKS Number,COF Number';
    	
    	
    	//if( wrapBulkOpportunityListJSON <> null) 
			// wrapItemsList = (List<Wrap_Item>) JSON.deserialize(wrapBulkOpportunityListJSON, List<Wrap_Item>.class);
			
			tmpOGList = [select items_string_1__c, items_string_2__c, items_string_3__c,
									items_string_4__c, items_string_5__c 
							from opportunity_group__c where id =:oppGroupID];
			if (tmpOGList.size() > 0) {
				system.debug ('==== tmpOGList[0].items_string_1__c :' + tmpOGList[0].items_string_1__c );
				/*
				if (tmpOGList.size() > 0 && ( tmpOGList[0].items_string_1__c <> '' && tmpOGList[0].items_string_1__c <> null) ) {
					wrapItemsList = (List<Wrap_Item>) JSON.deserialize( tmpOGList[0].items_string_1__c, List<Wrap_Item>.class);
				}*/
				
				string tmpString = tmpOGList[0].items_string_1__c + tmpOGList[0].items_string_2__c +
										tmpOGList[0].items_string_3__c + tmpOGList[0].items_string_4__c +
										tmpOGList[0].items_string_5__c ;
				
				system.debug ('==== tmpString :' + tmpString );
				wrapItemsList = (List<Wrap_Item>) JSON.deserialize( tmpString, List<Wrap_Item>.class);
			}
			
		system.debug ('==== wrapItemsList :' + wrapItemsList );
		
		//getLinkList (changePriceID, null, null);
		
	}
	
	public string getwrapitemsListJSONString () {
		system.debug ('=== lihat : ' + wrapItemsList);
		system.debug ('=== jSON.serialize(wrapItemsList) : ' + jSON.serialize(wrapItemsList));
		
		
		
    	return jSON.serialize(wrapItemsList);
    }
       
    public void updateItemStringForTemplate() {
     	opportunityGroup.items_string_1__c = ''; opportunityGroup.items_string_2__c = '';
		opportunityGroup.items_string_3__c = ''; opportunityGroup.items_string_4__c = '';
		opportunityGroup.items_string_5__c = '';
		
		List<Wrap_Item> wrapItemsListTmp = new List<Wrap_Item>();
		Wrap_Item WrapItem = new Wrap_Item();
		
		Opportunity_Group_Item__c ogi = new Opportunity_Group_Item__c();
		ogi.Opportunity_Group__c = opportunityGroup.id;
		ogi.Account_Site_A_BP_Site__c = null;
		ogi.Account_Site_B_BP_Site__c = null;
		ogi.Expected_RFS_Date__c = opportunityGroup.Expected_RFS_Date__c;
		
		ogi.Opportunity_Name__c = opportunityGroup.Opportunity_Name__c;
		ogi.Target_Closed_Date__c = opportunityGroup.Target_Closed_Date__c;
		ogi.PKS_number__c ='';
		ogi.COF_number__c ='';
		
		WrapItem.itemRec = ogi;
		WrapItem.selected = true;
		WrapItem.wrapIsDisable = true;
		WrapItem.notes = '';
		WrapItem.targetClosedDate = string.valueof(opportunityGroup.Target_Closed_Date__c);
		WrapItem.expectedRFSDate = string.valueof(opportunityGroup.Expected_RFS_Date__c);
		WrapItem.BPSiteA = '';
		WrapItem.BPSiteB = '';
		
		wrapItemsListTmp.add(WrapItem);
		string tmpString = jSON.serialize(wrapItemsListTmp);
		opportunityGroup.items_string_1__c = tmpString;
		update opportunityGroup;
    }
    
    public void updateItemString() {
    	system.debug ('=== updateItemString');
    	
    	//-- update items 1 string
		string tmpString = jSON.serialize(wrapItemsList);
		integer tmpStringLength = tmpString.length();
		integer variableNumber = 1;
		
		system.debug ('=== tmpStringLength : ' + tmpStringLength);
		
		integer stringMax =  131072;
		double tmpNumber = tmpStringLength / 131072; 
		integer sum = math.mod(tmpStringLength, 131072);
		if (sum>0) tmpNumber++;
		
		integer startChar=0;
		integer endChar=startChar + stringMax - 1 ;
		
		opportunityGroup.items_string_1__c = ''; opportunityGroup.items_string_2__c = '';
		opportunityGroup.items_string_3__c = ''; opportunityGroup.items_string_4__c = '';
		opportunityGroup.items_string_5__c = '';
		
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
	
			
			if (ind==1)
				opportunityGroup.items_string_1__c = tmpStringPartial;
			if (ind==2)
				opportunityGroup.items_string_2__c = tmpStringPartial;
			if (ind==3)
				opportunityGroup.items_string_3__c = tmpStringPartial;
			if (ind==4)
				opportunityGroup.items_string_4__c = tmpStringPartial;
			if (ind==5)
				opportunityGroup.items_string_5__c = tmpStringPartial;
			
			startChar = endChar ;
		}
		
		//opportunityGroup.items_string_1__c = tmpString;
		
		update opportunityGroup;
    }
    
    
}