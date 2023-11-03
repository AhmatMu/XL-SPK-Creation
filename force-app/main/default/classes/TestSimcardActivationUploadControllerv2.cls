@isTest(seealldata=true)
private class TestSimcardActivationUploadControllerv2 {
    
    static testMethod void testUploadValidation () {
    
            
            Account acc = [select id,ownerId from account where organization_type__c ='Head Office' limit 1];
            RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM (Activation)'];
            
            Pricebook2 PB=[SELECT id FROM Pricebook2 WHERE Name='GSM Activation'];
            PricebookEntry PBE=[SELECT id FROM PricebookEntry WHERE Pricebook2id=:PB.id and IsActive = True LIMIT 1];
            //Product2 PrdOrder = [SELECT id FROM Product2 WHERE name='z-dummy-product1' LIMIT 1];
            //PricebookEntry PBE=[SELECT id, product2id FROM PricebookEntry WHERE Pricebook2id=:PB.id and product2.name= 'z-dummy-product1' LIMIT 1];      	
            
            RecordType recTypeOrder = [Select id, Name From RecordType Where sObjectType = 'Order' and Name = 'POSTpaid Activation - Existing LA'];
    
            Opportunity Op = New Opportunity();
            Op.Name = 'Test GSM Activation';
            Op.Project_Group__c = 'Test Activation';
            Op.CloseDate = system.today();
            Op.AccountId = acc.id;
            Op.StageName = 'Prospecting';
            Op.Amount = 2250000;
            Op.Pricebook2id=PB.id;
            Op.OwnerId = acc.OwnerId;
        
            insert Op;
    
            OpportunityLineItem OLI=new OpportunityLineItem();
             OLI.Quantity=2;
             OLI.pricebookentryid=PBE.id;
             OLI.opportunityid=Op.id;
             OLI.UnitPrice=10000;
             insert OLI;
            
            test.starttest();
    
            Order Ord=New Order();
            Ord.AccountID=acc.id;
            Ord.opportunityId = Op.id;
            Ord.Status='Draft';
            
            Ord.EffectiveDate=system.today();
            Ord.pricebook2id = pb.id;
            Ord.RecordTypeId = recTypeOrder.id;
            insert Ord;
    
    
            MSISDN__c msisdn = new MSISDN__c(name = '6281709090909', iccid__c='8962115935455440000');
            insert msisdn;
            Order_MSISDN__c orderMSISDN = new Order_MSISDN__c(order__c =Ord.id, name='6281709090909', iccid__c ='8962115935455440000', MSISDN__c = msisdn.id, unique_id__c = Ord.id +'-8962115935455440000');
            insert orderMSISDN;
    
            msisdn = new MSISDN__c(name = '628170808080808', iccid__c='8962115935455490000');
            insert msisdn;
            orderMSISDN = new Order_MSISDN__c(order__c =Ord.id, name='628170808080808', iccid__c ='8962115935455490000', MSISDN__c = msisdn.id, unique_id__c = Ord.id +'-8962115935455490000');
            insert orderMSISDN;
    
            Account LA = [select id from Account where recordtype.name = 'LA' limit 1];
    
    		
            List<Order_msisdn__c> orderMSISDNList = new List<Order_msisdn__c>();
            Order_msisdn__c orderMSISDNObj = new Order_msisdn__c();
            //ApexPages.StandardController sc = new ApexPages.StandardController(orderMSISDNList);
            ApexPages.StandardController sc = new ApexPages.StandardController(orderMSISDNObj);
            SIMCardActivationUploadController SCAUController = new SIMCardActivationUploadController (SC); 
    
            SCAUController.getOrdertMSISDDataList(Ord.id);
            SCAUController.requestToUpload();
            SCAUController.requestToViewData();
            SCAUController.CancelUpload();
            SCAUController.IDCOMNumber();
            SCAUController.tagging(); 
            SCAUController.submit();
    
            string msisdnCSV= 'Name,ICCID,MSISDN,New MSISDN/IP,CL,PPS,Credit Class,Priceplan,AO,Email,Status,PC Notes\nDoddy,/8962115935455440000,/6281709090909,,145001,1,CX04,Biz Pro+ 12m,GPRS STD,f.nusantara24@gmail.com,Success,Hi\nDoddy,/8962115935455490000,/628170808080808,,500001,1,CX04,Biz Infinity+ 12m,GPRS STD,f.nusantara24@gmail.com,Success,hi' ;
            SCAUController.csvFileBody=  Blob.valueOf(msisdnCSV) ;
    
            SCAUController.doImportCSV();
    
            SCAUController.doExistingMSISDNExportCSV();
            SCAUController.doUploadMSISDNExportCSV();
            Ord.LA__c = LA.id;
            Ord.Status='Activation in Process';
            update Ord; 
            
            ApexPages.StandardsetController sc2 = new ApexPages.StandardSetController(orderMSISDNList);
            SIMCardActivationUploadController SCAUController2 = new SIMCardActivationUploadController (SC2); 
    
            SCAUController2.doUploadMSISDNExportCSV();
    
            SCAUController.doDeleteSelected();   
    
            test.stoptest();
        }
}