/**
 * @description       : 
 * @Test Class        : Trigger_OrderItem_v2_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-16-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   01-16-2023   Novando Utoyo Agmawan   Initial Version
**/

trigger Trigger_OrderItem_v2 on OrderItem (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	if (label.Is_Trigger_ORDERITEM_v2_ON == 'YES') {
		if(trigger.isInsert){
			
			//-- AFTER INSERT
			if(trigger.isAfter) 
			{
        		for(OrderItem newOrderItem:system.trigger.New) {
                	//OrderItem oldOrderItem=Trigger.oldMap.get(newOrderItem.id);
                	if (newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_GSM_SIM_Card) {
	                	String orderID = String.valueof(newOrderItem.orderid);
						//REST_Material.readAvailableMaterialOnOrder (orderID);
                	}
        		}
			}

			//-- BEFORE INSERT
			if(trigger.isBefore)
			{
				for(OrderItem newOrderItem:system.trigger.New) {
				
					
					if (label.Is_Trigger_ORDERITEM_VALIDATION_QTY_ON == 'YES') {
						/*  VALIDASI QUANTITY UNTUK :
							1. SIM CARD ORDER
							2. ACTIVATION, DEVICE BUNDLING dan TAGGING
						*/


						if ( newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_GSM_SIM_Card ) 
						{
							/**  
							 ** VALIDASI MAXIMUM quantity order product FOR SIM CARD ORDER
							*/

							Decimal Sisa=0;
							//Orderitem OldOrderItem=trigger.oldmap.get(neworderitem.id);
							Order orderRec =[SELECT OpportunityID from Order WHERE ID=:newOrderitem.orderid];
							
							//list<OpportunityLineItem> OLI=[SELECT id,Pricebookentryid,Quantity 
							//								FROM OpportunityLineItem 
							//								WHERE OpportunityID=: orderRec.OpportunityID];
							
							if (orderRec.OpportunityID == null) 
							{
								//-- SIM CARD Order boleh tanpa Opportunity.
								//------ THERE IS NO VALIDATION IF THE ORDER SIM CARD DOSEN'T HAVE AN OPPORTUNITY ------
								//--------------------------------------------------------------------------------------
							} 
							
							else 
							{
								//-- IF ORDER HAVE OPPORTUNITY

								list<OpportunityLineItem> OLIList=[SELECT id,Pricebookentryid,Quantity 
														FROM OpportunityLineItem 
														WHERE OpportunityID=: orderRec.OpportunityID];
									
								if (OLIList.size() == 0 && !test.isrunningtest() ) {
									//-- IF NO OPPORTUNITY PRODUCT
									neworderitem.adderror ( 'Karena tidak ada produk pada opportunity, maka sistem tidak mengetahui batas maximum (quantity) untuk Order SIM Card');

								} else {
								
									//-- VALIDASI QTY BERGANTUNG SISA ---------------------------------
									AggregateResult[] AR_OrderItem =[SELECT SUM(quantity) Total 
																		FROM orderitem 
																		WHERE order.opportunity.id=:orderRec.OpportunityID 
																			and order.status <> 'Draft'
																			and id <> :neworderitem.id
																			AND order.RECORDTYPE.Name = 'GSM SIM Card'];

									
									//-- GET SISA
									decimal tmpTotal = 0;
									if (AR_OrderItem.size() > 0 )
										tmpTotal = (decimal) AR_OrderItem[0].get('Total') ;
									
									integer productQTYofINPROGRESSOrder;
									if ( tmpTotal == null) productQTYofINPROGRESSOrder = 0;
										else productQTYofINPROGRESSOrder = integer.valueOf (tmpTotal);

									decimal tmpOptyProductTotalQuantity = 0;
									for (OpportunityLineItem OLI : OLIList ) {
										tmpOptyProductTotalQuantity = tmpOptyProductTotalQuantity + OLI.Quantity ;
									}

									Sisa = tmpOptyProductTotalQuantity - productQTYofINPROGRESSOrder ;

									if(neworderitem.quantity>Sisa){
										neworderitem.adderror('Quantity yang dimasukkan (' + Integer.valueof(neworderitem.quantity) 
												+ ') melebihi dari quota/sisa quantity yang diperbolehkan (' + Integer.valueof(sisa) + '). '
												+ '>> INFO : Total Quantity dari Opportunity-Product : '  +  Integer.valueof(tmpOptyProductTotalQuantity) 
												+ '. Total Quantity terakhir dari Order-Product  : '  + productQTYofINPROGRESSOrder +  '.' );

									}
								}
								
							}
						}
						
					
						
						else if ( //newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_GSM_SIM_Card
								newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_PREPAID_NEW
								|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_PREPAID_EXISTING
								|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_POSTPAID_NEW
								|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_POSTPAID_EXISTING
								|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_DEVICEBUNDLING_NEW
								|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING
								//|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_MSISDN_Tagging_Order
								
								) 
						{
							/**  
							 ** VALIDASI MAXIMUM quantity order product FOR ACTIVATION/TAGGING/DEVICE-BUNDLING ORDER
								*/
							
							Decimal Sisa=0;
							Order orderRec =[SELECT OpportunityID from Order WHERE ID=:newOrderitem.orderid];
							
				
							if (orderRec.OpportunityID == null) 
							{
								//-- HANYA ORDER PRAPAID TAGGING EXISITING ID COM yang boleh tanpa Opportunity
								if (newOrderItem.Order_Record_Type__c <> system.label.RT_ORDER_PREPAID_EXISTING && !test.isrunningtest())
									neworderitem.adderror('Order ini belum memiliki Opportunity. Mohon dibuat Opportunity terlebih dahulu.');
							}
							else 
							{
								//-- ORDER HAVE OPPORTUNITY
								list<OpportunityLineItem> OLIList=[SELECT id,Pricebookentryid,Quantity FROM OpportunityLineItem 
															WHERE OpportunityID=:orderRec.OpportunityID 
															and pricebookentryid=:neworderitem.pricebookentryid];
									
								if (OLIList.size() == 0 && !test.isrunningtest() ) {
									//-- IF NO OPPORTUNITY PRODUCT
									neworderitem.adderror ( 'Karena tidak ada produk pada opportunity, maka sistem tidak mengetahui batas maximum (quantity) untuk Order berikut');

								} else {
									
									AggregateResult[] AR_OrderMSISDN= [	select 
																			pricebookentry.name,
																			sum(quantity) total
																		from orderitem 
																		where  
																			order.opportunityid =: orderRec.OpportunityID 
																			AND pricebookentryid =: newOrderItem.pricebookentryid
																			AND order.status <> 'DRAFT'
																			and id <> :newOrderItem.id
																		group by pricebookentry.name] ;

									//-- GET SISA
									decimal tmpTotal = 0;
									if (AR_OrderMSISDN.size() > 0 )
										tmpTotal = (decimal) AR_OrderMSISDN[0].get('Total') ;

									integer productQTYofINPROGRESSOrder;
									if ( tmpTotal == null) productQTYofINPROGRESSOrder = 0;
										else productQTYofINPROGRESSOrder = integer.valueOf (tmpTotal);

									decimal tmpOptyProductTotalQuantity = 0;
									for (OpportunityLineItem OLI : OLIList ) {
										tmpOptyProductTotalQuantity = tmpOptyProductTotalQuantity + OLI.Quantity ;
									}

									Sisa = tmpOptyProductTotalQuantity - productQTYofINPROGRESSOrder ;

									if(neworderitem.quantity>Sisa) {
										neworderitem.adderror('Quantity yang dimasukkan (' + Integer.valueof(neworderitem.quantity) 
													+ ') melebihi dari quota/sisa quantity yang diperbolehkan (' + Integer.valueof(sisa) + '). '
													+ '>> INFO : Total Quantity dari Opportunity-Product : '  +  Integer.valueof(tmpOptyProductTotalQuantity) 
													+ '. Total Quantity terakhir dari Order-Product  : '  + productQTYofINPROGRESSOrder +  '.' );

									}
								}

							}
						}
					}
				}
			}
		}


		if(trigger.isUpdate)
		{
			if(trigger.isbefore)
			{
				//-- BEFORE UPDATE
				for(OrderItem newOrderItem:system.trigger.New) {
					Orderitem OldOrderItem=trigger.oldmap.get(neworderitem.id);

					
					if ( newOrderitem.quantity <> oldOrderitem.quantity && label.Is_Trigger_ORDERITEM_VALIDATION_QTY_ON == 'YES' )  
					{ 
						/*  VALIDASI QUANTITY UNTUK :
							1. SIM CARD ORDER
							2. ACTIVATION, DEVICE BUNDLING dan TAGGING
						*/


						if (  newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_GSM_SIM_Card ) 
						{
							/**  
							 ** VALIDASI MAXIMUM quantity order product FOR "SIM CARD ORDER"
							*/
							
							
							Decimal Sisa=0;
							Order orderRec =[SELECT OpportunityID from Order WHERE ID=:newOrderitem.orderid];

							

							if (orderRec.OpportunityID == null) 
							{
								//-- SIM CARD Order boleh tanpa Opportunity.
								//------ THERE IS NO VALIDATION IF THE ORDER SIM CARD DOSEN'T HAVE AN OPPORTUNITY ------
								//--------------------------------------------------------------------------------------
							} 

							else  
							{
								//-- IF ORDER HAVE OPPORTUNITY 
								list<OpportunityLineItem> OLIList=[SELECT id,Pricebookentryid,Quantity 
																FROM OpportunityLineItem 
																WHERE OpportunityID=: orderRec.OpportunityID];
								
								if(OLIList.size()==0 && !test.isrunningtest())
								{
									//-- IF NO OPPORTUNITY PRODUCT
									neworderitem.adderror ( 'Karena tidak ada produk pada opportunity, maka sistem tidak mengetahui batas maximum (quantity) untuk Order SIM Card');
								}

								else 
								{	//-- OPPORTUNIT HAVE PRODUCT
									
									AggregateResult[] AR_OrderItem =[SELECT SUM(quantity) Total 
																		FROM orderitem 
																		WHERE order.opportunity.id=:orderRec.OpportunityID 
																			and order.status <> 'Draft'
																			and id <> :neworderitem.id
																			AND order.RECORDTYPE.Name = 'GSM SIM Card'];
									
									//-- GET SISA
									decimal tmpTotal = 0;
									if (AR_OrderItem.size() > 0 )
										tmpTotal = (decimal) AR_OrderItem[0].get('Total') ;

									integer productQTYofINPROGRESSOrder;
									if ( tmpTotal == null) productQTYofINPROGRESSOrder = 0;
										else productQTYofINPROGRESSOrder = integer.valueOf (tmpTotal);

									decimal tmpOptyProductTotalQuantity = 0;
									for (OpportunityLineItem OLI : OLIList ) {
										tmpOptyProductTotalQuantity = tmpOptyProductTotalQuantity + OLI.Quantity ;
									}

									Sisa =tmpOptyProductTotalQuantity - productQTYofINPROGRESSOrder ;

									if(neworderitem.quantity>Sisa){
										//neworderitem.adderror('Cannot Insert Quantity More than Quantity (' + sisa + ' '  +  OLI[0].Quantity + ' '  + Integer.valueof(AR_OrderItem[0].get('Total')) +  ')' );

										neworderitem.adderror('Quantity yang dimasukkan (' + Integer.valueof(neworderitem.quantity) 
													+ ') melebihi dari quota/sisa quantity yang diperbolehkan (' + Integer.valueof(sisa) + '). '
													+ '>> INFO : Total Quantity dari Opportunity-Product : '  +  Integer.valueof(tmpOptyProductTotalQuantity) 
													+ '. Total Quantity terakhir dari Order-Product  : '  + productQTYofINPROGRESSOrder +  '.' );
									}
									
								}
								
							}

						}

						
						

						else if	( 
							newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_PREPAID_NEW
							|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_PREPAID_EXISTING
							|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_POSTPAID_NEW
							|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_POSTPAID_EXISTING
							|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_DEVICEBUNDLING_NEW
							|| newOrderItem.Order_Record_Type__c==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING
							) 
						{
							/**  
							 ** VALIDASI MAXIMUM quantity order product FOR ACTIVATION/TAGGING/DEVICE-BUNDLING ORDER
							*/

							Decimal Sisa=0;
							Order orderRec =[SELECT OpportunityID from Order WHERE ID=:newOrderitem.orderid];
							
							
							if (orderRec.OpportunityID == null) 
							{
								//-- HANYA ORDER PRAPAID TAGGING EXISITING ID COM yang boleh tanpa Opportunity
								if (newOrderItem.Order_Record_Type__c <> system.label.RT_ORDER_PREPAID_EXISTING  && !test.isrunningtest() ) 
									neworderitem.adderror('Order ini belum memiliki Opportunity. Mohon dibuat Opportunity terlebih dahulu.');
							}

							else 
							{	//-- ORDER HAVE OPPORTUNITY
								list<OpportunityLineItem> OLIList=[SELECT id,Pricebookentryid,Quantity 
															FROM OpportunityLineItem 
															WHERE OpportunityID=: orderRec.OpportunityID 
																and pricebookentryid=:neworderitem.pricebookentryid];

								if (OLIList.size() == 0 && !test.isrunningtest() ) {
									//-- IF NO OPPORTUNITY PRODUCT
									neworderitem.adderror ( 'Karena tidak ada produk pada opportunity, maka sistem tidak mengetahui batas maximum (quantity) untuk Order berikut');

								} else {							

									AggregateResult[] AR_OrderMSISDN= [	select 
																			pricebookentry.name,
																			sum(quantity) total
																		from orderitem 
																		where  
																			order.opportunityid =: orderRec.OpportunityID 
																			AND pricebookentryid =: newOrderItem.pricebookentryid
																			AND order.status <> 'DRAFT'
																			and id <> :newOrderItem.id
																		group by pricebookentry.name] ;

									//-- GET SISA
									decimal tmpTotal = 0;
									if (AR_OrderMSISDN.size() > 0 )
										tmpTotal = (decimal) AR_OrderMSISDN[0].get('Total') ;

									integer productQTYofINPROGRESSOrder;
									if ( tmpTotal == null) productQTYofINPROGRESSOrder = 0;
										else productQTYofINPROGRESSOrder = integer.valueOf (tmpTotal);

									decimal tmpOptyProductTotalQuantity = 0;
									for (OpportunityLineItem OLI : OLIList ) {
										tmpOptyProductTotalQuantity = tmpOptyProductTotalQuantity + OLI.Quantity ;
									}
										
									Sisa = tmpOptyProductTotalQuantity - productQTYofINPROGRESSOrder ;

									if(neworderitem.quantity>Sisa){
										// neworderitem.adderror('Cannot Insert Quantity More than Quantity (' + sisa + ')' );

										neworderitem.adderror('Quantity yang dimasukkan (' + Integer.valueof(neworderitem.quantity) 
													+ ') melebihi dari quota/sisa quantity yang diperbolehkan (' + Integer.valueof(sisa) + '). '
													+ '>> INFO : Total Quantity dari Opportunity-Product : '  +  Integer.valueof(tmpOptyProductTotalQuantity) 
													+ '. Total Quantity terakhir dari Order-Product  : '  + productQTYofINPROGRESSOrder +  '.' );

									}
								}
							}
						}
					
					}
				}
			}
		}
		if(trigger.isDelete){
        	if(trigger.isAfter) {
        		for(OrderItem oldOrderItem:system.trigger.old) {
                	//OrderItem oldOrderItem=Trigger.oldMap.get(newOrderItem.id);
                	if (oldOrderItem.Order_Record_Type__c==system.label.RT_ORDER_GSM_SIM_Card) {
	                	String orderID = oldOrderItem.orderid;
	                	//REST_Material.readAvailableMaterialOnOrder (orderID);
                	}
        		}
        	}
		}
		
	}
}