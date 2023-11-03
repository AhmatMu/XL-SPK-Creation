@isTest(seealldata=true)
private class Test_Schedule_IDCOMCreation_Check{
  
  static testMethod void test_execute_UseCase1(){
  
 
    test.startTest();
    //Order order_Obj = new Order(EffectiveDate = Date.today(), IsReductionOrder = false, Status = 'Draft', isReadyToApproval__c = false, New_LA__c = false, Summary_Billing__c = false, Summary_Invoice__c = false, Faktur_Pajak__c = false, Min_Commitment__c = false, Need_EDA__c = false, ID_COM_is_Created__c = false);
    //Insert order_Obj; 


    User U=[SELECT ID From User WHERE Name='Nityo Triantono'];
    Account A=New Account();
    Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
    PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id  and product2.isActive=true LIMIT 1];

   
    A.Name='tes';
    A.BillingStreet='Jl. S Parman';
    A.BillingCity='Jakarta';
    A.BillingPostalCode='14460';
    A.BillingState='DKI Jakarta';
    A.Organization_type__c='Head Office';
    insert A;
    Opportunity Op=new Opportunity();
    Op.Accountid=A.id;
    Op.StageName='Prospecting';
    Op.Name='Tes';
    Op.CloseDate=system.today();
    Op.Pricebook2id=PB.id;
    Op.Periode_UOM__c='Month';
    
    Op.BP_Payer__c=A.id;
    Op.BP_Vat__c=A.id;
    insert Op;
    OpportunityLineItem OLI=new OpportunityLineItem();
    OLI.Quantity=100;
    OLI.pricebookentryid=PBE.id;
    OLI.opportunityid=Op.id;
    OLI.UnitPrice=10000;
    insert OLI;
    SLOC__c S=new SLOC__c();
    S.Name='Tes';
    S.Sloc_id__c='123';
    insert S;

    Order Ord=New Order();
    Ord.AccountID=A.id;
    Ord.Name='Tes Order';
    Ord.Status='Draft';
    Ord.SLOC__c=S.id;
    Ord.recordtypeid=system.label.RT_ORDER_PREPAID_EXISTING;
    Ord.EffectiveDate=system.today();
    Ord.opportunityID=Op.id;
    Ord.Nama_Account__c='Tes Account';
    Ord.pic_name__c='Tes Contact';
    Ord.ID_COM_Number__c = 'COTS';

    insert Ord;
    OrderItem plcLineItem = new OrderItem(OrderId = Ord.id, PricebookEntryId = pbe.ID, Quantity = 1, UnitPrice = 300);
    insert plcLineItem;

    

    MSISDN__c MyMsisdn = new MSISDN__c();
    MyMsisdn.Account__c = a.id;
    MyMsisdn.Name = '6287799912301';
    MyMsisdn.MSISDN_No__c = '8962199912300001';
    MyMsisdn.Label__c = 'test label';
    MyMsisdn.ICCID__c = '8962199912300001';
  
    insert MyMsisdn;
    system.debug('=== MyMsisdn id nya'+MyMsisdn.id);
    
    Order_MSISDN__c OrdMsisdn = new Order_MSISDN__c();
      OrdMsisdn.Name = '6287799900001';
      OrdMsisdn.ICCID__c = '896219990000001';
      OrdMsisdn.CL__c = 145000;
      OrdMsisdn.Order__c= Ord.id;
      OrdMsisdn.MSISDN__c = MyMsisdn.id;
      OrdMsisdn.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
      insert OrdMsisdn;
      system.debug('=== OrdMsisdn id nya'+OrdMsisdn.id);
      
      Order_MSISDN__c OrdMsisdn1 = new Order_MSISDN__c();
      OrdMsisdn1.Name = '6287799900001';
      OrdMsisdn1.ICCID__c = '896219990000001';
      OrdMsisdn1.CL__c = 145000;
      OrdMsisdn1.Order__c= Ord.id;
      OrdMsisdn1.MSISDN__c = MyMsisdn.id;
      OrdMsisdn1.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
      insert OrdMsisdn1;


    Ord.Status='Create ID COM';
    update Ord;


  
  
    List<Order> order_Obj  =  [SELECT Id,EffectiveDate,IsReductionOrder,Status,isReadyToApproval__c,New_LA__c,Summary_Billing__c,Summary_Invoice__c,Faktur_Pajak__c,Min_Commitment__c,Need_EDA__c,ID_COM_is_Created__c from Order];
    System.assertEquals(true,order_Obj.size()>0);
    Schedule_IDCOMCreation_Check obj01 = new Schedule_IDCOMCreation_Check();
    obj01.execute(null);

    test.stopTest();

  }

}