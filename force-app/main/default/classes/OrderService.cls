/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 03-14-2022
 * @last modified by  : Diky Nurosid
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   21-02-2022   Doddy Prima   Initial Version
**/
public with sharing class OrderService {
    public Order orderRec; 

    public OrderService(Order orderRec) {
        this.orderRec = orderRec;

    }


    /**
     * get remining of product quantity each product
     */
    public Map<string, decimal> getRemainingOfOrderProductQuantity () {
        
        // get USED msisdn numbers per product (sfid)
        // used mean : the order stats after draft till complete 
        AggregateResult[] orderProductARList=[
                                SELECT SUM(Quantity) usedQty,
                                    PricebookEntry.ID productEntryID 
                                FROM OrderItem 
                                WHERE Order.OpportunityID =: orderRec.opportunityid 
                                    AND Order.Status <> 'Draft'  
                                GROUP BY PricebookEntry.ID
        ];

        
        //-- put the used msisdn number in map (pribook--entry--sfid, used--quantity )
        Map<string, decimal> orderProdUsedQuantityMap = new Map<string, decimal>();
        for (AggregateResult orderProductARRec: orderProductARList) {
            string productEntryID = (string) orderProductARRec.get('productEntryID');
            decimal quantity = (decimal) orderProductARRec.get('usedQty');
            
            orderProdUsedQuantityMap.put (productEntryID, quantity );
        }
        system.debug ('=== orderProdUsedQuantityMap : ' + orderProdUsedQuantityMap);


        
        return orderProdUsedQuantityMap;
    }


    
}