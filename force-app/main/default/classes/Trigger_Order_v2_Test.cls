/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-09-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   02-09-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest(seealldata=true)
public class Trigger_Order_v2_Test {
    @isTest
    static void myUnitTestActivationNewLA() {
        
        
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='LA'];
        //List<Account> lstAcc = [Select id, Name From Account Where recordtypeid =:RT.id];
        
        RecordType BP_RT=[SELECT id FROM Recordtype WHERE Name='BP'];

        Account accRec = New Account();
        accRec.Name='Account Name'; 
        accRec.BillingStreet='Jl. S Parman';
        accRec.BillingCity='Jakarta';
        accRec.BillingPostalCode='14460';
        accRec.BillingState='DKI Jakarta';
        accRec.Type='Competitor';
        accRec.Organization_type__c='Head Office';
        accRec.recordtypeid = BP_RT.id;
        insert accRec;


        system.debug('=== account id nya'+accRec.id);
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM'];
        
        Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        MyOppty.AccountId = accRec.id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
        MyOppty.Pricebook2id=PB.id;
        MyOppty.RecordTypeId = recTypeOppty.id;
        insert MyOppty;
        system.debug('=== MyOppty id nya'+MyOppty.id);
        //RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - New LA'];
        
       // List<Order> lstOrder = [Select id, Name,Status From Order Where OrderNumber = '00000198'];
       // system.debug('=== lstOrder size nya '+lstOrder.size());
        
        Order MyOrder = New Order();
        MyOrder.AccountId = accRec.id;
        MyOrder.OpportunityId = MyOppty.id;
        MyOrder.EffectiveDate = system.today();
        MyOrder.Name = 'POSTpaid Activation - New LA';
        MyOrder.Service_Type__c = 'New Number';
        myorder.Pricebook2id=PB.id;
        //MyOrder.LA__c = A.id;
        MyOrder.Min_Commitment__c = true;
        MyOrder.RecordTypeId = system.label.RT_ORDER_POSTPAID_NEW;
        MyOrder.Type = 'Postpaid Activation';
        MyOrder.Status = 'Draft';
        MyOrder.Pending_Reason__c = 'POSTpaid Activaton';
        MyOrder.Phone__c = '0812321313';
        MyOrder.NPWP_No__c = '21361732131';
        MyOrder.OU__c = '123';
        MyOrder.Address_street__c = 'street';
        MyOrder.Address_State_Province__c = 'my province';
        MyOrder.Address_City__c = 'my city';
        MyOrder.Address_Postal_Code__c = '12313';
        MyOrder.Address_Country__c = 'countru';
        MyOrder.PIC_Name__c='ATest';
        myorder.PIC_Date_of_Birth__c=system.today().addyears(-18);
        myorder.Mobile_Phone__c='998129102';
        myorder.PIC_Email__c='tes@saasten.com';
        MyOrder.COMNAME__c = 'CAD';
        MyOrder.COMTYPE__c = 'GADGET';
        MyOrder.ID_COM_Number__c = 'CAD';
        
        insert MyOrder;
        system.debug('=== MyOrder id nya '+MyOrder.id);
        system.debug('=== MyOrder Name nya '+MyOrder.Name);
        system.debug('=== order.opp :'+ MyOrder.OpportunityId );
        
        
        /*
        Product2 MyProduct = new Product2();
        MyProduct.Name = 'BIZ - Booster (Postpaid) - 1GB';
        MyProduct.ProductCode = 'POSTPAID';
        MyProduct.Family = 'GSM';
        MyProduct.Revenue_Type__c = 'Recurring';
        insert MyProduct;
        */

        
       
