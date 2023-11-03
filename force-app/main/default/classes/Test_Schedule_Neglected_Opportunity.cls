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
@isTest (SeeAllData=true)
private class Test_Schedule_Neglected_Opportunity {

    static testMethod void myUnitTest() {
        list<User> U=[SELECT id,Email FROM User WHERE Name='Saasten Dev'];
        // TO DO: implement unit test

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
        insert Opp;
        
         Opp.waiting_for_BA_Date__c=system.today().adddays(-7);
         update Opp;
         
         List<EmailTemplate> lstEmailTemplates = [SELECT Id from EmailTemplate where DeveloperName = 'Neglected_Opportunity'];
         
        
        schedule_neglected_opportunity no=new schedule_neglected_opportunity();
		no.execute(null);
        
        
    }
}