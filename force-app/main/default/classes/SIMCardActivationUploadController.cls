public with sharing class SIMCardActivationUploadController {
 	class WrapOrderMSISDN {
        public integer no {get; set;} 
 		public boolean selected {get; set;}
 		public boolean isValid {get; set;}
 		public string ownerName {get; set;}
        public string ownerID {get; set;}
        public string status {get; set;}
 		public string note {get; set;}
 		public boolean wrapIsDisable {get; set;}
 		public Order_MSISDN__c orderMSISDN {get; set;}
 		
 		public WrapOrderMSISDN() {
 			orderMSISDN = new Order_MSISDN__c();
 		}
 	}
     
    Public Order orderRec {get;set;}
    Public integer sisaMSISDNNumbers {get;set;}
 	Public String orderSalesName {get; set;}
    Public String orderSalesID {get; set;} 
    Public String orderSFID {get; set;}
    Public String orderName {get; set;}
    Public String LAName {get; set;}

    Public string mode  {get;set;}
     
 	 
 	
 	ApexPages.StandardSetController setCon; 
    ApexPages.StandardController con;
 	
 	Order_MSISDN__c tmpOrderMSISDN {get;set;}
 	List<Order_MSISDN__c> tmpOrderMSISDNList {get;set;}
 	public List<WrapOrderMSISDN> wrapOrderMSISDNList {get;set;}

 	public List<WrapOrderMSISDN> wrapOrderMSISDNUploadList {get;set;}
 	public List<WrapOrderMSISDN> wrapOrderMSISDNDataList {get;set;}

 	Map<String, String> OrderMSISDNMap = new Map<String, String>();
    Map<string, MSISDN__c> msisdnMap = new Map<string, MSISDN__c>(); 
 		
 	public Blob csvFileBody {get;set;}
    public boolean isRequestToUpload {get; set;}
    public boolean isRequestToViewData {get; set;}

    public boolean checkBoxAllIsVisible {get; set;}
    public boolean checkBoxInRowIsVisible {get; set;}

    public string profileName {get;set;}
    public string orderRecordTypeName {get;set;}
    public string orderTypeName {get;set;}

 
 	public SIMCardActivationUploadController () {
 		system.debug ('=== masuk SIMCardActivationUploadController ()');
 		
 	}
 	
 	public SIMCardActivationUploadController (ApexPages.StandardSetController controller) {
 		system.debug ('=== masuk SIMCardActivationUploadController (ApexPages.StandardSetController controller)');
 		setCon = Controller;

        isRequestToUpload = false; 
        isRequestToViewData = true;

        checkBoxAllIsVisible = true ;
        checkBoxInRowIsVisible = true ;

 		tmpOrderMSISDN = new Order_MSISDN__c();
 		tmpOrderMSISDNList = new List<Order_MSISDN__c>();


        wrapOrderMSISDNList = new  List<WrapOrderMSISDN>(); 
        wrapOrderMSISDNUploadList = new  List<WrapOrderMSISDN>(); 
        wrapOrderMSISDNDataList = new  List<WrapOrderMSISDN>(); 
 		
 		orderSFID = ApexPages.currentPage().getParameters().get('id');
 		system.debug ('=== orderSFID : ' + orderSFID);



        Id profileId=userinfo.getProfileId();
        system.debug('profileId'+profileId);
        list<profile> profileNamelist=[Select Id,Name from Profile where Id=:profileId];
        
        profilename = profileNamelist[0].Name;
        /*
        'Sales'
        'Sales Admin'
        'Project Coordinator'
        'System Administrator'
        */
        
        if (profileName == 'Sales Admin') profileName = 'Sales';
        
        getOrdertMSISDDataList(orderSFID);
        wrapOrderMSISDNList = wrapOrderMSISDNDataList;
        mode='view';

    }
    
    public void getOrdertMSISDDataList (string orderSFID) {
        list<order> orderList = [select id, name, account.owner.name, LA__r.name, status, MSISDN_Numbers__c, MSISDN_List_Report__c, Order_MSISDN_Report_Path__c, recordtype.name  from order where id =:orderSFID];
        orderRec = new Order(); 
        integer maxLimit = integer.valueof (system.label.GSM_Activation_Max_Limit_Number);

        if (orderList.size() > 0) {
        	orderSalesName = orderList[0].account.owner.name;
            orderSalesID = orderList[0].account.owner.id;
            LAName = orderList[0].LA__r.name;
            orderName = orderList[0].name;
            orderRecordTypeName = orderList[0].recordtype.name ;

            switch on orderRecordTypeName {
                when 'POSTpaid Activation - New LA' {
                    orderTypeName = 'Postpaid Activation';
                }
                when 'POSTpaid Activation - Existing LA' {
                    orderTypeName = 'Postpaid Activation';
                }
                when 'Device Bundling - New LA' {
                    orderTypeName = 'Device Bundling'; 
                }
                when 'Device Bundling - Existing LA' {
                    orderTypeName = 'Device Bundling';
                }
                when 'Prepaid Tagging - New ID COM' {
                    orderTypeName = 'Prepaid Tagging';
                }
                when 'Prepaid Tagging - Existing ID COM' {
                    orderTypeName = 'Prepaid Tagging';
                }
                when 'Prepaid Untagging - Existing ID COM' {
                    orderTypeName = 'Prepaid Untagging';
                }

            }

            system.debug ('======= orderRecordTypeName  : ' + orderRecordTypeName);
            system.debug ('======= orderTypeName        : ' + orderTypeName);
            
            orderRec = orderList[0];
            sisaMSISDNNumbers = maxLimit - integer.valueof (orderRec.MSISDN_Numbers__c) ;
        }

        //-- get existing Order MSISDN data
        List<Order_MSISDN__c> orderMSISDNList = [select id, name, msisdn__c, iccid__c, New_MSISDN_IP__c, cl__c, pps__c, ao__c, email__c, Unique_ID__c, 
                                                        Credit_Class__c, PricePlan__c, name__c,
                                                        status__c, activation_status__c, pc_notes__c  
                                                    from order_msisdn__c 
                                                    where order__c=:orderSFID
                                                    order by name 
                                                    limit :maxLimit ];
        
		system.debug ('======= orderMSISDNList        : ' + orderMSISDNList);
        List<string> msisdnIDList = new List<string>();
        for (Order_MSISDN__c orderMSISDN : orderMSISDNList ) {
            msisdnIDList.add(orderMSISDN.msisdn__c);
        }
        List<MSISDN__c> msisdnList = [SELECT Id, OwnerId, Name, MSISDN_No__c, Account__c, Label__c, ICCID__c, Status__c, Active__c 
                                        FROM MSISDN__c WHERE Id in  :msisdnIDList  order by name ];

        
                                        msisdnMap = new Map<string, MSISDN__c>(); 
        for (MSISDN__c msisdn : msisdnList){
            if (orderTypeName == 'Postpaid Activation' || orderTypeName == 'Device Bundling') {
                msisdnMap.put (msisdn.iccid__c, msisdn);
            } 
            else if (orderTypeName == 'Prepaid Tagging' || orderTypeName == 'Prepaid Untagging') {
                msisdnMap.put (msisdn.Name, msisdn);
            }
        }
        //------------------------------------------
        integer rowNum=1;
        wrapOrderMSISDNDataList = new List<wrapOrderMSISDN>();
        for (Order_MSISDN__c orderMSISDN : orderMSISDNList ) {
            
            WrapOrderMSISDN tmpWrapOrderMSISDN = new WrapOrderMSISDN();
            tmpWrapOrderMSISDN.no=rowNum; rowNum++;
            tmpWrapOrderMSISDN.selected=true;
            tmpWrapOrderMSISDN.isValid =true;
            tmpWrapOrderMSISDN.ownerName = orderSalesName;
            tmpWrapOrderMSISDN.ownerID = orderSalesID;
            tmpWrapOrderMSISDN.status = orderMSISDN.Status__c;
            tmpWrapOrderMSISDN.orderMSISDN =  orderMSISDN;
            tmpWrapOrderMSISDN.orderMSISDN.Unique_ID__c = orderSFID + '-' + orderMSISDN.name; //*--TODO: ganti sementara ke msisdn orderMSISDN.iccid__c;

            wrapOrderMSISDNDataList.add (tmpWrapOrderMSISDN);

            //*-- sementara TODO: hanti ke iccid
            //OrderMSISDNMap.put(orderSFID + '-' + orderMSISDN.iccid__c, 'isavailable');
            OrderMSISDNMap.put(orderSFID + '-' + orderMSISDN.name, 'isavailable');


            MSISDN__c tmpMSISDN = new MSISDN__c();

            //--TODO: ini diganti ditambahin semua data termasuk ownerid (buat query)
            tmpMSISDN.id=orderMSISDN.msisdn__c; //<-- nga dipakai neh..

        }

    }

 	
 	public SIMCardActivationUploadController (ApexPages.StandardController controller) {
 		system.debug ('=== masuk SIMCardActivationUploadController (ApexPages.StandardController controller)');
 		con = controller;
 		tmpOrderMSISDN = new Order_MSISDN__c();
 		tmpOrderMSISDNList = new List<Order_MSISDN__c>();
	}   
	
	
	
	public void requestToUpload() {
        isRequestToUpload = true;
        isRequestToViewData = false;

        //--olsd way : wrapOrderMSISDNList = wrapOrderMSISDNUploadList;

        //-- remove data existing
        wrapOrderMSISDNDataList = new List<WrapOrderMSISDN>();
        wrapOrderMSISDNList = wrapOrderMSISDNUploadList;

        mode = 'upload';

    }
	public void requestToViewData() {
        isRequestToViewData = true;
        isRequestToUpload = false;

        //-- remove data upload
        wrapOrderMSISDNUploadList = new List<WrapOrderMSISDN>();

        //-- get data existing order MSISDN
        getOrdertMSISDDataList(orderSFID);
        wrapOrderMSISDNList = wrapOrderMSISDNDataList;
        mode='view';

    }


    
	public void CancelUpload () {
        isRequestToUpload = false;
    }
     
    public string IDCOMNumber () {
    	
    	return '' ;
    }

    
    
    public void tagging () {
    	
    	List<Order_MSISDN__c> orderMSISDNList = new List<Order_MSISDN__c>();
    	for (WrapOrderMSISDN wrapOrderMSISDN: wrapOrderMSISDNUploadList) {
    		if (wrapOrderMSISDN.selected) {
    			orderMSISDNList.add (wrapOrderMSISDN.orderMSISDN);
    		}
    	}
    	
    	system.debug ('== orderMSISDNList : ' + orderMSISDNList);
    	//TODO: check this script :: string orderSFID = (string) Con.getRecord().id;
    	//system.debug ('== con.getRecord().id : ' + orderSFID);
    	
    	
    	//insert orderMSISDNList;
    }

    public void submit () {
    	List<Order_MSISDN__c> doInsertOrderMSISDNList = new List<Order_MSISDN__c>();
        
        
        //-- PUT selected DATA to temporary variable for UPSERT (DML) ----------------------
		for (WrapOrderMSISDN objwrapOrderMSISDN  : wrapOrderMSISDNUploadList) {
        	if ( objwrapOrderMSISDN.selected == true && objwrapOrderMSISDN.isValid == true) {
        		doInsertOrderMSISDNList.add(objwrapOrderMSISDN.orderMSISDN);
        	}
        }
        
        try {
            system.debug ('==== doInsertOrderMSISDNList : ' + doInsertOrderMSISDNList);
            upsert doInsertOrderMSISDNList Unique_ID__c;

        } catch(Exception e) {
            apputils.puterror('Error on Submit method.:: ' + orderRec.name + ' ' + orderRec.id + 
                ' '+ e.getmessage() + ' - ' +e.getStacktraceString() +' ' +'::' + e.getLineNumber());
        	
        }
        //__________________________________________________________________________________



        //-- ROMOVE MSISDN data from upload list after submit --------------------------------------------
        integer ind=0;
        integer no=0;
        for (ind=0; ind< wrapOrderMSISDNUploadList.size() ;ind++) {
        	if ( wrapOrderMSISDNUploadList[ind].selected == true && wrapOrderMSISDNUploadList[ind].isValid == true) {
                wrapOrderMSISDNUploadList.remove(ind);
                ind=ind-1;
            }else {
                no++;
                wrapOrderMSISDNUploadList[ind].no = no;
            }


        } 
        //________________________________________________________________________________________________



        /* nga dipakai sudahh menggunakan getOrdertMSISDDataList saat 
        //-- GET SUBMIT (existing + submited) DATA , put on WRAP to display on page  wrapOrderMSISDNDataList -----
        List<Order_MSISDN__c> orderMSISDNList = [select id, name, msisdn__c, iccid__c, New_MSISDN_IP__c, cl__c, pps__c, ao__c, email__c, Unique_ID__c, 
            status__c, activation_status__c, pc_notes__c  from order_msisdn__c where order__c=:orderSFID];
        
        
        integer rowNum=1;
        wrapOrderMSISDNDataList = new  List<WrapOrderMSISDN>(); 
        for (Order_MSISDN__c orderMSISDN : orderMSISDNList ) {

            WrapOrderMSISDN tmpWrapOrderMSISDN = new WrapOrderMSISDN();
            tmpWrapOrderMSISDN.no=rowNum; rowNum++;
            //tmpWrapOrderMSISDN.selected=true;
            //tmpWrapOrderMSISDN.isValid =true;
            tmpWrapOrderMSISDN.ownerName = orderSalesName;
            tmpWrapOrderMSISDN.ownerID = orderSalesID;
            tmpWrapOrderMSISDN.orderMSISDN =  orderMSISDN;
            tmpWrapOrderMSISDN.orderMSISDN.Unique_ID__c = orderSFID + '-' + orderMSISDN.iccid__c;

            wrapOrderMSISDNDataList.add (tmpWrapOrderMSISDN);

        }
        //________________________________________________________________________________________________________
        */


        //mode='view';

    	
    } //-- endOf: Submit Method
    
    
    
    public void doImportCSV () {
        system.debug('============ masuk doImportCSV =======');
        
        List <String> dataLines = new List<String>();
        Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
        List<String> lstFieldNames = new List<String>();
        Integer fieldNumber;
        String fieldValue;        
        
        wrapOrderMSISDNUploadList = new list<wrapOrderMSISDN>();
        
        //--GET AO + Priceplan from Order Item, as validation criteria
        List <OrderItem> orderItemList = [select id, AO__c, AO_Priceplan__c, PricePlan__c from OrderItem where orderid =:orderSFID];
        Map <string, id> aoPriceplanMap = new Map <string, id>();
        for (OrderItem  oi : orderItemList) {
            aoPriceplanMap.put(oi.AO_Priceplan__c, oi.id);
        }

        try {
        	system.debug('===== csvFileBody  : ' + csvFileBody );
            string fileDataAsString = csvFileBody.toString();
            system.debug('===== fileDataAsString  : ' + fileDataAsString );
            fileDataAsString = fileDataAsString.replace(';', ',');    //-- replace ';' into ','
            
            system.debug('===== fileDataAsString  : ' + fileDataAsString );
            
            //readCSVFile();
            //--OLD WAY : 
            //dataLines  = fileDataAsString.split('\n');
            dataLines = appUtils.safeSplit (fileDataAsString, '\n'); 


            string[] csvFieldNames = dataLines[0].split(',');
            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                fieldNumberMap.put(csvFieldNames[i], i);
                lstFieldNames.add(csvFieldNames[i].trim());        
            }
            
            system.debug('===== dataLines : ' + dataLines);
            system.debug('===== csvFieldNames : ' + csvFieldNames);
            system.debug('===== dataLines.size() : ' + dataLines.size());

            //List<string> linkIDList = new List<string> ();
            tmpOrderMSISDNList = new List<Order_MSISDN__c>();
            
            List<string> tmpICCIDList = new List<string>();
            List<string> tmpMSISDNList = new List<string>();
            integer rowNum=1;


            integer maxRow=integer.valueof (system.label.GSM_Activation_Max_Limit_Number);
            //--nga jadi : maxRow = maxRow - integer.valueof ( orderRec.MSISDN_Numbers__c);

            integer dataLinesSize = dataLines.size()-1;  //old-way dataLines.size()-1
            maxRow = dataLinesSize < maxRow  ? dataLinesSize : maxRow;
            

            for (Integer i = 1; i <= maxRow; i++) {
                
                string[] csvRecordData = dataLines[i].split(',');
                system.debug('===== csvRecordData : ' + csvRecordData);
                system.debug('===== csvRecordData.size() : ' + csvRecordData.size() );

                if (csvRecordData.size() <> csvFieldNames.size()){   // jika field data-nya tidak sebanyak field header maka data kosong (abaikan)
                    continue;
                }

                //-- loop for FIELDS
                //tmpLinkID = '';
                string tmpName;
                string tmpICCID;
                string tmpMSISDN;
                string tmpNewMSISDN;
                string tmpCL;
                string tmpPPS;
                string tmpCreditClass;
                string tmpPricePlan;
                string tmpAO;
                string tmpEmail;
                string tmpActivationStatus;
                string tmpPCNotes;
                
                
                for (String fieldName: csvFieldNames) {
                    //-- get field value
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];

                    if (fieldName.trim() == 'Name') {
                        tmpName = fieldValue.trim();
                    }

                    if (fieldName.trim() == 'ICCID') {
                        tmpICCID = fieldValue.trim().replace('\'','').replace('/','');
                        //linkIDList.add(tmpLinkID);
                        //mapDataLinkUploaded.put(tmpLinkID, 'uploaded');
                    }                    
                    if (fieldName.trim() == 'MSISDN') {
                        tmpMSISDN = fieldValue.trim().replace('\'','').replace('/','');
                    }
                    if (fieldName.trim() == 'New MSISDN/IP') {
                        tmpNewMSISDN = fieldValue.trim().replace('\'','').replace('/','');
                    }
                    if (fieldName.trim() == 'CL') {
                        tmpCL = fieldValue.trim();
                    }
                    if (fieldName.trim() == 'PPS') {
                        tmpPPS = fieldValue.trim();
                    }
                    if (fieldName.trim() == 'Credit Class') {
                        tmpCreditClass = fieldValue.trim();
                    }
                    if (fieldName.trim() == 'Priceplan') {
                        tmpPriceplan = fieldValue.trim();
                    }
                    if (fieldName.trim() == 'AO') {
                        tmpAO= fieldValue.trim();
                    }
                    if (fieldName.trim() == 'Email') {
                        tmpEmail = fieldValue.trim();
                    }
                    if (fieldName.trim() == 'Status') {
                        tmpActivationStatus = fieldValue.trim();
                    }
                    if (fieldName.trim() == 'PC Notes') {
                        tmpPCNotes = fieldValue.trim();
                    }
                }
                
                
                //* sementara Todo : ganti ke iccid
                //string orderMSISDNIsAvailable=OrderMSISDNMap.get(orderSFID + '-' + tmpICCID);
                string orderMSISDNIsAvailable=OrderMSISDNMap.get(orderSFID + '-' + tmpMSISDN);
                


                //if (orderMSISDNIsAvailable <> 'isavailable') {

                    WrapOrderMSISDN objWrapOrderMSISDN = new wrapOrderMSISDN();
                    objWrapOrderMSISDN.no=rowNum; rowNum++;
                    objWrapOrderMSISDN.selected = true; 
                    objWrapOrderMSISDN.note = '';

                    if (tmpMSISDN<>null) objWrapOrderMSISDN.orderMSISDN.name = '/' + tmpMSISDN;
                    if (tmpICCID<>null) objWrapOrderMSISDN.orderMSISDN.iccid__c = '/' + tmpICCID;
                    if (tmpNewMSISDN<>null) objWrapOrderMSISDN.orderMSISDN.New_MSISDN_IP__c = '/' + tmpNewMSISDN; 
                    
                    if (orderTypeName=='Postpaid Activation' || orderTypeName=='Device Bundling' ) {
                        //-- PUT DATA in csv to WRAP Object
                        if (tmpCL <> null && tmpCL<>'' ) objWrapOrderMSISDN.orderMSISDN.CL__c = integer.valueof(tmpCL); 
                        if (tmpPPS <> null && tmpCL<>'' ) objWrapOrderMSISDN.orderMSISDN.PPS__c = integer.valueof(tmpPPS);
                        
                        objWrapOrderMSISDN.orderMSISDN.Credit_Class__c = tmpCreditClass;
                        objWrapOrderMSISDN.orderMSISDN.PricePlan__c = tmpPricePlan;
                        objWrapOrderMSISDN.orderMSISDN.AO__c = tmpAO;
                        objWrapOrderMSISDN.orderMSISDN.Email__c = tmpEmail;
                        objWrapOrderMSISDN.orderMSISDN.Name__c = tmpName;
                    }

                    objWrapOrderMSISDN.orderMSISDN.Unique_ID__c = orderSFID + '-' + tmpMSISDN; //*-TODO: sementara. ganti dari tmpICCID;
                    objWrapOrderMSISDN.orderMSISDN.Order__c = orderSFID;


                    //-- SET isVALID for the FIRST time---
                    objwrapOrderMSISDN.wrapIsDisable = false;
                    objwrapOrderMSISDN.isValid = true;
                    objWrapOrderMSISDN.selected = true;

                    //-- then do set inValid if finding the break rules
                    //------
                    
                    SYSTEM.DEBUG ('======== orderTypeName : ' + orderTypeName);
                    SYSTEM.DEBUG ('======== orderRec.status : ' + orderRec.status);

                    if ( (orderTypeName=='Postpaid Activation' || orderTypeName=='Device Bundling' ) && orderRec.status == 'Activation in Process' ) {
                    //-- STATUS CHECKING for project Coordinator and System Administrator
                        if (profileName == 'Project Coordinator' || profileName == 'System Administrator' ) {
                            objWrapOrderMSISDN.status = tmpActivationStatus;


                            if (tmpActivationStatus == 'Success' || tmpActivationStatus == 'Failed' || profileName == 'System Administrator' ) {
                                objWrapOrderMSISDN.orderMSISDN.status__c = tmpActivationStatus;


                                if ( tmpActivationStatus == 'Failed' && tmpPCNotes == '') {
                                    objWrapOrderMSISDN.note = objWrapOrderMSISDN.note + 'The Failed status need PC Notes (reason). ';
                                    objwrapOrderMSISDN.wrapIsDisable = true;
                                    objwrapOrderMSISDN.isValid = false;
                                    objWrapOrderMSISDN.selected = false;
                                }
                                
                                /*objwrapOrderMSISDN.wrapIsDisable = false;
                                objwrapOrderMSISDN.isValid = true;
                                objWrapOrderMSISDN.selected = true;*/
                            }
                            else {
                                
                                objWrapOrderMSISDN.note = objWrapOrderMSISDN.note + 'Status is wrong. Type Success or Failed. ';
                                objwrapOrderMSISDN.wrapIsDisable = true;
                                objwrapOrderMSISDN.isValid = false;
                                objWrapOrderMSISDN.selected = false;
                                
                            }

                            objWrapOrderMSISDN.orderMSISDN.PC_Notes__c = tmpPCNotes;
                        }

                        //-- SET FOR PREPAID MODE
                        objwrapOrderMSISDN.wrapIsDisable = false;
                        objwrapOrderMSISDN.isValid = true;
                        objWrapOrderMSISDN.selected = true;
                    }

                    //-- INVALID DATA HANDLING
                    boolean isValid = true;

                    if (orderTypeName=='Postpaid Activation' || orderTypeName=='Device Bundling' ) {   
                        //-- checking AO + Priceplan in Order Product
                        string tmpOIID = aoPriceplanMap.get(tmpAO+ ' ' +tmpPricePlan);
                        system.debug('==== tmpOIID      : ' + tmpOIID);
                        system.debug('==== AO Priceplan : ' + tmpAO+ ' ' +tmpPricePlan);

                        if (tmpOIID==null) {
                            objWrapOrderMSISDN.note = 'AO or Priceplan is not available in order items. ';
                            isValid = false;

                        } else {
                            //-- do something
                        }

                        //-- cheking Field Name. Name & Credit Class is mandatory
                        //Update by Kahfi on 4th April 2022
                        if (tmpName == '' || tmpCreditClass =='' || !tmpCreditClass.startsWithIgnoreCase('CX') ) {
                            objWrapOrderMSISDN.note = 'Field "Name" & "Credit Class" is mandatory or not valid. ' ;
                            isValid = false;
                        }                  
                        
                        
                        if (isValid == false) {
                            objwrapOrderMSISDN.wrapIsDisable = true;
                            objwrapOrderMSISDN.isValid = false;
                            objWrapOrderMSISDN.selected = false;
                        }
                    }


                    

                    wrapOrderMSISDNUploadList.add(objWrapOrderMSISDN);
                    
                    tmpICCIDList.add(tmpICCID);
                    tmpMSISDNList.add(tmpMSISDN);

                    //* sementera , todo : ganti ke iccid
                    //OrderMSISDNMap.put(orderSFID + '-' + tmpICCID, 'isavailable');
                    OrderMSISDNMap.put(orderSFID + '-' + tmpMSISDN, 'isavailable');
                //} 
            }
            
            system.debug('==== tmpICCIDList : ' + tmpICCIDList);
            system.debug('==== tmpMSISDNList : ' + tmpMSISDNList);
            

            List<msisdn__c> tmpMSISDNDataList = new List<msisdn__c>();
            if (orderTypeName=='Postpaid Activation' || orderTypeName=='Device Bundling' ) {
                tmpMSISDNDataList= [select id, name, iccid__c, owner.name ,
                                        Available_to_Activate__c, Activated__c, Request_to_Activate__c,
                                        Available_to_Tag__c, Tagged__c, Request_to_Tag__c,
                                        Available_to_UnTag__c, UnTagged__c, Request_to_UnTag__c
                                    from msisdn__c where iccid__c in :tmpICCIDList];
            }
            else if (orderTypeName=='Prepaid Tagging' || orderTypeName=='Prepaid Untagging') {
                tmpMSISDNDataList= [select id, name, iccid__c, owner.name, 
                                            Available_to_Activate__c, Activated__c, Request_to_Activate__c,
                                            Available_to_Tag__c, Tagged__c, Request_to_Tag__c,
                                            Available_to_UnTag__c, UnTagged__c, Request_to_UnTag__c
                                    from msisdn__c where name in :tmpMSISDNList];
            }
            
            system.debug('==== tmpMSISDNDataList : ' + tmpMSISDNDataList);
            
            for (MSISDN__c msisdn : tmpMSISDNDataList){
            	msisdnMap.put (msisdn.iccid__c, msisdn);
            }

            for (MSISDN__c msisdn : tmpMSISDNDataList){
                if (orderTypeName == 'Postpaid Activation' || orderTypeName =='Device Bundling') {
                    msisdnMap.put (msisdn.iccid__c, msisdn);
                } 
                else if (orderTypeName == 'Prepaid Tagging'  || orderTypeName=='Prepaid Untagging') {
                    msisdnMap.put (msisdn.Name, msisdn);
                }
            }

            system.debug('==== msisdnMap : ' + msisdnMap);
            
            
            for (WrapOrderMSISDN objwrapOrderMSISDN  : wrapOrderMSISDNUploadList) {
            	system.debug('==== objwrapOrderMSISDN : ' + objwrapOrderMSISDN);
                system.debug('==== objwrapOrderMSISDN.orderMSISDN.iccid__c : ' + objwrapOrderMSISDN.orderMSISDN.iccid__c    );
				
				string iccidTmp;	
				string msisdnTmp;
				MSISDN__c tmpMSISDN = new MSISDN__c();
				if(objwrapOrderMSISDN.orderMSISDN.iccid__c != '' && objwrapOrderMSISDN.orderMSISDN.iccid__c != null){
                	iccidTmp = objwrapOrderMSISDN.orderMSISDN.iccid__c.replace('/','') ;
				}
				if(objwrapOrderMSISDN.orderMSISDN.name != '' && objwrapOrderMSISDN.orderMSISDN.name != null){
					msisdnTmp = objwrapOrderMSISDN.orderMSISDN.name.replace('/','') ;
				}
                system.debug ('===== iccidTmp : ' + iccidTmp);

                

                if (orderTypeName == 'Postpaid Activation' || orderTypeName == 'Device Bundling') {
                    tmpMSISDN = msisdnMap.get(iccidTmp);
                } 
                else if (orderTypeName == 'Prepaid Tagging'  || orderTypeName=='Prepaid Untagging') {
                    tmpMSISDN = msisdnMap.get(msisdnTmp); 
                }
				
                

            	system.debug('==== tmpMSISDN : ' + tmpMSISDN);
            	if (tmpMSISDN <> null) {
                    objwrapOrderMSISDN.ownerID = tmpMSISDN.ownerid;
                    objwrapOrderMSISDN.ownerName = tmpMSISDN.owner.name;
                    
                    
	            	if (objwrapOrderMSISDN.ownerID  <> orderSalesID) {
	            		//-- jika owner MSISDN bukan Sales yang Order (related to account owner)

                        system.debug('==== cek owner : ' + objwrapOrderMSISDN.ownerID  + ' <> ' + orderSalesID);
                        system.debug ('===== objWrapOrderMSISDN.note (1) : ' + objWrapOrderMSISDN.note);
	            		objwrapOrderMSISDN.note = objWrapOrderMSISDN.note +'This is not your MSISDN, see the Owner Name. ';
	            		
                    } else {
                    }

                    if (orderTypeName == 'Postpaid Activation' || orderTypeName == 'Device Bundling') {
                        if ( tmpMSISDN.activated__c ==true ) {
                            objwrapOrderMSISDN.isValid = false;
                            objwrapOrderMSISDN.note = objWrapOrderMSISDN.note +'This MSISDN status is ACTIVATED. ';
                        }
                    } 
                    else if (orderTypeName == 'Prepaid Tagging' ) {
                        if ( tmpMSISDN.tagged__c == true ) {
                            objwrapOrderMSISDN.isValid = false;
                            objwrapOrderMSISDN.note = objWrapOrderMSISDN.note +'This MSISDN status is TAGGED. ';
                        }

                        if ( tmpMSISDN.Request_to_Tag__c == true ) {
                            objwrapOrderMSISDN.isValid = false;
                            objwrapOrderMSISDN.note = objWrapOrderMSISDN.note +'This MSISDN have been reserved to tag. ';
                        }
                    }
                    else if (orderTypeName=='Prepaid Untagging') {
                        if ( tmpMSISDN.untagged__c == true ) {
                            objwrapOrderMSISDN.isValid = false;
                            objwrapOrderMSISDN.note = objWrapOrderMSISDN.note +'This MSISDN status is UNTAGGED. ';
                        }
                    }

                    if (objwrapOrderMSISDN.isValid == true) {
                        
                        objwrapOrderMSISDN.selected = true;
                        objwrapOrderMSISDN.wrapIsDisable = false;
                        objwrapOrderMSISDN.ordermsisdn.msisdn__c = tmpMSISDN.id ; 
                    } else {
                        objwrapOrderMSISDN.selected = false;
                        objwrapOrderMSISDN.wrapIsDisable = true;
                        objwrapOrderMSISDN.selected = false;

                    }

            	} else {
            		objwrapOrderMSISDN.isValid = false;
                    objwrapOrderMSISDN.selected = false;
                    objwrapOrderMSISDN.wrapIsDisable = true;
                    system.debug ('===== objWrapOrderMSISDN.note (2) : ' + objWrapOrderMSISDN.note);
            		objwrapOrderMSISDN.note = objWrapOrderMSISDN.note + 'ICCID/MSISDN is not registered in system. ';
            	}
            }
            
            system.debug('==== wrapOrderMSISDNUploadList : ' + wrapOrderMSISDNUploadList);
            
            wrapOrderMSISDNList = wrapOrderMSISDNUploadList;
            mode='upload';
        }
        
        catch(exception e){
            //readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file ' +
            	e.getStackTraceString()+ ' ' + e.getmessage() + ' ' + e.getLineNumber() );
            
             
            ApexPages.addMessage(errorMessage);
        }
    }  
    
    
    
	public void doExistingMSISDNExportCSV () {
        system.debug('============ masuk doExistingMSISDNExportCSV =======');
    }

	public void doUploadMSISDNExportCSV () {
        system.debug('============ masuk doUploadMSISDNExportCSV =======');
    }


    public void doDeleteSelected () { 
        system.debug('============ masuk doDeleteSelected =======');

        List <Order_MSISDN__c> doDeleteOrderMSISDNList = new List <Order_MSISDN__c>();
		for (WrapOrderMSISDN objwrapOrderMSISDN  : wrapOrderMSISDNList) {
        	if ( objwrapOrderMSISDN.selected == true) {
        		doDeleteOrderMSISDNList.add(objwrapOrderMSISDN.orderMSISDN);
        	}
        }

        try {
            delete doDeleteOrderMSISDNList;

            getOrdertMSISDDataList(orderSFID);
            wrapOrderMSISDNList = wrapOrderMSISDNDataList;
            mode='view';

        } 
        catch (exception e){
            //readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error in delete process ' +
            	e.getStackTraceString()+ ' ' + e.getmessage() + ' ' + e.getLineNumber() );
             
            ApexPages.addMessage(errorMessage);
        }

    }

}