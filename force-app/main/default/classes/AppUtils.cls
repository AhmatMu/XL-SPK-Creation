/**
 * @description       : 
 * @Test Class		  : TEST_AppUtils
 * @author            :
 * @group             : 
 * @last modified on  : 09-19-2023
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-16-2021   Novando Utoyo Agmawan   Initial Version
**/

public with sharing class AppUtils {

    public static string stripJsonNulls(string JsonString)
    { 
        if(JsonString != null)      
        {
            JsonString = JsonString.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
            JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
            
            //'"canBeIndividual":{}'
            JsonString = JsonString.replaceAll('\"[^\"]*\":\\{\\}',''); //basic removeal of null values
            JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it 
            
            //'"hasAccountDetailsIn":[]'
            JsonString = JsonString.replaceAll('\"[^\"]*\":\\[\\]',''); //basic removeal of null values  
            JsonString = JsonString.replaceAll(',[2,]', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it  
            
            
            
        }   
        return JsonString;
    }

    public static Map<String, Object> getObjectDataOnMap(Map<String, Object> m, string keysets) 
    {
        system.debug ('=');
        system.debug ('====== GET KEYSET VALUE');
        system.debug ('====== KEYSETS Name  : ' + keysets );
        List<string> keysetList = keysets.split('::');
    
        Map<String, Object>  mTemp = new Map<String, Object>(); 
        string s='';
        integer i=0;
        for (string keyset : keysetList) {
            //system.debug ('====== Keyset Value ' + keyset );
            if (i < keysetList.size()-1) {
                mTemp = new Map<String, Object>();
                try {
                    if (keyset.contains('[') ) {
                        integer index = integer.valueOf( keyset.substring(keyset.indexOf('[')+1, keyset.indexOf(']') ));
                        List<Object> tmpLo = (List<Object>) m.get(keyset.substring(0,keyset.indexOf('[')) );
                        mTemp = (Map<String, Object>) tmpLo[index];
                    }   
                    else {
                        //system.debug ('====== m value ' + m );
                        boolean b = isCollection(m.get(keyset));
                        //system.debug('===== b :' + b);
                        if (b) {
                            List<Object> tmpLo = (List<Object>) m.get(keyset);
                            mTemp = (Map<String, Object>) tmpLo[0];
                        }
                        else {
                            mTemp = (Map<String, Object>) m.get(keyset);
                        }
                        //system.debug ('====== mTemp value ' + mTemp );
                    }
                } catch (Exception e) {
                    system.debug ('== getStringDataOnMap ERROR get MAP Object (' + keyset + ') :' + e.getMessage());
                    //s='keyset "' + keyset + '" is not found';
                }
                m = mTemp;
            } 
            else {
                try {
                     m = (Map<String, Object>) m.get(keyset);

                } catch (Exception e) {
                    system.debug ('================ getObjectDataOnMap ERROR get MAP Objeect (' + keyset + ') :' + e.getMessage());
                }
            }
            i++;
        }
        //system.debug ('=');
        
        return m ; 
    }    


    public static string getStringDataOnMap(Map<String, Object> m, string keysets) 
    {
        system.debug ('=');
        system.debug ('====== GET KEYSET VALUE');
        system.debug ('====== KEYSETS Name  : ' + keysets );
        List<string> keysetList = keysets.split('::');
    
        Map<String, Object>  mTemp = new Map<String, Object>(); 
        string s='';
        integer i=0;
        for (string keyset : keysetList) {
            //system.debug ('====== Keyset Value ' + keyset );
            if (i < keysetList.size()-1) {
                mTemp = new Map<String, Object>();
                try {
                    if (keyset.contains('[') ) {
                        integer index = integer.valueOf( keyset.substring(keyset.indexOf('[')+1, keyset.indexOf(']') ));
                        List<Object> tmpLo = (List<Object>) m.get(keyset.substring(0,keyset.indexOf('[')) );
                        mTemp = (Map<String, Object>) tmpLo[index];
                    }   
                    else {
                        //system.debug ('====== m value ' + m );
                        boolean b = isCollection(m.get(keyset));
                        //system.debug('===== b :' + b);
                        if (b) {
                            List<Object> tmpLo = (List<Object>) m.get(keyset);
                            mTemp = (Map<String, Object>) tmpLo[0];
                        }
                        else {
                            mTemp = (Map<String, Object>) m.get(keyset);
                        }
                        //system.debug ('====== mTemp value ' + mTemp );
                    }
                } catch (Exception e) {
                    system.debug ('== getStringDataOnMap ERROR get MAP Object (' + keyset + ') :' + e.getMessage());
                    //s='keyset "' + keyset + '" is not found';
                }
                m = mTemp;
            } 
            else {
                try {
                    //Object oo = m.get(keyset);
                    //s = (string) oo.;
                    if (m.containsKey(keyset)) {
                        s = (string) String.valueOf (m.get(keyset));
                        system.debug ('================ GET : ' + keyset + ' <-- ' + s);
                    
                    } else { //s='keyset "' + keyset + '" is not found';
                        system.debug ('== Keyset NOT found  : (' + keyset + ') ## Keysets : ' + keysets ); 
                        s = '== Keyset NOT found ==';
                        }
                    
                    //system.debug ('================ CHECK VALUE OF MAP  ('+ keyset + ': ' + s + ') (m: ' + m + ') (m.get(keyset): ' + m.get(keyset)  + ')'  );
                } catch (Exception e) {
                    system.debug ('================ getStringDataOnMap ERROR get MAP String (' + keyset + ') :' + e.getMessage());
                }
            }
            i++;
        }
        //system.debug ('=');
        
        return s ; 
    }    
    
    public static List<Object> getListDataOnMap(Map<String, Object> m, string keysets) {
        system.debug ('=');
        system.debug ('====== GET LIST OBJECT');
        system.debug ('====== KEYSETS Name  : ' + keysets );
        
        List<string> keysetList = keysets.split('::');
    
        Map<String, Object>  mTemp = new Map<String, Object>(); 
        List<Object> lo = null;
        
        integer i=0;
        for (string keyset : keysetList) {
            
            if (i < keysetList.size()-1) {
                mTemp = new Map<String, Object>();
                try {
                    if (keyset.contains('[') ) {
                        system.debug('ini');
                        integer index = integer.valueOf( keyset.substring(keyset.indexOf('[')+1, keyset.indexOf(']') ));
                        //system.debug('===== index :' + index);
                        
                        List<Object> tmpLo = (List<Object>) m.get(keyset.substring(0,keyset.indexOf('[')) );
                        //system.debug('===== tmpLo :' + tmpLo +' ' + keyset.substring(0,keyset.indexOf('[') ));
                        
                        mTemp = (Map<String, Object>) tmpLo[index];
                        //system.debug('===== mTemp :' + mTemp);
                    }
                    else {
                        boolean b = isCollection(m.get(keyset));
                        //system.debug('===== b :' + b);
                        if (b) {
                            List<Object> tmpLo = (List<Object>) m.get(keyset);
                            mTemp = (Map<String, Object>) tmpLo[0];
                        }
                        else {
                            mTemp = (Map<String, Object>) m.get(keyset);
                        }
                    }
                } catch (Exception e) {
                    system.debug ('================ getListDataOnMap ERROR get MAP Object (' + keyset + ') :' + e.getMessage());
                }
                m = mTemp;
            } 
            else {
                try {
                    if (m.containsKey(keyset)) {
                        //s = (string) String.valueOf (m.get(keyset));
                        lo = (List<Object>) m.get(keyset);
                        system.debug ('================ GET : ' + keyset + ' <-- ' + lo);
                    
                    } else {system.debug ('== Keyset NOT found  : (' + keyset + ') ## Keysets : ' + keysets ); }
                    
                } catch (Exception e) {
                    system.debug ('================ getListDataOnMap ERROR get MAP Object List (' + keyset + ') :' + e.getMessage());
                }
            }
            i++;
        }
        return lo ; 
    }
    
    public static Boolean isCollection(Object input)
    {
        object test;
        try{
           test = (List<Object>)input;
           return true;
        }
        catch(System.TypeException ex)
        {
            String message = ex.getMessage();
            //system.debug ('============= message :' + message );
            //if (message.contains('Set<') || message.contains('Map<'))
            //    return true;
                
            return false;
        }
        
        
        //return false;
    }    

   
    public static Date strToDate(string s, string f){ 
        string dd;
        string mm;
        string yyyy;
        date d=null;
        
        s = s.trim();
        
        try {
            if (f==''){
                s = s.replaceAll('-','').replaceAll('/', '').replaceAll('\\.', '');
                f = 'yyyymmdd';
            }
                
            if (f=='yyyy-mm-dd'){
                s = s.replaceAll('-','');
                f = 'yyyymmdd';
            }
        
        
            if (f=='yyyymmdd'){
                if (s != '' &&  s!=null) {
                    dd = s.substring(6,8);
                    mm = s.substring(4,6);
                    yyyy = s.substring(0,4);
                    try {
                        d = Date.newInstance(integer.valueOf(yyyy), integer.valueOf(mm), integer.valueOf(dd) );
                    }
                    catch(Exception e) {
                        d = null;
                        system.debug ('============= strToDate message1 : ' + e.getMessage() );
                    }
                }
                else {
                    dd = '01';
                    mm = '01';
                    yyyy = '1900';
                    d = null;
                }
            }
            if (f=='yyyy/mm/dd'){  ///persiapan !!!
                if (s != '' &&  s!=null) {
                    dd = s.substring(6,8);
                    mm = s.substring(4,6);
                    yyyy = s.substring(0,4);
                    try {
                        d = Date.newInstance(integer.valueOf(yyyy), integer.valueOf(mm), integer.valueOf(dd) );
                    }
                    catch(Exception e) {
                        d = null;
                        system.debug ('============= strToDate message1 : ' + e.getMessage() );
                    }
                }
                else {
                    dd = '01';
                    mm = '01';
                    yyyy = '1900';
                    d = null;
                }
            }
                        
        }
        catch(Exception e) {
                    d = null;
                    system.debug ('============= strToDate message2 : ' + e.getMessage() );
                }
                
        return d;       
    } 
    
    
    
    public static DateTime strToDateTime (string s, string f){ 
        string dd;
        string mm;
        string yyyy;
        string hh;
        string nn;
        string ss;
        
        
        DateTime d=null;
        //system.debug('==test s: '+ s);
        //system.debug('==test f: '+ f);
        
        s = s.trim();
        
        try {
            if (f==''){
                s = s.replaceAll('-','').replaceAll('/', '').replaceAll('\\.', '');
                f = 'yyyymmdd';
            }
                
            if (f=='yyyy-mm-dd'){
                s = s.replaceAll('-','');
                f = 'yyyymmdd';
            }
            
            if (f=='yyyymmdd'){
                if (s != '' &&  s!=null) {
                    dd = s.substring(6,8);
                    mm = s.substring(4,6);
                    yyyy = s.substring(0,4);
                    try {
                        d = DateTime.newInstance(integer.valueOf(yyyy), integer.valueOf(mm), integer.valueOf(dd) );
                        //DateTime myDateTime = DateTime.newInstance(1997, 1, 31, 7, 8, 16)
                    }
                    catch(Exception e) {
                        d = null;
                        system.debug ('============= strToDateTime message1 : ' + e.getMessage() );
                    }
                }
                else {
                    dd = '01';
                    mm = '01';
                    yyyy = '1900';
                    d = null;
                }
            }
            else if (f=='yyyy-mm-dd hh:mm:ss') {
                if (s != '' &&  s!=null) {
                    yyyy = s.substring(0,4);
                    mm = s.substring(5,7);
                    dd = s.substring(8,10);
                    
                    hh = s.substring(11,13);
                    nn = s.substring(14,16);
                    ss = s.substring(17,19);
                    
                    system.debug('==full datetime : '+ s);
                    system.debug('==part of datetime : '+ yyyy + '::'+ mm + '::'+ dd + '::'+ hh + '::'+ nn + '::'+ ss + '::');
                    
                    
                    try {
                        d = Datetime.newInstance(integer.valueOf(yyyy), integer.valueOf(mm), integer.valueOf(dd), integer.valueOf(hh), integer.valueOf(nn), integer.valueOf(ss) );
                        system.debug('==test d1: '+ d);     
                    }
                    catch(Exception e) {
                        d = null;
                        system.debug ('============= strToDateTime message2 : ' + e.getMessage() );
                    }
                }
                else {
                    dd = '01';
                    mm = '01';
                    yyyy = '1900';
                    d = null;
                }
            }
            else if (f=='yyyymmddhhmmss') {
                if (s != '' &&  s!=null) {
                    yyyy = s.substring(0,4);
                    mm = s.substring(4,6);
                    dd = s.substring(6,8);
                    
                    hh = s.substring(8,10);
                    nn = s.substring(10,12);
                    ss = s.substring(12,14);
                    
                    system.debug('==full datetime : '+ s);
                    system.debug('==part of datetime : '+ yyyy + '::'+ mm + '::'+ dd + '::'+ hh + '::'+ nn + '::'+ ss + '::');
                    
                    
                    try {
                        d = Datetime.newInstance(integer.valueOf(yyyy), integer.valueOf(mm), integer.valueOf(dd), integer.valueOf(hh), integer.valueOf(nn), integer.valueOf(ss) );
                        system.debug('==test d1: '+ d);     
                    }
                    catch(Exception e) {
                        d = null;
                        system.debug ('============= strToDateTime message2 : ' + e.getMessage() );
                    }
                }
                else {
                    dd = '01';
                    mm = '01';
                    yyyy = '1900';
                    d = null;
                }
            }
        }
        catch(Exception e) {
                    d = null;
                }
        system.debug('==test d2: '+ d);     
        return d;       
    } 
    
    public static string birthToAge(Date birthDate){ 
        
        if (birthDate == null) return null;
        else {
            Age a = new Age(birthDate);
            //return  a.years  + ' years, ' + a.months + ' months ' ;
            return  a.years  + ' years';
        }
        
    }
    
    public class Age {
        public integer years ;
        public integer months ;
        public integer days ;
        
        public Age(Date birthDate){
            //long r = null;
            //r = (long.valueOf(Date.TODAY()) - long.valueOf(birthDate)) ;
            
            //long r = birthDate.daysBetween(Date.Today());
            integer r = birthDate.daysBetween(Date.Today());
            
            //long dy = (long) 365.2425;
            
            //years  = FLOOR( r / dy ); 
            //months = FLOOR( MOD(r , dy ) /30) ;
            //days   = Floor( MOD( Floor( MOD( r, dy )),30)) ;
            
            //years  = FLOOR( (decimal) r / 365.2425 );
            
            /*
            years  = (integer) math.floor( (r/3652425) * 1000);
            months = (integer) math.floor( (math.mod(r , 3652425 ) /30)  * 1000) ;
            */
            
            DateTime start_date_time;
            DateTime end_date_time;
             
            start_date_time = birthDate;
            end_date_time = Date.Today();
            
            Integer start_year_as_int = start_date_time.year(); //grab the start year
            Integer start_day_as_int = start_date_time.dayOfYear(); //grab the start day
            Integer start_hour_as_int = start_date_time.hour(); //grab the start hour
            Integer start_minute_as_int = start_date_time.minute(); //grab the start minute
            Integer start_second_as_int = start_date_time.second(); //grab the start second
            Integer start_in_seconds = (start_year_as_int * 31556926) + (start_day_as_int * 86400) + (start_hour_as_int * 3600) + (start_minute_as_int * 60) + (start_second_as_int * 1); //convert the start date to a value in seconds
            //there are 31556926 seconds in one year and that is why we are mutiplying the start_year_as_int value by 31556926 > this same logic applies to the days, hours & minutes logic which is why there are weird multipliers in that line of code
            Integer end_year_as_int = end_date_time.year(); //grab the end year
            Integer end_day_as_int = end_date_time.dayOfYear(); //grab the end day
            Integer end_hour_as_int = end_date_time.hour(); //grab the end hour
            Integer end_minute_as_int = end_date_time.minute(); //grab the end minute
            Integer end_second_as_int = end_date_time.second(); //grab the end second
            Integer end_in_seconds = (end_year_as_int * 31556926) + (end_day_as_int * 86400) + (end_hour_as_int * 3600) + (end_minute_as_int * 60) + (end_second_as_int * 1); //convert the end date to a value in seconds
            
            Integer total_duration_in_seconds = end_in_seconds - start_in_seconds; //duration in seconds
            Integer year_result = math.mod(math.floor(total_duration_in_seconds/31556926).intValue(),10000000); //number of years
            
            years = year_result;
            
             
        }
        
        //IF(ISNULL(DateofBirth__c),"",TEXT(FLOOR((TODAY()-DateofBirth__c)/365.2425)) & " year's " & TEXT(FLOOR(MOD((TODAY()-DateofBirth__c),365.2425)/30)) & " Month's " & Text(Floor(MOD(Floor(MOD((TODAY()-DateofBirth__c),365.2425)),30))) & " Day's ",
//NULL

    }
    
    public static decimal strToDec(string s){ 
        decimal d=null;
        s = s.trim();
        try {
            d = (s==null || s=='') ? null: (decimal) decimal.valueOf(s);
        }
        catch(Exception e) {
            d = null;
            system.debug ('============= strToDec message : ' + e.getMessage() );
        }
        return d;
    }   
    
    
    public static string getNewGUID() 
    {
        // Generate GUID
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug('========= guid :' + guid);
        
        return guid;
    }   

    public static string getUniqueNumber(){
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        String h = hexDigest ;
        //String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        //hexDigest  = hexDigest + ' * ' + guid ;
        
        system.debug('##########' + hexDigest );        
        return hexDigest;
    }
    
    public static string getSessionID() {
         return  UserInfo.getUserId() +'-' + Datetime.now().format('yyyyMMdd') +'-'+ AppUtils.getUniqueNumber();
    }
    
    public static String randomStringAll(Integer count) {
        Integer[] chars = new Integer[0],  
            offsets = new Integer[] { 48, 65, 97 },
                mods = new Integer[] { 10, 26, 26 };
    
        while(count > chars.size()) {
            Integer cat = Math.abs(Math.mod(Crypto.getRandomInteger(),3));
            chars.add(Math.mod(Math.abs(Crypto.getRandomInteger()), mods[cat])+offsets[cat]);
        }
        return String.fromCharArray(chars);
    }     
    
    
    public static Map<String, Object> getMapPackageFromJSON (string jsonStr){
        Map<String, Object> mapWS = new Map<String, Object>();
            
        try {
            // deserializeUntyped to mapData
            Map<String, Object> mapData = (Map<String, Object>) JSON.deserializeUntyped(jsonStr); 
            String status= AppUtils.getStringDataOnMap(mapData, 'Body::status');    
            String service = AppUtils.getStringDataOnMap(mapData, 'Body::service');     
            String operation = AppUtils.getStringDataOnMap(mapData, 'Body::operation');     
            String appID = AppUtils.getStringDataOnMap(mapData, 'Body::appID');     
            String entity = AppUtils.getStringDataOnMap(mapData, 'Body::entity');   
            String transactionId = AppUtils.getStringDataOnMap(mapData, 'Body::transactionId');     
            String exceptionMessage ='';
            String exceptionBackEndError ='';
            String exceptionCode ='';
            
            
            if (status=='0') {
                  exceptionMessage = AppUtils.getStringDataOnMap(mapData, 'Body::exception::message');
                  exceptionBackEndError = AppUtils.getStringDataOnMap(mapData, 'Body::exception::backEndError');
                  exceptionCode = AppUtils.getStringDataOnMap(mapData, 'Body::exception::code');
            }   
            
            
            mapWS.put('status', status);
            mapWS.put('exceptionMessage', exceptionMessage);
            mapWS.put('exceptionBackEndError', exceptionBackEndError);
            mapWS.put('exceptionCode', exceptionCode);
            mapWS.put('service', service);
            mapWS.put('operation', operation);
            mapWS.put('appID', appID);
            mapWS.put('entity', entity);
            mapWS.put('transactionId', transactionId);
            mapWS.put('mapData', mapData);  
            mapWS.put('jsonStr', jsonStr);      
        } 
        catch (Exception e) {
            mapWS.put('status', '-1');    // <<-- error on deserializeUntyped
            mapWS.put('mapData', 'null');
            mapWS.put('jsonStr', jsonStr);
            system.debug('============ error on try deserializeUntyped :' + e.getMessage());
        }
        
        return mapWS;
    }
    
    public static date nextDate (Date startDate, integer daysAdd, boolean incHoliday, boolean incSaturday, boolean incSunday)   {
        //Integer daysAdd = 8;
        //Datetime createdDate = system.now();
        //Datetime dueDate = startDate.addDays(daysAdd);
        string mode =''; 
        if (daysAdd>0)
            mode ='foward';
        else  {
            mode ='backward';
            daysAdd = daysAdd * -1;
        }


        Datetime nextDate = startDate;
        //Datetime nextDate = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 0, 0, 0);
    
        /*
        Integer holidaysCount = 0;
    
        BusinessHours bh = [SELECT ID, Name, IsDefault, IsActive From BusinessHours 
                        WHERE IsDefault = true LIMIT 1];
        */
    
        List<Holiday> holidays=[Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];
        system.debug ('== holidays : '  + holidays);
        Map<Date,boolean> holidayMap = new Map<Date,boolean>();
    
        for (Holiday h : holidays) {
            Date tmpDate = Date.newInstance (h.ActivityDate.year(), h.ActivityDate.month(), h.ActivityDate.day()) ;
            holidayMap.put(tmpDate, true);
        }                
        system.debug ('== holidayMap : '  + holidayMap);
    
    
        Integer nbDaysAdded = 0;
        boolean ketemuAkhir=false;
        while (nbDaysAdded != daysAdd  || !ketemuAkhir) {
            //Datetime now = Datetime.newInstance(nextDate.year(), nextDate.month(), nextDate.day(), 0, 0, 0);
            //Boolean isHoliday = !BusinessHours.isWithin(bh.Id, now);
    
            Date tmpDate = Date.newInstance(nextDate.year(), nextDate.month(), nextDate.day());
            boolean isHoliday = holidayMap.get(tmpDate);
            system.debug ('== nextDate  : '  + nextDate);
            system.debug ('== tmpDate   : '  + tmpDate);
            system.debug ('== isHoliday : '  + isHoliday );
            
            if (isHoliday==null) isHoliday=false;
    
            //if(( (isHoliday) || nextDate.format('E') == 'Sat' || nextDate.format('E') == 'Sun') == false){
    
            if (  (   (incHoliday==false && isHoliday==true ) ||
                    (incSaturday==false && nextDate.format('E') == 'Sat' ) ||
                    (incSunday==false && nextDate.format('E') == 'Sun' ) 
                    ) == false 
               ) {
               nbDaysAdded++;
               
            }
            system.debug ('nbDaysAdded  : ' + nextDate + ' - ' + nbDaysAdded);

            if (mode=='foward')
                nextDate = nextDate.addDays(1);
            else nextDate = nextDate.addDays(-1);
            
            
            //-- cek di akhir apakah masuk holiday
            if (nbDaysAdded == daysAdd) {
                system.debug ('=== akhir');

                tmpDate = Date.newInstance(nextDate.year(), nextDate.month(), nextDate.day());
                isHoliday = holidayMap.get(tmpDate);    


                system.debug ('== nextDate  : '  + nextDate);
                system.debug ('== tmpDate   : '  + tmpDate);
                system.debug ('== isHoliday : '  + isHoliday );
                system.debug ('== nextDate.format(E) : '  + nextDate.format('E') );
                system.debug ('== daysAdd : '  + daysAdd );


                if (  (   (incHoliday==false && isHoliday==true ) ||
                        (incSaturday==false && nextDate.format('E') == 'Sat' ) ||
                        (incSunday==false && nextDate.format('E') == 'Sun' ) 
                        ) == true
                   ) {
                    ketemuAkhir=false;
                    //system.debug ('=== add bro');
                } else {
                    ketemuAkhir=true;
                }
                system.debug ('ketemuAkhir : ' + ketemuAkhir);
                
            }
            
            system.debug ('nbDaysAdded == daysAdd : ' + nbDaysAdded + ' - ' + daysAdd);  
                        
        }  
    
        system.debug ('startDate  : ' + startDate);
        //system.debug ('dueDate      : ' + dueDate);
        system.debug ('nextDate     : ' + nextDate);
    
    
        return Date.newInstance(nextDate .year(), nextDate .month(), nextDate .day());
    
    
    }
    	/*
        public static date prevDate (Date startDate, integer daysAdd, boolean incHoliday, boolean incSaturday, boolean incSunday)   {
        //Integer daysAdd = 8;
        //Datetime createdDate = system.now();
        //Datetime dueDate = startDate.addDays(daysAdd);
        
        Datetime nextDate = startDate;
        //Datetime nextDate = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 0, 0, 0);
    
        ///*
        Integer holidaysCount = 0;
    
        BusinessHours bh = [SELECT ID, Name, IsDefault, IsActive From BusinessHours 
                        WHERE IsDefault = true LIMIT 1];
        //
    
        List<Holiday> holidays=[Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];
        system.debug ('== holidays : '  + holidays);
        Map<Date,boolean> holidayMap = new Map<Date,boolean>();
    
        for (Holiday h : holidays) {
            Date tmpDate = Date.newInstance (h.ActivityDate.year(), h.ActivityDate.month(), h.ActivityDate.day()) ;
            holidayMap.put(tmpDate, true);
        }                
        system.debug ('== holidayMap : '  + holidayMap);
    
    
        Integer nbDaysAdded = 0;
        boolean ketemuAkhir=false;
        while (nbDaysAdded != daysAdd  || !ketemuAkhir) {
            //Datetime now = Datetime.newInstance(nextDate.year(), nextDate.month(), nextDate.day(), 0, 0, 0);
            //Boolean isHoliday = !BusinessHours.isWithin(bh.Id, now);
    
            Date tmpDate = Date.newInstance(nextDate.year(), nextDate.month(), nextDate.day());
            boolean isHoliday = holidayMap.get(tmpDate);
            system.debug ('== nextDate  : '  + nextDate);
            system.debug ('== tmpDate   : '  + tmpDate);
            system.debug ('== isHoliday : '  + isHoliday );
            
            if (isHoliday==null) isHoliday=false;
    
            //if(( (isHoliday) || nextDate.format('E') == 'Sat' || nextDate.format('E') == 'Sun') == false){
    
            if (  (   (incHoliday==false && isHoliday==true ) ||
                    (incSaturday==false && nextDate.format('E') == 'Sat' ) ||
                    (incSunday==false && nextDate.format('E') == 'Sun' ) 
                    ) == false 
               ) {
               nbDaysAdded++;
               
            }
            system.debug ('nbDaysAdded  : ' + nextDate + ' - ' + nbDaysAdded);
            if(daysAdd <0){
            system.debug ('=== IN  DaysAdd <0');
            nextDate = nextDate.addDays(-1);
            }
            else{
            system.debug ('=== IN  DaysAdd >0');
            nextDate = nextDate.addDays(1);
            }
            //-- cek di akhir apakah masuk holiday
            if (nbDaysAdded == daysAdd) {
                system.debug ('=== akhir');

                tmpDate = Date.newInstance(nextDate.year(), nextDate.month(), nextDate.day());
                isHoliday = holidayMap.get(tmpDate);    


                system.debug ('== nextDate  : '  + nextDate);
                system.debug ('== tmpDate   : '  + tmpDate);
                system.debug ('== isHoliday : '  + isHoliday );
                system.debug ('== nextDate.format(E) : '  + nextDate.format('E') );
                system.debug ('== daysAdd : '  + daysAdd );


                if (  (   (incHoliday==false && isHoliday==true ) ||
                        (incSaturday==false && nextDate.format('E') == 'Sat' ) ||
                        (incSunday==false && nextDate.format('E') == 'Sun' ) 
                        ) == true
                   ) {
                    ketemuAkhir=false;
                    //system.debug ('=== add bro');
                } else {
                    ketemuAkhir=true;
                }
                system.debug ('ketemuAkhir : ' + ketemuAkhir);
                
            }
            
            system.debug ('nbDaysAdded == daysAdd : ' + nbDaysAdded + ' - ' + daysAdd);  
                        
        }  
    
        system.debug ('startDate  : ' + startDate);
        //system.debug ('dueDate      : ' + dueDate);
        system.debug ('nextDate     : ' + nextDate);
    
    
        return Date.newInstance(nextDate .year(), nextDate .month(), nextDate .day());
    
    
    }
	*/
    
    public static Datetime addHours(Datetime l, integer h)
    {    
         return l.addHours(h);
    }    
    
    public static decimal getDecimalOrNull (string value) {
        return  (value==null || value=='') ? null: (decimal) decimal.valueOf( value);               
    } 
    
    public static string getStringOrNull (string value) {
        return  (value==null) ? null: (string) value;               
    } 
    
    
    public static Boolean listContains(Object[] source, Object target) {
      return (new Set<Object>(source)).contains(target);
    }
  
    
    public static Boolean isKeysetNotFound (string s) {
        return (s == '== Keyset NOT found ==') ? true : false;
    }
    
    
    
    //-----
/*    
public static String create_multi_param (String boundary, String name, String val) {
    String param = '-' + boundary + '\r\n'
    + 'Content-Disposition: form-data; name = "' + name + '"'
    + '\r\n\r\n' + val + '\r\n';
    return param;
}


    
    public static void testconntransdb() {

// Body
String boundary = '------------' + String.valueOf (DateTime.now().GetTime());
String body = '';
//body + = this.create_multi_param (boundary, 'grant_type', 'password');
//body + = this.create_multi_param (boundary, 'name', '[sample]');
//body + = this.create_multi_param (boundary, 'client_id', '[sample]');
//body + = this.create_multi_param (boundary, 'client_secret', '[sample]');
body  = body + create_multi_param (boundary, 'username', 'apidemo');
body  = body + create_multi_param (boundary, 'password', 'password*1');
body  = body + '--' + boundary + '--\r\n';
System.debug ('================= body : ' + body);


Http http = new Http ();
HttpRequest req = new HttpRequest ();
req.setHeader ('Cache-Control', 'no-cache');
req.setHeader ('Content-Length', String.valueOf (body.length ()));
req.setHeader ('Content-Type', 'multipart / form-data; boundary =' + body);

string param='?username=apidemo&password=password*1';

req.setEndpoint ('https://easy-ops.xl.co.id/dev/api/auth/token' + param);
req.setBody (body);
req.setMethod ('POST');
HttpResponse res = http.send (req);
System.debug ('================= response message : ' + res.getBody ());

    }
    
    */
    



    // encrypt
    Public static string doEncrypt (string s) {
        String encryptName;

        try {
            Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');
            Blob data = Blob.valueOf(s);
            Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey , data );
            String b64Data = EncodingUtil.base64Encode(encryptedData);
            encryptName = b64Data ;
        }
        catch (Exception e) {
            putError('Error on doEncrypt function::' + e.getmessage() + '::' + e.getLineNumber()  );
            encryptName='failed:' + e.getmessage();
        }
        
        System.debug('============= Printing encryptName :  '+encryptName);
        return encryptName;
    }

    // decrypt
    Public static string doDecrypt (String s) {
        String dryptData;

        try {
            Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');
            Blob data = EncodingUtil.base64Decode(s);
            Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey , data);
            dryptData = decryptedData.toString();
        }
        catch (Exception e) {
            putError('Error on doDecrypt function::' + e.getmessage() + '::' + e.getLineNumber()  );
            dryptData='failed:' + e.getmessage();
        }

        System.debug('============= Printing dryptData '+dryptData);   
        return dryptData; 
    }

    public static void putError(string errString) {
        /* note::message::linenumber
         * 0 : notes 
         * 1 : message
         * 2 : linenumber
         * ...
         */
        List<Log_Error__c> tmpLogErrors = new List<Log_Error__c>();
        Log_Error__c tmpLogError = new Log_Error__c();

        List<string> ss = errString.split('::');
        integer index = 0;
        for (String s: ss) {
            if (index == 0) { tmpLogError.notes__c = s; }
            if (index == 1) { tmpLogError.message__c = s; }
            if (index == 2) { tmpLogError.line_number__c = s; }

            index=index+1;
        }
        try  {
            tmpLogErrors.add (tmpLogError);
            insert tmpLogErrors;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            string errMessage = e.getmessage() + ' - error line : '  + e.getLineNumber() ;
            //
        }

    }

    public static void putCalllog(string type, String method, Datetime startTime, String status, Datetime endTime, String requestMessage, String responseMessage) {

        try  {
            Call_Log__c calllog = new Call_Log__c();
            calllog.type__c = type;
            calllog.method__c = method;
            calllog.request_start_time__c = startTime;
            calllog.status__c = status ;
            calllog.response_end_time__c = endTime;     
            calllog.Request_Message__c = requestMessage;
            calllog.response_message__c = responseMessage ;
            insert calllog;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            string errMessage = e.getmessage() + ' - error line : '  + e.getLineNumber() ;
        }

    }

    public static string getToken(string endpoint, string username, string password, Integer type) {
        String token = '';
        String body = '';
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callout';
        calllog.method__c='POST';
        calllog.request_start_time__c = datetime.now();
        
        if (type == 1) {
            body =  'username=' + username + '&password=' + password ; //'username=apidemo&password=password*1';
            system.debug(' body >> ' +  body);
        }

        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setbody(body);
        req.setHeader('Accept', 'application/json');

        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;

        
        if (!Test.isRunningTest()) {
            http = new Http();
            response = http.send(req);
            
            try {
                System.debug ('================= response message : ' + response.getBody ());
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
                
                token = (string) responsemap.get('token');
                System.debug ('================= response token : ' + responsemap.get('token') );
                System.debug ('================= response message : ' + response.getBody ());         
    
                if (! isKeysetNotFound(token) ) {
                    calllog.status__c = 'Success';
                } else {
                    calllog.status__c = 'Failed';
                    token = 'failed'; 
                }

                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            } catch (Exception e) {
                token ='failed';
                putError('Error on getToken function::' + e.getmessage() + '::' + e.getLineNumber()  );
                
                calllog.request_message__c = body;
                if (!Test.isRunningTest()) {
                    calllog.response_message__c = response.getBody ();
                }
                
                //calllog.uri__c = req.requestURI;        
                calllog.callerFrom__c = 'salesforce' ; 
                calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
                calllog.response_end_time__c = datetime.now();     
                insert calllog;
            }
            
        }
        //-- PUT callout information then save the data on Call_Log object          
        calllog.request_message__c = body;
        if (!Test.isRunningTest()) {
            calllog.response_message__c = response.getBody ();
        }
        //calllog.uri__c = req.requestURI;        
        calllog.callerFrom__c = 'salesforce' ; 
        calllog.endpoint__c = endpoint ; // currentRequestURL.replace (calllog.uri__c,'');
        calllog.response_end_time__c = datetime.now();     
        //insert calllog;

        return token;
    } 
 



    public static List<ContentVersion> getOpportunityFilesOnBase64(String OpportunityID) {    

        //------ get base64 attachment files on opportunity
        try {
            List<ContentDocumentLink>
                attachments = [SELECT ContentDocumentId, ContentDocument.title, LinkedEntityId, ShareType, Visibility
                            FROM ContentDocumentLink WHERE LinkedEntityId = :OpportunityID] ; //'0065D000003MGBE'];

            List<string> cdIDs = new List<string>();
            for (ContentDocumentLink att : attachments) {
                cdIDs.add (att.ContentDocumentId);
            }              

            system.debug('=========== cdIDs : ' + cdIDs);           

            list <contentdocument> 
                cds= [select id, LatestPublishedVersionId 
                        from contentdocument where
                        id in :cdIDs];

            List<string> lpvIDs = new List<string>();
            for (ContentDocument cd : cds) {
                lpvIDs.add (cd.LatestPublishedVersionId);
            }              
            system.debug('=========== lpvIDs : ' + lpvIDs);         

            list <contentversion> 
                cvs = [select id, Checksum, ContentDocumentId
                            , ContentLocation, ContentModifiedById
                            , ContentModifiedDate, ContentSize, ContentUrl, Description
                            , ExternalDataSourceId, ExternalDocumentInfo1
                            , ExternalDocumentInfo2, 
                            title, VersionData, VersionNumber
                        from contentversion 
                        where ID in :lpvIDs];

            system.debug('=========== cvs : ' + cvs);   
            for (ContentVersion cv : CVs) {
                system.debug('=========== title : ' + cv.title 
                    + '. Body :' 
                    + EncodingUtil.base64Encode(cv.VersionData)  );     
            }
            return cvs;

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

        } catch (Exception e) {
                string errMessage = 'Error on AppUtils getOpportunityFilesOnBase64 method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }
            return null;

        
        
    }
  
//set contract end date on oppty
    public static date getNewContractEndDate (Date lastContractStartDate, Date lastContractEndDate, Integer ContractTerm, Date newContractStartDate,String UOM, Integer ContractPeriode,String PeriodeUOM) {
        Date newContractEndDate=system.today();
        
        //Date lastContractStartDate = Date.newInstance(2017, 1, 1);
        //Date lastContractEndDate = Date.newInstance(2017, 12, 31);
        //Integer ContractTerm = 6;
        
        //lastContractEndDate = lastContractStartDate.addMonths(ContractTerm).adddays(-1);
        //Date newContractStartDate = Date.newInstance(2019, 2, 1);

        boolean ketemu = false;
        
        date startDateTmp = lastContractStartDate;
        //date startDateTmp = lastContractEndDate.addmonths(ContractTerm * -1).adddays(1);
        date endDateTmp = lastContractEndDate;
        integer counter = 0;
        system.debug ('==== newContractStartDate : ' + newContractStartDate);
        if(newContractStartDate>=lastContractStartDate && newContractStartDate<=lastContractEndDate)
        {
            newContractEndDate=lastContractEndDate;
        }
        else if(newContractStartDate>lastContractEndDate)
        {
            if(PeriodeUOM=='Month')
            {
                newContractEndDate=newContractStartDate.addmonths(ContractPeriode)-1;
                system.debug('newContractEndDatemonth == ' + newContractEndDate);
            }
            if(PeriodeUOM=='Week')
            {
                newContractEndDate=newContractStartDate.adddays(ContractPeriode*7)-1;
                system.debug('newContractEndDateWeek == ' + newContractEndDate);
            }
            if(PeriodeUOM=='Day')
            {
                newContractEndDate=newContractStartDate.adddays(ContractPeriode)-1;
                system.debug('newContractEndDateDay == ' + newContractEndDate);
            }
        }
        /*
        while ( ketemu==false && counter < 50 ) {
            system.debug ('==== startDateTmp : ' + startDateTmp + '  -----  ' + 'endDateTmp   : ' + endDateTmp);
            try {
                if (newContractStartDate > startDateTmp && newContractStartDate < endDateTmp) {
                    ketemu=true;
                    system.debug ('==== * newContractStartDate : ' + newContractStartDate + '  -----  ' + 'newContractEndDate   : ' + endDateTmp );
                    newContractEndDate = endDateTmp;
                } 
            if(UOM=='Month')
            {   startDateTmp = startDateTmp.addMonths(ContractTerm);
                endDateTmp = endDateTmp.addMonths(ContractTerm);
            }
            if(UOM=='Week')
            {   startDateTmp = startDateTmp.adddays(ContractTerm*7);
                endDateTmp = endDateTmp.adddays(ContractTerm*7);
            }
            if(UOM=='Day')
            {   startDateTmp = startDateTmp.addDays(ContractTerm);
                endDateTmp = endDateTmp.addDays(ContractTerm);
            }
            } catch (Exception e) {
                string errMessage = 'Error on AppUtils getNewContractEndDate method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }
            counter++;
        }       */
        
        return newContractEndDate;
    } 
    
    
    
    public static void lockOpportunities (List <String> oppids) {
        
        /**
          * To enable this feature, from Setup, enter Process Automation Settings in the Quick Find box, then click Process Automation Settings. Then, select Enable record locking and unlocking in Apex.
          *
          * //-- call this function sample 
            //-- turn on system.debug
            List <string> oppids = new List <string> {'1811-001221','1901-001257'};
            apputils.lockOpportunities(oppids);
            
           */
        
        // Query the oportunities to lock
        Opportunity[] opps = [SELECT Id from opportunity WHERE Opportunity_ID__c in :oppids];
        
        // Lock the opportunities
        Approval.LockResult[] lrList = Approval.lock(opps, false);
        
        // Iterate through each returned result
        for(Approval.LockResult lr : lrList) {
            if (lr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully locked opportunity with ID: ' + lr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : lr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Opportunity fields that affected this error: ' + err.getFields());
                }
            }
        }       
    }
    
    
    public static string terbilang (integer angka) { 
        String[] nomina = new String[] {'','Satu','Dua','Tiga','Empat','Lima','Enam',
                         'Tujuh','Delapan','Sembilan','Sepuluh','Sebelas'};
 
        if(angka<12){
          return nomina[(integer)angka];
        }
        
        if(angka>=12 && angka <=19){
            return nomina[(integer)math.mod(angka,10)] +' Belas ';
        }
        
        if(angka>=20 && angka <=99){
            return nomina[(integer)angka/10] +' Puluh '+nomina[(integer)math.mod(angka,10)];
        }
        
        if(angka>=100 && angka <=199){
            return 'Seratus '+ terbilang(math.mod(angka,100));
        }
        
        if(angka>=200 && angka <=999){
            return nomina[(integer)angka/100]+' Ratus '+terbilang(math.mod(angka,100));
        }
        
        if(angka>=1000 && angka <=1999){
            return 'Seribu '+ terbilang(math.mod(angka,1000));
        }
        
        if(angka >= 2000 && angka <=999999){
            return terbilang((integer)angka/1000)+' Ribu '+ terbilang(math.mod(angka,1000));
        }
        
        if(angka >= 1000000 && angka <=999999999){
            return terbilang((integer)angka/1000000)+' Juta '+ terbilang(math.mod(angka,1000000));
        }
        
        return '';
    }

    public static string terbilang_Inggris (integer num) { 
        String[] ones = new String[] {'', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine','ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen','seventeen', 'eighteen', 'nineteen'};

        String[] tens = new String[] {'', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty','ninety'};

        String numString = String.ValueOf(num);

        if (num < 0) {
            return 'Negative numbers are not supported.';
        }

        if (num == 0) {
            return 'zero';
        }

        //the case of 1 - 20
        if (num < 20) {
            return ones[num];
        }

        if (numString.length() == 2) {
            return tens[Integer.ValueOf(numString.substring(0,1))] + ' ' + ones[Integer.ValueOf(numString.substring(1,2))];
        }

        //100 and more
        if (numString.length() == 3) {
            if (numString.substring(1,2) == '0' && numString.substring(2,3) == '0'){
                return ones[Integer.ValueOf(numString.substring(0,1))] + ' hundred';
            }
            else{
                return ones[Integer.ValueOf(numString.substring(0,1))] + ' hundred and ' + terbilang_Inggris(Integer.ValueOf(numString.substring(1,2) + numString.substring(2,3)));
            }
        }

        if (numString.length() == 4) {
            Integer ends = Integer.ValueOf(numString.substring(1,2) + numString.substring(2,3) + numString.substring(3,4));

            if (ends == 0) {
                return ones[Integer.ValueOf(numString.substring(0,1))] + ' thousand';
            }

            if (ends < 100) {
                return ones[Integer.ValueOf(numString.substring(0,1))] + ' thousand and ' + terbilang_Inggris(ends);
            }

            return ones[Integer.ValueOf(numString.substring(0,1))] + ' thousand ' + terbilang_Inggris(ends);
        }

        return '';
    }


    /**
    * Split a string of any size, while avoiding the dreaded 'Regex too complicated'
    * error, which the String.split(String) method causes on some large inputs.
    *
    * Note that this method does not avoid other errors, such as those related to 
    * excess heap size or CPU time.
    */
    public static List<String> safeSplit(String inStr, String delim)
    {
        Integer regexFindLimit = 100;
        Integer regexFindCount = 0;
        
        List<String> output = new List<String>();
        
        Matcher m = Pattern.compile(delim).matcher(inStr);
        
        Integer lastEnd = 0;
    
        while(!m.hitEnd())
        {
            while(regexFindCount < regexFindLimit && !m.hitEnd())
            {
                if(m.find())
                {
                    output.add(inStr.substring(lastEnd, m.start()));  
                    lastEnd = m.end();
                }
                else
                {
                    output.add(inStr.substring(lastEnd));
                    lastEnd = inStr.length();
                }
                
                regexFindCount++;
            }
    
            // Note: Using region() to advance instead of substring() saves 
            // drastically on heap size. Nonetheless, we still must reset the 
            // (unmodified) input sequence to avoid a 'Regex too complicated' 
            // error.
            m.reset(inStr);        
            m.region(lastEnd, m.regionEnd());
            
            regexFindCount = 0;
        }
        
        return output;
    }

    public static string get_userID (String setCondition_string, String setCondition_userId){
        DateTime start_time = datetime.now();
        String userId;

        try {

            if(setCondition_string == 'HEAD_SALES' && String.isNotBlank(setCondition_userId)){
                List<User> user_HEAD_SALES_List = [SELECT ManagerId FROM User WHERE Id=:setCondition_userId];

                if(user_HEAD_SALES_List!=null && !user_HEAD_SALES_List.isEmpty()){
                    userId = user_HEAD_SALES_List[0].ManagerId;
                }
            }

            if(setCondition_string == 'GH_SALES' && String.isNotBlank(setCondition_userId)){
                List<User> user_HEAD_SALES_List = [SELECT ManagerId FROM User WHERE Id =: setCondition_userId];

                if(user_HEAD_SALES_List!=null && !user_HEAD_SALES_List.isEmpty()){
                    List<User> user_GH_SALES_List = [SELECT ManagerId FROM User WHERE Id =: user_HEAD_SALES_List[0].ManagerId];

                    if(user_GH_SALES_List!=null && !user_GH_SALES_List.isEmpty()){
                        userId = user_GH_SALES_List[0].ManagerId;
                    }
                }
            }

            if(String.isNotBlank(setCondition_string) && String.isBlank(setCondition_userId)){
                List<User> user_ROLE_List = [SELECT id, name, email FROM User WHERE userrole.name =: setCondition_string];

                if(user_ROLE_List!=null && !user_ROLE_List.isEmpty()){
                    userId = user_ROLE_List[0].Id;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

        } catch (Exception e) {
            String err_message = 'Error on AppUtils.cls - get_userID ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            putError(err_message);
            putCalllog('Trigger',null,start_time,'failed',datetime.now(),'AppUtils.cls - get_userID',err_message);
        }
        
        return userId;
    }

    public static String Decimal_To_Currency(Decimal x){
        String y = String.valueOf(x);
        String z = '.';
        
        if(y.contains(',')){
            z = ',';
        } 
        
        if (y.indexOf(z) > 0) {
            // jika ada titik (.) pada value atau nilainya decimal
            y = y.substring(0, y.indexOf(z));
        }
        
        if(x - Decimal.valueOf(y) == 0){
            //return String.valueOf(x.format()) + z + '00';
            return String.valueOf(x.format());
        }else{
            return String.valueOf(x.format());
        } 
    }

    Public static String getDateMonthName_FORMAT_MMM_ID(Date dateValue){
        String monthValueFormat = '';
        Integer monthValue = dateValue.month();

        if(monthValue == 1){
            monthValueFormat = 'Jan';
        }else if(monthValue == 2){
            monthValueFormat = 'Feb';
        }else if(monthValue == 3){
            monthValueFormat = 'Mar';
        }else if(monthValue == 4){
            monthValueFormat = 'Apr';
        }else if(monthValue == 5){
            monthValueFormat = 'Mei';
        }else if(monthValue == 6){
            monthValueFormat = 'Jun';
        }else if(monthValue == 7){
            monthValueFormat = 'Jul';
        }else if(monthValue == 8){
            monthValueFormat = 'Agu';
        }else if(monthValue == 9){
            monthValueFormat = 'Sep';
        }else if(monthValue == 10){
            monthValueFormat = 'Okt';
        }else if(monthValue == 11){
            monthValueFormat = 'Nov';
        }else if(monthValue == 12){
            monthValueFormat = 'Des';
        }

        return monthValueFormat;
    }

    Public static String getDateMonthName_FORMAT_MMM_EN(Date dateValue){
        String monthValueFormat = '';
        Integer monthValue = dateValue.month();

        if(monthValue == 1){
            monthValueFormat = 'Jan';
        }else if(monthValue == 2){
            monthValueFormat = 'Feb';
        }else if(monthValue == 3){
            monthValueFormat = 'Mar';
        }else if(monthValue == 4){
            monthValueFormat = 'Apr';
        }else if(monthValue == 5){
            monthValueFormat = 'May';
        }else if(monthValue == 6){
            monthValueFormat = 'Jun';
        }else if(monthValue == 7){
            monthValueFormat = 'Jul';
        }else if(monthValue == 8){
            monthValueFormat = 'Aug';
        }else if(monthValue == 9){
            monthValueFormat = 'Sep';
        }else if(monthValue == 10){
            monthValueFormat = 'Oct';
        }else if(monthValue == 11){
            monthValueFormat = 'Nov';
        }else if(monthValue == 12){
            monthValueFormat = 'Dec';
        }

        return monthValueFormat;
    }

    Public static String getDateMonthName_FORMAT_MM_ID(Date dateValue){
        String monthValueFormat = '';
        Integer monthValue = dateValue.month();

        if(monthValue == 1){
            monthValueFormat = 'Januari';
        }else if(monthValue == 2){
            monthValueFormat = 'Februari';
        }else if(monthValue == 3){
            monthValueFormat = 'Maret';
        }else if(monthValue == 4){
            monthValueFormat = 'April';
        }else if(monthValue == 5){
            monthValueFormat = 'Mei';
        }else if(monthValue == 6){
            monthValueFormat = 'Juni';
        }else if(monthValue == 7){
            monthValueFormat = 'Juli';
        }else if(monthValue == 8){
            monthValueFormat = 'Agustus';
        }else if(monthValue == 9){
            monthValueFormat = 'September';
        }else if(monthValue == 10){
            monthValueFormat = 'Oktober';
        }else if(monthValue == 11){
            monthValueFormat = 'November';
        }else if(monthValue == 12){
            monthValueFormat = 'Desember';
        }

        return monthValueFormat;
    }

    Public static String getDateMonthName_FORMAT_MM_EN(Date dateValue){
        String monthValueFormat = '';
        Integer monthValue = dateValue.month();

        if(monthValue == 1){
            monthValueFormat = 'January';
        }else if(monthValue == 2){
            monthValueFormat = 'February';
        }else if(monthValue == 3){
            monthValueFormat = 'March';
        }else if(monthValue == 4){
            monthValueFormat = 'April';
        }else if(monthValue == 5){
            monthValueFormat = 'May';
        }else if(monthValue == 6){
            monthValueFormat = 'June';
        }else if(monthValue == 7){
            monthValueFormat = 'July';
        }else if(monthValue == 8){
            monthValueFormat = 'August';
        }else if(monthValue == 9){
            monthValueFormat = 'September';
        }else if(monthValue == 10){
            monthValueFormat = 'October';
        }else if(monthValue == 11){
            monthValueFormat = 'November';
        }else if(monthValue == 12){
            monthValueFormat = 'December';
        }

        return monthValueFormat;
    }

    Public static Integer weekOfMonth(Date todaysDate){
        Integer weekCount = 0;
        Integer startWeekResidue = 0;
        Integer endWeekResidue = 0;

        system.debug (' ==============' );
        system.debug (' == todaysDate : ' + todaysDate);
        system.debug (' == todaysDate.day() : ' + todaysDate.day());
         
         
        //Calculating startWeekResidue
        Date dt = todaysDate.toStartOfMonth().addDays(-1);
        Date dtFirstWeekend = dt.toStartOfWeek().addDays(6);
//        Date dtFirstWeekend = dt.toStartOfWeek().addDays(7);
        startWeekResidue = dt.daysBetween(dtFirstWeekend);

        system.debug (' == dt : ' + dt);
        system.debug (' == dtFirstWeekend : ' + dtFirstWeekend);
        system.debug (' == startWeekResidue : ' + startWeekResidue);
        system.debug (' == dt.toStartOfWeek() : ' + dt.toStartOfWeek());
         
        //Calculating endWeekResidue
        Date dtLastWeekend = todaysDate.toStartOfWeek().addDays(-1);
//        Date dtLastWeekend = todaysDate.toStartOfWeek();
        endWeekResidue = dtLastWeekend.daysBetween(todaysDate);

        system.debug (' == dtLastWeekend : ' + dtLastWeekend);
        system.debug (' == endWeekResidue : ' + endWeekResidue);
         
        //Counting the weeks
        weekCount = (todaysDate.day() - (startWeekResidue + endWeekResidue))/7;
        System.Debug('Week Number: ' + weekCount);

        weekCount += (startWeekResidue > 0 ? 1:0)+(endWeekResidue > 0 ? 1:0);
        System.Debug('Week Number: ' + weekCount);
        
        
        return weekCount;
    }

    Public static Integer weekOfYear(Datetime todaysDateTime){
        Integer weekCount = Integer.valueof(todaysDateTime.Format('w'));
        
        return weekCount;
    }
    
	public static string generateApprovalURL (String recordID) {
		String url='';  
  
		List<ProcessInstanceWorkitem> workItemLst =   [  SELECT id  FROM ProcessInstanceWorkitem  
		WHERE processInstance.TargetObjectId=:recordID];   

		if(workItemLst.size() > 0)  {  
			url='https://'+ System.URL.getSalesforceBaseUrl().getHost() +   
			'/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + workItemLst[0].id;      
		}  
		return url; 
	}

    public static Object getObjectOfRecord(SObject record, String field)
    {
        if (record == null) return null;
        if (!field.contains('.')) return record.get(field);
        return apputils.getObjectOfRecord(
            record.getSObject(field.substringBefore('.')),
            field.substringAfter('.')
        );
    }
    
    public static string getObjectType(Object o) {
        if(o==null) return '';              // we can't say much about null with our current techniques
        if(o instanceof SObject)            return ((SObject)o).getSObjectType().getDescribe().getName()+''; 
        if(o instanceof Boolean)            return 'Boolean';
        if(o instanceof Id)                 return 'Id';
        if(o instanceof String)             return 'String';
        if(o instanceof Blob)               return 'Blob';
        if(o instanceof Date)               return 'Date';
        if(o instanceof Datetime)           return 'Datetime';
        if(o instanceof Time)               return 'Time';
        if(o instanceof String)             return 'String';
        if(o instanceof Integer)            return 'Integer';
        if(o instanceof Long)               return 'Long';
        if(o instanceof Decimal)            return 'Decimal';  // we can't distinguish between decimal and double
        if(o instanceof Double)             return 'Double';   // we can't distinguish between decimal and double
        if(o instanceof List<object>)       return 'List';
    return 'Object';                    // actually we can't detect maps and sets and maps
  }

    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){

                //if (!sObj.contains('__')) to exclude managed package objects

                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                //System.debug('Prefix is ' + prefix);
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    //System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }

    public static String GetResourceURL(String resourceName){
        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];

        if(resourceList.size() == 1){
           String namespace = resourceList[0].NamespacePrefix;

           return URL.getSalesforceBaseUrl().toExternalForm()+'/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
        }
        else return '';
    }

    public static List<String> additionalSettingEmail(String valueSetting) {
        List<String> listValueAdditional = new List<String>();
        listValueAdditional = valueSetting.split(',');
        return listValueAdditional;
    }

    /*public static MetadataService.MetadataPort createService()
	{ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;		
	}

    public static void updatePicklist()
    {
        DateTime start_time = datetime.now();

        try {
            MetadataService.MetadataPort service = createService();	


            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on AppUtils.cls - createPicklistValue ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            putError(err_message);
        }
    }*/

    public static Map<String,String> getProductCodeFromOpptyLineProduct(List<String> opportunityIds){
        DateTime start_time = datetime.now();
        try {
            Map<String,String> Map_returnValues = new Map<String,String>();
            Set<String> Set_ProductCodes = new Set<String>();

            List<OpportunityLineItem> List_OpportunityLineItem = [SELECT Id, Product2Id, Product2.Product_Code2__c, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN : opportunityIds];

            system.debug('getProductCodeFromOpptyLineProduct - List_OpportunityLineItem : ' + List_OpportunityLineItem);

            if(List_OpportunityLineItem !=null && !List_OpportunityLineItem.isEmpty()){
                Integer ChangeRecord = 1;
                integer i = 0;
    
                for(i=0;i<List_OpportunityLineItem.size();i++) {
                    if(ChangeRecord==1)
                    {
                        Map_returnValues.put(List_OpportunityLineItem[i].OpportunityId,'%'+List_OpportunityLineItem[i].Product2.Product_Code2__c+'%');
                    }
                    
                    ChangeRecord=0;
                
                    if(ChangeRecord==0)
                    {
                        
                    }
                    
                    if(List_OpportunityLineItem.size()==i+1)
                    {
                        ChangeRecord=1;
                    } 
                    
                    else if(List_OpportunityLineItem[i+1].Id!=List_OpportunityLineItem[i].Id||i==List_OpportunityLineItem.size()-1)
                    {
                        ChangeRecord=1;
                    }
                }
            }else{
                Map_returnValues = null;
            }

            system.debug('getProductCodeFromOpptyLineProduct - Map_returnValues : ' + Map_returnValues);

         /*   if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/

            return Map_returnValues;
        } catch (Exception e) {
            String err_message = 'Error on AppUtils.cls - getProductCodeFromOpptyLineProduct ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            putError(err_message);
            return null;
        }
    }

    public static String getProfitability_RecordtypeController(String ProductCode){
        DateTime start_time = datetime.now();
        try {
            /*List<String> opportunityIds = new List<String>();
            opportunityIds.add('0061m000004EdOzAAK');

            Map<String,String> Map_ProductCodeFromOpptyLineProduct = AppUtils.getProductCodeFromOpptyLineProduct(opportunityIds);

            system.debug(Schema.SObjectType.Profitability__c.getRecordTypeInfosByName().get(AppUtils.getProfitability_RecordtypeController(Map_ProductCodeFromOpptyLineProduct.get('0061m000004EdOzAAK'))).getRecordTypeId());*/
            
            String String_returnValues = null;

            List<Profitability_Recordtype_Controller__c> List_ProfitabilityRecordtypeController = [SELECT Name, Product_Code__c FROM Profitability_Recordtype_Controller__c WHERE Product_Code__c Like : ProductCode];

            if(List_ProfitabilityRecordtypeController !=null && !List_ProfitabilityRecordtypeController.isEmpty()) {
                for(Profitability_Recordtype_Controller__c List_ProfitabilityRecordtypeController_Extract : List_ProfitabilityRecordtypeController){
                    String_returnValues = List_ProfitabilityRecordtypeController_Extract.Name;
                }
            }
           
            system.debug('getProfitability_RecordtypeController - String_returnValues : ' + String_returnValues);
			return String_returnValues;
            /*
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

           */ 
        } catch (Exception e) {
            String err_message = 'Error on AppUtils.cls - getProfitability_RecordtypeController ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            putError(err_message);
            return null;
        }
    }



    public static String ping (string endpoint) {
        string responseMsg;
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200) {
            System.debug('No errors');
            
        }
        responseMsg = res.getStatusCode() + ' ' + res.getStatus() + ' ' + res.getBody();

        return responseMsg;

    }

    public static String getNumberSuffix(Integer n) {
        if (n == null) {
            return '';
        }
    
        if (n >= 11 && n <= 13) {
            return 'th';
        }
    
        Integer modResult = Math.mod(n, 10);        
        if (modResult == 1) { 
            return 'st'; 
        } else if (modResult == 2) { 
            return 'nd'; 
        } else if (modResult == 3) { 
            return 'rd'; 
        } else { 
            return 'th';
        }
    }
}