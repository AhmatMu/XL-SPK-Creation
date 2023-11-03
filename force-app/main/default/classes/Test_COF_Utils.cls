@isTest
public class Test_COF_Utils {
        static testMethod void testTrigger(){
                
        list<User> U=[SELECT id,Email FROM User WHERE Name='Saasten Dev'];
        
        Transaction__c thisTrx = new Transaction__c();
        thisTrx.TransactionID__c = 301;
        insert thisTrx;
        
        
        Account A=new Account();
        A.Name='Tes';
        A.OwnerID=U[0].id;
        insert A;
        
        Opportunity Opp=new Opportunity();
        Opp.AccountID=A.id;
        Opp.Name='Opportunity for system';
        Opp.CloseDate=system.today().adddays(30);
        Opp.StageName='Waiting for BA';
        Opp.BA_Status__c=false;
        Opp.OwnerID=U[0].id;
        Opp.Service_Group__c='Non-GSM';
        Opp.service_type__C ='Newlink';
        insert Opp;
        
        COF__c co = new COF__c();
        co.name='sample cof';
        co.opportunity__c=Opp.id;
        co.Customer_Status__c = 'Existing';
        co.Ver_No__c=0;
        insert co;

        
        ApexPages.StandardController stdProd= new ApexPages.StandardController(co);
        COF_utils PC = new COF_utils(stdProd);
        PC.print();
        PC.cancel();
        
		co.Ver_No__c=0;
        update co;
            
        ApexPages.StandardController stdProd3= new ApexPages.StandardController(co);
        COF_utilsind PC3 = new COF_utilsind(stdProd3);
        PC3.print();
        PC3.cancel();
        
		Opportunity Opp2=new Opportunity();
        Opp2.AccountID=A.id;
        Opp2.Name='Opportunity for system';
        Opp2.CloseDate=system.today().adddays(30);
        Opp2.StageName='Waiting for BA';
        Opp2.BA_Status__c=false;
        Opp2.OwnerID=U[0].id;
        Opp2.Service_Group__c='Non-GSM';
        insert Opp2;
        
        COF__c co2 = new COF__c();
        co2.name='sample cof';
        co2.opportunity__c=Opp2.id;
        co2.Customer_Status__c = 'Existing';
        co2.Ver_No__c=1;
        insert co2;
        
        ApexPages.StandardController stdProd2= new ApexPages.StandardController(co2);
        COF_utils PC2 = new COF_utils(stdProd2);
        PC2.print();
        
        ApexPages.StandardController stdProd4= new ApexPages.StandardController(co2);
        COF_utilsind PC4 = new COF_utilsind(stdProd4);
        PC4.print();
    }
}