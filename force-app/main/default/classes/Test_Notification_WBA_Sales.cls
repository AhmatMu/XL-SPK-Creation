/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 02-04-2022
 * @last modified by  : Diky Nurosid
**/
@istest(seealldata=true)
private class Test_Notification_WBA_Sales {
    static testMethod void Test_Unit1() {
      
       Id RecordTypeOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Subscription One Site Newlink').getRecordTypeId();
        Account A=[SELECT id,ownerid from Account where Organization_Type__c='Head Office' AND BP_Number__c='706531' LIMIT 1];
       Pricebook2 PB=[SELECT id from PriceBook2 WHERE Name='MPLS'];
        test.starttest();
       User U=[SELECT id FROM User WHERE ID=:A.ownerid];
        Opportunity O=new Opportunity();
        String OpportunityID='';
        system.runas(U){
          
          O.Accountid=A.id;
          O.Account_Site_A__c=A.id;
          O.RecordTypeid=RecordTypeOppId;
          O.StageName='Prospecting';
          O.Name='Tes';
          O.CloseDate=system.today().adddays(10);
          O.Pricebook2id=PB.id;
          O.Periode_UOM__c='Month';
          O.Contract_Periode__c=12;
          O.Service_type__c='newlink';
          O.BP_payer__C = A.id;
          O.BP_vat__C = A.id;
          O.OwnerID=U.id;  
          O.project_Coordinator__c='90006544 Nancy Citraningrum';        
          insert O;
        }
        String JSONTes=json.serialize(O);
        Notification_WBA_Sales.Sendemail(JSONTes,JSONTes);
}
}