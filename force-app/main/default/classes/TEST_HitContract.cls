@isTest(seeAllData=true)
private class TEST_HitContract{
   
    
        private string cntID='';
        
        static testMethod void doScenario1Test() {
                // TO DO: implement unit test  

                Opportunity O=[SELECT ID,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>0 ORDER BY CREATEDDATE DESC LIMIT 1];
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
            	ci.Bandwidth_UoM_filled__c = 'Mbps';
                insert ci;

                Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
                CTI.Contract_Item__c=ci.id;
                CTI.Contract_Ticket__c=TmpContract.id;
                insert CTI;

                CTI.isinvoiced__c=true;
                CTI.Last_Invoice_Date__c=system.today();
                update CTI;

                Test.setMock(WebServiceMock.class, new ContractWebServiceMock());
                test.starttest();






                tmpContract.ticketstatus__c='Pending';
                tmpContract.Pending_Reason__c='Gagal Bayar';
                update tmpContract;
                tmpContract.ticketstatus__c='Review By Finance';
                update tmpContract;
                // to Complete
                tmpContract.TicketStatus__c= 'Complete';
                update tmpContract;
                //       HitsapComDocumentSapSoap.HitContract(tmpContract.id);
                //HitsapComDocumentSapSoap.HitContractUpdate(o.id, tmpContract.id);
                HitSAPSOAP_Contract.HitContractByHeader(String.valueof(tmpContract.id),'2492','1');

                string ContractTicketItemNo = String.valueof(CTI.id);
                HitSAPSOAP_Contract.HitContractByContractTicketItem(String.valueof(tmpContract.id), ContractTicketItemNo,'1');
            	//HitSAPSOAP_Contract.HitContractByContractTicketItem('a0S1m000001w3aHEAQ', 'a0T1m000002TrmVEAS', '08e1m000007l4D6');

                test.stoptest();
                
        
        }
        static testMethod void HitContractSuccess() {
                Opportunity O=[SELECT ID,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>0 ORDER BY CREATEDDATE DESC LIMIT 1];
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
            	ci.Bandwidth_UoM_filled__c = 'Mbps';
                insert ci;


                Test.setMock(WebServiceMock.class, new ContractWebServiceMock());
                test.starttest();
                HitSAPSOAP_Contract.HitContractByHeader(String.valueof(tmpContract.id),'2492','1');        
                //     HitsapComDocumentSapSoap.HitContract(tmpContract.id);

                Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
                CTI.Contract_Item__c=ci.id;
                CTI.Contract_Ticket__c=TmpContract.id;
                insert CTI;

                string ContractTicketItemNo = String.valueof(CTI.id);
                HitSAPSOAP_Contract.HitContractByContractTicketItem(String.valueof(tmpContract.id), ContractTicketItemNo,'1');

                test.stoptest();
        }

