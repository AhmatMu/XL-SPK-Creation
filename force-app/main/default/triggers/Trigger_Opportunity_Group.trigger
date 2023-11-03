trigger Trigger_Opportunity_Group on Opportunity_Group__c (before update, before insert) {

	Boolean doProcess = false;
	if (trigger.isBefore) {
		if (trigger.isUpdate || trigger.isInsert  ) {
			
			for(Opportunity_Group__c ogNEW : system.trigger.new){

				if (trigger.isInsert) {
					doProcess = true;
				} else {
					Opportunity_Group__c ogOld=Trigger.oldMap.get(ogNew.id);
					if ( ogNew.Price_book__c <> ogOld.Price_book__c ) { 
						doProcess = true;
					}	else {
						doProcess = false;
					}
					
				}
				doProcess = true;
				
				if (doProcess)
				{
					ogNEW.Product_String_List__c =''; 
					
					string priceBookID = ogNew.Price_book__c;
					List <pricebookentry> pbEntryList = [select Product2.name from pricebookentry where Pricebook2Id=:priceBookID and isActive=true order by Product2.name];
					system.debug ('==== pbEntryList : ' + pbEntryList );
					
					if (pbEntryList.size() > 0) {
						string productStringList = '';
						integer ind=1;
						for (pricebookentry pbEntryRec :pbEntryList) {
							//productStringList = productStringList + '[' + ind + ']. ' + pbEntryRec.Product2.name  + '; ' + ' \r\n'; 
							ogNEW.Product_String_List__c = ogNEW.Product_String_List__c + '[' + ind + ']. ' + pbEntryRec.Product2.name  + ' \r\n';
							
							ind++;
						}
						//ogNEW.Product_String_List__c = productStringList;
					}
				}
				
				if (ogNew.Product__c == null)
						ogNEW.List_Price_Product__c = null ;
					
				if (ogNew.Product_installation__c == null)
					ogNEW.List_Price_Product_Installation__c = null ;
				
				
				string productName;
				string priceBookID = ogNew.Price_book__c;
				string productType= '';
				string productID = '';
				product2 productRec = null;
				List <pricebookentry> pbEntryList = new List <pricebookentry>();
				
				
				/*
				if ( ogNew.Product__c <> ogOld.Product__c || ogNew.Product_installation__c <> ogOld.Product_installation__c ) {	
					if (ogNew.Product__c <> ogOld.Product__c) {
						productType = 'main product' ;
						productID = ogNew.Product__c;
					}
					else {
						productType = 'installation product' ;
						productID = ogNew.Product_installation__c;
					}
						
					
					List <pricebookentry> pbEntryList = [select Product2.name2__c, UnitPrice, Product2id from pricebookentry 
															where Pricebook2Id=:priceBookID
																and Product2id =:productID
															];
															
					
					system.debug ('==== pbEntryList : ' + pbEntryList );
					if (pbEntryList.size() == 0) {
						ogNew.addError ('The product "' + productName + '" is not exist in Pricebook' );
					} else {
						if (productType == 'main product') 
							ogNEW.List_Price_Product__c = pbEntryList[0].UnitPrice ;
							
						else if (productType == 'installation product')
							ogNEW.List_Price_Product_Installation__c = pbEntryList[0].UnitPrice ;
					}
					
				}
				*/
				
				//-- MAIN PRODUCT
				if (ogNew.Product__c <> null) {
					productRec = [select name from product2 where id =: ogNew.Product__c];
					productName = productRec.name;
					productID = ogNew.Product__c;
					pbEntryList = [select UnitPrice, Product2id from pricebookentry 
																where Pricebook2Id=:priceBookID
																	and Product2id =:productID
																	and isActive=true
																];
					system.debug ('==== pbEntryList1 : ' + pbEntryList );
					if (pbEntryList.size() == 0) {
							ogNew.addError ('The product "' + productName + '" is not exist in Pricebook' );
					} else {
							ogNEW.List_Price_Product__c = pbEntryList[0].UnitPrice ;
					}
				}
				
				
				//-- INSTALLATION PRODUCT
				if (ogNew.Product_installation__c <> null) {
					productRec = [select name from product2 where id =: ogNew.Product_installation__c];
					productName = productRec.name;
					
					productID = ogNew.Product_installation__c;
					pbEntryList = [select UnitPrice, Product2id from pricebookentry 
																where Pricebook2Id=:priceBookID
																	and Product2id =:productID
																	and isActive=true
																];
					
					system.debug ('==== pbEntryList2 : ' + pbEntryList );
					if (pbEntryList.size() == 0) {
							ogNew.addError ('The product "' + productName + '" is not exist in Pricebook' );
					}else {
							ogNEW.List_Price_Product_Installation__c = pbEntryList[0].UnitPrice ;
					
					}
					
					
				}
				
			}
		}
	}    
	
	
}