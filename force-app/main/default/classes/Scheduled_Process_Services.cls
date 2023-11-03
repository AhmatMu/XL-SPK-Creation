/**
 * @description       : 
 * @Test Class        : TEST_Scheduled_Process_Services
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 10-19-2023
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-14-2023   Novando Utoyo Agmawan   Initial Version
**/

global class Scheduled_Process_Services implements Schedulable{
    public string jobType = '';
    public string scheduledProcessID ='';
    
    global void execute(SchedulableContext sc) 
    {        
        
        system.debug('===== jobType : ' + jobType);
        
        List <Scheduled_Process__c > sps =  [
            SELECT id, type__c, Parameter1__c, Parameter2__c, Parameter3__c, Execute_Start__c, Execute_End__c 
            FROM Scheduled_Process__c 
            WHERE status__c='Waiting' 
                AND Createddate = TODAY 
                AND type__c != 'Callout Contract' 
            ORDER BY Execute_Plan__c asc limit 30 
        ];
        
        if (sps.size() >0) {
            for(Scheduled_Process__c SP:sps)
            {
                if (SP.type__c == 'Callout Contract') {
                    // call 
                    
                    /*    SP.status__c='In Progress';

                if(!test.isrunningtest())
                HitSAPSOAP_Contract.HitContractByHeader(SP.Parameter1__c, SP.Parameter2__c, SP.Parameter3__c);*/
                }
                
                if (SP.type__c=='Callout Link')
                {
                    SP.status__c='in progress';
                    
                    
                    REST_Callout_Update_Link.updatelink(SP.parameter1__c,SP.parameter3__c);
                }
                
                if (SP.type__c=='Callout Account')
                {
                    SP.status__c='in progress';
                    
                    
                    SyncBPToEasyOps.updateBP(SP.parameter1__c,SP.parameter3__c);
                }
                
                if (SP.type__c=='Replicate PR')
                {
                    SP.status__c='in progress';
                    
                    ReplicatePRToEasyOps.ReplicatePR(SP.parameter1__c,SP.parameter3__c);
                }
                
                //BatchUtilClass.futureMethodSample();
            }
            update SPs;
        }
        
        

        /**
         *  FOR HIT TO SAP RELATED TO CONTRACT (SOAP)
         * 
         */

        List <Scheduled_Process__c > sps2 =  [
            SELECT id, type__c, Parameter1__c, Parameter2__c, Parameter3__c, Execute_Start__c, Execute_End__c 
            FROM Scheduled_Process__c 
            WHERE status__c = 'Waiting' 
                AND Createddate = TODAY 
                AND (type__c = 'Callout Contract' OR type__c = 'Callout SO' )
                AND Scheduled_Process_Id__c = :scheduledProcessID 
            //ORDER BY Execute_Plan__c asc limit 1 
        ];
        
        if (sps2.size() >0) {
            for(Scheduled_Process__c SP : sps2)
            {
                
                
                SP.status__c='In Progress';
                
                if(!test.isrunningtest()) {
                    //-- TIDAK DIGUNAKAN LAGI : HitSAPSOAP_Contract.HitContractByHeader(SP.Parameter1__c, SP.Parameter2__c, SP.Parameter3__c);
                    
                    //-- 8 Januari 2021 by doddy
                    //-- using this method to do call api each contract ticket item
                    //-- there is any error in SAP if call api with multiple contract item in one package (because same header-id) 
                    //-- parameter1 : ContractTicketID
                    //-- paramater2 : ContractTicketItemID
                    //-- parameter3 : JobID

                    if (SP.type__c == 'Callout Contract') {
                        HitSAPSOAP_Contract.HitContractByContractTicketItem(SP.Parameter1__c, SP.Parameter2__c, SP.Parameter3__c);
                    }
                    else if (SP.type__c == 'Callout SO') {
                        REST_SAP_SO_Callout_v1.createSAPSoFreeMrc(SP.Parameter1__c,SP.Parameter2__c, SP.Parameter3__c);
                    }


                }
                
            }
            update SPS2;
        }
        
        
        /**
        * add by doddy : 06 May 2020
        * for GSM Tagging and Checking
        */
        
        system.debug ('========== scheduledProcessID : ' +  scheduledProcessID);       
        
        List <Scheduled_Process__c > generalSP =  [select id, type__c, Parameter1__c, Parameter2__c, Parameter3__c, 
                                                   Execute_Start__c, Execute_End__c 
                                                   from Scheduled_Process__c 
                                                   where id =:scheduledProcessID
                                                   //status__c='Waiting' 
                                                   //AND Createddate=TODAY 
                                                   //AND type__c = 'Callout GSMTagging' 
                                                   //AND type__c =: jobType
                                                   
                                                   order by Execute_Plan__c asc limit 1 ];
        
        system.debug ('========== generalSP : ' +  generalSP);       
        
        
        if (generalSP.size() >0) {
            //for(Scheduled_Process__c SP : generalSP) { 
            Scheduled_Process__c SP = generalSP[0];
            
            SP.status__c='In Progress';
            update SP;
            
            
            
            
            //-- GSMTagging ---------------------------------------------
            if (SP.type__c=='Callout GSMTagging' || SP.type__c=='Callout GSMUnTagging') {
                /** notes 
                    parameter1 : {orderid}	sample : 
                    parameter2 : sample: {"group_no":1,"data_limit":2}
                    */
                
                
                string orderID = SP.Parameter1__c;
                Data_Filter df = (Data_Filter) JSON.deserialize(SP.Parameter2__c, Data_Filter.class);
                
                system.debug('=========== orderID : ' + orderID);
                system.debug('=========== df.group_no : ' + df.group_no);
                system.debug('=========== df.data_limit : ' + df.data_limit);
                
                if (SP.type__c=='Callout GSMTagging') {
                    //-- OLD WAY : REST_Community.requestTaggingByGroup(orderID, df.group_no, df.data_limit, scheduledProcessID);
                    if(!test.isrunningtest()) 
                        REST_Tagging_Callout.requestTaggingByGroup(orderID, df.group_no, df.data_limit, scheduledProcessID);
                }    
                else if (SP.type__c=='Callout GSMUnTagging') {
                    if(!test.isrunningtest()) 
                        REST_UnTagging_Callout.requestUnTaggingByGroup(orderID, df.group_no, df.data_limit, scheduledProcessID);
                }
                
            }
            
            
            
            //-- GSMCheckTagging ---------------------------------------------
            if (SP.type__c=='Callout GSMTaggingCheck' || SP.type__c=='Callout GSMUnTaggingCheck' ) {  
                string orderID = SP.Parameter1__c;
                Data_Filter df = (Data_Filter) JSON.deserialize(SP.Parameter2__c, Data_Filter.class);
                
                if (SP.type__c=='Callout GSMTaggingCheck'  ) {
                    //-- OLD WAY : REST_Community.requestTaggingCheckByGroup (orderID, df.group_no, df.data_limit, scheduledProcessID);  
                    if(!test.isrunningtest())
                        REST_Tagging_Callout.requestTaggingCheckByGroup (orderID, df.group_no, df.data_limit, scheduledProcessID);
                }
                else if (SP.type__c=='Callout GSMUnTaggingCheck' ) {
                    if(!test.isrunningtest())
                        REST_UnTagging_Callout.requestUnTaggingCheckByGroup (orderID, df.group_no, df.data_limit, scheduledProcessID);
                }
            }
            
            
            
            //-- Check All Order_MSISDN Status ---------------------------------------------
            if (SP.type__c=='Check All Order_MSISDN Status') {
                try {
                    string orderID = SP.Parameter1__c;
                    OrderMSISDN.CheckOrderMSISDNStatus (orderID);
                    SP.status__c='Success';
                    update SP;  
                    
                }
                catch (Exception e) {
                    SP.status__c='Failed';
                    update SP;
                    
                    string errorMsg = 'Error on Scheduled_Process_Services.execute method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +'::' + e.getLineNumber();
                    apputils.puterror(errorMsg);
                    system.debug ('===== errorMsg : ' + errorMsg);
                }
                
            }
            //}
            
            update generalSP;
        }
    }
    
    class Data_Filter {
        integer group_no;
        integer data_limit;
    }
    
    
    
    
    
    
}