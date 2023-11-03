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
 
@isTest (seealldata = true)
public class Test_ChangePrice_Controller {
    static testMethod void test1 (){
    
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];  //0057F000000mCFvQAM
        
        List <link__c> links = [SELECT id, name, Site_A_Name__r.name, Site_A_Name__r.Organization_Type__c from link__c 
        							where Site_A_Name__r.Organization_Type__c ='HEad Office' and Site_A_Name__r.Ownerid=:u.id  limit 10];
        string accountID = links[1].Site_A_Name__r.id;
        //Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        Account A=[SELECT id from Account where id =:accountID];
        
        Link__C Link = [select id, Site_A_Name__c, Site_A_Name__r.name from link__c where Site_A_Name__c <> null limit 1];
        
        
        test.starttest();
        Change_Price__c CP = new Change_Price__c();
        
        system.runas(U) {
            
            CP.Name ='Description';
            CP.Status__c = 'Draft';
            CP.Customer__c =  A.ID; //Link.Site_A_Name__c; // A.ID;
            CP.Currency__c = 'IDR';
            
            insert CP; 
        }
            
            //-- 
            //ApexPages.StandardController sc = ApexPages.StandardController (CP);
            //ChangePrice_Controller CPController = new ChangePrice_Controller (sc); 
            
            ApexPages.StandardController sc = new ApexPages.StandardController(CP);
            ChangePrice_Controller CPController = new ChangePrice_Controller (SC); 
            
            
            CPController.getProductlist();
            CPController.selectListValue = 'MPLS';
            CPController.setProduct();
            
        
             
        
        //-- test after update
        
        test.stoptest();
        
    }

/*
    static testMethod void test2 (){
    
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];  //0057F000000mCFvQAM
        
        List <link__c> links = [SELECT id, name, Site_A_Name__r.name, Site_A_Name__r.Organization_Type__c from link__c 
        							where Site_A_Name__r.Organization_Type__c ='Branch' and Site_A_Name__r.Ownerid=:u.id  limit 10];
        string accountID = links[1].Site_A_Name__r.id;
        //Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Brac' LIMIT 1];
        Account A=[SELECT id from Account where id =:accountID];
        
        Link__C Link = [select id, Site_A_Name__c, Site_A_Name__r.name from link__c where Site_A_Name__c <> null limit 1];
        
        
        test.starttest();
        Change_Price__c CP = new Change_Price__c();
        
        system.runas(U) {
            
            CP.Name ='Description';
            CP.Status__c = 'Draft';
            CP.Customer__c =  A.ID; //Link.Site_A_Name__c; // A.ID;
            CP.Currency__c = 'IDR';
            
            insert CP; 
        }
            
            //-- 
            //ApexPages.StandardController sc = ApexPages.StandardController (CP);
            //ChangePrice_Controller CPController = new ChangePrice_Controller (sc); 
            
            ApexPages.StandardController sc = new ApexPages.StandardController(CP);
            ChangePrice_Controller CPController = new ChangePrice_Controller (SC); 
            
            
            CPController.getProductlist();
            CPController.selectListValue = 'MPLS';
            CPController.setProduct();
            
        
             
        
        //-- test after update
        
        test.stoptest();
        
    }
*/

}