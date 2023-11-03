/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seealldata=true)
public class Test_Contract_Services {

  static testMethod void upgrade() {
        // TO DO: implement unit test
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' and SobjectType ='Opportunity' LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.service_type__c='Upgrade';
          
          O.BW_after__c= '1';
          O.Uom_BW_After__c = 'Mbps';
          O.Uom_BW_before__c = 'Mbps';
          
          insert O;
      
          List <OpportunityLineItem> OliList = new List<OpportunityLineItem >();   
          OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          OLI.Billing_Type__c='Monthly';
          OliList.add( OLI);

          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=PRecurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=5000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OliList.add (OLI2);
          
          insert OliList;          
        }
        Contract_Services CS=new Contract_Services();
        CS.CreateContractsFromOpportunity(String.valueof(O.id));
        test.STOPtest();
     }
     
     static testMethod void downgrade() {
        // TO DO: implement unit test
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' and SobjectType ='Opportunity'  LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes2';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.service_type__c='Downgrade';
          O.BW_before__c = '0.05';
          O.BW_after__c = '1';
          O.Uom_BW_Before__c = 'Mbps';
          O.Uom_BW_After__c = 'Mbps';
          
          insert O;
      
          List <OpportunityLineItem> OliList = new List<OpportunityLineItem >();   
          OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          OLI.Billing_Type__c='Monthly';
          OliList.add( OLI);

          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=PRecurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=5000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OliList.add( OLI2);
          
          insert OliList;          
        }
        Contract_Services CS=new Contract_Services();
        CS.CreateContractsFromOpportunity(String.valueof(O.id));
        test.STOPtest();
     }
     
     static testMethod void Reroute() {
        // TO DO: implement unit test
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' and SobjectType ='Opportunity'  LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.service_type__c='Reroute';
          O.BW_After__c='5';
          insert O;
      
          OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          OLI.Billing_Type__c='Monthly';
          
          insert OLI;
         
        }
        Contract_Services CS=new Contract_Services();
        CS.CreateContractsFromOpportunity(String.valueof(O.id));
     }
          
     static testMethod void RELOCATION() {
        // TO DO: implement unit test
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' and SobjectType ='Opportunity'  LIMIT 1];
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
         Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=rt.id;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.service_type__c='Relocation';
          O.BW_After__c='5';
          insert O;
      
          List <OpportunityLineItem> OliList = new List<OpportunityLineItem >();   
          OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          OLI.Billing_Type__c='Monthly';
          OliList.add( OLI);

          OpportunityLineItem OLI2=new OpportunityLineItem();
          OLI2.Product2id=PRecurring.id;
          OLI2.OpportunityID=O.id;
          OLI2.revenue_type__c='Recurring';
          OLI2.UnitPrice=5000000;
          OLI2.Quantity=1;
          OLI2.Billing_Type__c='Monthly';
          OliList.add( OLI2);
          
          insert OliList;          
        }
        Contract_Services CS=new Contract_Services();
        CS.CreateContractsFromOpportunity(String.valueof(O.id));
         CS.updateContractsFromOpportunity(String.valueof(O.id));
     }
     static testmethod void changeprice()
     {
        Opportunity O=[SELECT ID,Account.Ownerid,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c,Link_Related__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>3000000 ORDER BY CREATEDDATE DESC LIMIT 1];
            Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            //tmpContract.name = 'TEST test';
            tmpContract.Account__c = O.AccountID;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = O.id;
            insert tmpContract;
            
            Contact CON=new COntact();
            Con.LastName='USer BA Print ';
            Con.Title='Bos';
            Con.Email='Tes@SF.com';
            Con.AccountID=O.Accountid;
            insert Con;
            
            AccountContactRelation AC3=[SELECT id,roles FROM AccountContactRelation WHERE AccountID=:O.Accountid AND ContactID=:Con.id];
            AC3.Roles='BA Print;';
            update AC3;
            
            Contact CON2=new COntact();
            Con2.LastName='BA Recipient';
            Con2.Title='BA Rec';
            Con2.Email='barec@SF.com';
            Con2.AccountID=O.Accountid;
            insert Con2;
            
            AC3=[SELECT id,roles FROM AccountContactRelation WHERE AccountID=:O.Accountid AND ContactID=:Con2.id];
            AC3.Roles='BA Recipient;';
            update AC3;
      
      
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
            
            Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
            CTI.Contract_Item__c=ci.id;
            CTI.Contract_Ticket__c=TmpContract.id;
            insert CTI;
            
            Contract_Extension__c CE=new Contract_Extension__c();
            CE.Account__c=O.AccountID;
            CE.Account_Manager__c=O.Account.Ownerid;
            CE.Existing_Contract_Item__c=CI.id;
            CE.Extension_Start_Date__c=system.today().addmonths(-1);
             CE.Extension_end_Date__c=system.today().addmonths(10);
             CE.Link__c=O.Link_Related__c;
             CE.Status__c='Fill BA Recipient and BA Print';
             CE.Link_Partner__c=false;
                User usr = [select id,name, email from user where profile.name='Solution' limit 1];
             usr.email = 'doddy.prima@gmail.com'; 
             update usr;
             
             CE.Solution_PIC__c = usr.id;
             insert CE;
             CE.Approved_By_Solution__c=true;
             CE.BA_Print__c=Con.id;
             CE.Status__c='Send BA To Customer';
             update CE;
              Contract_Services CS=new Contract_Services();
             CS.CreateChangePriceFromBAExtension(CE.id);
       
     }
     static testmethod void contractextension()
     {
        Opportunity O=[SELECT ID,Account.Ownerid,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c,Link_Related__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>3000000 ORDER BY CREATEDDATE DESC LIMIT 1];
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
            
            Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
            CTI.Contract_Item__c=ci.id;
            CTI.Contract_Ticket__c=TmpContract.id;
            insert CTI;
            
            Contract_Extension__c CE=new Contract_Extension__c();
            CE.Account__c=O.AccountID;
            CE.Account_Manager__c=O.Account.Ownerid;
            CE.Existing_Contract_Item__c=CI.id;
            CE.Extension_Start_Date__c=system.today().addmonths(-1);
             CE.Extension_end_Date__c=system.today().addmonths(10);
             CE.Link__c=O.Link_Related__c;
             CE.Status__c='Fill BA Recipient and BA Print';
             CE.Link_Partner__c=false;
             
             User usr = [select id,name, email from user where profile.name='Solution' limit 1];
             usr.email = 'doddy.prima@gmail.com'; 
             update usr;
             
             CE.Solution_PIC__c = usr.id;
             
             insert CE;
              Contract_Services CS=new Contract_Services();
             CS.CreateContractsFromBAExtension(CE.id);
     }
}