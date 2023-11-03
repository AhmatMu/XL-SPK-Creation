@isTest(seealldata=true)	
public with sharing class Test_Opportunity_Group_Item_Controller {    
    static testMethod void testMethod1() {
    	
    	Test.startTest();  
		
		//-- Opportunity Group
        Opportunity_Group__c ogNew = new Opportunity_Group__c();
        list<pricebook2> pbList = [select id, name from pricebook2 where name='MPLS'];
        ogNew.Price_book__c = pbList[0].id;
        
        list<pricebookentry> pbEntryList = [select id, Product2.name, product2id from pricebookentry where 
        										Pricebook2Id=:ogNew.Price_book__c and
												(Product2.name = 'MPLS - 1 Mbps' or Product2.name = 'Instalasi MPLS' )];  
        
        ogNew.Product__c = pbEntryList[0].product2id;
        ogNew.Product_installation__c = pbEntryList[1].product2id;
        
        Account acc = [select id from Account where organization_type__c ='Head Office' limit 1];
        ogNew.opportunity_name__c= 'sample';
        ogNew.Account__c =  acc.id;
        ogNew.Contract_Period__c = 5;
        ogNew.Target_Closed_Date__c = system.today();
		ogNew.Expected_RFS_Date__c = system.today();
        ogNew.BP_Payer__c = acc.id ;
        ogNew.BP_VAT__c = acc.id ;
        
        
        insert ogNew;
        system.debug('==== test ogNew : ' + ogNew);
        
		
		//--
		List<Opportunity_Group_Item__c> ogiList = new List<Opportunity_Group_Item__c>();
		
		//-- Opportunity Group Item
		Opportunity_Group_Item__c ogi = new Opportunity_Group_Item__c();
		ogi.Opportunity_Group__c = 	ogNew.id;
		ogi.Opportunity_Name__c = 'opp name';
		ogi.Target_Closed_Date__c = system.today();
		ogi.Expected_RFS_Date__c = system.today();
		ogi.Related_Opportunity__c = null;
		ogi.Account_Site_A_BP_Site__c = null;	
		ogi.Account_Site_B_BP_Site__c = null;
        ogi.Periode_UOM__c='Month';
        ogi.Auto_Renewal__c= FALSE ;
        ogi.Trial__c= True;
        
		ogiList.add(ogi);
		
		ogi = new Opportunity_Group_Item__c();
		ogi.Opportunity_Group__c = 	ogNew.id;
		ogi.Opportunity_Name__c = 'opp name2';
		ogi.Target_Closed_Date__c = system.today();
		ogi.Expected_RFS_Date__c = system.today();
		ogi.Related_Opportunity__c = null;
		ogi.Account_Site_A_BP_Site__c = acc.id;	
		ogi.Account_Site_B_BP_Site__c = acc.id;
        ogi.Periode_UOM__c='Month';
        ogi.Auto_Renewal__c= FALSE ;
        ogi.Trial__c= True;
        
        
		ogiList.add(ogi);
		
		insert ogiList;

		Opportunity_Group_Item_Controller ogiCon = new  Opportunity_Group_Item_Controller();
 		
 		ApexPages.CurrentPage().getparameters().put('id', ogNew.id);   
    	ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(ogiList);
    	//System.currentPageReference().getParameters().put('id', ogNew.id );
    	Opportunity_Group_Item_Controller OGISetController = new Opportunity_Group_Item_Controller (ssc); 
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ogi);
		Opportunity_Group_Item_Controller OGIController = new Opportunity_Group_Item_Controller (sc); 
        
        
        OGISetController.pb = pbList[0];
        OGISetController.stageNameIsChecked = false;
        OGISetController.serviceType = 'New';
        OGISetController.tmpStageName = 'Prospecting';
        
        
        
        OGISetController.getItemsList(ogNew.id, 'fromcreateopportunityselecteditems');
        OGISetController.getStagelist();
        OGISetController.showGenerateSection();
        OGISetController.hideGenerateSection();
        OGISetController.showMassUpdateSection();
        OGISetController.hideMassUpdateSection();
        OGISetController.showImportSection();
        OGISetController.hideImportSection();
        
        OGISetController.genRecordNumber=2;
        OGISetController.generateItems();
        
        
        OGISetController.moveStageSelectedItems();
        OGISetController.updateSelectedItem();
        
        
        OGISetController.wrapItemsList[0].selected=true;
        OGISetController.wrapItemsList[1].selected=true;
        OGISetController.wrapItemsList[0].BPSiteA=acc.id; OGISetController.wrapItemsList[0].BPSiteB=acc.id;
        OGISetController.wrapItemsList[1].BPSiteA=acc.id; OGISetController.wrapItemsList[1].BPSiteB=acc.id;
        
        OGISetController.createOpportunitySelectedItems();
        
        OGISetController.wrapItemsList[0].selected=true;
        OGISetController.wrapItemsList[1].selected=true;
        OGISetController.updateSelectedItems();
        
        OGISetController.refreshItems();
        
        string datalinks = 'Name,Opportunity Name,Opportunity ID,BP Site A,BP Site B,BP Site A Account Name,BP Site B Account Name,Stage Name,Target Close Date,Expected RFS Date,Price book,Product,Product (Installation),ID\nOGI-1907-00000164,Opportunity item - 1 cak,1907-002965,730231,,PT. Provinsi Jawa Barat,,Prospecting,2019-07-21,2019-08-01,MPLS,MPLS - 4 Mbps,Instalasi MPLS,a0g5D000000eJWJQA2' ;
		OGISetController.csvFileBody   = Blob.valueOf(datalinks) ;
            
        OGISetController.doImportCSV();
        
        OGISetController.doOppGroupUpdate();

		OGISetController.updateItemStringForTemplate();
        OGISetController.updateItemString();        
        OGISetController.getData();
        
        
        OGISetController.wrapItemsList[0].selected=true;
        OGISetController.deleteSelectedItems();
        
        Test.stopTest();
    }
}