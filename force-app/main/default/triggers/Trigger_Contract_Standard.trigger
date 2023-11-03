trigger Trigger_Contract_Standard on Contract (after insert, after update, before insert, before update) {
if(system.label.Is_Trigger_Contract_Standard_On=='YES') {
    
    if(trigger.isinsert) {
        if(trigger.isBefore){
            for(Contract contractNewRec : system.trigger.new){
            	
            	
            }
        }
         
        if(trigger.isafter){
        	List <string> cplIDs = new List <string>();
        	//List <string> cplIDContracts = new List <string>();
        	Map <string, string> cplIDContracts = new Map <string, string> {};
        	 
            for(Contract contractNewRec : system.trigger.new){
            	//-- after insert contract for change-price
            	if (contractNewRec.change_price_link__c <> null) {
            		string cplID = contractNewRec.change_price_link__c;
            		cplIDs.add (cplID);
            		cplIDContracts.put (cplID, contractNewRec.id);
            	}
            }
            
            system.debug ('========= cplIDs : ' + cplIDs);
            
            List <change_price_link__c> cplList = [select id, contract__c from change_price_link__c where id =:cplIDs];
            system.debug ('========= cplList : ' + cplList);
            if (cplList.size() > 0 ) {
            	for (integer ind=0; ind<cplList.size(); ind=ind+1){
            		
            		system.debug ('========= cplIDContracts.get(cplList[ind].id : ' + cplIDContracts.get(cplList[ind].id));
            		cplList[ind].contract__c = cplIDContracts.get(cplList[ind].id);
            	}
            	
            	system.debug ('========= cplList : ' + cplList);
            	update cplList;
            	
            }
            
        }
    }
    
    
    if(trigger.isUpdate) {
        if(trigger.isafter){
            for(Contract contractNewRec : system.trigger.new){
            
            
            }
        }
        
        if(trigger.isBefore){
            for(Contract contractNewRec : system.trigger.new){
                Contract contractOldRec = Trigger.oldMap.get(contractNewRec .id);
                
                //-- Jika Contract-Item-No terisi dari return SAP maka lakukan update informasi contract pada Link terkait ----
                //-- Ini digunakan untuk CONTRACT BARU (new Link)
                //-- Untuk upgrade Link eventnya pada saat LAST-CONTRACT-INVOCED (Call in API) 
                
                
                //-- after update field SAP_ID__c (contract item) -- there is update from return of contract-creation HIT SAP
                //-- update only if RECURRING product Contract

                system.debug ('============= contractNewRec.Product_Charge_Type__c : ' + contractNewRec.Product_Charge_Type__c);
                system.debug ('============= contractNewRec.Previous_Contract__c : ' + contractNewRec.Previous_Contract__c );

                if ( ( contractNewRec.Product_Charge_Type__c =='Recurring' ) 
                        //--  && ( contractNewRec.Previous_Contract__c == null)     -- INI awalanya kondisi untuk NEW LINK SAJA.  
                    )
                            //-- this for new link and upgrade                             
                  {
                    system.debug ('============= MASUK!! ');
                    boolean beforeEmpty = false ; 
                    boolean afterEmpty = false ; 

					if (contractOldRec.SAP_ID__c == null) {
						beforeEmpty = true;
					}
					if (contractNewRec.SAP_ID__c <> '' && contractNewRec.SAP_ID__c <> null) {
						afterEmpty = true;
					}
					
					system.debug ('============= beforeEmpty : ' + beforeEmpty);
					system.debug ('============= afterEmpty : ' + afterEmpty);
					
					
                    if ( beforeEmpty && afterEmpty )
					{
                        
                        //-- SET CONTRACT information on the LINK with this Contract record :: IF CONTRACT-ITEM-NO GET VALUE FROM SAP
                        //-- command: update Contract_Item_Rel__c field on LINK to this contract
                        string linkID = contractNewRec.Link__c;
                        string CID = contractNewRec.CID__C;
                        
                        system.debug ('=========== contractNewRec.CID__C : ' + contractNewRec.CID__C);
    
                        List<Link__c> linkList = [  select id, Contract_Item_Rel__c from Link__c 
                                                    where name=:CID];
                        
                        system.debug ('=========== linkList : ' + linkList);
                        system.debug ('=========== linkList.size() : ' + linkList.size());
                        if (linkList.size() > 0) {
                            
                            for (Link__c link : linkList) {
                                //-- set contract on the link
                                link.Contract_Item_Rel__c = contractNewRec.id;
                                link.Contract_Item__c = contractNewRec.Contract_ID__c + '-' + contractNewRec.SAP_ID__c ;
                                
                                //-- set bandwidth and uom on the link  
                                //-- hilangkan .00 di bandwidth 
                                string bandWidth ='';
                                if (contractNewRec.Bandwidth__c <> null) {
                                    bandWidth =string.valueof(contractNewRec.Bandwidth__c);
                                    bandWidth = bandWidth.replace('.00','');
                                }
                                link.Capacity_Bandwidth__c = bandWidth ;
                                link.UoM__c = contractNewRec.Bandwidth_UOM__c;
                            }
                            
                            system.debug ('=========== linkList : ' + linkList);
                            update linkList;
                            
                            //-- TODO: hit update Link to EASYOPS (new contract-item no etc)
                            //-- ... !!!!!
                            
                        }                                             
                         
                    }
               
               }
                    
            }
        }
    }
            
}
}