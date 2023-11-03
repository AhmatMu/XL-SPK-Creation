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
public class Test_ChangePriceLink_Controller { 
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
            
            //-- insert 2 links -------------------------
            Link__c link1 = new Link__c();
            link1.name =  'XL121212';
            link1.Service_Type__c = 'MPLS';
            link1.Site_A_Name__c = A.iD;
            //.Capacity_Bandwidth__c
            //.
            linkList.add(link1 );
            //insert link1 ;
            
            Link__c link2 = new Link__c();
            link2.name =  'XL121212';
            link2.Service_Type__c = 'MPLS';
            link2.Site_A_Name__c = A.iD;            
            linkList.add(link2 );
            //insert link2 ;
            
            
            insert linkList;
            system.debug ('========== linkList:' + linkList);
            //-------------------------------------------
            
            
            //----
            ApexPages.CurrentPage().getparameters().put('id', CP.id);
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(CPLS);
            ChangePriceLink_Controller stdSetController= new ChangePriceLink_Controller (SsC); 
            
            
            //-- insert 2 links -------------------------
            Link__c link3 = new Link__c();
            link3.name =  'L121212';
            link3.Service_Type__c = 'MPLS';
            link3.Site_A_Name__c = A.iD;
            //.Capacity_Bandwidth__c
            //.
            insert link3 ;
            
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
            CPL.link__c = link3.id;            
            CPLs.add(CPL); 
            
            CPL = new Change_Price_Link__c ();
            CPL.Change_Price__c = CP.id;
            CPL.name= 'L23232323';
            CPL.Bandwidth__c= '1';
            CPL.Site__c='site';
            CPL.link__c = link4.id;
            CPLs.add(CPL);
            
            insert CPLs;            
            system.debug ('========== CPLs :' + CPLs);
            //--------------------------------------------
            
            
            //-- START #2
            system.debug ('========== lihat CP.id :' + CP.id);
            ApexPages.CurrentPage().getparameters().put('id', CP.id);
            
            //ApexPages.StandardController sc = new ApexPages.StandardController(CPL);
            //ChangePriceLink_Controller CPLController = new ChangePriceLink_Controller (SC); 

            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(CPLS);
            ChangePriceLink_Controller CPLController = new ChangePriceLink_Controller (SC); 
                        
            CPLController.requestToUpload();
           
            string datalinks = 'Link ID,Effective Start Date (yyyy-mm-dd),To Be AutoRenewal (true/false)\n L121212,2019-09-09,true' ;
            system.debug ('========== datalinks :' + datalinks);
            system.debug ('========== datalinks2 :' + Blob.valueOf(datalinks));
            //CPLController.csvFileBody   = Blob.valueOf('Link ID,Effective Start Date (yyyy-mm-dd),To Be AutoRenewal (true/false)\n L121212,2019-09-09,true' ) ;
            
            Blob csvFileBody;
            csvFileBody = Blob.valueOf(datalinks);
            CPLController.csvFileBody = csvFileBody;
			CPLController.doImportCSV();
           
                     
            CPLController.CancelUpload();
            CPLController.doDownloadTemplate();
            CPLController.doExportToCsv();


            CPLController.updateItemString();
            CPLController.getData();
            

            //-- thick pilih
            stdSetController.wraplinksList[0].selected=true;  
            stdSetController.wraplinksList[0].effectiveStartDate ='2019-09-09';
            stdSetController.wraplinksList[0].tobeAutoRenewal =true;
            stdSetController.selectTheLinks();    
                      

            
        }    
        //-- test after update
        
        test.stoptest();
        
    }



}