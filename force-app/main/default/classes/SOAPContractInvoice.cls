global class SOAPContractInvoice {
    webservice static String Invoice(String ContractitemNO, String FLAG, String BillDate  )
    {
		/*
		01 : FIRST INVOICE
		02 : FIRST INVOICE CANCEL
		03 : LAST INVOICE
		04 : LAST INVOICE CANCEL
		05 : BOTH INVOICE
		06 : BOTH INVOICE CANCEL
		*/
        
        string strFLAG = '';
        if (FLAG == '01') strFLAG = 'FIRST INVOICE';
        if (FLAG == '02') strFLAG = 'FIRST INVOICE';
        if (FLAG == '03') strFLAG = 'LAST INVOICE';
        if (FLAG == '04') strFLAG = 'LAST INVOICE';
        //if (FLAG == '05') strFLAG = 'FIRST INVOICE';
        //if (FLAG == '06') strFLAG = 'FIRST INVOICE';
        
        
        Call_Log__c callLogRecord=new Call_Log__c();
        callLogRecord.type__c = 'Callin';
        callLogRecord.request_start_time__c = datetime.now();
        String returnMessage;
        string status;
        Date dateBillDate = null;
        
        callLogRecord.Request_Message__c = 'Contractitem No : ' + ContractitemNo + ', FLAG : ' + FLAG + ', BillDate : ' + BillDate;
        
        //convert Billdate to date format
        if (BillDate<>null || BillDate <>'') {
        	////---- TODO
        	
        	try {
        		dateBillDate = apputils.strToDate(BillDate, 'yyyymmdd');
        	}catch(exception e){
        	}
        	
        }
        
        
        try{
            List<Contract_Ticket_Item__c> contractTicketItemList = new List<Contract_Ticket_Item__c>();
            
            //-- FIRST INVOICE or LAST INVOICE or BOTH INVOICE
            if (FLAG == '01' || FLAG == '03' || FLAG == '05' ) {
	            
	            if (FLAG == '01' || FLAG == '03' ) { 											//-- FIRST INVOICE  and LAST INVOICE
	            	contractTicketItemList = [SELECT id,Contract_Item_No__c,isInvoiced__c 
	            									, contract_ticket__c, contract_item__c, FLAG__c
	            						FROM Contract_Ticket_Item__c 
	            						WHERE Contract_Item_No__c =:ContractitemNo
	            							and FLAG__c =:strFLAG
	            						];
	            						
	            } else  if (FLAG == '05') { 													//-- BOTH INVOICE
	            	contractTicketItemList = [SELECT id,Contract_Item_No__c,isInvoiced__c 
	            									, contract_ticket__c, contract_item__c, FLAG__c
	            						FROM Contract_Ticket_Item__c 
	            						WHERE Contract_Item_No__c =:ContractitemNo
	            							and (FLAG__c ='FIRST INVOICE' OR FLAG__c ='LAST INVOICE' )
	            						];
	            	
	            }		
	            
	            system.debug('============ contractTicketItemList : ' + contractTicketItemList);			
	            
	            List <Contract> contractList = new List <Contract>();
	            	
	            if(contractTicketItemList.size()>0){
	            	for (Contract_Ticket_Item__c contractTicketItemRecord : contractTicketItemList) {
	            	
		                contractTicketItemRecord.isInvoiced__c =TRUE;
		                
		                system.debug('============ contractTicketItemRecord.contract_item__c : ' + contractTicketItemRecord.contract_item__c);
		                system.debug('============ contractTicketItemRecord.FLAG__c : ' + contractTicketItemRecord.FLAG__c);
		                
		                
		                //-- set CONTRACT
		                Contract contractRec = new Contract();
		                contractRec.id = contractTicketItemRecord.contract_item__c;
		                if (contractTicketItemRecord.FLAG__c =='FIRST INVOICE' ) { 			//-- FIRST INVOICE
		                	contractRec.First_Bill_Date__c = dateBillDate;
		                	contractRec.status = 'Active';
		                	contractRec.ACTIVE__C = true;
		                
		                } else if (contractTicketItemRecord.FLAG__c =='LAST INVOICE' || contractTicketItemRecord.FLAG__c =='BOTH INVOICE' ) {		//-- LAST INVOICE or BOTH INVOICE
		                	contractRec.Last_Bill_Date__c = dateBillDate;
		                	contractRec.status = 'Inactive';
		                	contractRec.Active__c = false;
		                }
		                
		                contractList.add (contractRec);
		                //-----
		                
	            	}
	            	system.debug('============');
	            	system.debug('============ contractTicketItemList : ' + contractTicketItemList);	
	            	system.debug('============ contractList : ' + contractList);	
	            	
	            	update contractTicketItemList;
	            	update contractList;
	            	
	            	
	                status = 'Success';
	                returnMessage = 'success';
	                
		        }
	            else if (contractTicketItemList.size()==0){ 
	                callLogRecord.status__c = 'Failed';
	                string errMessage = 'Contract Item SAP ID Not Found';
	                callLogRecord.error_message__c = errMessage;
	                returnMessage = 'Contract Item SAP ID Not Found';
	                status = 'Failed';
	            }
        	}	
        	
        	
        	//-- FIRST INVOICE CANCEL or LAST INVOICE CANCEL or BOTH INVOICE CANCEL 
            if (FLAG == '02' || FLAG == '04' || FLAG == '06' ) {
            	/* 
	            	contract invoice status :  false
					contract ticket status : Review By Finance
					opportunity stage : Waiting for Contract
				*/
				if (FLAG == '02' || FLAG == '04') { 															//-- FIRST INVOICE  and LAST INVOICE
	            	contractTicketItemList = [SELECT id,Contract_Item_No__c,isInvoiced__c
	            								, contract_ticket__c , contract_item__c, FLAG__c
	            						FROM Contract_Ticket_Item__c 
	            						WHERE Contract_Item_No__c =:ContractitemNo
	            							and FLAG__c =:strFLAG
	            						];
	            						
	            } else  if (FLAG <> '06') { 																	//-- BOTH INVOICE
	            	contractTicketItemList = [SELECT id,Contract_Item_No__c,isInvoiced__c 
	            								, contract_ticket__c , contract_item__c, FLAG__c
	            						FROM Contract_Ticket_Item__c 
	            						WHERE Contract_Item_No__c =:ContractitemNo
	            							and (FLAG__c ='FIRST INVOICE' OR FLAG__c ='LAST INVOICE' )
	            						];
	            	
	            }
	            
	            List <Contract> contractList = new List <Contract>();
	            
	            if(contractTicketItemList.size()>0){
	            	for (Contract_Ticket_Item__c contractTicketItemRecord : contractTicketItemList) {
	            		
	            		//-- contract invoice status :  false
		                contractTicketItemRecord.isInvoiced__c =FALSE;
		                
		                //-- set CONTRACT
		                Contract contractRec = new Contract();
		                contractRec.id = contractTicketItemRecord.contract_item__c;
		                if (contractTicketItemRecord.FLAG__c =='FIRST INVOICE' ) {							//-- FIRST INVOICE
		                	contractRec.First_Bill_Date__c = null;
		                	contractRec.status = 'Review By Finance';
		                	contractRec.ACTIVE__C = false;
		                	
		                
		                } else if (contractTicketItemRecord.FLAG__c =='LAST INVOICE' || contractTicketItemRecord.FLAG__c =='BOTH INVOICE' ) {	//-- LAST INVOICE or BOTH INVOICE
		                	contractRec.Last_Bill_Date__c = null;
		                	contractRec.status = 'Active';
		                	contractRec.ACTIVE__C = true;
		                }
		                
		                contractList.add (contractRec);
		                //-----
	            	}
	            	update contractTicketItemList;
	            	update contractList;
	            	
	            	
	            	//-- contract ticket status : Review By Finance
	            	Contract_Ticket__c CT = new Contract_Ticket__c(); 
	            	CT.id = contractTicketItemList[0].contract_ticket__c;
	            	CT.TicketStatus__c = 'Review By Finance';
	            	update CT;
	            	
	            	system.debug ('=== CT.opportunity__c : ' + CT.opportunity__c);
	            	
	            	//-- GET CONTRACT TICKET Record
	            	List<Contract_Ticket__c> CTList= [select id, opportunity__c from Contract_Ticket__c where ID =:CT.id ];
	            	system.debug ('=== CTList : ' + CTList);
	            	
	            	if (CTList.size() >0 ) {
		            	//-- opportunity stage : Waiting for Contract
		            	if (CTList[0].opportunity__c <> null) {
		            		Opportunity opp = new Opportunity();
		            		opp.id = CTList[0].opportunity__c;
		            		opp.stageName = 'Waiting for Contract';
		            		
		            		system.debug ('=== opp : ' + opp);
		            		update Opp;
		            	}
	            	}
	            	
	            		            	
	            	//-- todo: for change price 
	            	/*
	            	if (CT.change_price__c <> null) {
	            		Change_Price__c CP = new Change_Price__c();
	            		CP.id = CT.change_price__c;
	            		CP.status= 'Waiting for Contract';
	            		update Opp;
	            	}*/
	                
	                status = 'Success';
	                returnMessage = 'success';
	                
		        }
	            else if (contractTicketItemList.size()==0){ 
	                callLogRecord.status__c = 'Failed';
	                string errMessage = 'Contract Item SAP ID Not Found';
	                callLogRecord.error_message__c = errMessage;
	                returnMessage = 'Contract Item SAP ID Not Found';
	                status = 'Failed';
	            }
				
				
            }
        		            
        }
        catch(exception e){
                callLogRecord.status__c = 'Failed';
                status = 'Failed';
                string errMessage = 'Error on SOAPContractInvoice, Invoice method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
                callLogRecord.error_message__c = errMessage;
                returnMessage = errMessage ;
                
                //-- todo : send email to system administrator
                
        }
        
        callLogRecord.endpoint__C = 'SOAPContractInvoice';
        callLogRecord.status__c = status;
        callLogRecord.response_end_time__c = datetime.now();
        
        insert callLogRecord;
        return returnMessage;
    }   
}