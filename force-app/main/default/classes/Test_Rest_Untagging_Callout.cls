/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 25-03-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   25-03-2022   Doddy Prima   Initial Version
**/
@isTest(seealldata=true)
private class Test_Rest_Untagging_Callout {

    static testMethod void myUnitTest() {
        /*
        RecordType RT=[SELECT id FROM Recordtype WHERE Name='LA'];
        List<Account> lstAcc = [Select id, Name From Account Where recordtypeid =:RT.id];
        
        /*Account A=New Account();
        A.Name='tes';
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Type='Competitor';
       
        A.Organization_type__c='Head Office';
        insert A;
        */
        /*
        system.debug('=== account id nya'+lstAcc[0].id);
        string A = lstAcc[0].id;
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM'];
        
        
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        MyOppty.AccountId = lstAcc[0].id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
        MyOppty.RecordTypeId = recTypeOppty.id;
        insert MyOppty;
        system.debug('=== MyOppty id nya'+MyOppty.id);
        //RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - New LA'];
        
       // List<Order> lstOrder = [Select id, Name,Status From Order Where OrderNumber = '00000198'];
       // system.debug('=== lstOrder size nya '+lstOrder.size());
        */

        

        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
      Id RecordTypeId_Opportunity_NonGSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Non GSM').getRecordTypeId();
      Id RecordTypeId_Opportunity_GSM = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GSM (Activation)').getRecordTypeId();
      Account accTest = new Account();

      Profile pf= [Select Id from profile where Name='System Administrator']; 
      
      String orgId=UserInfo.getOrganizationId(); 
      String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
      Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
      String uniqueName=orgId+dateString+RandomId; 
      User uu = new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'idewap@xl.co.id', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
      insert uu;
      
      Opportunity O = new Opportunity();
      Opportunity O2 = new Opportunity();

      
      
      system.runas(uu){
          
          accTest.RecordTypeId = recordTypeId_accBP;
          accTest.Name = 'Bank Maybank Indonesia Tbk';
          accTest.Unique_Name__c = 'Sentral Senayan Building 3';
          accTest.NumberOfEmployees = 2;
          accTest.Summary_Billing__c = false;
          accTest.Payer_For_GSM_Invoice__c = false;
          accTest.Using_HO_Billing_Address__c = false;
          accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
          accTest.Customer_VAT_Name__c = 'BANK MAYBANK INDONESIA TBK';
          accTest.Customer_Type__c = 'NONGSM';
          accTest.No_NPWP__c = '013093232091000';
          accTest.BillingStreet = 'hive';
          accTest.BillingState = 'hive';
          accTest.BillingCity = 'hive';
          accTest.BillingCountry = 'hive';
          accTest.BillingPostalCode = 'hive';
          accTest.ShippingStreet = 'hive';
          accTest.ShippingState = 'hive';
          accTest.ShippingCity = 'hive';
          accTest.ShippingCountry = 'hive';
          accTest.ShippingPostalCode = 'hive';
          accTest.Billing_Building_Name__c = 'hive';
          accTest.Shipping_Building_Name__c = 'hive';
          accTest.Field_Source__c = 'Bizstore Customer Registration';
          accTest.Organization_Type__c = 'Head Office';
          accTest.Type = 'Customer';
          accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
          accTest.OU__c = '1';
          accTest.Industry = 'Agriculture';
          accTest.BP_Number__c = '714197';
          accTest.Bizstore_Complete__c = false;
          Insert accTest;
          
          Account accTest2 = new Account(
              Name = 'PT Bank MayBank Indonesia Tbk',                         
              RecordTypeId = recordTypeId_accBP,                                     
              BP_Number__c = '707310',                                        
              Organization_Type__c = 'Branch',                                
              Type = 'Customer',                                              
              ParentId = accTest.Id,                                         
              Unique_Name__c = 'KCP Surabaya Pondok Candra',                  
              Customer_Type__c = 'NONGSM',                                    
              Payer_For_GSM_Invoice__c = false,                               
              term_of_payment__c = 'Z030 Within 30 Days Due Net',             
              Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)',
              Customer_VAT_Name__c = 'PT Bank MayBank Indonesia Tbk',         
              Summary_Billing__c = false,                                     
              Using_HO_Billing_Address__c = false                             
          );
          insert accTest2;
          
          Circuit__c  Circuit_Test = new Circuit__c(
              Name = '02-02021',
              datacode__c = 'circuitimport_201801'
          );
          insert Circuit_Test;
          
          Contract contractTest = new Contract();
          contractTest.Name = '[SAP] Contract Item of MPLS - 512 Kbps';
          contractTest.Full_Name__c = '[SAP] Contract Item of MPLS - 512 Kbps';
          contractTest.AccountId = accTest2.Id;
          contractTest.Account_BP_Payer__c = accTest.Id;
          contractTest.Start_Date__c = System.today();
          contractTest.End_Date__c = System.today();
          contractTest.Account_BP_VAT__c = accTest2.Id;
          contractTest.Contract_Term__c = 12;
          contractTest.Billing_Type__c = 'Monthly';
          contractTest.Price__c = 1213;
          contractTest.SAP_ID__c = '351';
          contractTest.Quantity__c = 1;
          contractTest.Periode_UOM__c = 'Month';
          contractTest.Bandwidth_filled__c = 512;
          contractTest.Bandwidth_UoM_filled__c = 'Kbps';
          contractTest.Account_Site_A_BP_Site__c = accTest2.Id;
          insert contractTest;
          
          Link__c linkTest = new Link__c(
              Name = '02-02021',                                  
              BU__c = 'ENTERPRISE',
              CID__c = '02-02021',                          
              ID__c = '3281',                       
              Status_Link__c = 'IN_SERVICE',
              Company_Name__c = 'Bank Maybank Indonesia Tbk',
              Service_Type__c = 'MPLS',
              Contract_Item__c = '3001207-351',
              BP_Site_A__c = '707310', 
              Capacity_Bandwidth__c = '512',
              UoM__c = 'Kbps',
              Routepath__c = '707310 BII KCP Pondok Candra Surabaya - POP BWA Rungkut (STARCOM) POP BWA Rungkut (STARCOM) - EC-SBRKO-01 EC-SBRKO-01',
              CID_RelD__c = Circuit_Test.Id,
              Link_ID__c = '007C362L84',
              Site_A_Name__c = accTest2.Id,
              Contract_Item_Rel__c = contractTest.Id,
              Free_Link__c = false,
              Selected__c = false,
              Partner__c = false                                                                    
          );
          insert linkTest;
          
          AccountContactRelation CR=new AccountContactRelation();
          Contact C=new Contact();
          C.LastName='Wiryo';
          C.Accountid=accTest.id;
          C.Firstname='Yohn';
          C.MobilePhone='0288282';
          C.Email='Fail@fail.com';
          insert C;
          
          CR.AccountID=accTest2.id;
          CR.Contactid=C.id;
          CR.Roles='PIC Site;PIC BA Sign';
          insert CR;

         //Create Product
         Product2 productObj = new Product2(Name = 'BIZ - Booster (Postpaid) - 1GB', Family = 'GSM', Product_Code2__c = 'Postpaid', Revenue_Type__c = 'Recurring', isActive = true);
         Insert productObj;

          //Create the PricebookEntry
          PricebookEntry pbe = new PricebookEntry(
              Pricebook2Id = Test.getStandardPricebookId(),
              Product2Id = productObj.Id,
              UnitPrice = 1020,
              IsActive = true
          );
          Insert pbe;

         Pricebook2 GSM_ActivationPricebook = new Pricebook2( name = 'GSM Activation',
             IsActive = true,
             GSM_Type__c = 'Package',
             Service_Group__c = 'GSM'
         );
         insert GSM_ActivationPricebook;

         PricebookEntry GSM_ActivationPbe = new PricebookEntry(
             Pricebook2Id = GSM_ActivationPricebook.Id,
             Product2Id = productObj.Id,
             UnitPrice = 1020,
             IsActive = true
         );
         Insert GSM_ActivationPbe;

          O.Accountid=accTest.id;
          O.Account_Site_A__c=accTest.id;
          O.Account_Site_B__c=accTest2.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.Link_Related__c=linkTest.id;
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id= Test.getStandardPricebookId();
          O.Periode_UOM__c='Month';
          O.BP_Payer__c=accTest2.id;
          O.BP_Vat__c=accTest2.id;
          O.Service_Type__c = 'Newlink';
          O.RecordTypeId = RecordTypeId_Opportunity_NonGSM;
          insert O;

          O2.Accountid=accTest.id;
          O2.Account_Site_A__c=accTest.id;
          O2.Account_Site_B__c=accTest2.id;
          O2.StageName='Prospecting';
          O2.Name='Tes';
          O2.Link_Related__c=linkTest.id;
          O2.CloseDate=system.today().adddays(10);
          O2.Pricebook2id= GSM_ActivationPricebook.id;
          O2.Periode_UOM__c='Month';
          O2.BP_Payer__c=accTest2.id;
          O2.BP_Vat__c=accTest2.id;
          O2.Service_Type__c = 'New Activation';
          O2.RecordTypeId = RecordTypeId_Opportunity_GSM;
          insert O2;

          OpportunitylineItem oliObj = new OpportunitylineItem();
          oliObj.unitprice = 10000;
          oliObj.quantity = 2;
          oliObj.billing_type__c = 'Monthly';
          oliObj.Revenue_Type__c = 'Recurring';
          oliObj.opportunityID = O2.id;
          oliObj.PricebookEntryId  = GSM_ActivationPbe.id;
          insert oliObj;

          O2.StageName = 'Negotiation';
          update O2;
      }


