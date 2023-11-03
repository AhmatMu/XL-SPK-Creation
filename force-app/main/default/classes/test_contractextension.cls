/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 08-30-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   08-30-2022   -                       Initial Version
**/

@isTest(seealldata=true)
private class test_contractextension {

    static testMethod void test_trigger_contractextension() {
        // TO DO: implement unit test
         Opportunity O=[SELECT ID,Account.Ownerid,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c,Link_Related__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>3000000 ORDER BY CREATEDDATE DESC LIMIT 1];

        Circuit__c  Circuit_Test = new Circuit__c(
            Name = '02-02021',
            datacode__c = 'circuitimport_201801'
        );
        insert Circuit_Test;

        Link__c linkTest = new Link__c(
            Name = '02-02021',                                  
            BU__c = 'ENTERPRISE',
            CID__c = '02-02021',                          
            ID__c = '3281',                       
            Status_Link__c = 'IN_SERVICE',
            Company_Name__c = 'Bank Maybank Indonesia Tbk',
            Service_Type__c = 'MPLS',
            Contract_Item__c = '3001207-351',
            BP_Site_A__c = '707310', 
            Capacity_Bandwidth__c = '512',
            UoM__c = 'Kbps',
            Routepath__c = '707310 BII KCP Pondok Candra Surabaya - POP BWA Rungkut (STARCOM) POP BWA Rungkut (STARCOM) - EC-SBRKO-01 EC-SBRKO-01',
            //CID_RelD__c = Circuit_Test.Id,
            Link_ID__c = '007C362L84',
            //Site_A_Name__c = accTest2.Id,
            //Contract_Item_Rel__c = contract_1.Id,
            Free_Link__c = false,
            Selected__c = false,
            Partner__c = false                                                                    
        );
        insert linkTest;
        
        O.Link_Related__c = linkTest.Id;
        Update O;

                Profile pf= [Select Id from profile where Name='Solution' OR Name='Solution']; 
                
                String orgId=UserInfo.getOrganizationId(); 
                String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
                Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
                String uniqueName=orgId+dateString+RandomId;
        
                User user_1=new User(firstname = 'Contract', 
                                lastName = 'Manager', 
                                email = uniqueName + '@test1' + orgId + '.org', 
                                Username = uniqueName + '@test1' + orgId + '.org', 
                                EmailEncodingKey = 'ISO-8859-1', 
                                Alias = uniqueName.substring(18, 23), 
                                TimeZoneSidKey = 'America/Los_Angeles', 
                                LocaleSidKey = 'en_US', 
                                LanguageLocaleKey = 'en_US', 
                                ProfileId = pf.Id,
                                isactive = TRUE
                                ); 
                insert user_1;

                User user_2=new User(firstname = 'Sales', 
                         lastName = 'Admin', 
                         email = uniqueName + '@tes2' + orgId + '.org', 
                         Username = uniqueName + '@test2' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id,
                         isactive = TRUE,
                         ManagerId = user_1.id
                        ); 
                insert user_2;

            Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            //tmpContract.name = 'TEST test';
            tmpContract.Account__c = O.AccountID;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = O.id;
        
            insert tmpContract;
             Contact CON=new COntact();
            Con.LastName='Tes Con';
            Con.Title='Bos';
            Con.Email='Tes@SF.com';
            Con.AccountID=O.Accountid;
            insert Con;
            
            AccountContactRelation AC3=[SELECT id,roles FROM AccountContactRelation WHERE AccountID=:O.Accountid AND ContactID=:Con.id];
            AC3.Roles='BA Print;BA Recipient';
            update AC3;
            
                Contract ci = new Contract();
            ci.name ='CI TEST';
            ci.Contract_Ticket__c = tmpContract.id;
            ci.Accountid=O.Accountid;
            ci.Opportunity__c=O.id;
            ci.Contract_Ticket__c=tmpContract.id;
            //--tutup dulu ci.BP_Payer__c='';
            //--tutup dulu ci.BP_VAT__c='';
            ci.Billing_Type__c=''; 
            ci.End_Date__c=system.today().addmonths(3);                   
            ci.start_Date__c=system.today().addmonths(3); 
            ci.Bill_Plan_End_Date__c=system.today().addyears(1);   
        	
            insert ci;
            
            Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
            CTI.Contract_Item__c=ci.id;
            CTI.Contract_Ticket__c=TmpContract.id;
            insert CTI;
            
            Contract_Extension__c CE=new Contract_Extension__c();
            CE.Account__c=O.AccountID;
            CE.Account_Manager__c=O.Account.Ownerid;
            CE.Existing_Contract_Item__c=CI.id;
            CE.Extension_Start_Date__c=system.today().addmonths(-1);
             CE.Extension_end_Date__c=system.today().addmonths(10);
             CE.Link__c=O.Link_Related__c;
             CE.Status__c='Fill BA Recipient and BA Print';
             CE.Link_Partner__c=false;
             CE.Solution_PIC__c = user_1.Id;
             CE.Account_Manager__c = user_2.Id;
             insert CE;

            CE.BA_Print__c=Con.id;
            CE.Approved_By_Solution__c=true;
            //----------------------
        	test.startTest();
        	CE.Status__c='Submit';
            update CE;
        	
        	CE.Status__c='Fill BA Recipient and BA Print';
            update CE;
        	
        	/*CE.Status__c='Waiting for BA';
        	update CE;
        	*/
        	
        	CE.Status__c='Change Price';
        	CE.Extension_Monthly_Price__c = 400000;
        	update CE;
        	
        	CE.Status__c='Waiting for Contract';
        	update CE;
        	        
        	CE.Status__c='Completed';
            CE.Complete_Status__c = 'Done';
        	
        	update CE;
        	test.stopTest();
        	
        
        	
            }
    