        static testMethod void TriggerContract() {
                Opportunity O=[SELECT ID,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>0 ORDER BY CREATEDDATE DESC LIMIT 1];
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
                Product2 P=[SELECT id from Product2 WHERE   Revenue_Type__c='Recurring' LIMIT 1];
                ci.Product__c=P.id;
                ci.Billing_Type__c=''; 
                ci.End_Date__c=system.today().addmonths(3);                   
                ci.start_Date__c=system.today().addmonths(3); 
                ci.Bill_Plan_End_Date__c=system.today().addyears(1);
            	ci.Bandwidth_UoM_filled__c = 'Mbps';
                insert ci;

                Link__c L=[SELECT id FROM Link__c WHERE Name<>null LIMIT 1];
                ci.Link__C=L.id;
                ci.SAP_ID__c='4';
                update ci;



                Test.setMock(WebServiceMock.class, new ContractWebServiceMock());
                test.starttest();
                HitSAPSOAP_Contract.HitContractByHeader(String.valueof(tmpContract.id),'2492','1');
                //   HitsapComDocumentSapSoap.HitContract(tmpContract.id);

                Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
                CTI.Contract_Item__c=ci.id;
                CTI.Contract_Ticket__c=TmpContract.id;
                insert CTI;

                string ContractTicketItemNo = String.valueof(CTI.id);
                HitSAPSOAP_Contract.HitContractByContractTicketItem(String.valueof(tmpContract.id), ContractTicketItemNo,'1');

                test.stoptest();
        }
        static testMethod void FailTestHit() {
                Opportunity O=[SELECT ID,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>0 ORDER BY CREATEDDATE DESC LIMIT 1];
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
            	ci.Bandwidth_UoM_filled__c = 'Mbps';
                insert ci;




                Test.setMock(WebServiceMock.class, new ContractWebServiceMock2());
                test.starttest();
                HitSAPSOAP_Contract.HitContractByHeader(String.valueof(tmpContract.id),'2492','1');
                //  HitsapComDocumentSapSoap.HitContract(tmpContract.id);

                Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c();
                CTI.Contract_Item__c=ci.id;
                CTI.Contract_Ticket__c=TmpContract.id;
                insert CTI;

                string ContractTicketItemNo = String.valueof(CTI.id);
                HitSAPSOAP_Contract.HitContractByContractTicketItem(String.valueof(tmpContract.id), ContractTicketItemNo,'1');

                test.stoptest();
        }
        static testMethod void TesthitContractHeader() {
                Opportunity O=[SELECT ID,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>0 ORDER BY CREATEDDATE DESC LIMIT 1];
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
                ci.Contract_ID__c='2492';
                ci.End_Date__c=system.today().addmonths(3);                   
                ci.start_Date__c=system.today().addmonths(3); 
                ci.Bill_Plan_End_Date__c=system.today().addyears(1); 
            	ci.Bandwidth_UoM_filled__c = 'Mbps';
                insert ci;

                Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c(Contract_Ticket__c=tmpContract.id);
                CTI.Contract_Item__c=ci.id;
                insert CTI;



                Test.setMock(WebServiceMock.class, new ContractWebServiceMock());
                test.starttest();
                HitSAPSOAP_Contract.HitContractByHeader(String.valueof(tmpContract.id),'2492','1');
                HitSAPSOAP_Contract.HitContractByHeader(String.valueof(tmpContract.id),'2493','1');

                string ContractTicketItemNo = String.valueof(CTI.id);
                HitSAPSOAP_Contract.HitContractByContractTicketItem(String.valueof(tmpContract.id), ContractTicketItemNo,'1');

                test.stoptest();
                        
                                
        }
        static testMethod void TesthitContractHeaderfailed() {
                Opportunity O=[SELECT ID,AccountID,BP_Payer__c,BP_VAT__c,Recurring_Revenue__c FROM Opportunity WHERE RecordType.Name LIKE '%NON GSM%' AND Recurring_Revenue__c>0 ORDER BY CREATEDDATE DESC LIMIT 1];
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
                ci.Contract_ID__c='2492';
                ci.End_Date__c=system.today().addmonths(3);                   
                ci.start_Date__c=system.today().addmonths(3); 
                ci.Bill_Plan_End_Date__c=system.today().addyears(1);   
            	ci.Bandwidth_UoM_filled__c = 'Mbps';
                insert ci;

                Contract_Ticket_Item__c CTI=new Contract_Ticket_Item__c(Contract_Ticket__c=tmpContract.id);
                CTI.Contract_Item__c=ci.id;
                insert CTI;



                Test.setMock(WebServiceMock.class, new ContractWebServiceMock2());
                test.starttest();
                HitSAPSOAP_Contract.HitContractByHeader(String.valueof(tmpContract.id),'2492','1');
                HitSAPSOAP_Contract.HitContractByHeader(String.valueof(tmpContract.id),'2492','A');

                string ContractTicketItemNo = String.valueof(CTI.id);
                HitSAPSOAP_Contract.HitContractByContractTicketItem(String.valueof(tmpContract.id), ContractTicketItemNo,'1');

                test.stoptest();
        }
        
      
}