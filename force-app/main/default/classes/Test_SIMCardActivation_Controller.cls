// SIMCardActivation_Controller
//TODO DISINI YA!!!!

@isTest(seealldata=true)
private class Test_SIMCardActivation_Controller  {

    
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
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name ='GSM'];
      
       
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
            
            O.Accountid=A.id;
            O.RecordTypeid=rt.id;
            O.StageName='Prospecting';
            O.Name='Tes';
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id=PB.id;
            //O.SIMCard_Order_Payment_Type__c='FREE';
            //O.Cost_Center__c='500';
            //O.GL_Account__c='Netty';
            
            
            List<Package_Product__c> pp = [select id from Package_Product__c where name='PLN'];
            if (pp.size()>0) 
                O.Package_Product__c = pp[0].id;
            O.Card_Type__c = 'PREPAID';
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
        SIMCardActivation_Controller SIMCardActivationControllerObj = new SIMCardActivation_Controller(sc); //Instantiate the Class
        
        
        List<Opportunity_attachment__c> oas = new List<Opportunity_attachment__c> ();
        
        Opportunity_attachment__c oa = new Opportunity_attachment__c();
        oa.opportunity__c = O.id;
        oa.Title__C='bro';
        oa.status__c='Sent Success';
        oas.add(oa);
        insert oas;
        
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(oas);
        SIMCardActivationControllerObj = new SIMCardActivation_Controller(ssc); //Instantiate the Class
        
        
        Integer ii = SIMCardActivationControllerObj.getMySelectedSize();
        Integer iii = SIMCardActivationControllerObj.getMyRecordsSize();
        SIMCardActivationControllerObj.resendConfirm();
                
        Test.stopTest();
        
        }
}