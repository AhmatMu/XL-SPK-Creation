@isTest
public class TEST_Trigger_Link  {
     static testMethod void testMthod1() {
         Test.startTest();
         Link__c link = new Link__C();
         link.name = 'CIDNO009';
         link.link_id__c ='linkid90' ;
         
         insert link;
         
         
         Test.stopTest();
     
     
     }
     
     static testMethod void testMthod2() {
         
         Link__c link = new Link__C();
         link.name = 'CIDNO010';
         link.link_id__c ='linkid10' ;
         
         insert link;
         
         Test.startTest();
         link.id__c= 'd';
         update link;
         
         Test.stopTest();
     
     }
}