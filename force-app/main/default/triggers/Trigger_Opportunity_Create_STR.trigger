/*  
  Modified by : David W
  08 Oct 2019
*/

/*  
  Modified by : David W
  14 Oct 2019 actual closed date to now
*/
trigger Trigger_Opportunity_Create_STR on Opportunity (after update) {
 if (label.Is_Trigger_Opportunity_Create_STR_On == 'YES') {
    List<Id> oppIdsWBA = new List<Id>(); //Opportunity untuk wba wfc
    List<Id> oppIdsCW = new List<Id>(); //Opportunity untuk closed won
    List<Id> oppgetIds = new List<Id>(); //Opportunity buat get it oppIds
    List<Id> oppDelIds = new List<Id>(); //Opportunity buat del oppIds

    String Profamily;
    String ProductCode;
    String Service_Type;
    String tmpNIK;
    String tmpCompany;
    String tmpCompanyBPHO;
    String OwnerID;
    String OwnerNIK;
    Date tmpSendtoSalesdate;
    Date tmpSubmittoORM;
    Date tmpSendtoFinancedate;
    String Forecast = System.Label.Forecast;
    String Forecast_detail = System.Label.Forecast_Detail;
    
    List <Sales_Target_and_Revenue__c> STRToInsert = new List <Sales_Target_and_Revenue__c> ();
    Sales_Target_and_Revenue_Detail__c strd = new Sales_Target_and_Revenue_Detail__c();
    
    List<Sales_Target_and_Revenue__c> tmpSTRList = new List<Sales_Target_and_Revenue__c>();
    List<Sales_Target_and_Revenue_Detail__c> tmpSTRDList = new List<Sales_Target_and_Revenue_Detail__c>();
    List<Sales_Target_and_Revenue_Detail__c> tempSTRDetaillist  = new List<Sales_Target_and_Revenue_Detail__c>();
    
    Map <String, ID> strUniqueIDMap = new Map <String, ID>();
    Map <ID, String> productCodeMap = new Map <ID, String>();
    Map <ID, String> productFamilyMap = new Map <ID, String>();
    
    for (Opportunity oppNew:system.trigger.new)
    {
        oppgetIds.add(oppNew.id);

    }
    system.debug('===== oppgetIds : ' + oppgetIds );
    //get product
    List<OpportunityLineItem> allOLI = [SELECT id,opportunityid,ProductCode,opportunity.owner.IsActive,opportunity.owner.Employee_ID__c, Product2.Family FROM OpportunityLineItem WHERE OpportunityId in: oppgetIds];
    system.debug('===== allOLI : ' + allOLI );
    for (OpportunityLineItem OLI: allOLI) {
        /*str.Product_Family__c=OLI.Product2.Family;
        strd.Product_Family__c=OLI.Product2.Family;
        strd.Product_Code__c=OLI.ProductCode;*/
        system.debug('====isi productCodeMap.get(OLI.opportunityid)'+productCodeMap.get(OLI.opportunityid));
        if(productCodeMap.get(OLI.opportunityid)==null)
        {
            productCodeMap.put(OLI.opportunityid, OLI.ProductCode);
            productFamilyMap.put(OLI.opportunityid, OLI.Product2.Family);
        }
        
        if(OLI.opportunity.owner.IsActive) {
                ownerID = OLI.opportunity.Ownerid;
                ownerNIK = OLI.opportunity.Owner.Employee_ID__c;
            } else if (OLI.opportunity.owner.IsActive == false) {
                ownerID = system.label.User_ID_System_Administrator;
                ownerNIK = system.label.User_NIK_System_Administrator;
            }
    }
        
    
        for (Opportunity oppNew:system.trigger.new) 
        {
            Opportunity oppOld=Trigger.oldMap.get(oppNew.id);
            Sales_Target_and_Revenue__c str = new Sales_Target_and_Revenue__c(); //instantiate the object to put values for future record
            //Upsert Waiting for BA
            if (((oppOld.stageName!= 'Waiting for BA' && oppNew.stageName== 'Waiting for BA' && oppNew.Service_Type__c!='Simcard Order')||
                (oppOld.stageName!= 'Waiting for Contract' && oppNew.stageName== 'Waiting for Contract' && oppNew.Service_Type__c!='Simcard Order')
                )||
                ((oppOld.stageName== 'Waiting for BA'||oppOld.stageName== 'Waiting for Contract')&&
                (oppOld.stageName ==oppNew.stageName)&&
                (oppOld.OwnerID!=oppNew.OwnerID)
                )) 
            {
                
                Date d = date.today(); //date send to finance
                //Date d = tmpSendtoSalesdate; //date Waiting for BA
                Integer quarterEndMonth = d.AddMonths(1).month();
                Date quarterEnd = Date.newInstance(d.year(), quarterEndMonth , 1);
                system.debug('===== quarterEnd : ' + quarterEnd );
 
                Integer tempMonth = quarterEnd.month();
                Integer tempYear = quarterEnd.year();
                string productfamily=productFamilyMap.get(oppNew.Id);
                string strUniqueID =OwnerNIK+'-Forecast-'+productfamily+'-'+tempMonth+'-'+tempYear;
                string strID = strUniqueIDMap.get(strUniqueID);
                if(strID==null){
                    
                    //bagian STR
                    str.AM__c= OwnerID;
                    str.NIK__c=OwnerNIK;
                    str.User__c= OwnerID;
                    //str.Product_Family__c= oppNew.Product_Family__c;
                    str.Product_Family__c= productFamilyMap.get(oppNew.Id);
                    str.Date__c=quarterEnd;
                    str.Type__c= 'Forecast';
                    str.RecordTypeId = Forecast;
                    str.Unique_ID__c=OwnerNIK+'-Forecast-'+productFamilyMap.get(oppNew.Id)+'-'+tempMonth+'-'+tempYear;
                    tmpSTRList.add(str);
                    
                    //Bagian STR Details
                    strd.AM__c= OwnerID;
                    strd.NIK__c=OwnerNIK;
                    strd.Invoicing_Company__c=oppNew.AccountId;
                    //strd.Product_Code__c=oppNew.Product_Code__c;
                    strd.Product_Code__c= productCodeMap.get(oppNew.Id);
                    strd.Product_Family__c= productFamilyMap.get(oppNew.Id);
                    //strd.Product_Family__c=oppNew.Product_Family__c;
                    strd.Date__c=quarterEnd;
                    strd.Type__c= 'Forecast';
                    strd.Forecast_Type__c= 'Pipeline';
                    strd.RecordTypeId = Forecast_detail;
                    strd.Opportunity_status__c=oppNew.stageName;
                    strd.Amount__c=oppNew.Amount;
                    strd.Opportunity__c=oppNew.Id;
                    strd.Unique_ID__c=oppNew.Id;
                    tmpSTRDList.add(strd);
                    oppIdsWBA.add(oppNew.id);
                }

            }//end if
            
            //Closed Won
            if((oppOld.stageName!= 'Closed Won' && oppNew.stageName== 'Closed Won' && oppNew.Service_Type__c!='Simcard Order')
                ||
                ((oppOld.stageName== 'Closed Won')&&
                (oppOld.stageName ==oppNew.stageName)&&
                (oppOld.OwnerID !=oppNew.OwnerID)
                )) 
            {
                Date d = date.today(); //date send to finance
                //Date d = tmpSendtoSalesdate; //date Waiting for BA
                Integer quarterEndMonth = d.AddMonths(1).month();
                Date quarterEnd = Date.newInstance(d.year(), quarterEndMonth , 1);
                system.debug('===== quarterEnd : ' + quarterEnd );
 
                //Integer tempMonth = oppNew.Actual_Closed_Date__c.month();
                //Integer tempYear = oppNew.Actual_Closed_Date__c.year();
                
                Date ActualDate = date.today();
                
                Integer tempMonth = ActualDate.month();
                Integer tempYear = ActualDate.year();
                
                string productfamily=productFamilyMap.get(oppNew.Id);
                string strUniqueID =ownerID+'-Forecast-'+productfamily+'-'+tempMonth+'-'+tempYear;
                //string strUniqueID =oppNew.Owner.Employee_ID__c;+'-Forecast-'+productFamilyMap.get(oppNew.Id)+'-'+tempMonth+'-'+tempYear;
                string strID = strUniqueIDMap.get(strUniqueID);
                if(strID==null){

                    //bagian STR
                    str.AM__c= OwnerID;
                    str.NIK__c=OwnerNIK;
                    str.User__c= OwnerID;
                    //str.Product_Family__c= oppNew.Product_Family__c;
                    str.Product_Family__c= productFamilyMap.get(oppNew.Id);
                    //str.Date__c=oppNew.Actual_Closed_Date__c;
                    str.Date__c=ActualDate;
                    str.Type__c= 'Forecast';
                    str.RecordTypeId = Forecast;
                    str.Unique_ID__c=OwnerNIK+'-Forecast-'+productFamilyMap.get(oppNew.Id)+'-'+tempMonth+'-'+tempYear;
                    tmpSTRList.add(str);
                    
                    //Bagian STR Details
                    strd.AM__c= OwnerID;
                    strd.NIK__c=OwnerNIK;
                    strd.Invoicing_Company__c=oppNew.AccountId;
                    //strd.Product_Code__c=oppNew.Product_Code__c;
                    //strd.Product_Family__c=oppNew.Product_Family__c;
                    strd.Product_Code__c= productCodeMap.get(oppNew.Id);
                    strd.Product_Family__c= productFamilyMap.get(oppNew.Id);
                    //strd.Date__c=oppNew.Actual_Closed_Date__c;
                    strd.Date__c=ActualDate;
                    strd.Type__c= 'Forecast';
                    strd.Forecast_Type__c= 'Pipeline';
                    strd.RecordTypeId = Forecast_detail;
                    strd.Opportunity_status__c=oppNew.stageName;
                    strd.Amount__c=oppNew.Amount;
                    strd.Opportunity__c=oppNew.Id;
                    strd.Unique_ID__c=oppNew.Id;
                    tmpSTRDList.add(strd);
                    oppIdsCW.add(oppNew.id);
                }
            }
            //Stepback to before WBA
            if ((oppOld.stageName == 'Waiting for BA'||oppOld.stageName == 'Closed Won' ||oppOld.stageName == 'Waiting for Contract') && oppNew.stageName != 'Closed Won' && oppNew.stageName != 'Waiting for BA' && oppNew.stageName != 'Waiting for Contract' && oppNew.Service_Type__c!='Simcard Order') {
                
                oppDelIds.add(oppNew.id);
                
            }
      }//end for PR
      
      
            //insert STR
      if (tmpSTRList.size()>0) {
          try {
                Date dt = date.today();
                
                STR_Main_Controller SMC = new STR_Main_Controller();
                //wba+wfc
                if(oppIdsWBA != null){
                    SMC.calculationOpportunity_WBA_WFC(oppIdsWBA, dt);
                }
                //
                else
                {
                    SMC.calculationOpportunity_ClosedWon(oppIdsCW, dt);
                }
             } catch (system.Dmlexception e) {
                string errMessageWBA = 'Error on create STRD Pipeline - Waiting for BA, Waiting for Contract. Record IDs : ' + oppIdsWBA+ '.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessageWBA );
                string errMessageWC = 'Error on create STRD Pipeline - Closed Won. Record IDs : ' + oppIdsCW+ '.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessageWC );
                AppUtils.putError(errMessageWBA );
                AppUtils.putError(errMessageWC );
            }//end try catch  
        } 
      /*
      //insert STR
      if (tmpSTRList.size()>0) {
          try {
                upsert tmpSTRList Unique_ID__c;
                for (Sales_Target_and_Revenue__c str : tmpSTRList ) {
                    strUniqueIDMap.put(str.Unique_ID__c, str.ID);
                    //strUniqueIDMap.put(str.NIK__c+'-'+Date.valueOf(str.Date__c)+'-'+str.Product_Family__c,str.Id);
                }
                tempSTRDetaillist = new List<Sales_Target_and_Revenue_Detail__c>(); //list temp untuk STR Detail 
                system.debug('===== tmpSTRDList: ' + tmpSTRDList);
                for (Sales_Target_and_Revenue_Detail__c SID: tmpSTRDList) {
                    Date tmpdate=Date.valueOf(SID.Date__c);
                    String tmpBLN=String.valueOf(tmpdate.month());
                    String tmpTHN=String.valueOf(tmpdate.year());
                    SID.Sales_Target_and_Revenue__c = strUniqueIDMap.get(SID.NIK__c+'-'+SID.Type__c+'-'+SID.Product_Family__c+'-'+tmpBLN+'-'+tmpTHN);
                    tempSTRDetaillist.add(SID);
                }
                
                List<Sales_Target_and_Revenue_Detail__c> toDel = new List<Sales_Target_and_Revenue_Detail__c>();
                toDel = [select id,Date__c from Sales_Target_and_Revenue_Detail__c where Opportunity__c =:oppIds];
                delete toDel;
                upsert tempSTRDetaillist Unique_ID__c;

            } catch (system.Dmlexception e) {
                string errMessage = 'Error on create STRD Pipeline - Waiting for BA, Waiting for Contract. Record IDs : ' + oppIds + '.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }//end try catch    
      }//end if cek null
      else{
            List<Sales_Target_and_Revenue_Detail__c> toDel = new List<Sales_Target_and_Revenue_Detail__c>();
            toDel = [select id from Sales_Target_and_Revenue_Detail__c where Opportunity__c =: oppDelIds];
            delete toDel;
      }
      */
   }//end if activation trigger
 }