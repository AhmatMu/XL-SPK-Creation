@isTest(seeAllData=true)
private class TEST_Trigger_Opp_SalesRevenue_Forecast {
    static testMethod void doScenario1Test() {
            
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        RecordType rt=[SELECT id FROM RecordType WHERE Name='Non GSM' and sobjecttype='opportunity' LIMIT 1];
        
        Product2 Ptime=[SELECT id FROM Product2 WHERE Name LIKE '%MPLS%' AND Revenue_Type__c='One Time' LIMIT 1];
        Product2 PRecurring=[SELECT id FROM Product2 WHERE Name ='MPLS - 1 Mbps' AND Revenue_Type__c='Recurring' LIMIT 1];

        Account A=[SELECT id from Account where Ownerid=:u.id LIMIT 1];
        //Account A=[SELECT id from Account where ID='0015D00000KkRgf' AND Ownerid=:u.id LIMIT 1];

        Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
		//id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NON GSM').getRecordTypeId();
        
        test.starttest();
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
            O.Accountid=A.id;
            O.Account_Site_A__c=A.id;
            O.RecordTypeid=rt.id;
            O.StageName='Prospecting';
            O.Amount =10000;
            O.Name='Tes';
            O.CloseDate=system.today().adddays(10);
            O.Pricebook2id=PB.id;
            o.service_type__c = 'newlink';
            insert O;
        
        OpportunityLineItem OLI=new OpportunityLineItem();
          OLI.Product2id=Ptime.id;
          OLI.OpportunityID=O.id;
          OLI.revenue_type__c='One Time';
          OLI.UnitPrice=10000000;
          OLI.Quantity=1;
          insert OLI;



            O.Amount =20000;
            update O;
        }  
    
        test.stoptest();
    }

}