      Order MyOrder = New Order();
        MyOrder.AccountId = accTest.id;
        MyOrder.OpportunityId = o2.id;
        MyOrder.EffectiveDate = system.today();
        MyOrder.Name = 'POSTpaid Activation - New LA';
        MyOrder.Service_Type__c = 'New Number';
        //MyOrder.LA__c = A.id;
        MyOrder.Min_Commitment__c = true;
        MyOrder.RecordTypeId = system.label.RT_ORDER_Prepaid_Tagging_New_IDCOM;
        MyOrder.Type = 'Postpaid Activation';
        MyOrder.Status = 'Draft';
        MyOrder.Pending_Reason__c = 'POSTpaid Activaton';
        MyOrder.Phone__c = '0812321313';
        /*MyOrder.NPWP_No__c = '21361732131';
        MyOrder.OU__c = 'test';
        MyOrder.Address_street__c = 'street';
        MyOrder.Address_State_Province__c = 'my province';
        MyOrder.Address_City__c = 'my city';
        MyOrder.Address_Postal_Code__c = '12313';
        MyOrder.Address_Country__c = 'countru';
        */
        //


        MyOrder.COMNAME__c = 'CAD';
        MyOrder.COMTYPE__c = 'GADGET';
        MyOrder.ID_COM_Number__c = 'CAD';   
        insert MyOrder;
        system.debug('=== MyOrder id nya '+MyOrder.id);
        system.debug('=== MyOrder Name nya '+MyOrder.Name);
        
        
        
