// MSISDNController

@isTest(seealldata=true)
private class Test_MSISDNController  {

    
    static testMethod void myUnitTest() {
        Test.startTest();
        
        
        
        MSISDN__c msisdn = new MSISDN__c ();
        Opportunity opp = new Opportunity ();
        
//        opp = [select id from opportunity where opportunity_no__c = '1808-001138'];
//        insert opp;
        
          user u=[SELECT id from user WHERE Name='Yopi Apriyana' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='GSM (Activation)' LIMIT 1];
        
         Account A=[SELECT id from Account where BP_number__c='720830' LIMIT 1];
        Product2 P=[SELECT id FROM Product2 WHERE Name='National Zone Basic Postpaid 35 K' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='GSM'];
      
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
            
            O.Accountid=A.id;
            O.RecordTypeid=rt.id;
            O.StageName='Prospecting';
            O.Name='Tes';
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id=PB.id;
            O.Service_Group__c='GSM';
            O.Product_Interest__c='GSM';
            //O.SIMCard_Order_Payment_Type__c='FREE';
            //O.Cost_Center__c='500';
            //O.GL_Account__c='Netty';
            
            List<Package_Product__c> pp = [select id from Package_Product__c where name='PLN'];
            if (pp.size()>0) 
                O.Package_Product__c = pp[0].id;
            
/*          List<Card_Type__c> ct = [select id from Card_Type__c where name='PREPAID'];
            if (ct.size()>0)
                O.Card_Type__c = ct[0].id;
  */        
            O.Card_Type__c = 'PREPAID';
            
/*          List<SIMCard_Order_Payment_Type__c> spt = [select id from SIMCard_Order_Payment_Type__c where name='Corp Paid'];
            if (spt.size()>0)
            o.SIMCard_Order_Payment_Type__c= spt[0].id;
  */        
            o.SIMCard_Activation_Payment_Type__c= 'Corp Paid';
            
            List<Price_Plan__c> ppl = [select id from Price_Plan__c where name='CUG20'];
            if (ppl.size()>0)
                O.Price_Plan_Ref__c = ppl[0].id;
            
            List<APN__c> apn = [select id from APN__c where name='APN-1'];
            if (apn.size()>0)
                O.APN__c = apn[0].id;
            
            
            o.OU__c='test';
            O.Note__c ='hello';
            
            insert O;
            
            
            OpportunityLineItem OLI=new OpportunityLineItem();
            OLI.Product2id=P.id;
            OLI.OpportunityID=O.id;
            OLI.revenue_type__c='One Time';
            PricebookEntry PBE=[SELECT id from PricebookEntry WHERE Product2id=:P.id AND Pricebook2id=:pB.ID];
            OLI.PricebookEntryId=PBE.id;
            OLI.UnitPrice=10000000;
            OLI.Quantity=1;
            insert OLI;
        }        
        

        
         
         
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        MSISDNController msisdnControllerObj = new MSISDNController(sc); //Instantiate the Class
        
        //msisdnControllerObj.searchByOpportunity (string accID, string oppID, string type) ;
        
        //PageReference pr = new PageReference ();
        
      //  msisdnControllerObj.selectedCategories=null;
        msisdnControllerObj.searchText = '09';
        msisdnControllerObj.search();
        msisdnControllerObj.searchNotActive();
        msisdnControllerObj.save();
        msisdnControllerObj.NeedToAdd();
        msisdnControllerObj.NeedToUpload();
        
        
        msisdnControllerObj.toDelete();
        
        
        msisdnControllerObj.toActivate();
        
        msisdnControllerObj.cancel();
        msisdnControllerObj.cancelUpload();
        msisdnControllerObj.add();
       
        
        String str = 'MSISDN, ICCID, LABEL\n 6287885036699, 8962115331282820780, UDAH ADA\n 0880808080808,08AAAAAA,NEW'; 
        msisdnControllerObj.csvFileBody = Blob.valueOf(str);
        msisdnControllerObj.importMSISDN();
        
        
        Test.stopTest();
        
        }
}