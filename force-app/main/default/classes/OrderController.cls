public with sharing class OrderController {
    public OrderController() {

    }


    public void  updateOnSIMCardOrder (Order orderRec) {
        system.debug('======= in method OrderController.updateOnSIMCardOrder ====');

        if (orderRec.status == 'Ready for Pickup') {
            List<MSISDN__c> MSISDNList = [SELECT id, Order_SIM_Card_Related__c, Order_SIM_Card_By__c, Available_to_Activate__c, 
                                            Available_to_Tag__c	, Order_SIM_Card_Completion_Date__c
                                                    FROM MSISDN__c WHERE Order_SIM_Card_Related__c =:orderRec.id];
            
            if (MSISDNList.size() > 0) {
                for (MSISDN__c msisdn  : MSISDNList) {
                    msisdn.Order_SIM_Card_Related__c = orderRec.id;
                    msisdn.Order_SIM_Card_By__c = orderRec.ownerid;
                    msisdn.Dealer_Account_SIM_Card_Order__c = orderRec.accountID;

                    msisdn.Available_to_Activate__c = true;
                    msisdn.Available_to_Tag__c = true;
                }


                update MSISDNList; 
            }

        }
        
        if (orderRec.status == 'Complete') {

            List<MSISDN__c> MSISDNList = [SELECT id, Order_SIM_Card_Related__c, Order_SIM_Card_By__c, Available_to_Activate__c, 
                                            Available_to_Tag__c	, Order_SIM_Card_Completion_Date__c
                                                    FROM MSISDN__c WHERE Order_SIM_Card_Related__c =:orderRec.id];
            
            if (MSISDNList.size() > 0) {
                for (MSISDN__c msisdn  : MSISDNList) {
                    msisdn.Order_SIM_Card_Completion_Date__c = orderRec.Stamp_Stage_Complete__c;
                }
                update MSISDNList;
            }

        }

    }

    public void updateOnActivationOrder (Order orderRec) {
        system.debug('======= in method OrderController.updateOnActivationOrder ====');

        switch on orderRec.status {
            when 'Activation in Review' {	
                List<Order_MSISDN__c> orderMSISDNList = [SELECT id, MSISDN__c
                                                    FROM Order_MSISDN__c WHERE order__c =:orderRec.id];
                
                if (orderMSISDNList.size() > 0) {
                    List <string> msisdnSFIDList = new List <string> ();
                    for (Order_MSISDN__c orderMSISDN  : orderMSISDNList) {
                        msisdnSFIDList.add (orderMSISDN.MSISDN__c);
                    }

                    List<MSISDN__c> MSISDNList = [SELECT id, Available_to_Activate__c,	Request_to_Activate__c
                                                    FROM MSISDN__c WHERE id in :msisdnSFIDList ];

                    if (MSISDNList.size() > 0) {
                        for (MSISDN__c msisdn  : MSISDNList) {
                            msisdn.Available_to_Activate__c = false;
                            msisdn.Request_to_Activate__c = true;
                        }        
                        update MSISDNList;
                    }
                }
            }

            

            when 'Complete' {	
                List<Order_MSISDN__c> orderMSISDNList = [SELECT id, MSISDN__c
                                                    FROM Order_MSISDN__c WHERE order__c =:orderRec.id and status__c='Success'  ];
                
                if (orderMSISDNList.size() > 0) {
                    List <string> msisdnSFIDList = new List <string> ();
                    for (Order_MSISDN__c orderMSISDN  : orderMSISDNList) {
                        msisdnSFIDList.add (orderMSISDN.MSISDN__c);
                    }

                    List<MSISDN__c> MSISDNList = [SELECT id, Order_Activation_Related__c,	Order_Activation_Completion_Date__c,	Order_Activation_By__c
                                                        , Account_Activation__c, Dealer_Account_activation__c, Activated__c, Request_to_Activate__c
                                                    FROM MSISDN__c WHERE id in :msisdnSFIDList ];

                    if (MSISDNList.size() > 0) {
                        for (MSISDN__c msisdn  : MSISDNList) {
                            msisdn.Order_Activation_Related__c = orderRec.id;
                            msisdn.Order_Activation_Completion_Date__C = orderRec.Stamp_Stage_Complete__c;
                            msisdn.Order_Activation_By__c = orderRec.ownerid;

                            msisdn.Request_to_Activate__c = false;
                            msisdn.Activated__c = true;

                            if (orderRec.Opportunity_Owner_is_InDirect_Sales__c) {
                                //-- INDIRECT SALES
                                msisdn.Account_Activation__c = orderRec.Opportunity_Account_ID__c;
                                msisdn.Dealer_Account_activation__c = orderRec.accountid ;
                            } else  {
                                //-- DIRECT SALES
                                msisdn.Account_Activation__c = orderRec.accountid;
                            }


                        }        
                        update MSISDNList;
                    }

                    // -- update quantity of success to order product
                    // -- TODO  : HARUS DISESUAIKAN DENGAN product nya (AO - Proceplan)
                    /*
                    List<OrderProduct> orderProductList = [select id, quantity from orderProduct where orderid = :orderRec.id];
                    if (orderProductList.size() > 0) {
                        orderProductList[0].quantity = orderMSISDNList.size() ;
                        update orderProductList;
                    }*/

                    List<AggregateResult> orderMSISDNARList = [SELECT AO__c, Priceplan__c, count(id) successNumber
                    FROM Order_MSISDN__c 
                    WHERE order__c =:orderRec.id and status__c='Success'
                    GROUP BY AO__c, Priceplan__c
                    ];

                    Map<String, Double> AOPriceplanMap = new  Map<String, Double>();
                    
                    for (AggregateResult orderMSISDNAR : orderMSISDNARList) {
                        string AOPriceplan = (string) orderMSISDNAR.get ('AO__c') + ' ' +
                            (string) orderMSISDNAR.get ('Priceplan__c'); 
                        
                        double successNumber = (double) orderMSISDNAR.get ('successNumber');
                        
                        AOPriceplanMap.put (AOPriceplan, successNumber);
                    }

                    List<OrderItem> orderProductList = [SELECT id, quantity, 
                        AO_Priceplan__c
                    FROM OrderItem
                    WHERE orderid =: orderRec.id
                    ];

                    //-- put order quantity Actual
                    double sisa = 0;
                    for (OrderItem orderProductRec :orderProductList) {
                        double successNumber = AOPriceplanMap.get (orderProductRec.AO_Priceplan__c);
                        system.debug('=== successNumber 1: ' + successNumber);
                        if (successNumber == null) {
                            successNumber = 0;
                        }

                        if ( successNumber <= orderProductRec.quantity ) {
                            orderProductRec.quantity = successNumber;
                            sisa = 0;
                        }
                        else {
                            sisa = successNumber - orderProductRec.quantity;
                        }

                        AOPriceplanMap.remove (orderProductRec.AO_Priceplan__c);
                        AOPriceplanMap.put (orderProductRec.AO_Priceplan__c, sisa);
                        system.debug ('=== AOPriceplanMap : ' + AOPriceplanMap);
                        system.debug('=== successNumber : ' + successNumber);

                    }
                    system.debug ('=== orderProductList : ' + orderProductList);
                    update orderProductList;


                    system.debug('=== opportunityID1 : ');
                    //-- PUT Actual to opportunity Product
                    String opportunityID = orderRec.opportunityid;
                    system.debug('=== opportunityID : ');
                    //-- get quantity order product of all order related to opportunity 
                    List<AggregateResult> orderProductARList = [SELECT Product2ID, sum(quantity) quantity
                    FROM OrderItem
                    WHERE order.opportunityid = :opportunityID
                        AND order.status = 'Complete'
                    GROUP BY Product2ID
                    ];

                    //-- set productMap for order product   
                    Map<String, Double> productMap = new  Map<String, Double>();
                    for (AggregateResult  orderProductAR : orderProductARList) {
                        string productID = ( string ) orderProductAR.get ('Product2ID') ;
                        double quantity = ( double ) orderProductAR.get ('quantity');
                        productMap.put (productID, quantity);
                    }

                    system.debug ('== productMap : ' + productMap);

                    //-- get opportunity product of the opportunity
                    List<OpportunityLineItem> oliList = [SELECT id, quantity, product2.id, QTY_Actual__c
                    FROM OpportunityLineItem
                    WHERE opportunity.id = :opportunityID
                    ];


                    for (OpportunityLineItem oliRec: oliList) {
                        system.debug ('== oliRec.product2.id : ' + oliRec.product2.id);

                        double quantity = productMap.get (oliRec.product2.id);
                        if (quantity == null ) {
                            quantity = 0;
                        }

                        system.debug ('=== quantity : ' + quantity);
                        system.debug ('=== oliRec.QTY_Actual__c : ' + oliRec.QTY_Actual__c);
                        system.debug ('=== oliRec.quantity : ' + oliRec.quantity);


                        if ( quantity <= oliRec.quantity ) {
                            oliRec.QTY_Actual__c = quantity;
                            sisa = 0;
                        }
                        else {
                            sisa = quantity - oliRec.quantity;
                        }

                        productMap.remove (oliRec.product2.id);
                        productMap.put (oliRec.product2.id, sisa);
                        system.debug ('=== productMap : ' + productMap);

                    }

                    system.debug ('=== oliList : ' + oliList);
                    update oliList;





                }

                /*  BELUM DIKERJAIN
                //-- PUT Actual to opportunity Product
                String opportunityID = orderRec.opportunityid;
                list<OpportunityLineITem> oliList= [select id, productid, qty_actual__c from opportunitylineitem where opportunity =: opportunityID];
                if (oliList.size() > 0) {
                    for (opportunitylineitem oli : oliList) {
                        //--TODO: avoid SOQL in loop
                        List <Order_MSISDN__c> orderMSISDNProductRelatedList = [select id, MSISDN__c
                                                                    FROM Order_MSISDN__c 
                                                                    WHERE order__c =:orderRec.id and status__c='Success' and product_rel__c =:oli.product2id ];
                        
                        oli.qty_actual__c = orderMSISDNProductRelatedList.size();
                    }

                    //-- TODO : using try an catch
                    update oliList; 
                }

                */

            }

        } 
    }

    public void updateOnTaggingOrder (Order orderRec) {
        system.debug('======= in method OrderController.updateOnTaggingOrder ====');

        switch on orderRec.status {
            when 'Tagging Process' {	
                List<Order_MSISDN__c> orderMSISDNList = [SELECT id, MSISDN__c
                                                    FROM Order_MSISDN__c WHERE order__c =:orderRec.id];
                
                system.debug('======= orderMSISDNList : ' +  orderMSISDNList);

                if (orderMSISDNList.size() > 0) {
                    List <string> msisdnSFIDList = new List <string> ();
                    for (Order_MSISDN__c orderMSISDN  : orderMSISDNList) {
                        msisdnSFIDList.add (orderMSISDN.MSISDN__c);
                    }

                    List<MSISDN__c> MSISDNList = [SELECT id, Available_to_Tag__c,	Request_to_Tag__c,
                                                        Available_to_UnTag__c,	Request_to_UnTag__c
                                                    FROM MSISDN__c WHERE id in :msisdnSFIDList ];

                    if (MSISDNList.size() > 0) {
                        for (MSISDN__c msisdn  : MSISDNList) {
                            msisdn.Available_to_Tag__c = false;
                            msisdn.Request_to_Tag__c = true;

                            //msisdn.Available_to_UnTag__c = false;
                            //msisdn.Request_to_UnTag__c = false;
                        }        
                        update MSISDNList;
                    }
                }
            }

            

            when 'Complete' {	
                //-- SET THE SUCCESS MSISDN
                List<Order_MSISDN__c> orderMSISDNSuccessList = [SELECT id, MSISDN__c
                                                    FROM Order_MSISDN__c WHERE order__c =:orderRec.id and status__c='Success'  ];
                
                system.debug('======= orderMSISDNSuccessList : ' +  orderMSISDNSuccessList);
                if (orderMSISDNSuccessList.size() > 0) {
                    List <string> msisdnSFIDList = new List <string> ();
                    for (Order_MSISDN__c orderMSISDN  : orderMSISDNSuccessList) {
                        msisdnSFIDList.add (orderMSISDN.MSISDN__c);
                    }

                    List<MSISDN__c> MSISDNList = [SELECT id, Order_Tagging_Related__c,	Order_Tagging_Completion_Date__c,	Order_Tagging_By__c
                                                        , Account_Tagging__c, Tagged__c, Request_to_Tag__c, Available_to_UnTag__c, UnTagged__c
                                                    FROM MSISDN__c WHERE id in :msisdnSFIDList ];

                    if (MSISDNList.size() > 0) {
                        for (MSISDN__c msisdn  : MSISDNList) {
                            msisdn.Order_Tagging_Related__c = orderRec.id;
                            msisdn.Order_Tagging_Completion_Date__c = orderRec.Stamp_Stage_Complete__c;
                            msisdn.Order_Tagging_By__c = orderRec.ownerid;

                            msisdn.Request_to_Tag__c = false;
                            msisdn.Tagged__c = true;

                            msisdn.Available_to_UnTag__c = true;
                            msisdn.UnTagged__c = false;
  

                            msisdn.Account_Tagging__c = orderRec.accountid;
                            
                        }        
                        update MSISDNList;
                    }

                    // -- update quantity of success to order product and opportunity 
                    List<OrderItem> orderItemList = [select id, quantity from OrderItem where orderid = :orderRec.id];
                    if (orderItemList.size() > 0) {
                        orderItemList[0].quantity = orderMSISDNSuccessList.size() ;
                        update orderItemList;
                    }

                    List<OpportunityLineItem> opportunityLineItemList = [select id, quantity from OpportunityLineItem where opportunityid = :orderRec.opportunityID];
                    if (opportunityLineItemList.size() > 0) {
                        opportunityLineItemList[0].quantity = orderMSISDNSuccessList.size() ;
                        opportunityLineItemList[0].qty_actual__c = orderMSISDNSuccessList.size() ;

                        system.debug('== opportunityLineItemList : ' + opportunityLineItemList);
                        update opportunityLineItemList;
                    }

                }

                //-- SET THE UNSUCCESS MSISDN (FAILED)
                List<Order_MSISDN__c> orderMSISDNFailedList = [SELECT id, MSISDN__c
                                                    FROM Order_MSISDN__c WHERE order__c =:orderRec.id and status__c <>'Success'  ];
                
                if (orderMSISDNFailedList.size() > 0) {
                    List <string> msisdnSFIDList = new List <string> ();
                    for (Order_MSISDN__c orderMSISDN  : orderMSISDNFailedList) {
                        msisdnSFIDList.add (orderMSISDN.MSISDN__c);
                    }

                    List<MSISDN__c> MSISDNList = [SELECT id, Order_Tagging_Related__c,	Order_Tagging_Completion_Date__c,	Order_Tagging_By__c
                                                        , Account_Tagging__c, Tagged__c, Request_to_Tag__c, Available_to_UnTag__c, UnTagged__c
                                                    FROM MSISDN__c WHERE id in :msisdnSFIDList ];

                    if (MSISDNList.size() > 0) {
                        for (MSISDN__c msisdn  : MSISDNList) {
                            msisdn.Request_to_Tag__c = false;
                            msisdn.Available_to_Tag__c = true;
                        }        
                        update MSISDNList;
                    }

                }

            }

        } 

    }

    public void updateOnUnTaggingOrder (Order orderRec) {
        system.debug('======= in method OrderController.updateOnUnTaggingOrder ====');

        switch on orderRec.status {
            when 'Untagging Process' {	
                List<Order_MSISDN__c> orderMSISDNList = [SELECT id, MSISDN__c
                                                    FROM Order_MSISDN__c WHERE order__c =:orderRec.id];
                
                system.debug('======= orderMSISDNList : ' +  orderMSISDNList);
                if (orderMSISDNList.size() > 0) {
                    List <string> msisdnSFIDList = new List <string> ();
                    for (Order_MSISDN__c orderMSISDN  : orderMSISDNList) {
                        msisdnSFIDList.add (orderMSISDN.MSISDN__c);
                    }

                    List<MSISDN__c> MSISDNList = [SELECT id, Available_to_Tag__c,	Request_to_Tag__c,
                                                        Available_to_UnTag__c,	Request_to_UnTag__c
                                                    FROM MSISDN__c WHERE id in :msisdnSFIDList ];

                    if (MSISDNList.size() > 0) {
                        for (MSISDN__c msisdn  : MSISDNList) {
                            msisdn.Available_to_UnTag__c = false;
                            msisdn.Request_to_UnTag__c = true;
                            
                            //msisdn.Available_to_Tag__c = false;
                            //msisdn.Request_to_Tag__c = false;

                            
                        }        
                        update MSISDNList;
                    }
                }
            }

            

            when 'Complete' {	

                //-- SET THE SUCCESS MSISDN
                List<Order_MSISDN__c> orderMSISDNSuccessList = [SELECT id, MSISDN__c
                                                    FROM Order_MSISDN__c WHERE order__c =:orderRec.id and status__c='Success'  ];

                                                  
                system.debug('======= orderMSISDNSuccessList : ' +  orderMSISDNSuccessList);
                if (orderMSISDNSuccessList.size() > 0) {
                    List <string> msisdnSFIDList = new List <string> ();
                    for (Order_MSISDN__c orderMSISDN  : orderMSISDNSuccessList) {
                        msisdnSFIDList.add (orderMSISDN.MSISDN__c);
                    }

                    List<MSISDN__c> MSISDNList = [SELECT id, Order_Tagging_Related__c,	Order_Tagging_Completion_Date__c,	Order_Tagging_By__c
                                                        , Account_Tagging__c, Tagged__c, Request_to_Tag__c, Available_to_UnTag__c, UnTagged__c
                                                    FROM MSISDN__c WHERE id in :msisdnSFIDList ];

                    if (MSISDNList.size() > 0) {
                        for (MSISDN__c msisdn  : MSISDNList) {
                            msisdn.Order_UnTagging_Related__c = orderRec.id;
                            msisdn.Order_UnTagging_Completion_Date__c = orderRec.Stamp_Stage_Complete__c;
                            msisdn.Order_UnTagging_By__c = orderRec.ownerid;

                            msisdn.Request_to_UnTag__c = false;
                            msisdn.UnTagged__c = true; 
                            
                            msisdn.Available_to_Tag__c = true;
                            msisdn.Tagged__c = false;

                            msisdn.Account_Tagging__c = orderRec.accountid;
                            
                        }        
                        update MSISDNList;
                    }

                    // -- update quantity of success to order product and opportunity product
                    List<OrderItem> orderItemList = [select id, quantity from OrderItem where orderid = :orderRec.id];
                    if (orderItemList.size() > 0) {
                        orderItemList[0].quantity = orderMSISDNSuccessList.size() ;
                        update orderItemList;
                    }

                    List<OpportunityLineItem> opportunityLineItemList = [select id, quantity from OpportunityLineItem where opportunityid = :orderRec.opportunityID];
                    if (opportunityLineItemList.size() > 0) {
                        opportunityLineItemList[0].quantity = orderMSISDNSuccessList.size() ;
                        opportunityLineItemList[0].qty_actual__c = orderMSISDNSuccessList.size() ;
                        
                        update opportunityLineItemList;
                    }
                }


                //-- SET THE NON SUCCESS MSISDN (FAILED)
                List<Order_MSISDN__c> orderMSISDNFailedList = [SELECT id, MSISDN__c
                                                    FROM Order_MSISDN__c WHERE order__c =:orderRec.id and status__c <> 'Success'  ];

                  
                if (orderMSISDNFailedList.size() > 0) {
                    List <string> msisdnSFIDList = new List <string> ();
                    for (Order_MSISDN__c orderMSISDN  : orderMSISDNFailedList) {
                        msisdnSFIDList.add (orderMSISDN.MSISDN__c);
                    }

                    List<MSISDN__c> MSISDNList = [SELECT id, Order_Tagging_Related__c,	Order_Tagging_Completion_Date__c,	Order_Tagging_By__c
                                                        , Account_Tagging__c, Tagged__c, Request_to_Tag__c, Available_to_UnTag__c, UnTagged__c
                                                    FROM MSISDN__c WHERE id in :msisdnSFIDList ];

                    if (MSISDNList.size() > 0) {
                        for (MSISDN__c msisdn  : MSISDNList) {

                            msisdn.Request_to_UnTag__c = false;
                            msisdn.Available_to_UnTag__c = true;
                            
                        }        
                        update MSISDNList;
                    }




                }

            }

        } 

    }

    public void deleteOnOrderMSISDN (Order orderRec, Order_MSISDN__c orderMSISDNRec) {
        system.debug('======= in method OrderController.deleteOnOrderMSISDN ====');

        if((orderRec.recordtypeid==system.label.RT_ORDER_POSTPAID_EXISTING
							||orderRec.recordtypeid==system.label.RT_ORDER_POSTPAID_NEW
							||orderRec.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_EXISTING
							||orderRec.recordtypeid==system.label.RT_ORDER_DEVICEBUNDLING_NEW
							
							))
		{
            MSISDN__c msisdnRec = new MSISDN__c(id = orderMSISDNRec.msisdn__c );
            msisdnRec.Request_to_Activate__c = false;
            msisdnRec.Available_to_Activate__c = true;

            update msisdnRec;
        
        }

        if((orderRec.recordtypeid==system.label.RT_ORDER_PREPAID_EXISTING
							||orderRec.recordtypeid==system.label.RT_ORDER_PREPAID_NEW
							))
		{
            MSISDN__c msisdnRec = new MSISDN__c(id = orderMSISDNRec.msisdn__c );
            msisdnRec.Request_to_Tag__c = false;
            msisdnRec.Available_to_Tag__c = true;

            update msisdnRec;
        
        }

        if( orderRec.recordtypeid==system.label.RT_ORDER_PREPAID_UNTAGGING_EXISTING)
		{
            MSISDN__c msisdnRec = new MSISDN__c(id = orderMSISDNRec.msisdn__c );
            msisdnRec.Request_to_UnTag__c = false;
            msisdnRec.Available_to_UnTag__c = true;

            update msisdnRec;
        
        }

    }


}