        Product2 MyProduct = new Product2();
        MyProduct.Name = 'BIZ - Booster (Postpaid) - 1GB';
        MyProduct.ProductCode = 'POSTPAID';
        MyProduct.Family = 'GSM';
        MyProduct.Revenue_Type__c = 'Recurring';
        insert MyProduct;
        
        //Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='BIZ - Booster (Postpaid) - 1GB'];
        //PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id LIMIT 1]; 
        /*Product2 PrdOrder = [SELECT id FROM Product2 WHERE id=:myProduct.id LIMIT 1];
        PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Product2Id=:PrdOrder.id LIMIT 1];
        
        OrderItem OrdItem = New OrderItem();
        OrdItem.OrderId = MyOrder.id;
        OrdItem.PricebookEntryId=  PBE.id;
        OrdItem.Quantity = 3;
        OrdItem.UnitPrice = 12000;
        insert OrdItem; 
        system.debug('=== OrdItem id nya'+OrdItem.id);
        */
        MSISDN__c MyMsisdn = new MSISDN__c();
        MyMsisdn.Account__c = accTest.id;
        MyMsisdn.Name = '6287799912301';
        MyMsisdn.MSISDN_No__c = '8962199912300001';
        MyMsisdn.Label__c = 'test label';
        MyMsisdn.ICCID__c = '8962199912300001';
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
        OrdMsisdn.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert OrdMsisdn;
        system.debug('=== OrdMsisdn id nya'+OrdMsisdn.id);
        
