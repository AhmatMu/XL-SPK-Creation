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
public class Test_Trigger_ChangePrice {
    static testMethod void test1 (){
    
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        
        Link__C Link = [select id, Site_A_Name__c, Site_A_Name__r.name from link__c where Site_A_Name__c <> null limit 1];
        
        
        test.starttest();
        Change_Price__c CP = new Change_Price__c();
        Change_Price_Link__c CPL = new Change_Price_Link__c ();
        List<Change_Price_Link__c> CPLs = new List<Change_Price_Link__c> ();
        
        List <link__c> linkList = new List <link__c> ();
        system.runas(U) {
            
            CP.Name ='Description';
            CP.Status__c = 'Draft';
            CP.Customer__c = A.ID; //Link.Site_A_Name__c; // A.ID;
            CP.Currency__c = 'IDR';
            CP.product__c= 'MPLS';
            insert CP; 
            
            //-- Contract Item
            Contract ctr = new Contract();
            ctr.accountid = A.id;
            ctr.ContractTerm =12;
            insert ctr;
            
            system.debug ('========== CHECK1 :' + ctr.ContractTerm);
            

            
            //----
            ApexPages.CurrentPage().getparameters().put('id', CP.id);
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(CPLS);
            ChangePriceLink_Controller stdSetController= new ChangePriceLink_Controller (SsC); 
            
            
            //-- insert 2 links -------------------------
            Link__c link3 = new Link__c();
            link3.name =  'L121212';
            link3.Service_Type__c = 'MPLS';
            link3.Site_A_Name__c = A.iD;
            link3.Contract_Item_Rel__c = ctr.id;
            //.Capacity_Bandwidth__c
            //.
            insert link3 ;
            system.debug ('========== link3 :' + link3);
            
            system.debug ('========== CHECK2 :' + link3.Contract_Item_Rel__r.ContractTerm);
            
            Link__c link4 = new Link__c();
            link4.name =  'L121212';
            link4.Service_Type__c = 'MPLS';
            link4.Site_A_Name__c = A.iD;            
            insert link4 ;
            //-------------------------------------------
            
            
            CPLs = new List<Change_Price_Link__c> ();
            //-- change price link ----------------------
            CPL = new Change_Price_Link__c ();
            CPL.Change_Price__c = CP.id;
            CPL.name= 'L121212';
            CPL.Bandwidth__c= '1';
            CPL.Site__c='site';
            CPL.Effective_Start_Date__c = system.today();
            CPL.link__c = link3.id;    
            
            
            system.debug ('========== CHECK :' + CPL.link__r.Contract_Item_Rel__r.ContractTerm);  
            CPLs.add(CPL); 
            
            
            insert CPLs;            
            system.debug ('========== CPLs :' + CPLs);
            //--------------------------------------------
            
            CP.status__c = 'Waiting for Contract';
            update CP;
            
            
            
        }    
        //-- test after update
        
        test.stoptest();
        
    }



}