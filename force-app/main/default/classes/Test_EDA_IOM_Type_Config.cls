/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-08-2021
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-08-2021   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class Test_EDA_IOM_Type_Config {
    static testMethod void testMethod1(){
        insert New Transaction__c(TransactionID__c=1);
        
        account EDAacc = New account();
        EDAacc.Name = 'PT Hasjrat Multifinance';
        EDAacc.BP_Number__c = '749134';
        EDAacc.Organization_Type__c = 'Head Office';
        insert EDAacc;
        
        //List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
        //UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
        
        User usr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            UserRoleId  = [SELECT Id FROM UserRole WHERE NAME LIKE '%CEO Enterprise and SME%'].id,
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //UserRoleId = r.Id
        );
        
        system.debug('    user ===' + usr);
               
        
        EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
        EDAConfig.document_type__c = 'IOM';
        EDAConfig.IOM_Type__c = 'Waiving';
        EDAConfig.Recipient_1__c = 'test@gmail.com';
        EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
        EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
        EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
        EDAConfig.Recipient_5__c = '';
        edaConfig.Approver_1_Type__c = 'Specific User';
        EDAConfig.Approver_1__c = usr.id;
        insert EDAConfig;
        system.debug('EDAConfig ID : '+EDAConfig.id);
        system.debug('Approver_1__c' +edaconfig.Approver_1_Type__c);
        
        EDA__C EDA = New EDA__C();
        EDA.IOM_Type__c = 'Waiving';
        EDA.Name = 'Testing EDA Automation';
        EDA.Document_Type__c = 'IOM';
        EDA.EDA_Status__c = 'Draft';
        EDA.Related_Customer__c = EDAacc.id;
        EDA.Service_Group__c = 'GSM';
        EDA.Service__c = 'RBT';
        insert EDA;
        system.debug('EDA ID : '+EDA.id);
        
        
        //User EDAuser1 = New User();
        // EDAuser1.Name = 'Fitria Agus';
        // insert EDAuser1;
        
        List<ID> EDAids = new List<ID>();
        EDAids.add (EDA.id);
        
        Test.starttest();
        	EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
        Test.stopTest();
        
    }

    static testMethod void testMethod2(){
        insert New Transaction__c(TransactionID__c=1);
        account EDAacc = New account();
        EDAacc.Name = 'PT Hasjrat Multifinance';
        EDAacc.BP_Number__c = '749134';
        EDAacc.Organization_Type__c = 'Head Office';
        insert EDAacc;
        
        //List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
        //UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
        
        User usr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            UserRoleId  = [SELECT Id FROM UserRole WHERE NAME LIKE '%CEO Enterprise and SME%'].id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //UserRoleId = r.Id
        );
        
        EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
        EDAConfig.document_type__c = 'IOM';
        EDAConfig.IOM_Type__c = 'Waiving';
        EDAConfig.Recipient_1__c = 'test@gmail.com';
        EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
        EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
        EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
        EDAConfig.Recipient_5__c = '';
        edaconfig.Approver_1_Type__c ='Specific Role';
        edaconfig.Approval_Role_1__c = 'Group Head - Operations';
        insert EDAConfig;
        system.debug('EDAConfig ID : '+EDAConfig.id);
        
        EDA__C EDA = New EDA__C();
        EDA.IOM_Type__c = 'Waiving';
        EDA.Name = 'Testing EDA Automation';
        EDA.Document_Type__c = 'IOM';
        EDA.EDA_Status__c = 'Draft';
        EDA.Related_Customer__c = EDAacc.id;
        EDA.Service_Group__c = 'GSM';
        EDA.Service__c = 'RBT';
        insert EDA;
        system.debug('EDA ID : '+EDA.id);
        
        
        //User EDAuser1 = New User();
        // EDAuser1.Name = 'Fitria Agus';
        // insert EDAuser1;
        
        List<ID> EDAids = new List<ID>();
        EDAids.add (EDA.id);
        
        Test.starttest();
        	EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
        Test.stopTest();
        
        
        
    }

    static testMethod void testMethod3(){
        insert New Transaction__c(TransactionID__c=1);
        account EDAacc = New account();
        EDAacc.Name = 'PT Hasjrat Multifinance';
        EDAacc.BP_Number__c = '749134';
        EDAacc.Organization_Type__c = 'Head Office';
        insert EDAacc;
        
        //List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
        //UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
        
        User usr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //UserRoleId = r.Id
        );
        
        EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
        EDAConfig.document_type__c = 'IOM';
        EDAConfig.IOM_Type__c = 'Waiving';
        EDAConfig.Recipient_1__c = 'test@gmail.com';
        EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
        EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
        EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
        EDAConfig.Recipient_5__c = '';
        edaConfig.Approver_1_Type__c = 'Grade level';
        edaconfig.Approval_Grade_Level_1__c = 'Head (L3)';
        insert EDAConfig;
        system.debug('EDAConfig ID : '+EDAConfig.id);
        
        EDA__C EDA = New EDA__C();
        EDA.IOM_Type__c = 'Waiving';
        EDA.Name = 'Testing EDA Automation';
        EDA.Document_Type__c = 'IOM';
        EDA.EDA_Status__c = 'Draft';
        EDA.Related_Customer__c = EDAacc.id;
        EDA.Service_Group__c = 'GSM';
        EDA.Service__c = 'RBT';
        insert EDA;
        system.debug('EDA ID : '+EDA.id);
        
        
        //User EDAuser1 = New User();
        // EDAuser1.Name = 'Fitria Agus';
        // insert EDAuser1;
        List<ID> EDAids = new List<ID>();
        EDAids.add (EDA.id);
        
        Test.starttest();
        	EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
        Test.stopTest();
        
        
        
    }

          static testMethod void testMethod4(){
     insert New Transaction__c(TransactionID__c=1);
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_1_Type__c = 'Grade level';
        		edaconfig.Approval_Grade_Level_1__c = 'Group Head (L2)';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }

        static testMethod void testMethod5(){
     insert New Transaction__c(TransactionID__c=1);
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_1_Type__c = 'Grade level';
        		edaconfig.Approval_Grade_Level_1__c = 'CHIEF (L1)';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
  static testMethod void testMethod6(){
     insert New Transaction__c(TransactionID__c=1);
                
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_2_Type__c = 'Specific User';
        		edaconfig.Approver_2__c = usr.id;
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
static testMethod void testMethod7(){
     insert New Transaction__c(TransactionID__c=1);
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_2_Type__c = 'Specific Role';
        		edaconfig.Approval_Role_2__c = 'Group Head - Operations';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
 static testMethod void testMethod8(){
     insert New Transaction__c(TransactionID__c=1);
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_2_Type__c = 'Grade level';
        		edaconfig.Approval_Grade_Level_2__c = 'HEAD (L3)';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
 static testMethod void testMethod9(){
     insert New Transaction__c(TransactionID__c=1);
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_2_Type__c = 'Grade level';
        		edaconfig.Approval_Grade_Level_2__c = 'Group Head (L2)';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
     static testMethod void testMethod10(){
     insert New Transaction__c(TransactionID__c=1);
                
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_2_Type__c = 'Grade level';
        		edaconfig.Approval_Grade_Level_2__c = 'CHIEF (L1)';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
        EDAids.add (EDA.id);
        
        Test.starttest();
        	EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
        Test.stopTest();
            


        }
     static testMethod void testMethod11(){
     insert New Transaction__c(TransactionID__c=1);
                
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_3_Type__c = 'Specific User';
        		edaconfig.Approver_3__c = usr.id;
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
        EDAids.add (EDA.id);
        
        Test.starttest();
        	EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
        Test.stopTest();
            


        }
     static testMethod void testMethod12(){
     insert New Transaction__c(TransactionID__c=1);
                
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_3_Type__c = 'Specific Role';
        		edaconfig.Approval_Role_3__c = 'Head - Digital Sales';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
    static testMethod void testMethod13(){
     insert New Transaction__c(TransactionID__c=1);
                
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_3_Type__c = 'Grade Level';
        		edaconfig.Approval_Grade_Level_3__c = 'HEAD (L3)';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
      static testMethod void testMethod14(){
     insert New Transaction__c(TransactionID__c=1);
                
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_3_Type__c = 'Grade Level';
        		edaconfig.Approval_Grade_Level_3__c = 'Group Head (L2)';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

                
               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
      static testMethod void testMethod15(){
     insert New Transaction__c(TransactionID__c=1);
                
            	account EDAacc = New account();
                EDAacc.Name = 'PT Hasjrat Multifinance';
                EDAacc.BP_Number__c = '749134';
                EDAacc.Organization_Type__c = 'Head Office';
                insert EDAacc;
				
            	//List<User>  UserList = [SELECT id, Name FROM User where Name = 'Fitria Agus'];
            	//UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
				//insert r;
            	
            	User usr = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                 LastName = 'last',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                 CompanyName = 'TEST',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US'
                 //UserRoleId = r.Id
            	);
            	
            	EDA_IOM_Type_Configuration__c EDAConfig = new EDA_IOM_Type_Configuration__c();
                EDAConfig.document_type__c = 'IOM';
            	EDAConfig.IOM_Type__c = 'Waiving';
                EDAConfig.Recipient_1__c = 'test@gmail.com';
                EDAConfig.Recipient_2__c = 'kahfif@xl.co.id.xlfullsb';
                EDAConfig.Recipient_3__c = 'sigit@xl.co.id.xlfullsb';
                EDAConfig.Recipient_4__c = 'maria@xl.co.id.xlfullsb';
                EDAConfig.Recipient_5__c = '';
             	edaConfig.Approver_3_Type__c = 'Grade Level';
        		edaconfig.Approval_Grade_Level_3__c = 'CHIEF (L1)';
                insert EDAConfig;
            	system.debug('EDAConfig ID : '+EDAConfig.id);
            
                EDA__C EDA = New EDA__C();
                EDA.IOM_Type__c = 'Waiving';
                EDA.Name = 'Testing EDA Automation';
                EDA.Document_Type__c = 'IOM';
                EDA.EDA_Status__c = 'Draft';
                EDA.Related_Customer__c = EDAacc.id;
                EDA.Service_Group__c = 'GSM';
                EDA.Service__c = 'RBT';
                insert EDA;
				system.debug('EDA ID : '+EDA.id);
            
                
                //User EDAuser1 = New User();
               // EDAuser1.Name = 'Fitria Agus';
               // insert EDAuser1;

               List<ID> EDAids = new List<ID>();
               EDAids.add (EDA.id);
               
               Test.starttest();
                   EdaIOMTypeConfig.EdaIOMTypeConfig (EDAids );
               Test.stopTest();
            


        }
        }