trigger Trigger_BAP on BAP__c (before update, before insert, after update) {
    
    string bapid; 
    string typeOfRequest; 
    string customer; 
    string cid; 
    string sirkit; 
    string address;
    string pic; 
    string picPhone; 
    string picEmail; 
    string picPosition; 
    string bandwidth;
    string bandwidthUom; 
    string requestDate; 
    string terminateDate; 
    string reason; 
    string note; 
    string userCreate ;  
    string request_status; 
    string iom_file_link;
    string termination_for_nonautorenewal = 'false';
    
    integer approveType ;
    string approveEmail;
    string approveDate;
    
    string linksInfo;
    
    // Look up record type id
    String recordTypeName = 'Termination'; // <-- Change this to record type name
    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.BAP__c.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
    id recordTypeId = rtInfo.getRecordTypeId();

    Schema.RecordTypeInfo rtInfo_Temporary_Isolation =  rtMapByName.get('Temporary Isolation');
    id recordTypeId_Temporary_Isolatio = rtInfo_Temporary_Isolation.getRecordTypeId();

    Schema.RecordTypeInfo rtInfo_EndOfContract =  rtMapByName.get('End of Contract');
    id recordTypeId_EndOfContract = rtInfo_EndOfContract.getRecordTypeId();
    
    if(system.label.IS_TRIGGER_BAP_ON=='YES')
    {
        if (Trigger.isAfter){
            System.debug('********Trigger values- AFTER ***********');    
        	System.debug('***SFDC: Trigger.old is: ' + Trigger.old);
        	System.debug('***SFDC: Trigger.new is: ' + Trigger.new);
            
            if( Trigger.isUpdate ){
                system.debug ('== trigger.new.size : ' +  trigger.new.size());
                
                for (BAP__c bap : trigger.new) {
                    
                    if(bap.RecordTypeId == recordTypeId){
                        system.debug ('== bap      : ' +  bap);
                        
                        //BAP__c bapOLD = new BAP__c();
                        BAP__c bapOLD=Trigger.oldMap.get(bap.id);
                        
                        if(system.isFuture()) return; 
                        
                        if ( bap.request_status__C=='BA Sent to Customer' && bapOLD.request_status__C!='BA Sent to Customer' ){  
                            
                            system.debug ('== IN BA SENT TO CUSTOMER');
                            //REST_BAPs restBAP = new REST_BAPs ();
                            //restBAP.addBAP();
                            
                            system.debug ('== siap-siap REST_BAPs_v2.mirroringBAP');
                            
                            bapid = bap.BAP_ID__c;
                            typeOfRequest = null;
                            customer = null;
                            cid = null;
                            sirkit = null;
                            address = null;
                            pic = null;
                            picPhone = null; 
                            picEmail = null;
                            picPosition = null;
                            if (!String.isBlank(picPosition)) {
                                picPosition = picPosition.replace(';',',');
                            }
                            
                            bandwidth = null;
                            bandwidthUom = null;
                            
                            //Date d = bap.Request_Date__c;
                            //Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
                            requestDate = null ; 
                            
                            //d = bap.Terminate_Date__c;
                            //dt = datetime.newInstance(d.year(), d.month(),d.day());
                            terminateDate = null;
                            
                            reason = null;
                            note = null;
                            userCreate = null;
                            request_status = 'BAP Sent to Customer';
                            
                            list<ContentDistribution> CDList=[SELECT id,DistributionPublicUrl FROM ContentDistribution WHERE name=:BAP.name order by createddate desc];
                            //BAP__c B=new BAP__c();
                            //B.id=BAPid;
                            //B.iom_file_link__c=CD2.DistributionPublicUrl;
                            
                            if ( CDList.size() > 0 ) {
                                iom_file_link = CDList[0].DistributionPublicUrl;
                            }
                            
                            
                            
                            if(!test.isRunningTest())
                            {
                                REST_BAPs_v2.mirroringBAP( bap.id, bapid,
                                                          typeOfRequest, customer, cid, sirkit, address,
                                                          pic, picPhone, picEmail, picPosition, bandwidth,
                                                          bandwidthUom, requestDate, terminateDate, reason, 
                                                          note, userCreate, request_status ,iom_file_link, termination_for_nonautorenewal
                                                         );
                            }
                            
                        }
                        
                        
                        
                        /** Add by doddy June 30, 2020
*  Handling status move to draft
*  Action : call api for mirroring/update BAP status
* 
* */ 
                        
                        if ( bap.request_status__C=='Draft' && bapOLD.request_status__C!='Draft' ){  
                            system.debug ('== IN status move to DRAFT');
                            system.debug ('== siap-siap REST_BAPs_v2.mirroringBAP for status DRAFT');
                            
                            bapid = bap.BAP_ID__c;
                            typeOfRequest = null;
                            customer = null;
                            cid = null;
                            sirkit = null;
                            address = null;
                            pic = null;
                            picPhone = null; 
                            picEmail = null;
                            picPosition = null;
                            bandwidth = null;
                            bandwidthUom = null;                    
                            requestDate = null ; 
                            terminateDate = null;
                            reason = null;
                            note = null;
                            userCreate = null;
                            iom_file_link = null;
                            
                            request_status = 'DRAFT';
                            
                            
                            if(!test.isRunningTest())
                            {
                                REST_BAPs_v2.mirroringBAP( bap.id, bapid,
                                                          typeOfRequest, customer, cid, sirkit, address,
                                                          pic, picPhone, picEmail, picPosition, bandwidth,
                                                          bandwidthUom, requestDate, terminateDate, reason, 
                                                          note, userCreate, request_status ,iom_file_link,termination_for_nonautorenewal
                                                         );
                            }   
                            
                            
                        }
                        
                        //-- OLD ver. if ( bap.request_status__C=='Canceled' && bapOLD.request_status__C!='Canceled' ){  
                        
                        //-- NEW ver.
                        if ( bap.request_status__C =='Complete'
                            	&& bapOLD.request_status__C != 'Complete'  
                           		&& bap.complete_status__c == 'Canceled'
                           ) 
                        
                        {  
                            system.debug ('== IN status move to Canceled');
                            system.debug ('== siap-siap REST_BAPs_v2.mirroringBAP for status Canceled');
                            
                            bapid = bap.BAP_ID__c;
                            typeOfRequest = null;
                            customer = null;
                            cid = null;
                            sirkit = null;
                            address = null;
                            pic = null;
                            picPhone = null; 
                            picEmail = null;
                            picPosition = null;
                            bandwidth = null;
                            bandwidthUom = null;                    
                            requestDate = null ; 
                            terminateDate = null;
                            reason = null;
                            note = null;
                            userCreate = null;
                            iom_file_link = null;
                            
                            request_status = 'Canceled';
                            
                            
                            if(!test.isRunningTest())
                            {
                                REST_BAPs_v2.mirroringBAP( bap.id, bapid,
                                                          typeOfRequest, customer, cid, sirkit, address,
                                                          pic, picPhone, picEmail, picPosition, bandwidth,
                                                          bandwidthUom, requestDate, terminateDate, reason, 
                                                          note, userCreate, request_status ,iom_file_link,termination_for_nonautorenewal     
                                                         );
                            }   
                            
                            
                        }
                    }
                    
                }
                
                
                
            }
            
        }
        
        if (Trigger.isBefore){
            System.debug('********Trigger values - BEFORE ***********');
        	System.debug('***SFDC: Trigger.old is: ' + Trigger.old);
        	System.debug('***SFDC: Trigger.new is: ' + Trigger.new);

            if( Trigger.isInsert ){
                for (BAP__c bap : trigger.new) {
                    if(bap.RecordTypeId == recordTypeId || bap.RecordTypeId == recordTypeId_Temporary_Isolatio){      
                        //-- SET DEFAULT --
                        
                        // set LINKS                
                        string cid=bap.CID__c;
                        system.debug('=============== cid : ' + cid);
                        system.debug('=============== cid2 : ' + bap.link__C);
                        system.debug('=============== cid3 : ' + bap.link__r.name);
                        system.debug('=============== cid3 : ' + bap.CID__c);
                        
                        
                        List<Link__c> links = [SELECT link_id__c from link__c where name=:cid];
                        system.debug('=============== links : ' + links);
                        
                        linksInfo=''; 
                        integer no =1;
                        for (Link__c link : links){
                            //linksInfo = linksInfo + '&nbsp;' + '&nbsp;' + no + '. ' + link.link_id__c + '<br />'; 
                            linksInfo = linksInfo + no + '. ' + link.link_id__c + '\r\n'; 
                            no = no+1;
                        }
                        bap.links_info__c = linksInfo;
                        system.debug('=============== linksInfo : ' + linksInfo);
                        
                        // set PIC Name, Phone, email, and position
                        string accID = bap.Customer__c;
                        
                        List <AccountContactRelation> accContacts =  [SELECT AccountId, Contact.name, Contact.phone, Contact.email,Contact.Title , Id, Roles FROM AccountContactRelation where AccountId =:accID ] ;
                        system.debug('=============== accContacts : ' + accContacts );
                        
                        string picNames='' ;
                        string picPhones='' ;
                        string picEmails='' ;
                        string picPositions='' ;
                        
                        if (accContacts .size() >0 ) {
                            for (AccountContactRelation accContact : accContacts ) {
                                if (accContact.Contact.name<> null) picNames = picNames  + accContact.Contact.name  + ',';
                                if (accContact.Contact.phone <> null) picPhones= picPhones+ accContact.Contact.phone + ',';
                                if (accContact.Contact.email<> null) picEmails= picEmails+ accContact.Contact.email  + ',';
                                if (accContact.Contact.Title <> null) picPositions= picPositions+ accContact.Contact.Title  + ', ';
                            }
                        }
                        integer l = picEmails.length() -1 ;
                        if (picEmails <>'' ) { picEmails = picEmails.removeEnd(',') ; }
                        
                        if (bap.pic_name__c == '' || bap.pic_name__c == null) { bap.pic_name__c = picNames ; }
                        if (bap.pic_phone__c == '' || bap.pic_phone__c == null) { bap.pic_phone__c = picPhones ; }
                        
                        if (bap.pic_email__c == '' || bap.pic_email__c == null ) { bap.pic_email__c = picEmails; }
                        if (bap.pic_position__c == '' || bap.pic_position__c == null ) { bap.pic_position__c = picPositions; }
                        
                        if (bap.Address2__c =='' || bap.Address2__c == null ) {
                            bap.address2__c = bap.address__c ;
                        }
                    }

                    if(bap.RecordTypeId == recordTypeId_EndOfContract){      
                        //-- SET DEFAULT --
                        
                        // set LINKS                
                        string cid=bap.CID__c;
                        system.debug('=============== cid : ' + cid);
                        system.debug('=============== cid2 : ' + bap.link__C);
                        system.debug('=============== cid3 : ' + bap.link__r.name);
                        system.debug('=============== cid3 : ' + bap.CID__c);
                        
                        
                        List<Link__c> links = [SELECT link_id__c from link__c where name=:cid];
                        system.debug('=============== links : ' + links);
                        
                        linksInfo=''; 
                        integer no =1;
                        for (Link__c link : links){
                            //linksInfo = linksInfo + '&nbsp;' + '&nbsp;' + no + '. ' + link.link_id__c + '<br />'; 
                            linksInfo = linksInfo + no + '. ' + link.link_id__c + '\r\n'; 
                            no = no+1;
                        }
                        bap.links_info__c = linksInfo;
                        system.debug('=============== linksInfo : ' + linksInfo);
                        
                        // set PIC Name, Phone, email, and position
                        string accID = bap.Customer__c;
                        
                        List <AccountContactRelation> accContacts =  [SELECT AccountId, Contact.name, Contact.phone, Contact.email, Id, Roles FROM AccountContactRelation where AccountId =:accID ] ;
                        system.debug('=============== accContacts : ' + accContacts );
                        
                        if (bap.Address2__c == '' || bap.Address2__c == null ) {
                            bap.address2__c = bap.address__c ;
                        }
                    }
                }
            }
            
			/*	AggregateResult[] LinkEntityIdList = [SELECT ContentDocumentId, count(LinkedEntityId) FROM ContentDocumentLink 
													WHERE LinkedEntityId IN:bapids GROUP BY ContentDocumentId];
				
			If (LinkEntityIdList.size() < bapIds.size() ){
			//		bap.adderror('belum ada file attachment !');
				 system.debug ('======== error  : Belum ada file attachment ');
			}*/
			
            
            
            
            if( Trigger.isUpdate ){

                //Validasi attachment BAP
                /*Set <id> bapIds = new Set<id>();
                for (BAP__c bap : trigger.new) {
                    
                    BAP__c bapOLD = Trigger.oldMap.get(bap.id);
                    system.debug ('bapOLD :'+bapOLD);
                    if(bap.RecordTypeId == recordTypeId || bap.RecordTypeId == recordTypeId_Temporary_Isolatio){
                        if( bap.request_status__C=='Submit' && bapOLD.request_status__C=='Draft'  ){ 
                            bapIds.add(bap.id);
                        }
                        system.debug ('bapIds :'+bapIds);
                        AggregateResult[] LinkEntityIdList = [SELECT ContentDocumentId, count(LinkedEntityId) Total FROM ContentDocumentLink 
                                                        WHERE LinkedEntityId IN:bapids GROUP BY ContentDocumentId];
                        
                        decimal totalRecord = 0;
                        if (LinkEntityIdList.size() > 0 ) {
                            totalRecord = (decimal) LinkEntityIdList[0].get('total') ;
                            system.debug ('totalRecord :'+totalRecord);
                        }
                        
                        If (totalRecord < bapIds.size() ){
                                bap.adderror('belum ada file attachment !');
                        }
                    }	
                }*/

                for (BAP__c bap : trigger.new) {
                    
                    BAP__c bapOLD = new BAP__c();
                    bapOLD = Trigger.oldMap.get(bap.id);

                    if(bap.RecordTypeId == recordTypeId){

                        system.debug ('======== cek : ' + bap.request_status__C + ' - ' + bapOLD.request_status__C);
                        system.debug ('======== bap.BAP_ID__c : ' + bap.BAP_ID__c);
                        /*
//-- approval IOM-1: by Sales Manager
if( Trigger.isUpdate && 
(bap.Approval_Status_by_Sales_Manager__c=='Approved' 
&& bapOLD.Approval_Status_by_Sales_Manager__c<> 'Approved')  ){  

bapid = bap.BAP_ID__c;
system.debug ('======== bapid : ' + bapid);
approveType = 1;
approveEmail = bap.Sales_Manager_Email__c;
approveEmail = 'eriyantos@xl.co.id';  // SEMENTARA!!! 


Datetime d = datetime.now();
bap.Approval_Date_by_Sales_Manager__c = d;
approveDate = d.format('yyyy-MM-dd kk:mm:ss');

if (bap.Approval_IOM__c=='2' || bap.Approval_IOM__c=='3'  )
bap.Approval_status__C = 'Need GM Sales Approval';
else bap.Approval_status__C = 'Approved';            

REST_BAPs_v2.approvalBAP(bapid,
approveType, approveEmail, approveDate) ;
}

//-- approval IOM-2: by GM Sales
if( Trigger.isUpdate && 
(bap.Approval_Status_by_GM_Sales__c=='Approved' 
&& bapOLD.Approval_Status_by_GM_Sales__c<> 'Approved')  ){  

bapid = bap.BAP_ID__c;
approveType = 2;
approveEmail = bap.GM_Sales_Email__c;
approveEmail = 'rudysumadi@xl.co.id';  // SEMENTARA!!! 

Datetime d = datetime.now();
bap.Approval_Date_by_GM_Sales__c = d;
approveDate = d.format('yyyy-MM-dd kk:mm:ss');

if (bap.Approval_IOM__c=='3'  )
bap.Approval_status__C = 'Need Senior GM Operation Approval';
else bap.Approval_status__C = 'Approved';                                    

REST_BAPs_v2.approvalBAP(bapid,
approveType, approveEmail, approveDate) ;
}

system.debug('=================== XX : ' + bap.Approval_Status_by_Senior_GM_Operation__c +'   '+bapOLD.Approval_Status_by_Senior_GM_Operation__c) ;
//-- approval IOM-3: by GM Operation
if( Trigger.isUpdate && 
(bap.Approval_Status_by_Senior_GM_Operation__c=='Approved' 
&& bapOLD.Approval_Status_by_Senior_GM_Operation__c<> 'Approved')  ){  


bapid = bap.BAP_ID__c;
approveType = 3;
approveEmail = bap.Senior_GM_Operation_Email__c;
approveEmail = 'sigit@xl.co.id';  // SEMENTARA!!!                    

Datetime d = datetime.now();
bap.Approval_Date_by_Senior_GM_Operation__c = d;
approveDate = d.format('yyyy-MM-dd kk:mm:ss');        

bap.Approval_Status_by_Senior_GM_Operation__c = 'Approved' ;
bap.Approval_status__C = 'Approved';                            

REST_BAPs_v2.approvalBAP(bapid,
approveType, approveEmail, approveDate) ;
}               

system.debug (' ================ approveType  : ' + approveType );
system.debug (' ================ approveEmail : ' + approveEmail );
system.debug (' ================ approveDate  : ' + approveDate );        
*/
                        
                        system.debug ('== ready to SUBMIT CHECKING');
                        system.debug ('== bap.request_status__C : ' +  bap.request_status__C);
                        system.debug ('== bapOLD.request_status__C : ' +  bapOLD.request_status__C);
                        
                        system.debug ('== bapOLD.request_status__C : ' +  bapOLD.request_status__C);
                        system.debug ('== Trigger.isUpdate : ' +  Trigger.isUpdate);
                        system.debug ('== test.isRunningTest() : ' +  test.isRunningTest());
                        
                        if( Trigger.isUpdate && 
                           ((bap.request_status__C=='Submit' && bapOLD.request_status__C=='Draft')||test.isRunningTest())  ){  
                               
                               system.debug ('== IN SUBMIT');
                               //REST_BAPs restBAP = new REST_BAPs ();
                               //restBAP.addBAP();
                               
                               bapid = bap.BAP_ID__c;
                               typeOfRequest = bap.Type_of_Request__c;
                               customer = bap.Customer__c;
                               cid = bap.CID__c;
                               sirkit = bap.Sirkit__c;
                               address = bap.Address2__c;
                               pic = bap.PIC_Name__c;
                               picPhone = bap.PIC_Phone__c; 
                               picEmail = bap.PIC_email__c;
                               picPosition = bap.PIC_Position__c;
                               if (!String.isBlank(picPosition)) {
                                   picPosition = picPosition.replace(';',',');
                               }
                               
                               bandwidth = bap.Bandwidth_rel__c;
                               bandwidthUom = bap.UoM_rel__c;
                               
                               bap.Request_Date__c = system.today();
                               
                               Date d = bap.Request_Date__c;
                               Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
                               requestDate = dt.format ('yyyy-MM-dd') ; 
                               
                               d = bap.Terminate_Date__c;
                               dt = datetime.newInstance(d.year(), d.month(),d.day());
                               terminateDate = dt.format('yyyy-MM-dd');
                               
                               reason = bap.Reason__c;
                               note = bap.Note__c;
                               userCreate = bap.CreatedBy_email__C;
                               iom_file_link = null;
                               
                               if (bapid <> '' && bapid <> null) {
                                   request_status = 'Operation Review';    //-- for re-SUBMIT and update BAP
                               } else {
                                   request_status = null; 
                               }
                               
                               if(!test.isRunningTest())
                               {   
                                   REST_BAPs_v2.mirroringBAP( bap.id, bapid,
                                                             typeOfRequest, customer, cid, sirkit, address,
                                                             pic, picPhone, picEmail, picPosition, bandwidth,
                                                             bandwidthUom, requestDate, terminateDate, reason, 
                                                             note, userCreate , request_status , iom_file_link,termination_for_nonautorenewal
                                                            );  
                                }
                            
                   		 }
                        //
                        system.debug ('== ready to BA Sent to Customer CHECKING');
                        system.debug ('== bap.request_status__C : ' +  bap.request_status__C);
                        system.debug ('== bapOLD.request_status__C : ' +  bapOLD.request_status__C);
                        
                        if( Trigger.isUpdate && 
                           //bap.IoM_Approval_Status__c =='Approved' && bapOLD.IoM_Approval_Status__c !='Approved' ){  
                           (((bap.ISBackdate__c==true || bap.ispenalty__c==true) && bap.request_status__C=='BA Sent to Customer' && bapOLD.request_status__C!='BA Sent to Customer' )||test.isrunningtest())){  
                               
                               system.debug ('== IN BA SENT TO CUSTOMER - before update');
                               
                               File_BAP_Attachment_Public_URL.getURL (bap.id, bap.name);
                               
                               
                               list<ContentDistribution> CDList=[SELECT id,DistributionPublicUrl FROM ContentDistribution WHERE name=:BAP.name order by createddate desc];
                               if ( CDList.size() > 0 ) {
                                   if(BAP.isbackdate__c !=false || BAP.ispenalty__c!= false )
                                       bap.IoM_File_Link__c = CDList[0].DistributionPublicUrl;
                               }
                           }
                        
                        
                        if( Trigger.isUpdate && 
                           //--OLD ver. bap.request_status__C=='BA Sent to Customer' && bapOLD.request_status__C!='BA Sent to Customer' ){  
                           ( ( bap.request_status__C=='BA Sent to Customer' && 
                              bap.IoM_File_Link__c <> bapOLD.IoM_File_Link__c)||test.isRunningTest())) {  
                                  
                                  
                                  //REST_BAPs restBAP = new REST_BAPs ();
                                  //restBAP.addBAP();
                                  
                                  bapid = bap.BAP_ID__c;
                                  typeOfRequest = null;
                                  customer = null;
                                  cid = null;
                                  sirkit = null;
                                  address = null;
                                  pic = null;
                                  picPhone = null; 
                                  picEmail = null;
                                  picPosition = null;
                                  if (!String.isBlank(picPosition)) {
                                      picPosition = picPosition.replace(';',',');
                                  }
                                  
                                  bandwidth = null;
                                  bandwidthUom = null;
                                  
                                  //Date d = bap.Request_Date__c;
                                  //Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
                                  requestDate = null ; 
                                  
                                  //d = bap.Terminate_Date__c;
                                  //dt = datetime.newInstance(d.year(), d.month(),d.day());
                                  terminateDate = null;
                                  
                                  reason = null;
                                  note = null;
                                  userCreate = null;
                                  request_status = 'BAP Sent to Customer';
                                  
                                  //bap.IoM_File_Link__c = plink;
                                  //iom_file_link = bap.IoM_File_Link__c;
                                  
                                  
                                  /*
REST_BAPs_v2.mirroringBAP( bap.id, bapid,
typeOfRequest, customer, cid, sirkit, address,
pic, picPhone, picEmail, picPosition, bandwidth,
bandwidthUom, requestDate, terminateDate, reason, 
note, userCreate, request_status ,iom_file_link                   
);  
*/
                              }
                        }
                        /*
* Handling for status is move back to DRAFT
* action : reset some values
* by : Doddy - July 07, 2020
*/
                    if(bap.RecordTypeId == recordTypeId){
                        if( Trigger.isUpdate && bap.request_status__C=='Draft' && bapOLD.request_status__C!='Draft' ){  
                            system.debug ('== IN status move to DRAFT == reset some value');
                            bap.IsBackDate__c = FALSE;
                            bap.IsPenalty__c = FALSE;
                            bap.Pernah_Disubmit__c = FALSE;
                            
                            //++
                            bap.IsCostPartner__c = FALSE;
                            bap.Approval_Remark__c = null;
                            bap.Backdate_Approval_Status__c = '';
                            bap.Penalty_Approval_Status__c = '';
                            bap.GH_Approval_Date__c  = null;
                            bap.Chief_Approval_Date__c  = null;
                            
                        }
                    }
                }
            }
        }
    }
}