    static testMethod void test_trigger_contractextension_complete() {
        // TO DO: implement unit test
        // Opportunity O=[SELECT ID,Account.Ownerid,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c,Link_Related__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>3000000 ORDER BY CREATEDDATE DESC LIMIT 1];
		
        Account A=New Account();
        A.Name='tes';
        A.BillingStreet='Jl. S Parman';
        A.BillingCity='Jakarta';
        A.BillingPostalCode='14460';
        A.BillingState='DKI Jakarta';
        A.Type='Competitor';
        //A.Account_Type__c ='BP'
        A.Organization_type__c='Head Office';
        insert A;
        
        
        RecordType recTypeOppty = [Select id, Name From RecordType Where sObjectType = 'Opportunity' and Name = 'GSM'];
        
        
        Opportunity MyOppty = New Opportunity();
        MyOppty.Name = 'Test GSM Activation';
        MyOppty.Project_Group__c = 'Test Activation';
        MyOppty.CloseDate = system.today();
        //MyOppty.AccountId = lstAcc[0].id;
        MyOppty.AccountId = A.id;
        MyOppty.StageName = 'Prospecting';
        MyOppty.Amount = 2250000;
        MyOppty.RecordTypeId = recTypeOppty.id;
        insert MyOppty;
        
        Circuit__c  Circuit_Test = new Circuit__c(
            Name = '02-02021',
            datacode__c = 'circuitimport_201801'
        );
        insert Circuit_Test;

        Link__c linkTest = new Link__c(
            Name = '02-02021',                                  
            BU__c = 'ENTERPRISE',
            CID__c = '02-02021',                          
            ID__c = '3281',                       
            Status_Link__c = 'IN_SERVICE',
            Company_Name__c = 'Bank Maybank Indonesia Tbk',
            Service_Type__c = 'MPLS',
            Contract_Item__c = '3001207-351',
            BP_Site_A__c = '707310', 
            Capacity_Bandwidth__c = '512',
            UoM__c = 'Kbps',
            Routepath__c = '707310 BII KCP Pondok Candra Surabaya - POP BWA Rungkut (STARCOM) POP BWA Rungkut (STARCOM) - EC-SBRKO-01 EC-SBRKO-01',
            //CID_RelD__c = Circuit_Test.Id,
            Link_ID__c = '007C362L84',
            //Site_A_Name__c = accTest2.Id,
            //Contract_Item_Rel__c = contract_1.Id,
            Free_Link__c = false,
            Selected__c = false,
            Partner__c = false                                                                    
        );
        insert linkTest;
        
        MyOppty.Link_Related__c = linkTest.Id;
        Update MyOppty;

                Profile pf= [Select Id from profile where Name='Solution' OR Name='Solution']; 
                
                String orgId=UserInfo.getOrganizationId(); 
                String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
                Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
                String uniqueName=orgId+dateString+RandomId;
        
                User user_1=new User(firstname = 'Contract', 
                                lastName = 'Manager', 
                                email = uniqueName + '@test1' + orgId + '.org', 
                                Username = uniqueName + '@test1' + orgId + '.org', 
                                EmailEncodingKey = 'ISO-8859-1', 
                                Alias = uniqueName.substring(18, 23), 
                                TimeZoneSidKey = 'America/Los_Angeles', 
                                LocaleSidKey = 'en_US', 
                                LanguageLocaleKey = 'en_US', 
                                ProfileId = pf.Id,
                                isactive = TRUE
                                ); 
                insert user_1;

                User user_2=new User(firstname = 'Sales', 
                         lastName = 'Admin', 
                         email = uniqueName + '@tes2' + orgId + '.org', 
                         Username = uniqueName + '@test2' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id,
                         isactive = TRUE,
                         ManagerId = user_1.id
                        ); 
                insert user_2;

            Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            //tmpContract.name = 'TEST test';
            tmpContract.Account__c = MyOppty.AccountID;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = MyOppty.id;
        
            insert tmpContract;
             Contact CON=new COntact();
            Con.LastName='Tes Con';
            Con.Title='Bos';
            Con.Email='Tes@SF.com';
            Con.AccountID=MyOppty.Accountid;
            insert Con;
            
            //AccountContactRelation AC3=[SELECT id,roles FROM AccountContactRelation WHERE AccountID=:O.Accountid AND ContactID=:Con.id];
            //AC3.Roles='BA Print;BA Recipient';
            //update AC3;
            
                Contract ci = new Contract();
            ci.name ='CI TEST';
            ci.Contract_Ticket__c = tmpContract.id;
            ci.Accountid=MyOppty.Accountid;
            ci.Opportunity__c=MyOppty.id;
            ci.Contract_Ticket__c=tmpContract.id;
            //--tutup dulu ci.BP_Payer__c='';
            //--tutup dulu ci.BP_VAT__c='';
            ci.Billing_Type__c=''; 
            ci.End_Date__c=system.today().addmonths(3);                   
            ci.start_Date__c=system.today().addmonths(3); 
            ci.Bill_Plan_End_Date__c=system.today().addyears(1);                 
            insert ci;
            
            Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
            CTI.Contract_Item__c=ci.id;
            CTI.Contract_Ticket__c=TmpContract.id;
            insert CTI;
            
            Contract_Extension__c CE=new Contract_Extension__c();
            CE.Account__c=MyOppty.AccountID;
            CE.Account_Manager__c=MyOppty.Account.Ownerid;
            CE.Existing_Contract_Item__c=CI.id;
            CE.Extension_Start_Date__c=system.today().addmonths(-1);
             CE.Extension_end_Date__c=system.today().addmonths(10);
             CE.Link__c=MyOppty.Link_Related__c;
            // CE.Status__c='Fill BA Recipient and BA Print';
             CE.Link_Partner__c=false;
             CE.Solution_PIC__c = user_1.Id;
             CE.Account_Manager__c = user_2.Id;
             
        	insert CE;
			/*
        	Test.starttest();
        	CE.Status__c='Completed';
        	CE.Complete_Status__c='Done';
        	CE.Remark__c = 'test';
        	
            update CE;
        	Test.stoptest();
        	*/
        	Test.starttest();
        	CE.Status__c='Completed';
        	CE.Complete_Status__c='Canceled';
        	CE.Remark__c = 'test';
        	CE.Approved_By_Solution__c=false;
            update CE;
        	Test.stoptest();
        	
			    }
    
    
     static testMethod void test_visualforce_contractextensionutil()
     {  
        Profile pf= [Select Id from profile where Name='System Administrator' OR Name='Systemadministrator']; 
        Profile pf_solution= [Select Id from profile where Name='Solution']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId;

        User user_1=new User(firstname = 'Contract', 
                         lastName = 'Manager', 
                         email = uniqueName + '@test1' + orgId + '.org', 
                         Username = uniqueName + '@test1' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id,
                         isactive = TRUE
                        ); 
        insert user_1;
        
        User user_2=new User(firstname = 'Sales', 
                         lastName = 'Admin', 
                         email = uniqueName + '@tes2' + orgId + '.org', 
                         Username = uniqueName + '@test2' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id,
                         isactive = TRUE,
                         ManagerId = user_1.id
                        ); 
        insert user_2;

        User user_3=new User(firstname = 'ABC3', 
                         lastName = 'XYZ3', 
                         email = uniqueName + '@test3' + orgId + '.org', 
                         Username = uniqueName + '@test3' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf_solution.Id,
                         isactive = TRUE,
                         ManagerId = user_2.id
                        ); 
        insert user_3;

        User user_4=new User(firstname = 'ABC3', 
                         lastName = 'XYZ3', 
                         email = uniqueName + '@test4' + orgId + '.org', 
                         Username = uniqueName + '@test4' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id,
                         isactive = TRUE,
                         ManagerId = user_2.id
                        ); 
        insert user_4;
        
     	 Opportunity O=[SELECT ID,Account.Ownerid,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c,Link_Related__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>0 ORDER BY CREATEDDATE DESC LIMIT 1];
            Contract_Ticket__c tmpContract = new Contract_Ticket__c ();
            //tmpContract.name = 'TEST test';
            tmpContract.Account__c = O.AccountID;
            tmpContract.Currency__c = 'IDR';
            tmpContract.TicketStatus__c = 'Review By Contract Manager';
            tmpContract.Opportunity__c = O.id;
        
            insert tmpContract;
                    Contract ci = new Contract();
            ci.name ='CI TEST';
            ci.Contract_Ticket__c = tmpContract.id;
            ci.Accountid=O.Accountid;
            ci.Opportunity__c=O.id;
            ci.Contract_Ticket__c=tmpContract.id;
            //--tutup dulu ci.BP_Payer__c='';
            //--tutup dulu ci.BP_VAT__c='';
            ci.Billing_Type__c=''; 
            ci.End_Date__c=system.today().addmonths(3);                   
            ci.start_Date__c=system.today().addmonths(3); 
            ci.Bill_Plan_End_Date__c=system.today().addyears(1);                 
            insert ci;
            
            Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
            CTI.Contract_Item__c=ci.id;
            CTI.Contract_Ticket__c=TmpContract.id;
            insert CTI;
            
            Contract_Extension__c CE=new Contract_Extension__c();
            CE.Account__c=O.AccountID;
            CE.Account_Manager__c=O.Account.Ownerid;
            CE.Existing_Contract_Item__c=CI.id;
            CE.Extension_Start_Date__c=system.today().addmonths(-1);
             CE.Extension_end_Date__c=system.today().addmonths(10);
             CE.Link__c=O.Link_Related__c;
             CE.Status__c='Fill BA Recipient and BA Print';
             CE.Link_Partner__c=false;
             CE.Solution_PIC__c = user_3.Id;
             insert CE;
             PageReference pageref=page.contractextensionba;
             pageref.getparameters().put('contractextensionid',CE.id);
             Apexpages.StandardController sc = new Apexpages.StandardController(CE);
             ContractExtensionUtils CEU=new ContractExtensionUtils(sc);
     }        
            
            /*static testMethod void test_scheduler() 
            {
            	Schedule_Notification_Contract_Extension schecontract=new Schedule_Notification_Contract_Extension();
schecontract.execute(null);
            }*/
     
}