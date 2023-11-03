@isTest(seealldata=true)
public class Test_Trigger_PR_Create_STR {
    
    static testMethod void testMethod_Create_PR() {
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        
        Account acc = new Account ();
        //acc.Name ='Test';
        //insert acc;
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        Link__c CLink=[SELECT id from Link__c LIMIT 1];
        acc = a;

        Contact cont = new Contact();
        cont.lastName ='Doddy';
        cont.accountid = acc.id;
        insert cont;
        
        Opportunity opp = new Opportunity();
        Pending_Recurring__c PR = new Pending_Recurring__c();
        Pending_Recurring__c PR2 = new Pending_Recurring__c();
        
        PR.name = 'TEst';
        PR.Status__c ='Draft';
        PR.Search_Link__c = CLink.Id;
        PR.AM_Email__c='david.wong@saasten.com';
        PR.Send_to_Sales_Date__c=date.today();
        PR.Submit_to_ORM_Date__c=date.today();
        PR.Send_to_Finance_Date__c=date.today();
        Test.startTest(); 
        Link__c L=[SELECT id from Link__c WHERE Name='02-09365'];
        Link__c LL=[SELECT id from Link__c WHERE Name='01-02679'];

        //PR.Search_LINK__C=L.id;
        PR.Search_Link__c=LL.id;
        insert PR;
        
        PR.Status__c ='Send To Sales';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Draft';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Send To Sales';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Submit To ORM';
        PR.Search_Link__c=LL.id;
        update PR;
               
        PR.Status__c ='Sent to Finance';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Submit To ORM';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Draft';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Submit To ORM';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Draft';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Sent to Finance';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Draft';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Sent to Finance';
        PR.Search_Link__c=LL.id;
        update PR;
        
        PR.Status__c ='Send To Sales';
        PR.Search_Link__c=LL.id;
        update PR;
                
        //PR.Status__c ='Draft';
        
        //update PR;

        //insert PR baru
              
        PR2.name = 'TEst';
        PR2.Status__c ='Draft';
        PR2.Search_Link__c = CLink.Id;
        PR2.AM_Email__c='david.wong@saasten.com';
        PR2.Send_to_Sales_Date__c=date.today();
        PR2.Submit_to_ORM_Date__c=date.today();
        PR2.Send_to_Finance_Date__c=date.today();

        //PR.Search_LINK__C=L.id;
        PR2.Search_Link__c=LL.id;
        insert PR2;
        
        PR2.Status__c ='Submit To ORM';
        PR2.Search_Link__c=LL.id;
        update PR2;
  
        Test.stopTest();
    } 
}