        Product2 PrdOrder = [SELECT id , ao_related__r.name , price_plan_related__r.name FROM Product2 WHERE 
            ao_related__r.name = 'AO_Post_M2M_50MB_Tier1_25K_NonAMR'
            AND price_plan_related__r.name = 'FWT OFFER'
            LIMIT 1];
        system.debug ('== PrdOrder : ' +  PrdOrder);
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Product2Id=:PrdOrder.id and pricebook2id=:PB.id LIMIT 1];
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.Quantity=100;
        OLI.pricebookentryid=PBE.id;
        OLI.opportunityid=MyOppty.id;
        OLI.UnitPrice=10000;
        insert OLI;

        OrderItem OrdItem = New OrderItem();
        OrdItem.OrderId = MyOrder.id;
        OrdItem.PricebookEntryId=  PBE.id;
        OrdItem.Quantity = oli.quantity;
        OrdItem.UnitPrice = 10000;
        insert OrdItem; 
        system.debug('=== OrdItem id nya'+OrdItem.id);
        
        MSISDN__c MyMsisdn = new MSISDN__c();
        MyMsisdn.Account__c = accRec.id;
        MyMsisdn.Name = '6287799912301';
        MyMsisdn.MSISDN_No__c = '8962199912300001';
        MyMsisdn.Label__c = 'test label';
        MyMsisdn.ICCID__c = '8962199912300001';
        MyMsisdn.Order_SIM_Card_Related__c = MyOrder.Id;
        //MyMsisdn.Status__c = '';
        //MyMsisdn.Dealer_Account__c = lstAcc[0].id;
        insert MyMsisdn;
        system.debug('=== MyMsisdn id nya'+MyMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn = new Order_MSISDN__c();
        OrdMsisdn.Name = '6287799900001';
        OrdMsisdn.ICCID__c = '896219990000001';
        OrdMsisdn.CL__c = 145000;
        OrdMsisdn.Order__c= MyOrder.id;
        OrdMsisdn.MSISDN__c = MyMsisdn.id;

        //OrdMsisdn.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert OrdMsisdn;
        system.debug('=== OrdMsisdn id nya'+OrdMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn1 = new Order_MSISDN__c();
        OrdMsisdn1.Name = '6287799900001';
        OrdMsisdn1.ICCID__c = '896219990000001';
        OrdMsisdn1.CL__c = 145000;
        OrdMsisdn1.Order__c= MyOrder.id;
        OrdMsisdn1.MSISDN__c = MyMsisdn.id;
        //OrdMsisdn1.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        
        OrdMsisdn1.ao__c = 'AO_Post_M2M_50MB_Tier1_25K_NonAMR';
        OrdMsisdn1.priceplan__c = 'FWT OFFER';
        OrdMsisdn1.status__c = 'Success';
        insert OrdMsisdn1;
   

        Test.startTest();

        myorder.Status='Activation in Review';
        update myorder;

        myorder.Status='Activation in Process';
        update myorder;

    
        myorder.Status='Complete';
        update myorder;
        
        test.stoptest();
    }

    @isTest
    static void myUnitTestActivationExistingLA() {
        RecordType LA_RT=[SELECT id FROM Recordtype WHERE Name='LA'];
        RecordType BP_RT=[SELECT id FROM Recordtype WHERE Name='BP'];

        Account accRec = New Account();
        accRec.Name='Account Name'; 
        accRec.BillingStreet='Jl. S Parman';
        accRec.BillingCity='Jakarta';
        accRec.BillingPostalCode='14460';
        accRec.BillingState='DKI Jakarta';
        accRec.Type='Competitor';
        accRec.Organization_type__c='Head Office';
        accRec.recordtypeid = BP_RT.id;
        insert accRec;

        Account LARec = New Account();
        LARec.Name='LA Name'; 
        LARec.BillingStreet='Jl. S Parman';
        LARec.BillingCity='Jakarta';
        LARec.BillingPostalCode='14460';
        LARec.BillingState='DKI Jakarta';
        LARec.Type='Competitor';
        LARec.Organization_type__c='Branch';
        LARec.recordtypeid = LA_RT.id;
        LARec.parentid =  accRec.id;
        LARec.OU__c = '123';
        insert LARec;


        
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM'];
        
        Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        MyOppty.AccountId = accRec.id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
        MyOppty.Pricebook2id=PB.id;
        MyOppty.RecordTypeId = recTypeOppty.id;
        insert MyOppty;
        system.debug('=== MyOppty id nya'+MyOppty.id);
        //RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - New LA'];
        
       // List<Order> lstOrder = [Select id, Name,Status From Order Where OrderNumber = '00000198'];
       // system.debug('=== lstOrder size nya '+lstOrder.size());
        
        Order MyOrder = New Order();
        MyOrder.AccountId = accRec.id;
        MyOrder.OpportunityId = MyOppty.id;
        MyOrder.EffectiveDate = system.today();
        MyOrder.Name = 'POSTpaid Activation - Existing LA';
        MyOrder.Service_Type__c = 'New Number';
        myorder.Pricebook2id=PB.id;
        MyOrder.LA__c = LARec.id;
        MyOrder.Min_Commitment__c = true;
        MyOrder.RecordTypeId = system.label.RT_ORDER_POSTPAID_EXISTING;
        MyOrder.Type = 'Postpaid Activation';
        MyOrder.Status = 'Draft';
        MyOrder.Pending_Reason__c = 'POSTpaid Activaton';
        MyOrder.Phone__c = '0812321313';
        MyOrder.NPWP_No__c = '21361732131';
        MyOrder.OU__c = 'test';
        MyOrder.Address_street__c = 'street';
        MyOrder.Address_State_Province__c = 'my province';
        MyOrder.Address_City__c = 'my city';
        MyOrder.Address_Postal_Code__c = '12313';
        MyOrder.Address_Country__c = 'countru';
        MyOrder.PIC_Name__c='ATest';
        myorder.PIC_Date_of_Birth__c=system.today().addyears(-18);
        myorder.Mobile_Phone__c='998129102';
        myorder.PIC_Email__c='tes@saasten.com';
        MyOrder.COMNAME__c = 'CAD';
        MyOrder.COMTYPE__c = 'GADGET';
        MyOrder.ID_COM_Number__c = 'CAD'; 
        MyOrder.Order_DCP__c  =false;  
        insert MyOrder;
        system.debug('=== MyOrder id nya '+MyOrder.id);
        system.debug('=== MyOrder Name nya '+MyOrder.Name);
        system.debug('=== order.opp :'+ MyOrder.OpportunityId );
        
        
        /*
        Product2 MyProduct = new Product2();
        MyProduct.Name = 'BIZ - Booster (Postpaid) - 1GB';
        MyProduct.ProductCode = 'POSTPAID';
        MyProduct.Family = 'GSM';
        MyProduct.Revenue_Type__c = 'Recurring';
        insert MyProduct;
        */

        
       
        Product2 PrdOrder = [SELECT id , ao_related__r.name , price_plan_related__r.name FROM Product2 WHERE 
            ao_related__r.name = 'AO_Post_M2M_50MB_Tier1_25K_NonAMR'
            AND price_plan_related__r.name = 'FWT OFFER'
            LIMIT 1];
        system.debug ('== PrdOrder : ' +  PrdOrder);
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Product2Id=:PrdOrder.id and pricebook2id=:PB.id LIMIT 1];
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.Quantity=100;
        OLI.pricebookentryid=PBE.id;
        OLI.opportunityid=MyOppty.id;
        OLI.UnitPrice=10000;
        insert OLI;

        OrderItem OrdItem = New OrderItem();
        OrdItem.OrderId = MyOrder.id;
        OrdItem.PricebookEntryId=  PBE.id;
        OrdItem.Quantity = oli.quantity;
        OrdItem.UnitPrice = 10000;
        insert OrdItem; 
        system.debug('=== OrdItem id nya'+OrdItem.id);
        
        MSISDN__c MyMsisdn = new MSISDN__c();
        MyMsisdn.Account__c = accRec.id;
        MyMsisdn.Name = '6287799912301';
        MyMsisdn.MSISDN_No__c = '8962199912300001';
        MyMsisdn.Label__c = 'test label';
        MyMsisdn.ICCID__c = '8962199912300001';
        MyMsisdn.Order_SIM_Card_Related__c = MyOrder.Id;
        //MyMsisdn.Status__c = '';
        //MyMsisdn.Dealer_Account__c = lstAcc[0].id;
        insert MyMsisdn;
        system.debug('=== MyMsisdn id nya'+MyMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn = new Order_MSISDN__c();
        OrdMsisdn.Name = '6287799900001';
        OrdMsisdn.ICCID__c = '896219990000001';
        OrdMsisdn.CL__c = 145000;
        OrdMsisdn.Order__c= MyOrder.id;
        OrdMsisdn.MSISDN__c = MyMsisdn.id;

        //OrdMsisdn.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert OrdMsisdn;
        system.debug('=== OrdMsisdn id nya'+OrdMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn1 = new Order_MSISDN__c();
        OrdMsisdn1.Name = '6287799900001';
        OrdMsisdn1.ICCID__c = '896219990000001';
        OrdMsisdn1.CL__c = 145000;
        OrdMsisdn1.Order__c= MyOrder.id;
        OrdMsisdn1.MSISDN__c = MyMsisdn.id;
        //OrdMsisdn1.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        
        OrdMsisdn1.ao__c = 'AO_Post_M2M_50MB_Tier1_25K_NonAMR';
        OrdMsisdn1.priceplan__c = 'FWT OFFER';
        OrdMsisdn1.status__c = 'Success';
        insert OrdMsisdn1;
   
        myorder.Status='Activation in Review';
        update myorder;



        Test.startTest();

        myorder.Status='Complete';
        update myorder;

        test.stoptest();
    }

    @isTest
    static void prepaid() {
        // TO DO: implement unit test
        User U=[SELECT ID From User WHERE Name='Nityo Triantono'];
        Account Accountobj=New Account();
        Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM-Material General'];
         PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id and product2.isactive=true LIMIT 1];

       
        Accountobj.Name='tes';
        Accountobj.BillingStreet='Jl. S Parman';
        Accountobj.BillingCity='Jakarta';
        Accountobj.BillingPostalCode='14460';
        Accountobj.BillingState='DKI Jakarta';
        Accountobj.Organization_type__c='Head Office';
        Accountobj.OU__c = '1234';
        insert Accountobj;
        Opportunity Opp=new Opportunity();
        Opp.Accountid=Accountobj.id;
        Opp.StageName='Prospecting';
        Opp.Name='Tes';
        Opp.CloseDate=system.today();
        Opp.Pricebook2id=PB.id;
        Opp.Periode_UOM__c='Month';
        Opp.TotalOpportunityQuantity=1;
        
        
        Opp.BP_Payer__c=Accountobj.id;
        Opp.BP_Vat__c=Accountobj.id;
        insert Opp;
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.Quantity=100;
        OLI.pricebookentryid=PBE.id;
        OLI.opportunityid=Opp.id;
        OLI.UnitPrice=10000;
        insert OLI;
        SLOC__c S=new SLOC__c();
        S.Name='Tes';
        S.Sloc_id__c='123';
        insert S;
        Order Orderobj=New Order();
             Orderobj.AccountID=Accountobj.id;
             Orderobj.Name='Tes Order';
            Orderobj.Status='Draft';
             Orderobj.SLOC__c=S.id;
             Orderobj.recordtypeid=system.label.RT_ORDER_PREPAID_NEW;
             Orderobj.EffectiveDate=system.today();
             Orderobj.opportunityID=Opp.id;
             Orderobj.Nama_Account__c='Tes Account';
             Orderobj.pic_name__c='Tes Contact';
             Orderobj.OU__c = '1234';
             insert Orderobj;
             OrderItem plcLineItem = new OrderItem(OrderId = Orderobj.id, PricebookEntryId = pbe.ID, Quantity = 1, UnitPrice = 300);
             insert plcLineItem;
          //   O.Status='Activation in Process';
          //   update O;

        Order_MSISDN__c orderMSISDNObj = new Order_MSISDN__c();
        orderMSISDNObj.name ='081616177190';
        orderMSISDNObj.iccid__c ='12415346576';
        orderMSISDNObj.order__c = Orderobj.id;
        insert orderMSISDNObj;


        Test.startTest();
        Orderobj.Status='Create ID COM';
          update Orderobj;

          Orderobj.Status='Tagging Process';
          update Orderobj;

            Orderobj.Status='Complete';
            Orderobj.Ownerid=U.id;
             update Orderobj;
          Test.stopTest();
        
        /*
             Schedule_Order_GSM_Closed_Date SGCD=new Schedule_Order_GSM_Closed_Date();
             SGCD.execute(null);
        system.runAs(U)
        {
            
        }
*/
        
    }
}