/**
 * @description       : 
 * @author            : Andre Prasetya
 * @group             : 
 * @last modified on  : 03-10-2022
 * @last modified by  : Andre Prasetya
**/
@isTest
public  class Test_REST_MarketPlaceOrder_Callout_v2 {

    @isTest
    static void testApexCallout() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(LastName='someone2', email='someone2@mail.com', Username='someone2@mail.com', 
                            Alias='smo', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', 
                            EmailEncodingKey='UTF-8', ProfileId=p.Id, LanguageLocaleKey='en_US');
        insert u;

        Account acc= new Account(Name ='Test',BP_Number__c = '123456', Organization_Type__c='Head Office', OwnerId=u.Id);
        insert acc;
        
        Contact con = new Contact(AccountId=acc.Id, LastName='lastname test', Email='test@mail.com');
        insert con;
        
        Id pbStandardId = Test.getStandardPricebookId();
        
        Pricebook2 pb = new Pricebook2(Name='Marketplace', IsActive = true);
        insert pb;
        
        Opportunity oppty = new Opportunity(AccountId=acc.Id, 
                                            Name='test order', 
                                            StageName='Prospecting',
                                            Type='marketplace',
                                            Service_type__c='Licensed', 
                                            Call_Id__c='1122334455', 
                                            Service__c='createorder',
                                            Order_Id__c='ord-2233445566',
                                            CloseDate=date.newInstance(2020, 4, 26),
                                            BP_Number__c='77889900',
                                            Pricebook2Id=pb.Id,
                                            recordtypeid=system.label.RT_Marketplace,
                                            OwnerId=acc.OwnerId,
                                            Provisioning_Type__c = 'Manual'
                            );
        insert oppty; 

        oppty.StageName = 'Waiting for BA';
        update oppty;

        Test.startTest(); 
        REST_MarketPlaceOrder_Callout_v2.apexCallout(oppty.id);
        Test.stopTest();

    }
}