/*
  Created by : David W
  10 September 2019
*/
public class STR_Recurring_Controller {
public Blob csvFileBody{get;set;}
public string csvAsString{get;set;}
public String[] csvFileLines{get;set;}
public List<Sales_Target_and_Revenue__c> STRlist{get;set;} //List STR Upload
public List<Sales_Target_and_Revenue__c> tempSTRlist{get;set;} // List Temp STR
public List<Sales_Target_and_Revenue_Detail__c> tempSTRDetaillist{get;set;} // List Temp STR Detail  
public List<Sales_Target_and_Revenue_Detail__c> STRDetaillist{get;set;} //List STR Detail Upload
public List<Sales_Target_and_Revenue__c> InsertSTRlist{get;set;} //declare insert list STR
public List<Sales_Target_and_Revenue_Detail__c> InsertSTRlistdetail{get;set;} //declare insert list STR detail

class Wrap_Item { 
   public Sales_Target_and_Revenue__c str {get;set;}
   public Sales_Target_and_Revenue_Detail__c strdetail {get;set;}
   public string notes {get;set;}
}   
    
public list <Wrap_Item> strList2 {get;set;}
public list <Wrap_Item> wrpstrListDetail {get;set;}
    
public STR_Recurring_Controller(){
  csvFileLines = new String[]{};
  STRlist = New List<Sales_Target_and_Revenue__c>(); 
  STRDetaillist = New List<Sales_Target_and_Revenue_Detail__c>(); 
}

    
  public void importCSVFile(){
       system.debug('============ masuk doImportCSV =======');
       STRlist = New List<Sales_Target_and_Revenue__c>(); 
       STRDetaillist = New List<Sales_Target_and_Revenue_Detail__c>(); 
       
        
        List <String> dataLines = new List<String>(); //row csv
        Map < String, Integer > fieldNumberMap = new Map < String, Integer > (); //mapping field csv
        List<String> lstFieldNames = new List<String>(); //list field csv
        Map < String, Sales_Target_and_Revenue__c > STRMap = new Map < String, Sales_Target_and_Revenue__c > (); //mapping untuk STR
      
        Map < String, String > STRMapSFId = new Map < String, String > (); //mapping untuk STR
        tempSTRlist = new List<Sales_Target_and_Revenue__c>(); //list temp untuk STR
        tempSTRDetaillist = new List<Sales_Target_and_Revenue_Detail__c>(); //list temp untuk STR Detail
              
        strList2 = new list <Wrap_Item> ();
        wrpstrListDetail = new list <Wrap_Item> ();

        string tmpUser;
        string tmpNIK;
        string tmpBPNumber;
        string tmpInvoicingCompany;
        string tmpYear;
        string tmpMonth;
        string tmpdate;
        String tmpToBeForecast;
        String tmpTarget;
        String fieldValue;
        String tmpProduct_Family;
        String tmpProduct_Code;
        Integer fieldNumber;
        String Forecast = System.Label.Forecast;
        String Forecast_detail = System.Label.Forecast_Detail;

        try {
            system.debug('===== csvFileBody  : ' + csvFileBody );
            string fileDataAsString = csvFileBody.toString();
            system.debug('===== fileDataAsString  : ' + fileDataAsString );
            fileDataAsString = fileDataAsString.replace(';', ',');    //-- replace ';' into ','
            
            system.debug('===== fileDataAsString  : ' + fileDataAsString );
            
            //readCSVFile();
            dataLines  = fileDataAsString.split('\n');
            string[] csvFieldNames = dataLines[0].split(',');
            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                fieldNumberMap.put(csvFieldNames[i], i);
                lstFieldNames.add(csvFieldNames[i].trim());        
            }
            
            system.debug('===== dataLines : ' + dataLines);
            system.debug('===== csvFieldNames : ' + csvFieldNames);
            
            //-- get Salesforce ID from user
            List <string> tmpBPNumberList = new  List<String>();
            List <string> tmpNIKList = new  List<String>();
            for (Integer i = 1; i < dataLines.size(); i++) {
            system.debug('%%%%% loop i : ' + i);
                string[] csvRecordData = dataLines[i].split(',');
                //-- loop for FIELDS
                tmpUser = '';
                for (String fieldName: csvFieldNames) {
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    
                    if (fieldName.trim() == 'NIK') {
                        tmpNIK = fieldValue.trim().replace('\'','');
                        tmpNIKList.add (tmpNIK);
                    }
                    
                    if (fieldName.trim() == 'BP Number') {
                        tmpBPNumber = fieldValue.trim().replace('\'','');
                        tmpBPNumberList.add (tmpBPNumber);
                    }
                }
            }
            
            List<User> allUser = [SELECT Name, Id, Employee_ID__c FROM User WHERE Employee_ID__c =: tmpNIKList];
            Map<String, String> mapUserNIK = new Map<String, String>();
            for (User usr: allUser) {
              string userID = usr.ID;
              mapUserNIK.put(usr.Employee_ID__c, userID );
            }
            
            List<Account> allAcct = [SELECT Id, Name,Owner.Name,OwnerId,Owner.Employee_ID__c,BP_Number__c FROM Account WHERE BP_Number__c=: tmpBPNumberList];
            Map<String, String> mapBPNumber = new Map<String, String>();
            for (Account acct: allAcct) {
              string AccountID = acct.Id;
              mapBPNumber.put(acct.BP_Number__c, AccountID);
            }
            
            system.debug('%%%%% loop mapBPNumber : ' + mapBPNumber);
            List<string> linkIDList = new List<string> ();
            
            for (Integer i = 1; i < dataLines.size(); i++) 
            {
                system.debug('%%%%% loop i : ' + i);
                string[] csvRecordData = dataLines[i].split(',');
                //-- loop for FIELDS
                tmpUser = '';
                for (String fieldName: csvFieldNames) {
                    //-- get field value
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    
                     //NIK
                    if (fieldName.trim() == 'NIK') {
                        tmpNIK = fieldValue.trim().replace('\'','');
                        tmpUser = mapUserNIK.get(tmpNIK);
                    }
    
                    //BP Number
                    if (fieldName.trim() == 'BP Number') {
                        tmpBPNumber = fieldValue.trim().replace('\'','');
                        tmpInvoicingCompany = mapBPNumber.get(tmpBPNumber); 
                    }
                    system.debug('%%%%% loop tmpInvoicingCompany : ' + tmpInvoicingCompany);
                    //Year
                    if (fieldName.trim() == 'Year') {
                        tmpYear = fieldValue.trim().replace('\'',''); 
                    }    
                    
                    //Product Family
                    if (fieldName.trim() == 'Product_Family') {
                        tmpProduct_Family = fieldValue.trim().replace('\'',''); 
                    }
                    //Product Code
                    if (fieldName.trim() == 'Service') {
                        tmpProduct_Code = fieldValue.trim().replace('\'',''); 
                    }  
                    
                    //Date
                    if (fieldName.trim() == 'Jan' || fieldName.trim() == 'Feb'|| fieldName.trim() == 'Mar'|| fieldName.trim() == 'Apr'|| fieldName.trim() == 'May'|| fieldName.trim() == 'Jun'|| fieldName.trim() == 'Jul'|| fieldName.trim() == 'Aug'|| fieldName.trim() == 'Sept'|| fieldName.trim() == 'Okt'|| fieldName.trim() == 'Nov'|| fieldName.trim() == 'Dec') 
                    {
                                                
                        if (fieldName.trim() == 'Jan') {
                            tmpdate = tmpYear+'-01-1';
                            tmpMonth ='1';
                        }
                        if (fieldName.trim() == 'Feb') {
                            tmpdate = tmpYear+'-02-1';
                            tmpMonth ='2';
                        }
                        if (fieldName.trim() == 'Mar') {
                            tmpdate = tmpYear+'-03-1';
                            tmpMonth ='3';
                        }
                        if (fieldName.trim() == 'Apr') {
                            tmpdate = tmpYear+'-04-1';
                            tmpMonth ='4';
                        }
                        if (fieldName.trim() == 'May') {
                            tmpdate = tmpYear+'-05-1';
                            tmpMonth ='5';
                        }
                        if (fieldName.trim() == 'Jun') {
                            tmpdate = tmpYear+'-06-1';
                            tmpMonth ='6';
                        }
                        if (fieldName.trim() == 'Jul') {
                            tmpdate = tmpYear+'-07-1';
                            tmpMonth ='7';
                        }
                        if (fieldName.trim() == 'Aug') {
                            tmpdate = tmpYear+'-08-1';
                            tmpMonth ='8';
                        }
                        if (fieldName.trim() == 'Sept') {
                            tmpdate = tmpYear+'-09-1';
                            tmpMonth ='9';
                        }
                        if (fieldName.trim() == 'Okt') {
                            tmpdate = tmpYear+'-10-1';
                            tmpMonth ='10';
                        }
                        if (fieldName.trim() == 'Nov') {
                            tmpdate = tmpYear+'-11-1';
                            tmpMonth ='11';
                        }
                        if (fieldName.trim() == 'Dec') {
                            tmpdate = tmpYear+'-12-1';
                            tmpMonth ='12';
                        }

                        tmpToBeForecast=fieldValue.trim().replace('\'',''); //value forecast
                        
                        if(tmpToBeForecast!=''){
                            Sales_Target_and_Revenue__c STR = new Sales_Target_and_Revenue__c ();
                            Sales_Target_and_Revenue_Detail__c STRDetail = new Sales_Target_and_Revenue_Detail__c();
                            
                            //STR
                            STR.User__c = tmpUser;
                            STR.AM__c = tmpUser;
                            STR.NIK__c  = tmpNIK;
                            STR.Product_Family__c = tmpProduct_Family;
                            STR.Type__c = 'Forecast';
                            STR.Date__c = Date.valueOf(tmpdate);
                            STR.RecordTypeId = Forecast;
                            STR.Amount__c = Double.valueOf(tmpToBeForecast);
                            //STR.Target__c = Double.valueOf(tmpToBeForecast);
                            STR.Unique_ID__c = tmpNIK+'-'+STR.Type__c+'-'+tmpProduct_Family+'-'+tmpMonth+'-'+tmpYear;
                            
                            
                            //STR Details
                            STRDetail.AM__c = tmpUser;
                            STRDetail.NIK__c = tmpNIK;
                            STRDetail.Product_Family__c = tmpProduct_Family;
                            STRDetail.Product_Code__c = tmpProduct_Code;
                            STRDetail.Invoicing_Company__c = tmpInvoicingCompany;
                            STRDetail.Type__c = 'Forecast';
                            STRDetail.Forecast_Type__c='Recurring';
                            STRDetail.RecordTypeId = Forecast_detail;
                            //STRDetail.Forecast_Status__c = 'Recurring sent to finance';
                            STRDetail.Date__c = Date.valueOf(tmpdate);
                            STRDetail.Amount__c = Double.valueOf(tmpToBeForecast);
                            //STRDetail.Unique_ID__c = tmpNIK+'-'+STRDetail.Type__c+'-'+tmpProduct_Family+'-'+tmpProduct_Code+'-'+tmpMonth+'-'+tmpYear;
                            STRDetail.Unique_ID__c = tmpNIK+'-'+tmpBPNumber+'-'+STRDetail.Type__c+'-'+tmpProduct_Family+'-'+tmpProduct_Code+'-'+tmpMonth+'-'+tmpYear;
                            system.debug('===== STR : ' + i + ' : ' + STR);
                            STRlist.add(STR);
                            
                            //wrapping STR
                            Wrap_Item wrapItem = new Wrap_Item();
                            wrapItem.str=STR;
                            wrapItem.notes = 'Ok';
                            
                            system.debug('===== STRDetail : ' + i + ' : ' + STRDetail);
                            system.debug('===== STRDetail.AM__c : ' + i + ' : ' + STRDetail.AM__c);
                            system.debug('===== STRDetail.Invoicing_Company__c : ' + i + ' : ' + STRDetail.Invoicing_Company__c);
                            if (STRDetail.AM__c == null || STRDetail.Invoicing_Company__c== null) wrapItem.notes = 'NOT OK. check AM or Invoicing Company!';
                            
                            //isi wrap str
                            strList2.add (wrapItem);
                                                                                    
                            //add str detaillist
                            system.debug('===== STRDetail : ' + i + ' : ' + STRDetail);
                            STRDetaillist.add(STRDetail);
                            
                            //Mapping
                            STRMap.put(tmpNIK+'-'+Date.valueOf(tmpdate)+'-'+tmpProduct_Family,STR);
                            
                            system.debug('===== STR MAP : ' + i + ' : ' + STRMap);
                        }
                        
                    }
                }
            }
            //Debug STR Mapping
                for (String key : STRMap.keySet()){
                    Sales_Target_and_Revenue__c tmpSTR = (Sales_Target_and_Revenue__c) STRMap.get(key);
                    system.debug('+++++ key : ' + key);
                    system.debug('+++++ value : ' + STRMap.get(key));
                    
                    System.debug('field name is ' + tmpSTR);
                    //System.debug('Debug 1'+tmpNIK+'-'+Date.valueOf(tmpdate)+'-'+tmpProduct_Family)
                    System.debug('Debug 1 '+key + '::' + tmpSTR.NIK__c + Date.valueOf(tmpSTR.Date__c)+tmpSTR.Product_Family__c);
                    
                    //tempSTRlist=(Sales_Target_and_Revenue__c)tmpSTR;
                    tempSTRlist.add(tmpSTR);
                    
                 }
                    System.debug('tempSTRlist is ' + tempSTRlist);
                    //upsert tempSTRlist Unique_ID__c;
            
            //upsert STR
            Database.UpsertResult[] results = Database.upsert(tempSTRlist, Sales_Target_and_Revenue__c.Unique_ID__c);
            if (results != null){
                for(Integer index = 0, size = results.size(); index < size; index++) {
                    if(results[index].isSuccess()) {
                        if(results[index].isCreated()) {
                            System.debug(tempSTRlist[index].Unique_ID__c +' was created');
                            //ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.Info,results.size()+' was created');
                            //ApexPages.addMessage(successMessage);
                        } else {
                            System.debug(tempSTRlist[index].Unique_ID__c +' was updated');
                            //ApexPages.Message updateMessage = new ApexPages.Message(ApexPages.Severity.Confirm,results.size()+' was updated');
                            //ApexPages.addMessage(updateMessage);
                        }
                    }
                }
            }
            
            //get sf id
            for (Sales_Target_and_Revenue__c SID: tempSTRlist) {
                //SFId.Unique_ID__c = SID.NIK__c+'-'+Date.valueOf(SID.Date__c)+'-'+SID.Product_Family__c;
                STRMapSFId.put(SID.NIK__c+'-'+Date.valueOf(SID.Date__c)+'-'+SID.Product_Family__c,SID.Id);
                System.debug('STRMapSFId is ' + STRMapSFId);
            }
            
            //get str details
            for(Sales_Target_and_Revenue_Detail__c STD : STRDetaillist)
            {
                //Sales_Target_and_Revenue_Detail__c SFId = new Sales_Target_and_Revenue_Detail__c ();
                STD.Sales_Target_and_Revenue__c = STRMapSFId.get(STD.NIK__c+'-'+Date.valueOf(STD.Date__c)+'-'+STD.Product_Family__c);
                tempSTRDetaillist.add(STD);
                system.debug('===== STRMapSFIdvalue is : '+ ' : ' + STD.NIK__c+'-'+Date.valueOf(STD.Date__c)+'-'+STD.Product_Family__c);
                
                //wrapping STR detail
                Wrap_Item wrapItemDetail = new Wrap_Item();
                wrapItemDetail.strdetail=STD;
                wrapItemDetail.notes = 'Ok';
                
                wrpstrListDetail.add(wrapItemDetail);
                system.debug('===== wrapItemDetail : ' + wrapItemDetail);
            }
            system.debug('===== tempSTRDetaillist is : '+ ' : ' + tempSTRDetaillist);
            //upsert tempSTRDetaillist Unique_ID__c;
        }
        