        Order_MSISDN__c OrdMsisdn1 = new Order_MSISDN__c();
        OrdMsisdn1.Name = '6287799900001';
        OrdMsisdn1.ICCID__c = '896219990000001';
        OrdMsisdn1.CL__c = 145000;
        OrdMsisdn1.Order__c= MyOrder.id;
        OrdMsisdn1.MSISDN__c = MyMsisdn.id;
        OrdMsisdn1.RecordTypeId = label.RT_ORDER_MSISDN_Tagging_Order;
        insert OrdMsisdn1;
        
        string orderID =MyOrder.id;
        
        Scheduled_Process__c  parSP = [select id, Scheduled_Process_Related__c from Scheduled_Process__c where Scheduled_Process_Related__c !=null limit 1];
        
        Test.startTest();
        
        SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'OK',
                                                         '{"access_token":"x43m7wuyvvw7xth7njr4mc8c","token_type":"bearer","expires_in":3600}',
                                                         null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_Exelcom_GetToken_EndPoint, getToken);
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //REST_Community.getAccessToken();
        //REST_Community.checkComm ('WEDHOUS', null);
        //REST_Community.createComm ('WEDHOUS', 'WEDHOUS', 'WEDHOUS', 1, 20);
        //REST_Community.taggingComm(jsonString, 'a0a5D000006W7tDQAS');
        Scheduled_Process__c  sp5 = new Scheduled_Process__c ();
        sp5.type__c = 'Callout GSMTagging';
        sp5.status__c = 'Waiting';
        sp5.parameter2__c='{"group_no":1, "data_limit":20}';
        sp5.parameter1__c=myorder.id;
        sp5.request_id__c='asasa';
        insert SP5;
        
        
        Scheduled_Process__c  sp6 = new Scheduled_Process__c ();
        sp6.type__c = 'Callout GSMTaggingCheck';
        sp6.status__c = 'Waiting';
        sp6.parameter2__c='{"group_no":1, "data_limit":20}';
        sp6.parameter1__c=myorder.id;
        sp6.request_id__c='asasa';
        sp6.Scheduled_Process_Related__c = sp5.id;
        insert SP6;
        
        SP_MSISDN__c  spMSISDN = new SP_MSISDN__c ();
        spMSISDN.name = 'SP Callout GSMunTagging';
        spMSISDN.Order_MSISDN__c = OrdMsisdn1.id;
        spMSISDN.Scheduled_Process__c=SP6.id;
        
        insert spMSISDN;
        REST_Untagging_Callout.requestunTaggingByGroup(orderID,1,2,SP6.id); 
        REST_Untagging_Callout.requestunTaggingCheckByGroup(orderID,1,2,SP6.id);
               
        Test.stopTest();
    }
}