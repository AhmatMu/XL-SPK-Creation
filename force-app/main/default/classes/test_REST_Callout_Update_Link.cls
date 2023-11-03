/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class test_REST_Callout_Update_Link {

    static testMethod void myUnitTest() {
        insert New Transaction__c(TransactionID__c=1);
        // TO DO: implement unit test
          // TO DO: implement unit test
         User Sales=[SELECT id FROM User WHERE Profile.Name='Sales' AND IsActive=true LIMIT 1];
        Account A=new Account();
        A.Name='Tes Akun XL';
        A.Ownerid=Sales.id;
        insert A;
        Link__c L=new Link__c();
        L.Link_ID__c='0535464';
        L.Service_Type__c='MPLS';
        L.Site_A_Name__c=A.id;
        insert L;
        
        L.Link_id__C='0535464';
        update L;
       REST_Callout_Update_Link.UpdateLink('0535464','AAA');
    }
}