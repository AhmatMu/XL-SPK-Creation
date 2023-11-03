@isTest(seealldata=true)
public class test_updatePRController {
    static testMethod void myUnitTestPositif(){
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        /*RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where  Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];*/
        test.starttest();
      
        Opportunity O=[SELECT id,AccountID from Opportunity WHERE OwnerID=:U.id AND Recurring_Revenue__c>0 AND OneTime_Revenue__c>0 AND RecordType.Name LIKE '%Non GSM%' ORDER BY CREATEDDATE DESC LIMIT 1];
   
        system.runas(U){
        /*	O.Accountid=A.id;
        	O.Account_Site_A__c=A.id;
        	O.RecordTypeid=rt.id;
        	O.StageName='Prospecting';
        	O.Name='Tes';
        	O.CloseDate=system.today().adddays(10);
        	O.Pricebook2id=PB.id;
        	O.PR__c='10333';
        	O.SR__c='0222';
        		O.Service_Type__c='NewLink';*/
        	O.LastMile_Type__c='Radio';
        	O.Expected_RFS_Date__c=system.today().addmonths(3);
        	O.Contract_Periode__c=12;
        	O.Periode_Uom__c='Year';
        //	O.StageName='negotiation';
        	O.SR__c='22222';
        	 o.Project_Coordinator__c='90006544 Nancy Citraningrum';
        	 O.PKS_Number__c='2334';
        	update O;
       /* 		OpportunityLineItem OLI=new OpportunityLineItem();
        	OLI.Product2id=Ptime.id;
        	OLI.OpportunityID=O.id;
        	OLI.revenue_type__c='One Time';
        	OLI.UnitPrice=10000000;
        	OLI.Quantity=1;
        //	insert OLI;
        	OpportunityLineItem OLI2=new OpportunityLineItem();
        	OLI2.Product2id=Precurring.id;
        	OLI2.OpportunityID=O.id;
        	OLI2.revenue_type__c='Recurring';
        	OLI2.UnitPrice=50000000;
        	OLI2.Quantity=1;
        	insert OLI2;*/
        }
         Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            //tmpContract.name = 'TEST test';
            tmpContract.Account__c = O.AccountID;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = O.id;
        
            insert tmpContract;
                    Contract ci = new Contract();
            ci.name ='CI TEST';
            ci.Contract_Ticket__c = tmpContract.id;
            ci.Accountid=O.Accountid;
            ci.Opportunity__c=O.id;
            ci.Contract_Ticket__c=tmpContract.id;
            //--tutup dulu ci.BP_Payer__c='';
            //--tutup dulu ci.BP_VAT__c='';
            ci.Billing_Type__c=''; 
            ci.End_Date__c=system.today().addmonths(3);                   
            ci.start_Date__c=system.today().addmonths(3); 
            ci.Bill_Plan_End_Date__c=system.today().addyears(1);                 
            insert ci;
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        UpdatePRController updateprControllerObj = new UpdatePRController(sc);
        
        updateprControllerObj.resendConfirm();
        
        test.stoptest();
    }
 static testMethod void myUnitTestNegatif(){
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
/*        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where  Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
        Opportunity O=new Opportunity();
        String OpportunityID='';
       	*/
        Opportunity O=[SELECT id,AccountID from Opportunity WHERE OwnerID=:U.id AND Recurring_Revenue__c>0 AND OneTime_Revenue__c>0 AND RecordType.Name LIKE '%Non GSM%' ORDER BY CREATEDDATE DESC LIMIT 1];
        system.runas(U){
        /*	O.Accountid=A.id;
        	O.Account_Site_A__c=A.id;
        	O.RecordTypeid=rt.id;
        	O.StageName='Prospecting';
        	O.Name='Tes';
        	O.CloseDate=system.today().adddays(10);
        	O.Pricebook2id=PB.id;
        	O.PR__c='';
        	O.SR__c='';
        		O.Service_Type__c='NewLink';*/
        	O.LastMile_Type__c='Radio';
        	O.Expected_RFS_Date__c=system.today().addmonths(3);
        	O.Contract_Periode__c=12;
        	O.Periode_Uom__c='Year';
       // 	O.StageName='negotiation';
        	 o.Project_Coordinator__c='90006544 Nancy Citraningrum';
        	 O.PKS_Number__c='2334';
        	update O;
      /*  		OpportunityLineItem OLI=new OpportunityLineItem();
        	OLI.Product2id=Ptime.id;
        	OLI.OpportunityID=O.id;
        	OLI.revenue_type__c='One Time';
        	OLI.UnitPrice=10000000;
        	OLI.Quantity=1;
        //	insert OLI;
        	OpportunityLineItem OLI2=new OpportunityLineItem();
        	OLI2.Product2id=Precurring.id;
        	OLI2.OpportunityID=O.id;
        	OLI2.revenue_type__c='Recurring';
        	OLI2.UnitPrice=50000000;
        	OLI2.Quantity=1;
        	insert OLI2;*/
        }
         Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            //tmpContract.name = 'TEST test';
            tmpContract.Account__c = O.AccountID;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = O.id;
        
            insert tmpContract;
                    Contract ci = new Contract();
            ci.name ='CI TEST';
            ci.Contract_Ticket__c = tmpContract.id;
            ci.Accountid=O.Accountid;
            ci.Opportunity__c=O.id;
            ci.Contract_Ticket__c=tmpContract.id;
            //--tutup dulu ci.BP_Payer__c='';
            //--tutup dulu ci.BP_VAT__c='';
            ci.Billing_Type__c=''; 
            ci.End_Date__c=system.today().addmonths(3);                   
            ci.start_Date__c=system.today().addmonths(3); 
            ci.Bill_Plan_End_Date__c=system.today().addyears(1);                 
            insert ci;
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        UpdatePRController updateprControllerObj = new UpdatePRController(sc);
        
        updateprControllerObj.resendConfirm();
        
      //  test.stoptest();
    }
static testMethod void myUnitTestNegatif2(){
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
      /*  RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where  Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
        Opportunity O=new Opportunity();
        String OpportunityID='';*/
        Opportunity O=[SELECT id,AccountID from Opportunity WHERE OwnerID=:U.id AND Recurring_Revenue__c>0 AND OneTime_Revenue__c>0 AND RecordType.Name LIKE '%Non GSM%' ORDER BY CREATEDDATE DESC LIMIT 1];
        system.runas(U){
       /* 	O.Accountid=A.id;
        	O.Account_Site_A__c=A.id;
        	O.RecordTypeid=rt.id;
        	O.StageName='Prospecting';
        	O.Name='Tes';
        	O.CloseDate=system.today().adddays(10);
        	O.Pricebook2id=PB.id;
        	O.PR__c='';
        	O.SR__c='';
        		O.Service_Type__c='NewLink';*/
        	O.LastMile_Type__c='Radio';
        	O.Expected_RFS_Date__c=system.today().addmonths(3);
        	O.Contract_Periode__c=12;
        	O.Periode_Uom__c='Year';
     //   	O.StageName='negotiation';
        	 o.Project_Coordinator__c='90006544 Nancy Citraningrum';
        	 O.PKS_Number__c='2334';
        	update O;
        /*		OpportunityLineItem OLI=new OpportunityLineItem();
        	OLI.Product2id=Ptime.id;
        	OLI.OpportunityID=O.id;
        	OLI.revenue_type__c='One Time';
        	OLI.UnitPrice=10000000;
        	OLI.Quantity=1;
        //	insert OLI;
        	OpportunityLineItem OLI2=new OpportunityLineItem();
        	OLI2.Product2id=Precurring.id;
        	OLI2.OpportunityID=O.id;
        	OLI2.revenue_type__c='Recurring';
        	OLI2.UnitPrice=50000000;
        	OLI2.Quantity=1;
        	insert OLI2;*/
        }
         Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            //tmpContract.name = 'TEST test';
            tmpContract.Account__c = O.AccountID;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = O.id;
        
            insert tmpContract;
                    Contract ci = new Contract();
            ci.name ='CI TEST';
            ci.Contract_Ticket__c = tmpContract.id;
            ci.Accountid=O.Accountid;
            ci.Opportunity__c=O.id;
            ci.Contract_Ticket__c=tmpContract.id;
            //--tutup dulu ci.BP_Payer__c='';
            //--tutup dulu ci.BP_VAT__c='';
            ci.Billing_Type__c=''; 
            ci.End_Date__c=system.today().addmonths(3);                   
            ci.start_Date__c=system.today().addmonths(3); 
            ci.Bill_Plan_End_Date__c=system.today().addyears(1);                 
            insert ci;
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        UpdatePRController updateprControllerObj = new UpdatePRController(sc);
        
        updateprControllerObj.resendConfirm();
        
       // test.stoptest();
    }
}