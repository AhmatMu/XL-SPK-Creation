@isTest(seealldata=true)
public class TestTriggerPresurvey {
    
   @isTest(seealldata=true)static void TestInsertPresurveyWithAccount(){
       
       user u=[SELECT id from user WHERE Name='Yopi Apriyana' LIMIT 1];
       Account A =[SELECT id,Name from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
       AM_Portfolio_Mapping__c solmapp = [SELECT id,Portfolio_Management_Support__c,AM__c,Status__c from AM_Portfolio_Mapping__c where AM__c=:u.id AND  Status__c = 'Active' LIMIT 1];
       
       System.RunAs(u){
           Test.startTest();
           Presurvey__c  presurvey = new Presurvey__c();
           presurvey.Account__c = A.id;
           presurvey.Customer_Name__c = 'presurvey02';
           presurvey.Service_Group__c = 'NON GSM';
           presurvey.Service__c = 'MPLS';
           presurvey.Province_Site_A__c = 'Sumatera Utara';
           presurvey.Location_Site_A__c = 'jl. Malabar No 235';          
           
           insert presurvey;
           //validate single insert
           Presurvey__c ps = [SELECT id,Account__c,Customer_Name__c, Solution_PIC__c FROM Presurvey__c WHERE CreatedDate = TODAY and CreatedById =:u.id and Account__c != null LIMIT 1];
           
           System.assertEquals(A.Name, ps.Customer_Name__c);
           System.assertEquals(solmapp.Portfolio_Management_Support__c, ps.Solution_PIC__c);          
           
           Test.stopTest();
           /*
           presurvey.Account__c = null;
           presurvey.Customer_Name__c = 'presurvey02';
           
           Test.startTest();
           update presurvey;
           Test.stopTest();*/
       }       
    }
    
    @isTest(seealldata=true)static void TestInsertPresurveyWithoutAccount(){
       
       user u=[SELECT id from user WHERE Name='Yopi Apriyana' LIMIT 1];
       //Account A =[SELECT id,Name from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' and Name ='PT Bank Permata Tbk' LIMIT 1];
       AM_Portfolio_Mapping__c solmapp = [SELECT id,Portfolio_Management_Support__c,AM__c,Status__c from AM_Portfolio_Mapping__c where AM__c=:u.id AND  Status__c = 'Active' LIMIT 1];
       String Aname = 'presurvey02';
        
       System.RunAs(u){
           Test.startTest();
           Presurvey__c  presurvey = new Presurvey__c();
           //presurvey.Account__c = A.id;
           presurvey.Customer_Name__c = Aname;
           presurvey.Service_Group__c = 'NON GSM';
           presurvey.Service__c = 'MPLS';
           presurvey.Province_Site_A__c = 'Sumatera Utara';
           presurvey.Location_Site_A__c = 'jl. Malabar No 235';          
           
           insert presurvey;
           //validate single insert
           Presurvey__c ps = [SELECT id,Customer_Name__c, Solution_PIC__c FROM Presurvey__c WHERE CreatedDate = TODAY and CreatedById =:u.id and Account__c = null LIMIT 1];
           
           System.assertEquals(Aname, ps.Customer_Name__c);
           System.assertEquals(solmapp.Portfolio_Management_Support__c, ps.Solution_PIC__c);          
           
           Test.stopTest();
           /*
           presurvey.Account__c = null;
           presurvey.Customer_Name__c = 'presurvey02';
           
           Test.startTest();
           update presurvey;
           Test.stopTest();*/
       }       
    } 
    
}