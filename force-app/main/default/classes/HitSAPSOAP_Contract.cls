/**
 * @description       : 
 * @Test Class        : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 09-15-2023
 * @last modified by  : Doddy Prima
 * 
 * history :
 * 1. 15 Spet 2023 : update by Doddy : replace from sapComDocumentSapRfcContract2 to sapComDocumentSapRfcFunctions3 (new WSDL)
 * 2.
 * 
**/

public with sharing class HitSAPSOAP_Contract {


    @future(callout = true)
    public static void HitContractByHeader(String ContractTicketID, String ContractHeaderID, string jobID )  //-- Contract-Ticket Salesforce ID
    {
        //hit SAP Contract
        Call_Log__c CL = new Call_Log__c();
        
        Datetime startTime = system.now();
        CL.request_start_time__c = startTime;
        
        
        sapComDocumentSapRfcFunctions3.ZEXDSDST00102 SAPContract = new sapComDocumentSapRfcFunctions3.ZEXDSDST00102();
        //declare parameter and mapping contract ticket/item to parameter
        //-- GET Contract-Ticket Record
        Contract_Ticket__c  contractTicketRec= new Contract_Ticket__c(); 
        
        List<Contract_Ticket__c>  contractTicketList = [   SELECT id, name, Account__C, Opportunity__c, Opportunity__r.Account.BP_Number__c, Change_Price__C 
                                                        , opportunity__r.service_type__c, opportunity__r.PR__c, BA_Extension__c
                                                        , Account__r.BP_Number__c, not_hit_to_sap__c, Contract_Ticket_No__c, CurrencyIsoCode
                                                    FROM  Contract_Ticket__c
                                                    WHERE ID =:ContractTicketID]; 
        
        system.debug('========= lihat : ' + ContractTicketID+ ' -- '  +  ContractHeaderID + ' -- '  +  jobID );
        system.debug('========= lihat : ' + contractTicketList);
        if (contractTicketList.size() >0 ) 
            contractTicketRec = contractTicketList[0];
        
        //-- GET Contract-Ticket-Items List
        List<Contract_Ticket_Item__c> CTIList = [   SELECT id, Contract_Item__c ,Contract_Item_No__c
                                                    FROM Contract_Ticket_Item__c
                                                    WHERE Contract_Ticket__c =:ContractTicketID
                                                        AND  Contract_Item__R.Contract_ID__c =:ContractHeaderID
                                                     ];
        
        system.debug ('============ JobID : ' + JobID);
        list<Scheduled_Process__c> spList = [select id, status__C from Scheduled_Process__c where jobID__c=:JobID];
        system.debug ('============ spList : ' + spList);
        if (spList.size() >0 ) {
            spList[0].Execute_Start__c = system.now();
        }   
            
        string OpportunityID;
        Opportunity opp = new Opportunity();    
        if (contractTicketRec.Opportunity__c <> null) {     
            OpportunityID = contractTicketRec.Opportunity__c;
            opp = [ SELECT AccountID, Account.BP_Number__c, Service_Type__c, PR__c, Link_Related__r.Link_ID__c, CID__C 
                    FROM Opportunity 
                    WHERE id = :OpportunityID];
        }
                                        

        
        //-- SET HEADER ------------------------------------------------------------------------
        Transaction__c settings = Transaction__c.getOrgDefaults();
        //SAPContract.Transaction_Date = transactionyear + transactionmonth + transactionday;
        Date dt = Date.today();
        SAPContract.Transaction_Date = String.valueOf(dt).replace('-','');
       
        String tmpTrxID = String.valueof(settings.transactionID__c);
        tmpTrxID = tmpTrxID.replace('.00','');
        tmpTrxID = apputils.randomStringAll(15) + tmpTrxID;
        tmpTrxID = tmpTrxID.right(15);
        SAPContract.Transaction_ID = tmpTrxID;
        
        settings.transactionID__c = settings.transactionID__c + 1;
        
        
        //-- old SAPContract.SOLD_TO_PARTY =  contractTicketRec.Opportunity__r.Account.BP_Number__c  ;//O.Account.BP_Number__c; //'704234';
        //-- new
        SAPContract.SOLD_TO_PARTY =  contractTicketRec.Account__r.BP_Number__c  ;//O.Account.BP_Number__c; //'704234';
      
        String resend='';
        if(contractTicketRec.not_hit_to_sap__c==true)
         return;       
       // resend='X';
        SAPContract.CURRENCY_x = contractTicketRec.CurrencyIsoCode; //'IDR';
        
        //-- .end of SET HEADER ----------------------------------------------------------------
        
        
        list<sapComDocumentSapRfcFunctions3.ZEXDSDST00103> listContract3 = new list<sapComDocumentSapRfcFunctions3.ZEXDSDST00103>();
        
        //-- This method using for handle many contract-items on Change Price (avoid SOQL on loop) ----
        //-- get Contract-Ticket-Item-ID list
        List <String> ContractItemIDs = new List <String>(); 
        String ContractitemNo='';
        for(Contract_Ticket_Item__c CTI: CTIList) {
            string CIid = CTI.Contract_Item__c;
            ContractItemIDs.add (CIid);
            if(CTI.Contract_Item_No__c!=null && CTI.Contract_Item_No__c!='')
            {
                contractitemNo=CTI.Contract_Item_No__c.substringbefore('-');
            }
        }
         // SAPContract.Ticket_id=ContractTicketRec.Contract_ticket_no__c+'-'+ContractItemNo;
        //-- get Contract-Item List
        system.debug ('========= ContractItemIDs : ' + ContractItemIDs);
        List<Contract> contractItemList  = [    select id, product__r.Bandwidth__c ,Bandwidth__c, Billing_Type__c, StartDate,EndDate, Start_Date__c, End_Date__c, Product__r.SAP_Code__c
                                                    , Quantity__c, Previous_Contract__c, Previous_Contract__R.SAP_ID__c, Previous_Contract__R.Contract_ID__c
                                                    , BP_Payer__c, BP_VAT__c,Auto_Renewal__c
                                                    , BP_Site_A__c, BP_Site_B__c,Bandwidth_UOM__c   
                                                    , Price__c, Link__r.Link_ID__c, Link__r.CID_RelD__r.name
                                                    , Product__r.UOM_Bandwidth__c,Project_Type__c,Bill_Plan_End_Date__c
                                                    , SAP_ID__c, Contract_ID__c, Contract_Header__c,LAST_Transaction_ID__c
                                                    , Bandwidth_filled__c, Bandwidth_UoM_filled__c
                                                    , Previous_Contract_Header_ID_filled__c, Previous_Contract_Item_No_filled__c
                                                    , Product_SAP_Code__c,CID__c,Link__c
                                                from Contract  
                                                where id = :ContractItemIDs]; 
        
        string contractHeaderNo ='';
        SYSTEM.DEBUG ('==== contractItemList : ' + contractItemList );
        for(Contract contractItem: contractItemList)
        {   SYSTEM.DEBUG ('==== contractItem : ' + contractItem );

            contractHeaderNo = contractItem.Contract_ID__c;
            sapComDocumentSapRfcFunctions3.ZEXDSDST00103 Contract3 = new sapComDocumentSapRfcFunctions3.ZEXDSDST00103();
            
            if (contractItem.SAP_ID__c == '' || contractItem.SAP_ID__c == null) {
                Contract3.task = 'I';
            }
            else {
                Contract3.task = 'U';
            } 
            
            //-- old : Contract3.BANDWIDTH = String.valueof(Contractitem.product__r.Bandwidth__c);
            //-- new 
            Contract3.BANDWIDTH = String.valueof(Contractitem.Bandwidth_filled__c);
			
         	System.debug(' == Bandwidth_UoM_filled__c > ' + ContractItem.Bandwidth_UoM_filled__c);
            //System.debug(' == Contract Name > ' + ContractItem.Name);
            System.debug(' == Contract Id > ' + ContractItem.Id);
            UOM_Setting__c UOM_Setting = UOM_Setting__c.getValues(ContractItem.Bandwidth_UoM_filled__c);
            Contract3.BANDWIDTH_UOM = UOM_Setting.SAP_Code__c;
            System.debug(' == BANDWIDTH_UOM > ' + Contract3.BANDWIDTH_UOM);
         	
            //-- TODO: use parameterize to get bandwidth code and bllingtype code!!
            /*if(ContractItem.Bandwidth_UoM_filled__c == 'Mbps'||test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0006';
            if(ContractItem.Bandwidth_UoM_filled__c == 'Kbps'||test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0001';
            if(ContractItem.Bandwidth_UoM_filled__c == 'Gbps'||test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0012';
             if(ContractItem.Bandwidth_UoM_filled__c =='E1'||test.isrunningtest())
                  Contract3.BANDWIDTH_UOM='0002';
             if(ContractItem.Bandwidth_UoM_filled__c =='DS3'||test.isrunningtest())
                Contract3.BANDWIDTH_UOM='0003';
            if(ContractItem.Bandwidth_UoM_filled__c =='STM1'||test.isrunningtest())
                Contract3.BANDWIDTH_UOM='0004';
     		*/
            if(ContractItem.Billing_Type__c == 'Monthly'||test.isrunningtest())
                Contract3.Billing_Type = '55';
            if(ContractItem.Billing_Type__c == 'Bi-Monthly'||test.isrunningtest())
                Contract3.Billing_Type = '56';
            if(ContractItem.Billing_Type__c == 'Tri-Monthly'||test.isrunningtest())
                Contract3.Billing_Type = '57';
            if(ContractItem.Billing_Type__c == 'Half-yearly'||test.isrunningtest())
                Contract3.Billing_Type = '58';
            if(ContractItem.Billing_Type__c == 'Weekly'||test.isrunningtest())
                Contract3.Billing_Type = '59';
            if(ContractItem.Billing_Type__c == 'Bi-Weekly'||test.isrunningtest())
                Contract3.Billing_Type = '60';
            if(ContractItem.Billing_Type__c == 'Billing plan for enquiry'||test.isrunningtest())
                Contract3.Billing_Type = '61';
            if(ContractItem.Billing_Type__c == 'Yearly'||test.isrunningtest())
                Contract3.Billing_Type = '62';
            if(ContractItem.Billing_Type__c == 'Four-Monthly'||test.isrunningtest())
                Contract3.Billing_Type = '63';
            if(ContractItem.Auto_Renewal__c==true)
                Contract3.AUTO_RENEWAL='X';
            else
                Contract3.AUTO_RENEWAL='';   
                if(contractitem.bill_plan_end_date__c!=null)
                { 
                    String BillPlanDay=String.valueof(ContractItem.Bill_Plan_End_Date__c.day());
                    String BillPlanMonth=String.valueof(ContractItem.Bill_Plan_End_Date__c.month());
                    String BillPlanYear=String.valueof(ContractItem.Bill_Plan_End_Date__c.year());
                    
                    if(BillPlanDay.length()==1)
                        BillPlanDay='0'+BillPlanDay;
                    
                    if(BillPlanMonth.length()==1)
                        BillPlanMonth='0'+BillPlanMonth;
                    
                        Contract3.BILL_PLAN_END=BillPlanYear+BillPlanMonth+BillPlanDay;
                }

            if(ContractItem.Start_Date__c!=null && ContractItem.End_Date__c!=null)
            {
                String StartDay = String.valueof(ContractItem.Start_Date__c.Day());
                String EndDay = String.valueof(ContractItem.End_Date__c.Day());
                String StartMonth = String.valueof(ContractItem.Start_Date__c.Month());
                String EndMonth = String.valueof(ContractItem.End_Date__c.Month());
                String StartYear = String.valueof(ContractItem.Start_Date__c.Year());
                String EndYear = String.valueof(ContractItem.End_Date__c.Year());
                if(Startday.length() == 1)
                    StartDay = '0' + Startday;
                if(Startmonth.length() == 1)
                    StartMonth = '0' + StartMonth;
                if(Endday.length() == 1)
                    Endday = '0' + EndDay;
                if(Endmonth.length() == 1)
                    EndMonth = '0' + EndMonth;
                Contract3.Contract_Start = StartYear + StartMonth + StartDay; //ContractItem.Start_Date__c;
                Contract3.Contract_End = EndYear + EndMonth + EndDay;
            }
            
            //--old : Contract3.Material = ContractItem.Product__r.SAP_Code__c;
            //-- new
            Contract3.Material = ContractItem.Product_SAP_Code__c;
            
            
            //-- Set PROJECT TYPE related to OPPORTUNITY or CHANGE PRICE
            if (contractTicketRec.opportunity__c <> null||Contractticketrec.BA_Extension__c<>null) { 
                //-- for OPPORTUNITY

                Contract3.Project_TYPE=ContractITEM.Project_type__c;         
           
                //-- TODO: Change opportunity for change price
                Contract3.PR_A = contractTicketRec.opportunity__r.PR__c;
                
                if (ContractItem.Contract_ID__c!='' && ContractItem.Contract_ID__c!=null)
                     SAPContract.CONTRACT_ID=ContractItem.Contract_ID__C;

                if (cONTRACTItem.SAP_ID__c!='' && ContractItem.SAP_ID__c!=null)
                     Contract3.CONTRACT_ITEM=ContractItem.SAP_ID__c;
                
            }
            else if (contractTicketRec.change_price__c <> null) { 
                //-- for CHANGE PRICE
                Contract3.PROJECT_TYPE = 'NEC';
                Contract3.PR_A = '';
                if (ContractItem.Contract_ID__c!='' && ContractItem.Contract_ID__c!=null)
                     SAPContract.CONTRACT_ID=ContractItem.Contract_ID__C;

                if (cONTRACTItem.SAP_ID__c!='' && ContractItem.SAP_ID__c!=null)
                     Contract3.CONTRACT_ITEM=ContractItem.SAP_ID__c;

            }
                
            Contract3.Quantity = String.valueof(ContractItem.Quantity__c);
            
            //-- set to default E1
            Contract3.UOM = 'E1';
            
            
            //-- JIKA CONTRACT MEMILIKI PREVIOUS (UPGRADE/DOWNGRADE/CHANGE PRICE) 
            if (ContractItem.Previous_Contract__c <> null) {
                
                //--old : Contract3.Reference_ITEM = ContractItem.Previous_Contract__R.SAP_ID__c;
                //--old : Contract3.REFERENCE_COntract = ContractItem.Previous_Contract__R.Contract_ID__c;
                //--new :
                Contract3.Reference_ITEM = ContractItem.Previous_Contract_Item_No_filled__c;
                Contract3.REFERENCE_COntract = ContractItem.Previous_Contract_Header_ID_filled__c;  
                
            }            
            
            Contract3.BP_PAYER = ContractItem.BP_Payer__c;
            Contract3.BP_SITE_A = ContractItem.BP_Site_A__c;
            
            /* old version 
            if(ContractItem.BP_Site_B__c == null)
                Contract3.BP_SITE_B = ContractItem.BP_Site_A__c;
            else
                Contract3.BP_SITE_B = ContractItem.BP_Site_B__c;
            */
            /* new version konfirmasi dari syamsul bahwa bila site B nya kosong tetap dikosongkan */
            Contract3.BP_SITE_B = ContractItem.BP_Site_B__c;
            

            //-- TODO: need confirm to Syamsul : no information on SAP documentation     
            Contract3.BP_VAT = ContractItem.BP_VAT__c;
            Contract3.PRICE = String.valueof(ContractItem.Price__c);
            Contract3.CPE_PRICE = '0';
            
            
            //-- put transaction id item
            Contract3.Transaction_ID_ITEM = 'CI' + String.valueof(math.random()).LEFT(5) + String.valueof(settings.transactionID__c).left(3); //'01234567';
            Contract3.Transaction_ID_ITEM = Contract3.transaction_ID_Item.LEFT(12);
            Contract3.Transaction_ID_ITEM = Contract3.transaction_ID_Item.REPLACE('.', '');
            ContractItem.Last_Transaction_ID__c=CONTRACT3.TRANSACTION_ID_ITEM;
            Contract3.LinkID = ContractItem.Link__r.Link_ID__c;
            Contract3.CID = ContractItem.Link__r.CID_RelD__r.name;
            listContract3.add(Contract3);
            
        } // .endOf FOR
        
        sapComDocumentSapRfcFunctions3.ZEXDSDTT00055 Contract5 = new sapComDocumentSapRfcFunctions3.ZEXDSDTT00055();
        Contract5.item = listContract3;
        sapComDocumentSapRfcFunctions3.ZEXDSDST00104 Contract4 = new sapComDocumentSapRfcFunctions3.ZEXDSDST00104();
        sapComDocumentSapRfcFunctions3.ZEXDSDTT00056 returnMessage = new sapComDocumentSapRfcFunctions3.ZEXDSDTT00056();
        sapComDocumentSapRfcFunctions3.ZBD_SF_CONTRACT ContractFunction = new sapComDocumentSapRfcFunctions3.ZBD_SF_CONTRACT();
        ContractFunction.inputHttpHeaders_x = new Map<String, String>();
        ContractFunction.timeout_x=120000;
        //prepare to hit to SAP
        String username = system.label.SAPUsername; //'P2001211266';// system.label.SAPUsername;//'xlsapint';
        String password = apputils.doDecrypt(system.label.SAPPassword);  // // 'M@nt4pXL';// //'jakarta03';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        ContractFunction.inputHttpHeaders_x.put('Authorization', authorizationHeader);
        ContractFunction.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        ContractFunction.endpoint_x=system.label.URL_Contract;
        string callStatus ='';
        try
        { 
            //call hit function to SAP
            Contract4 = ContractFunction.ZEXD_SF_CONTRACT(Contract5, SAPContract,resend);
            returnMessage = Contract4.Messages;

            
            if(Contract4.Contract_ID != '' && Contract4.Contract_ID != null)
            {   //-- if Contract_ID (HEADER) NOT NULL - mean of the Hit process is success 
                
                list<sapComDocumentSapRfcFunctions3.ZEXDSDST00105> ReturnListContractItem = new list<sapComDocumentSapRfcFunctions3.ZEXDSDST00105>();
                ReturnListContractItem = returnMessage.item;
                Integer L = 0;
                list<Contract_header__c> ListContractHeader = [SELECT id, name, Contract_ID__c  from Contract_Header__c WHERE Contract_ID__c = :Contract4.Contract_ID];
                Contract_Header__c Contractheader = new Contract_Header__c();
                if(listContractHeader.size() > 0)
                {
                    Contractheader.id = listContractheader[0].id;
                    ContractHeader.Contract_ID__c=listContractHeader[0].Contract_id__c;
                }
                else
                {
                    ContractHeader.Contract_ID__C = Contract4.Contract_ID;
                    ContractHeader.Account__c = contractTicketRec.Account__C;
                    insert ContractHeader;
                }
                

                
 
                
                //** NOTES ** ----------------------------------------------------------------------------------
                //-- SET CONTRACT-ITEM-NO and CONTRACT-HEADER-NO based on API HIT RETURN
                //-- listContract3          : contract list yang dikirim ke SAP
                //-- ReturnListContractItem : return list (isinya nomo contract-item dan contract-header)
                
                String returnTransactionID;
                
                //-- New Version
                for(integer i = 0; i < ReturnListContractItem.size(); i++) {
                    returnTransactionID = returnlistContractItem[i].TRANSACTION_ID_ITEM;
               //   for(integer j = 0; j < listContract3.size(); j++) {
                //      if (listContract3[j].TRANSACTION_ID_ITEM == returnTransactionID) {
                            
                            //-- set contract-item-no : SAP_ID__c
                            //-- set contract-item-header : Contract_header__c
                            //-- create contract-header record if not exist
                            
                            //-- 
                            for(integer k = 0; k < contractItemList.size(); k++) {
                                
                                if ( contractItemList[k].LAST_Transaction_ID__c == returnlistContractItem[i].TRANSACTION_ID_ITEM ) {
                                
                                        //-- set contract-item-no
                                        contractItemList[k].SAP_ID__c = returnlistContractItem[i].CONTRACT_ITEM;
                                        contractItemList[k].Contract_header__c = Contractheader.id;
                                        contractItemList[k].Contract_ID__c = Contractheader.Contract_ID__c;
                                    
                                    
                                 
                    
                                
                            }
                            }
                            
                    //  }
               //   }
                    
                }
                //-- .endOf New Version
                
                system.debug ('============ contractItemList : ' + contractItemList);
                callStatus ='Success';
            }
            else
            {
                //-- IF Hit process is Failed (Contract_ID / Header is null or empty)
                contractTicketRec.TicketStatus__c = 'Review By Contract Manager';
                callStatus ='Failed';
                list<sapComDocumentSapRfcFunctions3.ZEXDSDST00105> listmessage=new  list<sapComDocumentSapRfcFunctions3.ZEXDSDST00105>();
                listmessage=returnmessage.item;
                String AllMessage='';
                Send_Email__c e=new Send_Email__c();
                list<user> useradmin=[SELECT id from user where ProfileID=:system.label.Profile_ID_System_Administrator];
                list<user> useradmin2=[SELECT id from user where email=:system.label.System_Admin_Email];
                if(useradmin.size()!=0 )
                {
                e.User_Receiver__c=useradmin[0].id;
                if( useradmin2.size()!=0)
                e.User_Receiver_2__c=useradmin2[0].id;
                e.Subject__c='Error at Contract Creation at '+system.now();
                e.to_email_1__c='OperationRevenueManagement@xl.co.id';
                e.to_email_2__c='OperationGovernanceDS@xl.co.id';
                AllMessage=AllMessage+'  Contract Ticket Name         : '+ contractTicketRec.Name + '<br>';
                AllMessage=AllMessage+'  Contract Header              : '+ contractHeaderNo + '<br>';
                
                // sample url : https://cs72.lightning.force.com/lightning/r/Contract_Ticket__c/a0X5D000000qS4iUAE/view
                // ContractTicketID, String ContractHeaderID, string jobID
                string url =  System.URL.getSalesforceBaseUrl().toExternalForm() +'/lightning/r/Contract_Ticket__c/' + ContractTicketID  + '/view';
                
                AllMessage=AllMessage +'  Contract Ticket link : ' + url +'<br>';
                AllMessage=AllMessage+'  ========================================'+ '<br><br>';
                
                for(sapComDocumentSapRfcFunctions3.ZEXDSDST00105 msg:listmessage)
                {
                    if(Msg.Message_NO!='000')
                    {
                        AllMessage=AllMessage+'  Transaction ID Contract Item : '+msg.TRANSACTION_ID_ITEM + '<br>';
                        AllMessage=AllMessage+'  Message No                   : '+msg.Message_NO + '<br>';
                        AllMessage=AllMessage+'  Messages                     : '+msg.MESSAGE + '<br>';
                        AllMessage=AllMessage+'  --------------------------------------------------------------------';
                        AllMessage=AllMessage +'<br>' + '<br>' ;
                    }
                }
                e.status__c='New';
                e.Message_Body__c=AllMessage;
                insert e;
                }      
            }
            
            
            //Call_Log__c CL = new Call_Log__c();
            //CL.request_start_time__c = startTime;
            CL.endpoint__c = ContractFunction.endpoint_x;
            
            //-- old version
            //CL.Request_Message__c = String.valueof('Contract' + Contract5 + '  ' + SAPContract);
            //CL.response_message__c = String.valueof(returnMessage);
            //if successful hit,Call log will be defined here
            //-- new version
            //CL.Request_Message__c = JSON.serialize (Contract5) + ' --***-- ' + JSON.serialize (SAPContract);
            CL.Request_Message__c = '{"Contract5" :' + JSON.serialize (Contract5) + ', "SAPContract" : ' + JSON.serialize (SAPContract) + '}' ;
            CL.response_message__c = JSON.serialize (Contract4);
            
            CL.response_end_time__c = system.now();
            CL.Type__c = 'Callout';
            cl.status__c = callStatus;
            
            system.debug ('============ contractItemList : ' + contractItemList);
             
            update contractTicketRec; //update C;
            
            update contractItemList; //update CI;
            
            cl.salesforce_id_1__c = ContractTicketID;
            cl.salesforce_id_2__c = ContractHeaderID;
            cl.salesforce_id_3__c = jobID;
            
            insert CL;
            update settings;
            
            
            if (spList.size() >0 ) {
                spList[0].status__c = 'Success';
                spList[0].Execute_End__c = system.now();
                update spList;
            }
            
        }
        catch(exception e)
        {
            // Call_Log__c CL = new Call_Log__c();
            
            //-- old version
            //CL.endpoint__c = ContractFunction.endpoint_x;
            //CL.Request_Message__c = String.valueof('Contract' + Contract5 + '  ' + SAPContract);
            
            //-- new version
            //CL.Request_Message__c = JSON.serialize (Contract5) + ' --***-- ' + JSON.serialize (SAPContract);
            CL.Request_Message__c = '{"Contract5" :' + JSON.serialize (Contract5) + ', "SAPContract" : ' + JSON.serialize (SAPContract) + '}' ;
            //CL.response_message__c = JSON.serialize (returnMessage);
            CL.response_message__c = JSON.serialize (Contract4);
            
            CL.endpoint__c = ContractFunction.endpoint_x;
            CL.response_message__c = e.getmessage()+' **** '+e.getstacktracestring() + ' #### ' + JSON.serialize (Contract4);
            //CL.request_start_time__c = startTime;
            CL.response_end_time__c = system.now();
            CL.Type__c = 'Callout';
            CL.Status__c ='Failed';
            
            //-- OLD contractTicketRec.TicketStatus__c = 'Review By Contract Manager';
            //-- REVISION :
            contractTicketRec.TicketStatus__c = 'Review By Contract Manager';
                Send_Email__c e2=new Send_Email__c();
                list<user> useradmin=[SELECT id from user where ProfileID=:system.label.Profile_ID_System_Administrator];
                list<user> useradmin2=[SELECT id from user where email=:system.label.System_Admin_Email];
                
                String AllMessage='';
                if(useradmin.size()!=0 )
                {
                    //send email if failed to system admin
                    e2.User_Receiver__c=useradmin[0].id;
                    if( useradmin2.size()!=0)
                    e2.User_Receiver_2__c=useradmin2[0].id;
                    e2.Subject__c='Error at Contract Creation at '+system.now();
                    e2.status__c='New';
                    e2.to_email_1__c='OperationRevenueManagement@xl.co.id';
                    e2.to_email_2__c='OperationGovernanceDS@xl.co.id';
                    AllMessage=AllMessage + 'Error System : '+e.getmessage()+'  '+e.getstacktracestring() + '<br>'; 
                    AllMessage=AllMessage+'  Contract Ticket Name         : '+ contractTicketRec.Name + '<br>';
                    AllMessage=AllMessage+'  Contract Header              : '+ contractHeaderNo + '<br>';
                    
                    // sample url : https://cs72.lightning.force.com/lightning/r/Contract_Ticket__c/a0X5D000000qS4iUAE/view
                    // ContractTicketID, String ContractHeaderID, string jobID
                    string url =  System.URL.getSalesforceBaseUrl().toExternalForm() +'/lightning/r/Contract_Ticket__c/' + ContractTicketID  + '/view';
                    AllMessage=AllMessage+'  Contract Ticket link : ' + url ;                
                    
                    e2.Message_Body__c= AllMessage;
                    insert e2;
                }
                
            update contractTicketRec;
            
            cl.salesforce_id_1__c = ContractTicketID;
            cl.salesforce_id_2__c = ContractHeaderID;
            cl.salesforce_id_3__c = jobID;
            
            insert CL;
            update settings;
            
            AppUtils.putError(CL.response_message__c );
            
            if (spList.size() >0 ) {
                spList[0].status__c = 'Failed';
                spList[0].Execute_End__c  = system.now();
                update spList;

            }
        }
    }
    
/*
    @future(callout = true)
    public static void HitContractByHeader(String ContractTicketID, String ContractHeaderID, string jobID )  //-- Contract-Ticket Salesforce ID
    {
        Call_Log__c CL = new Call_Log__c();
        
        Datetime startTime = system.now();
        CL.request_start_time__c = startTime;
        
        
        sapComDocumentSapRfcFunctions3.ZEXDSDST00102 SAPContract = new sapComDocumentSapRfcFunctions3.ZEXDSDST00102();

        //-- GET Contract-Ticket Record
        Contract_Ticket__c  contractTicketRec= new Contract_Ticket__c(); 
        
        List<Contract_Ticket__c>  contractTicketList = [   SELECT id, name, Account__C, Opportunity__c, Opportunity__r.Account.BP_Number__c, Change_Price__C 
                                                        , opportunity__r.service_type__c, opportunity__r.PR__c, BA_Extension__c
                                                        , Account__r.BP_Number__c,not_hit_to_sap__c,Contract_Ticket_No__c
                                                    FROM  Contract_Ticket__c
                                                    WHERE ID =:ContractTicketID]; 
        
        system.debug('========= lihat : ' + ContractTicketID+ ' -- '  +  ContractHeaderID + ' -- '  +  jobID );
        system.debug('========= lihat : ' + contractTicketList);
        if (contractTicketList.size() >0 ) 
            contractTicketRec = contractTicketList[0];
        
        //-- GET Contract-Ticket-Items List
        List<Contract_Ticket_Item__c> CTIList = [   SELECT id, Contract_Item__c ,Contract_Item_No__c
                                                    FROM Contract_Ticket_Item__c
                                                    WHERE Contract_Ticket__c =:ContractTicketID
                                                        AND  Contract_Item__R.Contract_ID__c =:ContractHeaderID
                                                     ];
        
        system.debug ('============ JobID : ' + JobID);
        list<Scheduled_Process__c> spList = [select id, status__C from Scheduled_Process__c where jobID__c=:JobID];
        system.debug ('============ spList : ' + spList);
        if (spList.size() >0 ) {
            spList[0].Execute_Start__c = system.now();
        }   
            
        string OpportunityID;
        Opportunity opp = new Opportunity();    
        if (contractTicketRec.Opportunity__c <> null) {     
            OpportunityID = contractTicketRec.Opportunity__c;
            opp = [ SELECT AccountID, Account.BP_Number__c, Service_Type__c, PR__c, Link_Related__r.Link_ID__c, CID__C 
                    FROM Opportunity 
                    WHERE id = :OpportunityID];
        }
                                        

        
        //-- SET HEADER ------------------------------------------------------------------------
        Transaction__c settings = Transaction__c.getOrgDefaults();
        //SAPContract.Transaction_Date = transactionyear + transactionmonth + transactionday;
        Date dt = Date.today();
        SAPContract.Transaction_Date = String.valueOf(dt).replace('-','');
       
        String tmpTrxID = String.valueof(settings.transactionID__c);
        tmpTrxID = tmpTrxID.replace('.00','');
        tmpTrxID = apputils.randomStringAll(15) + tmpTrxID;
        tmpTrxID = tmpTrxID.right(15);
        SAPContract.Transaction_ID = tmpTrxID;
        
        settings.transactionID__c = settings.transactionID__c + 1;
        
        
        //-- old SAPContract.SOLD_TO_PARTY =  contractTicketRec.Opportunity__r.Account.BP_Number__c  ;//O.Account.BP_Number__c; //'704234';
        //-- new
        SAPContract.SOLD_TO_PARTY =  contractTicketRec.Account__r.BP_Number__c  ;//O.Account.BP_Number__c; //'704234';
      
        String resend='';
        if(contractTicketRec.not_hit_to_sap__c==true)
         return;       
       // resend='X';
        SAPContract.CURRENCY_x = 'IDR';
        
        //-- .end of SET HEADER ----------------------------------------------------------------
        
        
        list<sapComDocumentSapRfcFunctions3.ZEXDSDST00103> listContract3 = new list<sapComDocumentSapRfcFunctions3.ZEXDSDST00103>();
        
        //-- This method using for handle many contract-items on Change Price (avoid SOQL on loop) ----
        //-- get Contract-Ticket-Item-ID list
        List <String> ContractItemIDs = new List <String>(); 
        String ContractitemNo='';
        for(Contract_Ticket_Item__c CTI: CTIList) {
            string CIid = CTI.Contract_Item__c;
            ContractItemIDs.add (CIid);
            if(CTI.Contract_Item_No__c!=null && CTI.Contract_Item_No__c!='')
            {
                contractitemNo=CTI.Contract_Item_No__c.substringbefore('-');
            }
        }
          SAPContract.Ticket_id=ContractTicketRec.Contract_ticket_no__c+'-'+ContractItemNo;
        //-- get Contract-Item List
        List<Contract> contractItemList  = [    select id, product__r.Bandwidth__c ,Bandwidth__c, Billing_Type__c, StartDate,EndDate, Start_Date__c, End_Date__c, Product__r.SAP_Code__c
                                                    , Quantity__c, Previous_Contract__c, Previous_Contract__R.SAP_ID__c, Previous_Contract__R.Contract_ID__c
                                                    , BP_Payer__c, BP_VAT__c,Auto_Renewal__c
                                                    , BP_Site_A__c, BP_Site_B__c,Bandwidth_UOM__c   
                                                    , Price__c, Link__r.Link_ID__c, Link__r.CID_RelD__r.name
                                                    , Product__r.UOM_Bandwidth__c,Project_Type__c,Bill_Plan_End_Date__c
                                                    , SAP_ID__c, Contract_ID__c, Contract_Header__c,LAST_Transaction_ID__c
                                                    , Bandwidth_filled__c, Bandwidth_UoM_filled__c
                                                    , Previous_Contract_Header_ID_filled__c, Previous_Contract_Item_No_filled__c
                                                    , Product_SAP_Code__c,CID__c,Link__c
                                                from Contract  
                                                where id = :ContractItemIDs]; 
        
        string contractHeaderNo ='';
        for(Contract contractItem: contractItemList)
        {
            contractHeaderNo = contractItem.Contract_ID__c;
            sapComDocumentSapRfcFunctions3.ZEXDSDST00103 Contract3 = new sapComDocumentSapRfcFunctions3.ZEXDSDST00103();
            
            if (contractItem.SAP_ID__c == '' || contractItem.SAP_ID__c == null) {
                Contract3.task = 'I';
            }
            else {
                Contract3.task = 'U';
            } 
            
            //-- old : Contract3.BANDWIDTH = String.valueof(Contractitem.product__r.Bandwidth__c);
            //-- new 
            Contract3.BANDWIDTH = String.valueof(Contractitem.Bandwidth_filled__c);

            //-- TODO: use parameterize to get bandwidth code and bllingtype code!!
                     if(ContractItem.Bandwidth_UoM_filled__c == 'Mbps')
                Contract3.BANDWIDTH_UOM = '0006';
            if(ContractItem.Bandwidth_UoM_filled__c == 'Kbps')
                Contract3.BANDWIDTH_UOM = '0001';
            if(ContractItem.Bandwidth_UoM_filled__c == 'Gbps')
                Contract3.BANDWIDTH_UOM = '0012';
             if(ContractItem.Bandwidth_UoM_filled__c =='E1')
                  Contract3.BANDWIDTH_UOM='0002';
             if(ContractItem.Bandwidth_UoM_filled__c =='DS3')
                Contract3.BANDWIDTH_UOM='0003';
            if(ContractItem.Bandwidth_UoM_filled__c =='STM1')
                Contract3.BANDWIDTH_UOM='0004';
                
            if(ContractItem.Billing_Type__c == 'Monthly')
                Contract3.Billing_Type = '55';
            if(ContractItem.Billing_Type__c == 'Bi-Monthly')
                Contract3.Billing_Type = '56';
            if(ContractItem.Billing_Type__c == 'Tri-Monthly')
                Contract3.Billing_Type = '57';
            if(ContractItem.Billing_Type__c == 'Half-yearly')
                Contract3.Billing_Type = '58';
            if(ContractItem.Billing_Type__c == 'Weekly')
                Contract3.Billing_Type = '59';
            if(ContractItem.Billing_Type__c == 'Bi-Weekly')
                Contract3.Billing_Type = '60';
            if(ContractItem.Billing_Type__c == 'Billing plan for enquiry')
                Contract3.Billing_Type = '61';
            if(ContractItem.Billing_Type__c == 'Yearly')
                Contract3.Billing_Type = '62';
            if(ContractItem.Billing_Type__c == 'Four-Monthly')
                Contract3.Billing_Type = '63';
            if(ContractItem.Auto_Renewal__c==true)
                Contract3.AUTO_RENEWAL='X';
            else
                Contract3.AUTO_RENEWAL='';   
                if(contractitem.bill_plan_end_date__c!=null)
                { 
            String BillPlanDay=String.valueof(ContractItem.Bill_Plan_End_Date__c.day());
            String BillPlanMonth=String.valueof(ContractItem.Bill_Plan_End_Date__c.month());
            String BillPlanYear=String.valueof(ContractItem.Bill_Plan_End_Date__c.year());
            if(BillPlanDay.length()==1)
            BillPlanDay='0'+BillPlanDay;
            if(BillPlanMonth.length()==1)
            BillPlanMonth='0'+BillPlanMonth;
            Contract3.BILL_PLAN_END=BillPlanYear+BillPlanMonth+BillPlanDay;
                }
            if(ContractItem.Start_Date__c!=null && ContractItem.End_Date__c!=null)
            {
            String StartDay = String.valueof(ContractItem.Start_Date__c.Day());
            String EndDay = String.valueof(ContractItem.End_Date__c.Day());
            String StartMonth = String.valueof(ContractItem.Start_Date__c.Month());
            String EndMonth = String.valueof(ContractItem.End_Date__c.Month());
            String StartYear = String.valueof(ContractItem.Start_Date__c.Year());
            String EndYear = String.valueof(ContractItem.End_Date__c.Year());
            if(Startday.length() == 1)
                StartDay = '0' + Startday;
            if(Startmonth.length() == 1)
                StartMonth = '0' + StartMonth;
            if(Endday.length() == 1)
                Endday = '0' + EndDay;
            if(Endmonth.length() == 1)
                EndMonth = '0' + EndMonth;
            Contract3.Contract_Start = StartYear + StartMonth + StartDay; //ContractItem.Start_Date__c;
            Contract3.Contract_End = EndYear + EndMonth + EndDay;
            }
            
            //--old : Contract3.Material = ContractItem.Product__r.SAP_Code__c;
            //-- new
            Contract3.Material = ContractItem.Product_SAP_Code__c;
            
            
            //-- Set PROJECT TYPE related to OPPORTUNITY or CHANGE PRICE
           if (contractTicketRec.opportunity__c <> null||Contractticketrec.BA_Extension__c<>null) { 
                //-- for OPPORTUNITY

           Contract3.Project_TYPE=ContractITEM.Project_type__c;         
           
           //-- TODO: Change opportunity for change price
           Contract3.PR_A = contractTicketRec.opportunity__r.PR__c;
                
                    if(ContractItem.Contract_ID__c!='' && ContractItem.Contract_ID__c!=null)
                     SAPContract.CONTRACT_ID=ContractItem.Contract_ID__C;
                     IF(cONTRACTItem.SAP_ID__c!='' && ContractItem.SAP_ID__c!=null)
                     Contract3.CONTRACT_ITEM=ContractItem.SAP_ID__c;
                
            }
            else if (contractTicketRec.change_price__c <> null) { 
                //-- for CHANGE PRICE
                Contract3.PROJECT_TYPE = 'NEC';
            }
                
            Contract3.Quantity = String.valueof(ContractItem.Quantity__c);
            
            //-- set to default E1
            Contract3.UOM = 'E1';
            
            
            //-- JIKA CONTRACT MEMILIKI PREVIOUS (UPGRADE/DOWNGRADE/CHANGE PRICE) 
            if (ContractItem.Previous_Contract__c <> null) {
                
                //--old : Contract3.Reference_ITEM = ContractItem.Previous_Contract__R.SAP_ID__c;
                //--old : Contract3.REFERENCE_COntract = ContractItem.Previous_Contract__R.Contract_ID__c;
                //--new :
                Contract3.Reference_ITEM = ContractItem.Previous_Contract_Item_No_filled__c;
                Contract3.REFERENCE_COntract = ContractItem.Previous_Contract_Header_ID_filled__c;  
                
            }            
            
            Contract3.BP_PAYER = ContractItem.BP_Payer__c;
            Contract3.BP_SITE_A = ContractItem.BP_Site_A__c;
            
          
            Contract3.BP_SITE_B = ContractItem.BP_Site_B__c;
            

            //-- TODO: need confirm to Syamsul : no information on SAP documentation     
            Contract3.BP_VAT = ContractItem.BP_VAT__c;
            Contract3.PRICE = String.valueof(ContractItem.Price__c);
            Contract3.CPE_PRICE = '0';
            
            
            //-- put transaction id item
            Contract3.Transaction_ID_ITEM = 'CI' + String.valueof(math.random()).LEFT(5) + String.valueof(settings.transactionID__c).left(3); //'01234567';
            Contract3.Transaction_ID_ITEM = Contract3.transaction_ID_Item.LEFT(12);
            Contract3.Transaction_ID_ITEM = Contract3.transaction_ID_Item.REPLACE('.', '');
            ContractItem.Last_Transaction_ID__c=CONTRACT3.TRANSACTION_ID_ITEM;
            Contract3.LinkID = ContractItem.Link__r.Link_ID__c;
            Contract3.CID = ContractItem.Link__r.CID_RelD__r.name;
            listContract3.add(Contract3);
            
        } // .endOf FOR
        
        sapComDocumentSapRfcFunctions3.ZEXDSDTT00055 Contract5 = new sapComDocumentSapRfcFunctions3.ZEXDSDTT00055();
        Contract5.item = listContract3;
        sapComDocumentSapRfcFunctions3.ZEXDSDST00104 Contract4 = new sapComDocumentSapRfcFunctions3.ZEXDSDST00104();
        sapComDocumentSapRfcFunctions3.ZEXDSDTT00056 returnMessage = new sapComDocumentSapRfcFunctions3.ZEXDSDTT00056();
        sapComDocumentSapRfcFunctions3.ZBD_SF_CONTRACT ContractFunction = new sapComDocumentSapRfcFunctions3.ZBD_SF_CONTRACT();
        ContractFunction.inputHttpHeaders_x = new Map<String, String>();
        ContractFunction.timeout_x=120000;
        String username = system.label.SAPUsername;//'xlsapint';
        String password = 'M@nt4pXL';//apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        ContractFunction.inputHttpHeaders_x.put('Authorization', authorizationHeader);
        ContractFunction.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        
        string callStatus ='';
        try
        { 
            
            Contract4 = ContractFunction.ZEXD_SF_CONTRACT(Contract5, SAPContract,resend,'');
            returnMessage = Contract4.Messages;
            if(Contract4.Contract_ID != '' && Contract4.Contract_ID != null)
            {   //-- if Contract_ID (HEADER) NOT NULL - mean of the Hit process is success 
                
                list<sapComDocumentSapRfcFunctions3.ZEXDSDST00105> ReturnListContractItem = new list<sapComDocumentSapRfcFunctions3.ZEXDSDST00105>();
                ReturnListContractItem = returnMessage.item;
                Integer L = 0;
                list<Contract_header__c> ListContractHeader = [SELECT id, name, Contract_ID__c  from Contract_Header__c WHERE Contract_ID__c = :Contract4.Contract_ID];
                Contract_Header__c Contractheader = new Contract_Header__c();
                if(listContractHeader.size() > 0)
                {
                    Contractheader.id = listContractheader[0].id;
                    ContractHeader.Contract_ID__c=listContractHeader[0].Contract_id__c;
                }
                else
                {
                    ContractHeader.Contract_ID__C = Contract4.Contract_ID;
                    ContractHeader.Account__c = contractTicketRec.Account__C;
                    insert ContractHeader;
                }
                

                
 
                
                //** NOTES ** ----------------------------------------------------------------------------------
                //-- SET CONTRACT-ITEM-NO and CONTRACT-HEADER-NO based on API HIT RETURN
                //-- listContract3          : contract list yang dikirim ke SAP
                //-- ReturnListContractItem : return list (isinya nomo contract-item dan contract-header)
                
                String returnTransactionID;
                
                //-- New Version
                for(integer i = 0; i < ReturnListContractItem.size(); i++) {
                    returnTransactionID = returnlistContractItem[i].TRANSACTION_ID_ITEM;
               //   for(integer j = 0; j < listContract3.size(); j++) {
                //      if (listContract3[j].TRANSACTION_ID_ITEM == returnTransactionID) {
                            
                            //-- set contract-item-no : SAP_ID__c
                            //-- set contract-item-header : Contract_header__c
                            //-- create contract-header record if not exist
                            
                            //-- 
                            for(integer k = 0; k < contractItemList.size(); k++) {
                                
                                if ( contractItemList[k].LAST_Transaction_ID__c == returnlistContractItem[i].TRANSACTION_ID_ITEM ) {
                                
                                        //-- set contract-item-no
                                        contractItemList[k].SAP_ID__c = returnlistContractItem[i].CONTRACT_ITEM;
                                        contractItemList[k].Contract_header__c = Contractheader.id;
                                        contractItemList[k].Contract_ID__c = Contractheader.Contract_ID__c;
                                    
                                    
                                 
                    
                                
                            }
                            }
                            
                    //  }
               //   }
                    
                }
                //-- .endOf New Version
                
                system.debug ('============ contractItemList : ' + contractItemList);
                callStatus ='Success';
            }
            else
            {
                //-- IF Hit process is Failed (Contract_ID / Header is null or empty)
                contractTicketRec.TicketStatus__c = 'Review By Contract Manager';
                callStatus ='Failed';
                list<sapComDocumentSapRfcFunctions3.ZEXDSDST00105> listmessage=new  list<sapComDocumentSapRfcFunctions3.ZEXDSDST00105>();
                listmessage=returnmessage.item;
                String AllMessage='';
                Send_Email__c e=new Send_Email__c();
                list<user> useradmin=[SELECT id from user where ProfileID=:system.label.Profile_ID_System_Administrator];
                list<user> useradmin2=[SELECT id from user where email=:system.label.System_Admin_Email];
                if(useradmin.size()!=0 )
                {
                e.User_Receiver__c=useradmin[0].id;
                if( useradmin2.size()!=0)
                e.User_Receiver_2__c=useradmin2[0].id;
                e.Subject__c='Error at Contract Creation at '+system.now();
                e.to_email_1__c='OperationRevenueManagement@xl.co.id';
                e.to_email_2__c='OperationGovernanceDS@xl.co.id';
                AllMessage=AllMessage+'  Contract Ticket Name         : '+ contractTicketRec.Name + '<br>';
                AllMessage=AllMessage+'  Contract Header              : '+ contractHeaderNo + '<br>';
                
                // sample url : https://cs72.lightning.force.com/lightning/r/Contract_Ticket__c/a0X5D000000qS4iUAE/view
                // ContractTicketID, String ContractHeaderID, string jobID
                string url =  System.URL.getSalesforceBaseUrl().toExternalForm() +'/lightning/r/Contract_Ticket__c/' + ContractTicketID  + '/view';
                
                AllMessage=AllMessage +'  Contract Ticket link : ' + url +'<br>';
                AllMessage=AllMessage+'  ========================================'+ '<br><br>';
                
                for(sapComDocumentSapRfcContract.ZEXDSDST00105 msg:listmessage)
                {
                    if(Msg.Message_NO!='000')
                    {
                        AllMessage=AllMessage+'  Transaction ID Contract Item : '+msg.TRANSACTION_ID_ITEM + '<br>';
                        AllMessage=AllMessage+'  Message No                   : '+msg.Message_NO + '<br>';
                        AllMessage=AllMessage+'  Messages                     : '+msg.MESSAGE + '<br>';
                        AllMessage=AllMessage+'  --------------------------------------------------------------------';
                        AllMessage=AllMessage +'<br>' + '<br>' ;
                    }
                }
                e.status__c='New';
                e.Message_Body__c=AllMessage;
                insert e;
                }      
            }
            
            
            //Call_Log__c CL = new Call_Log__c();
            //CL.request_start_time__c = startTime;
            CL.endpoint__c = ContractFunction.endpoint_x;
            
            //-- old version
            //CL.Request_Message__c = String.valueof('Contract' + Contract5 + '  ' + SAPContract);
            //CL.response_message__c = String.valueof(returnMessage);
            
            //-- new version
            //CL.Request_Message__c = JSON.serialize (Contract5) + ' --***-- ' + JSON.serialize (SAPContract);
            CL.Request_Message__c = '{"Contract5" :' + JSON.serialize (Contract5) + ', "SAPContract" : ' + JSON.serialize (SAPContract) + '}' ;
            CL.response_message__c = JSON.serialize (Contract4);
            
            CL.response_end_time__c = system.now();
            CL.Type__c = 'Callout';
            cl.status__c = callStatus;
            
            system.debug ('============ contractItemList : ' + contractItemList);
             
            update contractTicketRec; //update C;
            
            update contractItemList; //update CI;
            
            cl.salesforce_id_1__c = ContractTicketID;
            cl.salesforce_id_2__c = ContractHeaderID;
            cl.salesforce_id_3__c = jobID;
            
            insert CL;
            update settings;
            
            
            if (spList.size() >0 ) {
                spList[0].status__c = 'Success';
                spList[0].Execute_End__c = system.now();
                update spList;
            }
            
        }
        catch(exception e)
        {
            // Call_Log__c CL = new Call_Log__c();
            
            //-- old version
            //CL.endpoint__c = ContractFunction.endpoint_x;
            //CL.Request_Message__c = String.valueof('Contract' + Contract5 + '  ' + SAPContract);
            
            //-- new version
            //CL.Request_Message__c = JSON.serialize (Contract5) + ' --***-- ' + JSON.serialize (SAPContract);
            CL.Request_Message__c = '{"Contract5" :' + JSON.serialize (Contract5) + ', "SAPContract" : ' + JSON.serialize (SAPContract) + '}' ;
            //CL.response_message__c = JSON.serialize (returnMessage);
            CL.response_message__c = JSON.serialize (Contract4);
            
            CL.endpoint__c = ContractFunction.endpoint_x;
            CL.response_message__c = e.getmessage()+'  '+e.getstacktracestring() + ' ' + Contract4;
            //CL.request_start_time__c = startTime;
            CL.response_end_time__c = system.now();
            CL.Type__c = 'Callout';
            CL.Status__c ='Failed';
            
            //-- OLD contractTicketRec.TicketStatus__c = 'Review By Contract Manager';
            //-- REVISION :
            contractTicketRec.TicketStatus__c = 'Review By Contract Manager';
                Send_Email__c e2=new Send_Email__c();
                list<user> useradmin=[SELECT id from user where ProfileID=:system.label.Profile_ID_System_Administrator];
                list<user> useradmin2=[SELECT id from user where email=:system.label.System_Admin_Email];
                
                String AllMessage='';
                if(useradmin.size()!=0 )
                {
                    e2.User_Receiver__c=useradmin[0].id;
                    if( useradmin2.size()!=0)
                    e2.User_Receiver_2__c=useradmin2[0].id;
                    e2.Subject__c='Error at Contract Creation at '+system.now();
                    e2.status__c='New';
                    e2.to_email_1__c='OperationRevenueManagement@xl.co.id';
                    e2.to_email_2__c='OperationGovernanceDS@xl.co.id';
                    AllMessage=AllMessage + 'Error System : '+e.getmessage()+'  '+e.getstacktracestring() + '<br>'; 
                    AllMessage=AllMessage+'  Contract Ticket Name         : '+ contractTicketRec.Name + '<br>';
                    AllMessage=AllMessage+'  Contract Header              : '+ contractHeaderNo + '<br>';
                    
                    // sample url : https://cs72.lightning.force.com/lightning/r/Contract_Ticket__c/a0X5D000000qS4iUAE/view
                    // ContractTicketID, String ContractHeaderID, string jobID
                    string url =  System.URL.getSalesforceBaseUrl().toExternalForm() +'/lightning/r/Contract_Ticket__c/' + ContractTicketID  + '/view';
                    AllMessage=AllMessage+'  Contract Ticket link : ' + url ;                
                    
                    e2.Message_Body__c= AllMessage;
                    insert e2;
                }
                
            update contractTicketRec;
            
            cl.salesforce_id_1__c = ContractTicketID;
            cl.salesforce_id_2__c = ContractHeaderID;
            cl.salesforce_id_3__c = jobID;
            
            insert CL;
            update settings;
            
            AppUtils.putError(CL.response_message__c );
            
            if (spList.size() >0 ) {
                spList[0].status__c = 'Failed';
                spList[0].Execute_End__c  = system.now();
                update spList;
            }
        }
    }
    
   */
    @future(callout = true)
    public static void HitContractByContractTicketItem(String ContractTicketID, String ContractTicketItemID, string jobID) //-- Contract-Ticket Salesforce ID
    {   

        SYSTEM.DEBUG ('=========== in method : HitContractByContractTicketItem ===========================') ; 
        SYSTEM.DEBUG ('=========== ContractTicketID     : ' + ContractTicketID );
        SYSTEM.DEBUG ('=========== ContractTicketItemID : ' + ContractTicketItemID );
        SYSTEM.DEBUG ('=========== jobID                : ' + jobID );

        Datetime startTime = system.now();
        
        string requestID = '';
        String endPoint = '';
        String callerFrom = 'Salesforce';
        String callType = 'Callout';
        String callStatus = '';
        String requestMessage = '';
        String responseMessage = '';
        String errorMessage = '';

        ID spID = null;

        sapComDocumentSapRfcFunctions3.ZEXDSDST00102 SAPContract = new sapComDocumentSapRfcFunctions3.ZEXDSDST00102();
        //declare parameter and mapping contract ticket/item to parameter
        //-- GET Contract-Ticket Record
        Contract_Ticket__c contractTicketRec = new Contract_Ticket__c();

        List < Contract_Ticket__c > contractTicketList = [SELECT id, name, Account__C, Opportunity__c, Opportunity__r.Account.BP_Number__c, 
                                                                Change_Price__C, opportunity__r.service_type__c, opportunity__r.PR__c, 
                                                                BA_Extension__c, Account__r.BP_Number__c, not_hit_to_sap__c, Contract_Ticket_No__c, CurrencyIsoCode
                                                        FROM Contract_Ticket__c
                                                        WHERE ID =: ContractTicketID
                                                        ];

        //system.debug('========= lihat : ' + ContractTicketID+ ' -- '  +  ContractHeaderID + ' -- '  +  jobID );
        system.debug('========= Check ContractTicketID ContractTicketItemID jobID : ' + ContractTicketID + ' -- ' + ContractTicketItemID + ' -- ' + jobID);
        system.debug('========= Check contractTicketList : ' + contractTicketList);
        if (contractTicketList.size() > 0)
            contractTicketRec = contractTicketList[0];

        
        //-- if any flag that NO NEED HIT then skip the flow !!!
        if (contractTicketRec.not_hit_to_sap__c == true)
            return;


        //-- GET Contract-Ticket-Items List
        List < Contract_Ticket_Item__c > CTIList = [SELECT id, Contract_Item__c, Contract_Item_No__c
            FROM Contract_Ticket_Item__c
            WHERE Contract_Ticket__c =: ContractTicketID
            //AND  Contract_Item__R.Contract_ID__c =:ContractHeaderID
            AND id =: ContractTicketItemID
        ];

        system.debug('============ JobID : ' + JobID);
        
        list < Scheduled_Process__c > spList = [select id, status__C from Scheduled_Process__c where jobID__c =: JobID];
        system.debug('============ spList : ' + spList);
        
        if (spList.size() > 0) {
            spList[0].Execute_Start__c = system.now();
        }

        string OpportunityID;
        Opportunity opp = new Opportunity();
        if (contractTicketRec.Opportunity__c <> null) {
            OpportunityID = contractTicketRec.Opportunity__c;
            opp = [SELECT AccountID, Account.BP_Number__c, Service_Type__c, PR__c, Link_Related__r.Link_ID__c, CID__C
                FROM Opportunity
                WHERE id =: OpportunityID
            ];
        }



        //-- SET HEADER ------------------------------------------------------------------------
        Transaction__c settings = Transaction__c.getOrgDefaults();
        //SAPContract.Transaction_Date = transactionyear + transactionmonth + transactionday;
        Date dt = Date.today();
        SAPContract.Transaction_Date = String.valueOf(dt).replace('-', '');

        String tmpTrxID = String.valueof(settings.transactionID__c);
        tmpTrxID = tmpTrxID.replace('.00', '');
        tmpTrxID = apputils.randomStringAll(15) + tmpTrxID;
        tmpTrxID = tmpTrxID.right(15);
        SAPContract.Transaction_ID = tmpTrxID;

        requestID = tmpTrxID;

        settings.transactionID__c = settings.transactionID__c + 1;


        //-- old SAPContract.SOLD_TO_PARTY =  contractTicketRec.Opportunity__r.Account.BP_Number__c  ;//O.Account.BP_Number__c; //'704234';
        //-- new
        SAPContract.SOLD_TO_PARTY = contractTicketRec.Account__r.BP_Number__c; //O.Account.BP_Number__c; //'704234';

        String resend = '';
        
        
            // resend='X';
        SAPContract.CURRENCY_x = contractTicketRec.CurrencyIsoCode; //'IDR';

        //-- .end of SET HEADER ----------------------------------------------------------------


        list < sapComDocumentSapRfcFunctions3.ZEXDSDST00103 > listContract3 = new list < sapComDocumentSapRfcFunctions3.ZEXDSDST00103 > ();

        //-- This method using for handle many contract-items on Change Price (avoid SOQL on loop) ----
        //-- get Contract-Ticket-Item-ID list
        List < String > ContractItemIDs = new List < String > ();
        String ContractitemNo = '';
        for (Contract_Ticket_Item__c CTI: CTIList) {
            string CIid = CTI.Contract_Item__c;
            ContractItemIDs.add(CIid);

            if (CTI.Contract_Item_No__c != null && CTI.Contract_Item_No__c != '') {
                contractitemNo = CTI.Contract_Item_No__c.substringbefore('-');
            }
        }
        // SAPContract.Ticket_id=ContractTicketRec.Contract_ticket_no__c+'-'+ContractItemNo;
        
        //-- GET CONTRACT List
        List < Contract > contractItemList = [SELECT id,Name, product__r.Bandwidth__c, Bandwidth__c, Billing_Type__c, StartDate, EndDate, 
                                                Start_Date__c, End_Date__c, Product__r.SAP_Code__c, Quantity__c, Previous_Contract__c, 
                                                Previous_Contract__R.SAP_ID__c, Previous_Contract__R.Contract_ID__c, BP_Payer__c, 
                                                BP_VAT__c, Auto_Renewal__c, BP_Site_A__c, BP_Site_B__c, Bandwidth_UOM__c, Price__c, 
                                                Link__r.Link_ID__c, Link__r.CID_RelD__r.name, Product__r.UOM_Bandwidth__c, Project_Type__c, 
                                                Bill_Plan_End_Date__c, SAP_ID__c, Contract_ID__c, Contract_Header__c, LAST_Transaction_ID__c, 
                                                Bandwidth_filled__c, Bandwidth_UoM_filled__c, Previous_Contract_Header_ID_filled__c, 
                                                Previous_Contract_Item_No_filled__c, Product_SAP_Code__c, CID__c, Link__c, CPE_Price__c
                                            FROM Contract
                                            WHERE id =: ContractItemIDs
        ];

        string contractHeaderNo = '';
        for (Contract contractItem: contractItemList) {
            contractHeaderNo = contractItem.Contract_ID__c;
            sapComDocumentSapRfcFunctions3.ZEXDSDST00103 Contract3 = new sapComDocumentSapRfcFunctions3.ZEXDSDST00103();

            if (contractItem.SAP_ID__c == '' || contractItem.SAP_ID__c == null) {
                //-- IF CONTRACT-ITEM-NO is empthy that mean need to CREATE CONTRACT
                Contract3.task = 'I';

            } else {
                //-- IF CONTRACT-ITEM-NO is empthy (svsilsble) that mean need to UPDATE CONTRACT only
                Contract3.task = 'U';
            }

            //-- old : Contract3.BANDWIDTH = String.valueof(Contractitem.product__r.Bandwidth__c);
            //-- new 
            Contract3.BANDWIDTH = String.valueof(Contractitem.Bandwidth_filled__c);
			
            System.debug(' == Bandwidth_UoM_filled__c > ' + ContractItem.Bandwidth_UoM_filled__c);
            System.debug(' == Contract Name > ' + ContractItem.Name);
            System.debug(' == Contract Id > ' + ContractItem.Id);
            UOM_Setting__c UOM_Setting = UOM_Setting__c.getValues(ContractItem.Bandwidth_UoM_filled__c);
            	
            if(UOM_Setting != null){
                Contract3.BANDWIDTH_UOM = UOM_Setting.SAP_Code__c;
            } else{
                Contract3.BANDWIDTH_UOM = '';
            }
                
            
            //-------------
            /*
            if(ContractItem.Bandwidth_UoM_filled__c == null || ContractItem.Bandwidth_UoM_filled__c == ''){
            	Contract3.BANDWIDTH_UOM = '';
            }else {
                
            	UOM_Setting__c UOM_Setting = UOM_Setting__c.getValues(ContractItem.Bandwidth_UoM_filled__c);
            	Contract3.BANDWIDTH_UOM = UOM_Setting.SAP_Code__c;
            }*/
            System.debug(' == BANDWIDTH_UOM > ' + Contract3.BANDWIDTH_UOM);
            
            /*
            //-- TODO: use parameterize to get bandwidth code and bllingtype code!!
            if (ContractItem.Bandwidth_UoM_filled__c == 'Mbps' || test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0006';
            
            if (ContractItem.Bandwidth_UoM_filled__c == 'Kbps' || test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0001';
            
            if (ContractItem.Bandwidth_UoM_filled__c == 'Gbps' || test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0012';
            
            if (ContractItem.Bandwidth_UoM_filled__c == 'E1' || test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0002';
            
            if (ContractItem.Bandwidth_UoM_filled__c == 'DS3' || test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0003';

            if (ContractItem.Bandwidth_UoM_filled__c == 'STM1' || test.isrunningtest())
                Contract3.BANDWIDTH_UOM = '0004';

*/

            if (ContractItem.Billing_Type__c == 'Monthly' || test.isrunningtest())
                Contract3.Billing_Type = '55';
            
            if (ContractItem.Billing_Type__c == 'Bi-Monthly' || test.isrunningtest())
                Contract3.Billing_Type = '56';
            
            if (ContractItem.Billing_Type__c == 'Tri-Monthly' || test.isrunningtest())
                Contract3.Billing_Type = '57';
            
            if (ContractItem.Billing_Type__c == 'Half-yearly' || test.isrunningtest())
                Contract3.Billing_Type = '58';
            
            if (ContractItem.Billing_Type__c == 'Weekly' || test.isrunningtest())
                Contract3.Billing_Type = '59';
            
            if (ContractItem.Billing_Type__c == 'Bi-Weekly' || test.isrunningtest())
                Contract3.Billing_Type = '60';
            
            if (ContractItem.Billing_Type__c == 'Billing plan for enquiry' || test.isrunningtest())
                Contract3.Billing_Type = '61';
            
            if (ContractItem.Billing_Type__c == 'Yearly' || test.isrunningtest())
                Contract3.Billing_Type = '62';
            
            if (ContractItem.Billing_Type__c == 'Four-Monthly' || test.isrunningtest())
                Contract3.Billing_Type = '63';
            
            if (ContractItem.Auto_Renewal__c == true)
                Contract3.AUTO_RENEWAL = 'X';
            else
                Contract3.AUTO_RENEWAL = '';

            if (contractitem.bill_plan_end_date__c != null) {
                String BillPlanDay = String.valueof(ContractItem.Bill_Plan_End_Date__c.day());
                String BillPlanMonth = String.valueof(ContractItem.Bill_Plan_End_Date__c.month());
                String BillPlanYear = String.valueof(ContractItem.Bill_Plan_End_Date__c.year());

                if (BillPlanDay.length() == 1)
                    BillPlanDay = '0' + BillPlanDay;

                if (BillPlanMonth.length() == 1)
                    BillPlanMonth = '0' + BillPlanMonth;

                Contract3.BILL_PLAN_END = BillPlanYear + BillPlanMonth + BillPlanDay;
            }

            if (ContractItem.Start_Date__c != null && ContractItem.End_Date__c != null) {
                String StartDay = String.valueof(ContractItem.Start_Date__c.Day());
                String EndDay = String.valueof(ContractItem.End_Date__c.Day());
                String StartMonth = String.valueof(ContractItem.Start_Date__c.Month());
                String EndMonth = String.valueof(ContractItem.End_Date__c.Month());
                String StartYear = String.valueof(ContractItem.Start_Date__c.Year());
                String EndYear = String.valueof(ContractItem.End_Date__c.Year());

                if (Startday.length() == 1)
                    StartDay = '0' + Startday;

                if (Startmonth.length() == 1)
                    StartMonth = '0' + StartMonth;

                if (Endday.length() == 1)
                    Endday = '0' + EndDay;

                if (Endmonth.length() == 1)
                    EndMonth = '0' + EndMonth;

                Contract3.Contract_Start = StartYear + StartMonth + StartDay; //ContractItem.Start_Date__c;
                Contract3.Contract_End = EndYear + EndMonth + EndDay;

            }

            //--old : Contract3.Material = ContractItem.Product__r.SAP_Code__c;
            //-- new
            Contract3.Material = ContractItem.Product_SAP_Code__c;


            //-- Set PROJECT TYPE related to OPPORTUNITY or CHANGE PRICE
            if (contractTicketRec.opportunity__c <> null || Contractticketrec.BA_Extension__c <> null) {
                //-- for OPPORTUNITY --------------------------------------

                Contract3.Project_TYPE = ContractITEM.Project_type__c;

                //-- TODO: Change opportunity for change price
                Contract3.PR_A = contractTicketRec.opportunity__r.PR__c;

                if (ContractItem.Contract_ID__c != '' && ContractItem.Contract_ID__c != null)
                    SAPContract.CONTRACT_ID = ContractItem.Contract_ID__C;

                IF (cONTRACTItem.SAP_ID__c != '' && ContractItem.SAP_ID__c != null)
                    Contract3.CONTRACT_ITEM = ContractItem.SAP_ID__c;


            } else if (contractTicketRec.change_price__c <> null) {
                //-- for CHANGE PRICE --------------------------------------

                Contract3.PROJECT_TYPE = 'NEC';
                Contract3.PR_A = '';
                if (ContractItem.Contract_ID__c != '' && ContractItem.Contract_ID__c != null)
                    SAPContract.CONTRACT_ID = ContractItem.Contract_ID__C;

                if (cONTRACTItem.SAP_ID__c != '' && ContractItem.SAP_ID__c != null)
                    Contract3.CONTRACT_ITEM = ContractItem.SAP_ID__c;
            }

            Contract3.Quantity = String.valueof(ContractItem.Quantity__c);

            //-- set to default E1
            Contract3.UOM = 'E1';


            //-- JIKA CONTRACT MEMILIKI PREVIOUS (UPGRADE/DOWNGRADE/CHANGE PRICE) 
            if (ContractItem.Previous_Contract__c <> null) {

                //--old : Contract3.Reference_ITEM = ContractItem.Previous_Contract__R.SAP_ID__c;
                //--old : Contract3.REFERENCE_COntract = ContractItem.Previous_Contract__R.Contract_ID__c;
                //--new :
                Contract3.Reference_ITEM = ContractItem.Previous_Contract_Item_No_filled__c;
                Contract3.REFERENCE_COntract = ContractItem.Previous_Contract_Header_ID_filled__c;

            }

            Contract3.BP_PAYER = ContractItem.BP_Payer__c;
            Contract3.BP_SITE_A = ContractItem.BP_Site_A__c;

            /* old version 
            if(ContractItem.BP_Site_B__c == null)
                Contract3.BP_SITE_B = ContractItem.BP_Site_A__c;
            else
                Contract3.BP_SITE_B = ContractItem.BP_Site_B__c;
            */
            /* new version konfirmasi dari syamsul bahwa bila site B nya kosong tetap dikosongkan */
            Contract3.BP_SITE_B = ContractItem.BP_Site_B__c;


            //-- TODO: need confirm to Syamsul : no information on SAP documentation     
            Contract3.BP_VAT = ContractItem.BP_VAT__c;
            Contract3.PRICE = String.valueof(ContractItem.Price__c);

            //-- Set CPE value to null if the real value is 0.
            Contract3.CPE_PRICE = (ContractItem.CPE_Price__c == 0 || ContractItem.CPE_Price__c == null ) ? '' : string.valueOf(ContractItem.CPE_Price__c);
            

            //-- put transaction id item
            Contract3.Transaction_ID_ITEM = 'CI' + String.valueof(math.random()).LEFT(5) + String.valueof(settings.transactionID__c).left(3); //'01234567';
            Contract3.Transaction_ID_ITEM = Contract3.transaction_ID_Item.LEFT(12);
            Contract3.Transaction_ID_ITEM = Contract3.transaction_ID_Item.REPLACE('.', '');
            ContractItem.Last_Transaction_ID__c = CONTRACT3.TRANSACTION_ID_ITEM;
            Contract3.LinkID = ContractItem.Link__r.Link_ID__c;
            Contract3.CID = ContractItem.Link__r.CID_RelD__r.name;
            listContract3.add(Contract3);

        } // .endOf FOR

        sapComDocumentSapRfcFunctions3.ZEXDSDTT00055 Contract5 = new sapComDocumentSapRfcFunctions3.ZEXDSDTT00055();
        Contract5.item = listContract3;
        sapComDocumentSapRfcFunctions3.ZEXDSDST00104 Contract4 = new sapComDocumentSapRfcFunctions3.ZEXDSDST00104();
        sapComDocumentSapRfcFunctions3.ZEXDSDTT00056 returnMessage = new sapComDocumentSapRfcFunctions3.ZEXDSDTT00056();
        sapComDocumentSapRfcFunctions3.ZBD_SF_CONTRACT ContractFunction = new sapComDocumentSapRfcFunctions3.ZBD_SF_CONTRACT();
        ContractFunction.inputHttpHeaders_x = new Map < String, String > ();
        ContractFunction.timeout_x = 120000;

        //prepare to hit to SAP
        String username = system.label.SAPUsername; //'P2001211266';// system.label.SAPUsername;//'xlsapint';
        String password = apputils.doDecrypt(system.label.SAPPassword); // // 'M@nt4pXL';// //'jakarta03';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        ContractFunction.inputHttpHeaders_x.put('Authorization', authorizationHeader);
        ContractFunction.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        ContractFunction.endpoint_x = system.label.URL_Contract;
        
        try {
            //call hit function to SAP
            Contract4 = ContractFunction.ZEXD_SF_CONTRACT(Contract5, SAPContract, resend);
            returnMessage = Contract4.Messages;
            


            



            list < sapComDocumentSapRfcFunctions3.ZEXDSDST00105 > ReturnListContractItem = new list < sapComDocumentSapRfcFunctions3.ZEXDSDST00105 > ();
            ReturnListContractItem = returnMessage.item;

            boolean isAnyFailed = false ;
            for (sapComDocumentSapRfcFunctions3.ZEXDSDST00105 msg: ReturnListContractItem) {
                if (Msg.Message_NO != '000') {
                    isAnyFailed = true;
                }
            }


            //--- OLD LOGIC :: if (Contract4.Contract_ID != '' && Contract4.Contract_ID != null) { //-- if Contract_ID (HEADER) NOT NULL - mean of the Hit process is success 
            if (isAnyFailed == false)    {

                //-- THERE IS NO FAILED ITEM (ALL SUCCESS)

                Integer L = 0;
                list < Contract_header__c > ListContractHeader = [SELECT id, name, Contract_ID__c from Contract_Header__c WHERE Contract_ID__c =: Contract4.Contract_ID];
                Contract_Header__c Contractheader = new Contract_Header__c();
                
                if (listContractHeader.size() > 0) {
                    Contractheader.id = listContractheader[0].id;
                    ContractHeader.Contract_ID__c = listContractHeader[0].Contract_id__c;
                } else {
                    ContractHeader.Contract_ID__C = Contract4.Contract_ID;
                    ContractHeader.Account__c = contractTicketRec.Account__C;
                    insert ContractHeader;
                }


                //** NOTES ** ----------------------------------------------------------------------------------
                //-- SET CONTRACT-ITEM-NO and CONTRACT-HEADER-NO based on API HIT RETURN
                //-- listContract3          : contract list yang dikirim ke SAP
                //-- ReturnListContractItem : return list (isinya nomo contract-item dan contract-header)

                String returnTransactionID;

                //-- New Version
                for (integer i = 0; i < ReturnListContractItem.size(); i++) {
                    returnTransactionID = returnlistContractItem[i].TRANSACTION_ID_ITEM;
                    //   for(integer j = 0; j < listContract3.size(); j++) {
                    //      if (listContract3[j].TRANSACTION_ID_ITEM == returnTransactionID) {

                    //-- set contract-item-no : SAP_ID__c
                    //-- set contract-item-header : Contract_header__c
                    //-- create contract-header record if not exist

                    //-- 
                    for (integer k = 0; k < contractItemList.size(); k++) {

                        if (contractItemList[k].LAST_Transaction_ID__c == returnlistContractItem[i].TRANSACTION_ID_ITEM) {

                            //-- set contract-item-no
                            contractItemList[k].SAP_ID__c = returnlistContractItem[i].CONTRACT_ITEM;
                            contractItemList[k].Contract_header__c = Contractheader.id;
                            contractItemList[k].Contract_ID__c = Contractheader.Contract_ID__c;

                        }
                    }

                    //  }
                    //   }

                }
                //-- .endOf New Version

                system.debug('============ contractItemList : ' + contractItemList);
                callStatus = 'Success';


                if (spList.size() > 0) {
                    spID = spList[0].id;
                    
                    spList[0].status__c = 'Success';
                    spList[0].Execute_End__c = system.now();
                    update spList;
                
                } else {
                    spID = null;
                }

            } else {
                //-- IF Hit process ANY Failed  ITEM 

                contractTicketRec.TicketStatus__c = 'Review By Contract Manager';
                callStatus = 'Failed';
                
                list < sapComDocumentSapRfcFunctions3.ZEXDSDST00105 > listmessage = new list < sapComDocumentSapRfcFunctions3.ZEXDSDST00105 > ();
                listmessage = returnmessage.item;
                String AllMessage = '';
                
                Send_Email__c sendEmailObj = new Send_Email__c();
                list < user > useradmin = [SELECT id from user where ProfileID =: system.label.Profile_ID_System_Administrator];
                list < user > useradmin2 = [SELECT id from user where email =: system.label.System_Admin_Email];

                if (useradmin.size() != 0) {
                    sendEmailObj.User_Receiver__c = useradmin[0].id;
                
                    if (useradmin2.size() != 0)
                        sendEmailObj.User_Receiver_2__c = useradmin2[0].id;
                        
                    sendEmailObj.Subject__c = 'Error at Contract Creation at ' + system.now();
                    sendEmailObj.to_email_1__c = 'OperationRevenueManagement@xl.co.id';     // TODO : add this value to custom setting
                    sendEmailObj.to_email_2__c = 'OperationGovernanceDS@xl.co.id';          // TODO : add this value to custom setting

                    AllMessage = AllMessage + '  Contract Ticket Name         : ' + contractTicketRec.Name + '<br>';
                    AllMessage = AllMessage + '  Contract Header              : ' + contractHeaderNo + '<br>';

                    // sample url : https://cs72.lightning.force.com/lightning/r/Contract_Ticket__c/a0X5D000000qS4iUAE/view
                    // ContractTicketID, String ContractHeaderID, string jobID
                    string url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/Contract_Ticket__c/' + ContractTicketID + '/view';

                    AllMessage = AllMessage + '  Contract Ticket link : ' + url + '<br>';
                    AllMessage = AllMessage + '  ========================================' + '<br><br>';

                    for (sapComDocumentSapRfcFunctions3.ZEXDSDST00105 msg: listmessage) {
                        if (Msg.Message_NO != '000') {
                            AllMessage = AllMessage + '  Transaction ID Contract Item : ' + msg.TRANSACTION_ID_ITEM + '<br>';
                            AllMessage = AllMessage + '  Message No                   : ' + msg.Message_NO + '<br>';
                            AllMessage = AllMessage + '  Messages                     : ' + msg.MESSAGE + '<br>';
                            AllMessage = AllMessage + '  --------------------------------------------------------------------';
                            AllMessage = AllMessage + '<br>' + '<br>';
                        }
                    }

                    sendEmailObj.status__c = 'New';
                    sendEmailObj.Message_Body__c = AllMessage;
                    
                    insert sendEmailObj;
                }

                if (spList.size() > 0) {
                    spID = spList[0].id;
    
                    spList[0].status__c = 'Failed';
                    spList[0].Execute_End__c = system.now();
                    update spList;
    
                } else {
                    spID = null;
                }
            }


            //Call_Log__c CL = new Call_Log__c();
            //CL.request_start_time__c = startTime;
            endPoint = ContractFunction.endpoint_x;

            //-- old version
            //CL.Request_Message__c = String.valueof('Contract' + Contract5 + '  ' + SAPContract);
            //CL.response_message__c = String.valueof(returnMessage);
            //if successful hit,Call log will be defined here

            //-- new version
            requestMessage = '{"Contract5" :' + JSON.serialize(Contract5) + ', "SAPContract" : ' + JSON.serialize(SAPContract) + '}';
            responseMessage = JSON.serialize(Contract4);

            system.debug('============ contractItemList : ' + contractItemList);

            update contractTicketRec; //update C;
            update contractItemList; //update CI;

            
            /*
                //--tambahan informasi : 21 September 2020
            cl.contract_ticket_related__c = contractTicketRec.id;

            if (CTIList.size() > 0)
                cl.contract_ticket_item_related__c = CTIList[0].id;

            ID spID = null;
            
            if (spList.size() > 0) spID = spList[0].id;
            else spID = null;

            cl.Scheduled_Process_Related__c = spID;

            insert CL;*/

        } catch (exception e) {

            //-- put infofrmation for CALL-LOG
            requestMessage = '{"Contract5" :' + JSON.serialize(Contract5) + ', "SAPContract" : ' + JSON.serialize(SAPContract) + '}';
            responseMessage = JSON.serialize(Contract4);
            endPoint = ContractFunction.endpoint_x;
            responseMessage = e.getmessage() + ' **** ' + e.getstacktracestring() + ' #### ' + JSON.serialize(Contract4); 
            callType = 'Callout';
            callStatus = 'Failed';


            if (spList.size() > 0) {
                spID = spList[0].id;

                spList[0].status__c = 'Failed';
                spList[0].Execute_End__c = system.now();
                update spList;

            } else {
                spID = null;
            }

            errorMessage = 'An Error occured on HitContractByContractTicketItem Method. Message :' + e.getmessage() + 
                                ' - StacktraceString : ' + e.getStacktraceString() + 
                                ' - Line Number :' + e.getLineNumber();

			
			
            contractTicketRec.TicketStatus__c = 'Review By Contract Manager';
            update contractTicketRec;
           

            //-- SEND EMAIL NOTIFICATION FOR ERROR
            Send_Email__c sendEmailObj = new Send_Email__c();
            list < user > useradmin = [SELECT id from user where ProfileID =: system.label.Profile_ID_System_Administrator];
            list < user > useradmin2 = [SELECT id from user where email =: system.label.System_Admin_Email];

            String AllMessage = '';
            if (useradmin.size() != 0) {
                //send email if failed to system admin
                sendEmailObj.User_Receiver__c = useradmin[0].id;
                if (useradmin2.size() != 0)
                    sendEmailObj.User_Receiver_2__c = useradmin2[0].id;
                
                sendEmailObj.Subject__c = 'Error at Contract Creation at ' + system.now();
                sendEmailObj.status__c = 'New';
                sendEmailObj.to_email_1__c = 'OperationRevenueManagement@xl.co.id';     //TODO : add to custom setting
                sendEmailObj.to_email_2__c = 'OperationGovernanceDS@xl.co.id';          //TODO : add to custom setting

                AllMessage = AllMessage + '  Error System : ' + e.getmessage() + '  ' + e.getstacktracestring() + '<br>';
                AllMessage = AllMessage + '  Contract Ticket Name         : ' + contractTicketRec.Name + '<br>';
                AllMessage = AllMessage + '  Contract Header              : ' + contractHeaderNo + '<br>';

                // sample url : https://cs72.lightning.force.com/lightning/r/Contract_Ticket__c/a0X5D000000qS4iUAE/view
                // ContractTicketID, String ContractHeaderID, string jobID
                string url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/Contract_Ticket__c/' + ContractTicketID + '/view';
                AllMessage = AllMessage + '  Contract Ticket link : ' + url;

                sendEmailObj.Message_Body__c = AllMessage;
                insert sendEmailObj;
            }

            //-- PUT ERROR info in LOG ERROR
            AppUtils.putError('An Error occured when salesfore call the API of Contract creation/Updating (SAP). HitContractByContractTicketItem Method::' + AllMessage  + '::' + e.getLineNumber());

        }

        //-- update transaction number
        update settings;


        //-- PUT CALL LOG INFORMATION
        Call_Log__c callLogObj = new Call_Log__c();

        callLogObj.request_start_time__c = startTime;
        callLogObj.endpoint__c = endPoint;
        callLogObj.type__c = callType;
        callLogObj.callerFrom__c = 'Salesforce';
        callLogObj.request_message__c = requestMessage;
        callLogObj.response_message__c = responseMessage;
        callLogObj.error_message__c = errorMessage;
        callLogObj.request_ID__c = requestID;
        callLogObj.status__c = callStatus;

        //-- RELATED links -----------------------------------------------------##
        callLogObj.salesforce_id_1__c = ContractTicketID;
        callLogObj.salesforce_id_2__c = ContractTicketItemID;
        callLogObj.salesforce_id_3__c = jobID;

        //-- Contract Ticket related link
        callLogObj.contract_ticket_related__c = contractTicketRec.id;

        if (CTIList.size() > 0)
            //-- Contract Ticket ITEM related link
            callLogObj.contract_ticket_item_related__c = CTIList[0].id;

        //-- Scheduled Process related link
        callLogObj.Scheduled_Process_Related__c = spID;
        // ---------------------------------------------------------------------##

        callLogObj.response_end_time__c = system.now();

        insert callLogObj;





    }
  
}