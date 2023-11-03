/*  
  Modified by : David W
  11 Oct 2019
*/
trigger Trigger_Pending_Recurring_Create_STR on Pending_Recurring__c (after update) {
 if (label.Is_Trigger_PR_CreateSTR_On == 'YES') {
    List<Id> PRIdsSTS = new List<Id>(); //Pending Recurring
    List<Id> PRIdsSTF = new List<Id>(); //Pending Recurring
    List<Id> PRDelIds = new List<Id>(); //Opportunity buat del oppIds
    
    String Profamily;
    String ProductCode;
    String Service_Type;
    String tmpNIK;
    String tmpCompany;
    String tmpCompanyBPHO;
    String prOwnerStatus;
    String ownerID;
    String ownerNIK;
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
    
    
        for (Pending_Recurring__c prNew:system.trigger.new) 
        {
            Pending_Recurring__c prOld=Trigger.oldMap.get(prNew.id);
            Sales_Target_and_Revenue__c str = new Sales_Target_and_Revenue__c(); //instantiate the object to put values for future record
            //Upsert Send To Sales
             if (((prOld.Status__c!= 'Send To Sales' && prNew.Status__c== 'Send To Sales')||
                (prOld.Status__c!= 'Submit To ORM' && prNew.Status__c== 'Submit To ORM'))
                ||
                ((prOld.Status__c== 'Send To Sales'||prOld.Status__c== 'Submit To ORM')&&
                (prOld.Status__c ==prNew.Status__c)&&
                (prOld.OwnerID !=prNew.OwnerID)
                ))
            {

                Date d = date.today(); //date send to sales
                //Date d = tmpSendtoSalesdate; //date send to sales
                Integer quarterEndMonth = (((Math.ceil((Decimal.valueOf(d.month()) / 12) * 4))*3)).intValue(); //rumus get end of current quarter
                Date quarterEnd = Date.newInstance(d.year(), quarterEndMonth , 1);
                system.debug('===== quarterEnd : ' + quarterEnd );
 
                Integer tempMonth = quarterEnd.month();
                Integer tempYear = quarterEnd.year();
                
                prOwnerStatus=prNew.IsActiveUser__c;
                    if (prOwnerStatus=='Active') {
                        ownerID = prNew.OwnerId;
                        ownerNIK = prNew.Owner_NIK__c;
                    } else if (prOwnerStatus == 'Non-Active') {
                        ownerID = system.label.User_ID_System_Administrator;
                        ownerNIK = system.label.User_NIK_System_Administrator;
                    }
                
                string strUniqueID =ownerNIK+'-Forecast-'+prNew.Product_Family__c+'-'+tempMonth+'-'+tempYear;
                string strID = strUniqueIDMap.get(strUniqueID);
                if(strID==null){
                    //bagian STR
                    str.AM__c= ownerID;
                    str.NIK__c=ownerNIK;
                    str.User__c= ownerID;
                    str.Product_Family__c= prNew.Product_Family__c;
                    str.Date__c=quarterEnd;
                    str.Type__c= 'Forecast';
                    str.RecordTypeId = Forecast;
                    str.Unique_ID__c=ownerNIK+'-Forecast-'+prNew.Product_Family__c+'-'+tempMonth+'-'+tempYear;
                    tmpSTRList.add(str);
                    
                    //Bagian STR Details
                    strd.AM__c= ownerID;
                    strd.NIK__c=ownerNIK;
                    strd.Invoicing_Company__c=prNew.search_link__r.HO_ID__c;
                    strd.Product_Code__c=prNew.Product_Code__c;
                    strd.Product_Family__c=prNew.Product_Family__c;
                    strd.Date__c=quarterEnd;
                    strd.Type__c= 'Forecast';
                    strd.Forecast_Type__c= 'Pending Recurring';
                    strd.RecordTypeId = Forecast_detail;
                    strd.Pending_Recurring_Status__c=prNew.Status__c;
                    strd.Amount__c=prNew.Total_Revenue__c;
                    strd.Pending_Recurring__c=prNew.Id;
                    strd.Unique_ID__c=prNew.Id;
                    tmpSTRDList.add(strd);
                    PRIdsSTS.add(prNew.id);
                }

            }//end if
            
            //sent to finance
            if((prOld.Status__c!= 'Sent to Finance' && prNew.Status__c== 'Sent to Finance')
                ||
                ((prOld.Status__c== 'Sent to Finance')&&
                (prOld.Status__c ==prNew.Status__c)&&
                (prOld.OwnerID !=prNew.OwnerID)
                ))
            {
                Date d = date.today(); //date send to finance
                //Date d = tmpSendtoSalesdate; //date send to sales
                Integer quarterEndMonth = d.AddMonths(1).month();
                Date quarterEnd = Date.newInstance(d.year(), quarterEndMonth , 1);
                system.debug('===== quarterEnd : ' + quarterEnd );
 
                Integer tempMonth = quarterEnd.month();
                Integer tempYear = quarterEnd.year();
                
                 prOwnerStatus=prNew.IsActiveUser__c;
                    if (prOwnerStatus=='Active') {
                        ownerID = prNew.OwnerId;
                        ownerNIK = prNew.Owner_NIK__c;
                    } else if (prOwnerStatus == 'Non-Active') {
                        ownerID = system.label.User_ID_System_Administrator;
                        ownerNIK = system.label.User_NIK_System_Administrator;
                    }
                
                string strUniqueID =ownerNIK+'-Forecast-'+prNew.Product_Family__c+'-'+tempMonth+'-'+tempYear;
                string strID = strUniqueIDMap.get(strUniqueID);
                if(strID==null){
                    //bagian STR
                   
                    str.AM__c= ownerID;
                    str.NIK__c=ownerNIK;
                    str.User__c= ownerID;
                    str.Product_Family__c= prNew.Product_Family__c;
                    str.Date__c=quarterEnd;
                    str.Type__c= 'Forecast';
                    str.RecordTypeId = Forecast;
                    str.Unique_ID__c=ownerNIK+'-Forecast-'+prNew.Product_Family__c+'-'+tempMonth+'-'+tempYear;
                    tmpSTRList.add(str);
                    
                    //Bagian STR Details
                    strd.AM__c= ownerID;
                    strd.NIK__c=ownerNIK;
                    strd.Invoicing_Company__c=prNew.search_link__r.HO_ID__c;
                    strd.Product_Code__c=prNew.Product_Code__c;
                    strd.Product_Family__c=prNew.Product_Family__c;
                    strd.Date__c=quarterEnd;
                    strd.Type__c= 'Forecast';
                    strd.Forecast_Type__c= 'Pending Recurring';
                    strd.RecordTypeId = Forecast_detail;
                    strd.Pending_Recurring_Status__c=prNew.Status__c;
                    strd.Amount__c=prNew.Total_Revenue__c;
                    strd.Pending_Recurring__c=prNew.Id;
                    strd.Unique_ID__c=prNew.Id;
                    tmpSTRDList.add(strd);
                    PRIdsSTF.add(prNew.id);
                }
                if ((prOld.Status__c == 'Send To Sales'||prOld.Status__c == 'Submit To ORM' ||prOld.Status__c == 'Sent to Finance') && prNew.Status__c != 'Draft') {
                    PRDelIds.add(prNew.id);
                }
            }
      }//end for PR
      
            //insert STR
      if (tmpSTRList.size()>0) {
          try 
          {
                Date dt = date.today();
                
                STR_Main_Controller SMC = new STR_Main_Controller();
                
                if(PRIdsSTS!=null){
                    //send to sales+ submit to orm
                    SMC.calculationPendingRecurring_STS_STO(PRIdsSTS, dt);
                }
                else{
                    //sent to finance
                    SMC.calculationPendingRecurring_STF(PRIdsSTF, dt);
                }
           } catch (system.Dmlexception e) {
                string errMessageSTS = 'Error on create STRD Pending Recurring - Send to Sales, Submit to ORM. Record IDs : ' + PRIdsSTS + '.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessageSTS );
                string errMessageSTF = 'Error on create STRD Pending Recurring - Sent to Finance. Record IDs : ' + PRIdsSTF + '.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessageSTF );
                AppUtils.putError(errMessageSTS );
                AppUtils.putError(errMessageSTF );
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
                toDel = [select id,Date__c from Sales_Target_and_Revenue_Detail__c where Pending_Recurring__c =:PRIds];
                delete toDel;
                upsert tempSTRDetaillist Unique_ID__c;

            } catch (system.Dmlexception e) {
                string errMessage = 'Error on create STRD Pending Recurring - Send to Sales, Submit to ORM. Record IDs : ' + prIds + '.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }//end try catch    
      }//end if cek null
      else{
            List<Sales_Target_and_Revenue_Detail__c> toDel = new List<Sales_Target_and_Revenue_Detail__c>();
            toDel = [select id from Sales_Target_and_Revenue_Detail__c where Pending_Recurring__c =: PRDelIds];
            
            delete toDel;
      }*/
   }//end if activation trigger
 }