        catch(exception e){
            //readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file. '+e.getMessage()+'+++'+e.getLineNumber());
            ApexPages.addMessage(errorMessage);
        }
               
        //getLinkList (changePriceID, mapDataEffectiveDate, mapDataToBeAutoRenewal);
  }
    public void insertCSVFile(){
        try {
            InsertSTRlistdetail = New List<Sales_Target_and_Revenue_Detail__c>();
            for (Wrap_Item CekWrap : wrpstrListDetail) {
                if (CekWrap.notes == 'Ok') {
                        InsertSTRlistdetail.add(CekWrap.strdetail);
                    }
                //InsertSTRlist
            }          
            Database.UpsertResult[] resultsdetail = Database.upsert(InsertSTRlistdetail, Sales_Target_and_Revenue_Detail__c.Unique_ID__c);
            if (resultsdetail != null){
                /*for(Integer index = 0, size = resultsdetail.size(); index < size; index++) {
                    if(resultsdetail[index].isSuccess()) {
                        if(resultsdetail[index].isCreated()) {
                            System.debug(tempSTRDetaillist[index].Unique_ID__c +' Detail was created');
                            ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.Info,resultsdetail.size()+' was created');
                            ApexPages.addMessage(successMessage);
                        } else {
                            System.debug(tempSTRDetaillist[index].Unique_ID__c +' Detail was updated');
                            ApexPages.Message updateMessage = new ApexPages.Message(ApexPages.Severity.Confirm,resultsdetail.size()+' was updated');
                            ApexPages.addMessage(updateMessage);
                        }
                    }
                }*/
                
                integer numberOfSuccess = 0 ; 
                for (Wrap_Item wi : wrpstrListDetail) {
                    if (wi.notes == 'Ok') {
                        wi.notes = 'Upload Success';
                        numberOfSuccess++;
                    }
                }
                
                ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.Info, numberOfSuccess +' data was upload success');
                ApexPages.addMessage(successMessage);
                
                system.debug ('=== wrpstrListDetail : ' + wrpstrListDetail);
            }
        
        } catch (Exception e) {
            System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
        }
    }
    public pagereference callpageredirect(){
        PageReference demoPage = new PageReference(label.Sales_Target_and_Revenue_Details_Forecast);
        //pageReference demoPage = new pageReference('/006');
        return demoPage;
    }
}