@isTest(seealldata=true)
private class Test_Trigger_ContentDocumentLink {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
         Test.startTest();
          SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);

        SingleRequestMock UploadActivation = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"uploadfile","request_id":"96aeaea4-f24a-b2eb-8d35-7a547915b8cf"},"body":{"data":{"success":false,"message":"File Uploaded Successfully","sf_id":"197","filename":"5b83f091899ed.txt"}}}',
                                                   null);


        SingleRequestMock CreateSalesActivation = new SingleRequestMock(200,
                                                  'success',
                                                  '{"headers":{"status":"success","service":"addsalesactivation","request_id":"657878986879"},"body":{"data":{"success":false,"message":"Record has been saved.","sa_id":"124", "sf_id":"197"}}}',
                                                   null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        endpoint2TestResp.put(Label.REST_TransDB_SimCardActivation_Endpoint, UploadActivation);
        endpoint2TestResp.put(Label.REST_TransDB_SimCardActivation_Endpoint, CreateSalesActivation);
        
        HttpCalloutMock multiCalloutMock =
                                 new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        /*
          user u=[SELECT id from user WHERE Name='Erik Ridha' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='GSM (Simcard Order)' LIMIT 1];
        
         Account A=[SELECT id from Account where Name='PT Nettocyber Indonesia' AND Organization_type__c='Head Office' LIMIT 1];
        Product2 P=[SELECT id FROM Product2 WHERE Name='BIZ - Infinity (Postpaid) - Unlimited' AND FamilY='GSM' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name ='GSM'];
      */
       
               Opportunity opp = new Opportunity ();
        
//        opp = [select id from opportunity where opportunity_no__c = '1808-001138'];
//        insert opp;
        
          user u=[SELECT id from user WHERE Name='Yopi Apriyana' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='GSM (Activation)' LIMIT 1];
        
         Account A=[SELECT id from Account where BP_number__c='720830' LIMIT 1];
        Product2 P=[SELECT id FROM Product2 WHERE Name='National Zone Basic Postpaid 35 K' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name ='GSM Activation'];
      
       
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
            
            
            //-- attachments:
                    // -- Create and insert 2 Attachment instances and relate to Opportunity      
            /*
            Attachment att1 = new Attachment();
            att1.Name       = 'Unit Test Attachment 1';
            att1.body       = Blob.valueOf('Unit Test Attachment Body 1');
            att1.parentId   = o.id;
               
            insert att1;   
                
            Attachment att2 = new Attachment();
            att2.Name       = 'Unit Test Attachment 2';
            att2.body       = Blob.valueOf('Unit Test Attachment Body 2');
            att2.parentId   = o.id;   
                
            insert att2;
            */
            
            
            
            
            
            /*OpportunityLineItem OLI=new OpportunityLineItem();
            OLI.Product2id=P.id;
            OLI.OpportunityID=O.id;
            OLI.revenue_type__c='One Time';
            PricebookEntry PBE=[SELECT id from PricebookEntry WHERE Product2id=:P.id AND Pricebook2id=:pB.ID];
            OLI.PricebookEntryId=PBE.id;
            OLI.UnitPrice=10000000;
            OLI.Quantity=1;
            insert OLI;*/

            String yourFiles = 'Lets assume this is your binary string of the files';
 
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'ionicLogo.png'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'Proposal '; // Display name of the files
            conVer.VersionData = EncodingUtil.base64Decode(yourFiles); // converting your binary string to Blog
            insert conVer;
            
            
            // First get the content document Id from ContentVersion
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
             
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = O.Id; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            //cDe.Visibility = 'InternalUsers';
            insert cDe;
            
            delete cDe;
            
            
        }    
        
    }
}